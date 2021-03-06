<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>队伍管理管理</title>
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
		<li class="active"><a href="${ctx}/partyteam/ccmPartyVolunteerTeam/">队伍管理列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPartyVolunteerTeam" action="${ctx}/partyteam/ccmPartyVolunteerTeam/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>成立日期：</label>
				<input name="foundTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPartyVolunteerTeam.foundTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li><label>负责人：</label>
				<form:input path="user.id" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li class="btns"><a
					onclick="parent.parent.parent.LayerDialog('${ctx}/partyteam/ccmPartyVolunteerTeam/form', '添加', '1230px', '600px')"
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
				<th>名称</th>
				<th>选择社区</th>
				<th>成立日期</th>
				<th>负责人</th>
				<th>联系电话</th>
				<th>通讯地址</th>
				<shiro:hasPermission name="partyteam:ccmPartyVolunteerTeam:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPartyVolunteerTeam">
			<tr>
				<td><a onclick="parent.parent.parent.LayerDialog('${ctx}/partyteam/ccmPartyVolunteerTeam/form?id=${ccmPartyVolunteerTeam.id}', '修改', '1230px', '600px')">
					${ccmPartyVolunteerTeam.name}
				</a></td>
				<td>
					${ccmPartyVolunteerTeam.community.name}
				</td>
				<td>
					<fmt:formatDate value="${ccmPartyVolunteerTeam.foundTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmPartyVolunteerTeam.user.id}
				</td>
				<td>
					${ccmPartyVolunteerTeam.telphone}
				</td>
				<td>
					${ccmPartyVolunteerTeam.address}
				</td>
				<shiro:hasPermission name="partyteam:ccmPartyVolunteerTeam:edit"><td>
    				<%--<a href="${ctx}/partyteam/ccmPartyVolunteerTeam/form?id=${ccmPartyVolunteerTeam.id}">修改</a>--%>
					<%--<a href="${ctx}/partyteam/ccmPartyVolunteerTeam/delete?id=${ccmPartyVolunteerTeam.id}" onclick="return confirmx('确认要删除该队伍管理吗？', this.href)">删除</a>--%>
						<a  class="btnList"
							onclick="parent.parent.parent.LayerDialog('${ctx}/partyteam/ccmPartyVolunteerTeam/form?id=${ccmPartyVolunteerTeam.id}', '修改', '1230px', '600px')"><i class="icon-pencil"></i></a>
						<a  class="btnList"
							href="${ctx}/partyteam/ccmPartyVolunteerTeam/delete?id=${ccmPartyVolunteerTeam.id}"
							onclick="return confirmx('确认要删除该队伍信息管理吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>