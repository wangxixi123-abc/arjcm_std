<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>物资申请管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript" src="${ctxStatic}/plm/act/supervise.js"></script>
<link type="text/css" href="${ctxStatic}/common/zztable.css"
	rel="stylesheet">
<%-- <link type="text/css" href="${ctxStatic}/common/zzformtable.css"
	rel="stylesheet"> --%>
	<link href="${ctxStatic}/form/css/formTable.css" rel="stylesheet" />
<link rel="stylesheet"
	href="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.css">
<script src="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript"
	src="${ctxStatic}/plm/storage/ajaxMessageAlert.js"></script>
<script type="text/javascript">
	$(document).ready(
				function() {
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
							}
							
					);
					
					$("#detail").on("click", "a", function() {
						if ($(this).attr("name") == "addDetail") {
							$(this).parent().parent().remove();
						}
					});
					$("#btnSubmit").on("click",function() {
						 if($("#detail").children().length<=0){
								messageAlert("请添加申请的装备信息！", "error");
							return false;
						 }else{
										$('#flag').val('yes');
										$("#inputForm").attr("action","${ctx}/equapply/plmEquApply/save");
										$("#inputForm").submit();
						 }
						});
					$("#btnSubmit2").on("click",function() {
										$('#flag').val('no');
										$("#inputForm")
												.attr("action",
														"${ctx}/equapply/plmEquApply/save");
										$("#inputForm").submit();
									});
					$("a[title='deleteDetail']").on(
							"click",
							function() {
								var id = $(this).next().attr("id");
								$.ajax({
									url : "${ctx}/equapply/plmEquApply/deleteDetail?ids=1",
									type : "post",
									data : {
										"id" : id
									},
									async : true,
									cache : false,
									timeout : 30000,
									success : function(data) {
										var content = jQuery.parseJSON(data);
										if (content === undefined || content == null
												|| content == "") {
											messageAlert("删除失败！", "error");
											return;
										}
										 if (content.ret != 0) {
											messageAlert(content.message, "error");
											return;
										} 
										messageAlert("删除成功！", "success");
										$("#" + id).parent().parent().remove();
									},
									error : function(jqXHR, textStatus, errorThrown) {
										messageAlert("删除失败！", "error");
										console.error("jqXHR:", jqXHR);
										console.error("textStatus:", textStatus);
										console.error("errorThrown:", errorThrown);
										top.$.jBox.closeTip();
									}
								});
							});
					$("#btnSubmit3").on("click",function() {
						 if($("#detail").children().length<=0){
							messageAlert("请添加申请的装备信息", "error");
							return false;
						 }else{
									$("#inputForm").attr("action","${ctx}/equapply/plmEquApply/notCommit");
									$("#inputForm").submit();
						 }
						});
					});
	
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
	//详情弹框--刷新父页面
	function LayerDialog(src, title, height, width) {
		layer.open({
			type : 2,
			title : title,
			area : [ height, width ],
			fixed : true, //固定
			maxmin : true,
			shade: false,
			content : src,
			end : function() {
			}
		});
	}
</script>
</head>
<body>
	<br />
	<form:form target="_parent"  id="inputForm" modelAttribute="plmEquApply"
		action="${ctx}/equapply/plmEquApply/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="type" />
		<form:hidden path="plmAct.id" />
		<form:hidden path="plmAct.title" />
		<form:hidden path="plmAct.tableName" />
		<form:hidden path="plmAct.tableId" />
		<form:hidden path="plmAct.formUrl" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}" />
		
		<h2>装备申请单</h2>
		
		<table id="tabletop" class="table  ">
			<tr>
				<td class="tabletop" colspan="3">申请人：<c:if
						test="${empty plmEquApply.user.id}">
						<sys:treeselect id="user" name="user.id"
							value="${fns:getUser().id}" labelName="user.name"
							labelValue="${fns:getUser().name}" title="用户"
							url="/sys/office/treeData?type=3" cssClass="" allowClear="true"
							notAllowSelectParent="true" />
					</c:if> <c:if test="${not empty plmEquApply.user.id}">
					${plmEquApply.user.name }
				</c:if></td>
				<td class="tabletop" colspan="3">申请人所在部门：<c:if
						test="${empty plmEquApply.user.id}">
				${fns:getUser().office.name}
				</c:if> <c:if test="${not empty plmEquApply.user.id}">
				${plmEquApply.user.office.name}
				</c:if></td>
				<td class="tabletop" colspan="3">申请日期：<input type="text"
					name="applyDate" id="today" readonly="readonly"  /> <script
						type="text/javascript">
						function today() {
							var today = new Date();
							var h = today.getFullYear();
							var m = today.getMonth() + 1;
							var d = today.getDate();
							return h + "-" + m + "-" + d;
						}
						document.getElementById("today").value = today();
					</script></td>
			</tr>
		</table>
		<table id="table" class="table   table-condensed">
			
			<tr>
				<td class="trtop">申请原因<span class="help-inline"><font
						color="red">*</font> </span>
				</td>
				<td colspan="8"><form:textarea path="applyBody"
						htmlEscape="false" rows="8" class="input-xxlarge required"
						cssStyle="width:76.296%" /></td>
			</tr>
			<tr>
				<td class="trtop">备注</td>
				<td colspan="8"><form:textarea path="remarks"
						htmlEscape="false" rows="6" maxlength="255" class="input-xxlarge "
						cssStyle="width:76.296%" /></td>
			</tr>
			<tr>
				<td class="trtop" colspan="9">
					<a title="addDetail" style="color: #fff; background-color: #19a7f0; width: 60px; height: 20px; background-repeat: no-repeat;"
					class="btn" onclick="LayerDialog('${ctx}/equapply/plmEquApply/findListBySpec', '添加装备', '80%', '80%')"><i class="icon-plus"></i>添加装备</a>
					</td>
			</tr>
			<tr>
				<td class="trtop" colspan="3">物品<font
						color="red">*</font></td>
				<td class="trtop" colspan="2">规格型号<font
						color="red">*</font></td>
				<td class="trtop" colspan="1">申请数量<font
						color="red">*</font></td>
				<td class="trtop" colspan="2">申请有效期<font
						color="red">*</font></td>
				<td class="trtop" colspan="1">操作</td>
			</tr>
			<tbody id="detail">
				<c:forEach items="${applyDetails}" var="plmEquApplyDetail">
					<tr>
						<td class="trtop" colspan="3">${plmEquApplyDetail.name}</td>
						<td class="trtop" colspan="2">${plmEquApplyDetail.spec}</td>
						<td class="trtop" colspan="1">${plmEquApplyDetail.number}</td>
						<td class="trtop" colspan="2"><fmt:formatDate value="${plmEquApplyDetail.validityDate}" pattern="yyyy-MM-dd"/></td>
						<td class="trtop" colspan="1"><a title="deleteDetail"><i class="icon-remove-sign"></i>删除</a>&nbsp;
						<input id="${plmEquApplyDetail.id}" type="hidden" value="${plmEquApplyDetail.id}"/>
						</td>
					</tr>
				</c:forEach>
			</tbody>
			<tr>
				<td class="trtop" colspan="3" style="width: 20%">是否督办</td>
				<td id="isSubTd" colspan="7"><form:radiobuttons
						path="plmAct.isSup" items="${fns:getDictList('yes_no')}"
						itemLabel="label" itemValue="value" htmlEscape="false" class="" />
				</td>
				<td class="trtop isSup" colspan="2" style="width: 20%">督办人</td>
				<td class="isSup" colspan="2" style="width: 30%"><sys:treeselect
						id="supExe" name="plmAct.supExe.id"
						value="${plmEquApply.plmAct.supExe.id}"
						labelName="plmAct.supExe.name"
						labelValue="${plmEquApply.plmAct.supExe.name}" title="用户"
						url="/sys/office/treeData?type=3" cssClass="" allowClear="true"
						notAllowSelectParent="true" isAll="true" /></td>
			</tr>
			<tr class="isSup">
				<td class="trtop" colspan="2">督办明细</td>
				<td colspan="7"><form:textarea path="plmAct.supDetail"
						htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge " />
				</td>
			</tr>
			<act:histoicTable procInsId="${plmEquApply.procInsId}" colspan="7"
				titleColspan="2" />
			<c:if test="${not empty plmEquApply.procInsId}">
				<tr>
					<td class="trtop" colspan="2">修改备注</td>
					<td colspan="7"><form:textarea path="act.comment"
							htmlEscape="false" rows="5" maxlength="255"
							class="input-xxlarge " /></td>
				</tr>
			</c:if>
		</table>
		<input name='details' type='hidden' value="">
		<div class="form-actions">
			
				<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-print"></i>提交申请</a>&nbsp;
				<c:if test="${not empty plmEquApply.procInsId}">
					<a id="btnSubmit2" class="btn btn-primary" href="javascript:;"><i class="icon-minus-sign"></i>销毁申请</a>&nbsp;
				</c:if>
				<c:if test="${ empty plmEquApply.procInsId}">
					<a id="btnSubmit3" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>&nbsp;
			</c:if>
			<c:if test="${not empty plmEquApply.id}">
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
			</c:if>
			<c:if test="${empty plmEquApply.id}">
			<a id="btnCancelf" class="btn btn-primary" href="javascript:;" onclick="parent.layer.closeAll();" ><i class="icon-remove-circle"></i>关闭</a>
			</c:if>
		</div>
	</form:form>
</body>
</html>