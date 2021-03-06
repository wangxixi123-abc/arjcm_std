/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.flat.deviceuse.service;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.flat.analyst.entity.Count;
import com.arjjs.ccm.modules.flat.deviceuse.dao.CcmDeviceUseDao;
import com.arjjs.ccm.modules.flat.deviceuse.entity.CcmDeviceUse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 移动设备使用记录实体类Service
 * 
 * @author lgh
 * @version 2019-07-12
 */
@Service
@Transactional(readOnly = true)
public class CcmDeviceUseService extends CrudService<CcmDeviceUseDao, CcmDeviceUse> {

	@Autowired
	private CcmDeviceUseDao ccmDeviceUseDao;

	public CcmDeviceUse getByDeviceId(String deviceId) {
		return ccmDeviceUseDao.getByDeviceId(deviceId);
	}

	public List<Count> countUseTime(String userId, String beginDate, String endDate) {
		return ccmDeviceUseDao.countUseTime(userId, beginDate, endDate);
	}

	public List<Count> getDataByDept(String[] ids) {
		return ccmDeviceUseDao.getDataByDept(ids);
	}

	public CcmDeviceUse get(String id) {
		return super.get(id);
	}

	public List<CcmDeviceUse> findList(CcmDeviceUse ccmDeviceUse) {
		return super.findList(ccmDeviceUse);
	}

	public Page<CcmDeviceUse> findPage(Page<CcmDeviceUse> page, CcmDeviceUse ccmDeviceUse) {
		return super.findPage(page, ccmDeviceUse);
	}

	@Transactional(readOnly = false)
	public void save(CcmDeviceUse ccmDeviceUse) {
		super.save(ccmDeviceUse);
	}

	@Transactional(readOnly = false)
	public void delete(CcmDeviceUse ccmDeviceUse) {
		super.delete(ccmDeviceUse);
	}

}