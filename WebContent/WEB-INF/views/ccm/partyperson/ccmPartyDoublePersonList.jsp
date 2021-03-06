<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>党员信息管理管理</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css" />
	<script src="${ctxStatic}/layer-v3.1.1/layer/layer.js" type="text/javascript"></script>
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
		//详情弹框--不刷新父页面
		function LayerDialog(src, title, height, width) {
			layer.open({
				type : 2,
				title : title,
				area : [ height, width ],
				fixed : true, //固定
				maxmin : true,
				//btn: ['确定', '关闭'], //可以无限个按钮
				content : src,
			});
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/partyperson/ccmPartyPerson/">党员信息管理列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPartyPerson" action="${ctx}/partyperson/ccmPartyPerson/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="type" name="type" type="hidden" value="2"/>
		<ul class="ul-form">
			<li><label>党员姓名：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li>
				<label>所属组织：</label>
				<%--<sys:treeselect id="beloneOrg" name="beloneOrg" value="${ccmPartyPerson.beloneOrg}" labelName="" labelValue="${ccmPartyPerson.beloneOrg}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>--%>

				<form:select path="beloneOrg" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${list}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><a
					onclick="parent.parent.parent.LayerDialog('${ctx}/partyperson/ccmPartyPerson/form?type=2', '添加', '1330px', '800px')"
					class="btn btn-success"><i class="icon-plus"></i> 添加</a></li>
			<li class="btns">
				<a href="javascript:;" id="btnSubmit" class="btn btn-primary"> 
					<i class="icon-search"></i> 查询
				</a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>党员姓名</th>
				<th>所属组织</th>
				<th>党员身份</th>
				<th>入党时间</th>
				<th>现任党内职务</th>
				<shiro:hasPermission name="partyperson:ccmPartyPerson:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPartyPerson">
			<tr>
				<td><a onclick="parent.parent.parent.LayerDialog('${ctx}/partyperson/ccmPartyPerson/form?id=${ccmPartyPerson.id}', '修改', '1330px', '800px')">
					${ccmPartyPerson.name}
				</a></td>
				<td>
					${ccmPartyPerson.beloneOrgName}
				</td>
				<td>
					${ccmPartyPerson.partMembership}
				</td>
				<td>
					<fmt:formatDate value="${ccmPartyPerson.joinPartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPartyPerson.innerPartPosition}
				</td>
				<shiro:hasPermission name="partyperson:ccmPartyPerson:edit"><td>
    				<%--<a href="${ctx}/partyperson/ccmPartyPerson/form?id=${ccmPartyPerson.id}">修改</a>
					<a href="${ctx}/partyperson/ccmPartyPerson/delete?id=${ccmPartyPerson.id}" onclick="return confirmx('确认要删除该党员信息管理吗？', this.href)">删除</a>--%>
						<a  class="btnList"
							onclick="parent.parent.parent.LayerDialog('${ctx}/partyperson/ccmPartyPerson/form?id=${ccmPartyPerson.id}', '修改', '1330px', '800px')"><i class="icon-pencil"></i></a>
						<a  class="btnList"
							href="${ctx}/partyperson/ccmPartyPerson/delete?id=${ccmPartyPerson.id}"
							onclick="return confirmx('确认要删除该党员信息管理吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>