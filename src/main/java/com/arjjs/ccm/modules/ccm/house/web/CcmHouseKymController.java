/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.arjjs.ccm.tool.EntityTools;
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

import com.arjjs.ccm.common.beanvalidator.BeanValidators;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.tool.ExportExcel;
import com.arjjs.ccm.common.utils.excel.ImportExcel;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseAids;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseKym;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseKymService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.CommUtil;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 重点青少年管理模块Controller
 * 
 * @author arj
 * @version 2018-01-08
 */
@Controller
@RequestMapping(value = "${adminPath}/house/ccmHouseKym")
public class CcmHouseKymController extends BaseController {

	@Autowired
	private CcmHouseKymService ccmHouseKymService;
	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private CcmLogTailService ccmLogTailService;

	@ModelAttribute
	public CcmHouseKym get(@RequestParam(value = "id", required = false) String id,
			@RequestParam(value = "peopleId", required = false) String peopleId) {
		CcmHouseKym entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmHouseKymService.get(id);
		} else if (StringUtils.isNotBlank(peopleId)) {
			entity = ccmHouseKymService.getPeopleALL(peopleId);
		}
		if (entity == null) {
			entity = new CcmHouseKym();
			// 如果 peopleId 不为空 则 添加该ID
			if (StringUtils.isNotBlank(peopleId)) {
				entity.setPeopleId(peopleId);
			}
		}

		return entity;
	}

	@RequestMapping(value = { "list", "" })
	public String list(@Param("tableType")String tableType,CcmHouseKym ccmHouseKym, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmHouseKym> page = ccmHouseKymService.findPage(new Page<CcmHouseKym>(request, response), ccmHouseKym);
		model.addAttribute("page", page);
		if(StringUtils.isBlank(tableType)) {
			return "ccm/house/ccmHouseKymList";
		}else {
			return "ccm/house/emphasis/ccmHouseKymList";
		}
	}

	@RequiresPermissions("house:ccmHouseKym:view")
	@RequestMapping(value = "form")
	public String form(CcmHouseKym ccmHouseKym, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHouseKym.getId());
		ccmLogTailDto.setRelevanceTable("ccm_house_kym");
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
		model.addAttribute("ccmHouseKym", ccmHouseKym);
		return "ccm/house/ccmHouseKymForm";
	}

	@RequiresPermissions("house:ccmHouseKym:edit")
	@RequestMapping(value = "save")
	public void save(CcmHouseKym ccmHouseKym, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) throws IOException{
		if (!beanValidator(model, ccmHouseKym)) {
//			return form(ccmHouseKym, model);
		}
		ccmHouseKymService.save(ccmHouseKym);
		// 更新 当前人 是 重点青少年
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseKym.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsKym(1);
			ccmPeopleService.save(ccmPop);
		}
		addMessage(redirectAttributes, "保存重点青少年成功");
		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存重点青少年成功");
	}

	@RequiresPermissions("house:ccmHouseKym:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmHouseKym ccmHouseKym, RedirectAttributes redirectAttributes) {
		ccmHouseKymService.delete(ccmHouseKym);
		// 更新 当前人 是 重点青少年
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseKym.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsKym(0);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "删除重点青少年成功");
		return "redirect:" + Global.getAdminPath() + "/house/ccmHouseKym/?repage";
	}
	
	@RequiresPermissions("house:ccmHouseKym:edit")
	@RequestMapping(value = "savePop")
	public String savePop(CcmHouseKym ccmHouseKym, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmHouseKym)) {
			return form(ccmHouseKym, model);
		}
		ccmHouseKymService.save(ccmHouseKym);
		// 更新 当前人 是 重点青少年
		CcmPeople ccmPop = ccmPeopleService.get(ccmHouseKym.getPeopleId());
		if(ccmPop!=null){
			ccmPop.setIsKym(1);
			ccmPeopleService.save(ccmPop);
		}
		
		addMessage(redirectAttributes, "保存重点青少年成功");

		return "redirect:" + Global.getAdminPath() + "/pop/ccmPeople/?repage";
	}

	@RequiresPermissions("house:ccmHouseKym:view")
	@RequestMapping(value = "specialform")
	public String specialform(CcmPeople ccmPeople, Model model) {
		model.addAttribute("ccmPeople", ccmPeople);
		CcmHouseKym kym = ccmHouseKymService.getPeopleALL(ccmPeople.getId());
		if (kym == null) {
			kym = new CcmHouseKym();
		}
		model.addAttribute("ccmHouseKym", kym);
		return "/ccm/house/pop/ccmHousePoPKymForm";
	}
	/**
	 * 导出重点青少年数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseKym:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmHouseKym ccmHouseKym, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		String [] strArr={"姓名","联系方式","人口类型","现住门（楼）详址","公民身份号码","人员类型","监护人公民身份号码","与监护人关系","监护人居住详址","帮扶人联系方式","关注程度","家庭情况","监护人姓名","监护人联系方式","帮扶人姓名","帮扶手段","是否犯罪"};
		try {
			String fileName = "KymPeople" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<CcmHouseKym> list = ccmHouseKymService.findList(ccmHouseKym);
			new ExportExcel("重点青少年数据", CcmHouseKym.class,strArr).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出重点青少年失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHouseKym/?repage";
	}

	/**
	 * 导入重点青少年数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseKym:view")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/house/ccmHouseKym/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CcmHouseKym> list = ei.getDataList(CcmHouseKym.class);
			for (CcmHouseKym ccmHouseKym : list) {
				try {


					if(EntityTools.isEmpty(ccmHouseKym)){
						continue;
					}

					if(StringUtils.isBlank(ccmHouseKym.getManType()) ||
							StringUtils.isBlank(ccmHouseKym.getGuarPerId()) ||
							StringUtils.isBlank(ccmHouseKym.getGuarRela()) ||
							StringUtils.isBlank(ccmHouseKym.getGuarAdd()) ||
							StringUtils.isBlank(ccmHouseKym.getAssistTl()) ||
							StringUtils.isBlank(ccmHouseKym.getAtteType()) ||
							StringUtils.isBlank(ccmHouseKym.getFamiStat()) ||
							StringUtils.isBlank(ccmHouseKym.getGuarName()) ||
							StringUtils.isBlank(ccmHouseKym.getGuarTl()) ||
							StringUtils.isBlank(ccmHouseKym.getAssistName()) ||
							StringUtils.isBlank(ccmHouseKym.getAssistMethod()) ||
							ccmHouseKym.getDelinquency()==null
					){
						failureMsg.append("<br/>重点青少年 " + ccmHouseKym.getName() + " 导入失败：必填项为空");
						continue;
					}

					// 如果当前用户的身份未填写或者为空或者身份证号码位数不够18位则应该进行 剔除
					if (StringUtils.isBlank(ccmHouseKym.getIdent()) || ccmHouseKym.getIdent().length() != 18) {
						failureMsg.append("<br/>实有人口名" + ccmHouseKym.getName() + " 导入失败：" + "身份证信息错误。");
						ccmHouseKym.setName(ccmHouseKym.getName() + "，失败原因：身份证信息错误");
						failureNum++;
						continue;
					}
					
					CcmPeople ccmPeople=new CcmPeople();
					ccmPeople.setIdent(ccmHouseKym.getIdent());
					List<CcmPeople> list1 = ccmPeopleService.findList(ccmPeople);
					CcmHouseKym ccmHouseKymFind;

					if (list1.isEmpty()){
						failureMsg.append("<br/>重点青少年 " + ccmHouseKym.getName() + " 导入失败：实有人口表中无此人");
						continue;
					}else{
						ccmPeople.setId(list1.get(0).getId());
						ccmPeople.setUpdateBy(UserUtils.getUser());
						ccmPeople.setUpdateDate(new Date());
						ccmPeople.setIsKym(1);
						ccmPeopleService.updatePeople(ccmPeople);
						ccmHouseKymFind=ccmHouseKymService.getPeopleALL(list1.get(0).getId());
						BeanValidators.validateWithException(validator, ccmHouseKym);
						if(ccmHouseKymFind == null){
							ccmHouseKym.setPeopleId(list1.get(0).getId());
							ccmHouseKymService.save(ccmHouseKym);
							successNum++;
						}else{
							failureMsg.append("<br/>重点青少年 " + ccmHouseKym.getName() + " 导入失败：记录已存在");
						}
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>重点青少年 " + ccmHouseKym.getName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + ccmHouseKym.getName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条重点青少年信息，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条重点青少年" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入重点青少年失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHouseKym/?repage";
	}

}