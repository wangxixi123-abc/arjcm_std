/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.org.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgNpse;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgNpseService;
import com.arjjs.ccm.tool.CommUtil;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 其他重点Controller
 * @author wwh
 * @version 2018-01-26
 */
@Controller
@RequestMapping(value = "${adminPath}/org/ccmOrgNpseElse")
public class CcmOrgNpseElseController extends BaseController {

	@Autowired
	private CcmOrgNpseService ccmOrgNpseService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@ModelAttribute
	public CcmOrgNpse get(@RequestParam(required=false) String id) {
		CcmOrgNpse entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmOrgNpseService.get(id);
		}
		if (entity == null){
			entity = new CcmOrgNpse();
		}
		return entity;
	}
	
	@RequiresPermissions("org:ccmOrgNpseElse:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmOrgNpse ccmOrgNpse, HttpServletRequest request, HttpServletResponse response, Model model) {
		ccmOrgNpse.setCompImpoType(CommUtil.COMP_IMPO_TYPE_ELSE);
		Page<CcmOrgNpse> page = ccmOrgNpseService.findPage(new Page<CcmOrgNpse>(request, response), ccmOrgNpse); 
		model.addAttribute("page", page);
		return "ccm/org/ccmOrgNpseElseList";
	}

	@RequiresPermissions("org:ccmOrgNpseElse:view")
	@RequestMapping(value = "form")
	public String form(CcmOrgNpse ccmOrgNpse, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmOrgNpse.getId());
		ccmLogTailDto.setRelevanceTable("ccm_org_npseElse");
		ccmLogTailDto.setRelevanceTable("ccm_org_npse");
		List<CcmLogTail > ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"createBy","updateBy","currentUser","dbName","global","page","createDate","updateDate","sqlMap"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList,config).toString(); 
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());
		
		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmOrgNpse", ccmOrgNpse);
		return "ccm/org/ccmOrgNpseElseForm";
	}

	@RequiresPermissions("org:ccmOrgNpseElse:edit")
	@RequestMapping(value = "save")
	public void save(CcmOrgNpse ccmOrgNpse, Model model, RedirectAttributes redirectAttributes,HttpServletResponse response) {
		if (!beanValidator(model, ccmOrgNpse)){
			//return form(ccmOrgNpse, model);
		}
		ccmOrgNpseService.save(ccmOrgNpse);
		addMessage(redirectAttributes, "保存其他重点成功");
		//return "redirect:"+Global.getAdminPath()+"/org/ccmOrgNpseElse/?repage";
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		CommUtil.openWinExpDiv(out, "保存其他重点企业成功");
		
	}
	
	@RequiresPermissions("org:ccmOrgNpseElse:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmOrgNpse ccmOrgNpse, RedirectAttributes redirectAttributes) {
		ccmOrgNpseService.delete(ccmOrgNpse);
		addMessage(redirectAttributes, "删除其他重点成功");
		return "redirect:"+Global.getAdminPath()+"/org/ccmOrgNpseElse/?repage";
	}

}