/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.org.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDevice;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmDeviceService;
import com.arjjs.ccm.modules.ccm.org.entity.CcmDeviceVo;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgCommonality;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgDevice;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgDeviceInfo;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgCommonalityService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgDeviceService;
import com.arjjs.ccm.tool.CommUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 机构设置绑定Controller
 * @author maoxb
 * @version 2019-08-29
 */
@Controller
@RequestMapping(value = "${adminPath}/org/ccmOrgDevice")
public class CcmOrgDeviceController extends BaseController {

	@Autowired
	private CcmOrgDeviceService ccmOrgDeviceService;
	@Autowired
	private CcmOrgCommonalityService ccmOrgCommonalityService;
	@Autowired
	private CcmDeviceService ccmDeviceService;
	
	@ModelAttribute
	public CcmOrgDevice get(@RequestParam(required=false) String id) {
		CcmOrgDevice entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmOrgDeviceService.get(id);
		}
		if (entity == null){
			entity = new CcmOrgDevice();
		}
		return entity;
	}


	@RequestMapping(value = {"list", ""})
	public String list(String id, Model model) {
//		Page<CcmOrgDevice> page = ccmOrgDeviceService.findPage(new Page<CcmOrgDevice>(request, response), ccmOrgDevice);
		CcmOrgDeviceInfo ccmDevice =  ccmOrgDeviceService.queryDeviceByOrgDeviceId(id);
		String deviceIdList = "";
		if (ccmDevice != null){
			List<CcmDeviceVo> deviceList = ccmDevice.getDeviceList();
			for (CcmDeviceVo deviceVo : deviceList){
				deviceIdList += StringUtils.join(deviceVo.getId(),",");
			}
		}
		CcmOrgDevice ccmOrgDevice = new CcmOrgDevice();
		if(ccmDevice != null) {
			if(StringUtils.isNotEmpty(ccmDevice.getOrgId())) {
				ccmOrgDevice.setOrgId(ccmDevice.getOrgId());
			}
		}
		model.addAttribute("ccmOrgDevice", ccmOrgDevice);
		model.addAttribute("ccmDevice", ccmDevice);
		if(StringUtils.isNotEmpty(deviceIdList)) {
			model.addAttribute("deviceIdList", deviceIdList.substring(0,deviceIdList.length()-1) );
		}else {
			model.addAttribute("deviceIdList", null);
		}
		return "ccm/org/ccmOrgDeviceList";
	}

	@RequestMapping(value = "form")
	public String form(String id, Model model) {
		CcmOrgDevice ccmOrgDevice = new CcmOrgDevice();
		CcmOrgCommonality ccmOrgCommonality = ccmOrgCommonalityService.get(id);
		ccmOrgDevice.setOrgId(id);
		ccmOrgDevice.setOrgName(ccmOrgCommonality.getName());
		model.addAttribute("ccmOrgDevice", ccmOrgDevice);
		List<CcmDevice> list = ccmDeviceService.findList(new CcmDevice());
		model.addAttribute("videoList", list);
		return "ccm/org/ccmOrgDeviceForm";
	}

	@RequestMapping(value = "save")
	public void save(CcmOrgDevice ccmOrgDevice, Model model, RedirectAttributes redirectAttributes, HttpServletResponse response) {
		List<String> deviceSelectList = ccmOrgDevice.getDeviceSelect();
		if(deviceSelectList!=null&&deviceSelectList.size()>0){
			//先把机构下设备都清除，在进行保存新的设备
			ccmOrgDeviceService.deleteOrgDevice(ccmOrgDevice.getOrgId());
			for (String deviceId:deviceSelectList) {
				ccmOrgDevice.setDeviceId(ccmDeviceService.get(deviceId));
				ccmOrgDeviceService.save(ccmOrgDevice);
			}
		}
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
		}
		CommUtil.openWinExpDiv(out, "保存机构设置绑定成功");
	}
	
	@RequestMapping(value = "delete")
	public String delete(CcmOrgDevice ccmOrgDevice, RedirectAttributes redirectAttributes) {
		ccmOrgDeviceService.delete(ccmOrgDevice);
		addMessage(redirectAttributes, "删除机构设置绑定成功");
		return "redirect:"+Global.getAdminPath()+"/org/ccmOrgDevice/?repage";
	}

}