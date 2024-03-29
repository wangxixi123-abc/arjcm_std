<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>学员-组织关系管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript"
	src="${ctxStatic}/pbs/person/js/pbsPartymembindForm.js"></script>
<script type="text/javascript">
	
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/person/pbsPartymem/">学员信息列表</a></li>
		<li class="active"><a
			href="${ctx}/person/pbsPartymembind/form?id=${pbsPartymembind.id}">学员表关系<shiro:hasPermission
					name="person:pbsPartymembind:edit">${not empty pbsPartymembind.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="person:pbsPartymembind:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<br/>
	<form:form id="inputForm" modelAttribute="pbsPartymembind"
		action="${ctx}/person/pbsPartymembind/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="sSource" value="sys_user" />
		<form:hidden path="sType" value="User" />
		<form:hidden path="pageTurn" value="add" />
		<form:hidden path="sPartymemid"
			value="${pbsPartymembind.partymem.id}" />
		<sys:message content="${message}" />
		<div class="control-group">
			<label class="control-label">学员名称：</label>
			<div class="controls">
				<input  value="${pbsPartymembind.partymem.SName}"
					htmlEscape="false" maxlength="50" class="input-xlarge" type="text"
					readonly="readonly" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>用户选择：</label>
			<div class="controls required">
				<sys:treeselect id="sPrimarykey01" name="sPrimarykey01"
					value="${SPrimarykey01}" labelName="username"
					labelValue="${username}" title="用户"
					url="/sys/office/treeData?type=3" cssClass="input-small"
					allowClear="true" notAllowSelectParent="true"/>
				</li>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>学员：</label>
			<div class="controls">
				<sys:treeselect id="sMemberid" name="sMemberid"
					value="${pbsMemlabel.sMemberid.id}" labelName=""
					labelValue="${pbsMemlabel.sMemberid.SName}" title="用户"
					url="/sys/pbsOffice/treeData?type=4" cssClass="required" allowClear="true"
					notAllowSelectParent="true" />
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">备注：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="person:pbsPartymembind:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>