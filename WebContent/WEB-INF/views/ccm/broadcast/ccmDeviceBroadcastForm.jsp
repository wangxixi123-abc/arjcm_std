<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应急广播管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
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
			$("td").css({"padding":"8px"});
			$("td").css({"border":"0px dashed #CCCCCC"});
		});
	</script>
	<%--引入文本框外部样式--%>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/broadcast/ccmDeviceBroadcast/">应急广播列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/broadcast/ccmDeviceBroadcast/form?id=${ccmDeviceBroadcast.id}">应急广播<shiro:hasPermission name="broadcast:ccmDeviceBroadcast:edit">${not empty ccmDeviceBroadcast.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="broadcast:ccmDeviceBroadcast:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmDeviceBroadcast" action="${ctx}/broadcast/ccmDeviceBroadcast/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
	<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; width: 100%;border-top-color: white" >
		<tr>
			<td>
				<div>
					<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>设备编号：</label>
					<div class="controls">
						<form:input path="code" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>设备名称：</label>
					<div class="controls">
						<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge required "/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div>
					<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>IP地址：</label>
					<div class="controls">
						<form:input path="ip" htmlEscape="false" maxlength="15" class="input-xlarge required"/>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label">串口号：</label>
					<div class="controls">
						<form:input path="comPort" htmlEscape="false" maxlength="20" class="input-xlarge "/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div>
					<label class="control-label">设备参数信息：</label>
					<div class="controls">
						<form:textarea path="param" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label">登陆账号：</label>
					<div class="controls">
						<form:input path="account" htmlEscape="false" maxlength="64" class="input-xlarge "/>
					</div>

				</div>
			</td>
		</tr>

		<tr>
			<td>
				<div>
					<label class="control-label">密码：</label>
					<div class="controls">
						<form:input path="password" htmlEscape="false" maxlength="64" class="input-xlarge "/>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label">设备类型：</label>
					<div class="controls">
						<form:input path="typeId" htmlEscape="false" maxlength="3" class="input-xlarge "/>
					</div>
				</div>
			</td>
		</tr>

		<tr>
			<td>
				<div>
					<label class="control-label">所属区域：</label>
					<div class="controls">
						<sys:treeselect id="area" name="area.id" value="${ccmDeviceBroadcast.area.id}" labelName="area.name" labelValue="${ccmDeviceBroadcast.area.name}"
										title="区域" url="/sys/area/treeData" cssClass="" allowClear="true" notAllowSelectParent="false"/>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label">安放位置：</label>
					<div class="controls">
						<form:input path="address" htmlEscape="false" maxlength="200" class="input-xlarge "/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div>
					<label class="control-label">设备状态：</label>
					<div class="controls">
						<form:select path="status" class="input-xlarge ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('ccm_broadcast_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label">厂商：</label>
					<div class="controls">
						<form:input path="companyId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
					</div>
				</div>
			</td>
		</tr>
		<tr>

			<td>
				<div>

					<label class="control-label">版本：</label>
					<div class="controls">
						<form:input path="version" htmlEscape="false" maxlength="64" class="input-xlarge "/>
					</div>
				</div>
			</td>
			<td>
				<div>
					<label class="control-label">说明：</label>
					<div class="controls">
						<form:textarea path="description" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div>

					<label class="control-label">设备坐标：</label>
					<div class="controls">
						<form:input path="coordinate" htmlEscape="false" maxlength="64" class="input-xlarge "/>
					</div>
				</div>
			</td>
			<td>
				<div>

					<label class="control-label">备注信息：</label>
					<div class="controls">
						<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
					</div>
				</div>
			</td>
		</tr>
	</table>
		<div class="form-actions">
			<shiro:hasPermission name="broadcast:ccmDeviceBroadcast:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>