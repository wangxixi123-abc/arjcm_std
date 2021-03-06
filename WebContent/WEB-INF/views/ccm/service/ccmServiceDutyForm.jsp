<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工作职责管理</title>
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
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/service/ccmServiceDuty/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/service/ccmServiceDuty/form?id=${ccmServiceDuty.id}">数据<shiro:hasPermission name="service:ccmServiceDuty:edit">${not empty ccmServiceDuty.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="service:ccmServiceDuty:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmServiceDuty" action="${ctx}/service/ccmServiceDuty/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table>
			<tr>
				<td>
					<div class="control-group" style="padding-top: 8px">
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>岗位名称：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge required"/>

						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">岗位编号：</label>
						<div class="controls">
							<form:input path="code" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">所在部门：</label>
						<div class="controls">
							<form:input path="department" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">主管领导：</label>
						<div class="controls">
							<form:input path="chief" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">岗位概要：</label>
						<div class="controls">
							<form:textarea path="summary" htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">岗位职责：</label>
						<div class="controls">
							<form:textarea path="duty" htmlEscape="false" rows="8" maxlength="512" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">知识技能要求：</label>
						<div class="controls">
							<form:textarea path="skill" htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">个人素质要求：</label>
						<div class="controls">
							<form:textarea path="quality" htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
						</div>
					</div>
				</td>
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="service:ccmServiceDuty:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>