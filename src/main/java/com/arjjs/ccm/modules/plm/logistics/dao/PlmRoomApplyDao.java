/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.logistics.dao;



import java.util.List;
import java.util.Map;

import com.arjjs.ccm.common.persistence.CrudDao;
import com.arjjs.ccm.common.persistence.annotation.MyBatisDao;
import com.arjjs.ccm.modules.plm.logistics.entity.PlmRoomApply;
import com.arjjs.ccm.tool.EchartType;

/**
 * 会议申请DAO接口
 * @author fu
 * @version 2018-06-26
 */
@MyBatisDao
public interface PlmRoomApplyDao extends CrudDao<PlmRoomApply> {

	public PlmRoomApply getByProcInsId(String procInsId);

	public int updateProcInsId(PlmRoomApply plmRoomApply);

	public void updateIsEnd(PlmRoomApply plmRoomApply);


	List<Map<String, Object>> findApplyCount(Map<String, Object> map);
	
	List<EchartType> roomUseCount (Map<String, Object> map);
	
	
	public List<PlmRoomApply> getroombyuserId(PlmRoomApply plmRoomApply);
	
}