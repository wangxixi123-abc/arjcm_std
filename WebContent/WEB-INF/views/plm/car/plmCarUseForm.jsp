<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>领用记录管理</title>
	<meta name="decorator" content="default"/>
	<link type="text/css" href="${ctxStatic}/common/zztable.css" rel="stylesheet">
	<link type="text/css" href="${ctxStatic}/common/zzformtable.css" rel="stylesheet">
	<script type="text/javascript" src="${ctxStatic}/plm/car/plmCarUseForm.js"></script> 
 	<script type="text/javascript">
		$(document).ready(function() {
			$('#btnSubmit').click(function(){
				$('#inputForm').submit();
			});
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
		});
		
	</script>	
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/car/plmCarUse/">领用记录列表</a></li>
		<li class="active"><a href="${ctx}/car/plmCarUse/form?id=${plmCarUse.id}">领用记录<shiro:hasPermission name="car:plmCarUse:edit">${not empty plmCarUse.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="car:plmCarUse:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" style="margin: 30px 200px;" modelAttribute="plmCarUse" action="${ctx}/car/plmCarUse/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<h2 style="margin-bottom: 20px">领用记录单</h2>	
		<table id="table" class="table table-condensed">
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">车辆<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
						${plmCarUse.car.vehicle}
				</td>
				<td class="trtop" colspan="2" style="width: 20%">司机</td>
				<td colspan="2" style="width: 30%">
					<c:if test="${not empty plmCarUse.driver.name}" var="condition">
						<form:input type="hidden" id="driverIds" path="driver.id" class="input-xlarge " />
					</c:if>
					<c:if test="${!condition}">
					 自驾
					</c:if>
				</td>
			</tr>		
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">领出人<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
					<shiro:lacksPermission name="car:plmCarUse:edit">
						${plmCarUse.use.name}
					</shiro:lacksPermission>
					<shiro:hasPermission name="car:plmCarUse:edit">
						<sys:treeselect id="use" name="use.id" value="${plmCarUse.use.id}" labelName="use.name" labelValue="${plmCarUse.use.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="required" allowClear="true" notAllowSelectParent="true" isAll="true"/>
					</shiro:hasPermission>		
				</td>
				<td class="trtop" colspan="2" style="width: 20%">领出日期<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
					<shiro:lacksPermission name="car:plmCarUse:edit">
						<fmt:formatDate value="${plmCarUse.outDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</shiro:lacksPermission>
					<shiro:hasPermission name="car:plmCarUse:edit">
						<input name="outDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
						value="<fmt:formatDate value="${plmCarUse.outDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});"/>
					</shiro:hasPermission>				
				</td>
			</tr>		
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">领出时车辆总里程(km)<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
					<c:if test="${not empty plmCarUse.outMileage}" var="condition">
						${plmCarUse.outMileage}
					</c:if>
					<c:if test="${!condition}">
						<form:input path="outMileage" htmlEscape="false"  class="input-xlarge lrunlv62 required"/>
					</c:if>					
				</td>
				<td class="trtop" colspan="2" style="width: 20%">领用事由</td>
				<td colspan="2" style="width: 30%">
					<c:if test="${not empty plmCarUse.cause}" var="condition">
						${plmCarUse.cause}
					</c:if>
					<c:if test="${!condition}">
						<form:input path="cause" htmlEscape="false"  class="input-xlarge "/>
					</c:if>		 					
				</td>				
			</tr>
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">流程类型<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
				<c:if test="${not empty plmCarUse.type}" var="condition">
						${fns:getDictLabel(plmCarUse.type, 'plm_car_use_type', '')}
						<input type="hidden" id="type" value="${plmCarUse.type}">
					</c:if>
					<c:if test="${!condition}">
						<form:select path="type" class="input-xlarge required">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('plm_car_use_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</c:if>		
					
				</td>
				<td class="trtop" colspan="2" style="width: 20%">关联流程</td>
				<td colspan="2" style="width: 40%">
				
					<input id="proBfore" type="text" class="input-xlarge number" placeholder="请先选择流程类型" disabled="disabled"/>
					<form:input type="hidden" path="process" htmlEscape="false" maxlength="64" class="input-xlarge number" />
				</td>
			</tr>	
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">备注信息</td>
				<td colspan="6" style="width: 30%">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
				</td>
			</tr>
			<c:if test="${not empty plmCarUse.id}">
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">归还人<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
					<shiro:lacksPermission name="car:plmCarUse:edit">
						${plmCarUse.gbuse.name}
					</shiro:lacksPermission>
					<shiro:hasPermission name="car:plmCarUse:edit">
						<sys:treeselect id="gbuse" name="gbuse.id" value="${plmCarUse.gbuse.id}" labelName="gbuse.name" labelValue="${plmCarUse.gbuse.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="required" allowClear="true" notAllowSelectParent="true"/>
					</shiro:hasPermission>								
				</td>
				<td class="trtop" colspan="2" style="width: 20%">归还日期<font color="red">*</font></td>
				<td colspan="2" style="width: 30%">
					<shiro:lacksPermission name="car:plmCarUse:edit">
						<fmt:formatDate value="${plmCarUse.inDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</shiro:lacksPermission>
					<shiro:hasPermission name="car:plmCarUse:edit">
						<input name="inDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
						value="<fmt:formatDate value="${plmCarUse.inDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});"/>
					</shiro:hasPermission>			
				</td>				
			</tr>	
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">归还时车辆总里程(km)<font color="red">*</font></td>
				<td colspan="6" style="width: 30%">
					<shiro:lacksPermission name="car:plmCarUse:edit">
						${plmCarUse.inMileage}
					</shiro:lacksPermission>
					<shiro:hasPermission name="car:plmCarUse:edit">
						<form:input path="inMileage" htmlEscape="false"  class="input-xlarge  znumber lrunlv decimal  required"/>
					</shiro:hasPermission>			
				</td>
			</tr>					
			</c:if>
		</table>
		<c:if test="${not empty plmCarUse.id}">
			<h4 style="padding:8px">费用信息：</h4>
			<c:if test="${plmCarUse.type eq '01'}">
			<table id="table" class="table table-condensed">
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">是否损坏<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:radiobuttons path="spend.isDamaged" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					</td>
					<td class="trtop" colspan="2" style="width: 20%">行驶里程(km)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input path="spend.mildage" htmlEscape="false" class="input-xlarge  znumber lrunlv decimal required"/>
					</td>
				</tr>
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">加油费(元)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input id="oilFee" path="spend.oilFee" htmlEscape="false" class="input-xlarge amount  number required"/>
					</td>
					<td class="trtop" colspan="2" style="width: 20%">过路费(元)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input id="tollFee" path="spend.tollFee" htmlEscape="false" class="input-xlarge amount  number required"/>
					</td>
				</tr>
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">停车费(元)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input id="parkingFee" path="spend.parkingFee" htmlEscape="false" class="input-xlarge  amount  number required"/>
					</td>
					<td class="trtop" colspan="2" style="width: 20%">其他费用(元)</td>
					<td colspan="2" style="width: 30%">
						<form:input id="otherFee" path="spend.otherFee" htmlEscape="false" class="input-xlarge  amount  number"/>
					</td>
				</tr>	
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">总费用(元)<font color="red">*</font></td>
					<td colspan="6" style="width: 30%">
						<form:input id="totaFee" path="spend.totaFee" htmlEscape="false" class="input-xlarge   amount number required" placeholder="点击自动求和"/>
					</td>
				</tr>																		
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">用车详情</td>
					<td colspan="6" style="width: 30%">
						<form:textarea path="spend.remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
					</td>
				</tr>
			</table>
			</c:if>
			<c:if test="${plmCarUse.type eq '02'}">
			<table id="table" class="table table-condensed">
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">维保单位<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input type="hidden" id="repairComIds" path="spend.repairCom.id" class="input-xlarge required" />
					</td>
					<td class="trtop" colspan="2" style="width: 20%">行驶里程(km)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input path="spend.mildage" htmlEscape="false" class="input-xlarge  lrunlv  znumber decimal"/>
					</td>
				</tr>			
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">维保费用(元)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input id="repairFee" path="spend.repairFee" htmlEscape="false" class="input-xlarge amount number required"/>
					</td>
					<td class="trtop" colspan="2" style="width: 20%">其他费用(元)</td>
					<td colspan="2" style="width: 30%">
						<form:input id="otherFee" path="spend.otherFee" htmlEscape="false" class="input-xlarge amount number"/>
					</td>
				</tr>			
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">总费用(元)<font color="red">*</font></td>
					<td colspan="6" style="width: 30%">
						<form:input id="totaFee" path="spend.totaFee" htmlEscape="false" class="input-xlarge amount number required" placeholder="点击自动求和"/>
					</td>
				</tr>																		
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">维保详情</td>
					<td colspan="6" style="width: 30%">
						<form:textarea path="spend.remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
					</td>
				</tr>			
			</table>
			</c:if>
			<%-- <c:if test="${plmCarUse.type eq '03'}">	
			<table id="table" class="table table-condensed">
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">维保单位<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input type="hidden" id="repairComIds" path="spend.repairCom.id" class="input-xlarge required" />
					</td>
					<td class="trtop" colspan="2" style="width: 20%">行驶里程(km)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input path="spend.mildage" htmlEscape="false" class="input-xlarge  number required"/>
					</td>
				</tr>			
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">保养费用(元)<font color="red">*</font></td>
					<td colspan="2" style="width: 30%">
						<form:input id="repairFee" path="spend.repairFee" htmlEscape="false" class="input-xlarge  number required"/>
					</td>
					<td class="trtop" colspan="2" style="width: 20%">其他费用(元)</td>
					<td colspan="2" style="width: 30%">
						<form:input id="otherFee" path="spend.otherFee" htmlEscape="false" class="input-xlarge  number"/>
					</td>
				</tr>			
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">总费用(元)<font color="red">*</font></td>
					<td colspan="6" style="width: 30%">
						<form:input id="totaFee" path="spend.totaFee" htmlEscape="false" class="input-xlarge number required" placeholder="点击自动求和"/>
					</td>
				</tr>																		
				<tr>
					<td class="trtop" colspan="2" style="width: 20%">保养详情</td>
					<td colspan="6" style="width: 30%">
						<form:textarea path="spend.remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
					</td>
				</tr>							
			</table>
			</c:if>		 --%>
		</c:if>
		<div class="form-actions">
			<shiro:hasPermission name="car:plmCarUse:edit"><a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>&nbsp;</shiro:hasPermission>
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
</body>
</html>