<%@page import="com.arjjs.ccm.modules.sys.entity.User"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>用户管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#btnExport").click(function() {
			top.$.jBox.confirm("确认要导出数据吗？", "系统提示", function(v, h, f) {
				if (v == "ok") {
					$("#searchForm").attr("action", "${ctx}/sys/user/export");
					$("#searchForm").submit();
				}
			}, {
				buttonsFocus : 1
			});
			top.$('.jbox-body .jbox-icon').css('top', '55px');
		});
		$("#btnImport").click(function() {
			$.jBox($("#importBox").html(), {
				title : "导入数据",
				buttons : {
					"关闭" : true
				},
				bottomText : "导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"
			});
		});
	});
	function page(n, s) {
		if (n)
			$("#pageNo").val(n);
		if (s)
			$("#pageSize").val(s);
		$("#searchForm").attr("action", "${ctx}/sys/user/list");
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/sys/user/import" method="post"
			enctype="multipart/form-data" class="form-search"
			style="padding-left: 20px; text-align: center;"
			onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file"
				style="width: 330px" /><br />
			<br /> <input id="btnImportSubmit" class="btn btn-primary"
				type="submit" value="   导    入   " /> <a
				href="${ctx}/sys/user/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/user/list">用户列表</a></li>
		<li class="active"><a
			href="${ctx}/sys/userAuthstr/list?loginFlag=0">待审核用户列表</a></li>
		<shiro:hasPermission name="sys:user:edit">
			<li><a href="${ctx}/sys/user/form">用户添加</a></li>
		</shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="user"
		action="${ctx}/sys/userAuthstr/list" method="post"
		class="breadcrumb form-search ">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<input id="loginFlag" name="loginFlag" type="hidden" value="0" />
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
			callback="page();" />
		<ul class="ul-form">
			<li><label>归属机构：</label>
			<sys:treeselect id="company" name="company.id"
					value="${user.company.id}" labelName="company.name"
					labelValue="${user.company.name}" title="机构"
					url="/sys/office/treeData?type=1" cssClass="input-small"
					allowClear="true" /></li>
			<li><label>登录名：</label>
			<form:input path="loginName" htmlEscape="false" maxlength="50"
					class="input-medium" /></li>
			<li><label>归属部门：</label>
			<sys:treeselect id="office" name="office.id"
					value="${user.office.id}" labelName="office.name"
					labelValue="${user.office.name}" title="部门"
					url="/sys/office/treeData?type=2" cssClass="input-small"
					allowClear="true" notAllowSelectParent="true" /></li>
			<li><label>姓&nbsp;&nbsp;&nbsp;名：</label>
			<form:input path="name" htmlEscape="false" maxlength="50"
					class="input-medium" /></li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary"
				type="submit" value="查询" onclick="return page();" /> <shiro:hasPermission
					name="sys:user:edit">
				<!-- 	<input id="btnExport" class="btn btn-primary" type="button"
						value="导出" />
					<input id="btnImport" class="btn btn-primary" type="button"
						value="导入" /> -->
						<a href="javascript:;" id="btnImport" class="btn  btn-export ">
						<i class=" icon-share-alt "></i> 导入
					</a>
					<a href="javascript:;" id="btnExport" class="btn btn-export"> 
						<i class=" icon-reply"></i> 导出
					</a>
				</shiro:hasPermission></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}" />
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>归属机构</th>
				<th>归属部门</th>
				<th class="sort-column login_name">登录名</th>
				<th class="sort-column name">姓名</th>
				<th>手机</th>
				<th>审核状态</th>
				<%--<th>角色</th> --%>
				<shiro:hasPermission name="sys:user:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="user">
				<tr>
					<td>${user.company.name}</td>
					<td>${user.office.name}</td>
					<td><a href="${ctx}/sys/user/form?id=${user.id}">${user.loginName}</a></td>
					<td>${user.name}</td>
					<td>${user.mobile}</td>
					<td>
						<c:if test="${user.loginFlag == '0'}">未审核</c:if>
						<c:if test="${user.loginFlag == '1'}">已审核</c:if>
					</td>
					<%--
				<td>${user.roleNames}</td> --%>
					<shiro:hasPermission name="sys:user:edit">
						<td><a class="btnList"
							href="${ctx}/sys/user/form?id=${user.id}" title="修改"><i
								class="icon-pencil"></i></a> <a class="btnList"
							href="${ctx}/sys/user/delete?id=${user.id}"
							onclick="return confirmx('确认要删除该用户吗？', this.href)" title="删除"><i
								class="icon-trash"></i></a></td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>