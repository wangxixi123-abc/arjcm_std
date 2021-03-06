/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.web;

import com.arjjs.ccm.common.beanvalidator.BeanValidators;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.utils.excel.ExportExcel;
import com.arjjs.ccm.common.utils.excel.ImportExcel;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildentrance;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseBuildmanageService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenant;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPopTenantService;
import com.google.common.collect.Lists;
import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.*;

/**
 * 楼栋Controller
 * 
 * @author wwh
 * @version 2018-01-05
 */
@Controller
@RequestMapping(value = "${adminPath}/house/ccmHouseBuildmanage")
public class CcmHouseBuildmanageController extends BaseController {

	@Autowired
	private CcmHouseBuildmanageService ccmHouseBuildmanageService;

	@Autowired
	private CcmLogTailService ccmLogTailService;

	@Autowired
	private CcmPopTenantService ccmPopTenantService;

	@ModelAttribute
	public CcmHouseBuildmanage get(@RequestParam(required = false) String id) {
		CcmHouseBuildmanage entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmHouseBuildmanageService.get(id);
		}
		if (entity == null) {
			entity = new CcmHouseBuildmanage();
		}
		return entity;
	}
	
	// 楼栋房屋弹框
	@ResponseBody
	@RequestMapping(value = "getBuildentrance")
	public List<CcmHouseBuildentrance> getBuildentrance(String id) {
		List<CcmHouseBuildentrance> buildentranceList = new ArrayList<CcmHouseBuildentrance>();
		if (StringUtils.isNotBlank(id)) {
			buildentranceList = ccmHouseBuildmanageService.findBuildentrance(id);
		}
		return buildentranceList;
	}

	// 楼栋房屋弹框
	@ResponseBody
	@RequestMapping(value = "getHouseList")
	public List<CcmPopTenant> getHouseList(CcmHouseBuildmanage ccmHouseBuildmanage, Model model) {
		// 返回对象结果
		CcmPopTenant ccmPopTenant = new CcmPopTenant();
		ccmPopTenant.setBuildingId(ccmHouseBuildmanage);
		List<CcmPopTenant> list = ccmPopTenantService.getHouseList(ccmPopTenant);
		return list;
	}

	// 楼栋房屋弹框
	@ResponseBody
	@RequestMapping(value = "getHouseList1")
	public CcmPopTenant getHouseList1(CcmHouseBuildmanage ccmHouseBuildmanage, Model model) {
		// 返回对象结果
		CcmPopTenant ccmPopTenant = new CcmPopTenant();
		ccmPopTenant.setBuildingId(ccmHouseBuildmanage);
		List<CcmPopTenant> list = ccmPopTenantService.getHouseList(ccmPopTenant);
		return list.get(0);
	}

	//
	@RequiresPermissions("house:ccmHouseBuildmanage:view")
	@RequestMapping(value = { "list", "" })
	public String list(CcmHouseBuildmanage ccmHouseBuildmanage, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<CcmHouseBuildmanage> respage = ccmHouseBuildmanageService.findListId(new Page<CcmHouseBuildmanage>(request, response), ccmHouseBuildmanage);
		List<String> idlist = Lists.newArrayList();
		respage.getList().forEach(item->{
			idlist.add(item.getId());
		});
		ccmHouseBuildmanage.setListLimite(idlist);
		Page<CcmHouseBuildmanage> pagelist = ccmHouseBuildmanageService.findList_V2(new Page<CcmHouseBuildmanage>(request, response), ccmHouseBuildmanage);
		respage.setList(pagelist.getList());
		model.addAttribute("page", respage);
		return "ccm/house/ccmHouseBuildmanageList";
	}

	@RequiresPermissions("house:ccmHouseBuildmanage:view")
	@RequestMapping(value = "form")
	public String form(CcmHouseBuildmanage ccmHouseBuildmanage, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHouseBuildmanage.getId());
		ccmLogTailDto.setRelevanceTable("ccm_house_buildmanage");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"createBy","updateBy","currentUser","dbName","global","page","createDate","updateDate","sqlMap"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList,config).toString(); 
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());
		
		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmHouseBuildmanage", ccmHouseBuildmanage);
		return "ccm/house/ccmHouseBuildmanageForm";
	}

	@RequiresPermissions("house:ccmHouseBuildmanage:edit")
	@RequestMapping(value = "save")
	public String save(CcmHouseBuildmanage ccmHouseBuildmanage, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmHouseBuildmanage)) {
			return form(ccmHouseBuildmanage, model);
		}
		ccmHouseBuildmanageService.save(ccmHouseBuildmanage);
		addMessage(redirectAttributes, "保存楼栋成功");
		return "redirect:" + Global.getAdminPath() + "/house/ccmHouseBuildmanage/?repage";
	}

	@RequiresPermissions("house:ccmHouseBuildmanage:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmHouseBuildmanage ccmHouseBuildmanage, RedirectAttributes redirectAttributes) {
		ccmHouseBuildmanageService.delete(ccmHouseBuildmanage);
		addMessage(redirectAttributes, "删除楼栋成功");
		return "redirect:" + Global.getAdminPath() + "/house/ccmHouseBuildmanage/?repage";
	}

	/**
	 * 导出楼栋数据
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseBuildmanage:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(CcmHouseBuildmanage ccmHouseBuildmanage, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "楼栋数据" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<CcmHouseBuildmanage> list = ccmHouseBuildmanageService.findList(ccmHouseBuildmanage);
			new ExportExcel("楼栋数据", CcmHouseBuildmanage.class).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出楼栋失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHouseBuildmanage/?repage";
	}

	/**
	 * 导入楼栋数据
	 * 
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseBuildmanage:view")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/house/ccmHouseBuildmanage/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<CcmHouseBuildmanage> list = ei.getDataList(CcmHouseBuildmanage.class);
			for (CcmHouseBuildmanage Buildmanage : list) {
				try {

					BeanValidators.validateWithException(validator, Buildmanage);
					ccmHouseBuildmanageService.save(Buildmanage);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>楼栋名 " + Buildmanage.getName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + Buildmanage.getName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条楼栋，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条楼栋" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入楼栋失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/house/ccmHouseBuildmanage/?repage";
	}

	/**
	 * @see 地图跳转信息
	 * @param ccmHouseBuildmanage
	 * @param model
	 * @return
	 */
	@RequiresPermissions("house:ccmHouseBuildmanage:view")
	@RequestMapping(value = "ToMap", method = RequestMethod.GET)
	public String ToMap(CcmHouseBuildmanage ccmHouseBuildmanage, Model model) {
		// 创建 查询对象 建立查询条件
		model.addAttribute("ccmHouseBuildmanage", ccmHouseBuildmanage);
		return "/ccm/house/map/mapBuildmanage";
	}

	// 获取所有 地图信息
	/**
	 * 
	 * @param ccmHouseBuildmanage
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "Maplist")
	public String Maplist(@RequestParam(required = false) String type,	CcmHouseBuildmanage ccmHouseBuildmanage , Model model) {
		//  step1 楼栋查询内部的房屋数量
	
		// 一层最大个数
		int MaxElemNum = 0;
		// 查询相关内容
		CcmPopTenant ccmPopTenantDto1 = new CcmPopTenant();
		ccmPopTenantDto1.setBuildingId(ccmHouseBuildmanage);
		// 获取所有 list
		List<CcmPopTenant> list = ccmPopTenantService.getHouseList(ccmPopTenantDto1);
		List<Map<String, CcmPopTenant>> listCcmTent = new ArrayList<>();
		// 循环生成Map i：楼层数
		for (int i = 1; i <= ccmHouseBuildmanage.getPilesNum(); i++) {
			// 循环当前所有的 list 对象 生成 相关的Map
			Map<String, CcmPopTenant> ccmTentMap = new TreeMap<>();
			// 计数
			int tentM = 0;
			for (int l1 = 0; l1 < list.size(); l1++) {
				// 如果为当前的 楼层
				if (list.get(l1).getFloorNum()!=null&&Integer.parseInt(list.get(l1).getFloorNum()) == i) {
					ccmTentMap.put((tentM++) + "", list.get(l1));
				}
			}
			// 获取每一层最大个数
			if (MaxElemNum < tentM) {
				MaxElemNum = tentM;
			}
			// 返回 相关对象
			listCcmTent.add(ccmTentMap);
		}
		// 生成最大的公约数
		MaxElemNum  =  MaxElemNum+(4-(MaxElemNum%4)==4?0:4-(MaxElemNum%4));
		// list反转
		Collections.reverse(listCcmTent);
		// 实际 对象
		model.addAttribute("list", list);
		// 总数
		model.addAttribute("maxelemnum", MaxElemNum);
		// 房屋对象
		model.addAttribute("listCcmTent", listCcmTent);
		// 生成相关对象
		for (Map<String, CcmPopTenant> c : listCcmTent) {
			// 判断当前的 list 是否为 4 的倍数 ，如果不是则进行 添加
			if (c.size() < MaxElemNum) {
				// 循环生成 list
				for (int N = c.size(); N < MaxElemNum; N++) {
					// 添加新的空对象
					c.put(N + "", new CcmPopTenant());
				}
			}
		}
		
		// step2 查询相关的重点人员所在的房屋
//		type  = StringUtils.isNumeric(type)?type:"127";
//		CcmPopTenant ccmPopTenantDto2 = new CcmPopTenant(); 
//		// 获取相关的参数值 	
//		ccmPopTenantDto2.setMore1(CommUtil.ReturnPeoType(type).getMore1());
//		ccmPopTenantDto2.setBuildingId(ccmHouseBuildmanage);
//		List<String> SpeIDList = ccmPopTenantService.getStringSpecial(ccmPopTenantDto2);
		
		// 总层数
		model.addAttribute("pilesNum", ccmHouseBuildmanage.getPilesNum()!=null?ccmHouseBuildmanage.getPilesNum():0);
		// 总单元数
		model.addAttribute("elemNum", ccmHouseBuildmanage.getElemNum()!=null?ccmHouseBuildmanage.getElemNum():0);
		// 楼栋名称
		model.addAttribute("buildName", ccmHouseBuildmanage.getBuildname());
		// 楼栋的ID
		model.addAttribute("buildId", ccmHouseBuildmanage.getId());
		// 重点人员的参数 值
		//model.addAttribute("SpeIDList", SpeIDList);

		if(type!=null && type.equals("1")){
			// 返回数据可视化页面 楼栋详情
			return "/modules/mapping/houseBuild/mapBulidstatIndex";
		} else {
			// 返回所有 GIS数据内容
			return "/modules/mapping/houseBuild/mapBulid";
		}

	}


	@ResponseBody
	@RequestMapping(value = "findListNum")
	public String findListNum(CcmHouseBuildmanage ccmHouseBuildmanage, HttpServletRequest request,
					   HttpServletResponse response, Model model) {
		int listNum = ccmHouseBuildmanageService.findListNum(ccmHouseBuildmanage);
		return String.valueOf(listNum);
	}

	@RequestMapping(value = "mapvForm")
	public String mapvForm(CcmHouseBuildmanage ccmHouseBuildmanage, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmHouseBuildmanage.getId());
		ccmLogTailDto.setRelevanceTable("ccm_house_buildmanage");
		List<CcmLogTail> ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		// 返回查询结果
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"createBy","updateBy","currentUser","dbName","global","page","createDate","updateDate","sqlMap"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(ccmLogTailList,config).toString();
		model.addAttribute("documentList", jsonDocumentList);
		model.addAttribute("documentNumber", ccmLogTailList.size());

		model.addAttribute("ccmLogTailList", ccmLogTailList);
		model.addAttribute("ccmHouseBuildmanage", ccmHouseBuildmanage);
		return "ccm/house/ccmHouseBuildmanageMapvForm";
	}
}
