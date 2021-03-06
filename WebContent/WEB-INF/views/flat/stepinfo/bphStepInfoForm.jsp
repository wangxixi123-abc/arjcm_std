<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>预案过程管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
<script src="${ctxStatic}/common/alarm.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#stepName").on("input",function(e){
				var stepName = e.delegateTarget.value;
				if(stepName == "" || stepName == null || stepName === undefined){
					$("#nameLabel").hide();
					$("#nameLabel").html("");
					return;
				}
				var oldStepName = $("#oldStepName").val();
				if(stepName == oldStepName){
					$("#nameLabel").hide();
					$("#nameLabel").html("");
					return;
				}
				$.post("${ctx}/stepinfo/bphStepInfo/checkStepName",{'stepName':stepName},function(data) {
					if(data == "false"){
						$("#nameLabel").show();
						$("#nameLabel").html("该过程名已存在，请重新输入。");
					}else if(data == "true"){
						$("#nameLabel").hide();
						$("#nameLabel").html("");
					}
				});
			});
			$("#btnSubmit").click(function(){
				var nameLabel = $("#nameLabel").text();
				if(nameLabel != null && nameLabel != "" && nameLabel !== undefined){
					return;
				}
				$("#inputForm").submit();
			});
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
	<%--引入文本框外部样式--%>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/stepinfo/bphStepInfo/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/stepinfo/bphStepInfo/form?id=${bphStepInfo.id}">数据<shiro:hasPermission name="stepinfo:bphStepInfo:edit">${not empty bphStepInfo.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="stepinfo:bphStepInfo:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="bphStepInfo" action="${ctx}/stepinfo/bphStepInfo/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group head_Space" >
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>过程名称：</label>
			<div class="controls">
				<input id="oldStepName" name="oldStepName" type="hidden" value="${bphStepInfo.name}">
				<form:input path="name" htmlEscape="false" maxlength="80" class="input-xlarge required" id="stepName"/>
				<label class="error" id="nameLabel" style="display:none;"></label>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">过程描述：</label>
			<div class="controls">
				<form:textarea path="content" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="stepinfo:bphStepInfo:edit">
		<!-- 	<input id="btnSubmit" class="btn btn-primary" type="button" value="保存"/> -->
		<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i ></i>保 存</a>
			&nbsp;</shiro:hasPermission>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/> -->
			<a id="btnCancel" class="btn btn-back" href="javascript:;"  onclick="history.go(-1)"><i ></i>返 回</a>
		</div>
	</form:form>
	<!-- 保存提交 -->
	<script type="text/javascript">


	</script>
</body>
</html>