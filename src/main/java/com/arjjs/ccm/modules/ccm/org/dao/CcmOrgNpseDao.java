/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.org.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgNpse;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmAreaPoint;
import com.arjjs.ccm.modules.ccm.sys.entity.CcmAreaPointVo;
import com.arjjs.ccm.modules.flat.analyst.entity.Count;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SearchTabMore;

import java.util.List;

/**
 * 非公有制经济组织DAO接口
 * @author wwh
 * @version 2018-01-26
 */
@MyBatisDao
public interface CcmOrgNpseDao extends CrudDao<CcmOrgNpse> {

	List<Count> getByCount();
	//安全生产重点
	public List<CcmOrgNpse> findPageSafe(CcmOrgNpse ccmOrgNpse);
	
	// 更新点坐标信息
	public int updateCoordinates(CcmOrgNpse ccmOrgNpse);

	//报表:非公有经济组织数量
	public SearchTabMore findNumStatistics();

	//报表:非公有经济组织类别
	public List<EchartType> findCompType();

	//报表:非公有经济组织控股情况
	public List<EchartType> findHoldCase();

	//报表:非公有经济组织安全隐患类型
	public List<EchartType> findSafeHazaType();

	//报表:非公有经济组织重点类型
	public List<EchartType> findCompImpoType();

	//报表:非公有经济组织是否危化企业
	public List<EchartType> findDangComp();

	//报表:非公有经济组织关注程度
	public List<EchartType> findConcExte();

	//报表:重点场所数据重点类型
	public List<EchartType> findKeyPlaceType(EchartType echartType);

	//报表:重点场所数据重点类型-学校
	public List<EchartType> findSchool();

	//报表:重点场所数据-学校办学类型统计
	public List<EchartType> findSchoolType();

	//重点企业数量
	public int findCompImpoTypes();

	//报表:重点场所数据区域
	public List<EchartType> findArea(EchartType echartType);

	//危化企业
	public List<EchartType> getDangComp();

	//风险级别数量
	public int findNumRiskRank(CcmOrgNpse ccmOrgNpse);

	//首页概况各种总数查询//安全生产重点//消防重点//物流安全
	public int findCompImpoTypeData(CcmOrgNpse ccmOrgNpse);

	//重点企业分布
	public List<EchartType> getCompImpoTypeTrue();
	
	//治安重点场所
	public List<EchartType> getSafePubData();

	//企业数量-大屏-滨海新区社会网格化管理信息平台
	public String getqiyeNumData(CcmOrgNpse ccmOrgNpse);

	//风险单位数据分析-按街道-大屏-滨海新区社会网格化管理信息平台
	public List<EchartType> findSumByString(CcmOrgNpse ccmOrgNpse);

	//街道信息-大屏-滨海新区社会网格化管理信息平台
	public List<SearchTab> findListAllData(CcmOrgNpse ccmOrgNpse);

	//报表:非公有经济组织重点类型-无关联
	public List<EchartType> findCompImpoType2();
	
	//首页统计两新组织数量 
	public List<CcmOrgNpse> findCountByCompType();

	//按登记注册类型分类的图表
	public List<EchartType> getOrgNpseByRegiType(CcmOrgNpse ccmOrgNpse);

	//根据行业类型统计
	public List<EchartType> getOrgNpseBysysdicts(EchartType echartType);

	//各区域企业分布
	public List<EchartType> getOrgNpseBysysArea();

	//查询注册资金
	public List<CcmOrgNpse> getRegistered();

    public List<CcmAreaPoint> selectByAreaGIdAndName(CcmAreaPointVo areaPointVo);

	//按照风险级别分组
    public List<EchartType> getNpseGroupByRiskType();
}
