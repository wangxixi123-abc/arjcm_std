package com.arjjs.ccm.modules.ccm.rest.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.service.entity.CcmCommunityWork;
import com.arjjs.ccm.modules.ccm.service.entity.CcmServiceGuidance;
import com.arjjs.ccm.modules.ccm.service.entity.CcmServiceOnline;
import com.arjjs.ccm.modules.ccm.service.service.CcmCommunityWorkService;
import com.arjjs.ccm.modules.ccm.service.service.CcmServiceGuidanceService;
import com.arjjs.ccm.modules.ccm.service.service.CcmServiceOnlineService;
import com.arjjs.ccm.modules.ccm.sys.entity.CcmWorkReport;
import com.arjjs.ccm.modules.sys.entity.Dict;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.DictUtils;
import com.arjjs.ccm.tool.CommUtilRest;

/**
 * 社区服务
 * 
 * @author arj
 * @version 2018-03-12
 */
@Controller
@RequestMapping(value = "${appPath}/rest/service/online")
public class CcmRestServiceOnline extends BaseController {
	private static final String STATUS = "01";
	@Autowired
	private CcmServiceOnlineService ccmServiceOnlineService;

	/**
	 * @see 获取单个在线办事
	 * @param id
	 *           在线办事ID
	 * @return
	 * @author fuxinshuang
	 * @version 2018-03-15
	 */
	@ResponseBody
	@RequestMapping(value = "/get", method = RequestMethod.GET)
	public CcmRestResult get(String userId, HttpServletRequest req, HttpServletResponse resp, String id)
			throws IOException {
		// 获取results
		CcmRestResult result = CommUtilRest.getResult(userId, req, resp, id);
		// 如果当前的 flag 为返回
		if (result.isReturnFlag()) {
			return result;
		}
		// 当前 是否为空
		CcmServiceOnline ccmServiceOnline = ccmServiceOnlineService.get(id);

		String file = ccmServiceOnline.getFile();

		if (StringUtils.isNotEmpty(file)) {
			String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
			ccmServiceOnline.setFile(fileUrl + file);
		}

		result.setCode(CcmRestType.OK);
		result.setResult(ccmServiceOnline);

		return result;
	}

	/**
	 * @see 查询我的在线办事信息
	 * @param pageNo
	 *            页码
	 * @param pageSiz
	 *            分页大小
	 * @return
	 * @author fuxinshuang
	 * @version 2018-03-15
	 */
	@ResponseBody
	@RequestMapping(value = "/query", method = RequestMethod.GET)
	public CcmRestResult query(String userId, HttpServletRequest req, HttpServletResponse resp,
			CcmServiceOnline ccmServiceOnline) throws IOException {
		// 获取结果
		CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
		// 如果当前的 flag 为返回
		if (result.isReturnFlag()) {
			return result;
		}
		// 设置当前的 在线办事不为空
		ccmServiceOnline = (null == ccmServiceOnline) ? new CcmServiceOnline() : ccmServiceOnline;
		if(null == ccmServiceOnline.getType()) {
			ccmServiceOnline.setType("");
		}
		// 获取userId
		User userEntity = new User();
		userEntity.setId(userId);
		ccmServiceOnline.setCreateBy(userEntity);
		// 设置当前用户 为自身
		ccmServiceOnline.setSelf(true);
		//设置当前的用户   
		ccmServiceOnline.setCurrentUser(userEntity);
		Page<CcmServiceOnline> page = ccmServiceOnlineService.findPage(new Page<CcmServiceOnline>(req, resp),
				(null == ccmServiceOnline) ? new CcmServiceOnline() : ccmServiceOnline);
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		// 输出结果
		return result;
	}

	/**
	 * @see 填加在线补充
	 * @param ccmServiceOnline
	 *            在线办事对象
	 * @author fuxinshuang
	 * @version 2018-03-13
	 */
	@ResponseBody
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public CcmRestResult modify(String userId, CcmServiceOnline ccmServiceOnline, HttpServletRequest req,
			HttpServletResponse resp) throws IOException {
		// 获取结果
		CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
		// 如果当前的 flag 为返回
		if (result.isReturnFlag()) {
			return result;
		}
		// 不允许修改已发送在线办事
		if (ccmServiceOnline.getId()!=null && !"".equals(ccmServiceOnline.getId())) {
			result.setCode(CcmRestType.ERROR_NO_MODIFY_PERMISSIONS);
			return result;
		}
		// 如果创建者为空
		if (null == ccmServiceOnline.getCreateBy()) {
			ccmServiceOnline.setCreateBy(new User(userId));
		}
		ccmServiceOnline.setStatus(STATUS);
		ccmServiceOnline.setUpdateBy(new User(userId));
		ccmServiceOnlineService.save(ccmServiceOnline);
		// 返回
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
	}


}