<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>设备管理</title>
	<meta name="decorator" content="technology"/>
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
			$("td").css({"border":"1px dashed #CCCCCC"});
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
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
</head>
<body>
	<br/>
	<form:form id="inputForm" modelAttribute="ccmDevice" action="${ctx}/ccmsys/ccmDevice/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		
		<table border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; width: 100%" >
			<tr>
				<td>
					<div>
						<label class="control-label">设备编号：</label>
						<div class="controls">
							<form:input readonly="true" path="code" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">设备名称：</label>
						<div class="controls">
							<form:input readonly="true" path="name" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
						    <span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">IP地址：</label>
						<div class="controls">
							<form:input readonly="true" path="ip" htmlEscape="false" maxlength="15" class="input-xlarge required ip"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">子网掩码：</label>
						<div class="controls">
							<form:input readonly="true" path="mask" htmlEscape="false" maxlength="15" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">网关：</label>
						<div class="controls">
							<form:input readonly="true" path="gateway" htmlEscape="false" maxlength="15" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">代理IP及端口：</label>
						<div class="controls">
							<form:input readonly="true" path="proxy" htmlEscape="false" maxlength="22" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">协议：</label>
						<div class="controls">
							<form:input readonly="true" path="protocol" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">端口：</label>
						<div class="controls">
							<form:input readonly="true" path="port" htmlEscape="false" maxlength="5" class="input-xlarge required number"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">SDK端口号：</label>
						<div class="controls">
							<form:input readonly="true" path="sdkPort" htmlEscape="false" maxlength="5" class="input-xlarge required number"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">通道号：</label>
						<div class="controls">
							<form:input readonly="true" path="channelNum" htmlEscape="false" maxlength="3" class="input-xlarge required number"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">设备参数信息：</label>
						<div class="controls">
							<form:input readonly="true" path="param" htmlEscape="false" maxlength="1000" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">登陆账号：</label>
						<div class="controls">
							<form:input readonly="true" path="account" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">密码：</label>
						<div class="controls">
							<form:input readonly="true" path="password" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">设备类型：</label>
						<div class="controls">
							<form:select disabled="true" path="typeId" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_device_type_id')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>	
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font></span>所属区域：</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id" value="${ccmDevice.area.id}" labelName="area.name" labelValue="${ccmDevice.area.name}"
							title="区域" url="/sys/area/treeData" cssClass="" allowClear="true" notAllowSelectParent="true"/>
							<span class="help-inline"><font color="red" id="show1"></font></span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">安装位置：</label>
						<div class="controls">
							<form:input readonly="true" path="address" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">设备状态：</label>
						<div class="controls">
							<form:select disabled="true" path="status" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_device_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">厂商：</label>
						<div class="controls">
							<form:input readonly="true" path="companyId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">版本：</label>
						<div class="controls">
							<form:input readonly="true" path="version" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">图片：</label>
						<div class="controls">
							<form:input readonly="true" path="imagePath" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">设备坐标：</label>
						<div class="controls">
							<form:input readonly="true" path="coordinate" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">摄像机类型：</label>
						<div class="controls">
							<form:select disabled="true" path="typeVidicon" class="input-xlarge required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_devicel_type_vidicon')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>	
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">说明：</label>
						<div class="controls">
							<form:textarea disabled="true" path="description" htmlEscape="false" rows="4" maxlength="1000" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
				</td>
			</tr>
			
		</table>	
		<%-- <div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div> --%> 
		<!-- <div class="control-group">
			<label class="control-label">父节点ID：</label>
			<div class="controls">
			</div>
		</div> -->
	</form:form>
</body>
</html>