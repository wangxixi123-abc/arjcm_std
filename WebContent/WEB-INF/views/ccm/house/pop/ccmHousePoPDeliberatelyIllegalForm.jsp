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
				if('${ccmHouseDeliberatelyIllegal.isRecidivism}' =="0"){
					$("#crimeHistory").attr("readonly", "readonly");
					$("#crimeHistory").val("无犯罪史，不可填写")
				}
				$("input[name='isRecidivism']").click(function() {
					if ($(this).val() == "0") {
						$("#crimeHistory").attr("readonly", "readonly");
						$("#crimeHistory").val("无犯罪史，不可填写")
					} else {
						$("#crimeHistory").removeAttr("readonly");
						$("#crimeHistory").val("")

					}
				});
			});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<%-- <li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatPerson">人口统计</a></li>
		<li class=" "><a href="${ctx}/pop/ccmPeople/">实有人口列表</a></li>
		<li class="active"><a href="">人员标记</a></li> --%>
	</ul>
	<%-- <ul class="nav nav-pills">
		<li class="active spePop"><a href="${ctx}/pop/ccmPeople/specialform?id=${ccmPeople.id}">吸毒人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseRelease/specialform?id=${ccmPeople.id}">安置帮教人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseRectification/specialform?id=${ccmPeople.id}">社区矫正人员标记</a></li>
		<li><a href="${ctx}/house/ccmHousePsychogeny/specialform?id=${ccmPeople.id}">易肇事肇祸精神病人标记</a></li>
		<li><a href="${ctx}/house/ccmHouseAids/specialform?id=${ccmPeople.id}">艾滋病危险人员标记</a></li>
		<li><a href="${ctx}/house/ccmHousePetition/specialform?id=${ccmPeople.id}">重点上访人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseHeresy/specialform?id=${ccmPeople.id}">涉教人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseDangerous/specialform?id=${ccmPeople.id}">危险品从业人员标记</a></li>
		<li><a href="${ctx}/pop/ccmPopBehind/specialform?id=${ccmPeople.id}">留守人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseKym/specialform?id=${ccmPeople.id}">重点青少年标记</a></li>
            
	</ul> --%>

	<form:form id="inputForm" modelAttribute="ccmHouseDeliberatelyIllegal"
		action="${ctx}/house/ccmHouseDeliberatelyIllegal/save" method="post"
		class="form-horizontal">
		<h4 class="tableName color-bg6">故意违法刑释不足5年人员信息</h4>
		<sys:message content="${message}" />
		<form:hidden path="peopleId" value="${ccmPeople.id}" />
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>所判罪行：</label>
						<div class="controls">
							<form:input path="convictCrimes" htmlEscape="false"
								maxlength="50" class="input-xlarge required" />

						</div>
							
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>审判结果：</label>
						<div class="controls">
							<form:input path="convictResult" htmlEscape="false"
								maxlength="50" class="input-xlarge required" />

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>监管状态：</label>
						<div class="controls">
							<form:radiobuttons path="superviseStatus"
								items="${fns:getDictList('house_supervise_status')}"
								itemLabel="label" itemValue="value" htmlEscape="false" class="required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>关注程度：</label>
						<div class="controls">
							<form:select path="atteType" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_conc_exte')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">帮扶情况：</label>
						<div class="controls">
							<form:input path="helpCase" htmlEscape="false" maxlength="1024"
								class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">帮扶人姓名：</label>
						<div class="controls">
							<form:input path="helpName" htmlEscape="false" maxlength="50"
								class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">帮扶人联系方式：</label>
						<div class="controls">
							<form:input path="helpTl" htmlEscape="false" maxlength="18"
								class="input-xlarge phone" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">违法地区：</label>
						<div class="controls">
							<form:input path="illegalArea" htmlEscape="false"
								maxlength="255" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>违法时间：</label>
						<div class="controls">
							<input name="illegalDate" type="text" readonly="readonly"
								maxlength="20" class="input-medium Wdate required"
								value="<fmt:formatDate value="${ccmHouseDeliberatelyIllegal.illegalDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>释放时间：</label>
						<div class="controls">
							<input name="acquittalDate" type="text" readonly="readonly"
								maxlength="20" class="input-medium Wdate required"
								value="<fmt:formatDate value="${ccmHouseDeliberatelyIllegal.acquittalDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">改造情况：</label>
						<div class="controls">
							<form:input path="transformInfo" htmlEscape="false"
								maxlength="255" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>是否累犯：</label>
						<div class="controls">
							<form:radiobuttons path="isRecidivism"
								items="${fns:getDictList('have_no')}" itemLabel="label"
								itemValue="value" htmlEscape="false" class="" />

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
					<label class="control-label">违法原因：</label>
						<div class="controls">
							<form:textarea path="illegalDescription" htmlEscape="false" rows="4"
								maxlength="1024" class="input-xlarge " />
						</div>
						
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">回访情况：</label>
						<div class="controls">
							<form:textarea path="reviewType" htmlEscape="false" rows="4"
								maxlength="2084" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">犯罪史详情：</label>
						<div class="controls">
							<form:textarea path="crimeHistory" htmlEscape="false" rows="4"
								maxlength="1024" class="input-xlarge " />
						</div>
					</div>

				</td>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4"
								maxlength="255" class="input-xlarge " />
						</div>
					</div>
					</td>
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="house:ccmHouseDeliberatelyIllegal:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" /> -->
		</div>
	</form:form>
</body>
</html>