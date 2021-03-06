<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>标签信息表管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
  $(document).ready(function() {

  });
  function page(n, s) {
    $("#pageNo").val(n);
    $("#pageSize").val(s);
    $("#searchForm").submit();
    return false;
  }
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/person/pbsLabelinfo/">标签信息表列表</a></li>
		<shiro:hasPermission name="person:pbsLabelinfo:edit">
			<li><a href="${ctx}/person/pbsLabelinfo/form">标签信息表添加</a></li>
		</shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="pbsLabelinfo"
		action="${ctx}/person/pbsLabelinfo/" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li><label>标签名称：</label> <form:input path="sName"
					htmlEscape="false" maxlength="1000" class="input-medium" /></li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary"
				type="submit" value="查询" /></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}" />
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>标签名称</th>
				<th>标签类型</th>
				<th>描述信息</th>
				<th>更新时间</th>
				<shiro:hasPermission name="person:pbsLabelinfo:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="pbsLabelinfo">
				<tr>
					<td><a
						href="${ctx}/person/pbsLabelinfo/form?id=${pbsLabelinfo.id}">
							${pbsLabelinfo.SName}</a></td>
					<td>${pbsLabelinfo.SType}</td>
					<td>${pbsLabelinfo.SDescription}</td>
					<td><fmt:formatDate value="${pbsLabelinfo.updateDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<shiro:hasPermission name="person:pbsLabelinfo:edit">
						<td>
							<a href="${ctx}/person/pbsLabelinfo/form?id=${pbsLabelinfo.id}" title = "修改"><i class="icon icon-pencil"></i></a>
							<a href="${ctx}/person/pbsLabelinfo/delete?id=${pbsLabelinfo.id}" onclick="return confirmx('确认要删除该建议分区吗？', this.href)" title = "删除"><i class="icon icon-trash"></i></a>
						</td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>