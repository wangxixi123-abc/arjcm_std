<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>重点地区排查整治管理</title>
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
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">社会治安</span>--%>
<div class="back-list">
	<div class="context" content="${ctx}"></div>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/event/ccmEventKacc/map">排查整治分析</a></li>
		<li class="active"><a class="nav-head" href="${ctx}/event/ccmEventKacc/">排查整治列表</a></li>
		<shiro:hasPermission name="event:ccmEventKacc:edit"><li><a href="${ctx}/event/ccmEventKacc/form">排查整治添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmEventKacc" action="${ctx}/event/ccmEventKacc/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label class="title-text">治安重点地区：</label>
				<form:input path="secuPlace" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="first-line"><label class="title-text">所属社区：</label>
				<sys:treeselect id="area" name="area.id" value="${ccmEventKacc.area.id}" labelName="area.name" labelValue="${ccmEventKacc.area.name}"
					title="区域" url="/tree/ccmTree/treeDataArea?type=6" cssClass="input-medium" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li class="first-line"><label class="title-text">治安突出问题：</label>
				<form:select path="secuProb" class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_sese_prob')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="first-line"><label class="title-text">涉及区域类型：</label>
				<form:select path="distType" class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_touc_regi')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="first-line"><label class="title-text">效果评估：</label>
				<form:select path="resuAsse" class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_impa_eval')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>


	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
			<i></i> <span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>治安重点地区</th>
				<th>所属社区</th>
				<th>治安突出问题</th>
				<th>涉及区域类型</th>
				<th>效果评估</th>
				<th>整治牵头单位</th>
				<th>整治牵头单位负责人姓名</th>
				<shiro:hasPermission name="event:ccmEventKacc:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmEventKacc">
			<tr>
				<td style="height: 50px"><a href="${ctx}/event/ccmEventKacc/form?id=${ccmEventKacc.id}">
					${ccmEventKacc.secuPlace}
				</a></td>
				<td style="height: 50px">
					${ccmEventKacc.area.name}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmEventKacc.secuProb, 'ccm_sese_prob', '')}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmEventKacc.distType, 'ccm_touc_regi', '')}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmEventKacc.resuAsse, 'ccm_impa_eval', '')}
				</td>
				<td style="height: 50px">
					${ccmEventKacc.compLead}
				</td>
				<td style="height: 50px">
					${ccmEventKacc.compPrinName}
				</td>
				<shiro:hasPermission name="event:ccmEventKacc:edit"><td style="height: 50px">
    				<a class="btnList" href="${ctx}/event/ccmEventKacc/form?id=${ccmEventKacc.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/event/ccmEventKacc/delete?id=${ccmEventKacc.id}" onclick="return confirmx('确认要删除该重点地区排查整治吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>