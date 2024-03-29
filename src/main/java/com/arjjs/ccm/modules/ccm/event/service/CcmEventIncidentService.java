/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.event.service;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmUploadLog;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmUploadLogService;
import com.arjjs.ccm.modules.ccm.event.dao.CcmEventCasedealDao;
import com.arjjs.ccm.modules.ccm.event.dao.CcmEventIncidentDao;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventCasedeal;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.org.entity.SysArea;
import com.arjjs.ccm.modules.ccm.org.service.SysAreaService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmAreaPoint;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.sys.entity.CcmAreaPointVo;
import com.arjjs.ccm.modules.ccm.sys.entity.SysConfig;
import com.arjjs.ccm.modules.ccm.sys.service.SysConfigService;
import com.arjjs.ccm.modules.dma.eventheme.entity.CountAreaEventByReportTypeVo;
import com.arjjs.ccm.modules.dma.eventheme.entity.CountEventByReportTypeVo;
import com.arjjs.ccm.modules.dma.eventheme.entity.EventIncidentVo;
import com.arjjs.ccm.modules.flat.alarm.dao.BphAlarmInfoDao;
import com.arjjs.ccm.modules.sys.dao.OfficeDao;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.EchartForce;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SysConfigInit;
import com.arjjs.ccm.tool.geoJson.Features;
import com.arjjs.ccm.tool.geoJson.GeoJSON;
import com.arjjs.ccm.tool.geoJson.Geometry;
import com.arjjs.ccm.tool.geoJson.Properties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 案事件登记Service
 * 
 * @author arj
 * @version 2018-01-10
 */
@Service
@Transactional(readOnly = true)
public class CcmEventIncidentService extends CrudService<CcmEventIncidentDao, CcmEventIncident> {

	public static final String[] EVENT_REPORT_TYPE = new String[]{"手动录入", "APP录入", "短信录入", "热线录入", "网站录入", "机顶盒录入"};

	@Autowired
	private SysAreaService sysAreaService;
	@Autowired
	private CcmEventCasedealDao casedealDao;
	@Autowired
	private CcmEventIncidentDao ccmEventIncidentDao;
	@Autowired
	private BphAlarmInfoDao bphAlarmInfoDao;
	//上传上级平台记录
	@Autowired
	private CcmUploadLogService ccmUploadLogService;
	@Autowired
	private SysConfigService sysConfigService;
	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;
	@Autowired
	private OfficeDao officeDao;

	public CcmEventIncident get(String id) {
		return super.get(id);
	}

	public List<CcmEventIncident> findList(CcmEventIncident ccmEventIncident) {
		return super.findList(ccmEventIncident);
	}

	/**
	 * @param id 案事件登记ID
	 * @return 事件处理结果集
	 */
	public List<CcmEventCasedeal> findList(String id) {
		//时间编辑时不显示事件说明
		//List<CcmEventCasedeal> list = casedealDao.listWithPID(id);
		List<CcmEventCasedeal> list1 = casedealDao.findLogTailByRelevanceId(id);
//		list.addAll(list1);
//		//集合内的数量大于1才进行排序
//		if(list.size()>1) {
//			for (int i=0; i<list.size() ; i++) {
//				for(int j=0; j<list.size()-i-1; j++) {
//					if(list.get(j).getCreateDate().after(list.get(j+1).getCreateDate())) {
//						CcmEventCasedeal ccmEventCasedeal = list.get(j+1);
//						list.set((j+1), list.get(j));
//						list.set(j, ccmEventCasedeal);
//					}
//				}
//			}
//		}
		return list1;
	}

	/**
	 * @return 师生案事件列表
	 */
	public Page<CcmEventIncident> findPageStudent(Page<CcmEventIncident> page, CcmEventIncident ccmEventIncident) {
		ccmEventIncident.setPage(page);
		page.setList(ccmEventIncidentDao.findPageStudent(ccmEventIncident));
		return page;
	}

	/**
	 * @return 命案列表
	 */
	public Page<CcmEventIncident> findPageMurder(Page<CcmEventIncident> page, CcmEventIncident ccmEventIncident) {
		ccmEventIncident.setPage(page);
		page.setList(ccmEventIncidentDao.findPageMurder(ccmEventIncident));
		return page;
	}

	/**
	 * @return 线路事件结果集
	 */
	public Page<CcmEventIncident> findPageLine(Page<CcmEventIncident> page, CcmEventIncident ccmEventIncident) {
		ccmEventIncident.setPage(page);
		page.setList(ccmEventIncidentDao.findPageLine(ccmEventIncident));
		return page;
	}
	// public Page<CcmEventIncident> findPageLine(Page<CcmEventIncident> page,
	// CcmEventIncident ccmEventIncident) {
	// return ccmEventIncidentDao.findPageLine(page, ccmEventIncident);
	// }

	public Page<CcmEventIncident> findPage(Page<CcmEventIncident> page, CcmEventIncident ccmEventIncident) {
		return super.findPage(page, ccmEventIncident);
	}
	
	public List<CcmEventIncident> getIncidents(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getIncidents(ccmEventIncident);
	}
	
	public List<String> getIncidentPlace(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getIncidentPlace(ccmEventIncident);
	}
	@Transactional(readOnly = false)
	public void deleteIncidentPlace(CcmEventIncident ccmEventIncident) {
		ccmEventIncidentDao.deleteIncidentPlace(ccmEventIncident);
	}
	@Transactional(readOnly = false)
	public void saveIncidentPlace(CcmEventIncident ccmEventIncident) {
		ccmEventIncidentDao.saveIncidentPlace(ccmEventIncident);
	}

	@Transactional(readOnly = false)
	public void save(CcmEventIncident ccmEventIncident,User user) {
		boolean isNew = false;
		if (ccmEventIncident.getId() == null || "".equals(ccmEventIncident.getId())) {//无主键ID，则是新记录
			isNew = true;
			String id = UUID.randomUUID().toString();
			ccmEventIncident.setId(id);
			ccmEventIncident.setCreateBy(user);
			ccmEventIncident.setCreateDate(new Date());
			ccmEventIncident.setUpdateBy(user);
			ccmEventIncident.setUpdateDate(new Date());
			ccmEventIncident.setDelFlag("0");
			ccmEventIncident.setStick("0");
			ccmEventIncidentDao.insert(ccmEventIncident);
//			BphAlarmInfo bphAlarmInfo = new BphAlarmInfo();
//			//接警单编号生成规则 年月日时分秒
//			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
//			bphAlarmInfo.setOtherNum(sdf.format(new Date()));
//			if("1".equalsIgnoreCase(ccmEventIncident.getWhatType())) {
//				if(StringUtils.isNotEmpty(ccmEventIncident.getAlarmPeopleName())) {
//					bphAlarmInfo.setManName(ccmEventIncident.getAlarmPeopleName());
//				}else {
//					bphAlarmInfo.setManName("匿名");
//				}
//				if(StringUtils.isNotEmpty(ccmEventIncident.getAlarmPeopleTel())) {
//					bphAlarmInfo.setManTel(ccmEventIncident.getAlarmPeopleTel());
//				}else {
//					bphAlarmInfo.setManTel("");
//				}
//			}else {
//				if(StringUtils.isNotEmpty(ccmEventIncident.getReportPerson())) {
//					bphAlarmInfo.setManName(ccmEventIncident.getReportPerson());
//				}else {
//					bphAlarmInfo.setManName("匿名");
//				}
//				if(StringUtils.isNotEmpty(ccmEventIncident.getReportPersonPhone())) {
//					bphAlarmInfo.setManTel(ccmEventIncident.getReportPersonPhone());
//				}else {
//					bphAlarmInfo.setManTel("");
//				}
//			}
//			bphAlarmInfo.setId(id);
//			bphAlarmInfo.setPlace(ccmEventIncident.getHappenPlace());
//			bphAlarmInfo.setContent(ccmEventIncident.getCaseName());
//			bphAlarmInfo.setTypeCode(ccmEventIncident.getProperty());
//			bphAlarmInfo.setState("0");
//			bphAlarmInfo.setAlarmTime(new Date());
//			bphAlarmInfo.setIsImportant("0");
//			bphAlarmInfo.setCreateBy(new User("1"));
//			bphAlarmInfo.setCreateDate(new Date());
//			bphAlarmInfo.setUpdateBy(new User("1"));
//			bphAlarmInfo.setUpdateDate(new Date());
//			bphAlarmInfo.setDelFlag("0");
//			if(ccmEventIncident.getAreaPoint()!=null && !ccmEventIncident.getAreaPoint().equals("")){
//				bphAlarmInfo.setX(Double.parseDouble(ccmEventIncident.getAreaPoint().split(",")[0]));
//				bphAlarmInfo.setY(Double.parseDouble(ccmEventIncident.getAreaPoint().split(",")[1]));
//			}
//			bphAlarmInfoDao.insert(bphAlarmInfo);
		} else {
			super.save(ccmEventIncident);
		}
		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			if (isNew) {//新增数据
				uploadLog.setOperateType("1");
				uploadLog.setRemarks("新增案事件数据：" + ccmEventIncident.getCaseName());
			} else {//编辑数据
				uploadLog.setOperateType("2");
				uploadLog.setRemarks("编辑案事件数据：" + ccmEventIncident.getCaseName());
			}
			uploadLog.setTableName("ccm_event_incident");
			uploadLog.setDataId(ccmEventIncident.getId());
			uploadLog.setUploadStatus("1");
//			User user = UserUtils.getUser();
//			if (user == null || StringUtils.isBlank(user.getId())) {
			uploadLog.setCreateBy(user);
			uploadLog.setUpdateBy(user);
//			}
			ccmUploadLogService.save(uploadLog);
		}
	}

	@Transactional(readOnly = false)
	public void delete(CcmEventIncident ccmEventIncident) {
		super.delete(ccmEventIncident);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			uploadLog.setOperateType("3");
			uploadLog.setRemarks("删除案事件数据：" + ccmEventIncident.getCaseName());
			uploadLog.setTableName("ccm_event_incident");
			uploadLog.setDataId(ccmEventIncident.getId());
			uploadLog.setUploadStatus("1");
			User user = UserUtils.getUser();
			if (user == null || StringUtils.isBlank(user.getId())) {
				uploadLog.setCreateBy(new User("1"));
				uploadLog.setUpdateBy(new User("1"));
			}
			ccmUploadLogService.save(uploadLog);
		}
	}

	@Transactional(readOnly = false)
	public int incident(CcmEventIncident ccmEventIncident) {
		if (null == ccmEventIncident.getUpdateBy()) {
            ccmEventIncident.setUpdateBy(UserUtils.getUser());
		}
		ccmEventIncident.setUpdateDate(new Date());
		return dao.incident(ccmEventIncident);
	}

	/**
	 * @return
	 * @see /根据案事件性质统计情况。
	 */
	public List<EchartType> getItemByProperty() {
		List<EchartType> list = ccmEventIncidentDao.getItemByProperty();
		List<EchartType> result = new ArrayList<EchartType>(); 
		int otherNum = 0;
		for (EchartType echartType : list) {
			if(StringUtils.isEmpty(echartType.getType())) {
				otherNum = otherNum+Integer.parseInt(echartType.getValue());
				continue;
			}
			result.add(echartType);
		}
		int temp = 20;
		for(int i = 0;i<result.size();i++) {
			if("其它报警类别".equals(result.get(i).getType())) {
				temp = i;
			}
		}
		if(temp == 20) {
			EchartType echart = new EchartType();
			echart.setType("其它报警类别");
			echart.setValue(otherNum+"");
			result.add(echart);
		}else {
			result.get(temp).setValue((Integer.parseInt(result.get(temp).getValue())+otherNum)+"");
		}
		return result;
	}

	/**
	 * @return
	 * @see /根据案事件性质统计校园周边情况
	 */
	public List<EchartType> getItemByPropertyec() {
		return ccmEventIncidentDao.getItemByPropertyec();
	}

	/**
	 * @return
	 * @see /根据案事件分级统计情况
	 */
	public Map<String, Object> getItemByScale() {
		List<EchartType> list = ccmEventIncidentDao.getItemByScale();
		List<EchartType> result = new ArrayList<EchartType>(); 
		int i=0;
		for (EchartType echartType : list) {
			if(StringUtils.isEmpty(echartType.getType())) {
				i = i+Integer.parseInt(echartType.getValue());
			}else {
				result.add(echartType);
			}
		}
		EchartType echartType = new EchartType();
		echartType.setType("其他");
		echartType.setValue(i+"");
		result.add(echartType);
		String[] name = new String[result.size()];
		for (int j = 0; j<result.size(); j++) {
			name[j] = result.get(j).getType();
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", name);
		map.put("result", result);
		return map;
	}

	/**
	 * @param ccmEventIncident 案事件实体
	 * @return
	 * @see /查询出所有的 案事件根据地区以及分级数量
	 */
	public List<EchartType> getItemByScaleTable(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getItemByScaleTable(ccmEventIncident);
	}

	/**
	 * @return
	 * @see /案事件统计 是否解决
	 */
	public List<EchartType> getItemBySum() {
		return ccmEventIncidentDao.getItemBySum();
	}

	/**
	 * @return
	 * @see /前10的地区破案率
	 */
	public List<EchartType> findSolveByArea() {
		return ccmEventIncidentDao.findSolveByArea();
	}

	/**
	 * @return
	 * @see /按月统计的案事件数
	 */
	public List<EchartType> findSumByMon(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.findSumByMon(ccmEventIncident);
	}

	/**
	 * @return
	 * @see /按月统计的处理率
	 */
	public List<EchartType> findSolveByMon() {
		return ccmEventIncidentDao.findSolveByMon();
	}

	/**
	 * @return
	 * @see /最新案事件
	 */
	public List<SearchTab> findSumByCondition() {
		return ccmEventIncidentDao.findSumByCondition();
	}

	/**
	 * @return
	 * @see /案事件类型统计
	 */
	public List<EchartType> findSumByEventType() {
		List<EchartType> list = ccmEventIncidentDao.findSumByEventType();
		List<EchartType> result = new ArrayList<EchartType>();
		int num = 0;
		for (EchartType echartType : list) {
			if(StringUtils.isNotEmpty(echartType.getType())) {
				result.add(echartType);
			}else {
				num = num+Integer.parseInt(echartType.getValue());
			}
		}
		for (EchartType echartType : result) {
			if("05".equals(echartType.getTypeO())) {
				num = num+Integer.parseInt(echartType.getValue());
				echartType.setValue(""+num);
			}
		}
		return result;
	}

	// 获取一周内的数量
	public List<EchartType> findSumByEventWeek() {
		return ccmEventIncidentDao.findSumByEventWeek();
	}

	//今日案事件统计
	public List<EchartType> getItemBySumToday() {
		return ccmEventIncidentDao.getItemBySumToday();
	}

	//今日前10条案事件
	public List<CcmEventIncident> getListToday() {
		return ccmEventIncidentDao.getListToday();
	}

	//安全事故分布
	public List<EchartType> getSafeDisData(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getSafeDisData(ccmEventIncident);
	}

	//事故类型
	public List<EchartType> getSafeTypeData(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getSafeTypeData(ccmEventIncident);
	}

	//事故级别
	public List<EchartType> getSafeLevelData(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getSafeLevelData(ccmEventIncident);
	}
	
	//安全生产事故类型
	public List<EchartType> getSafeAnalysisType(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getSafeAnalysisType(ccmEventIncident);
	}

	//安全生产事故级别
	public List<EchartType> getSafeAnalysisLevel(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getSafeAnalysisLevel(ccmEventIncident);
	}

	//事件分类
	public List<EchartType> findEventFenLeiData() {
		return ccmEventIncidentDao.findEventFenLeiData();
	}
	
	//事件规模统计
	public List<EchartType> findEventGuiMoData() {
		//查询各规模事件数量
		List<EchartType> list = ccmEventIncidentDao.findEventGuiMoData();
		//查询事件总数
		EchartType echart = ccmEventIncidentDao.findAllEventNum();
		//判断查询的总数是否为空，为空的话赋值为其他类型的和
		if(StringUtils.isNotEmpty(echart.getValue())) {
			echart.setType("累计受理纠纷");
		}else {
			int num = 0;
			for(int i=0;i<list.size();i++) {
				num = num + Integer.parseInt(list.get(i).getValue());
			}
			echart.setValue(String.valueOf(num));
			echart.setType("累计受理纠纷");
		}
		list.add(echart);
		return list;
	}

	//事件查询Line
	public CcmEventIncident getLine(String id) {
		return ccmEventIncidentDao.getLine(id);
	}

	//本月事件发生前十
	public List<EchartType> findEventMonthMap() {
		return ccmEventIncidentDao.findEventMonthMap();
	}

	//近一年事件发生/重点人员帮扶趋势图
	public List<SearchTab> findEventYearMap() {
		return ccmEventIncidentDao.findEventYearMap();
	}


	public GeoJSON queryAlarmInfoByDateAndAlarmType(CcmEventIncident ccmEventIncident) {
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		List<Features> featureList = new ArrayList<Features>();
		String[] typeCode = ccmEventIncident.getEventKind().split(",");
		ccmEventIncident.setEventKindParents(typeCode);
		List<CcmEventIncident> list = this.dao.queryAlarmInfoByDateAndAlarmType(ccmEventIncident);
		for (CcmEventIncident bean : list) {
			// 特征属性
			Features featureDto = new Features();
			Properties properties = new Properties();
			// 1 type 默认不填
			// 2 id 添加
			featureDto.setId(bean.getId());
			// 3 properties 展示属性信息
			properties.setName(bean.getCaseName());
			// 创建附属信息
			featureList.add(featureDto);
			featureDto.setProperties(properties);
			// 4 geometry 配置参数
			Geometry geometry = new Geometry();
			featureDto.setGeometry(geometry);
			// 点位信息 测试为面
			geometry.setType("Point");
			if (null != bean.getAreaPoint() && !"".equals(bean.getAreaPoint())) {
				String area_point = String.valueOf(bean.getAreaPoint());
				if (area_point.contains(",")) {
					String x = area_point.split(",")[0];
					String y = area_point.split(",")[1];
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
		}
		geoJSON.setFeatures(featureList);
		// 如果无数据
		if (featureList.size() == 0) {
			return null;
		}
		return geoJSON;
	}

	public GeoJSON queryAlarmInfoByDateAndAlarmTypeToFourColor(CcmEventIncident ccmEventIncident) {
		// 返回对象
		GeoJSON geoJSON = new GeoJSON();
		List<Features> featureList = new ArrayList<Features>();
		String[] typeCode = ccmEventIncident.getEventKind().split(",");
		ccmEventIncident.setEventKindParents(typeCode);
		List<CcmEventIncident> list = this.dao.queryAlarmInfoByDateAndAlarmTypeToFourColor(ccmEventIncident);
		for (CcmEventIncident bean : list) {
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
			map.put("事件数量", bean.getNum());
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
					String[] a = {"", ""};
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

	public List<EchartType> getHomicideByArea(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getHomicideByArea(ccmEventIncident);
	}

	/**
	 * // 统计某一段时间内各上报类型 中案件 的数量
	 *
	 * @param beginHappenDate
	 * @param endHappenDate
	 * @return
	 */
	public List<CountEventByReportTypeVo> countEventPreviewByReportType(String beginHappenDate, String endHappenDate) {
		List<CountEventByReportTypeVo> countEventByReportTypeVos = dao.countEventPreviewByReportType(beginHappenDate, endHappenDate);

//		List<CountEventByReportTypeVo> resultInfo = dao.countEventByReportType(beginHappenDate, endHappenDate);
		//List<CountEventByReportTypeVo> resultNull = new ArrayList<>();
		if (countEventByReportTypeVos.size() == 0) {
			List<String> eventReportTypeList = Arrays.asList(EVENT_REPORT_TYPE);
			for (String reportType : eventReportTypeList) {
				CountEventByReportTypeVo eventInfo = new CountEventByReportTypeVo();
				eventInfo.setName(reportType);
				eventInfo.setValue("0");
				countEventByReportTypeVos.add(eventInfo);
			}
		}
		return countEventByReportTypeVos;
	}

	/**
	 * (事件实际发生数量统计) 统计某一段时间内各类型事件的数量
	 *
	 * @param beginHappenDate
	 * @param endHappenDate
	 * @return
	 */
	public List<CountEventByReportTypeVo> countEventByReportType(String beginHappenDate, String endHappenDate) {
		List<CountEventByReportTypeVo> resultInfo = dao.countEventByReportType(beginHappenDate, endHappenDate);
		//List<CountEventByReportTypeVo> resultNull = new ArrayList<>();
		if (resultInfo.size() == 0) {
			List<String> eventReportTypeList = Arrays.asList(EVENT_REPORT_TYPE);
			for (String reportType : eventReportTypeList) {
				CountEventByReportTypeVo eventInfo = new CountEventByReportTypeVo();
				eventInfo.setName(reportType);
				eventInfo.setValue("0");
				resultInfo.add(eventInfo);
			}
		}
		return resultInfo;
	}

	public Map<String, Object> countAreaEventByReportType(String beginHappenDate, String endHappenDate) {
		//封装返回结果
		Map<String, Object> resultMap = new HashMap<>();
		//List<CountAreaEventResult> areaEventResultList = new ArrayList<>();
		List<CountAreaEventByReportTypeVo> resultEventInfo = new ArrayList<>();
		//上报社区汇总封装
		List<String> typeName = new ArrayList<>();
		Set<String> areaName = new HashSet<>();

		//查询所有案件
		List<EventIncidentVo> eventIncidentList = dao.queryAll(beginHappenDate, endHappenDate);
		//构造新的含有社区ID的集合 （用来进行分组）
		List<EventIncidentVo> eventAreaIncidentList = new ArrayList<>();
		for (EventIncidentVo eventIncident : eventIncidentList) {
			CountAreaEventByReportTypeVo areaEventByReportTypeVo = new CountAreaEventByReportTypeVo();
			//根据网格找社区
			String casePlace = eventIncident.getCasePlace();
			SysArea sysArea = sysAreaService.get(casePlace);
			//获取网格所在社区
			List<String> areaStr = Arrays.asList(sysArea.getParentIds().split(","));
			SysArea sysAreaName = sysAreaService.get(areaStr.get(areaStr.size() - 2));
			if (sysAreaName == null) {
				continue;
			}
			eventIncident.setCaseAreaPlace(sysAreaName.getName());//社区名称
			eventAreaIncidentList.add(eventIncident);
		}
		// 数据为空的封装
		if (eventAreaIncidentList.size() == 0) {

			List<String> eventReportTypeList = Arrays.asList(EVENT_REPORT_TYPE);
			for (String reportType : eventReportTypeList) {
				CountAreaEventByReportTypeVo paddEventAreaInfo = new CountAreaEventByReportTypeVo();
				paddEventAreaInfo.setName(reportType);
				paddEventAreaInfo.setData(Arrays.asList("0"));
				paddEventAreaInfo.setType("bar");// 此处为固定的，
				resultEventInfo.add(paddEventAreaInfo);
			}
			resultMap.put("eventAreaData", resultEventInfo);

			resultMap.put("eventAreaNameData", Arrays.asList("中国"));
			resultMap.put("eventAreaTypeData", eventReportTypeList);
			return resultMap;
		}
		//上报类型分组 -各组数据统计
		Map<String, List<EventIncidentVo>> eventAreaIncidentMap =
				eventAreaIncidentList.stream().collect(Collectors.groupingBy(EventIncidentVo::getReportType));

//		System.out.println("上报类型分组" + JSON.toJSONString(eventAreaIncidentMap));


		//区域分组结果
		for (Map.Entry<String, List<EventIncidentVo>> entry : eventAreaIncidentMap.entrySet()) {

			Map<String, List<EventIncidentVo>> eventAreaReportyIncidentMap =
					entry.getValue().stream().collect(Collectors.groupingBy(EventIncidentVo::getCaseAreaPlace));

			CountAreaEventByReportTypeVo areaEventByReportTypeVo = new CountAreaEventByReportTypeVo();

			areaEventByReportTypeVo.setName(entry.getKey());

			typeName.add(entry.getKey());
			List<String> eventAreaCount = new ArrayList<>();

			//社区上报类型数量统计
			for (Map.Entry<String, List<EventIncidentVo>> reportTypeEntity : eventAreaReportyIncidentMap.entrySet()) {
				areaName.add(reportTypeEntity.getKey());
				eventAreaCount.add(reportTypeEntity.getValue().size() + "");
			}
			areaEventByReportTypeVo.setData(eventAreaCount);
			areaEventByReportTypeVo.setType("bar");// 此处为固定的，
			resultEventInfo.add(areaEventByReportTypeVo);

		}
		resultMap.put("eventAreaData", resultEventInfo);
		resultMap.put("eventAreaNameData", areaName);
		resultMap.put("eventAreaTypeData", typeName);
		return resultMap;
	}

	private Map<String, List<EventIncidentVo>> sortMapByValue(Map<String, List<EventIncidentVo>> oriMap) {
		Map<String, List<EventIncidentVo>> sortedMap = new LinkedHashMap<String, List<EventIncidentVo>>();
		if (oriMap != null && !oriMap.isEmpty()) {
			List<Map.Entry<String, List<EventIncidentVo>>> entryList = new ArrayList<Map.Entry<String, List<EventIncidentVo>>>(oriMap.entrySet());
			Collections.sort(entryList, new Comparator<Map.Entry<String, List<EventIncidentVo>>>() {
				public int compare(Map.Entry<String, List<EventIncidentVo>> entry1, Map.Entry<String, List<EventIncidentVo>> entry2) {
					//   String value1 = ""; String value2 = "";
					String value1 = entry1.getValue().get(0).getReportType();
					String value2 = entry2.getValue().get(0).getReportType();
					int res = value2.compareTo(value1);
					return res;
				}
			});
			Iterator<Map.Entry<String, List<EventIncidentVo>>> iter = entryList.iterator();
			Map.Entry<String, List<EventIncidentVo>> tmpEntry = null;
			while (iter.hasNext()) {
				tmpEntry = iter.next();
				sortedMap.put(tmpEntry.getKey(), tmpEntry.getValue());
			}
		}
		return sortedMap;
	}


	public EchartForce getEventForForce(CcmEventIncident ccmEventIncident) {
		return ccmEventIncidentDao.getEventForForce(ccmEventIncident);
	}

	//查询事件数量  12个月
	public List<EchartType> getcountevent(String num) {
		return ccmEventIncidentDao.getcountevent(num);
	}



	public void specialPersonEvent(CcmPeople ccmPeople) {
		SysConfig sysConfig = sysConfigService.get(SysConfig.SPECIAL_PERSONNEL_EVENT_ID);
		if (sysConfig.getParamInt() == 1) {
			//将信息存入事件
			CcmEventIncident ccmEventIncident = new CcmEventIncident();
			ccmEventIncident.setStatus("01");
			ccmEventIncident.setReportType("0");
			ccmEventIncident.setCaseName("新增重点人员-" + ccmPeople.getName() + "，请关注！");
			ccmEventIncident.setHappenDate(new Date());
			ccmEventIncident.setHappenPlace(ccmPeople.getResidencedetail());
			Area area = new Area();
			area.setId(ccmPeople.getAreaGridId().getId());
			ccmEventIncident.setArea(area);
			ccmEventIncident.setEventKind("09");//事件模块分类：其他
			ccmEventIncident.setEventSort("99");//事件类别：其他
			ccmEventIncident.setEventScale("04");//事件分级：一般
			ccmEventIncident.setProperty("99");//事件性质：其他报警类别
			ccmEventIncident.setEventType("05");//事件类型：其他
			this.save(ccmEventIncident);
			SysArea sysArea = sysAreaService.get(ccmPeople.getAreaGridId().getId());
			List<String> parentIds = Arrays.asList(sysArea.getParentIds().split(","));
			List<User> assignUsers = ccmEventCasedealService.findAssignUser(ccmPeople.getAreaGridId().getId(),parentIds);
			for (int i = 0; i < assignUsers.size(); i++) {
				CcmEventCasedeal ccmEventCasedeal = new CcmEventCasedeal();
				ccmEventCasedeal.setHandleUser(assignUsers.get(i));
				ccmEventCasedeal.setObjType("ccm_event_incident");
				ccmEventCasedeal.setObjId(ccmEventIncident.getId());
				ccmEventCasedeal.setHandleDeadline(new Date());
				ccmEventCasedeal.setIsSupervise("0");
				ccmEventCasedeal.setHandleStatus("01");
				ccmEventCasedeal.setCheckScore(0);
				ccmEventCasedeal.setGradeNum(0);
				ccmEventCasedealService.save(ccmEventCasedeal);
			}
		}
	}


	public List<Office> findOfficeList() {
		List<Office> eventOfficeList = (List)UserUtils.getCache("eventOfficeList");

		if (eventOfficeList == null) {
			User user = UserUtils.getUser();
			if (user.isAdmin()) {
				eventOfficeList = officeDao.findAllList(new Office());
			} else {
				eventOfficeList = ccmEventIncidentDao.findOfficeList(user);
			}

			UserUtils.putCache("eventOfficeList", eventOfficeList);
		}

		return eventOfficeList;
	}


    public List<CcmAreaPoint> selectByAreaGIdAndName(CcmAreaPointVo areaPointVo) {
		return dao.selectByAreaIdAndName(areaPointVo);
    }

	public Page<CcmEventIncident> findDispatchPage(Page<CcmEventIncident> page, CcmEventIncident ccmEventIncident) {
		ccmEventIncident.setPage(page);
		page.setList(this.dao.findDispatch(ccmEventIncident));
		return page;
	}
	public Page<CcmEventIncident> findArchivePage(Page<CcmEventIncident> page, CcmEventIncident ccmEventIncident) {
		ccmEventIncident.setPage(page);
		page.setList(this.dao.findArchive(ccmEventIncident));
		return page;
	}

	/**
	 * @param id 案事件登记ID
	 * @return 事件处理结果集
	 */
	public List<CcmLogTail> findEventProcessLogTail(String id) {
//		List<CcmEventCasedeal> list = casedealDao.listWithPID(id);
		List<CcmLogTail> list1 = casedealDao.findEventProcessLogTail(id);
//		list.addAll(list1);
		return list1;
	}
}