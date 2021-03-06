/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.org.entity;

import com.arjjs.ccm.modules.sys.entity.Area;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.arjjs.ccm.common.persistence.DataEntity;

/**
 * 区域扩展表（社区、网格）Entity
 * @author pengjianqiang
 * @version 2018-01-29
 */
public class CcmOrgArea extends DataEntity<CcmOrgArea> {
	
	private static final long serialVersionUID = 1L;
	private Area area;		// 关联区域
	private String netManName;		// 管理员姓名
	private String sex;		// 性别
	private String nation;		// 民族
	private String politics;		// 政治面貌
	private Date birthday;		// 出生日期
	private String education;		// 联系方式
	private String telephone;		// 手机号码
	private String fixTel;		// 固定电话
	private String netPeoName;		// 工作人员姓名
	private Integer netPeoNum;		// 工作人员数量
	private Integer netNum;		// 户数
	private Integer mannum;		// 人口
	private Integer keyPersonnelNum; //重点人员数量
	private Double netArea;		// 面积（平方米）
	private Integer videoSafetyNum;		// 公共安全视频监控摄像机总数
	private Integer definitionNum;		// 高清摄像机数量
	private Integer videoTownsNum;		// 与乡镇（街道）摄像机数量
	private Integer videoAlldayNum;		// 24小时值守摄像机数量
	private Integer eachKiloNum;		// 每平方公里视频监控摄像机数量
	private Integer eachHundNum;		// 每百人视频监控摄像机数量
	private String areaMap;		// 区域图
	private String areaPoint;		// 中心点
	private String icon;		// 图标
	private String more1;		// sql(查询条件)
	private String areainfor;		// 辖区说明
	private String more2;		// 冗余字段2
	private String more3;		// 冗余字段3
	private String type;		// 区域类型：社区、网格等
	private String areaId;		// 关联区域ID，上下级同步时json对象转换用
	private String areaParentId;		// 关联区域父节点ID，上下级同步时json对象转换用
	private Area userArea;  //登录用户所在区域
	private String areaColor; //区域颜色
	private Integer partyMembersNum; //党员人数
	private Integer directorPovertyAlleviation; //扶贫主任
	private Integer firstSecretary; //扶贫第一书记
	private Integer policeAssistant; //警务助理
	private Integer politicalLegalDeployment; //政法派驻员
	private Integer peopleLivelihoodSupervisor; //民生监督员
	private String  remarks;		// 备注
	
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getAreaParentId() {
		return areaParentId;
	}

	public void setAreaParentId(String areaParentId) {
		this.areaParentId = areaParentId;
	}

	public Integer getDirectorPovertyAlleviation() {
		return directorPovertyAlleviation;
	}

	public void setDirectorPovertyAlleviation(Integer directorPovertyAlleviation) {
		this.directorPovertyAlleviation = directorPovertyAlleviation;
	}

	public Integer getFirstSecretary() {
		return firstSecretary;
	}

	public void setFirstSecretary(Integer firstSecretary) {
		this.firstSecretary = firstSecretary;
	}

	public Integer getPoliceAssistant() {
		return policeAssistant;
	}

	public void setPoliceAssistant(Integer policeAssistant) {
		this.policeAssistant = policeAssistant;
	}

	public Integer getPoliticalLegalDeployment() {
		return politicalLegalDeployment;
	}

	public void setPoliticalLegalDeployment(Integer politicalLegalDeployment) {
		this.politicalLegalDeployment = politicalLegalDeployment;
	}

	public Integer getPeopleLivelihoodSupervisor() {
		return peopleLivelihoodSupervisor;
	}

	public void setPeopleLivelihoodSupervisor(Integer peopleLivelihoodSupervisor) {
		this.peopleLivelihoodSupervisor = peopleLivelihoodSupervisor;
	}

	public Integer getPartyMembersNum() {
		return partyMembersNum;
	}

	public void setPartyMembersNum(Integer partyMembersNum) {
		this.partyMembersNum = partyMembersNum;
	}

	public String getAreaColor() {
		return areaColor;
	}

	public void setAreaColor(String areaColor) {
		this.areaColor = areaColor;
	}

	public Area getUserArea() {
		return userArea;
	}

	public void setUserArea(Area userArea) {
		this.userArea = userArea;
	}

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public CcmOrgArea() {
		super();
	}

	public CcmOrgArea(String id){
		super(id);
	}

	public Area getArea() {
		return area;
	}

	public void setArea(Area area) {
		this.area = area;
	}
	
	@Length(min=0, max=50, message="管理员姓名长度必须介于 0 和 50 之间")
	public String getNetManName() {
		return netManName;
	}

	public void setNetManName(String netManName) {
		this.netManName = netManName;
	}
	
	@Length(min=0, max=1, message="性别长度必须介于 0 和 1 之间")
	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	@Length(min=0, max=2, message="民族长度必须介于 0 和 2 之间")
	public String getNation() {
		return nation;
	}

	public void setNation(String nation) {
		this.nation = nation;
	}
	
	@Length(min=0, max=2, message="政治面貌长度必须介于 0 和 2 之间")
	public String getPolitics() {
		return politics;
	}

	public void setPolitics(String politics) {
		this.politics = politics;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}
	
	@Length(min=0, max=2, message="联系方式长度必须介于 0 和 2 之间")
	public String getEducation() {
		return education;
	}

	public void setEducation(String education) {
		this.education = education;
	}
	
	@Length(min=0, max=18, message="手机号码长度必须介于 0 和 18 之间")
	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	
	@Length(min=0, max=18, message="固定电话长度必须介于 0 和 18 之间")
	public String getFixTel() {
		return fixTel;
	}

	public void setFixTel(String fixTel) {
		this.fixTel = fixTel;
	}
	
	@Length(min=0, max=255, message="工作人员姓名长度必须介于 0 和 255 之间")
	public String getNetPeoName() {
		return netPeoName;
	}

	public void setNetPeoName(String netPeoName) {
		this.netPeoName = netPeoName;
	}
	
	public Integer getNetPeoNum() {
		return netPeoNum;
	}

	public void setNetPeoNum(Integer netPeoNum) {
		this.netPeoNum = netPeoNum;
	}
	
	public Integer getNetNum() {
		return netNum;
	}

	public void setNetNum(Integer netNum) {
		this.netNum = netNum;
	}
	
	public Integer getMannum() {
		return mannum;
	}

	public void setMannum(Integer mannum) {
		this.mannum = mannum;
	}
	
	public Double getNetArea() {
		return netArea;
	}

	public void setNetArea(Double netArea) {
		this.netArea = netArea;
	}
	
	public Integer getVideoSafetyNum() {
		return videoSafetyNum;
	}

	public void setVideoSafetyNum(Integer videoSafetyNum) {
		this.videoSafetyNum = videoSafetyNum;
	}
	
	public Integer getDefinitionNum() {
		return definitionNum;
	}

	public void setDefinitionNum(Integer definitionNum) {
		this.definitionNum = definitionNum;
	}
	
	public Integer getVideoTownsNum() {
		return videoTownsNum;
	}

	public void setVideoTownsNum(Integer videoTownsNum) {
		this.videoTownsNum = videoTownsNum;
	}
	
	public Integer getVideoAlldayNum() {
		return videoAlldayNum;
	}

	public void setVideoAlldayNum(Integer videoAlldayNum) {
		this.videoAlldayNum = videoAlldayNum;
	}
	
	public Integer getEachKiloNum() {
		return eachKiloNum;
	}

	public void setEachKiloNum(Integer eachKiloNum) {
		this.eachKiloNum = eachKiloNum;
	}
	
	public Integer getEachHundNum() {
		return eachHundNum;
	}

	public void setEachHundNum(Integer eachHundNum) {
		this.eachHundNum = eachHundNum;
	}
	
	@Length(min=0, max=20000, message="区域图长度必须介于 0 和 20000 之间")
	public String getAreaMap() {
		return areaMap;
	}

	public void setAreaMap(String areaMap) {
		this.areaMap = areaMap;
	}
	
	@Length(min=0, max=40, message="中心点长度必须介于 0 和 40 之间")
	public String getAreaPoint() {
		return areaPoint;
	}

	public void setAreaPoint(String areaPoint) {
		this.areaPoint = areaPoint;
	}
	
	@Length(min=0, max=255, message="图标长度必须介于 0 和 255 之间")
	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}
	
	@Length(min=0, max=100, message="冗余字段1长度必须介于 0 和 100 之间")
	public String getMore1() {
		return more1;
	}

	public void setMore1(String more1) {
		this.more1 = more1;
	}
	
	public String getAreainfor() {
		return areainfor;
	}

	public void setAreainfor(String areainfor) {
		this.areainfor = areainfor;
	}
	
	@Length(min=0, max=100, message="冗余字段2长度必须介于 0 和 100 之间")
	public String getMore2() {
		return more2;
	}

	public void setMore2(String more2) {
		this.more2 = more2;
	}
	
	@Length(min=0, max=100, message="冗余字段3长度必须介于 0 和 100 之间")
	public String getMore3() {
		return more3;
	}

	public void setMore3(String more3) {
		this.more3 = more3;
	}

	public Integer getKeyPersonnelNum() {
		return keyPersonnelNum;
	}

	public void setKeyPersonnelNum(Integer keyPersonnelNum) {
		this.keyPersonnelNum = keyPersonnelNum;
	}

	@Override
	public String toString() {
		return "CcmOrgArea{" +
				"area=" + area +
				", netManName='" + netManName + '\'' +
				", sex='" + sex + '\'' +
				", nation='" + nation + '\'' +
				", politics='" + politics + '\'' +
				", birthday=" + birthday +
				", education='" + education + '\'' +
				", telephone='" + telephone + '\'' +
				", fixTel='" + fixTel + '\'' +
				", netPeoName='" + netPeoName + '\'' +
				", netPeoNum=" + netPeoNum +
				", netNum=" + netNum +
				", mannum=" + mannum +
				", netArea=" + netArea +
				", videoSafetyNum=" + videoSafetyNum +
				", definitionNum=" + definitionNum +
				", videoTownsNum=" + videoTownsNum +
				", videoAlldayNum=" + videoAlldayNum +
				", eachKiloNum=" + eachKiloNum +
				", eachHundNum=" + eachHundNum +
				", areaMap='" + areaMap + '\'' +
				", areaPoint='" + areaPoint + '\'' +
				", icon='" + icon + '\'' +
				", more1='" + more1 + '\'' +
				", areainfor='" + areainfor + '\'' +
				", more2='" + more2 + '\'' +
				", more3='" + more3 + '\'' +
				", type='" + type + '\'' +
				", areaId='" + areaId + '\'' +
				", userArea=" + userArea +
				", areaColor='" + areaColor + '\'' +
				", partyMembersNum=" + partyMembersNum +
				", directorPovertyAlleviation=" + directorPovertyAlleviation +
				", firstSecretary=" + firstSecretary +
				", policeAssistant=" + policeAssistant +
				", politicalLegalDeployment=" + politicalLegalDeployment +
				", peopleLivelihoodSupervisor=" + peopleLivelihoodSupervisor +
				'}';
	}
}