<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>请求登记管理</title>
<meta name="decorator" content="default" />
<link rel="stylesheet" href="${ctxStatic}/ccm/event/css/fishBoneCase.css" />
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/fishBoneCase.js"></script>
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
<script charset="utf-8" type="text/javascript" >
$(document).ready(
	 	function() {
				// $("#name").focus();
				$("#inputForm").validate(
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
						if (element.is(":checkbox") || element.is(":radio")
							|| element.parent().is(".input-append")) {
							error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			var jsonString = '${CcmEventCasedealList}';
			data = JSON.parse(jsonString);  
			//创建事件历史
			$(".fishBone1").fishBone(data, '${ctx}','deal');
			$(".fishBone2").fishBone(data, '${ctx}','read');
		});
		
function saveForm() {
	var area = $("#areaId").val();
	var html1 = '<label for="" class="error">必选字段 *<label>';
	//alert(officeId.length);
	if (area.length != 0) {
		$("#show1").html("*");
	} else {
		$("#show1").html(html1);
	}

	if (area.length != 0) {
		$("#inputForm").submit();
	}

}
</script>
<style type="text/css">
	td{padding: 8px;border: 1px dashed #CCCCCC}
</style>
</head>
<body>
	<br />
	<form:form id="inputForm" modelAttribute="ccmEventRequest"
		action="${ctx}/event/ccmEventRequest/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<table border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label">请求名称：</label>
						<div class="controls">
							<form:input path="caseName" htmlEscape="false"
							maxlength="100" class="input-xlarge required" />
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td rowspan="5">
					<div>
						<label class="control-label">图片：</label>
						<div class="controls">
							<form:hidden id="icon" path="icon" htmlEscape="false" maxlength="255" class="input-xlarge"/>
							<sys:ckfinder input="icon" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="120" maxHeight="180"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">发生日期：</label>
						<div class="controls">
							<input name="happenDate" type="text"
							readonly="readonly" maxlength="20" class="input-medium Wdate "
							value="<fmt:formatDate value="${ccmEventRequest.happenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">请求种类：</label>
						<div class="controls">
							<form:select path="eventKind" class="input-xlarge ">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_event_inci_kind')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td><label class="control-label">请求地点：</label>
					<div class="controls">
							<sys:treeselect id="area" name="area.id"
											value="${ccmEventRequest.area.id}" labelName="area.name"
											labelValue="${ccmEventRequest.area.name}" title="区域"
											url="/sys/area/treeData" allowClear="true"
											notAllowSelectParent="true" cssStyle="width: 220.22px" cssClass=""/>
						<span class="help-inline"><font color="red" id="show1">*</font>
						</span>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">详址：</label>
						<div class="controls">
							<form:input path="happenPlace"
							htmlEscape="false" maxlength="200" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>

			<c:if test="${not empty ccmEventRequest.id}">
				<shiro:hasPermission name="event:ccmEventRequest:edit">
					<tr>
						<td>
							<div>
								<label class="control-label">区域图：</label>
								<div class="controls">
									<form:input path="areaMap" readonly="true" htmlEscape="false"
												maxlength="2000" class="input-xlarge " />
								</div>
							</div>
						</td>
						<td>
							<div>
								<label class="control-label">中心点：</label>
								<div class="controls">
									<form:input path="areaPoint" readonly="true" htmlEscape="false"
												maxlength="40" class="input-xlarge " />
								</div>
							</div>
						</td>
					</tr>
				</shiro:hasPermission>
			</c:if>

			<tr>
				<td>
					<div>
						<label class="control-label">请求内容：</label>
						<div class="controls">
							<form:input path="caseCondition" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">处理：</label>
						<div class="controls">
							<form:select path="type" class="input-xlarge ">
								<c:if test="${empty ccmEventRequest.id}"><form:option value="01" label="未处理"/></c:if>
								<c:if test="${not empty ccmEventRequest.id}">
								<form:options items="${fns:getDictList('ccm_event_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</c:if>
							</form:select></td>
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
							htmlEscape="false" rows="4" maxlength="255" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">附件：</label>
						<div class="controls">
							<form:hidden id="file" path="file"  htmlEscape="false" maxlength="255" class="input-xxlarge"/>
				    		<sys:ckfinder input="file" type="files" uploadPath="/event/ccmEventRequest" selectMultiple="false"/>
						</div>
					</div>
				</td>
			</tr>
		</table>
		

		<div class="form-actions">
			<shiro:hasPermission name="event:ccmEventRequest:edit">
				<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button"
					value="保 存" />&nbsp;</shiro:hasPermission>
		</div>

	</form:form>
	<br/>
	<c:if test="${CasedealListNumber > 0}">
		<shiro:hasPermission name="event:ccmEventCasedeal:edit">
			<h4>&nbsp;修改处理信息：</h4>
			<div class="fishBone1" ></div>
		</shiro:hasPermission>
		<shiro:lacksPermission name="event:ccmEventCasedeal:edit">
			<h4>&nbsp;查看处理信息：</h4>
			<div class="fishBone2" ></div>
		</shiro:lacksPermission> 
	</c:if>
</body>
</html>