<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>综治视联网信息中心管理</title>
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
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/org/ccmOrgInfovideo/">数据列表</a></li>
		<shiro:hasPermission name="org:ccmOrgInfovideo:edit"><li><a href="${ctx}/org/ccmOrgInfovideo/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmOrgInfovideo" action="${ctx}/org/ccmOrgInfovideo/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>中心名称：</label>
				<form:input path="centreName" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>中心层级：</label>
				<form:select path="centreScale" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_ply_rat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>负责人姓名：</label>
				<form:input path="centreRespName" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
			<li class="btns">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary">
                <i class="icon-search"></i> 查询 </a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>中心名称</th>
				<th>中心层级</th>
				<th>中心联系方式</th>
				<th>中心负责人姓名</th>
				<th>专职工作人员数量</th>
				<th>联网公共安全视频监控摄像机数量</th>
				<th>是否24小时有人值守</th>
				<shiro:hasPermission name="org:ccmOrgInfovideo:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmOrgInfovideo">
			<tr>
				<td><a href="${ctx}/org/ccmOrgInfovideo/form?id=${ccmOrgInfovideo.id}">
					${ccmOrgInfovideo.centreName}
				</a></td>
				<td>
					${fns:getDictLabel(ccmOrgInfovideo.centreScale, 'ccm_ply_rat', '')}
				</td>
				<td>
					${ccmOrgInfovideo.centreTel}
				</td>
				<td>
					${ccmOrgInfovideo.centreRespName}
				</td>
				<td>
					${ccmOrgInfovideo.specialtyNum}
				</td>
				<td>
					${ccmOrgInfovideo.videoSecuNum}
				</td>
				<td>
					${fns:getDictLabel(ccmOrgInfovideo.officeAllday, 'yes_no', '')}
				</td>
				<shiro:hasPermission name="org:ccmOrgInfovideo:edit"><td>
    				<a class="btnList" href="${ctx}/org/ccmOrgInfovideo/form?id=${ccmOrgInfovideo.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/org/ccmOrgInfovideo/delete?id=${ccmOrgInfovideo.id}" onclick="return confirmx('确认要删除该综治视联网信息中心吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>