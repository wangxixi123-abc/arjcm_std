<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工作职责管理</title>
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
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">社区事务</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/service/ccmServiceDuty/">数据列表</a></li>
		<shiro:hasPermission name="service:ccmServiceDuty:edit"><li><a style="width: 140px;text-align:center" href="${ctx}/service/ccmServiceDuty/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmServiceDuty" action="${ctx}/service/ccmServiceDuty/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>岗位名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li class="first-line"><label>所在部门：</label>
				<form:input path="department" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li class="first-line"><label>主管领导：</label>
				<form:input path="chief" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;margin-right: 14px;
    margin-bottom: 20px;/*margin-top: 25px;*/display:inline-block;float: right;margin-left: 20px" class="btn btn-primary">
				<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>岗位名称</th>
				<th>岗位编号</th>
				<th>所在部门</th>
				<th>主管领导</th>
				<shiro:hasPermission name="service:ccmServiceDuty:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmServiceDuty">
			<tr>
				<td style="height: 50px"><a href="${ctx}/service/ccmServiceDuty/form?id=${ccmServiceDuty.id}">
					${ccmServiceDuty.name}
				</a></td>
				<td style="height: 50px">
					${ccmServiceDuty.code}
				</td>
				<td style="height: 50px">
					${ccmServiceDuty.department}
				</td>
				<td style="height: 50px">
					${ccmServiceDuty.chief}
				</td>
				<shiro:hasPermission name="service:ccmServiceDuty:edit"><td style="height: 50px">
    				<a class="btnList" href="${ctx}/service/ccmServiceDuty/form?id=${ccmServiceDuty.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/service/ccmServiceDuty/delete?id=${ccmServiceDuty.id}" onclick="return confirmx('确认要删除该工作职责吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>