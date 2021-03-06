/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.pbs.activity.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.pbs.activity.entity.PbsActivitysignin;
import com.arjjs.ccm.modules.pbs.activity.service.PbsActivitysigninService;

/**
 * 活动签到Controller
 * @author lc
 * @version 2018-05-15
 */
@Controller
@RequestMapping(value = "${adminPath}/activity/pbsActivitysignin")
public class PbsActivitysigninController extends BaseController {

	@Autowired
	private PbsActivitysigninService pbsActivitysigninService;
	
	@ModelAttribute
	public PbsActivitysignin get(@RequestParam(required=false) String id) {
		PbsActivitysignin entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = pbsActivitysigninService.get(id);
		}
		if (entity == null){
			entity = new PbsActivitysignin();
		}
		return entity;
	}
	
	@RequiresPermissions("activity:pbsActivitysignin:view")
	@RequestMapping(value = {"list", ""})
	public String list(PbsActivitysignin pbsActivitysignin, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PbsActivitysignin> page = pbsActivitysigninService.findPage(new Page<PbsActivitysignin>(request, response), pbsActivitysignin); 
		model.addAttribute("page", page);
		return "pbs/activity/pbsActivitysigninList";
	}

	@RequiresPermissions("activity:pbsActivitysignin:view")
	@RequestMapping(value = "form")
	public String form(PbsActivitysignin pbsActivitysignin, Model model) {
		model.addAttribute("pbsActivitysignin", pbsActivitysignin);
		return "pbs/activity/pbsActivitysigninForm";
	}

	@RequiresPermissions("activity:pbsActivitysignin:edit")
	@RequestMapping(value = "save")
	public String save(PbsActivitysignin pbsActivitysignin, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, pbsActivitysignin)){
			return form(pbsActivitysignin, model);
		}
		pbsActivitysigninService.save(pbsActivitysignin);
		addMessage(redirectAttributes, "保存活动签到成功");
		return "redirect:"+Global.getAdminPath()+"/activity/pbsActivitysignin/?repage";
	}
	
	@RequiresPermissions("activity:pbsActivitysignin:edit")
	@RequestMapping(value = "delete")
	public String delete(PbsActivitysignin pbsActivitysignin, RedirectAttributes redirectAttributes) {
		pbsActivitysigninService.delete(pbsActivitysignin);
		addMessage(redirectAttributes, "删除活动签到成功");
		return "redirect:"+Global.getAdminPath()+"/activity/pbsActivitysignin/?repage";
	}

}