/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.broadcast.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.ccm.broadcast.entity.CcmDeviceBroadcast;
import com.arjjs.ccm.modules.ccm.broadcast.dao.CcmDeviceBroadcastDao;

/**
 * 广播站Service
 * @author maoxb
 * @version 2019-08-28
 */
@Service
@Transactional(readOnly = true)
public class CcmDeviceBroadcastService extends CrudService<CcmDeviceBroadcastDao, CcmDeviceBroadcast> {

	public CcmDeviceBroadcast get(String id) {
		return super.get(id);
	}
	
	public List<CcmDeviceBroadcast> findList(CcmDeviceBroadcast ccmDeviceBroadcast) {
		return super.findList(ccmDeviceBroadcast);
	}
	
	public Page<CcmDeviceBroadcast> findPage(Page<CcmDeviceBroadcast> page, CcmDeviceBroadcast ccmDeviceBroadcast) {
		return super.findPage(page, ccmDeviceBroadcast);
	}
	
	@Transactional(readOnly = false)
	public void save(CcmDeviceBroadcast ccmDeviceBroadcast) {
		super.save(ccmDeviceBroadcast);
	}
	
	@Transactional(readOnly = false)
	public void delete(CcmDeviceBroadcast ccmDeviceBroadcast) {
		super.delete(ccmDeviceBroadcast);
	}

	@Transactional(readOnly = false)
    public boolean updateCoordinates(CcmDeviceBroadcast broadcast) {
		return dao.updateCoordinates(broadcast)>0;
    }

	public List<CcmDeviceBroadcast> getByCode(CcmDeviceBroadcast deviceBroadcast) {
		return dao.getByCode(deviceBroadcast);
	}
}