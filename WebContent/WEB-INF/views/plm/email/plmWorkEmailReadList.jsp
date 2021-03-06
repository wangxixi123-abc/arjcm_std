<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>工作日志记录管理</title>
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
<style type="text/css">
.treeSelect-medium{
	width:130px;
}
</style>
</head>

<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">事件管理</span>--%>
<ul class="back-list">
	<ul class="nav nav-tabs">
	<li class="active"><a class="nav-head" href="${ctx}/email/plmWorkEmail/self?readStatus=${readStatus}&view=${view}">
	${readStatus eq '1' ? (view ? '星标邮件' : '收件箱') : '已删除'}&nbsp;
	<c:if test="${readStatus eq '1' && !view}" var="condition">(共${totalNum}封,其中<span style="color: red">&nbsp;未读邮件&nbsp;</span>${unReaadNum}封)</c:if>
	<c:if test="${!condition }">(共${page.count}封)</c:if>
	</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="plmWorkEmail" 
	action="${ctx}/email/plmWorkEmail/self?readStatus=${readStatus}&view=${view}" 
	method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label>主题：</label> <form:input path="title"
					htmlEscape="false" maxlength="100" class="input-medium" /></li>
			<c:if test="${readStatus eq '1' && !view}">	
				<li class="first-line"><label>查阅状态：</label> <form:select path="readFlag"
						class="input-medium">
						<form:option value="" label="全部" />
						<form:options items="${fns:getDictList('oa_notify_read')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select></li>
				<li class="first-line"><label>发件人：</label>
					<sys:treeselect id="createBy" name="createBy.id" value="${plmWorkEmail.createBy.id}" labelName="createBy.name" labelValue="${plmWorkEmail.createBy.name}"
					title="用户" url="/sys/office/treeData?type=3&isAll=true" cssClass="treeSelect-medium" allowClear="true" notAllowSelectParent="true" cssStyle="width: 158px" />
				</li>	
			</c:if>
			<li class="first-line"><label>发送开始日期：</label>
				<input name="beginDate" type="text"
				readonly="readonly" maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${plmWorkEmail.beginDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" /></li>
			<li class="first-line"><label>发送结束日期：</label>
                <input name="endDate" type="text" readonly="readonly"
				maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${plmWorkEmail.endDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" />
			</li>

<%--			<li class="clearfix"></li>--%>
		</ul>
	<div class="clearfix pull-right btn-box">
		<a id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;margin-left: 20px;margin-right: 14px;margin-bottom: 20px" href="javascript:;" ><i></i> <span style="font-size: 12px">查询</span></a>
	</div>
	</form:form>
	<sys:message content="${message}" />

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>主题</th>
				<th>发件人</th>
				<th>时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="plmWorkEmail">
				<tr>
					<td class="tp"style="height: 50px">
						<c:if test="${plmWorkEmail.readFlag eq '1'}"><img title="已读" src="${ctxStatic}/plm/email/images/read_yes.png">&nbsp;&nbsp;</c:if>
						<c:if test="${plmWorkEmail.readFlag eq '0'}"><img title="未读" src="${ctxStatic}/plm/email/images/read_no.png">&nbsp;&nbsp;<b></c:if>
						<c:if test="${plmWorkEmail.readFlag eq ''}"><img title="我的" src="${ctxStatic}/plm/email/images/own.png">&nbsp;&nbsp;</c:if>
						<c:if test="${plmWorkEmail.status eq '0'}">
							<c:if test="${plmWorkEmail.delFlag eq '1' || plmWorkEmail.readStatus eq '2' }" var="condition">
								<a href="${ctx}/email/plmWorkEmail/receive?id=${plmWorkEmail.id}&readFlag=${plmWorkEmail.readFlag}&isDel=true">
							</c:if>
							<c:if test="${!condition}">
								<a href="${ctx}/email/plmWorkEmail/receive?id=${plmWorkEmail.id}&readFlag=${plmWorkEmail.readFlag}">
							</c:if>
						</c:if>
						<c:if test="${plmWorkEmail.status eq '1'}"><a href="${ctx}/email/plmWorkEmail/form?id=${plmWorkEmail.id}"></c:if>
						${plmWorkEmail.title}</a><c:if test="${plmWorkEmail.readFlag eq '0'}"></b></c:if>				
					</td>
					</td>
					<td style="height: 50px">${plmWorkEmail.createBy.name}</td>
					<td style="height: 50px"><fmt:formatDate value="${plmWorkEmail.createDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td style="height: 50px">
						<a class="star" emailId="${plmWorkEmail.id}" readStatus="${plmWorkEmail.readStatus eq ''?'':'self'}">
							<img id="list${plmWorkEmail.id}${plmWorkEmail.readStatus eq ''?'':'self'}" isStar="${plmWorkEmail.isStar eq '1'?0:1}" title="" style="margin-bottom: 3px" src="" ></a>
						<script type="text/javascript">
							var isStar = "${plmWorkEmail.isStar}";
							if(isStar==1){
								$("#list${plmWorkEmail.id}${plmWorkEmail.readStatus eq ''?'':'self'}").attr("title","取消星标");
								$("#list${plmWorkEmail.id}${plmWorkEmail.readStatus eq ''?'':'self'}").attr("src","${ctxStatic}/plm/email/images/star_yes.png");
							}else{
								$("#list${plmWorkEmail.id}${plmWorkEmail.readStatus eq ''?'':'self'}").attr("title","添加星标");
								$("#list${plmWorkEmail.id}${plmWorkEmail.readStatus eq ''?'':'self'}").attr("src","${ctxStatic}/plm/email/images/star_no.png");
							}
						</script>			
					
					
						<c:if test="${plmWorkEmail.readStatus eq '1'}">
							<a class="btnList" href="${ctx}/email/plmWorkEmail/self/delete?reportId=${plmWorkEmail.id}&view=${view ? true : false}" title="删除"><i class="icon-remove-sign"></i></a>
						</c:if>
						<c:if test="${plmWorkEmail.readStatus eq '2'}"> 
						
							<a class="btnList" href="${ctx}/email/plmWorkEmail/self/delete2?reportId=${plmWorkEmail.id}" 
							title="彻底删除" onclick="return confirmx('彻底删除后邮件将无法恢复，您确定要删除吗？', this.href)"><i class="icon-remove-sign"></i></a>
							
							<a class="btnList" href="${ctx}/email/plmWorkEmail/self/recover?reportId=${plmWorkEmail.id}" 
								title="还原" onclick="return confirmx('还原后邮件将保存到删除前位置，您确定要还原吗？', this.href)"><i class="icon-upload"></i></a>
							
						</c:if>
						<c:if test="${plmWorkEmail.readStatus eq ''}">
							<c:if test="${plmWorkEmail.delFlag eq '1'}">
								<a class="btnList" href="${ctx}/email/plmWorkEmail/delete2?id=${plmWorkEmail.id}" 
								title="彻底删除" onclick="return confirmx('彻底删除后邮件将无法恢复，您确定要删除吗？', this.href)"><i class="icon-remove-sign"></i></a>
								
								<a class="btnList" href="${ctx}/email/plmWorkEmail/recover?id=${plmWorkEmail.id}" 
								title="还原" onclick="return confirmx('还原后邮件将保存到删除前位置，您确定要还原吗？', this.href)"><i class="icon-retweet"></i></a>
								
							</c:if>
							<c:if test="${plmWorkEmail.delFlag eq '0'}">
								<a class="btnList" href="${ctx}/email/plmWorkEmail/delete?id=${plmWorkEmail.id}&view=${view ? true : false}" title="删除"><i class="icon-remove-sign"></i></a>
							</c:if>
						</c:if>
						
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>