<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务学习管理</title>
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
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/service/pbsCourseinfo/">数据列表</a></li>
		<shiro:hasPermission name="service:pbsCourseinfo:edit"><li style="width: 112px"><a style="text-align: center" href="${ctx}/service/pbsCourseinfo/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="pbsCourseinfo" action="${ctx}/service/pbsCourseinfo/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>课程类型：</label>
				<form:select path="sType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('pbs_courseinfo_stype')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="first-line"><label>课程名称：</label>
				<form:input path="sName" htmlEscape="false" maxlength="50" class="input-medium"/>
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

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>课程类型</th>
				<th>课程名称</th>
				<th>文件类型</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="service:pbsCourseinfo:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="pbsCourseinfo">
			<tr>
				<td style="height: 50px"><a href="${ctx}/service/pbsCourseinfo/form?id=${pbsCourseinfo.id}">
					${fns:getDictLabel(pbsCourseinfo.sType, 'pbs_courseinfo_stype', '')}
				</a></td>
				<td style="height: 50px">
					${pbsCourseinfo.sName}
				</td>
				<td style="height: 50px">
					${pbsCourseinfo.sFiletype}
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${pbsCourseinfo.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td style="height: 50px">
					${pbsCourseinfo.remarks}
				</td>
				<shiro:hasPermission name="service:pbsCourseinfo:edit"><td style="height: 50px">
    				<a class="btnList" href="${ctx}/service/pbsCourseinfo/form?id=${pbsCourseinfo.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/service/pbsCourseinfo/delete?id=${pbsCourseinfo.id}" onclick="return confirmx('确认要删除该业务学习吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>