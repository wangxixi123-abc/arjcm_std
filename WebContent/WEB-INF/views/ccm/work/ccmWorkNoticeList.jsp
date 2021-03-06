<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>公告管理</title>
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
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">通知公告</span>--%>
<ul class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/work/ccmWorkNotice/">数据列表</a></li>
		<c:if test="${user.id eq '1'}">
			<shiro:hasPermission name="work:ccmWorkNotice:edit"><li style="width: 112px"><a style="text-align: center" href="${ctx}/work/ccmWorkNotice/form">数据添加</a></li></shiro:hasPermission>
		</c:if>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmWorkNotice" action="${ctx}/work/ccmWorkNotice/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>标题：</label>
				<form:input path="title" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="first-line"><label>开始日期：</label>
				<input name="beginDatas" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmWorkNotice.beginDatas}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> </li>
			<li class="first-line"><label>结束日期：</label>	<input name="endDatas" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmWorkNotice.endDatas}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>
		<div class="clearfix pull-right btn-box">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
				<i></i><span style="font-size: 12px">查询</span>  </a>
		</div>
	</form:form>
	<sys:message content="${message}"/>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient" style="table-layout: fixed;">
		<thead>
			<tr>
				<th>标题</th>
				<th>时间</th>
				<th>发布人</th>
				<th>备注信息</th>
				<shiro:hasPermission name="work:ccmWorkNotice:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmWorkNotice">
			<tr>
				<td style="height: 50px"><a href="${ctx}/work/ccmWorkNotice/form?id=${ccmWorkNotice.id}">
					${ccmWorkNotice.title}
				</a></td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmWorkNotice.datas}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td style="height: 50px">
					${ccmWorkNotice.createBy.name}
				</td>
				<td class="" style="height: 50px; white-space:nowrap;overflow:hidden;text-overflow: ellipsis;">
					${ccmWorkNotice.remarks}
				</td>
				<shiro:hasPermission name="work:ccmWorkNotice:edit"><td style="width:5%;height: 50px">
    				<a class="btnList" href="${ctx}/work/ccmWorkNotice/form?id=${ccmWorkNotice.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/work/ccmWorkNotice/delete?id=${ccmWorkNotice.id}" onclick="return confirmx('确认要删除该公告吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>