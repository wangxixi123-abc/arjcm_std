/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.work.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeonduty;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeondutyExport;

import java.util.List;

/**
 * 值班表DAO接口
 * @author liang
 * @version 2018-06-12
 */
@MyBatisDao
public interface CcmWorkBeondutyDao extends CrudDao<CcmWorkBeonduty> {


    public List<CcmWorkBeonduty> findByYearMonth(CcmWorkBeonduty ccmWorkBeonduty);

    public List<CcmWorkBeondutyExport> exportList (CcmWorkBeonduty ccmWorkBeonduty);
}