/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.line.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.line.entity.CcmLineProtect;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SysConfigInit;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmUploadLog;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmUploadLogService;
import com.arjjs.ccm.modules.ccm.event.dao.CcmEventIncidentDao;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.line.dao.CcmLineProtectDao;

/**
 * 护路护线Service
 * @author arj
 * @version 2018-01-23
 */
@Service
@Transactional(readOnly = true)
public class CcmLineProtectService extends CrudService<CcmLineProtectDao, CcmLineProtect> {

	//查询相关案事件
	@Autowired
	private CcmEventIncidentDao ccmEventIncidentDao;
	//上传上级平台记录
	@Autowired
	private CcmUploadLogService ccmUploadLogService;
	
	@Autowired
	private CcmLineProtectDao ccmLineProtectDao;
		
		
	public List<CcmEventIncident> findList(String otherId) {
		if(otherId==""||otherId==null){
			return null;
		}
		CcmEventIncident ccmEventIncident = new CcmEventIncident();
		ccmEventIncident.setOtherId(otherId);
		return ccmEventIncidentDao.findOtherId(ccmEventIncident);
	}
		
	public CcmLineProtect get(String id) {
		return super.get(id);
	}
	
	public List<CcmLineProtect> findList(CcmLineProtect ccmLineProtect) {
		return super.findList(ccmLineProtect);
	}
	
	public Page<CcmLineProtect> findPage(Page<CcmLineProtect> page, CcmLineProtect ccmLineProtect) {
		return super.findPage(page, ccmLineProtect);
	}
	
	public List<EchartType> getLineByType() {
		return ccmLineProtectDao.getLineByType();
	}
	
	public List<EchartType> getLineByGrade() {
		return ccmLineProtectDao.getLineByGrade();
	}
	
	@Transactional(readOnly = false)
	public void save(CcmLineProtect ccmLineProtect) {
		boolean isNew = false;
		if (ccmLineProtect.getId() == null || "".equals(ccmLineProtect.getId())) {//无主键ID，则是新记录
			isNew = true;
		}
		if (ccmLineProtect.getIsNewRecord()) {//指定了是新增记录，则算新记录
			isNew = true;
		}
		super.save(ccmLineProtect);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			if (isNew) {//新增数据
				uploadLog.setOperateType("1");
				uploadLog.setRemarks("新增护路护线数据：" + ccmLineProtect.getName());
			} else {//编辑数据
				uploadLog.setOperateType("2");
				uploadLog.setRemarks("编辑护路护线数据：" + ccmLineProtect.getName());
			}
			uploadLog.setTableName("ccm_line_protect");
			uploadLog.setDataId(ccmLineProtect.getId());
			uploadLog.setUploadStatus("1");
			User user = UserUtils.getUser();
			if (user == null || StringUtils.isBlank(user.getId())){
				uploadLog.setCreateBy(new User("1"));
				uploadLog.setUpdateBy(new User("1"));
			}
			ccmUploadLogService.save(uploadLog);
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(CcmLineProtect ccmLineProtect) {
		super.delete(ccmLineProtect);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			uploadLog.setOperateType("3");
			uploadLog.setRemarks("删除护路护线数据：" + ccmLineProtect.getName());
			uploadLog.setTableName("ccm_line_protect");
			uploadLog.setDataId(ccmLineProtect.getId());
			uploadLog.setUploadStatus("1");
			User user = UserUtils.getUser();
			if (user == null || StringUtils.isBlank(user.getId())){
				uploadLog.setCreateBy(new User("1"));
				uploadLog.setUpdateBy(new User("1"));
			}
			ccmUploadLogService.save(uploadLog);
		}
	}
	
}