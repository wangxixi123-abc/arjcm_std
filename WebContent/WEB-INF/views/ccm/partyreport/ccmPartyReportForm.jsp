<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>双报道情况管理管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			//关闭弹框事件
			$('#btnCancel').click(function() {
				parent.layer.close(parent.layerIndex);
			})
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
	<ul class="nav nav-tabs">
		<%--<li><a href="${ctx}/partyreport/ccmPartyReport/">双报道情况管理列表</a></li>
		<li class="active"><a href="${ctx}/partyreport/ccmPartyReport/form?id=${ccmPartyReport.id}">双报道情况管理<shiro:hasPermission name="partyreport:ccmPartyReport:edit">${not empty ccmPartyReport.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="partyreport:ccmPartyReport:edit">查看</shiro:lacksPermission></a></li>--%>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmPartyReport" action="${ctx}/partyreport/ccmPartyReport/save" method="post" class="form-horizontal">
	<div>
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
		<input id="type" name="type" type="hidden" value="${ccmPartyReport.type}"/>
		<table id="reportDetailTable" border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC" colspan="2">
					<div>
							<label class="control-label">选择社区：</label>
							<div class="controls">
								<sys:treeselect id="community" name="community" value="${ccmPartyReport.community}" labelName="" labelValue="${ccmPartyReport.community}"
												title="区域" url="/sys/area/treeData" cssClass="" allowClear="true" notAllowSelectParent="true"/>
							</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC" >
					<div>
						<c:if test="${ccmPartyReport.type == 1}">
							<label class="control-label">党组织：</label>
						</c:if>
						<c:if test="${ccmPartyReport.type == 2}">
							<label class="control-label">党  员：</label>
						</c:if>
						<div class="controls">
							<form:select path="orgParty" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${list}" itemLabel="name" itemValue="id" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC" >
					<div>
							<label class="control-label">报道时间：</label>
							<div class="controls">
								<input name="reportingTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
									   value="<fmt:formatDate value="${ccmPartyReport.reportingTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC" colspan="2">
					<div>
							<label class="control-label">简介：</label>
							<div class="controls">
								<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
							</div>
					</div>
				</td>
			</tr>
		</table>
	</div>



		<div class="form-actions">
			<shiro:hasPermission name="partyreport:ccmPartyReport:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭"/>
		</div>
	</form:form>
</body>
</html>