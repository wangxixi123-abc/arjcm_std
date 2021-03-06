<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>公众信息上报管理</title>
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
		<li class="active"><a href="${ctx}/service/ccmServiceWechat/">数据列表</a></li>
		<%-- <shiro:hasPermission name="service:ccmServiceWechat:edit"><li><a href="${ctx}/service/ccmServiceWechat/form">公众信息上报添加</a></li></shiro:hasPermission> --%>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmServiceWechat" action="${ctx}/service/ccmServiceWechat/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>上报分类：</label>
				<form:select path="type" class="input-medium">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_service_wechat_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>事件描述：</label>
				<form:input path="content" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>状态：</label>
				<form:radiobuttons onclick="$('#searchForm').submit();" path="delFlag" items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false" />
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
				<th>上报分类</th>
				<th>事件描述</th>
				<th>姓名</th>
				<th>上报时间</th>
				<th>回复人</th>
				<th>回复内容</th>
				<th>回复时间</th>
				<shiro:hasPermission name="service:ccmServiceWechat:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmServiceWechat">
			<tr>
				<td>
					${fns:getDictLabel(ccmServiceWechat.type, 'ccm_service_wechat_type', '')}
				</a></td>
				<td>
					<a href="${ctx}/service/ccmServiceWechat/form?id=${ccmServiceWechat.id}">
						${fns:abbr(ccmServiceWechat.content,40)}
					</a>
				</td>
				<td>
					${ccmServiceWechat.name}
				</td>
				<td>
					<fmt:formatDate value="${ccmServiceWechat.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${ccmServiceWechat.reName}
				</td>
				<td>
					${fns:abbr(ccmServiceWechat.reContent,40)}
				</td>
				<td>
					<fmt:formatDate value="${ccmServiceWechat.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="service:ccmServiceWechat:edit"><td>
    				<a class="btnList" href="${ctx}/service/ccmServiceWechat/form?id=${ccmServiceWechat.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/service/ccmServiceWechat/delete?id=${ccmServiceWechat.id}" onclick="return confirmx('确认要删除该公众信息上报吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>