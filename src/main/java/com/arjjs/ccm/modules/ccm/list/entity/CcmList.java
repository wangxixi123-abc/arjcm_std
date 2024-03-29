/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.list.entity;

import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;

/**
 * 名单库实体类Entity
 * @author jpy
 * @version 2019-06-04
 */
public class CcmList extends DataEntity<CcmList> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String type;		// 类型
	private String description;		// 描述
	
	private int peopleCount;  //库下属人员总数
	
	public CcmList() {
		super();
	}

	public CcmList(String id){
		super(id);
	}

	@Length(min=1, max=64, message="名称长度必须介于 1 和 64 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=2, message="类型长度必须介于 1 和 2 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=0, max=255, message="描述长度必须介于 0 和 255 之间")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getPeopleCount() {
		return peopleCount;
	}

	public void setPeopleCount(int peopleCount) {
		this.peopleCount = peopleCount;
	}
		
}