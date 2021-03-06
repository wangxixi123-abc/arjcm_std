/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.report.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.report.entity.CcmPeopleStat;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SearchTabMore;

/**
 * 人口新增统计DAO接口
 * 
 * @author arj
 * @version 2018-01-20
 */
@MyBatisDao
public interface CcmPeopleStatDao extends CrudDao<CcmPeopleStat> {
	/**
	 * @see 查询的新增人口数量按月
	 * @param column
	 * @return
	 */
	List<EchartType> findListBySum(@Param("column")String column);

	/**
	 * @see 查询的新增人口数量按地区
	 * @param column
	 * @return
	 */
	List<EchartType> findListByMon(@Param("column")String column);
	/**
	 * @see 实有人口总数、新增
	 * @param column
	 * @return
	 */
	EchartType getOnLineRate();
	/**
	 * @see 本月人口信息getnumPopFollowPop
	 * @param column
	 * @return
	 */
	SearchTabMore getnumPopFollowPop();
	/**
	 * @see 首页社区弹框：本月新增人口
	 * @param column
	 * @return
	 */
	CcmPeopleStat findMonthAreaStat(CcmPeopleStat ccmPeopleStat);

	//流入流出分析
	List<SearchTab> findFloatOutInArea(CcmPeopleStat ccmPeopleStat);

	//户籍人口迁入迁出情况
	List<SearchTab> getPopInOut(CcmPeopleStat ccmPeopleStat);

	//查询近12个月的数据
	List<EchartType> getcountperson(int num);
	
	/**
	 * 获取所有类型新增人口数量
	 */
	List<EchartType> findPeopleNewSum();
	
	//特殊人员分析
	SearchTabMore getSpecialPopDataQL();

}