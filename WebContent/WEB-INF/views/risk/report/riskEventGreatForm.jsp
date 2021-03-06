<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>重大事项报备管理</title>
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
		function saveList(){
			$("#inputForm").attr("action","${ctx}/report/riskEventGreat/saveList");
			$("#inputForm").submit();
		}
		
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/report/riskEventGreat/">重大事项报备列表</a></li>
		<li class="active"><a href="${ctx}/report/riskEventGreat/form?id=${riskEventGreat.id}">重大事项报备<shiro:hasPermission name="report:riskEventGreat:edit">${not empty riskEventGreat.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="report:riskEventGreat:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="riskEventGreat" action="${ctx}/report/riskEventGreat/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">事项名称：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">报告单位：</label>
			<div class="controls">
				<form:input path="department" htmlEscape="false" maxlength="20" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">责任人：</label>
			<div class="controls">
				<form:input path="respName" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">事项描述：</label>
			<div class="controls">
				<form:textarea path="description" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">可能造成的影响：</label>
			<div class="controls">
				<form:textarea path="influence" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">处理结果：</label>
			<div class="controls">
				<form:textarea path="process" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
			</div>
		</div>
		<!--  
		<div class="control-group">
			<label class="control-label">是否入库：</label>
			<div class="controls">
				<form:select path="isReserve" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>-->
		<div class="control-group">
			<label class="control-label">附件：</label>
			<div class="controls">
				<form:hidden id="file" path="file" htmlEscape="false" maxlength="256" class="input-xlarge"/>
				<sys:ckfinder input="file" type="files" uploadPath="/report/riskEventGreat" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="report:riskEventGreat:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<!--  
			<shiro:hasPermission name="report:riskEventGreat:edit"><input id="" class="btn btn-success" onclick="saveList()" type="button" value="入库"/>&nbsp;</shiro:hasPermission>
			-->
			<c:if test="${not empty riskEventGreat.id}">
				<a class="btn btn-success" href="${ctx}/report/riskEventGreat/saveList?id=${riskEventGreat.id}" onclick="return confirmx('确认要将该重大事项报备入库吗？', this.href)">入库</a> 
			</c:if>
			<!--<a class="btn btn-success" href="${ctx}/report/riskEventGreat/saveList?id=${riskEventGreat.id}" title="添加记录">入库</a>  -->
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>