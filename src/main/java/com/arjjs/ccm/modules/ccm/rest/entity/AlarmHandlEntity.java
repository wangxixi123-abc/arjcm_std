package com.arjjs.ccm.modules.ccm.rest.entity;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 警情列表实体类
 */

public class AlarmHandlEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	private String handleId;
	private String handleStatus;
	private String alarmId;
	private String alarmPlace;
	private String alarmContent;
	private String alarmIsImportant;
	private String alarmGenreCode;
	private String alarmGenerName;
	private String task;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date   alarmTime;

	public String getHandleId() {
		return handleId;
	}

	public void setHandleId(String handleId) {
		this.handleId = handleId;
	}

	public String getAlarmId() {
		return alarmId;
	}

	public void setAlarmId(String alarmId) {
		this.alarmId = alarmId;
	}

	public String getAlarmPlace() {
		return alarmPlace;
	}

	public void setAlarmPlace(String alarmPlace) {
		this.alarmPlace = alarmPlace;
	}

	public String getAlarmContent() {
		return alarmContent;
	}

	public void setAlarmContent(String alarmContent) {
		this.alarmContent = alarmContent;
	}

	public String getAlarmIsImportant() {
		return alarmIsImportant;
	}

	public void setAlarmIsImportant(String alarmIsImportant) {
		this.alarmIsImportant = alarmIsImportant;
	}

	public String getHandleStatus() {
		return handleStatus;
	}

	public void setHandleStatus(String handleStatus) {
		this.handleStatus = handleStatus;
	}

	public String getAlarmGenreCode() {
		return alarmGenreCode;
	}

	public void setAlarmGenreCode(String alarmGenreCode) {
		this.alarmGenreCode = alarmGenreCode;
	}

	public String getAlarmGenerName() {
		return alarmGenerName;
	}

	public void setAlarmGenerName(String alarmGenerName) {
		this.alarmGenerName = alarmGenerName;
	}


	public Date getAlarmTime() {
		return alarmTime;
	}

	public void setAlarmTime(Date alarmTime) {
		this.alarmTime = alarmTime;
	}

	public String getTask() {
		return task;
	}

	public void setTask(String task) {
		this.task = task;
	}
}
