/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.partyvoluteer.entity;

import com.arjjs.ccm.modules.sys.entity.Area;
import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;

/**
 * 志愿者管理Entity
 * @author maoxb
 * @version 2019-08-13
 */
public class CcmPartyVolunteer extends DataEntity<CcmPartyVolunteer> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String sex;		// 性别
	private Area community;		// 选择社区
	private String beloneTeam;		// 所属队伍
	private String educationalBackground;		// 学历
	private String age;		// 年龄
	private String nation;		// 民族
	private String healthCondition;		// 健康状况
	private String presentAssignment;		// 现任职务
	private String personalSpecialty;		// 个人特长
	private String serviceIntention;		// 服务意向
	private String beginAge;		// 开始 年龄
	private String endAge;		// 结束 年龄
	private String officeId;
	
	public String getOfficeId() {
		return officeId;
	}

	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}
	public CcmPartyVolunteer() {
		super();
	}

	public CcmPartyVolunteer(String id){
		super(id);
	}

	@Length(min=0, max=100, message="名称长度必须介于 0 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=1, message="性别长度必须介于 0 和 1 之间")
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	

	public Area getCommunity() {
		return community;
	}

	public void setCommunity(Area community) {
		this.community = community;
	}
	
	@Length(min=0, max=64, message="所属队伍长度必须介于 0 和 64 之间")
	public String getBeloneTeam() {
		return beloneTeam;
	}

	public void setBeloneTeam(String beloneTeam) {
		this.beloneTeam = beloneTeam;
	}
	
	@Length(min=0, max=64, message="学历长度必须介于 0 和 64 之间")
	public String getEducationalBackground() {
		return educationalBackground;
	}

	public void setEducationalBackground(String educationalBackground) {
		this.educationalBackground = educationalBackground;
	}
	
	@Length(min=0, max=10, message="年龄长度必须介于 0 和 10 之间")
	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}
	
	@Length(min=0, max=64, message="民族长度必须介于 0 和 64 之间")
	public String getNation() {
		return nation;
	}

	public void setNation(String nation) {
		this.nation = nation;
	}
	
	@Length(min=0, max=64, message="健康状况长度必须介于 0 和 64 之间")
	public String getHealthCondition() {
		return healthCondition;
	}

	public void setHealthCondition(String healthCondition) {
		this.healthCondition = healthCondition;
	}
	
	@Length(min=0, max=100, message="现任职务长度必须介于 0 和 100 之间")
	public String getPresentAssignment() {
		return presentAssignment;
	}

	public void setPresentAssignment(String presentAssignment) {
		this.presentAssignment = presentAssignment;
	}
	
	public String getPersonalSpecialty() {
		return personalSpecialty;
	}

	public void setPersonalSpecialty(String personalSpecialty) {
		this.personalSpecialty = personalSpecialty;
	}
	
	public String getServiceIntention() {
		return serviceIntention;
	}

	public void setServiceIntention(String serviceIntention) {
		this.serviceIntention = serviceIntention;
	}
	
	public String getBeginAge() {
		return beginAge;
	}

	public void setBeginAge(String beginAge) {
		this.beginAge = beginAge;
	}
	
	public String getEndAge() {
		return endAge;
	}

	public void setEndAge(String endAge) {
		this.endAge = endAge;
	}
		
}