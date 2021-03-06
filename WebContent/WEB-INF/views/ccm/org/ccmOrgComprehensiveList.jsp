<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>综治机构管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				$("#searchForm").submit();
			})
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
		<li class="active"><a href="${ctx}/org/ccmOrgComprehensive/">数据列表</a></li>
		<shiro:hasPermission name="org:ccmOrgComprehensive:edit"><li><a href="${ctx}/org/ccmOrgComprehensive/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmOrgComprehensive" action="${ctx}/org/ccmOrgComprehensive/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
			<li class="btns">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary">
                <i class="icon-search"></i> 查询 </a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="org:ccmOrgComprehensive:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmOrgComprehensive">
			<tr>
				<td><a href="${ctx}/org/ccmOrgComprehensive/form?id=${ccmOrgComprehensive.id}">
					<fmt:formatDate value="${ccmOrgComprehensive.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</a></td>
				<td>
					${ccmOrgComprehensive.remarks}
				</td>
				<shiro:hasPermission name="org:ccmOrgComprehensive:edit"><td>
    				<a class="btn btn-info" href="${ctx}/org/ccmOrgComprehensive/form?id=${ccmOrgComprehensive.id}">修改</a>
					<a class="btn btn-danger" href="${ctx}/org/ccmOrgComprehensive/delete?id=${ccmOrgComprehensive.id}" onclick="return confirmx('确认要删除该综治机构吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>