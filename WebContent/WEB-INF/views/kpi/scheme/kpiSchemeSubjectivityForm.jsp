<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效主观评分管理</title>
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
		<li><a href="${ctx}/scheme/kpiSchemeSubjectivity/">数据列表</a></li>
		<li class="active"><a href="${ctx}/scheme/kpiSchemeSubjectivity/form?id=${kpiSchemeSubjectivity.id}">数据<shiro:hasPermission name="scheme:kpiSchemeSubjectivity:edit">${not empty kpiSchemeSubjectivity.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="scheme:kpiSchemeSubjectivity:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="kpiSchemeSubjectivity" action="${ctx}/scheme/kpiSchemeSubjectivity/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">被考核人：</label>
			<div class="controls">
				<sys:treeselect id="userId" name="userId.id" value="${kpiSchemeSubjectivity.userId.id}" labelName="userId.name" labelValue="${kpiSchemeSubjectivity.userId.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">评分人：</label>
			<div class="controls">
				<sys:treeselect id="scorerId" name="scorerId.id" value="${kpiSchemeSubjectivity.scorerId.id}" labelName="scorerId.name" labelValue="${kpiSchemeSubjectivity.scorerId.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">KPI编号：</label>
			<div class="controls">
				<form:input path="kpiId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权重：</label>
			<div class="controls">
				<form:input path="weight" htmlEscape="false" class="input-xlarge  number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="scheme:kpiSchemeSubjectivity:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>