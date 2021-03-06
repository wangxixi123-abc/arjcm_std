<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购合同会签管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/common/zztable.css" type="text/css" rel="stylesheet">
	<script type="text/javascript">
		$(document).ready(function() {
			/* //隐藏上传文件的“上传”和“清除”按钮
			$("#files").next().hide();
			$("#files").next().next().hide(); */
			
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
			$("#btn").on("click", function(){
					$("#inputForm").attr("action","${ctx}/act/plmAct/cancelApply");
					$("#inputForm").submit();
			});
		});
		
		/* pdf下载 */
		//根据html模版 pdf下载       url表示请求路径,进入后台处理,后台返回一个文件流		
		function downloadFile(){

		    //定义一个form表单,通过form表单来发送请求
		    var form=$("<form>");

		    //设置表单状态为不显示
		    form.attr("style","display:none");

		    //method属性设置请求类型为get
		    form.attr("method","get");

		    //action属性设置请求路径,(如有需要,可直接在路径后面跟参数)
		    //例如:htpp://127.0.0.1/test?id=123
		    form.attr("action",'${ctx}/contract/plmContractSign/printPdfIo');
            
		    var input1 = $('<input>');//将你请求的数据模仿成一个input表单
		    input1.attr('type', 'hidden');
		    input1.attr('name', 'id');//该输入框的name
		    input1.attr('value','${plmContractSign.id}');//该输入框的值
		    
		    //将表单放置在页面(body)中
		    $("body").append(form);
		    form.append(input1);
		    
		    //表单提交
		    form.submit();
		    		  
		    form.remove();
		} 
	</script>
</head>
<body>
	<br />
	<form:form id="inputForm" modelAttribute="plmContractSign" action="${ctx}/contract/plmContractSign/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="procInsId" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}"/>		
		
		
		<h2>合同会签表</h2>	
		  	 <!--pdf下载   --> 
		  <div style="text-align: right; ">       <a onclick="downloadFile()"><i class="icon-download"></i>下载</a></div>	  
		    <!--/pdf下载   -->	    	  	
	    <table  id="tabletop" class="table  ">
		
		<tr>
		     <td class="tabletop" colspan="2" >申请人： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmContractSign.createBy.name}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u>  </td>			
			<td class="tabletop" colspan="2" > 采购项目部门： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmContractSign.depart.name} </span>&nbsp;&nbsp;&nbsp;&nbsp;</u>      </td>
			<td  class="tabletop" colspan="2" >申请日期： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span><fmt:formatDate value="${plmContractSign.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></span>&nbsp;&nbsp;&nbsp;&nbsp;</u>  </td>	
			<td class="tabletop" colspan="2" >项目编号： <u> &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmContractSign.applyId}</span>&nbsp;&nbsp;&nbsp;&nbsp;</u>       </td>					
		</tr>
		</table>
		
		
		<table id="table" class="table   table-condensed">
		
		<tr>
			<td class="trtop">合同名称</td>
			<td >${plmContractSign.contractName}</td>
			<td class="trtop">合同编号</td>
			<td >${plmContractSign.contractId}</td>
			<td class="trtop">合同类型</td>
			<td ><c:forEach items="${fns:getDictList('contract_contract_type')}" var="contractType">
				<c:if test="${contractType.value==plmContractSign.contractType }">
				${contractType.label}
				</c:if>				
				</c:forEach></td>
			
		</tr>
		<tr>
			<td class="trtop">项目负责人</td>
			<td >${plmContractSign.user.name}</td>
			<td class="trtop">是否标准合同</td>
			<td ><c:forEach items="${fns:getDictList('contract_is_standard')}" var="isStandard">
				<c:if test="${isStandard.value==plmContractSign.isStandard }">
				${isStandard.label}
				</c:if>				
				</c:forEach></td>
			<td class="trtop">合同提供方</td>
			<td ><c:forEach items="${fns:getDictList('contract_provider')}" var="provider">
				<c:if test="${provider.value==plmContractSign.provider }">
				${provider.label}
				</c:if>				
				</c:forEach></td>
			
		</tr>
		<tr>
			<td class="trtop">合同金额</td>
			<td >${plmContractSign.contractMoney}万元</td>
			<td class="trtop">是否在预算内</td>
			<td  colspan="3"><c:forEach items="${fns:getDictList('contract_isBudget')}" var="isBudget">
				<c:if test="${isBudget.value==plmContractSign.isBudget }">
				${isBudget.label}
				</c:if>				
				</c:forEach></td>
			
			
		</tr>
		
		<tr>
			<td class="trtop">合同概要</td>
			<td colspan="5" >${plmContractSign.describes}</td>
				
		</tr>
		<tr>
			<td class="trtop">附件</td>
			<td colspan="5" ><form:hidden id="files" path="files" htmlEscape="false" maxlength="256" class="input-xlarge"/> 
				<sys:ckfinder  input="files" type="files" uploadPath="/contract/plmContractSign" selectMultiple="true" readonly="true"/></td>
				
		</tr>
		<tr>
				<td class="trtop" colspan="1" style="width: 20%">是否督办</td>
				<td colspan="2" style="width: 30%">${fns:getDictLabel(plmContractSign.plmAct.isSup, 'yes_no', '')}</td>
				<td class="trtop" colspan="1" style="width: 20%">督办人</td>
				<td colspan="2" style="width: 30%">${plmContractSign.plmAct.supExe.name}</td>
			</tr>		
			<tr>
				<td class="trtop" colspan="1">督办明细</td>
				<td colspan="5">${plmContractSign.plmAct.supDetail}</td>
			</tr>			
		<!-- 自定义标签   把流转信息用纸质表的方式显示   colspan:表格意见部分跨列数    WEB-INF/tags/act/histoicTable.tag   -->
		<c:if test="${not empty plmContractSign.procInsId}">
			<act:histoicTable procInsId="${plmContractSign.act.procInsId}" colspan="5" />
		</c:if>		
	</table>
	
		<div class="form-actions">		
			<c:if test="${cancelFlag == 1}">
				<a id="btn" class="btn" ><i class="icon-undo"></i>撤销</a>&nbsp;
			</c:if>
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
</body>
</html>