/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.web;

import com.arjjs.ccm.common.beanvalidator.BeanValidators;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.utils.excel.ImportExcel;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventCasedeal;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventCasedealService;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventIncidentService;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHousePetition;
import com.arjjs.ccm.modules.ccm.house.service.CcmHousePetitionService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.ccm.sys.entity.SysConfig;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.CommUtil;
import com.arjjs.ccm.tool.EntityTools;
import com.arjjs.ccm.tool.ExportExcel;
import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.ibatis.annotations.Param;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 重点上访人员Controller
 * @author liang
 * @version 2018-03-07
 */
@Controller
@RequestMapping(value = "${adminPath}/house/ccmHousePetition")
public class CcmHousePetitionController extends BaseController {

	@Autowired
	private CcmHousePetitionService ccmHousePetitionService;
	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@Autowired
	private CcmEventIncidentService ccmEventIncidentService;
	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;
	
	@ModelAttribute
	public CcmHousePetition get(@RequestParam(required=false) String id,@RequestParam(value = "peopleId", required = false) String peopleId) {
		CcmHousePetition entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmHousePetitionService.get(id);
		}else if(StringUtils.isNotBlank(peopleId)) {
			entity = ccmHousePetitionService.getPeopleALL(peopleId);
		}
		if (entity == null){
			entity = new CcmHousePetition();
			// 如果 peopleId 不为空 则 添加该ID
			if (StringUtils.isNotBlank(peopleId)) {
				entity.setPeopleId(peopleId);
			}
		}
		return entity;
	}
	
	
	/**
	 * 导出重点上访人员数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHousePetition:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmHousePetition ccmHousePetition, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		String [] strArr={"姓名","联系方式","人口类型","现住门（楼）详址","公民身份号码"};
		try {
			String fileName = "PetitionPeople" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";

			List<CcmHousePetition> list = new ArrayList<CcmHousePetition>();
			String permissionKey = request.getParameter("permissionKey");
			User user = UserUtils.getUser();
			if (user != null && "1".equals(user.getHasPermission())) {//有涉密权限
				list = ccmHousePetitionService.findList(ccmHousePetition);
			} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
				if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
					list = ccmHousePetitionService.findList(ccmHousePetition);
				}
			}
			
//			List<CcmHousePetition> list = ccmHousePetitionService.findList(ccmHousePetition);
			new ExportExcel("重点上访人员数据", CcmHousePetition.class,strArr).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出重点上访人员失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHousePetition/?repage";
	}
	
	
	
	
	
	
	@RequestMapping(value = {"list", ""})
	public String list(@Param("tableType")String tableType,CcmHousePetition ccmHousePetition, HttpServletRequest request, HttpServletResponse response, Model model) {
//		Page<CcmHousePetition> page = ccmHousePetitionService.findPage(new Page<CcmHousePetition>(request, response), ccmHousePetition); 
//		model.addAttribute("page", page);
		
		Page<CcmHousePetition> page = new Page();
		String permissionKey = request.getParameter("permissionKey");
		User user = UserUtils.getUser();
		if (user != null && "1".equals(user.getHasPermission()) ) {//有涉密权限
			page = ccmHousePetitionService.findPage(new Page<CcmHousePetition>(request, response), ccmHousePetition);
		} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
			if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
				page = ccmHousePetitionService.findPage(new Page<CcmHousePetition>(request, response), ccmHousePetition);
			} else {
				model.addAttribute("message", "涉密权限不正确！");
			}
		}
		model.addAttribute("page", page);
		model.addAttribute("permissionKey", permissionKey);
		if(StringUtils.isBlank(tableType)) {
			return "ccm/house/ccmHousePetitionList";
		}else {
			return "ccm/house/emphasis/ccmHousePetitionList";
		}
	}

	@RequiresPermissions("house:ccmHousePetition:view")
	@RequestMapping(value = "form")
	public String form(CcmHousePetition ccmHousePetition, Model model) {
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHousePetition.getId());
		ccmLogTailDto.setRelevanceTable("ccm_House_Petition");
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
		model.addAttribute("ccmHousePetition", ccmHousePetition);
		return "ccm/house/ccmHousePetitionForm";
		
				
	}

	@RequiresPermissions("house:ccmHousePetition:edit")
	@RequestMapping(value = "save")
	public void save(HttpServletRequest request, HttpServletResponse response, CcmHousePetition ccmHousePetition, Model model, RedirectAttributes redirectAttributes) throws IOException {
		if (!beanValidator(model, ccmHousePetition)){
//			return form(ccmHousePetition, model);
		}
		// 更新 当前人 是 上访人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHousePetition.getPeopleId());
		ccmHousePetitionService.save(ccmHousePetition,ccmPop);
		if(ccmPop!=null){
			ccmPop.setIsVisit(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存重点上访人员成功");
//		return "redirect:"+Global.getAdminPath()+"/house/ccmHousePetition/?repage";

		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存重点上访人员成功");
		ccmPop.setMqTitle("新增重点人员(重点上访人员)");
	}
	
	@RequiresPermissions("house:ccmHousePetition:edit")
	@RequestMapping(value = "delete")
	public String delete(HttpServletRequest request, CcmHousePetition ccmHousePetition, RedirectAttributes redirectAttributes) {
		ccmHousePetitionService.delete(ccmHousePetition);
		addMessage(redirectAttributes, "删除重点上访人员成功");
		// 更新 当前人不再 是  上访人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHousePetition.getPeopleId());
		String permissionKey = request.getParameter("permissionKey");
		if(ccmPop!=null){
			ccmPop.setIsVisit(0);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存重点上访人员成功");
		return "redirect:"+Global.getAdminPath()+"/house/ccmHousePetition/?repage&permissionKey=" + permissionKey;
	}
	
	
	
	//人员标记处
	@RequiresPermissions("house:ccmHousePetition:view")
	@RequestMapping(value = "specialform")
	public String specialform(CcmPeople ccmPeople, Model model) {
		model.addAttribute("ccmPeople", ccmPeople);
		CcmHousePetition petition = ccmHousePetitionService.getPeopleALL(ccmPeople.getId());
		if (petition == null){
			petition = new CcmHousePetition();
		}
		model.addAttribute("ccmHousePetition", petition);
		return "/ccm/house/pop/ccmHousePoPPetitionForm";
	}
	
	//保存+标记
	@RequiresPermissions("house:ccmHousePetition:edit")
	@RequestMapping(value = "savePop")
	public String savePop(CcmHousePetition ccmHousePetition, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmHousePetition)){
			return form(ccmHousePetition, model);
		}
		ccmHousePetitionService.save(ccmHousePetition);
		// 更新 当前人 是 上访人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHousePetition.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsVisit(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存重点上访人员成功");
		return "redirect:"+Global.getAdminPath()+"/pop/ccmPeople/?repage";
		
	}
	
	/**
	 * 导入上访人员数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHousePetition:view")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/house/ccmHousePetition/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CcmHousePetition> list = ei.getDataList(CcmHousePetition.class);
			for (CcmHousePetition HousePetition : list) {
				try {

					if(EntityTools.isEmpty(HousePetition)){
						continue;
					}
					
					// 如果当前用户的身份未填写或者为空或者身份证号码位数不够18位则应该进行 剔除
					if (StringUtils.isBlank(HousePetition.getIdent()) || HousePetition.getIdent().length() != 18) {
						failureMsg.append("<br/>实有人口名" + HousePetition.getName() + " 导入失败：" + "身份证信息错误。");
						HousePetition.setName(HousePetition.getName() + "，失败原因：身份证信息错误");
						failureNum++;
						continue;
					}
					
					CcmPeople ccmPeople=new CcmPeople();
					ccmPeople.setIdent(HousePetition.getIdent());
					List<CcmPeople> list1 = ccmPeopleService.findList(ccmPeople);
					CcmHousePetition HousePetitionFind;

					if (list1.isEmpty()){
						failureMsg.append("<br/>重点上访人员名 " + HousePetition.getName() + " 导入失败：实有人口表中无此人");
						continue;
					}else{
						ccmPeople.setId(list1.get(0).getId());
						ccmPeople.setUpdateBy(UserUtils.getUser());
						ccmPeople.setUpdateDate(new Date());
						ccmPeople.setIsVisit(1);
						ccmPeopleService.updatePeople(ccmPeople);
						HousePetitionFind=ccmHousePetitionService.getPeopleALL(list1.get(0).getId());
						BeanValidators.validateWithException(validator, HousePetition);
						if(HousePetitionFind == null){
							HousePetition.setPeopleId(list1.get(0).getId());
							ccmHousePetitionService.save(HousePetition);
							successNum++;
						}else{
							failureMsg.append("<br/>重点上访人员名 " + HousePetition.getName() + " 导入失败：记录已存在");
						}
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>重点上访人员名 " + HousePetition.getName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + HousePetition.getName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条重点上访人员，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条重点上访人员" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入重点上访人员失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHousePetition/?repage";
	}
	
	
	
	
	

}