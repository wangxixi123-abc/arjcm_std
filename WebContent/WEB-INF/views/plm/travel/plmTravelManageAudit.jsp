<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>出差申请表单管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
	<!-- 表格试表单css -->
	<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
	<script type="text/javascript" src="${ctxStatic}/plm/act/supervise.js"></script>	
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$('#btnSubmit').click(function(){
				$('#inputForm').submit();
			});
			$("#inputForm").validate({
				submitHandler: function(form){
					$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#btnSubmit").removeAttr('disabled');
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="plmTravelManage" action="${ctx}/travel/plmTravelManage/saveAudit" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="plmAct.id"/>
		<form:hidden path="plmAct.title"/>
		<form:hidden path="procInsId"/>
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}"/>		
		<h2>出差申请单</h2>
		<table id="tabletop" class="table">
			<tr>
				<td class="tabletop" colspan="2">申请编号:<u>&nbsp;&nbsp; &nbsp;&nbsp;<span>${plmTravelManage.code}</span>&nbsp;&nbsp; &nbsp;&nbsp;</u></td>
				<td class="tabletop" colspan="2">申请人:<u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmTravelManage.fldApplicant.name}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u></td>
				<td class="tabletop" colspan="2">所属部门:<u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmTravelManage.fldDept.name}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u></td>
				<td class="tabletop" colspan="2">申请日期： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span><fmt:formatDate value="${plmTravelManage.fldDt}" pattern="yyyy-MM-dd HH:mm:ss"/></span>&nbsp;&nbsp;&nbsp;&nbsp;</u></td>
			</tr>
		</table>
		<table id="table" class="table table-condensed">
			<tr>
				<td class="trtop" colspan="2">主题</td>
				<td colspan="6">${plmTravelManage.fldSubject}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">目的地</td>
				<td colspan="2">${plmTravelManage.fldDest}</td>
				<td class="trtop" colspan="2">交通工具</td>
				<td colspan="2">${plmTravelManage.fldTransport}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">出发时间</td>
				<td colspan="2"><fmt:formatDate value="${plmTravelManage.fldBdt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<td class="trtop" colspan="2">返回时间</td>
				<td colspan="2"><fmt:formatDate value="${plmTravelManage.fldEdt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">出差天数(天)</td>
				<td colspan="2">${plmTravelManage.fldDays}</td>
				<td class="trtop" colspan="2">借款总额(元)</td>
				<td colspan="2">${plmTravelManage.fldLoan}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">出差路线</td>
				<td colspan="6">${plmTravelManage.fldRoute}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">出差事由</td>
				<td colspan="6">${plmTravelManage.fldReason}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">备注信息</td>
				<td colspan="6">${plmTravelManage.remarks}</td>
			</tr>
			<c:if test="${plmTravelManage.plmAct.isSup eq '0'}">
				<tr>
					<td class="trtop" colspan="2">是否督办</td>
					<td colspan="6">${fns:getDictLabel(plmTravelManage.plmAct.isSup, 'yes_no', '')}</td>
				</tr>	
			</c:if>
			<c:if test="${plmTravelManage.plmAct.isSup eq '1'}">
				<tr>
					<td class="trtop" colspan="2">是否督办</td>
					<td colspan="2">${fns:getDictLabel(plmTravelManage.plmAct.isSup, 'yes_no', '')}</td>
					<td class="trtop" colspan="2">督办人</td>
					<td colspan="2">${plmTravelManage.plmAct.supExe.name}</td>
				</tr>		
				<tr>
					<td class="trtop" colspan="2">督办明细</td>
					<td colspan="6">${plmTravelManage.plmAct.supDetail}</td>
				</tr>
			</c:if>		
			<act:histoicTable procInsId="${plmTravelManage.procInsId}" colspan="6" titleColspan="2"/>
			<c:if test="${rejectedBtn}">
			<c:if test="${plmTravelManage.plmAct.isSup ne '1'}">
				<tr>
					<td class="trtop" colspan="2">是否添加督办</td>
					<td id="isSubTd" colspan="6">
						<form:radiobuttons path="plmAct.isSup" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
					</td>
					<td class="trtop isSup" colspan="2">督办人</td>
					<td class="isSup" colspan="2">
						<sys:treeselect id="supExe" name="plmAct.supExe.id" value="${plmTravelManage.plmAct.supExe.id}" labelName="plmAct.supExe.name" labelValue="${plmTravelManage.plmAct.supExe.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true" isAll="true"/>
					</td>
				</tr>		
				<tr class="isSup">
					<td class="trtop" colspan="2">督办明细</td>
					<td colspan="6">
						<form:textarea path="plmAct.supDetail" htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge "/>
					</td>
				</tr>		
			</c:if>	
			</c:if>
			<tr>
				<td class="trtop" colspan="2">您的意见</td>
				<td class="pingshen" colspan="6">
				   <form:textarea path="act.comment" htmlEscape="false" rows="5" maxlength="255" class="input-xxlarge "/>
				</td>				
			</tr>		
			<tr>
				<td class="trtop" colspan="2">附件</td>
				<td colspan="6">
					<form:hidden id="fldAccessory" path="fldAccessory" htmlEscape="false" maxlength="256" class="input-xlarge"/>
					<sys:ckfinder input="fldAccessory" type="files" uploadPath="/travel/plmTravelManage" selectMultiple="false" readonly="true"/>
				</td>
			</tr>
		</table>
		<div class="form-actions">
			<a id="btnConmit" class="btn btn-primary" onclick="$('#flag').val('yes')"><i class="icon-ok-sign"></i>同 意</a>&nbsp;
			<c:if test="${rejectedBtn}">
			<a id="btnCancel" class="btn btn-inverse" onclick="$('#flag').val('no')"><i class="icon-remove-sign"></i>驳 回</a>&nbsp;
			</c:if>
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
</body>
</html>