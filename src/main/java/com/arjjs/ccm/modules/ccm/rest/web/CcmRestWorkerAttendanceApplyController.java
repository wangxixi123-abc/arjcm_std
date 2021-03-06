/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.rest.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.attendanceapply.entity.CcmWorkerAttendanceApply;
import com.arjjs.ccm.modules.ccm.attendanceapply.service.CcmWorkerAttendanceApplyService;
import com.arjjs.ccm.modules.ccm.message.entity.CcmMessage;
import com.arjjs.ccm.modules.ccm.message.service.CcmMessageService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.rest.service.CcmRestOfficeService;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.RabbitMQTools;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import net.sf.json.JSONObject;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 加班请假申请Controller
 * @author yi
 * @version 2019-11-04
 */
@Controller
@RequestMapping(value = "${appPath}/rest/attendanceapply/ccmRestWorkerAttendanceApply")
public class CcmRestWorkerAttendanceApplyController extends BaseController {

	@Autowired
	private CcmWorkerAttendanceApplyService ccmWorkerAttendanceApplyService;
	@Autowired
	private CcmRestOfficeService restOfficeService;
	@Autowired
	private CcmMessageService ccmMessageService;

	public static final String officetotalNum = "-1";   //总部门
	public static final String officeregionNum = "2";   //区域部门


	@ModelAttribute
	public CcmWorkerAttendanceApply get(@RequestParam(required=false) String id) {
		CcmWorkerAttendanceApply entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmWorkerAttendanceApplyService.get(id);
		}
		if (entity == null){
			entity = new CcmWorkerAttendanceApply();
		}
		return entity;
	}
	
//	@RequiresPermissions("attendanceapply:ccmWorkerAttendanceApply:view")
//	@RequestMapping(value = {"list", ""})
//	public String list(CcmWorkerAttendanceApply ccmWorkerAttendanceApply, HttpServletRequest request, HttpServletResponse response, Model model) {
//		Page<CcmWorkerAttendanceApply> page = ccmWorkerAttendanceApplyService.findPage(new Page<CcmWorkerAttendanceApply>(request, response), ccmWorkerAttendanceApply);
//		model.addAttribute("page", page);
//		return "ccm/attendance/ccmWorkerAttendanceApplyList";
//	}
//
//	@RequiresPermissions("attendanceapply:ccmWorkerAttendanceApply:view")
//	@RequestMapping(value = "form")
//	public String form(CcmWorkerAttendanceApply ccmWorkerAttendanceApply, Model model) {
//		model.addAttribute("ccmWorkerAttendanceApply", ccmWorkerAttendanceApply);
//		return "ccm/attendance/ccmWorkerAttendanceApplyForm";
//	}
//
//	@RequiresPermissions("attendanceapply:ccmWorkerAttendanceApply:edit")
//	@RequestMapping(value = "save")
//	public String save(CcmWorkerAttendanceApply ccmWorkerAttendanceApply, Model model, RedirectAttributes redirectAttributes) {
//		if (!beanValidator(model, ccmWorkerAttendanceApply)){
//			return form(ccmWorkerAttendanceApply, model);
//		}
//		ccmWorkerAttendanceApplyService.save(ccmWorkerAttendanceApply);
//		addMessage(redirectAttributes, "保存加班请假申请成功");
//		return "redirect:"+Global.getAdminPath()+"/attendanceapply/ccmWorkerAttendanceApply/?repage";
//	}
//	
//	@RequiresPermissions("attendanceapply:ccmWorkerAttendanceApply:edit")
//	@RequestMapping(value = "delete")
//	public String delete(CcmWorkerAttendanceApply ccmWorkerAttendanceApply, RedirectAttributes redirectAttributes) {
//		ccmWorkerAttendanceApplyService.delete(ccmWorkerAttendanceApply);
//		addMessage(redirectAttributes, "删除加班请假申请成功");
//		return "redirect:"+Global.getAdminPath()+"/attendanceapply/ccmWorkerAttendanceApply/?repage";
//	}


	//获取列表
	@ResponseBody
	@RequestMapping(value = "/getList", method = RequestMethod.GET)
	public CcmRestResult getList(String userId,CcmWorkerAttendanceApply ccmWorkerAttendanceApply, HttpServletRequest request, HttpServletResponse response) {
		CcmRestResult result = new CcmRestResult();
		User user = UserUtils.get(userId);
		if(!user.isAdmin()){
			ccmWorkerAttendanceApply.setCurrentUser(user);
		}
		Page<CcmWorkerAttendanceApply> page = ccmWorkerAttendanceApplyService.findPage(new Page<CcmWorkerAttendanceApply>(request, response), ccmWorkerAttendanceApply);
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		return result;
	}


	@ResponseBody
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public CcmRestResult saveWechatEventAtta(String userId,CcmWorkerAttendanceApply ccmWorkerAttendanceApply){
		CcmRestResult result = new CcmRestResult();
		User user = UserUtils.get(userId);
		ccmWorkerAttendanceApply.setApplyType("1"); //待审核
		ccmWorkerAttendanceApply.setCreateBy(user);
		ccmWorkerAttendanceApply.setUpdateBy(user);
		ccmWorkerAttendanceApplyService.save(ccmWorkerAttendanceApply);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		User primaryPerson = user.getOffice().getPrimaryPerson();
		User deputyPerson = user.getOffice().getDeputyPerson();
		Set<String> sets = Sets.newHashSet();
		if(primaryPerson!=null ){
			sets.add(primaryPerson.getId());
		}
		if(deputyPerson!=null){
			sets.add(deputyPerson.getId());
		}
		Map resmap = Maps.newHashMap();
		resmap.put("type","AttendanceApplyType");
		resmap.put("name","有请假申请,请前往平台端审核!");
		resmap.put("id",userId);
		List<CcmMessage> list = new ArrayList<CcmMessage>();
		for(String id : sets){
			RabbitMQTools.sendMessage(id, JSONObject.fromObject(resmap).toString());

			CcmMessage ccmMessage = new CcmMessage();
			ccmMessage.preInsert();
			ccmMessage.setType("13");//通知

			Date createDate = ccmWorkerAttendanceApply.getCreateDate();
			String str = "MM-dd HH:mm:ss";
			SimpleDateFormat sdf = new SimpleDateFormat(str);
			ccmMessage.setContent(sdf.format(createDate)+ " 通知：有请假申请!");
			ccmMessage.setReadFlag("0");//未读
			ccmMessage.setObjId(ccmWorkerAttendanceApply.getId());
			ccmMessage.setUserId(id);
			ccmMessage.setCreateBy(user);
			ccmMessage.setUpdateBy(user);
			list.add(ccmMessage);
		}
		if(list.size()!=0) {
			ccmMessageService.insertEventAll(list);
			CcmRestEvent.sendMessageToMq(list);
		}
		return result;
	}

	//获取详情
	@ResponseBody
	@RequestMapping(value = "/getById", method = RequestMethod.GET)
	public CcmRestResult getById(String id) {
		CcmRestResult result = new CcmRestResult();
		CcmWorkerAttendanceApply entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmWorkerAttendanceApplyService.get(id);
		}
		if (entity == null){
			entity = new CcmWorkerAttendanceApply();
		}
		result.setCode(CcmRestType.OK);
		result.setResult(entity);
		return result;
	}

}