/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.storage.entity;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.common.utils.excel.annotation.ExcelField;
import com.fasterxml.jackson.annotation.JsonBackReference;

/**
 * 盘点详细Entity
 * @author dongqikai
 * @version 2018-07-10
 */
public class PlmCheckDetial extends DataEntity<PlmCheckDetial> {
	
	private static final long serialVersionUID = 1L;
	private PlmStorage storage;		// 仓库
	private String parent;		// 明细id
	private String code;		// 物资编号
	private String name;		// 物资名称
	private String spec;		// 规格型号
	private String typeId;		// 物资类别
	private String typeChild;		// 物资类别2
	private Integer remainingQuantity = 1;		// 物资剩余数量（主要是耗材）
	private String unit;		// 计量单位
	private String status;		// 盘点结果
	private String flag = "0";  //是否完成盘点
	private String extend1;		// 扩展1
	private String extend2;		// 扩展2
	public static final String MISSING = "缺失";  //盘点结果为缺失
	public static final String NORMAL = "正常";   //盘点结果为正常
	public static final String SURPLUS = "多余";  //盘点结果为多余
	public static final String COMPLETE_CHECK = "1";  //盘点完成标记
	public static final String NOT_CHECK = "0";  //未盘点标记
	
	public PlmCheckDetial() {
		super();
	}

	public PlmCheckDetial(String id){
		super(id);
	}

	public PlmStorage getStorage() {
		return storage;
	}

	public void setStorage(PlmStorage storage) {
		this.storage = storage;
	}
	
	@JsonBackReference
	@NotNull(message="明细id不能为空")
	public String getParent() {
		return parent;
	}

	public void setParent(String parent) {
		this.parent = parent;
	}
	@ExcelField(title="物资编号", align=1)
	@Length(min=1, max=64, message="物资编号长度必须介于 1 和 64 之间")
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	
	@Length(min=1, max=64, message="物资名称长度必须介于 1 和 64 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=64, message="规格型号长度必须介于 0 和 64 之间")
	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}
	
	@Length(min=1, max=64, message="物资类别长度必须介于 1 和 64 之间")
	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	
	@Length(min=0, max=64, message="物资类别2长度必须介于 0 和 64 之间")
	public String getTypeChild() {
		return typeChild;
	}

	public void setTypeChild(String typeChild) {
		this.typeChild = typeChild;
	}
	
	public Integer getRemainingQuantity() {
		return remainingQuantity;
	}

	public void setRemainingQuantity(Integer remainingQuantity) {
		this.remainingQuantity = remainingQuantity;
	}
	
	@Length(min=1, max=64, message="计量单位长度必须介于 1 和 64 之间")
	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	@Length(min=0, max=64, message="盘点结果长度必须介于 0 和 64 之间")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}
	
}