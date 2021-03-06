package com.arjjs.ccm.modules.ccm.rest.web;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.pbs.common.config.Global;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgNpse;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgSocialorg;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgNpseService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgSocialorgService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.sys.entity.User;

/**
 * 非公有制经济组织接口类
 * 
 * @author fuxinshuang
 * @version 2018-03-29
 */
@Controller
@RequestMapping(value = "${appPath}/rest/orgNpse")
public class CcmRestOrgNpse extends BaseController {

	@Autowired
	private CcmOrgNpseService ccmOrgNpseService;

	/**
	 * @see  获取单个非公有制经济组织信息
	 * @param id  ID
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-29
	 */
	@ResponseBody
	@RequestMapping(value="/get", method = RequestMethod.GET)
	public CcmRestResult get(String userId,HttpServletRequest req, HttpServletResponse resp, String id) throws IOException {
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
		
		CcmOrgNpse ccmOrgNpse = ccmOrgNpseService.get(id);
		String images = ccmOrgNpse.getImages();
		if (StringUtils.isNotEmpty(images)) {
			String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
			ccmOrgNpse.setImages(fileUrl + images);
		}
		result.setCode(CcmRestType.OK);
		result.setResult(ccmOrgNpse);
		
		return result;
	}
	
	/**
	 * @see  查询个非公有制经济组织列表
	 * @param ccmOrgNpse
	 * @param pageNo 页码
	 * @param pageSize 分页大小
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-29
	 */
	@ResponseBody
	@RequestMapping(value="/query", method = RequestMethod.GET)
	public CcmRestResult query(String userId,CcmOrgNpse ccmOrgNpse, HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
		ccmOrgNpse.setCheckUser(sessionUser);
		Page<CcmOrgNpse> page = ccmOrgNpseService.findPage(new Page<CcmOrgNpse>(req, resp), ccmOrgNpse);
		String file = Global.getConfig("FILE_UPLOAD_URL");
		if(page.getList().size() > 0){
			for(CcmOrgNpse res : page.getList()){
				if(StringUtils.isNotEmpty(res.getImages())) {
					res.setImages(file + res.getImages());
				}
			}
		}

		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		
		return result;
	}
	
	/**
	 * @see  保存非公有制经济组织信息
	 * @param 
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-03-29
	 */
	@ResponseBody
	@RequestMapping(value="/save", method = RequestMethod.POST)
	public CcmRestResult modify(String Flag, String userId,CcmOrgNpse ccmOrgNpse, HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
		if (ccmOrgNpse.getId()!= null && !"".equals(ccmOrgNpse.getId())) {
			CcmOrgNpse ccmOrgNpseDB = ccmOrgNpseService.get(ccmOrgNpse.getId());
			if (ccmOrgNpseDB == null ) {//从数据库中没有取到对应数据
				result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
				return result;
			}
			ccmOrgNpse.setAreaPoint(ccmOrgNpseDB.getAreaPoint());
			ccmOrgNpse.setAreaMap(ccmOrgNpseDB.getAreaMap());
			ccmOrgNpse.setIcon(ccmOrgNpseDB.getIcon());
		}else{
			ccmOrgNpse.setAreaPoint("");
			ccmOrgNpse.setAreaMap("");
			ccmOrgNpse.setIcon("");
		}
		if (ccmOrgNpse.getCreateBy()== null) {
			ccmOrgNpse.setCreateBy(new User(userId));
		}
		ccmOrgNpse.setUpdateBy(new User(userId));
		String file = ccmOrgNpse.getImages();
		if(StringUtils.isNotEmpty(file)) {
			if(file.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
				ccmOrgNpse.setImages(file.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
			}else {
				ccmOrgNpse.setImages(file);
			}
		}
		ccmOrgNpseService.save(ccmOrgNpse);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}

	/**
	 * @see  保存非公有制经济组织（支持新增和编辑,数据同步用）
	 * @param 
	 * @return 
	 * @author liangwanmin
	 * @version 2018-05-21
	 */
	@ResponseBody
	@RequestMapping(value="/saveSyn", method = RequestMethod.POST)
	public CcmRestResult saveSyn(String userId,CcmOrgNpse ccmOrgNpse,HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		if (userId == null || "".equals(userId)) {
			userId = "1";
		}
		User user = new User(userId);
		ccmOrgNpse.setCreateBy(user);
		ccmOrgNpse.setUpdateBy(user);
		
		ccmOrgNpseService.save(ccmOrgNpse);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}

	/**
	 * @see  删除非公有制经济组织信息（数据同步用）
	 * @param 
	 * @return 
	 * @author liangwanmin
	 * @version 2018-05-21
	 */
	@ResponseBody
	@RequestMapping(value="/deleteSyn", method = RequestMethod.POST)
	public CcmRestResult deleteSyn(String userId,CcmOrgNpse ccmOrgNpse,HttpServletRequest req, HttpServletResponse resp) throws IOException {
		CcmRestResult result = new CcmRestResult();
		ccmOrgNpseService.delete(ccmOrgNpse);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}
	
	
	
	
	
	
	
}