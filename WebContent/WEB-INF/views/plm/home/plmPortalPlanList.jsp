<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>门户方案管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		$('#btnSubmit').click(function() {
			$('#searchForm').submit();
		});
	});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
	//编辑内容
	var qid = null
	function bj(id) {
		qid = id

		jBox('iframe:${ctx}/home/plmPortalPlan/form?id=' + qid, {
			title : "编辑门户内容",
			width : 600,
			height : 400,
			buttons : {}, //为了不出现底部的按钮这里特别要这样填写
			closed : function() { //关闭时发生，为了刷新父级页面
				search();
			},
			loaded : function(h) { //隐藏滚动条
				$(".jbox-content").css("overflow", "inherit");
			}
		});

	}
</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">系统设置</span>--%>
<div class="back-list">
	<%-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/home/plmPortalPlan/">门户方案列表</a></li>
		<shiro:hasPermission name="home:plmPortalPlan:edit"><li><a href="${ctx}/home/plmPortalPlan/form">门户方案添加</a></li></shiro:hasPermission>
	</ul> --%>
	<form:form id="searchForm" modelAttribute="plmPortalPlan"
		action="${ctx}/home/plmPortalPlan/" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label>方案名称：</label> <form:input path="name"
					htmlEscape="false" maxlength="256" class="input-medium" /></li>
			<li class="first-line"><label>平台类别：</label> <form:select path="extend1"
					class="input-large">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('index_sys_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false"
						maxlength="2" class="input-medium" />
				</form:select></li>
<%--			<li class="clearfix"></li>--%>
		</ul>
		<div class="clearfix pull-right btn-box">

			<a id="searchForm" class="btn btn-export" style="width: 49px;display:inline-block;float: right;padding-top: 4px!important;" onclick="bj('')"
			   href="javascript:;"><i ></i><span style="font-size: 12px">添加</span></a>
			<a id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;"
			   href="javascript:;"><i ></i><span style="font-size: 12px"> 查询 </span></a>
		</div>
		</form:form>
	<sys:message content="${message}" />


	<table id="contentTable"
		class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>方案名称</th>
				<th>说明</th>
				<th>每行列数</th>
				<th>平台类别</th>
				<th>更新时间</th>
				<shiro:hasPermission name="home:plmPortalPlan:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="plmPortalPlan">
				<tr>
					<td style="height: 50px"><a onclick="bj('${plmPortalPlan.id}')">
							${plmPortalPlan.name} </a></td>
					<td style="height: 50px">${plmPortalPlan.introduce}</td>
					<td style="height: 50px">${plmPortalPlan.type}</td>
					<td style="height: 50px">${fns:getDictLabel(plmPortalPlan.extend1, 'index_sys_type', '无')}
					</td>
					<td style="height: 50px"><fmt:formatDate value="${plmPortalPlan.updateDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<shiro:hasPermission name="home:plmPortalPlan:edit">
						<td style="height: 50px"><a
							href="${ctx}/home/plmPortalDetail/list?pid=${plmPortalPlan.id}"
							title="方案明细"><i class="icon-edit"></i></a> <a
							onclick="bj('${plmPortalPlan.id}')" title="修改"><i
								class="icon-pencil"></i></a> <a class="btnList"
							href="${ctx}/home/plmPortalPlan/delete?id=${plmPortalPlan.id}"
							onclick="return confirmx('确认要删除该门户方案吗？', this.href)" title="删除">
								<i class="icon-remove-sign"></i>
						</a></td>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>