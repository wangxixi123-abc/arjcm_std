/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.hospital.entity;

import java.util.Date;
import java.util.List;

import com.arjjs.ccm.modules.sys.entity.User;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.modules.ccm.place.entity.CcmBasePlace;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.google.common.collect.Lists;

/**
 * 医疗卫生场所Entity
 * 
 * @author ljd
 * @version 2019-04-28
 */
public class CcmPlaceHospital extends DataEntity<CcmPlaceHospital> {

	private static final long serialVersionUID = 1L;
	private CcmBasePlace ccmBasePlace;
	private String type; // 场所类型
	private String hopitalType; // 医疗类型（01医院02私人诊所03药店）
	private String hospitalNature; // 医院性质
	private String hospitalLevel; // 医院等级
	private String hospitalPhoneNumber; // 办公电话
	private String faxNumber; // 传真号
	private String managerName; // 行政管理员名字
	private String partManagerName; // 党政负责人姓名
	private String managerPhoneNumber; // 行政管理员联系方式
	private String medicalStaffNumber; // 医务人员数量
	private String basePlaceId; // 场所id
	private String partManagerPhoneNumber; // 党政负责人联系方式
	private Date beginCreateDate; // 开始 创建时间
	private Date endCreateDate; // 结束 创建时间
	private String isCredentials; // 证件情况
	private String registeredFund; // 注册资金
	private String pharmacistNumber; // 药师人数
	private String doctorNumber; // 医生人数
	private String nurseNumber; // 护士人数
	private String diagnosisSubject; // 诊疗科目
	private String proposerName; // 申请人姓名
	private String proposerLevel; // 申请人职称等级

	private Area area;
	private User checkUser;
	public List<String> getKeyPointList() {
		List<String> list = Lists.newArrayList();
		if (ccmBasePlace!=null&&ccmBasePlace.getKeyPoint() != null) {
			for (String s : StringUtils.split(ccmBasePlace.getKeyPoint(), ",")) {
				list.add(s);
			}
		}
		return list;
	}

	public void setKeyPointList(List<String> keyPointList) {
		ccmBasePlace.setKeyPoint("," + StringUtils.join(keyPointList, ",") + ",");
	}

	// 设置证件
	public List<String> getLicenceList() {
		List<String> list = Lists.newArrayList();
		if (this.getIsCredentials() != null) {
			for (String s : StringUtils.split(this.getIsCredentials(), ",")) {
				list.add(s);
			}
		}
		return list;
	}

	public void setLicenceList(List<String> LicenceList) {
		this.setIsCredentials("," + StringUtils.join(LicenceList, ",") + ",");
	}

	public Area getArea() {
		return area;
	}

	public void setArea(Area area) {
		this.area = area;
	}

	public String getDoctorNumber() {
		return doctorNumber;
	}

	public void setDoctorNumber(String doctorNumber) {
		this.doctorNumber = doctorNumber;
	}

	public String getNurseNumber() {
		return nurseNumber;
	}

	public void setNurseNumber(String nurseNumber) {
		this.nurseNumber = nurseNumber;
	}

	public String getDiagnosisSubject() {
		return diagnosisSubject;
	}

	public void setDiagnosisSubject(String diagnosisSubject) {
		this.diagnosisSubject = diagnosisSubject;
	}

	public String getProposerName() {
		return proposerName;
	}

	public void setProposerName(String proposerName) {
		this.proposerName = proposerName;
	}

	public String getProposerLevel() {
		return proposerLevel;
	}

	public void setProposerLevel(String proposerLevel) {
		this.proposerLevel = proposerLevel;
	}

	public String getIsCredentials() {
		return isCredentials;
	}

	public void setIsCredentials(String isCredentials) {
		this.isCredentials = isCredentials;
	}

	public String getRegisteredFund() {
		return registeredFund;
	}

	public void setRegisteredFund(String registeredFund) {
		this.registeredFund = registeredFund;
	}

	public String getPharmacistNumber() {
		return pharmacistNumber;
	}

	public void setPharmacistNumber(String pharmacistNumber) {
		this.pharmacistNumber = pharmacistNumber;
	}

	// 基础场所属性
	private String placeType;
	private String placeName; // 场所名称
	private String relevanceOrg; // 关联组织机构
	private String leaderName; // 负责人姓名
	private String address; // 地址
	private String leaderContact; // 负责人联系方式
	private String leaderIdCard;
	private String placeUse;
	private Date createTime;
	private String keyPoint;
	private String placeArea;
	private String workerNumber; // 工作人员数量
	private String placePicture;
	private String governingBodyName;
	private String administrativeDivision; // 行政区划
	public CcmBasePlace getCcmBasePlace() {
		return ccmBasePlace;
	}

	public void setCcmBasePlace(CcmBasePlace ccmBasePlace) {
		this.ccmBasePlace = ccmBasePlace;
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

	public CcmPlaceHospital() {
		super();
	}

	public CcmPlaceHospital(String id) {
		super(id);
	}

	@Length(min = 0, max = 255, message = "场所类型长度必须介于 0 和 255 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Length(min = 0, max = 2, message = "医疗类型（01医院02私人诊所03药店）长度必须介于 0 和 2 之间")
	public String getHopitalType() {
		return hopitalType;
	}

	public void setHopitalType(String hopitalType) {
		this.hopitalType = hopitalType;
	}

	@Length(min = 0, max = 255, message = "医院性质长度必须介于 0 和 255 之间")
	public String getHospitalNature() {
		return hospitalNature;
	}

	public void setHospitalNature(String hospitalNature) {
		this.hospitalNature = hospitalNature;
	}

	@Length(min = 0, max = 255, message = "医院等级长度必须介于 0 和 255 之间")
	public String getHospitalLevel() {
		return hospitalLevel;
	}

	public void setHospitalLevel(String hospitalLevel) {
		this.hospitalLevel = hospitalLevel;
	}

	@Length(min = 0, max = 11, message = "办公电话长度必须介于 0 和 11 之间")
	public String getHospitalPhoneNumber() {
		return hospitalPhoneNumber;
	}

	public void setHospitalPhoneNumber(String hospitalPhoneNumber) {
		this.hospitalPhoneNumber = hospitalPhoneNumber;
	}

	@Length(min = 0, max = 255, message = "传真号长度必须介于 0 和 255 之间")
	public String getFaxNumber() {
		return faxNumber;
	}

	public void setFaxNumber(String faxNumber) {
		this.faxNumber = faxNumber;
	}

	@Length(min = 0, max = 255, message = "行政管理员名字长度必须介于 0 和 255 之间")
	public String getManagerName() {
		return managerName;
	}

	public void setManagerName(String managerName) {
		this.managerName = managerName;
	}

	@Length(min = 0, max = 255, message = "党政负责人姓名长度必须介于 0 和 255 之间")
	public String getPartManagerName() {
		return partManagerName;
	}

	public void setPartManagerName(String partManagerName) {
		this.partManagerName = partManagerName;
	}

	@Length(min = 0, max = 255, message = "行政管理员联系方式长度必须介于 0 和 255 之间")
	public String getManagerPhoneNumber() {
		return managerPhoneNumber;
	}

	public void setManagerPhoneNumber(String managerPhoneNumber) {
		this.managerPhoneNumber = managerPhoneNumber;
	}

	@Length(min = 0, max = 11, message = "医务人员数量长度必须介于 0 和 11 之间")
	public String getMedicalStaffNumber() {
		return medicalStaffNumber;
	}

	public void setMedicalStaffNumber(String medicalStaffNumber) {
		this.medicalStaffNumber = medicalStaffNumber;
	}

	@Length(min = 0, max = 64, message = "场所id长度必须介于 0 和 64 之间")
	public String getBasePlaceId() {
		return basePlaceId;
	}

	public void setBasePlaceId(String basePlaceId) {
		this.basePlaceId = basePlaceId;
	}

	@Length(min = 0, max = 11, message = "党政负责人联系方式长度必须介于 0 和 11 之间")
	public String getPartManagerPhoneNumber() {
		return partManagerPhoneNumber;
	}

	public void setPartManagerPhoneNumber(String partManagerPhoneNumber) {
		this.partManagerPhoneNumber = partManagerPhoneNumber;
	}

	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}

	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPlaceUse() {
		return placeUse;
	}

	public void setPlaceUse(String placeUse) {
		this.placeUse = placeUse;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getKeyPoint() {
		return keyPoint;
	}

	public void setKeyPoint(String keyPoint) {
		this.keyPoint = keyPoint;
	}

	public String getPlaceArea() {
		return placeArea;
	}

	public void setPlaceArea(String placeArea) {
		this.placeArea = placeArea;
	}

	public String getWorkerNumber() {
		return workerNumber;
	}

	public void setWorkerNumber(String workerNumber) {
		this.workerNumber = workerNumber;
	}

	public String getPlacePicture() {
		return placePicture;
	}

	public void setPlacePicture(String placePicture) {
		this.placePicture = placePicture;
	}

	public String getGoverningBodyName() {
		return governingBodyName;
	}

	public void setGoverningBodyName(String governingBodyName) {
		this.governingBodyName = governingBodyName;
	}

	public String getAdministrativeDivision() {
		return administrativeDivision;
	}

	public void setAdministrativeDivision(String administrativeDivision) {
		this.administrativeDivision = administrativeDivision;
	}

	public String getPlaceType() {
		return placeType;
	}

	public void setPlaceType(String placeType) {
		this.placeType = placeType;
	}

	public User getCheckUser() {
		return checkUser;
	}

	public void setCheckUser(User checkUser) {
		this.checkUser = checkUser;
	}
}