<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>仓库信息管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
<!-- 表格试表单css -->
<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
<script type="text/javascript" src="${ctxStatic}/plm/storage/storageValidate.js"></script>
<script type="text/javascript">
	$(document).ready(
			
			function() {
				 
				$('#btnSubmit').click(function(){
					$('#inputForm').submit();
				});
				$("#inputForm")
						.validate(
								{
									rules: {
										name: {
											required: true,
											maxlength : 50,
											special_str: $("#name").val()    //调用自定义验证
						                },
						                simpleName: {
											maxlength : 20,
											special_str: $("#simpleName").val()    //调用自定义验证
						                },
						                stoAddress: {
											maxlength : 256,
											special_str: $("#stoAddress").val()    //调用自定义验证
						                },
						                longItude: {
											maxlength : 11,
											lrunlv: $("#longItude").val(),    //调用自定义验证
										
						                },
						                latItude: {
											maxlength : 11,
											lrunlv: $("#latItude").val(),    //调用自定义验证
										
						                }
						            },
						            
						            messages: {
						            	name: {
						            		maxlength: "最大长度50"
						                },
						                simpleName: {
						            		maxlength: "最大长度20"
						                },
						                stoAddress: {
						            		maxlength: "最大长度256"
						                },
						                longItude: {
						            		maxlength: "最大长度17"
						                },
						                latItude: {
						            		maxlength: "最大长度17"
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
			});
</script>
	<%--引入文本框外部样式--%>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/storage/plmStorage/">仓库信息列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head"
			href="${ctx}/storage/plmStorage/form?id=${plmStorage.id}&parent.id=${plmStorageparent.id}">仓库信息<shiro:hasPermission
					name="storage:plmStorage:edit">${not empty plmStorage.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="storage:plmStorage:edit">查看</shiro:lacksPermission></a></li>
	</ul>

	<form:form id="inputForm" modelAttribute="plmStorage"
		action="${ctx}/storage/plmStorage/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="code" />
		<sys:message content="${message}" />
		<div class="control-group head_Space">
			<h2>仓库信息</h2>
		</div>
		<table id="table" class="table   table-condensed first_table"
			style="table-layout: fixed;">
			<tr>
				<td class="trtop">所属上级</td>
				<td ><sys:treeselect id="parent" name="parent.id"
						value="${plmStorage.parent.id}" labelName="parent.name"
						labelValue="${plmStorage.parent.name}" title="父级编号"
						url="/storage/plmStorage/treeData" extId="${plmStorage.id}"
						cssStyle="padding-right: 13px;padding-left: 13px;"
						allowClear="true" /></td>
				<td class="trtop">联系人</td>
				<td ><sys:treeselect id="user" name="user.id"
						value="${plmStorage.user.id}" labelName="user.name"
						labelValue="${plmStorage.user.name}" title="用户"
						url="/sys/office/treeData?type=3"
						cssStyle="padding-right: 13px;padding-left: 13px;"
						allowClear="true" notAllowSelectParent="true" isAll="true"/></td>
			</tr>
			<tr>
				<td class="trtop">编号(系统生成)<span class="help-inline"><font
						color="red"></font> </span>
				</td>
				<td >${plmStorage.code}</td>
				<td class="trtop"><span class="help-inline"><font
						color="red">*</font> </span>名称
				</td>
				<td ><form:input path="name" htmlEscape="false"
						maxlength="50" class="input-xlarge required" /></td>
			</tr>
			<tr>
				<td class="trtop">简称</td>
				<td ><form:input path="simpleName"
						htmlEscape="false" maxlength="30" class="input-xlarge " /></td>
				<td class="trtop"><span class="help-inline"><font
						color="red">*</font> </span>仓库类型
				</td>
				<td ><form:select path="type"
						class="input-xlarge required">
						<form:option value="" label="" />
						<form:options items="${fns:getDictList('plm_storage')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select></td>
			</tr>
			<tr>
				<td class="trtop"><span class="help-inline"><font
						color="red">*</font> </span>排序
				</td>
				<td ><form:input path="sort" htmlEscape="false"
						class="input-xlarge required digits" /></td>
				<td class="trtop">地址</td>
				<td ><form:input path="stoAddress"
						htmlEscape="false" maxlength="256" class="input-xlarge " /></td>
			</tr>
			<tr>
				<td class="trtop">经度</td>
				<td ><form:input path="longItude" htmlEscape="false" maxlength="17"
						class="input-xlarge " /></td>
				<td class="trtop">纬度</td>
				<td ><form:input path="latItude" htmlEscape="false" maxlength="17"
						class="input-xlarge  " /></td>
			</tr>
			<tr>
				<td class="trtop">备注</td>
				<td colspan="3"><form:textarea path="remarks" 
						htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " /></td>
			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="storage:plmStorage:edit">
				<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i ></i>保存</a>&nbsp;</shiro:hasPermission>
				<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i ></i>返回</a>
		</div>
	</form:form>
</body>
</html>