/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.work.service;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.ccm.work.dao.CcmWorkBeondutyDao;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeonduty;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeondutyExport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 值班表Service
 * @author liang
 * @version 2018-06-12
 */
@Service
@Transactional(readOnly = true)
public class CcmWorkBeondutyService extends CrudService<CcmWorkBeondutyDao, CcmWorkBeonduty> {

	@Autowired
	private CcmWorkBeondutyDao ccmWorkBeondutyDao;

	public CcmWorkBeonduty get(String id) {
		return super.get(id);
	}
	
	public List<CcmWorkBeonduty> findList(CcmWorkBeonduty ccmWorkBeonduty) {
		return super.findList(ccmWorkBeonduty);
	}

	public List<CcmWorkBeondutyExport> exportList(CcmWorkBeonduty ccmWorkBeonduty) {
		return dao.exportList(ccmWorkBeonduty);
	}

	public List<CcmWorkBeonduty> findByYearMonth(CcmWorkBeonduty ccmWorkBeonduty) {
		return ccmWorkBeondutyDao.findByYearMonth(ccmWorkBeonduty);
	}

	public Page<CcmWorkBeonduty> findPage(Page<CcmWorkBeonduty> page, CcmWorkBeonduty ccmWorkBeonduty) {
		return super.findPage(page, ccmWorkBeonduty);
	}
	
	@Transactional(readOnly = false)
	public void save(CcmWorkBeonduty ccmWorkBeonduty) {
		super.save(ccmWorkBeonduty);
	}
	
	@Transactional(readOnly = false)
	public void delete(CcmWorkBeonduty ccmWorkBeonduty) {
		super.delete(ccmWorkBeonduty);
	}
	
}