<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>会议安排管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
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
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/logistics/plmRoomMeetingApplyResource/getroombyuserId">会议室安排</a></li>
		<c:if test="${update eq 'ok'}">
			<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/logistics/plmRoomMeetingApplyResource/form?id=${plmRoomApply.id}&update=ok">会议室安排<shiro:hasPermission name="logistics:plmRoom:edit">${not empty plmRoomApply.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="logistics:plmRoom:edit">查看</shiro:lacksPermission></a></li>
		</c:if>
		<c:if test="${update ne 'ok'}">
			<li class="active"><a href="${ctx}/logistics/plmRoomMeetingApplyResource/form?id=${plmRoomApply.id}">会议室安排详情查看</a></li>
		</c:if>
	</ul>
	<form:form id="inputForm" modelAttribute="plmRoomApply" action="${ctx}/logistics/plmRoomMeetingApplyResource/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;border-top-color: white">
			<tr>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">会议名称：</label>
						<div class="controls">
							<form:input path="subject" htmlEscape="false" maxlength="100" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">会议类型：</label>
						<div class="controls">
							<form:select path="type" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('plm_room_apply_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">开始时间：</label>
						<div class="controls">
							<input name="startTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
								value="<fmt:formatDate value="${plmRoomApply.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">结束时间：</label>
						<div class="controls">
							<input name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
								value="<fmt:formatDate value="${plmRoomApply.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">会议地点(会议室)：</label>
						<div class="controls">
							<form:select path="room" class="input-xlarge ">
								<form:options items="${roomlist}" itemLabel="subject" itemValue="id" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">与会总人数：</label>
						<div class="controls">
							<form:input path="number" htmlEscape="false" maxlength="6" class="input-xlarge number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">会议发起人：</label>
						<div class="controls">
							<sys:treeselect id="initiator" name="initiator" value="${plmRoomApply.initiator.id}" labelName="${plmRoomApply.initiator.name}" labelValue="${plmRoomApply.initiator.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</td>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">发起人联系方式：</label>
						<div class="controls">
							<form:input path="initiatorTel" htmlEscape="false" maxlength="20" class="input-xlarge phone"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">会议主持人：</label>
						<div class="controls">
							<sys:treeselect id="presider" name="presider" value="${plmRoomApply.presider.id}" labelName="${plmRoomApply.presider.name}" labelValue="${plmRoomApply.presider.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</td>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">会议记录人：</label>
						<div class="controls">
							<sys:treeselect id="recorder" name="recorder" value="${plmRoomApply.recorder.id}" labelName="${plmRoomApply.recorder.name}" labelValue="${plmRoomApply.recorder.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">详情：</label>
						<div class="controls">
							<form:textarea path="details" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
				<td style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">参会人员：</label>
						<div class="controls">
							<form:textarea path="files" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="padding: 10px; border: 0px dashed rgb(204, 204, 204);">
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
						</div>
					</div>
				</td>
			</tr>
		</table>
		<div class="form-actions">
			<c:if test="${update eq 'ok'}">
				<shiro:hasPermission name="logistics:plmRoom:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>