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
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseDrugs;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseDrugsService;
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
 * 吸毒人口&middot;Controller
 * 
 * @author arj
 * @version 2018-01-03
 */
@Controller
@RequestMapping(value = "${adminPath}/house/ccmHouseDrugs")
public class CcmHouseDrugsController extends BaseController {

	@Autowired
	private CcmHouseDrugsService ccmHouseDrugsService;
	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@Autowired
	private CcmEventIncidentService ccmEventIncidentService;
	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;

	@ModelAttribute
	public CcmHouseDrugs get(@RequestParam(value = "id", required = false) String id,
			@RequestParam(value = "peopleId", required = false) String peopleId) {
		CcmHouseDrugs entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmHouseDrugsService.get(id);
		} else if (StringUtils.isNotBlank(peopleId)) {
			entity = ccmHouseDrugsService.getPeopleALL(peopleId);
		}
		if (entity == null) {
			entity = new CcmHouseDrugs();
			// 如果 peopleId 不为空 则 添加该ID
			if (StringUtils.isNotBlank(peopleId)) {
				entity.setPeopleId(peopleId);
			}
		}

		return entity;
	}

	@RequestMapping(value = { "list", "" })
	public String list(@Param("tableType")String tableType,CcmHouseDrugs ccmHouseDrugs, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<CcmHouseDrugs> page = new Page();
		String permissionKey = request.getParameter("permissionKey");
		User user = UserUtils.getUser();
		if (user != null && "1".equals(user.getHasPermission())) {//有涉密权限
			page = ccmHouseDrugsService.findPage(new Page<CcmHouseDrugs>(request, response), ccmHouseDrugs);
		} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
			if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
				page = ccmHouseDrugsService.findPage(new Page<CcmHouseDrugs>(request, response), ccmHouseDrugs);
			} else {
				model.addAttribute("message", "涉密权限不正确！");
			}
		}
		model.addAttribute("page", page);
		model.addAttribute("permissionKey", permissionKey);
		if(StringUtils.isBlank(tableType)) {
			return "ccm/house/ccmHouseDrugsList";
		}else {
			return "ccm/house/emphasis/ccmHouseDrugsList";
		}
	}

	@RequiresPermissions("house:ccmHouseDrugs:view")
	@RequestMapping(value = "form")
	public String form(CcmHouseDrugs ccmHouseDrugs, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHouseDrugs.getId());
		ccmLogTailDto.setRelevanceTable("ccm_house_drugs");
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
		model.addAttribute("ccmHouseDrugs", ccmHouseDrugs);
		return "ccm/house/ccmHouseDrugsForm";
	}

	@RequiresPermissions("house:ccmHouseDrugs:edit")
	@RequestMapping(value = "savePop")
	public String savePop(CcmHouseDrugs ccmHouseDrugs, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmHouseDrugs)) {
			return form(ccmHouseDrugs, model);
		}
		ccmHouseDrugsService.save(ccmHouseDrugs);
		// 更新 当前人 是 吸毒人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseDrugs.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsDrugs(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存吸毒人口成功");

		return "redirect:" + Global.getAdminPath() + "/pop/ccmPeople/?repage";
	}

	@RequiresPermissions("house:ccmHouseDrugs:edit")
	@RequestMapping(value = "save")
	public void save(HttpServletRequest request, HttpServletResponse response, 
			CcmHouseDrugs ccmHouseDrugs, Model model, RedirectAttributes redirectAttributes) throws IOException {
		if (!beanValidator(model, ccmHouseDrugs)) {
//			return form(ccmHouseDrugs, model);
		}
		// 更新 当前人 是 吸毒人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseDrugs.getPeopleId());
		ccmHouseDrugsService.save(ccmHouseDrugs,ccmPop);
		if(ccmPop!=null){
			ccmPop.setIsDrugs(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存吸毒人员成功");

//		return "redirect:" + Global.getAdminPath() + "/house/ccmHouseDrugs/?repage";

		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存吸毒人员成功");
		ccmPop.setMqTitle("新增重点人员(吸毒人员)");
	}

	@RequiresPermissions("house:ccmHouseDrugs:edit")
	@RequestMapping(value = "delete")
	public String delete(HttpServletRequest request, CcmHouseDrugs ccmHouseDrugs, RedirectAttributes redirectAttributes) {
		ccmHouseDrugsService.delete(ccmHouseDrugs);
		addMessage(redirectAttributes, "删除吸毒人员成功");
		String permissionKey = request.getParameter("permissionKey");
		// 更新 当前人 不再是 吸毒人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseDrugs.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsDrugs(0);
			ccmPeopleService.save(ccmPop);
		}
		
		return "redirect:" + Global.getAdminPath() + "/house/ccmHouseDrugs/?repage&permissionKey=" + permissionKey;
	}


	/**
	 * 导出吸毒人员数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseDrugs:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmHouseDrugs ccmHouseDrugs, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		String [] strArr={"姓名","联系方式","人口类型","现住门（楼）详址","公民身份号码","初次发现日期","管控人姓名","帮扶人联系方式","管控情况","管控人联系方式","帮扶人姓名","吸毒原因","关注程度"};
		try {
			String fileName = "DrugsPeople" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			
			List<CcmHouseDrugs> list = new ArrayList<CcmHouseDrugs>();
			String permissionKey = request.getParameter("permissionKey");
			User user = UserUtils.getUser();
			if (user != null && "1".equals(user.getHasPermission())) {//有涉密权限
				list = ccmHouseDrugsService.findList(ccmHouseDrugs);
			} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
				if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
					list = ccmHouseDrugsService.findList(ccmHouseDrugs);
				}
			}
			
//			List<CcmHouseDrugs> list = ccmHouseDrugsService.findList(ccmHouseDrugs);
			new ExportExcel("吸毒人员数据", CcmHouseDrugs.class,strArr).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出吸毒人员失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHouseDrugs/?repage";
	}

	/**
	 * 导入吸毒人员数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseDrugs:view")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/house/ccmHouseDrugs/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CcmHouseDrugs> list = ei.getDataList(CcmHouseDrugs.class);
			for (CcmHouseDrugs HouseDrugs : list) {
				try {

					if(EntityTools.isEmpty(HouseDrugs)){
						continue;
					}

					if(HouseDrugs.getFirstFound()==null ||
							StringUtils.isBlank(HouseDrugs.getContName()) ||
							StringUtils.isBlank(HouseDrugs.getHelpTl()) ||
							StringUtils.isBlank(HouseDrugs.getContSit()) ||
							StringUtils.isBlank(HouseDrugs.getContTl()) ||
							StringUtils.isBlank(HouseDrugs.getHelpName()) ||
							StringUtils.isBlank(HouseDrugs.getDrugCaus()) ||
							StringUtils.isBlank(HouseDrugs.getAtteType())

					){
						StringBuilder str = new StringBuilder();
						str.append("(");
						if(HouseDrugs.getFirstFound()==null) {
							str.append("初次发现日期信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getContName())) {
							str.append("管控人姓名信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getHelpTl())) {
							str.append("帮扶人联系方式信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getContSit())) {
							str.append("管控情况信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getContTl())) {
							str.append("管控人联系方式信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getHelpName())) {
							str.append("帮扶人姓名信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getDrugCaus())) {
							str.append("吸毒原因信息错误;");
						}
						if(StringUtils.isBlank(HouseDrugs.getAtteType())) {
							str.append("关注程度信息错误;");
						}
						str.append(")");
						failureMsg.append("<br/>吸毒人员名 " + HouseDrugs.getName() + " 导入失败：必填项为空。"+str.toString());
						continue;
					}

					// 如果当前用户的身份未填写或者为空或者身份证号码位数不够18位则应该进行 剔除
					if (StringUtils.isBlank(HouseDrugs.getIdent()) || HouseDrugs.getIdent().length() != 18) {
						failureMsg.append("<br/>实有人口名" + HouseDrugs.getName() + " 导入失败：" + "身份证信息错误。");
						HouseDrugs.setName(HouseDrugs.getName() + "，失败原因：身份证信息错误");
						failureNum++;
						continue;
					}
					
					CcmPeople ccmPeople=new CcmPeople();
					ccmPeople.setIdent(HouseDrugs.getIdent());
					List<CcmPeople> list1 = ccmPeopleService.findList(ccmPeople);
					CcmHouseDrugs HouseDrugsFind;

					if (list1.isEmpty()){
						failureMsg.append("<br/>吸毒人员名 " + HouseDrugs.getName() + " 导入失败：实有人口表中无此人");
						continue;
					}else{
						ccmPeople.setId(list1.get(0).getId());
						ccmPeople.setUpdateBy(UserUtils.getUser());
						ccmPeople.setUpdateDate(new Date());
						ccmPeople.setIsDrugs(1);
						ccmPeopleService.updatePeople(ccmPeople);
						HouseDrugsFind=ccmHouseDrugsService.getPeopleALL(list1.get(0).getId());
						HouseDrugs.setPeopleId(list1.get(0).getId());
						BeanValidators.validateWithException(validator, HouseDrugs);
						if(HouseDrugsFind == null){
							ccmHouseDrugsService.save(HouseDrugs);
							successNum++;
						}else{
							failureMsg.append("<br/>吸毒人员名 " + HouseDrugs.getName() + " 导入失败：记录已存在");
						}
					}
					
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>吸毒人员名 " + HouseDrugs.getName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + HouseDrugs.getName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条吸毒人员，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条吸毒人员" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入吸毒人员失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHouseDrugs/?repage";
	}
	 
	
}