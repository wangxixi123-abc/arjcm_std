package com.arjjs.ccm.modules.ccm.rest.entity;

import com.alibaba.fastjson.annotation.JSONField;

public class AlarmHandleUserStatus {

    private String logId; //日志ID
    private String handleId; //处警ID
    @JSONField(format="yyyy-MM-dd HH:mm:ss")
    private String createDate; //日志创建时间
    private String operateDesc;//操作记录
    private String useId;  //用户ID
    private String useName; //用户名称
    private String mobile;   //用户电话
    private String officeId; //部门ID
    private String officeName;//部门名称
    private String status;//警情状态 1：任务签收 2：到达现场 3：任务反馈
    public String getLogId() {
        return logId;
    }

    public void setLogId(String logId) {
        this.logId = logId;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public String getOperateDesc() {
        return operateDesc;
    }

    public void setOperateDesc(String operateDesc) {
        this.operateDesc = operateDesc;
    }

    public String getUseId() {
        return useId;
    }

    public void setUseId(String useId) {
        this.useId = useId;
    }

    public String getUseName() {
        return useName;
    }

    public void setUseName(String useName) {
        this.useName = useName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getOfficeId() {
        return officeId;
    }

    public void setOfficeId(String officeId) {
        this.officeId = officeId;
    }

    public String getOfficeName() {
        return officeName;
    }

    public void setOfficeName(String officeName) {
        this.officeName = officeName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getHandleId() {
        return handleId;
    }

    public void setHandleId(String handleId) {
        this.handleId = handleId;
    }
}
