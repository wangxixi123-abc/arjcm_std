/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.patrollog.web;

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
import com.arjjs.ccm.modules.ccm.patrollog.entity.CcmPatrolCheck;
import com.arjjs.ccm.modules.ccm.patrollog.service.CcmPatrolCheckService;

/**
 * 巡检考评Controller
 * @author 刘永建
 * @version 2019-07-15
 */
@Controller
@RequestMapping(value = "${adminPath}/patrollog/ccmPatrolCheck")
public class CcmPatrolCheckController extends BaseController {

	@Autowired
	private CcmPatrolCheckService ccmPatrolCheckService;
	
	@ModelAttribute
	public CcmPatrolCheck get(@RequestParam(required=false) String id) {
		CcmPatrolCheck entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmPatrolCheckService.get(id);
		}
		if (entity == null){
			entity = new CcmPatrolCheck();
		}
		return entity;
	}
	
	@RequiresPermissions("patrollog:ccmPatrolCheck:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmPatrolCheck ccmPatrolCheck, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmPatrolCheck> page = ccmPatrolCheckService.findPage(new Page<CcmPatrolCheck>(request, response), ccmPatrolCheck); 
		model.addAttribute("page", page);
		return "ccm/patrollog/ccmPatrolCheckList";
	}

	@RequiresPermissions("patrollog:ccmPatrolCheck:view")
	@RequestMapping(value = "form")
	public String form(CcmPatrolCheck ccmPatrolCheck, Model model) {
		model.addAttribute("ccmPatrolCheck", ccmPatrolCheck);
		return "ccm/patrollog/ccmPatrolCheckForm";
	}

	@RequiresPermissions("patrollog:ccmPatrolCheck:edit")
	@RequestMapping(value = "save")
	public String save(CcmPatrolCheck ccmPatrolCheck, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPatrolCheck)){
			return form(ccmPatrolCheck, model);
		}
		ccmPatrolCheckService.save(ccmPatrolCheck);
		addMessage(redirectAttributes, "保存巡检考评成功");
		return "redirect:"+Global.getAdminPath()+"/patrollog/ccmPatrolCheck/?repage";
	}
	
	@RequiresPermissions("patrollog:ccmPatrolCheck:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmPatrolCheck ccmPatrolCheck, RedirectAttributes redirectAttributes) {
		ccmPatrolCheckService.delete(ccmPatrolCheck);
		addMessage(redirectAttributes, "删除巡检日志成功");
		return "redirect:"+Global.getAdminPath()+"/patrollog/ccmPatrolLog/?repage";
	}

}