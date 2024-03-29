/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.dao;

import java.util.List;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseKym;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;

/**
 * 重点青少年管理模块DAO接口
 * @author arj
 * @version 2018-01-08
 */
@MyBatisDao
public interface CcmHouseKymDao extends CrudDao<CcmHouseKym> {
	
	public CcmHouseKym getItemByPeopleId(String id);
	//重点青少年分析
	public List<SearchTab> getnumPopFlowTable();
	
	//重点青少年帮扶方式统计分析
	public List<EchartType> getNumKymByAssistMethod();
	//重点青少年分析（曲梁）
	public List<EchartType> getnumPopFlowTableQL();
	
	EchartType getAllNumKymByAssistMethod();
	
	
	
	
}