/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.catering.web;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.catering.entity.CcmPlaceCatering;
import com.arjjs.ccm.modules.ccm.catering.service.CcmPlaceCateringService;
import com.arjjs.ccm.modules.ccm.place.entity.CcmBasePlace;
import com.arjjs.ccm.modules.ccm.place.service.CcmBasePlaceService;
import com.arjjs.ccm.tool.CommUtil;

/**
 * 餐饮场所Controller
 * 
 * @author ljd
 * @version 2019-04-29
 */
@Controller
@RequestMapping(value = "${adminPath}/catering/ccmPlaceCatering")
public class CcmPlaceCateringController extends BaseController {

	@Autowired
	private CcmPlaceCateringService ccmPlaceCateringService;
	@Autowired
	private CcmBasePlaceService ccmBasePlaceService;

	@ModelAttribute
	public CcmPlaceCatering get(@RequestParam(required = false) String id) {
		CcmPlaceCatering entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmPlaceCateringService.get(id);
		}
		if (entity == null) {
			entity = new CcmPlaceCatering();
		}
		return entity;
	}

	@RequiresPermissions("catering:ccmPlaceCatering:view")
	@RequestMapping(value = { "list", " ", "{type}" })
	public String list(CcmPlaceCatering ccmPlaceCatering, HttpServletRequest request, HttpServletResponse response,
			Model model, @PathVariable("type") String type) {
		ccmPlaceCatering.setType(type);
		Page<CcmPlaceCatering> page = ccmPlaceCateringService.findPage(new Page<CcmPlaceCatering>(request, response),
				ccmPlaceCatering);
		List<CcmPlaceCatering> findList = page.getList();
		for (CcmPlaceCatering catering : findList) {
			catering.setCcmBasePlace(ccmBasePlaceService.get(catering.getBasePlaceId()));
		}
		model.addAttribute("page", page);
		if (StringUtils.isNoneBlank(ccmPlaceCatering.getType()) && "01".equals(ccmPlaceCatering.getType())) {
			// 餐馆
			return "ccm/catering/ccmPlaceCateringList";
		}
		return "ccm/catering/ccmPlaceCateringList";
	}

	@RequiresPermissions("catering:ccmPlaceCatering:view")
	@RequestMapping(value = "form")
	public String form(CcmPlaceCatering ccmPlaceCatering, Model model) {
		CcmBasePlace ccmBasePlace = new CcmBasePlace();
		ccmBasePlace.setId(ccmPlaceCatering.getBasePlaceId());
		CcmBasePlace ccmBasePlace2 = ccmBasePlaceService.get(ccmBasePlace);
		ccmPlaceCatering.setCcmBasePlace(ccmBasePlace2);
		model.addAttribute("ccmPlaceCatering", ccmPlaceCatering);
		
		if (StringUtils.isNoneBlank(ccmPlaceCatering.getType()) && "01".equals(ccmPlaceCatering.getType())) {
			// 餐馆
			return "ccm/catering/ccmPlaceCateringForm";
		}
		return "ccm/catering/ccmPlaceCateringForm";
	}

	@RequiresPermissions("catering:ccmPlaceCatering:edit")
	@RequestMapping(value = "save")
	public void save(CcmPlaceCatering ccmPlaceCatering, Model model, RedirectAttributes redirectAttributes,
			HttpServletResponse response) {
		if (!beanValidator(model, ccmPlaceCatering)) {
		}
		// 处理场所基本信息
		if (null == ccmPlaceCatering.getBasePlaceId() || "".equals(ccmPlaceCatering.getBasePlaceId())) {
			CcmBasePlace ccmBasePlace = ccmPlaceCatering.getCcmBasePlace();
			String id = UUID.randomUUID().toString();
			ccmBasePlace.setId(id);
			ccmBasePlace.setIsNewRecord(true);
			ccmBasePlace.setChildType("01");
			ccmBasePlace.setPlaceType("ccm_place_catering");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceCatering.setCcmBasePlace(ccmBasePlace);
			ccmPlaceCatering.setBasePlaceId(id);
		} else {
			CcmBasePlace ccmBasePlace = ccmPlaceCatering.getCcmBasePlace();
			ccmBasePlace.setId(ccmPlaceCatering.getBasePlaceId());
			ccmBasePlace.setPlaceType("ccm_place_catering");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceCatering.setCcmBasePlace(ccmBasePlace);
		}

		ccmPlaceCatering.setType("01");
		// TODO 首先保存基础场所表数据，之后把生成id存到houseId里
		ccmPlaceCateringService.save(ccmPlaceCatering);
		addMessage(redirectAttributes, "保存餐饮场所成功");
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		CommUtil.openWinExpDiv(out, "保存餐馆成功");
	}

	@RequiresPermissions("catering:ccmPlaceCatering:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmPlaceCatering ccmPlaceCatering, RedirectAttributes redirectAttributes) {
		if (null != ccmPlaceCatering.getBasePlaceId() && !("".equals(ccmPlaceCatering.getBasePlaceId()))) {
			CcmBasePlace ccmBasePlace = ccmBasePlaceService.get(ccmPlaceCatering.getBasePlaceId());
			ccmBasePlaceService.delete(ccmBasePlace);
		}
		ccmPlaceCateringService.delete(ccmPlaceCatering);
		addMessage(redirectAttributes, "删除餐饮场所成功");
		return "redirect:" + Global.getAdminPath() + "/catering/ccmPlaceCatering/" + ccmPlaceCatering.getType()
				+ "?repage";
	}

}