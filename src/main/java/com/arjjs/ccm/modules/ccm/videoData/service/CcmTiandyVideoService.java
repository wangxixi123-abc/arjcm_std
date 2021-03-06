package com.arjjs.ccm.modules.ccm.videoData.service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.ccmsys.dao.CcmDeviceDao;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDevice;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDeviceArea;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgArea;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgAreaService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.sys.entity.SysConfig;
import com.arjjs.ccm.modules.ccm.sys.service.SysConfigService;
import com.arjjs.ccm.modules.ccm.videoData.entity.CcmTiandyOnlineStatus;
import com.arjjs.ccm.modules.flat.deviceonline.dao.CcmDeviceOnlineDao;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.tool.Tool;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

@Service
@Transactional(readOnly = true)
public class CcmTiandyVideoService extends BaseController {
	@Autowired
	private SysConfigService sysConfigService;
	
	@Autowired
	private CcmDeviceDao ccmDeviceDao;

	@Autowired
	private CcmDeviceOnlineDao ccmDeviceOnlineDao;
	
	@Autowired
	private CcmOrgAreaService ccmOrgAreaService;

	public CcmRestResult getCameras() {
		CcmRestResult result = new CcmRestResult();
		SysConfig sysConfig = sysConfigService.get("tiandy_video_ocx_play");
		//解JSON
		JSONObject jsonObject = JSONObject.parseObject(sysConfig.getParamStr());
		String tiandyIp = null;
		if(jsonObject.containsKey("tiandyIp")) {
			tiandyIp = jsonObject.getString("tiandyIp");
		}
		String tiandyPort = null;
		if(jsonObject.containsKey("tiandyPort")) {
			tiandyPort = jsonObject.getString("tiandyPort");
		}
		if(StringUtils.isNotEmpty(tiandyIp) && StringUtils.isNotEmpty(tiandyPort)) {			
			if(isStopThread) {	
				TiandyCamerasInsertThread tiandyCamerasInsertThread = new TiandyCamerasInsertThread();
				tiandyCamerasInsertThread.start();
			}
			result.setCode(CcmRestType.OK);
			result.setResult(null);
		}else {
			result.setCode(CcmRestType.ERROR_PARAM);
			result.setResult(null);
		}
		return result;
	}
	
	private static boolean isStopThread = true;

	@Transactional(readOnly = false)
	public CcmRestResult updateCamerasStatus() {
		CcmRestResult result = new CcmRestResult();
		SysConfig sysConfig = sysConfigService.get("tiandy_video_ocx_play");
		//解JSON
		JSONObject jsonObject = JSONObject.parseObject(sysConfig.getParamStr());
		String tiandyIp = jsonObject.getString("tiandyIp");
		String tiandyPort = jsonObject.getString("tiandyPort");
		String username = "";
		String password = "";
		if(jsonObject.containsKey("tiandyUserName")) {
			username = jsonObject.getString("tiandyUserName");
		}
		if(jsonObject.containsKey("tiandyPassWord")) {
			password = jsonObject.getString("tiandyPassWord");
		}
		// 登陆
		String urlUserId = "http://" + tiandyIp + ":" + tiandyPort + "/Easy7/apps/WebService/LogIn.jsp?";
		if(StringUtils.isNotEmpty(username) && StringUtils.isNotEmpty(password)) {
			urlUserId += "UserName=" + username + "&Password=" + password;
		}else {
			urlUserId += "UserName=admin&Password=1111";
		}
//		System.out.println("获取userid的url === 》》》 " + urlUserId);
		String userIdReturn = Tool.getRestReturn(urlUserId);
		String tiandyUserId = null;
		if(StringUtils.isNotBlank(userIdReturn)) {
			JSONObject dataJson = JSONObject.parseObject(userIdReturn);
			if(dataJson.containsKey("content")) {
				tiandyUserId = dataJson.getString("content");
			}
		}
		/*System.out.println("tiandyUserId === 》》》 " + tiandyUserId);*/
		// 获取设备在线状态
		if(StringUtils.isNotEmpty(tiandyUserId)) {
			String urlRest = "http://" + tiandyIp + ":" + tiandyPort + "/Easy7/rest/obj/getObjStatus?CurrentUserId=" + tiandyUserId;
			if(StringUtils.isNotEmpty(username) && StringUtils.isNotEmpty(password)) {
				urlRest += "&UserId=" + username + "&Password=" + password;
			}else {
				urlRest += "&UserId=admin&Password=1111";
			}
		/*	System.out.println("获的设备在线状态的url === 》》》 " + urlRest);*/
			String restReturn = Tool.getRestReturn(urlRest);
/*			String restReturn = "{\"ret\":0,\n" +
					"\"content\":[\n" +
					"{\"id\":\"46020900001325000026_host\",\"status\":1},\n" +
					"{\"id\":\"46020900001325000025_host\",\"status\":5},\n" +
					"{\"id\":\"46020900001325000021_host\",\"status\":5},\n" +
					"{\"id\":\"46020900001325000023_host\",\"status\":5},\n" +
					"{\"id\":\"46020900001325000011_host\",\"status\":5}\n" +
					"]\n" +
					"}";*/
			if(StringUtils.isNotBlank(restReturn)) {
				JSONObject dataJson = JSONObject.parseObject(restReturn);
				if(dataJson.containsKey("content")) {
					JSONArray itemsJson = dataJson.getJSONArray("content");
					List<CcmTiandyOnlineStatus> easy7DevList =JSONArray.parseArray(itemsJson.toJSONString(),CcmTiandyOnlineStatus.class);
					List<CcmTiandyOnlineStatus>  ccmDevList =  ccmDeviceDao.findIdAndStatus();
					for (CcmTiandyOnlineStatus  easy7Dev : easy7DevList){
                        String status = easy7Dev.getStatus();
                        if ("5".equals(status)){// easy7 的状态
                            status = "3"; //本系统 的状态
                        }
						for(CcmTiandyOnlineStatus ccmDev:ccmDevList){
							if (easy7Dev.getId().equals(ccmDev.getId()) && !status.equals(ccmDev.getStatus())){
								ccmDeviceDao.updateDevStatus(easy7Dev.getId(),status);
							}
						}
					}
				}
			}
		}
		return  result;
	}

	class TiandyCamerasInsertThread extends Thread {
		public void run() {
			System.out.println("获取监控点开始");
			isStopThread = false;
			SysConfig sysConfig = sysConfigService.get("tiandy_video_ocx_play");
			//解JSON
			JSONObject jsonObject = JSONObject.parseObject(sysConfig.getParamStr());
			String tiandyIp = jsonObject.getString("tiandyIp");
			String tiandyPort = jsonObject.getString("tiandyPort");
			if(jsonObject.containsKey("tiandyUserName")) {
				username = jsonObject.getString("tiandyUserName");
			}
			if(jsonObject.containsKey("tiandyPassWord")) {
				password = jsonObject.getString("tiandyPassWord");
			}
			try {
				String urlUserId = "http://" + tiandyIp + ":" + tiandyPort + "/Easy7/apps/WebService/LogIn.jsp?";
				if(StringUtils.isNotEmpty(username) && StringUtils.isNotEmpty(password)) {
					urlUserId += "UserName=" + username + "&Password=" + password;
				}else {
					urlUserId += "UserName=admin&Password=1111";
				}
				System.out.println("获取userid的url === 》》》 " + urlUserId);
				String userIdReturn = Tool.getRestReturn(urlUserId);
				String tiandyUserId = null;
				if(StringUtils.isNotBlank(userIdReturn)) {
					JSONObject dataJson = JSONObject.parseObject(userIdReturn);
					if(dataJson.containsKey("content")) {
						tiandyUserId = dataJson.getString("content");
					}
				}
				System.out.println("tiandyUserId === 》》》 " + tiandyUserId);
				if(StringUtils.isNotEmpty(tiandyUserId)) {
					String urlRest = "http://" + tiandyIp + ":" + tiandyPort + "/Easy7/apps/WebService/GetResourceTree_Ex.jsp?CurrentUserId=" + tiandyUserId;
					if(StringUtils.isNotEmpty(username) && StringUtils.isNotEmpty(password)) {
						urlRest += "&UserId=" + username + "&Password=" + password;
					}else {
						urlRest += "&UserId=admin&Password=1111";
					}
					System.out.println("获取相机的url === 》》》 " + urlRest);
					String restReturn = Tool.getRestReturn(urlRest);
					//logger.debug("获取相机的返回参数----------》》》》》》》》》"+restReturn);
					if(StringUtils.isNotBlank(restReturn)) {
						JSONArray dataJson = JSONArray.parseArray(restReturn);
						if(dataJson.size() > 0) {
							System.out.println("开始便利数组");
							areaList.clear();
							List<CcmOrgArea> orgAreaList = ccmOrgAreaService.getAreaMap(new CcmOrgArea());
							this.sortList(areaList, orgAreaList, "0", true);
							forEachData(dataJson);
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				System.out.println("获取监控点结束");
				isStopThread = true;
			}
		}
		private List<CcmDeviceArea> areaList = Lists.newArrayList();
		private String client_sup_id = null;
		private String client_sup_ip = null;
		private String client_sup_port = null;
		private String dev_sup_id = null;
		private String dev_id = null;
		private String username = null;
		private String password = null;
		public void forEachData(JSONArray dataJson) {
			for (int i = 0; i < dataJson.size(); i++) {
				JSONObject deviceJson = dataJson.getJSONObject(i);
				String typeId = null;
				if(deviceJson.containsKey("typeId")) {
					typeId = deviceJson.getString("typeId");
				}
				if(StringUtils.isNotBlank(typeId)) {
					if(typeId.equals("3")) {
						if(deviceJson.containsKey("id")) {
							client_sup_id = deviceJson.getString("id");
						}
						if(deviceJson.containsKey("ip")) {
							client_sup_ip = deviceJson.getString("ip");
						}
						if(deviceJson.containsKey("port")) {
							client_sup_port = deviceJson.getString("port");
						}
						if(deviceJson.containsKey("items") && StringUtils.isNotBlank(deviceJson.getString("items"))) {
							JSONArray itemsJson = deviceJson.getJSONArray("items");
							forEachMsData(itemsJson);
						}
					}else {
						if(deviceJson.containsKey("items") && StringUtils.isNotBlank(deviceJson.getString("items"))) {
							JSONArray itemsJson = deviceJson.getJSONArray("items");
							forEachData(itemsJson);
						}
					}
				}
			}
		}
		public void forEachMsData(JSONArray dataJson) {
			for (int i = 0; i < dataJson.size(); i++) {
				JSONObject deviceJson = dataJson.getJSONObject(i);
				String typeId = null;
				if(deviceJson.containsKey("typeId")) {
					typeId = deviceJson.getString("typeId");
				}
				if(StringUtils.isNotBlank(typeId)) {
					if(typeId.equals("3")) {
						if(deviceJson.containsKey("id")) {
							dev_sup_id = deviceJson.getString("id");
						}
						if(deviceJson.containsKey("items") && StringUtils.isNotBlank(deviceJson.getString("items"))) {
							JSONArray itemsJson = deviceJson.getJSONArray("items");
							forEachMsData(itemsJson);
						}
					}else if(typeId.equals("4")) {
						if(deviceJson.containsKey("id")) {
							dev_id = deviceJson.getString("id");
						}
						if(StringUtils.isBlank(dev_sup_id)) {
							dev_sup_id = client_sup_id;
						}
						if(deviceJson.containsKey("items") && StringUtils.isNotBlank(deviceJson.getString("items"))) {
							JSONArray itemsJson = deviceJson.getJSONArray("items");
							forEachDeviceData(itemsJson);
						}
					}
				}
			}
		}
		public void forEachDeviceData(JSONArray dataJson) {
			for (int i = 0; i < dataJson.size(); i++) {
				JSONObject deviceJson = dataJson.getJSONObject(i);
				String typeId = null;
				if(deviceJson.containsKey("typeId")) {
					typeId = deviceJson.getString("typeId");
				}
				if(StringUtils.isNotBlank(typeId)) {
					if(typeId.equals("5")) {
						String code = null;
						String longitude = null;
						if(deviceJson.containsKey("longitude")) {
							longitude = deviceJson.getString("longitude");
						}
						String latitude = null;
						if(deviceJson.containsKey("latitude")) {
							latitude = deviceJson.getString("latitude");
						}
						if(StringUtils.isNotBlank(longitude) && StringUtils.isNotBlank(latitude)
								&& !longitude.equals("") && !latitude.equals("")
								&& !longitude.equals("0.0") && !latitude.equals("0.0")
								&& !longitude.equals("0") && !latitude.equals("0")
								&& !longitude.equals("null") && !latitude.equals("null")) {							
							if(deviceJson.containsKey("gaysId")) {
								code = deviceJson.getString("gaysId");
							}
							if(StringUtils.isNotBlank(code)) {
								CcmDevice ccmDevice = ccmDeviceDao.getByCode(code);
								if(ccmDevice == null || "".equals(ccmDevice.getId())) {//通过code没有取到对应设备，再通过名称去取设备（现场网关对接会经常改code，故增加名称的更新）
									if(deviceJson.containsKey("caption") && StringUtils.isNotBlank(deviceJson.getString("caption"))) {
										CcmDevice ccmDeviceFrom = new CcmDevice();
										ccmDeviceFrom.setName(deviceJson.getString("caption"));
										List<CcmDevice> ccmDeviceList = ccmDeviceDao.findList(ccmDeviceFrom);
										if (ccmDeviceList != null && ccmDeviceList.size() == 1) {//通过名称取到一条设备数据，则进行数据更新操作
											this.updateDevice(deviceJson, ccmDeviceList.get(0));
										} else {//code没有取到，名称没有取到，则新增数据
											this.insertDevice(deviceJson);
										}
									}
								} else {//通过code取得数据，则更新数据
									this.updateDevice(deviceJson, ccmDevice);
								}
							}
						}
					}
				}
			}
		}
		public void insertDevice(JSONObject deviceJson) {
			CcmDevice ccmDevice = new CcmDevice();
			String devId = deviceJson.getString("id");
			if(deviceJson.containsKey("id")) {
				ccmDevice.setId(devId);
			}
			if(deviceJson.containsKey("gaysId")) {
				ccmDevice.setCode(deviceJson.getString("gaysId"));
			}
			String caption = null;
			if(deviceJson.containsKey("caption")) {
				caption = deviceJson.getString("caption");
				ccmDevice.setName(deviceJson.getString("caption"));
			}
			String cameraType = "0";//0:'枪机'；1:'球机';2:'半球'
			if(deviceJson.containsKey("cameraType")) {
				cameraType = deviceJson.getString("cameraType");
				ccmDevice.setType(cameraType);
			}else{
				ccmDevice.setType("3");//其它
			}
			String longitude = null;
			if(deviceJson.containsKey("longitude")) {
				longitude = deviceJson.getString("longitude");
			}
			String latitude = null;
			if(deviceJson.containsKey("latitude")) {
				latitude = deviceJson.getString("latitude");
			}
			String areaId = null;
			if(StringUtils.isNotBlank(longitude) && StringUtils.isNotBlank(latitude)) {	        				
				String coordinate = longitude + "," + latitude;
				ccmDevice.setCoordinate(coordinate);
				List<String> pointList = Lists.newArrayList();
				areaId = this.getDeviceAreaId(areaList, pointList, Double.parseDouble(longitude), Double.parseDouble(latitude));
			}
			if(StringUtils.isBlank(areaId)) {
				areaId = Global.getConfig("DOCKING_MONITORING_POINT");
				if(StringUtils.isBlank(areaId)) {
					areaId = "0ac94bc554e241e9abeedcb982000003";
				}
			}
			String ch = null;
			if(deviceJson.containsKey("ch")) {	        					
				ch = deviceJson.getString("ch");
				ccmDevice.setChannelNum(deviceJson.getString("ch"));
			}
			JSONObject jsonOBJ = new JSONObject();
			jsonOBJ.put("caption", caption);
			jsonOBJ.put("dev_id", dev_id);
			jsonOBJ.put("username", username);
			jsonOBJ.put("password", password);
			jsonOBJ.put("client_sup_id", client_sup_id);
			jsonOBJ.put("dev_sup_id", dev_sup_id);
			jsonOBJ.put("client_sup_ip", client_sup_ip);
			jsonOBJ.put("client_sup_port", client_sup_port);
			jsonOBJ.put("ch", ch);
			jsonOBJ.put("data_type", 1);//0 主码流 1：子码流
			ccmDevice.setParam(jsonOBJ.toJSONString());
			ccmDevice.setCompanyId("tiandy");
			ccmDevice.setTypeId("001");
			ccmDevice.setImagePath("video.png");
			ccmDevice.setTypeVidicon("4");
			ccmDevice.setStatus("3"); //默认状态为离线 使用本系统字典对应值 Easy7 系统离线状态值 为：5
			Area areaTmp = new Area();
			areaTmp.setId(areaId);
			ccmDevice.setArea(areaTmp);
			User userTmp = new User();
			userTmp.setId("1");
			ccmDevice.setCreateBy(userTmp);
			ccmDevice.setCreateDate(new Date());
			ccmDevice.setUpdateBy(userTmp);
			ccmDevice.setUpdateDate(new Date());
			ccmDeviceDao.insert(ccmDevice);

		}
		public void updateDevice(JSONObject deviceJson,CcmDevice ccmDevice) {
			if(deviceJson.containsKey("gaysId") && StringUtils.isNotBlank(deviceJson.getString("gaysId"))) {
				ccmDevice.setCode(deviceJson.getString("gaysId"));
			}
			String caption = null;
			if(deviceJson.containsKey("caption") && StringUtils.isNotBlank(deviceJson.getString("caption"))) {
				caption = deviceJson.getString("caption");
				ccmDevice.setName(deviceJson.getString("caption"));
			}
			String cameraType = "0";//0:'枪机'；1:'球机';2:'半球'
			if(deviceJson.containsKey("cameraType")) {
				cameraType = deviceJson.getString("cameraType");
				ccmDevice.setType(cameraType);
			}
			String longitude = null;
			if(deviceJson.containsKey("longitude")) {
				longitude = deviceJson.getString("longitude");
			}
			String latitude = null;
			if(deviceJson.containsKey("latitude")) {
				latitude = deviceJson.getString("latitude");
			}
			String areaId = null;
			if (ccmDevice.getArea() != null && !"".equals(ccmDevice.getArea().getId())) {//原数据已设置区域的话，更新数据时用原来的区域id，pengjianqiang
				areaId = ccmDevice.getArea().getId();
			}
			//原无区域id时，存在坐标时，用坐标计算并更新区域
			if(StringUtils.isBlank(areaId) && StringUtils.isNotBlank(longitude) && StringUtils.isNotBlank(latitude)) {	        				
				String coordinate = longitude + "," + latitude;
				ccmDevice.setCoordinate(coordinate);
				List<String> pointList = Lists.newArrayList();
				areaId = this.getDeviceAreaId(areaList, pointList, Double.parseDouble(longitude), Double.parseDouble(latitude));
			}
			if(StringUtils.isBlank(areaId)) {
				areaId = Global.getConfig("DOCKING_MONITORING_POINT");
				if(StringUtils.isBlank(areaId)) {
					areaId = "0ac94bc554e241e9abeedcb982000003";
				}
			}
			String ch = null;
			if(deviceJson.containsKey("ch") && StringUtils.isNotBlank(deviceJson.getString("ch"))) {	        					
				ch = deviceJson.getString("ch");
				ccmDevice.setChannelNum(deviceJson.getString("ch"));
			}
			JSONObject jsonOBJ = new JSONObject();
			jsonOBJ.put("caption", caption);
			jsonOBJ.put("dev_id", dev_id);
			jsonOBJ.put("username", username);
			jsonOBJ.put("password", password);
			jsonOBJ.put("client_sup_id", client_sup_id);
			jsonOBJ.put("dev_sup_id", dev_sup_id);
			jsonOBJ.put("client_sup_ip", client_sup_ip);
			jsonOBJ.put("client_sup_port", client_sup_port);
			jsonOBJ.put("ch", ch);
			jsonOBJ.put("data_type", 1); //0 主码流 1：子码流
			ccmDevice.setParam(jsonOBJ.toJSONString());
			ccmDevice.setCompanyId("tiandy");
			ccmDevice.setTypeId("003");
			ccmDevice.setImagePath("video.png");
			ccmDevice.setTypeVidicon("4");
			if(StringUtils.isNotBlank(areaId)) {
				Area areaTmp = new Area();
				areaTmp.setId(areaId);
				ccmDevice.setArea(areaTmp);
			}
			User userTmp = new User();
			userTmp.setId("1");
			ccmDevice.setUpdateBy(userTmp);
			ccmDevice.setUpdateDate(new Date());
			ccmDeviceDao.update(ccmDevice);
		}
		
		public void sortList(List<CcmDeviceArea> list, List<CcmOrgArea> sourcelist, String parentId, boolean cascade) {
			for(int i = 0; i < sourcelist.size(); ++i) {
				CcmOrgArea e = (CcmOrgArea)sourcelist.get(i);
				if (e.getAreaParentId() != null && e.getAreaParentId().equals(parentId)) {
					CcmDeviceArea ccmDeviceArea = new CcmDeviceArea();
					ccmDeviceArea.setId(e.getAreaId());
					ccmDeviceArea.setAreaMap(e.getAreaMap());
					List<CcmDeviceArea> childrenList = Lists.newArrayList();
					ccmDeviceArea.setChildrenList(childrenList);
					list.add(ccmDeviceArea);
					if (cascade) {
						for(int j = 0; j < sourcelist.size(); ++j) {
							CcmOrgArea child = (CcmOrgArea)sourcelist.get(j);
							if (child.getAreaParentId() != null && child.getAreaParentId().equals(e.getAreaId())) {
								sortList(childrenList, sourcelist, e.getAreaId(), true);
								break;
							}
						}
					}
				}
			}
		}
		
		public String getDeviceAreaId(List<CcmDeviceArea> resultList, List<String> pointList, double lat, double lon) {
			String areaId = null;
			for (int i = 0; i < resultList.size(); i++) {
				CcmDeviceArea ccmDeviceArea = resultList.get(i);
				if(ccmDeviceArea != null) {
					List<CcmDeviceArea> childrenList = ccmDeviceArea.getChildrenList();
					if(childrenList.size() > 0) {
						areaId = getDeviceAreaId(childrenList,pointList,lat,lon);
						if(StringUtils.isBlank(areaId)) {
							areaId = isInPolygon(pointList, ccmDeviceArea, lat, lon);
						}
					}else {
						areaId = isInPolygon(pointList, ccmDeviceArea, lat, lon);
					}
					if(StringUtils.isNotBlank(areaId)) {
						break;
					}
				}
			}
			return areaId;
		}
		
		public String isInPolygon(List<String> pointList,CcmDeviceArea ccmDeviceArea, double lat, double lon) {
			boolean flag = false;
			String areaId = null;
			String areaMap = ccmDeviceArea.getAreaMap();
			if(StringUtils.isNotBlank(areaMap) && areaMap.contains(";")) {//增加判断，pengjianqiang
				String[] point = areaMap.split(";");
				pointList.addAll(Arrays.asList(point));
				double[] latList = new double[pointList.size()];
				double[] lonList = new double[pointList.size()];
				for(int i = 0; i < pointList.size(); i++) {
					if (pointList.get(i).contains(",")) {//增加判断，pengjianqiang
						String[] pointInfo = pointList.get(i).split(",");
						latList[i] = Double.valueOf(pointInfo[0]);
						lonList[i] = Double.valueOf(pointInfo[1]);
					}
				}
				flag = Tool.isInPolygon(lon, lat, lonList, latList);
				if(flag) {
					areaId = ccmDeviceArea.getId();
				}
			}
			return areaId;
		}
	}
}
