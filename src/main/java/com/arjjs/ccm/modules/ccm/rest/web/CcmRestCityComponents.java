package com.arjjs.ccm.modules.ccm.rest.web;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.pbs.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDevice;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmDeviceService;
import com.arjjs.ccm.modules.ccm.citycomponents.entity.CcmCityComponents;
import com.arjjs.ccm.modules.ccm.citycomponents.entity.CcmLand;
import com.arjjs.ccm.modules.ccm.citycomponents.service.CcmCityComponentsService;
import com.arjjs.ccm.modules.ccm.citycomponents.service.CcmLandService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.sys.entity.User;

/**
 * 城市部件接口类
 * 
 * @author pengjianqiang
 * @version 2018-02-23
 */
@Controller
@RequestMapping(value = "${appPath}/rest/cityComponents")
public class CcmRestCityComponents extends BaseController {

	@Autowired
	private CcmCityComponentsService ccmCityComponentsService;
	
	@Autowired
	private CcmLandService ccmLandService;

	@Autowired
	private CcmDeviceService ccmDeviceService;

	/**
	 * @see  获取单个城市部件信息
	 * @param id  ID
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-02-23
	 */
	@ResponseBody
	@RequestMapping(value="/getCityComponent", method = RequestMethod.GET)
	public CcmRestResult getCityComponent(String userId,HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		if (id == null || "".equals(id)) {//参数id不对
			result.setCode(CcmRestType.ERROR_PARAM);
			return result;
		}
		
		CcmCityComponents ccmCityComponent = ccmCityComponentsService.get(id);
		String file = Global.getConfig("FILE_UPLOAD_URL");
		if(StringUtils.isNotEmpty(ccmCityComponent.getImagePath()) && !ccmCityComponent.getImagePath().contains(file)){
			ccmCityComponent.setImagePath(file + ccmCityComponent.getImagePath());
		}

		result.setCode(CcmRestType.OK);
		result.setResult(ccmCityComponent);
		
		return result;
	}
	
	/**
	 * @see  查询城市部件信息
	 * @param ccmCityComponent
	 * @param pageNo 页码
	 * @param pageSize 分页大小
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-02-23
	 */
	@ResponseBody
	@RequestMapping(value="/queryCityComponent", method = RequestMethod.GET)
	public CcmRestResult queryCityComponent(String userId,CcmCityComponents ccmCityComponent, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}

		ccmCityComponent.setCheckUser(sessionUser);
		Page<CcmCityComponents> page = ccmCityComponentsService.findPage(new Page<CcmCityComponents>(req, resp), ccmCityComponent);
		if(page.getList().size()>0){
			String file = Global.getConfig("FILE_UPLOAD_URL");
			for(CcmCityComponents resccmCityComponents : page.getList()){
				if(StringUtils.isNotEmpty(resccmCityComponents.getImagePath()) && !resccmCityComponents.getImagePath().contains(file)){
					resccmCityComponents.setImagePath(file + resccmCityComponents.getImagePath());
				}
			}
		}
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		
		return result;
	}
	/**
	 * @see  保存城市部件信息
	 * @param 
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-06
	 */
	@ResponseBody
	@RequestMapping(value="/saveCityComponent", method = RequestMethod.POST)
	public CcmRestResult saveCityComponent(String userId,CcmCityComponents ccmCityComponent, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		if (ccmCityComponent.getId()!= null && !"".equals(ccmCityComponent.getId())) {
			CcmCityComponents ccmCityComponentDB = ccmCityComponentsService.get(ccmCityComponent.getId());
			if (ccmCityComponentDB == null ) {//从数据库中没有取到对应数据
				result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
				return result;
			}
			ccmCityComponent.setAreaPoint(ccmCityComponentDB.getAreaPoint());
			ccmCityComponent.setAreaMap(ccmCityComponentDB.getAreaMap());
		}else{
			ccmCityComponent.setAreaPoint("");
			ccmCityComponent.setAreaMap("");
		}
		if (ccmCityComponent.getCreateBy()== null) {
			ccmCityComponent.setCreateBy(new User(userId));
		}
		ccmCityComponent.setUpdateBy(new User(userId));
		String file = ccmCityComponent.getImagePath();
			if(StringUtils.isNotEmpty(file)) {
			if(file.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
				ccmCityComponent.setImagePath(file.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
			}else {
				ccmCityComponent.setImagePath(file);
			}
		}

		ccmCityComponentsService.save(ccmCityComponent);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}
	/**
	 * @see  获取单个土地信息
	 * @param id  ID
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-02-23
	 */
	@ResponseBody
	@RequestMapping(value="/getLand", method = RequestMethod.GET)
	public CcmRestResult getLand(String userId,HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		if (id == null || "".equals(id)) {//参数id不对
			result.setCode(CcmRestType.ERROR_PARAM);
			return result;
		}
		
		CcmLand ccmLand = ccmLandService.get(id);
		
		result.setCode(CcmRestType.OK);
		result.setResult(ccmLand);
		
		return result;
	}
	
	/**
	 * @see  查询土地信息
	 * @param ccmLand
	 * @param pageNo 页码
	 * @param pageSize 分页大小
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-02-23
	 */
	@ResponseBody
	@RequestMapping(value="/queryLand", method = RequestMethod.GET)
	public CcmRestResult queryLand(String userId,CcmLand ccmLand, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User user = UserUtils.get(userId);
		ccmLand.setCheckUser(user);
		Page<CcmLand> page = ccmLandService.findPage(new Page<CcmLand>(req, resp), ccmLand);
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		return result;
	}
	/**
	 * @see  保存城市部件信息
	 * @param 
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-06
	 */
	@ResponseBody
	@RequestMapping(value="/saveLand", method = RequestMethod.POST)
	public CcmRestResult saveLand(String userId,CcmLand ccmLand, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		if (ccmLand.getId()!= null && !"".equals(ccmLand.getId())) {
			CcmLand ccmLandDB = ccmLandService.get(ccmLand.getId());
			if (ccmLandDB == null ) {//从数据库中没有取到对应数据
				result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
				return result;
			}
			ccmLand.setAreaPoint(ccmLandDB.getAreaPoint());
			ccmLand.setAreaMap(ccmLandDB.getAreaMap());
		}else{
			ccmLand.setAreaPoint("");
			ccmLand.setAreaMap("");
		}
		if (ccmLand.getCreateBy()== null) {
			ccmLand.setCreateBy(new User(userId));
		}
		ccmLand.setUpdateBy(new User(userId));
		ccmLandService.save(ccmLand);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}

	/**
	 * @see  获取单个网络设备信息
	 * @param id  ID
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-02-23
	 * @param userId 
	 */
	@ResponseBody
	@RequestMapping(value="/getDevice", method = RequestMethod.GET)
	public CcmRestResult getDevice(HttpServletRequest req, HttpServletResponse resp, String id, String userId) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		if (id == null || "".equals(id)) {//参数id不对
			result.setCode(CcmRestType.ERROR_PARAM);
			return result;
		}
		
		CcmDevice ccmDevice = ccmDeviceService.get(id);
		
		result.setCode(CcmRestType.OK);
		result.setResult(ccmDevice);
		
		return result;
	}
	
	/**
	 * @see  查询网络设备信息
	 * @param CcmDevice
	 * @param pageNo 页码
	 * @param pageSize 分页大小
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-02-23
	 * @param userId 
	 */
	@ResponseBody
	@RequestMapping(value="/queryDevice", method = RequestMethod.GET)
	public CcmRestResult queryDevice(CcmDevice ccmDevice, HttpServletRequest req, HttpServletResponse resp, String userId) throws IOException {
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}

		ccmDevice.setCheckUser(sessionUser);
		Page<CcmDevice> page = ccmDeviceService.findPage(new Page<CcmDevice>(req, resp), ccmDevice);
	
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		
		return result;
	}
	
	

	/**
	 * @see  保存城市部件信息（支持新增和编辑,数据同步用）
	 * @param 
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-05-12
	 */
	@ResponseBody
	@RequestMapping(value="/saveSyn", method = RequestMethod.POST)
	public CcmRestResult saveSyn(String userId,CcmCityComponents ccmCityComponent,HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		if (userId == null || "".equals(userId)) {
			userId = "1";
		}
		User user = new User(userId);
		ccmCityComponent.setCreateBy(user);
		ccmCityComponent.setUpdateBy(user);
		
		ccmCityComponentsService.save(ccmCityComponent);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}

	/**
	 * @see  删除城市部件信息（数据同步用）
	 * @param 
	 * @return 
	 * @author pengjianqiang
	 * @version 2018-05-17
	 */
	@ResponseBody
	@RequestMapping(value="/deleteSyn", method = RequestMethod.POST)
	public CcmRestResult deleteSyn(String userId,CcmCityComponents ccmCityComponent,HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		ccmCityComponentsService.delete(ccmCityComponent);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}
	

}