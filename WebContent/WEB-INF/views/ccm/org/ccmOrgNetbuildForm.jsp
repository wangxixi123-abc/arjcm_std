<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>网格化建设管理</title>
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
					if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			$("td").css({"padding":"10px"});
			$("td").css({"border":"1px dashed #CCCCCC"});
		});
	</script>
	<style type="text/css">
		.input-xlarge{width: 200px;}
	</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/org/ccmOrgNetbuild/list">数据列表</a></li>
		<li class="active"><a href="${ctx}/org/ccmOrgNetbuild/form?id=${ccmOrgNetbuild.id}&parent.id=${ccmOrgNetbuildparent.id}">数据<shiro:hasPermission name="org:ccmOrgNetbuild:edit">${not empty ccmOrgNetbuild.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="org:ccmOrgNetbuild:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmOrgNetbuild" action="${ctx}/org/ccmOrgNetbuild/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		
		<table border="1px" style="border-color: #CCCCCC; border: 1px dashed #CCCCCC; padding: 10px; width: 100%" >
		<tr>
			<td style="width: 50%">	
		<div>
			<label class="control-label">上级网格:</label>
			<div class="controls">
				<sys:treeselect id="parent" name="parent.id" value="${ccmOrgNetbuild.parent.id}" labelName="parent.name" labelValue="${ccmOrgNetbuild.parent.name}"
					title="父级编号" url="/org/ccmOrgNetbuild/treeData" extId="${ccmOrgNetbuild.id}" cssClass="" allowClear="true"/>
			</div>
		</div>
			</td>
			<td style="width: 50%">
		<div>
			<label class="control-label">网格名称：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="20" class="input-xlarge "/>
			</div>
		</div>
			</td>
		</tr>
		<tr>
			<td>
		<div>
			<label class="control-label">网格长姓名：</label>
			<div class="controls">
				<form:input path="netManName" htmlEscape="false" maxlength="10" class="input-xlarge "/>
			</div>
		</div>
			</td>
			<td>
		<div>
			<label class="control-label">性别：</label>
			<div class="controls">
				<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
			</div>
		</div>
			</td>
		</tr>
		<tr>
			<td>
		<div>
			<label class="control-label">民族：</label>
			<div class="controls">
				<form:select path="nation" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sys_volk')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
			</td>
			<td>
		<div>
			<label class="control-label">政治面貌：</label>
			<div class="controls">
				<form:select path="politics" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sys_ccm_poli_stat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
			</td>
		</tr>
		<tr>
			<td>
		<div>
			<label class="control-label">出生日期：</label>
			<div class="controls">
				<input name="birthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${ccmOrgNetbuild.birthday}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
			</td>
			<td>
		<div>
			<label class="control-label">学历：</label>
			<div class="controls">
				<form:select path="education" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sys_ccm_degree')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
			</td>
		</tr>
		<tr>
			<td>
		<div>
			<label class="control-label">手机号码：</label>
			<div class="controls">
				<form:input path="telephone" htmlEscape="false" maxlength="18" class="input-xlarge mobile"/>
			</div>
		</div>
			</td>
			<td>
		<div>
			<label class="control-label">固定电话：</label>
			<div class="controls">
				<form:input path="fixTel" htmlEscape="false" maxlength="18" class="input-xlarge simplePhone"/>
			</div>
		</div>
			</td>
		</tr>
		<tr>
			<td>
		<div>
			<label class="control-label">网格员姓名：</label>
			<div class="controls">
				<form:input path="netPeoName" htmlEscape="false" maxlength="50" class="input-xlarge "/>
			</div>
		</div>
			</td>
			<td>
		<div>
			<label class="control-label">网格员数量：</label>
			<div class="controls">
				<form:input path="netManNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits"/>
			</div>
		</div>
			</td>
		</tr>
		<tr>
			<td>
		<div>
			<label class="control-label">网格户数：</label>
			<div class="controls">
				<form:input path="netNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits"/>
			</div>
		</div>
			</td>
			<td>
		<div>
			<label class="control-label">网格面积（平方米）：</label>
			<div class="controls">
				<form:input path="netArea" htmlEscape="false" class="input-xlarge  number"/>
			</div>
		</div>
			</td>
		</tr>
		<tr>
		
			<td colspan="2">
		<div>
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
			</td>
		</tr>
		</table>
		
		
		
		
		<div style="display: none">
			<label class="control-label">排序：</label>
			<div class="controls">
				<form:input path="sort" htmlEscape="false" class="input-xlarge  digits"/>
			</div>
		</div>
		
		
		<div class="form-actions">
			<shiro:hasPermission name="org:ccmOrgNetbuild:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>