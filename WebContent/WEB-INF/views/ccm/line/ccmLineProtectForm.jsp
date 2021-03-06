<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>护路护线管理</title>
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				//$("#name").focus();
				$("#inputForm")
						.validate(
								{
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
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/line/ccmLineProtect/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head"
			href="${ctx}/line/ccmLineProtect/form?id=${ccmLineProtect.id}">数据<shiro:hasPermission
					name="line:ccmLineProtect:edit">${not empty ccmLineProtect.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="line:ccmLineProtect:edit">查看</shiro:lacksPermission></a></li>
<%--		<c:if test="${not empty ccmLineProtect.id}">
			<li><a
				href="${ctx}/event/ccmEventIncident/formIncident?otherId=${ccmLineProtect.id}">案事件登记添加</a></li>
		</c:if>--%>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmLineProtect"
		action="${ctx}/line/ccmLineProtect/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />

		<table class="table table-bordered table-hover" >
			<tr>
				<td style="border-top-color: white">
					<div>
						<label class="control-label"><span class="help-inline"><font color="red" id="show1">*</font></span>名称：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="30"
								class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>线路类型：</label>
						<div class="controls">
							<form:select path="lineType" class="input-xlarge required" >
								<form:options items="${fns:getDictList('ccm_line_type')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>隶属单位名称：</label>
						<div class="controls">
							<form:input path="compName" htmlEscape="false" maxlength="50"
								class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>隶属单位详址：</label>
						<div class="controls">
							<form:input path="compAdd" htmlEscape="false" maxlength="200"
								class="input-xlarge required" />

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>隶属单位联系方式：</label>
						<div class="controls">
							<form:input path="compTel" htmlEscape="false" maxlength="18"
								class="input-xlarge phone required" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>隶属单位负责人姓名：</label>
						<div class="controls">
							<form:input path="compPrinName" htmlEscape="false" maxlength="50"
								class="input-xlarge required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>隶属单位负责人联系方式：</label>
						<div class="controls">
							<form:input path="compPrinTel" htmlEscape="false" maxlength="18"
								class="input-xlarge  phone required" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>管辖单位名称：</label>
						<div class="controls">
							<form:input path="goveName" htmlEscape="false" maxlength="50"
								class="input-xlarge required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>管辖单位详址：</label>
						<div class="controls">
							<form:input path="goveAdd" htmlEscape="false" maxlength="200"
								class="input-xlarge required" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>管辖单位联系方式：</label>
						<div class="controls">
							<form:input path="goveTel" htmlEscape="false" maxlength="18"
								class="input-xlarge phone required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>分管治保负责人姓名：</label>
						<div class="controls">
							<form:input path="secuName" htmlEscape="false" maxlength="50"
								class="input-xlarge required" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>分管治保负责人联系方式：</label>
						<div class="controls">
							<form:input path="secuTel" htmlEscape="false" maxlength="18"
								class="input-xlarge phone required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>治安隐患等级：</label>
						<div class="controls">
							<form:select path="dangGrade" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_secu_grade')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">线路：</label>
						<div class="controls">
							<form:input path="line" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td colspan="2">
					<div>
						<label class="control-label">治安隐患情况：</label>
						<div class="controls ">
							<form:textarea path="dangCase" htmlEscape="false" rows="10"
								maxlength="4000" class="input-xxlarge" />
							<sys:ckeditor uploadPath="/line/ccmLineProtect"
								replace="dangCase" height="200" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4"
								maxlength="255" class="input-xxlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>

				<td class="pad" colspan="2">
					<div>
						<label class="control-label">涉及线路案事件信息：</label>
						<div class="controls">
							<table>
								<c:forEach items="${ccmEventIncidentList}"
									var="ccmEventIncident">
									<tr>
										<!-- 编辑处理权限   -->
										<shiro:hasPermission name="event:ccmEventIncident:edit">
											<li style="list-style-type: none;"><a
												href="${ctx}/event/ccmEventIncident/formIncident?id=${ccmEventIncident.id}">
													${ccmEventIncident.caseName}&nbsp; 于&nbsp; <fmt:formatDate
														value="${ccmEventIncident.updateDate}"
														pattern="yyyy-MM-dd HH:mm:ss" />&nbsp; 涉及线路案事件信息
											</a></li>
										</shiro:hasPermission>
										<!-- 只读处理权限  
												<shiro:hasPermission name="event:ccmEventIncident:viewRead">
													<li style="list-style-type: none;"><a
														href="${ctx}/event/ccmEventIncident/readformIncident?id=${ccmEventIncident.id}">
															${ccmEventIncident.caseName}&nbsp; 于&nbsp; <fmt:formatDate
																value="${ccmEventIncident.updateDate}"
																pattern="yyyy-MM-dd HH:mm:ss" />&nbsp; 涉及线路案事件信息
													</a></li>
												</shiro:hasPermission> -->
									</tr>
								</c:forEach>

							</table>
						</div>
					</div>
				</td>
			</tr>
		</table>


		<div class="form-actions">
			<shiro:hasPermission name="line:ccmLineProtect:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>