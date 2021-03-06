<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>学员信息管理</title>
<meta name="decorator" content="default" />
<link rel="stylesheet"
	href="${ctxStatic}/jquery-icheck/skins/all.css?v=0.7.1">
<script type="text/javascript"
	src="${ctxStatic}/jquery-icheck/js/jquery.icheck.js"></script>
<script type="text/javascript">
  $(document).ready(
      function() {
        //$("#name").focus();
        $("#inputForm").validate(
            {
              submitHandler : function(form) {
                loading('正在提交，请稍等...');
                form.submit();
              },
              errorContainer : "#messageBox",
              errorPlacement : function(error, element) {
                $("#messageBox").text("输入有误，请先更正。");
                if (element.is(":checkbox") || element.is(":radio")
                    || element.parent().is(".input-append")) {
                  error.appendTo(element.parent().parent());
                } else {
                  error.insertAfter(element);
                }
              }
            });
      });
  
    function getiType(){
	/*   $(".select2-chosen").val(); */
	    if($("#iType").val()==2){
	    	$("#dtAdmission").attr("disabled",true);
	    	$("#dtCorrection").attr("disabled",true);
	    	$("#dtAdmission").val("");
	    	$("#dtCorrection").val("");
	    }else if($("#iType").val()==0){
	    	$("#dtCorrection").attr("disabled",true);
	    	$("#dtCorrection").val("");
	    	$("#dtAdmission").removeAttr("disabled");	
	    }else if($("#iType").val()==1){
	    	$("#dtAdmission").removeAttr("disabled");
	    	$("#dtCorrection").removeAttr("disabled");	
	    }
    }
	  
	  function getiFloat(){
		  if($("#iFloat").val()==0){
			  $("#sFloattopro").attr("disabled",true);
			  $("#sFloattocity").attr("disabled",true);
			  $("#sFloattocounty").attr("disabled",true);
			  $("#sFloattopro").val("");
			  $("#sFloattocity").val("");
			  $("#sFloattocounty").val("")
		  }else{
			  $("#sFloattopro").removeAttr("disabled");
			  $("#sFloattocity").removeAttr("disabled");
			  $("#sFloattocounty").removeAttr("disabled");
		  }
	  }
/*   }
	function getspAlleviation() {
		if($("#spAlleviation").val()==02){
			$("#spIncomeType").attr("disabled",true);
			$("#spIncomeAmount").attr("disabled",true);
			$("#spTime").attr("disabled",true);
			$("#spIncomeType").val("");
			$("#s2id_spIncomeType").find(".select2-chosen").text("");
			$("#spIncomeAmount").val("");
			$("#spTime").val("");
		} else {
			$("#spIncomeType").removeAttr("disabled");
			$("#spIncomeAmount").removeAttr("disabled");
			$("#spTime").removeAttr("disabled");
		}
	} */
  
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/person/pbsPartymem/">学员信息列表</a></li>
		<li class="active"><a
			href="${ctx}/person/pbsPartymem/form?id=${pbsPartymem.id}">学员信息<shiro:hasPermission
					name="person:pbsPartymem:edit">${not empty pbsPartymem.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="person:pbsPartymem:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="pbsPartymem"
		action="${ctx}/person/pbsPartymem/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="pbsMemlabel.id"  value="${pbsPartymem.pbsMemlabel.id}"/>
		<sys:message content="${message}" />
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>证件类别：</label>
			<div class="controls">
				<!-- sys_idtype  -->
				<form:select path="sIdtype" class="input-xlarge required">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('sys_idtype')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>证件号码：</label>
			<div class="controls">
				<form:input path="sIdnum" htmlEscape="false" maxlength="30"
					class="input-xlarge required" />
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>证件号码：</label>
			<div class="controls">
				<form:input path="sIdnum" htmlEscape="false" maxlength="18"
					class="input-xlarge required ident0 card" />
				<span id="ident0"></span><span class="help-inline"></span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>姓名：</label>
			<div class="controls">
				<form:input path="sName" htmlEscape="false" maxlength="200"
					class="input-xlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>性别：</label>
			<div class="controls">
				<form:select path="iSex" class="input-xlarge required">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('sex')}" itemLabel="label"
						itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>民族信息：</label>
			<div class="controls">
				<form:select path="iNation" class="input-xlarge required">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('sys_volk')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">出生日期：</label>
			<div class="controls">
				<input name="dtBirth" type="text" readonly="readonly" maxlength="20"
					class="input-xlarge Wdate "
					value="<fmt:formatDate value="${pbsPartymem.dtBirth}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">学历信息：</label>
			<div class="controls">
				<form:select path="sEducation" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('sys_degree')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>学员类别：</label>
			<div class="controls">
				<form:select path="iType" class="input-xlarge required" onclick="getiType()">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('sys_mebcategory')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">所在党支部全称：</label>
			<div class="controls">
				<form:input path="sPartybranch" htmlEscape="false" maxlength="64"
					class="input-xlarge " />
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">入党日期：</label>
			<div class="controls">
				<input id="dtAdmission" name="dtAdmission" type="text" readonly="readonly"
					maxlength="20" class="input-xlarge Wdate "
					value="<fmt:formatDate value="${pbsPartymem.dtAdmission}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">转正日期：</label>
			<div class="controls">
				<input id="dtCorrection" name="dtCorrection" type="text" readonly="readonly"
					maxlength="20" class="input-xlarge Wdate "
					value="<fmt:formatDate value="${pbsPartymem.dtCorrection}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">工作岗位：</label>
			<div class="controls">
				<form:input path="sPost" htmlEscape="false" maxlength="64"
					class="input-xlarge " />
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label"><font color="red">*&nbsp;</font>联系电话-移动电话：</label>
			<div class="controls">
				<form:input path="sMobilephone" htmlEscape="false" maxlength="64"
					class="input-xlarge required mobile" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">联系电话-固定电话：</label>
			<div class="controls">
				<form:input path="sFixedphone" htmlEscape="false" maxlength="64"
					class="input-xlarge simplePhone" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">家庭住址：</label>
			<div class="controls">
				<form:input path="sHomeaddr" htmlEscape="false" maxlength="200"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">党籍状态：</label>
			<div class="controls">
				<form:select path="iStat" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('sys_mebtype')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">人物标签：</label>
			<div class="controls">
				<form:checkboxes path="pbsMemlabel.posidList"
					items="${pbsLabelinfos}" itemLabel="SName" itemValue="SType"
					htmlEscape="false" class="" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">人物标签描述：</label>
			<div class="controls">
				<form:textarea path="pbsMemlabel.sDescription" htmlEscape="false" rows="4" maxlength="200" class="input-xlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否为失联学员：</label>
			<div class="controls">
				<form:select path="iOutcontact" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('yes_no')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">失联日期：</label>
			<div class="controls">
				<input name="dtOutcontact" type="text" readonly="readonly"
					maxlength="20" class="input-xlarge Wdate "
					value="<fmt:formatDate value="${pbsPartymem.dtOutcontact}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否为流动学员：</label>
			<div class="controls">
				<form:select path="iFloat" class="input-xlarge " onclick="getiFloat()">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('yes_no')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">外出流向_省：</label>
			<div class="controls">
				<form:input path="sFloattopro" htmlEscape="false" maxlength="64"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">外出流向_市：</label>
			<div class="controls">
				<form:input path="sFloattocity" htmlEscape="false" maxlength="64"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">外出流向_县：</label>
			<div class="controls">
				<form:input path="sFloattocounty" htmlEscape="false" maxlength="64"
					class="input-xlarge " />
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4"
					maxlength="255" class="input-xxlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">归属组织：</label>
			<div class="controls">
				<form:input path="company.id" htmlEscape="false" maxlength="64"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">归属部门：</label>
			<div class="controls">
				<sys:treeselect id="office" name="office.id"
					value="${pbsPartymem.office.id}" labelName="office.name"
					labelValue="${pbsPartymem.office.name}" title="部门"
					url="/sys/office/treeData?type=2" cssClass="" allowClear="true"
					notAllowSelectParent="true" />
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">学员头像：</label>
			<div class="controls">
				<form:hidden id="nameImage" path="sPhoto" htmlEscape="false"
					maxlength="255" class="input-xlarge" />
				<sys:ckfinder input="nameImage" type="images"
					uploadPath="/person/pbsPartymem" selectMultiple="false"
					maxWidth="100" maxHeight="100" />
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="person:pbsPartymem:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>

