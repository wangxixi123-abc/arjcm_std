<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>统计首页字典管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#btnSubmit').click(function(){
				$('#searchForm').submit();
			});
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
		<li class="active"><a href="${ctx}/statistics/plmStatisticsDict/">统计首页字典列表</a></li>
		<shiro:hasPermission name="statistics:plmStatisticsDict:edit"><li><a href="${ctx}/statistics/plmStatisticsDict/form">统计首页字典添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="plmStatisticsDict" action="${ctx}/statistics/plmStatisticsDict/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>标题：</label>
				<form:input path="title" htmlEscape="false" maxlength="256" class="input-medium"/>
			</li>
			
			<li class="btns"><a id="btnSubmit" class="btn btn-primary" href="javascript:;" ><i class="icon-search"></i> 查询</a></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>标题</th>
				<th>内容链接</th>
				<th>数据行数</th>	
				<th>类型</th>		
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="statistics:plmStatisticsDict:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="plmStatisticsDict">
			<tr>
				<td><a href="${ctx}/statistics/plmStatisticsDict/form?id=${plmStatisticsDict.id}">
					${plmStatisticsDict.title}
				</a></td>
				<td>
					${plmStatisticsDict.content}
				</td>
				<td>
					${plmStatisticsDict.line}
				</td>
				<td>
					${plmStatisticsDict.typeName}
				</td>
				<td>
					<fmt:formatDate value="${plmStatisticsDict.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${plmStatisticsDict.remarks}
				</td>
				<shiro:hasPermission name="statistics:plmStatisticsDict:edit"><td>
    				<a href="${ctx}/statistics/plmStatisticsDict/form?id=${plmStatisticsDict.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/statistics/plmStatisticsDict/delete?id=${plmStatisticsDict.id}" 
					onclick="return confirmx('确认要删除该统计首页字典吗？', this.href)">
					<i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>