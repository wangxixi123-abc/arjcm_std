<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>综治领导责任制管理</title>
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
		<li class="active"><a href="${ctx}/org/ccmOrgLeadduty/">数据列表</a></li>
		<shiro:hasPermission name="org:ccmOrgLeadduty:edit"><li><a href="${ctx}/org/ccmOrgLeadduty/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmOrgLeadduty" action="${ctx}/org/ccmOrgLeadduty/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>被实施地区：</label>
				<form:input path="implementedAdd" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>实施主体名称：</label>
				<form:input path="implementName" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>政策种类：</label>
				<form:select path="policyType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_pol_var')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
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
				<th>被实施地区</th>
				<th>被实施地区层级</th>
				<th>实施主体名称</th>
				<th>实施主体层级</th>
				<th>政策种类</th>
				<shiro:hasPermission name="org:ccmOrgLeadduty:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmOrgLeadduty">
			<tr>
				<td><a href="${ctx}/org/ccmOrgLeadduty/form?id=${ccmOrgLeadduty.id}">
					${ccmOrgLeadduty.implementedAdd}
				</a></td>
				<td>
					${fns:getDictLabel(ccmOrgLeadduty.implementedAddScale, 'ccm_ply_rat', '')}
				</td>
				<td>
					${ccmOrgLeadduty.implementName}
				</td>
				<td>
					${fns:getDictLabel(ccmOrgLeadduty.implementScale, 'ccm_ply_rat', '')}
				</td>
				<td>
					${fns:getDictLabel(ccmOrgLeadduty.policyType, 'ccm_pol_var', '')}
				</td>
				<shiro:hasPermission name="org:ccmOrgLeadduty:edit"><td>
    				<a class="btnList" href="${ctx}/org/ccmOrgLeadduty/form?id=${ccmOrgLeadduty.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/org/ccmOrgLeadduty/delete?id=${ccmOrgLeadduty.id}" onclick="return confirmx('确认要删除该综治领导责任制吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>