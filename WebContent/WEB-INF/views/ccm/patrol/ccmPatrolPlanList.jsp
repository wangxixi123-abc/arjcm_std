<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>巡逻计划管理</title>
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
		<li class="active"><a href="${ctx}/patrol/ccmPatrolPlan/">数据列表</a></li>
		<shiro:hasPermission name="patrol:ccmPatrolPlan:edit"><li><a href="${ctx}/patrol/ccmPatrolPlan/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPatrolPlan" action="${ctx}/patrol/ccmPatrolPlan/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>职责：</label>
				<form:input path="responsibility" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>时间类型：</label>
				<form:select path="timeType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_patrol_time_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>启动状态：</label>
				<form:select path="status" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_patrol_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>点位类型：</label>
				<form:select path="pointType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_patrol_point_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
				<th>名称</th>
				<th>职责</th>
				<th>时间类型</th>
				<th>启动状态</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<th>点位类型</th>
				<shiro:hasPermission name="patrol:ccmPatrolPlan:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPatrolPlan">
			<tr>
				<td><a href="${ctx}/patrol/ccmPatrolPlan/form?id=${ccmPatrolPlan.id}">
					${ccmPatrolPlan.name}
				</a></td>
				<td>
					${ccmPatrolPlan.responsibility}
				</td>
				<td>
					${fns:getDictLabel(ccmPatrolPlan.timeType, 'ccm_patrol_time_type', '')}
				</td>
				<td>
					${fns:getDictLabel(ccmPatrolPlan.status, 'ccm_patrol_status', '')}
				</td>
				<td>
					<fmt:formatDate value="${ccmPatrolPlan.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPatrolPlan.remarks}
				</td>
				<td>
					${fns:getDictLabel(ccmPatrolPlan.pointType, 'ccm_patrol_point_type', '')}
				</td>
				<shiro:hasPermission name="patrol:ccmPatrolPlan:edit"><td>
    				<a class="btnList" href="${ctx}/patrol/ccmPatrolPlan/form?id=${ccmPatrolPlan.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/patrol/ccmPatrolPlan/delete?id=${ccmPatrolPlan.id}" onclick="return confirmx('确认要删除该巡逻计划吗？', this.href)" title="删除"><i class="icon-trash"></i></a>
					<a class="btnList" href="${ctx}/patrol/ccmPatrolResult/startplan?planId=${ccmPatrolPlan.id}" onclick="return confirmx('确认要开启该巡逻计划吗？', this.href)" title="开启计划"><i class="icon-play"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>