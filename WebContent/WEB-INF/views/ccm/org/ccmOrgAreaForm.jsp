<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>区域管理</title>
	<meta name="decorator" content="default"/>
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
			$("td").css({"padding":"8px"});
			$("td").css({"border":"1px dashed #CCCCCC"});
		});
	</script>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/org/sysArea?type=${type}">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/org/ccmOrgArea/form?id=${ccmOrgArea.id}">数据<shiro:hasPermission name="org:ccmOrgArea:edit">${not empty ccmOrgArea.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="org:ccmOrgArea:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmOrgArea" action="${ctx}/org/ccmOrgArea/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input id="type" name="type" type="hidden" value="${type}"/>
		<sys:message content="${message}"/>		
		<form:hidden path="area.id"/>
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>关联区域：</label>
						<div class="controls">
							<form:input path="area.name" htmlEscape="false" maxlength="255"
								class="input-xlarge required" readonly="true"/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>管理员姓名：</label>
						<div class="controls">
							<form:input path="netManName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td >
					<div>
							<%-- <label class="control-label">图标：</label>
                            <div class="controls">
                                <sys:iconselect id="icon" name="icon" value="${ccmOrgArea.icon}"/>
                            </div> --%>
						<label class="control-label">照片：</label>
						<div class="controls">
							<form:hidden id="icon" path="icon" htmlEscape="false" maxlength="255" class="input-xlarge"/>
							<sys:ckfinder input="icon" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="240" maxHeight="360"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>民族：</label>
						<div class="controls">
							<form:select path="nation" class="input-xlarge required ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sys_volk')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>性别：</label>
						<div class="controls">
							<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>出生日期：</label>
						<div class="controls">
							<input name="birthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
								value="<fmt:formatDate value="${ccmOrgArea.birthday}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>手机号码：</label>
						<div class="controls">
							<form:input path="telephone" htmlEscape="false" maxlength="18" class="input-xlarge digits required"/>
						</div>
					</div>
					
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>政治面貌：</label>
						<div class="controls">
							<form:select path="politics" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sys_ccm_poli_stat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>学历：</label>
						<div class="controls">
							<form:select path="education" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sys_ccm_degree')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">固定电话：</label>
						<div class="controls">
							<form:input path="fixTel" htmlEscape="false" maxlength="18" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>工作人员数量：</label>
						<div class="controls">
							<form:input path="netPeoNum" htmlEscape="false" maxlength="6" class="input-xlarge digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<%-- <tr>
				<td>
					<div>
						<label class="control-label">工作人员姓名：</label>
						<div class="controls">
							<form:input path="netPeoName" htmlEscape="false" maxlength="255" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					
				</td>
			</tr> --%>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>户数：</label>
						<div class="controls">
							<form:input path="netNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>人口数量：</label>
						<div class="controls">
							<form:input path="mannum" htmlEscape="false" maxlength="10" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>面积（平方米）：</label>
						<div class="controls">
							<form:input path="netArea" htmlEscape="false" class="input-xlarge number required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>重点人员数量：</label>
						<div class="controls">
							<form:input path="keyPersonnelNum" htmlEscape="false" maxlength="10" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>公共安全监控摄像机总数：</label>
						<div class="controls">
							<form:input path="videoSafetyNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>高清摄像机数量：</label>
						<div class="controls">
							<form:input path="definitionNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>乡镇（街道）摄像机数量：</label>
						<div class="controls">
							<form:input path="videoTownsNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>24小时值守摄像机数量：</label>
						<div class="controls">
							<form:input path="videoAlldayNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>党员人数：</label>
						<div class="controls">
							<form:input path="partyMembersNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>每平方公里视频监控摄像机数量：</label>
						<div class="controls">
							<form:input path="eachKiloNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>每百人视频监控摄像机数量：</label>
						<div class="controls">
							<form:input path="eachHundNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>扶贫主任：</label>
						<div class="controls">
							<form:input path="directorPovertyAlleviation" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>政法派驻员：</label>
						<div class="controls">
							<form:input path="politicalLegalDeployment" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>扶贫第一书记：</label>
						<div class="controls">
							<form:input path="policeAssistant" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>民生监督员：</label>
						<div class="controls">
							<form:input path="peopleLivelihoodSupervisor" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>警务助理：</label>
						<div class="controls">
							<form:input path="policeAssistant" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">区域图：</label>
						<div class="controls">
							<form:input path="areaMap" readonly="true" htmlEscape="false" maxlength="20000" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">中心点：</label>
						<div class="controls">
							<form:input path="areaPoint" readonly="true" htmlEscape="false" maxlength="40" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">辖区说明：</label>
						<div class="controls">
							<form:textarea path="areainfor" htmlEscape="false" rows="4" class="input-xxlarge "/>
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td>
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
			<shiro:hasPermission name="org:ccmOrgArea:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>