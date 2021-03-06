/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.storage.entity;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;

/**
 * 供应商Entity
 * @author dongqikai
 * @version 2018-06-28
 */
public class PlmProvideInfo extends DataEntity<PlmProvideInfo> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 供应商全称
	private String shortName;		// 供应商简称
	private String proId;		// 供应商类型表id
	private String area;		// 地区
	private User principal;		// 负责人
	private String phoneOne;		// 联系电话1
	private String phoneTwo;		// 联系电话2
	private String mobilePhone;		// 移动电话
	private String bankAccounts;		// 银行帐号
	private String openBank;		// 开户银行
	private String email;		// 电子邮件
	private String web;		// 网址
	private String faxes;		// 传真号码
	private User emp;		// 联系人id
	private String calling;		// 行业类别
	private String creditClass;		// 信用等级
	private String extend1;		// 扩展1
	private String extend2;		// 扩展2
	
	public PlmProvideInfo() {
		super();
	}

	public PlmProvideInfo(String id){
		super(id);
	}

	@Length(min=1, max=128, message="供应商全称长度必须介于 1 和 128 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=128, message="供应商简称长度必须介于 1 和 128 之间")
	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}
	
	@Length(min=0, max=64, message="供应商类型表id长度必须介于 0 和 64 之间")
	public String getProId() {
		return proId;
	}

	public void setProId(String proId) {
		this.proId = proId;
	}
	
	@NotNull(message="地区不能为空")
	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}
	
	@NotNull(message="负责人不能为空")
	public User getPrincipal() {
		return principal;
	}

	public void setPrincipal(User principal) {
		this.principal = principal;
	}
	
	@Length(min=0, max=32, message="联系电话1长度必须介于 0 和 32 之间")
	public String getPhoneOne() {
		return phoneOne;
	}

	public void setPhoneOne(String phoneOne) {
		this.phoneOne = phoneOne;
	}
	
	@Length(min=0, max=32, message="联系电话2长度必须介于 0 和 32 之间")
	public String getPhoneTwo() {
		return phoneTwo;
	}

	public void setPhoneTwo(String phoneTwo) {
		this.phoneTwo = phoneTwo;
	}
	
	@Length(min=0, max=32, message="移动电话长度必须介于 0 和 32 之间")
	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}
	
	@Length(min=0, max=32, message="银行帐号长度必须介于 0 和 32 之间")
	public String getBankAccounts() {
		return bankAccounts;
	}

	public void setBankAccounts(String bankAccounts) {
		this.bankAccounts = bankAccounts;
	}
	
	@Length(min=0, max=64, message="开户银行长度必须介于 0 和 64 之间")
	public String getOpenBank() {
		return openBank;
	}

	public void setOpenBank(String openBank) {
		this.openBank = openBank;
	}
	
	@Length(min=0, max=32, message="电子邮件长度必须介于 0 和 32 之间")
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=64, message="网址长度必须介于 0 和 64 之间")
	public String getWeb() {
		return web;
	}

	public void setWeb(String web) {
		this.web = web;
	}
	
	@Length(min=0, max=32, message="传真号码长度必须介于 0 和 32 之间")
	public String getFaxes() {
		return faxes;
	}

	public void setFaxes(String faxes) {
		this.faxes = faxes;
	}
	
	public User getEmp() {
		return emp;
	}

	public void setEmp(User emp) {
		this.emp = emp;
	}
	
	@Length(min=0, max=64, message="行业类别长度必须介于 0 和 64 之间")
	public String getCalling() {
		return calling;
	}

	public void setCalling(String calling) {
		this.calling = calling;
	}
	
	@Length(min=1, max=32, message="信用等级长度必须介于 1 和 32 之间")
	public String getCreditClass() {
		return creditClass;
	}

	public void setCreditClass(String creditClass) {
		this.creditClass = creditClass;
	}
	
	@Length(min=0, max=256, message="扩展1长度必须介于 0 和 256 之间")
	public String getExtend1() {
		return extend1;
	}

	public void setExtend1(String extend1) {
		this.extend1 = extend1;
	}
	
	@Length(min=0, max=256, message="扩展2长度必须介于 0 和 256 之间")
	public String getExtend2() {
		return extend2;
	}

	public void setExtend2(String extend2) {
		this.extend2 = extend2;
	}
	
}