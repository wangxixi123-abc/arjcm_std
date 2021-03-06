<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>装备物资管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
<!-- 表格试表单css -->
<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
<script type="text/javascript" src="${ctxStatic}/plm/storage/storageValidate.js"></script>
<link rel="stylesheet" href="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.css">
<script src="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript">
	$(document).ready(
									
			function() {
				//$("#name").focus();
				$('#btnSubmit').click(function(){
					$('#inputForm').submit();
				});
				$("#inputForm")
						.validate(
								{
									rules: {
										price: {
											required: true,
											maxlength : 64,
											amount: $("#price").val()    //调用自定义验证
						                },
						                unit: {
						                	required: true,
											maxlength : 8,
											chinese: $("#unit").val()    //调用自定义验证
						                },
						                spec: {
											maxlength : 64,
											special_str: $("#spec").val()    //调用自定义验证
						                },
						                productionBatch: {
											maxlength : 20,
											order_num: $("#productionBatch").val()    //调用自定义验证
						                }
						            },
						            
						            messages: {
						            	price: {
						            		maxlength: "最大长度64"
						                },
						                unit: {
						                	required: "必填信息",
						            		maxlength: "最大长度8"
						                },
						                spec: {
						            		maxlength: "最大长度64"
						                },
						                productionBatch: {
						            		maxlength: "最大长度20"
						                }
						            },
									
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
				$("td[colspan='2']").css({
					"width" : "22.5%"
				});
				$("#printCode").dialog({
				    autoOpen: false,
				    closeOnEscape: false,
				    height: 400,
				    width: 400,
				    modal: true,
				    close: function() {
				    	$( this ).dialog( "close" );
				    }
				  });
				$("#print").on("click", function(){
					var src = "${ctx}/storage/plmEquipment/printQrCode?id=${plmEquipment.id}";
					$("#printCode").attr("src", src);
					$("#printCode").dialog("open");
					$("#printCode").css({"width":"98%"});
				});
			});
	            
			 
	        
</script>
<script type="text/javascript"
	src="${ctxStatic}/plm/storage/plmEquipmentType.js"></script>
	<%--引入文本框外部样式--%>
<%--	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">--%>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 112px" href="${ctx}/storage/plmEquipment/">装备物资列表</a></li>
		<li class="active" style="width: 112px"><a class="nav-head"
			href="${ctx}/storage/plmEquipment/form?id=${plmEquipment.id}">装备物资<shiro:hasPermission
					name="storage:plmEquipment:edit">${not empty plmEquipment.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="storage:plmEquipment:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="plmEquipment"
		action="${ctx}/storage/plmEquipment/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<h2>装备物资信息</h2>
		<table id="table" class="table   table-condensed"
			style="table-layout: fixed;">
			<tr>
				<td class="trtop"><span class="help-inline"><font
						color="red">*</font> </span>物资名称
				</td>
				<td colspan="2"><form:input path="name" htmlEscape="false"
						maxlength="64" class="input-xlarge required" /></td>
				<td class="trtop"><span class="help-inline"><font
						color="red">*</font> </span>物资编号
				</td>
				<td colspan="2">${plmEquipment.code}</td>
				<td class="trtop">状态</td>
				<td colspan="1"><form:select path="type"
						class="input-xlarge " cssStyle="width:150px;">
						<form:option value="" label="" />
						<form:options items="${fns:getDictList('plm_equipment_status')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select></td>
				<td class="trtop" style="width: 75px; width: 75px;">二维码</td>
			</tr>
			<tr>
				<td class="trtop">所属仓库</td>
				<td colspan="2"><sys:treeselect id="storage" name="storage.id"
						value="${plmEquipment.storage.id}" labelName="storage.name"
						labelValue="${plmEquipment.storage.name}" title="仓库"
						url="/storage/plmStorage/treeData"
						allowClear="true" notAllowSelectParent="true" /></td>
				<td class="trtop">规格型号</td>
				<td colspan="2"><form:input path="spec" htmlEscape="false"
						maxlength="64" class="input-xlarge " /></td>
				<td class="trtop">分类</td>
				<td><form:select path="category"
						class="input-xlarge " cssStyle="width:150px;">
						<form:options items="${fns:getDictList('equ_category')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select></td>
				<td rowspan="4"><img style="width: 70px; width: 70px;" src="${ctx}/storage/plmEquipment/getQrCode?code=${plmEquipment.code}">
				<div align="center"><a id="print">打印</a></div>
				</td>

			</tr>
			<tr>
				<td class="trtop"><span class="help-inline"><font
						color="red">*</font> </span>物资类别
				</td>
				<td colspan="2"><form:select path="typeId"
						class="input-xlarge required" dictTyep="plm_equipment_type">
						<form:option value="" label="" />
						<form:options items="${fns:getDictList('plm_equipment_type')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select></td>
				<td class="trtop">物资子类</td>
				<td colspan="2"><form:select path="typeChild"
						class="input-xlarge ">
						<form:option value="" label="" />
						<form:options
							items="${fns:getDictList('plm_equipment_type_child')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select></td>
					<td rowspan="3" class="trtop"><img id="imgUrlShow" src="${plmEquipment.imgUrl}" 
				        onerror='this.src="${ctxStatic}/common/list/images/timg.jpg"'
				        style="max-width:100px;max-height:100px;_height:100px;border:0;padding:3px;"></td>
				<td rowspan="3" colspan="1">
				<form:hidden id="imgUrl" path="imgUrl"
						htmlEscape="false" maxlength="256" class="input-xlarge" /> <sys:ckfinder
						input="imgUrl" type="files" uploadPath="/storage/plmEquipment"
						selectMultiple="false" /></td>
			</tr>
			<tr>
				<td class="trtop">使用人</td>
				<td colspan="2"><sys:treeselect id="user" name="user.id"
						value="${plmEquipment.user.id}" labelName="user.name"
						labelValue="${plmEquipment.user.name}" title="用户"
						url="/sys/office/treeData?type=3"
						allowClear="true" notAllowSelectParent="true" /></td>
				<td class="trtop">使用人部门</td>
				<td colspan="2"><sys:treeselect id="userJob" name="userJob.id"
						value="${plmEquipment.userJob.id}" labelName="userJob.name"
						labelValue="${plmEquipment.userJob.name}" title="部门"
						url="/sys/office/treeData?type=2"
						allowClear="true" notAllowSelectParent="true" /></td>
			</tr>
			<tr>
				<td class="trtop">生产日期</td>
				<td colspan="2"><input name="productionDate" type="text"
					readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${plmEquipment.productionDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" /></td>
				<td class="trtop">生产批次</td>
				<td colspan="2"><form:input path="productionBatch"
						htmlEscape="false" maxlength="20" class="input-xlarge " /></td>
			</tr>
			<tr>
				<td class="trtop">质保期限</td>
				<td colspan="2"><input name="guaranteePeriod" type="text"
					readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${plmEquipment.guaranteePeriod}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" /></td>
				<td class="trtop">使用年限</td>
				<td colspan="2"><input name="durableYears" type="text"
					readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${plmEquipment.durableYears}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" /></td>
				<td class="trtop">保质期(月)</td>
				<td colspan="2"><form:input path="expirationDate" htmlEscape="false"
						maxlength="9" class="input-xlarge  digits" /></td>
			</tr>
			<tr>
				<c:choose>
					<c:when test="${plmEquipment.typeId != '0'}">
						<td class="trtop">物资价格</td>
						<td colspan="8"><form:input path="price" htmlEscape="false"
								maxlength="64" class="input-xlarge " /></td>
					</c:when>
					<c:otherwise>
						<td class="trtop">物资价格</td>
						<td colspan="2"><form:input path="price" htmlEscape="false"
								maxlength="64" class="input-xlarge " /></td>
						<td class="trtop"><span class="help-inline"><font
								color="red">*</font> </span>计量单位
						</td>
						<td colspan="2"><form:input path="unit" htmlEscape="false"
								maxlength="64" class="input-xlarge " /></td>
							<td class="trtop"><span class="help-inline"><font
									color="red">*</font> </span>物资数量（耗材）
						</td>
						<td colspan="2"><form:input path="erialNumber"
								htmlEscape="false" maxlength="64"
								class="input-xlarge required digits" /></td>
					</c:otherwise>
				</c:choose>
			</tr>
			<c:if test="${plmEquipment.typeId == '0'}">
				<tr>
					<td class="trtop"><span class="help-inline"><font
							color="red">*</font> </span>告警数量
					</td>
					<td colspan="8"><form:input path="stockahead"
							htmlEscape="false" maxlength="64"
							class="input-xlarge required digits" /></td>
				</tr>
			</c:if>
			<tr>
				<td class="trtop">备注</td>
				<td colspan="8"><form:textarea path="remarks"
						htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " /></td>
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="storage:plmEquipment:edit">
				<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>&nbsp;</shiro:hasPermission>
				<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
	<iframe id="printCode" src=""></iframe>
</body>
</html>