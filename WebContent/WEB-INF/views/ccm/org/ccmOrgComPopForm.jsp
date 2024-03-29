<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>公共机构人员管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
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
        //时间合格标记
        var flag=true;
        function initAge(data) {
            // console.log("1111")
            var date=new Date(data);
            var time=new Date().getTime()-date.getTime();
            var age=time/1000/60/60/24/365;
            age=parseInt(age);
            if(time<0 || age>150 ){
                //时间不合法
                $("#tshi").show()
                flag=false;
            }else{
                $("#tshi").hide();
                flag=true;
            }
        }
		function saveForm(){
			var commonalityIdId = $("#commonalityIdId").val();
			var html1 = '<label for="" class="error">必填信息 *<label>';
			//alert(commonalityIdId.length);
			if(commonalityIdId.length!=0){
				$("#show1").html("*");
			}else{
				$("#show1").html(html1);
			}
			if(commonalityIdId.length!=0&&flag){
				$("#inputForm").submit();
			}else {
                parent.layer.msg('日期不能大于当前日期或大于150岁!', {
                    icon: 5
                });
                event.preventDefault();
            }
		}
	</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/org/ccmOrgComPop/">数据列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/org/ccmOrgComPop/form?id=${ccmOrgComPop.id}">数据<shiro:hasPermission name="org:ccmOrgComPop:edit">${not empty ccmOrgComPop.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="org:ccmOrgComPop:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmOrgComPop" action="${ctx}/org/ccmOrgComPop/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
	<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;border-top-color: white">
		<tr>

			<td>
				<div class="control-group" style="padding-top: 8px">
					<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>姓名：</label>
					<div class="controls">
						<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge required"/>

					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">性别：</label>
					<div class="controls">
						<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
		<td>
			<div class="control-group" >
				<label class="control-label" ><span class="help-inline"><font color="red" id="show1">*</font> </span>所属机构：</label>
				<div class="controls">
					<!--<form:input path="commonalityId" htmlEscape="false" maxlength="64" class="input-xlarge "/>-->
					<sys:treeselect id="commonalityId" name="commonalityId.id" value="${ccmOrgComPop.commonalityId.id}" labelName="commonalityId.name" labelValue="${ccmOrgComPop.commonalityId.name}"
									title="机构名称" url="/org/ccmOrgCommonality/treeData" cssClass="" allowClear="true" notAllowSelectParent="true" cssStyle=""/>

				</div>
			</div>
		</td>
		<td>
			<div class="control-group">
			<label class="control-label">编号：</label>
			<div class="controls">
				<form:input path="code" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
			</div>
		</td>
		<td>
			<div class="control-group">
				<label class="control-label">证件类型：</label>
				<div class="controls">
					<form:select path="idenCode" class="input-xlarge " items="${fns:getDictList('legal_person_certificate_type')}"
								 itemLabel="label" itemValue="value" htmlEscape="false"></form:select>
				</div>
			</div>
		</td>
		</tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">照片：</label>
					<div class="controls">
						<form:hidden id="images" path="images" htmlEscape="false" maxlength="255" class="input-xlarge"/>
						<sys:ckfinder input="images" type="images" uploadPath="/photo/GongGongJiGou" selectMultiple="false"  maxWidth="240" maxHeight="360"/>
					</div>
				</div>

			</td>
		</tr>


<tr>
	<td>
		<div class="control-group">
			<label class="control-label">民族：</label>
			<div class="controls">
				<form:select path="nation" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sys_volk')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
	</td>

	<td>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>出生日期：</label>
			<div class="controls">
				<input name="birthday" type="text" readonly="readonly" onchange="initAge(this.value)" maxlength="20" class="input-medium Wdate "
					   value="<fmt:formatDate value="${ccmOrgComPop.birthday}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

				<span id="tshi" class="help-inline" style="display: none"><font color="red">日期不能大于当前日期或大于150岁</font> </span>
			</div>
		</div>
	</td>
	<td>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*</font></span>证件号码：</label>
			<div class="controls">
				<form:input path="idenNum" htmlEscape="false" maxlength="30" class="input-xlarge required"/>

			</div>
		</div>
	</td>
</tr>

		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">政治面貌：</label>
					<div class="controls">
						<form:select path="politics" class="input-xlarge ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('sys_ccm_poli_stat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">学历：</label>
					<div class="controls">
						<form:select path="education" class="input-xlarge ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('sys_ccm_degree')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">职务：</label>
					<div class="controls">
						<form:input path="service" htmlEscape="false" maxlength="30" class="input-xlarge "/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">专业特长：</label>
					<div class="controls">
						<form:input path="profExpertise" htmlEscape="false" maxlength="80" class="input-xlarge "/>
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">手机号码：</label>
					<div class="controls">
						<form:input path="telephone" htmlEscape="false" maxlength="64" class="input-xlarge mobile"/>
					</div>
				</div>
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">固定电话：</label>
					<div class="controls">
						<form:input path="fixTel" htmlEscape="false" maxlength="64" class="input-xlarge simplePhone"/>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div class="control-group">
					<label class="control-label">备注信息：</label>
					<div class="controls">
						<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
					</div>
				</div>
			</td>
			<td></td>
			<td></td>
		</tr>


	</table>
		<div class="form-actions">
			<shiro:hasPermission name="org:ccmOrgComPop:edit"><input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>