<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>政府项目采购申请管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/common/zztable.css" type="text/css" rel="stylesheet">
	<script type="text/javascript" src="${ctxStatic}/plm/act/supervise.js"></script> 	
	<link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet">
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
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
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/purchase/plmPurchaseApply/">采购计划申请列表</a></li>
		<li class="active"><a href="${ctx}/purchase/plmPurchaseApply/form?id=${plmPurchaseApply.id}">采购计划申请<shiro:hasPermission name="purchase:plmPurchaseApply:edit">${not empty plmPurchaseApply.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="purchase:plmPurchaseApply:edit">查看</shiro:lacksPermission></a></li>
	</ul> <br/>--%>
	<form:form id="inputForm" modelAttribute="plmPurchaseApply" action="${ctx}/purchase/plmPurchaseApply/saveAudit" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="plmAct.id"/>
		<form:hidden path="plmAct.title"/>		
		<form:hidden path="procInsId" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}"/>		
		
		<h2>政府项目采购申请单</h2>	  	  	  	
	    <table  id="tabletop" class="table  ">
		
		<tr>
			<td class="tabletop" colspan="2" >申请人： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmPurchaseApply.createBy.name}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u>  </td>			
			<td class="tabletop" colspan="2" > 采购项目部门： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmPurchaseApply.office.name} </span>&nbsp;&nbsp;&nbsp;&nbsp;</u>      </td>
			<td  class="tabletop" colspan="2" >申请日期： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span><fmt:formatDate value="${plmPurchaseApply.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></span>&nbsp;&nbsp;&nbsp;&nbsp;</u>  </td>	
				<td class="tabletop" colspan="2" >项目编号： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmPurchaseApply.applyId}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u>  </td>			
		</tr>
		</table>
		<table id="table" class="table   table-condensed">
		<tr>
			<td class="trtop">经费项目名称</td>
			<td colspan="5" >${plmPurchaseApply.fundingName}</td>			
		</tr>
		<tr>
			<td class="trtop">经费卡号</td>
			<td colspan="2" >${plmPurchaseApply.fundingCard}</td>
			<td class="trtop">经费类型</td>
			<td colspan="2" ><c:forEach items="${fns:getDictList('purchase_funding_type')}" var="fundingType">
				<c:if test="${fundingType.value==plmPurchaseApply.fundingType }">
				${fundingType.label}
				</c:if>				
				</c:forEach></td>			
		</tr>
		
		<tr>
			<td class="trtop">采购项目名称</td>
			<td colspan="2" >${plmPurchaseApply.name}</td>		
			<td class="trtop">采购项目预算</td>
			<td colspan="2" >${plmPurchaseApply.purBudget}	万元</td>			
		</tr>
		<tr>
			<td rowspan="2" class="trtop tabletd1">采购项目负责人</td>
			<td class="tabletd2 trtop">姓名</td>
			<td class="tabletd3 ">${plmPurchaseApply.userPur.name}
					</td>
			<td rowspan="2" class="trtop tabletd2">项目技术负责人</td>
			<td class="tabletd5 trtop">姓名</td>
			<td class="tabletd6 ">${plmPurchaseApply.userTech.name} 				
				</td>
		</tr>
		<tr>		
			<td class=" trtop">联系电话</td>
			<td>${plmPurchaseApply.userPur.phone}</td>			
			<td class=" trtop">联系电话/手机/邮箱</td>
			<td><c:if test="${not empty plmPurchaseApply.userTech.phone}" var="e"> ${plmPurchaseApply.userTech.phone}</c:if>
				<c:if test="${!e&&not empty plmPurchaseApply.userTech.mobile}" var="f">${plmPurchaseApply.userTech.mobile}</c:if>
				<c:if test="${!e&&!f}" >${plmPurchaseApply.userTech.email}</c:if></td>
		</tr> 
		<tr>
			<td class="trtop">采购项目概括</td>
			<td class="pingshen" colspan="5"> ${plmPurchaseApply.describes}</td>
			
		</tr>
		<tr>
			<td class="trtop">附件（采购清单等）</td>
			<td colspan="5" ><form:hidden id="files" path="files" htmlEscape="false" maxlength="256" class="input-xlarge"/> 
				<sys:ckfinder  input="files" type="files" uploadPath="/purchase/plmPurchaseApply" selectMultiple="true" readonly="true"/></td>
				
		</tr>
		<c:if test="${plmPurchaseApply.plmAct.isSup eq '0'}">
				<tr>
					<td class="trtop" colspan="1">是否督办</td>
					<td colspan="5">${fns:getDictLabel(plmPurchaseApply.plmAct.isSup, 'yes_no', '')}</td>
				</tr>	
			</c:if>
			<c:if test="${plmPurchaseApply.plmAct.isSup eq '1'}">
				<tr>
					<td class="trtop" colspan="1">是否督办</td>
					<td colspan="2">${fns:getDictLabel(plmPurchaseApply.plmAct.isSup, 'yes_no', '')}</td>
					<td class="trtop" colspan="1">督办人</td>
					<td colspan="2">${plmPurchaseApply.plmAct.supExe.name}</td>
				</tr>		
				<tr>
					<td class="trtop" colspan="1">督办明细</td>
					<td colspan="5">${plmPurchaseApply.plmAct.supDetail}</td>
				</tr>
			</c:if>	
				<!-- 自定义标签   把流转信息用纸质表的方式显示   colspan:表格意见部分跨列数    WEB-INF/tags/act/histoicTable.tag   -->		
			<act:histoicTable procInsId="${plmPurchaseApply.procInsId}" colspan="5" titleColspan="1"/>
		   	<c:if test="${rejectedBtn}">
			<c:if test="${plmPurchaseApply.plmAct.isSup ne '1'}">
				<tr>
					<td class="trtop" colspan="1">是否添加督办</td>
					<td id="isSubTd" colspan="2">
						<form:radiobuttons path="plmAct.isSup" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
					</td>
					<td class="trtop isSup" colspan="1">督办人</td>
					<td class="isSup" colspan="2">
						<sys:treeselect id="supExe" name="plmAct.supExe.id" value="${plmPurchaseApply.plmAct.supExe.id}" labelName="plmAct.supExe.name" labelValue="${plmPurchaseApply.plmAct.supExe.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true" isAll="true"/>
					</td>
				</tr>		
				<tr class="isSup">
					<td class="trtop" colspan="1">督办明细</td>
					<td colspan="5">
						<form:textarea path="plmAct.supDetail" htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge "/>
					</td>
				</tr>		
			</c:if>	
			</c:if>	
	
		
			
		<tr>
				<td class="trtop">您的意见</td>
				<td class="pingshen" colspan="5">
				   <form:textarea path="act.comment" htmlEscape="false" rows="5" maxlength="255" class="input-xxlarge "/>
                   
				</td>				
			</tr>
	</table>
		<%-- <div class="control-group">
			<label class="control-label">附件：</label>
			<div class="controls">
				<form:hidden id="files" path="files" htmlEscape="false" maxlength="256" class="input-xlarge"/>
				<sys:ckfinder input="files" type="files" uploadPath="/purchase/plmPurchaseApply" selectMultiple="true"/>
			</div>
		</div> --%>
		
		<div class="form-actions">
			<a id="btnSubmit" class="btn btn-primary" onclick="$('#flag').val('yes')"><i class="icon-ok-sign"></i>同 意</a>&nbsp;
			<c:if test="${rejectedBtn}">
			<a id="btnSubmit" class="btn btn-inverse" onclick="$('#flag').val('no')"><i class="icon-remove-sign"></i>驳 回</a>&nbsp;
			</c:if>	
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
		</div>
		
	</form:form>
</body>
</html>