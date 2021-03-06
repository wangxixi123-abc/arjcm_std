<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>政策法规管理</title>
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
			$("td").css({"padding":"8px"});
			$("td").css({"border":"0px dashed #CCCCCC"});
		});
	</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/know/ccmKnowPolicy/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/know/ccmKnowPolicy/form?id=${ccmKnowPolicy.id}">数据<shiro:hasPermission name="know:ccmKnowPolicy:edit">${not empty ccmKnowPolicy.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="know:ccmKnowPolicy:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmKnowPolicy" action="${ctx}/know/ccmKnowPolicy/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;border-top-color: white ">
			
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>效力级别：</label>
						<div class="controls">
							<form:select path="level" class="input-xlarge ">
								<form:options items="${fns:getDictList('sys_effe_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>类别：</label>
						<div class="controls">
							<form:select path="type" class="input-xlarge ">
								<form:options items="${fns:getDictList('sys_laws_class')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>标题：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="512" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">发文字号：</label>
						<div class="controls">
							<form:input path="lssNo" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">发布部门：</label>
						<div class="controls">
							<form:input path="relDept" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">发布日期：</label>
						<div class="controls">
							<input name="relDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmKnowPolicy.relDate}" pattern="yyyy-MM-dd"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">实施日期：</label>
						<div class="controls">
							<input name="impDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmKnowPolicy.impDate}" pattern="yyyy-MM-dd"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">批准部门：</label>
						<div class="controls">
							<form:input path="ratifyDept" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">批准日期：</label>
						<div class="controls">
							<input name="ratifyDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${ccmKnowPolicy.ratifyDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">时效性：</label>
						<div class="controls">
							<form:input path="prescription" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			
		</table>
			
		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			
			<tr>
				<td>
					<div>
						<label class="control-label">内容：</label>
						<div class="controls">
							<form:textarea path="content" htmlEscape="false" rows="30" maxlength="280"  class="input-xxlarge "/>
							<sys:ckeditor uploadPath="/know/ccmKnowPolicy" replace="content" height="200"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">附件一：</label>
						<div class="controls">
							<form:hidden id="file1" path="file1"  htmlEscape="false" maxlength="255" class="input-xxlarge"/>
				    		<sys:ckfinder input="file1" type="files" uploadPath="/know/ccmKnowPolicy" selectMultiple="true"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">附件二：</label>
						<div class="controls">
							<form:hidden id="file2" path="file2" htmlEscape="false" maxlength="255" class="input-xxlarge"/>
			       			<sys:ckfinder input="file2" type="files" uploadPath="/know/ccmKnowPolicy" selectMultiple="true"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">附件三：</label>
						<div class="controls">
							<form:hidden id="file3" path="file3" htmlEscape="false" maxlength="255" class="input-xxlarge"/>
				   			<sys:ckfinder input="file3" type="files" uploadPath="/know/ccmKnowPolicy" selectMultiple="true"/>
						</div>
					</div>
				</td>
			</tr>   
	    	
		</table>
		
		
		<div class="form-actions">
			<shiro:hasPermission name="know:ccmKnowPolicy:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>