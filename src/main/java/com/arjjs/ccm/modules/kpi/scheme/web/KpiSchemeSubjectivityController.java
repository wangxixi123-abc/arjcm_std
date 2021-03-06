/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.kpi.scheme.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.view.entity.VCcmTeam;
import com.arjjs.ccm.modules.ccm.view.service.VCcmTeamService;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiScheme;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiSchemeKpi;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiSchemeSubjectivity;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeKpiService;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeService;
import com.arjjs.ccm.modules.kpi.scheme.service.KpiSchemeSubjectivityService;
import com.arjjs.ccm.modules.kpi.score.entity.KpiFinalScore;
import com.arjjs.ccm.modules.kpi.score.service.KpiSchemeScoreService;
import com.arjjs.ccm.modules.sys.entity.User;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 绩效主观评分Controller
 * @author liang
 * @version 2018-04-11
 */
@Controller
@RequestMapping(value = "${adminPath}/scheme/kpiSchemeSubjectivity")
public class KpiSchemeSubjectivityController extends BaseController {

	@Autowired
	private KpiSchemeSubjectivityService kpiSchemeSubjectivityService;
	@Autowired
	private KpiSchemeKpiService kpiSchemeKpiService;
	@Autowired
	private KpiSchemeScoreService kpiSchemeScoreService;
	@Autowired
	private KpiSchemeService kpiSchemeService;
	@Autowired
	private VCcmTeamService vCcmTeamService;
	
	@ModelAttribute
	public KpiSchemeSubjectivity get(@RequestParam(required=false) String id) {
		KpiSchemeSubjectivity entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = kpiSchemeSubjectivityService.get(id);
		}
		if (entity == null){
			entity = new KpiSchemeSubjectivity();
		}
		return entity;
	}
	//考评关系
	@RequiresPermissions("scheme:kpiSchemeSubjectivity:view")
	@RequestMapping(value = "relationship")
	public String relationship(KpiSchemeSubjectivity kpiSchemeSubjectivity, HttpServletRequest request, HttpServletResponse response, Model model) {
		KpiSchemeKpi kpiSchemeKpi = new KpiSchemeKpi();
		List<KpiFinalScore> schemeUserLst = new ArrayList<KpiFinalScore>();
		KpiScheme scheme = new KpiScheme();
		if(kpiSchemeSubjectivity.getKpiId()!=null){
			kpiSchemeKpi = kpiSchemeKpiService.get(kpiSchemeSubjectivity.getKpiId());
			KpiScheme kpiScheme = new KpiScheme();
			if(kpiSchemeKpi!=null){
				kpiScheme.setId(kpiSchemeKpi.getSchemeId());
				kpiScheme = kpiSchemeService.get(kpiScheme);
				scheme = kpiScheme;//获取方案信息
				//根据方案查询方案中考核对象的信息
				schemeUserLst = kpiSchemeScoreService.getSchemeUserBySchemeID(kpiScheme);
				for(KpiFinalScore l:schemeUserLst){
					l.setKpiId(kpiSchemeKpi.getId());//写入kpi的id
					KpiSchemeSubjectivity kpiSchemeSubjectivity2 = new KpiSchemeSubjectivity();
					kpiSchemeSubjectivity2.setUserId(l.getUser());
					kpiSchemeSubjectivity2.setKpiId(kpiSchemeKpi.getId());
					List<KpiSchemeSubjectivity> KpiSchemeSubjectivityList = kpiSchemeSubjectivityService.findList(kpiSchemeSubjectivity2);
					String r = "";
					for(KpiSchemeSubjectivity k:KpiSchemeSubjectivityList){
						r += "["+k.getScorerId().getId()+","+k.getScorerId().getName()+","+k.getWeight()+"];";
					}
					l.setRemarks(r);//写入绩效主观评分
				}
			}
			
		}
		
		model.addAttribute("schemeUserLst", schemeUserLst);
		model.addAttribute("kpiSchemeKpi", kpiSchemeKpi);//获取kpi信息
		model.addAttribute("kpiScheme", scheme);//获取方案信息
		return "kpi/scheme/kpiSchemeSubjectivityRelationship";
	}
	//绩效主观评分全部保存
	@RequiresPermissions("scheme:kpiSchemeSubjectivity:edit")
	@RequestMapping(value = "saveList")
	public void saveList(KpiFinalScore kpiFinalScore, RedirectAttributes redirectAttributes) {
		KpiSchemeSubjectivity kpiSchemeSubjectivity = new KpiSchemeSubjectivity();
		kpiSchemeSubjectivity.setUserId(kpiFinalScore.getUser());//写入user
		String remarks = kpiFinalScore.getRemarks();//绩效主观评分
		String id = kpiFinalScore.getUser().getId();//被考核人id
		String kid = kpiFinalScore.getKpiId();//KPI编号
		kpiSchemeSubjectivity.setKpiId(kid);//写入kpi的id
		List<KpiSchemeSubjectivity> list = kpiSchemeSubjectivityService.findList(kpiSchemeSubjectivity);//查询同一kpi下同一被考核人的list
		for(KpiSchemeSubjectivity l:list){
			kpiSchemeSubjectivityService.deleteTrue(l);//删除同一kpi下同一被考核人的list-真删除
		}
		if(!"".equals(remarks)){
			String[] ls = remarks.split(";");
			for(int i=0;i<ls.length;i++){
				//System.out.println(ls[i]+"ppp");
				String[] lss = ls[i].substring(1, ls[i].length()-1).split(",");
				if(lss.length>0){
					String sid = lss[0];//scorer的id
					User s = new User();
					s.setId(sid);//写scorer
					Double w =Double.parseDouble(lss[2]);//权重
					KpiSchemeSubjectivity kpiSchemeSubjectivity2 = new KpiSchemeSubjectivity();
					kpiSchemeSubjectivity2.setUserId(kpiFinalScore.getUser());//写入user
					kpiSchemeSubjectivity2.setKpiId(kid);//写入kpi的id
					kpiSchemeSubjectivity2.setScorerId(s);//写入scorer
					kpiSchemeSubjectivity2.setWeight(w);//写入权重
					kpiSchemeSubjectivityService.save(kpiSchemeSubjectivity2);//保存
					//System.out.println(w+"QQQ"+sid);
				}
			}
		}else{
			//System.out.println("xxx");
			
		}
		System.out.println(remarks+"+"+id+"+"+kid);
	}
	//考评关系添加
	@RequiresPermissions("scheme:kpiSchemeSubjectivity:view")
	@RequestMapping(value = "remarksAdd")
	public String remarksAdd(KpiSchemeSubjectivity kpiSchemeSubjectivity, HttpServletRequest request, HttpServletResponse response, Model model) {
		String id = kpiSchemeSubjectivity.getId();
		String remarks = kpiSchemeSubjectivity.getRemarks();
		model.addAttribute("id", id);
		model.addAttribute("remarks", remarks);
		return "kpi/scheme/kpiSchemeSubjectivityRemarksAdd";
	}
	//相关人员List
	@RequiresPermissions("scheme:kpiSchemeSubjectivity:view")
	@RequestMapping(value = "pop")
	public String list(VCcmTeam vCcmTeam, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<VCcmTeam> list = vCcmTeamService.findList(vCcmTeam); 
		model.addAttribute("list", list);
		model.addAttribute("vCcmTeam", vCcmTeam);
		return "kpi/scheme/kpiSchemeSubjectivityPop";
	}
	
	
	
	//
	@RequiresPermissions("scheme:kpiSchemeSubjectivity:view")
	@RequestMapping(value = {"list", ""})
	public String list(KpiSchemeSubjectivity kpiSchemeSubjectivity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<KpiSchemeSubjectivity> page = kpiSchemeSubjectivityService.findPage(new Page<KpiSchemeSubjectivity>(request, response), kpiSchemeSubjectivity); 
		model.addAttribute("page", page);
		return "kpi/scheme/kpiSchemeSubjectivityList";
	}

	@RequiresPermissions("scheme:kpiSchemeSubjectivity:view")
	@RequestMapping(value = "form")
	public String form(KpiSchemeSubjectivity kpiSchemeSubjectivity, Model model) {
		model.addAttribute("kpiSchemeSubjectivity", kpiSchemeSubjectivity);
		return "kpi/scheme/kpiSchemeSubjectivityForm";
	}

	@RequiresPermissions("scheme:kpiSchemeSubjectivity:edit")
	@RequestMapping(value = "save")
	public String save(KpiSchemeSubjectivity kpiSchemeSubjectivity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, kpiSchemeSubjectivity)){
			return form(kpiSchemeSubjectivity, model);
		}
		kpiSchemeSubjectivityService.save(kpiSchemeSubjectivity);
		addMessage(redirectAttributes, "保存绩效主观评分成功");
		return "redirect:"+Global.getAdminPath()+"/scheme/kpiSchemeSubjectivity/?repage";
	}
	
	@RequiresPermissions("scheme:kpiSchemeSubjectivity:edit")
	@RequestMapping(value = "delete")
	public String delete(KpiSchemeSubjectivity kpiSchemeSubjectivity, RedirectAttributes redirectAttributes) {
		kpiSchemeSubjectivityService.delete(kpiSchemeSubjectivity);
		addMessage(redirectAttributes, "删除绩效主观评分成功");
		return "redirect:"+Global.getAdminPath()+"/scheme/kpiSchemeSubjectivity/?repage";
	}

}