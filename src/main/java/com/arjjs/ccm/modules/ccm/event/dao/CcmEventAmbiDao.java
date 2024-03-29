/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.event.dao;

import java.util.List;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventAmbi;
import com.arjjs.ccm.tool.EchartType;

/**
 * 矛盾纠纷排查化解DAO接口
 * @author wwh
 * @version 2018-01-30
 */
@MyBatisDao
public interface CcmEventAmbiDao extends CrudDao<CcmEventAmbi> {

	//化解是否成功统计
	List<EchartType> findSuccessMap(CcmEventAmbi ccmEventAmbi);

	//矛盾纠纷规模统计
	List<EchartType> findScaleMap(CcmEventAmbi ccmEventAmbi);

	//处理状态统计
	List<EchartType> findStatusMap(CcmEventAmbi ccmEventAmbi);

	//总数统计
	List<EchartType> findLineMap(CcmEventAmbi ccmEventAmbi);
	
	//按登录用户社区统计
	List<EchartType> findAreaMap(CcmEventAmbi ccmEventAmbi);
	
	/**
	 * 近12个月处理案件数量按月统计  矛盾纠纷折线图
	 * @param ccmEventAmbi
	 * @return
	 */
	List<EchartType> stateEventOneYear(CcmEventAmbi ccmEventAmbi);

	//首页统计矛盾纠纷数量
	List<CcmEventAmbi> findCountByStatus();
	//首页统计综治机构数量
	List<CcmEventAmbi> findOfficeCount();
	//累计受理纠纷总数
	int findListNum();
	
}