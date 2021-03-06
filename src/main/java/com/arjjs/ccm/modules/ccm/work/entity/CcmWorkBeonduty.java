/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.work.entity;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;

import com.arjjs.ccm.common.persistence.DataEntity;

/**
 * 值班表Entity
 * @author liang
 * @version 2018-06-12
 */
public class CcmWorkBeonduty extends DataEntity<CcmWorkBeonduty> {
	
	private static final long serialVersionUID = 1L;
	private Date months;		// 年月
	private String datas;		// 时间段
	private User principal;		// 值班负责人
	private String principalMans;		// 值班队伍
	private String adds;		// 值班地点
	private String details;		// 工作重点
	private Date beginMonths;		// 开始 年月
	private Date endMonths;		// 结束 年月
	private Office office;	// 归属部门
	private String clickDate;		// 年月
	private Date beginDatas;		// 开始时间段
	private Date endDatas;        // 结束时间段

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}
	public Date getBeginDatas() {
		return beginDatas;
	}

	public void setBeginDatas(Date beginDatas) {
		this.beginDatas = beginDatas;
	}
	public Date getEndDatas() {
		return endDatas;
	}

	public void setEndDatas(Date endDatas) {
		this.endDatas = endDatas;
	}




	public String getClickDate() {
		return clickDate;
	}

	public void setClickDate(String clickDate) {
		this.clickDate = clickDate;
	}

	public CcmWorkBeonduty() {
		super();
	}

	public CcmWorkBeonduty(String id){
		super(id);
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getMonths() {
		return months;
	}

	public void setMonths(Date months) {
		this.months = months;
	}
	
	@Length(min=0, max=100, message="时间段长度必须介于 0 和 100 之间")
	public String getDatas() {
		return datas;
	}

	public void setDatas(String datas) {
		this.datas = datas;
	}
	
	public User getPrincipal() {
		return principal;
	}

	public void setPrincipal(User principal) {
		this.principal = principal;
	}
	
	@Length(min=0, max=1000, message="值班队伍长度必须介于 0 和 1000 之间")
	public String getPrincipalMans() {
		return principalMans;
	}

	public void setPrincipalMans(String principalMans) {
		this.principalMans = principalMans;
	}
	
	@Length(min=0, max=100, message="值班地点长度必须介于 0 和 100 之间")
	public String getAdds() {
		return adds;
	}

	public void setAdds(String adds) {
		this.adds = adds;
	}
	
	@Length(min=0, max=1000, message="工作重点长度必须介于 0 和 1000 之间")
	public String getDetails() {
		return details;
	}

	public void setDetails(String details) {
		this.details = details;
	}
	
	public Date getBeginMonths() {
		return beginMonths;
	}

	public void setBeginMonths(Date beginMonths) {
		this.beginMonths = beginMonths;
	}
	
	public Date getEndMonths() {
		return endMonths;
	}

	public void setEndMonths(Date endMonths) {
		this.endMonths = endMonths;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
		
}