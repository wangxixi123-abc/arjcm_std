<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>党员活动管理管理</title>
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
		<%--<li><a href="${ctx}/partyactivity/ccmPartyActivity/">党员活动管理列表</a></li>--%>
		<%--<li class="active"><a href="${ctx}/partyactivity/ccmPartyActivity/form?id=${ccmPartyActivity.id}">党员活动管理<shiro:hasPermission name="partyactivity:ccmPartyActivity:edit">${not empty ccmPartyActivity.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="partyactivity:ccmPartyActivity:edit">查看</shiro:lacksPermission></a></li>--%>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmPartyActivity" action="${ctx}/partyactivity/ccmPartyActivity/save" method="post" class="form-horizontal">
		<div>
		<form:hidden path="id"/>
		<input id="type" name="type" type="hidden" value="2"/>
		<sys:message content="${message}"/>
			<table id="PartyPersonDetailTable" border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC" colspan="2">
						<div>
							<label class="control-label">社区（单位）：</label>
							<div class="controls">
								<sys:treeselect id="community" name="community" value="${ccmPartyActivity.community}" labelName="" labelValue="${ccmPartyActivity.community}"
												title="区域" url="/sys/area/treeData" cssClass="" allowClear="true" notAllowSelectParent="true" cssStyle="width:345px"/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC" >
						<div>
							<label class="control-label">活动时间：</label>
							<div class="controls">
								<input name="activitTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
									   value="<fmt:formatDate value="${ccmPartyActivity.activitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
						</div>
					</td>
					<td style="padding: 8px;border: 1px dashed #CCCCCC" >
						<div>
							<label class="control-label">选择组织：</label>
							<div class="controls">
								<%--<sys:treeselect id="organization" name="organization" value="${ccmPartyActivity.organization}" labelName="" labelValue="${ccmPartyActivity.organization}"
												title="部门" url="/sys/office/treeData?type=2" cssClass="" allowClear="true" notAllowSelectParent="true" />--%>
									<form:select path="organization" class="input-xlarge ">
										<form:option value="" label=""/>
										<form:options items="${list}" itemLabel="name" itemValue="id" htmlEscape="false"/>
									</form:select>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC"  colspan="2">
						<div>
							<label class="control-label">参加党员情况：</label>
							<label  style="padding-left: 20px;">应参加党员：</label>
							<form:input path="shouldJoinParty" htmlEscape="false" maxlength="10" class="input-xlarge" style="width:30px"/> &nbsp;人 ，
							<label >实际参加党员：</label>
							<form:input path="realityJoinParyt" htmlEscape="false" maxlength="10" class="input-xlarge" style="width:30px"/> &nbsp;人 ，
							<label >请假人员名称：</label>
							<form:input path="leavePersonId" htmlEscape="false" maxlength="500" class="input-xlarge" style="width:410px" />
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC"  colspan="2">
						<div>
							<label class="control-label">活动主题：</label>
							<div class="controls">
								<form:input path="activitTitle" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge " style="width:400px"/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC"  colspan="2">
						<div>
							<label class="control-label">活动内容：</label>
							<div class="controls">
								<form:textarea path="activitContent" htmlEscape="false" rows="4" class="input-xxlarge " style="width:863px"/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC"  colspan="2">
						<div>
							<label class="control-label">简介：</label>
							<div class="controls">
								<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " style="width:863px"/>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="partyactivity:ccmPartyActivity:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭"/>
		</div>
	</form:form>
</body>
</html>