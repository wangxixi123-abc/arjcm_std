<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购申报管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/common/zztable.css" type="text/css"
	rel="stylesheet">
<!-- 表格试表单css -->
<%-- <link href="${ctxStatic}/common/zzformtable.css" type="text/css"
	rel="stylesheet"> --%>
	<link href="${ctxStatic}/form/css/formTable.css" rel="stylesheet" />
	<script type="text/javascript" src="${ctxStatic}/plm/act/supervise.js"></script> 
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
			$("#btnCancel").on("click", function(){
				
				/* confirmx("确定要撤销申请吗？",function(){ */
					$('#flag').val('no');
					$("#inputForm").attr("action","${ctx}/purchase/plmPurchaseDeclare/apply");
					$("#inputForm").submit();
				/* }); */
			});
			$("#btnSubmit").on("click", function(){
				$("#inputForm").attr("action","${ctx}/purchase/plmPurchaseDeclare/save");
				$("#inputForm").submit();
			});
			$("#btnApply").on("click", function(){
				confirmx("提交申请后无法修改申请信息",function(){
					$('#flag').val('yes');
					$("#inputForm").attr("action","${ctx}/purchase/plmPurchaseDeclare/apply");
					$("#inputForm").submit();
				});
			});	
			
			
			$("#declareTotal").on("click", function(){
				
				var dec=$(".declareMoney");
				var declareTotal=0;
				for (var i = 0; i < dec.length; i++) {
					
					declareTotal+=Number(dec.eq(i).val());
					
					
					if(declareTotal!=0){
						$("#declareTotal").val(declareTotal)
					}
				}
				
			})
			
			
			$("#verifyTotal").on("click", function(){
				
				var dec=$(".verifyMoney");
				var declareTotal=0;
				for (var i = 0; i < dec.length; i++) {
					
					declareTotal+=Number(dec.eq(i).val());
					if(declareTotal!=0){
						$("#verifyTotal").val(declareTotal)
					}
				
					
				}
				
			})
			
				
				
			
			
			
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
		
		
	</script>
	<style type="text/css">
	
	.filebtn+.btn,.filebtn+a+.btn  {
	   font-size: 10px;
	   padding: 3px  8px;
	}
	#contentTable th{
	background-color: white;
	text-align: center;
	font-weight: 800;
	border-color:black;
	border-width: 1px 0px 1px 1px ;
	}
	#contentTable {
	border: 0px ;
	border-radius:0px;
	margin-bottom: 0px
	}
	#contentTable td{
	border-width: 1px 0px 0px 1px ;
	}
	
	</style>
</head>
<body>
	
	<form:form target="_parent"  id="inputForm" modelAttribute="plmPurchaseDeclare" action="${ctx}/purchase/plmPurchaseDeclare/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="depart.id"/>


		<form:hidden path="plmAct.id"/>
		<form:hidden path="plmAct.title"/>
		<form:hidden path="plmAct.tableName"/>
		<form:hidden path="plmAct.tableId"/>
		<form:hidden path="plmAct.formUrl"/>	
		<form:hidden path="procInsId" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}"/>		

  
      <h2>采购申报申请单</h2>

		<table id="tabletop" class="table">
			<tr>
				<td class="tabletop" colspan="2" width="25%">申请人 </span>:&nbsp;&nbsp; &nbsp;&nbsp;<span>${plmPurchaseDeclare.createBy.name}</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="tabletop" colspan="2" width="25%">所属部门 </span>: &nbsp;&nbsp; &nbsp;&nbsp;<span>${plmPurchaseDeclare.depart.name}</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="tabletop" colspan="2">申请日期：				    
					 <input name="applyDate" id="applyDate"  type="text" readonly="readonly" maxlength="20" class="input-medium  required"
					value="<fmt:formatDate value="${plmPurchaseDeclare.applyDate}" pattern="yyyy-MM-dd HH:mm:ss" />"/>
					</td>
				<td class="tabletop" colspan="2" width="25%">申请编号(系统生成): <form:input path="applyId"
						 htmlEscape="false" maxlength="64" class="input-xlarge " readonly="true" placeholder="保存后自动生成"/></td>
			</tr>
		</table>
		<table id="table" class="table table-condensed">
			
			<!-- <tr>
			<td class="trtop"  colspan="8">采购物品详细</td>
			
			</tr> -->
			<tr>					
			<td colspan="8" style="padding: 0px; ">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th style="border-left: 0px; ">名称<font color="red">*</font></th>
								<th>型号</th>
								<th>数量<font color="red">*</font></th>
								<th>申报金额(元)<font color="red">*</font></th>
								<th>核实金额(元)</th>
								<th>存放地点</th>
								<th>使用人</th>
								<!-- <th>附件</th> -->
								
								<th width="10">&nbsp;</th>
							</tr>
						</thead>
						<tbody id="plmPurchaseDeclareDetailList">
						</tbody>
						<tfoot>
							<tr><td colspan="14" style="border-left: 0px; "><a href="javascript:" onclick="addRow('#plmPurchaseDeclareDetailList', plmPurchaseDeclareDetailRowIdx, plmPurchaseDeclareDetailTpl);plmPurchaseDeclareDetailRowIdx = plmPurchaseDeclareDetailRowIdx + 1;" class="btn btn-primary">新增</a></td></tr>
						</tfoot>
					</table>
					
					
					<script type="text/template" id="plmPurchaseDeclareDetailTpl">//<!--
						<tr id="plmPurchaseDeclareDetailList{{idx}}">
							<td class="hide">
								<input id="plmPurchaseDeclareDetailList{{idx}}_id" name="plmPurchaseDeclareDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="plmPurchaseDeclareDetailList{{idx}}_delFlag" name="plmPurchaseDeclareDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td style="border-left: 0px; ">
								<input id="plmPurchaseDeclareDetailList{{idx}}_name" name="plmPurchaseDeclareDetailList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="64" class="input-small required"/>
							</td>
							<td>
								<input id="plmPurchaseDeclareDetailList{{idx}}_spec" name="plmPurchaseDeclareDetailList[{{idx}}].spec" type="text" value="{{row.spec}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<input id="plmPurchaseDeclareDetailList{{idx}}_number" min=1  name="plmPurchaseDeclareDetailList[{{idx}}].number" type="text" value="{{row.number}}" maxlength="6" class="input-small digits required"/>
							</td>
							<td>
								<input id="plmPurchaseDeclareDetailList{{idx}}_declareMoney" maxlength="9"    name="plmPurchaseDeclareDetailList[{{idx}}].declareMoney" type="text" value="{{row.declareMoney}}" class="input-small declareMoney lrunlv62"/>
							</td>
							<td>
								<input id="plmPurchaseDeclareDetailList{{idx}}_verifyMoney" maxlength="9"    name="plmPurchaseDeclareDetailList[{{idx}}].verifyMoney" type="text" value="{{row.verifyMoney}}" class="input-small  verifyMoney lrunlv62"/>
							</td>
							<td>
								<input id="plmPurchaseDeclareDetailList{{idx}}_place" name="plmPurchaseDeclareDetailList[{{idx}}].place" type="text" value="{{row.place}}" maxlength="255" class="input-small "/>
							</td>
							<td>
								<sys:treeselect id="plmPurchaseDeclareDetailList{{idx}}_user" name="plmPurchaseDeclareDetailList[{{idx}}].user.id" value="{{row.user.id}}" labelName="plmPurchaseDeclareDetailList{{idx}}.user.name" labelValue="{{row.user.name}}"
									title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
							</td>													
							<td class="text-center" width="10">
								{{#delBtn}}<span class="close btnList"  onclick="delRow(this, '#plmPurchaseDeclareDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var plmPurchaseDeclareDetailRowIdx = 0, plmPurchaseDeclareDetailTpl = $("#plmPurchaseDeclareDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(plmPurchaseDeclare.plmPurchaseDeclareDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#plmPurchaseDeclareDetailList', plmPurchaseDeclareDetailRowIdx, plmPurchaseDeclareDetailTpl, data[i]);
								plmPurchaseDeclareDetailRowIdx = plmPurchaseDeclareDetailRowIdx + 1;
							}
						});
					</script>
			
			</td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">申报合计(元)<span class="help-inline"><font color="red">*</font></span></td>
				<td colspan="2"><form:input path="declareTotal"   htmlEscape="false" maxlength="10" placeholder="点击核算" readonly="true"    class="input-xlarge  lrunlv72"/></td>
				<td class="trtop" colspan="2">核实合计(元)<span class="help-inline"></span></td>
				<td colspan="2"><form:input path="verifyTotal"    htmlEscape="false" maxlength="10"  placeholder="点击核算" readonly="true"  class="input-xlarge  lrunlv72 "/></td>
			</tr>
			<tr>
				<td class="trtop" colspan="2">采购原由</td>
				<td class="pingshen" colspan="6">
				   
                    <form:textarea path="describes" htmlEscape="false" rows="4"
								maxlength="255" class="input-xxlarge  "  cssStyle=" "/>
								<span class="help-inline"></span>
				</td>				
			</tr>
			<tr>
				<td class="trtop" colspan="2">备注</td>
				<td class="pingshen" colspan="6">
				   
                    <form:textarea path="remarks" htmlEscape="false"   maxlength="255" rows="4" class="input-xxlarge "/>
				</td>				
			</tr>
			<tr>
				<td class="trtop" colspan="2">附件（采购清单等）</td>
				<td colspan="6"><form:hidden id="files" path="files"
						htmlEscape="false" maxlength="256" class="input-xlarge" /> <sys:ckfinder
						input="files" type="files" uploadPath="/purchase/plmPurchaseApply"
						selectMultiple="true" />  </td>
                   
			</tr>
			
			<tr>
				<td class="trtop" colspan="2" style="width: 20%">是否督办</td>
				<td id="isSubTd" colspan="6">
					<form:radiobuttons path="plmAct.isSup" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</td>
				<td class="trtop isSup" colspan="2" style="width: 20%">督办人</td>
				<td class="isSup" colspan="2" style="width: 30%">
					<sys:treeselect id="supExe" name="plmAct.supExe.id" value="${plmPurchaseDeclare.plmAct.supExe.id}" labelName="plmAct.supExe.name" labelValue="${plmPurchaseDeclare.plmAct.supExe.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true" notAllowSelectParent="true" isAll="true"/>
				</td>
			</tr>		
			<tr class="isSup">
				<td class="trtop" colspan="2">督办明细</td>
				<td colspan="6">
					<form:textarea path="plmAct.supDetail" htmlEscape="false" rows="4" maxlength="256" class="input-xxlarge "/>
				</td>
			</tr>			
			<c:if test="${not empty plmPurchaseDeclare.procInsId}">
				<act:histoicTable procInsId="${plmPurchaseDeclare.procInsId}"  colspan="6" titleColspan="2"/>
			</c:if>
			<c:if test="${not empty plmPurchaseDeclare.procInsId}">
				<tr>
					<td class="trtop" colspan="2">修改备注</td>
					<td colspan="6">
					   <form:textarea path="act.comment" htmlEscape="false" rows="5" maxlength="255" class="input-xxlarge "/>
					</td>				
				</tr>			
			</c:if>
			
			
		</table>
		<div class="form-actions">
			<a id="btnApply" class="btn btn-primary" href="javascript:;"><i class="icon-print"></i>提交申请</a>&nbsp;
			<c:if test="${ empty plmPurchaseDeclare.procInsId}">
			<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>&nbsp;
			</c:if>
			
			<c:if test="${not empty plmPurchaseDeclare.procInsId}">
				<a id="btnCancel" class="btn btn-primary" href="javascript:;"><i class="icon-minus-sign"></i>作废</a>&nbsp;
			</c:if>
		
			<c:if test="${not empty plmPurchaseDeclare.id}">
			<a id="btnCancel" class="btn" href="javascript:;" onclick="history.go(-1)" ><i class="icon-reply"></i>返回</a>
			</c:if>
			<c:if test="${empty plmPurchaseDeclare.id}">
			<a id="btnCancelf" class="btn btn-primary" href="javascript:;" onclick="parent.layer.closeAll();" ><i class="icon-remove-circle"></i>关闭</a>
			</c:if>
		</div>
				
	</form:form>
</body>
</html>