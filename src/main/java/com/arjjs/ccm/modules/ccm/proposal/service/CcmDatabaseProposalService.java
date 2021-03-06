/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.proposal.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.ccm.proposal.entity.CcmDatabaseProposal;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestProposal;
import com.arjjs.ccm.modules.ccm.proposal.dao.CcmDatabaseProposalDao;

/**
 * 公告建议管理Service
 * @author cdz
 * @version 2019-09-16
 */
@Service
@Transactional(readOnly = true)
public class CcmDatabaseProposalService extends CrudService<CcmDatabaseProposalDao, CcmDatabaseProposal> {

	public CcmDatabaseProposal get(String id) {
		return super.get(id);
	}
	
	public List<CcmDatabaseProposal> findList(CcmDatabaseProposal ccmDatabaseProposal) {
		return super.findList(ccmDatabaseProposal);
	}
	
	public Page<CcmDatabaseProposal> findPage(Page<CcmDatabaseProposal> page, CcmDatabaseProposal ccmDatabaseProposal) {
		return super.findPage(page, ccmDatabaseProposal);
	}
	
	@Transactional(readOnly = false)
	public void save(CcmDatabaseProposal ccmDatabaseProposal) {
		super.save(ccmDatabaseProposal);
	}
	
	@Transactional(readOnly = false)
	public void delete(CcmDatabaseProposal ccmDatabaseProposal) {
		super.delete(ccmDatabaseProposal);
	}
	
	@Transactional(readOnly = false)
	public void addProposal(CcmDatabaseProposal ccmDatabaseProposal) {
		dao.insert(ccmDatabaseProposal);
	}
	
	public List<CcmRestProposal> getProposalInfo(CcmDatabaseProposal ccmDatabaseProposal) {
		return dao.getProposalInfo(ccmDatabaseProposal);
	}
}