package com.arjjs.ccm.modules.ccm.rest.web;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.service.entity.PbsCourseinfo;
import com.arjjs.ccm.modules.ccm.service.service.PbsCourseinfoService;
import com.arjjs.ccm.modules.sys.entity.User;

/**
 * 业务学习类
 * 
 * @author pengjianqiang
 * @version 2018-02-02
 */
@Controller
@RequestMapping(value = "${appPath}/rest/pbsCourseinfo")
public class CcmRestPbsCourseInfo extends BaseController {

	@Autowired
	private PbsCourseinfoService pbsCourseinfoService;
	


	/**
	 * @see  获取单个业务学习信息
	 * @return sName 课程名称
	 * @author pengjianqiang
	 * @version 2018-02-02
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
		
		PbsCourseinfo pbsCourseinfo = pbsCourseinfoService.get(id);
		String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
		if (StringUtils.isNotEmpty(pbsCourseinfo.getSFileurl())) {
			pbsCourseinfo.setSFileurl(fileUrl + pbsCourseinfo.getSFileurl());
		}
		if (StringUtils.isNotEmpty(pbsCourseinfo.getsIconurl())){
			pbsCourseinfo.setsIconurl(fileUrl + pbsCourseinfo.getsIconurl());
		}

		result.setCode(CcmRestType.OK);
		result.setResult(pbsCourseinfo);
		
		return result;
	}
	
	/**
	 * @see  查询业务学习信息
	 * @param sName  课程名称
	 * @param sType 课程类型 
	 * @param pageNo 页码
	 * @param pageSize 分页大小
	 * @return 
	 * @author fuxinshuang
	 * @version 2018-02-03
	 */
	@ResponseBody
	@RequestMapping(value="/query", method = RequestMethod.GET)
	public CcmRestResult query(String userId,PbsCourseinfo pbsCourseinfo,HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
		pbsCourseinfo.setCheckUser(sessionUser);
		Page<PbsCourseinfo> page = pbsCourseinfoService
				.findPage(new Page<PbsCourseinfo>(req, resp), pbsCourseinfo);
	
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		
		return result;
	}
	
	
}