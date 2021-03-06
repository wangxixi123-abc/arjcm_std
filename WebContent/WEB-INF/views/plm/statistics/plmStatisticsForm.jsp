<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>个人门户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
			//$("#name").focus();
			$('#btnSubmit').click(function(){
				$('#inputForm').submit();
			});
			$("#inputForm").validate({
				submitHandler: function(form){
					
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
		
		//下拉事件
		function  selectsubmit(){	
			
			var content= $("#content").val();
				//alert(content)
				//内容变动时  回自动匹配 相对应的标题和更多链接
			 $.ajax({
				  url:'${ctx}/statistics/plmStatistics/selectContent',
				  data:{"content":content },
				  type:'post',
				  dataType:'json',
				  error: function(){ alert("错误")},
				  success:function(data){
					  
					
					$("input[name='title']").attr("value",data.title);
				   }
				  });	  
			}
		
	</script>
</head>
<body>
	<br/>
	<form:form target="_parent" id="inputForm" modelAttribute="plmStatistics" action="${ctx}/statistics/plmStatistics/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<br>
		<div class="control-group">
			<label class="control-label">内容：</label>
			<div class="controls">
				<form:select path="content" class="input-xlarge required" onchange="selectsubmit()" >				
					<form:options items="${plmStatisticsDictList}" itemLabel="titleAndTypeName" itemValue="content" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font></span>
			</div>
		</div>
		<br>
		<div class="control-group">
			<label class="control-label">布局标题：</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" class="input-xlarge required"/>
				<span class="help-inline"> <font color="red">*</font></span>
			</div>
		</div>
		 
		
		
		<div class="form-actions">
			<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>
			
		</div>
	</form:form>
</body>
</html>