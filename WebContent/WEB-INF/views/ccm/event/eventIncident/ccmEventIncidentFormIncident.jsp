<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>护路护线事件登记管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
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
				$("td").css({"padding":"8px"});
				$("td").css({"border":"0px dashed #CCCCCC"});
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
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/line/ccmLineProtect/">护路护线列表</a></li>
		<li><a style="width: 140px;text-align:center" href="${ctx}/line/ccmLineProtect/form?id=${ccmEventIncident.otherId}">护路护线修改</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/event/ccmEventIncident/formIncident?otherId=${ccmEventIncident.otherId}&id=${ccmEventIncident.id}">案事件信息<shiro:hasPermission
					name="event:ccmEventIncident:edit">${not empty ccmEventIncident.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="event:ccmEventIncident:edit">查看</shiro:lacksPermission></a></li>
		<!--  编辑处理权限  
		<c:if test="${not empty ccmEventIncident.id}">
			<shiro:hasPermission name="event:ccmEventCasedeal:edit">
				<li><a href="${ctx}/event/ccmEventCasedeal/dealformIncident?eventIncidentId=${ccmEventIncident.id}">事件处理添加</a></li>
			</shiro:hasPermission>
		</c:if>-->
		<!--  只读处理权限  
		<shiro:hasPermission name="event:ccmEventCasedeal:viewRead">
			<li><a
				href="${ctx}/event/ccmEventIncident/readformIncident?otherId=${ccmEventIncident.otherId}&id=${ccmEventIncident.id}">查看线路案事件信息</a></li>
		</shiro:hasPermission>-->

	</ul>
	<form:form id="inputForm" modelAttribute="ccmEventIncident"
		action="${ctx}/event/ccmEventIncident/saveIncident" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="otherId" />
		<sys:message content="${message}" />
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red" id="show1">*</font></span>发案地：</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id"
							value="${ccmEventIncident.area.id}" labelName="area.name"
							labelValue="${ccmEventIncident.area.name}" title="区域"
							url="/sys/area/treeData" cssClass="" allowClear="true"
							notAllowSelectParent="false" cssStyle="width: 150px" />

						</div>
					</div>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span> 案事件名称：</label>
						<div class="controls">
							<form:input path="caseName" htmlEscape="false"
								maxlength="100" class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">发生日期：</label>
						<div class="controls">
							<input name="happenDate" type="text"
							readonly="readonly" maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmEventIncident.happenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">发案地代码：</label>
						<div class="controls">
							<form:input path="address" htmlEscape="false" maxlength="6" class="input-xlarge number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">发生地详址：</label>
						<div class="controls">
							<form:input path="happenPlace"
						htmlEscape="false" maxlength="200" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span> 案事件模块分类：</label>
						<div class="controls">
							<form:select path="eventKind" class="input-xlarge required">
								<form:option value="03" label="涉及路线" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span> 案事件类型：</label>
						<div class="controls">
							<form:select path="eventType" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_case_type')}" 
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">案事件编号：</label>
						<div class="controls">
							<form:input path="number" htmlEscape="false"
						maxlength="100" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span> 案事件性质：</label>
						<div class="controls">
							<form:select path="property" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('bph_alarm_info_typecode')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span> 案事件级别：</label>
						<div class="controls">
							<form:select path="eventScale" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_case_grad')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">主犯（嫌疑人）姓名：</label>
						<div class="controls">
							<form:input path="culName" htmlEscape="false"
						maxlength="80" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">主犯（嫌疑人）证件类型：</label>
						<div class="controls">
							<form:select path="culPapercode" class="input-xlarge " items="${fns:getDictList('sys_ccm_org_papers')}" itemLabel="label" itemValue="value" htmlEscape="false">
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">主犯（嫌疑人）证件号码：</label>
						<div class="controls">
							<form:input path="culPaperid"
						htmlEscape="false" maxlength="50" class="input-xlarge ident0 card" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">作案人数：</label>
						<div class="controls">
							<form:input path="numCrime" htmlEscape="false"
						maxlength="6" class="input-xlarge number digits"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">在逃人数：</label>
						<div class="controls">
							<form:input path="numFlee" htmlEscape="false"
						maxlength="6" class="input-xlarge number digits"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">抓捕人数：</label>
						<div class="controls">
							<form:input path="numArrest" htmlEscape="false"
							maxlength="6" class="input-xlarge number digits"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">侦查终结日期：</label>
						<div class="controls">
							<input name="caseOverDay" type="text"
							readonly="readonly" maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmEventIncident.caseOverDay}" pattern="yyyy-MM-dd HH:mm:ss"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">图标：</label>
						<div class="controls">
							<sys:iconselect id="image" name="image" value="${ccmEventIncident.image}"/>	
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">是否破案：</label>
						<div class="controls">
							<form:radiobuttons path="typeSolve"
							items="${fns:getDictList('yes_no')}" itemLabel="label"
							itemValue="value" htmlEscape="false" class="" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">区域图：</label>
						<div class="controls">
							<form:input path="areaMap" htmlEscape="false"
						maxlength="2000" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">中心点：</label>
						<div class="controls">
							<form:input path="areaPoint" htmlEscape="false"
						maxlength="40" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">案事件情况：</label>
						<div class="controls">
							<form:textarea path="caseCondition"
						htmlEscape="false" rows="4" maxlength="4000" class="input-xxlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">事件上报人评价：</label>
						<div class="controls">
							<form:textarea path="caseSolve"
						htmlEscape="false" rows="4" maxlength="4000" class="input-xxlarge " />
						</div>
					</div>
				</td>
			</tr> 
			<tr>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks"
								htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge " />
						</div>
					</div>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">附件一：</label>
						<div class="controls">
							<form:hidden id="file1" path="file1"  htmlEscape="false" maxlength="200" class="input-xxlarge"/>
				    		<sys:ckfinder input="file1" type="files" uploadPath="/event/ccmEventIncident" selectMultiple="false"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">附件二：</label>
						<div class="controls">
							<form:hidden id="file2" path="file2" htmlEscape="false" maxlength="24" class="input-xlarge"/>
						    <sys:ckfinder input="file2" type="files" uploadPath="/event/ccmEventIncident" selectMultiple="false"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">附件三：</label>
						<div class="controls">
							<form:hidden id="file3" path="file3" htmlEscape="false" maxlength="24" class="input-xlarge"/>
				   			<sys:ckfinder input="file3" type="files" uploadPath="/event/ccmEventIncident" selectMultiple="false"/>
						</div>
					</div>
				</td>
				<td>
				</td>
			</tr>	
			
		</table>
		
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td class="pad">事件处理信息：</td>
				<td class="pad" colspan="3">
					<table>
						<c:forEach items="${CcmEventCasedealList}" var="ccmeventcasedeal">
							<tr>
								<!-- 编辑处理权限   -->
								<shiro:hasPermission name="event:ccmEventCasedeal:edit">
									<li style="list-style-type: none;"><a
										href="${ctx}/event/ccmEventCasedeal/dealformIncident?id=${ccmeventcasedeal.id}">
											${ccmeventcasedeal.eventPrincipal}&nbsp; 于&nbsp; <fmt:formatDate
												value="${ccmeventcasedeal.updateDate}"
												pattern="yyyy-MM-dd HH:mm:ss" />&nbsp; 涉及线路处理事件的处理信息
									</a></li>
								</shiro:hasPermission>
								<!-- 只读处理权限   -->
								<shiro:hasPermission name="event:ccmEventCasedeal:viewRead">
									<!--  -->
									<li style="list-style-type: none;"><a
										href="${ctx}/event/ccmEventCasedeal/readformIncident?id=${ccmeventcasedeal.id}">
											${ccmeventcasedeal.eventPrincipal}&nbsp; 于&nbsp; <fmt:formatDate
												value="${ccmeventcasedeal.updateDate}"
												pattern="yyyy-MM-dd HH:mm:ss" />&nbsp; 涉及线路处理事件的处理信息
									</a></li>
								</shiro:hasPermission>
							</tr>
						</c:forEach>

					</table>

				</td>
			</tr>

		</table>

		<div class="form-actions">
			<shiro:hasPermission name="event:ccmEventIncident:edit">
				<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>