package com.arjjs.ccm.modules.flat.realtimeSituation.service;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.SpringContextHolder;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDevice;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmDeviceService;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgTeam;
import com.arjjs.ccm.modules.ccm.org.entity.CcmUserDevicePo;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgTeamService;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandleUserState;
import com.arjjs.ccm.modules.flat.handle.service.BphAlarmHandleService;
import com.arjjs.ccm.modules.flat.realtimeSituation.entity.DataList;
import com.arjjs.ccm.modules.flat.realtimeSituation.entity.PeopleData;
import com.arjjs.ccm.modules.flat.rest.service.FlatRestService;
import com.arjjs.ccm.modules.flat.tree.dao.FlatTreeDao;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.DictUtils;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.LayUIBean;
import com.arjjs.ccm.tool.Result;
import com.arjjs.ccm.tool.Tool;
import com.arjjs.ccm.tool.geoJson.Features;
import com.arjjs.ccm.tool.geoJson.GeoJSON;
import com.arjjs.ccm.tool.geoJson.Geometry;
import com.arjjs.ccm.tool.geoJson.Properties;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@Service
public class RealtimeSituationService {

	@Autowired
	private CcmDeviceService ccmDeviceService;
	@Autowired
	FlatTreeDao flatTreeDao;
	@Autowired
	CcmOrgTeamService ccmOrgTeamService;

	public DataList findList(DataList dataList) {
		String type = dataList.getType();
		String[] typeArray = type.split(",");
		if ("1".equals(typeArray[0])) {// 警车
			String paramNew = "{id:"+dataList.getId()+",x:"+dataList.getX()+",y:"+dataList.getY()+",radius:"+dataList.getRadius()+"}";
			String url = Global.getConfig("arjsps") + "/flat?param=" + paramNew;
			String jsonData = Tool.getRestReturn(url);
			if (jsonData != null) {
				JSONObject jsonObject = JSONObject.fromObject(jsonData);
				JSONObject jsonArrayData = JSONObject.fromObject(jsonObject.getString("content"));
				String carData = jsonArrayData.getString("carData");
				dataList.setCarData(carData);
			}
		}
		if ("1".equals(typeArray[2])) {// 视频
			CcmDevice ccmDevice = new CcmDevice();
			List<CcmDevice> devList1 = Lists.newArrayList();
			List<CcmDevice> devList = ccmDeviceService.findList(ccmDevice);
			for (int i = 0; i < devList.size(); i++) {
				String coordinate = devList.get(i).getCoordinate();
				if (coordinate != null && coordinate != "") {
					String[] sourceStrArray = coordinate.split(",");
					if (sourceStrArray.length > 1) {
						devList.get(i).setX(sourceStrArray[0]);
						devList.get(i).setY(sourceStrArray[1]);
					}
					if (Tool.isInCircle(Double.parseDouble(devList.get(i).getX()),
							Double.parseDouble(devList.get(i).getY()), Double.parseDouble(dataList.getX()),
							Double.parseDouble(dataList.getY()), dataList.getRadius())) {
						devList1.add(devList.get(i));
					}
				}
			}
			dataList.setVideoDelList(devList1);
		}
		return dataList;
	}

	/**
	 * 描述：警力查询
	 * @param param
	 * @return
	 */
	public LayUIBean queryPolice(DataList dataList) {
		LayUIBean result = new LayUIBean();
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<CcmOrgTeam> userList = Lists.newArrayList();
		List<User> onlineUsers = UserUtils.getOnlineUsers();
		List<String> userIdList = Lists.newArrayList();
		BphAlarmHandleUserState bphAlarmHandleUserState = new BphAlarmHandleUserState();
		for (Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
			if (StringUtils.isNotBlank(entry.getValue().getX()) && StringUtils.isNotBlank(entry.getValue().getY())) {
				if (Tool.isInCircle(Double.valueOf(dataList.getX()), Double.valueOf(dataList.getY()), Double.valueOf(entry.getValue().getX()), Double.valueOf(entry.getValue().getY()), dataList.getRadius())) {
					PeopleData peopleData = entry.getValue();
					userIdList.add(peopleData.getUserId());
				}
			}
		}
		if(CollectionUtils.isNotEmpty(userIdList)) {
			for(int i = 0;i<userIdList.size();i++){
				CcmOrgTeam userOrgTeam = new CcmOrgTeam(); 
				userOrgTeam.setId(userIdList.get(i));
				userOrgTeam = flatTreeDao.findUserById(userOrgTeam);
				userList.add(userOrgTeam);
			}
			String[] userIds = new String[userIdList.size()];
			bphAlarmHandleUserState.setUserIds(userIdList.toArray(userIds));
			BphAlarmHandleService handleBean = SpringContextHolder.getBean("bphAlarmHandleService");
			List<BphAlarmHandleUserState> findUserState = handleBean.findUserState(bphAlarmHandleUserState);
			userList.forEach(ccmOrgTeam -> {
			User user = ccmOrgTeam.getUser();
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", user.getId());
			map.put("name", user.getName()+"/"+DictUtils.getDictLabel(ccmOrgTeam.getTeamType(), "POLICE_FORCES", ""));
			map.put("distance", "未知");
			String loginState = "offline";
			String userState = "free";
				for(User u : onlineUsers) {
					if(StringUtils.equals(user.getId(), u.getId())) {
						loginState = "online";
						for(BphAlarmHandleUserState state : findUserState) {
							if (StringUtils.equals(state.getUserId(), user.getId())) {
								userState = state.getUserState();
								break;
							}
						}
						break;
					}
				}
				
				for(Map.Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
					if(StringUtils.equals(user.getId(), entry.getValue().getUserId())) {
						loginState = "online";
						for(BphAlarmHandleUserState state : findUserState) {
							if (StringUtils.equals(state.getUserId(), user.getId())) {
								userState = state.getUserState();
								break;
							}
						}
						break;
					}
				}
				if(StringUtils.equals("online", loginState)) {
					if(StringUtils.equals("free", userState)) {
						map.put("state", "备勤");
					} else {
						map.put("state", "忙碌");
					}
					PeopleData peopleData = FlatRestService.peoPleMap.get(user.getId());
					if(peopleData != null) {
						String x = peopleData.getX();
						String y = peopleData.getY();
						double distance = Tool.getDistance(Double.valueOf(x), Double.valueOf(y), Double.valueOf(dataList.getX()), Double.valueOf(dataList.getY()));
						map.put("distance", String.format("%.2f", distance));
						map.put("x", x);
						map.put("y", y);
					}
				}
				mapList.add(map);
			});
			result.setData(mapList);
			result.setCode(Result.ERROR_OK);
			result.setMsg("操作成功");
			return result;
		}
		result.setMsg("没有数据");
		return result;
	}
	
	public JSONArray getCarDevice() {
		String url = Global.getConfig("arjsps") + "/findCarDevice";
		String jsonData = Tool.getRestReturn(url);
		JSONObject jsonObject = JSONObject.fromObject(jsonData);
		JSONArray jsonArrayData = new JSONArray();
		if (jsonObject.isNullObject()) {
			return jsonArrayData;
		} else {
			jsonArrayData = JSONArray.fromObject(jsonObject.getString("content"));
			return jsonArrayData;
		}
	}

	public GeoJSON getPoliceCarData() {
		GeoJSON geoJSON = new GeoJSON();
		JSONArray jsonArrayData = getCarDevice();
		List<Features> featureList = Lists.newArrayList();
		for(int i = 0;i < jsonArrayData.size();i++) {
			JSONObject jsonObject = (JSONObject) jsonArrayData.get(i);
			String id = jsonObject.getString("id");
			String x = jsonObject.getString("x");
			String y = jsonObject.getString("y");
			String code = jsonObject.getString("code");
			String manager = jsonObject.getString("manager");
			String name = jsonObject.getString("name");
			String param = jsonObject.getString("param");
			String policeNo = jsonObject.getString("policeNo");
			String tel = jsonObject.getString("tel");
			Properties properties = new Properties();
			properties.setName(name);
			String[] point = new String[2];
			point[0] = x;
			point[1] = y;
			properties.setCoordinateCentre(point);
			geoJSON.setCentpoint(point);
			Map<String, Object> info = new HashMap<String, Object>();
			info.put("名称：", name);
			info.put("负责人：", manager);
			info.put("设备编号：", code);
			info.put("视频连接参数：", param);
			info.put("负责人警号：", policeNo);
			info.put("负责人联系电话：", tel);
			properties.setInfo(info);
			Features featureDto = new Features();
			featureDto.setProperties(properties);
			featureDto.setId(id);
			Geometry geometry = new Geometry();
			geometry.setType("Point");
			geometry.setCoordinateCentre(point);
			featureDto.setGeometry(geometry);
			featureList.add(featureDto);
		}
		geoJSON.setFeatures(featureList);
		return geoJSON;
	}

	public GeoJSON findPeopleInfo() {
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		List<Features> featureList = new ArrayList<Features>();
		List<String> userIdList = Lists.newArrayList();

		//在线用户逻辑修改
		List<CcmUserDevicePo> onlineUserList = ccmOrgTeamService.findOnlineUserInfo();
		onlineUserList.forEach(ccmUserDevicePo -> userIdList.add(ccmUserDevicePo.getUserId()));

		List<BphAlarmHandleUserState> findUserState = Lists.newArrayList();
		if(CollectionUtils.isNotEmpty(userIdList)){
			BphAlarmHandleUserState bphAlarmHandleUserState = new BphAlarmHandleUserState();
			String[] userIds = new String[userIdList.size()];
			bphAlarmHandleUserState.setUserIds(userIdList.toArray(userIds));
			BphAlarmHandleService bean = SpringContextHolder.getBean("bphAlarmHandleService");
			findUserState = bean.findUserState(bphAlarmHandleUserState);
		}
		List<BphAlarmHandleUserState> finalFindUserState = findUserState;
		onlineUserList.forEach(ccmUserDevicePo ->{
				// 特征属性
			Features featureDto = new Features();
			Properties properties = new Properties();
			String x = "";
			String y = "";
			if (!"".equals(ccmUserDevicePo.getAreaPoint()) && ccmUserDevicePo.getAreaPoint() != null){
				String[] split = ccmUserDevicePo.getAreaPoint().split(",");
				x = split[0];
				y = split[1];
			}


				// 1 type 默认不填
			// 2 id 添加
			featureDto.setId(ccmUserDevicePo.getUserId());
			// 3 properties 展示属性信息
			properties.setName(ccmUserDevicePo.getName());
			// 创建附属信息
			Map<String, Object> map = Maps.newLinkedHashMap();
			map.put("姓名", ccmUserDevicePo.getName());
			map.put("电话", ccmUserDevicePo.getPhone());
			map.put("手机", ccmUserDevicePo.getMobile());
			map.put("经度", x);
			map.put("纬度", y);
			map.put("警务通", ccmUserDevicePo.getDeviceId());
			map.put("设备唯一标识码", ccmUserDevicePo.getDeviceCode());
			map.put("状态", "备勤");
			properties.setUserState("free");
			for(BphAlarmHandleUserState userState : finalFindUserState) {
				if (StringUtils.equals(userState.getUserId(), ccmUserDevicePo.getUserId())) {
					if (StringUtils.equals("free", userState.getUserState())) {
						map.put("状态", "备勤");
						properties.setUserState("free");
					} else if (StringUtils.equals("busy", userState.getUserState())) {
						map.put("状态", "忙碌");
						properties.setUserState("busy");
					}
					break;
				}
			}
			properties.addInfo(map);
			featureList.add(featureDto);
			featureDto.setProperties(properties);
			// 4 geometry 配置参数
			Geometry geometry = new Geometry();
			featureDto.setGeometry(geometry);
			// 点位信息 测试为面
			geometry.setType("Point");
			if (StringUtils.isNotBlank(x) && StringUtils.isNotBlank(y)) {
				String[] point = new String[2];
				point[0] = x;
				point[1] = y;
				geoJSON.setCentpoint(point);
				// 添加图形中心点位信息
				properties.setCoordinateCentre(point);
			}
			// 添加具体数据
			// 封装的list
			List<String> Coordinateslist = new ArrayList<>();
			Coordinateslist.add(x);
			Coordinateslist.add(y);
			// 装配点位
			geometry.setCoordinates(Coordinateslist);
		});
		featureList.add(featureList());
		featureList.add(featureList1());
		featureList.add(featureList2());
		geoJSON.setFeatures(featureList);
		return geoJSON;
	}
	public GeoJSON findPeopleInfo1() {
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		List<Features> featureList = new ArrayList<Features>();
		List<String> userIdList = Lists.newArrayList();
		for(Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
			userIdList.add(entry.getValue().getUserId());
		}
		List<BphAlarmHandleUserState> findUserState = Lists.newArrayList();
		if(CollectionUtils.isNotEmpty(userIdList)){
			BphAlarmHandleUserState bphAlarmHandleUserState = new BphAlarmHandleUserState();
			String[] userIds = new String[userIdList.size()];
			bphAlarmHandleUserState.setUserIds(userIdList.toArray(userIds));
			BphAlarmHandleService bean = SpringContextHolder.getBean("bphAlarmHandleService");
			findUserState = bean.findUserState(bphAlarmHandleUserState);
		}
		for (Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
			if (StringUtils.isNotBlank(entry.getValue().getUserId())) {
				// 特征属性
				Features featureDto = new Features();
				Properties properties = new Properties();
				// 1 type 默认不填
				// 2 id 添加
				featureDto.setId(entry.getValue().getUserId());
				// 3 properties 展示属性信息
				properties.setName(entry.getValue().getName());
				// 创建附属信息
				Map<String, Object> map = Maps.newLinkedHashMap();
				map.put("姓名", entry.getValue().getName());
				map.put("电话", entry.getValue().getPhone());
				map.put("手机", entry.getValue().getMobile());
				map.put("经度", entry.getValue().getX());
				map.put("纬度", entry.getValue().getY());
				if ("0".equals(entry.getValue().getDefualtDevice())) {// 警务通
					map.put("警务通", entry.getValue().getPolicePhoneCode());
				} else if ("1".equals(entry.getValue().getDefualtDevice())) {// 执法记录仪
					map.put("执法记录仪", entry.getValue().getActionRecoderCode());
				} else if ("2".equals(entry.getValue().getDefualtDevice())) {// 对讲
					map.put("对讲", entry.getValue().getInterPhoneCode());
				}
				map.put("设备唯一标识码", entry.getValue().getCode());
				map.put("状态", "备勤");
				properties.setUserState("free");
				for(BphAlarmHandleUserState userState : findUserState) {
					if (StringUtils.equals(userState.getUserId(), entry.getValue().getUserId())) {
						if (StringUtils.equals("free", userState.getUserState())) {
							map.put("状态", "备勤");
							properties.setUserState("free");
						} else if (StringUtils.equals("busy", userState.getUserState())) {
							map.put("状态", "忙碌");
							properties.setUserState("busy");
						}
						break;
					}
				}
				properties.addInfo(map);
				featureList.add(featureDto);
				featureDto.setProperties(properties);
				// 4 geometry 配置参数
				Geometry geometry = new Geometry();
				featureDto.setGeometry(geometry);
				// 点位信息 测试为面
				geometry.setType("Point");
				String x = entry.getValue().getX();
				String y = entry.getValue().getY();
				if (StringUtils.isNotBlank(x) && StringUtils.isNotBlank(y)) {
					String[] point = new String[2];
					point[0] = x;
					point[1] = y;
					geoJSON.setCentpoint(point);
					// 添加图形中心点位信息
					properties.setCoordinateCentre(point);
				}
				// 添加具体数据
				// 封装的list
				List<String> Coordinateslist = new ArrayList<>();
				Coordinateslist.add(x);
				Coordinateslist.add(y);
				// 装配点位
				geometry.setCoordinates(Coordinateslist);
			}
		}
		featureList.add(featureList());
		featureList.add(featureList1());
		featureList.add(featureList2());
		geoJSON.setFeatures(featureList);
		return geoJSON;
	}

	public Features featureList(){
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		// 特征属性
		Features featureDto = new Features();
		Properties properties = new Properties();
		// 1 type 默认不填
		// 2 id 添加
		featureDto.setId("1");
		// 3 properties 展示属性信息
		properties.setName("王某");
		// 创建附属信息
		Map<String, Object> map = Maps.newLinkedHashMap();
		map.put("姓名", "王某");
		map.put("电话", "15672689571");
		map.put("手机", "15672689571");
		map.put("经度", "117.2486536865235");
		map.put("纬度", "39.1266626647949");
		map.put("警务通", "JWT56874256415");
		map.put("设备唯一标识码", "JWT56874256415");
		map.put("状态", "忙碌");
		properties.setUserState("busy");
		properties.addInfo(map);
		featureDto.setProperties(properties);
		// 4 geometry 配置参数
		Geometry geometry = new Geometry();
		featureDto.setGeometry(geometry);
		// 点位信息 测试为面
		geometry.setType("Point");
		String x = "117.2486536865235";
		String y = "39.1266626647949";
		if (StringUtils.isNotBlank(x) && StringUtils.isNotBlank(y)) {
			String[] point = new String[2];
			point[0] = x;
			point[1] = y;
			geoJSON.setCentpoint(point);
			// 添加图形中心点位信息
			properties.setCoordinateCentre(point);
		}
		// 添加具体数据
		// 封装的list
		List<String> Coordinateslist = new ArrayList<>();
		Coordinateslist.add(x);
		Coordinateslist.add(y);
		// 装配点位
		geometry.setCoordinates(Coordinateslist);
		return featureDto;
	}
	public Features featureList1(){
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		// 特征属性
		Features featureDto = new Features();
		Properties properties = new Properties();
		// 1 type 默认不填
		// 2 id 添加
		featureDto.setId("2");
		// 3 properties 展示属性信息
		properties.setName("刘某");
		// 创建附属信息
		Map<String, Object> map = Maps.newLinkedHashMap();
		map.put("姓名", "刘某");
		map.put("电话", "17772689571");
		map.put("手机", "17772689571");
		map.put("经度", "117.2686536865235");
		map.put("纬度", "39.1236626647949");
		map.put("警务通", "JWT326545414245");
		map.put("设备唯一标识码", "JWT326545414245");
		map.put("状态", "忙碌");
		properties.setUserState("busy");
		properties.addInfo(map);
		featureDto.setProperties(properties);
		// 4 geometry 配置参数
		Geometry geometry = new Geometry();
		featureDto.setGeometry(geometry);
		// 点位信息 测试为面
		geometry.setType("Point");
		String x = "117.2686536865235";
		String y = "39.1236626647949";
		if (StringUtils.isNotBlank(x) && StringUtils.isNotBlank(y)) {
			String[] point = new String[2];
			point[0] = x;
			point[1] = y;
			geoJSON.setCentpoint(point);
			// 添加图形中心点位信息
			properties.setCoordinateCentre(point);
		}
		// 添加具体数据
		// 封装的list
		List<String> Coordinateslist = new ArrayList<>();
		Coordinateslist.add(x);
		Coordinateslist.add(y);
		// 装配点位
		geometry.setCoordinates(Coordinateslist);
		return featureDto;
	}
	public Features featureList2(){
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		// 特征属性
		Features featureDto = new Features();
		Properties properties = new Properties();
		// 1 type 默认不填
		// 2 id 添加
		featureDto.setId("3");
		// 3 properties 展示属性信息
		properties.setName("蔡某");
		// 创建附属信息
		Map<String, Object> map = Maps.newLinkedHashMap();
		map.put("姓名", "蔡某");
		map.put("电话", "15872689571");
		map.put("手机", "15872689571");
		map.put("经度", "117.2282536865235");
		map.put("纬度", "39.1565226647949");
		map.put("警务通", "JWT984561484");
		map.put("设备唯一标识码", "JWT984561484");
		map.put("状态", "忙碌");
		properties.setUserState("busy");
		properties.addInfo(map);
		featureDto.setProperties(properties);
		// 4 geometry 配置参数
		Geometry geometry = new Geometry();
		featureDto.setGeometry(geometry);
		// 点位信息 测试为面
		geometry.setType("Point");
		String x = "117.2282536865235";
		String y = "39.1565226647949";
		if (StringUtils.isNotBlank(x) && StringUtils.isNotBlank(y)) {
			String[] point = new String[2];
			point[0] = x;
			point[1] = y;
			geoJSON.setCentpoint(point);
			// 添加图形中心点位信息
			properties.setCoordinateCentre(point);
		}
		// 添加具体数据
		// 封装的list
		List<String> Coordinateslist = new ArrayList<>();
		Coordinateslist.add(x);
		Coordinateslist.add(y);
		// 装配点位
		geometry.setCoordinates(Coordinateslist);
		return featureDto;
	}
}
