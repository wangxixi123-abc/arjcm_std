<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>宣传信息管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
            $('#btnSubmit').click(function(){
                $('#searchForm').submit();
            });
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
		<li class="active"style="width: 140px"><a class="nav-head" href="${ctx}/publicity/ccmLogPublicity/">数据列表</a></li>
		<shiro:hasPermission name="publicity:ccmLogPublicity:edit"><li><a style="width: 140px;text-align:center" href="${ctx}/publicity/ccmLogPublicity/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmLogPublicity" action="${ctx}/publicity/ccmLogPublicity/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li><label>标题：</label>
				<form:input path="title" htmlEscape="false" maxlength="200" class="input-medium"/>
			</li>
			<li><label>宣传类型：</label>
				<form:select path="type" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_log_publiciy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>宣传状态：</label>
				<form:select path="status" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_log_publiciy_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>

			<%--<li class="clearfix"></li>--%>
			<%--<li class="clearfix"></li>--%>
			<%--<li class="clearfix"></li>--%>
				<%--<li class="btns"><input id="btnSubmit" class="btn btn-export" style="width: 75px;display:inline-block;float: right;margin-left: 20px;margin-right: 14px;margin-bottom: 20px" type="submit" value="查询"/></li>--%>

		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
			<i></i><span style="font-size: 12px">查询</span>  </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>


	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>标题</th>
				<th>宣传类型</th>
				<th>宣传状态</th>
				<th>创建时间</th>
				<th>更新时间</th>
				<th>发布人</th>
				<shiro:hasPermission name="publicity:ccmLogPublicity:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmLogPublicity">
			<tr>
				<td style="height: 50px"><a href="${ctx}/publicity/ccmLogPublicity/form?id=${ccmLogPublicity.id}">
					${ccmLogPublicity.title}
				</a></td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmLogPublicity.type, 'ccm_log_publiciy_type', '')}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmLogPublicity.status, 'ccm_log_publiciy_status', '')}
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmLogPublicity.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmLogPublicity.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td style="height: 50px">
					${ccmLogPublicity.createBy.name}
				</td>
				<shiro:hasPermission name="publicity:ccmLogPublicity:edit"><td style="height: 50px">
					<c:if test="${user.id eq ccmLogPublicity.createBy.id or user.id eq '1'}">
						<a class="btnList" href="${ctx}/publicity/ccmLogPublicity/form?id=${ccmLogPublicity.id}"><i title="修改" class="icon-pencil"></i></a>
						<a class="btnList" href="${ctx}/publicity/ccmLogPublicity/delete?id=${ccmLogPublicity.id}" onclick="return confirmx('确认要删除该宣传信息吗？', this.href)"><i title="删除" class="icon-trash"></i> </a>
					</c:if>
					<c:if test="${user.id ne ccmLogPublicity.createBy.id and user.id ne '1'}">
						<a class="btnList" href="${ctx}/publicity/ccmLogPublicity/form?id=${ccmLogPublicity.id}"><i title="详情" class="icon-file"></i></a>
					</c:if>
    				<!-- <a href="${ctx}/publicity/ccmLogPublicity/form?id=${ccmLogPublicity.id}">修改</a>
					<a href="${ctx}/publicity/ccmLogPublicity/delete?id=${ccmLogPublicity.id}" onclick="return confirmx('确认要删除该宣传信息吗？', this.href)">删除</a> -->
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>