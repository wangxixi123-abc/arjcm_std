/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.hospital.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.ccm.hospital.entity.CcmPlaceHospital;
import com.arjjs.ccm.modules.ccm.hospital.dao.CcmPlaceHospitalDao;

/**
 * 医疗卫生场所Service
 * @author ljd
 * @version 2019-04-28
 */
@Service
@Transactional(readOnly = true)
public class CcmPlaceHospitalService extends CrudService<CcmPlaceHospitalDao, CcmPlaceHospital> {

	public CcmPlaceHospital get(String id) {
		return super.get(id);
	}
	
	public CcmPlaceHospital get2(String basePlaceId) {
		return super.get(basePlaceId);
	}

	
	
	public List<CcmPlaceHospital> findList(CcmPlaceHospital ccmPlaceHospital) {
		return super.findList(ccmPlaceHospital);
	}
	
	public Page<CcmPlaceHospital> findPage(Page<CcmPlaceHospital> page, CcmPlaceHospital ccmPlaceHospital) {
		return super.findPage(page, ccmPlaceHospital);
	}
	
	@Transactional(readOnly = false)
	public void save(CcmPlaceHospital ccmPlaceHospital) {
		super.save(ccmPlaceHospital);
	}
	
	@Transactional(readOnly = false)
	public void delete(CcmPlaceHospital ccmPlaceHospital) {
		super.delete(ccmPlaceHospital);
	}
	
}