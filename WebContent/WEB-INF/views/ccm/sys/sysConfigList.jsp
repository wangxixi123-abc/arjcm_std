<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<link
		href="https://cdn.bootcss.com/bootstrap-switch/3.0.0/css/bootstrap3/bootstrap-switch.css"
		rel="stylesheet">

<script
		src="https://cdn.bootcss.com/bootstrap-switch/3.0.0/js/bootstrap-switch.js"></script>
<html>
<head>
	<title>系统信息配置管理</title>
	<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document)
				.ready(
						function() {
							parent.$.jBox.tip('正在更新配置信息 ');
							$('#btnSubmit1').click(function() {
								$('#inputFormSystemLevel').submit();
							});
							$('#btnSubmit2').click(function() {
								$('#inputFormLogSaveConfig').submit();
							});
							$('#btnSubmit3').click(function() {
								$('#inputFormUpperSystemConfig').submit();
							});
							$('#btnSubmit4').click(function() {
								$('#inputFormPreviewSystemConfig').submit();
							});
							$('#btnSubmit5').click(function() {
								$('#inputFormAlarmColorLevel').submit();
							});
							$('#btnSubmit6').click(function() {
								$('#alarmCheckSystemConfig').submit();
							});
							$('#btnSubmit7').click(function() {
								$('#inputFormAlarmDataConfig').submit();
							});
							$('#btnSubmit8').click(function() {
								$('#inputFormEmphasisPeopleConfig').submit();
							});
							$('#btnSubmit9').click(function() {
								$('#inputFormHikvisonVideoConfig').submit();
							});
							$('#btnGetCameras').click(function() {
								$.getJSON("/arjccm/app/videoData/getCameras",function(data){
									if(data.code == 0){
										alert("获取监控设备中");
									}else{
										alert("配置信息有误");
									}
								})
							});
							$('#btnSubmit11').click(function() {
								$('#inputFormTiandyVideoConfig').submit();
							});
							$('#btnGetTiandyCameras').click(function() {
								$.getJSON("/arjccm/app/videoData/getTiandyCameras",function(data){
									if(data.code == 0){
										alert("获取监控设备中");
									}else{
										alert("配置信息有误");
									}
								})
							});
							// 自定义地图层级
							$('#btnSubmit10').click(function () {
								$('#inputFormMapLevel').submit();
							});
							$("#inputFormMapLevel")
									.validate(
											{
												submitHandler: function (form) {
													var quXian = $('#quXian').val();
													var jieDaoMin = $('#jieDaoMin')
															.val();
													var jieDaoMax = $('#jieDaoMax')
															.val();
													var sheQuMin = $('#sheQuMin')
															.val();
													var sheQuMax = $('#sheQuMax')
															.val();
													var wangGe = $('#wangGe').val();
													if (Number(jieDaoMin) <= Number(quXian)) {
														$.jBox.tip('社区层级最低值应大于街道最高值');
														return;
													}
													if (Number(jieDaoMax) <= Number(jieDaoMin)) {
														$.jBox.tip('社区层级最高值应大于社区层级最低值');
														return;
													}
													if (Number(sheQuMin) <= Number(jieDaoMax)) {
														$.jBox.tip('网格层级最低值应大于社区层级最高值');
														return;
													}
													if (Number(sheQuMax) <= Number(sheQuMin)) {
														$.jBox.tip('网格层级最高值应大于网格层级最低值');
														return;
													}
													if (Number(wangGe) <= Number(sheQuMax)) {
														$.jBox.tip('楼栋层级最低值应大于网格层级最高值');
														return;
													}
													$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
													form.submit();
												},
												errorContainer: "#messageBox",
												errorPlacement: function (error,
																		  element) {
													$("#messageBox").text(
															"输入有误，请先更正。");
													if (element.is(":checkbox")
															|| element.is(":radio")
															|| element
																	.parent()
																	.is(
																			".input-append")) {
														error.appendTo(element
																.parent().parent());
													} else {
														error.insertAfter(element);
													}
												}
											});

							$("#inputFormAlarmColorLevel")
									.validate(
											{
												submitHandler : function(form) {
													var green = $('#green').val();
													var yellowMin = $('#yellowMin')
															.val();
													var yellowMax = $('#yellowMax')
															.val();
													var orangeMin = $('#orangeMin')
															.val();
													var orangeMax = $('#orangeMax')
															.val();
													var red = $('#red').val();
													if (Number(yellowMin) <= Number(green)) {
														$.jBox.tip('黄色最低值应大于绿色最高值');
														return;
													}
													if (Number(yellowMax) <= Number(yellowMin)) {
														$.jBox.tip('黄色最高值应大于黄色最低值');
														return;
													}
													if (Number(orangeMin) <= Number(yellowMax)) {
														$.jBox.tip('橙色最低值应大于黄色最高值');
														return;
													}
													if (Number(orangeMax) <= Number(orangeMin)) {
														$.jBox.tip('橙色最高值应大于橙色最低值');
														return;
													}
													if (Number(red) <= Number(orangeMax)) {
														$.jBox.tip('红色最低值应大于橙色最高值');
														return;
													}
													$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
													form.submit();
												},
												errorContainer : "#messageBox",
												errorPlacement : function(error,
																		  element) {
													$("#messageBox").text(
															"输入有误，请先更正。");
													if (element.is(":checkbox")
															|| element.is(":radio")
															|| element
																	.parent()
																	.is(
																			".input-append")) {
														error.appendTo(element
																.parent().parent());
													} else {
														error.insertAfter(element);
													}
												}
											});
							$("td").css({
								"padding" : "8px"
							});
							$("td").css({
								"border" : "1px dashed #CCCCCC"
							});

							//$('#handleModelSelect').hide();
						});
		function page(n, s) {
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
			return false;
		}
		function alarmHandleModel(flag) {
			if ($('#alarmHandleFlag').val() == '1') {
				$('#handleModelSelect').show();
			} else {
				$('#handleModelSelect').hide();
			}

		}
	</script>

	<style type="text/css">
		.lableStyle {
			width: 70px;
			margin-right: 10px;
			text-align: right;
		}
		.form-horizontal {
			padding-top: 8px;
		}
		.high {
			margin-bottom: 10px
		}
		#btnGetCameras,#btnGetTiandyCameras{
			width: 100px!important;
		}
	</style>
</head>
<body>
<ul class="nav nav-tabs">
	<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/sys/sysConfig/listForm">系统信息配置</a></li>
</ul>
<!--<sys:message content="${message}"/>	-->
<!-- 系统应用级别 -->
<form:form id="inputFormSystemLevel" modelAttribute="systemLevel"
		   action="${ctx}/sys/sysConfig/save" method="post"
		   class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<label class="control-label">系统应用级别：</label>
		<div class="controls">
			<form:select path="paramStr" class="input-medium">
				<form:options items="${fns:getDictList('sys_config_system_level')}"
							  itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
			<span style="float: right; margin-right: 200px"> <shiro:hasPermission
					name="sys:sysConfig:edit">
						<a id="btnSubmit1" class="btn btn-primary" href="javascript:;"><i
								class="icon-ok"></i>保存</a>
			</shiro:hasPermission>
				</span>
		</div>
	</div>
</form:form>
<!-- 日志保存天数 -->
<form:form id="inputFormLogSaveConfig" modelAttribute="logSaveConfig"
		   action="${ctx}/sys/sysConfig/save" method="post"
		   class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<label class="control-label">${logSaveConfig.remarks}：</label>
		<div class="controls">
			<form:input path="paramInt" htmlEscape="false" maxlength="8"
						class="input-xlarge digits" type="number" />
			<span style="float: right; margin-right: 200px"> <shiro:hasPermission
					name="sys:sysConfig:edit">
						<a id="btnSubmit2" class="btn btn-primary" href="javascript:;"><i
								class="icon-ok"></i>保存</a>
			</shiro:hasPermission>
				</span>
		</div>
	</div>
</form:form>
<!-- 上级域系统设置 -->
<form:form id="inputFormUpperSystemConfig"
		   modelAttribute="upperSystemConfig" action="${ctx}/sys/sysConfig/save"
		   method="post" class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<label class="control-label">${upperSystemConfig.remarks}：</label>
		<div class="controls">
			<br> <label class="high"><label class="lableStyle">URL：</label>
			<form:input path="url" htmlEscape="false" maxlength="128"
						class="input-xlarge " /></label><span class="help-inline">上级接口rest地址，如：http://192.168.1.243:8080/arjccm</span><br>
			<label class="high"><label class="lableStyle">用户名：</label> <form:input
					path="username" htmlEscape="false" maxlength="128"
					class="input-xlarge " /></label><br> <label class="high"><label
				class="lableStyle">密码：</label> <form:input path="password"
														   htmlEscape="false" maxlength="128" class="input-xlarge " /></label> <span
				style="float: right; margin-right: 200px"> <shiro:hasPermission
				name="sys:sysConfig:edit">
						<a id="btnSubmit3" class="btn btn-primary" href="javascript:;"><i
								class="icon-ok"></i>保存</a>
		</shiro:hasPermission>
				</span>
		</div>
	</div>
</form:form>

<!-- 事件预处理系统 -->
<form:form id="inputFormPreviewSystemConfig"
		   modelAttribute="previewSystemConfig"
		   action="${ctx}/sys/sysConfig/save" method="post"
		   class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<label class="control-label">事件预处理系统：</label>
		<div class="controls">
			<form:radiobuttons path="paramInt"
							   items="${fns:getDictList('preview_system_status')}"
							   itemLabel="label" itemValue="value" htmlEscape="false" class="" />
			<span style="float: right; margin-right: 200px"> <shiro:hasPermission
					name="sys:sysConfig:edit">
						<a id="btnSubmit4" class="btn btn-primary" href="javascript:;"><i
								class="icon-ok"></i>保存</a>
			</shiro:hasPermission>
				</span>
		</div>
	</div>
</form:form>

<!-- 自定义地图层级 -->
<c:if test="${mapLevel != null}">
	<form:form id="inputFormMapLevel"
			   modelAttribute="mapLevel" action="${ctx}/sys/sysConfig/save"
			   method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="remarks"/>
		<div class="control-group">
			<br> <label class="control-label">${mapLevel.remarks}：</label>
			<div class="controls">
				<br> <label class="">街道层级范围：</label> <input type="number"
															name="" class="input-small required" disabled="disabled"
															value='9'/><span
					class="help-inline"><font color="red">*</font> </span> <span
					class="">-</span>
				<form:input path="quXian" htmlEscape="false"
							class="input-small required"/>
				<span class="help-inline"><font color="red">*</font> </span>
					<%-- <div class=help-inline>表示低概率</div>--%>
			</div>
			<div class="controls">
				<br> <label class="">社区层级范围：</label>
				<form:input path="jieDaoMin" htmlEscape="false"
							class="input-small required"/>
				<span class="help-inline"><font color="red">*</font> </span> <span
					class="">-</span>
				<form:input path="jieDaoMax" htmlEscape="false"
							class="input-small required"/>
				<span class="help-inline"><font color="red">*</font> </span>
					<%-- <div class=help-inline>表示较大概率</div>--%>
			</div>
			<div class="controls">
				<br> <label class="">网格层级范围：</label>
				<form:input path="sheQuMin" htmlEscape="false"
							class="input-small required"/>
				<span class="help-inline"><font color="red">*</font> </span> <span
					class="">-</span>
				<form:input path="sheQuMax" htmlEscape="false"
							class="input-small required"/>
				<span class="help-inline"><font color="red">*</font> </span>
					<%-- <div class=help-inline>表示较大概率</div>--%>
			</div>
			<div class="controls">
				<br> <label class="">楼栋层级范围：</label>
				<form:input path="wangGe" htmlEscape="false"
							class="input-small required"/>
				<span class="help-inline"><font color="red">*</font> </span> <span
					class="">-</span> <input type="text" name="" htmlEscape="false"
											 class="input-small required" disabled="disabled" value="20"/><span
					class="help-inline"><font color="red">*</font> </span>
					<%--<div class=help-inline>表示重大概率</div>--%>
			</div>
			<span style="float: right; margin-right: 200px"> <shiro:hasPermission
					name="sys:sysConfig:edit">
					<a id="btnSubmit10" class="btn btn-primary" href="javascript:;"><i
							class="icon-ok"></i>保存</a>
			</shiro:hasPermission>
			</span>
		</div>
	</form:form>
</c:if>

<!-- 四色预警设置（天） -->
<form:form id="inputFormAlarmColorLevel"
		   modelAttribute="alarmColorLevel" action="${ctx}/sys/sysConfig/save"
		   method="post" class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<br> <label class="control-label">${alarmColorLevel.remarks}：</label>
		<div class="controls">
			<br> <label class="">绿色等级范围：</label> <input type="number"
														name="" class="input-small required" disabled="disabled" value='0' /><span
				class="help-inline"><font color="red">*</font> </span> <span
				class="">-</span>
			<form:input path="green" htmlEscape="false"
						class="input-small required" />
			<span class="help-inline"><font color="red">*</font> </span>
			<div class=help-inline>表示低概率</div>
		</div>
		<div class="controls">
			<br> <label class="">黄色等级范围：</label>
			<form:input path="yellowMin" htmlEscape="false"
						class="input-small required" />
			<span class="help-inline"><font color="red">*</font> </span> <span
				class="">-</span>
			<form:input path="yellowMax" htmlEscape="false"
						class="input-small required" />
			<span class="help-inline"><font color="red">*</font> </span>
			<div class=help-inline>表示一般概率</div>
		</div>
		<div class="controls">
			<br> <label class="">橙色等级范围：</label>
			<form:input path="orangeMin" htmlEscape="false"
						class="input-small required" />
			<span class="help-inline"><font color="red">*</font> </span> <span
				class="">-</span>
			<form:input path="orangeMax" htmlEscape="false"
						class="input-small required" />
			<span class="help-inline"><font color="red">*</font> </span>
			<div class=help-inline>表示较大概率</div>
		</div>
		<div class="controls">
			<br> <label class="">红色等级范围：</label>
			<form:input path="red" htmlEscape="false"
						class="input-small required" />
			<span class="help-inline"><font color="red">*</font> </span> <span
				class="">-</span> <input type="text" name="" htmlEscape="false"
										 class="input-small required" disabled="disabled" value="+∞" /><span
				class="help-inline"><font color="red">*</font> </span>
			<div class=help-inline>表示重大概率</div>
		</div>
		<span style="float: right; margin-right: 200px"> <shiro:hasPermission
				name="sys:sysConfig:edit">
					<a id="btnSubmit5" class="btn btn-primary" href="javascript:;"><i
							class="icon-ok"></i>保存</a>
		</shiro:hasPermission>
			</span>
	</div>
</form:form>
<!-- 警情时间检测配置 -->
<form:form id="alarmCheckSystemConfig"
		   modelAttribute="alarmCheckConfig" action="${ctx}/sys/sysConfig/save"
		   method="post" class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<label class="control-label">${alarmCheckConfig.remarks}：</label>
		<div class="controls">
			<br> <label class="high"><label>最大派发时间：</label> <form:input
				path="maxDispatchTime" htmlEscape="false" maxlength="128"
				class="input-xlarge " /></label><br> <label class="high"><label>最大签收时间：</label>
			<form:input path="maxAcceptTime" htmlEscape="false" maxlength="128"
						class="input-xlarge " /></label><br> <label class="high"><label>最大到达时间：</label>
			<form:input path="maxArriveTime" htmlEscape="false" maxlength="128"
						class="input-xlarge " /></label> <span
				style="float: right; margin-right: 200px"> <shiro:hasPermission
				name="sys:sysConfig:edit">
						<a id="btnSubmit6" class="btn btn-primary" href="javascript:;"><i
								class="icon-ok"></i>保存</a>
		</shiro:hasPermission>
				</span>
		</div>
	</div>
</form:form>
<!-- 警情设置 -->
<form:form id="inputFormAlarmDataConfig"
		   modelAttribute="alarmDataConfig" action="${ctx}/sys/sysConfig/save"
		   method="post" class="form-horizontal">
	<form:hidden path="id" />
	<form:hidden path="remarks" />
	<div class="control-group">
		<label class="control-label">${alarmDataConfig.remarks}：</label>
		<div class="controls">
			<label class="high">警情分流设置是否自动:</label>
			<form:select path="alarmFlowFlag">
				<form:options items="${fns:getDictList('yes_no')}"
							  itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
			<br> <label class="high">处警单位设置是否自动:</label>
			<form:select path="alarmHandleFlag" onchange="alarmHandleModel()">
				<form:options items="${fns:getDictList('yes_no')}"
							  itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
			<div class="help-inline" id="handleModelSelect">
				<label class="high">警情处警模式:</label>
				<form:select path="handleModel">
					<form:options items="${fns:getDictList('alarmHandleModel')}"
								  itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
			<span style="float: right; margin-right: 200px"> <shiro:hasPermission
					name="sys:sysConfig:edit">
						<a id="btnSubmit7" class="btn btn-primary" href="javascript:;"><i
								class="icon-ok"></i>保存</a>
			</shiro:hasPermission>
				</span>
		</div>
	</div>
</form:form>
<!-- 海康视频ocx方式播放  -->
<c:if test="${hikvisonVideoConfig != null}">
	<form:form id="inputFormHikvisonVideoConfig" modelAttribute="hikvisonVideoConfig"
			   action="${ctx}/sys/sysConfig/save" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="remarks" />
		<div class="control-group">
			<label class="control-label">${hikvisonVideoConfig.remarks}：</label>
			<div class="controls">
				<br>
				<label class="high">
					<label class="lableStyle">apiUrl：</label>
					<form:input path="apiUrl" htmlEscape="false" maxlength="128"
								class="input-xlarge"/>
				</label><br>
				<label class="high">
					<label class="lableStyle">appKey：</label>
					<form:input path="appKey" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label><br>
				<label class="high">
					<label class="lableStyle">appSecet：</label>
					<form:input path="appSecet" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label><br>
				<label class="high">
					<label class="lableStyle">svrIp：</label>
					<form:input path="svrIp" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label><br>
				<label class="high">
					<label class="lableStyle">svrPort：</label>
					<form:input path="svrPort" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label>
				<span style="float: right; margin-right: 200px"> 
					<shiro:hasPermission name="sys:sysConfig:edit">
						<a id="btnSubmit9" class="btn btn-primary" href="javascript:;">
							<i class="icon-ok"></i>保存
						</a>
						<a id="btnGetCameras" class="btn btn-primary" href="javascript:;">
							<i class="icon-facetime-video"></i>获取监控设备
						</a>
					</shiro:hasPermission>
				</span>
			</div>
		</div>
	</form:form>
</c:if>
<!-- tiandy视频ocx方式播放  -->
<c:if test="${tiandyVideoConfig != null}">
	<form:form id="inputFormTiandyVideoConfig" modelAttribute="tiandyVideoConfig"
			   action="${ctx}/sys/sysConfig/save" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="remarks" />
		<div class="control-group">
			<label class="control-label">${tiandyVideoConfig.remarks}：</label>
			<div class="controls">
				<br>
				<label class="high">
					<label class="lableStyle">平台ip：</label>
					<form:input path="tiandyIp" htmlEscape="false" maxlength="128"
								class="input-xlarge"/>
				</label><br>
				<label class="high">
					<label class="lableStyle">平台端口：</label>
					<form:input path="tiandyPort" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label><br>
				<label class="high">
					<label class="lableStyle">用户名：</label>
					<form:input path="tiandyUserName" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label><br>
				<label class="high">
					<label class="lableStyle">密码：</label>
					<form:input path="tiandyPassWord" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
				</label>
				<span style="float: right; margin-right: 200px"> 
					<shiro:hasPermission name="sys:sysConfig:edit">
						<a id="btnSubmit11" class="btn btn-primary" href="javascript:;">
							<i class="icon-ok"></i>保存
						</a>
						<a id="btnGetTiandyCameras" class="btn btn-primary" href="javascript:;">
							<i class="icon-facetime-video"></i>获取监控设备
						</a>
					</shiro:hasPermission>
				</span>
			</div>
		</div>
	</form:form>
</c:if>
<%--	<!-- 重点人员emphasisPeople -->
	<form:form id="inputFormEmphasisPeopleConfig"
		modelAttribute="emphasisPeopleConfig"
		action="${ctx}/sys/sysConfig/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="remarks" />
		<div class="control-group">
			<label class="control-label">${emphasisPeopleConfig.remarks}：</label>
			<div class="controls">
				<form:checkboxes path="paramStrList"
					items="${fns:getDictList('emphasis_people_type')}"
					itemLabel="label" itemValue="value" htmlEscape="false" class="" />
				<span style="float: right; margin-right: 200px"> <shiro:hasPermission
						name="sys:sysConfig:edit">
						<a id="btnSubmit8" class="btn btn-primary" href="javascript:;"><i
							class="icon-ok"></i>保存</a>
					</shiro:hasPermission>
				</span>
			</div>
		</div>
	</form:form> --%>
</body>
</html>