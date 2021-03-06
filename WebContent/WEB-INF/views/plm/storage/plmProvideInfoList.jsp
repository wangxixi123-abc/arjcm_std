<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>供应商信息管理</title>
<meta name="decorator" content="default" />
<!-- 列表缩略图切换 -->
<!--自适应  -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link
	href="${ctxStatic}/bootstrap/2.3.1/css_flat/bootstrap-responsive.css"
	rel="stylesheet">
<link rel="stylesheet" href="${ctxStatic}/common/list/list.css">
<script type="text/javascript" src="${ctxStatic}/common/list/list.js"></script>
<!-- /列表缩略图切换 -->
<script type="text/javascript">
	$(document).ready(function() {
		$('#btnSubmit').click(function(){
			$('#searchForm').submit();
		});
	});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">应急物资保障</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/storage/plmProvideInfo/">供应商信息列表</a></li>
		<shiro:hasPermission name="storage:plmProvideInfo:edit">
			<li><a style="width: 140px;text-align:center" href="${ctx}/storage/plmProvideInfo/form">供应商信息添加</a></li>
		</shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="plmProvideInfo"
		action="${ctx}/storage/plmProvideInfo/" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label>供应商全称：</label> <form:input path="name"
					htmlEscape="false" maxlength="128" class="input-medium" /></li>
			<li class="first-line"><label>供应商类型：</label> <form:select path="proId"
					class="input-medium">
					<form:option value="" label="未选择" />
					<form:options items="${fns:getDictList('plm_provide_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
			<li class="first-line"><label>地区：</label> <form:input path="area"
					htmlEscape="false" maxlength="128" class="input-medium" /></li>
			<li class="first-line"><label>负责人：</label><form:input path="principal"
					htmlEscape="false" maxlength="128" class="input-medium" /></li>
			<li class="first-line"><label>行业类别：</label> <form:select path="calling"
					class="input-medium">
					<form:option value="" label="未选择" />
					<form:options items="${fns:getDictList('plm_calling_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
			<li class="second-line"><label>信用等级：</label> <form:select path="creditClass"
					class="input-medium">
					<form:option value="" label="未选择" />
					<form:options items="${fns:getDictList('plm_credit_level')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
<%--			<li class="clearfix"></li>--%>

		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;
    /*margin-top: 25px;*/display:inline-block;float: right;" class="btn btn-primary">
				<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}" />

	<!-- 列表缩略图切换按钮 -->
	<div id="switchbtn" style="margin-top: 15px">
		<a class="thumbnailbtn"><i class="icon-th "></i></a>&nbsp; <a
			class="listbtn" style="margin-right: 15px"> <i class="icon-th-list2 "></i></a>
	</div>

	<!--/列表缩略图切换按钮 -->
	<div id="prodInfo_List">
		<table id="contentTable"
			class="table table-striped table-bordered table-condensed table-gradient">
			<thead>
				<tr>
					<th>供应商全称</th>
					<th>供应商类型</th>
					<th>地区</th>
					<th>负责人</th>
					<th>联系电话</th>
					<th>移动电话</th>
					<th>行业类别</th>
					<th>信用等级</th>
					<shiro:hasPermission name="storage:plmProvideInfo:edit">
						<th>操作</th>
					</shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="plmProvideInfo">
					<tr>
						<td style="height: 50px"><a
							href="${ctx}/storage/plmProvideInfo/form?id=${plmProvideInfo.id}">
								${plmProvideInfo.name} </a></td>
						<td style="height: 50px">${fns:getDictLabel(plmProvideInfo.proId, 'plm_provide_type', '')}
						</td>
						<td style="height: 50px">${plmProvideInfo.area}</td>
						<td style="height: 50px">${plmProvideInfo.principal}</td>
						<td style="height: 50px">${plmProvideInfo.phoneOne}</td>
						<td style="height: 50px">${plmProvideInfo.mobilePhone}</td>
						<td style="height: 50px">${fns:getDictLabel(plmProvideInfo.calling, 'plm_calling_type', '')}
						</td>
						<td style="height: 50px">${fns:getDictLabel(plmProvideInfo.creditClass, 'plm_credit_level', '')}
						</td>
						<shiro:hasPermission name="storage:plmProvideInfo:edit">
							<td style="height: 50px"><a
								href="${ctx}/storage/plmProvideInfo/form?id=${plmProvideInfo.id}" class="btnList"><i title="修改" class="icon-pencil"></i></a>
								<a
								href="${ctx}/storage/plmProvideInfo/delete?id=${plmProvideInfo.id}"
								onclick="return confirmx('确认要删除该供应商信息吗？', this.href)" class="btnList"><i title="删除" class="icon-trash"></i></a></td>
						</shiro:hasPermission>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<!-- 缩略图 -->
	<div id="prodInfo_small">
		<div class="row">
			<c:forEach items="${page.list}" var="plmProvideInfo">
				<div class="span4 spandiv">
					<div class="thumbnail">
						<a
							href="${ctx}/storage/plmProvideInfo/form?id=${plmProvideInfo.id}">
							<h4 title="${plmProvideInfo.name}">供应商全称:${plmProvideInfo.name}</h4>
						</a> </a>
						<div class="caption row-fluid">
							<div class=" spanimg" style="width: 30%">
								<img src="${ctxStatic}/common/index/images/index-bg.gif"
									onerror='this.src="${ctxStatic}/common/list/images/timg.jpg"'
									alt="通用的占位符缩略图" />
							</div>
							<div class="spantext  " style="width: 63%; margin-left: 7%">
								<p title="${plmProvideInfo.principal.name}">负责人:${plmProvideInfo.principal.name}</p>
								<p title="${plmProvideInfo.phoneOne}">联系电话:${plmProvideInfo.phoneOne}</p>
								<p
									title="${fns:getDictLabel(plmProvideInfo.calling, 'plm_calling_type', '')}">行业类别:${fns:getDictLabel(plmProvideInfo.calling, 'plm_calling_type', '')}</p>
							</div>
						</div>

						<div class="footbtn" style="text-align: right;">
							<shiro:hasPermission name="storage:plmProvideInfo:edit">
								<a
									href="${ctx}/storage/plmProvideInfo/form?id=${plmProvideInfo.id}" class="btnList"><i title="修改" class="icon-pencil"></i></a>
								<a
									href="${ctx}/storage/plmProvideInfo/delete?id=${plmProvideInfo.id}"
									onclick="return confirmx('确认要删除该供应商信息吗？', this.href)" class="btnList"><i title="删除" class="icon-trash"></i></a>
							</shiro:hasPermission>

						</div>
					</div>
				</div>

			</c:forEach>
		</div>
	</div>
	<!-- /缩略图 -->
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>