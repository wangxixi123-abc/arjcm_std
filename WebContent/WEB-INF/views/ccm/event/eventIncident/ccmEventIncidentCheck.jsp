<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>事件管理</title>
    <meta name="decorator" content="default"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/ccm/event/css/ccmEventIncident.css"/>
    <script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
    <script src="${ctxStatic}/layer-v3.1.1/layer/layer.js" type="text/javascript"></script>
    <script src="${ctxStatic}/ccm/event/js/ccmEventIncident.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctxStatic}/plm/storage/ajaxMessageAlert.js"></script>
    <script type="text/javascript">
		$(document).ready(function() {
			//关闭弹框事件
			$('#btnCancel').click(function() {
				parent.layer.close(parent.layerIndex);
			});
		});
	</script>
</head>
<body>
	<div class="context" content="${ctx}"></div>
	<form:form id="searchForm" modelAttribute="ccmEventIncident" action="${ctx}/event/ccmEventIncident/listCheck" 
		method="post" class="breadcrumb form-search">
	    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
	    <input id="placeId" name="placeId" type="hidden" value="${ccmEventIncident.placeId}"/>
	    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	    <ul class="ul-form">
	        <li>
	        	<label class="first-line">事件名称：</label>
	        	<form:input path="caseName" htmlEscape="false" maxlength="100" class="input-medium"/>
	        </li>
	        <li>
	        	<label class="first-line">事件分级：</label>
	        	<form:select path="eventScale" class="input-medium">
	            	<form:option value="" label="全部"/>
	            	<form:options items="${fns:getDictList('ccm_case_grad')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
	        	</form:select>
	        </li>
	        <li>
	        	<label class="first-line">事件类型：</label>
	        	<form:select path="eventType" class="input-medium">
		            <form:option value="" label="全部"/>
		            <form:options items="${fns:getDictList('ccm_case_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
	        	</form:select>
	        </li>
	        <li class="second-line">
	        	<label >开始日期：</label>
	            <input name="beginHappenDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
	                   value="<fmt:formatDate value="${ccmEventIncident.beginHappenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/></li>
	           <li class="second-line"><label>结束日期:</label> <input name="endHappenDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
	                     value="<fmt:formatDate value="${ccmEventIncident.endHappenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
	                     onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
	        </li>
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
		        <th><input id="allboxs" onclick="allcheck()" type="checkbox"/></th>
		        <th width="14%">事件名称</th>
		        <th>发生日期</th>
		        <th>事件分级</th>
		        <th>事件类型</th>
		    </tr>
	    </thead>
	    <tbody>
		    <c:forEach items="${page.list}" var="ccmEventIncident">
		        <tr>
		            <td><input name="boxs" type="checkbox" value="${ccmEventIncident.id}"/></td>
		            <td>${ccmEventIncident.caseName}</td>
		            <td><fmt:formatDate value="${ccmEventIncident.happenDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
		            <td>${fns:getDictLabel(ccmEventIncident.eventScale, 'ccm_case_grad', '')}</td>
		            <td>${fns:getDictLabel(ccmEventIncident.eventType, 'ccm_case_type', '')}</td>
		        </tr>
		    </c:forEach>
	    </tbody>
	</table>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
	<div class="form-actions">
		<input id="btnSubmit" class="btn btn-primary" type="button" value="保 存" onclick="checkIncident()"/>&nbsp;
		<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭" />
	</div>
</body>
</html>