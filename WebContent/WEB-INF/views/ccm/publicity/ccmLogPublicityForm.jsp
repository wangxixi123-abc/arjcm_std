<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>宣传信息管理</title>
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
		<li><a style="width: 140px;text-align:center" href="${ctx}/publicity/ccmLogPublicity/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head"href="${ctx}/publicity/ccmLogPublicity/form?id=${ccmLogPublicity.id}">数据<shiro:hasPermission name="publicity:ccmLogPublicity:edit">${not empty ccmLogPublicity.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="publicity:ccmLogPublicity:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmLogPublicity" action="${ctx}/publicity/ccmLogPublicity/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group" style="padding-top: 8px">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>标题：</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" maxlength="200" class="input-xlarge required"/>

			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>内容：</label>
			<div class="controls">
				<form:textarea path="content" htmlEscape="false" rows="4" maxlength="2000" class="input-xxlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>类型：</label>
			<div class="controls">
				<form:select path="type" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_log_publiciy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">附件：</label>
			<div class="controls">
				<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class="input-xlarge"/>
				<sys:ckfinder input="files" type="files" uploadPath="/publicity/ccmLogPublicity" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>状态：</label>
			<div class="controls">
				<form:select path="status" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_log_publiciy_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<c:if test="${user.id eq ccmLogPublicity.createBy.id or user.id eq '1' or ccmLogPublicity.createBy==null}">
				<shiro:hasPermission name="publicity:ccmLogPublicity:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>