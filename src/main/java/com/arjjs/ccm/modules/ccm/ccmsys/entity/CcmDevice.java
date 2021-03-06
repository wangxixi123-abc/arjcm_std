/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.ccmsys.entity;

import org.hibernate.validator.constraints.Length;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.common.utils.excel.annotation.ExcelField;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.fasterxml.jackson.annotation.JsonBackReference;

/**
 * 设备管理Entity
 * @author arj
 * @version 2018-01-25
 */
public class CcmDevice extends DataEntity<CcmDevice> {
	
	private static final long serialVersionUID = 1L;
	private String code;		// 设备编号
	private String name;		// 设备名称
	private String ip;		// IP地址
	private String mask;		// 子网掩码
	private String gateway;		// 网关
	private String proxy;		// 代理IP及端口
	private String protocol;		// 协议
	private String port;		// 端口
	private String sdkPort;		// SDK端口号
	private String channelNum;		// 通道号
	private String param;		// 设备参数信息
	private String account;		// 登陆账号
	private String password;		// 密码
	private CcmDevice parent;		// 父节点ID
	private String typeId;			// 设备类型
	private String typeVidicon;		// 摄像机类型
	private Area area;		// 所属区域
	private String address;		// 安装位置
	private String status;		// 设备状态
	private String companyId;		// 厂商
	private String version;		// 版本
	private String imagePath;		// 图片
	private String description;		// 说明
	private String coordinate;		// 设备坐标
	private String parentIds;		// parentIds
	private String more1;  // Sql 查询语句
	private User checkUser;		// 拦截器中使用该用户进行权限拦截，App的rest接口使用
	private Area userArea;
	private String x;
	private String y;
	private String rangeType;
	private String type; // 摄像机类型  0:'枪机'；1:'球机';2:'半球'

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getRangeType() {
		return rangeType;
	}
	public void setRangeType(String rangeType) {
		this.rangeType = rangeType;
	}
	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	public String getY() {
		return y;
	}
	public void setY(String y) {
		this.y = y;
	}
	public User getCheckUser() {
		return checkUser;
	}
	public void setCheckUser(User checkUser) {
		this.checkUser = checkUser;
	}

	public Area getUserArea() {
		return userArea;
	}

	public void setUserArea(Area userArea) {
		this.userArea = userArea;
	}

	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}

	public CcmDevice() {
		super();
	}

	public CcmDevice(String id){
		super(id);
	}
	@ExcelField(title="设备编号", align=1,sort=1)
	@Length(min=0, max=64, message="设备编号长度必须介于 0 和 64 之间")
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	@ExcelField(title="设备名称", align=1,sort=2)
	@Length(min=0, max=64, message="设备名称长度必须介于 0 和 64 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	@ExcelField(title="IP地址", align=3,sort=3)
	@Length(min=0, max=15, message="IP地址长度必须介于 0 和 15 之间")
	public String getIp() {
		return ip;
	}
    
	public String getMore1() {
		return more1;
	}
	public void setMore1(String more1) {
		this.more1 = more1;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	@ExcelField(title="子网掩码", align=3,sort=4)
	@Length(min=0, max=15, message="子网掩码长度必须介于 0 和 15 之间")
	public String getMask() {
		return mask;
	}

	public void setMask(String mask) {
		this.mask = mask;
	}
	@ExcelField(title="网关", align=3,sort=5)
	@Length(min=0, max=15, message="网关长度必须介于 0 和 15 之间")
	public String getGateway() {
		return gateway;
	}

	public void setGateway(String gateway) {
		this.gateway = gateway;
	}
	@ExcelField(title="代理IP及端口", align=3,sort=6)
	@Length(min=0, max=22, message="代理IP及端口长度必须介于 0 和 22 之间")
	public String getProxy() {
		return proxy;
	}

	public void setProxy(String proxy) {
		this.proxy = proxy;
	}
	@ExcelField(title="协议", align=3,sort=7)
	@Length(min=0, max=64, message="协议长度必须介于 0 和 64 之间")
	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}
	@ExcelField(title="端口", align=3,sort=8)
	@Length(min=0, max=5, message="端口长度必须介于 0 和 5 之间")
	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}
	@ExcelField(title="SDK端口号", align=3,sort=9)
	@Length(min=0, max=5, message="SDK端口号长度必须介于 0 和 5 之间")
	public String getSdkPort() {
		return sdkPort;
	}

	public void setSdkPort(String sdkPort) {
		this.sdkPort = sdkPort;
	}
	@ExcelField(title="通道号", align=3,sort=10)
	@Length(min=0, max=3, message="通道号长度必须介于 0 和 3 之间")
	public String getChannelNum() {
		return channelNum;
	}

	public void setChannelNum(String channelNum) {
		this.channelNum = channelNum;
	}
	@ExcelField(title="设备参数信息", align=1,sort=11)
	@Length(min=0, max=1000, message="设备参数信息长度必须介于 0 和 1000 之间")
	public String getParam() {
		return param;
	}

	public void setParam(String param) {
		this.param = param;
	}
	@ExcelField(title="登陆账号", align=1,sort=12)
	@Length(min=0, max=64, message="登陆账号长度必须介于 0 和 64 之间")
	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}
	@ExcelField(title="密码", align=1,sort=13)
	@Length(min=0, max=64, message="密码长度必须介于 0 和 64 之间")
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	@JsonBackReference
	public CcmDevice getParent() {
		return parent;
	}

	public void setParent(CcmDevice parent) {
		this.parent = parent;
	}
	@ExcelField(title="设备类型", align=1,sort=14,dictType="ccm_device_type_id")
	@Length(min=0, max=3, message="设备类型长度必须介于 0 和 3 之间")
	public String getTypeId() {
		return typeId;
	}

	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	@ExcelField(title="所属区域", align=1,sort=15)
	public Area getArea() {
		return area;
	}

	public void setArea(Area area) {
		this.area = area;
	}
	@ExcelField(title="安装位置", align=1,sort=16)
	@Length(min=0, max=200, message="安装位置长度必须介于 0 和 200 之间")
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	@ExcelField(title="设备状态", align=1,sort=17,dictType="ccm_device_status")
	@Length(min=0, max=1, message="设备状态长度必须介于 0 和 1 之间")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	@ExcelField(title="厂商", align=1,sort=18)
	@Length(min=0, max=64, message="厂商长度必须介于 0 和 64 之间")
	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	@ExcelField(title="版本", align=3,sort=19)
	@Length(min=0, max=64, message="版本长度必须介于 0 和 64 之间")
	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}
	@ExcelField(title="图片路径", align=3,sort=20)
	@Length(min=0, max=100, message="图片长度必须介于 0 和 100 之间")
	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	@ExcelField(title="说明", align=1,sort=21)
	@Length(min=0, max=1000, message="说明长度必须介于 0 和 1000 之间")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	@ExcelField(title="设备坐标", align=3,sort=22)
	@Length(min=0, max=64, message="设备坐标长度必须介于 0 和 64 之间")
	public String getCoordinate() {
		return coordinate;
	}

	public void setCoordinate(String coordinate) {
		this.coordinate = coordinate;
	}

	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}
	
	public String getTypeVidicon() {
		return typeVidicon;
	}
	public void setTypeVidicon(String typeVidicon) {
		this.typeVidicon = typeVidicon;
	}
	
}