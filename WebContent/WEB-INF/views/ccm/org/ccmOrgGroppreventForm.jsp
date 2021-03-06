<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>群防群治队伍管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			//关闭弹框事件
			$('#btnCancel').click(function() {
				parent.layer.close(parent.layerIndex);
			})
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
	<style type="text/css">
		.pad{padding: 5px; padding-left: 10px}
		#person{display: none;}
		#float{display: none;}
		#oversea{display: none;}
		/*
		.input-xlarge{width: 200px;}
        .select2-container.input-xlarge{width:215px;}
        .input-medium.Wdate {width: 200px;}
        */
	</style>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<%-- <li><a href="${ctx}/org/ccmOrgGropprevent/">数据列表</a></li>
		<li class="active"><a href="${ctx}/org/ccmOrgGropprevent/form?id=${ccmOrgGropprevent.id}">数据<shiro:hasPermission name="org:ccmOrgGropprevent:edit">${not empty ccmOrgGropprevent.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="org:ccmOrgGropprevent:edit">查看</shiro:lacksPermission></a></li> --%>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmOrgGropprevent" action="${ctx}/org/ccmOrgGropprevent/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%" >
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>组织名称:</label>
						<div class="controls">
							<form:select path="orgpreventId.id" class="input-xlarge required">
								<form:options items="${ccmOrgOrgpreventList}" itemLabel="comName" itemValue="id" htmlEscape="false"/>
							</form:select>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>姓名：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td >
					<div>
						<label class="control-label">人员照片：</label>
						<div class="controls">
							<form:hidden id="images" path="images" htmlEscape="false" maxlength="255" class="input-xlarge"/>
							<sys:ckfinder input="images" type="images" uploadPath="/photo/QunFangQunZhiDuiWu" selectMultiple="false" maxWidth="240" maxHeight="360"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>性别：</label>
						<div class="controls">
							<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" 
								itemValue="value" htmlEscape="false" class="required"/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>民族：</label>
						<div class="controls">
							<form:select path="nation" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sys_volk')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
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
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>证件类型：</label>
						<div class="controls">
							<form:select path="idenCode" class="input-xlarge required" items="${fns:getDictList('sys_ccm_org_papers')}" itemLabel="label" itemValue="value" htmlEscape="false">
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>证件号码：</label>
						<div class="controls">
							<form:input path="idenNum" htmlEscape="false" maxlength="30" class="input-xlarge required ident0 card"/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>出生日期：</label>
						<div class="controls">
							<input name="birthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
								   value="<fmt:formatDate value="${ccmOrgGropprevent.birthday}" pattern="yyyy-MM-dd"/>"
								   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td colspan="2">
					<div>
						<label class="control-label">专业特长：</label>
						<div class="controls">
							<form:checkboxes path="profExpertiseList" items="${fns:getDictList('ccm_pro_spe')}" 
								itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
						</div>
					</div>
				</td>
			</tr>
			
			<tr>
				<td>
					<div>
						<label class="control-label">职务：</label>
						<div class="controls">
							<form:input path="service" htmlEscape="false" maxlength="30" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>学历:</label>
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
						<label class="control-label">年龄：</label>
						<div class="controls">
							<form:input path="age" htmlEscape="false" maxlength="255" class="input-xlarge digits required" type="number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">健康情况：</label>
						<div class="controls">
							<form:select path="health" class="input-xlarge">
								<form:options items="${fns:getDictList('ccm_phy_cdt')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>手机号码：</label>
						<div class="controls">
							<form:input path="telephone" htmlEscape="false" maxlength="18" class="input-xlarge required mobile"/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">固定电话：</label>
						<div class="controls">
							<form:input path="fixTel" htmlEscape="false" maxlength="18" class="input-xlarge simplePhone "/>
						</div>
					</div>
				</td>
			</tr>
			
			<tr>
				<td>
					<div>
						<label class="control-label">现任职务：</label>
						<div class="controls">
							<form:select path="duty" class="input-xlarge">
								<form:options items="${fns:getDictList('present_occupation')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
		</table>	
		
		<div class="form-actions">
			<shiro:hasPermission name="org:ccmOrgGropprevent:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/> -->
			<input id="btnCancel" class="btn btn-danger" type="button" value="关 闭"/>
		</div>
	</form:form>
</body>
</html>