<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>党组织管理管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
	<link rel="stylesheet" href="${ctxStatic}/ccm/event/css/fishBone.css" />
	<script type="text/javascript" src="${ctxStatic}/ccm/event/js/fishBone.js"></script>
	<script type="text/javascript" src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			//关闭弹框事件
			$('#btnCancel').click(function() {
				parent.layer.close(parent.layerIndex);
			})
			$("#PartyOrgDetailBtn").click(function() {
				$("#PartyOrgDetailTable").toggle();
			});
			$("#DeptDetailBtn").click(function() {
				$("#DeptDetailTable").toggle();
			});
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
</head>
<body>
	<ul class="nav nav-tabs">

	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmPartyOrganiz" action="${ctx}/partybuild/ccmPartyOrganiz/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input id="type" name="type" type="hidden" value="2"/>
		<sys:message content="${message}"/>
		<div>
			<h4 class="tableNamefirst" id="PartyOrgDetailBtn"
				style="cursor: pointer;">
				党组织信息<i class=" icon-share-alt"></i>
			</h4>
			<table id="PartyOrgDetailTable" border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC"  colspan="2">
					<div>
						<label class="control-label">组织名称：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required" style=" width: 83%;"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC"   colspan="2">
					<div>
						<label class="control-label">组织全称：</label>
						<div class="controls">
							<form:input path="allName" htmlEscape="false" maxlength="150" class="input-xlarge " style=" width: 83%;"/>
						</div>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">选择社区：</label>
						<div class="controls">
								<%--<sys:treeselect id="community" name="community" value="${ccmPartyOrganiz.community.id}" labelName="community.name"--%>
								<%--labelValue="${ccmPartyOrganiz.community.name}"--%>
								<%--title="区域" url="/sys/area/treeData" cssClass="required" allowClear="true" notAllowSelectParent="true"/>--%>
							<sys:treeselect id="community" name="community.id"
											value="${ccmPartyOrganiz.community.id}" labelName="community.name"
											labelValue="${ccmPartyOrganiz.community.name}" title="区域"
											url="/tree/ccmTree/treeDataArea?type=6" cssClass=""
											allowClear="true" notAllowSelectParent="true"
											cssStyle="" />
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">通讯地址：</label>
						<div class="controls">
							<form:input path="address" htmlEscape="false" maxlength="200" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>		
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">传真号码：</label>
						<div class="controls">
							<form:input path="faxNum" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>	
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">上级组织：</label>
						<div class="controls">
							<form:select path="superOrg" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${list}" itemLabel="name" itemValue="superOrg" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">组织属性：</label>
						<div class="controls">
							<form:select path="orgAttr" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_party_attr')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">党组织属地关系：</label>
						<div class="controls">
							<form:select path="orgAttrRelation" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_ply_rat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>

						<label class="control-label">邮政编码：</label>
						<div class="controls">
							<form:input path="postalCode" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">党组织编号：</label>
						<div class="controls">
							<form:input path="orgCode" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">建立日期：</label>
						<div class="controls">
							<form:input path="createDate" htmlEscape="false" maxlength="100" class="input-xlarge " readonly="true"/>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<label class="control-label">建立文号：</label>
					<div class="controls">
						<form:input path="createReferenceNum" htmlEscape="false" maxlength="100" class="input-xlarge "/>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<div>
							<label class="control-label">联系电话：</label>
							<div class="controls">
								<form:input path="telphone" htmlEscape="false" maxlength="20" class="input-xlarge "/>
							</div>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">负责人：</label>
						<div class="controls">
							<sys:treeselect id="user" name="user.id" value="${ccmPartyOrganiz.user.id}" labelName="user.name" labelValue="${ccmPartyOrganiz.user.name}"
											title="用户" url="/sys/office/treeData?type=3" cssClass="required" allowClear="true" notAllowSelectParent="true"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>			
			<tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC" colspan="2">
					<div>
						<label class="control-label">建立原因：</label>
						<div class="controls">
							<form:textarea path="createReason" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge required" style="width:950px"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			</table>
		</div>
		<div>
			<h4 class="tableNamefirst" id="DeptDetailBtn"		style="cursor: pointer;padding-top: 30px;">
				单位信息<i class=" icon-share-alt"></i>
			</h4>
			<table id="DeptDetailTable" border="1px" style="display: none;border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC">
						<div>
							<label class="control-label">单位名称：</label>
							<div class="controls">
								<form:input path="deptName" htmlEscape="false" maxlength="100" class="input-xlarge "/>
							</div>
						</div>
					</td>
					<td style="padding: 8px;border: 1px dashed #CCCCCC">
						<div>
							<label class="control-label">单位隶属关系：</label>
							<div class="controls">
								<form:select path="deptAttrRelation" class="input-xlarge ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</td>
				</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">单位属性：</label>
						<div class="controls">
							<form:select path="deptAttr" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">所属行业：</label>
						<div class="controls">
							<form:select path="deptIndustry" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">经济类型：</label>
						<div class="controls">
							<form:select path="deptEconomicType" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">企业类型：</label>
						<div class="controls">
							<form:select path="deptEnterpriseType" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">企业规模：</label>
						<div class="controls">
							<form:select path="deptEnterpriseScope" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">重要骨干企业：</label>
						<div class="controls">
							<form:radiobuttons path="deptImptEnterpriseFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">法人单位建立党的基层组织：</label>
						<div class="controls">
							<form:select path="deptLegalGrassOrg" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">政府工作部门建立党组织情况：</label>
						<div class="controls">
							<form:select path="deptGovePartOrg" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">城市街道社区乡镇标识：</label>
						<div class="controls">
							<form:select path="deptCityRoadInfo" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">中介组织类型：</label>
						<div class="controls">
							<form:select path="deptMediuOrgType" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">建立党员服务机构标识：</label>
						<div class="controls">
							<form:radiobuttons path="deptPartServFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">是否建立党员志愿者队伍：</label>
						<div class="controls">
							<form:radiobuttons path="deptPartPostFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">是否党建工作指导员联系：</label>
						<div class="controls">
							<form:radiobuttons path="deptSendPartFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">是否派出党建指导员：</label>
						<div class="controls">
							<form:radiobuttons path="deptParToFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
						</div>
					</div>
				</td>
			</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC">
						<div>
							<label class="control-label">党建指导员数量：</label>
							<div class="controls">
								<form:input path="deptPartNum" htmlEscape="false" maxlength="10" class="input-xlarge "/>
							</div>
						</div>
					</td>
					<td style="padding: 8px;border: 1px dashed #CCCCCC">
						<div>
							<label class="control-label">是否改制企业：</label>
							<div class="controls">
								<form:radiobuttons path="deptModfEnterFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding: 8px;border: 1px dashed #CCCCCC">
						<div>
							<label class="control-label">法定代表人是否党员：</label>
							<div class="controls">
								<form:radiobuttons path="deptLegalPartFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
							</div>
						</div>
					</td>
					<td style="padding: 8px;border: 1px dashed #CCCCCC">
						<div>
							<label class="control-label">法定代表兼任企业党组织书记：</label>
							<div class="controls">
								<form:radiobuttons path="deptLegalAllFlag" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
							</div>
						</div>
					</td>
				</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">在岗职工数从业人数：</label>
						<div class="controls">
							<form:input path="deptOnEmployeesNum" htmlEscape="false" maxlength="10" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">在岗职工中工人数：</label>
						<div class="controls">
							<form:input path="deptOnWorkersNum" htmlEscape="false" maxlength="10" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr><tr>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">35岁以下在岗职工数：</label>
						<div class="controls">
							<form:input path="deptTreeFiveNum" htmlEscape="false" maxlength="10" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td style="padding: 8px;border: 1px dashed #CCCCCC">
					<div>
						<label class="control-label">在岗专业技术人员：</label>
						<div class="controls">
							<form:input path="deptProfTechNum" htmlEscape="false" maxlength="10" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			</table>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="partybuild:ccmPartyOrganiz:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭"/>
		</div>
	</form:form>
</body>
</html>