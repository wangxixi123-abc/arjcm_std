/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.work.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeondutylog;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeondutylogExport;

import java.util.List;

/**
 * 值班日志表DAO接口
 * @author liang
 * @version 2018-06-12
 */
@MyBatisDao
public interface CcmWorkBeondutylogDao extends CrudDao<CcmWorkBeondutylog> {

    public List<CcmWorkBeondutylogExport> exportList (CcmWorkBeondutylog ccmWorkBeondutylog);
}