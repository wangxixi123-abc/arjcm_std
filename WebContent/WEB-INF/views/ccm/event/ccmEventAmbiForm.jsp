<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>矛盾纠纷登记</title>
<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
<!-- 鱼骨图 -->
<link rel="stylesheet"
	href="${ctxStatic}/ccm/event/css/fishBoneCase.css" />
<script type="text/javascript"
	src="${ctxStatic}/ccm/event/js/fishBoneCase.js"></script>
<script type="text/javascript"
	src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				//$("#name").focus();
				function getUrlParam(name) {
					var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
					var r = window.location.search.substr(1).match(reg); //匹配目标参数
					if (r != null)
						return unescape(r[2]);
					return null; //返回参数值
				}
				var hide1 = getUrlParam('hide1');
				var hide2 = getUrlParam('hide2');
				if (hide1 != null && hide2 != null) {
					if (hide1 == "true") {
						$('.hide1').show();
						$('.form-actions').hide();
					}
					if (hide2 == "true") {
						$('.form-actions').hide();
						$('.hide2').show();

					}
				} else {
					$('.hide1').show();
					$('.hide2').show();
				}
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
				$("td").css({
					"padding" : "8px"
				});
				$("td").css({
					"border" : "0px dashed #CCCCCC"
				});
				//创建案事件历史
				var jsonString = '${documentList}';
				data = JSON.parse(jsonString);
				$(".fishBone1").fishBone(data, '${ctx}', 'deal');
				$(".fishBone2").fishBone(data, '${ctx}', 'read');
			});
	
	function saveForm() {
		var area = $("#areaId").val();
		var html1 = '<label for="" class="error">必选字段 <label>';
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
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/event/ccmEventAmbi/map">矛盾纠纷统计</a></li>
		<li><a style="width: 140px;text-align:center" href="${ctx}/event/ccmEventAmbi/">矛盾纠纷列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head"
			href="${ctx}/event/ccmEventAmbi/form?id=${ccmEventAmbi.id}">矛盾纠纷<shiro:hasPermission
					name="event:ccmEventAmbi:edit">${not empty ccmEventAmbi.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="event:ccmEventAmbi:edit">查看</shiro:lacksPermission></a></li>
		<!--  
	    <c:if test="${not empty ccmEventAmbi.id}">
	    	<li><a href="${ctx}/log/ccmLogTail/formPro?relevance_id=${ccmEventAmbi.id}&relevance_table=ccm_event_ambi">跟踪信息<shiro:hasPermission name="log:ccmLogTail:edit">${not empty ccmLogTail.id?'修改':'添加'}</shiro:hasPermission>	<shiro:lacksPermission name="log:ccmLogTail:edit">查看</shiro:lacksPermission></a></li>
		</c:if>-->
	</ul>
	<form:form id="inputForm" modelAttribute="ccmEventAmbi"
		action="${ctx}/event/ccmEventAmbi/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />


		<table border="0px"
			style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;border-top-color: white">

			<tr>
				<td >
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>事件名称：</label>
						<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="100"
								class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span
								class="help-inline"><font color="red">*</font> </span>发生时间：</label>
						<div class="controls">
							<input name="sendDate" type="text" readonly="readonly"
								   maxlength="20" class="input-medium Wdate required"
								   value="<fmt:formatDate value="${ccmEventAmbi.sendDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
								   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red" id="show1">*</font> </span> 所属网格：</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id"
								value="${ccmEventAmbi.area.id}" labelName="area.name"
								labelValue="${ccmEventAmbi.area.name}" title="区域"
								url="/tree/ccmTree/treeDataArea?type=7&areaid="
								allowClear="true" notAllowSelectParent="true" cssClass=""/>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>发生地点详址：</label>
						<div class="controls">
							<form:input path="sendAdd" htmlEscape="false" maxlength="100"
										class="input-xlarge required" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>事件规模：</label>
						<div class="controls">
							<form:select path="eventScale" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_event_scale')}"
											  itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">图片：</label>
						<div class="controls">
							<form:hidden id="icon" path="icon" htmlEscape="false"
										 maxlength="255" class="input-xlarge" />
							<sys:ckfinder input="icon" type="images" uploadPath="/photo"
										  selectMultiple="false" maxWidth="120" maxHeight="180" />
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>事件类别：</label>
						<div class="controls">
							<form:select path="eventType" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_event_sort')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>涉及人数：</label>
						<div class="controls">
							<form:input path="invoNum" htmlEscape="false" maxlength="6"
								class="input-xlarge required digits" type="number" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">事件简述：</label>
						<div class="controls">
							<form:input path="eventSket" htmlEscape="false" maxlength="100"
										class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>


			<tr>
				<td>
					<div>
						<label class="control-label">涉及单位：</label>
						<div class="controls">
							<form:input path="involveCom" htmlEscape="false" maxlength="100"
										class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人证件类型：</label>
						<div class="controls">
							<form:select path="partCode" class="input-xlarge required"
								items="${fns:getDictList('legal_person_certificate_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false">
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人证件号码：</label>
						<div class="controls">
							<form:input path="partNum" htmlEscape="false" maxlength="18"
								class="input-xlarge required card" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人姓名：</label>
						<div class="controls">
							<form:input path="partName" htmlEscape="false" maxlength="80"
								class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人性别：</label>
						<div class="controls">
							<form:radiobuttons path="partSex"
								items="${fns:getDictList('sex')}" itemLabel="label"
								itemValue="value" htmlEscape="false" class="required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人民族：</label>
						<div class="controls">
							<form:select path="partNat" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('sys_volk')}"
											  itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
			</tr>
			<tr>

				<td>
					<div>
						<label class="control-label">主要当事人学历：</label>
						<div class="controls">
							<form:select path="partEduBg" class="input-xlarge ">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('sys_ccm_degree')}"
									itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人人员类别：</label>
						<div class="controls">
							<form:select path="partType" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_zydsr_type')}"
											  itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>主要当事人居住详址：</label>
						<div class="controls">
							<form:input path="partAdd" htmlEscape="false" maxlength="200"
										class="input-xlarge required" />
						</div>
					</div>
				</td>
			</tr>


			<c:if test="${not empty ccmEventAmbi.id}">
				<tr>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解时限：</label>
							<div class="controls">
								<input name="solve" type="text" readonly="readonly"
									maxlength="20" class="input-medium Wdate required"
									value="<fmt:formatDate value="${ccmEventAmbi.solve}" pattern="yyyy-MM-dd"/>"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
							</div>
						</div>
					</td>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解方式：</label>
							<div class="controls">
								<form:select path="solveType" class="input-xlarge required">
									<form:option value="" label="" />
									<form:options items="${fns:getDictList('ccm_disl_way')}"
										itemLabel="label" itemValue="value" htmlEscape="false" />
								</form:select>

							</div>
						</div>
					</td>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解组织：</label>
							<div class="controls">
								<form:input path="solveComp" htmlEscape="false" maxlength="100"
											class="input-xlarge required" />
							</div>
						</div>
					</td>
				</tr>
				<tr>


				</tr>
				<tr>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解负责人姓名：</label>
							<div class="controls">
								<form:input path="solveName" htmlEscape="false" maxlength="50"
											class="input-xlarge required" />

							</div>
						</div>
					</td>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解负责人联系方式：</label>
							<div class="controls">
								<form:input path="solveTl" htmlEscape="false" maxlength="11"
									class="input-xlarge required phone" />

							</div>
						</div>
					</td>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解是否成功：</label>
							<div class="controls">
								<form:radiobuttons path="solveSucc"
									items="${fns:getDictList('yes_no')}" itemLabel="label"
									itemValue="value" htmlEscape="false" class="required" />

							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div>
							<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>化解情况：</label>
							<div class="controls">
								<form:input path="solveCase" htmlEscape="false" maxlength="100"
									class="input-xlarge required" />

							</div>
						</div>
					</td>
					<td>
						<div>
							<label class="control-label">处理状态：</label>
							<div class="controls">
								<form:select path="status" class="input-xlarge ">
									<form:option value="" label="" />
									<form:options items="${fns:getDictList('ccm_event_status')}"
										itemLabel="label" itemValue="value" htmlEscape="false" />
								</form:select>
							</div>
						</div>
					</td>
					<td>
						<div>
							<label class="control-label">考评意见：</label>
							<div class="controls">
								<form:input path="evaluateAdv" htmlEscape="false"
											maxlength="100" class="input-xlarge " />
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div>
							<label class="control-label">附件：</label>
							<div class="controls">
								<form:hidden id="file" path="file" htmlEscape="false"
											 maxlength="255" class="input-xxlarge" />
								<sys:ckfinder input="file" type="files"
											  uploadPath="/event/ccmEventAmbi" selectMultiple="false" />
							</div>
						</div>
					</td>
				</tr>
			</c:if>
			<tr>
			<%--	<td>
					<div>
						<label class="control-label">中心点：</label>
						<div class="controls">
							<form:input path="areaPoint" readonly="true" htmlEscape="false" maxlength="40"
								class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">区域图：</label>
						<div class="controls">
							<form:input path="areaMap" readonly="true" htmlEscape="false" maxlength="2000"
								class="input-xlarge " />
						</div>
					</div>
				</td>--%>
				<td>
					<div>
						<label class="control-label">考评日期：</label>
						<div class="controls">
							<input name="evaluateDate" type="text" readonly="readonly"
								   maxlength="20" class="input-medium Wdate "
								   value="<fmt:formatDate value="${ccmEventAmbi.evaluateDate}" pattern="yyyy-MM-dd"/>"
								   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						</div>
					</div>
				</td>

			</tr>

			<tr>
				<td colspan="3">
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4"
								maxlength="255" class="input-xlarge " />
						</div>
					</div>
				</td>

			</tr>


		</table>
		<div class="form-actions">
			<shiro:hasPermission name="event:ccmEventAmbi:edit">
				<input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
	<br>
	<c:if test="${documentNumber > 0}">
		<shiro:hasPermission name="log:ccmLogTail:edit">
			<h4 class="hide2">&nbsp;跟踪信息：</h4>
			<br>
			<div class="fishBone1 hide2"></div>
		</shiro:hasPermission>
		<shiro:lacksPermission name="log:ccmLogTail:edit">
			<h4 class="hide2">&nbsp;查看跟踪信息：</h4>
			<br>
			<div class="fishBone2 hide2"></div>
		</shiro:lacksPermission>
	</c:if>
</body>
</html>