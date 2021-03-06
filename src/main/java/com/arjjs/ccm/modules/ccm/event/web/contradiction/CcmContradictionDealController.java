/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.event.web.contradiction;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventAmbi;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventCasedeal;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventRequest;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventAmbiService;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventCasedealService;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventIncidentService;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventRequestService;
import com.arjjs.ccm.modules.pbs.sys.utils.UserUtils;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.SystemService;
import com.arjjs.ccm.tool.CommUtil;
import org.apache.ibatis.annotations.Param;
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

/**
 * 事件处理Controller
 * 
 * @author arj
 * @version 2018-01-10
 */
@Controller
@RequestMapping(value = "${adminPath}/contradiction/ccmContradictionDeal")
public class CcmContradictionDealController extends BaseController {

	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;
	@Autowired
	private CcmEventIncidentService ccmEventIncidentService;
	@Autowired
	private CcmEventAmbiService ccmEventAmbiService;
	@Autowired
	private CcmEventRequestService ccmEventRequestService;
	@Autowired
	private SystemService systemService;
	
	
	
	// ccmEventCasedeal
	@ModelAttribute
	public CcmEventCasedeal get(@RequestParam(required = false) String id,
			@RequestParam(required = false) String eventIncidentId) {
		CcmEventCasedeal entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmEventCasedealService.get(id);
		}
		if (entity == null) {
			entity = new CcmEventCasedeal();
		}
		return entity;
	}

	/**
	 * @see 返回视图列表页面
	 * @param ccmEventCasedeal 事件处理原型
	 * @param request  
	 * @param response  
	 * @param model 
	 * @return
	 */
	@RequestMapping(value = { "list", "" })
	public String list(CcmEventCasedeal ccmEventCasedeal, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		ccmEventCasedeal.setObjType("ccm_event_ambi");
		Page<CcmEventCasedeal> page = ccmEventCasedealService.findPage(new Page<CcmEventCasedeal>(request, response),
				ccmEventCasedeal);
		model.addAttribute("page", page);
		/*
		 * if("01".equals(ccmEventCasedeal.getHandleStatus())){ return
		 * "ccm/event/eventCasedeal/ccmEventCasedealUndisposedList"; }else
		 * if("02".equals(ccmEventCasedeal.getHandleStatus())) { return
		 * "ccm/event/eventCasedeal/ccmEventCasedealBeingProcessedList"; }else
		 * if("03".equals(ccmEventCasedeal.getHandleStatus())) { return
		 * "ccm/event/eventCasedeal/ccmEventCasedealProcessedList"; }else { return
		 * "ccm/event/eventCasedeal/ccmEventCasedealList"; }
		 */
		return "ccm/event/contradiction/ccmContradictiondealList"; 
	}
	
	/**
	 * @see 返回视图列表页面
	 * @param ccmEventCasedeal 事件督办处理
	 * @param request  
	 * @param response  
	 * @param model 
	 * @return
	 */
	@RequestMapping(value = "supervise")
	public String listSupervise(CcmEventCasedeal ccmEventCasedeal, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		ccmEventCasedeal.setObjType("ccm_event_ambi");
		Page<CcmEventCasedeal> page = ccmEventCasedealService.findPage(new Page<CcmEventCasedeal>(request, response),
				ccmEventCasedeal);
		model.addAttribute("page", page);
		return "ccm/event/eventCasedeal/ccmEventCasedealSuperviseList";
	}

	/**
	 * @see  添加或修改表单页面
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmContradictionDeal:view")
	@RequestMapping(value = "form")
	public String form(CcmEventCasedeal ccmEventCasedeal, Model model) {
		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
		return "ccm/event/eventCasedeal/ccmEventCasedealForm";
	}

	/**
	 * @see 返回只读页面
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
//1113	@RequiresPermissions("event:ccmEventCasedeal:viewRead")
//	@RequestMapping(value = "readform")
//	public String readform(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormOnlyRead";
//	}
	
	
	
	
	
	/**
	 * @see 导航栏路线的事件处理添加页面-只读  （通过路线案事件登记界面进入用）
	 * @param ccmEventCasedeal 线路的事件处理原型
	 * @param model
	 * @return
	 */
//1115	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "readformSDLine")
//	public String readformSDLine(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormOnlyReadLine";
//	}
	
	/**
	 * @see 导航栏师生的事件处理添加页面-只读  （通过师生案事件登记界面进入用）
	 * @param ccmEventCasedeal 师生的事件处理原型
	 * @param model
	 * @return
	 */
//1116	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "readformSDStudent")
//	public String readformSDStudent(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormOnlyReadStudent";
//	}
	
	
	
	/**
	 * @see 导航栏路线的事件处理添加页面  （通过路线案事件登记界面进入用）
	 * @param ccmEventCasedeal 线路的事件处理原型
	 * @param model
	 * @return
	 */
//1119	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformSDLine")
//	public String dealformSDLine(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventIncident/ccmEventIncidentSDFormLine";
//	}
	/**
	 * @see 导航栏师生的事件处理添加页面  （通过师生案事件登记界面进入用）
	 * @param ccmEventCasedeal 师生的事件处理原型
	 * @param model
	 * @return
	 */
//111b	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformSDStudent")
//	public String dealformSDStudent(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventIncident/ccmEventIncidentSDFormStudent";
//	}
	
	/**
	 * @see 导航栏命案的事件处理添加页面  （通过命案案事件登记界面进入用）
	 * @param ccmEventCasedeal 命案的事件处理原型
	 * @param model
	 * @return
	 */
//1110	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformSDMurder")
//	public String dealformSDMurder(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventIncident/ccmEventIncidentSDFormMurder";
//	}
	
	/**
	 * 只读
	 * @see 导航栏命案的事件处理添加页面  （通过命案案事件登记界面进入用）
	 * @param ccmEventCasedeal 命案的事件处理原型
	 * @param model
	 * @return
	 */
//111a	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "readformSDMurder")
//	public String readformSDMurder(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventIncident/ccmEventIncidentSDFormMurderRead";
//	}
	
	/**
	 * @see 返回路线的案事件登记的处理添加页面  （通过路线案事件登记界面进入用）
	 * @param ccmEventCasedeal 线路的事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmContradictionDeal:edit")
	@RequestMapping(value = "saveLine")
	public String saveLine(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
			return form(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/listLine/?repage";
	}
	/**
	 * @see 返回师生的案事件登记的处理添加页面  （通过师生案事件登记界面进入用）
	 * @param ccmEventCasedeal 师生的事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "saveStudent")
	public String saveStudent(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
			return form(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/listStudent/?repage";
	}
	
	/**
	 * @see 返回命案的案事件登记的处理添加页面  （通过命案案事件登记界面进入用）
	 * @param ccmEventCasedeal 命案的事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "saveMurder")
	public String saveMurder(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
			return form(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/listMurder/?repage";
	}
	
	/**
	 * @see 返回路线的案事件登记的处理添加页面  （通过路线案事件登记界面进入用）
	 * @param ccmEventCasedeal 线路的事件处理原型
	 * @param model
	 * @return
	 */
//1111	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformLine")
//	public String dealformLine(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormLine";
//	}
	
	/**
	 * @see 返回师生的案事件登记的处理添加页面  （通过师生案事件登记界面进入用）
	 * @param ccmEventCasedeal 师生的事件处理原型
	 * @param model
	 * @return
	 */
//1117	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformStudent")
//	public String dealformStudent(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormStudent";
//	}
	
	/**
	 * @see 返回命案的案事件登记的处理添加页面  （通过命案案事件登记界面进入用）
	 * @param ccmEventCasedeal 命案的事件处理原型
	 * @param model
	 * @return
	 */
//1112	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformMurder")
//	public String dealformMurder(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormMurder";
//	}
	
	
	/**
	 * @see 返回只读页面（通过案事件登记界面进入用）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
//1114	@RequiresPermissions("event:ccmEventCasedeal:viewRead")
//	@RequestMapping(value = "readformIncident")
//	public String readformIncident(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventCasedeal/ccmEventCasedealFormOnlyReadIncident";
//	}
	
	/**
	 * @see 返回案事件登记的处理添加页面  （通过案事件登记界面进入用）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:view")
	@RequestMapping(value = "dealform")
	public String dealform(CcmEventCasedeal ccmEventCasedeal, Model model) {
		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
		return "ccm/event/eventIncident/ccmEventIncidentSDForm";
	}
	
	/**
	 * @see 返回案事件登记的处理添加页面  （通过涉及线路的案事件登记界面进入用）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
//1118	@RequiresPermissions("event:ccmEventCasedeal:view")
//	@RequestMapping(value = "dealformIncident")
//	public String dealformIncident(CcmEventCasedeal ccmEventCasedeal, Model model) {
//		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
//		return "ccm/event/eventIncident/ccmEventIncidentSDFormIncident";
//	}

	/**
	 * @see 编辑事件处理页面
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws IOException 
	 */
	@RequiresPermissions("contradiction:ccmContradictionDeal:edit")
	@RequestMapping(value = "save")
	public void save(HttpServletRequest request,
			HttpServletResponse response, CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) throws IOException {
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		
		/**修改对应的事件状态为进行中**/
//		CcmEventCasedeal ccmEventCasedeal2 = new CcmEventCasedeal();
//		ccmEventCasedeal2.setObjType(ccmEventCasedeal.getObjType());
//		ccmEventCasedeal2.setObjId(ccmEventCasedeal.getObjId());
//		List<CcmEventCasedeal> list = ccmEventCasedealService.findList(ccmEventCasedeal2);
//		int flag = 0;
//		for(CcmEventCasedeal l:list){
//			if("03".equals(l.getHandleStatus())){
//				flag +=1;
//			}
//		}
//		if(list.size()==flag){
//			if ("ccm_event_incident".equals(ccmEventCasedeal.getObjType())) {
//				CcmEventIncident ccmEventIncident = ccmEventIncidentService.get(ccmEventCasedeal.getObjId());
//				ccmEventIncident.setStatus("03");
//				ccmEventIncidentService.save(ccmEventIncident,UserUtils.getUser());//修改案事件状态为：进行中
//			} else if ("ccm_event_ambi".equals(ccmEventCasedeal.getObjType())) {
//				CcmEventAmbi ccmEventAmbi = ccmEventAmbiService.get(ccmEventCasedeal.getObjId());
//				ccmEventAmbi.setStatus("03");
//				ccmEventAmbiService.save(ccmEventAmbi);//修改矛盾纠纷状态为：进行中
//			}else if ("ccm_event_request".equals(ccmEventCasedeal.getObjType())) {
//				CcmEventRequest ccmEventRequest = ccmEventRequestService.get(ccmEventCasedeal.getObjId());
//				ccmEventRequest.setType("03");
//				ccmEventRequestService.save(ccmEventRequest);//修改矛盾纠纷状态为：进行中
//			}
//		}
		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存成功");
	}

	/**
	 * @see 编辑事件处理页面-弹框
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws IOException 
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "saveJump")
	public void saveJump(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		//return "redirect:" + Global.getAdminPath() + "/event/ccmEventCasedeal/?repage";
	}
	
	/**
	 * @see 案事件处理通用页面  （所有处理界面可以进入）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:view")
	@RequestMapping(value = "dealformCommon")
	public String dealformCommon(CcmEventCasedeal ccmEventCasedeal, Model model) {
		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
		return "ccm/event/eventIncident/ccmEventIncidentDealForm";
	}
	
	/**
	 * @see 案事件处理通用页面  （所有处理界面可以进入）Map
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:view")
	@RequestMapping(value = "dealformCommonMap")
	public String dealformCommonMap(CcmEventCasedeal ccmEventCasedeal, Model model) {
		if(ccmEventCasedeal.getHandleUser()!=null && ccmEventCasedeal.getHandleUser().getId()!=null && !"".equals(ccmEventCasedeal.getHandleUser().getId())){
			User user = new User();
			user = systemService.getUser(ccmEventCasedeal.getHandleUser().getId());
			ccmEventCasedeal.setHandleUser(user);
		}
		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
		return "ccm/event/eventIncident/ccmEventIncidentDealFormMap";
	}

	/**
	 * @see 用于下发事件处理任务页面 （所有处理界面可以进入）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws IOException 
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "saveCasedealCommon")
	public void saveCasedealCommon(HttpServletRequest request,
			HttpServletResponse response, CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) throws IOException {
		if (!beanValidator(model, ccmEventCasedeal)) {
//			return dealform(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);

		/**修改对应的事件状态为进行中**/
		if ("ccm_event_incident".equals(ccmEventCasedeal.getObjType())) {
			CcmEventIncident ccmEventIncident = ccmEventIncidentService.get(ccmEventCasedeal.getObjId());
			ccmEventIncident.setStatus("02");
			ccmEventIncidentService.save(ccmEventIncident, UserUtils.getUser());//修改案事件状态为：进行中
		} else if ("ccm_event_ambi".equals(ccmEventCasedeal.getObjType())) {
			CcmEventAmbi ccmEventAmbi = ccmEventAmbiService.get(ccmEventCasedeal.getObjId());
			ccmEventAmbi.setStatus("02");
			ccmEventAmbiService.save(ccmEventAmbi);//修改矛盾纠纷状态为：进行中
		}else if ("ccm_event_request".equals(ccmEventCasedeal.getObjType())) {
			CcmEventRequest ccmEventRequest = ccmEventRequestService.get(ccmEventCasedeal.getObjId());
			ccmEventRequest.setType("02");
			ccmEventRequestService.save(ccmEventRequest);//修改矛盾纠纷状态为：进行中
		}
		
		addMessage(redirectAttributes, "下发事件处理任务成功");
//		return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/list?repage";
		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "下发事件处理任务成功");
	}
	
	
	/**
	 * @see 用于下发事件处理任务页面 （所有处理界面可以进入）Map
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws IOException 
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "saveCasedealCommonMap")
	public void saveCasedealCommonMap(HttpServletRequest request,
			HttpServletResponse response, CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
//			return dealform(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);

		/**修改对应的事件状态为进行中**/
		if ("ccm_event_incident".equals(ccmEventCasedeal.getObjType())) {
			CcmEventIncident ccmEventIncident = ccmEventIncidentService.get(ccmEventCasedeal.getObjId());
			ccmEventIncident.setStatus("02");
			ccmEventIncidentService.save(ccmEventIncident,UserUtils.getUser());//修改案事件状态为：进行中
		} else if ("ccm_event_ambi".equals(ccmEventCasedeal.getObjType())) {
			CcmEventAmbi ccmEventAmbi = ccmEventAmbiService.get(ccmEventCasedeal.getObjId());
			ccmEventAmbi.setStatus("02");
			ccmEventAmbiService.save(ccmEventAmbi);//修改矛盾纠纷状态为：进行中
		}else if ("ccm_event_request".equals(ccmEventCasedeal.getObjType())) {
			CcmEventRequest ccmEventRequest = ccmEventRequestService.get(ccmEventCasedeal.getObjId());
			ccmEventRequest.setType("02");
			ccmEventRequestService.save(ccmEventRequest);//修改矛盾纠纷状态为：进行中
		}
		
		//addMessage(redirectAttributes, "下发事件处理任务成功");
		//return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/list?repage";
		//PrintWriter out = response.getWriter();
		//openWinExpDiv(out, "下发事件处理任务成功");
		//out.println("<script language='javascript'>parent.layer.close(parent.layer.getFrameIndex(window.name));</script>");	//关闭jBox
	}
	
	
	


	/**
	 * @see 案事件处理通用页面  （所有处理界面可以进入）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmContradictionDeal:view")
	@RequestMapping(value = "detail")
	public String detail(CcmEventCasedeal ccmEventCasedeal, Model model) {
		model.addAttribute("ccmEventCasedeal", ccmEventCasedeal);
		return "ccm/event/eventCasedeal/ccmEventCasedealDetail";
	}

	
	/**
	 * @see 编辑案事件登记的处理添加页面内提交的内容  （通过案事件登记界面进入用）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmContradictionDeal:edit")
	@RequestMapping(value = "savedeal")
	public String savedeal(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
			return dealform(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/listLine?repage";
	}
	
	/**
	 * @see 编辑案事件登记的处理添加页面内提交的内容  （通过案事件登记界面进入用）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "saveCasedeal")
	public String saveCasedeal(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
			return dealform(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		return "redirect:" + Global.getAdminPath() + "/event/ccmEventIncident/list?repage";
	}

	/**
	 * @see 编辑案事件登记的处理添加页面内提交的内容  （通过涉及线路的案事件登记界面进入用）
	 * @param ccmEventCasedeal 事件处理原型
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmcontradictionDeal:edit")
	@RequestMapping(value = "savedealIncident")
	public String savedealIncident(CcmEventCasedeal ccmEventCasedeal, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmEventCasedeal)) {
			return dealform(ccmEventCasedeal, model);
		}
		ccmEventCasedealService.save(ccmEventCasedeal);
		addMessage(redirectAttributes, "保存事件处理成功");
		return "redirect:" + Global.getAdminPath() + "/line/ccmLineProtect/?repage";
	}
	
	/**
	 * @see  删除事件处理信息
	 * @param ccmEventCasedeal 事件处理原型
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("contradiction:ccmContradictionDeal:edit")
	@RequestMapping(value = "delete")
	public String delete(@Param("handleSta")String handleSta,CcmEventCasedeal ccmEventCasedeal, RedirectAttributes redirectAttributes) {
		ccmEventCasedealService.delete(ccmEventCasedeal);
		addMessage(redirectAttributes, "删除事件处理成功");
		if("01".equals(handleSta)){
			return "redirect:" + Global.getAdminPath() +"/event/ccmEventCasedeal/?repage&handleStatus=01";
		}else if("02".equals(handleSta)) {
			return "redirect:" + Global.getAdminPath() +"/event/ccmEventCasedeal/?repage&handleStatus=02";
		}else if("03".equals(handleSta)) {
			return "redirect:" + Global.getAdminPath() +"/event/ccmEventCasedeal/?repage&handleStatus=03";
		}else {
			return "redirect:" + Global.getAdminPath() +"/event/ccmEventCasedeal/?repage";
		}
	}
	@RequestMapping(value = "deleteSupervise")
	public String deleteSupervise(CcmEventCasedeal ccmEventCasedeal, RedirectAttributes redirectAttributes) {
		ccmEventCasedealService.delete(ccmEventCasedeal);
		addMessage(redirectAttributes, "删除事件处理成功");
		return "redirect:" + Global.getAdminPath() +"/event/ccmEventCasedeal/supervise?repage";
	}
}