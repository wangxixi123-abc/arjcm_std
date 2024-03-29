<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>人员标记</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
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
				$("td").css({"padding":"8px"});
				$("td").css({"border":"0px dashed #CCCCCC"});
			});
</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<%-- <li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatPerson">人口统计</a></li>
		<li class=" "><a href="${ctx}/pop/ccmPeople/">实有人口列表</a></li>
		<li class="active"><a href="">人员标记</a></li> --%>
	</ul>
	<%-- <ul class="nav nav-pills">
		<li class=" spePop"><a href="${ctx}/pop/ccmPeople/specialform?id=${ccmPeople.id}">吸毒人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseRelease/specialform?id=${ccmPeople.id}">安置帮教人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseRectification/specialform?id=${ccmPeople.id}">社区矫正人员标记</a></li>
		<li><a href="${ctx}/house/ccmHousePsychogeny/specialform?id=${ccmPeople.id}">易肇事肇祸精神病人标记</a></li>
		<li><a href="${ctx}/house/ccmHouseAids/specialform?id=${ccmPeople.id}">艾滋病危险人员标记</a></li>
		<li class="active"><a href="${ctx}/house/ccmHousePetition/specialform?id=${ccmPeople.id}">重点上访人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseHeresy/specialform?id=${ccmPeople.id}">涉教人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseDangerous/specialform?id=${ccmPeople.id}">危险品从业人员标记</a></li>
		<li><a href="${ctx}/pop/ccmPopBehind/specialform?id=${ccmPeople.id}">留守人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseKym/specialform?id=${ccmPeople.id}">重点青少年标记</a></li>
	</ul> --%>

	<form:form id="inputForm" modelAttribute="ccmHousePetition" action="${ctx}/house/ccmHousePetition/save" method="post" class="form-horizontal">
		<sys:message content="${message}" />
		<form:hidden path="peopleId" value="${ccmPeople.id}" />
		
		<h4 class="tableName color-bg6">重点上访人员信息</h4>
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>关注程度：</label>
						<div class="controls">
							<form:select path="atteType" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_conc_exte')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">工作单位：</label>
						<div class="controls">
							<form:input path="workUnit" htmlEscape="false" maxlength="100" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>上访性质：</label>
						<div class="controls">
							<form:select path="petitionType" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_house_petition_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">工作单位电话：</label>
						<div class="controls">
							<form:input path="workPhone" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>个或群访：</label>
						<div class="controls">
							<form:select path="peopleNumber" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_house_petition_popnum')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">上访事由：</label>
						<div class="controls">
							<form:input path="petitionFor" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">初次上访时间：</label>
						<div class="controls">
							<input name="firstTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmHousePetition.firstTime}" pattern="yyyy-MM-dd"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">上访次数：</label>
						<div class="controls">
							<form:input path="petitionNum" htmlEscape="false" maxlength="10" class="input-xlarge  digits" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">上访地点：</label>
						<div class="controls">
							<form:input path="petitionPlace" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">反映问题：</label>
						<div class="controls">
							<form:input path="reflectProblem" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">滋事行为：</label>
						<div class="controls">
							<form:input path="troubleBehavior" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">上访结果：</label>
						<div class="controls">
							<form:input path="petitionResult" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
				</td>
			</tr>
			<tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="house:ccmHousePetition:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/> -->
		</div>

	</form:form>
</body>
</html>