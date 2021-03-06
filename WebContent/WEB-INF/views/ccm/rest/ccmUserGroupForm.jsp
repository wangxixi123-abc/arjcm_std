<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户好友分组管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					//校验
					if($("#avatarImage").val()==null||$("#avatarImage").val()==""){
						var carId = $("#textName").val();
						var html1 = '<label for="" class="error">请选择图片 *<label>';
						$("#showImage").html(html1);
						return false;
					}else{
						$("#showImage").html("*");
					}
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
		<li><a style="width: 140px;text-align:center" href="${ctx}/rest/ccmUserGroup/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/rest/ccmUserGroup/form?id=${ccmUserGroup.id}">数据<shiro:hasPermission name="rest:ccmUserGroup:edit">${not empty ccmUserGroup.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="rest:ccmUserGroup:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmUserGroup" action="${ctx}/rest/ccmUserGroup/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group" style="padding-top: 8px">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>分组名称：</label>
			<div class="controls">
				<form:input path="groupname" htmlEscape="false" maxlength="64" class="input-xlarge required"/>

			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>群组头像：</label>
			<div class="controls">
				<form:hidden id="avatarImage" path="avatar" htmlEscape="false" maxlength="255" class="input-xlarge required"/>
				<sys:ckfinder input="avatarImage" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"/>
			</div>
		</div>
		
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="rest:ccmUserGroup:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>