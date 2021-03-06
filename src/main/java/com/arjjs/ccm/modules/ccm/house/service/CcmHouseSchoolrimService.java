/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseSchoolrim;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SearchTabMore;
import com.arjjs.ccm.tool.SysConfigInit;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmUploadLog;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmUploadLogService;
import com.arjjs.ccm.modules.ccm.house.dao.CcmHouseSchoolrimDao;

/**
 * 学校Service
 * 
 * @author wwh
 * @version 2018-01-10
 */
@Service
@Transactional(readOnly = true)
public class CcmHouseSchoolrimService extends CrudService<CcmHouseSchoolrimDao, CcmHouseSchoolrim> {

	@Autowired
	private CcmHouseSchoolrimDao ccmHouseSchoolrimDao;

	//上传上级平台记录
	@Autowired
	private CcmUploadLogService ccmUploadLogService;
	
	public CcmHouseSchoolrim get(String id) {
		return super.get(id);
	}

	public List<CcmHouseSchoolrim> findList(CcmHouseSchoolrim ccmHouseSchoolrim) {
		return super.findList(ccmHouseSchoolrim);
	}

	public Page<CcmHouseSchoolrim> findPage(Page<CcmHouseSchoolrim> page, CcmHouseSchoolrim ccmHouseSchoolrim) {
		return super.findPage(page, ccmHouseSchoolrim);
	}

	@Transactional(readOnly = false)
	public void save(CcmHouseSchoolrim ccmHouseSchoolrim) {
		boolean isNew = false;
		if (ccmHouseSchoolrim.getId() == null || "".equals(ccmHouseSchoolrim.getId())) {//无主键ID，则是新记录
			isNew = true;
		}
		if (ccmHouseSchoolrim.getIsNewRecord()) {//指定了是新增记录，则算新记录
			isNew = true;
		}
		
		super.save(ccmHouseSchoolrim);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			if (isNew) {//新增数据
				uploadLog.setOperateType("1");
				uploadLog.setRemarks("新增学校数据：" + ccmHouseSchoolrim.getSchoolName());
			} else {//编辑数据
				uploadLog.setOperateType("2");
				uploadLog.setRemarks("编辑学校数据：" + ccmHouseSchoolrim.getSchoolName());
			}
			uploadLog.setTableName("ccm_house_schoolrim");
			uploadLog.setDataId(ccmHouseSchoolrim.getId());
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
	public void delete(CcmHouseSchoolrim ccmHouseSchoolrim) {
		super.delete(ccmHouseSchoolrim);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			uploadLog.setOperateType("3");
			uploadLog.setRemarks("删除学校数据：" + ccmHouseSchoolrim.getSchoolName());
			uploadLog.setTableName("ccm_house_schoolrim");
			uploadLog.setDataId(ccmHouseSchoolrim.getId());
			uploadLog.setUploadStatus("1");
			User user = UserUtils.getUser();
			if (user == null || StringUtils.isBlank(user.getId())){
				uploadLog.setCreateBy(new User("1"));
				uploadLog.setUpdateBy(new User("1"));
			}
			ccmUploadLogService.save(uploadLog);
		}
	}

	// 更新点位坐标信息
	@Transactional(readOnly = false)
	public boolean updateCoordinates(CcmHouseSchoolrim CcmHouseSchoolrim) {
		return ccmHouseSchoolrimDao.updateCoordinates(CcmHouseSchoolrim)>0;
	}

	//校园周边重点人员区域树
	public List<CcmHouseSchoolrim> findListSP(CcmHouseSchoolrim ccmHouseSchoolrim) {
		return ccmHouseSchoolrimDao.findListSP(ccmHouseSchoolrim);
	}

	//街道信息-大屏-滨海新区社会网格化管理信息平台
	public List<SearchTab> findListAllData(CcmHouseSchoolrim ccmHouseSchoolrim) {
		return ccmHouseSchoolrimDao.findListAllData(ccmHouseSchoolrim);
	}

	//学生人数、教职工人数、教学经费getCountInfo
	public SearchTabMore getCountInfo() {
		return ccmHouseSchoolrimDao.getCountInfo();
	}
	
	public List<EchartType> selectSchoolNumAllByOffice() {
		return dao.selectSchoolNumAllByOffice() ;
	}
	
	public List<EchartType> selectschoolEventAmbiScale() {
		return dao.selectschoolEventAmbiScale() ;
	}
	
	//查询所有学校的所属区域并分组
	public List<CcmHouseSchoolrim> getAreaBySchool(){
		return ccmHouseSchoolrimDao.getAreaBySchool();
	}
}