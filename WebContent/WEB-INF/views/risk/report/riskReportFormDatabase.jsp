<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>稳评案例库管理</title>
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
		function saveList(){
			$("#inputForm").attr("action","${ctx}/report/riskReport/saveList");
			$("#inputForm").submit();
		}	
			
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/report/riskReport/listDatabase">稳评案例库列表</a></li>
		<li class="active"><a href="${ctx}/report/riskReport/formDatabase?id=${riskReport.id}">稳评案例库查看</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="riskReport" action="${ctx}/report/riskReport/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">所属重大事项：</label>
			<div class="controls">
				<sys:treeselect id="riskEventGreat" name="riskEventGreat.id" value="${riskReport.riskEventGreat.id}" labelName="riskEventGreat.name" labelValue="${riskReport.riskEventGreat.name}"
					title="重大事项" url="/report/riskIncident/treeData" cssClass="" allowClear="true" notAllowSelectParent="true" cssStyle="width: 150px"/>
				<span class="help-inline"><font color="red" id="show1">*</font> </span>	
			</div>
		</div>
		<!--  
		<div class="control-group">
			<label class="control-label">是否入库：</label>
			<div class="controls">
				<form:select path="isReserve" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>-->
		<div class="control-group">
			<label class="control-label">事项评估报告：</label>
			<div class="controls">
				<form:hidden id="file" path="file" htmlEscape="false" maxlength="256" class="input-xlarge"/>
				<sys:ckfinder input="file" type="files" uploadPath="/report/riskReport" selectMultiple="true"/>
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
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>