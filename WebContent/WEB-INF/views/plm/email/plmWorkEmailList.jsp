<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>工作日志管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript"
	src="${ctxStatic}/plm/storage/ajaxMessageAlert.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#btnSubmit").on("click", function() {
				var begin = new Date(Date.parse($("[name='beginDate']").val()));
			    var end = new Date(Date.parse($("[name='endDate']").val()));
			    if(begin.getTime() > end.getTime()){
			    	messageAlert("开始时间大于结束时间！", "error");
			    	return false;
			    }
			    $("#searchForm").submit();
			});
		});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
<script type="text/javascript" src="${ctxStatic}/plm/email/plmWorkEmailList.js"></script> 
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">事件管理</span>--%>
<ul class="back-list">
	<ul class="nav nav-tabs">
		<li class="active"><a class="nav-head" href="${ctx}/email/plmWorkEmail/?status=${status}">
		${status eq '1' ? '草稿箱' : '已发送'}&nbsp;(共${page.count}封)</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="plmWorkEmail"
		action="${ctx}/email/plmWorkEmail/?status=${status}" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line" ><label>主题：</label> <form:input path="title"
					htmlEscape="false" maxlength="100" class="input-medium" /></li>
			<li class="btns"></li>
			<li class="first-line"><label>发送开始日期：</label>
				<input name="beginDate" type="text"
				readonly="readonly" maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${plmWorkEmail.beginDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" /></li>
			<li class="first-line"><label>发送结束日期：</label>	<input name="endDate" type="text" readonly="readonly"
				maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${plmWorkEmail.endDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" />
			</li>

<%--				<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<li class="btns"><a id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;margin-left: 20px;margin-right: 14px;margin-bottom: 20px" href="javascript:;" ><i></i><span style="font-size: 12px">查询</span> </a></li>
	</div>
	</form:form>
	<sys:message content="${message}" />

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>主题</th>
				<th>发送时间</th>
				<c:if test="${status eq '0'}">
					<th>查阅状态</th>
				</c:if>
				<shiro:hasPermission name="email:plmWorkEmail:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="plmWorkEmail">
				<tr>
					<td  class="tp"style="height: 50px">
						<a href="${ctx}/email/plmWorkEmail/${plmWorkEmail.status eq '0' ? 'receive' : 'form'}?id=${plmWorkEmail.id}">
						${plmWorkEmail.title}</a>
					</td>
					<td style="height: 50px"><fmt:formatDate value="${plmWorkEmail.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
					<c:if test="${status eq '0'}">
						<td style="height: 50px"><c:if test="${plmWorkEmail.self}">
	                        ${fns:getDictLabel(oaNotify.readFlag, 'oa_notify_read', '')}
	                    </c:if> <c:if test="${!plmWorkEmail.self}">
	                    	<a onclick="parent.LayerDialog('${ctx}/email/plmWorkEmail/readStatusList?id=${plmWorkEmail.id}', '查阅状态', '800px', '500px')" ">
	                        ${plmWorkEmail.readNum} / ${plmWorkEmail.readNum + plmWorkEmail.unReadNum}</a>
	                    </c:if></td>
                    </c:if>
					<td style="height: 50px">
						<a class="star" emailId="${plmWorkEmail.id}" readStatus="">
							<img id="list${plmWorkEmail.id}" isStar="${plmWorkEmail.isStar eq '1'?0:1}" title="" style="margin-bottom: 3px" src="" ></a>
						<script type="text/javascript">
							var isStar = "${plmWorkEmail.isStar}";
							if(isStar==1){
								$("#list${plmWorkEmail.id}").attr("title","取消星标");
								$("#list${plmWorkEmail.id}").attr("src","${ctxStatic}/plm/email/images/star_yes.png");
							}else{
								$("#list${plmWorkEmail.id}").attr("title","添加星标");
								$("#list${plmWorkEmail.id}").attr("src","${ctxStatic}/plm/email/images/star_no.png");
							}
						</script>
						<a class="btnList" href="${ctx}/email/plmWorkEmail/delete?id=${plmWorkEmail.id}" title="删除"><i class="icon-remove-sign"></i></a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
	<ul>
</body>
</html>