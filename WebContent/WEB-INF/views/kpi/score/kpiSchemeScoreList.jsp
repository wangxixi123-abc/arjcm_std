<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效客观KPI打分</title>
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
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">绩效考核</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/score/kpiSchemeScore/">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="kpiScheme" action="${ctx}/score/kpiSchemeScore/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>方案名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li class="first-line"><label>所属部门：</label>
				<sys:treeselect id="office" name="office.id" value="${kpiScheme.office.id}" labelName="office.name" labelValue="${kpiScheme.office.name}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="input-medium" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li class="first-line"><label>考核人员类别：</label>
				<form:select path="userType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

			<li class="first-line"><label>方案状态：</label>
				<form:select path="state" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('kpi_scheme_state')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
		</ul>

	<sys:message content="${message}"/>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
			<i></i><span style="font-size: 12px">查询</span>  </a>
	</div>
	</form:form>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>方案名称</th>
				<th>起止时间</th>
				<th>所属部门</th>
				<th>考核人员类别</th>
				<th>方案状态</th>
				<shiro:hasPermission name="score:kpiSchemeScore:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="kpiScheme">
			<tr>
				<td style="height: 50px">
					${kpiScheme.name}
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${kpiScheme.startTime}" pattern="yyyy-MM-dd"/> —— <fmt:formatDate value="${kpiScheme.endTime}" pattern="yyyy-MM-dd"/>
				</td>
				<td style="height: 50px">
					${kpiScheme.office.name}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(kpiScheme.userType, 'sys_user_type', '')}
				</td>
				<c:if test="${kpiScheme.state eq '1'}">
					<td style='color:#D69601;height: 50px'>${fns:getDictLabel(kpiScheme.state, 'kpi_scheme_state', '')}</td>
				</c:if>
				<c:if test="${kpiScheme.state eq '2'}">
					<td style='color:red;height: 50px'>${fns:getDictLabel(kpiScheme.state, 'kpi_scheme_state', '')}</td>
				</c:if>
				<c:if test="${kpiScheme.state eq '' or empty kpiScheme.state or kpiScheme.state eq '0' }">
					<td style="height: 50px">${fns:getDictLabel(kpiScheme.state, 'kpi_scheme_state', '')}</td>
				</c:if>
				
				<shiro:hasPermission name="score:kpiSchemeScore:edit"><td style="height: 50px">
					<c:if test="${kpiScheme.state != '' and not empty kpiScheme.state and kpiScheme.state != '0' }">
						<a class="btnList" href="${ctx}/score/kpiSchemeScore/form?id=${kpiScheme.id}" title="数据录入"><i class="icon-pencil"></i></a>
					</c:if>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>