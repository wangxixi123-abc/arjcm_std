<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>实时警情管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
	<script src="${ctxStatic}/common/alarm.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#btnSubmit').click(function(){
				var area = $("#areaId").val();
				var html1 = '<label for="" class="error">必选字段 *<label>';
				if (area.length != 0) {
					$("#show1").html("*");
				} else {
					$("#show1").html(html1);
				}
				if (area.length != 0) {
					$("#inputForm").submit();
				}
			});
			$("#inputForm").validate({
				submitHandler: function(form){
			/*		var arr = ["OGG","MP3","WAV","ogg","mp3","wav"];
					var record = $('#alarmRecord').val();
					var recordIndex = record.lastIndexOf(".");
				 	var recordExt = record.substr(recordIndex+1);
				 	if(typeof (record)!="undefined" && record!=""){
						if($.inArray(recordExt, arr)!=-1){
							$("#btnSubmit").attr("disabled", true);
							loading('正在提交，请稍等...');
							form.submit();
						}else{
							$.jBox.tip('您的音频不符合OGG、MP3、WAV格式');
							return false;
						}
					} else {*/
						$("#btnSubmit").attr("disabled", true);
						loading('正在提交，请稍等...');
						form.submit();
				/*	}*/
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
			initAlarmType();//初始化警情类型和警情类别
			//给警情类型绑定事件
			$("#alarmType").change(function(){
				var alarmClassSelectOptions = $("#alarmClass")[0].options;
				for(var i in alarmClassSelectOptions){
					alarmClassSelectOptions.remove(0);
				}
				var alarmTypeId = $(this).children('option:selected').attr("data-id");
				var alarmClassUrl = '/sys/sysDict/getDictListByParentId?type=bph_alarm_info_class&parentId=' + alarmTypeId;
				alarmClassUrl = '/sys/dict/listData?type=bph_alarm_info_class';
				$.getJSON(ctx + alarmClassUrl,function(datas){
					for(var i=0;i<datas.length;i++){
						$("#alarmClass").append("<option value='"+datas[i].value+"'>"+datas[i].label+"</option>");
					}
				});
			});
			$("#AlarmDetailBtn").click(function () {
				$("#AlarmDetailTable").toggle();
			});
		});
		
		function initAlarmType(){
			var alarmTypeSelectNode = $("<select id='alarmType' name='typeCode' class='input-xlarge'></select>");
			$("#alarmTypeDiv").append(alarmTypeSelectNode);
			var alarmClassSelectNode = $("<select id='alarmClass' name='genreCode' class='input-xlarge'></select>");
			$("#alarmClassDiv").append(alarmClassSelectNode);
			$.getJSON(ctx+'/sys/dict/listData?type=bph_alarm_info_typecode',function(datas){
				for(var i=0;i<datas.length;i++){
					if(datas[i].value == "${bphAlarmInfo.typeCode}"){
						alarmTypeSelectNode.append("<option data-id='"+datas[i].id+"' value='"+datas[i].value+"' selected='selected'>"+datas[i].label+"</option>");
					}else{
						alarmTypeSelectNode.append("<option data-id='"+datas[i].id+"' value='"+datas[i].value+"'>"+datas[i].label+"</option>");
					}
				}
				var parentId = $("#alarmType").children('option:selected').attr("data-id");
				var alarmClassUrl = '/sys/sysDict/getDictListByParentId?type=bph_alarm_info_class&parentId=' + parentId;
				alarmClassUrl = '/sys/dict/listData?type=bph_alarm_info_class';
				$.getJSON(ctx + alarmClassUrl,function(datas){
					for(var i=0;i<datas.length;i++){
						if(datas[i].value == "${bphAlarmInfo.genreCode}"){
							alarmClassSelectNode.append("<option value='"+datas[i].value+"' selected='selected'>"+datas[i].label+"</option>");
						}else{
							alarmClassSelectNode.append("<option value='"+datas[i].value+"'>"+datas[i].label+"</option>");
						}
					}
				});
			})
		}
		
		
	</script>
	<style type="text/css">
		.control-group {
			border-bottom: 0px dotted #dddddd;
		}
		.input-xxlarge{
			width: 282px;
		}
		.select2-container .select2-choice{
			width: 274px;
		}
		input, textarea, .uneditable-input{
			width: 270px;
		}
		#alarmClass ,#alarmType{
			width: 284px;
		}
	</style>
</head>
<body>
	<form:form id="inputForm" cssStyle="padding-top: 20px" modelAttribute="bphAlarmInfo" action="${ctx}/alarm/bphAlarmInfo/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<table style=" padding: 10px; width: 100%" >
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">接警单编号：</label>
						<div class="controls">
							<form:input path="orderNum" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">接警员工号：</label>
						<div class="controls">
								<form:input path="policeNum" htmlEscape="false" maxlength="64" class="input-xlarge "/>
						</div>
					</div>
			</td>
			</tr>
			<tr>
				<td style="width: 50%" colspan="2">
					<div class="control-group">
						<label class="control-label">接警员姓名：</label>
						<div class="controls">
							<form:input path="policeName" htmlEscape="false" maxlength="12" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<%--
				 <td style="width: 50%">
					<div class="control-group">
						<label class="control-label">接警录音：</label>
					<div class="controls">
						<form:hidden id="alarmRecord" path="alarmRecord" htmlEscape="false" maxlength="64" class="input-xlarge record"/>
						<sys:ckfinder input="alarmRecord" type="files" uploadPath="/alarm/bphAlarmInfo" selectMultiple="false" maxWidth="100" maxHeight="100"/>
					</div>
					</div>
				</td>
				--%>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">报警人姓名：</label>
						<div class="controls">
							<form:input path="manName" htmlEscape="false" maxlength="12" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">报警人性别：</label>
						<div class="controls">
							<form:select path="manSex" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">报警人联系电话：</label>
						<div class="controls">
							<form:input path="manTel" htmlEscape="false" maxlength="15" class="input-xlarge"/>
						</div>
					</div>
				</td>
				<td style="width: 50%">
				<div class="control-group">
					<label class="control-label">报警方式：</label>
					<div class="controls">
						<form:select path="alarmFrom" class="input-xlarge ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('bph_alarm_from')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">报警时间：</label>
						<div class="controls">
							<input name="alarmTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
								value="<fmt:formatDate value="${bphAlarmInfo.alarmTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">是否重大警情：</label>
						<div class="controls">
							<form:select path="isImportant" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">警情状态：</label>
						<div class="controls">
							<form:select path="state" class="input-xlarge " disabled="true">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('bph_alarm_info_state')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">案发地点：</label>
						<div class="controls">
							<form:input path="place" htmlEscape="false" maxlength="200" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">警情类型：</label>
						<div class="controls" id="alarmTypeDiv">
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">警情类别：</label>
						<div class="controls" id="alarmClassDiv">
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">经度：</label>
						<div class="controls">
							<form:input path="x" htmlEscape="false" class="input-xlarge  number"/>
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">纬度：</label>
						<div class="controls">
							<form:input path="y" htmlEscape="false" class="input-xlarge  number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">高度：</label>
						<div class="controls">
							<form:input path="z" htmlEscape="false" class="input-xlarge  number"/>
						</div>
					</div>
				</td>
				<td style="width: 50%">
					<div class="control-group">
						<label class="control-label">区域：</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id" value="${bphAlarmInfo.area.id}" labelName="area.name" labelValue="${bphAlarmInfo.area.name}"
								title="区域" url="/sys/area/treeData" allowClear="true" notAllowSelectParent="false" cssClass=""/>
								<span class="help-inline"><font color="red" id="show1"></font></span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 50%" colspan="2">
					<div class="control-group">
						<label class="control-label">警情内容：</label>
						<div class="controls">
							<form:textarea path="content" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>
						</div>
					</div>
				</td>
			</tr>
			</tr>
		</table>
		<div>
			<h4 class="tableNamefirst" id="AlarmDetailBtn"
				style="cursor: pointer;">
				警情处警详情 <i class=" icon-share-alt"></i>
			</h4>
			<table id="AlarmDetailTable"  class="table table-striped table-bordered table-condensed" style="margin-top: 10px;display: none;">
				<thead>
				<th>处警人姓名</th>
				<th>任务描述</th>
				<th>反馈信息</th>
				<th>处置状态</th>
				<th>执行预案</th>
				<th>执行过程</th>
				<th>执行动作</th>
				</thead>
				<tbody>
				<c:forEach items="${bphAlarmHandle}" var="bphAlarmHandle">
					<tr>
						<td>${bphAlarmHandle.user.name}</td>
						<td>${bphAlarmHandle.task}</td>
						<td>${bphAlarmHandle.handleResult}</td>
						<c:if test="${bphAlarmHandle.status == 0}">
							<td><span class="major" style="background: #ec4c6c; padding:1px 3px; border-radius: 4px;margin-left:5px; color: #fff;display:inline">未处理</span></td>
						</c:if>
						<c:if test="${bphAlarmHandle.status == 1}">
							<td><span class="major" style="background: #f9d04b; padding:1px 3px; border-radius: 4px;margin-left:5px; color: #fff;display:inline">已签收</span></td>
						</c:if>
						<c:if test="${bphAlarmHandle.status == 2}">
							<td><span class="major" style="background: #5cb1ea; padding:1px 3px; border-radius: 4px;margin-left:5px; color: #fff;display:inline">已到达</span></td>
						</c:if>
						<c:if test="${bphAlarmHandle.status == 3}">
							<td><span class="major" style="background: #258233; padding:1px 3px; border-radius: 4px;margin-left:5px; color: #fff;display:inline">已反馈</span></td>
						</c:if>
						<td>${bphAlarmHandle.plan.name}</td>
						<td>${bphAlarmHandle.plan.name}</td>
						<td>${bphAlarmHandle.action.name}</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
		<div class="form-actions">
			<!-- <input id="btnSubmit" class="btn btn-primary" type="submit" value="保存"/> -->
			<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>
			&nbsp;
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/> -->
			<a id="btnCancel" class="btn btn-back" href="javascript:;"  onclick="history.go(-1)"><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
</body>
</html>