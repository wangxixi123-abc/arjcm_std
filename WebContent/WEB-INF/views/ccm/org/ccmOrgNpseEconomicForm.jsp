<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>企业经济运行数据管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				//关闭弹框事件
				$('#btnCancel').click(function() {
					parent.layer.close(parent.layerIndex);
				})
				//$("#name").focus();
				$("#inputForm")
						.validate(
								{
									submitHandler : function(form) {
										$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
										form.submit();
									},
									errorContainer : "#messageBox",
									errorPlacement : function(error, element) {
										$("#btnSubmit").removeAttr('disabled');
					$("#messageBox").text("输入有误，请先更正。");
										if (element.is(":checkbox")
												|| element.is(":radio")
												|| element.parent().is(
														".input-append")) {
											error.appendTo(element.parent()
													.parent());
										} else {
											error.insertAfter(element);
										}
									}
								});
				var flag = "${flag}";
				if (flag != "") {
					top.$.jBox.tip(flag);
					var htmls = '<label for="" class="error">' + flag
							+ '<label>';
					$("#compIdFlag").html(htmls);
				}

			});
	function saveForm() {
		var flag = 0;
		var htmls = '<label for="" class="error">必填信息 *<label>';
		var years = $("#years").val();
		if (years.length != 0) {
			years = years.substring(0, 4);
			years = years + "-01";
			$("#years").val(years);
			$("#yearsFlag").html("*");
			flag += 1;
		} else {
			$("#yearsFlag").html(htmls);
		}

		var html = '<label for="" class="error">数字不能大于等于10,000,000！且不能小于等于-10,000,000！<label>';
		var turnover = $("#turnover").val();
		if (turnover > 9999999.99 || turnover < -9999999.99) {
			flag = false;
			$("#num1").html(html);
		} else {
			$("#num1").html("");
			flag += 1;
		}
		var netMargin = $("#netMargin").val();
		if (netMargin > 9999999.99 || netMargin < -9999999.99) {
			flag = false;
			$("#num2").html(html);
		} else {
			$("#num2").html("");
			flag += 1;
		}
		var taxes = $("#taxes").val();
		if (taxes > 9999999.99 || taxes < -9999999.99) {
			flag = false;
			$("#num3").html(html);
		} else {
			$("#num3").html("");
			flag += 1;
		}
		var fixedAssets = $("#fixedAssets").val();
		if (fixedAssets > 9999999.99 || fixedAssets < -9999999.99) {
			flag = false;
			$("#num4").html(html);
		} else {
			$("#num4").html("");
			flag += 1;
		}
		var liabilities = $("#liabilities").val();
		if (liabilities > 9999999.99 || liabilities < -9999999.99) {
			flag = false;
			$("#num5").html(html);
		} else {
			$("#num5").html("");
			flag += 1;
		}

		if (flag >= 6) {
			$("#inputForm").submit();
		}

	}
</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/org/ccmOrgNpseEconomic/">企业经济运行数据列表</a></li>
		<li class="active"><a href="${ctx}/org/ccmOrgNpseEconomic/form?id=${ccmOrgNpseEconomic.id}">企业经济运行数据<shiro:hasPermission name="org:ccmOrgNpseEconomic:edit">${not empty ccmOrgNpseEconomic.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="org:ccmOrgNpseEconomic:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%>
	<br />
	<form:form id="inputForm" modelAttribute="ccmOrgNpseEconomic"
		action="${ctx}/org/ccmOrgNpseEconomic/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="naspId" />
		<sys:message content="${message}" />
		<%-- <div class="control-group">
			<label class="control-label">企业id：</label>
			<div class="controls">
				<form:input path="naspId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div> --%>
		<c:if test="${empty ccmOrgNpseEconomic.id}">
			<div class="control-group" >
				<label class="control-label"><span class="help-inline"><font color="red">*</font></span>工商执照注册号：</label>
				<div class="controls">
					<form:input path="compId" htmlEscape="false" maxlength="64"
						class="input-xlarge required" />
				</div>
			</div>
		</c:if>
		<c:if test="${not empty ccmOrgNpseEconomic.id}">
			<div class="control-group">
				<label class="control-label"><span class="help-inline"><font color="red">*</font></span>工商执照注册号：</label>
				<div class="controls">${ccmOrgNpseEconomic.compId}</div>
			</div>

			<div class="control-group">
				<label class="control-label">名称：</label>
				<div class="controls">${ccmOrgNpseEconomic.compName}</div>
			</div>
		</c:if>

		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red" id="yearsFlag">*</font></span>年：</label>
			<div class="controls">
				<input name="years" type="text" readonly="readonly" maxlength="20"
					class="input-medium Wdate" id="years"
					value="<fmt:formatDate value="${ccmOrgNpseEconomic.years}" pattern="yyyy"/>"
					onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">营业额（万元）：</label>
			<div class="controls">
				<form:input path="turnover" htmlEscape="false"
					class="input-xlarge  number" maxlength="11" />
				<font color="red" id="num1"></font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">净利润（万元）：</label>
			<div class="controls">
				<form:input path="netMargin" htmlEscape="false"
					class="input-xlarge  number" maxlength="11" />
				<font color="red" id="num2"></font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">纳税总额（万元）：</label>
			<div class="controls">
				<form:input path="taxes" htmlEscape="false"
					class="input-xlarge  number" maxlength="11" />
				<font color="red" id="num3"></font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">固定资产总额（万元）：</label>
			<div class="controls">
				<form:input path="fixedAssets" htmlEscape="false"
					class="input-xlarge  number" maxlength="11" />
				<font color="red" id="num4"></font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">负债（万元）：</label>
			<div class="controls">
				<form:input path="liabilities" htmlEscape="false"
					class="input-xlarge  number" maxlength="11" />
				<font color="red" id="num5"></font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4"
					maxlength="255" class="input-xxlarge " />
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="org:ccmOrgNpseEconomic:edit">
				<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()"
					type="button" value="保 存" />&nbsp;
			<input id="btnCancel" class="btn btn-danger" type="button" value="关闭" />
			</shiro:hasPermission>
		</div>
	</form:form>
</body>
</html>