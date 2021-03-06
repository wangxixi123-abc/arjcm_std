<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>公告建议管理管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript"	src="${ctxStatic}/plm/storage/ajaxMessageAlert.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				var begin = new Date($("[name='beginCreateDate']").val());
				var end = new Date($("[name='endCreateDate']").val());
				if(begin.getTime() > end.getTime()){
					messageAlert("开始时间大于结束时间！", "error");
					return false;
				}
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
		<li class="active"><a href="${ctx}/proposal/ccmDatabaseProposal/">公告建议列表</a></li>
		<%--<shiro:hasPermission name="proposal:ccmDatabaseProposal:edit"><li><a href="${ctx}/proposal/ccmDatabaseProposal/form">公告建议管理添加</a></li></shiro:hasPermission>--%>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmDatabaseProposal" action="${ctx}/proposal/ccmDatabaseProposal/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>公告标题：</label>
				<form:input path="title" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label >创建时间：</label>
				<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					   value="<fmt:formatDate value="${ccmDatabaseProposal.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
				- <input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
						 value="<fmt:formatDate value="${ccmDatabaseProposal.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						 onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</li>
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
				<th>公告标题</th>
				<th>创建时间</th>
				<th>描述信息</th>
				<shiro:hasPermission name="proposal:ccmDatabaseProposal:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmDatabaseProposal">
			<tr>
				<td><a href="${ctx}/proposal/ccmDatabaseProposal/form?id=${ccmDatabaseProposal.id}">
					${ccmDatabaseProposal.title}
				</a></td>
				<td>
					<fmt:formatDate value="${ccmDatabaseProposal.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
						${ccmDatabaseProposal.remarks}
				</td>
				<shiro:hasPermission name="proposal:ccmDatabaseProposal:edit"><td>
    				<%--<a href="${ctx}/proposal/ccmDatabaseProposal/form?id=${ccmDatabaseProposal.id}">修改</a>--%>
					<a href="${ctx}/proposal/ccmDatabaseProposal/delete?id=${ccmDatabaseProposal.id}" onclick="return confirmx('确认要删除该公告建议管理吗？', this.href)"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>