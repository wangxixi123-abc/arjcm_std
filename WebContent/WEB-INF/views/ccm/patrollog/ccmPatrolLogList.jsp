<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>巡检日志管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				var begin = new Date($("[name='beginCreateDate']").val());
				var end = new Date($("[name='endCreateDate']").val());
				if(begin.getTime() > end.getTime()){
					alert("开始时间大于结束时间！", "error");
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
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">日常值守</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/patrollog/ccmPatrolLog/">巡检日志列表</a></li>
		<shiro:hasPermission name="patrollog:ccmPatrolLog:edit"><li><a style="width: 140px;text-align:center" href="${ctx}/patrollog/ccmPatrolLog/form">巡检日志添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPatrolLog" action="${ctx}/patrollog/ccmPatrolLog/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>巡检内容：</label>
				<form:input path="patrolContent" htmlEscape="false" maxlength="2000" class="input-medium"/>
			</li>
			<li class="first-line"><label>登记开始日期：</label>
				<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPatrolLog.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>  </li>
			<li class="first-line"><label>登记结束日期：</label>	<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPatrolLog.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li style="display:none;"><label>登记人：</label>
				<form:input path="createBy.name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>

<%--			<li class="clearfix"></li>--%>
		</ul>

	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;
    /*margin-top: 25px;*/display:inline-block;float: right" class="btn btn-primary">
			<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>照片</th>
				<th>巡检内容</th>
				<th>登记时间</th>
				<th>登记人</th>
				<shiro:hasPermission name="patrollog:ccmPatrolLog:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPatrolLog">
			<tr>
				<td width="100px">
					<img src="${ccmPatrolLog.image}" style="height:50px;"/>
				</td>
				<td>
					<a href="${ctx}/patrollog/ccmPatrolLog/form?id=${ccmPatrolLog.id}">
							${ccmPatrolLog.patrolContent}
					</a>
				</td>
				<td>
					<fmt:formatDate value="${ccmPatrolLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPatrolLog.createBy.name}
				</td>
				<shiro:hasPermission name="patrollog:ccmPatrolLog:edit"><td>
					<a class="btnList" href="${ctx}/patrollog/ccmPatrolLog/form?id=${ccmPatrolLog.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/patrollog/ccmPatrolCheck/delete?id=${ccmPatrolLog.id}" onclick="return confirmx('确认要删除该巡检日志吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
<%--     				<a href="${ctx}/patrollog/ccmPatrolLog/form?id=${ccmPatrolLog.id}">修改</a>
					<a href="${ctx}/patrollog/ccmPatrolLog/delete?id=${ccmPatrolLog.id}" onclick="return confirmx('确认要删除该巡检日志吗？', this.href)">删除</a> --%>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>