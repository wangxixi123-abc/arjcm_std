<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>公文管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
	<!-- 表格试表单css -->
	<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
	<script type="text/javascript" src="${ctxStatic}/plm/act/supervise.js"></script>	
	<script type="text/javascript">
			$(function(){
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
	<form:form id="inputForm"  modelAttribute="plmOfficialDocument" action="${ctx}/travel/plmOfficialDocument/saveAudit" method="post" class="form-horizontal">
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
		<h2>公文收发申请单</h2>
		<table id="tabletop" class="table">
			<tr>
				<td class="tabletop" colspan="3">申请编号:<u>&nbsp;&nbsp; &nbsp;&nbsp;<span>${plmOfficialDocument.code}</span>&nbsp;&nbsp; &nbsp;&nbsp;</u></td>
				<td class="tabletop" colspan="2">密级:<u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${fns:getDictLabel(plmOfficialDocument.confidentiality, 'confident_type', '未选择')}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u></td>
				<td class="tabletop" colspan="3">申请日期： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span><fmt:formatDate value="${plmOfficialDocument.date}" pattern="yyyy-MM-dd"/></span>&nbsp;&nbsp;&nbsp;&nbsp;</u></td>
			</tr>
		</table>
		<table id="table" class="table table-condensed">
			<tr>
				<td class="trtop" colspan="2">标题</td>
				<td colspan="6">${plmOfficialDocument.title}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">文案类型</td>
				<td colspan="2">${fns:getDictLabel(plmOfficialDocument.documentType, 'official_doc_type', '未选择')}</td>
				<td class="trtop" colspan="2">保密期限</td>
				<td colspan="2">${fns:getDictLabel(plmOfficialDocument.deadline, 'deadline_type', '未选择')}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">紧急程度</td>
				<td colspan="2">${fns:getDictLabel(plmOfficialDocument.urgent, 'urgent_type', '未选择')}</td>
				<td class="trtop" colspan="2">发送单位</td>
				<td colspan="2">${plmOfficialDocument.fromDept.name}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">联合行文单位</td>
				<td colspan="2">${plmOfficialDocument.associatedDept.name}</td>
				<td class="trtop" colspan="2">接收单位</td>
				<td colspan="2">${plmOfficialDocument.toDept.name}</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">备注信息</td>
				<td colspan="6">${plmOfficialDocument.remarks}</td>
			</tr>
			<c:if test="${plmOfficialDocument.plmAct.isSup eq '0'}">
				<tr>
					<td class="trtop" colspan="2">是否督办</td>
					<td colspan="6">${fns:getDictLabel(plmOfficialDocument.plmAct.isSup, 'yes_no', '')}</td>
				</tr>	
			</c:if>
			<c:if test="${plmOfficialDocument.plmAct.isSup eq '1'}">
				<tr>
					<td class="trtop" colspan="2">是否督办</td>
					<td colspan="2">${fns:getDictLabel(plmOfficialDocument.plmAct.isSup, 'yes_no', '')}</td>
					<td class="trtop" colspan="2">督办人</td>
					<td colspan="2">${plmOfficialDocument.plmAct.supExe.name}</td>
				</tr>		
				<tr>
					<td class="trtop" colspan="2">督办明细</td>
					<td colspan="6">${plmOfficialDocument.plmAct.supDetail}</td>
				</tr>
			</c:if>		
			<act:histoicTable procInsId="${plmOfficialDocument.procInsId}" colspan="6" titleColspan="2"/>
				<c:if test="${rejectedBtn}">
			<c:if test="${plmOfficialDocument.plmAct.isSup ne '1'}">
				<tr>
					<td class="trtop" colspan="2">是否添加督办</td>
					<td id="isSubTd" colspan="2">
						<form:radiobuttons path="plmAct.isSup" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
					</td>
					<td class="trtop isSup" colspan="2">督办人</td>
					<td class="isSup" colspan="2">
						<sys:treeselect id="supExe" name="plmAct.supExe.id" value="${plmOfficialDocument.plmAct.supExe.id}" labelName="plmAct.supExe.name" labelValue="${plmOfficialDocument.plmAct.supExe.name}"
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
					<form:hidden id="file" path="file" htmlEscape="false" maxlength="4000" class="input-xlarge"/>
					<sys:ckfinder input="file" type="files" uploadPath="/travel/plmOfficialDocument" selectMultiple="false" readonly="true"/>
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