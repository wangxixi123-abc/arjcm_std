/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.line.web;

import java.util.List;

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
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.line.entity.CcmLineProtect;
import com.arjjs.ccm.modules.ccm.line.service.CcmLineProtectService;
import com.arjjs.ccm.tool.EchartType;

/**
 * 护路护线Controller
 * @author arj
 * @version 2018-01-23
 */
@Controller
@RequestMapping(value = "${adminPath}/line/ccmLineProtect")
public class CcmLineProtectController extends BaseController {

	@Autowired
	private CcmLineProtectService ccmLineProtectService;
	
	@ModelAttribute
	public CcmLineProtect get(@RequestParam(required=false) String id) {
		CcmLineProtect entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmLineProtectService.get(id);
		}
		if (entity == null){
			entity = new CcmLineProtect();
		}
		return entity;
	}
	
	@RequiresPermissions("line:ccmLineProtect:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmLineProtect ccmLineProtect, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmLineProtect> page = ccmLineProtectService.findPage(new Page<CcmLineProtect>(request, response), ccmLineProtect); 
		model.addAttribute("page", page);
		return "ccm/line/ccmLineProtectList";
	}

	@RequiresPermissions("line:ccmLineProtect:view")
	@RequestMapping(value = "form")
	public String form(CcmLineProtect ccmLineProtect, Model model) {
		//查询相关案事件
		List<CcmEventIncident> ccmEventIncidentList = ccmLineProtectService.findList(ccmLineProtect.getId());
		model.addAttribute("ccmEventIncidentList", ccmEventIncidentList);
		model.addAttribute("ccmLineProtect", ccmLineProtect);
		return "ccm/line/ccmLineProtectForm";
	}

	@RequiresPermissions("line:ccmLineProtect:edit")
	@RequestMapping(value = "save")
	public String save(CcmLineProtect ccmLineProtect, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmLineProtect)){
			return form(ccmLineProtect, model);
		}
		ccmLineProtectService.save(ccmLineProtect);
		addMessage(redirectAttributes, "保存护路护线成功");
		return "redirect:"+Global.getAdminPath()+"/line/ccmLineProtect/?repage";
	}
	
	@RequiresPermissions("event:ccmEventIncident:view")
	@RequestMapping(value ="map")
	public String map(CcmLineProtect ccmLineProtect, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		//系统级别
/*		SysConfig sysConfig = new SysConfig();
		sysConfig = sysConfigService.get("system_level");
		String level = sysConfig.getParamStr();
		model.addAttribute("level", level);
		model.addAttribute("ccmEventAmbi", ccmEventAmbi);*/
		return "dma/lineprotect/dmaLineProtectMap";
	}
	
	@ResponseBody
	@RequestMapping(value = "getLineByType")
	public List<com.arjjs.ccm.tool.EchartType> getLineByType(Model model) {
	    // 返回对象结果
	    List<EchartType> list = ccmLineProtectService.getLineByType();
	    return list;
	}
	
	@ResponseBody
	@RequestMapping(value = "getLineByGrade")
	public List<com.arjjs.ccm.tool.EchartType> getLineByGrade(Model model) {
	    // 返回对象结果
	    List<EchartType> list = ccmLineProtectService.getLineByGrade();
	    return list;
	}
	
	
	@RequiresPermissions("line:ccmLineProtect:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmLineProtect ccmLineProtect, RedirectAttributes redirectAttributes) {
		ccmLineProtectService.delete(ccmLineProtect);
		addMessage(redirectAttributes, "删除护路护线成功");
		return "redirect:"+Global.getAdminPath()+"/line/ccmLineProtect/?repage";
	}

}