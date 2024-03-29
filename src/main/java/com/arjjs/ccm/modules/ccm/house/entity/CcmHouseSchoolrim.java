/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.house.entity;

import org.hibernate.validator.constraints.Length;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.common.persistence.DataEntity;

/**
 * 学校Entity
 * @author wwh
 * @version 2018-01-10
 */
public class CcmHouseSchoolrim extends DataEntity<CcmHouseSchoolrim> {
	
	private static final long serialVersionUID = 1L;
	private String schoolName;		// 学校名称
	private String schoolAdd;		// 学校地址
	private String schoolType;		// 学校办学类型
	private String schoolEducDepa;		// 学校所属主管教育行政部门
	private Integer schoolNum;		// 在校学生人数
	private Integer teacherNum;		// 教职工人数
	private Integer teachingFunds;		// 教学经费(元)
	private String headName;		// 校长姓名
	private String headTl;		// 校长联系方式
	private String secuBranName;		// 分管安全保卫责任人姓名
	private String secuBranTl;		// 分管安全保卫责任人联系方式
	private String secuGuardName;		// 安全保卫责任人姓名
	private String secuGuardTl;		// 安全保卫责任人联系方式
	private String secuName;		// 治安责任人姓名
	private String secuTl;		// 治安责任人联系方式
	private Integer secuGuardNum;		// 安全保卫人数
	private Area area;		// 所属区域
	private String areaMap;   // 区域图
	private String areaPoint;		// 中心点
	private String image;		// 图标
	private String images;		// 学校图片
	private String schoolTypeLable; 	//app接口使用
	private String count;
	
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}


	private User checkUser;		// 拦截器中使用该用户进行权限拦截，App的rest接口使用
	public User getCheckUser() {
		return checkUser;
	}
	public void setCheckUser(User checkUser) {
		this.checkUser = checkUser;
	}

	
	private String more1;		// sql
	private String more2;		// more2
	private String more3;		// more3
	
	public String getMore1() {
		return more1;
	}

	public void setMore1(String more1) {
		this.more1 = more1;
	}

	public String getMore2() {
		return more2;
	}

	public void setMore2(String more2) {
		this.more2 = more2;
	}

	public String getMore3() {
		return more3;
	}

	public void setMore3(String more3) {
		this.more3 = more3;
	}

	public CcmHouseSchoolrim() {
		super();
	}

	public CcmHouseSchoolrim(String id){
		super(id);
	}

	@Length(min=0, max=100, message="学校名称长度必须介于 0 和 100 之间")
	public String getSchoolName() {
		return schoolName;
	}

	public void setSchoolName(String schoolName) {
		this.schoolName = schoolName;
	}
	
	@Length(min=0, max=200, message="学校地址长度必须介于 0 和 200 之间")
	public String getSchoolAdd() {
		return schoolAdd;
	}

	public void setSchoolAdd(String schoolAdd) {
		this.schoolAdd = schoolAdd;
	}
	
	@Length(min=0, max=2, message="学校办学类型长度必须介于 0 和 2 之间")
	public String getSchoolType() {
		return schoolType;
	}

	public void setSchoolType(String schoolType) {
		this.schoolType = schoolType;
	}
	
	@Length(min=0, max=6, message="学校所属主管教育行政部门长度必须介于 0 和 6 之间")
	public String getSchoolEducDepa() {
		return schoolEducDepa;
	}

	public void setSchoolEducDepa(String schoolEducDepa) {
		this.schoolEducDepa = schoolEducDepa;
	}
	
	public Integer getSchoolNum() {
		return schoolNum;
	}

	public void setSchoolNum(Integer schoolNum) {
		this.schoolNum = schoolNum;
	}
	
	@Length(min=0, max=50, message="校长姓名长度必须介于 0 和 50 之间")
	public String getHeadName() {
		return headName;
	}

	public void setHeadName(String headName) {
		this.headName = headName;
	}
	
	@Length(min=0, max=50, message="校长联系方式长度必须介于 0 和 50 之间")
	public String getHeadTl() {
		return headTl;
	}

	public void setHeadTl(String headTl) {
		this.headTl = headTl;
	}
	
	@Length(min=0, max=50, message="分管安全保卫责任人姓名长度必须介于 0 和 50 之间")
	public String getSecuBranName() {
		return secuBranName;
	}

	public void setSecuBranName(String secuBranName) {
		this.secuBranName = secuBranName;
	}
	
	@Length(min=0, max=50, message="分管安全保卫责任人联系方式长度必须介于 0 和 50 之间")
	public String getSecuBranTl() {
		return secuBranTl;
	}

	public void setSecuBranTl(String secuBranTl) {
		this.secuBranTl = secuBranTl;
	}
	
	@Length(min=0, max=50, message="安全保卫责任人姓名长度必须介于 0 和 50 之间")
	public String getSecuGuardName() {
		return secuGuardName;
	}

	public void setSecuGuardName(String secuGuardName) {
		this.secuGuardName = secuGuardName;
	}
	
	@Length(min=0, max=50, message="安全保卫责任人联系方式长度必须介于 0 和 50 之间")
	public String getSecuGuardTl() {
		return secuGuardTl;
	}

	public void setSecuGuardTl(String secuGuardTl) {
		this.secuGuardTl = secuGuardTl;
	}
	
	@Length(min=0, max=50, message="治安责任人姓名长度必须介于 0 和 50 之间")
	public String getSecuName() {
		return secuName;
	}

	public void setSecuName(String secuName) {
		this.secuName = secuName;
	}
	
	@Length(min=0, max=50, message="治安责任人联系方式长度必须介于 0 和 50 之间")
	public String getSecuTl() {
		return secuTl;
	}

	public void setSecuTl(String secuTl) {
		this.secuTl = secuTl;
	}
	
	public Integer getSecuGuardNum() {
		return secuGuardNum;
	}

	public void setSecuGuardNum(Integer secuGuardNum) {
		this.secuGuardNum = secuGuardNum;
	}
	
	public Area getArea() {
		return area;
	}

	public void setArea(Area area) {
		this.area = area;
	}
	
	@Length(min=0, max=2000, message="中心点长度必须介于 0 和 2000 之间")
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
	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	@Length(min=0, max=255, message="学校图片长度必须介于 0 和 255 之间")
	public String getImages() {
		return images;
	}

	public void setImages(String images) {
		this.images = images;
	}
	public String getSchoolTypeLable() {
		return schoolTypeLable;
	}
	public void setSchoolTypeLable(String schoolTypeLable) {
		this.schoolTypeLable = schoolTypeLable;
	}
	public Integer getTeacherNum() {
		return teacherNum;
	}
	public void setTeacherNum(Integer teacherNum) {
		this.teacherNum = teacherNum;
	}
	public Integer getTeachingFunds() {
		return teachingFunds;
	}
	public void setTeachingFunds(Integer teachingFunds) {
		this.teachingFunds = teachingFunds;
	}
	
}