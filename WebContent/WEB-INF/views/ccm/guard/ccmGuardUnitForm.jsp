<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>警卫单位管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
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
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/guard/ccmGuardUnit/securityList">警卫任务</a></li>
		<li class="active"><a href="${ctx}/guard/ccmGuardUnit/">警卫单位列表</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmGuardUnit" action="${ctx}/guard/ccmGuardUnit/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">警卫任务：</label>
			<div class="controls">
				<form:input path="security.title" htmlEscape="false" maxlength="255" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">警卫：</label>
			<div class="controls">
				<sys:treeselect id="user" name="user.id" value="${ccmGuardUnit.user.id}" labelName="user.name" labelValue="${ccmGuardUnit.user.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<!-- 
		<div class="control-group">
			<label class="control-label">车辆：</label>
			<div class="controls">
				<form:input path="patrolVehicles" htmlEscape="false" maxlength="255" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车载设备：</label>
			<div class="controls">
				<form:input path="vehicleEquipment" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		-->
		<div class="control-group">
		<label class="control-label">警卫路线：</label>
		<div class="controls">
			<form:input path="guardLine" htmlEscape="false" disabled="true" maxlength="255" class="input-xlarge "/>
		</div>
		</div>

		<div class="control-group">
			<label class="control-label">时间：</label>
			<div class="controls">
				<input name="departureTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${ccmGuardUnit.departureTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">状态：</label>
			<div class="controls">
				<form:select path="status" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_patrol_missions_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">描述信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="guard:ccmGuardUnit:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>