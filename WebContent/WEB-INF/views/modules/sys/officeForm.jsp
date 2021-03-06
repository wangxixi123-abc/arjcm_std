<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
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
		
		function saveForm() {
			var area = $("#areaId").val();
			var html1 = '<label for="" class="error">必选字段 <label>';
			//alert(officeId.length);
			if (area.length != 0) {
				$("#show1").html("");
			} else {
				$("#show1").html(html1);
			}

			if (area.length != 0) {
				$("#inputForm").submit();
			}

		}
	</script>
	<style type="text/css">
		td{
			padding: 8px;
		}
	</style>
	<%--引入文本框外部样式--%>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/sys/office/list?id=${office.parent.id}&parentIds=${office.parentIds}&name=${office.id}">机构列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/sys/office/form?id=${office.id}&parent.id=${office.parent.id}">机构<shiro:hasPermission name="sys:office:edit">${not empty office.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:office:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" cssStyle="padding-top: 20px;" modelAttribute="office" action="${ctx}/sys/office/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<table  border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; width: 100%;border-top-color: white" >
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">上级机构:</label>
						<div class="controls">
							<sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
											title="机构" url="/sys/office/treeData" extId="${office.id}" cssClass="" allowClear="${office.currentUser.admin}"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span>归属区域:</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id" value="${office.area.id}" labelName="area.name" labelValue="${office.area.name}"
											title="区域" url="/sys/area/treeData" cssClass=""/>
							<span class="help-inline"><font color="red" id="show1"></font></span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>机构名称:</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">机构编码:</label>
						<div class="controls">
							<form:input path="code" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">机构类型:</label>
						<div class="controls">
							<form:select path="type" class="input-medium">
								<form:options items="${fns:getDictList('sys_office_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">机构层级:</label>
						<div class="controls">
							<form:select path="grade" class="input-medium">
								<form:options items="${fns:getDictList('ccm_ply_rat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">是否可用:</label>
						<div class="controls">
							<form:select path="useable">
								<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">主负责人:</label>
						<div class="controls">
							<sys:treeselect id="primaryPerson" name="primaryPerson.id" value="${office.primaryPerson.id}" labelName="office.primaryPerson.name" labelValue="${office.primaryPerson.name}"
											title="用户" url="/sys/office/treeData?type=3" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">副负责人:</label>
						<div class="controls">
							<sys:treeselect id="deputyPerson" name="deputyPerson.id" value="${office.deputyPerson.id}" labelName="office.deputyPerson.name" labelValue="${office.deputyPerson.name}"
											title="用户" url="/sys/office/treeData?type=3" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">联系地址:</label>
						<div class="controls">
							<form:input path="address" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">邮政编码:</label>
						<div class="controls">
							<form:input path="zipCode" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">负责人:</label>
						<div class="controls">
							<form:input path="master" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">电话:</label>
						<div class="controls">
							<form:input path="phone" htmlEscape="false" maxlength="50" class="phone"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">传真:</label>
						<div class="controls">
							<form:input path="fax" htmlEscape="false" maxlength="50"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">邮箱:</label>
						<div class="controls">
							<form:input path="email" htmlEscape="false" maxlength="50" class="email"/>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">备注:</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<c:if test="${empty office.id}">
						<div class="control-group">
							<label class="control-label">快速添加下级部门:</label>
							<div class="controls">
								<form:checkboxes path="childDeptList" items="${fns:getDictList('sys_office_common')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</div>
						</div>
					</c:if>
				</td>
				<td>

				</td>
			</tr>
		</table >
		<div class="form-actions">
			<shiro:hasPermission name="sys:office:edit">
			<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>