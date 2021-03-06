<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>社工签到管理</title>
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

		function getAreaPointMap(id){
			var context = $(".context").attr("content");
			$.get(context+ "/worker/ccmWorkerSign/getSignAreaPoint?id="+id,function(data){
				if(data==""){
					top.$.jBox.tip("暂无位置信息");
				}else{
					windowOpen(context + "/worker/ccmWorkerSign/getSignAreaPointMap?id="+id,"位置信息",1000,700);
				}
			})
		}
	</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">网格员管理</span>--%>
<ul class="back-list">
	<div class="context" content="${ctx}"></div>
	<ul class="nav nav-tabs">
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/worker/ccmWorkerSign/">数据列表</a></li>
		<%-- <shiro:hasPermission name="worker:ccmWorkerSign:edit"><li><a href="${ctx}/worker/ccmWorkerSign/form">社工签到添加</a></li></shiro:hasPermission> --%>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmWorkerSign" action="${ctx}/worker/ccmWorkerSign/" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>人员：</label>
				<sys:treeselect id="user" name="user.id" value="${ccmWorkerSign.user.id}" labelName="user.name" labelValue="${ccmWorkerSign.user.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li class="first-line"><label>签到内容：</label>
				<form:input path="content" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li class="first-line"><label>签到类型：</label>
				<form:select path="type" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_worker_sign_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
		<%--	<li><label>签到状态：</label>
				<form:select path="status" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_worker_sign_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>--%>
			<li class="first-line"><label>签到开始日期：</label>
				<input name="beginSignDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmWorkerSign.beginSignDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> </li>
			<li class="first-line"><label>签到结束日期：</label>	<input name="endSignDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmWorkerSign.endSignDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>


<%--			<li class="clearfix"></li>--%>
		</ul>
        <div class="clearfix pull-right btn-box">

            <shiro:hasPermission name="worker:ccmWorkerSign:edit">
                <a href="${ctx}/worker/ccmWorkerSign/resform"
                   onclick="return confirmx('您确认签退吗？', this.href)" class="btn btn-export" style="width: 49px;display:inline-block;float: right;">
                    <i></i> <span>签退</span></a>
            </shiro:hasPermission>

            <shiro:hasPermission name="worker:ccmWorkerSign:edit">
                <a href="${ctx}/worker/ccmWorkerSign/getform"
                   onclick="return confirmx('您确认签到吗？', this.href)" class="btn btn-export" style="width: 49px;display:inline-block;float: right;">
                    <i></i><span style="font-size: 12px">签到</span>   </a>
            </shiro:hasPermission>
            <input id="btnSubmit" class="btn btn-primary" style="width: 75px;display:inline-block;float: right;margin-right: 15px" type="submit" value="查询"/>
        </div>
	<sys:message content="${message}"/>
	</form:form>

	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>人员</th>
				<th>签到内容</th>
				<th>签到类型</th>
				<!-- <th>签到状态</th> -->
				<th>签到时间</th>
				<shiro:hasPermission name="worker:ccmWorkerSign:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmWorkerSign">
			<tr>
				<td style="height: 50px"><a onclick="parent.parent.LayerDialog('${ctx}/worker/ccmWorkerSign/form?id=${ccmWorkerSign.id}&hide1=true&hide2=false', '详情', '500px', '275px')">
					${ccmWorkerSign.user.name}
				</a></td>
				<td style="height: 50px">
					${ccmWorkerSign.content}
				</td>
				<td style="height: 50px">
					${fns:getDictLabel(ccmWorkerSign.type, 'ccm_worker_sign_type', '')}
				</td>
				<%-- <td>
					${fns:getDictLabel(ccmWorkerSign.status, 'ccm_worker_sign_status', '')}
				</td> --%>
				<td style="height: 50px">
					<fmt:formatDate value="${ccmWorkerSign.signDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			<%-- 	<shiro:hasPermission name="worker:ccmWorkerSign:edit"><td>
    				<a href="${ctx}/worker/ccmWorkerSign/form?id=${ccmWorkerSign.id}">修改</a>
					<a href="${ctx}/worker/ccmWorkerSign/delete?id=${ccmWorkerSign.id}" onclick="return confirmx('确认要删除该社工签到吗？', this.href)">删除</a>
				</td></shiro:hasPermission> --%>
				<td style="height: 50px">
				<a class="btnList" onclick="parent.parent.LayerDialog('${ctx}/worker/ccmWorkerSign/form?id=${ccmWorkerSign.id}&hide1=true&hide2=false', '详情', '500px', '275px')" title="详情"><i class="icon-list-alt"></i></a>
				<a class="btnList" href="javascript:;" onclick="getAreaPointMap('${ccmWorkerSign.id}')"  title="位置信息"><i class="icon-map-marker "></i></a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>