<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>盘点单管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
<!-- 表格试表单css -->
<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.css">
<script src="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<style type="text/css">
.input-select {
	width: 220px;
}
</style>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						//$("#name").focus();
						$('#btnSubmit').click(function(){
							$('#inputForm').submit();
						});
						$("#inputForm").validate(
								{
									submitHandler : function(form) {
										$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
										form.submit();
									},
									errorContainer : "#messageBox",
									errorPlacement : function(error, element) {
										$("#btnSubmit").removeAttr('disabled');
					$("#messageBox").text("输入有误，请先更正。");
										if (element.is(":checkbox")
												|| element.is(":radio")
												|| element.parent().is(
														".input-append")) {
											error.appendTo(element.parent()
													.parent());
										} else {
											error.insertAfter(element);
										}
									}
								});
						

						$("#checkDetail").dialog({
							autoOpen : false,
							closeOnEscape : false,
							height : 500,
							width : 1100,
							modal : true,
							close : function() {
								$(this).dialog("close");
								$("#checkForm")[0].click();
							}
						});
						$("#check")
								.on(
										"click",
										function() {
											var src = "${ctx}/storage/plmCheck/checkInfo?id=${plmCheck.id}";
											$("#checkDetail").attr("src", src);
											$("#checkDetail").dialog("open");
											$("#checkDetail").css({
												"width" : "98%"
											});
										});
						$("#btnSubmit").on("click", function(){
							$("#status").val("2");
							$("#inputForm").submit();
						});
					});
		    function  closeDialog () {
		    	$("#checkDetail").dialog("close");
			}
</script>
	<%--引入文本框外部样式--%>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/storage/plmCheck/">盘点单列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" id="checkForm"
			href="${ctx}/storage/plmCheck/form?id=${plmCheck.id}">盘点单<shiro:hasPermission
					name="storage:plmCheck:edit">${not empty plmCheck.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="storage:plmCheck:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="plmCheck"
		action="${ctx}/storage/plmCheck/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="code" />
		<form:hidden path="status" />
		<sys:message content="${message}" />
		<div class="control-group head_Space">
			<h2>盘点单信息表</h2>
		</div>
		<table id="table" class="table   table-condensed first_table" >
			<tr>
				<td class="trtop"><span class="help-inline"><font color="red">*</font> </span>盘点主题	</td>
				<td><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '1'}">
							<form:input path="title" htmlEscape="false" maxlength="256"
								class="input-xlarge required" />
						
						</c:when>
						<c:otherwise>
							<label>${plmCheck.title}</label>
						</c:otherwise>
					</c:choose></td>
				<td class="trtop">编号(系统生成)</td>
				<td>${plmCheck.code}</td>
			</tr>
			<tr>
				<td class="trtop"><span class="help-inline"><font color="red">*</font> </span>盘点开始时间</td>
				<td><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '1'}">
							<input id="checkDateStart" name="checkDateStart" type="text" readonly="readonly"
								maxlength="20" class="input-medium Wdate required"
								value="<fmt:formatDate value="${plmCheck.checkDateStart}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" />
							
						</c:when>
						<c:otherwise>
							<label><fmt:formatDate value="${plmCheck.checkDateStart}"
									pattern="yyyy-MM-dd HH:mm:ss" /></label>
						</c:otherwise>
					</c:choose></td>
				<td class="trtop"><span class="help-inline"><font color="red">*</font> </span>盘点结束时间</td>
				<td><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '1'}">
							<input id="checkDateEnd" name="checkDateEnd" type="text" readonly="readonly"
								maxlength="20" class="input-medium Wdate required"  compareDate="#checkDateStart"
								value="<fmt:formatDate value="${plmCheck.checkDateEnd}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" />
							
						</c:when>
						<c:otherwise>
							<label><fmt:formatDate value="${plmCheck.checkDateEnd}"
									pattern="yyyy-MM-dd HH:mm:ss" /></label>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<td class="trtop">盘点物资类型</td>
				<td><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '1'}">
							<form:select path="type" class="input-xlarge required">
								<form:option value="" label="未选择" />
								<form:options items="${fns:getDictList('plm_equipment_type')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</c:when>
						<c:otherwise>
											${fns:getDictLabel(plmCheck.type, 'plm_equipment_type', '不限')}
										</c:otherwise>
					</c:choose></td>
				<td class="trtop">盘点物资子类</td>
				<td><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '1'}">
							<form:select path="typeChild" class="input-xlarge ">
								<form:option value="" label="未选择" />
								<form:options
									items="${fns:getDictList('plm_equipment_type_child')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</c:when>
						<c:otherwise>
							<label>${fns:getDictLabel(plmCheck.typeChild, 'plm_equipment_type_child', '不限')}</label>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<td class="trtop">盘点状态</td>
				<td>
					<form:select path="status" class="input-xlarge ">
								<form:option value="" label="未选择" />
								<form:options
									items="${fns:getDictList('check_status')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
					
				<td class="trtop">盘点仓库</td>
				<td><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '3'}">
							<sys:treeselect id="storage" name="storage.id"
								value="${plmCheck.storage.id}" labelName="storage.name"
								labelValue="${plmCheck.storage.name}" title="仓库"
								url="/storage/plmStorage/treeData" cssClass="input-select"
								allowClear="true" />
						</c:when>
						<c:otherwise>
							<label>${plmCheck.storage.name}</label>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<td class="trtop">盘点计划</td>
				<td colspan="4"><c:choose>
						<c:when test="${empty plmCheck.id || plmCheck.status == '1'}">
							<form:textarea path="content" htmlEscape="false" rows="4"
								maxlength="512" class="input-xxlarge " />
						</c:when>
						<c:otherwise>
							<p>${plmCheck.content}</p>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<td class="trtop">备注</td>
				<td colspan="4"><form:textarea path="remarks"
						htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " /></td>
			</tr>
		</table>
		<div class="form-actions">
			<c:if test="${empty plmCheck.id || plmCheck.status == '1'}">
				<shiro:hasPermission name="storage:plmCheck:edit">
					<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i ></i>保存</a>&nbsp;</shiro:hasPermission>
			</c:if>
			<c:if test="${plmCheck.status == '2'}">
				<a id="check" class="btn" ><i class=" icon-shopping-cart"></i>盘点</a>
			</c:if>
			<a href="${ctx}/storage/plmCheck/" class="btn"><i ></i>返 回</a>
		</div>
	</form:form>
	<iframe id="checkDetail" src=""></iframe>
</body>
</html>