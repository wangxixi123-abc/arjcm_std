<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>工作日历管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				//$("#name").focus();
				jQuery.validator.methods.compareDate = function(value, element,
						param) {
					var startDate = $(param).val();//补全yyyy-MM-dd HH:mm:ss格式

					var date1 = new Date(Date
							.parse(startDate.replace(/\-/g,"/")));
					var date2 = new Date(Date.parse(value.replace(/\-/g,"/")));
					return date1 <= date2;
				};
				jQuery.validator.methods.compareTime = function(value, element,
						param) {
					//var startDate = jQuery(param).val() + ":00";补全yyyy-MM-dd HH:mm:ss格式 
					//value = value + ":00"; 
					var startTime = $(param).val();
					var startDate = $("#beginDate").val()//
					var endDate = $("#endDate").val()
					var date1
					var date2
					if (startDate == null || startDate == "") {

						date1 = new Date(Date.parse(("2000/01/01 " + startTime)
								.replace(/\-/g,"/")));

					} else {

						date1 = new Date(Date.parse((startDate
								.replace(/\-/g,"/")
								+ ' ' + startTime).replace(/\-/g,"/")));
					}
					if (endDate == null || endDate == "") {
						date2 = new Date(Date.parse(("2000/01/01 " + value)
								.replace("-", "/")));
					} else {
						date2 = new Date(Date.parse((endDate.replace(/\-/g,"/")
								+ ' ' + value).replace(/\-/g,"/")));
					}

					return date1 <= date2;
				};
				$('#btnSubmit').click(function(){
					$('#inputForm').submit();
				});
				$("#inputForm")
						.validate(
								{
									rules : {
										"beginDate" : {
											required : true
										},
										"endDate" : {
											required : true,
											compareDate : "#beginDate"

										},
										"beginTime" : {
											required : true
										},
										"endTime" : {
											required : true,
											compareTime : "#beginTime"
										}
									},
									messages : {
										"beginDate" : {
											required : "开始日期不能为空"
										},
										"endDate" : {
											required : "结束日期不能为空",
											compareDate : "结束日期必须大于等于开始日期!"
										},
										"beginTime" : {
											required : "开始时间不能为空"
										},
										"endTime" : {
											required : "结束时间不能为空",
											compareTime : "结束日期必须大于等于开始日期时间!"
										}
									},

									submitHandler : function(form) {

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

				$("input[name='isRepeat']").click(function() {

					if ($(this).val() == "2") {

						$("#round").attr("readonly", "readonly");
					} else {
						$("#round").removeAttr("readonly");

					}
				});

			});

	/* function repeat() {
		
		if ($(this).val()=="2") {
			alert(1)
	        $("#round").hide();
	   } else {
	        $("#round").show();
	   }
	
	} */
</script>
</head>
<body>
	<br>
	<br>
	<form:form target="_parent" id="inputForm" modelAttribute="plmCalendar"
		action="${ctx}/calendar/plmCalendar/save2" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">日程标题：</label>
						<div class="controls">
							<form:input path="subject" htmlEscape="false" maxlength="256"
								class="input-xlarge required" />
							<span class="help-inline"><font color="red">*</font></span>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">日程类型：</label>
						<div class="controls">
							<form:select path="tag" class="input-xlarge ">
								<form:option value="" label="未选择" />
								<form:options items="${fns:getDictList('calendar_tag')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">开始日期：</label>
						<div class="controls">
							<input id="beginDate" name="beginDate" type="text"
								readonly="readonly" maxlength="20"
								class="input-medium Wdate required"
								value="<fmt:formatDate value="${plmCalendar.beginDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
							<span class="help-inline"><font color="red">*</font></span>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">开始时间：</label>
						<div class="controls">
							<input name="beginTime" id="beginTime" type="text"
								readonly="readonly" maxlength="20"
								class="input-medium Wdate required"
								value="<fmt:formatDate value="${plmCalendar.beginTime}" pattern="HH:mm"/>"
								onclick="WdatePicker({dateFmt:'HH:mm',isShowClear:false});" /> <span
								class="help-inline"><font color="red">*</font></span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">结束日期：</label>
						<div class="controls">
							<input id="endDate" name="endDate" type="text"
								readonly="readonly" maxlength="20"
								class="input-medium Wdate required"
								value="<fmt:formatDate value="${plmCalendar.endDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
							<span class="help-inline"><font color="red">*</font></span>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">结束时间：</label>
						<div class="controls">
							<input id="endTime" name="endTime" type="text"
								readonly="readonly" maxlength="20"
								class="input-medium Wdate required"
								value="<fmt:formatDate value="${plmCalendar.endTime}" pattern="HH:mm"/>"
								onclick="WdatePicker({dateFmt:'HH:mm',isShowClear:false});" /> <span
								class="help-inline"><font color="red">*</font></span>
						</div>
					</div>
				</td>
			</tr>
			<%-- <tr>
				<td>
		<div class="control-group">
			<label class="control-label">是否重复：</label>
			<div class="controls">
				<form:radiobuttons path="isRepeat" items="${fns:getDictList('calendar_repeat')}"  itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
			</div>
		</div>
		</td>
				<td>
		<div class="control-group">
			<label class="control-label">重复周期：</label>
			<div class="controls">
				<form:select path="round" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('calendar_round')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		</td>
			</tr>
			<tr>
				<td>
		<div class="control-group">
			<label class="control-label">重要性：</label>
			<div class="controls">
				<form:radiobuttons path="importance" items="${fns:getDictList('calendar_import')}" itemLabel="label" itemValue="value" htmlEscape="false" class="" />
			</div>
		</div>
		</td>
				<td>
		<div class="control-group">
			<label class="control-label">紧急程度：</label>
			<div class="controls">
				<form:radiobuttons path="priority" items="${fns:getDictList('calendar_priority')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
			</div>
		</div>
		</td>
			</tr> 
			<td>
		<div class="control-group">
			<label class="control-label">状态：</label>
			<div class="controls">
				<form:select path="state" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('calendar_state')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		</td>
			</tr>
			<tr>
				 <td>
		<div class="control-group">
			<label class="control-label">提示方式：</label>
			<div class="controls">
				<form:checkboxes path="notifylist" items="${fns:getDictList('calendar_notify')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
			</div>
		</div>
		</td> --%>
			<tr>
				<td>
					
					<div class="control-group">
						<label class="control-label">重要性：</label>
						<div class="controls">
							<form:radiobuttons path="importance"
											items="${fns:getDictList('plm_calendar_importance')}" itemLabel="label"
											itemValue="value" htmlEscape="false" class="" ></form:radiobuttons>
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">地点：</label>
						<div class="controls">
							<form:input path="spot" htmlEscape="false" maxlength="256"
								class="input-xlarge " />
						</div>
					</div>
				</td>
				
			</tr>
			<tr>
				<td colspan="2">
					<div class="control-group">
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4"
											maxlength="255" class="input-xxlarge " cssStyle="width:74.296%" />
						</div>
					</div>
				</td>
				
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="calendar:plmCalendar:edit">
				<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>&nbsp;</shiro:hasPermission>
			
		</div>
	</form:form>
</body>
</html>