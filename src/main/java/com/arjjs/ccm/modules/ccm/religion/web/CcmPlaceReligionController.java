/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.religion.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.place.entity.CcmBasePlace;
import com.arjjs.ccm.modules.ccm.place.service.CcmBasePlaceService;
import com.arjjs.ccm.modules.ccm.religion.entity.CcmPlaceReligion;
import com.arjjs.ccm.modules.ccm.religion.service.CcmPlaceReligionService;
import com.arjjs.ccm.tool.CommUtil;

/**
 * 宗教组织Controller
 * 
 * @author ljd
 * @version 2019-04-29
 */
@Controller
@RequestMapping(value = "${adminPath}/religion/ccmPlaceReligion")
public class CcmPlaceReligionController extends BaseController {

	@Autowired
	private CcmPlaceReligionService ccmPlaceReligionService;
	@Autowired
	private CcmBasePlaceService ccmBasePlaceService;

	@ModelAttribute
	public CcmPlaceReligion get(@RequestParam(required = false) String id) {
		CcmPlaceReligion entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmPlaceReligionService.get(id);
		}
		if (entity == null) {
			entity = new CcmPlaceReligion();
		}
		return entity;
	}

	@RequiresPermissions("religion:ccmPlaceReligion:view")
	@RequestMapping(value = { "list", "" })
	public String list(CcmPlaceReligion ccmPlaceReligion, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<CcmPlaceReligion> page = ccmPlaceReligionService.findPage(new Page<CcmPlaceReligion>(request, response),
				ccmPlaceReligion);
		List<CcmPlaceReligion> findList = ccmPlaceReligionService.findList(ccmPlaceReligion);
		for (CcmPlaceReligion religion : findList) {
			religion.setCcmBasePlace(ccmBasePlaceService.get(religion.getBasePlaceId()));
		}
		page.setList(findList);
		model.addAttribute("page", page);
		return "ccm/religion/ccmPlaceReligionList";
	}

	// 新密宗教列表
	@RequiresPermissions("religion:ccmPlaceReligion:view")
	@RequestMapping(value = { "list1" })
	public String list1(CcmPlaceReligion ccmPlaceReligion, HttpServletRequest request, HttpServletResponse response,
					   Model model) {
		Page<CcmPlaceReligion> page = ccmPlaceReligionService.findPage(new Page<CcmPlaceReligion>(request, response),
				ccmPlaceReligion);
		List<CcmPlaceReligion> findList = ccmPlaceReligionService.findList(ccmPlaceReligion);
		for (CcmPlaceReligion religion : findList) {
			religion.setCcmBasePlace(ccmBasePlaceService.get(religion.getBasePlaceId()));
		}
		page.setList(findList);
		model.addAttribute("page", page);
		return "ccm/religion/ccmPlaceReligionListZj";
	}


	// 新密宗教表单
	@RequiresPermissions("religion:ccmPlaceReligion:view")
	@RequestMapping(value = "form1")
	public String form1(CcmPlaceReligion ccmPlaceReligion, Model model) {
		CcmBasePlace ccmBasePlace = new CcmBasePlace();
		ccmBasePlace.setId(ccmPlaceReligion.getBasePlaceId());
		CcmBasePlace ccmBasePlace2 = ccmBasePlaceService.get(ccmBasePlace);
		ccmPlaceReligion.setCcmBasePlace(ccmBasePlace2);
		if(ccmBasePlace2!=null){
			ccmPlaceReligion.setAreaPoint(ccmBasePlace2.getAreaPoint()!=null ? ccmBasePlace2.getAreaPoint(): "");
			ccmPlaceReligion.setAreaMap(ccmBasePlace2.getAreaMap()!=null ? ccmBasePlace2.getAreaMap(): "");
		}
		model.addAttribute("ccmPlaceReligion", ccmPlaceReligion);
		return "ccm/religion/ccmPlaceReligionFormZj";
	}


	@RequiresPermissions("religion:ccmPlaceReligion:view")
	@RequestMapping(value = "form")
	public String form(CcmPlaceReligion ccmPlaceReligion, Model model) {
		CcmBasePlace ccmBasePlace = new CcmBasePlace();
		ccmBasePlace.setId(ccmPlaceReligion.getBasePlaceId());
		CcmBasePlace ccmBasePlace2 = ccmBasePlaceService.get(ccmBasePlace);
		ccmPlaceReligion.setCcmBasePlace(ccmBasePlace2);
		model.addAttribute("ccmPlaceReligion", ccmPlaceReligion);
		return "ccm/religion/ccmPlaceReligionForm";
	}

	// 正常保存
	@RequiresPermissions("religion:ccmPlaceReligion:edit")
	@RequestMapping(value = "save/Zj")
	public String save(CcmPlaceReligion ccmPlaceReligion, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmPlaceReligion)) {
			return form(ccmPlaceReligion, model);
		}
		// 处理场所基本信息
		if (StringUtils.isEmpty(ccmPlaceReligion.getBasePlaceId())) {
			CcmBasePlace ccmBasePlace = ccmPlaceReligion.getCcmBasePlace();
			String id = UUID.randomUUID().toString();
			ccmBasePlace.setId(id);
			ccmBasePlace.setIsNewRecord(true);
			ccmBasePlace.setPlaceType("ccm_place_religion");
			ccmBasePlace.setAreaPoint(ccmPlaceReligion.getAreaPoint()!=null ? ccmPlaceReligion.getAreaPoint() : "");
			ccmBasePlace.setAreaMap(ccmPlaceReligion.getAreaMap()!=null ? ccmPlaceReligion.getAreaMap() : "");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceReligion.setCcmBasePlace(ccmBasePlace);
			ccmPlaceReligion.setBasePlaceId(id);
		} else {
			CcmBasePlace ccmBasePlace = ccmPlaceReligion.getCcmBasePlace();
			ccmBasePlace.setId(ccmPlaceReligion.getBasePlaceId());
			ccmBasePlace.setPlaceType("ccm_place_religion");
			ccmBasePlace.setAreaPoint(ccmPlaceReligion.getAreaPoint()!=null ? ccmPlaceReligion.getAreaPoint() : "");
			ccmBasePlace.setAreaMap(ccmPlaceReligion.getAreaMap()!=null ? ccmPlaceReligion.getAreaMap() : "");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceReligion.setCcmBasePlace(ccmBasePlace);
		}
		ccmPlaceReligion.setType("1");
		// TODO 首先保存基础场所表数据，之后把生成id存到houseId里
		ccmPlaceReligionService.save(ccmPlaceReligion);
		addMessage(redirectAttributes, "保存宗教场所成功");
		return "redirect:" + Global.getAdminPath() + "/religion/ccmPlaceReligion/list1/?repage";
	}


	// 弹窗保存
	@RequiresPermissions("religion:ccmPlaceReligion:edit")
	@RequestMapping(value = "save")
	public void save(CcmPlaceReligion ccmPlaceReligion, Model model, RedirectAttributes redirectAttributes,
			HttpServletResponse response) {
		// 处理场所基本信息
		if (null == ccmPlaceReligion.getBasePlaceId() || "".equals(ccmPlaceReligion.getBasePlaceId())) {
			CcmBasePlace ccmBasePlace = ccmPlaceReligion.getCcmBasePlace();
			String id = UUID.randomUUID().toString();
			ccmBasePlace.setId(id);
			ccmBasePlace.setIsNewRecord(true);
			ccmBasePlace.setPlaceType("ccm_place_religion");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceReligion.setCcmBasePlace(ccmBasePlace);
			ccmPlaceReligion.setBasePlaceId(id);
		} else {
			CcmBasePlace ccmBasePlace = ccmPlaceReligion.getCcmBasePlace();
			ccmBasePlace.setId(ccmPlaceReligion.getBasePlaceId());
			ccmBasePlace.setPlaceType("ccm_place_religion");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceReligion.setCcmBasePlace(ccmBasePlace);
		}
		ccmPlaceReligion.setType("1");
		// TODO 首先保存基础场所表数据，之后把生成id存到houseId里
		ccmPlaceReligionService.save(ccmPlaceReligion);
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		CommUtil.openWinExpDiv(out, "保存宗教组织成功");

	}

	@RequiresPermissions("religion:ccmPlaceReligion:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmPlaceReligion ccmPlaceReligion, RedirectAttributes redirectAttributes) {
		if (null != ccmPlaceReligion.getBasePlaceId() && !("".equals(ccmPlaceReligion.getBasePlaceId()))) {
			CcmBasePlace ccmBasePlace = ccmBasePlaceService.get(ccmPlaceReligion.getBasePlaceId());
			ccmBasePlaceService.delete(ccmBasePlace);
		}
		ccmPlaceReligionService.delete(ccmPlaceReligion);
		addMessage(redirectAttributes, "删除宗教组织成功");
		return "redirect:" + Global.getAdminPath() + "/religion/ccmPlaceReligion/?repage";
	}

}