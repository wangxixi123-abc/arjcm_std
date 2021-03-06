<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>评估流程管理管理</title>
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
		<li class="active"><a href="${ctx}/manage/riskAssessFlow/">评估流程管理列表</a></li>
		<shiro:hasPermission name="manage:riskAssessFlow:edit"><li><a href="${ctx}/manage/riskAssessFlow/form">评估流程管理添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="riskAssessFlow" action="${ctx}/manage/riskAssessFlow/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>流程名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>发起人：</label>
				<form:input path="userName" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>专家组人员：</label>
				<form:input path="specialists" htmlEscape="false" maxlength="256" class="input-medium"/>
			</li>
			<li><label>有效时限：</label>
				<input name="beginLimitTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${riskAssessFlow.beginLimitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
				<input name="endLimitTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${riskAssessFlow.endLimitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
				<li class="btns">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary">
                <i class="icon-search"></i> 查询 </a>
			</li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>流程名称</th>
				<th>发起人</th>
				<th>专家组人员</th>
				<th>有效时限</th>
				<th>备注信息</th>
				<shiro:hasPermission name="manage:riskAssessFlow:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="riskAssessFlow">
			<tr>
				<td><a href="${ctx}/manage/riskAssessFlow/form?id=${riskAssessFlow.id}">
					${riskAssessFlow.name}
				</a></td>
				<td>
					${riskAssessFlow.userName}
				</td>
				<td>
					${riskAssessFlow.specialists}
				</td>
				<td>
					<fmt:formatDate value="${riskAssessFlow.limitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td class="tp">
					${riskAssessFlow.remarks}
				</td>
				<shiro:hasPermission name="manage:riskAssessFlow:edit"><td>
    				<a class="btnList" href="${ctx}/manage/riskAssessFlow/form?id=${riskAssessFlow.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/manage/riskAssessFlow/delete?id=${riskAssessFlow.id}" onclick="return confirmx('确认要删除该评估流程管理吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>