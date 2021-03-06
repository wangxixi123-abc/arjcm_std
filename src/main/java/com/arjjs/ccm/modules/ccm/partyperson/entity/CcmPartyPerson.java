/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.partyperson.entity;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.Date;

/**
 * 党员信息管理Entity
 * @author maoxb
 * @version 2019-08-13
 */
public class CcmPartyPerson extends DataEntity<CcmPartyPerson> {
	
	private static final long serialVersionUID = 1L;
	private String type;		// 1:社区党员管理2：两新党员管理
	private String name;		// 党员姓名
	private String status;		// 人员状态
	private Area community;		// 社区（单位）
	private String beloneOrg;		// 所属组织
	private String beloneOrgName;		// 所属组织
	private String partMembership;		// 党员身份
	private String superPartOrg;		// 上级党组织
	private String superPartOrgName;		// 上级党组织
	private Date joinPartTime;		// 入党时间
	private String beloneBranch;		// 所属支部
	private String innerPartPosition;		// 现任党内职务
	private String chargemanFlag;		// 是否是组长或楼道长
	private String oldPartFlag;		// 是否是老党员
	private String difficultPartFlag;		// 是否是困难党员
	private String difficultInfo;		// 困难情况
	private String subsidyInfo;		// 补助情况
	private String flowPartFlag;		// 是否流动党员
	private String flowOutAdd;		// 流出地
	private String flowInAdd;		// 流入地
	private String nowWorkAndPosition;		// 现工作单位及职务
	private String nowBeAttachPart;		// 现挂靠党组织名称
	private Date reportingTime;		// 报道时间
	private String actAsLeaderFlag;		// 是否担任所领办
	private String conditionInfo;		// 结对情况
	private String leaderProject;		// 领办项目
	private String deptLevel;		// 隶属单位级别
	private Date admissionTime;		// 入学时间
	private Date graduationTime;		// 毕业时间
	private String familyOrigin;		// 家庭出身
	private String democraticParty;		// 民主党派
	private String individualStatus;		// 个人身份
	private String migrantWorkerFlag;		// 农民工
	private String firstLineSituation;		// 一线情况
	private String newOrder;		// 新阶层
	private String educationalBackground;		// 学历
	private String academicDegree;		// 学位
	private String profession;		// 专业
	private String graduateInstitutions;		// 毕业院校
	private String technicalPosition;		// 技术职务
	private String positionLevel;		// 职务级别
	private String contactInfo;		// 联系情况
	private Date joinOtherPartTime;		// 加入其它党团日期
	private Date retirementTime;		// 退休时间
	private Date departureTime;		// 离岗时间
	private String belonePartGroup;		// 所在党小组
	private String joinPartReference;		// 入党介绍人
	private Date correctionTime;		// 转正时间
	private String developType;		// 发展类型
	private String basePartFees;		// 党费缴纳基数
	private String julyJoinPartFlag;		// 是否27年7月前入团8月后转入党
	private Date workStartTime;		// 工作开始日期
	private Date workEndTime;		// 工作截止日期
	private Date workTime;		// 工作时间
	private String partPositionCaption;		// 党内职务名称
	private String officeOrgCoding;		// 任职组织编码
	private String officeOrgWhich;		// 任职所在组织
	private String classMemberFlag;		// 是否班子成员
	private String modeOfService;		// 任职方式
	private Date serviceTime;		// 任职时间
	private Date serviceYears;		// 任职年限
	private String villaCommMembFlag;		// 是否兼任村委会社区居委会委员
	private String direCommMembFlag;		// 是否兼任村委会社区居委会主任
	private String rankingOfTeamPosts;		// 班子职务排序
	private String adminPostionName;		// 行政职务名称
	private String servingUint;		// 任职单位
	private String personalJobRanking;		// 个人职务排序
	private Date adminServiceTime;		// 行政任职时间
	private Date adminDepartTime;		// 行政离任时间
	private String educationCategory;		// 教育类别
	private Date degreeAwardTime;		// 学位授予日期
	private Date engageStartTime;		// 聘任起始日期
	private Date engageEndTime;		// 聘任终止日期
	private String profTechPosition;		// 专业技术职务
	private String profTechTitle;		// 专业技术资格
	private Date eligibilityTime;		// 获得资格日期
	private String partRelaVillaFlag;		// 党员是否联系村务、厂务
	private String relationName;		// 联系点名称
	private String partRelaFarmerFlag;		// 党员是否联系农户
	private String farmerNum;		// 农户数量
	private String villaWorkGroupFlag;		// 是否&rdquo;十百千万&ldquo;驻村工作组干部
	private String residentVillageName;		// 驻村名称
	private Date addTime;		// 增加时间
	private String partAdd;		// 党员增加
	private String deptAttr;		// 单位属性
	private String deptIndustry;		// 所属行业
	private String officeId;
	
	public String getOfficeId() {
		return officeId;
	}

	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}

	public CcmPartyPerson() {
		super();
	}

	public CcmPartyPerson(String id){
		super(id);
	}

	@Length(min=0, max=1, message="1:社区党员管理2：两新党员管理长度必须介于 0 和 1 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=1, max=100, message="党员姓名长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=100, message="人员状态长度必须介于 1 和 100 之间")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@Length(min=1, max=100, message="社区（单位）长度必须介于 1 和 100 之间")
	public Area getCommunity() {
		return community;
	}

	public void setCommunity(Area community) {
		this.community = community;
	}
	
	@Length(min=0, max=64, message="所属组织长度必须介于 0 和 64 之间")
	public String getBeloneOrg() {
		return beloneOrg;
	}

	public void setBeloneOrg(String beloneOrg) {
		this.beloneOrg = beloneOrg;
	}
	
	@Length(min=0, max=100, message="党员身份长度必须介于 0 和 100 之间")
	public String getPartMembership() {
		return partMembership;
	}

	public void setPartMembership(String partMembership) {
		this.partMembership = partMembership;
	}
	
	@Length(min=0, max=64, message="上级党组织长度必须介于 0 和 64 之间")
	public String getSuperPartOrg() {
		return superPartOrg;
	}

	public void setSuperPartOrg(String superPartOrg) {
		this.superPartOrg = superPartOrg;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@NotNull(message="入党时间不能为空")
	public Date getJoinPartTime() {
		return joinPartTime;
	}

	public void setJoinPartTime(Date joinPartTime) {
		this.joinPartTime = joinPartTime;
	}
	
	@Length(min=1, max=100, message="所属支部长度必须介于 1 和 100 之间")
	public String getBeloneBranch() {
		return beloneBranch;
	}

	public void setBeloneBranch(String beloneBranch) {
		this.beloneBranch = beloneBranch;
	}
	
	@Length(min=1, max=100, message="现任党内职务长度必须介于 1 和 100 之间")
	public String getInnerPartPosition() {
		return innerPartPosition;
	}

	public void setInnerPartPosition(String innerPartPosition) {
		this.innerPartPosition = innerPartPosition;
	}
	
	@Length(min=0, max=1, message="是否是组长或楼道长长度必须介于 0 和 1 之间")
	public String getChargemanFlag() {
		return chargemanFlag;
	}

	public void setChargemanFlag(String chargemanFlag) {
		this.chargemanFlag = chargemanFlag;
	}
	
	@Length(min=0, max=1, message="是否是老党员长度必须介于 0 和 1 之间")
	public String getOldPartFlag() {
		return oldPartFlag;
	}

	public void setOldPartFlag(String oldPartFlag) {
		this.oldPartFlag = oldPartFlag;
	}
	
	@Length(min=0, max=1, message="是否是困难党员长度必须介于 0 和 1 之间")
	public String getDifficultPartFlag() {
		return difficultPartFlag;
	}

	public void setDifficultPartFlag(String difficultPartFlag) {
		this.difficultPartFlag = difficultPartFlag;
	}
	
	@Length(min=0, max=500, message="困难情况长度必须介于 0 和 500 之间")
	public String getDifficultInfo() {
		return difficultInfo;
	}

	public void setDifficultInfo(String difficultInfo) {
		this.difficultInfo = difficultInfo;
	}
	
	@Length(min=0, max=500, message="补助情况长度必须介于 0 和 500 之间")
	public String getSubsidyInfo() {
		return subsidyInfo;
	}

	public void setSubsidyInfo(String subsidyInfo) {
		this.subsidyInfo = subsidyInfo;
	}
	
	@Length(min=0, max=1, message="是否流动党员长度必须介于 0 和 1 之间")
	public String getFlowPartFlag() {
		return flowPartFlag;
	}

	public void setFlowPartFlag(String flowPartFlag) {
		this.flowPartFlag = flowPartFlag;
	}
	
	@Length(min=0, max=100, message="流出地长度必须介于 0 和 100 之间")
	public String getFlowOutAdd() {
		return flowOutAdd;
	}

	public void setFlowOutAdd(String flowOutAdd) {
		this.flowOutAdd = flowOutAdd;
	}
	
	@Length(min=0, max=100, message="流入地长度必须介于 0 和 100 之间")
	public String getFlowInAdd() {
		return flowInAdd;
	}

	public void setFlowInAdd(String flowInAdd) {
		this.flowInAdd = flowInAdd;
	}
	
	@Length(min=0, max=100, message="现工作单位及职务长度必须介于 0 和 100 之间")
	public String getNowWorkAndPosition() {
		return nowWorkAndPosition;
	}

	public void setNowWorkAndPosition(String nowWorkAndPosition) {
		this.nowWorkAndPosition = nowWorkAndPosition;
	}
	
	@Length(min=0, max=100, message="现挂靠党组织名称长度必须介于 0 和 100 之间")
	public String getNowBeAttachPart() {
		return nowBeAttachPart;
	}

	public void setNowBeAttachPart(String nowBeAttachPart) {
		this.nowBeAttachPart = nowBeAttachPart;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getReportingTime() {
		return reportingTime;
	}

	public void setReportingTime(Date reportingTime) {
		this.reportingTime = reportingTime;
	}
	
	@Length(min=0, max=1, message="是否担任所领办长度必须介于 0 和 1 之间")
	public String getActAsLeaderFlag() {
		return actAsLeaderFlag;
	}

	public void setActAsLeaderFlag(String actAsLeaderFlag) {
		this.actAsLeaderFlag = actAsLeaderFlag;
	}
	
	@Length(min=0, max=200, message="结对情况长度必须介于 0 和 200 之间")
	public String getConditionInfo() {
		return conditionInfo;
	}

	public void setConditionInfo(String conditionInfo) {
		this.conditionInfo = conditionInfo;
	}
	
	@Length(min=0, max=100, message="领办项目长度必须介于 0 和 100 之间")
	public String getLeaderProject() {
		return leaderProject;
	}

	public void setLeaderProject(String leaderProject) {
		this.leaderProject = leaderProject;
	}
	
	@Length(min=0, max=20, message="隶属单位级别长度必须介于 0 和 20 之间")
	public String getDeptLevel() {
		return deptLevel;
	}

	public void setDeptLevel(String deptLevel) {
		this.deptLevel = deptLevel;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getAdmissionTime() {
		return admissionTime;
	}

	public void setAdmissionTime(Date admissionTime) {
		this.admissionTime = admissionTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getGraduationTime() {
		return graduationTime;
	}

	public void setGraduationTime(Date graduationTime) {
		this.graduationTime = graduationTime;
	}
	
	@Length(min=0, max=64, message="家庭出身长度必须介于 0 和 64 之间")
	public String getFamilyOrigin() {
		return familyOrigin;
	}

	public void setFamilyOrigin(String familyOrigin) {
		this.familyOrigin = familyOrigin;
	}
	
	@Length(min=0, max=100, message="民主党派长度必须介于 0 和 100 之间")
	public String getDemocraticParty() {
		return democraticParty;
	}

	public void setDemocraticParty(String democraticParty) {
		this.democraticParty = democraticParty;
	}
	
	@Length(min=0, max=100, message="个人身份长度必须介于 0 和 100 之间")
	public String getIndividualStatus() {
		return individualStatus;
	}

	public void setIndividualStatus(String individualStatus) {
		this.individualStatus = individualStatus;
	}
	
	@Length(min=0, max=1, message="农民工长度必须介于 0 和 1 之间")
	public String getMigrantWorkerFlag() {
		return migrantWorkerFlag;
	}

	public void setMigrantWorkerFlag(String migrantWorkerFlag) {
		this.migrantWorkerFlag = migrantWorkerFlag;
	}
	
	@Length(min=0, max=64, message="一线情况长度必须介于 0 和 64 之间")
	public String getFirstLineSituation() {
		return firstLineSituation;
	}

	public void setFirstLineSituation(String firstLineSituation) {
		this.firstLineSituation = firstLineSituation;
	}
	
	@Length(min=0, max=64, message="新阶层长度必须介于 0 和 64 之间")
	public String getNewOrder() {
		return newOrder;
	}

	public void setNewOrder(String newOrder) {
		this.newOrder = newOrder;
	}
	
	@Length(min=0, max=64, message="学历长度必须介于 0 和 64 之间")
	public String getEducationalBackground() {
		return educationalBackground;
	}

	public void setEducationalBackground(String educationalBackground) {
		this.educationalBackground = educationalBackground;
	}
	
	@Length(min=0, max=64, message="学位长度必须介于 0 和 64 之间")
	public String getAcademicDegree() {
		return academicDegree;
	}

	public void setAcademicDegree(String academicDegree) {
		this.academicDegree = academicDegree;
	}
	
	@Length(min=0, max=64, message="专业长度必须介于 0 和 64 之间")
	public String getProfession() {
		return profession;
	}

	public void setProfession(String profession) {
		this.profession = profession;
	}
	
	@Length(min=0, max=100, message="毕业院校长度必须介于 0 和 100 之间")
	public String getGraduateInstitutions() {
		return graduateInstitutions;
	}

	public void setGraduateInstitutions(String graduateInstitutions) {
		this.graduateInstitutions = graduateInstitutions;
	}
	
	@Length(min=0, max=64, message="技术职务长度必须介于 0 和 64 之间")
	public String getTechnicalPosition() {
		return technicalPosition;
	}

	public void setTechnicalPosition(String technicalPosition) {
		this.technicalPosition = technicalPosition;
	}
	
	@Length(min=0, max=64, message="职务级别长度必须介于 0 和 64 之间")
	public String getPositionLevel() {
		return positionLevel;
	}

	public void setPositionLevel(String positionLevel) {
		this.positionLevel = positionLevel;
	}
	
	@Length(min=0, max=64, message="联系情况长度必须介于 0 和 64 之间")
	public String getContactInfo() {
		return contactInfo;
	}

	public void setContactInfo(String contactInfo) {
		this.contactInfo = contactInfo;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getJoinOtherPartTime() {
		return joinOtherPartTime;
	}

	public void setJoinOtherPartTime(Date joinOtherPartTime) {
		this.joinOtherPartTime = joinOtherPartTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getRetirementTime() {
		return retirementTime;
	}

	public void setRetirementTime(Date retirementTime) {
		this.retirementTime = retirementTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getDepartureTime() {
		return departureTime;
	}

	public void setDepartureTime(Date departureTime) {
		this.departureTime = departureTime;
	}
	
	@Length(min=0, max=100, message="所在党小组长度必须介于 0 和 100 之间")
	public String getBelonePartGroup() {
		return belonePartGroup;
	}

	public void setBelonePartGroup(String belonePartGroup) {
		this.belonePartGroup = belonePartGroup;
	}
	
	@Length(min=0, max=64, message="入党介绍人长度必须介于 0 和 64 之间")
	public String getJoinPartReference() {
		return joinPartReference;
	}

	public void setJoinPartReference(String joinPartReference) {
		this.joinPartReference = joinPartReference;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getCorrectionTime() {
		return correctionTime;
	}

	public void setCorrectionTime(Date correctionTime) {
		this.correctionTime = correctionTime;
	}
	
	@Length(min=0, max=64, message="发展类型长度必须介于 0 和 64 之间")
	public String getDevelopType() {
		return developType;
	}

	public void setDevelopType(String developType) {
		this.developType = developType;
	}
	
	@Length(min=0, max=64, message="党费缴纳基数长度必须介于 0 和 64 之间")
	public String getBasePartFees() {
		return basePartFees;
	}

	public void setBasePartFees(String basePartFees) {
		this.basePartFees = basePartFees;
	}
	
	@Length(min=0, max=1, message="是否27年7月前入团8月后转入党长度必须介于 0 和 1 之间")
	public String getJulyJoinPartFlag() {
		return julyJoinPartFlag;
	}

	public void setJulyJoinPartFlag(String julyJoinPartFlag) {
		this.julyJoinPartFlag = julyJoinPartFlag;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getWorkStartTime() {
		return workStartTime;
	}

	public void setWorkStartTime(Date workStartTime) {
		this.workStartTime = workStartTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getWorkEndTime() {
		return workEndTime;
	}

	public void setWorkEndTime(Date workEndTime) {
		this.workEndTime = workEndTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getWorkTime() {
		return workTime;
	}

	public void setWorkTime(Date workTime) {
		this.workTime = workTime;
	}
	
	@Length(min=0, max=100, message="党内职务名称长度必须介于 0 和 100 之间")
	public String getPartPositionCaption() {
		return partPositionCaption;
	}

	public void setPartPositionCaption(String partPositionCaption) {
		this.partPositionCaption = partPositionCaption;
	}
	
	@Length(min=0, max=64, message="任职组织编码长度必须介于 0 和 64 之间")
	public String getOfficeOrgCoding() {
		return officeOrgCoding;
	}

	public void setOfficeOrgCoding(String officeOrgCoding) {
		this.officeOrgCoding = officeOrgCoding;
	}
	
	@Length(min=0, max=255, message="任职所在组织长度必须介于 0 和 255 之间")
	public String getOfficeOrgWhich() {
		return officeOrgWhich;
	}

	public void setOfficeOrgWhich(String officeOrgWhich) {
		this.officeOrgWhich = officeOrgWhich;
	}
	
	@Length(min=0, max=1, message="是否班子成员长度必须介于 0 和 1 之间")
	public String getClassMemberFlag() {
		return classMemberFlag;
	}

	public void setClassMemberFlag(String classMemberFlag) {
		this.classMemberFlag = classMemberFlag;
	}
	
	@Length(min=0, max=100, message="任职方式长度必须介于 0 和 100 之间")
	public String getModeOfService() {
		return modeOfService;
	}

	public void setModeOfService(String modeOfService) {
		this.modeOfService = modeOfService;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getServiceTime() {
		return serviceTime;
	}

	public void setServiceTime(Date serviceTime) {
		this.serviceTime = serviceTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getServiceYears() {
		return serviceYears;
	}

	public void setServiceYears(Date serviceYears) {
		this.serviceYears = serviceYears;
	}
	
	@Length(min=0, max=1, message="是否兼任村委会社区居委会委员长度必须介于 0 和 1 之间")
	public String getVillaCommMembFlag() {
		return villaCommMembFlag;
	}

	public void setVillaCommMembFlag(String villaCommMembFlag) {
		this.villaCommMembFlag = villaCommMembFlag;
	}
	
	@Length(min=0, max=1, message="是否兼任村委会社区居委会主任长度必须介于 0 和 1 之间")
	public String getDireCommMembFlag() {
		return direCommMembFlag;
	}

	public void setDireCommMembFlag(String direCommMembFlag) {
		this.direCommMembFlag = direCommMembFlag;
	}
	
	@Length(min=0, max=10, message="班子职务排序长度必须介于 0 和 10 之间")
	public String getRankingOfTeamPosts() {
		return rankingOfTeamPosts;
	}

	public void setRankingOfTeamPosts(String rankingOfTeamPosts) {
		this.rankingOfTeamPosts = rankingOfTeamPosts;
	}
	
	@Length(min=0, max=64, message="行政职务名称长度必须介于 0 和 64 之间")
	public String getAdminPostionName() {
		return adminPostionName;
	}

	public void setAdminPostionName(String adminPostionName) {
		this.adminPostionName = adminPostionName;
	}
	
	@Length(min=0, max=100, message="任职单位长度必须介于 0 和 100 之间")
	public String getServingUint() {
		return servingUint;
	}

	public void setServingUint(String servingUint) {
		this.servingUint = servingUint;
	}
	
	@Length(min=0, max=10, message="个人职务排序长度必须介于 0 和 10 之间")
	public String getPersonalJobRanking() {
		return personalJobRanking;
	}

	public void setPersonalJobRanking(String personalJobRanking) {
		this.personalJobRanking = personalJobRanking;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getAdminServiceTime() {
		return adminServiceTime;
	}

	public void setAdminServiceTime(Date adminServiceTime) {
		this.adminServiceTime = adminServiceTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getAdminDepartTime() {
		return adminDepartTime;
	}

	public void setAdminDepartTime(Date adminDepartTime) {
		this.adminDepartTime = adminDepartTime;
	}
	
	@Length(min=0, max=64, message="教育类别长度必须介于 0 和 64 之间")
	public String getEducationCategory() {
		return educationCategory;
	}

	public void setEducationCategory(String educationCategory) {
		this.educationCategory = educationCategory;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getDegreeAwardTime() {
		return degreeAwardTime;
	}

	public void setDegreeAwardTime(Date degreeAwardTime) {
		this.degreeAwardTime = degreeAwardTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEngageStartTime() {
		return engageStartTime;
	}

	public void setEngageStartTime(Date engageStartTime) {
		this.engageStartTime = engageStartTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEngageEndTime() {
		return engageEndTime;
	}

	public void setEngageEndTime(Date engageEndTime) {
		this.engageEndTime = engageEndTime;
	}
	
	@Length(min=0, max=100, message="专业技术职务长度必须介于 0 和 100 之间")
	public String getProfTechPosition() {
		return profTechPosition;
	}

	public void setProfTechPosition(String profTechPosition) {
		this.profTechPosition = profTechPosition;
	}
	
	@Length(min=0, max=100, message="专业技术资格长度必须介于 0 和 100 之间")
	public String getProfTechTitle() {
		return profTechTitle;
	}

	public void setProfTechTitle(String profTechTitle) {
		this.profTechTitle = profTechTitle;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEligibilityTime() {
		return eligibilityTime;
	}

	public void setEligibilityTime(Date eligibilityTime) {
		this.eligibilityTime = eligibilityTime;
	}
	
	@Length(min=0, max=1, message="党员是否联系村务、厂务长度必须介于 0 和 1 之间")
	public String getPartRelaVillaFlag() {
		return partRelaVillaFlag;
	}

	public void setPartRelaVillaFlag(String partRelaVillaFlag) {
		this.partRelaVillaFlag = partRelaVillaFlag;
	}
	
	@Length(min=0, max=100, message="联系点名称长度必须介于 0 和 100 之间")
	public String getRelationName() {
		return relationName;
	}

	public void setRelationName(String relationName) {
		this.relationName = relationName;
	}
	
	@Length(min=0, max=1, message="党员是否联系农户长度必须介于 0 和 1 之间")
	public String getPartRelaFarmerFlag() {
		return partRelaFarmerFlag;
	}

	public void setPartRelaFarmerFlag(String partRelaFarmerFlag) {
		this.partRelaFarmerFlag = partRelaFarmerFlag;
	}
	
	@Length(min=0, max=10, message="农户数量长度必须介于 0 和 10 之间")
	public String getFarmerNum() {
		return farmerNum;
	}

	public void setFarmerNum(String farmerNum) {
		this.farmerNum = farmerNum;
	}
	
	@Length(min=0, max=1, message="是否&rdquo;十百千万&ldquo;驻村工作组干部长度必须介于 0 和 1 之间")
	public String getVillaWorkGroupFlag() {
		return villaWorkGroupFlag;
	}

	public void setVillaWorkGroupFlag(String villaWorkGroupFlag) {
		this.villaWorkGroupFlag = villaWorkGroupFlag;
	}
	
	@Length(min=0, max=100, message="驻村名称长度必须介于 0 和 100 之间")
	public String getResidentVillageName() {
		return residentVillageName;
	}

	public void setResidentVillageName(String residentVillageName) {
		this.residentVillageName = residentVillageName;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getAddTime() {
		return addTime;
	}

	public void setAddTime(Date addTime) {
		this.addTime = addTime;
	}
	
	@Length(min=0, max=100, message="党员增加长度必须介于 0 和 100 之间")
	public String getPartAdd() {
		return partAdd;
	}

	public void setPartAdd(String partAdd) {
		this.partAdd = partAdd;
	}
	
	@Length(min=0, max=64, message="单位属性长度必须介于 0 和 64 之间")
	public String getDeptAttr() {
		return deptAttr;
	}

	public void setDeptAttr(String deptAttr) {
		this.deptAttr = deptAttr;
	}
	
	@Length(min=0, max=255, message="所属行业长度必须介于 0 和 255 之间")
	public String getDeptIndustry() {
		return deptIndustry;
	}

	public void setDeptIndustry(String deptIndustry) {
		this.deptIndustry = deptIndustry;
	}

	public String getBeloneOrgName() {
		return beloneOrgName;
	}

	public void setBeloneOrgName(String beloneOrgName) {
		this.beloneOrgName = beloneOrgName;
	}

	public String getSuperPartOrgName() {
		return superPartOrgName;
	}

	public void setSuperPartOrgName(String superPartOrgName) {
		this.superPartOrgName = superPartOrgName;
	}
}