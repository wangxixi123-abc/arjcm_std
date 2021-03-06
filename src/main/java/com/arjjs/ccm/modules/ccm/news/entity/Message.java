/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.news.entity;

import com.arjjs.ccm.common.utils.excel.annotation.ExcelField;
import org.hibernate.validator.constraints.Length;
import com.arjjs.ccm.modules.sys.entity.User;
import javax.validation.constraints.NotNull;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.arjjs.ccm.common.persistence.DataEntity;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 消息管理Entity
 * @author cby
 * @version 2019-11-28
 */
public class Message extends DataEntity<Message> {
	
	private static final long serialVersionUID = 1L;
	private String type;		// 消息类型
	private String objId;		// 需要查询的消息本体
	private String content;		// 消息内容
	private User user;		// 收到信息的用户
	private String readFlag;		// read_flag
	private Date deadline;		// deadline
	private String createByName; // 发送人
	private Date beginDates;    //发送开始日期
	private Date endDatas;   //发送结束日期

	public void setBeginDates(Date beginDates) {
		this.beginDates = beginDates;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getBeginDates() {
		return beginDates;
	}

	public void setEndDatas(Date endDatas) {
		this.endDatas = endDatas;
	}
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEndDatas() {
		return endDatas;
	}



	public Message() {
		super();
	}

	public Message(String id){
		super(id);
	}

	@Length(min=1, max=2, message="消息类型长度必须介于 1 和 2 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=0, max=64, message="需要查询的消息本体长度必须介于 0 和 64 之间")
	public String getObjId() {
		return objId;
	}

	public void setObjId(String objId) {
		this.objId = objId;
	}
	
	@Length(min=1, max=255, message="消息内容长度必须介于 1 和 255 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@NotNull(message="收到信息的用户不能为空")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@Length(min=0, max=1, message="read_flag长度必须介于 0 和 1 之间")
	public String getReadFlag() {
		return readFlag;
	}

	public void setReadFlag(String readFlag) {
		this.readFlag = readFlag;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getDeadline() {
		return deadline;
	}

	public void setDeadline(Date deadline) {
		this.deadline = deadline;
	}

	public String getCreateByName() {
		return createByName;
	}

	public void setCreateByName(String createByName) {
		this.createByName = createByName;
	}
	
	
}