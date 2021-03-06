<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户好友分组管理</title>
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
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">工作助手</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/rest/ccmUserGroup/">数据列表</a></li>
		<shiro:hasPermission name="rest:ccmUserGroup:edit"><li style="width: 140px;text-align:center" ><a href="${ctx}/rest/ccmUserGroup/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmUserGroup" action="${ctx}/rest/ccmUserGroup/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label class="title-text">分组名称：</label>
				<form:input path="groupname" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
<%--			<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;/*margin-top: 25px;*/display:inline-block;float: right;" class="btn btn-primary">
				<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>分组名称</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="rest:ccmUserGroup:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmUserGroup">
			<tr>
				<td style="height: 50px"><a href="${ctx}/rest/ccmUserGroup/form?id=${ccmUserGroup.id}">
					${ccmUserGroup.groupname}
				</a></td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmUserGroup.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td class="tp" style="height: 50px">
					${ccmUserGroup.remarks}
				</td>
				<shiro:hasPermission name="rest:ccmUserGroup:edit"><td style="height: 50px">
					<a class="btnList" href="${ctx}/rest/ccmUserGroup/form?id=${ccmUserGroup.id}"><i title="修改" class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/rest/ccmUserGroup/delete?id=${ccmUserGroup.id}" onclick="return confirmx('确认要删除该用户好友分组吗？', this.href)"><i title="删除" class="icon-trash"></i> </a>
				
    				<%-- <a href="${ctx}/rest/ccmUserGroup/form?id=${ccmUserGroup.id}">修改</a>
					<a href="${ctx}/rest/ccmUserGroup/delete?id=${ccmUserGroup.id}" onclick="return confirmx('确认要删除该用户好友分组吗？', this.href)">删除</a> --%>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>