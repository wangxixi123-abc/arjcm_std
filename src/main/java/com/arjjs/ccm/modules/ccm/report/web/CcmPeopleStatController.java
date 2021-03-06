/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.report.web;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Lists;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.report.entity.CcmPeopleStat;
import com.arjjs.ccm.modules.ccm.report.service.CcmPeopleAmountService;
import com.arjjs.ccm.modules.ccm.report.service.CcmPeopleStatService;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.google.common.collect.Maps;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import static com.arjjs.ccm.tool.DateTools.getSixMonth;
import static org.apache.commons.codec.binary.StringUtils.newString;

/**
 * 人口统计Controller
 *
 * @author arj
 * @version 2018-01-20
 */
@Controller
@RequestMapping(value = "${adminPath}/report/ccmPeopleStat")
public class CcmPeopleStatController extends BaseController {

	@Autowired
	private CcmPeopleStatService ccmPeopleStatService;
	@Autowired
	private CcmPeopleAmountService ccmPeopleAmountService;

	// 新增人口统计列
	private static String[] columnListNew = { "person_new", "oversea_new", "float_new", "aids_new", "psychogeny_new",
			"rectification_new", "release_new", "drugs_new", "behind_new",
			"kym_new", "unsettle_new", "visit_new", "heresy_new", "dangerous_new",
			"care_new", "older_new", "communist_new","escape_new","harmNational_new", "seriousCriminalOffense_new", "deliberatelyIllegal_new","dispute_new"};
	// 总数人口统计列
	private static String[] columnListAmount = { "person_amount", "oversea_amount", "float_amount", "aids_amount",
			"psychogeny_amount", "rectification_amount", "release_amount", "drugs_amount", "behind_amount",
			"kym_amount", "unsettle_amount", "visit_amount", "heresy_amount", "dangerous_amount",
			"care_amount", "older_amount", "communist_amount","escape_amount", "harmNational_amount", "seriousCriminalOffense_amount", "deliberatelyIllegal_amount", "dispute_amount"};

	@ModelAttribute
	public CcmPeopleStat get(@RequestParam(required = false) String id) {
		CcmPeopleStat entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmPeopleStatService.get(id);
		}
		if (entity == null) {
			entity = new CcmPeopleStat();
		}
		return entity;
	}

	@RequiresPermissions("report:ccmPeopleStat:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmPeopleStat ccmPeopleStat, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmPeopleStat> page = ccmPeopleStatService.findPage(new Page<CcmPeopleStat>(request, response), ccmPeopleStat);
		model.addAttribute("page", page);
		return "ccm/report/ccmPeopleStatList";
	}


	@RequiresPermissions("report:ccmPeopleStat:view")
	@RequestMapping(value = "form")
	public String form(CcmPeopleStat ccmPeopleStat, Model model) {
		model.addAttribute("ccmPeopleStat", ccmPeopleStat);
		return "ccm/report/people/ccmPeopleStatForm";
	}

	/**
	 * @see 统计户籍人口
	 * @param ccmPeopleStat
	 * @param model
	 * @return
	 */
	@RequiresPermissions("report:ccmPeopleStat:view")
	@RequestMapping(value = "statisticsPage")
	public String personPage(@RequestParam(value = "title", required = false) String title, Model model) {
		return "ccm/report/people/"+title;
	}

	/**
	 * @see 获取Json 数据
	 * @param type 当前用户类别
	 * @param model
	 * @return
	 */
	@RequiresPermissions("report:ccmPeopleStat:view")
	@ResponseBody
	@RequestMapping(value = "personStat")
	public Map<String, Object> personStat(@RequestParam(value = "title", required = false) String title,
			@RequestParam(value = "type", required = false) int type, Model model) {

		// 返回对象结果
		Map<String, Object> map = Maps.newHashMap();
		// 1. 根据于地区为分界线
		// 1)本月新增人员数据 2)本月人员总数
		List<EchartType> list1 = ccmPeopleStatService.findListByMon(columnListNew[type]);
		List<EchartType> list2 = ccmPeopleAmountService.findListByMon(columnListAmount[type]);
		map.put("本月"+title+"新增人数", list1);
		map.put("本月"+title+"总数", list2);
		// 2. 根据于月份为分界线
		// 1) 所有新增日新增总和 2)所有人数地区总和
		List<EchartType> list3 = ccmPeopleStatService.findListBySum(columnListNew[type]);
		List<EchartType> list4 = ccmPeopleAmountService.findListBySum(columnListAmount[type]);
		map.put("新增"+title+"人数", list3);
		map.put(title+"总人数", list4);
		return map;
	}


	/**
	 * 流入流出分析
	 *
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "findFloatOutInArea")
	public String findFloatOutInArea(CcmPeopleStat ccmPeopleStat, Model model,Integer popAll) {
		// 返回对象结果
		List<SearchTab> list = new ArrayList<>();
		if(ccmPeopleStat.getArea()!=null && ccmPeopleStat.getArea().getId()!=null && ccmPeopleStat.getArea().getId() !=""){
			list = ccmPeopleStatService.findFloatOutInArea(ccmPeopleStat);
		}
		SearchTab searchTab = new SearchTab();
		searchTab.setType("暂无信息");
		searchTab.setValue1("0");
		searchTab.setValue2("0");
		if(list.size()==0){
			list.add(searchTab);
		}
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{"typeO","value","value3","value4"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String listAll = JSONArray.fromObject(list,config).toString(); //Json
		return listAll;
	}


	/**
	 * 户籍人口迁入迁出情况
	 *
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getPopInOut")
	public List<SearchTab> getPopInOut(CcmPeopleStat ccmPeopleStat, Model model,Integer popAll) {
		// 返回对象结果
		List<SearchTab> list = new ArrayList<>();
		list = ccmPeopleStatService.getPopInOut(ccmPeopleStat);

		SearchTab searchTab = new SearchTab();
		searchTab.setType("暂无信息");
		searchTab.setValue1("0");
		searchTab.setValue2("0");
		if(list.size()==0){
			list.add(searchTab);
		}
		return list;
	}

	/**
	 * 获取所有类型新增人口数量
	 */
	@ResponseBody
	@RequestMapping(value = "findPeopleNewSum")
	public Map<String, Object> findPeopleNewSum(Model model) {
		// 返回对象结果
		Map<String, Object> map = Maps.newHashMap();
		Map<String, Integer> map1 = Maps.newHashMap();
		Map<String, Integer> map2 = Maps.newHashMap();
		// 2. 根据于月份为分界线
		// 1) 所有新增日新增总和 2)所有人数地区总和
		List<EchartType> list1 = ccmPeopleStatService.findPeopleNewSum();
		List<EchartType> list2 = ccmPeopleAmountService.findListBySumNum();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");

		for (int i = 0; i < list1.size(); i++) {
			int list1i = 0;
			list1i += Integer.parseInt(list1.get(i).getValue());
			list1i += Integer.parseInt(list1.get(i).getValue1());
			list1i += Integer.parseInt(list1.get(i).getValue2());
			list1i += Integer.parseInt(list1.get(i).getValue3());
			map1.put(list1.get(i).getType(),list1i);
		}

		for (int i = 0; i < list2.size(); i++) {
			int list2i = 0;
			list2i += Integer.parseInt(list2.get(i).getValue());
			list2i += Integer.parseInt(list2.get(i).getValue1());
			list2i += Integer.parseInt(list2.get(i).getValue2());
			list2i += Integer.parseInt(list2.get(i).getValue3());
			map2.put(list2.get(i).getType(),list2i);
		}

		List<String> reslist1 = Lists.newArrayList();
		List<String> reslist2 = Lists.newArrayList();
		List<String> listdata = getSixMonth(df.format(new Date()));
		for(int i =0;i<listdata.size();i++){

			if(map1.get(listdata.get(i))!=null){
				reslist1.add(map1.get(listdata.get(i)).toString());
			} else {
				reslist1.add("0");
			}

			if(map2.get(listdata.get(i))!=null){
				reslist2.add(map2.get(listdata.get(i)).toString());
			} else {
				reslist2.add("0");
			}
		}
		map.put("新增人数", reslist1);
		map.put("人数", reslist2);
		map.put("日期", listdata);
		return map;

//		return ccmPeopleStatService.findPeopleNewSum();
	}

}