/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.home.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.plm.home.dao.PlmPortalDetailDao;
import com.arjjs.ccm.modules.plm.home.entity.PlmPortalDetail;

/**
 * 门户明细Service
 * @author liuxue
 * @version 2018-07-04
 */
@Service
@Transactional(readOnly = true)
public class PlmPortalDetailService extends CrudService<PlmPortalDetailDao, PlmPortalDetail> {

	public PlmPortalDetail get(String id) {
		return super.get(id);
	}
	
	public List<PlmPortalDetail> findList(PlmPortalDetail plmPortalDetail) {
		return super.findList(plmPortalDetail);
	}
	
	public Page<PlmPortalDetail> findPage(Page<PlmPortalDetail> page, PlmPortalDetail plmPortalDetail) {
		return super.findPage(page, plmPortalDetail);
	}
	
	@Transactional(readOnly = false)
	public void save(PlmPortalDetail plmPortalDetail) {
		super.save(plmPortalDetail);
	}
	
	@Transactional(readOnly = false)
	public void delete(PlmPortalDetail plmPortalDetail) {
		super.delete(plmPortalDetail);
	}
	
}