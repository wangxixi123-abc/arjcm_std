<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>盘点单管理</title>
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
<link rel="stylesheet"
	href="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.css">
<script src="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript"
	src="${ctxStatic}/plm/storage/ajaxMessageAlert.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#btnSubmit").on("click", function() {
				var begin = new Date(Date.parse($("[name='checkDateStart']").val()));
			    var end = new Date(Date.parse($("[name='checkDateEnd']").val()));
			    if(begin.getTime() > end.getTime()){
			    	messageAlert("开始时间大于结束时间！", "error");
			    	return false;
			    }
			    $("#searchForm").submit();
			});
				/* var sd = new Date();
				sd.setDate(sd.getDate() - 1);
				var sy = sd.getFullYear();
				var sm = sd.getMonth() + 1;
				var sdd = sd.getDate();
				if (sm >= 1 && sm <= 9) {
					sm = "0" + sm;
				}
				if (sdd >= 0 && sdd <= 9) {
					sdd = "0" + sdd;
				}

				var ed = new Date();
				ed.setDate(ed.getDate() + 1);
				var ey = ed.getFullYear();
				var em = ed.getMonth() + 1;
				var edd = ed.getDate();
				if (em >= 1 && em <= 9) {
					em = "0" + em;
				}
				if (edd >= 0 && edd <= 9) {
					edd = "0" + edd;
				}
				$("input[name='checkDateStart']").val(
						sy + "-" + sm + "-" + sdd + " 00:00:00");
				$("input[name='checkDateEnd']").val(
						ey + "-" + em + "-" + edd + " 00:00:00"); */

				$("#checkDetail").dialog({
					autoOpen : false,
					closeOnEscape : false,
					height : 500,
					width : 1100,
					modal : true,
					close : function() {
						$(this).dialog("close");
					}
				});
				$("a[title='check']").on(
						"click",
						function() {
							var src = "${ctx}/storage/plmCheck/checkInfo?id="
									+ this.id;
							$("#checkDetail").attr("src", src);
							$("#checkDetail").dialog("open");
							$("#checkDetail").css({
								"width" : "98%"
							});
						});
			});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">物资盘点</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/storage/plmCheck/">盘点单列表</a></li>
		<shiro:hasPermission name="storage:plmCheck:edit">
			<li><a style="width: 140px;text-align:center" href="${ctx}/storage/plmCheck/form">盘点单添加</a></li>
		</shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="plmCheck"
		action="${ctx}/storage/plmCheck/" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label>盘点开始时间：</label> <input name="checkDateStart"
				type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate"
				value="<fmt:formatDate value="${plmCheck.checkDateStart}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" />
			</li>
			<li class="first-line"><label>盘点结束时间：</label> <input name="checkDateEnd"
				type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate"
				value="<fmt:formatDate value="${plmCheck.checkDateEnd}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" />
			</li>
			<li class="first-line"><label>盘点主题：</label> <form:input path="title"
					htmlEscape="false" maxlength="256" class="input-medium" /></li>
			<li class="first-line"><label>盘点状态：</label> <form:select path="status"
					class="input-medium">
					<form:option value="" label="未选择" />
					<form:options items="${fns:getDictList('check_status')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>

			<%--<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" style="width: 49px;
   /*margin-top: 25px;*/display:inline-block;float: right;" class="btn btn-primary">
				<%--<i class="icon-search"></i> --%><span style="font-size: 12px">查询</span> </a>
	</div>
	</form:form>
	<sys:message content="${message}" />

	<!-- 列表缩略图切换按钮 -->
	<div id="switchbtn" style="margin-top: 15px">
		<a class="thumbnailbtn"><i class="icon-th "></i></a>&nbsp; <a
			class="listbtn" style="margin-right: 15px"> <i class="icon-th-list2 "></i></a>
	</div>

	<!--/列表缩略图切换按钮 -->
	<div id="prodInfo_List">
		<table id="contentTable"
			class="table table-striped table-bordered table-condensed table-gradient">
			<thead>
				<tr>
					<th>盘点主题</th>
					<th>盘点开始时间</th>
					<th>盘点结束时间</th>
					<th>编号</th>
					<th>盘点状态</th>
					<th>更新时间</th>
					<th>备注</th>
					<shiro:hasPermission name="storage:plmCheck:edit">
						<th>操作</th>
					</shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="plmCheck">
					<tr>
						<td style="height: 50px"><a href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}">
								${plmCheck.title} </a></td>
						<td style="height: 50px"><fmt:formatDate value="${plmCheck.checkDateStart}"
								pattern="yyyy-MM-dd HH:mm:ss" /></td>
						<td style="height: 50px"><fmt:formatDate value="${plmCheck.checkDateEnd}"
								pattern="yyyy-MM-dd HH:mm:ss" /></td>
						<td style="height: 50px">${plmCheck.code}</td>
						<td style="height: 50px">${fns:getDictLabel(plmCheck.status, 'check_status', '不限')}
						</td>
						<td style="height: 50px"><fmt:formatDate value="${plmCheck.updateDate}"
								pattern="yyyy-MM-dd HH:mm:ss" /></td>
						<td class="tp" style="height: 50px">${plmCheck.remarks}</td>
						<c:choose>
							<c:when test="${plmCheck.status == '1'}">
								<shiro:hasPermission name="storage:plmCheck:edit">
									<td style="height: 50px"><a
										href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}" class="btnList"><i title="修改" class="icon-pencil"></i></a> <a
										href="${ctx}/storage/plmCheck/delete?id=${plmCheck.id}"
										onclick="return confirmx('确认要删除该盘点单吗？', this.href)" class="btnList"><i title="删除" class="icon-trash"></i></a></td>
								</shiro:hasPermission>
							</c:when>
							<c:otherwise>
								<td style="height: 50px"><a
									href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}" class="btnList"><i title="查看" class="icon-file"></i></a>&nbsp;
									<c:if test="${plmCheck.status != '1'}">
										<a title="check" id="${plmCheck.id}" class="btnList"><i title="盘点" class="icon-search"></i></a>
									</c:if></td>
							</c:otherwise>
						</c:choose>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<!-- 缩略图 -->
	<ul style="padding-top: 50px">
	<div id="prodInfo_small">
		<div class="row">
			<c:forEach items="${page.list}" var="plmCheck">
				<div class="span4 spandiv">
					<div class="thumbnail">
						<a href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}">

							<h4 title="${plmCheck.title} ">盘点主题:${plmCheck.title}</h4>
						</a> </a>
						<div class="caption row-fluid">
							<div class=" spanimg" style="width: 30%">
								<img src="${ctxStatic}/common/index/images/index-bg.gif"
									onerror='this.src="${ctxStatic}/common/list/images/timg.jpg"'
									alt="通用的占位符缩略图" />
							</div>
							<div class="spantext  " style="width: 63%; margin-left: 7%">
								<p title="${plmCheck.code}">编号:${plmCheck.code}</p>
								<p
									title="${fns:getDictLabel(plmCheck.status, 'check_status', '不限')}">盘点状态:${fns:getDictLabel(plmCheck.status, 'check_status', '不限')}</p>
								<p
									title="<fmt:formatDate value="${plmCheck.checkDateStart}" pattern="yyyy-MM-dd"/>">
									盘点开始时间:
									<fmt:formatDate value="${plmCheck.checkDateStart}"
										pattern="yyyy-MM-dd" />
								</p>
							</div>
						</div>

						<div class="footbtn" style="text-align: right;">
							<c:choose>
								<c:when test="${plmCheck.status == '1'}">
									<shiro:hasPermission name="storage:plmCheck:edit">
										<a href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}" class="btnList"><i title="修改" class="icon-pencil"></i></a>
										<a href="${ctx}/storage/plmCheck/delete?id=${plmCheck.id}"
											onclick="return confirmx('确认要删除该盘点单吗？', this.href)" class="btnList"><i title="删除" class="icon-trash"></i></a>
									</shiro:hasPermission>
								</c:when>
								<c:otherwise>
									<a href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}" class="btnList"><i title="查看" class="icon-file"></i></a>&nbsp;
							<c:if test="${plmCheck.status != '1'}">
										<a title="check" id="${plmCheck.id}" class="btnList"><i title="盘点" class="icon-search"></i></a>
									</c:if>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>

			</c:forEach>
		</div>
	</div>
	</ul>
	<!-- /缩略图 -->
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
	<iframe id="checkDetail" src=""></iframe>
</body>
</html>