/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.attendance.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.utils.excel.ExportExcel;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.attendance.entity.CcmWorkerAttendance;
import com.arjjs.ccm.modules.ccm.attendance.service.CcmWorkerAttendanceService;
import com.arjjs.ccm.modules.ccm.attendanceapply.entity.CcmWorkerAttendanceApply;
import com.arjjs.ccm.modules.ccm.attendanceapply.service.CcmWorkerAttendanceApplyService;
import com.arjjs.ccm.modules.pbs.sys.utils.UserUtils;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.tool.CommUtil;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 社工考勤登记Controller
 * @author yiqingxuan
 * @version 2019-06-18
 */
@Controller
@RequestMapping(value = "${adminPath}/attendance/ccmWorkerAttendance")
public class CcmWorkerAttendanceController extends BaseController {

	@Autowired
	private CcmWorkerAttendanceService ccmWorkerAttendanceService;

	@Autowired
	private CcmWorkerAttendanceApplyService ccmWorkerAttendanceApplyService;

	@ModelAttribute
	public CcmWorkerAttendance get(@RequestParam(required=false) String id) {
		CcmWorkerAttendance entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmWorkerAttendanceService.get(id);
		}
		if (entity == null){
			entity = new CcmWorkerAttendance();
		}
		return entity;
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmWorkerAttendance ccmWorkerAttendance, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmWorkerAttendance> page = ccmWorkerAttendanceService.findPage(new Page<CcmWorkerAttendance>(request, response), ccmWorkerAttendance); 
		model.addAttribute("page", page);
		return "ccm/attendance/ccmWorkerAttendanceList";
	}

	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = "form")
	public String form(CcmWorkerAttendance ccmWorkerAttendance, Model model) {
		model.addAttribute("ccmWorkerAttendance", ccmWorkerAttendance);
		return "ccm/attendance/ccmWorkerAttendanceForm";
	}

	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "save")
	public String save(CcmWorkerAttendance ccmWorkerAttendance, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmWorkerAttendance)){
			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		addMessage(redirectAttributes, "保存社工考勤登记成功");
		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/?repage";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmWorkerAttendance ccmWorkerAttendance, RedirectAttributes redirectAttributes,String deleteType) {
		ccmWorkerAttendanceService.delete(ccmWorkerAttendance);
		addMessage(redirectAttributes, "删除社工考勤登记成功");
		if("1".equals(deleteType)){
			return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/gooutlist?repage";
		}
		if("2".equals(deleteType)){
			return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/leavelist?repage";
		}else if("3".equals(deleteType)){
			return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/workingtimelist?repage";
		}
		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/?repage";
	}

	
	/**
	 * 
	 * @Title: list
	 * @Description : 外出登记
	 * @author：
	 * @date： 2019年6月19日上午10:17:25
	 * @param ccmWorkerAttendance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = {"gooutlist"})
	public String gooutlist(CcmWorkerAttendance ccmWorkerAttendance, HttpServletRequest request, HttpServletResponse response, Model model) {
		ccmWorkerAttendance.setType("1");
		Page<CcmWorkerAttendance> page = ccmWorkerAttendanceService.findPage(new Page<CcmWorkerAttendance>(request, response), ccmWorkerAttendance); 
		model.addAttribute("page", page);
		return "ccm/attendance/ccmWorkerAttendanceGooutList";
	}

	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = "gooutform")
	public String gooutform(CcmWorkerAttendance ccmWorkerAttendance, Model model) {
		model.addAttribute("ccmWorkerAttendance", ccmWorkerAttendance);
		return "ccm/attendance/ccmWorkerAttendanceGooutForm";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "gooutsave")
	public void gooutsave(CcmWorkerAttendance ccmWorkerAttendance, Model model,HttpServletResponse response) {
		if (!beanValidator(model, ccmWorkerAttendance)){
//			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendance.setType("1");
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		PrintWriter out = null;
		try {
			out = response.getWriter();
			CommUtil.openWinExpDiv(out, "保存外出登记成功");
		} catch (IOException e) {
			e.printStackTrace();
		}
//		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/gooutlist?repage";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "gooutupdate")
	public String gooutupdate(CcmWorkerAttendance ccmWorkerAttendance, Model model,HttpServletResponse response) {
		if (!beanValidator(model, ccmWorkerAttendance)){
			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendance.setType("1");
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/gooutlist?repage";
	}
	
	/**
	 * 
	 * @Title: leavelist
	 * @Description : 请假登记
	 * @author：
	 * @date： 2019年6月19日上午10:19:43
	 * @param ccmWorkerAttendance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = {"leavelist"})
	public String leavelist(CcmWorkerAttendance ccmWorkerAttendance, HttpServletRequest request, HttpServletResponse response, Model model) {
		ccmWorkerAttendance.setType("2");
		Page<CcmWorkerAttendance> page = ccmWorkerAttendanceService.findPage(new Page<CcmWorkerAttendance>(request, response), ccmWorkerAttendance);
		if(page.getList().size()>0){
			for(CcmWorkerAttendance res : page.getList()){
				if(StringUtils.isNotEmpty(res.getApplyId())){
					CcmWorkerAttendanceApply ccmWorkerAttendanceApply = ccmWorkerAttendanceApplyService.get(res.getApplyId());
					User user = UserUtils.get(ccmWorkerAttendanceApply.getCreateBy().getId());
					if(user!=null) {
						res.setCreateByname(user.getName());
						res.setCreateBy(user);
					}else {
						continue;
					}
				}
			}
		}
		model.addAttribute("page", page);
		return "ccm/attendance/ccmWorkerAttendanceLeaveList";
	}

	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = "leaveform")
	public String leaveform(CcmWorkerAttendance ccmWorkerAttendance, Model model) {
		model.addAttribute("ccmWorkerAttendance", ccmWorkerAttendance);
		return "ccm/attendance/ccmWorkerAttendanceLeaveForm";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "leavesave")
	public void leavesave(CcmWorkerAttendance ccmWorkerAttendance, Model model,HttpServletResponse response) {
		if (!beanValidator(model, ccmWorkerAttendance)){
//			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendance.setType("2");
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		PrintWriter out = null;
		try {
			out = response.getWriter();
			CommUtil.openWinExpDiv(out, "保存请假登记成功");
		} catch (IOException e) {
			e.printStackTrace();
		}
//		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/leavelist?repage";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "leaveupdate")
	public String leaveupdate(CcmWorkerAttendance ccmWorkerAttendance, Model model,HttpServletResponse response) {
		if (!beanValidator(model, ccmWorkerAttendance)){
			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendance.setType("2");
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/leavelist?repage";
	}
	
	/**
	 * 
	 * @Title: workingtimelist
	 * @Description : 加班登记
	 * @author：
	 * @date： 2019年6月19日上午10:20:34
	 * @param ccmWorkerAttendance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = {"workingtimelist"})
	public String workingtimelist(CcmWorkerAttendance ccmWorkerAttendance, HttpServletRequest request, HttpServletResponse response, Model model) {
		ccmWorkerAttendance.setType("3");
		Page<CcmWorkerAttendance> page = ccmWorkerAttendanceService.findPage(new Page<CcmWorkerAttendance>(request, response), ccmWorkerAttendance);
		if(page.getList().size()>0){
			for(CcmWorkerAttendance res : page.getList()){
				if(StringUtils.isNotEmpty(res.getApplyId())){
					CcmWorkerAttendanceApply ccmWorkerAttendanceApply = ccmWorkerAttendanceApplyService.get(res.getApplyId());
					User user = UserUtils.get(ccmWorkerAttendanceApply.getCreateBy().getId());
					if(user!=null) {
						res.setCreateByname(user.getName());
						res.setCreateBy(user);
					}else {
						
					}
				}
			}
		}
		model.addAttribute("page", page);
		return "ccm/attendance/ccmWorkerAttendanceWorkingTimeList";
	}

	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = "workingtimeform")
	public String workingtimeform(CcmWorkerAttendance ccmWorkerAttendance, Model model) {
		model.addAttribute("ccmWorkerAttendance", ccmWorkerAttendance);
		return "ccm/attendance/ccmWorkerAttendanceWorkingTimeForm";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "workingtimesave")
	public void workingtimesave(CcmWorkerAttendance ccmWorkerAttendance, Model model , HttpServletResponse response) {
		if (!beanValidator(model, ccmWorkerAttendance)){
//			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendance.setType("3");
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		PrintWriter out = null;
		try {
			out = response.getWriter();
			CommUtil.openWinExpDiv(out, "保存加班登记成功");
		} catch (IOException e) {
			e.printStackTrace();
		}
//		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/workingtimelist?repage";
	}
	
	@RequiresPermissions("attendance:ccmWorkerAttendance:edit")
	@RequestMapping(value = "workingtimeupdate")
	public String workingtimeupdate(CcmWorkerAttendance ccmWorkerAttendance, Model model , HttpServletResponse response) {
		if (!beanValidator(model, ccmWorkerAttendance)){
			return form(ccmWorkerAttendance, model);
		}
		ccmWorkerAttendance.setType("3");
		ccmWorkerAttendanceService.save(ccmWorkerAttendance);
		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/workingtimelist?repage";
	}
	
	/**
	 * 
	 * @Title: getcount
	 * @Description : 统计报表查询
	 * @author：
	 * @date： 2019年6月19日下午3:27:10
	 * @param ccmWorkerAttendance
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = {"getcount"})
	public String getcount(CcmWorkerAttendance ccmWorkerAttendance, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmWorkerAttendance> page = ccmWorkerAttendanceService.getcountPage(new Page<CcmWorkerAttendance>(request, response), ccmWorkerAttendance); 
		model.addAttribute("page", page);
		return "ccm/attendance/ccmWorkerAttendanceList";
	}
	
	
	/**
	 * 
	 * @Title: exportFile
	 * @Description : 考勤统计导出
	 * @author：
	 * @date： 2019年6月19日下午6:23:13
	 * @param ccmWorkerAttendance
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("attendance:ccmWorkerAttendance:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmWorkerAttendance ccmWorkerAttendance, HttpServletRequest request,HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "考勤统计" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<CcmWorkerAttendance> list = ccmWorkerAttendanceService.getcountexport(ccmWorkerAttendance);
			System.out.println(list.size());
			new ExportExcel("考勤统计", CcmWorkerAttendance.class).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出考勤统计数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/attendance/ccmWorkerAttendance/getcount?repage";
	}
	
}