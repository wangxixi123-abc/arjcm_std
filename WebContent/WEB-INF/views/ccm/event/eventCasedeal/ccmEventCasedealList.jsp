<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<html>
<head>
<title>事件管理-任务处理</title>
<meta name="decorator" content="default" />
<link rel="stylesheet" href="${ctxStatic}/ccm/event/css/eventCasedeal.css" type="text/css">

<script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
<script src="${ctxStatic}/ccm/event/js/eventCasedeal.js" type="text/javascript"></script>
<link rel="stylesheet" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css"
	  rel="stylesheet" />
<script type="text/javascript" src="${ctxStatic}/layer-v3.1.1/layer/layer.js"></script>
<script type="text/javascript">
	function HandleTips(_this, id) {
		var html = '';
		html += '<div style="padding:10px;" >';
		html += '<p style="margin-botom:20px;">请做出选择</p>';
		html += '<div>';
		html += '<input id="btnSuccess" onclick="Pass('
				+ "&quot;"
				+ id
				+ "&quot;"
				+ ')" class="btn btn-primary " type="button" value="签收" style="background: #73a839">';
		html += '<input id="btnPass"  onclick="NoPass('
				+ "&quot;"
				+ id
				+ "&quot;"
				+ ')" class="btn btn-primary" type="button" value="拒绝" style="background: #c71c22">';
		html += '</div>';
		html += '</div>';
		tip_index = layer.tips(html, _this, {
			tips : [ 1, '#20c694' ],
			time : 3000,
		});
	}
	function Pass(id) {
		$.post('${ctx}/event/ccmEventCasedeal/signing?id='+ id,function(data){
			if(data.code == '200'){
				setTimeout(function () {
					window.location.reload();
				}, 1000);

				$.jBox.tip('操作成功！');

			}
		})
	}
	function NoPass(id) {
		$.post('${ctx}/event/ccmEventCasedeal/reject?id='+ id,function(data){
			if(data.code == '200'){
				setTimeout(function () {
					window.location.reload();
				}, 1000);

				$.jBox.tip('操作成功！');
			}
		})
	}
	function ArchiveTips(_this, id) {
		var html = '';
		html += '<div style="padding:10px;" >';
		html += '<p style="margin-botom:20px;">请确认事件归档</p>';
		html += '<div>';
		html += '<input id="btnSuccess" onclick="ArchivePass('
				+ "&quot;"
				+ id
				+ "&quot;"
				+ ')" class="btn btn-primary " type="button" value="确认" style="background: #73a839">';
		html += '<input id="btnPass"  onclick="ArchiveNoPass('
				+ "&quot;"
				+ id
				+ "&quot;"
				+ ')" class="btn btn-primary" type="button" value="取消" style="background: #c71c22">';
		html += '</div>';
		html += '</div>';
		tip_index = layer.tips(html, _this, {
			tips : [ 1, '#20c694' ],
			time : 3000,
		});
	}
	function ArchivePass(id) {
		$.post('${ctx}/event/ccmEventIncident/archiveIncident?id='+ id,function(data){
			if(data.code == '200'){
				setTimeout(function () {
					window.location.reload();
				}, 1000);

				$.jBox.tip('操作成功！');

			}
		})
	}
	function ArchiveNoPass(id) {
			layer.close(tip_index);
		<%--$.post('${ctx}/event/ccmEventCasedeal/reject?id='+ id,function(data){--%>
		<%--	if(data.code == '200'){--%>
		<%--		setTimeout(function () {--%>
		<%--			window.location.reload();--%>
		<%--		}, 1000);--%>

		<%--		$.jBox.tip('操作成功！');--%>
		<%--	}--%>
		<%--})--%>
	}
</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">事件管理</span>--%>
<ul class="back-list">
<div class="context" content="${ctx}"></div>
<%--<ul class="nav nav-tabs">
	<li class="active"><a href="${ctx}/event/ccmEventCasedeal/list">任务处理列表</a></li>
</ul>--%>
	<ul class="nav nav-tabs" >
<%--		<li style="float:right;"><a style="background-color:#9f3df8;color:white;" href="${ctx}/event/ccmEventCasedeal/supervise?isSupervise=1">督办事件</a></li>--%>
	    <li class="active"><a class="nav-head" href="${ctx}/event/ccmEventCasedeal/list">任务处理列表</a></li>
		<li style="float:right;"><a style="background-color:#73a839;color:white;" href="${ctx}/event/ccmEventCasedeal/?handleStatus=05">已办事件</a></li>
		<li style="float:right;"><a style="background-color:#eea807;color:white;" href="${ctx}/event/ccmEventCasedeal/?handleStatus=02">办理中事件</a></li>
		<li style="float:right;"><a style="background-color:#ec5c00;color:white;" href="${ctx}/event/ccmEventCasedeal/?handleStatus=01">待办事件</a></li>
		<li style="float:right;" class="active"><a style="background-color: #3bb4f2;color: white;" href="${ctx}/event/ccmEventCasedeal">事件处理列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmEventCasedeal"
		action="${ctx}/event/ccmEventCasedeal/" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label>截至时间开始：</label>
				<input name="beginHandleDeadline" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmEventCasedeal.beginHandleDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> 
		    </li>
			<li class="first-line"><label>截止时间结束：</label><input name="endHandleDeadline" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmEventCasedeal.endHandleDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li class="first-line"><label>事件名称：</label> <form:input path="caseName"
					htmlEscape="false" maxlength="64" class="input-medium" /></li>
<%--			<li><label>处理措施：</label> <form:input path="handleStep"--%>
<%--					htmlEscape="false" maxlength="64" class="input-medium" /></li>--%>
			<li class="first-line"><label>分类：</label>
				<form:select path="objType" class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_event_obj_table')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
<%--			<li><label>事件状态：</label>--%>
<%--				<form:select path="status" class="input-medium">--%>
<%--					<form:option value="" label="全部" />--%>
<%--					<form:options items="${fns:getDictList('ccm_event_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>--%>
<%--				</form:select>--%>
<%--			</li>--%>
			<li class="first-line"><label>任务处理状态：</label>
				<form:select path="handleStatus" class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_task_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<!-- 
			<li><label>处理人员：</label>
				<sys:treeselect id="handleUser" name="handleUser.id" value="${ccmEventCasedeal.handleUser.id}" labelName="handleUser.name" labelValue="${ccmEventCasedeal.handleUser.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>

	<sys:message content="${message}" />
	<div class="clearfix pull-right btn-box">

			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
				<i></i><span style="font-size: 12px">查询</span>  </a>

	</div>
	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>事件名称</th>
				<th>分类</th>
<%--				<th>事件状态</th>--%>
				<th>处理人员</th>
				<th>处理截至时间</th>
				<th>是否督办</th>
				<th>任务处理状态</th>
				<shiro:hasPermission name="event:ccmEventCasedeal:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="ccmEventCasedeal">
				<tr>
					<td style="height: 50px">
						<c:if test="${ccmEventCasedeal.objType eq 'ccm_event_incident'}">
							<a onclick="parent.LayerDialog('${ctx}/event/ccmEventIncident/detail?id=${ccmEventCasedeal.objId}', '案事件详情', '1100px', '700px')">
								${ccmEventCasedeal.caseName} </a>
						</c:if>
						<c:if test="${ccmEventCasedeal.objType eq 'ccm_event_ambi'}">
							<a onclick="parent.LayerDialog('${ctx}/event/ccmEventAmbi/detail?id=${ccmEventCasedeal.objId}', '矛盾纠纷详情', '1100px', '700px')">
								${ccmEventCasedeal.caseName} </a>
						</c:if>
						<c:if test="${ccmEventCasedeal.objType eq 'ccm_event_request'}">
							<a onclick="parent.LayerDialog('${ctx}/event/ccmEventRequest/detail?id=${ccmEventCasedeal.objId}', '请求详情', '1100px', '700px')">
								${ccmEventCasedeal.caseName} </a>
						</c:if>
						<c:if test="${ccmEventCasedeal.objType eq 'ccm_wechat_event'}">
							<a onclick="parent.LayerDialog('${ctx}/event/wechat/ccmWechatEvent/detail?id=${ccmEventCasedeal.objId}', '微信上报详情', '1100px', '700px')">
								${fns:abbr(ccmEventCasedeal.caseName,15)}</a>
						</c:if>
					</td>
					 
					<td style="height: 50px">
						${fns:getDictLabel(ccmEventCasedeal.objType, 'ccm_event_obj_table', '')}
					</td>
<%--					<td>--%>
<%--					<span class="eventScaleCss statusCss-${ccmEventCasedeal.status}">--%>
<%--						${fns:getDictLabel(ccmEventCasedeal.status, 'ccm_event_status', '')}--%>
<%--						</span>--%>
<%--					</td>--%>
					<td style="height: 50px">
						${ccmEventCasedeal.handleUser.name}
					</td>
					
					
					<td style="height: 50px">
						<c:choose>
							<c:when test="${ccmEventCasedeal.isExtension eq '1'}">
								<span style="color:#F00">
									<fmt:formatDate value="${ccmEventCasedeal.handleDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/>&nbsp;超期！
								</span>
							</c:when>
							<c:otherwise>
								<fmt:formatDate value="${ccmEventCasedeal.handleDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</c:otherwise>
						</c:choose>
					</td>
					
					
					<td style="height: 50px">
						${fns:getDictLabel(ccmEventCasedeal.isSupervise, 'yes_no', '')}
					</td>
					<td style="height: 50px">
						<span class="eventScaleCss statusCss-${ccmEventCasedeal.handleStatus}">
							${fns:getDictLabel(ccmEventCasedeal.handleStatus, 'ccm_task_status', '')}
						</span>
							<%--						<c:if test="${ccmEventCasedeal.manageType != null}">--%>
							<%--							<img src="${ctxStatic}/images/arrows.png"> --%>
							<%--							<span class="eventScaleCss statusCss-${ccmEventCasedeal.handleStatus}">--%>
							<%--								${fns:getDictLabel(ccmEventCasedeal.manageType, 'manage_type', '')}--%>
							<%--							</span>--%>
							<%--						</c:if>--%>
					</td>
					<shiro:hasPermission name="event:ccmEventCasedeal:edit">
						<td style="height: 50px">

						<a  class="btnList"
							onclick="parent.LayerDialog('${ctx}/event/ccmEventCasedeal/form?id=${ccmEventCasedeal.id}','处理', '1100px', '700px')"><i class="icon-pencil"></i></a>
						<a  class="btnList"
							href="${ctx}/event/ccmEventCasedeal/delete?id=${ccmEventCasedeal.id}"
							onclick="return confirmx('确认要删除该事件处理吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
						<a class="btnList" href="javascript:;" onclick="LocationOpen('${ccmEventCasedeal.objId}')"  title="位置信息"><i class="icon-map-marker "></i></a>
						<c:if test="${ccmEventCasedeal.handleStatus ne '01'}">
							<a  class="btnList" title="签收"><i class="icon-edit" style="color: #656565 ;"></i></a>
						</c:if>
						<c:if test="${ccmEventCasedeal.handleStatus eq '01'}">
							<a  class="btnList" onclick="HandleTips(this,'${ccmEventCasedeal.id}')" title="签收"><i class="icon-edit"></i></a>
						</c:if>
					</shiro:hasPermission>
					<shiro:hasPermission name="event:ccmEventCasedeal:archive">
						<c:if test="${ccmEventCasedeal.status ne '02'}">
						<a  class="btnList" onclick="ArchiveTips(this,'${ccmEventCasedeal.objId}')" title="归档"><i class="icon-bookmark"></i></a>
						</c:if>
						<c:if test="${ccmEventCasedeal.status eq '02'}">
						<a  class="btnList" title="归档"><i class="icon-bookmark" style="color: #000;"></i></a>
						</c:if>
					</shiro:hasPermission>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>