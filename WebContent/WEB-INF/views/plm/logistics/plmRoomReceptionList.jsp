<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>接待室</title>
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
<style type="text/css">
img {
	width: 130px;
	max-width: 150px;
}

p {
	margin: 0 27px 10px;
}
</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/logistics/plmRoom?category=02">接待室列表</a></li>
		<shiro:hasPermission name="logistics:plmRoom:edit">
			<li><a href="${ctx}/logistics/plmRoom/form">接待室添加</a></li>
		</shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="plmRoom"
		action="${ctx}/logistics/plmRoom/?category=02" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form">
			<li><label>接待室名称：</label> <form:input path="subject"
					htmlEscape="false" maxlength="64" class="input-medium" /></li>
			<li><label>使用状态：</label> <form:select path="state"
					class="input-medium">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('plm_room_state')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
			<li><label>座位数：</label> <form:input path="seat"
					htmlEscape="false" maxlength="6" class="input-medium" /></li>
			<li class="btns"><a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-search"></i> 查询</a></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}" />
	<!-- 列表缩略图切换按钮 -->
	<div id="switchbtn">
		<a class="thumbnailbtn"><i class="icon-th "></i></a>&nbsp; <a
			class="listbtn"> <i class="icon-th-list "></i></a>
	</div>
	<!--/列表缩略图切换按钮 -->
	<div id="prodInfo_List">
		<table id="contentTable"
			class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>接待室名称</th>
					<th>接待室地址/位置</th>
					<th>使用状态</th>
					<th>座位数</th>
					<th>更新时间</th>
					<th>备注信息</th>
					<shiro:hasPermission name="logistics:plmRoom:edit">
						<th>操作</th>
					</shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="plmRoom">
					<tr>
						<td><a href="${ctx}/logistics/plmRoom/form?id=${plmRoom.id}">
								${plmRoom.subject} </a></td>
						<td>${plmRoom.address}</td>
						<td>${fns:getDictLabel(plmRoom.state, 'plm_room_state', '')}
						</td>
						<td>${plmRoom.seat}</td>
						<td><fmt:formatDate value="${plmRoom.updateDate}"
								pattern="yyyy-MM-dd HH:mm:ss" /></td>
						<td class="tp">${plmRoom.remarks}</td>
						<td><shiro:hasPermission name="logistics:plmRoom:edit">
								<a class="btnList"
									href="${ctx}/logistics/plmRoom/form?id=${plmRoom.id}"
									title="修改"><i class="icon-pencil"></i></a>
								<a class="btnList"
									href="${ctx}/logistics/plmRoom/delete?id=${plmRoom.id}"
									onclick="return confirmx('确认要删除该会议室吗？', this.href)" title="删除"><i
									class="icon-trash"></i></a>
							</shiro:hasPermission> <a class="btnList"
							onclick="parent.LayerDialog('${ctx}/logistics/plmRoom/scheduList?id=${plmRoom.id}', '【${plmRoom.subject}】排期记录', '1200px', '800px')"
							title="排期记录"><i class="icon-fast-forward"></i></a></td>
					</tr>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<!-- 缩略图 -->
	<div id="prodInfo_small">
		<div class="row">
			<c:forEach items="${page.list}" var="plmRoom">
				<div class="span4 spandiv">
					<div class="thumbnail">
						<a href="${ctx}/logistics/plmRoom/form?id=${plmRoom.id}">
							<h4 title="${plmRoom.subject}">接待室名称：${plmRoom.subject}</h4>
						</a>
						<div class="caption row-fluid">
							<div class=" spanimg" style="width: 30%">
								<img src="${plmRoom.picture}"
									onerror='this.src="${ctxStatic}/common/list/images/timg.jpg"'
									alt="通用的占位符缩略图" />
							</div>
							<div class="spantext  " style="width: 63%; margin-left: 7%">
								<p
									title="${fns:getDictLabel(plmRoom.state, 'plm_room_state', '')}">使用状态:${fns:getDictLabel(plmRoom.state, 'plm_room_state', '')}</p>
								<p title="${plmRoom.seat}">座位数:${plmRoom.seat}</p>
								<p title="${plmRoom.address}">地址:${plmRoom.address}</p>
							</div>
						</div>
						<div class="footbtn" style="text-align: right;">
							<shiro:hasPermission name="logistics:plmRoom:edit">
								<a class="btnList"
									href="${ctx}/logistics/plmRoom/form?id=${plmRoom.id}"
									title="修改"><i class="icon-pencil"></i></a>
								<a class="btnList"
									href="${ctx}/logistics/plmRoom/delete?id=${plmRoom.id}"
									onclick="return confirmx('确认要删除该会议室吗？', this.href)" title="删除"><i
									class="icon-trash"></i></a>
							</shiro:hasPermission>
							<a class="btnList"
								onclick="parent.LayerDialog('${ctx}/logistics/plmRoom/scheduList?id=${plmRoom.id}', '【${plmRoom.subject}】排期记录', '1200px', '800px')"
								title="排期记录"><i class="icon-fast-forward"></i></a>
						</div>
					</div>
				</div>

			</c:forEach>
		</div>
	</div>
	<!-- /缩略图 -->
	<div class="pagination">${page}</div>
</body>
</html>