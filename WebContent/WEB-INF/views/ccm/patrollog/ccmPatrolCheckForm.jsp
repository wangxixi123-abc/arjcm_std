<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>巡检考评管理</title>
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
		<li><a style="width: 140px;text-align:center" href="${ctx}/patrollog/ccmPatrolCheck/">巡检考评列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/patrollog/ccmPatrolCheck/form?id=${ccmPatrolCheck.id}">巡检考评<shiro:hasPermission name="patrollog:ccmPatrolCheck:edit">${not empty ccmPatrolCheck.id?'评分':'添加'}</shiro:hasPermission><shiro:lacksPermission name="patrollog:ccmPatrolCheck:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmPatrolCheck" action="${ctx}/patrollog/ccmPatrolCheck/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<div class="control-group" style="padding-top: 10px">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>巡检内容：</label>
			<div class="controls">
				<form:textarea path="patrolContent" htmlEscape="false" rows="4" maxlength="2000" class="input-xxlarge required" disabled="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">路段：</label>
			<div class="controls">
				<form:input path="reportRoad" htmlEscape="false" maxlength="255" class="input-xlarge " disabled="true"/>
			</div>
		</div>	
		<div class="control-group">
			<label class="control-label">考评人：</label>
			<div class="controls">
				<form:input path="checkPerson" htmlEscape="false" maxlength="15" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">考评时间：</label>
			<div class="controls">
				<input name="checkDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${ccmPatrolCheck.checkDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">分数：</label>
			<div class="controls">
				<form:input path="score" htmlEscape="false" maxlength="255" class="input-xlarge number"/>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div> --%>
		<div class="form-actions">
			<shiro:hasPermission name="patrollog:ccmPatrolCheck:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>