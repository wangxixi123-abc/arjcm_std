/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.car.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.car.entity.CcmCarControl;

/**
 * 车辆布控实体类DAO接口
 * @author lgh
 * @version 2019-06-03
 */
@MyBatisDao
public interface CcmCarControlDao extends CrudDao<CcmCarControl> {

    public void deleteByIdent(CcmCarControl ccmCarControl);

    public int getCount(CcmCarControl ccmCarControl);
}