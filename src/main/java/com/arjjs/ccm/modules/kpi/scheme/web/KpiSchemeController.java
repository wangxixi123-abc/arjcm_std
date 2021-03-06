/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.kpi.scheme.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiScheme;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiSchemeKpi;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiSchemeSubjectivity;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeKpiService;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeService;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeSubjectivityService;
import com.arjjs.ccm.modules.kpi.score.entity.KpiFinalScore;
import com.arjjs.ccm.modules.kpi.score.entity.KpiSchemeScore;
import com.arjjs.ccm.modules.kpi.score.service.KpiFinalScoreService;
import com.arjjs.ccm.modules.kpi.score.service.KpiSchemeScoreService;
import com.arjjs.ccm.tool.EchartType;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 绩效考评方案Controller
 * @author liang
 * @version 2018-04-11
 */
@Controller
@RequestMapping(value = "${adminPath}/scheme/kpiScheme")
public class KpiSchemeController extends BaseController {

	@Autowired
	private KpiSchemeService kpiSchemeService;
	@Autowired
	private KpiSchemeScoreService kpiSchemeScoreService;
	@Autowired
	private KpiSchemeKpiService kpiSchemeKpiService;
	@Autowired
	private KpiSchemeSubjectivityService kpiSchemeSubjectivityService;
	@Autowired
	private KpiFinalScoreService kpiFinalScoreService;
	
	@ModelAttribute
	public KpiScheme get(@RequestParam(required=false) String id) {
		KpiScheme entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = kpiSchemeService.get(id);
		}
		if (entity == null){
			entity = new KpiScheme();
		}
		return entity;
	}
	//启动方案
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "starList")
	public String starList(KpiScheme kpiScheme, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		kpiScheme = kpiSchemeService.get(kpiScheme);
		KpiSchemeKpi kpiSchemeKpi = new KpiSchemeKpi();
		kpiSchemeKpi.setSchemeId(kpiScheme.getId());
		kpiSchemeKpi.setType("02");
		List<KpiSchemeKpi> kpiSchemeKpiList = kpiSchemeKpiService.findList(kpiSchemeKpi);
		boolean bool = true;
		if(kpiSchemeKpiList.size() > 0) {
			List<KpiFinalScore> schemeUserLst = kpiSchemeScoreService.getSchemeUserBySchemeID(kpiScheme);
			if(schemeUserLst.size() > 0) {
				String kpiName = "";
				for (KpiSchemeKpi kpiSchemeKpi2 : kpiSchemeKpiList) {
					boolean boolkpi = true;
					for(KpiFinalScore KpiFinalScore:schemeUserLst){
						KpiSchemeSubjectivity kpiSchemeSubjectivity2 = new KpiSchemeSubjectivity();
						kpiSchemeSubjectivity2.setUserId(KpiFinalScore.getUser());
						kpiSchemeSubjectivity2.setKpiId(kpiSchemeKpi2.getId());
						List<KpiSchemeSubjectivity> KpiSchemeSubjectivityList = kpiSchemeSubjectivityService.findList(kpiSchemeSubjectivity2);
						Double r = 0.0;
						for(KpiSchemeSubjectivity k:KpiSchemeSubjectivityList){
							r +=  k.getWeight();
						}
						if(r <= 0) {
							boolkpi = false;
							break;
						}
					}
					if(!boolkpi) {
						kpiName = kpiSchemeKpi2.getName();
						bool = false;
						break;
					}
				}
				if(!bool) {
					addMessage(redirectAttributes, "启动方案《" + kpiScheme.getName() + "》失败，此方案的主观名为《" + kpiName + "》的考评没有设置考评关系");
				}
			}else {
				addMessage(redirectAttributes, "启动方案《" + kpiScheme.getName() + "》失败，此方案没有下属考核人员");
				bool = false;
			}
		}
		if(bool) {			
			kpiScheme.setState("1");
			kpiSchemeService.save(kpiScheme);//修改为启动方案
		}
		return "redirect:"+Global.getAdminPath()+"/scheme/kpiScheme/?repage";
	}
	//冻结方案
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "pauseList")
	public String pauseList(KpiScheme kpiScheme, HttpServletRequest request, HttpServletResponse response, Model model) {
		kpiScheme = kpiSchemeService.get(kpiScheme);
		kpiScheme.setState("2");
		kpiSchemeService.save(kpiScheme);//修改为冻结方案
		return "redirect:"+Global.getAdminPath()+"/scheme/kpiScheme/?repage";
	}
	//计算分值
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "calculateList")
	public String calculateList(KpiScheme kpiScheme, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes){
		KpiFinalScore kpiFinalScore = new KpiFinalScore();
		kpiFinalScore.setSchemeId(kpiScheme.getId());
		List<KpiFinalScore> kpiFinalScoreList = kpiFinalScoreService.findList(kpiFinalScore);
		for(KpiFinalScore ls:kpiFinalScoreList){
			kpiFinalScoreService.delete(ls);//删除绩效总得分，相对应的方案
		}
		//添加绩效总得分，相对应的方案,各个kpi
		List<KpiFinalScore> kfsLists = kpiFinalScoreService.findSumAll(kpiFinalScore);
		for(KpiFinalScore l:kfsLists){
			kpiFinalScoreService.save(l);
		}
		//添加绩效总得分，相对应的方案,总绩效
		List<KpiFinalScore> kfsSum = kpiFinalScoreService.findSum(kpiFinalScore);
		for(KpiFinalScore lss:kfsSum){
			kpiFinalScoreService.save(lss);
		}
		addMessage(redirectAttributes, "计算成功");
		return "redirect:"+Global.getAdminPath()+"/scheme/kpiScheme/?repage";
	}
	//开启新一轮考核
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "againList")
	public String againList(KpiScheme kpiScheme, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes){
		kpiScheme = kpiSchemeService.get(kpiScheme);
		kpiScheme.setState("0");
		kpiSchemeService.save(kpiScheme);//修改为开启新一轮考核
//		KpiSchemeScore kpiSchemeScore = new KpiSchemeScore();
//		kpiSchemeScore.setSchemeId(kpiScheme.getId());
//		List<KpiSchemeScore> lists = kpiSchemeScoreService.findList(kpiSchemeScore);//获取此方案下的绩效KPI得分
//		if(lists.size()>0){
//			for(KpiSchemeScore ls:lists){
//				kpiSchemeScoreService.delete(ls);//删除此方案下的绩效KPI得分
//			}
//		}
		KpiSchemeKpi kpiSchemeKpi = new KpiSchemeKpi();
		kpiSchemeKpi.setSchemeId(kpiScheme.getId());
		List<KpiSchemeKpi> listsKpi = kpiSchemeKpiService.findList(kpiSchemeKpi);
		for(KpiSchemeKpi k:listsKpi){
			KpiSchemeScore kpiSchemeScore = new KpiSchemeScore();
			kpiSchemeScore.setKpiId(k.getId());
			List<KpiSchemeScore> lists = kpiSchemeScoreService.findList(kpiSchemeScore);//获取此方案下的绩效KPI得分
			if(lists.size()>0){
				for(KpiSchemeScore ls:lists){
					kpiSchemeScoreService.delete(ls);//删除此方案下的绩效KPI得分
				}
			}
		}
		KpiFinalScore kpiFinalScore = new KpiFinalScore();
		kpiFinalScore.setSchemeId(kpiScheme.getId());
		List<KpiFinalScore> kpiFinalScoreList = kpiFinalScoreService.findList(kpiFinalScore);
		for(KpiFinalScore ls:kpiFinalScoreList){
			kpiFinalScoreService.delete(ls);//删除绩效总得分，相对应的方案
		}
		addMessage(redirectAttributes, "已开启新一轮考核");
		return "redirect:"+Global.getAdminPath()+"/scheme/kpiScheme/?repage";
	}
	//方案KPI管理tree
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "treeList")
	public String treeList(KpiScheme kpiScheme,@RequestParam(required = false) String extId, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<EchartType> echartTypeList =  new ArrayList<EchartType>();
		List<KpiScheme> list = kpiSchemeService.findList(kpiScheme);
		if(list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				KpiScheme k = list.get(i);
				if (StringUtils.isBlank(extId) || (extId != null && !extId.equals(k.getId()) )) {
					
					Double sum = 0.0;
					KpiSchemeKpi kpiSchemeKpi = new KpiSchemeKpi();
					kpiSchemeKpi.setSchemeId(k.getId());
					List<KpiSchemeKpi> listKpi = kpiSchemeKpiService.findList(kpiSchemeKpi);
					if(listKpi.size()>0){
						for (KpiSchemeKpi kp :listKpi) {
							EchartType echartType2 = new EchartType();
							echartType2.setType(kp.getId());
							echartType2.setTypeO(kp.getSchemeId());
							echartType2.setValue(kp.getName()+":("+kp.getScore()+")");
							echartTypeList.add(echartType2);
							sum += kp.getScore();
						}
					}
					EchartType echartType = new EchartType();
					echartType.setType(k.getId());
					echartType.setTypeO("0");
					echartType.setValue(k.getName()+":("+sum+")");
					echartTypeList.add(echartType);
				}
			}
		}else{
			EchartType echartType = new EchartType();
			echartType.setType("0");
			echartType.setTypeO("0");
			echartType.setValue("暂无数据");
			echartTypeList.add(echartType);
		}
		JsonConfig config = new JsonConfig();//PingJson
		config.setExcludes(new String[]{});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String mapList = JSONArray.fromObject(echartTypeList,config).toString(); //Json
		model.addAttribute("mapList", mapList);
		return "kpi/scheme/kpiSchemeTreeList";
	}
	
	//跳转方案页面
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "formDap")
	public String formDap(KpiScheme kpiScheme, Model model) {
		model.addAttribute("kpiScheme", kpiScheme);
		return "kpi/scheme/kpiSchemeFormDap";
	}

	
	
	
	
	
	
	
	
	
	//
	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = {"list", ""})
	public String list(KpiScheme kpiScheme, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<KpiScheme> page = kpiSchemeService.findPage(new Page<KpiScheme>(request, response), kpiScheme); 
		model.addAttribute("page", page);
		return "kpi/scheme/kpiSchemeList";
	}

	@RequiresPermissions("scheme:kpiScheme:view")
	@RequestMapping(value = "form")
	public String form(KpiScheme kpiScheme, Model model) {
		model.addAttribute("kpiScheme", kpiScheme);
		return "kpi/scheme/kpiSchemeForm";
	}

	@RequiresPermissions("scheme:kpiScheme:edit")
	@RequestMapping(value = "save")
	public void save(KpiScheme kpiScheme, Model model, RedirectAttributes redirectAttributes, HttpServletResponse response) throws IOException {
		if(kpiScheme.getState()==null){
			kpiScheme.setState("0");
		}
		kpiSchemeService.save(kpiScheme);
		addMessage(redirectAttributes, "保存绩效考评方案成功");
		PrintWriter out = response.getWriter();
		out.println("<script language='javascript'>parent.location.reload();</script>");//跳转上层iframe
		out.println("<script language='javascript'>top.$.jBox.tip('保存绩效考评方案成功 ');</script>");//提示
	}
	
	@RequiresPermissions("scheme:kpiScheme:edit")
	@RequestMapping(value = "delete")
	public void delete(KpiScheme kpiScheme, RedirectAttributes redirectAttributes, HttpServletResponse response) throws IOException {
		if(kpiScheme!=null && kpiScheme.getId()!=null && kpiScheme.getId()!=""){
			KpiSchemeKpi kpiSchemeKpi = new KpiSchemeKpi();
			kpiSchemeKpi.setSchemeId(kpiScheme.getId());
			List<KpiSchemeKpi> listKpi = kpiSchemeKpiService.findList(kpiSchemeKpi);//查找KPI
			if(listKpi.size()>0){
				for(KpiSchemeKpi k :listKpi){
					KpiSchemeSubjectivity kpiSchemeSubjectivity = new KpiSchemeSubjectivity();
					kpiSchemeSubjectivity.setKpiId(k.getId());
					List<KpiSchemeSubjectivity> list = kpiSchemeSubjectivityService.findList(kpiSchemeSubjectivity);
					for(KpiSchemeSubjectivity l:list){
						kpiSchemeSubjectivityService.delete(l);//删除绩效主观评分
					}
					kpiSchemeKpiService.delete(k);//删除KPI
				}
			}
			kpiSchemeService.delete(kpiScheme);//删除方案
		}
		addMessage(redirectAttributes, "删除绩效考评方案及其绩效考评KPI成功");
		//return "redirect:"+Global.getAdminPath()+"/scheme/kpiScheme/treeList?repage";
		PrintWriter out = response.getWriter();
		out.println("<script language='javascript'>parent.location.reload();</script>");//跳转上层iframe
		out.println("<script language='javascript'>top.$.jBox.tip('删除绩效考评方案成功 ');</script>");//提示
	}

}