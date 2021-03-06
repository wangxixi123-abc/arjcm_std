<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>道德模范表管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/moral/ccmMoral/">数据列表</a></li>
		<shiro:hasPermission name="moral:ccmMoral:edit"><li><a href="${ctx}/moral/ccmMoral/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmMoral" action="${ctx}/moral/ccmMoral/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>模范标题：</label>
				<form:input path="title" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>名字：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>内容：</label>
				<form:input path="content" htmlEscape="false" maxlength="1024" class="input-medium"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>模范标题</th>
				<th>名字</th>
				<th>头像</th>
				<th>内容</th>
				<shiro:hasPermission name="moral:ccmMoral:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmMoral">
			<tr>
				<td><a href="${ctx}/moral/ccmMoral/form?id=${ccmMoral.id}">
					${ccmMoral.title}
				</a></td>
				<td>
					${ccmMoral.name}
				</td>
				<td>
					<img src="${ccmMoral.headPhoto}" style="height:50px;">

				</td>
				<td class="tp">
					${ccmMoral.content}
				</td>

				<shiro:hasPermission name="moral:ccmMoral:edit"><td>
    				<a class="btnList" href="${ctx}/moral/ccmMoral/form?id=${ccmMoral.id}" title="编辑"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/moral/ccmMoral/delete?id=${ccmMoral.id}" onclick="return confirmx('确认要删除该道德模范表吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>