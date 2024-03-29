<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>事件处理考核</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
<link href="${ctxStatic}/layui/css/layui.css" rel="stylesheet" />
<script charset="utf-8" type="text/javascript" src="${ctxStatic}/ccm/validator/validatorBaseForm.js"></script>
<script type="text/javascript" src="${ctxStatic}/layui/layui.js"></script>
<script type="text/javascript" src="${ctxStatic}/common/common.js"></script>
<%-- <script charset="utf-8" type="text/javascript" src="${ctxStatic}/jquery/jquery-2.2.4.min.js"></script> --%>
<style type="text/css">
	td{padding: 8px;border: 0px dashed #CCCCCC}
</style>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
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
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
<%-- 		<li><a href="${ctx}/event/ccmEventCasedealCheck/list">事件处理列表</a></li> --%>
		<!--  相关的事件处理 -->
		<li class="active"><a
			href="${ctx}/event/ccmEventCasedealCheck/form?id=${ccmEventCasedeal.id}">事件处理考核<shiro:hasPermission
					name="event:ccmEventCasedealCheck:edit">${not empty ccmEventCasedeal.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="event:ccmEventCasedealCheck:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmEventCasedeal"
		action="${ctx}/event/ccmEventCasedealCheck/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="objId" />
		<form:hidden path="objType" />
		<sys:message content="${message}" />
		
		<h4 class="color-bg6">任务安排：</h4>
		<br>
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td style="width: 50%;" >
					<label class="control-label">处理人员：</label>
					<div class="controls">

					<input type="text" value="${ccmEventCasedeal.handleUser.name}">

					</div>
				</td>
				<td>
					<label class="control-label">处理人联系方式：</label>
					<div class="controls">
						<input type="text" value="${ccmEventCasedeal.handleUser.phone}">

					</div>
				</td>
			</tr>
			<tr>
				<td>
					<label class="control-label">处理截至时间：</label>
					<div class="controls">
						<input id="checkDate" name="checkDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
							   value="<fmt:formatDate value="${ccmEventCasedeal.handleDeadline}" pattern="yyyy-MM-dd"/>"
							   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

					</div>
				
				</td>
				<td>
					<label class="control-label">是否督办：</label>
					<div class="controls">
						${fns:getDictLabel(ccmEventCasedeal.isSupervise, 'yes_no', '')}
					</div>
				
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">附件上传：</label>
						<div class="controls">
							<form:hidden id="file" path="file" htmlEscape="false"
								maxlength="255" class="input-xlarge" />
							<sys:ckfinder input="file" type="images"
								uploadPath="/event/ccmEventCasedeal" selectMultiple="false" maxWidth="240"
								maxHeight="360" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">事件反馈状态：</label>
						<div class="controls">
							<form:radiobuttons name="manageType" path="manageType" items="${fns:getDictList('manage_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" class="" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
			</tr>
			<tr>
				<td colspan="2">
					<label class="control-label">事件说明及任务安排：</label>
					<div class="controls">
						<form:textarea path="remarks"  htmlEscape="false" rows="8" maxlength="1000" class="input-xxlarge "/>
					</div>
				</td>
			</tr>
		</table>
		
		<br>
		<h4 class="color-bg6">处理信息：</h4>
		<br>
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
						<label class="control-label">处理时间：</label>
						<div class="controls">
							<input id="checkDate" name="checkDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
								   value="<fmt:formatDate value="${ccmEventCasedeal.handleDate}" pattern="yyyy-MM-dd"/>"
								   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

						</div>
				</td>
				<td>
						<label class="control-label">任务处理状态：</label>
						<div class="controls">
							${fns:getDictLabel(ccmEventCasedeal.handleStatus, 'ccm_task_status', '')}
						</div>
				</td>
			</tr>
			<tr>
				<td>
						<label class="control-label">处理措施：</label>
						<div class="controls">
							<form:textarea path="handleStep" htmlEscape="false" rows="4" maxlength="256" class="input-xlarge "/>
						</div>
				</td>
				<td>
						<label class="control-label">案事件反馈：</label>
						<div class="controls">
							<form:textarea path="handleFeedback" htmlEscape="false" rows="4" maxlength="256" class="input-xlarge "/>
						</div>
				</td>
			</tr>
			
		</table>
		
		<br>
		<h4 class="color-bg6">考核信息：</h4>
		<br>
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
		
			<tr>
				<td>
						<label class="control-label">考评日期：</label>
						<div class="controls">
							<input id="checkDate" name="checkDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
								value="<fmt:formatDate value="${ccmEventCasedeal.checkDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
				</td>
				<td>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>考评人员：</label>
						<div class="controls">
							<form:input path="checkUser" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
						</div>
				</td>
			</tr>
			<tr>
				<td>
					<label class="control-label" style="padding-top: 10px;">评价等级：</label>
					<div class="controls">
						<div id="test4"></div>
					<div class="controls">
					<form:input id="gradeNum" path="gradeNum" style="display:none;"/>
				</td>
				<td>
					<label class="control-label" style="padding-top: 10px;"><span class="help-inline"><font color="red">*</font> </span>效果评估：</label>
					<div class="controls">
							<form:select id="effectType" path="effectType" class="input-xlarge required" style="width: 285px;">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('effect_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
					</div>
				</td>
			</tr>
			<tr>
				<td>
						<label class="control-label">考评意见：</label>
						<div class="controls">
							<form:input path="checkOpinion" htmlEscape="false" maxlength="256" class="input-xlarge "/>
						</div>
				</td>
				<td>
						<label class="control-label">得分：</label>
						<div class="controls">
							<form:input id="checkScore" path="checkScore" readonly="true" htmlEscape="false" maxlength="4" class="input-xlarge "/>
						</div>
				</td>
			</tr>
			
		</table>
			
		<div class="form-actions">
			<shiro:hasPermission name="event:ccmEventCasedealCheck:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
<!-- 			<input id="btnCancel" class="btn" type="button" value="返 回" -->
<!-- 				onclick="history.go(-1)" /> -->
		</div>
	</form:form>
	<script type="text/javascript">
	$("#checkDate").val(today());
	layui.use(['rate'], function(){
		var gradeNum = ${ccmEventCasedeal.gradeNum};
		if(gradeNum === undefined && gradeNum == null && gradeNum == ''){
			gradeNum = 0;
		}
		var rate = layui.rate;
		 //自定义文本
		rate.render({
		  elem: '#test4'
		  ,value: gradeNum
		  ,text: true
		  ,setText: function(value){ //自定义文本的回调
		    var arrs = {
		      '1': '极差'
		      ,'2': '差'
		      ,'3': '中等'
		      ,'4': '好'
		      ,'5': '极好'
		    };
		    this.span.text(arrs[value] || ( value + "星"));
		    $('#gradeNum').val(value);
		    var score = value * 20;
		    $('#checkScore').val(score);
		  }
		})
	});
	</script>
</body>
</html>