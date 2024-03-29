<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>脱贫攻坚管理</title>
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
		});

		function getspAlleviation() {
			if($("#spAlleviation").val()==02){
				$("#spIncomeType").attr("disabled",true);
				$("#spIncomeAmount").attr("disabled",true);
				$("#spTime").attr("disabled",true);
				$("#spIncomeType").val("");
				$("#s2id_spIncomeType").find(".select2-chosen").text("");
				$("#spIncomeAmount").val("");
				$("#spTime").val("");
			} else {
				$("#spIncomeType").removeAttr("disabled");
				$("#spIncomeAmount").removeAttr("disabled");
				$("#spTime").removeAttr("disabled");
			}
		}

	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/shake/ccmShakePovertyPeople/">数据列表</a></li>
		<li class="active"><a href="${ctx}/shake/ccmShakePovertyPeople/form?id=${ccmShakePovertyPeople.id}">数据<shiro:hasPermission name="shake:ccmShakePovertyPeople:edit">${not empty ccmShakePovertyPeople.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="shake:ccmShakePovertyPeople:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmShakePovertyPeople" action="${ctx}/shake/ccmShakePovertyPeople/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">姓名：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">性别：</label>
			<div class="controls">
				<form:select path="sex" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所属网格：</label>
			<div class="controls">
				<sys:treeselect id="areaGridId" name="areaGridId.id" value="${ccmShakePovertyPeople.areaGridId.id}" labelName="areaGridId.name" labelValue="${ccmShakePovertyPeople.areaGridId.name}"
					title="区域" url="/sys/area/treeData" allowClear="true" notAllowSelectParent="true" cssClass="required"/>
							<span class="help-inline"><font color="red">*</font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">公民身份号码：</label>
			<div class="controls">
				<form:input path="ident" htmlEscape="false" maxlength="18" class="input-xlarge ident0 card required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">户主公民身份号码：</label>
			<div class="controls">
				<form:input path="accountidentity" htmlEscape="false" maxlength="18" class="input-xlarge ident1 card"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">出生日期：</label>
			<div class="controls">
				<input name="birthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
					value="<fmt:formatDate value="${ccmShakePovertyPeople.birthday}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">建档时间：</label>
			<div class="controls">
				<input name="filingTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
					value="<fmt:formatDate value="${ccmShakePovertyPeople.filingTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">乡镇：</label>
			<div class="controls">
				<sys:treeselect id="areaTownId" name="areaTownId.id" value="${ccmShakePovertyPeople.areaTownId.id}" labelName="areaTownId.name" labelValue="${ccmShakePovertyPeople.areaTownId.name}"
					title="区域" url="/sys/area/treeData" allowClear="true" notAllowSelectParent="false" cssClass="required"/>
							<span class="help-inline"><font color="red">*</font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">社区：</label>
			<div class="controls">
				<sys:treeselect id="areaCommunityId" name="areaCommunityId.id" value="${ccmShakePovertyPeople.areaCommunityId.id}" labelName="areaCommunityId.name" labelValue="${ccmShakePovertyPeople.areaCommunityId.name}"
					title="区域" url="/sys/area/treeData" allowClear="true" notAllowSelectParent="false" cssClass="required"/>
							<span class="help-inline"><font color="red">*</font>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">脱贫属性：</label>
			<div class="controls">
				<form:select path="spAlleviation" class="input-xlarge " onclick="getspAlleviation()">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_shake_poverty_people_sp_alleviation')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">贫困户属性：</label>
			<div class="controls">
				<form:select path="spPeopleAlleviation" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_shake_poverty_people_sp_people_alleviation')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">致贫原因：</label>
			<div class="controls">
				<form:select path="spReason" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_shake_poverty_people_sp_reason')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">健康状况：</label>
			<div class="controls">
				<form:select path="spHealth" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_shake_poverty_people_sp_health')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">贫困人口劳动技能：</label>
			<div class="controls">
				<form:select path="spLaborSkill" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_shake_poverty_people_sp_labor_skill')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">脱贫户收入类型：</label>
			<div class="controls">
				<form:select path="spIncomeType" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_shake_poverty_people_sp_income_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">脱贫户收入金额：</label>
			<div class="controls">
				<form:input path="spIncomeAmount" htmlEscape="false" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">脱贫时间：</label>
			<div class="controls">
				<input name="spTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${ccmShakePovertyPeople.spTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="shake:ccmShakePovertyPeople:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>