package com.arjjs.ccm.modules.ccm.rest.entity;

import io.swagger.annotations.ApiModelProperty;
import org.hibernate.validator.constraints.NotBlank;

public class CcmEntityUser {

    @NotBlank(message = "当前登陆人ID不能为空")
    @ApiModelProperty(value = "当前登陆人ID")
    private String  userId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
