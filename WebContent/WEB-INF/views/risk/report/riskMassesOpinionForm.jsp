<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>社情民意调查管理</title>
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
		function saveForm(){
			var riskEventGreatId = $("#riskEventGreatId").val();
			var html1 = '<label for="" class="error">必填信息 *<label>';
			//alert(riskEventGreatId.length);
			if(riskEventGreatId.length!=0){
				$("#show1").html("*");
			}else{
				$("#show1").html(html1);
			}

			var fileName = $("#filePreview li a:first-child").html();
			$("#fileName").val(fileName);
			var file = $("#file").val();
			if(file.length!=0){
				$("#show2").html("*");
			}else{
				$("#show2").html(html1);
			}
			if(riskEventGreatId.length!=0 && file.length!=0){
				$("#inputForm").submit();
			}
			
			
		}
		//riskEventGreatId
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/report/riskMassesOpinion/">社情民意调查列表</a></li>
		<li class="active"><a href="${ctx}/report/riskMassesOpinion/form?id=${riskMassesOpinion.id}">社情民意调查<shiro:hasPermission name="report:riskMassesOpinion:edit">${not empty riskMassesOpinion.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="report:riskMassesOpinion:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="riskMassesOpinion" action="${ctx}/report/riskMassesOpinion/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="fileName" htmlEscape="false" maxlength="256" class="input-xlarge" />
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">所属重大事项：</label>
			<div class="controls">
				<sys:treeselect id="riskEventGreat" name="riskEventGreat.id" value="${riskMassesOpinion.riskEventGreat.id}" labelName="riskEventGreat.name" labelValue="${riskMassesOpinion.riskEventGreat.name}"
					title="重大事项" url="/report/riskIncident/treeData" cssClass="" allowClear="true" notAllowSelectParent="true" cssStyle="width: 150px"/>
				<span class="help-inline"><font color="red" id="show1">*</font> </span>	
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">类型：</label>
			<div class="controls">
				<form:select path="type" class="input-xlarge required">
					<form:options items="${fns:getDictList('risk_masses_opinion_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">上传问卷结果：</label>
			<div class="controls">
				<form:hidden id="file" path="file" htmlEscape="false" maxlength="256" class="input-xlarge required"/>
				<sys:ckfinder input="file" type="files" uploadPath="/report/riskMassesOpinion" selectMultiple="true"/>
				<span class="help-inline"><font color="red" id="show2">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="report:riskMassesOpinion:edit"><input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button" value="确定"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>