/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.flat.alarm.service;

import com.alibaba.fastjson.JSON;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.common.utils.SpringContextHolder;
import com.arjjs.ccm.modules.ccm.event.dao.CcmEventIncidentDao;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.org.dao.CcmOrgTeamDao;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgTeam;
import com.arjjs.ccm.modules.ccm.rest.entity.AlarmNotifyInfo;
import com.arjjs.ccm.modules.ccm.sys.dao.SysConfigDao;
import com.arjjs.ccm.modules.ccm.sys.entity.SysConfig;
import com.arjjs.ccm.modules.flat.alarm.dao.BphAlarmInfoDao;
import com.arjjs.ccm.modules.flat.alarm.entity.*;
import com.arjjs.ccm.modules.flat.alarmhandlelog.entity.BphAlarmHandleLog;
import com.arjjs.ccm.modules.flat.alarmhandlelog.entity.BphNoticeContent;
import com.arjjs.ccm.modules.flat.alarmhandlelog.entity.BphNoticeData;
import com.arjjs.ccm.modules.flat.alarmhandlelog.service.BphAlarmHandleLogService;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandleFile;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandleReceive;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandleUserState;
import com.arjjs.ccm.modules.flat.handle.service.BphAlarmHandleService;
import com.arjjs.ccm.modules.flat.realtimeSituation.entity.PeopleData;
import com.arjjs.ccm.modules.flat.realtimeSituation.service.RealtimeSituationService;
import com.arjjs.ccm.modules.flat.rest.service.FlatRestService;
import com.arjjs.ccm.modules.flat.tree.dao.FlatTreeDao;
import com.arjjs.ccm.modules.sys.dao.UserDao;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.Dict;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.AreaService;
import com.arjjs.ccm.modules.sys.service.OfficeService;
import com.arjjs.ccm.modules.sys.utils.DictUtils;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.*;
import com.arjjs.ccm.tool.geoJson.Features;
import com.arjjs.ccm.tool.geoJson.GeoJSON;
import com.arjjs.ccm.tool.geoJson.Geometry;
import com.arjjs.ccm.tool.geoJson.Properties;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 实时警情Service
 *
 * @author wangyikai
 * @version 2018-11-14
 */
@Service
@Transactional
public class BphAlarmInfoService extends CrudService<BphAlarmInfoDao, BphAlarmInfo> {
	private ConcurrentHashMap<String, BphAppVideo> userAppVideoMap = new ConcurrentHashMap<>();
	private static List<BphDockingAlarmInfo> dataCacheList = Collections.synchronizedList(Lists.newArrayList());

	@Autowired
	RealtimeSituationService realtimeSituationService;
	@Autowired
	OfficeService officeService;
	@Autowired
	FlatTreeDao flatTreeDao;
	@Autowired
	CcmOrgTeamDao ccmOrgTeamDao;
	@Autowired
	UserDao userDao;
	@Autowired
    AreaService areaService;
	@Autowired
	SysConfigDao sysConfigDao;
	@Autowired
	CcmEventIncidentDao ccmEventIncidentDao;


	public BphAlarmInfo get(String id) {
		BphAlarmInfo alarmInfo = dao.get(id);
		Office officePo = alarmInfo.getOffice();
		if(officePo != null) {
			String offId = officePo.getId();
			if (StringUtils.isNotBlank(offId)) {
				String[] officeId = officePo.getId().split(",");
				String officeName = "";
				for(int i = 0;i< officeId.length;i++) {
					Office office = officeService.get(officeId[i]);
					officeName += office.getName() + "、";
				}
				officeName = officeName.substring(0,officeName.length()-1);
				alarmInfo.setOfficeName(officeName);
			}
		}
		return alarmInfo;
	}

	public List<BphAlarmInfo> findList(BphAlarmInfo bphAlarmInfo) {
		if("1".equals(UserUtils.getUser().getId())) {
			bphAlarmInfo.setOfficeId(null);
		} else {
			bphAlarmInfo.setOfficeId(UserUtils.getUser().getOffice().getId());
		}
		List<BphAlarmInfo> list = dao.findAlarmList(bphAlarmInfo);
		return list;
	}

	public int insert(BphAlarmInfo bphAlarmInfo){

		return dao.insert(bphAlarmInfo);
	}


	/**
	 * 查询分页数据
	 *
	 * @param page   分页对象
	 * @param entity
	 * @return
	 */
	public List<BphAlarmInfo> findDistributeList(BphAlarmInfo bphAlarmInfo) {
		return dao.findDistributeList(bphAlarmInfo);
	}

	/**
	 * 根据查询条件查询总数
	 *
	 * @param bphAlarmInfo
	 * @return
	 */
	public Integer countDistributeList(BphAlarmInfo bphAlarmInfo) {
		return dao.countDistributeList(bphAlarmInfo);
	}

	/**
	 * 根据查询条件查询总数
	 *
	 * @param bphAlarmInfo
	 * @return
	 */
	public Integer countAlarmList(BphAlarmInfo bphAlarmInfo) {
		return dao.countAlarmList(bphAlarmInfo);
	}

	@Transactional(readOnly = false)
	public void save(BphAlarmInfo bphAlarmInfo) {
		super.save(bphAlarmInfo);
		BphAlarmHandleLog log = new BphAlarmHandleLog();
		log.setAlarmId(bphAlarmInfo.getId());
		log.setOperateTime(new Date());
		log.setUser(UserUtils.getUser());
		log.setOperateDesc("修改警情信息");
		BphAlarmHandleLogService bphAlarmHandleLogServiceBean = SpringContextHolder.getBean("bphAlarmHandleLogService");
		bphAlarmHandleLogServiceBean.save(log);
	}

	public boolean eventToAlarmInfo(String eventIncidentId){
		CcmEventIncident ccmEventIncident = ccmEventIncidentDao.get(eventIncidentId);

		//根据事件发生地，追溯到事件的发生部门，如果一个发生地有多个部门，此处只取第一个部门进行匹配；
		String officeId = "";
		Office office = new Office();
		Area areaOffice = ccmEventIncident.getArea();
        Area areaPo = new Area();
		if (areaOffice != null){
            areaPo = areaService.get(areaOffice.getId());
            List<OfficeAreaEntity> list = officeList(areaPo.getId());
            if (list.size() >0 && list != null){
                officeId = list.get(0).getOfficeId();
                office = officeService.get(officeId);
            }else{
                list = officeList(areaPo.getParentId());
                officeId = list.get(0).getOfficeId();
                office = officeService.get(officeId);
            }
		}

		BphAlarmInfo bphAlarmInfo1 = dao.get(eventIncidentId);
		if(ccmEventIncident==null || bphAlarmInfo1!=null){
			return false;
		}
		BphAlarmInfo bphAlarmInfo = new BphAlarmInfo();
		//接警单编号生成规则 年月日时分秒
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		bphAlarmInfo.setOrderNum(sdf.format(new Date()));
		if("1".equalsIgnoreCase(ccmEventIncident.getWhatType())) {
			if(com.arjjs.ccm.common.utils.StringUtils.isNotEmpty(ccmEventIncident.getAlarmPeopleName())) {
				bphAlarmInfo.setManName(ccmEventIncident.getAlarmPeopleName());
			}else {
				bphAlarmInfo.setManName("匿名");
			}
			if(com.arjjs.ccm.common.utils.StringUtils.isNotEmpty(ccmEventIncident.getAlarmPeopleTel())) {
				bphAlarmInfo.setManTel(ccmEventIncident.getAlarmPeopleTel());
			}else {
				bphAlarmInfo.setManTel("");
			}
		}else {
			if(com.arjjs.ccm.common.utils.StringUtils.isNotEmpty(ccmEventIncident.getReportPerson())) {
				bphAlarmInfo.setManName(ccmEventIncident.getReportPerson());
			}else {
				bphAlarmInfo.setManName("匿名");
			}
			if(com.arjjs.ccm.common.utils.StringUtils.isNotEmpty(ccmEventIncident.getReportPersonPhone())) {
				bphAlarmInfo.setManTel(ccmEventIncident.getReportPersonPhone());
			}else {
				bphAlarmInfo.setManTel("");
			}
		}
		bphAlarmInfo.setId(ccmEventIncident.getId());
		bphAlarmInfo.setPlace(ccmEventIncident.getHappenPlace());
		bphAlarmInfo.setContent(ccmEventIncident.getCaseName() + "："+ ccmEventIncident.getCaseCondition());
		bphAlarmInfo.setTypeCode(ccmEventIncident.getProperty());
		bphAlarmInfo.setState("0");
		bphAlarmInfo.setAlarmTime(new Date());
		bphAlarmInfo.setIsImportant("0");
		bphAlarmInfo.setCreateBy(new User("1"));
		bphAlarmInfo.setCreateDate(new Date());
		bphAlarmInfo.setUpdateBy(new User("1"));
		bphAlarmInfo.setUpdateDate(new Date());
		bphAlarmInfo.setDelFlag("0");
		bphAlarmInfo.setOfficeId(officeId);
		bphAlarmInfo.setOffice(office);
		bphAlarmInfo.setOfficeIds(office.getParentIds());
		if(StringUtils.isNotEmpty(areaOffice.getId())) {
			bphAlarmInfo.setAreaId(areaOffice.getId());
			bphAlarmInfo.setArea(areaOffice);
		}
		if(ccmEventIncident.getAreaPoint()!=null && !ccmEventIncident.getAreaPoint().equals("")){
			bphAlarmInfo.setX(Double.parseDouble(ccmEventIncident.getAreaPoint().split(",")[0]));
			bphAlarmInfo.setY(Double.parseDouble(ccmEventIncident.getAreaPoint().split(",")[1]));
		}
		dao.insert(bphAlarmInfo);
		return true;
	}

	@Transactional(readOnly = false)
	public int deleteBphAlarmInfo(BphAlarmInfo bphAlarmInfo) {
		return dao.delete(bphAlarmInfo);
	}


	public List<OfficeAreaEntity> officeList(String areaId){
		return dao.officeList(areaId);
	}
	/**
	 * 查询当天的实时警情
	 * @param bphAlarmInfo
	 * @return
	 */
	public List<BphAlarmInfo> queryAlarmSituation(BphAlarmInfo bphAlarmInfo) {
		return dao.queryAlarmSituation(bphAlarmInfo);
	}

	/**
	 * 查询历史警情
	 * @param bphAlarmInfo
	 * @return
	 */
	public List<BphAlarmInfo> queryHisAlarmSituation(BphAlarmInfo bphAlarmInfo) {
		if("1".equals(UserUtils.getUser().getId())) {
			bphAlarmInfo.setOfficeId(null);
			return dao.queryHisAlarmSituation(bphAlarmInfo);
		} else {
			bphAlarmInfo.setOfficeId(UserUtils.getUser().getOffice().getId());
			return dao.queryHisAlarmSituation(bphAlarmInfo);
		}
	}

	public GeoJSON queryAlarmInfoByDateAndAlarmType(BphAlarmInfo bphAlarmInfo) {
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		List<Features> featureList = new ArrayList<Features>();
		String[] typeCode = bphAlarmInfo.getTypeCode().split(",");
		bphAlarmInfo.setTypeCodes(typeCode);
		List<BphAlarmInfo> list = this.dao.queryAlarmInfoByDateAndAlarmType(bphAlarmInfo);
		for (BphAlarmInfo bean : list) {

			String x = String.valueOf(bean.getX());
			String y =	String.valueOf(bean.getY());

			List<String> Coordinateslist = new ArrayList<>();
			if (bean.getX() == null && bean.getY() == null) {
				continue;
			}
			if ( "0.0".equals(x) && "0.0".equals(y)) {
				continue;
			}
			// 特征属性
			Features featureDto = new Features();
			Properties properties = new Properties();
			// 1 type 默认不填
			// 2 id 添加
			featureDto.setId(bean.getId());
			// 3 properties 展示属性信息
			properties.setName(bean.getOrderNum());
			// 创建附属信息
			featureList.add(featureDto);
			featureDto.setProperties(properties);
			// 4 geometry 配置参数
			Geometry geometry = new Geometry();
			featureDto.setGeometry(geometry);
			// 点位信息 测试为面
			geometry.setType("Point");

			String[] point = new String[2];
			point[0] = x;
			point[1] = y;
			geoJSON.setCentpoint(point);
			// 添加图形中心点位信息
			properties.setCoordinateCentre(point);
			// 添加具体数据
			// 封装的list
			Coordinateslist.add(x);
			Coordinateslist.add(y);
			// 装配点位
			if (CollectionUtils.isNotEmpty(Coordinateslist)) {
				geometry.setCoordinates(Coordinateslist);
			}
		}
		geoJSON.setFeatures(featureList);
		// 如果无数据
		if (featureList.size() == 0) {
			return null;
		}
		return geoJSON;
	}

	public GeoJSON queryAlarmInfoByDateAndAlarmTypeToFourColor(BphAlarmInfo bphAlarmInfo) {
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		List<Features> featureList = new ArrayList<Features>();
		String[] typeCode = bphAlarmInfo.getTypeCode().split(",");
		bphAlarmInfo.setTypeCodes(typeCode);
		List<BphAlarmInfo> list = this.dao.queryAlarmInfoByDateAndAlarmTypeToFourColor(bphAlarmInfo);
		for (BphAlarmInfo bean : list) {
			if (bean.getArea() == null) {
				continue;
			}
			// 特征属性
			Features featureDto = new Features();
			Properties properties = new Properties();
			// 1 type 默认不填
			// 2 id 添加
			featureDto.setId(bean.getArea().getId());
			// 3 properties 展示属性信息
			properties.setName(bean.getArea().getName());
			// 创建附属信息
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("警情数量", bean.getNum());
			properties.addInfo(map);
			featureList.add(featureDto);
			featureDto.setProperties(properties);
			// 4 geometry 配置参数
			Geometry geometry = new Geometry();
			featureDto.setGeometry(geometry);
			// 点位信息 测试为面
			geometry.setType("Polygon");
			if (!StringUtils.isEmpty(bean.getAreaPoint())) {
				// 获取中心点的值
				String[] centpoint = bean.getAreaPoint().split(",");
				geoJSON.setCentpoint(centpoint);
				// 添加图形中心点位信息
				properties.setCoordinateCentre(centpoint);
			}
			// 添加具体数据
			// 封装的list 以有孔与无孔进行添加
			List<Object> CoordinateslistR = new ArrayList<>();
			// 以下是无孔面积数组
			String[] coordinates = (StringUtils.isEmpty(bean.getAreaMap()) ? ";" : bean.getAreaMap()).split(";");
			// 返回无孔结果 2层数据一个数据源
			List<String[]> Coordinateslist = new ArrayList<>();
			for (int i = 0; i < coordinates.length; i++) {
				if (coordinates.length > 1) {
					String corrdinate = coordinates[i];
					// 以“，”为分割数据
					String[] a = corrdinate.split(",");
					Coordinateslist.add(a);
				} else {
					// 补充一个空的数据源
					String[] a = { "", "" };
					Coordinateslist.add(a);
				}
			}
			// 根据格式要求 两层list
			CoordinateslistR.add(Coordinateslist);
			// 获取最后的结果
			geometry.setCoordinates(CoordinateslistR);
		}
		geoJSON.setFeatures(featureList);
		// 如果无数据
		if (featureList.size() == 0) {
			return null;
		}
		return geoJSON;
	}

	@Transactional(readOnly = false)
	public Result updateAlarmInfo(BphAlarmInfo bphAlarmInfo) {
		Result result = new Result();
		if (StringUtils.isBlank(bphAlarmInfo.getId())) {
			result.setRet(Result.ERROR_PARAM);
			return result;
		}
		int a = dao.updateAlarmInfo(bphAlarmInfo);
		if (a > 0) {
			BphAlarmInfo alarmInfo = dao.get(bphAlarmInfo.getId());
			result.setContent(alarmInfo);
			result.setRet(Result.ERROR_OK);
			BphAlarmHandleLog log = new BphAlarmHandleLog();
			log.setAlarmId(bphAlarmInfo.getId());
			log.setOperateTime(new Date());
			log.setUser(UserUtils.getUser());
			log.setOperateDesc(bphAlarmInfo.getOptionDesc());
			log.setCreateBy(new User("1"));
			log.setCreateDate(new Date());
			log.setUpdateBy(new User("1"));
			log.setUpdateDate(new Date());
			log.setDelFlag("0");
			BphAlarmHandleLogService bphAlarmHandleLogServiceBean = SpringContextHolder.getBean("bphAlarmHandleLogService");
			bphAlarmHandleLogServiceBean.save(log);
		} else {
			result.setRet(Result.ERROR_DB);
		}
		return result;
	}

	public List<BphAlarmInfo> findNewestAlarmInfo() {
		return dao.findNewestAlarmInfo();
	}

	public List<BphAlarmInfo> countDtae() {
		return dao.countDtae();
	}

	public Map<String, Object> findPieData() {
		List<BphAlarmInfo> bphAlarmInfoList = dao.findPieData();
		List<Dict> dictList = DictUtils.getDictList("bph_alarm_info_typecode");
		List<BphAlarmTypeStat> dataList = Lists.newArrayList();
		List<String> typeNameList = Lists.newArrayList();
		for (Dict dict : dictList) {
			typeNameList.add(dict.getLabel());
			BphAlarmTypeStat b = new BphAlarmTypeStat();
			b.setName(dict.getLabel());
			b.setType(dict.getValue());
			b.setNum("0");
			dataList.add(b);
		}
		for (BphAlarmTypeStat bphAlarmTypeStat : dataList) {
			for (BphAlarmInfo bphAlarmInfo : bphAlarmInfoList) {
				if (bphAlarmTypeStat.getName().equals(bphAlarmInfo.getTypeName())) {
					bphAlarmTypeStat.setNum(bphAlarmInfo.getNum());
				}
			}
		}
		Map<String, Object> map = new HashMap<>();
		map.put("typeName", typeNameList);
		map.put("data", dataList);
		return map;
	}

	public GeoJSON getPeripheralResources(String type) {
		if ("8".equals(type)) {// 警员
			return realtimeSituationService.findPeopleInfo();
		} else if ("11".equals(type)) {// 警车
			return realtimeSituationService.getPoliceCarData();
		} else {
			return null;
		}
	}

	public BphAlarmInfo count(BphAlarmInfo bphAlarmInfo) {
		return dao.count(bphAlarmInfo);
	}

	public List<BphAlarmInfo> byOfficeCount(BphAlarmInfo bphAlarmInfo) {
		List<BphAlarmInfo> BphAlarmInfoList = dao.byOfficeCount(bphAlarmInfo);
		List<BphAlarmInfo> list = Lists.newArrayList();
		for (BphAlarmInfo s : BphAlarmInfoList) {
			String[] numStateStr = s.getNumState().split(",");
			for (int i = 0; i < numStateStr.length; i++) {
				String[] num = numStateStr[i].split(":");
				for (int j = 0; j < num.length; j++) {
					if ("0".equals(num[0])) {
						s.setNumState0(num[1]);
					}
					if ("1".equals(num[0])) {
						s.setNumState1(num[1]);
					}
					if ("2".equals(num[0])) {
						s.setNumState2(num[1]);
					}
					if ("3".equals(num[0])) {
						s.setNumState3(num[1]);
					}
				}
			}
			list.add(s);
		}
		return list;
	}

	public List<Office> findOfficeAllList(String type) {
		Office office = new Office();
		office.setType(type);
		return dao.findOfficeAllList(office);
	}

	public Map<String, Object> statCountByAlarmType() {
		Map<String, Object> map = new HashMap<>();
		List<BphAlarmTypeStat> alarmTypeStats = dao.statCountByAlarmType();
		List<Dict> dictList = DictUtils.getDictList("bph_alarm_info_typecode");
		List<String> typeDataList = Lists.newArrayList();
		List<String> dateDataList = Lists.newArrayList();//放日期的数组，前台使用
		for (Dict dict : dictList) {
			typeDataList.add(dict.getLabel());
		}
		map.put("typeData", typeDataList);
		map.put("dateData", dateDataList);
		map.put("data", alarmTypeStats);
		return map;
	}

	public Map<String, Object> sameDayContrastStat() {
		//List<String> dateNum = new ArrayList<>();

		//List<String> strings = dao.selectDataNum();
		List<String> dateNum = DateTools.getThisMounthNum();
		Collections.reverse(dateNum);
		List<String> thisMonthNum = new ArrayList<>();

		List<BphAlarmSameDayContrast> thisMonthStatList = dao.thisMonthContrastStat();
		for (BphAlarmSameDayContrast alarmData :thisMonthStatList) {
			thisMonthNum.add(alarmData.getNum());
		}

		List<BphAlarmSameDayContrast> lastMonthStatList = dao.lastMonthContrastStat();
		List<String> lastMonthNum = new ArrayList<>();
		for (BphAlarmSameDayContrast alarmData :lastMonthStatList) {
			lastMonthNum.add(alarmData.getNum());
		}
		Map<String, Object> map = new HashMap<>();

		map.put("thisMonthNum", thisMonthNum);
		map.put("lastMonthNum", lastMonthNum);
		map.put("dateNum", dateNum);
		return map;
	}

	public List<BphAlarmInfo> statPercentByAlarmType(BphAlarmInfo bphAlarmInfo) {
		return dao.statPercentByAlarmType(bphAlarmInfo);
	}

	public List<BphAlarmInfo> statCountByOfficeAndAlarmType(BphAlarmInfo bphAlarmInfo) {
		return dao.statCountByOfficeAndAlarmType(bphAlarmInfo);
	}

	public Integer findCount(BphAlarmInfo bphAlarmInfo){
		if("1".equals(UserUtils.getUser().getId())) {
			bphAlarmInfo.setOfficeId(null);
			return dao.findCount(bphAlarmInfo);
		} else {
			bphAlarmInfo.setOfficeId(UserUtils.getUser().getOffice().getId());
			return dao.findCount(bphAlarmInfo);
		}
	}

	public Result requestAppVideo(String userId) {
		Result result = new Result();
		BphNoticeData bphNoticeData = new BphNoticeData();
		BphNoticeContent bphNoticeContent = new BphNoticeContent();
		bphNoticeContent.setTitle("请求视频直播");
		bphNoticeContent.setMessage(UserUtils.getUser().getName() + "请求视频播放，请打开视频功能");
		List<String> lists = Lists.newArrayList();
		lists.add(userId);
		bphNoticeData.setUserId(lists);
		bphNoticeData.setType("3");
		bphNoticeData.setContent(bphNoticeContent);
		JSONObject jsonObject = JSONObject.fromObject(bphNoticeData);
		String arjflatapp = Global.getConfig("arjflatapp");
		String url = arjflatapp + "/rabbitService/appRabbitMQ/" + UserUtils.getUser().getLoginName();
		String param = "parm=" + jsonObject.toString();
		String res = Tool.sendPost(url, param);
		JSONObject resJson = JSONObject.fromObject(res);
		String retCode = resJson.getString("retCode");
		if(!"0".equals(retCode)) {
			result.setRet(retCode);
			result.setContent(resJson.getString("retMessage"));
			return result;
		}
		int flag = 0;
		while (true) {
			for (Map.Entry<String, BphAppVideo> entry : userAppVideoMap.entrySet()) {
				if (userId.equals(entry.getKey())) {
					if ("0".equals(entry.getValue().getStatus())) {
						result.setRet(Result.ERROR_OK);
						result.setContent(entry.getValue());
						userAppVideoMap.remove(userId);
						return result;
					} else if ("1".equals(entry.getValue().getStatus())) {
						result.setRet("1");
						result.setContent(entry.getValue());
						userAppVideoMap.remove(userId);
						return result;
					}
				}
			}
			try {
				Thread.sleep(1000);
				flag++;
				if (flag >= 60) {
					result.setRet("2");
					if (userAppVideoMap.contains(userId)) {
						userAppVideoMap.remove(userId);
					}
					return result;
				}
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	public void requestAppVideoCallback(String paramIn) {
		BphAppVideo bphAppVideo = null;
		try {
			bphAppVideo = (BphAppVideo) JSON.parseObject(paramIn, Class.forName(BphAppVideo.class.getName()));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		userAppVideoMap.put(bphAppVideo.getUserId(), bphAppVideo);
	}

	public Map<String, Object> statCountGroupOffice() {
		List<BphAlarmTypeStat> dataList = Lists.newArrayList();
		List<Office> officeList = officeService.findAll();
		officeList.forEach((office) -> {
			if("0".equals(office.getDelFlag()) && "2".equals(office.getType())) {
				BphAlarmTypeStat b = new BphAlarmTypeStat();
				b.setOfficeName(office.getName());
				b.setNum("0");
				b.setOfficeId(office.getId());
				dataList.add(b);
			}
		});
		List<BphAlarmInfo> bphAlarmInfoList = dao.statCountGroupOffice();
		for (BphAlarmTypeStat bphAlarmTypeStat : dataList) {
			for (BphAlarmInfo bphAlarmInfo : bphAlarmInfoList) {
				if (bphAlarmTypeStat.getOfficeName().equals(bphAlarmInfo.getOffice().getName())) {
					bphAlarmTypeStat.setNum(bphAlarmInfo.getNum());
				}
			}
		}
		Map<String, Object> map = new HashMap<>();
		map.put("data", dataList);
		return map;
	}

	public Map<String, Object> statPercentByOffice(BphAlarmInfo bphAlarmInfo) {
		List<BphAlarmInfo> bphAlarmInfoList = dao.statPercentByOffice(bphAlarmInfo);
		List<Dict> dictList = DictUtils.getDictList("bph_alarm_info_typecode");
		List<BphAlarmTypeStat> dataList = Lists.newArrayList();
		List<String> typeNameList = Lists.newArrayList();
		for (Dict dict : dictList) {
			typeNameList.add(dict.getLabel());
			BphAlarmTypeStat b = new BphAlarmTypeStat();
			b.setName(dict.getLabel());
			b.setType(dict.getValue());
			b.setNum("0");
			b.setOfficeId(bphAlarmInfo.getOfficeId());
			dataList.add(b);
		}
		for (BphAlarmTypeStat bphAlarmTypeStat : dataList) {
			for (BphAlarmInfo info : bphAlarmInfoList) {
				if (bphAlarmTypeStat.getName().equals(info.getTypeName())) {
					bphAlarmTypeStat.setNum(info.getNum());
				}
			}
		}
		Map<String, Object> map = new HashMap<>();
		map.put("typeName", typeNameList);
		map.put("data", dataList);
		return map;
	}

	public Map<String, Object> statCountByOffice(BphAlarmInfo bphAlarmInfo) {
		List<BphAlarmInfo> bphAlarmInfoList = dao.statCountByOffice(bphAlarmInfo);
		List<Dict> dictList = DictUtils.getDictList("bph_alarm_info_typecode");
		List<String> typeNameList = Lists.newArrayList();//警情类型数组
		List<BphAlarmTypeStat> resultList = Lists.newArrayList();//返回的数据
		dictList.forEach((d) -> {
			typeNameList.add(d.getLabel());
			BphAlarmTypeStat b = new BphAlarmTypeStat();
			b.setName(d.getLabel());
			b.setType(d.getValue());
			b.setNumList(Lists.newArrayList());
			resultList.add(b);
		});
		List<String> dateList = Lists.newArrayList();//日期数组
		bphAlarmInfoList.forEach((alarmInfo) -> {
			if(!dateList.contains(alarmInfo.getDateTime())) {
				dateList.add(alarmInfo.getDateTime());
			}
			resultList.forEach((stat) -> {
				if(stat.getName().equals(alarmInfo.getTypeName())) {
					stat.getNumList().add(alarmInfo.getNum());
				}
			});
		});
		Map<String, Object> map = new HashMap<>();
		map.put("dateArray", dateList);
		map.put("typeName", typeNameList);
		map.put("data", resultList);
		return map;
	}

	public List<BphAlarmInfo> findByHandlePoliceId(String handlePoliceId){
		return dao.findByHandlePoliceId(handlePoliceId);
	}

	public LayUIBean queryPoliceByAlarmId(String alarmId) {
		LayUIBean result = new LayUIBean();
		BphAlarmInfo bphAlarmInfo = get(alarmId);
		Office handlingUnit = bphAlarmInfo.getOffice();
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<CcmOrgTeam> userList = Lists.newArrayList();
		if(handlingUnit == null) {
			//没有处理单位，查询出所有的警员赋值
			userList = flatTreeDao.findAllUser();
		} else {
			//根据处理单位查询出所有的用户，然后给用户赋值
			User user = new User();
			Office office = new Office();
			office.setId(handlingUnit.getId());
			user.setOffice(office);
			CcmOrgTeam ccmOrgTeam = new CcmOrgTeam();
			ccmOrgTeam.setUser(user);
			userList = ccmOrgTeamDao.queryUserByOfficeId(ccmOrgTeam);
		}
		List<User> onlineUsers = UserUtils.getOnlineUsers();
		List<String> userIdList = Lists.newArrayList();
		for (int i = 0; i < onlineUsers.size(); i++) {
			userIdList.add(onlineUsers.get(i).getId());
		}
		for(Map.Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
			userIdList.add(entry.getValue().getUserId());
		}
		BphAlarmHandleUserState bphAlarmHandleUserState = new BphAlarmHandleUserState();
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
					double distance = Tool.getDistance(Double.valueOf(x), Double.valueOf(y), Double.valueOf(bphAlarmInfo.getX()), Double.valueOf(bphAlarmInfo.getY()));
					map.put("distance", String.format("%.2f", distance));
					map.put("x", x);
					map.put("y", y);
				}
			} else {
				map.put("state", "离线");
			}
			mapList.add(map);
		});
		result.setData(mapList);
		result.setCode(Result.ERROR_OK);
		result.setMsg("操作成功");
		return result;
	}

	public Map<String, Object> queryTimeoutAlarm() {
		BphTimeoutAlarm bphTimeoutAlarm = new BphTimeoutAlarm();
		Map<String, Object> resultMap = Maps.newConcurrentMap();
		List<BphTimeoutAlarm> dispatchTimeoutAlarmList = Lists.newArrayList();
		List<BphTimeoutAlarm> acceptTimeoutAlarmList = Lists.newArrayList();
		List<BphTimeoutAlarm> arriveTimeoutAlarmList = Lists.newArrayList();
		bphTimeoutAlarm.setMaxAcceptTime(Long.valueOf(SysConfigInit.ALARM_CHECK_CONFIG.getMaxAcceptTime()) * 60);
		bphTimeoutAlarm.setMaxArriveTime(Long.valueOf(SysConfigInit.ALARM_CHECK_CONFIG.getMaxArriveTime()) * 60);
		bphTimeoutAlarm.setMaxDispatchTime(Long.valueOf(SysConfigInit.ALARM_CHECK_CONFIG.getMaxDispatchTime()) * 60);
		List<BphTimeoutAlarm> timeoutAlarmList = dao.queryTimeoutAlarm(bphTimeoutAlarm);
		timeoutAlarmList.forEach(alarm -> {
			if (StringUtils.equals("0", alarm.getTimeoutType())) {
				dispatchTimeoutAlarmList.add(alarm);
			} else if (StringUtils.equals("1", alarm.getTimeoutType())) {
				acceptTimeoutAlarmList.add(alarm);
			} else if (StringUtils.equals("2", alarm.getTimeoutType())) {
				arriveTimeoutAlarmList.add(alarm);
			}
		});
		resultMap.put("dispatchTimeoutAlarm", dispatchTimeoutAlarmList);
		resultMap.put("acceptTimeoutAlarm", acceptTimeoutAlarmList);
		resultMap.put("arriveTimeoutAlarm", arriveTimeoutAlarmList);
		return resultMap;
	}

	public String receiveDockingData(String param) {

		JSONObject jsonParm = JSONObject.fromObject(param);
		jsonParm.get("");
		BphDockingAlarmInfo bphDockingAlarmInfo = analysisJson(param);
		if (bphDockingAlarmInfo == null) {
			return "-1";
		}
		//分流数据处理，如果为自动分流，则配置部门，否则直接存储
		SysConfig sysConfig = sysConfigDao.get("alarm_data_config");
		JSONObject jsonObject = JSONObject.fromObject(sysConfig.getParamStr());


		String splitFlag = (String) jsonObject.get("alarmFlowFlag");
		if ("1".equals(splitFlag)) {
			List<String> pointList = Lists.newArrayList();
			for(Map.Entry<String, String> entry : CacheTableData.AREA_ID_POINTS.entrySet()) {
				if(StringUtils.isNotBlank(entry.getValue())) {
					String[] point = entry.getValue().split(";");
					pointList.addAll(Arrays.asList(point));
					double[] lat = new double[pointList.size()];
					double[] lon = new double[pointList.size()];
					for(int i = 0; i < pointList.size(); i++) {
						String[] pointInfo = pointList.get(i).split(",");
						lat[i] = Double.valueOf(pointInfo[0]);
						lon[i] = Double.valueOf(pointInfo[1]);
					}
					boolean flag = Tool.isInPolygon(bphDockingAlarmInfo.getY(), bphDockingAlarmInfo.getX(), lon, lat);
					if(flag) {
						bphDockingAlarmInfo.setAreaId(entry.getKey());
						bphDockingAlarmInfo.setOfficeId(CacheTableData.AREA_ID_OFFICE.get(entry.getKey()).getId());
						bphDockingAlarmInfo.setOfficeIds(CacheTableData.AREA_ID_OFFICE.get(entry.getKey()).getParentIds());
					}
				}
			}
		}
		
		/*//添加人员警情标志位，明确处理时的警情
		String alarmHandleFlag = (String) jsonObject.get("alarmHandleFlag");
		//警情处警单位设置标志们 1：自动 0手动
		if ("1".equals(alarmHandleFlag)) {//如果为自动,设置标志位，否则不作处理；
			bphDockingAlarmInfo.setPoliceName("alarmHandleAuto");
		}*/
		dataCacheList.add(bphDockingAlarmInfo);
		return "0";
	}


	/**
	 * 方法说明： json字符串解析
	 *
	 * @param param
	 * @return
	 * @作者及日期：wangyikai 2018-08-15
	 * @修改人及日期：
	 * @修改描述：
	 * @其他：
	 */
	@SuppressWarnings("serial")
	private BphDockingAlarmInfo analysisJson(String param) {
		BphDockingAlarmInfo bphDockingAlarmInfo = null;
		if (StringUtils.isNotBlank(param)) {
			try {
				Gson gson = new Gson();
				Type type = new TypeToken<BphDockingAlarmInfo>(){}.getType();
				bphDockingAlarmInfo = gson.fromJson(param, type);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return bphDockingAlarmInfo;
	}
	/**
	 * 方法说明： json字符串解析
	 *
	 * @param param
	 * @return
	 * @作者及日期：wangyikai 2018-08-15
	 * @修改人及日期：
	 * @修改描述：
	 * @其他：
	 */
	@SuppressWarnings("serial")
	private BphDockingJjdbInfo analysisJsonJj(String param) {
		BphDockingJjdbInfo bphDockingAlarmInfo = null;
		if (StringUtils.isNotBlank(param)) {
			try {
				Gson gson = new Gson();
				Type type = new TypeToken<BphDockingJjdbInfo>(){}.getType();
				bphDockingAlarmInfo = gson.fromJson(param, type);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return bphDockingAlarmInfo;
	}

	public void insertDockingData() {
		if(CollectionUtils.isNotEmpty(dataCacheList)) {
			List<BphDockingAlarmInfo> dataList = Lists.newArrayList();
			dataList.addAll(dataCacheList);
			dataCacheList = Collections.synchronizedList(Lists.newArrayList());
			DataInsertThread dataInsertThread = new DataInsertThread(dataList);
			dataInsertThread.start();
		}
	}

	class DataInsertThread extends Thread {
		List<BphDockingAlarmInfo> backups = Lists.newArrayList(); // 该线程保存的数据
		public DataInsertThread(List<BphDockingAlarmInfo> cache) {
			backups.addAll(cache);
		}
		public void run() {
			try {
				if (CollectionUtils.isNotEmpty(dataCacheList)) {
					dao.insertData(backups);
				}
			} catch (Exception e) {
				e.getStackTrace();
			}
		}
	}

	public List<BphAlarmHandleFileResult> getAlarmHandleFile(String id) {
		List<BphAlarmHandleFile> alarmHandleFile = dao.getAlarmHandleFile(id);
		Map<String, BphAlarmHandleFileResult> fileMap = Maps.newConcurrentMap();
		alarmHandleFile.forEach(file -> {
			if (fileMap.containsKey(file.getUserId())) {
				if(StringUtils.equals("0", file.getType())) {
					fileMap.get(file.getUserId()).getImgFileList().add(file);
				}else if(StringUtils.equals("3", file.getType())) {
					fileMap.get(file.getUserId()).getAudioFileList().add(file);
				}else if(StringUtils.equals("4", file.getType())) {
					fileMap.get(file.getUserId()).getVideoFileList().add(file);
				}
			} else {
				BphAlarmHandleFileResult fileResult = new BphAlarmHandleFileResult();
				fileResult.setUserId(file.getUserId());
				fileResult.setUserName(file.getUserName());
				fileResult.setHandleResult(file.getHandleResult());
				fileResult.setImgFileList(Lists.newArrayList());
				fileResult.setAudioFileList(Lists.newArrayList());
				fileResult.setVideoFileList(Lists.newArrayList());
				if(StringUtils.equals("0", file.getType())) {
					fileResult.getImgFileList().add(file);
				}else if(StringUtils.equals("3", file.getType())) {
					fileResult.getAudioFileList().add(file);
				}else if(StringUtils.equals("4", file.getType())) {
					fileResult.getVideoFileList().add(file);
				}
				fileMap.put(file.getUserId(), fileResult);
			}
		});
		List<BphAlarmHandleFileResult> result = Lists.newArrayList();
		for (Entry<String, BphAlarmHandleFileResult> entry : fileMap.entrySet()) {
			result.add(entry.getValue());
		}
		return result;
	}

	@Transactional(readOnly = false)
	public boolean insertAlarmByIdForOffice(@Param("id")String id,@Param("officeId")String officeId) {
		String[] offIds = officeId.split(",");
		Set<String> officeSet = Sets.newHashSet();
		for(int i = 0;i < offIds.length;i++) {
			Office office = officeService.get(offIds[i]);
			if (office != null)
				officeSet.add(office.getParentIds());
		}
		String officeIds = officeSet.toString();
		officeIds = Tool.getStringValue(officeIds);
		int i = dao.insertAlarmByIdForOffice(id, officeId,officeIds);
		if(i <= 0) {
			return false;
		}
		return sendAlarmInfo(offIds,id);
	}

	/**
	 * 方法描述：警情分流发送警情
	 * @param offIds
	 * @param id
	 * @return
	 */
	public boolean sendAlarmInfo(String[] offIds,String id) {
		System.out.println("处警数据对接 ---》sendAlarmInfo");
		BphAlarmInfo alarmInfo = get(id);
		BphAlarmHandleReceive bphAlarmHandleReceive = new BphAlarmHandleReceive();
		String userIds = getUserIds(offIds);
		bphAlarmHandleReceive.setUserId(userIds);
		bphAlarmHandleReceive.setDestinationX(String.valueOf(alarmInfo.getX()));
		bphAlarmHandleReceive.setDestinationY(String.valueOf(alarmInfo.getY()));
		bphAlarmHandleReceive.setType("2");
		bphAlarmHandleReceive.setOptionDesc("警情分流派发");
		bphAlarmHandleReceive.setAlarmId(id);
		BphAlarmHandleService handleBean = SpringContextHolder.getBean("bphAlarmHandleService");
		return handleBean.sendAlarmInfo(bphAlarmHandleReceive);
	}

	/**
	 * 方法描述：获取user的id
	 * @param office
	 * @return
	 */
	public String getUserIds(String[] officeIds) {
		String userIds = "";
		for(int i = 0;i < officeIds.length;i++) {
			User user = new User();
			Office office = new Office();
			office.setId(officeIds[i]);
			user.setOffice(office);
			List<User> users = userDao.findUserByOfficeId(user);
			for (User userId : users) {
				userIds += userId.getId() + ",";
			}
		}
		return userIds;
	}

	/**
	 * 分流数据逻辑
	 * 1、对接过数据，插入数据时，首先判断：自动分流(是：否)
	 *   是自动分流，| 查看当前数据是否有管辖单位 (有：无) 
	 *                      |有管辖单位|进行下一步判断 
	 *                      |无管辖单位|则根据中心点算出坐标区域，配置部门
	 *	  不是自动分流|后端不作处理，属于页面操作(手动进行分配单位)		                   
	 * 2、对数据分流之后数据继续往下流转，流转的过程中判断：警情处警设置：(自动：手动)
	 *   自动处警：|判断当前属于自动处警的哪种模式( 1： 片区片警制  2 ：抢单模式  0： 无)
	 *          |如果是0，则系统 没有配置，则默认设置为 抢单模式，否则为其它对应模式；
	 *                 |如果为抢单模式：|则派警为部门所有人(找出管辖区所有部门人员，进行群发案件，实现抢单模式)
	 *                 |如果为片区片警：|根据坐标推算出当前区域部门 --然后找人发送(通过区域找部门，通过部门找人员进行片区专人发送)
	 *
	 *
	 */

	public String directReceiveDockingData(BphDockingJjdbInfo bphDockingAlarmInfo ) {

		if (bphDockingAlarmInfo == null) {
			return "-1";
		}
		
		/*
		JSONObject jsonParm = JSONObject.fromObject(param);
		BphDockingJjdbInfo bphDockingAlarmInfo = (BphDockingJjdbInfo) jsonParm.toBean(jsonParm, BphDockingJjdbInfo.class);//analysisJson(param);
*/
		//BphDockingJjdbInfo bphDockingAlarmInfo = analysisJsonJj(param);

		String yzb = bphDockingAlarmInfo.getYzb();
		String xzb = bphDockingAlarmInfo.getXzb();
		double y = 0;
		double x = 0;
		if (StringUtils.isNoneBlank(yzb)) {
			y = Double.valueOf(yzb);
		}
		if(StringUtils.isNoneBlank(xzb)){
			x = Double.valueOf(xzb);
		}
		String gxofficeId = bphDockingAlarmInfo.getGxdwdm();
		SysConfig sysConfig = sysConfigDao.get("alarm_data_config");
		JSONObject jsonObject = JSONObject.fromObject(sysConfig.getParamStr());
		String splitFlag = (String) jsonObject.get("alarmFlowFlag");
		//分流数据处理，如果为自动分流，且管辖单位为空， 则配置部门，否则直接进行下一步判断 
		if ("1".equals(splitFlag)  ) {
			if (StringUtils.isBlank(gxofficeId)) {
				List<String> pointList = Lists.newArrayList();
				for(Map.Entry<String, String> entry : CacheTableData.AREA_ID_POINTS.entrySet()) {
					if(StringUtils.isNotBlank(entry.getValue())) {
						String[] point = entry.getValue().split(";");
						pointList.addAll(Arrays.asList(point));
						double[] lat = new double[pointList.size()];
						double[] lon = new double[pointList.size()];
						for(int i = 0; i < pointList.size(); i++) {
							String[] pointInfo = pointList.get(i).split(",");
							lat[i] = Double.valueOf(pointInfo[0]);
							lon[i] = Double.valueOf(pointInfo[1]);
						}

						boolean flag = Tool.isInPolygon(y, x, lon, lat);
						if(flag) {
							bphDockingAlarmInfo.setAreaId(entry.getKey());
							bphDockingAlarmInfo.setOfficeId(CacheTableData.AREA_ID_OFFICE.get(entry.getKey()).getId());
							bphDockingAlarmInfo.setOfficeIds(CacheTableData.AREA_ID_OFFICE.get(entry.getKey()).getParentIds());
						}
					}
				}
			}
			String id = UUID.randomUUID().toString() ;
			BphAlarmInfo alarmInfo =  tranBphEntity(id,bphDockingAlarmInfo);

			dao.insertAlarm(alarmInfo);
			//对数据分流之后数据继续往下流转，流转的过程中判断：警情处警设置：(自动：手动)
			setAlarmToUsers(id,alarmInfo.getOfficeId(),bphDockingAlarmInfo);
		}
		return "0";
	}

	private BphAlarmInfo tranBphEntity(String id,BphDockingJjdbInfo bphDockingAlarmInfo) {
		BphAlarmInfo alarmInfo = new BphAlarmInfo();
		alarmInfo.setId(id);
		alarmInfo.setOrderNum(bphDockingAlarmInfo.getJjdbh());
		alarmInfo.setPoliceNum(bphDockingAlarmInfo.getJjygh());
		alarmInfo.setPoliceName(bphDockingAlarmInfo.getJjyxm());
		alarmInfo.setManName(bphDockingAlarmInfo.getBjrxm());
		Long bjrxb = bphDockingAlarmInfo.getBjrxb();
		if (bjrxb != null ) {
			alarmInfo.setManSex(bjrxb.toString());
		}
		alarmInfo.setManTel(bphDockingAlarmInfo.getLxdh());
		alarmInfo.setPlace(bphDockingAlarmInfo.getAfdz());
		String yzb = bphDockingAlarmInfo.getYzb();
		String xzb = bphDockingAlarmInfo.getXzb();
		String hzb = bphDockingAlarmInfo.getHbgd();
		if (StringUtils.isNoneBlank(xzb)) {
			alarmInfo.setX(Double.valueOf(Double.valueOf(xzb)));
		}
		if(StringUtils.isNoneBlank(yzb)){
			alarmInfo.setY(Double.valueOf(yzb));
		}
		if(StringUtils.isNoneBlank(hzb)){
			alarmInfo.setZ(Double.valueOf(hzb));
		}
		alarmInfo.setContent(bphDockingAlarmInfo.getBjnr());
		alarmInfo.setTypeCode(bphDockingAlarmInfo.getJqlbdm()); //对接数据的类别 是本平台的类型数据

		alarmInfo.setTypeName(DictUtils.getDictLabel(bphDockingAlarmInfo.getJqlxdm(), "bph_alarm_info_typecode", ""));
		alarmInfo.setGenreCode(bphDockingAlarmInfo.getJqlxdm());
		alarmInfo.setClassCode(bphDockingAlarmInfo.getJqxldm());//对接数据的类型数据 是本平台的类别数据
		Office office = new Office();
		String officeCode = bphDockingAlarmInfo.getGxdwdm();
		if (StringUtils.isNoneBlank(officeCode)) {
			office = dao.selectOfficeByCode(officeCode);
		}
		if (office != null) {
			Area area = office.getArea();
			if (area != null) {
				alarmInfo.setAreaId(office.getArea().getId());
			}
			alarmInfo.setOfficeId(office.getId());
			alarmInfo.setOfficeIds(office.getParentIds());
		}
		alarmInfo.setAlarmFrom(bphDockingAlarmInfo.getBjfsdm());
		alarmInfo.setAlarmTime(bphDockingAlarmInfo.getBjsj());
		alarmInfo.setAlarmRecord(bphDockingAlarmInfo.getJjlyh());
		alarmInfo.setIsImportant("0");//所有同步过来的数据设置警情为普通警情
		alarmInfo.setState("0");//同步过来的数据都设为未处理	
		alarmInfo.setCreateBy(new User("1"));
		alarmInfo.setCreateDate(new Date());
		alarmInfo.setUpdateBy(new User("1"));
		alarmInfo.setUpdateDate(new Date());
		alarmInfo.setDelFlag("0");

		alarmInfo.setDealTypeCode(bphDockingAlarmInfo.getCllxdm());
		alarmInfo.setReceiveOfficeId(bphDockingAlarmInfo.getJjdwdm());
		return alarmInfo;
	}

	//设置警情给警区人员
	private void setAlarmToUsers(String id,String officeId,BphDockingJjdbInfo bphDockingAlarmInfo) {
		SysConfig sysConfig = sysConfigDao.get("alarm_data_config");
		JSONObject jsonObject = JSONObject.fromObject(sysConfig.getParamStr());
		//alarmHandleFlag 警情处警单位设置标志们 1：自动 0手动
		//handleModel 处警模式设置  1 片区片警制 2 抢单模式 0  无
		String alarmHandleFlag = (String) jsonObject.get("alarmHandleFlag");
		if ("1".equals(alarmHandleFlag) ) {
			String handleModel = (String) jsonObject.get("handleModel");
			//|如果是0，则系统 没有配置，则默认设置为 抢单模式，否则为其它对应模式；
			//0 或 2 抢单模式  (给派出所及警区内所有人发送案件信息)
			if ("0".equals(handleModel) || "2".equals(handleModel) ) {
				//找出派出所所有部门人员，进行群发案件，实现抢单模式
				sendAlarmInfo(officeId.split(","),id);
			}else{
				//1 片区片警制(通过区域找部门，通过部门找人员进行片区专人发送)
			}
		}
		//	List<String> asList = Arrays.asList(bphDockingAlarmInfo.getOfficeIds().split(",")) ;

	}
	/**
	 *
	 * @param orderNum
	 * @return 有， true
	 * @return  空     false;
	 */
	public boolean dataExist(String orderNum){
		boolean flag = false;
		List<BphAlarmInfo> selectAlarmInfoByOrderNum = dao.selectAlarmInfoByOrderNum(orderNum);
		if (selectAlarmInfoByOrderNum.size() > 0 && selectAlarmInfoByOrderNum != null) {
			flag = true;

		}
		//dao.selectAlarmInfoByOrderNum(orderNum).size()> 0 && dao.selectAlarmInfoByOrderNum(orderNum) != null
		return    flag;
	}
	@Transactional(readOnly = false)
	public int updateBphAlarmInfo(BphAlarmInfo alarmInfo) {
		int num = dao.updateBphAlarmInfo(alarmInfo);
		return num;
	}

	public AlarmNotifyInfo selectAlarmNotifyInfoById(String alarmId) {
		return dao.selectAlarmNotifyInfoById(alarmId);
	}
}