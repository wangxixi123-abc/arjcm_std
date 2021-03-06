/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.report.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.excel.ExportExcel;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDevice;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmDeviceService;
import com.arjjs.ccm.modules.ccm.citycomponents.entity.CcmCityComponents;
import com.arjjs.ccm.modules.ccm.citycomponents.service.CcmCityComponentsService;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseSchoolrim;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseBuildmanageService;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseSchoolrimService;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgArea;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgCommonality;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgNpse;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgAreaService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgComPopService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgCommonalityService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgNpseService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenant;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPopTenantService;
import com.arjjs.ccm.modules.ccm.report.entity.CcmPeopleAmount;
import com.arjjs.ccm.modules.ccm.report.service.CcmPeopleAmountService;
import com.arjjs.ccm.modules.ccm.sys.entity.CcmWorkReportCount;
import com.arjjs.ccm.modules.ccm.sys.service.CcmWorkReportService;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiScheme;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiSchemeKpi;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeKpiService;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeService;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.AreaService;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SearchTabMore;
import com.google.common.collect.Maps;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 案事件统计Controller
 * 
 * @author arj
 * @version 2018-01-20
 */
@Controller
@RequestMapping(value = "${adminPath}/report/ccmReportOthers")
public class CcmReportOthersController extends BaseController {

	
	@Autowired
	private CcmPopTenantService ccmPopTenantService;
	@Autowired
	private CcmOrgNpseService ccmOrgNpseService;
	@Autowired
	private CcmWorkReportService ccmWorkReportService;
	@Autowired
	private CcmOrgComPopService ccmOrgComPopService;
	@Autowired
	private CcmOrgCommonalityService ccmOrgCommonalityService;
	@Autowired
	private CcmOrgAreaService ccmOrgAreaService;
	@Autowired
	private CcmDeviceService ccmDeviceService;
	@Autowired
	private CcmCityComponentsService ccmCityComponentsService;
	@Autowired
	private AreaService areaService;
	@Autowired
	private CcmHouseBuildmanageService ccmHouseBuildmanageService;
	@Autowired
	private CcmHouseSchoolrimService ccmHouseSchoolrimService;
	@Autowired
	private CcmPeopleAmountService ccmPeopleAmountService;
	@Autowired
	private KpiSchemeService kpiSchemeService;
	@Autowired
	private KpiSchemeKpiService kpiSchemeKpiService;
	
	
	
	//报表:楼栋房屋
	@RequiresPermissions("report:ccmReportOthers:view")
	@RequestMapping(value ="houseAndBuild")
	public String houseAndBuild(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "ccm/report/reportHouseAndBuild";
	}
	//报表:楼栋房屋getJSON
	@ResponseBody
	@RequestMapping(value = "getHouseAndBuild")
	public List<SearchTabMore> getHouseAndBuild(Model model) {
		SearchTabMore searchTabMore = new SearchTabMore();
		searchTabMore.setValue5("all");
		searchTabMore.setValue8("all");
		List<SearchTabMore> list = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋
		searchTabMore.setValue5("01");
		searchTabMore.setValue8("all");
		List<SearchTabMore> list5 = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋状态01自住
		searchTabMore.setValue5("02");
		searchTabMore.setValue8("all");
		List<SearchTabMore> list6 = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋状态02出租
		searchTabMore.setValue5("03");
		searchTabMore.setValue8("all");
		List<SearchTabMore> list7 = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋状态03空置
		
		for(SearchTabMore se:list){
			se.setValue5("0");se.setValue6("0");se.setValue7("0");
			for(SearchTabMore se5:list5){
				if(se.getType().equals(se5.getType())){
					se.setValue5(se5.getValue4());//添加自住数据
				}
			}
			for(SearchTabMore se6:list6){
				if(se.getType().equals(se6.getType())){
					se.setValue6(se6.getValue4());//添加出租数据
				}
			}
			for(SearchTabMore se7:list7){
				if(se.getType().equals(se7.getType())){
					se.setValue7(se7.getValue4());//添加空置数据
				}
			}
		}
		
		return list;
	}
	//报表:房屋安全隐患统计
	@ResponseBody
	@RequestMapping(value = "getHouseHazard")
	public String getHouseHazard(Model model) {
		List<EchartType> list = ccmPopTenantService.getHouseHazard();
		
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{"type"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listHazard = JSONArray.fromObject(list,config).toString(); //Json
		
		return listHazard;
	}
	
	//报表:非公有经济组织
	@RequiresPermissions("report:ccmReportOthers:view")
	@RequestMapping(value ="organization")
	public String organization(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "ccm/report/reportOrganization";
	}
	//报表:非公有经济组织getJSONList
	@ResponseBody
	@RequestMapping(value = "getOrganizationList")
	public SearchTabMore getOrganizationList(Model model) {
		SearchTabMore searchTabMore =  ccmOrgNpseService.findNumStatistics();//报表:非公有经济组织数量
		return searchTabMore;
	}
	//报表:非公有经济组织getJSON-findCompType/findCompImpoType
	@ResponseBody
	@RequestMapping(value = "findCompTypeAndCompImpoType")
	public List<Object> findCompTypeAndCompImpoType(Model model) {
		List<Object> listAll = new ArrayList<>();
		
		List<EchartType> listCompType = ccmOrgNpseService.findCompType(); //报表:非公有经济组织类别
		List<EchartType> listCompImpoType = ccmOrgNpseService.findCompImpoType(); //报表:非公有经济组织重点类型
		EchartType newEchartType = new EchartType();//非空判断
		newEchartType.setType("暂无数据");
		newEchartType.setValue("0");
		if(listCompType.size()==0){
			listCompType.add(newEchartType);
		}
		if(listCompImpoType.size()==0){
			listCompImpoType.add(newEchartType);
		}
		
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{"typeO"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listCompTypeString = JSONArray.fromObject(listCompType,config).toString(); //Json报表:非公有经济组织类别
		String listCompImpoTypeString = JSONArray.fromObject(listCompImpoType,config).toString(); //Json报表:非公有经济组织重点类型

		listAll.add(listCompTypeString);
		listAll.add(listCompImpoTypeString);
		return listAll;
	}
	//报表:非公有经济组织getJSON-findHoldCase/findSafeHazaType
	@ResponseBody
	@RequestMapping(value = "findHoldCaseAndSafeHazaType")
	public List<Object> findHoldCaseAndSafeHazaType(Model model) {
		List<Object> listAll = new ArrayList<>();
		
		List<EchartType> listHoldCase = ccmOrgNpseService.findHoldCase(); //报表:非公有经济组织控股情况
		List<EchartType> listSafeHazaType = ccmOrgNpseService.findSafeHazaType(); //报表:非公有经济组织安全隐患类型
		
		EchartType newEchartType = new EchartType();//非空判断
		newEchartType.setType("暂无数据");
		newEchartType.setValue("0");
		if(listHoldCase.size()==0){
			listHoldCase.add(newEchartType);
		}
		if(listSafeHazaType.size()==0){
			listSafeHazaType.add(newEchartType);
		}
		
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{"typeO"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listHoldCaseString = JSONArray.fromObject(listHoldCase,config).toString(); //Json报表:非公有经济组织控股情况
		String listSafeHazaTypeString = JSONArray.fromObject(listSafeHazaType,config).toString(); //Json报表:非公有经济组织安全隐患类型

		listAll.add(listHoldCaseString);
		listAll.add(listSafeHazaTypeString);

		return listAll;
	}
	//报表:非公有经济组织getJSON-findDangComp/findConcExte
	@ResponseBody
	@RequestMapping(value = "findDangCompAndConcExte")
	public List<Object> findDangCompAndConcExte(Model model) {
		List<Object> listAll = new ArrayList<>();
		
		List<EchartType> listDangComp = ccmOrgNpseService.findDangComp(); //报表:非公有经济组织是否危化企业
		List<EchartType> listConcExte = ccmOrgNpseService.findConcExte(); //报表:非公有经济组织关注程度
		
		EchartType newEchartType = new EchartType();//非空判断
		newEchartType.setType("暂无数据");
		newEchartType.setValue("0");
		if(listDangComp.size()==0){
			listDangComp.add(newEchartType);
		}
		if(listConcExte.size()==0){
			listConcExte.add(newEchartType);
		}
		
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{"typeO"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listDangCompString = JSONArray.fromObject(listDangComp,config).toString(); //Json报表:非公有经济组织是否危化企业
		String listConcExteString = JSONArray.fromObject(listConcExte,config).toString(); //Json报表:非公有经济组织关注程度
		
		listAll.add(listDangCompString);
		listAll.add(listConcExteString);

		return listAll;
	}
	
	
	
	//报表:重点场所
	@RequiresPermissions("report:ccmReportOthers:view")
	@RequestMapping(value ="keyPlace")
	public String keyPlace(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "ccm/report/reportKeyPlace";
	}
	
	//报表:报表:重点场所getJSON-findKeyPlace
	@ResponseBody
	@RequestMapping(value = "findKeyPlace")
	public List<Object> findKeyPlace(Model model) {
		List<Object> listAll = new ArrayList<>();
		
		EchartType echartType = new EchartType();
		List<EchartType> listArea = ccmOrgNpseService.findArea(echartType); //报表:重点场所数据区域
		echartType.setValue("all");
		List<EchartType> listKeyPlaceType0 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型
		echartType.setValue("00");
		List<EchartType> listKeyPlaceType1 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型00无
		echartType.setValue("01");
		List<EchartType> listKeyPlaceType2 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型01物流安全
		echartType.setValue("02");
		List<EchartType> listKeyPlaceType3 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型02安全生产重点
		echartType.setValue("03");
		List<EchartType> listKeyPlaceType4 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型03消防重点
		echartType.setValue("04");
		List<EchartType> listKeyPlaceType5 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型04治安重点
		echartType.setValue("05");
		List<EchartType> listKeyPlaceType6 = ccmOrgNpseService.findKeyPlaceType(echartType); //报表:重点场所数据重点类型05其他重点
		List<EchartType> listKeyPlaceType7 = ccmOrgNpseService.findSchool(); //报表:重点场所数据重点类型-学校
		List<EchartType> listSchoolType = ccmOrgNpseService.findSchoolType(); //报表:重点场所数据-学校办学类型统计
		List<SearchTabMore> list = new ArrayList<>();
		for(EchartType li:listArea){
			SearchTabMore searchTabMore = new SearchTabMore();
			searchTabMore.setTypeO(li.getTypeO());
			searchTabMore.setType(li.getType());
			searchTabMore.setValue("0");
			searchTabMore.setValue1("0");
			searchTabMore.setValue2("0");
			searchTabMore.setValue3("0");
			searchTabMore.setValue4("0");
			searchTabMore.setValue5("0");
			searchTabMore.setValue6("0");
			searchTabMore.setValue7("0");
			for(EchartType li0:listKeyPlaceType0){
				if(li.getTypeO().equals(li0.getTypeO())){
					searchTabMore.setValue(li0.getValue());
				}
			}
			for(EchartType li1:listKeyPlaceType1){
				if(li.getTypeO().equals(li1.getTypeO())){
					searchTabMore.setValue1(li1.getValue());
				}
			}
			for(EchartType li2:listKeyPlaceType2){
				if(li.getTypeO().equals(li2.getTypeO())){
					searchTabMore.setValue2(li2.getValue());
				}
			}
			for(EchartType li3:listKeyPlaceType3){
				if(li.getTypeO().equals(li3.getTypeO())){
					searchTabMore.setValue3(li3.getValue());
				}
			}
			for(EchartType li4:listKeyPlaceType4){
				if(li.getTypeO().equals(li4.getTypeO())){
					searchTabMore.setValue4(li4.getValue());
				}
			}
			for(EchartType li5:listKeyPlaceType5){
				if(li.getTypeO().equals(li5.getTypeO())){
					searchTabMore.setValue5(li5.getValue());
				}
			}
			for(EchartType li6:listKeyPlaceType6){
				if(li.getTypeO().equals(li6.getTypeO())){
					searchTabMore.setValue6(li6.getValue());
				}
			}
			for(EchartType li7:listKeyPlaceType7){
				if(li.getTypeO().equals(li7.getTypeO())){
					searchTabMore.setValue7(li7.getValue());
				}
			}
			list.add(searchTabMore);
		}
		
		
		int a=0;//计算总数量
		int b=0;
		int c=0;
		int d=0;
		int e=0;
		int f=0;
		int g=0;
		for(SearchTabMore l:list){
			a+=Integer.parseInt(l.getValue1());
			b+=Integer.parseInt(l.getValue2());
			c+=Integer.parseInt(l.getValue3());
			d+=Integer.parseInt(l.getValue4());
			e+=Integer.parseInt(l.getValue5());
			f+=Integer.parseInt(l.getValue6());
			g+=Integer.parseInt(l.getValue7());
		}
		
		List<EchartType> allListType = new ArrayList<>();
		EchartType allType1 = new EchartType();
		EchartType allType2 = new EchartType();
		EchartType allType3 = new EchartType();
		EchartType allType4 = new EchartType();
		EchartType allType5 = new EchartType();
		EchartType allType6 = new EchartType();
		EchartType allType7 = new EchartType();
		allType1.setType("无");
		allType1.setValue(String.valueOf(a));
		allType2.setType("物流安全");
		allType2.setValue(String.valueOf(b));
		allType3.setType("安全生产重点");
		allType3.setValue(String.valueOf(c));
		allType4.setType("消防重点");
		allType4.setValue(String.valueOf(d));
		allType5.setType("治安重点");
		allType5.setValue(String.valueOf(e));
		allType6.setType("其他重点");
		allType6.setValue(String.valueOf(f));
		allType7.setType("学校");
		allType7.setValue(String.valueOf(g));
		allListType.add(allType7);
		allListType.add(allType1);
		allListType.add(allType2);
		allListType.add(allType3);
		allListType.add(allType4);
		allListType.add(allType5);
		allListType.add(allType6);
		
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{"typeO"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String allListTypeString = JSONArray.fromObject(allListType,config).toString(); //Json报表:重点场所数据重点类型-计算总数量
		String listSchoolTypeString = JSONArray.fromObject(listSchoolType,config).toString(); //Json报表:重点场所数据-学校办学类型统计

		listAll.add(allListTypeString);
		listAll.add(listSchoolTypeString);
		listAll.add(list);

		return listAll;
	}
	
	
	
	//报表:日常工作数据
	@RequiresPermissions("report:ccmReportOthers:view")
	@RequestMapping(value ="logBook")
	public String logBook(CcmWorkReportCount ccmWorkReportCount, HttpServletRequest request, HttpServletResponse response, Model model) {
		Office office = ccmWorkReportCount.getOffice();
		if (ccmWorkReportCount.getBeginDate() == null) {
			Date beginDate = new Date();
			long time = beginDate.getTime() - ((long)30 * (long)86400 * (long)1000) ;
			beginDate.setTime(time);
			ccmWorkReportCount.setBeginDate(beginDate);
		}
		if (ccmWorkReportCount.getEndDate() == null) {
			Date endDate = new Date();
			ccmWorkReportCount.setEndDate(endDate);
		}
		
		List<CcmWorkReportCount> logBookList = ccmWorkReportService.findLogBook(ccmWorkReportCount);
		model.addAttribute("office", office);
		model.addAttribute("ccmWorkReportCount", ccmWorkReportCount);
		model.addAttribute("logBookList", logBookList);
		return "ccm/report/reportLogBook";
	}

	/**
	 * 导出日常工作数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("report:ccmReportOthers:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public void export(CcmWorkReportCount ccmWorkReportCount, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String title = "日常工作数据报表";
			String beginDate = "";
			String endDate = "今";
			if (ccmWorkReportCount.getBeginDate() != null) {
				beginDate = DateFormatUtils.format(ccmWorkReportCount.getBeginDate(), "yyyy-MM-dd HH:mm:ss");
			}

			if (ccmWorkReportCount.getEndDate() != null) {
				endDate = DateFormatUtils.format(ccmWorkReportCount.getEndDate(), "yyyy-MM-dd HH:mm:ss");
			}
			
			title = title + "(" + beginDate + " 至 " + endDate + ")";
			String fileName = "日常工作数据报表" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<CcmWorkReportCount> logBookList = ccmWorkReportService.findLogBook(ccmWorkReportCount);
			new ExportExcel(title, CcmWorkReportCount.class).setDataList(logBookList).write(response, fileName).dispose();
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出日常工作数据失败！失败信息：" + e.getMessage());
		}
	}
	
	
	//日常工作数据详情-KPI
	@RequiresPermissions("report:ccmReportOthers:view")
	@RequestMapping(value ="logBookOffice")
	public String logBookOffice(CcmWorkReportCount ccmWorkReportCount, String kpiSchemeId, String kpiId, HttpServletRequest request, HttpServletResponse response, Model model) {
		KpiScheme kpiScheme = new KpiScheme();
		kpiScheme = kpiSchemeService.get(kpiSchemeId);//方案
		
		KpiSchemeKpi kpiSchemeKpi = new KpiSchemeKpi();
		kpiSchemeKpi = kpiSchemeKpiService.get(kpiId);//kpi
		
		Office office = kpiScheme.getOffice();//所属部门
		ccmWorkReportCount.setOffice(office);
		
		String userType = kpiScheme.getUserType();//用户类型
		User user = new User();
		user.setUserType(userType);
		ccmWorkReportCount.setUser(user);
		
		if (ccmWorkReportCount.getBeginDate() == null) {
			Date beginDate = new Date();
			long time = beginDate.getTime() - ((long)30 * (long)86400 * (long)1000) ;
			beginDate.setTime(time);
			ccmWorkReportCount.setBeginDate(beginDate);
		}
		if (ccmWorkReportCount.getEndDate() == null) {
			Date endDate = new Date();
			ccmWorkReportCount.setEndDate(endDate);
		}
		
		List<CcmWorkReportCount> logBookList = ccmWorkReportService.findLogBook(ccmWorkReportCount);
		CcmWorkReportCount ccmWorkReportCountSource = kpiSchemeKpiService.getccmWorkReportCountSource(kpiSchemeKpi);
		model.addAttribute("ccmWorkReportCountSource", ccmWorkReportCountSource);
		model.addAttribute("kpiScheme", kpiScheme);
		model.addAttribute("kpiSchemeKpi", kpiSchemeKpi);
		model.addAttribute("ccmWorkReportCount", ccmWorkReportCount);
		model.addAttribute("logBookList", logBookList);
		return "ccm/report/reportLogBookOffice";
	}
	
	
	
	//首页概况各种总数查询getOthersAll
	@ResponseBody
	@RequestMapping(value = "getOthersAll")
	public List<String> getOthersAll(Model model) {
		// 返回对象结果
		List<String> list = new ArrayList<>();
		//社区民警/辅警
		int num1 = ccmOrgComPopService.findPop();
		list.add(num1+"");
		//公安警务站
		String[] com = {"01"};//公安警务站
		for(int n=0;n<com.length;n++){
			CcmOrgCommonality ccmOrgCommonality = new CcmOrgCommonality();
			ccmOrgCommonality.setType(com[n]);
			List<CcmOrgCommonality> list2 = ccmOrgCommonalityService.findList(ccmOrgCommonality);
			list.add(list2.size()+"");
		}
		//网格员
		List<CcmOrgArea> list5 = ccmOrgAreaService.findList(new CcmOrgArea());
		int a=0;
		if(list5.size()>0){
			for(CcmOrgArea areas:list5){
				if(areas.getNetPeoNum()!=null){
					a +=areas.getNetPeoNum();
				}
			}
		}
		list.add(a+"");
		//视频监控
		CcmDevice ccmDevice = new CcmDevice();
		ccmDevice.setTypeId("003");
		List<CcmDevice> listCcmDevice = ccmDeviceService.findList(ccmDevice); 
		list.add(listCcmDevice.size()+"");
		//应急避难场所//应急物资
		String[] city = {"18","19"};//应急避难场所//应急物资
		for(int q=0;q<city.length;q++){
			CcmCityComponents ccmCityComponents = new CcmCityComponents();
			ccmCityComponents.setType(city[q]);
			List<CcmCityComponents> listCity = ccmCityComponentsService.findList(ccmCityComponents);
			list.add(listCity.size()+"");
		}
		
		return list;
	}
	
	/**
	 * 街道信息-大屏-滨海新区社会网格化管理信息平台
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findStringType")
	public List<Map<String, Object>> findStringType(Model model) {
		// 返回对象结果
		Area area = new Area();
		area.setType("5");//街道
		CcmOrgArea jiedao = new CcmOrgArea();
		jiedao.setArea(area);
		List<SearchTab> list = ccmOrgAreaService.findListAllData(jiedao);
		//List<Area> list = areaService.findList(area);
		List<Map<String, Object>> all = new ArrayList<>();
		for(SearchTab str:list){
			Map<String, Object> areas = Maps.newHashMap();
			areas.put("id", str.getType());							//街道id
			areas.put("name", str.getValue());						//街道名称
			areas.put("map", str.getValue1());						//街道map
			areas.put("point", str.getValue2());						//街道point
			Area a = new Area();
			a.setId(str.getType());
			//社区
			Area areaSuequ = new Area();
			areaSuequ.setType("6");
			areaSuequ.setParent(a);
			CcmOrgArea ccmOrgArea = new CcmOrgArea();
			ccmOrgArea.setArea(areaSuequ);
			List<SearchTab> list1 = ccmOrgAreaService.findListAllData(ccmOrgArea);
			List<Map<String, String>> map1 = new ArrayList<>();
			for(SearchTab s:list1){
				Map<String, String> data1 = Maps.newHashMap();
				data1.put("id", s.getType());	
				data1.put("name", s.getValue());	
				//data1.put("map", s.getValue1());	
				data1.put("point", s.getValue2());	
				map1.add(data1);
			}
			//楼栋
			CcmHouseBuildmanage ccmHouseBuildmanage = new CcmHouseBuildmanage();
			ccmHouseBuildmanage.setArea(a);
//			List<SearchTab> list2 = ccmHouseBuildmanageService.findListAllData(ccmHouseBuildmanage);
			int build = ccmHouseBuildmanageService.findListNum(ccmHouseBuildmanage);
			//单元
			CcmHouseBuildmanage ccmHouseBuildmanageDanYuan = new CcmHouseBuildmanage();
			ccmHouseBuildmanageDanYuan.setArea(a);
//			List<SearchTab> list7 = ccmHouseBuildmanageService.findListAllData(ccmHouseBuildmanageDanYuan);
			int buildDanYuan = ccmHouseBuildmanageService.findListNumDanYuan(ccmHouseBuildmanage);
			//房屋
			CcmPopTenant ccmPopTenant = new CcmPopTenant();
			ccmPopTenant.setArea(a);
			//List<SearchTab> list3 = ccmPopTenantService.findListAllData(ccmPopTenant);
			int house = ccmPopTenantService.findListNum(ccmPopTenant);
			//学校
			CcmHouseSchoolrim ccmHouseSchoolrim = new CcmHouseSchoolrim();
			ccmHouseSchoolrim.setArea(a);
			List<SearchTab> list4 = ccmHouseSchoolrimService.findListAllData(ccmHouseSchoolrim);
			List<Map<String, String>> map4 = new ArrayList<>();
			for(SearchTab s:list4){
				Map<String, String> data4 = Maps.newHashMap();
				data4.put("id", s.getType());	
				data4.put("name", s.getValue());	
				//data4.put("map", s.getValue1());	
				data4.put("point", s.getValue2());	
				map4.add(data4);
			}
			//人口
			CcmPeopleAmount ccmPeopleAmount = new CcmPeopleAmount();
			ccmPeopleAmount.setArea(a);
			List<CcmPeopleAmount> list5 = ccmPeopleAmountService.findList(ccmPeopleAmount);
			int num = 0;
			if(list5.size()>0){
				num = (list5.get(0).getPersonAmount()==null?0:list5.get(0).getPersonAmount())
						+(list5.get(0).getOverseaAmount()==null?0:list5.get(0).getOverseaAmount())
						+(list5.get(0).getFloatAmount()==null?0:list5.get(0).getFloatAmount())
						+(list5.get(0).getUnsettleAmount()==null?0:list5.get(0).getUnsettleAmount());
			}
			//重点场所
			CcmOrgNpse ccmOrgNpse = new CcmOrgNpse();
			ccmOrgNpse.setArea(a);
			List<SearchTab> list6 = ccmOrgNpseService.findListAllData(ccmOrgNpse);
			List<Map<String, String>> map6 = new ArrayList<>();
			for(SearchTab s:list6){
				Map<String, String> data6 = Maps.newHashMap();
				data6.put("id", s.getType());	
				data6.put("name", s.getValue());	
				//data6.put("map", s.getValue1());	
				data6.put("point", s.getValue2());	
				map6.add(data6);
			}
			//
			areas.put("shequNum", list1.size());				//街道/社区数据num
			areas.put("loudongNum", build);						//街道/楼栋数据num
			areas.put("danyuanNum", buildDanYuan);				//街道/单元数据num
			areas.put("fangwuNum", house);						//街道/房屋数据num
			areas.put("xuexiaoNum", list4.size());				//街道/学校数据num
			areas.put("renkouNum", num);						//街道/人口数据num
			areas.put("zhongdianchangsuoNum", list6.size());	//街道/重点场所数据num
			areas.put("shequData", map1);						//街道/社区数据
			//areas.put("loudongData", list2);					//街道/楼栋数据
			//areas.put("danyuanData", list7);					//街道/单元数据
			//areas.put("fangwuData", list3);					//街道/房屋数据
			areas.put("xuexiaoData", map4);						//街道/学校数据
			//areas.put("renkouData", list5);					//街道/人口数据
			areas.put("zhongdianchangsuoData", map6);			//街道/重点场所数据
			
			all.add(areas);
		}
		
		System.out.print(all);
		return all;
	}
	
	
	
	// 特殊人群分析(曲梁)
	@ResponseBody
	@RequestMapping(value = "getnumOfWorkPower")
	public Map<String, Object> getnumOfWorkPower(Model model) {
		Map<String, Object> result = ccmOrgComPopService.getnumOfWorkPower();
		return result;
	}

}