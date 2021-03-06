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
import com.arjjs.ccm.modules.ccm.event.service.CcmEventCasedealService;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventIncidentService;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHousePsychogeny;
import com.arjjs.ccm.modules.ccm.house.service.CcmHousePsychogenyService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.sys.entity.Dict;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.DictService;
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
 * 肇事肇祸等严重精神障碍患者Controller
 * 
 * @author arj
 * @version 2018-01-05
 */
@Controller
@RequestMapping(value = "${adminPath}/house/ccmHousePsychogeny")
public class CcmHousePsychogenyController extends BaseController {

	@Autowired
	private CcmHousePsychogenyService ccmHousePsychogenyService;
	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@Autowired
	private CcmEventIncidentService ccmEventIncidentService;
	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;
	@Autowired
	private DictService dictService;

	@ModelAttribute
	public CcmHousePsychogeny get(@RequestParam(value = "id", required = false) String id,
			@RequestParam(value = "peopleId", required = false) String peopleId) {
		CcmHousePsychogeny entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmHousePsychogenyService.get(id);
		} else if (StringUtils.isNotBlank(peopleId)) {
			entity = ccmHousePsychogenyService.getPeopleALL(peopleId);
		}
		if (entity == null) {
			entity = new CcmHousePsychogeny();
			// 如果 peopleId 不为空 则 添加该ID
			if (StringUtils.isNotBlank(peopleId)) {
				entity.setPeopleId(peopleId);
			}
		}
		return entity;
	}

	@RequestMapping(value = { "list", "" })
	public String list(@Param("tableType")String tableType,CcmHousePsychogeny ccmHousePsychogeny, HttpServletRequest request, HttpServletResponse response,
			Model model) {
//		Page<CcmHousePsychogeny> page = ccmHousePsychogenyService
//				.findPage(new Page<CcmHousePsychogeny>(request, response), ccmHousePsychogeny);
//		model.addAttribute("page", page);

		Page<CcmHousePsychogeny> page = new Page();
		String permissionKey = request.getParameter("permissionKey");
		User user = UserUtils.getUser();
		if (user != null && "1".equals(user.getHasPermission()) ) {//有涉密权限
			page = ccmHousePsychogenyService.findPage(new Page<CcmHousePsychogeny>(request, response), ccmHousePsychogeny);
		} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
			if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
				page = ccmHousePsychogenyService.findPage(new Page<CcmHousePsychogeny>(request, response), ccmHousePsychogeny);
			} else {
				model.addAttribute("message", "涉密权限不正确！");
			}
		}
		model.addAttribute("page", page);
		model.addAttribute("permissionKey", permissionKey);
		if(StringUtils.isBlank(tableType)) {
			return "ccm/house/ccmHousePsychogenyList";
		}else {
			return "ccm/house/emphasis/ccmHousePsychogenyList";
		}
	}

	@RequiresPermissions("house:ccmHousePsychogeny:view")
	@RequestMapping(value = "form")
	public String form(CcmHousePsychogeny ccmHousePsychogeny, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHousePsychogeny.getId());
		ccmLogTailDto.setRelevanceTable("ccm_house_psychogeny");
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
		model.addAttribute("ccmHousePsychogeny", ccmHousePsychogeny);
		return "ccm/house/ccmHousePsychogenyForm";
	}

	@RequiresPermissions("house:ccmHousePsychogeny:edit")
	@RequestMapping(value = "save")
	public void save(HttpServletRequest request, HttpServletResponse response, CcmHousePsychogeny ccmHousePsychogeny, Model model, RedirectAttributes redirectAttributes) throws IOException {
		if (!beanValidator(model, ccmHousePsychogeny)) {
//			return form(ccmHousePsychogeny, model);
		}
		// 更新 当前人 是 肇事肇祸等严重精神障碍患者
		CcmPeople ccmPop = ccmPeopleService.get(ccmHousePsychogeny.getPeopleId());
		ccmHousePsychogenyService.save(ccmHousePsychogeny,ccmPop);

		if(ccmPop!=null){
			ccmPop.setIsPsychogeny(1);
			ccmPeopleService.save(ccmPop);
		}
		addMessage(redirectAttributes, "保存肇事肇祸等严重精神障碍患者成功");
//		return "redirect:" + Global.getAdminPath() + "/house/ccmHousePsychogeny/?repage";

		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存肇事肇祸等严重精神障碍患者成功");
		ccmPop.setMqTitle("新增重点人员(肇事肇祸等严重精神障碍患者)");
	}

	@RequiresPermissions("house:ccmHousePsychogeny:edit")
	@RequestMapping(value = "delete")
	public String delete(HttpServletRequest request, CcmHousePsychogeny ccmHousePsychogeny, RedirectAttributes redirectAttributes) {
		ccmHousePsychogenyService.delete(ccmHousePsychogeny);
		CcmPeople ccmPop = ccmPeopleService.get(ccmHousePsychogeny.getPeopleId());
		String permissionKey = request.getParameter("permissionKey");
		if(ccmPop!=null){
			ccmPop.setIsPsychogeny(0);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "删除肇事肇祸等严重精神障碍患者成功");
		return "redirect:" + Global.getAdminPath() + "/house/ccmHousePsychogeny/?repage&permissionKey=" + permissionKey;
	}

	@RequiresPermissions("house:ccmHousePsychogeny:edit")
	@RequestMapping(value = "savePop")
	public String savePop(CcmHousePsychogeny ccmHousePsychogeny, Model model,
			RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmHousePsychogeny)) {
			return form(ccmHousePsychogeny, model);
		}
		ccmHousePsychogenyService.save(ccmHousePsychogeny);
		// 更新 当前人 是 肇事肇祸等严重精神障碍患者
		CcmPeople ccmPop = ccmPeopleService.get(ccmHousePsychogeny.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsPsychogeny(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存肇事肇祸等严重精神障碍患者成功");

		return "redirect:" + Global.getAdminPath() + "/pop/ccmPeople/?repage";
	}

	@RequiresPermissions("house:ccmHousePsychogeny:view")
	@RequestMapping(value = "specialform")
	public String specialform(CcmPeople ccmPeople, Model model) {
		model.addAttribute("ccmPeople", ccmPeople);
		CcmHousePsychogeny psychogeny = ccmHousePsychogenyService.getPeopleALL(ccmPeople.getId());
		if (psychogeny == null) {
			psychogeny = new CcmHousePsychogeny();
		}
		model.addAttribute("ccmHousePsychogeny", psychogeny);
		return "/ccm/house/pop/ccmHousePoPPsychogenyForm";
	}
	
	/**
	 * 导出肇事肇祸等严重精神障碍患者数据
	 * 
	 * @param ccmHousePsychogeny
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHousePsychogeny:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmHousePsychogeny ccmHousePsychogeny, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		String [] strArr={"姓名","联系方式","人口类型","现住门（楼）详址","公民身份号码","家庭经济状况","监护人联系方式","目前诊断类型","目前危险性评估等级","是否纳入低保","监护人姓名","治疗情况","关注程度"};
		try {
			String fileName = "PsychogenyPeople" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";

			List<CcmHousePsychogeny> list = new ArrayList<CcmHousePsychogeny>();
			String permissionKey = request.getParameter("permissionKey");
			User user = UserUtils.getUser();
			if (user != null && "1".equals(user.getHasPermission())) {//有涉密权限
				list = ccmHousePsychogenyService.findList(ccmHousePsychogeny);
			} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
				if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
					list = ccmHousePsychogenyService.findList(ccmHousePsychogeny);
				}
			}
			//将多选字段转为字典了label
			Dict dict = new Dict();
			dict.setType("ccm_hosl_cause");
			List<Dict> hospReasonList = dictService.findList(dict);
			dict.setType("ccm_parp_mang");
			List<Dict> managementList = dictService.findList(dict);
			dict.setType("ccm_supp_case");
			List<Dict> helpcaseList = dictService.findList(dict);
			for (CcmHousePsychogeny ccmHousePsychogeny2 : list) {
				String[] hospres = ccmHousePsychogeny2.getHospReason().split(",");
				StringBuilder str1 = new StringBuilder();
				for(int i=0;i<hospReasonList.size();i++) {
					for(int j=0;j<hospres.length;j++) {
						if(hospReasonList.get(i).getValue().equals(hospres[j])) {
							str1.append(","+hospReasonList.get(i).getLabel());
						}
					}
				}
				str1.append(",");
				ccmHousePsychogeny2.setHospReason(str1.toString());
				
				String[] manage = ccmHousePsychogeny2.getManagement().split(",");
				StringBuilder str2 = new StringBuilder();
				for(int i=0;i<managementList.size();i++) {
					for(int j=0;j<manage.length;j++) {
						if(managementList.get(i).getValue().equals(manage[j])) {
							str2.append(","+managementList.get(i).getLabel());
						}
					}
				}
				str2.append(",");
				ccmHousePsychogeny2.setManagement(str2.toString());
				
				String[] help = ccmHousePsychogeny2.getHelpcase().split(",");
				StringBuilder str3 = new StringBuilder();
				for(int i=0;i<helpcaseList.size();i++) {
					for(int j=0;j<help.length;j++) {
						if(helpcaseList.get(i).getValue().equals(help[j])) {
							str3.append(","+helpcaseList.get(i).getLabel());
						}
					}
				}
				str3.append(",");
				ccmHousePsychogeny2.setHelpcase(str3.toString());
 			}
//			List<CcmHousePsychogeny> list = ccmHousePsychogenyService.findList(ccmHousePsychogeny);
			new ExportExcel("肇事肇祸等严重精神障碍患者数据", CcmHousePsychogeny.class,strArr).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出肇事肇祸等严重精神障碍患者失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHousePsychogeny/?repage";
	}

	/**
	 * 导入肇事肇祸等严重精神障碍患者数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHousePsychogeny:view")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/pop/ccmPeople/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CcmHousePsychogeny> list = ei.getDataList(CcmHousePsychogeny.class);
			//将多选字段转为字典了label
			Dict dict = new Dict();
			dict.setType("ccm_hosl_cause");
			List<Dict> hospReasonList = dictService.findList(dict);
			dict.setType("ccm_parp_mang");
			List<Dict> managementList = dictService.findList(dict);
			dict.setType("ccm_supp_case");
			List<Dict> helpcaseList = dictService.findList(dict);
			for (CcmHousePsychogeny HousePsychogeny : list) {
				try {

					if(EntityTools.isEmpty(HousePsychogeny)){
						continue;
					}
					
					if(StringUtils.isBlank(HousePsychogeny.getEconomic()) ||
							StringUtils.isBlank(HousePsychogeny.getGuarTel()) ||
							HousePsychogeny.getDiagType()==null||
							StringUtils.isBlank(HousePsychogeny.getDangAsse()) ||
							HousePsychogeny.getAllowance()==null ||
							StringUtils.isBlank(HousePsychogeny.getGuarName()) ||
							HousePsychogeny.getTreaCond()==null ||
							StringUtils.isBlank(HousePsychogeny.getAtteType())
					){
						StringBuilder str = new StringBuilder();
						str.append("(");
						if(StringUtils.isBlank(HousePsychogeny.getEconomic())) {
							str.append("家庭经济状况信息错误;");
						}
						if(StringUtils.isBlank(HousePsychogeny.getGuarTel())) {
							str.append("监护人联系方式信息错误;");
						}
						if(HousePsychogeny.getDiagType()==null) {
							str.append("目前诊断类型信息错误;");
						}
						if(StringUtils.isBlank(HousePsychogeny.getDangAsse())) {
							str.append("目前危险性评估等级信息错误;");
						}
						if(HousePsychogeny.getAllowance()==null) {
							str.append("是否纳入低保信息错误;");
						}
						if(StringUtils.isBlank(HousePsychogeny.getGuarName())) {
							str.append("社区矫正人员编号信息错误;");
						}
						if(HousePsychogeny.getTreaCond()==null) {
							str.append("监护人姓名信息错误;");
						}
						if(StringUtils.isBlank(HousePsychogeny.getAtteType())) {
							str.append("关注程度信息错误;");
						}
						str.append(")");
						failureMsg.append("<br/>肇事肇祸等严重精神障碍患者名 " + HousePsychogeny.getName() + " 导入失败：必填项为空。"+str.toString());
						continue;
					}
					
					if(StringUtils.isNotEmpty(HousePsychogeny.getHospReason())) {
						String[] hospres = HousePsychogeny.getHospReason().split(",");
						StringBuilder str1 = new StringBuilder();
						for(int i=0;i<hospReasonList.size();i++) {
							for(int j=0;j<hospres.length;j++) {
								if(hospReasonList.get(i).getLabel().equals(hospres[j])) {
									str1.append(","+hospReasonList.get(i).getValue());
								}
							}
						}
						str1.append(",");
						HousePsychogeny.setHospReason(str1.toString());
					}
					
					if(StringUtils.isNotEmpty(HousePsychogeny.getManagement())) {
						String[] manage = HousePsychogeny.getManagement().split(",");
						StringBuilder str2 = new StringBuilder();
						for(int i=0;i<managementList.size();i++) {
							for(int j=0;j<manage.length;j++) {
								if(managementList.get(i).getLabel().equals(manage[j])) {
									str2.append(","+managementList.get(i).getValue());
								}
							}
						}
						str2.append(",");
						HousePsychogeny.setManagement(str2.toString());
					}
					
					if(StringUtils.isNotEmpty(HousePsychogeny.getHelpcase())) {
						String[] help = HousePsychogeny.getHelpcase().split(",");
						StringBuilder str3 = new StringBuilder();
						for(int i=0;i<helpcaseList.size();i++) {
							for(int j=0;j<help.length;j++) {
								if(helpcaseList.get(i).getLabel().equals(help[j])) {
									str3.append(","+helpcaseList.get(i).getValue());
								}
							}
						}
						str3.append(",");
						HousePsychogeny.setHelpcase(str3.toString());
					}
					
					// 如果当前用户的身份未填写或者为空或者身份证号码位数不够18位则应该进行 剔除
					if (StringUtils.isBlank(HousePsychogeny.getIdent()) || HousePsychogeny.getIdent().length() != 18) {
						failureMsg.append("<br/>实有人口名" + HousePsychogeny.getName() + " 导入失败：" + "身份证信息错误。");
						HousePsychogeny.setName(HousePsychogeny.getName() + "，失败原因：身份证信息错误");
						failureNum++;
						continue;
					}
					
					CcmPeople ccmPeople = new CcmPeople();
					ccmPeople.setIdent(HousePsychogeny.getIdent());
					List<CcmPeople> list1 = ccmPeopleService.findList(ccmPeople);
					CcmHousePsychogeny HousePsychogenyFind;

					if (list1.isEmpty()) {
						failureMsg.append("<br/>肇事肇祸等严重精神障碍患者名 " + HousePsychogeny.getName() + " 导入失败：实有人口表中无此人");
						continue;
					} else {
						ccmPeople.setId(list1.get(0).getId());
						ccmPeople.setUpdateBy(UserUtils.getUser());
						ccmPeople.setUpdateDate(new Date());
						ccmPeople.setIsPsychogeny(1);
						ccmPeopleService.updatePeople(ccmPeople);
						HousePsychogenyFind = ccmHousePsychogenyService.getPeopleALL(list1.get(0).getId());
						BeanValidators.validateWithException(validator, HousePsychogeny);
						if(HousePsychogenyFind == null){
							HousePsychogeny.setPeopleId(list1.get(0).getId());
							ccmHousePsychogenyService.save(HousePsychogeny);
							successNum++;
						}else{
							failureMsg.append("<br/>肇事肇祸等严重精神障碍患者名 " + HousePsychogeny.getName() + " 导入失败：记录已存在");
						}
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>肇事肇祸等严重精神障碍患者名 " + HousePsychogeny.getName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + HousePsychogeny.getName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条肇事肇祸等严重精神障碍患者，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条肇事肇祸等严重精神障碍患者" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入肇事肇祸等严重精神障碍患者失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHousePsychogeny/?repage";
	}
	 

}