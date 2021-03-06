<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调解组织管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			//关闭弹框事件
			$('#btnCancel').click(function() {
				parent.layer.close(parent.layerIndex);
			})
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
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmEventOrganization" action="${ctx}/organization/ccmEventOrganization/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<%-- <div class="control-group">
			<label class="control-label">父级编号：</label>
			<div class="controls">
				<form:input path="more2" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所有父级编号：</label>
			<div class="controls">
				<form:input path="more3" htmlEscape="false" maxlength="2000" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">排序：</label>
			<div class="controls">
				<form:input path="more4" htmlEscape="false" class="input-xlarge "/>
			</div>
		</div> --%>
		
		<div class="control-group">
			<label class="control-label">组织名称：</label>
			<div class="controls">
				<form:input path="orgName" htmlEscape="false" maxlength="100" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">归属区域：</label>
			<div class="controls">
				<sys:treeselect id="area" name="area.id" value="${ccmEventOrganization.area.id}" labelName="area.name" labelValue="${ccmEventOrganization.area.name}"
					title="区域" url="/sys/area/treeData" cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">区域编码：</label>
			<div class="controls">
				<form:input path="code" htmlEscape="false" maxlength="100" class="input-xlarge number"/>
			</div>
		</div>
		
		<div class="control-group">
			<label class="control-label">组织联系方式：</label>
			<div class="controls">
				<form:input path="orgPhone" htmlEscape="false" maxlength="50" class="input-xlarge phone"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">组织详址：</label>
			<div class="controls">
				<form:input path="orgAdd" htmlEscape="false" maxlength="200" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">组织类型：</label>
			<div class="controls">
				<form:select path="orgType" class="input-xlarge">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('ccm_org_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">组织层级：</label>
			<div class="controls">
				<form:select path="orgScale" class="input-xlarge">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('ccm_ply_rat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">业务指导部门：</label>
			<div class="controls">
				<form:input path="guidePart" htmlEscape="false" maxlength="200" class="input-xlarge "/>
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">人员数量：</label>
			<div class="controls">
				<form:input path="manNum" htmlEscape="false" maxlength="6" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">主要职能：</label>
			<div class="controls">
				<form:input path="mainFunc" htmlEscape="false" maxlength="1024" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group" style="display:none;">
			<label class="control-label">冗余字段1：</label>
			<div class="controls">
				<form:input path="more1" htmlEscape="false" maxlength="100" class="input-xlarge "/>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">区域图：</label>
			<div class="controls">
				<form:input path="areaMap" htmlEscape="false" maxlength="2000" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">中心点：</label>
			<div class="controls">
				<form:input path="areaPoint" htmlEscape="false" maxlength="40" class="input-xlarge "/>
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="organization:ccmEventOrganization:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭"/>
		</div>
	</form:form>
</body>
</html>