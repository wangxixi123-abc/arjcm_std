<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学校管理</title>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
	<!-- 鱼骨图 -->
<link rel="stylesheet" href="${ctxStatic}/ccm/event/css/fishBonePop.css" />
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/fishBonePop.js"></script>
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
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
			$("td").css({"padding":"8px"});
			$("td").css({"border":"0px dashed #CCCCCC"});
			//跟踪信息
			var jsonString = '${documentList}';
            data = JSON.parse(jsonString);  
			$(".fishBone1").fishBone(data, '${ctx}','deal');
			$(".fishBone2").fishBone(data, '${ctx}','read');
		});
		
		function saveForm() {
			var area = $("#areaId").val();
			var html1 = '<label for="" class="error">必选字段 <label>';
			//alert(officeId.length);
			if (area.length != 0) {
				$("#show1").html("");
			} else {
				$("#show1").html(html1);
			}

			if (area.length != 0) {
				$("#inputForm").submit();
			}

		}
		function ThisLayerDialog(src, title, height, width) {
			parent.drawForm = parent.layer.open({
				type: 2,
				title: title,
				area: [height, width],
				fixed: true, //固定
				maxmin: false,
				/*   btn: ['关闭'], //可以无限个按钮 */
				content: src,
				zIndex: '1992',
				cancel: function () {
					//防止取消和删除效果一样
					window.isCancel = true;
				},
				end: function () {
					if (!window.isCancel) {
						$("#areaPoint")[0].value = parent.areaPoint;
						parent.areaPoint = null;
						$("#areaMap")[0].value = parent.areaMap;
						parent.areaMap = null;
					}
					window.isCancel = null;
				}
			});
		}
	</script>
	<link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
	<style>

	</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a style="width: 140px;text-align:center" href="${ctx}/house/ccmHouseSchoolrim/list">学校列表</a></li>
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/house/ccmHouseSchoolrim/form?id=${ccmHouseSchoolrim.id}">学校<shiro:hasPermission name="house:ccmHouseSchoolrim:edit">${not empty ccmHouseSchoolrim.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="house:ccmHouseSchoolrim:edit">查看</shiro:lacksPermission></a></li>
		<%-- <c:if test="${not empty ccmHouseSchoolrim.id}">
			<li><a
				href="${ctx}/log/ccmLogTail/formPro?relevance_id=${ccmHouseSchoolrim.id}&relevance_table=ccm_house_school">跟踪信息<shiro:hasPermission
						name="log:ccmLogTail:edit">${not empty ccmLogTail.id?'修改':'添加'}</shiro:hasPermission>
					<shiro:lacksPermission name="log:ccmLogTail:edit">查看</shiro:lacksPermission></a>
			</li>
		</c:if> --%>
	</ul>
	<form:form id="inputForm" modelAttribute="ccmHouseSchoolrim" action="${ctx}/house/ccmHouseSchoolrim/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
		<table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;border-top-color: white">
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>学校名称：</label>
						<div class="controls">
							<form:input path="schoolName" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>学校地址：</label>
						<div class="controls">
							<form:input path="schoolAdd" htmlEscape="false" maxlength="200" class="input-xlarge required"/>
						</div>
					</div>
				</td>

			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red" id="show1">*</font> </span>所属社区：</label>
						<div class="controls">
							<sys:treeselect id="area" name="area.id" value="${ccmHouseSchoolrim.area.id}" labelName="area.name" labelValue="${ccmHouseSchoolrim.area.name}"
											title="区域" url="/tree/ccmTree/treeDataArea?type=6" allowClear="true" notAllowSelectParent="true" cssClass=""/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>在校学生人数：</label>
						<div class="controls">
							<form:input path="schoolNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits required" type= "number"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>学校办学类型：</label>
						<div class="controls">
							<form:select path="schoolType" class="input-xlarge required">
								<form:options items="${fns:getDictList('ccm_schol_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>

						</div>
					</div>
				</td>


			</tr>
			<tr><td>
				<div>
					<label class="control-label">学校照片：</label>
					<div class="controls">
						<form:hidden id="images" path="images" htmlEscape="false" maxlength="255" class="input-xlarge"/>
						<sys:ckfinder input="images" type="images" uploadPath="/photo/XueXiao" selectMultiple="false" maxWidth="160" maxHeight="240"/>
					</div>
				</div>
			</td></tr>
			<tr>


			</tr>
			<tr>
			<tr>

				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>学校所属主管教育行政部门：</label>
						<div class="controls">
							<form:input path="schoolEducDepa" htmlEscape="false" maxlength="6" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">教职工人数：</label>
						<div class="controls">
							<form:input path="teacherNum" htmlEscape="false" maxlength="6" class="input-xlarge  digits" type= "number"/>
						</div>
					</div>
				</td>
			<td>
				<div>
					<label class="control-label">教学经费(元)：</label>
					<div class="controls">
						<form:input path="teachingFunds" htmlEscape="false" maxlength="12" class="input-xlarge  digits" type= "number"/>
					</div>
				</div>
			</td>

			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>校长姓名：</label>
						<div class="controls">
							<form:input path="headName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>校长联系方式：</label>
						<div class="controls">
							<form:input path="headTl" htmlEscape="false" maxlength="18" class="input-xlarge required phone"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>分管安全保卫责任人姓名：</label>
						<div class="controls">
							<form:input path="secuBranName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>分管安全保卫责任人联系方式：</label>
						<div class="controls">
							<form:input path="secuBranTl" htmlEscape="false" maxlength="50" class="input-xlarge required phone"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>安全保卫责任人姓名：</label>
						<div class="controls">
							<form:input path="secuGuardName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>安全保卫责任人联系方式：</label>
						<div class="controls">
							<form:input path="secuGuardTl" htmlEscape="false" maxlength="50" class="input-xlarge required phone" />
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>治安责任人姓名：</label>
						<div class="controls">
							<form:input path="secuName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>治安责任人联系方式：</label>
						<div class="controls">
							<form:input path="secuTl" htmlEscape="false" maxlength="50" class="input-xlarge required phone" />
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>安全保卫人数：</label>
						<div class="controls">
							<form:input path="secuGuardNum" htmlEscape="false" maxlength="3" class="input-xlarge number digits required"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">区域图：</label>
						<div class="controls">
							<form:input path="areaMap" readonly="true" htmlEscape="false" maxlength="2000" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">中心点：</label>
						<div class="controls">
							<form:input path="areaPoint" readonly="true" htmlEscape="false" maxlength="40" class="input-xlarge "/>
							<a onclick="ThisLayerDialog('${ctx}/event/ccmEventIncident/drawForm?areaMap='+$('#areaMap').val()+'&areaPoint='+$('#areaPoint').val(), '标注', '1100px', '700px');"
						    	class="btn hide1 btn-primary">标 注</a>
						</div>
					</div>
				</td>


			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">图标：</label>
						<div class="controls">
							<sys:iconselect id="image" name="image" value="${ccmHouseSchoolrim.image}"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td rowspan="3">
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="255" class="input-xlarge " />
						</div>
					</div>
				</td>

			</tr>
		</table>
		
	<%-- 	<table border="1px" style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			
        	<%@include file="/WEB-INF/views/include/ccmlog.jsp" %>
		</table> --%>
		<div class="form-actions">
			<shiro:hasPermission name="house:ccmHouseSchoolrim:edit"><input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form><br>
	<c:if test="${documentNumber > 0}">
		<shiro:hasPermission name="log:ccmLogTail:edit">
			<h4>&nbsp;跟踪信息：</h4>
			<br>
			<div class="fishBone1" ></div>
		</shiro:hasPermission>
		<shiro:lacksPermission name="log:ccmLogTail:edit">
			<h4>&nbsp;查看跟踪信息：</h4>
			<br>
			<div class="fishBone2" ></div>
		</shiro:lacksPermission> 
	</c:if>
</body>
</html>