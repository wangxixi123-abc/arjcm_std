<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>车道管理</title>
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
		<li class="active"><a href="${ctx}/lane/ccmLane/">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmLane"
		action="${ctx}/lane/ccmLane/" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li><label>车道名称：</label> <form:input path="laneName"
					htmlEscape="false" maxlength="64" class="input-medium" /></li>
			<li><label>车道方向：</label> <form:select path="laneDirection"
					class="input-large">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_lane_direction')}"
						itemLabel="label" itemValue="value" htmlEscape="false"
						class="required" />
				</form:select></li>
			<li style="display: none"><label>所属卡口：</label> <form:input path="bayonetId"
					htmlEscape="false" maxlength="64" class="input-medium" /></li>
			<li><label>出入城方向：</label> <form:select path="passDirection"
					class="input-large">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_pass_direction')}"
						itemLabel="label" itemValue="value" htmlEscape="false"
						class="required" />
				</form:select></li>
			<li class="btns"><a
				onclick="parent.parent.LayerDialog('${ctx}/lane/ccmLane/form', '添加', '1100px', '700px')"
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
				<th>车道名称</th>
				<th>车道方向</th>
				<th>出入城方向</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="lane:ccmLane:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="ccmLane">
				<tr>
					<td><a class="btnList"
						onclick="parent.parent.LayerDialog('${ctx}/lane/ccmLane/form?id=${ccmLane.id}', '编辑', '1100px', '700px')">
							${ccmLane.laneName}</a></td>
					<td>${fns:getDictLabel(ccmLane.laneDirection, 'ccm_lane_direction', '无')}</td>
					<td>${fns:getDictLabel(ccmLane.passDirection, 'ccm_pass_direction', '无')}</td>
					<td><fmt:formatDate value="${ccmLane.updateDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td class="tp">${ccmLane.remarks}</td>
					<shiro:hasPermission name="lane:ccmLane:edit">
						<td><a class="btnList"
							onclick="parent.parent.LayerDialog('${ctx}/lane/ccmLane/form?id=${ccmLane.id}', '编辑', '1100px', '700px')"
							title="修改"><i class="icon-pencil"></i></a> <a class="btnList"
							href="${ctx}/lane/ccmLane/delete?id=${ccmLane.id}"
							onclick="return confirmx('确认要删除该车道吗？', this.href)" title="删除"><i
								class="icon-trash"></i></a></td>

					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>