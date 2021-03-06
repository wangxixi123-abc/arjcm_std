/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.partybuild.service;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.ccm.partybuild.dao.CcmPartyOrganizDao;
import com.arjjs.ccm.modules.ccm.partybuild.entity.CcmPartyOrganiz;
import com.arjjs.ccm.tool.EchartType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 党组织管理Service
 * @author maoxb
 * @version 2019-08-12
 */
@Service
@Transactional(readOnly = true)
public class CcmPartyOrganizService extends CrudService<CcmPartyOrganizDao, CcmPartyOrganiz> {

	@Autowired
	private CcmPartyOrganizDao ccmPartyOrganizDao;

	public CcmPartyOrganiz get(String id) {
		return super.get(id);
	}
	
	public List<CcmPartyOrganiz> findList(CcmPartyOrganiz ccmPartyOrganiz) {
		return super.findList(ccmPartyOrganiz);
	}
	
	public Page<CcmPartyOrganiz> findPage(Page<CcmPartyOrganiz> page, CcmPartyOrganiz ccmPartyOrganiz) {
		return super.findPage(page, ccmPartyOrganiz);
	}
	
	@Transactional(readOnly = false)
	public void save(CcmPartyOrganiz ccmPartyOrganiz) {
		super.save(ccmPartyOrganiz);
	}
	
	@Transactional(readOnly = false)
	public void delete(CcmPartyOrganiz ccmPartyOrganiz) {
		super.delete(ccmPartyOrganiz);
	}

	public List<EchartType> getOrgByBussCate() {
		return ccmPartyOrganizDao.getOrgByBussCate();
	}
}