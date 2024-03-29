package com.arjjs.ccm.modules.ccm.rest.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.common.utils.SpringContextHolder;
import com.arjjs.ccm.modules.sys.dao.LogDao;
import com.arjjs.ccm.modules.sys.entity.*;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSONObject;
import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.org.entity.SysArea;
import com.arjjs.ccm.modules.ccm.org.service.SysAreaService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenant;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPopTenantService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestMenu;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.rest.service.CcmRestAreaService;
import com.arjjs.ccm.modules.ccm.rest.service.CcmRestOfficeService;
import com.arjjs.ccm.modules.ccm.sys.service.AreaSPService;
import com.arjjs.ccm.modules.ccm.tree.entity.CcmTree;
import com.arjjs.ccm.modules.ccm.tree.service.CcmTreeService;
import com.arjjs.ccm.modules.sys.service.AreaService;
import com.arjjs.ccm.modules.sys.service.DictService;
import com.arjjs.ccm.modules.sys.service.SystemService;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.Tree;
import com.fay.tree.service.IFayTreeNode;
import com.fay.tree.util.FayTreeUtil;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 *系统信息接口类
 * 
 * @author fuxinshuang
 * @version 2018-03-01
 */
@Controller
@RequestMapping(value = "${appPath}/rest/system")
public class CcmRestSystem extends BaseController {

	@Autowired
    private SysAreaService sysAreaService;
	@Autowired
	private DictService dictService;
	@Autowired
	private CcmRestAreaService restAreaService;
	@Autowired
	private CcmPopTenantService ccmPopTenantService;
	@Autowired
	private CcmRestOfficeService restOfficeService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private AreaService areaService;
	@Autowired
	private CcmTreeService ccmTreeService;

	/**
	 * @see  获取数据字典信息
	 * @param type  类型
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-01
	 */
	@ResponseBody
	@RequestMapping(value = "dict", method = RequestMethod.GET)
	public CcmRestResult listData(@RequestParam(required=false) String type) {
		CcmRestResult result = new CcmRestResult();
		Dict dict = new Dict();
		dict.setType(type);
		List<Dict> dictList = dictService.findList(dict);
		
		// 返回具体内容
		result.setCode(CcmRestType.OK);
		result.setResult(dictList);
	//	return dictService.findList(dict);
		return result;
	}
	
	/**
	 * @see  获取区域列表信息并生成树形
	 * @param type  类型
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-02
	 */
	@ResponseBody
	@RequestMapping(value = "area", method = RequestMethod.GET)
	public Object treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		CcmRestResult result = new CcmRestResult();
		List<Area> list = restAreaService.findAll();
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();
		for (int i = 0; i < list.size(); i++) {
			Area area = list.get(i);
			boolean spread = false;//树形节点展开状态
			if ("1".equals(area.getType()) || "2".equals(area.getType()) || "3".equals(area.getType()) || "4".equals(area.getType()) 
					|| "5".equals(area.getType())) {//区域树形节点的展开：一直展开到社区(社区节点不展开)
				spread = true;
			}
			Tree tree = new Tree(area.getId(), area.getParentId(), area.getName(), "","", spread);
			listTree.add(tree);
		}
		Object data = FayTreeUtil.getTreeInJsonObject(listTree);
		//return data;
		// 返回具体内容
		result.setCode(CcmRestType.OK);
		result.setResult(data);
		return result;
	}
	
	/**
	 * @see  获取事件区域列表（当前用户所属区域下）
	 * @param type  类型
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-02
	 */
	@ResponseBody
	@RequestMapping(value = "areaEvent", method = RequestMethod.GET)
	public Object treeEventData(@RequestParam(required=false) String extId, @RequestParam(required=true) String id, HttpServletResponse response) {
		CcmRestResult result = new CcmRestResult();
		SysArea area1 = new SysArea();
		User user = UserUtils.get(id);
	    area1.setParentIds(user.getOffice().getArea().getId());
	    List<SysArea> list = sysAreaService.findByPid(area1);
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();
		for (int i = 0; i < list.size(); i++) {
			SysArea area = list.get(i);
			boolean spread = false;//树形节点展开状态
			if ("1".equals(area.getType()) || "2".equals(area.getType()) || "3".equals(area.getType()) || "4".equals(area.getType()) 
					|| "5".equals(area.getType()) || "6".equals(area.getType()) || "7".equals(area.getType())) {//区域树形节点的展开：一直展开到社区(社区节点不展开)
				spread = true;
			}
			Tree tree = new Tree(area.getId(), area.getParent().getId(), area.getName(), "","", spread);
			listTree.add(tree);
		}
		Object data = FayTreeUtil.getTreeInJsonObject(listTree);
		//return data;
		// 返回具体内容
		result.setCode(CcmRestType.OK);
		result.setResult(data);
		return result;
	}
	

	/**
	 * @see  获取区域列表信息并生成树形
	 * @param type  类型
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-02
	 */
	@ResponseBody
	@RequestMapping(value = "treeDataArea", method = RequestMethod.GET)
	public Object treeDataArea(@RequestParam(required=false) String extId, HttpServletResponse response, @RequestParam(required = false) String type, @RequestParam(required = false) String areaid) {
		CcmTree ccmTree = new CcmTree();
		ccmTree.setType(type);
		ccmTree.setId(areaid);
		List<Area> list = ccmTreeService.findTreeAll(ccmTree);
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();
		for (int i = 0; i < list.size(); i++) {
			Area area = list.get(i);
			boolean spread = false;//树形节点展开状态
			if ("1".equals(area.getType()) || "2".equals(area.getType()) || "3".equals(area.getType()) || "4".equals(area.getType()) 
					|| "5".equals(area.getType())) {//区域树形节点的展开：一直展开到社区(社区节点不展开)
				spread = true;
			}
			Tree tree = new Tree(area.getId(), area.getParentId(), area.getName(), "","", spread);
			listTree.add(tree);
		}
		Object data = FayTreeUtil.getTreeInJsonObject(listTree);
		return data;
	}
	
	
	
	
	/**
	 * @see  获取区域+楼栋+房屋列表信息并生成树形
	 * @param type  类型
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-09
	 */
	@ResponseBody
	@RequestMapping(value = "areaHouse", method = RequestMethod.GET)
	public Object areaHouse(@RequestParam(required = false) String extId,
			@RequestParam(required = false) String type, HttpServletResponse response) {
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();
		List<CcmPopTenant> list = ccmPopTenantService.findAreaBuildTenantList(new CcmPopTenant(), type);
		for (int i = 0; i < list.size(); i++) {
			CcmPopTenant ccmPopTenant = list.get(i);
			if ((StringUtils.isBlank(extId) || (extId != null && !extId.equals(ccmPopTenant.getId())))) {
				boolean spread = false;//树形节点展开状态
				if ("true".equals(ccmPopTenant.getHouseType())) {//临时借用houseType，确定树形节点的展开形式
					spread = true;
				}
				Tree tree = new Tree(ccmPopTenant.getId(), ccmPopTenant.getBuildingId().getId(), ccmPopTenant.getHouseBuild(), "","", spread);
				listTree.add(tree);
			}
		}
		Object data = FayTreeUtil.getTreeInJsonObject(listTree);
		return data;
	}
	/**
	 * @see  获取区域详情
	 * @param type  类型
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-08
	 */
	@ResponseBody
	@RequestMapping(value = "/areaNameById", method = RequestMethod.GET)
	public CcmRestResult areaNameById(String userId,HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
		CcmRestResult result = new CcmRestResult();
		if (id == null || "".equals(id)) {//参数id不对
			result.setCode(CcmRestType.ERROR_PARAM);
			return result;
		}
		Area area = restAreaService.get(id);
		result.setCode(CcmRestType.OK);
		result.setResult(area);
		return result;
	}
	/**
	 * @see  获取机构列表信息并生成树形
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-12
	 */
	@ResponseBody
	@RequestMapping(value = "officeTree", method = RequestMethod.GET)
	public Object areaTree(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Office> list = restOfficeService.findAll();
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();
		for (int i = 0; i < list.size(); i++) {
			Office office = list.get(i);
			Tree tree = new Tree(office.getId(), office.getParentId(), office.getName(), "","", false);
			listTree.add(tree);
		}
		Object data = FayTreeUtil.getTreeInJsonObject(listTree);
		CcmRestResult result = new CcmRestResult();
	    result.setCode(CcmRestType.OK);
		result.setResult(data);
		return result;
	}
	/**
	 * @see  获取机构列表信息
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-12
	 */
	@ResponseBody
	@RequestMapping(value = "/officeList", method = RequestMethod.GET)
	public CcmRestResult officeList(String userId,HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
		CcmRestResult result = new CcmRestResult();
		List<Office> list = restOfficeService.findAll();
		result.setCode(CcmRestType.OK);
		result.setResult(list);
		return result;
	}
	/**
	 * @see  获取机构详情信息
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-12
	 */
	@ResponseBody
	@RequestMapping(value = "/getOffice", method = RequestMethod.GET)
	public CcmRestResult getOffice(String userId,HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
		CcmRestResult result = new CcmRestResult();
		Office office = restOfficeService.get(id);
		result.setCode(CcmRestType.OK);
		if(office.getId()==null) {
			result.setResult("");
		}else {
			result.setResult(office);	
		}
		return result;
	}
	/**
	 * @see  添加用户
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-17
	 */
	@ResponseBody
	@RequestMapping(value = "saveUser")
	public CcmRestResult saveUser(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		CcmRestResult result = new CcmRestResult();
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		// 修正引用赋值问题，不知道为何，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
		String companyId = Global.getConfig("WECHAT_USER_COMPANY");//微信注册用户机构
		String officeId = Global.getConfig("WECHAT_USER_OFFICE");//微信注册用户部门
		user.setCompany(new Office(companyId));
		user.setOffice(new Office(officeId));
		// 如果新密码为空，则不更换密码
		if (StringUtils.isNotBlank(user.getNewPassword())) {
			user.setPassword(SystemService.entryptPassword(user.getNewPassword()));
		}
		if (!beanValidator(model, user)){
			result.setCode(CcmRestType.ERROR_PARAM);
			return result;
		}
		if (!"true".equals(checkLoginName(user.getOldLoginName(), user.getLoginName()))){
			addMessage(model, "保存用户'" + user.getLoginName() + "'失败，登录名已存在");
			result.setCode(CcmRestType.ERROR_SAME_USER_LOGON);
			return result;
		}
		// 为用户添加角色
		List<Role> roleList = Lists.newArrayList();
		
		Role role = systemService.getRole(Global.getConfig("WECHAT_USER_ROLE"));
		roleList.add(role);
		user.setRoleList(roleList);
		user.setNo("000000");;
		user.setCreateBy(new User("1"));
		user.setUpdateBy(new User("1"));
		//微信用户 loginName 与 name 相同
//		user.setName(user.getLoginName());
		// 保存用户信息
		systemService.saveUser(user);
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())){
			UserUtils.clearCache();
			//UserUtils.getCacheMap().clear();
		}
		addMessage(redirectAttributes, "保存用户'" + user.getLoginName() + "'成功");
		result.setCode(CcmRestType.OK);
//		result.setResult(list);
		return result;
	}
	/**
	 * 验证登录名是否有效
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String oldLoginName, String loginName) {
		if (loginName !=null && loginName.equals(oldLoginName)) {
			return "true";
		} else if (loginName !=null && systemService.getUserByLoginName(loginName) == null) {
			return "true";
		}
		return "false";
	}

	/**
	 * @see  获取区域信息（通过区域code，获取其对象信息），上下级域数据同步使用
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-05-9
	 */
	@ResponseBody
	@RequestMapping(value = "/getAreaByCode", method = RequestMethod.GET)
	public CcmRestResult getAreaByCode(HttpServletRequest req, HttpServletResponse resp, String code) throws IOException {
		CcmRestResult result = new CcmRestResult();
		List<Area> areaList= areaService.getByCode(code);
		result.setCode(CcmRestType.OK);
		result.setResult(areaList.get(0));
		return result;
	}

	/**
	 * @see  获取区域列表信息（通过区域父节点id，获取其所有子节点的所有信息），上下级域数据同步使用
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-05-9
	 */
	@ResponseBody
	@RequestMapping(value = "/getAreaListByParentID", method = RequestMethod.GET)
	public CcmRestResult getAreaListByParentID(HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
		CcmRestResult result = new CcmRestResult();
		Area area = new Area();
		area.setId(id);
		List<Area> areaList= areaService.getChildrenList(area);
		result.setCode(CcmRestType.OK);
		result.setResult(areaList);
		return result;
	}


	/**
	 * 记录app报错日志信息
	 */
	private static LogDao logDao = SpringContextHolder.getBean(LogDao.class);
	@ResponseBody
	@RequestMapping(value = "/saveLog", method = RequestMethod.GET)
	public CcmRestResult saveLog(Log log, String id){
		CcmRestResult result = new CcmRestResult();
		log.setId(id);
		log.preInsert();
		log.setCreateBy(new User(id));
		logDao.insert(log);
		result.setCode(CcmRestType.OK);
		return result;
	}

}