<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>房屋管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript"
	src="${ctxStatic}/ccm/pop/js/ccmTenantInfo.js"></script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">房屋管理</span>--%>
<div class="back-list">
	<!-- 导入、导出模块 -->
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/pop/ccmPopTenant/import"
			method="post" enctype="multipart/form-data" class="form-search"
			style="padding-left: 20px; text-align: center;"
			onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file"
				style="width: 330px" /><br /> <br /> <input id="btnImportSubmit"
				class="btn btn-primary" type="submit" value="导  入 " />
		</form>
	</div>

	<ul class="nav nav-tabs">
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/pop/ccmPopTenant/">数据列表</a></li>
		<%-- 去掉添加功能 		<shiro:hasPermission name="pop:ccmPopTenant:edit"><li><a href="${ctx}/pop/ccmPopTenant/form">房屋添加</a></li></shiro:hasPermission> --%>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPopTenant"
		action="${ctx}/pop/ccmPopTenant/" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label class="title-text">房屋编号：</label> <form:input path="houseBuild"
					htmlEscape="false" maxlength="50" class="input-medium" /></li>
			<li class="first-line"><label class="title-text">所属网格：</label> <sys:treeselect id="area"
					name="area.id" value="${ccmPopTenant.area.id}"
					labelName="area.name" labelValue="${ccmPopTenant.area.name}"
					title="网格" url="/tree/ccmTree/treeDataArea?type=7&areaid="
					cssClass="input-medium" allowClear="true"
					notAllowSelectParent="true" /></li>
			<li class="first-line"><label class="title-text" style="width: 175px">状态：</label> <form:select path="houseType"
					class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_pop_tenant_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>


			<li class="first-line"><label class="title-text">房主姓名：</label> <form:input path="houseName"
					htmlEscape="false" maxlength="50" class="input-medium" /></li>
			<li class="first-line"><label class="title-text">房屋地址：</label> <form:input path="housePlace"
					htmlEscape="false" maxlength="200" class="input-medium" /></li>

			<!-- <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li> -->
		</ul>


	<div class="clearfix pull-right btn-box">
		<shiro:hasPermission
				name="pop:ccmPopTenant:edit">
			<!-- <input id="btnImport" class="btn btn-primary" type="button" value="导入" />
			<input id="btnExport" class="btn btn-primary" type="button" value="导出" /> -->
			<!-- 					<a href="javascript:;" id="btnImport" class="btn  btn-export ">
			<i class=" icon-share-alt "></i> 导入
			</a> -->
			<a href="javascript:;" id="btnExportAll" class="btn btn-export" style="width: 49px;display:inline-block;float: right;"> <i
					></i> 导出
			</a>
		</shiro:hasPermission> <!-- 添加该input的点击方法为 return page();--> <!-- <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();" /> -->
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;/*margin-top: 25px;*/display:inline-block;float: right;"> <i
					></i> 查询
			</a>
	</div>
	</form:form>
	<sys:message content="${message}" />
	<table id="contentTable"
		class="center-table table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>楼门号</th>
				<th>门牌号</th>
				<th>房屋编号</th>
				<th>状态</th>
				<th>所属网格</th>
				<th>所属楼栋</th>
				<th>房主姓名</th>
				<th>房屋地址</th>
				<th>建筑面积(平方米）</th>
				<shiro:hasPermission name="pop:ccmPopTenant:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="ccmPopTenant">
				<tr>
					<td class="tc" style="height: 50px">${ccmPopTenant.buildDoorNum}</td>
					<td class="tc" style="height: 50px"><a
						href="${ctx}/pop/ccmPopTenant/formByHouse?id=${ccmPopTenant.id}">
							${ccmPopTenant.doorNum} </a></td>
					<td class="tc" style="height: 50px">${ccmPopTenant.houseBuild}</td>
					<td class="tc" style="height: 50px">${fns:getDictLabel(ccmPopTenant.houseType, 'ccm_pop_tenant_type', '')}</td>
					<td class="tc" style="height: 50px">${ccmPopTenant.area.name}</td>
					<td class="tc" style="height: 50px">${ccmPopTenant.buildingId.buildname}</td>
					<td class="tc" style="height: 50px">${ccmPopTenant.houseName}</td>
					<td class="" style="height: 50px">${ccmPopTenant.housePlace}</td>
					<td class="tc" style="height: 50px">${ccmPopTenant.houseArea}</td>
					<td class="tc" style=" width:230px;height: 50px  "><shiro:hasPermission name="pop:ccmPopTenant:edit">
							<a class="btnList"
								href="${ctx}/pop/ccmPopTenant/formByHouse?id=${ccmPopTenant.id}"
								title="修改"><i class="icon-pencil"></i></a>
							<a class="btnList"
								href="${ctx}/pop/ccmPopTenant/delete?id=${ccmPopTenant.id}"
								onclick="return confirmx('确认要删除该房屋吗？', this.href)" title="删除"><i
								class="icon-trash"></i></a>
							<a class="btnList"
								href="${ctx}/pop/ccmPeople/getPeoListByHouse?houseId=${ccmPopTenant.id}&type=house"
								title="住户管理"><i class="icon-group"></i></a>
						</shiro:hasPermission> <shiro:hasPermission name="log:ccmLogTail:edit">
							<a class="btnList" onclick="parent.LayerDialog('${ctx}/log/ccmLogTail/list?relevance_id=${ccmPopTenant.id}&relevance_table=ccm_pop_tenant', '记录信息', '800px', '660px')" 
								  title="记录信息"><i class="icon-print" style="color: cornflowerblue;"></i></a>
							<a class="btnList"
								onclick="parent.LayerDialog('${ctx}/log/ccmLogTail/formPro?relevance_id=${ccmPopTenant.id}&relevance_table=ccm_pop_tenant', '添加记录', '800px', '660px')"
								title="添加记录"><i class="icon-plus"></i></a>
							<a class="btnList"
								onclick="parent.LayerDialog('${ctx}/tenant/ccmTenantRecord/${ccmPopTenant.id}', '历史住户信息', '800px', '660px')"
								title="历史住户信息"><i class="icon-eye-open"></i></a>
						</shiro:hasPermission></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>