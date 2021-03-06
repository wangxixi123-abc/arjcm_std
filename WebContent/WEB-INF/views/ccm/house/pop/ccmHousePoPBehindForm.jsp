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
				//关闭弹框事件
				$('#btnCancel').click(function() {
					parent.layer.close(parent.layerIndex);
				})
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
					"padding" : "8px"
				});
				$("td").css({
					"border" : "0px dashed #CCCCCC"
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
		<li class="spePop"><a href="${ctx}/pop/ccmPeople/specialform?id=${ccmPeople.id}">吸毒人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseRelease/specialform?id=${ccmPeople.id}">安置帮教人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseRectification/specialform?id=${ccmPeople.id}">社区矫正人员标记</a></li>
		<li><a href="${ctx}/house/ccmHousePsychogeny/specialform?id=${ccmPeople.id}">易肇事肇祸精神病人标记</a></li>
		<li><a href="${ctx}/house/ccmHouseAids/specialform?id=${ccmPeople.id}">艾滋病危险人员标记</a></li>
		<li><a href="${ctx}/house/ccmHousePetition/specialform?id=${ccmPeople.id}">重点上访人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseHeresy/specialform?id=${ccmPeople.id}">涉教人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseDangerous/specialform?id=${ccmPeople.id}">危险品从业人员标记</a></li>
		<li class="active"><a href="${ctx}/pop/ccmPopBehind/specialform?id=${ccmPeople.id}">留守人员标记</a></li>
		<li><a href="${ctx}/house/ccmHouseKym/specialform?id=${ccmPeople.id}">重点青少年标记</a></li>
	</ul> --%>

	<form:form id="inputForm" modelAttribute="ccmPopBehind"
		action="${ctx}/pop/ccmPopBehind/save" method="post"
		class="form-horizontal">
		<h4 class="tableName color-bg6" >留守人员信息</h4>
		<sys:message content="${message}" />
		<form:hidden path="peopleId" value="${ccmPeople.id}" />
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span> <br>留守人员类型：</label>
						<div class="controls">
							<form:select path="staytype" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_rear_type')}"
									itemTd="td" itemValue="value" htmlEscape="false" />
							</form:select>

							<span class="help-inline"><font color="red">留守老人是有子女到本县以外务工达6个月以上；</font>
							</span> <br> <span class="help-inline"><font color="red">留守妇女是丈夫到本县以外务工达6个月以上；</font>
							</span> <br> <span class="help-inline"><font color="red">留守儿童是父母一方或者双方到本县以外务工达6个月以上；</font>
							</span>
						</div>
					</div>
				</td>
				<td></td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>关注程度：</label>
						<div class="controls">
							<form:select path="atteType" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_conc_exte')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">个人年收入：</label>
						<div class="controls">
							<form:input path="annualincome" htmlEscape="false" maxlength="8"
								class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>健康状况：</label>
						<div class="controls">
							<form:select path="health" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_phy_cdt')}"
									itemTd="td" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">家庭主要成员身份号码：</label>
						<div class="controls">
							<form:input path="crucialcondition" htmlEscape="false"
								maxlength="18" class="input-xlarge ident0 card" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">家庭主要成员姓名：</label>
						<div class="controls">
							<form:input path="crucialname" htmlEscape="false" maxlength="50"
								class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">家庭主要成员健康状况：</label>
						<div class="controls">
							<form:select path="crucialhealth" class="input-xlarge ">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_phy_cdt')}"
									itemTd="td" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">与留守人员关系：</label>
						<div class="controls">
							<form:select path="crucialrelation" class="input-xlarge ">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('sys_ccm_fami_ties')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">家庭主要成员联系方式：</label>
						<div class="controls">
							<form:input path="crucialtelephone" htmlEscape="false"
								maxlength="50" class="input-xlarge phone" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">家庭主要成员工作详细地址：</label>
						<div class="controls">
							<form:input path="crucialwork" htmlEscape="false" maxlength="200"
								class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">家庭年收入：</label>
						<div class="controls">
							<form:input path="crucialmoney" htmlEscape="false" maxlength="8"
								class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">困难及诉求：</label>
						<div class="controls">
							<form:textarea path="difficult" htmlEscape="false" rows="4"
								maxlength="1024" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">帮扶情况：</label>
						<div class="controls">
							<form:textarea path="helpcase" htmlEscape="false" rows="4"
								maxlength="1024" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td colspan="2">
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
			<shiro:hasPermission name="pop:ccmPopBehind:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="关闭"
				 />
		</div>
	</form:form>
</body>
</html>