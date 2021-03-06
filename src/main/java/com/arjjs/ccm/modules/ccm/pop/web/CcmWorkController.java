package com.arjjs.ccm.modules.ccm.pop.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.beanvalidator.BeanValidators;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.utils.excel.ExportExcel;
import com.arjjs.ccm.common.utils.excel.ImportExcel;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenant;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPopTenantService;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 
 * @author UserLi
 * 
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/pop/ccmWork")
public class CcmWorkController extends BaseController {

	@Autowired
	private CcmPeopleService ccmPeopleService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@Autowired
	private CcmPopTenantService ccmPopTenantService;

	@ModelAttribute
	public CcmPeople get(@RequestParam(required = false) String id) {
		CcmPeople entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmPeopleService.get(id);
		}
		if (entity == null) {
			entity = new CcmPeople();
		}
		return entity;
	}

	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = { "list", "" })
	public String list(CcmPeople ccmPeople, HttpServletRequest request, HttpServletResponse response, Model model) {
		ccmPeople.setIsPermanent("1");
		Page<CcmPeople> page = ccmPeopleService.findPermanentPage(new Page<CcmPeople>(request, response), ccmPeople);

		// 数组查询id
		List<CcmPeople> list = page.getList();
		CcmPeople ccmPeople2 = new CcmPeople();
		String[] listLimite = new String[list.size()];
		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				listLimite[i] = list.get(i).getId();
			}
			ccmPeople2.setListLimite(listLimite);
			List<CcmPeople> list2 = ccmPeopleService.findListLimite_V2(ccmPeople2);// 数组查询id
			page.setList(list2);
		}

		model.addAttribute("page", page);
		return "ccm/pop/ccmWorkList";
	}

	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = { "list/{type}" })
	public String listByResidence(CcmPeople ccmPeople, HttpServletRequest request, HttpServletResponse response,
			Model model, @PathVariable("type") String type) {
//		ccmPeople.setIsPermanent("1");  //修改bug，pengjianqiang，各人员类型查询时，不需要设置为常住人员
		ccmPeople.setType(type);
		Page<CcmPeople> page = ccmPeopleService.findPermanentPage(new Page<CcmPeople>(request, response), ccmPeople);

		// 数组查询id
		List<CcmPeople> list = page.getList();
		CcmPeople ccmPeople2 = new CcmPeople();
		String[] listLimite = new String[list.size()];
		if (list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				listLimite[i] = list.get(i).getId();
			}
			ccmPeople2.setListLimite(listLimite);
			List<CcmPeople> list2 = ccmPeopleService.findListLimite_V2(ccmPeople2);// 数组查询id
			page.setList(list2);
		}

		model.addAttribute("page", page);
		String temp = "";
		if (type.equals("10")) {
			temp = "Residence";
		}
		if (type.equals("20")) {
			temp = "Flow";
		}
		if (type.equals("30")) {
			temp = "Overseas";
		}
		if (type.equals("40")) {
			temp = "NoSettle";
		}
		return "ccm/pop/ccm" + temp + "List";
	}

	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = "form")
	public String form(CcmPeople ccmPeople, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmPeople.getId());
		ccmLogTailDto.setRelevanceTable("ccm_people");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[] { "createBy", "updateBy", "currentUser", "dbName", "global", "page",
				"createDate", "updateDate", "sqlMap" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList, config).toString();
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());

		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmPeople", ccmPeople);
		return "ccm/pop/ccmWorkForm";
	}

	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = "form/residence")
	public String formByResidence(CcmPeople ccmPeople, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmPeople.getId());
		ccmLogTailDto.setRelevanceTable("ccm_people");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[] { "createBy", "updateBy", "currentUser", "dbName", "global", "page",
				"createDate", "updateDate", "sqlMap" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList, config).toString();
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());

		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmPeople", ccmPeople);
		return "ccm/pop/ccmResidenceForm";
	}
	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = "form/flow")
	public String formByFlow(CcmPeople ccmPeople, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmPeople.getId());
		ccmLogTailDto.setRelevanceTable("ccm_people");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[] { "createBy", "updateBy", "currentUser", "dbName", "global", "page",
				"createDate", "updateDate", "sqlMap" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList, config).toString();
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());
		
		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmPeople", ccmPeople);
		return "ccm/pop/ccmFlowForm";
	}
	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = "form/overseas")
	public String formByOverseas(CcmPeople ccmPeople, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmPeople.getId());
		ccmLogTailDto.setRelevanceTable("ccm_people");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[] { "createBy", "updateBy", "currentUser", "dbName", "global", "page",
				"createDate", "updateDate", "sqlMap" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList, config).toString();
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());
		
		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmPeople", ccmPeople);
		return "ccm/pop/ccmOverseasForm";
	}
	@RequiresPermissions("pop:ccmWork:view")
	@RequestMapping(value = "form/noSettle")
	public String formByNoSettle(CcmPeople ccmPeople, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmPeople.getId());
		ccmLogTailDto.setRelevanceTable("ccm_people");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[] { "createBy", "updateBy", "currentUser", "dbName", "global", "page",
				"createDate", "updateDate", "sqlMap" });
		config.setIgnoreDefaultExcludes(false); // 设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList, config).toString();
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());
		
		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmPeople", ccmPeople);
		return "ccm/pop/ccmNoSettleForm";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "save")
	public String save(CcmPeople ccmPeople, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPeople)) {
			return form(ccmPeople, model);
		}
		// 注入楼栋id
		if (ccmPeople.getRoomId() != null && ccmPeople.getRoomId().getId() != null
				&& !"".equals(ccmPeople.getRoomId().getId())) {
			CcmPopTenant ccmPopTenant = ccmPopTenantService.get(ccmPeople.getRoomId().getId());
			if (ccmPopTenant != null && ccmPopTenant.getBuildingId() != null
					&& ccmPopTenant.getBuildingId().getId() != null && ccmPopTenant.getBuildingId().getId() != "") {
				ccmPeople.setBuildId(ccmPopTenant.getBuildingId());
			}
		}
		ccmPeopleService.save(ccmPeople);
		addMessage(redirectAttributes, "保存工作单位成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/?repage";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "save/residence")
	public String saveByResidence(CcmPeople ccmPeople, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPeople)) {
			return form(ccmPeople, model);
		}
		// 注入楼栋id
		if (ccmPeople.getRoomId() != null && ccmPeople.getRoomId().getId() != null
				&& !"".equals(ccmPeople.getRoomId().getId())) {
			CcmPopTenant ccmPopTenant = ccmPopTenantService.get(ccmPeople.getRoomId().getId());
			if (ccmPopTenant != null && ccmPopTenant.getBuildingId() != null
					&& ccmPopTenant.getBuildingId().getId() != null && ccmPopTenant.getBuildingId().getId() != "") {
				ccmPeople.setBuildId(ccmPopTenant.getBuildingId());
			}
		}
		ccmPeopleService.save(ccmPeople);
		addMessage(redirectAttributes, "保存户籍人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/10?repage";
	}
	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "save/flow")
	public String saveByFlow(CcmPeople ccmPeople, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPeople)) {
			return form(ccmPeople, model);
		}
		// 注入楼栋id
		if (ccmPeople.getRoomId() != null && ccmPeople.getRoomId().getId() != null
				&& !"".equals(ccmPeople.getRoomId().getId())) {
			CcmPopTenant ccmPopTenant = ccmPopTenantService.get(ccmPeople.getRoomId().getId());
			if (ccmPopTenant != null && ccmPopTenant.getBuildingId() != null
					&& ccmPopTenant.getBuildingId().getId() != null && ccmPopTenant.getBuildingId().getId() != "") {
				ccmPeople.setBuildId(ccmPopTenant.getBuildingId());
			}
		}
		ccmPeopleService.save(ccmPeople);
		addMessage(redirectAttributes, "保存流动人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/20?repage";
	}
	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "save/overseas")
	public String saveByOverseas(CcmPeople ccmPeople, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPeople)) {
			return form(ccmPeople, model);
		}
		// 注入楼栋id
		if (ccmPeople.getRoomId() != null && ccmPeople.getRoomId().getId() != null
				&& !"".equals(ccmPeople.getRoomId().getId())) {
			CcmPopTenant ccmPopTenant = ccmPopTenantService.get(ccmPeople.getRoomId().getId());
			if (ccmPopTenant != null && ccmPopTenant.getBuildingId() != null
					&& ccmPopTenant.getBuildingId().getId() != null && ccmPopTenant.getBuildingId().getId() != "") {
				ccmPeople.setBuildId(ccmPopTenant.getBuildingId());
			}
		}
		ccmPeopleService.save(ccmPeople);
		addMessage(redirectAttributes, "保存境外人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/30?repage";
	}
	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "save/noSettle")
	public String saveByNoSettle(CcmPeople ccmPeople, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPeople)) {
			return form(ccmPeople, model);
		}
		// 注入楼栋id
		if (ccmPeople.getRoomId() != null && ccmPeople.getRoomId().getId() != null
				&& !"".equals(ccmPeople.getRoomId().getId())) {
			CcmPopTenant ccmPopTenant = ccmPopTenantService.get(ccmPeople.getRoomId().getId());
			if (ccmPopTenant != null && ccmPopTenant.getBuildingId() != null
					&& ccmPopTenant.getBuildingId().getId() != null && ccmPopTenant.getBuildingId().getId() != "") {
				ccmPeople.setBuildId(ccmPopTenant.getBuildingId());
			}
		}
		ccmPeopleService.save(ccmPeople);
		addMessage(redirectAttributes, "保存未落户人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/40?repage";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "delete/residence")
	public String deletebyResidence(CcmPeople ccmPeople, RedirectAttributes redirectAttributes) {
		ccmPeopleService.delete(ccmPeople);
		addMessage(redirectAttributes, "删除户籍人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/10/?repage";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "delete/flow")
	public String deletebyFlow(CcmPeople ccmPeople, RedirectAttributes redirectAttributes) {
		ccmPeopleService.delete(ccmPeople);
		addMessage(redirectAttributes, "删除流动人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/20/?repage";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "delete/overseas")
	public String deleteByOverseas(CcmPeople ccmPeople, RedirectAttributes redirectAttributes) {
		ccmPeopleService.delete(ccmPeople);
		addMessage(redirectAttributes, "删除境外人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/30/?repage";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "delete/noSettle")
	public String deleteByNoSettle(CcmPeople ccmPeople, RedirectAttributes redirectAttributes) {
		ccmPeopleService.delete(ccmPeople);
		addMessage(redirectAttributes, "删除未落户人口成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/list/40/?repage";
	}

	@RequiresPermissions("pop:ccmWork:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmPeople ccmPeople, RedirectAttributes redirectAttributes) {
		ccmPeopleService.delete(ccmPeople);
		addMessage(redirectAttributes, "删除工作单位成功");
		return "redirect:" + Global.getAdminPath() + "/pop/ccmWork/?repage";
	}

	/**
	 * 导出实有人口数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("pop:ccmPermanent:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmPeople ccmPeople, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "实有人口数据" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<CcmPeople> list = ccmPeopleService.findList(ccmPeople);
			new ExportExcel("实有人口数据", CcmPeople.class).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出实有人口失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/pop/ccmPermanent/?repage";
	}

	/**
	 * 导入实有人口数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("pop:ccmPermanent:view")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/pop/ccmPermanent/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CcmPeople> list = ei.getDataList(CcmPeople.class);
			for (CcmPeople People : list) {
				// 如果当前用户的身份未填写或者为空则应该进行 剔除
				if (StringUtils.isBlank(People.getIdenCode()) || StringUtils.isBlank(People.getIdenNum())) {
					failureMsg.append("<br/>实有人口名" + People.getName() + " 导入失败：" + "当前的用户的身份证材料尚未存在。");
					continue;
				}
				// 进行身份证验证 ,如果已经存在则进行 失败条目的添加。 并跳过当前的内容
				if (!ccmPeopleService.checkPeopleIden(People)) {
					failureMsg.append("<br/>实有人口名" + People.getName() + " 导入失败：" + "当前的用户的身份证材料已经存在于当前的数据库中。");
					continue;
				}

				try {
					BeanValidators.validateWithException(validator, People);
					ccmPeopleService.save(People);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>实有人口名 " + People.getName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>实有人口名 " + People.getName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条实有人口，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条实有人口" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入实有人口失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/pop/ccmPermanent/?repage";
	}

}
