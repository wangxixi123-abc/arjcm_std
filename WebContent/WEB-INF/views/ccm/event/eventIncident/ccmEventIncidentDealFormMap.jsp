<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>事件处理管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />

	<script type="text/javascript">
		function saveForm(){
			var handleUserId = $("#handleUserId").val();
			var html1 = '<label for="" class="error">必填信息 *<label>';
			//alert(officeId.length);
			if(handleUserId.length!=0){
				$("#show1").html("*");
			}else{
				$("#show1").html(html1);
			}

			
			if(handleUserId.length!=0){
				$("#inputForm").submit();
				parent.TodayHandleDialogLayerClose()
			}
		
			
		}
		 $(document).ready(
				 	function() {
							// $("#name").focus();
							$("#inputForm").validate(
							{
								submitHandler : function(form) {
									//loading('正在提交，请稍等...');
									form.submit();
									top.layer.close(top.layer.getFrameIndex(window.name));
								},
								errorContainer : "#messageBox",
								errorPlacement : function(error, element) {
									$("#btnSubmit").removeAttr('disabled');
					$("#messageBox").text("输入有误，请先更正。");
									if (element.is(":checkbox") || element.is(":radio")
										|| element.parent().is(".input-append")) {
										error.appendTo(element.parent().parent());
								} else {
									error.insertAfter(element);
								}
							}
						});
					});
	</script>
	<style type="text/css">
		td{padding: 8px;border: 1px dashed #CCCCCC}
	</style>
</head>
<body>
    <br />
    <form:form id="inputForm" modelAttribute="ccmEventCasedeal"
        action="${ctx}/event/ccmEventCasedeal/saveCasedealCommonMap" method="post"
        class="form-horizontal">
        <form:hidden path="id" />
        <form:hidden path="objId" />
        <form:hidden path="objType" />
        <form:hidden path="handleDate" />
        <form:hidden path="handleStep" />
        <input id="handleStatus" name="handleStatus" type="hidden" value="01"/>
        <form:hidden path="handleFeedback" />
        <form:hidden path="checkDate" />
        <form:hidden path="checkUser" />
        <form:hidden path="checkOpinion" />
        <form:hidden path="checkScore" />
        <sys:message content="${message}" />
        <table border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
				<label class="control-label">处理人员：</label>
				<div class="controls">
					<sys:treeselect id="handleUser" name="handleUser.id" value="${ccmEventCasedeal.handleUser.id}" labelName="handleUser.name" labelValue="${ccmEventCasedeal.handleUser.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true"/>
					<span class="help-inline"><font color="red" id="show1">*</font> </span>
				</div>
				</td>
			</tr>
			<tr>
				<td>
				<label class="control-label">处理截至时间：</label>
				<div class="controls">
					<input name="handleDeadline" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
						value="<fmt:formatDate value="${ccmEventCasedeal.handleDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
				</td>
			</tr>
			<tr>
				<td>
				<label class="control-label">是否督办：</label>
				<div class="controls">
					<form:select path="isSupervise" class="input-xlarge required">
						<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
				</td>
			</tr>
			<tr>
				<td>
				<label class="control-label">事件说明及任务安排：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="8" maxlength="1000" class="input-xxlarge "/>
				</div>
				</td>
			</tr>
			
			
			<!--  进行事件分流处理时，下述不显示
			<div class="control-group">
				<label class="control-label">处理时间：</label>
				<div class="controls">
					<input name="handleDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${ccmEventCasedeal.handleDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">处理措施：</label>
				<div class="controls">
					<form:textarea path="handleStep" htmlEscape="false" rows="8" maxlength="256" class="input-xxlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">任务处理状态：</label>
				<div class="controls">
					<form:select path="handleStatus" class="input-xlarge ">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('ccm_event_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">案事件反馈：</label>
				<div class="controls">
					<form:textarea path="handleFeedback" htmlEscape="false" rows="8" maxlength="256" class="input-xxlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">考评日期：</label>
				<div class="controls">
					<input name="checkDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${ccmEventCasedeal.checkDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">考评人员：</label>
				<div class="controls">
					<form:input path="checkUser" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">考评意见：</label>
				<div class="controls">
					<form:input path="checkOpinion" htmlEscape="false" maxlength="256" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">得分：</label>
				<div class="controls">
					<form:input path="checkScore" htmlEscape="false" maxlength="4" class="input-xlarge "/>
				</div>
			</div>
			
			 -->
			
		</table>
			
        <div class="form-actions">
            <shiro:hasPermission name="event:ccmEventCasedeal:edit">
                <input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button"
                    value="保 存" />&nbsp;</shiro:hasPermission>
        </div>
    </form:form>
</body>
</html>