/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.event.entity;

import com.arjjs.ccm.common.persistence.DataEntity;
import com.arjjs.ccm.modules.ccm.line.entity.CcmLineProtect;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.Past;
import java.util.Date;

/**
 * 案事件登记Entity
 * @author arj
 * @version 2018-01-10
 */
public class CcmEventIncident extends DataEntity<CcmEventIncident> {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1344241916663884564L;
	
	@NotEmpty(message = "案（事）件名称不能为空")
	private String caseName;		// 案事件名称
	@Past(message = "发生日期必须是一个过去事件")
	private Date happenDate;		// 发生日期
	private String casePlace; // 发案地
	private String placeId; // 场所id
	private String eventId; // 事件id
	private String deleteType; // 是否删除之前的关联
	private String caseAreaPlace; // 案发地社区
	private Area area;  // 发案地
    private String address;		// 发生地代码
    private String happenPlace;		// 发生地详址
	private String areaMap;		// 区域图
	private String areaPoint;		// 中心点
	private String image;		// 图标
	@NotEmpty(message = "案（事）件种类不能为空")
	private String eventKind;		// 案（事）件种类
	private String otherId;		// 种类详细信息
	private CcmLineProtect line;	// 种类详细信息类
	@NotEmpty(message = "案（事）件分级不能为空")
	private String eventScale;		// 案（事）件分级
	@NotEmpty(message = "案（事）件类型不能为空")
	private String eventType;		// 案（事）件类型
	private String number;		// 案事件编号
	@NotEmpty(message = "案（事）件性质不能为空")
	private String property;		// 案事件性质
	private String caseCondition;		// 案事件情况
	private String culPapercode;		// 主犯（嫌疑人)证件代码
	private String culPaperid;		// 主犯（嫌疑人)证件号码
	private String culName;		// 主犯（嫌疑人）姓名
	private Integer typeSolve;		// 是否破案
	private Integer numCrime;		// 作案人数
	private Integer numFlee;		// 在逃人数
	private Integer numArrest;		// 抓捕人数
	private Date caseOverDay;		// 侦查终结日期
	private String caseSolve;		// 事件上报人评价
	private String file1;		// 附件1
	private String file2;		// 附件2
	private String file3;		// 附件3
	private Date beginHappenDate;		// 开始 发生日期
	private Date endHappenDate;		// 结束 发生日期
	private String createName;
	private String status;		// 处理状态
	private String statusLable;	//用于app接口列表显示

	private String peopleName;		// 重点人员姓名

	private User checkUser;		// 拦截器中使用该用户进行权限拦截，App的rest接口使用
    private Area userArea;  //登录用户所在区域
	private String count;
	
	

	private String[] eventKindParents;		// 事件类别（多选，事件分析时使用）
	private String num;                     // 区域内警情数量
	
	private String ratify;		//是否批示
	private String stick;		//是否置顶
	private String urgent;		//是否加急
	private String historyLegacy;		//是否历史遗留
	private String[] ids;
	private String eventSort;//事件类别
	private String caseScope;//事件规模
	private String reportType; // 上报类型
	
	private String cameraCode; // 摄像机编号 pengjianqiang 20190317 安顺雪亮，与海康机顶盒对接
	private String alarmPeopleId; // 报警人id
	private String alarmPeopleName; // 报警人姓名
	private String alarmPeopleTel; // 报警人联系电话
	private String alarmTvSn; // 报警机顶盒sn
	private String collectType; // 数据来源 0平台采集；1APP采集；2微信采集；3电视机采集；4人脸对接
	
	private String reportPerson; // 上报人姓名
	private String reportPersonPhone; // 上报人联系电话
	
	private String whatType; //上报渠道
	private String[] eventTypes; // 部件类型数组

	private String bphAlarmInfoId;//警情id
	private String isDispatch; //从任务指派页面进入
	private String doing; //案件是否已经分配处理
	
	private String handleStep; //处理措施
	public String getHandleStep() {
		return handleStep;
	}

	public void setHandleStep(String handleStep) {
		this.handleStep = handleStep;
	}

	public String getEventId() {
		return eventId;
	}

	public void setEventId(String eventId) {
		this.eventId = eventId;
	}

	public String getDeleteType() {
		return deleteType;
	}

	public void setDeleteType(String deleteType) {
		this.deleteType = deleteType;
	}

	public String getPlaceId() {
		return placeId;
	}

	public void setPlaceId(String placeId) {
		this.placeId = placeId;
	}

	public String[] getEventTypes() {
		return eventTypes;
	}

	public void setEventTypes(String[] eventTypes) {
		this.eventTypes = eventTypes;
	}

	public String getWhatType() {
		return whatType;
	}

	public void setWhatType(String whatType) {
		this.whatType = whatType;
	}

	public String getReportPerson() {
		return reportPerson;
	}

	public void setReportPerson(String reportPerson) {
		this.reportPerson = reportPerson;
	}

	public String getReportPersonPhone() {
		return reportPersonPhone;
	}

	public void setReportPersonPhone(String reportPersonPhone) {
		this.reportPersonPhone = reportPersonPhone;
	}

	public String getCameraCode() {
		return cameraCode;
	}

	public void setCameraCode(String cameraCode) {
		this.cameraCode = cameraCode;
	}

	public String getAlarmPeopleId() {
		return alarmPeopleId;
	}

	public void setAlarmPeopleId(String alarmPeopleId) {
		this.alarmPeopleId = alarmPeopleId;
	}

	public String getAlarmPeopleName() {
		return alarmPeopleName;
	}

	public void setAlarmPeopleName(String alarmPeopleName) {
		this.alarmPeopleName = alarmPeopleName;
	}

	public String getAlarmPeopleTel() {
		return alarmPeopleTel;
	}

	public void setAlarmPeopleTel(String alarmPeopleTel) {
		this.alarmPeopleTel = alarmPeopleTel;
	}

	public String getAlarmTvSn() {
		return alarmTvSn;
	}

	public void setAlarmTvSn(String alarmTvSn) {
		this.alarmTvSn = alarmTvSn;
	}

	public String getCollectType() {
		return collectType;
	}

	public void setCollectType(String collectType) {
		this.collectType = collectType;
	}

	public String[] getIds() {
		return ids;
	}

	public void setIds(String[] ids) {
		this.ids = ids;
	}

	public String getReportType() {
		return reportType;
	}

	public void setReportType(String reportType) {
		this.reportType = reportType;
	}

	public String getCaseAreaPlace() {
		return caseAreaPlace;
	}

	public void setCaseAreaPlace(String caseAreaPlace) {
		this.caseAreaPlace = caseAreaPlace;
	}

	public String getRatify() {
		return ratify;
	}

	public void setRatify(String ratify) {
		this.ratify = ratify;
	}

	public String getStick() {
		return stick;
	}

	public void setStick(String stick) {
		this.stick = stick;
	}

	public String getUrgent() {
		return urgent;
	}

	public void setUrgent(String urgent) {
		this.urgent = urgent;
	}

	public String getHistoryLegacy() {
		return historyLegacy;
	}

	public void setHistoryLegacy(String historyLegacy) {
		this.historyLegacy = historyLegacy;
	}

	public String[] getEventKindParents() {
		return eventKindParents;
	}

	public void setEventKindParents(String[] eventKindParents) {
		this.eventKindParents = eventKindParents;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public Area getUserArea() {
		return userArea;
	}

	public void setUserArea(Area userArea) {
		this.userArea = userArea;
	}
	
	
	public User getCheckUser() {
		return checkUser;
	}
	public void setCheckUser(User checkUser) {
		this.checkUser = checkUser;
	}

	public CcmEventIncident() {
		super();
	}

	public CcmEventIncident(String id){
		super(id);
	}

	public String getPeopleName() {
		return peopleName;
	}
	public void setPeopleName(String peopleName) {
		this.peopleName = peopleName;
	}
	@Length(min=0, max=100, message="案事件名称长度必须介于 0 和 100 之间")
	public String getCaseName() {
		return caseName;
	}

	public void setCaseName(String caseName) {
		this.caseName = caseName;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getHappenDate() {
		return happenDate;
	}

	public void setHappenDate(Date happenDate) {
		this.happenDate = happenDate;
	}
	
	
	@Length(min=0, max=6, message="发案地长度必须介于 0 和 6 之间")
	public String getCasePlace() {
		return casePlace;
	}

	public void setCasePlace(String casePlace) {
		this.casePlace = casePlace;
	}
	
	@Length(min=0, max=200, message="发生地详址长度必须介于 0 和 200 之间")
	public String getHappenPlace() {
		return happenPlace;
	}

	public void setHappenPlace(String happenPlace) {
		this.happenPlace = happenPlace;
	}
	
	@Length(min=0, max=2000, message="区域图长度必须介于 0 和 2000 之间")
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
	
	@Length(min=0, max=64, message="种类详细信息长度必须介于 0 和 64 之间")
	public String getOtherId() {
		return otherId;
	}

	public void setOtherId(String otherId) {
		this.otherId = otherId;
	}
	
	public CcmLineProtect getLine() {
		return line;
	}
	public void setLine(CcmLineProtect line) {
		this.line = line;
	}
	@Length(min=0, max=2, message="案（事）件种类长度必须介于 0 和 2 之间")
	public String getEventKind() {
		return eventKind;
	}

	public void setEventKind(String eventKind) {
		this.eventKind = eventKind;
	}
	
	@Length(min=0, max=2, message="案（事）件分级长度必须介于 0 和 2 之间")
	public String getEventScale() {
		return eventScale;
	}

	public void setEventScale(String eventScale) {
		this.eventScale = eventScale;
	}
	
	@Length(min=0, max=2, message="案（事）件类型长度必须介于 0 和 2 之间")
	public String getEventType() {
		return eventType;
	}

	public void setEventType(String eventType) {
		this.eventType = eventType;
	}
	
	@Length(min=0, max=100, message="案事件编号长度必须介于 0 和 100 之间")
	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}
	
	@Length(min=0, max=2, message="案事件性质长度必须介于 0 和 2 之间")
	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}
	
	public String getCaseCondition() {
		return caseCondition;
	}

	public void setCaseCondition(String caseCondition) {
		this.caseCondition = caseCondition;
	}
	
	@Length(min=0, max=3, message="主犯（嫌疑人)证件代码长度必须介于 0 和 3 之间")
	public String getCulPapercode() {
		return culPapercode;
	}

	public void setCulPapercode(String culPapercode) {
		this.culPapercode = culPapercode;
	}
	
	@Length(min=0, max=50, message="主犯（嫌疑人)证件号码长度必须介于 0 和 50 之间")
	public String getCulPaperid() {
		return culPaperid;
	}

	public void setCulPaperid(String culPaperid) {
		this.culPaperid = culPaperid;
	}
	
	@Length(min=0, max=80, message="主犯（嫌疑人）姓名长度必须介于 0 和 80 之间")
	public String getCulName() {
		return culName;
	}

	public void setCulName(String culName) {
		this.culName = culName;
	}
	
	public Integer getTypeSolve() {
		return typeSolve;
	}

	public void setTypeSolve(Integer typeSolve) {
		this.typeSolve = typeSolve;
	}
	
	public Integer getNumCrime() {
		return numCrime;
	}

	public void setNumCrime(Integer numCrime) {
		this.numCrime = numCrime;
	}
	
	public Integer getNumFlee() {
		return numFlee;
	}

	public void setNumFlee(Integer numFlee) {
		this.numFlee = numFlee;
	}
	
	public Integer getNumArrest() {
		return numArrest;
	}

	public void setNumArrest(Integer numArrest) {
		this.numArrest = numArrest;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getCaseOverDay() {
		return caseOverDay;
	}

	public void setCaseOverDay(Date caseOverDay) {
		this.caseOverDay = caseOverDay;
	}
	
	public String getCaseSolve() {
		return caseSolve;
	}

	public void setCaseSolve(String caseSolve) {
		this.caseSolve = caseSolve;
	}
	
	public Date getBeginHappenDate() {
		return beginHappenDate;
	}

	public void setBeginHappenDate(Date beginHappenDate) {
		this.beginHappenDate = beginHappenDate;
	}
	
	public Date getEndHappenDate() {
		return endHappenDate;
	}

	public void setEndHappenDate(Date endHappenDate) {
		this.endHappenDate = endHappenDate;
	}

	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}
	
	public Area getArea() {
        return area;
    }

    public void setArea(Area area) {
        this.area = area;
    }
    @Length(min=0, max=256, message="附件1长度必须介于 0 和 256 之间")
	public String getFile1() {
		return file1;
	}

	public void setFile1(String file1) {
		this.file1 = file1;
	}
	
	@Length(min=0, max=256, message="附件2长度必须介于 0 和 256 之间")
	public String getFile2() {
		return file2;
	}

	public void setFile2(String file2) {
		this.file2 = file2;
	}
	
	@Length(min=0, max=256, message="附件3长度必须介于 0 和 256 之间")
	public String getFile3() {
		return file3;
	}

	public void setFile3(String file3) {
		this.file3 = file3;
	}	
	@Length(min=0, max=2, message="处理状态必须介于 0 和 2 之间")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatusLable() {
		return statusLable;
	}
	public void setStatusLable(String statusLable) {
		this.statusLable = statusLable;
	}

	@Length(min=0, max=6, message="发案地代码长度必须介于 0 和 6 之间")
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}

	@Length(min = 0, max = 64, message = "事件类别长度必须介于 0 和 64 之间")
	public String getEventSort() {
		return eventSort;
	}

	public void setEventSort(String eventSort) {
		this.eventSort = eventSort;
	}

	@Length(min = 0, max = 64, message = "事件规模长度必须介于 1 和 64 之间")
	public String getCaseScope() {
		return caseScope;
	}

	public void setCaseScope(String caseScope) {
		this.caseScope = caseScope;
	}

	public String getBphAlarmInfoId() {
		return bphAlarmInfoId;
	}

	public void setBphAlarmInfoId(String bphAlarmInfoId) {
		this.bphAlarmInfoId = bphAlarmInfoId;
	}

	public String getIsDispatch() {
		return isDispatch;
	}

	public void setIsDispatch(String isDispatch) {
		this.isDispatch = isDispatch;
	}

	public String getDoing() {
		return doing;
	}

	public void setDoing(String doing) {
		this.doing = doing;
	}
}