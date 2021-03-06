/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.place.entity;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;
import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.common.utils.excel.annotation.ExcelField;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;

/**
 * 场所基本信息表Entity
 * 
 * @author lgh
 * @version 2019-04-23
 */
public class CcmBasePlace extends DataEntity<CcmBasePlace> {

	private static final long serialVersionUID = 1L;
	private String placeName; // 场所名称
	private String relevanceOrg; // 关联组织机构
	private String keyPoint; // 重点属性
	private String placeArea; // 场所面积
	private String placeUse; // 场所用途
	private String workerNumber; // 工作人员数量
	private String leaderName; // 负责人姓名
	private String leaderIdCard; // 负责人身份证号码
	private String leaderContact; // 负责人联系方式
	private Date createTime; // 成立时间
	private String governingBodyName; // 主管单位名称
	private String address; // 地址
	private String placeType; // 场所类型
	private String placePicture; // 场所图片
	private String administrativeDivision; // 行政区划
	private String childType; // 场所子类型
	private String juniorId; // 下级关联id
	private String areaMap;		// 区域图
	private String areaPoint;		// 中心点
	private Area area;	// 
	private Area userArea;  //登录用户所在区域
	private User checkUser;
	

	public Area getUserArea() {
		return userArea;
	}

	public void setUserArea(Area userArea) {
		this.userArea = userArea;
	}

	public Area getArea() {
		return area;
	}

	public void setArea(Area area) {
		this.area = area;
	}

	public List<String> getKeyPointList() {
		List<String> list = Lists.newArrayList();
		if (keyPoint != null) {
			for (String s : StringUtils.split(keyPoint, ",")) {
				list.add(s);
			}
		}
		return list;
	}

	public void setKeyPointList(List<String> keyPointList) {
		keyPoint = "," + StringUtils.join(keyPointList, ",") + ",";
	}

	public String getChildType() {
		return childType;
	}

	public void setChildType(String childType) {
		this.childType = childType;
	}

	public String getJuniorId() {
		return juniorId;
	}

	public void setJuniorId(String juniorId) {
		this.juniorId = juniorId;
	}

	public CcmBasePlace() {
		super();
	}

	public CcmBasePlace(String id) {
		super(id);
	}

	@Length(min = 1, max = 255, message = "场所名称长度必须介于 1 和 255 之间")
	public String getPlaceName() {
		return placeName;
	}

	public void setPlaceName(String placeName) {
		this.placeName = placeName;
	}

	@Length(min = 0, max = 255, message = "关联组织机构长度必须介于 0 和 255 之间")
	public String getRelevanceOrg() {
		return relevanceOrg;
	}

	public void setRelevanceOrg(String relevanceOrg) {
		this.relevanceOrg = relevanceOrg;
	}

	@Length(min = 0, max = 255, message = "重点属性长度必须介于 0 和 255 之间")
	public String getKeyPoint() {
		return keyPoint;
	}

	public void setKeyPoint(String keyPoint) {
		this.keyPoint = keyPoint;
	}

	@Length(min = 0, max = 255, message = "场所面积长度必须介于 0 和 255 之间")
	public String getPlaceArea() {
		return placeArea;
	}

	public void setPlaceArea(String placeArea) {
		this.placeArea = placeArea;
	}

	@Length(min = 0, max = 255, message = "场所用途长度必须介于 0 和 255 之间")
	public String getPlaceUse() {
		return placeUse;
	}

	public void setPlaceUse(String placeUse) {
		this.placeUse = placeUse;
	}

	@Length(min = 0, max = 255, message = "工作人员数量长度必须介于 0 和 255 之间")
	public String getWorkerNumber() {
		return workerNumber;
	}

	public void setWorkerNumber(String workerNumber) {
		this.workerNumber = workerNumber;
	}

	@Length(min = 0, max = 255, message = "负责人姓名长度必须介于 0 和 255 之间")
	public String getLeaderName() {
		return leaderName;
	}

	public void setLeaderName(String leaderName) {
		this.leaderName = leaderName;
	}

	@Length(min = 0, max = 255, message = "负责人身份证号码长度必须介于 0 和 255 之间")
	public String getLeaderIdCard() {
		return leaderIdCard;
	}

	public void setLeaderIdCard(String leaderIdCard) {
		this.leaderIdCard = leaderIdCard;
	}

	@Length(min = 0, max = 255, message = "负责人联系方式长度必须介于 0 和 255 之间")
	public String getLeaderContact() {
		return leaderContact;
	}

	public void setLeaderContact(String leaderContact) {
		this.leaderContact = leaderContact;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Length(min = 0, max = 255, message = "主管单位名称长度必须介于 0 和 255 之间")
	public String getGoverningBodyName() {
		return governingBodyName;
	}

	public void setGoverningBodyName(String governingBodyName) {
		this.governingBodyName = governingBodyName;
	}

	@Length(min = 0, max = 255, message = "地址长度必须介于 0 和 255 之间")
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@Length(min = 0, max = 255, message = "场所类型长度必须介于 0 和 255 之间")
	public String getPlaceType() {
		return placeType;
	}

	public void setPlaceType(String placeType) {
		this.placeType = placeType;
	}

	@Length(min = 0, max = 255, message = "场所图片长度必须介于 0 和 255 之间")
	public String getPlacePicture() {
		return placePicture;
	}

	public void setPlacePicture(String placePicture) {
		this.placePicture = placePicture;
	}

	@Length(min = 0, max = 255, message = "行政区划长度必须介于 0 和 255 之间")
	public String getAdministrativeDivision() {
		return administrativeDivision;
	}

	public void setAdministrativeDivision(String administrativeDivision) {
		this.administrativeDivision = administrativeDivision;
	}

	@Length(min=0, max=2000, message="区域图长度必须介于 0 和 2000 之间")
	@ExcelField(title="区域图", align=2, sort=14)
	public String getAreaMap() {
		return areaMap;
	}

	public void setAreaMap(String areaMap) {
		this.areaMap = areaMap;
	}
	
	@Length(min=0, max=40, message="中心点长度必须介于 0 和 40 之间")
	@ExcelField(title="中心点", align=2, sort=15)
	public String getAreaPoint() {
		return areaPoint;
	}

	public void setAreaPoint(String areaPoint) {
		this.areaPoint = areaPoint;
	}

    public User getCheckUser() {
        return checkUser;
    }

    public void setCheckUser(User checkUser) {
        this.checkUser = checkUser;
    }

	
/*	public void setCheckUser(User sessionUser) {
		// TODO Auto-generated method stub
		
	}*/

}