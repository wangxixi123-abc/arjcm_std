<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>服务项目管理管理</title>
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
		<li class="active"><a href="${ctx}/partyserverproject/ccmPartyServerProject/">服务项目管理列表</a></li>
		<%--<shiro:hasPermission name="partyserverproject:ccmPartyServerProject:edit"><li><a href="${ctx}/partyserverproject/ccmPartyServerProject/form">服务项目管理添加</a></li></shiro:hasPermission>--%>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPartyServerProject" action="${ctx}/partyserverproject/ccmPartyServerProject/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>项目名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium" />
			</li>
			<li><label>所属社区：</label>
				<sys:treeselect id="community" name="community.id" value="${ccmPartyServerProject.community.id}" labelName="community.name" labelValue="${ccmPartyServerProject.community.name}"
					title="区域" url="/sys/area/treeData" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>创建时间：</label>
				<input name="createDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPartyServerProject.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li class="btns"><a id="add"
							   onclick="parent.parent.parent.LayerDialog('${ctx}/partyserverproject/ccmPartyServerProject/form', '添加', '1120px', '650px')"
							   class="btn btn-success"><i class="icon-plus"></i> 添加</a></li>
			<li class="btns">
				<a href="javascript:;" id="btnSubmit" class="btn btn-primary"> 
					<i class="icon-search"></i> 查询
				</a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>项目名称</th>
				<th>项目创建时间</th>
				<th>所属社区</th>
				<th>拟认领数</th>
                <th>实认领数</th>
				<th>联系人</th>
				<th>联系人电话</th>
				<shiro:hasPermission name="partyserverproject:ccmPartyServerProject:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPartyServerProject">
			<tr>
				<td><a onclick="parent.parent.parent.LayerDialog('${ctx}/partyserverproject/ccmPartyServerProject/form?id=${ccmPartyServerProject.id}', '修改', '1100px', '700px')">
					${ccmPartyServerProject.name}
				</a></td>
				<td>
					<fmt:formatDate value="${ccmPartyServerProject.projectCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPartyServerProject.community.name}
				</td>
				<td>
					${ccmPartyServerProject.clailNum}
				</td>
                <td>
                        ${ccmPartyServerProject.relclailNum}
                </td>
				<td>
					${ccmPartyServerProject.relaName}
				</td>
				<td>
					${ccmPartyServerProject.relaTelphone}
				</td>
				<shiro:hasPermission name="partyserverproject:ccmPartyServerProject:edit"><td>
    				<%--<a href="${ctx}/partyserverproject/ccmPartyServerProject/form?id=${ccmPartyServerProject.id}">修改</a>--%>
					<%--<a href="${ctx}/partyserverproject/ccmPartyServerProject/delete?id=${ccmPartyServerProject.id}" onclick="return confirmx('确认要删除该服务项目管理吗？', this.href)">删除</a>--%>

					<a  class="btnList" title="编辑"
						onclick="parent.parent.parent.LayerDialog('${ctx}/partyserverproject/ccmPartyServerProject/form?id=${ccmPartyServerProject.id}', '修改', '1100px', '700px')">
                        <i class="icon-pencil"></i></a>
                    <a  class="btnList" title="认领"
                        onclick="parent.parent.parent.LayerDialog('${ctx}/partyprojectpost/ccmPartyProjectPost/form?type=1&proPost=${ccmPartyServerProject.id}', '认领', '620px', '200px')">
                        <i class="icon-folder-open" style="    color: maroon"></i></a>
					<a  class="btnList"
						href="${ctx}/partyserverproject/ccmPartyServerProject/delete?id=${ccmPartyServerProject.id}"
						onclick="return confirmx('确认要删除该双报道情况管理吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>