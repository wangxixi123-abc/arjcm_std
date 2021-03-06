<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>重大事项审核管理</title>
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
		<li><a href="${ctx}/audit/riskAudit/">重大事项审核列表</a></li>
		<li class="active"><a href="${ctx}/audit/riskAudit/form?id=${riskAudit.id}">重大事项审核<shiro:hasPermission name="audit:riskAudit:edit">${not empty riskAudit.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="audit:riskAudit:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="riskAudit" action="" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">报告名称：</label>
			<div class="controls">${riskAudit.riskReport.fileName}
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">事项评估报告：</label>
			<div class="controls">
				<form:hidden id="file" path="file" htmlEscape="false" maxlength="256" class="input-xlarge"/>
				<sys:ckfinder input="file" type="files" uploadPath="/report/riskReport" selectMultiple="true" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所属重大事项：</label>
			<div class="controls">${riskAudit.riskReport.riskEventGreat.name}
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">审核人：</label>
			<div class="controls">${riskAudit.user.name}
			</div>
		</div>
	
	</form:form>
	<form:form id="inputForm2" modelAttribute="riskAudit" action="${ctx}/audit/riskAudit/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<div class="control-group">
			<label class="control-label">审核意见：</label>
			<div class="controls">
				<form:textarea path="opinion" htmlEscape="false" rows="12" maxlength="1000" class="input-xxlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">审核结果：</label>
			<div class="controls">
				<form:select path="result" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_service_online_handle')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
			<shiro:hasPermission name="audit:riskAudit:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<a class="btn" href="${ctx}/audit/riskAudit/" onclick="return  this.href">返 回</a> 
		</div>
	</form:form>
</body>
</html>