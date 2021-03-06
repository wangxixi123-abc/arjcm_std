<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>过车信息管理</title>
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
		<li><a href="${ctx}/carpass/ccmCarPass/">过车信息详情</a></li>
		<%-- <li class="active"><a href="${ctx}/carpass/ccmCarPass/form?id=${ccmCarPass.id}">过车信息<shiro:hasPermission name="carpass:ccmCarPass:edit">${not empty ccmCarPass.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="carpass:ccmCarPass:edit">查看</shiro:lacksPermission></a></li> --%>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmCarPass" action="${ctx}/carpass/ccmCarPass/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
	<%-- 	<div class="control-group">
			<label class="control-label">车牌：</label>
			<div class="controls">
				<form:hidden id="plate" path="plate" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="plate" type="files" uploadPath="/carpass/ccmCarPass" selectMultiple="true"/>
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">车牌号码：</label>
			<div class="controls">
				<form:input path="number" htmlEscape="false" maxlength="11" class="input-xlarge " readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所属卡口：</label>
			<div class="controls">
				<form:input path="bayonet" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所属车道：</label>
			<div class="controls">
				<form:input path="lane" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆品牌：</label>
			<div class="controls">
				<form:input path="brand" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆类型：</label>
			<div class="controls">
				<form:input path="type" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">过车时间：</label>
			<div class="controls">
				<input type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${ccmCarPass.passtime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">方向：</label>
			<div class="controls">
				<form:input path="direction" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车道序号：</label>
			<div class="controls">
				<form:input path="lanenumber" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">经度：</label>
			<div class="controls">
				<form:input path="longitude" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">纬度：</label>
			<div class="controls">
				<form:input path="latitude" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">行驶状态：</label>
			<div class="controls">
				<form:input path="condition" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆速度：</label>
			<div class="controls">
				<form:input path="speed" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车牌类型：</label>
			<div class="controls">
				<form:input path="platetype" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车牌颜色：</label>
			<div class="controls">
				<form:input path="platecolor" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆类型：</label>
			<div class="controls">
				<form:input path="cartype" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆颜色：</label>
			<div class="controls">
				<form:input path="carcolor" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">违法类型：</label>
			<div class="controls">
				<form:input path="illegaltype" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">遮阳板：</label>
			<div class="controls">
				<form:input path="sunlouver" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆子品牌：</label>
			<div class="controls">
				<form:input path="subbrand" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">出入城：</label>
			<div class="controls">
				<form:input path="outincity" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">系安全带：</label>
			<div class="controls">
				<form:input path="issafety" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">挂件：</label>
			<div class="controls">
				<form:input path="pendant" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否打电话：</label>
			<div class="controls">
				<form:input path="iscall" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否黄标车：</label>
			<div class="controls">
				<form:input path="yellowcar" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否危险品：</label>
			<div class="controls">
				<form:input path="dangerous" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">年代款：</label>
			<div class="controls">
				<form:input path="chronology" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车头方向：</label>
			<div class="controls">
				<form:input path="headdirection" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车辆照片：</label>
			<div class="controls">
				<form:input path="carphotos" htmlEscape="false" maxlength="255" class="input-xlarge " readonly="true"/>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">车辆照片：</label>
			<div class="controls">
				<form:hidden id="carphotos" path="carphotos" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="carphotos" type="files" uploadPath="/carpass/ccmCarPass" selectMultiple="true"/>
			</div>
		</div> --%>
		<%-- <div class="form-actions">
			<shiro:hasPermission name="carpass:ccmCarPass:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission> 
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>--%>
	</form:form>
</body>
</html>