<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>道德模范表管理</title>
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
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/moral/ccmMoral/">数据列表</a></li>
		<li class="active"><a href="${ctx}/moral/ccmMoral/form?id=${ccmMoral.id}">数据<shiro:hasPermission name="moral:ccmMoral:edit">${not empty ccmMoral.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="moral:ccmMoral:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmMoral" action="${ctx}/moral/ccmMoral/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">模范标题：</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" maxlength="255" class="input-xlarge required"/>
				<span class="help-inline"><font color="red" >*</font></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">名字：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red" >*</font></span>
			</div>

		</div>
		<div class="control-group">
			<label class="control-label">头像：</label>
			<div class="controls">
				<form:hidden id="headPhoto" path="headPhoto" htmlEscape="false" maxlength="64" class="input-xlarge"/>
				<sys:ckfinder input="headPhoto" type="files" uploadPath="/moral/ccmMoral" selectMultiple="false"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">内容：</label>
			<div class="controls">
				<form:textarea path="content" htmlEscape="false" rows="4" maxlength="1024" class="input-xxlarge required"/>
				<span class="help-inline"><font color="red" >*</font></span>
			</div>
		</div>

		<div class="form-actions">
			<shiro:hasPermission name="moral:ccmMoral:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>