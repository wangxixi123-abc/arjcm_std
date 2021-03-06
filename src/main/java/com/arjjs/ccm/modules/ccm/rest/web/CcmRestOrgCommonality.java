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
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgCommonality;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgNpse;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgSocialorg;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgCommonalityService;
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
@RequestMapping(value = "${appPath}/rest/commonality")
public class CcmRestOrgCommonality extends BaseController {

	@Autowired
	private CcmOrgCommonalityService ccmOrgCommonalityService;

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
		
		CcmOrgCommonality ccmOrgCommonality = ccmOrgCommonalityService.get(id);
		String file = Global.getConfig("FILE_UPLOAD_URL");
		if(StringUtils.isNotEmpty(ccmOrgCommonality.getImages())){
			ccmOrgCommonality.setImages(file + ccmOrgCommonality.getImages());
		}
		if(StringUtils.isNotEmpty(ccmOrgCommonality.getFiles())){
			ccmOrgCommonality.setFiles(file + ccmOrgCommonality.getFiles());
		}
		result.setCode(CcmRestType.OK);
		result.setResult(ccmOrgCommonality);
		
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
	public CcmRestResult query(String userId,CcmOrgCommonality ccmOrgCommonality, HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
		ccmOrgCommonality.setCheckUser(sessionUser);
		Page<CcmOrgCommonality> page = ccmOrgCommonalityService.findPage(new Page<CcmOrgCommonality>(req, resp), ccmOrgCommonality);
		String file = Global.getConfig("FILE_UPLOAD_URL");
		if(page.getList().size() > 0){
			for(CcmOrgCommonality res : page.getList()){
				if(StringUtils.isNotEmpty(res.getImages())) {
					res.setImages(file + res.getImages());
				}
				if(StringUtils.isNotEmpty(res.getFiles())) {
					res.setFiles(file + res.getFiles());
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
	public CcmRestResult modify(String userId,CcmOrgCommonality ccmOrgCommonality, HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
		if (ccmOrgCommonality.getCreateBy()== null) {
			ccmOrgCommonality.setCreateBy(new User(userId));
		}
		String images = ccmOrgCommonality.getImages();
		String file = ccmOrgCommonality.getFiles();
		if(StringUtils.isNotEmpty(images)) {
			if(images.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
				ccmOrgCommonality.setImages(images.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
			}else {
				ccmOrgCommonality.setImages(images);
			}
		}
		if(StringUtils.isNotEmpty(file)){
			if(file.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
				ccmOrgCommonality.setFiles(file.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
			}else {
				ccmOrgCommonality.setFiles(file);
			}
		}
		ccmOrgCommonality.setUpdateBy(new User(userId));
		ccmOrgCommonalityService.save(ccmOrgCommonality);
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
		
	}

}