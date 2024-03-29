<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>人脸布控记录管理</title>
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
		<li class="active"><a href="${ctx}/face/ccmFaceControl/">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmFaceControl"
		action="${ctx}/face/ccmFaceControl/" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li><label>布控名称：</label> <form:input path="name"
					htmlEscape="false" maxlength="255" class="input-medium" /></li>
			<li><label>布控等级：</label> <form:select path="controllerLevel"
					class="input-large">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_control_level')}"
						itemLabel="label" itemValue="value" htmlEscape="false"
						maxlength="2" class="input-medium" />
				</form:select></li>
			<li class="btns"><a
				onclick="parent.LayerDialog('${ctx}/face/ccmFaceControl/form', '添加','1100px', '410px')"
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
				<th>布控名称</th>
				<th>布控开始时间</th>
				<th>布控结束时间</th>
				<th>布控原因</th>
				<th>更新时间</th>
				<shiro:hasPermission name="face:ccmFaceControl:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="ccmFaceControl">
				<tr>
					<td><a
							href="${ctx}/face/ccmFaceControl/form?id=${ccmFaceControl.id}">${ccmFaceControl.name}
					</a></td>
					<td><fmt:formatDate value="${ccmFaceControl.startTime}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td><fmt:formatDate value="${ccmFaceControl.endTime}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td>${ccmFaceControl.controllerReason}</td>
					<td><fmt:formatDate value="${ccmFaceControl.updateDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<shiro:hasPermission name="face:ccmFaceControl:edit">
						<td><a class="btnList"
							onclick="parent.LayerDialog('${ctx}/face/ccmFaceControl/form?id=${ccmFaceControl.id}', '编辑', '1100px', '410px')"
							title="修改"><i class="icon-pencil"></i></a> <a class="btnList"
							href="${ctx}/face/ccmFaceControl/delete?id=${ccmFaceControl.id}"
							onclick="return confirmx('确认要删除该人脸布控记录吗？', this.href)" title="删除"><i
								class="icon-trash"></i></a></td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>