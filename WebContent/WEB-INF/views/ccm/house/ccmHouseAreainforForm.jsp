<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>辖区信息管理</title>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
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
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/house/ccmHouseAreainfor/">辖区信息列表</a></li>
		<li class="active"><a href="${ctx}/house/ccmHouseAreainfor/form?id=${ccmHouseAreainfor.id}">辖区信息<shiro:hasPermission name="house:ccmHouseAreainfor:edit">${not empty ccmHouseAreainfor.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="house:ccmHouseAreainfor:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="ccmHouseAreainfor" action="${ctx}/house/ccmHouseAreainfor/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<h4 class="tableNamefirst">辖区简介</h4>
		<table border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 90%;">
		    <tr>
				<td class="pad"><span class="help-inline"><font color="red">*</font> </span>辖区名称：</td>
				<td class="pad"><sys:treeselect id="area" name="area.id" value="${ccmHouseAreainfor.area.id}" labelName="area.name" labelValue="${ccmHouseAreainfor.area.name}" title="区域" url="/sys/area/treeData" cssClass="" allowClear="true" notAllowSelectParent="false"/><span class="help-inline"><font color="red" id="show1"></font> </span></td>
		    </tr>		
		    <tr>		
				<td class="pad">辖区说明：</td>
				<td class="pad"><form:textarea path="areainfor" htmlEscape="false" rows="10" maxlength="280"  class="input-xxlarge required"/><sys:ckeditor uploadPath="/house/ccmHouseAreainfor" replace="areainfor" height="200"/></td>
		    </tr>		
		  
		   <%--  <tr>		
				<td class="pad">冗余字段1：</td>
				<td class="pad">
			        <form:input path="more1" htmlEscape="false" maxlength="100" class="input-xlarge "/>
				</td>
		   </tr>	
		  
		   <tr>
				<td class="pad">冗余字段2：</td>
				<td class="pad" colspan="3">
				     <form:input path="more2" htmlEscape="false" maxlength="100" class="input-xlarge "/>
				</td>	
	       </tr>	 --%>
		  
		    <tr>
				<td class="pad">备注信息：</td>
				<td class="pad" colspan="3"> <form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="255" class="input-xxlarge " /></td>	
	        </tr>		
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="house:ccmHouseAreainfor:edit">
			<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>