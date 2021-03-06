/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.flat.alarm.dao;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.ccm.rest.entity.AlarmNotifyInfo;
import com.arjjs.ccm.modules.flat.alarm.entity.*;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandleFile;
import com.arjjs.ccm.modules.sys.entity.Office;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 实时警情DAO接口
 * @author wangyikai
 * @version 2018-11-14
 */
@MyBatisDao
public interface BphAlarmInfoDao extends CrudDao<BphAlarmInfo> {
	List<BphAlarmInfo> queryAlarmSituation(BphAlarmInfo bphAlarmInfo);//查询当天的实时警情
	List<BphAlarmInfo> findAlarmList(BphAlarmInfo bphAlarmInfo);//警情管理查询
	List<BphAlarmInfo> queryHisAlarmSituation(BphAlarmInfo bphAlarmInfo);//查询历史警情
	List<BphAlarmInfo> queryAlarmInfoByDateAndAlarmType(BphAlarmInfo bphAlarmInfo);
	List<BphAlarmInfo> queryAlarmInfoByDateAndAlarmTypeToFourColor(BphAlarmInfo bphAlarmInfo);
	int updateAlarmInfo(BphAlarmInfo bphAlarmInfo);
	List<BphAlarmInfo> findNewestAlarmInfo();//查询最新警情前十条
	List<BphAlarmInfo> countDtae();//今日统计查询
	List<BphAlarmInfo> findPieData();//今日警情摘要
	BphAlarmInfo count(BphAlarmInfo bphAlarmInfo);//查询数量
	List<BphAlarmInfo> findDistributeList(BphAlarmInfo bphAlarmInfo);//根据部门查询数量
	Integer countDistributeList(BphAlarmInfo bphAlarmInfo);
	Integer countAlarmList(BphAlarmInfo bphAlarmInfo);
	List<BphAlarmInfo> byOfficeCount(BphAlarmInfo bphAlarmInfo);
	List<Office> findOfficeAllList(Office office);
	List<BphAlarmTypeStat> statCountByAlarmType();
	List<BphAlarmSameDayContrast> sameDayContrastStat(BphAlarmSameDayContrast bphAlarmSameDayContrast);
	List<BphAlarmSameDayContrast> sameAlarmDayContrastStat(BphAlarmSameDayContrast bphAlarmSameDayContrast);
	List<BphAlarmInfo> statPercentByAlarmType(BphAlarmInfo bphAlarmInfo);
	List<BphAlarmInfo> statCountByOfficeAndAlarmType(BphAlarmInfo bphAlarmInfo);
	List<BphAlarmInfo> statCountGroupOffice();
	List<BphAlarmInfo> statCountByOffice(BphAlarmInfo bphAlarmInfo);
	List<BphAlarmInfo> statPercentByOffice(BphAlarmInfo bphAlarmInfo);
	BphAlarmInfo getParentId(BphAlarmInfo bphAlarmInfo);
	BphAlarmInfo find(String id);
	Integer findCount(BphAlarmInfo bphAlarmInfo);//查询警情总条数
	List<BphAlarmInfo> findByHandlePoliceId(String handlePoliceId);
	int insert(BphAlarmInfo bphAlarmInfo);
	int insertAlarm(BphAlarmInfo bphAlarmInfo);
	void insertData(List<BphDockingAlarmInfo> backups);
	void insertJjDockiData(BphDockingAlarmInfo backups);
	List<BphTimeoutAlarm> queryTimeoutAlarm(BphTimeoutAlarm bphTimeoutAlarm);
	List<BphAlarmHandleFile> getAlarmHandleFile(String id);
	int insertAlarmByIdForOffice(@Param("id")String id,@Param("officeId")String officeId,@Param("officeIds")String officeIds);
	Office selectOfficeByCode(@Param("code") String code);
	List<BphAlarmInfo> selectAlarmInfoByOrderNum(@Param("orderNum") String orderNum);

	//根据区域ID，查询部门ID
    List<OfficeAreaEntity> officeList(String areaId);

    /*List<String> selectDataNum();*/
    List<BphAlarmSameDayContrast> thisMonthContrastStat();
    List<BphAlarmSameDayContrast> lastMonthContrastStat();
	// 接处警： 更新警情的接口
	int updateBphAlarmInfo(BphAlarmInfo alarmInfo);
	AlarmNotifyInfo selectAlarmNotifyInfoById(@Param("alarmId") String alarmId);

}