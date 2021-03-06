<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>土地管理</title>
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
		
		function ThisLayerDialog(src, title, height, width) {
			parent.drawForm = parent.layer.open({
				type: 2,
				title: title,
				area: [height, width],
				fixed: true, //固定
				maxmin: false,
				/*   btn: ['关闭'], //可以无限个按钮 */
				content: src,
				zIndex: '1992',
				cancel: function () {
					//防止取消和删除效果一样
					window.isCancel = true;
				},
				end: function () {
					if (!window.isCancel) {
						$("#areaPoint")[0].value = parent.areaPoint;
						parent.areaPoint = null;
						$("#areaMap")[0].value = parent.areaMap;
						parent.areaMap = null;
					}
					window.isCancel = null;
				}
			});
		}
	</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/citycomponents/ccmLand/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/citycomponents/ccmLand/form?id=${ccmLand.id}">数据<shiro:hasPermission name="citycomponents:ccmLand:edit">${not empty ccmLand.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="citycomponents:ccmLand:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmLand" action="${ctx}/citycomponents/ccmLand/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table border="1px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;border-top-color: white">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>地块名称：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required"/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>地块编码：</label>
						<div class="controls">
							<form:input path="code" htmlEscape="false" maxlength="64" class="input-xlarge required"/>

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span>所属区域：</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id" value="${ccmLand.area.id}" labelName="area.name" labelValue="${ccmLand.area.name}"
								title="区域" url="/tree/ccmTree/treeDataArea?type=6" cssClass="" allowClear="true" notAllowSelectParent="false"/>
							<span class="help-inline"><font color="red" id="show1"></font></span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">坐落位置：</label>
						<div class="controls">
							<form:input path="address" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>地块面积（平方米）：</label>
						<div class="controls">
							<form:input path="landArea" htmlEscape="false" maxlength="10" class="input-xlarge required digits" type="number"/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">土地使用者：</label>
						<div class="controls">
							<form:input path="user" htmlEscape="false" maxlength="100" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">用地性质：</label>
						<div class="controls">
							<form:select path="landUsage" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_land_usage')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">土地用途：</label>
						<div class="controls">
							<form:select path="type" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_land_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">使用期限：</label>
						<div class="controls">
							<input name="lifeTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
								value="<fmt:formatDate value="${ccmLand.lifeTime}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">坐标(点)：</label>
						<div class="controls">
							<form:input path="areaPoint" htmlEscape="false" maxlength="40" class="input-xlarge " disabled="true"/>
							<a onclick="ThisLayerDialog('${ctx}/event/ccmEventIncident/drawForm?areaMap='+$('#areaMap').val()+'&areaPoint='+$('#areaPoint').val(), '标注', '1100px', '700px');"
							   class="btn hide1 btn-primary">标 注</a>
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">坐标(面)：</label>
						<div class="controls">
							<form:input path="areaMap" htmlEscape="false" maxlength="2000" class="input-xlarge " disabled="true"/>
						</div>
					</div>
				</td>
				<td rowspan="2">
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>

				</td>

			</tr>
			<tr>

			</tr>
		</table>
		<div class="form-actions">
			<shiro:hasPermission name="citycomponents:ccmLand:edit"><input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>