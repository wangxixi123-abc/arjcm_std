<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>历史租客记录管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#btnSubmit").removeAttr('disabled');
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/tenant/ccmTenantRecord/">历史租客记录列表</a></li>
		<li class="active"><a href="${ctx}/tenant/ccmTenantRecord/form?id=${ccmTenantRecord.id}">历史租客记录<shiro:hasPermission name="tenant:ccmTenantRecord:edit">${not empty ccmTenantRecord.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="tenant:ccmTenantRecord:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%>
	<form:form id="inputForm" modelAttribute="ccmTenantRecord" action="${ctx}/tenant/ccmTenantRecord/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group" style="padding-top: 8px">
			<label class="control-label">姓名：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge" value="${ccmTenantRecord.name}"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">电话号码：</label>
			<div class="controls">
				<form:input path="phoneNumber" htmlEscape="false" maxlength="64" class="input-xlarge " value="${ccmTenantRecord.phoneNumber}"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">身份证号码：</label>
			<div class="controls">
				<form:input path="idCard" htmlEscape="false" maxlength="64" class="input-xlarge " value="${ccmTenantRecord.idCard}"/>
			</div>
		</div>
		<div class="control-group" style="display: none;">
			<label class="control-label">房屋id：</label>
			<div class="controls">
				<form:input path="houseId" htmlEscape="false" maxlength="64" class="input-xlarge " value="${ccmTenantRecord.houseId}"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font></span>入住时间：</label>
			<div class="controls">
			<input name="liveDate" id="liveDate" type="text"  maxlength="20" class="input-medium Wdate  required"
					value="<fmt:formatDate value="${ccmTenantRecord.liveDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({maxDate: '#F{$dp.$D(\'leaveDate\')}',dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font></span>离开时间：</label>
			<div class="controls">
			<input name="leaveDate" id="leaveDate" type="text"  maxlength="20" class="input-medium Wdate  required"
					value="<fmt:formatDate value="${ccmTenantRecord.leaveDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({minDate:'#F{$dp.$D(\'liveDate\')}',dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

			</div> 
		</div>
		
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
		<shiro:hasPermission name="tenant:ccmTenantRecord:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
		</div>
	</form:form>
</body>
</html>