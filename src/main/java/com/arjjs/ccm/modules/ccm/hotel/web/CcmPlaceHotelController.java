/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.hotel.web;

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
import com.arjjs.ccm.modules.ccm.hotel.entity.CcmPlaceHotel;
import com.arjjs.ccm.modules.ccm.hotel.service.CcmPlaceHotelService;
import com.arjjs.ccm.modules.ccm.place.entity.CcmBasePlace;
import com.arjjs.ccm.modules.ccm.place.service.CcmBasePlaceService;
import com.arjjs.ccm.tool.CommUtil;

/**
 * 酒店住宿Controller
 * 
 * @author ljd
 * @version 2019-04-29
 */
@Controller
@RequestMapping(value = "${adminPath}/hotel/ccmPlaceHotel")
public class CcmPlaceHotelController extends BaseController {

	@Autowired
	private CcmPlaceHotelService ccmPlaceHotelService;

	@Autowired
	private CcmBasePlaceService ccmBasePlaceService;

	@ModelAttribute
	public CcmPlaceHotel get(@RequestParam(required = false) String id) {
		CcmPlaceHotel entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ccmPlaceHotelService.get(id);
		}
		if (entity == null) {
			entity = new CcmPlaceHotel();
		}
		return entity;
	}

	@RequiresPermissions("hotel:ccmPlaceHotel:view")
	@RequestMapping(value = { "list", "", "{type}" })
	public String list(CcmPlaceHotel ccmPlaceHotel, HttpServletRequest request, HttpServletResponse response,
			Model model, @PathVariable("type") String type) {
		Page<CcmPlaceHotel> page = ccmPlaceHotelService.findPage(new Page<CcmPlaceHotel>(request, response),
				ccmPlaceHotel);
		List<CcmPlaceHotel> findList = ccmPlaceHotelService.findList(ccmPlaceHotel);
		for (CcmPlaceHotel hotel : findList) {
			hotel.setCcmBasePlace(ccmBasePlaceService.get(hotel.getBasePlaceId()));
		}
		page.setList(findList);
		model.addAttribute("page", page);
		if ("01".equals(type)) {
			return "ccm/hotel/ccmPlaceHotelList";
		}
		if ("02".equals(type)) {
			return "ccm/hotel/ccmPlaceFamilyHotelList";
		}
		return "ccm/hotel/ccmPlaceHotelList";
	}

	@RequiresPermissions("hotel:ccmPlaceHotel:view")
	@RequestMapping(value = "form")
	public String form(CcmPlaceHotel ccmPlaceHotel, Model model) {
		CcmBasePlace ccmBasePlace = new CcmBasePlace();
		ccmBasePlace.setId(ccmPlaceHotel.getBasePlaceId());
		CcmBasePlace ccmBasePlace2 = ccmBasePlaceService.get(ccmBasePlace);
		ccmPlaceHotel.setCcmBasePlace(ccmBasePlace2);
		model.addAttribute("ccmPlaceHotel", ccmPlaceHotel);

		if ("01".equals(ccmPlaceHotel.getType())) {
			// 酒店
			return "ccm/hotel/ccmPlaceHotelForm";
		}
		if ("02".equals(ccmPlaceHotel.getType())) {
			// 家庭旅店
			return "ccm/hotel/ccmPlaceFamilyHotelForm";
		}
		return "ccm/hotel/ccmPlaceHotelForm";
	}

	@RequiresPermissions("hotel:ccmPlaceHotel:edit")
	@RequestMapping(value = "save/{type}")
	public void save(CcmPlaceHotel ccmPlaceHotel, Model model, RedirectAttributes redirectAttributes,
			HttpServletResponse response, @PathVariable("type") String type) {
		if (!beanValidator(model, ccmPlaceHotel)) {
		}
		// 处理场所基本信息
		if (null == ccmPlaceHotel.getBasePlaceId() || "".equals(ccmPlaceHotel.getBasePlaceId())) {
			CcmBasePlace ccmBasePlace = ccmPlaceHotel.getCcmBasePlace();
			String id = UUID.randomUUID().toString();
			ccmBasePlace.setId(id);
			ccmBasePlace.setIsNewRecord(true);
			ccmBasePlace.setPlaceType("ccm_place_hotel");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceHotel.setCcmBasePlace(ccmBasePlace);
			ccmPlaceHotel.setBasePlaceId(id);
		} else {
			CcmBasePlace ccmBasePlace = ccmPlaceHotel.getCcmBasePlace();
			ccmBasePlace.setId(ccmPlaceHotel.getBasePlaceId());
			ccmBasePlace.setPlaceType("ccm_place_hotel");
			ccmBasePlaceService.save(ccmBasePlace);
			ccmPlaceHotel.setCcmBasePlace(ccmBasePlace);
		}

		// 公园和体育场新增
		ccmPlaceHotel.setType(type);
		ccmPlaceHotelService.save(ccmPlaceHotel);
		addMessage(redirectAttributes, "保存酒店住宿场所成功");
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if ("01".equals(type)) {
			CommUtil.openWinExpDiv(out, "保存酒店成功");
		}
		if ("02".equals(type)) {
			CommUtil.openWinExpDiv(out, "保存家庭旅馆成功");
		}
	}

	@RequiresPermissions("hotel:ccmPlaceHotel:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmPlaceHotel ccmPlaceHotel, RedirectAttributes redirectAttributes) {
		if (null != ccmPlaceHotel.getBasePlaceId() && !("".equals(ccmPlaceHotel.getBasePlaceId()))) {
			CcmBasePlace ccmBasePlace = ccmBasePlaceService.get(ccmPlaceHotel.getBasePlaceId());
			ccmBasePlaceService.delete(ccmBasePlace);
		}
		ccmPlaceHotelService.delete(ccmPlaceHotel);
		addMessage(redirectAttributes, "删除酒店住宿成功");
		return "redirect:" + Global.getAdminPath() + "/hotel/ccmPlaceHotel/" + ccmPlaceHotel.getType() + "?repage";
	}

}