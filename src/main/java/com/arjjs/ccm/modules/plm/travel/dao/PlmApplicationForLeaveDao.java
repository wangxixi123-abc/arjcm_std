/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.travel.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.plm.travel.entity.PlmApplicationForLeave;

/**
 * 请假申请DAO接口
 * @author dongqikai
 * @version 2018-07-16
 */
@MyBatisDao
public interface PlmApplicationForLeaveDao extends CrudDao<PlmApplicationForLeave> {
	
}