/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.service;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmUploadLog;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmUploadLogService;
import com.arjjs.ccm.modules.ccm.house.dao.CcmHouseBuildmanageDao;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildentrance;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildentranceVo;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenantVo;
import com.arjjs.ccm.modules.ccm.sys.entity.CcmAreaPointVo;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.AreaService;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.SearchTab;
import com.arjjs.ccm.tool.SearchTabMore;
import com.arjjs.ccm.tool.SysConfigInit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 楼栋Service
 * 
 * @author wwh
 * @version 2018-01-05
 */
@Service
@Transactional(readOnly = true)
public class CcmHouseBuildmanageService extends CrudService<CcmHouseBuildmanageDao, CcmHouseBuildmanage> {
	@Autowired
	private CcmHouseBuildmanageDao ccmHouseBuildmanageDao;

	@Autowired
	private AreaService areaService;
	//上传上级平台记录
	@Autowired
	private CcmUploadLogService ccmUploadLogService;

	public CcmHouseBuildmanage get(String id) {
		return super.get(id);
	}

	public List<CcmHouseBuildmanage> findList(CcmHouseBuildmanage ccmHouseBuildmanage) {
		return super.findList(ccmHouseBuildmanage);
	}

	/**
	 *   查询楼幢集合
	 * @param ccmHouseBuildmanage
	 * @return
	 */
	public List<CcmHouseBuildmanage> queryList(CcmHouseBuildmanage ccmHouseBuildmanage) {
		List<CcmHouseBuildmanage> ccmHouseBuildmanages = dao.queryList(ccmHouseBuildmanage);
		List<CcmHouseBuildmanage> houseBuildmanage = new ArrayList<>();
		for (CcmHouseBuildmanage houseBuildInfo: ccmHouseBuildmanages) {
			CcmHouseBuildmanage buildmanagePoJo = get(houseBuildInfo.getId());
			houseBuildmanage.add(buildmanagePoJo);
		}
		return houseBuildmanage;
	}
	public Page<CcmHouseBuildmanage> findPageNew(Page pageIn, CcmHouseBuildmanage ccmHouseBuildmanage) {

		ccmHouseBuildmanage.setPage(pageIn);
		pageIn.setList(this.dao.queryList(ccmHouseBuildmanage));
		return pageIn;
	}
	public Page<CcmHouseBuildmanage> findPage(Page<CcmHouseBuildmanage> page, CcmHouseBuildmanage ccmHouseBuildmanage) {
		return super.findPage(page, ccmHouseBuildmanage);
	}

	public Page<CcmHouseBuildmanage> findListId(Page<CcmHouseBuildmanage> page,CcmHouseBuildmanage ccmHouseBuildmanage){
		ccmHouseBuildmanage.setPage(page);
		return page.setList(dao.findListId(ccmHouseBuildmanage));
	}

	public Page<CcmHouseBuildmanage> findList_V2(Page<CcmHouseBuildmanage> page, CcmHouseBuildmanage ccmHouseBuildmanage){
		ccmHouseBuildmanage.setPage(page);
		return page.setList(dao.findList_V2(ccmHouseBuildmanage));
	}
	@Transactional(readOnly = false)
	public void save(CcmHouseBuildmanage ccmHouseBuildmanage) {
		boolean isNew = false;
		if (ccmHouseBuildmanage.getId() == null || "".equals(ccmHouseBuildmanage.getId())) {//无主键ID，则是新记录
			isNew = true;
		}
		if (ccmHouseBuildmanage.getIsNewRecord()) {//指定了是新增记录，则算新记录
			isNew = true;
		}
		super.save(ccmHouseBuildmanage);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			if (isNew) {//新增数据
				uploadLog.setOperateType("1");
				uploadLog.setRemarks("新增楼栋数据：" + ccmHouseBuildmanage.getBuildname());
			} else {//编辑数据
				uploadLog.setOperateType("2");
				uploadLog.setRemarks("编辑楼栋数据：" + ccmHouseBuildmanage.getBuildname());
			}
			uploadLog.setTableName("ccm_house_buildmanage");
			uploadLog.setDataId(ccmHouseBuildmanage.getId());
			uploadLog.setUploadStatus("1");
			User user = UserUtils.getUser();
			if (user == null || StringUtils.isBlank(user.getId())){
				uploadLog.setCreateBy(new User("1"));
				uploadLog.setUpdateBy(new User("1"));
			}
			ccmUploadLogService.save(uploadLog);
		}
		
	}

	@Transactional(readOnly = false)
	public void delete(CcmHouseBuildmanage ccmHouseBuildmanage) {
		super.delete(ccmHouseBuildmanage);

		//上传上级平台记录
		if (!SysConfigInit.UPPER_URL.equals("")) {//有上级平台地址时，才存入上传上级平台记录的日志
			CcmUploadLog uploadLog = new CcmUploadLog();
			uploadLog.setOperateType("3");
			uploadLog.setRemarks("删除楼栋数据：" + ccmHouseBuildmanage.getBuildname());
			uploadLog.setTableName("ccm_house_buildmanage");
			uploadLog.setDataId(ccmHouseBuildmanage.getId());
			uploadLog.setUploadStatus("1");
			User user = UserUtils.getUser();
			if (user == null || StringUtils.isBlank(user.getId())){
				uploadLog.setCreateBy(new User("1"));
				uploadLog.setUpdateBy(new User("1"));
			}
			ccmUploadLogService.save(uploadLog);
		}
	}

	// 返回指定类型的重点人群列表
	public List<String> findBuildListBySpecilPop(CcmPeople c) {
		return ccmHouseBuildmanageDao.findBuildListBySpecilPop(c);
	}

	// 返回的指定 map 对象信息
	public Map<String, CcmHouseBuildmanage> findMap(CcmHouseBuildmanage ccmHouseBuildmanage) {
		return ccmHouseBuildmanageDao.findMap(ccmHouseBuildmanage);
	}

	// 返回指定的 出租屋 ID 字符串
	public List<String> findBuildListByPrup() {
		return ccmHouseBuildmanageDao.findBuildListByPrup();
	}

	@Transactional(readOnly = false)
	public boolean updateCoordinates(CcmHouseBuildmanage c) {
		return ccmHouseBuildmanageDao.updateCoordinates(c);
	}

	public List<CcmHouseBuildmanage> getBuildByImmigration(SearchTabMore searchTabMore) {
		return ccmHouseBuildmanageDao.getBuildByImmigration(searchTabMore);
	}

	//街道信息-大屏-滨海新区社会网格化管理信息平台
	public List<SearchTab> findListAllData(CcmHouseBuildmanage ccmHouseBuildmanage) {
		return ccmHouseBuildmanageDao.findListAllData(ccmHouseBuildmanage);
	}

	//楼栋总数
	public int findListNum(CcmHouseBuildmanage ccmHouseBuildmanage) {
		return ccmHouseBuildmanageDao.findListNum(ccmHouseBuildmanage);
	}

	//默认全部的重点人员类型
	public List<String> findBuildListBySpecilPopUNION(CcmPeople cmPeopleDto) {
		return ccmHouseBuildmanageDao.findBuildListBySpecilPopUNION(cmPeopleDto);
	}

	//单元
	public int findListNumDanYuan(CcmHouseBuildmanage ccmHouseBuildmanage) {
		return ccmHouseBuildmanageDao.findListNumDanYuan(ccmHouseBuildmanage);
	}
	
	//根据建筑id获取单元数据
	public List<CcmHouseBuildentrance> findBuildentrance(String id) {
		CcmHouseBuildentrance ccmHouseBuildentrance = new CcmHouseBuildentrance();
		CcmHouseBuildmanage buildingId = new CcmHouseBuildmanage();
		buildingId.setId(id);
		ccmHouseBuildentrance.setBuildingId(buildingId);
		return ccmHouseBuildmanageDao.findBuildentrance(ccmHouseBuildentrance);
	}


	public List<CcmHouseBuildmanage> queryMapOtherBuildList(CcmHouseBuildmanage ccmHouseBuildmanage) {
		List<CcmHouseBuildmanage> houseBuildmanageList = queryList(ccmHouseBuildmanage);

		Area userArea=UserUtils.getUser().getOffice().getArea();
		ccmHouseBuildmanage.setUserArea(userArea);
		for (CcmHouseBuildmanage houseBuild:houseBuildmanageList) {
			CcmHouseBuildmanage houseBuildmanage = get(houseBuild.getId());
		}

		return null;

	}
	//根据建筑id获取单元数据列表
	public List<CcmHouseBuildentranceVo> selectBuildentranceById(String buildId,String tranceId){

		return ccmHouseBuildmanageDao.selectBuildentranceById(buildId,tranceId);
	}
	//根据建筑id,楼门号 获取房屋列表
	public List<CcmPopTenantVo> selectPopTenantByBuildAndDoorNum(String buildId,String doorNum){
		return ccmHouseBuildmanageDao.selectPopTenantByBuildAndDoorNum(buildId,doorNum);
	}
	public List<CcmHouseBuildmanage> selectByAreaGIdAndName(CcmAreaPointVo areaPointVo){
		return dao.selectByAreaGIdAndName(areaPointVo);
	}
	public List<CcmHouseBuildmanage> selectByAreaId(String areaId){
		return dao.selectByAreaId(areaId);
	}
}