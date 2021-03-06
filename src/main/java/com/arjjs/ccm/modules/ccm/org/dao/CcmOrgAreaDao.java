/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.org.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgArea;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.tool.SearchTab;

import java.util.List;

/**
 * 区域扩展表（社区、网格）DAO接口
 * 
 * @author pengjianqiang
 * @version 2018-01-29
 */
@MyBatisDao
public interface CcmOrgAreaDao extends CrudDao<CcmOrgArea> {

	public CcmOrgArea GetItByUserId(String id);

	// 首页社区弹框：社区网格（通过父键查子集）area借用ccmOrgArea
	public List<Area> findAreaNet(Area area2);

	// 社区网格外表（通过社区网格id查外表）
	public CcmOrgArea findCcmOrgArea(CcmOrgArea ccmOrgArea2);

	// 更新社区信息
	public int updateCoordinates(CcmOrgArea ccmOrgArea);

	//区域全部数据
	public List<SearchTab> findListAllData(CcmOrgArea ccmOrgArea);

	// 查询乡镇有关信息
	public List<CcmOrgArea> findTownList(CcmOrgArea ccmOrgArea);

	public List<CcmOrgArea> getAreaMap(CcmOrgArea ccmOrgArea);
	
	// 社区网格外表（通过社区网格id查外表/不关联sys_area表）
	public CcmOrgArea getCcmOrgArea(CcmOrgArea ccmOrgArea2);
}