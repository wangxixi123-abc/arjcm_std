<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学员表关系管理</title>
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
		<li><a href="${ctx}/person/pbsPartymembind/">学员用户关系列表</a></li>
		<li class="active"><a href="${ctx}/person/pbsPartymembind/form?id=${pbsPartymembind.id}">学员用户关系<shiro:hasPermission name="person:pbsPartymembind:edit">${not empty pbsPartymembind.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="person:pbsPartymembind:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="pbsPartymembind" action="${ctx}/person/pbsPartymembind/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="sType" value="user"/>
		<form:hidden path="sSource" value="sys_user"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">学员的主键信息：</label>
			<div class="controls">
				<form:input path="sPartymemid" htmlEscape="false" maxlength="30" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">选择用户：</label>
			<div class="controls">
				<sys:treeselect id="sPrimarykey02" name="sPrimarykey02"
                    value="${pbsPartymembind.SPrimarykey02}" labelName="sPrimarykey03"
                    labelValue="${pbsPartymembind.SPrimarykey03}" title="用户"
                    url="/sys/office/treeData?type=3" cssClass="input-small"
                    allowClear="true" />
				
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">选择学员：</label>
			<div class="controls">
				<form:input path="sPartymemid" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		 
		<div class="form-actions">
			<shiro:hasPermission name="person:pbsPartymembind:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>