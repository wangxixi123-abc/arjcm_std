/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.report.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseBuildmanageService;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseKymService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgAreaService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgNpseService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenant;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPopTenantService;
import com.arjjs.ccm.modules.ccm.report.entity.CcmPeopleAmount;
import com.arjjs.ccm.modules.ccm.report.service.CcmPeopleAmountService;
import com.arjjs.ccm.modules.ccm.report.service.CcmPeopleStatService;
import com.arjjs.ccm.modules.plm.home.service.PlmPortalDictService;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.service.AreaService;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SearchTabMore;
import com.google.common.collect.Maps;
import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 人口总数统计Controller
 * 
 * @author arj
 * @version 2018-01-20
 */
@Controller
@RequestMapping(value = "${adminPath}/report/ccmPeopleAmount")
public class CcmPeopleAmountController extends BaseController {

	@Autowired
	private CcmPeopleAmountService ccmPeopleAmountService;
	@Autowired
	private CcmPeopleStatService ccmPeopleStatService;
	@Autowired
	private CcmHouseKymService ccmHouseKymService;
	@Autowired
	private CcmPopTenantService ccmPopTenantService;
	@Autowired
	private CcmOrgNpseService ccmOrgNpseService;
	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private AreaService areaService;
	@Autowired
	private CcmOrgAreaService ccmOrgAreaService;
	@Autowired
	private CcmHouseBuildmanageService ccmHouseBuildmanageService;
	@Autowired
	private PlmPortalDictService plmPortalDictService;

	@ModelAttribute
	public CcmPeopleAmount get(@RequestParam(required = false) String id) {
		CcmPeopleAmount entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmPeopleAmountService.get(id);
		}
		if (entity == null) {
			entity = new CcmPeopleAmount();
		}
		return entity;
	}

	// 实有人口统计情况
	@ResponseBody
	@RequestMapping(value = "getAnalyzePopData")
	public List<String> getAnalyzePopData(Model model) {
		// 返回对象结果
		SearchTab searchTab = ccmPeopleAmountService.getAnalyzePopData();
		List<String> list = new ArrayList<>();
		if (searchTab != null) {
			list.add(searchTab.getValue1());
			list.add(searchTab.getValue2());
			list.add(searchTab.getValue3());
			list.add(searchTab.getValue4());
			list.add(searchTab.getValue());
		} else {
			list.add("0");
			list.add("0");
			list.add("0");
			list.add("0");
			list.add("0");
		}
		return list;
	}

	// 实有人口统计情况
	@ResponseBody
	@RequestMapping(value = "getAnalyzePopNewData")
	public List<String> getAnalyzePopNewData(Model model) {
		// 返回对象结果
		SearchTab searchTab = ccmPeopleAmountService.getAnalyzePopData();
		List<String> list = new ArrayList<>();
		if (searchTab != null) {
			list.add(searchTab.getValue1());
			list.add(searchTab.getValue2());
			list.add(searchTab.getValue3());
			list.add(searchTab.getValue4());
		} else {
			list.add("0");
			list.add("0");
			list.add("0");
			list.add("0");
		}
		return list;
	}

	// 特殊人群分析
	@ResponseBody
	@RequestMapping(value = "getSpecialPopData")
	public SearchTabMore getSpecialPopData(Model model) {
		// 返回对象结果
		SearchTabMore searchTabMore = new SearchTabMore();
		searchTabMore.setType("0");
		searchTabMore.setValue("0");
		searchTabMore.setValue1("0");
		searchTabMore.setValue2("0");
		searchTabMore.setValue3("0");
		searchTabMore.setValue4("0");
		searchTabMore.setValue5("0");
		searchTabMore.setValue6("0");
		searchTabMore.setValue7("0");
		searchTabMore.setValue8("0");
		searchTabMore.setValue9("0");
		searchTabMore.setValue10("0");
		searchTabMore.setValue11("0");
		searchTabMore.setValue12("0");
		searchTabMore.setValue13("0");
		searchTabMore.setValue14("0");
		searchTabMore.setValue15("0");
		searchTabMore.setValue16("0");
		searchTabMore.setValue17("0");
		searchTabMore.setValue18("0");
		searchTabMore.setValue19("0");
		searchTabMore.setValue20("0");
		searchTabMore.setValue21("0");
		SearchTabMore searchTabMore1 = ccmPeopleAmountService.getSpecialPopData();
		if (searchTabMore1 == null) {
			searchTabMore1 = searchTabMore;
		}
		return searchTabMore1;
	}

	// 实有人口总数、新增getnumPopData/CameraTotal/OnLineRate
	@ResponseBody
	@RequestMapping(value = "getnumPopData")
	public List<String> getnumPopData(Model model) {
		// 返回对象结果
		EchartType echartType1 = ccmPeopleAmountService.getCameraTotal();
		EchartType echartType2 = ccmPeopleStatService.getOnLineRate();
		List<String> list = new ArrayList<>();
		if (echartType1 != null) {
			list.add(echartType1.getValue());
		} else {
			list.add("0");
		}
		if (echartType2 != null) {
			list.add(echartType2.getValue());
		} else {
			list.add("0");
		}

		return list;
	}

	// 重点青少年分析
	@ResponseBody
	@RequestMapping(value = "getnumPopFlowTable")
	public List<SearchTab> getnumPopFlowTable(Model model) {
		// 返回对象结果
		List<SearchTab> list = ccmHouseKymService.getnumPopFlowTable();
		return list;
	}

	// 本月人口信息PopFollowPop
	@ResponseBody
	@RequestMapping(value = "getnumPopFollowPop")
	public List<SearchTabMore> getnumPopFollowPop(Model model) {
		// 返回对象结果
		List<SearchTabMore> list = new ArrayList<>();
		SearchTabMore searchTabMore = new SearchTabMore();
		searchTabMore.setType("0");
		searchTabMore.setValue("0");
		searchTabMore.setValue1("0");
		searchTabMore.setValue2("0");
		searchTabMore.setValue3("0");
		searchTabMore.setValue4("0");
		searchTabMore.setValue5("0");
		searchTabMore.setValue6("0");
		searchTabMore.setValue7("0");
		searchTabMore.setValue8("0");
		searchTabMore.setValue9("0");
		searchTabMore.setValue10("0");
		searchTabMore.setValue11("0");
		searchTabMore.setValue12("0");
		searchTabMore.setValue13("0");
		searchTabMore.setValue14("0");
		searchTabMore.setValue15("0");
		searchTabMore.setValue16("0");
		searchTabMore.setValue17("0");
		searchTabMore.setValue18("0");
		searchTabMore.setValue19("0");
		searchTabMore.setValue20("0");
		searchTabMore.setValue21("0");
		SearchTabMore searchTabMore1 = new SearchTabMore();
		searchTabMore1 = ccmPeopleStatService.getnumPopFollowPop();
		if (searchTabMore1 == null) {
			searchTabMore1 = searchTabMore;
		}
		list.add(searchTabMore1);
		searchTabMore1 = ccmPeopleAmountService.getnumPopFollowPop();
		if (searchTabMore1 == null) {
			searchTabMore1 = searchTabMore;
		}
		list.add(searchTabMore1);
		return list;
	}

	// 重点关怀getEmphasisCare
	@ResponseBody
	@RequestMapping(value = "getEmphasisCare")
	public List<String> getEmphasisCare(Model model) {
		// 返回对象结果
		List<String> list = new ArrayList<>();
		SearchTabMore searchTabMore1 = ccmPeopleAmountService.getnumPopFollowPop();
		if (searchTabMore1 != null) {
			list.add(searchTabMore1.getValue4());// 留守
			list.add(searchTabMore1.getValue10());// 重点青少年
			list.add(searchTabMore1.getValue15());// 老年
		} else {
			list.add("0");
			list.add("0");
			list.add("0");
		}
		String[] care = { ",k,", ",b,", ",d,", ",f,", ",a," };// 失独//残疾//优抚//烈士//低保
		for (int n = 0; n < care.length; n++) {
			String careTypes = care[n];// 特殊关怀类型
			String specialCareTypeStr = "";
			CcmPeople ccmPeople = new CcmPeople();
			String[] specialCareTypes = careTypes.split(",");
			for (int i = 0; i < specialCareTypes.length; i++) {// 去掉空字符串和null字符串
				if (specialCareTypes[i] != null && !"".equals(specialCareTypes[i])
						&& !"null".equals(specialCareTypes[i])) {
					specialCareTypeStr = specialCareTypeStr + specialCareTypes[i] + ",";
				}
			}
			ccmPeople.setSpecialCareTypes(specialCareTypeStr.split(","));
			int ListNum = ccmPeopleService.findListNum(ccmPeople);// 特殊关怀人员数量
			list.add(ListNum + "");
		}
		int sum = 0; // 总数
		for (String l : list) {
			sum += Integer.parseInt(l);
		}
		list.add(sum + "");
		return list;
	}

	// 重点青少年统计
	@ResponseBody
	@RequestMapping(value = "getnumPopFollowEcharts")
	public List<EchartType> getnumPopFollowEcharts(Model model) {
		// 返回对象结果
		List<EchartType> list = new ArrayList<>();
		List<EchartType> list1 = ccmPeopleAmountService.getnumPopFollowEcharts();
		EchartType echartType = new EchartType();
		echartType.setType("暂无数据");
		echartType.setValue("0");
		if (list1.size() != 0) {
			list = list1;
		} else {
			list.add(echartType);
		}
		return list;
	}

	//
	@RequiresPermissions("report:ccmPeopleAmount:view")
	@RequestMapping(value = { "list", "" })
	public String list(CcmPeopleAmount ccmPeopleAmount, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<CcmPeopleAmount> page = ccmPeopleAmountService.findPage(new Page<CcmPeopleAmount>(request, response),
				ccmPeopleAmount);
		model.addAttribute("page", page);
		return "ccm/report/ccmPeopleAmountList";
	}

	@RequiresPermissions("report:ccmPeopleAmount:view")
	@RequestMapping(value = "form")
	public String form(CcmPeopleAmount ccmPeopleAmount, Model model) {
		model.addAttribute("ccmPeopleAmount", ccmPeopleAmount);
		return "ccm/report/ccmPeopleAmountForm";
	}

	@RequiresPermissions("report:ccmPeopleAmount:edit")
	@RequestMapping(value = "save")
	public String save(CcmPeopleAmount ccmPeopleAmount, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPeopleAmount)) {
			return form(ccmPeopleAmount, model);
		}
		ccmPeopleAmountService.save(ccmPeopleAmount);
		addMessage(redirectAttributes, "保存人口总数统计成功");
		return "redirect:" + Global.getAdminPath() + "/report/ccmPeopleAmount/?repage";
	}

	@RequiresPermissions("report:ccmPeopleAmount:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmPeopleAmount ccmPeopleAmount, RedirectAttributes redirectAttributes) {
		ccmPeopleAmountService.delete(ccmPeopleAmount);
		addMessage(redirectAttributes, "删除人口总数统计成功");
		return "redirect:" + Global.getAdminPath() + "/report/ccmPeopleAmount/?repage";
	}

	/**
	 * 社区特殊人群类型统计
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findPopByArea")
	public List<EchartType> findPopByArea(CcmPeopleAmount ccmPeopleAmount, Model model) {
		// 返回对象结果
		List<SearchTabMore> SearchTabMore = ccmPeopleAmountService.findPopByArea(ccmPeopleAmount);
		EchartType echartType1 = new EchartType();
		EchartType echartType2 = new EchartType();
		EchartType echartType3 = new EchartType();
		EchartType echartType4 = new EchartType();
		EchartType echartType5 = new EchartType();
		EchartType echartType6 = new EchartType();
		EchartType echartType7 = new EchartType();
		EchartType echartType8 = new EchartType();
		EchartType echartType9 = new EchartType();
		List<EchartType> list = new ArrayList<EchartType>();

		echartType1.setType("留守人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue1() == null) {
			echartType1.setValue("0");
		} else {
			echartType1.setValue(SearchTabMore.get(0).getValue1());
		}
		// list.add(echartType1);

		echartType2.setType("社区矫正人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue2() == null) {
			echartType2.setValue("0");
		} else {
			echartType2.setValue(SearchTabMore.get(0).getValue2());
		}

		echartType3.setType("肇事肇祸等严重精神障碍患者");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue3() == null) {
			echartType3.setValue("0");
		} else {
			echartType3.setValue(SearchTabMore.get(0).getValue3());
		}

		echartType4.setType("吸毒人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue4() == null) {
			echartType4.setValue("0");
		} else {
			echartType4.setValue(SearchTabMore.get(0).getValue4());
		}

		echartType5.setType("安置帮教人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue5() == null) {
			echartType5.setValue("0");
		} else {
			echartType5.setValue(SearchTabMore.get(0).getValue5());
		}

		echartType6.setType("艾滋人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue6() == null) {
			echartType6.setValue("0");
		} else {
			echartType6.setValue(SearchTabMore.get(0).getValue6());
		}

		echartType7.setType("重点上访人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue11() == null) {
			echartType7.setValue("0");
		} else {
			echartType7.setValue(SearchTabMore.get(0).getValue11());
		}

		echartType8.setType("涉教人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue12() == null) {
			echartType8.setValue("0");
		} else {
			echartType8.setValue(SearchTabMore.get(0).getValue12());
		}

		echartType9.setType("危险品从业人员");
		if (SearchTabMore.size() == 0 || SearchTabMore.get(0) == null || SearchTabMore.get(0).getValue13() == null) {
			echartType9.setValue("0");
		} else {
			echartType9.setValue(SearchTabMore.get(0).getValue13());
		}
		list.add(echartType3);// 肇事肇祸等严重精神障碍患者
		list.add(echartType5);// 安置帮教人员
		list.add(echartType2);// 社区矫正人员
		list.add(echartType4);// 吸毒人员
		list.add(echartType6);// 艾滋人员
		list.add(echartType7);// 重点上访人员
		list.add(echartType8);// 涉教人员
		list.add(echartType9);// 危险品从业人员

		return list;
	}

	/**
	 * 社区特殊人群变化趋势
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findPopTrendByArea")
	public List<SearchTabMore> findPopTrendByArea(CcmPeopleAmount ccmPeopleAmount, Model model) {
		// 返回对象结果
		List<SearchTabMore> list = ccmPeopleAmountService.findPopTrendByArea(ccmPeopleAmount);
		if (list.size() == 0) {
			SearchTabMore searchTabMore = new SearchTabMore();
			searchTabMore.setType("暂无数据");
			searchTabMore.setValue1("0");
			searchTabMore.setValue2("0");
			searchTabMore.setValue3("0");
			searchTabMore.setValue4("0");
			searchTabMore.setValue5("0");
			searchTabMore.setValue6("0");
			searchTabMore.setValue7("0");
			searchTabMore.setValue8("0");
			searchTabMore.setValue11("0");
			searchTabMore.setValue12("0");
			searchTabMore.setValue13("0");
			list.add(searchTabMore);
		} else {
			for (int i = 0; i < list.size(); i++) {
				if (list.get(i).getType() == null) {
					list.get(i).setType("暂无数据");
				}
				if (list.get(i).getValue1() == null) {
					list.get(i).setValue1("0");
				}
				if (list.get(i).getValue2() == null) {
					list.get(i).setValue2("0");
				}
				if (list.get(i).getValue3() == null) {
					list.get(i).setValue3("0");
				}
				if (list.get(i).getValue4() == null) {
					list.get(i).setValue4("0");
				}
				if (list.get(i).getValue5() == null) {
					list.get(i).setValue5("0");
				}
				if (list.get(i).getValue6() == null) {
					list.get(i).setValue6("0");
				}
				if (list.get(i).getValue7() == null) {
					list.get(i).setValue7("0");
				}
				if (list.get(i).getValue8() == null) {
					list.get(i).setValue8("0");
				}
				if (list.get(i).getValue11() == null) {
					list.get(i).setValue11("0");
				}
				if (list.get(i).getValue12() == null) {
					list.get(i).setValue12("0");
				}
				if (list.get(i).getValue13() == null) {
					list.get(i).setValue13("0");
				}
			}
		}
		return list;
	}

	/**
	 * 出租房数量
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findChuZuFang")
	public Integer findChuZuFang(CcmPeopleAmount ccmPeopleAmount, Model model) {
		// 返回对象结果
		CcmPopTenant ccmPopTenant = new CcmPopTenant();
		int house = 0;
		if (ccmPeopleAmount.getArea() != null && ccmPeopleAmount.getArea().getId() != null
				&& ccmPeopleAmount.getArea().getId() != "") {
			ccmPopTenant.setArea(ccmPeopleAmount.getArea());
			Area area = areaService.get(ccmPeopleAmount.getArea().getId());
			if ("5".equals(area.getType())) {
				house = ccmPopTenantService.findListNum(ccmPopTenant); // 出租房数量-街道
			} else if ("6".equals(area.getType())) {
				house = ccmPopTenantService.findListNumCommunity(ccmPopTenant); // 出租房数量-社区
			}
		}

		return house;
	}

	/**
	 * 楼栋总面积+人均住房面积
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findBuildArea")
	public List<String> findBuildArea(CcmPeopleAmount ccmPeopleAmount, Model model, Integer popAll) {
		// 返回对象结果
		List<String> list = new ArrayList<>();

		Area area = new Area();
		area.setId(ccmPeopleAmount.getArea().getId());
		area = areaService.get(area);// 区域
		Area area2 = new Area();
		area2.setParentIds(area.getId());
		List<Area> areaNetAll = new ArrayList<>();
		areaNetAll = ccmOrgAreaService.findAreaNet(area2);// 子集-社区and网格（通过父键查子集）area借用ccmOrgArea

		List<CcmHouseBuildmanage> listBuildmanage2 = new ArrayList<>();
		CcmHouseBuildmanage ccmHouseBuildmanage2 = new CcmHouseBuildmanage();
		double BuildmanageArea = 0;
		for (Area net : areaNetAll) {
			if ("7".equals(net.getType())) {
				ccmHouseBuildmanage2.setArea(net);
				listBuildmanage2 = ccmHouseBuildmanageService.findList(ccmHouseBuildmanage2);
				for (CcmHouseBuildmanage buildmanage : listBuildmanage2) {
					if (buildmanage.getFloorArea() == null || "".equals(buildmanage.getFloorArea())) {
						buildmanage.setFloorArea(0.0);
					}
					BuildmanageArea += buildmanage.getFloorArea();// 楼栋总面积
				}
			}
		}

		double BuildmanageAreaPop = 0;
		if (popAll != 0) {
			BuildmanageAreaPop = BuildmanageArea / popAll;// 人均住房面积
		}

		String BuildmanageAreaPop1 = String.format("%.2f", BuildmanageAreaPop);// 人均住房面积
		BuildmanageAreaPop = Double.valueOf(BuildmanageAreaPop1);// 人均住房面积

		list.add(BuildmanageArea + "");
		list.add(BuildmanageAreaPop + "");

		return list;
	}

	// 全部房屋类型统计
	@ResponseBody
	@RequestMapping(value = "getListTypeAll")
	public String getListTypeAll(Model model) {
		// 返回对象结果
//		SearchTabMore searchTabMore = new SearchTabMore();
//		searchTabMore.setValue5("all");
//		searchTabMore.setValue8("all");
//		List<SearchTabMore> list = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋
//		searchTabMore.setValue5("01");
//		searchTabMore.setValue8("all");
//		List<SearchTabMore> list5 = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋状态01自住
//		searchTabMore.setValue5("02");
//		searchTabMore.setValue8("all");
//		List<SearchTabMore> list6 = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋状态02出租
//		searchTabMore.setValue5("03");
//		searchTabMore.setValue8("all");
//		List<SearchTabMore> list7 = ccmPopTenantService.findHouseAndBuild(searchTabMore); //报表:楼栋房屋状态03空置
//		
//		int type5 = 0;
//		int type6 = 0;
//		int type7 = 0;
//		for(SearchTabMore se:list){
//			se.setValue5("0");se.setValue6("0");se.setValue7("0");
//			for(SearchTabMore se5:list5){
//				if(se.getType().equals(se5.getType())){
//					se.setValue5(se5.getValue4());//添加自住数据
//				}
//			}
//			for(SearchTabMore se6:list6){
//				if(se.getType().equals(se6.getType())){
//					se.setValue6(se6.getValue4());//添加出租数据
//				}
//			}
//			for(SearchTabMore se7:list7){
//				if(se.getType().equals(se7.getType())){
//					se.setValue7(se7.getValue4());//添加空置数据
//				}
//			}
//			type5 +=Integer.parseInt(se.getValue5());//计算自住数据
//			type6 +=Integer.parseInt(se.getValue6());//计算出租数据
//			type7 +=Integer.parseInt(se.getValue7());//计算空置数据
//		}

		int type5 = 0;// 自住数据
		int type6 = 0;// 出租数据
		int type7 = 0;// 空置数据
		int type8 = 0;// 其他数据
		List<EchartType> list = ccmPopTenantService.findHouseType(); // 报表:房屋类型
		for (EchartType l : list) {
			if ("01".equals(l.getTypeO())) {
				type5 = Integer.parseInt(l.getValue());
			}
			if ("02".equals(l.getTypeO())) {
				type6 = Integer.parseInt(l.getValue());
			}
			if ("03".equals(l.getTypeO())) {
				type7 = Integer.parseInt(l.getValue());
			}
			if ("99".equals(l.getTypeO())) {
				type8 = Integer.parseInt(l.getValue());
			}
		}

		List<EchartType> listType = new ArrayList<>();
		EchartType echartType5 = new EchartType();
		EchartType echartType6 = new EchartType();
		EchartType echartType7 = new EchartType();
		EchartType echartType8 = new EchartType();
		echartType5.setType("自住");
		echartType5.setValue(String.valueOf(type5));
		listType.add(echartType5);
		echartType6.setType("出租");
		echartType6.setValue(String.valueOf(type6));
		listType.add(echartType6);
		echartType7.setType("空置");
		echartType7.setValue(String.valueOf(type7));
		listType.add(echartType7);// 拼接自住、出租、空置类型
		echartType8.setType("其他");
		echartType8.setValue(String.valueOf(type8));
		listType.add(echartType8);// 拼接自住、出租、空置类型

		JsonConfig config = new JsonConfig();// PingJson
		config.setExcludes(new String[] { "typeO" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listTypeAll = JSONArray.fromObject(listType, config).toString(); // Json治安自住、出租、空置类型统计
		return listTypeAll;
	}

	// 非公有制经济组织类型统计
	@ResponseBody
	@RequestMapping(value = "getListCompType")
	public String getListCompType(Model model) {
		// 返回对象结果
		List<EchartType> listCompType = ccmOrgNpseService.findCompType(); // 报表:非公有经济组织类别

		EchartType newEchartType = new EchartType();// 非空判断
		newEchartType.setType("暂无数据");
		newEchartType.setValue("0");
		if (listCompType.size() == 0) {
			listCompType.add(newEchartType);
		}

		JsonConfig config = new JsonConfig();// PingJson
		config.setExcludes(new String[] { "typeO" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listCompTypeString = JSONArray.fromObject(listCompType, config).toString(); // Json报表:非公有经济组织类别

		return listCompTypeString;
	}

	// 重点类型统计
	@ResponseBody
	@RequestMapping(value = "getListCompImpoType")
	public String getListCompImpoType(Model model) {
		// 返回对象结果
		List<EchartType> listCompImpoType = ccmOrgNpseService.findCompImpoType(); // 报表:非公有经济组织重点类型

		EchartType newEchartType = new EchartType();// 非空判断
		newEchartType.setType("暂无数据");
		newEchartType.setValue("0");
		if (listCompImpoType.size() == 0) {
			listCompImpoType.add(newEchartType);
		}

		JsonConfig config = new JsonConfig();// PingJson
		config.setExcludes(new String[] { "typeO" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listCompImpoTypeString = JSONArray.fromObject(listCompImpoType, config).toString(); // Json报表:非公有经济组织重点类型

		return listCompImpoTypeString;
	}

	/**
	 * 按街道查询所有人员及事件总和
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findPeopleAndEventByArea")
	public Map<String, Object> findSolveByArea(Model model) {
		// 返回对象结果
		List<EchartType> list = ccmPeopleAmountService.findPeopleAndEventByArea();
		List<String> list1 = new ArrayList<>();
		List<String> list2 = new ArrayList<>();
		List<String> list3 = new ArrayList<>();

		for (int i = 0; i < list.size(); i++) {
			EchartType et = list.get(i);
			list1.add(et.getType());
			list2.add(et.getTypeO());
			list3.add(et.getValue());
		}
		// 返回对象结果
		Map<String, Object> map = Maps.newHashMap();
		map.put("1", list1);
		map.put("2", list2);
		map.put("3", list3);

		return map;
	}

	/**
	 * 各街道人口数据对比（重点人群与特殊人群关系）-大屏-滨海新区社会网格化管理信息平台
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getStreetPopData")
	public String getStreetPopData(Model model) {
		// 返回对象结果
		List<SearchTab> listStreetPop = ccmPeopleAmountService.getStreetPopData();

		JsonConfig config = new JsonConfig();// PingJson
		config.setExcludes(new String[] { "typeO", "value", "value3", "value4" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listStreetPopString = JSONArray.fromObject(listStreetPop, config).toString(); // Json
		return listStreetPopString;
	}

	// 个人门户
	@SuppressWarnings("static-access")
	@RequestMapping(value = { "view" })
	public String view(CcmPeopleAmount ccmPeopleAmount, HttpServletRequest request, HttpServletResponse response,
			Model model, String height, String width, String content, String divId) {
		int line = plmPortalDictService.line(content);
		// plmKnowPolicy.setTypes(plmTypes.POLICY_ACT);
		// List<PlmKnowPolicy> list = plmKnowPolicyService.findView(plmKnowPolicy);
		// request.setAttribute("list", list);
		request.setAttribute("porheigh", height);
		request.setAttribute("line", line);
		request.setAttribute("porwidth", width);
		request.setAttribute("porcontent", content);
		request.setAttribute("divId", divId);

		return "ccm/report/reportCcmPeopleAmountHome";
	}


	@ResponseBody
	@RequestMapping(value = "getCountpersonAndEvent")
	public Map<String, Object> getCountpersonAndEvent(){
		List<EchartType> reslist =  ccmPeopleStatService.getcountperson(6);


		String[] type = new String[reslist.size()];
		String[] value = new String[reslist.size()];
		String[] value1 = new String[reslist.size()];

		for (int i = 0; i < reslist.size(); i++) {
			type[i] = reslist.get(i).getType();
			value[i] = reslist.get(i).getValue();
			value1[i] = reslist.get(i).getValue1();
		}

		Map<String, Object> data = Maps.newHashMap();
		data.put("name", type);
		data.put("value", value);
		data.put("value1", value1);
		return data;
	}
	
	// 重点青少年帮扶方式统计
	@ResponseBody
	@RequestMapping(value = "getNumKymByAssistMethod")
	public Map<String, Object> getNumKymByAssistMethod(Model model) {
		// 返回对象结果
		Map<String, Object> result = ccmHouseKymService.getNumKymByAssistMethod();
		return result;
	}
	
	// 重点青少年分析
	@ResponseBody
	@RequestMapping(value = "getnumPopFlowTableQL")
	public Map<String, Object> getnumPopFlowTableQL(Model model) {
		// 返回对象结果
		Map<String, Object> reslut = ccmHouseKymService.getnumPopFlowTableQL();
		return reslut;
	}
	
	// 特殊人群分析(曲梁)
	@ResponseBody
	@RequestMapping(value = "getSpecialPopDataQL")
	public Map<String, Object> getSpecialPopDataQL(Model model) {
		Map<String, Object> result = ccmPeopleStatService.getSpecialPopDataQL();
		return result;
	}
	
	// 重点关注对象(曲梁)
	@ResponseBody
	@RequestMapping(value = "getnumPopFollowPopQL")
	public Map<String, Object> getnumPopFollowPopQL(Model model) {
		Map<String, Object> result = ccmPeopleAmountService.getnumPopFollowPopQL();
		return result;
	}
}