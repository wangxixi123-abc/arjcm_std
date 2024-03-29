<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经济运行数据-月管理</title>
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
		<li><a href="${ctx}/know/ccmEconomicsMonth/">数据列表</a></li>
		<li class="active"><a href="${ctx}/know/ccmEconomicsMonth/form?id=${ccmEconomicsMonth.id}">数据<shiro:hasPermission name="know:ccmEconomicsMonth:edit">${not empty ccmEconomicsMonth.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="know:ccmEconomicsMonth:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmEconomicsMonth" action="${ctx}/know/ccmEconomicsMonth/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">年月：</label>
			<div class="controls">
				<input name="months" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
					value="<fmt:formatDate value="${ccmEconomicsMonth.months}" pattern="yyyy-MM"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">本年累计生产总值（亿元）：</label>
			<div class="controls">
				<form:input path="gdp" htmlEscape="false" class="input-xlarge  number" maxlength="7"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">失业率：</label>
			<div class="controls">
				<form:input path="unemploymentRate" htmlEscape="false" maxlength="10" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">利率：</label>
			<div class="controls">
				<form:input path="interestRate" htmlEscape="false" maxlength="10" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">生产物价指数（PPI）：</label>
			<div class="controls">
				<form:input path="ppi" htmlEscape="false" maxlength="10" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">消费物价指数（CPI）：</label>
			<div class="controls">
				<form:input path="cpi" htmlEscape="false" maxlength="10" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">人均可支配收入（元）：</label>
			<div class="controls">
				<form:input path="personalIncome" htmlEscape="false" maxlength="10" class="input-xlarge  digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">税收（万元）：</label>
			<div class="controls">
				<form:input path="revenue" htmlEscape="false" maxlength="8" class="input-xlarge  digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="know:ccmEconomicsMonth:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>