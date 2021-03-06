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
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseDangerous;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseDangerousService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.ccm.sys.service.SysConfigService;
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
 * 危险品从业人员Controller
 * @author liang
 * @version 2018-03-07
 */
@Controller
@RequestMapping(value = "${adminPath}/house/ccmHouseDangerous")
public class CcmHouseDangerousController extends BaseController {

	@Autowired
	private CcmHouseDangerousService ccmHouseDangerousService;
	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@Autowired
	private CcmEventIncidentService ccmEventIncidentService;
	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;
	@Autowired
	private SysConfigService sysConfigService;

	@ModelAttribute
	public CcmHouseDangerous get(@RequestParam(required=false) String id,@RequestParam(value = "peopleId", required = false) String peopleId) {
		CcmHouseDangerous entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmHouseDangerousService.get(id);
		}else if (StringUtils.isNotBlank(peopleId)) {
			entity = ccmHouseDangerousService.getPeopleALL(peopleId);
		}
		if (entity == null){
			entity = new CcmHouseDangerous();
			if (StringUtils.isNotBlank(peopleId)) {
				entity.setPeopleId(peopleId);
			}
		}
		return entity;
	}
	
	@RequestMapping(value = {"list", ""})
	public String list(@Param("tableType")String tableType,CcmHouseDangerous ccmHouseDangerous, HttpServletRequest request, HttpServletResponse response, Model model) {
//		Page<CcmHouseDangerous> page = ccmHouseDangerousService.findPage(new Page<CcmHouseDangerous>(request, response), ccmHouseDangerous); 
//		model.addAttribute("page", page);
//		

		Page<CcmHouseDangerous> page = new Page();
		String permissionKey = request.getParameter("permissionKey");
		User user = UserUtils.getUser();
		if (user != null && "1".equals(user.getHasPermission()) ) {//有涉密权限
			page = ccmHouseDangerousService.findPage(new Page<CcmHouseDangerous>(request, response), ccmHouseDangerous);
		} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
			if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
				page = ccmHouseDangerousService.findPage(new Page<CcmHouseDangerous>(request, response), ccmHouseDangerous);
			} else {
				model.addAttribute("message", "涉密权限不正确！");
			}
		}
		model.addAttribute("page", page);
		model.addAttribute("permissionKey", permissionKey);
		if(StringUtils.isBlank(tableType)) {
			return "ccm/house/ccmHouseDangerousList";
		}else {
			return "ccm/house/emphasis/ccmHouseDangerousList";
		}
	}

	@RequiresPermissions("house:ccmHouseDangerous:view")
	@RequestMapping(value = "form")
	public String form(CcmHouseDangerous ccmHouseDangerous, Model model) {
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHouseDangerous.getId());
		ccmLogTailDto.setRelevanceTable("ccm_House_Dangerous");
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
		model.addAttribute("ccmHouseDangerous", ccmHouseDangerous);
		return "ccm/house/ccmHouseDangerousForm";
	}

	@RequiresPermissions("house:ccmHouseDangerous:edit")
	@RequestMapping(value = "save")
	public void save(HttpServletRequest request, HttpServletResponse response, CcmHouseDangerous ccmHouseDangerous, Model model, RedirectAttributes redirectAttributes) throws IOException {
		if (!beanValidator(model, ccmHouseDangerous)){
//			return form(ccmHouseDangerous, model);
		}
		// 更新 当前人 是 危险品从业人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseDangerous.getPeopleId());
		ccmHouseDangerousService.save(ccmHouseDangerous,ccmPop);
		if(ccmPop!=null){
			ccmPop.setIsDangerous(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存危险品从业人员成功");
//		return "redirect:"+Global.getAdminPath()+"/house/ccmHouseDangerous/?repage";

		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存危险品从业人员成功");
		ccmPop.setMqTitle("新增重点人员(危险品从业人员)");
	}
	
	@RequiresPermissions("house:ccmHouseDangerous:edit")
	@RequestMapping(value = "delete")
	public String delete(HttpServletRequest request, CcmHouseDangerous ccmHouseDangerous, RedirectAttributes redirectAttributes) {
		ccmHouseDangerousService.delete(ccmHouseDangerous);
		addMessage(redirectAttributes, "删除危险品从业人员成功");
		// 更新 当前人不再 是危险品从业人员
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseDangerous.getPeopleId());
		String permissionKey = request.getParameter("permissionKey");
		if(ccmPop!=null){
			ccmPop.setIsDangerous(0);
			ccmPeopleService.save(ccmPop);
		}

		addMessage(redirectAttributes, "保存危险品从业人员成功");

		return "redirect:"+Global.getAdminPath()+"/house/ccmHouseDangerous/?repage&permissionKey=" + permissionKey;
	}
	
	
	//人员标记处
		@RequiresPermissions("house:ccmHouseDangerous:view")
		@RequestMapping(value = "specialform")
		public String specialform(CcmPeople ccmPeople, Model model) {
			model.addAttribute("ccmPeople", ccmPeople);
			CcmHouseDangerous Dangerous = ccmHouseDangerousService.getPeopleALL(ccmPeople.getId());
			if (Dangerous == null){
				Dangerous = new CcmHouseDangerous();
			}
			model.addAttribute("ccmHouseDangerous", Dangerous);
			return "/ccm/house/pop/ccmHousePoPDangerousForm";
		}
		
		//保存+标记
		@RequiresPermissions("house:ccmHouseDangerous:edit")
		@RequestMapping(value = "savePop")
		public String savePop(CcmHouseDangerous ccmHouseDangerous, Model model, RedirectAttributes redirectAttributes) {
			if (!beanValidator(model, ccmHouseDangerous)){
				return form(ccmHouseDangerous, model);
			}
			ccmHouseDangerousService.save(ccmHouseDangerous);
			// 更新 当前人 是 危险品从业人员
			CcmPeople ccmPop = ccmPeopleService.get(ccmHouseDangerous.getPeopleId());
			if(ccmPop!=null){
				ccmPop.setIsDangerous(1);
				ccmPeopleService.save(ccmPop);
			}
			
			addMessage(redirectAttributes, "保存重点上访人员成功");
			return "redirect:"+Global.getAdminPath()+"/pop/ccmPeople/?repage";
			
			
			
		}

		/**
		 * 导出危险品从业人员数据
		 * 
		 * @param user
		 * @param request
		 * @param response
		 * @param redirectAttributes
		 * @return
		 */
		@RequiresPermissions("house:ccmHouseDangerous:view")
		@RequestMapping(value = "export", method = RequestMethod.POST)
		public String exportFile(CcmHouseDangerous ccmHouseDangerous, HttpServletRequest request,
				HttpServletResponse response, RedirectAttributes redirectAttributes) {
			String [] strArr={"姓名","联系方式","人口类型","现住门（楼）详址","公民身份号码","工作单位","危险品类别","关注程度","工作类别"};
			try {
				String fileName = "DangerousPeople" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";

				List<CcmHouseDangerous> list = new ArrayList<CcmHouseDangerous>();
				String permissionKey = request.getParameter("permissionKey");
				User user = UserUtils.getUser();
				if (user != null && "1".equals(user.getHasPermission())) {//有涉密权限
					list = ccmHouseDangerousService.findList(ccmHouseDangerous);
				} else if (user != null && "0".equals(user.getHasPermission())) {//无涉密权限
					if (user.getPermissionKey() != null && user.getPermissionKey().equals(permissionKey)) {
						list = ccmHouseDangerousService.findList(ccmHouseDangerous);
					}
				}
				
//				List<CcmHouseDangerous> list = ccmHouseDangerousService.findList(ccmHouseDangerous);
				new ExportExcel("危险品从业人员数据", CcmHouseDangerous.class,strArr).setDataList(list).write(response, fileName).dispose();
				return null;
			} catch (Exception e) {
				addMessage(redirectAttributes, "导出危险品从业人员失败！失败信息：" + e.getMessage());
			}
			return "redirect:" + adminPath + "/house/ccmHousePetition/?repage";
		}
		
		/**
		 * 导入危险品从业人员数据
		 * 
		 * @param file
		 * @param redirectAttributes
		 * @return
		 */
		@RequiresPermissions("house:ccmHouseDangerous:view")
		@RequestMapping(value = "import", method = RequestMethod.POST)
		public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
			if (Global.isDemoMode()) {
				addMessage(redirectAttributes, "演示模式，不允许操作！");
				return "redirect:" + adminPath + "/house/ccmHouseDangerous/?repage";
			}
			try {
				int successNum = 0;
				int failureNum = 0;
				StringBuilder failureMsg = new StringBuilder();
				ImportExcel ei = new ImportExcel(file, 1, 0);
				List<CcmHouseDangerous> list = ei.getDataList(CcmHouseDangerous.class);
				for (CcmHouseDangerous HouseDangerous : list) {
					try {

						if(EntityTools.isEmpty(HouseDangerous)){
							continue;
						}
						
						if(StringUtils.isBlank(HouseDangerous.getWorkUnit()) ||
								StringUtils.isBlank(HouseDangerous.getGoodsType()) ||
								StringUtils.isBlank(HouseDangerous.getAtteType()) ||
								StringUtils.isBlank(HouseDangerous.getWorkType())
						){
							StringBuilder str = new StringBuilder();
							str.append("(");
							if(StringUtils.isBlank(HouseDangerous.getWorkUnit())) {
								str.append("工作单位信息错误;");
							}
							if(StringUtils.isBlank(HouseDangerous.getGoodsType())) {
								str.append("危险品类别信息错误;");
							}
							if(StringUtils.isBlank(HouseDangerous.getAtteType())) {
								str.append("关注程度信息错误;");
							}
							if(StringUtils.isBlank(HouseDangerous.getWorkType())) {
								str.append("工作类别信息错误;");
							}
							str.append(")");
							failureMsg.append("<br/>危险品从业人员名 " + HouseDangerous.getName() + " 导入失败：必填项为空。"+str.toString());
							continue;
						}
						
						// 如果当前用户的身份未填写或者为空或者身份证号码位数不够18位则应该进行 剔除
						if (StringUtils.isBlank(HouseDangerous.getIdent()) || HouseDangerous.getIdent().length() != 18) {
							failureMsg.append("<br/>实有人口名" + HouseDangerous.getName() + " 导入失败：" + "身份证信息错误。");
							HouseDangerous.setName(HouseDangerous.getName() + "，失败原因：身份证信息错误");
							failureNum++;
							continue;
						}

						CcmPeople ccmPeople=new CcmPeople();
						ccmPeople.setIdent(HouseDangerous.getIdent());
						List<CcmPeople> list1 = ccmPeopleService.findList(ccmPeople);
						CcmHouseDangerous HouseDangerousFind;

						if (list1.isEmpty()){
							failureMsg.append("<br/>危险品从业人员名 " + HouseDangerous.getName() + " 导入失败：实有人口表中无此人");
							continue;
						}else{
							ccmPeople.setId(list1.get(0).getId());
							ccmPeople.setUpdateBy(UserUtils.getUser());
							ccmPeople.setUpdateDate(new Date());
							ccmPeople.setIsDangerous(1);
							ccmPeopleService.updatePeople(ccmPeople);
							HouseDangerousFind=ccmHouseDangerousService.getPeopleALL(list1.get(0).getId());
							BeanValidators.validateWithException(validator, HouseDangerous);
							if(HouseDangerousFind == null){
								HouseDangerous.setPeopleId(list1.get(0).getId());
								ccmHouseDangerousService.save(HouseDangerous);
								successNum++;
							}else{
								failureMsg.append("<br/>危险品从业人员名 " + HouseDangerous.getName() + " 导入失败：记录已存在");
							}
						}
					} catch (ConstraintViolationException ex) {
						failureMsg.append("<br/>危险品从业人员名 " + HouseDangerous.getName() + " 导入失败：");
						List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
						for (String message : messageList) {
							failureMsg.append(message + "; ");
							failureNum++;
						}
					} catch (Exception ex) {
						failureMsg.append("<br/>登录名 " + HouseDangerous.getName() + " 导入失败：" + ex.getMessage());
					}
				}
				if (failureNum > 0) {
					failureMsg.insert(0, "，失败 " + failureNum + " 条危险品从业人员，导入信息如下：");
				}
				addMessage(redirectAttributes, "已成功导入 " + successNum + " 条危险品从业人员" + failureMsg);
			} catch (Exception e) {
				addMessage(redirectAttributes, "导入危险品从业人员失败！失败信息：" + e.getMessage());
			}
			return "redirect:" + adminPath + "/house/ccmHouseDangerous/?repage";
		}
		 
		
		

}