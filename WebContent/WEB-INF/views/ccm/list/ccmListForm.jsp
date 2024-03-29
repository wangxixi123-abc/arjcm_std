<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>名单库管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
	<link href="${ctxStatic}/form/css/formTable.css" rel="stylesheet" />
	<script type="text/javascript">
		$(document).ready(function() {
			//关闭弹框事件
			$('#btnCancel').click(function() {
				parent.layer.close(parent.layerIndex);
			})
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
	<br/>
	<form:form id="inputForm" modelAttribute="ccmList" action="${ctx}/list/ccmList/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<table>
			<tr>
				<td>
					<label class="control-label">名称：</label>
					<div class="controls">
						<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<label class="control-label">类型：</label>
					<div class="controls">
						<form:select path="type" class="input-xlarge required">
							<form:option value="" label="请选择" />
							<form:options items="${fns:getDictList('ccm_list_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false"
								class="required" />
						</form:select>
						<span class="help-inline"><font color="red">*</font> </span>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<label class="control-label">描述：</label>
					<div class="controls">
						<form:textarea path="description" htmlEscape="false" rows="4" maxlength="255" class="input-xlarge "/>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<label class="control-label">备注信息：</label>
					<div class="controls">
						<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xlarge "/>
					</div>
				</td>
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="list:ccmList:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
			</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭" />
		</div>
	</form:form>
</body>
</html>