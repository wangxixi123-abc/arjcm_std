<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户指南管理</title>
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
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/service/ccmServiceGuidance/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/service/ccmServiceGuidance/form?id=${ccmServiceGuidance.id}">数据<shiro:hasPermission name="service:ccmServiceGuidance:edit">${not empty ccmServiceGuidance.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="service:ccmServiceGuidance:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmServiceGuidance" action="${ctx}/service/ccmServiceGuidance/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table>
			<tr>
				<td >
					<div class="control-group" style="padding-top: 8px">
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>事项分类：</label>
						<div class="controls">
							<form:select path="type" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_service_guidance_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>

						</div>
					</div>
				</td>
				<td >
					<div class="control-group">
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>标题：</label>
						<div class="controls">
							<form:input path="title" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">办理对象：</label>
						<div class="controls">
							<form:input path="pcsPeople" htmlEscape="false" maxlength="256" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">办公时间：</label>
						<div class="controls">
							<form:input path="officeHours" htmlEscape="false" maxlength="256" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">办事地点：</label>
						<div class="controls">
							<form:input path="pcsAdd" htmlEscape="false" maxlength="256" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>

			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">办理条件：</label>
						<div class="controls">
							<form:textarea path="pcsConditions" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">提前准备材料：</label>
						<div class="controls">
							<form:textarea path="pcsFiles" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">注意事项：</label>
						<div class="controls">
							<form:textarea path="attention" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
			</tr>




			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">相关费用：</label>
						<div class="controls">
							<form:textarea path="expense" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td >
					<div class="control-group">
						<label class="control-label">具体流程：</label>
						<div class="controls">
							<form:textarea path="process" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
						</div>
					</div>
				</td>

			</tr>




			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">相关附件：</label>
						<div class="controls">
							<form:hidden id="file" path="file"  htmlEscape="false" maxlength="200" class="input-xxlarge"/>
							<sys:ckfinder input="file" type="files" uploadPath="/service/ccmServiceGuidance" selectMultiple="false"/>
						</div>
					</div>
				</td>
			</tr>
		</table>










		<%-- <div class="control-group">
			<label class="control-label">扩展1：</label>
			<div class="controls">
				<form:input path="extend1" htmlEscape="false" maxlength="256" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">扩展2：</label>
			<div class="controls">
				<form:input path="extend2" htmlEscape="false" maxlength="256" class="input-xlarge "/>
			</div>
		</div>--%>


		<div class="form-actions">
			<shiro:hasPermission name="service:ccmServiceGuidance:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>