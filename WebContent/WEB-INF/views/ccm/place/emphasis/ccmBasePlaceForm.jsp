<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>场所信息管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
<link href="${ctxStatic}/form/css/formTable.css" rel="stylesheet" />
<style>
#administrativeDivisionName {
	width: 225px;
}

.select2-container.select2 {
	width: 283px;
}
form#inputForm .tableNamefirst {
	margin: 0px 10px 10px 10px;
}
</style>
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
			});

	$(
			function() {
				$
						.getJSON(
								'${ctx}/sys/dict/listData?type=place_types',
								function(datas) {
									for (var i = 0; i < datas.length; i++) {
										if (i == 0) {
											$('#placeTypeUp').append(
													"<option value='" + datas[i].value + "' selected='selected'>"
															+ datas[i].label
															+ "</option>");
											$(
													'#s2id_placeTypeUp .select2-chosen')
													.html(datas[i].label);
										} else {
											$('#placeTypeUp').append(
													"<option value='" + datas[i].value + "'>"
															+ datas[i].label
															+ "</option>");
										}

									}
									$
											.getJSON(
													'${ctx}/sys/dict/listData?type=place_types_ccm_place_live',
													function(datas) {
														for (var i = 0; i < datas.length; i++) {
															if (i == 0) {
																$(
																		'#placeTypeDown')
																		.append(
																				"<option value='" + datas[i].value + "' selected='selected'>"
																						+ datas[i].label
																						+ "</option>");
																$(
																		'#s2id_placeTypeDown .select2-chosen')
																		.html(
																				datas[i].label);
															} else {
																$(
																		'#placeTypeDown')
																		.append(
																				"<option value='" + datas[i].value + "'>"
																						+ datas[i].label
																						+ "</option>");
															}

														}
													});
								});
				$('#placeTypeUp')
						.change(
								function() {
									var val = $('#placeTypeUp').val();
									$
											.getJSON(
													'${ctx}/sys/dict/listData?type=place_types_'
															+ val + '',
													function(datas) {
														$('#placeTypeDown')
																.html('');
														for (var i = 0; i < datas.length; i++) {
															if (i == 0) {
																$(
																		'#placeTypeDown')
																		.append(
																				"<option value='" + datas[i].value + "' selected='selected'>"
																						+ datas[i].label
																						+ "</option>");
																$(
																		'#s2id_placeTypeDown .select2-chosen')
																		.html(
																				datas[i].label);
															} else {
																$(
																		'#placeTypeDown')
																		.append(
																				"<option value='" + datas[i].value + "'>"
																						+ datas[i].label
																						+ "</option>");
															}

														}
													});
								})
			})
			
			
	function saveForm() {
		var area = $("#areaId").val();
		var html1 = '<label for="" class="error">必选字段 <label>';
		//alert(officeId.length);
		if (area.length != 0) {
			$("#show1").html("");
		} else {
			$("#show1").html(html1);
		}

		if (area.length != 0) {
			$("#inputForm").submit();
		}

	}
</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<form:form id="inputForm" modelAttribute="ccmBasePlace"
		action="${ctx}/place/ccmBasePlace/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<h4 class="tableNamefirst color-bg6" >基本信息</h4>
		<table>
			<tr>
				<td style="width: 50%;"><label class="control-label"><span class="help-inline"><font color="red">*</font> </span>场所名称：</label>
					<div class="controls">
						<form:input path="placeName" htmlEscape="false" maxlength="255"
							class="input-xlarge required" />

					</div></td>
				<td rowspan="2"><label class="control-label">场所图片：</label>
					<div class="controls">
						<form:hidden id="images" path="placePicture" htmlEscape="false"
							maxlength="255" class="input-xlarge" />
						<sys:ckfinder input="images" type="images" uploadPath="/photo"
							selectMultiple="false" maxWidth="240" maxHeight="360" />
					</div></td>
			</tr>
			<tr>
				<td><label class="control-label">关联组织机构：</label>
					<div class="controls">
						<form:select path="relevanceOrg" class="input-xlarge">
							<form:option value="" label="无关联" />
							<form:options items="${fns:getDictList('ccm_buss_cate')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>

					</div></td>

			</tr>
			<tr>
				<td colspan="2"><label class="control-label">重点场所：</label>
					<div class="controls">
						<form:checkboxes path="keyPointList"
							items="${fns:getDictList('ccm_place_important')}"
							itemLabel="label" itemValue="value" htmlEscape="false"
							class="required" />
					</div></td>
			</tr>
			<tr>

			</tr>
			<tr>
				<td><label class="control-label">场所用途：</label>
					<div class="controls">
						<form:input path="placeUse" htmlEscape="false" maxlength="255"
							class="input-xlarge " />
					</div></td>
				<td><label class="control-label">工作人员数量：</label>
					<div class="controls">
						<form:input path="workerNumber" htmlEscape="false" maxlength="255"
							class="input-xlarge number" />
					</div></td>
			</tr>
			<tr>
				<td><label class="control-label">负责人姓名：</label>
					<div class="controls">
						<form:input path="leaderName" htmlEscape="false" maxlength="255"
							class="input-xlarge " />
					</div></td>
				<td><label class="control-label">负责人身份证号码：</label>
					<div class="controls">
						<form:input path="leaderIdCard" htmlEscape="false" maxlength="255"
							class="input-xlarge card" />
					</div></td>
			</tr>
			<tr>
				<td><label class="control-label">负责人联系方式：</label>
					<div class="controls">
						<form:input path="leaderContact" htmlEscape="false"
							maxlength="255" class="input-xlarge phone" />
					</div></td>
				<td><label class="control-label">成立时间：</label>
					<div class="controls">
						<input name="createTime" type="text" readonly="readonly"
							maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmBasePlace.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
					</div></td>
			</tr>
			<tr>
				<td><label class="control-label" style="display: none">场所类型：</label>
					<div class="controls" style="display: none">
						<form:input path="placeType" style="display: none"
							htmlEscape="false" maxlength="255" class="input-xlarge " />
					</div> <label class="control-label"><span class="help-inline"><font color="red">*</font></span>所属网格：</label>
					<div class="controls">
						<sys:treeselect id="area" name="administrativeDivision"
							value="${ccmBasePlace.administrativeDivision}" labelName=""
							labelValue="${ccmBasePlace.area.name}" title="网格"
							url="/sys/area/treeData" allowClear="true"
							notAllowSelectParent="true" cssClass=""/>
						<span class="help-inline"><font color="red" id="show1"></font></span>
					</div></td>
				<td><label class="control-label">地址：</label>
					<div class="controls">
						<form:input path="address" htmlEscape="false" maxlength="255"
							class="input-xlarge " />
					</div></td>
			</tr>
<!-- 			<tr>
				<td><label class="control-label">场所类型：</label>
					<div class="controls">
						<select id="placeTypeUp" name="placeType"
							class="select2  input-xlarge"></select> <span class="help-inline"><font
							color="red">*</font> </span>
					</div></td>
				<td><label class="control-label">场所子类型：</label>
					<div class="controls">
						<select id="placeTypeDown" name="childType"
							class="select2  input-xlarge"></select> <span class="help-inline"><font
							color="red">*</font> </span>
					</div></td>
			</tr> -->
			<tr>
				<td><label class="control-label">主管单位名称：</label>
					<div class="controls">
						<form:input path="governingBodyName" htmlEscape="false"
							maxlength="255" class="input-xlarge " />
					</div></td>
				<td><label class="control-label">场所面积：</label>
					<div class="controls">
						<form:input path="placeArea" htmlEscape="false" maxlength="255"
									class="input-xlarge number" />
					</div></td>

			</tr>
			<tr>
				<td><label class="control-label">备注信息：</label>
					<div class="controls">
						<form:textarea path="remarks" htmlEscape="false" rows="4"
									   maxlength="255" class="input-xlarge " />
					</div></td>
				<td></td>
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="place:ccmBasePlace:edit">
				<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button"
					value="保 存" />&nbsp;</shiro:hasPermission>
		</div>
	</form:form>
</body>
</html>