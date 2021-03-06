<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>群防群治组织管理</title>
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
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/org/ccmOrgOrgprevent/">数据列表</a></li>
		<%-- <shiro:hasPermission name="org:ccmOrgOrgprevent:edit"><li><a href="${ctx}/org/ccmOrgOrgprevent/form">数据添加</a></li></shiro:hasPermission> --%>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmOrgOrgprevent" action="${ctx}/org/ccmOrgOrgprevent/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>组织名称：</label>
				<form:input path="comName" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="first-line"><label>归属区域：</label>
				<sys:treeselect id="area" name="area.id" value="${ccmOrgOrgprevent.area.id}" labelName="area.name" labelValue="${ccmOrgOrgprevent.area.name}"
					title="区域" url="/sys/area/treeData" cssClass="input-medium" allowClear="true" notAllowSelectParent="false"/>
			</li>
			<li class="first-line"><label>组织类型：</label>
				<form:select path="comType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_org_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="first-line"><label>组织层级：</label>
				<form:select path="comScale" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_ply_rat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>

	<sys:message content="${message}"/>
	<div class="clearfix pull-right btn-box">

			<a onclick="parent.parent.LayerDialog('${ctx}/org/ccmOrgOrgprevent/form', '添加', '1330px', '600px')"
			   class="btn btn-export" style="width: 49px;display:inline-block;float: right;"><i></i><span style="font-size: 12px">添加</span></a>


			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
				<i></i><span style="font-size: 12px">查询</span>  </a>

	</div>
	</form:form>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>组织名称</th>
				<th>组织类型</th>
				<th>组织层级</th>
				<th>业务指导部门</th>
				<th>人员数量</th>
				<th>主要职能</th>
				<shiro:hasPermission name="org:ccmOrgOrgprevent:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmOrgOrgprevent">
			<tr>
				<td style="height: 50px"><a onclick="parent.parent.LayerDialog('${ctx}/org/ccmOrgOrgprevent/form?id=${ccmOrgOrgprevent.id}', '修改', '1330px', '600px')">
					${ccmOrgOrgprevent.comName}
				</a></td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmOrgOrgprevent.comType, 'ccm_org_type', '')}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmOrgOrgprevent.comScale, 'ccm_ply_rat', '')}
				</td>
				<td style="height: 50px">
					${ccmOrgOrgprevent.guidePart}
				</td>
				<td style="height: 50px">
					${ccmOrgOrgprevent.manNum}
				</td>
				<td style="height: 50px">
					${ccmOrgOrgprevent.mainFunc}
				</td>
				<shiro:hasPermission name="org:ccmOrgOrgprevent:edit"><td style="height: 50px">
    				<a class="btnList" onclick="parent.parent.LayerDialog('${ctx}/org/ccmOrgOrgprevent/form?id=${ccmOrgOrgprevent.id}', '修改', '1330px', '600px')"  title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/org/ccmOrgOrgprevent/delete?id=${ccmOrgOrgprevent.id}" onclick="return confirmx('确认要删除该群防群治组织吗？', this.href)"  title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>