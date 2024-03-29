<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>危化品车辆布控记录管理</title>
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
<script src="${ctxStatic}/ccm/event/js/ccmEventIncident.js"
	type="text/javascript"></script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a
			href="${ctx}/dangerous/dangerousCarControl/">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="dangerousCarControl"
		action="${ctx}/dangerous/dangerousCarControl/" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li><label>车牌号码：</label> <form:input path="plateNumber"
					htmlEscape="false" maxlength="255" class="input-medium" /></li>
			<li><label>布控等级：</label> <form:select path="controllerLevel"
					class="input-large">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_control_level')}"
						itemLabel="label" itemValue="value" htmlEscape="false"
						maxlength="2" class="input-medium" />
				</form:select></li>
			<li class="btns"><a
				onclick="parent.LayerDialog('${ctx}/dangerous/dangerousCarControl/form', '添加', '1100px', '500px')"
				class="btn btn-success"><i class="icon-plus"></i> 添加</a></li>
			<li class="btns"><a href="javascript:;" id="btnSubmit"
				class="btn btn-primary"> <i class="icon-search"></i> 查询
			</a></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}" />
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>车牌号码</th>
				<th>布控原因</th>
				<th>布控开始时间</th>
				<th>布控结束时间</th>
				<th>更新时间</th>
				<shiro:hasPermission name="dangerous:dangerousCarControl:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="dangerousCarControl">
				<tr>
					<td>${dangerousCarControl.plateNumber}</td>
					<td>${dangerousCarControl.controllerReason}</td>
					<td><fmt:formatDate value="${dangerousCarControl.startTime}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td><fmt:formatDate value="${dangerousCarControl.endTime}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td><fmt:formatDate value="${dangerousCarControl.updateDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<shiro:hasPermission name="dangerous:dangerousCarControl:edit">
						<td><a class="btnList"
							onclick="parent.LayerDialog('${ctx}/dangerous/dangerousCarControl/form?id=${dangerousCarControl.id}', '编辑', '1100px', '700px')"
							title="修改"><i class="icon-pencil"></i></a> <a class="btnList"
							href="${ctx}/dangerous/dangerousCarControl/delete?id=${dangerousCarControl.id}"
							onclick="return confirmx('确认要删除该危化品车辆布控记录吗？', this.href)"
							title="删除"><i class="icon-remove-sign"></i></a></td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>