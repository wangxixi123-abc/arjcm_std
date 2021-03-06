<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>警卫管理</title>
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
		<li ><a href="${ctx}/security/ccmPatrolSecurity/summaryGraph">数据统计</a></li>
		<li class="active"><a href="${ctx}/security/ccmPatrolSecurity/list">警卫任务列表</a></li>
		<shiro:hasPermission name="security:ccmPatrolSecurity:edit"><li><a href="${ctx}/security/ccmPatrolSecurity/form">警卫任务添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPatrolSecurity" action="${ctx}/security/ccmPatrolSecurity/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<%--<li><label>巡逻民警：</label>--%>
				<%--<sys:treeselect id="user" name="user.id" value="${ccmPatrolSecurity.user.id}" labelName="user.name" labelValue="${ccmPatrolSecurity.user.name}"--%>
					<%--title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>--%>
			<%--</li>--%>
			<li><label>警卫时间：</label>
				<input name="securityTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPatrolSecurity.securityTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li><label>参与单位：</label>
				<sys:treeselect id="office" name="office" value="${ccmPatrolSecurity.office}" labelName="officeName" labelValue="${ccmPatrolSecurity.officeName}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>状态：</label>
				<form:select path="status" class="input-medium">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_patrol_missions_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>任务标题</th>
				<%--<th>巡逻民警</th>--%>
				<th>警卫时间</th>
				<th>结束时间</th>
				<th>参与单位</th>
				<th>单位人数</th>
				<th>警卫线路</th>
				<th>集合时间</th>
				<th>集合地点</th>
				<th>状态</th>
				<th>审核状态</th>
				<th>更新时间</th>
				<th>描述信息</th>
				<shiro:hasPermission name="security:ccmPatrolSecurity:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPatrolSecurity">
			<tr>
				<td><a href="${ctx}/security/ccmPatrolSecurity/form?id=${ccmPatrolSecurity.id}">
					${ccmPatrolSecurity.title}
				</a></td>
				<%--<td><a href="${ctx}/security/ccmPatrolSecurity/form?id=${ccmPatrolSecurity.id}">--%>
					<%--${ccmPatrolSecurity.user.name}--%>
				<%--</a></td>--%>
				<td>
					<fmt:formatDate value="${ccmPatrolSecurity.securityTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<fmt:formatDate value="${ccmPatrolSecurity.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPatrolSecurity.officeName}
				</td>
				<td>
					${ccmPatrolSecurity.numberUnits}
				</td>
				<td>
					${ccmPatrolSecurity.guardLine}
				</td>
				<td>
					<fmt:formatDate value="${ccmPatrolSecurity.collectionTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPatrolSecurity.collectionPlace}
				</td>
				<td>
					${fns:getDictLabel(ccmPatrolSecurity.status, 'ccm_patrol_missions_status', '')}
				</td>
				<td>
					${fns:getDictLabel(ccmPatrolSecurity.auditingStatus, 'auditing_status', '')}
				</td>
				<td>
					<fmt:formatDate value="${ccmPatrolSecurity.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPatrolSecurity.remarks}
				</td>
				<shiro:hasPermission name="security:ccmPatrolSecurity:edit"><td>
    				<a href="${ctx}/security/ccmPatrolSecurity/form?id=${ccmPatrolSecurity.id}"><i style="color:#2fa4e7;" class="icon-pencil" title="修改"></i></a>
					<a href="${ctx}/security/ccmPatrolSecurity/delete?id=${ccmPatrolSecurity.id}" onclick="return confirmx('确认要删除该警卫吗？', this.href)"><i style="color:red;" class="icon-trash" title="删除"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>