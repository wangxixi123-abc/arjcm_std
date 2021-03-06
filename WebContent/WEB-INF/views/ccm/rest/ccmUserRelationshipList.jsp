<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户关系管理</title>
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
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/rest/ccmUserRelationship/">数据列表</a></li>
		<shiro:hasPermission name="rest:ccmUserRelationship:edit"><li style="width: 140px;text-align:center"><a href="${ctx}/rest/ccmUserRelationship/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmUserRelationship" action="${ctx}/rest/ccmUserRelationship/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>所属群组：</label>
				<sys:treeselect id="groupId" name="groupId" value="${ccmUserRelationship.userGroup.id}" labelName="userGroup.groupname" labelValue="${ccmUserRelationship.userGroup.groupname}"
					title="分组名称" url="/rest/ccmUserGroup/treeData" cssClass="" allowClear="true" notAllowSelectParent="true" cssStyle="width: 150px"/>
			</li>
			<li class="first-line"><label>备注信息：</label>
				<form:input path="remarks" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
<%--			<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;
    /*margin-top: 25px;*/display:inline-block;float: right;" class="btn btn-primary">
				<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>联系人</th>
				<th>联系方式</th>
				<th>分组名称</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="rest:ccmUserRelationship:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmUserRelationship">
			<tr>
				<td style="height: 50px"><a href="${ctx}/rest/ccmUserRelationship/form?id=${ccmUserRelationship.id}">
					${ccmUserRelationship.user.name}
				</a></td>
				<td style="height: 50px">${ccmUserRelationship.user.mobile}</td>
				<td style="height: 50px">
					${ccmUserRelationship.userGroup.groupname}
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmUserRelationship.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td style="height: 50px">
					${ccmUserRelationship.remarks}
				</td>
				<shiro:hasPermission name="rest:ccmUserRelationship:edit"><td style="height: 50px">
					<a class="btnList" href="${ctx}/rest/ccmUserRelationship/form?id=${ccmUserRelationship.id}"><i title="修改" class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/rest/ccmUserRelationship/delete?id=${ccmUserRelationship.id}" onclick="return confirmx('确认要删除该用户关系吗？', this.href)"><i title="删除" class="icon-trash"></i> </a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>