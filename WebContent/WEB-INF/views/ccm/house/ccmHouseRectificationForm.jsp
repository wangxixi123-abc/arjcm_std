<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>社区矫正人员管理</title>
<meta name="decorator" content="default" />
<!-- 鱼骨图 -->
<link rel="stylesheet" href="${ctxStatic}/ccm/event/css/fishBonePop.css" />
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/fishBonePop.js"></script>
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
<style>
.hide1,.hide2{
display: none
}
</style>
<script type="text/javascript">
	$(document).ready(
			function() {
				//获取url中的参数
				function getUrlParam(name) {
				    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
				    var r = window.location.search.substr(1).match(reg);  //匹配目标参数
				    if (r != null) return unescape(r[2]); return null; //返回参数值
				}
				var hide1=getUrlParam('hide1');
				var hide2=getUrlParam('hide2');
				if(hide1!=null&&hide2!=null){
					if(hide1=="true"){
						$('.hide1').show();
						$('.form-actions').hide();
						$('.help-inline').hide();
						$('.input-xlarge').attr("readonly","readonly");
						$('.input-medium').attr("disabled","disabled");
						$('.displayedbuttons').attr("disabled","disabled");
					}
					if(hide2=="true"){
						$('.form-actions').hide();
						$('.hide2').show();
						
					}
				}else{
					$('.hide1').show();
					$('.hide2').show();
				}
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
				//跟踪信息
				var jsonString = '${documentList}';
                data = JSON.parse(jsonString);  
				$(".fishBone1").fishBone(data, '${ctx}','deal');
				$(".fishBone2").fishBone(data, '${ctx}','read');
			});
</script>
    <%--引入文本框外部样式--%>
    <link href="${ctxStatic}/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatRectification">社区矫正人口统计</a></li>
		<li><a href="javascript:;" data-href="${ctx}/house/ccmHouseRectification" onclick="HasSecret(this)">社区矫正人员列表</a></li>
		<li class="active">
			<a href="${ctx}/house/ccmHouseRectification/form?id=${ccmHouseRectification.id}">社区矫正人员
				<shiro:hasPermission name="house:ccmHouseRectification:edit">${not empty ccmHouseRectification.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="house:ccmHouseRectification:edit">查看</shiro:lacksPermission></a></li>
		<li><a
			href="${ctx}/log/ccmLogTail/formPro?relevance_id=${ccmHouseRectification.id}&relevance_table=ccm_house_rectification">跟踪信息<shiro:hasPermission
					name="log:ccmLogTail:edit">${not empty ccmLogTail.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="log:ccmLogTail:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%>
	<br />
	<form:form id="inputForm" modelAttribute="ccmHouseRectification" action="${ctx}/house/ccmHouseRectification/save" method="post" class="form-horizontal hide1">
		<h4 class="tableNamefirst color-bg6">人员基本信息</h4>
		<form:hidden path="id" />
		<form:hidden path="peopleId" value="${ccmPeople.id}" />
		<sys:message content="${message}" />
		<table class="first_table" border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label">人口类型：</label>
						<div class="controls">
							${fns:getDictLabel(ccmHouseRectification.type, 'sys_ccm_people', "")}
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">姓名：</label>
						<div class="controls">
							${ccmHouseRectification.name}
						</div>
					</div>
				</td>
				<td rowspan="4" width="30%" align="left" >
					<div>
						<label class="control-label">照片：</label>
						<div class="controls">
							<form:hidden id="images" path="images" htmlEscape="false" maxlength="255" class="input-xlarge" /> 
							<sys:ckfinder input="images" readonly="true" type="images" uploadPath="/photo/ShiYouRenKou" selectMultiple="false" maxWidth="120" maxHeight="180" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">公民身份号码：</label>
						<div class="controls">
							${ccmHouseRectification.ident}
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">籍贯：</label>
						<div class="controls">
							${ccmHouseRectification.censu}
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">性别：</label>
						<div class="controls">
							${fns:getDictLabel(ccmHouseRectification.sex, 'sex', '')}
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">联系方式：</label>
						<div class="controls">
							${ccmHouseRectification.telephone}
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">户籍详细地址：</label>
						<div class="controls">
							${ccmHouseRectification.domiciledetail}
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">现住详细地址：</label>
						<div class="controls">
							${ccmHouseRectification.residencedetail}
						</div>
					</div>
				</td>
			</tr>
		</table>

		<h4 class="tableName color-bg6">社区矫正人员信息</h4>
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td style="width: 43%">
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>社区矫正人员编号：</label>
						<div class="controls">
							<form:input path="rectNum" htmlEscape="false" maxlength="16" class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">原羁押场所：</label>
						<div class="controls">
							<form:input path="rectPlace" htmlEscape="false" maxlength="100" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>矫正类別：</label>
						<div class="controls">
							<form:select path="rectType" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_core_sort')}" itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>案件类別：</label>
						<div class="controls">
							<form:select path="caseType" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_house_aids_cate')}" itemtd="td" itemValue="value" htmlEscape="false" />
							</form:select>

						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>具体罪名：</label>
						<div class="controls">
							<form:input path="charge" htmlEscape="false" maxlength="100" class="input-xlarge required" />

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">原判刑期：</label>
						<div class="controls">
							<form:input path="origCharge" htmlEscape="false" maxlength="50" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">原判刑开始曰期：</label>
						<div class="controls">
							<input name="origBegin" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate " value="<fmt:formatDate value="${ccmHouseRectification.origBegin}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">原判刑结束日期：</label>
						<div class="controls">
							<input name="origEnd" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate " value="<fmt:formatDate value="${ccmHouseRectification.origEnd}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>矫正开始日期：</label>
						<div class="controls">
							<input name="rectBegin" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required" value="<fmt:formatDate value="${ccmHouseRectification.rectBegin}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>矫正结束日期：</label>
						<div class="controls">
							<input name="rectEnd" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required" value="<fmt:formatDate value="${ccmHouseRectification.rectEnd}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>接收方式：</label>
						<div class="controls">
							<form:select path="receiveMode" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_recv_way')}" itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">&ldquo;四史&rdquo;情况：</label>
						<div class="controls">
							<form:checkboxes path="fourHisList" items="${fns:getDictList('ccm_four_case')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">是否累惯犯：</label>
						<div class="controls">
							<form:radiobuttons path="recidivist" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">&ldquo;三涉&rdquo;情况：</label>
						<div class="controls">
							<form:checkboxes path="thrHoldList" items="${fns:getDictList('ccm_three_case')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>是否建立矫正小组：</label>
						<div class="controls">
							<form:radiobuttons path="correcthas" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons required" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>是否有脱管：</label>
						<div class="controls">
							<form:radiobuttons path="detached" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons required" />
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td colspan="2">
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>矫正小组人员组成情况：</label>
						<div class="controls">
							<form:checkboxes path="correctedList" items="${fns:getDictList('ccm_jzxz_ryzc')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons required"/>

						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">矫正解除（终止）类型：</label>
						<div class="controls">
							<form:select path="correctlift" class="input-xlarge ">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_core_rele')}" itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">脱管原因：</label>
						<div class="controls">
							<form:input path="detaReason" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">检察监督脱管情况：</label>
						<div class="controls">
							<form:input path="detaSupe" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">脱管纠正情况：</label>
						<div class="controls">
							<form:input path="detaCorr" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>是否有漏管：</label>
						<div class="controls">
							<form:radiobuttons path="lackContr" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">漏管原因：</label>
						<div class="controls">
							<form:input path="lackContrRe" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">检察监督漏管情况：</label>
						<div class="controls">
							<form:input path="lackContrCase" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">漏管纠正情况：</label>
						<div class="controls">
							<form:input path="lackContrCaseCorr" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">奖惩情况：</label>
						<div class="controls">
							<form:input path="rewandpun" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">刑罚变更执行情况：</label>
						<div class="controls">
							<form:input path="penaChan" htmlEscape="false" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>是否重新犯罪：</label>
						<div class="controls">
							<form:radiobuttons path="reoffend" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="displayedbuttons required" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>关注程度：</label>
						<div class="controls">
							<form:select path="atteType" class="input-xlarge required">
								<form:option value="" label="" />
								<form:options items="${fns:getDictList('ccm_conc_exte')}" itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>

						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">重新犯罪名称：</label>
						<div class="controls">
							<form:input path="reofCharge" htmlEscape="false" maxlength="100" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xlarge " />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"></label>
						<div class="controls">
						</div>
					</div>
				</td>
			</tr>
		</table>
		
<%-- 		<table border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<%@include file="/WEB-INF/views/include/ccmlog.jsp" %>

		</table> --%>
		<div class="form-actions">
			<shiro:hasPermission name="house:ccmHouseRectification:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp;
			</shiro:hasPermission>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" /> -->
		</div>
	</form:form><br>
	<c:if test="${documentNumber > 0}">
		<shiro:hasPermission name="log:ccmLogTail:edit">
			<h4 class="hide2">&nbsp;跟踪信息：</h4>
			<br>
			<div class="fishBone1 hide2" ></div>
		</shiro:hasPermission>
		<shiro:lacksPermission name="log:ccmLogTail:edit">
			<h4 class="hide2">&nbsp;查看跟踪信息：</h4>
			<br>
			<div class="fishBone2 hide2" ></div>
		</shiro:lacksPermission> 
	</c:if>
	<c:if test="${documentNumber <= 0}">
		<shiro:hasPermission name="log:ccmLogTail:edit">
			<h2 class="hide2">&nbsp;&nbsp;暂无跟踪信息</h2>
			<br>
		</shiro:hasPermission>
	</c:if>
</body>
</html>