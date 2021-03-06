<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>地方政策管理</title>
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
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/know/ccmKnowSpace/">数据列表</a></li>
		<shiro:hasPermission name="know:ccmKnowSpace:edit"><li><a style="width: 140px;text-align:center" href="${ctx}/know/ccmKnowSpace/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmKnowSpace" action="${ctx}/know/ccmKnowSpace/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<%--  <li><label>法规类别：</label>
				<form:select path="type" class="input-medium">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sys_laws_class_two')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>  --%>
			<li class="first-line"><label>标题：</label>
				<form:input path="name" htmlEscape="false" maxlength="512" class="input-small"/>
			</li>
			<li class="first-line"><label>发文字号：</label>
				<form:input path="lssNo" htmlEscape="false" class="input-medium"/>
			</li>
			<li class="first-line"><label>内容：</label>
				<form:input path="content" htmlEscape="false" class="input-medium"/>
			</li>
			<li class="first-line"><label>发布开始日期：</label>
				<input name="beginPublishDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmKnowSpace.beginPublishDate}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> </li>
			<li class="first-line"><label>发布结束日期：</label>	
				<input name="endPublishDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmKnowSpace.endPublishDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;margin-right: 14px;
    margin-bottom: 20px;/*margin-top: 25px;*/display:inline-block;float: right;margin-left: 20px" class="btn btn-primary">
				<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>标题</th>
				<th>类别</th>
				<th>发文字号</th>
				<th>发布部门</th>
				<th>发布日期</th>
				<th>更新时间</th>
				<shiro:hasPermission name="know:ccmKnowSpace:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmKnowSpace">
			<tr>
				<td style="height: 50px"><a href="${ctx}/know/ccmKnowSpace/form?id=${ccmKnowSpace.id}">
					${ccmKnowSpace.name}</a>
				</td>
				<td style="height: 50px">${fns:getDictLabel(ccmKnowSpace.type, 'sys_laws_class', '暂无')}</td>
				<td style="height: 50px">
					${ccmKnowSpace.lssNo}
				</td>
				<td style="height: 50px">
					${ccmKnowSpace.relDept}
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmKnowSpace.relDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmKnowSpace.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="know:ccmKnowSpace:edit"><td style="height: 50px">
    				<a class="btnList" href="${ctx}/know/ccmKnowSpace/form?id=${ccmKnowSpace.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/know/ccmKnowSpace/delete?id=${ccmKnowSpace.id}" onclick="return confirmx('确认要删除该地方政策吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>