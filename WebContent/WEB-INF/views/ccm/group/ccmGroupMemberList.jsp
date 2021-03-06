<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>群成员管理</title>
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
		<li class="active"><a href="${ctx}/group/ccmGroupMember/">群成员列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmGroupMember" action="${ctx}/group/ccmGroupMember/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>真实姓名：</label>
				<form:input path="name" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>性别：</label>
				<form:radiobuttons path="sex" items="${fns:getDictList('member_sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			</li>
			<li><label>联系电话：</label>
				<form:input path="phonenumber" htmlEscape="false" maxlength="11" class="input-medium"/>
			</li>
			<li><label>类型：</label>
				<form:input path="type" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li class="btns">
				<a onclick="parent.parent.LayerDialog('${ctx}/group/ccmGroupMember/form', '添加', '700px', '600px')"
					class="btn btn-success"><i class="icon-plus"></i> 添加</a>
			</li>
			<li class="btns">
				<a href="javascript:;" id="btnSubmit" class="btn btn-primary"> 
					<i class="icon-search"></i> 查询
				</a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>真实姓名</th>
				<th>性别</th>
				<th>联系电话</th>
				<th>类型</th>
				<th>申请时间</th>
				<shiro:hasPermission name="group:ccmGroupMember:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmGroupMember">
			<tr>
				<td><a onclick="parent.parent.LayerDialog('${ctx}/group/ccmGroupMember/form?id=${ccmGroupMember.id}', '修改', '700px', '600px')">
					${ccmGroupMember.name}
				</a></td>
				<td>
					${fns:getDictLabel(ccmGroupMember.sex, '', '')}
				</td>
				<td>
					${ccmGroupMember.phonenumber}
				</td>
				<td>
					${ccmGroupMember.type}
				</td>
				<td>
					<fmt:formatDate value="${ccmGroupMember.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="group:ccmGroupMember:edit"><td>
					<a class="btnList" onclick="parent.parent.LayerDialog('${ctx}/group/ccmGroupMember/form?id=${ccmGroupMember.id}', '修改', '700px', '600px')" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/group/ccmGroupMember/delete?id=${ccmGroupMember.id}" onclick="return confirmx('确认要删除该群成员吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>