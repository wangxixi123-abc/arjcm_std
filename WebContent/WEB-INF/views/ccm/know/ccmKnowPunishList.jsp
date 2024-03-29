<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>城管行政处罚管理</title>
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
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">个人办公</span>--%>
<ul class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/know/ccmKnowPunish/">数据列表</a></li>
		<shiro:hasPermission name="know:ccmKnowPunish:edit"><li style="width: 112px"><a style="text-align: center" href="${ctx}/know/ccmKnowPunish/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmKnowPunish" action="${ctx}/know/ccmKnowPunish/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>简介：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="first-line"><label>处罚开始日期：</label>
				<input name="beginInspectData" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmKnowPunish.beginInspectData}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/></li>
			<li class="first-line"><label>处罚结束日期：</label>	<input name="endInspectData" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmKnowPunish.endInspectData}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li class="first-line"><label>类别：</label>
				<form:select path="type" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_know_punish_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>
		<div class="clearfix pull-right btn-box">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;margin-left: 20px;margin-right: 14px;margin-bottom: 20px">
				<i></i><span style="font-size: 12px">查询</span>  </a>
		</div>
	</form:form>
	<sys:message content="${message}"/>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>简介</th>
				<th>处罚日期</th>
				<th>类别</th>
				<shiro:hasPermission name="know:ccmKnowPunish:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmKnowPunish">
			<tr>
				<td style="height: 50px"><a href="${ctx}/know/ccmKnowPunish/form?id=${ccmKnowPunish.id}">
					${ccmKnowPunish.name}
				</a></td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmKnowPunish.inspectData}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmKnowPunish.type, 'ccm_know_punish_type', '')}
				</td>
				<shiro:hasPermission name="know:ccmKnowPunish:edit"><td style="height: 50px">
    				<a class="btnList" href="${ctx}/know/ccmKnowPunish/form?id=${ccmKnowPunish.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/know/ccmKnowPunish/delete?id=${ccmKnowPunish.id}" onclick="return confirmx('确认要删除该城管行政处罚吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>