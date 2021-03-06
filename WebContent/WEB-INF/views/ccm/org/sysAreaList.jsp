<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>区域管理</title>
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
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">事件管理</span>--%>
<ul class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/org/sysArea?type=${type}">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="sysArea" action="${ctx}/org/sysArea/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="type" name="type" type="hidden" value="${type}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="first-line"><label>区域编码：</label>
				<form:input path="code" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>


	<div class="clearfix pull-right btn-box">

			<a href="javascript:;" id="btnSubmit" class="btn btn-primary"  style="width: 49px;display:inline-block;float: right;">
				<i></i><span style="font-size: 12px">查询</span> </a>

	</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient"style="table-layout: fixed;">
		<thead>
			<tr>
				<th>名称</th>
				<th>区域编码</th>
				<th>上级区域</th>
				<th>备注信息</th>
				<shiro:hasPermission name="org:ccmOrgArea:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysArea">
			<tr>
			<!-- 解决ie浏览器url解析问题 -->
				<td style="height: 50px"><a href="${ctx}/org/ccmOrgArea/form?id=${sysArea.idEx}&area.id=${sysArea.id}&type=${sysArea.type}&area.name="+ encodeURI({sysArea.name})>
					${sysArea.name}
				</a></td>
				<td style="height: 50px">
					${sysArea.code}
				</td>
				<td style=" white-space:nowrap;overflow:hidden;text-overflow: ellipsis;height: 50px">
					${sysArea.parent.name}
				</td>
				<td class="tp" style="white-space: nowrap;
overflow: hidden;
text-overflow: ellipsis;height: 50px">
					${sysArea.remarks}
				</td>
				<shiro:hasPermission name="org:ccmOrgArea:edit"><td style="height: 50px">
    				<a class="btnList" href="${ctx}/org/ccmOrgArea/form?id=${sysArea.idEx}&area.id=${sysArea.id}&type=${sysArea.type}&area.name="+ encodeURI({sysArea.name}) title="修改"><i class="icon-pencil"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>