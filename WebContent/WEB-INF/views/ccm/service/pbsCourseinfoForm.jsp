<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务学习管理</title>
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
	</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/service/pbsCourseinfo/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/service/pbsCourseinfo/form?id=${pbsCourseinfo.id}">数据<shiro:hasPermission name="service:pbsCourseinfo:edit">${not empty pbsCourseinfo.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="service:pbsCourseinfo:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="pbsCourseinfo" action="${ctx}/service/pbsCourseinfo/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<%-- <div class="control-group">
			<label class="control-label">科目id：</label>
			<div class="controls">
				<form:input path="sParentid" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div> --%>
		<div class="control-group" style="padding-top: 8px">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>课程类型：</label>
			<div class="controls">
				<form:select path="sType" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('pbs_courseinfo_stype')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>

			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>课程名称：</label>
			<div class="controls">
				<form:input path="sName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">课程排序：</label>
			<div class="controls">
				<form:input path="iSort" htmlEscape="false" maxlength="10" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">图片：</label>
			<div class="controls">
				<%-- <form:input path="sIconurl" htmlEscape="false" maxlength="1000" class="input-xlarge "/> --%>
				<form:hidden id="sIconurl" path="sIconurl" htmlEscape="false" maxlength="1000" class="input-xlarge" />
                <sys:ckfinder input="sIconurl" type="images" uploadPath="/course/pbsCourseinfo/images"   />
			</div>
		</div>
	<%-- 	<div class="control-group">
			<label class="control-label">文件类型：</label>
			<div class="controls">
				<form:input path="sFiletype" htmlEscape="false" maxlength="50" class="input-xlarge "/>
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">附件：</label>
			<div class="controls">
				<%-- <form:input path="sFileurl" htmlEscape="false" maxlength="1000" class="input-xlarge "/> --%>
				<form:hidden id="sFileurl" path="sFileurl" htmlEscape="false"
					maxlength="1000" class="input-xlarge" />
				<sys:ckfinder input="sFileurl" type="files"
					uploadPath="/service/pbsCourseinfo"  />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">课程内容：</label>
			<div class="controls">
				<form:textarea path="sContent" htmlEscape="false" rows="4"
                    maxlength="255" class="input-xxlarge " />
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">备用字段：</label>
			<div class="controls">
				<form:input path="sSpare01" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备用字段：</label>
			<div class="controls">
				<form:input path="sSpare02" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备用字段：</label>
			<div class="controls">
				<form:input path="sSpare03" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备用字段：</label>
			<div class="controls">
				<form:input path="sSpare04" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="service:pbsCourseinfo:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>