<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>建议意见箱管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript" src="${ctxStatic}/plm/opinion/supervise.js"></script>
<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
<!-- 表格试表单css -->
<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
<script type="text/javascript">
	$(document).ready(
			function() {
				//$("#name").focus();
				$("#inputForm")
						.validate(
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
				$("td").css({
					"padding" : "1%"
				});
				
				
				
			});
</script>
</head>
<body>
	<br />
	<form:form id="inputForm" modelAttribute="plmOpinion" style="margin: 0px 260px;"
		action="${ctx}/opinion/plmOpinion/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="procInsId" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<sys:message content="${message}" />
		<h2>建议意见信息</h2>
		<table id="table" class="table   table-condensed"
			style="table-layout: fixed;">
			<tr>
				<td class="trtop">标题名称<span class="help-inline"><font
						color="red">*</font> </span>
				</td>
				<td colspan="2">${plmOpinion.name }</td>
				<td class="trtop" style="text-align: center;width:250px; font-weight: 800">图片</td>
			</tr>
			<tr>
				<td class="trtop">主题名称<span class="help-inline"><font
						color="red">*</font> </span>
				</td>
				<td colspan="2">${plmOpinion.themeName }</td>
				<td class="trtop" rowspan="3"><input type="hidden" id="imgUrl"
					name="imgUrl" value="${plmOpinion.imgUrl}" /> <sys:ckfinder
						input="imgUrl" type="thumb" uploadPath="/opinion/plmOpinion"
						selectMultiple="false"  readonly="true"/></td>
			</tr>
			<tr>
				<td class="trtop">意见类型<span class="help-inline"><font
						color="red">*</font> </span>
				</td>
				<td colspan="2">${fns:getDictLabel(plmOpinion.type, 'plm_opinion_type', '')}</td>
			</tr>
			<tr>
				<td class="trtop">附件：</td>
				<td colspan="2"><form:hidden id="file" path="file"
						htmlEscape="false" maxlength="256" class="input-xlarge" /> <sys:ckfinder
						input="file" type="files" uploadPath="/opinion/plmOpinion"
						selectMultiple="true"  readonly="true"/></td>
			</tr>
			<tr>
				<td class="trtop">意见内容<span class="help-inline"><font
						color="red">*</font> </span>
				</td>
				<td colspan="3" id="bodyHtml">	
				${plmOpinion.body}
				</td>
			<script>
			$(document).ready(function() {
			   $("#bodyHtml").html( $("#bodyHtml").text())
			});
			</script>
			</tr>

			<tr>
				<td class="trtop">备注：</td>
				<td colspan="3"><form:textarea path="remarks"
						htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " /></td>
			</tr>
			<tr>
				<td class="trtop">是否督办</td>
				<td class="trtop">${fns:getDictLabel(plmOpinion.plmAct.isSup, 'yes_no', '')}</td>
				<td class="trtop">督办人</td>
				<td class="trtop">${plmOpinion.plmAct.supExe.name}</td>
			</tr>
			<tr>
				<td class="trtop">督办明细</td>
				<td colspan="3">${plmOpinion.plmAct.supDetail}</td>
			</tr>
			<act:histoicTable procInsId="${plmOpinion.procInsId}" colspan="3"
				titleColspan="1" />
		</table>
		<div class="form-actions">
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
</body>
</html>