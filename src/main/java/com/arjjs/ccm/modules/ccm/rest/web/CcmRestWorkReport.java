package com.arjjs.ccm.modules.ccm.rest.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.arjjs.ccm.modules.sys.service.SystemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.rest.service.CcmRestOfficeService;
import com.arjjs.ccm.modules.ccm.sys.entity.CcmWorkReport;
import com.arjjs.ccm.modules.ccm.sys.service.CcmWorkReportService;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.OfficeService;
import com.arjjs.ccm.tool.CommUtilRest;
import com.arjjs.ccm.tool.Tree;
import com.fay.tree.service.IFayTreeNode;
import com.fay.tree.util.FayTreeUtil;

/**
 * 工作日志
 * 
 * @author arj
 * @version 2018-03-12
 */
@Controller
@RequestMapping(value = "${appPath}/rest/service/ccmWorkReport")
public class CcmRestWorkReport extends BaseController {

	@Autowired
	private CcmWorkReportService ccmWorkReportService;
	@Autowired
	private OfficeService officeService;
	@Autowired
	private CcmRestOfficeService restOfficeService;

	@Autowired
	private SystemService systemService;

	/**
	 * @see 获取单个工作日志
	 * @param id 社区服务ID
	 * @return
	 * @author arj
	 * @version 2018-03-12
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
		CcmWorkReport ccmWorkReport = ccmWorkReportService.get(id);
		if(StringUtils.isNotBlank(ccmWorkReport.getFiles())) {
			String[] str = ccmWorkReport.getFiles().split("|");
			StringBuilder stringBuilder = new StringBuilder();
			for (int i = 0; i < str.length; i++) {
				if (str[i].equals("|")) {
					if (i == 0) {
						str[i] = Global.getConfig("FILE_UPLOAD_URL");
					} else {
						str[i] = ";" + Global.getConfig("FILE_UPLOAD_URL");
					}
				}
				stringBuilder.append(str[i]);
			}
			ccmWorkReport.setFiles(stringBuilder.toString());
		}
		if (StringUtils.isNotEmpty(ccmWorkReport.getId())) {
			ccmWorkReport = ccmWorkReportService.getRecordList(ccmWorkReport);
		}
		result.setCode(CcmRestType.OK);
		result.setResult(ccmWorkReport);
		ccmWorkReportService.updateAppReadFlag(ccmWorkReport,userId);
		return result;
	}

	/**
	 * @see 查询服务信息
	 * @param pageNo  页码
	 * @param pageSiz 分页大小
	 * @return
	 * @author arj
	 * @version 2018-03-12
	 */
	@ResponseBody
	@RequestMapping(value = "/query", method = RequestMethod.GET)
	public CcmRestResult query(String userId, HttpServletRequest req, HttpServletResponse resp,
			CcmWorkReport ccmWorkReport) throws IOException {
		// 获取结果
		CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
		// 如果当前的 flag 为返回
		if (result.isReturnFlag()) {
			return result;
		}
		// 设置当前的 日志不为空
		ccmWorkReport = (null == ccmWorkReport) ? new CcmWorkReport() : ccmWorkReport;
		// 获取userId
		User userEntity = new User();
		userEntity.setId(userId);
		ccmWorkReport.setCreateBy(userEntity);
		Page<CcmWorkReport> page = ccmWorkReportService.findPage(new Page<CcmWorkReport>(req, resp), ccmWorkReport);
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		// 输出结果
		return result;
	}

	// 返回
	@RequestMapping(value = "selfData")
	@ResponseBody
	public CcmRestResult listData(String userId, CcmWorkReport ccmWorkReport, HttpServletRequest request,
			HttpServletResponse response) {
		// 获取结果
		CcmRestResult result = CommUtilRest.queryResult(userId, request, response);
		// 如果当前的 flag 为返回
		if (result.isReturnFlag()) {
			return result;
		}
		// 设置当前用户 为自身
		ccmWorkReport.setSelf(true);
		//设置当前的用户   
		User userEntity = new User();
		userEntity.setId(userId);
		ccmWorkReport.setCurrentUser(userEntity);
		Page<CcmWorkReport> page = ccmWorkReportService.findPage(new Page<CcmWorkReport>(request, response),
				ccmWorkReport);
		// 传出 结果
		result.setCode(CcmRestType.OK);
		result.setResult(page.getList());
		return result;
	}

	/**
	 * @see 修改 社区服务
	 * @param ccmCommunityWork  社区服务对象
	 * @author arj
	 * @version 2018-02-03
	 */
	@ResponseBody
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public CcmRestResult modify(String userId, CcmWorkReport ccmWorkReport, HttpServletRequest req,
			HttpServletResponse resp) throws IOException {
		// 获取结果
		CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
		// 不允许修改已发送日志
		if (ccmWorkReport.getId()!=null && !"".equals(ccmWorkReport.getId())) {
			result.setCode(CcmRestType.ERROR_NO_MODIFY_PERMISSIONS);
			return result;
		}
		// 如果当前的 flag 为返回
		if (result.isReturnFlag()) {
			return result;
		}
		// 判断是否过期 dt1.getTime() > dt2.getTime()
		Date dt1 = new Date();
		Date dt2 = ccmWorkReport.getEndDate();
		if (dt1.getTime() > dt2.getTime()) {
			ccmWorkReport.setStatus("1");
		} else {
			ccmWorkReport.setStatus("0");
		}
		// 如果创建者为空
		if (null == ccmWorkReport.getCreateBy()) {
			ccmWorkReport.setCreateBy(new User(userId));
		}
		ccmWorkReport.setUpdateBy(new User(userId));
		ccmWorkReportService.save(ccmWorkReport);
		// 返回
		result.setCode(CcmRestType.OK);
		result.setResult("成功");
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "treeData")
	public Object treeData(@RequestParam(required = false) String extId,
			@RequestParam(required = false) String type, @RequestParam(required = false) Long grade,
			@RequestParam(required = false) Boolean isAll, HttpServletResponse response) {
		CcmRestResult result = new CcmRestResult();
		/*List<Map<String, Object>> mapList = Lists.newArrayList();*/
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();
		List<Office> list = restOfficeService.findOfficeUser();
		for (int i = 0; i < list.size(); i++) {
			Office e = list.get(i);
			/*if ((StringUtils.isBlank(extId)
					|| (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1))
					&& (type == null || (type != null && (type.equals("1") ? type.equals(e.getType()) : true)))
					&& (grade == null || (grade != null && Integer.parseInt(e.getGrade()) <= grade.intValue()))
					&& Global.YES.equals(e.getUseable())) {*/
				
				Tree tree = new Tree(e.getId(), e.getParentId(), e.getName(), "","", false);
				listTree.add(tree);
				/*Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("pIds", e.getParentIds());
				map.put("name", e.getName());
				if (type != null && "3".equals(type)) {
					map.put("isParent", true);
				}
				mapList.add(map);*/
			/*}*/
		}
		Object data = FayTreeUtil.getTreeInJsonObject(listTree);
		result.setCode(CcmRestType.OK);
		result.setResult(data);
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "allTreeData")
	public Object allTreeData() {
		CcmRestResult ccmRestResult=new CcmRestResult();
		List<Office> list = this.officeService.findList(true);
		List<IFayTreeNode> listTree = new ArrayList<IFayTreeNode>();

		for(int i = 0; i < list.size(); ++i) {
			Office e = list.get(i);
			Tree tree = new Tree(e.getId(), e.getParentId(), e.getName(), "","", false);
			listTree.add(tree);
			List<User> userByOfficeId = systemService.findUserByOfficeId(e.getId());
			userByOfficeId.forEach(item->{
				Tree temp = new Tree(item.getId(), e.getId(), item.getName(), "","people", false);
				listTree.add(temp);
			});
		}
		ccmRestResult.setCode(CcmRestType.OK);
		ccmRestResult.setResult(FayTreeUtil.getTreeInJsonObject(listTree));
		return ccmRestResult;
	}


	/**
             * @see 查询接受人详情
             * @param ccmWorkReport
             * @author fuxinshuang
             * @version 2018-04-20
             */
	@ResponseBody
	@RequestMapping(value = "/acceptUsers", method = RequestMethod.GET)
	public CcmRestResult acceptUsers(String userId, String ccmWorkReportReadIds, HttpServletRequest req,
			HttpServletResponse resp) throws IOException {
		// 获取结果
		CcmRestResult result = new CcmRestResult();
		CcmWorkReport ccmWorkReport = ccmWorkReportService.findUsers(ccmWorkReportReadIds);
		result.setCode(CcmRestType.OK);
		result.setResult(ccmWorkReport);
		return result;
	}
}