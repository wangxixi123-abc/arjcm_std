/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.home.entity;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.fasterxml.jackson.annotation.JsonBackReference;

/**
 * 门户方案Entity
 * 
 * @author liuxue
 * @version 2018-07-04
 */
public class PlmPortalDetail extends DataEntity<PlmPortalDetail> {

	private static final long serialVersionUID = 1L;
	private PlmPortalPlan parent; // 方案编号 父类
	private String portalDictId; // 门户字典ID
	private String title; // 布局标题
	private String connect; // 链接
	private String content; // 内容链接
	private String hight; // 高度
	private String longItude; // 横向位置
	private String latItude; // 纵向位置
	private String type; // 类型
	private String sort; // 排序
	private String extend1; // 扩展1
	private String extend2; // 扩展2

	public String getPortalDictId() {
		return portalDictId;
	}

	public void setPortalDictId(String portalDictId) {
		this.portalDictId = portalDictId;
	}

	public PlmPortalDetail() {
		super();
	}

	public PlmPortalDetail(String id) {
		super(id);
	}

	public PlmPortalDetail(PlmPortalPlan parent) {
		this.parent = parent;
	}

	@JsonBackReference
	@NotNull(message = "方案编号不能为空")
	public PlmPortalPlan getParent() {
		return parent;
	}

	public void setParent(PlmPortalPlan parent) {
		this.parent = parent;
	}

	@Length(min = 0, max = 256, message = "布局标题长度必须介于 0 和 256 之间")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Length(min = 0, max = 256, message = "链接长度必须介于 0 和 256 之间")
	public String getConnect() {
		return connect;
	}

	public void setConnect(String connect) {
		this.connect = connect;
	}

	@Length(min = 1, max = 256, message = "内容链接长度必须介于 1 和 256 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@Length(min = 1, max = 4, message = "高度长度必须介于 1 和 4 之间")
	public String getHight() {
		return hight;
	}

	public void setHight(String hight) {
		this.hight = hight;
	}

	@Length(min = 1, max = 24, message = "横向位置长度必须介于 1 和 24 之间")
	public String getLongItude() {
		return longItude;
	}

	public void setLongItude(String longItude) {
		this.longItude = longItude;
	}

	@Length(min = 1, max = 24, message = "纵向位置长度必须介于 1 和 24 之间")
	public String getLatItude() {
		return latItude;
	}

	public void setLatItude(String latItude) {
		this.latItude = latItude;
	}

	@Length(min = 1, max = 1, message = "类型长度必须介于 1 和 1 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Length(min = 0, max = 100, message = "排序长度必须介于 0 和 100 之间")
	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	@Length(min = 0, max = 256, message = "扩展1长度必须介于 0 和 256 之间")
	public String getExtend1() {
		return extend1;
	}

	public void setExtend1(String extend1) {
		this.extend1 = extend1;
	}

	@Length(min = 0, max = 256, message = "扩展2长度必须介于 0 和 256 之间")
	public String getExtend2() {
		return extend2;
	}

	public void setExtend2(String extend2) {
		this.extend2 = extend2;
	}

}