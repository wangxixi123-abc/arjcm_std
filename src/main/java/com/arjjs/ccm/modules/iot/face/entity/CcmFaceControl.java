/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.iot.face.entity;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;

import java.util.Date;
import java.util.List;

/**
 * 人脸布控实体类Entity
 * @author lgh
 * @version 2019-06-05
 */
public class CcmFaceControl extends DataEntity<CcmFaceControl> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 布控名称
	private String listId;		// 布控名单库
	private Date startTime;		// 布控开始时间
	private Date endTime;		// 布控结束时间
	private String controllerLevel;		// 布控等级
	private String machine;		// 布控抓拍机
	private String controllerReason;		// 布控原因
	private String ident;	//身份证号

	private List<String> librarySelectList;	//名单库集合
	private List<String> captureMachineList;	//抓拍机集合
	
	public CcmFaceControl() {
		super();
	}

	public CcmFaceControl(String id){
		super(id);
	}

	@Length(min=1, max=255, message="布控名称长度必须介于 1 和 255 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=1000, message="布控名单库长度必须介于 1 和 1000 之间")
	public String getListId() {
		return listId;
	}

	public void setListId(String listId) {
		this.listId = listId;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	@Length(min=1, max=2, message="布控等级长度必须介于 1 和 2 之间")
	public String getControllerLevel() {
		return controllerLevel;
	}

	public void setControllerLevel(String controllerLevel) {
		this.controllerLevel = controllerLevel;
	}
	
	@Length(min=1, max=1000, message="布控抓拍机长度必须介于 1 和 1000 之间")
	public String getMachine() {
		return machine;
	}

	public void setMachine(String machine) {
		this.machine = machine;
	}
	
	@Length(min=0, max=255, message="布控原因长度必须介于 0 和 255 之间")
	public String getControllerReason() {
		return controllerReason;
	}

	public void setControllerReason(String controllerReason) {
		this.controllerReason = controllerReason;
	}

	@Length(min=0, max=18, message="身份证长度必须介于 0 和 18 之间")
	public String getIdent() {
		return ident;
	}

	public void setIdent(String ident) {
		this.ident = ident;
	}

	public List<String> getLibrarySelectList() {
		return librarySelectList;
	}

	public void setLibrarySelectList(List<String> librarySelectList) {
		this.librarySelectList = librarySelectList;
	}

	public List<String> getCaptureMachineList() {
		return captureMachineList;
	}

	public void setCaptureMachineList(List<String> captureMachineList) {
		this.captureMachineList = captureMachineList;
	}
}