/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.event.web.wechat;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.modules.ccm.event.entity.wechat.CcmWechatEventAttachment;
import com.arjjs.ccm.modules.ccm.event.service.wechat.CcmWechatEventAttachmentService;
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
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventCasedeal;
import com.arjjs.ccm.modules.ccm.event.entity.wechat.CcmWechatEvent;
import com.arjjs.ccm.modules.ccm.event.service.CcmEventCasedealService;
import com.arjjs.ccm.modules.ccm.event.service.wechat.CcmWechatEventService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.tool.CommUtil;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 微信信息上报Controller
 * @author fu
 * @version 2018-04-14
 */
@Controller
@RequestMapping(value = "${adminPath}/event/wechat/ccmWechatEvent")
public class CcmWechatEventController extends BaseController {

	@Autowired
	private CcmWechatEventService ccmWechatEventService;
	@Autowired
	private CcmLogTailService ccmLogTailService;
	@Autowired
	private CcmEventCasedealService ccmEventCasedealService;
	@Autowired
	private CcmWechatEventAttachmentService ccmWechatEventAttachmentService;
	
	
	@ModelAttribute
	public CcmWechatEvent get(@RequestParam(required=false) String id) {
		CcmWechatEvent entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmWechatEventService.get(id);
			String state = entity.getState();
			if("01".equals(state)){
				entity.setState("02");
				ccmWechatEventService.save(entity);
			}
			CcmWechatEventAttachment ccmWechatEventAttachment = new CcmWechatEventAttachment();
			ccmWechatEventAttachment.setEventId(id);
			List<CcmWechatEventAttachment> list = ccmWechatEventAttachmentService.findList(ccmWechatEventAttachment);
			if(list.size()>0){
				entity.setEventAttachmentList(list);
				entity.setFile(list.get(0).getPath());
			}
		}
		if (entity == null){
			entity = new CcmWechatEvent();
		}
		return entity;
	}
	
	@RequiresPermissions("event:wechat:ccmWechatEvent:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmWechatEvent ccmWechatEvent, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmWechatEvent> page = ccmWechatEventService.findPage(new Page<CcmWechatEvent>(request, response), ccmWechatEvent);
		model.addAttribute("page", page);
		return "ccm/event/wechat/ccmWechatEventList";
	}

	@RequiresPermissions("event:wechat:ccmWechatEvent:view")
	@RequestMapping(value = "form")
	public String form(CcmWechatEvent ccmWechatEvent, Model model) {
		// 创建 查询对象 建立查询条件
		CcmLogTail ccmLogTailDto = new CcmLogTail();
		ccmLogTailDto.setRelevanceId(ccmWechatEvent.getId());
		ccmLogTailDto.setRelevanceTable("ccm_wechat_event");
		List<CcmLogTail > ccmLogTailList = ccmLogTailService.findListByObject(ccmLogTailDto);
		List<CcmEventCasedeal> CcmEventCasedealList = ccmEventCasedealService.findCasedealList(ccmWechatEvent.getId());
		// 返回查询结果
		for (CcmEventCasedeal ccmEventCasedeal : CcmEventCasedealList) {
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date = sdf.format(ccmEventCasedeal.getCreateDate());
//			ccmEventCasedeal.setDealDate(date);todo
		}
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"createBy","updateBy","currentUser","dbName","global","page","createDate","updateDate","sqlMap"});
		config.setIgnoreDefaultExcludes(false);  //设置默认忽略
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		String jsonDocumentList = JSONArray.fromObject(CcmEventCasedealList,config).toString(); 
		model.addAttribute("CcmEventCasedealList", jsonDocumentList);
		model.addAttribute("CasedealListNumber", CcmEventCasedealList.size());
		model.addAttribute("ccmLogTailList", ccmLogTailList);		
		model.addAttribute("ccmWechatEvent", ccmWechatEvent);
		return "ccm/event/wechat/ccmWechatEventForm";
	}
	@RequiresPermissions("event:wechat:ccmWechatEvent:view")
	@RequestMapping(value = "detail")
	public String detail(CcmWechatEvent ccmWechatEvent, Model model) {
		model.addAttribute("ccmWechatEvent", ccmWechatEvent);
		return "ccm/event/wechat/ccmWechatEventDetail";
	}

	@RequiresPermissions("event:wechat:ccmWechatEvent:edit")
	@RequestMapping(value = "save")
	public void save(HttpServletRequest request,
			HttpServletResponse response,CcmWechatEvent ccmWechatEvent, Model model, RedirectAttributes redirectAttributes) throws IOException {
		ccmWechatEventService.save(ccmWechatEvent);
		if(null!= ccmWechatEvent.getFile()){
			ccmWechatEvent.getEventAttachmentList();
			CcmWechatEventAttachment ccmWechatEventAttachment = new CcmWechatEventAttachment();
			ccmWechatEventAttachment.setEventId(ccmWechatEvent.getId());
			ccmWechatEventAttachment.setPath(ccmWechatEvent.getFile());
			ccmWechatEventAttachment.setCreateBy(ccmWechatEvent.getCreateBy());
			ccmWechatEventAttachmentService.save(ccmWechatEventAttachment);
		}
		PrintWriter out = response.getWriter();
		CommUtil.openWinExpDiv(out, "保存成功");
	}
	
	@RequiresPermissions("event:wechat:ccmWechatEvent:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmWechatEvent ccmWechatEvent, RedirectAttributes redirectAttributes) {
		ccmWechatEventService.delete(ccmWechatEvent);
		addMessage(redirectAttributes, "删除微信信息上报成功");
		return "redirect:"+Global.getAdminPath()+"/event/wechat/ccmWechatEvent/?repage";
	}

}