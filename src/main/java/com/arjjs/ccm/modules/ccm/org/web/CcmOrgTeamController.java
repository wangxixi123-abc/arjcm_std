/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.org.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.IdGen;
import com.arjjs.ccm.common.utils.SpringContextHolder;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgComprehensive;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgTeam;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgTeamService;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandleUserState;
import com.arjjs.ccm.modules.flat.handle.service.BphAlarmHandleService;
import com.arjjs.ccm.modules.flat.realtimeSituation.entity.PeopleData;
import com.arjjs.ccm.modules.flat.rest.service.FlatRestService;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 * 综治队伍Controller
 * @author liang
 * @version 2018-01-13
 */
@Controller
@RequestMapping(value = "${adminPath}/org/ccmOrgTeam")
public class CcmOrgTeamController extends BaseController {

	@Autowired
	private CcmOrgTeamService ccmOrgTeamService;
	
	@ModelAttribute
	public CcmOrgTeam get(@RequestParam(required=false) String id) {
		CcmOrgTeam entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmOrgTeamService.get(id);
		}
		if (entity == null){
			entity = new CcmOrgTeam();
		}
		return entity;
	}
	
	@RequiresPermissions("org:ccmOrgTeam:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmOrgTeam ccmOrgTeam, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmOrgTeam> page = ccmOrgTeamService.findPage(new Page<CcmOrgTeam>(request, response), ccmOrgTeam); 
		model.addAttribute("page", page);
		return "ccm/org/ccmOrgTeamList";
	}

	@RequiresPermissions("org:ccmOrgTeam:view")
	@RequestMapping(value = "form")
	public String form(CcmOrgTeam ccmOrgTeam, Model model) {
		model.addAttribute("ccmOrgTeam", ccmOrgTeam);
		return "ccm/org/ccmOrgTeamForm";
	}

	@RequiresPermissions("org:ccmOrgTeam:edit")
	@RequestMapping(value = "save")
	public String save(CcmOrgTeam ccmOrgTeam, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, ccmOrgTeam)){
			return form(ccmOrgTeam, model);
		}
		
		// TODO 查询 当前  数据是否 含有 user_id
		ccmOrgTeam.setUser(new User(ccmOrgTeam.getId()));
		CcmOrgTeam ccmOrgTeam2 = ccmOrgTeamService.findUserId(ccmOrgTeam.getId());
		if(ccmOrgTeam2==null){
			ccmOrgTeam.setIsNewRecord(true);//新添
			ccmOrgTeam.setId(IdGen.uuid());
			ccmOrgTeamService.save(ccmOrgTeam);
		}else{
			ccmOrgTeam.setIsNewRecord(false);//修改
			ccmOrgTeam.setId(ccmOrgTeam2.getId());
			ccmOrgTeamService.save(ccmOrgTeam);
		}
				
		//ccmOrgTeamService.save(ccmOrgTeam);
		addMessage(redirectAttributes, "保存综治队伍成功");
		Office office = UserUtils.getUser().getOffice();
		//return "redirect:"+Global.getAdminPath()+"/org/ccmOrgTeam/?repage";
		return "redirect:"+Global.getAdminPath()+"/view/vCcmTeam/list?office.id="+office.getId()+"&office.parentIds=,"+office.getId()+",";
	}
	
	@RequiresPermissions("org:ccmOrgTeam:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmOrgTeam ccmOrgTeam, RedirectAttributes redirectAttributes) {
		ccmOrgTeamService.delete(ccmOrgTeam);
		addMessage(redirectAttributes, "删除综治队伍成功");
		return "redirect:"+Global.getAdminPath()+"/org/ccmOrgTeam/?repage";
	}

	/**
	 * @desc 加载树形菜单，根据受理单位和人员类型查询用户
	 * @param officeId
	 * @param teamType
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(String officeId, String teamType, HttpServletResponse response) {
		CcmOrgTeam ccmOrgTeam = new CcmOrgTeam();
		User u = new User();
		Office office = new Office();
		office.setId(officeId);
		u.setOffice(office);
		ccmOrgTeam.setUser(u);
		ccmOrgTeam.setTeamType(teamType);
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<User> list = ccmOrgTeamService.findUserByOfficeId(ccmOrgTeam);
		//获取在线用户
		List<String> userIdList = Lists.newArrayList();
		List<User> onlineUsers = UserUtils.getOnlineUsers();
		for (int i = 0; i < onlineUsers.size(); i++) {
			userIdList.add(onlineUsers.get(i).getId());
		}
		for(Map.Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
			userIdList.add(entry.getValue().getUserId());
		}
		BphAlarmHandleUserState bphAlarmHandleUserState = new BphAlarmHandleUserState();
		String[] userIds = new String[userIdList.size()];
		bphAlarmHandleUserState.setUserIds(userIdList.toArray(userIds));
		BphAlarmHandleService bean = SpringContextHolder.getBean("bphAlarmHandleService");
		List<BphAlarmHandleUserState> findUserState = bean.findUserState(bphAlarmHandleUserState);
		List<String> onlineUserIdList = ccmOrgTeamService.findOnlineUserId();
		for (int i=0; i<list.size(); i++){
			User e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", "u_"+e.getId());
			map.put("pId", officeId);
			map.put("name", StringUtils.replace(e.getName(), " ", ""));
			map.put("loginState", "offline");
			map.put("userState", "free");
			for(User user : onlineUsers) {
				if(StringUtils.equals(e.getId(), user.getId())) {
					map.put("loginState", "online");
					for(BphAlarmHandleUserState userState : findUserState) {
						if (StringUtils.equals(userState.getUserId(), e.getId())) {
							map.put("userState", userState.getUserState());
						}
						break;
					}
					break;
				}
			}
			for (String onlineUserId : onlineUserIdList) {
				if(StringUtils.equals(e.getId(), onlineUserId)) {
					map.put("loginState", "online");
				}
			}
			for(Map.Entry<String, PeopleData> entry : FlatRestService.peoPleMap.entrySet()) {
				if(StringUtils.equals(e.getId(), entry.getValue().getUserId())) {
					map.put("loginState", "online");
					for(BphAlarmHandleUserState userState : findUserState) {
						if (StringUtils.equals(userState.getUserId(), e.getId())) {
							map.put("userState", userState.getUserState());
						}
						break;
					}
					break;
				}
			}
			mapList.add(map);
		}
		return mapList;
	}
}