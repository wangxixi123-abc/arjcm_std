<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>App 上传记录表管理</title>
	<meta name="decorator" content="default"/>
	<%--引入文本框外部样式--%>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
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
</head>

<body>
<ul class="nav nav-tabs">
	<li><a style="width: 140px;text-align:center" href="${ctx}/appupload/sysAppUpload/">数据列表</a></li>
	<li class="active" style="width: 150px"><a class="nav-head" href="${ctx}/appupload/sysAppUpload/form?id=${sysAppUpload.id}">数据<shiro:hasPermission name="appupload:sysAppUpload:edit">${not empty sysAppUpload.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="appupload:sysAppUpload:edit">查看</shiro:lacksPermission></a></li>
	</ul>
<form:form id="inputForm" modelAttribute="sysAppUpload" action="${ctx}/appupload/sysAppUpload/save" method="post" class="form-horizontal">
	<form:hidden path="id"/>
	<sys:message content="${message}"/>
		<div class="control-group head_Space">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>APP名称：</label>
		<div class="controls">
				<form:input  path="name" htmlEscape="false" maxlength="40" class="input-xlarge required"/>
		</div>
	</div>
	<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>类别：</label>
		<div class="controls">
				<form:select  path="type"  class="input-xlarge required">
				<form:option value="" label=""/>
					<form:options items="${fns:getDictList('app_os_type')}" itemLabel="label" itemValue="value"  htmlEscape="false"/>
			</form:select>
		</div>
	</div>
	<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>版本号：</label>
		<div class="controls">
				<form:input path="version" htmlEscape="false" type="number" maxlength="10" class="input-xlarge required"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">备注信息：</label>
		<div class="controls">
			<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">附件：</label>
		<div class="controls">
			<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class="input-xlarge"/>
			<sys:ckfinder input="files" type="files" uploadPath="/appupload/sysAppUpload" selectMultiple="true"/>
		</div>
	</div>
	<div class="form-actions">
		<shiro:hasPermission name="appupload:sysAppUpload:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
		<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
	</div>
</form:form>
</body>
</html>