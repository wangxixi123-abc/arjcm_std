<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>房屋管理</title>
	<link href="${ctxStatic}/form/css/form.css" rel="stylesheet" />
	<meta name="decorator" content="technology"/>
	<!-- 鱼骨图 -->
<link rel="stylesheet" href="${ctxStatic}/ccm/event/css/fishBonePop.css" />
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/fishBonePop.js"></script>
<script type="text/javascript" src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
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
			$("td").css({"border":"1px dashed #CCCCCC"});
			//鱼骨图
			var jsonString = '${documentList}';
            data = JSON.parse(jsonString);  
			$(".fishBone1").fishBone(data, '${ctx}','deal');
			$(".fishBone2").fishBone(data, '${ctx}','read');
			var s = $("#sel").val();
			if(s=="02"){
				$(".selectHidden").show();
			}else{
				$(".selectHidden").hide();
			}
		});
		function sels(){
			var s = $("#sel").val();
			if(s=="02"){
				$(".selectHidden").show();
			}else{
				$(".selectHidden").hide();
			}
		}
	</script>
</head>
<body>
	<br/>
	<c:if test="${type eq 'hire' }">
		<form:form id="inputForm" modelAttribute="ccmPopTenant" action="${ctx}/pop/ccmPopTenant/save/rent" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="buildingId"/>
		<form:hidden path="buildingId.id"/>
		<form:hidden path="area.id"/>
		<sys:message content="${message}"/>	
		<table border="1px"
			style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			<tr>
				<td>
					<div>
						<label class="control-label">房屋编号：</label>
						<div class="controls">
							<form:input path="houseBuild" htmlEscape="false" maxlength="50" readonly="true"  class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">门牌号：</label>
						<div class="controls">
							<form:input path="doorNum" htmlEscape="false" maxlength="6" readonly="true" class="input-xlarge required"/>
				   			<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
					
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">楼门号：</label>
						<div class="controls">
				  			<form:input path="buildDoorNum" htmlEscape="false" maxlength="4" readonly="true" class="input-xlarge" style="display:none"/>
							<select id="buildDoorNumSelect" disabled="true" class="input-xlarge required" name="buildDoorNumSelect"></select>
				  			<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">层数：</label>
						<div class="controls">
							<form:input path="floorNum" htmlEscape="false" maxlength="3" readonly="true" class="input-xlarge required digits" type= "number"/>
				  			<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">建筑用途：</label>
						<div class="controls">
							<form:select path="housePrup" disabled="true" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_str_use')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						    </form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">建筑面积(平方米）：</label>
						<div class="controls">
							<form:input path="houseArea" htmlEscape="false" readonly="true" class="input-xlarge " type="number"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">状态：</label>
						<div class="controls">
							<form:select path="houseType" class="input-xlarge" disabled="true"  id="sel"  onchange="sels()" >
								<form:options items="${fns:getDictList('ccm_pop_tenant_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						    </form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">房屋地址：</label>
						<div class="controls">
							<form:input path="housePlace" htmlEscape="false" maxlength="200" readonly="true" class="input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">房主姓名：</label>
						<div class="controls">
							<form:input path="houseName" htmlEscape="false" maxlength="50" readonly="true" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">房主联系方式：</label>
						<div class="controls">
							<form:input path="houseTl" htmlEscape="false" maxlength="50" readonly="true" class="input-xlarge phone"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">证件类型：</label>
						<div class="controls">
							<form:select path="idenCode" disabled="true" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sys_ccm_org_papers')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						    </form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">证件号码：</label>
						<div class="controls">
							<form:input path="idenNum" htmlEscape="false" maxlength="30" readonly="true" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">隐患类型：</label>
						<div class="controls">
							<form:select path="hazard" disabled="true" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_hidd_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						    </form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">房主现在居住详细地址：</label>
						<div class="controls">
							<form:input path="houseCur" htmlEscape="false" maxlength="200" readonly="true" class="input-xlarge "/>
						</div>
					</div>
				</td>
			</tr>
			<tr class="selectHidden">
				<td>
					<div>
						<label class="control-label">承租人姓名：</label>
						<div class="controls">
							<form:input path="tenantName" htmlEscape="false" maxlength="50" readonly="true" class="input-xlarge "/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">承租人公民身份号码：</label>
						<div class="controls">
							<form:input path="tenantId" htmlEscape="false" maxlength="18" readonly="true" class="input-xlarge"/>
						</div>
					</div>
				</td>
			</tr>
			<tr class="selectHidden">
				<td>
					<div>
						<label class="control-label">承租人联系方式：</label>
						<div class="controls">
							<form:input path="tenantTl" htmlEscape="false" maxlength="50" readonly="true" class="input-xlarge phone"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">出租用途：</label>
						<div class="controls">
							<form:select path="rentPur" disabled="true" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_let_use')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						    </form:select>
						</div>
					</div>
				</td>
			</tr>

			<%--<c:if test="${not empty ccmPopTenant.id}">
				<shiro:hasPermission name="pop:ccmPopTenant:edit">
					<tr>
						<td>
							<div>
								<label class="control-label">中心点：</label>
								<div class="controls">
									<form:input path="areaPoint" readonly="true" htmlEscape="false" maxlength="40" class="input-xlarge "/>
								</div>
							</div>
						</td>
						<td>
							<div>
								<label class="control-label">区域图：</label>
								<div class="controls">
									<form:input path="areaMap" readonly="true" htmlEscape="false" maxlength="2000" class="input-xlarge "/>
								</div>
							</div>
						</td>
					</tr>
				</shiro:hasPermission>
			</c:if>--%>
			<tr>
				<td>
					<div>
						<label class="control-label">所属楼栋：</label>
						<div class="controls">
						<form:input path="buildingId" htmlEscape="false" maxlength="2000" readonly="true" class="input-xlarge " value="${ccmPopTenant.buildingId.buildname}" readOnly="true"/>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">图标：</label>
						<div class="controls">
							<sys:iconselect id="image" name="image" value="${ccmPopTenant.image}"/>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div>
						<label class="control-label">房屋产权类型：</label>
						<div class="controls">
							<form:select path="propertyType" disabled="true" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('ccm_PopTenant_propertyType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">年限：</label>
						<div class="controls">
						<form:select path="buildingYears" disabled="true" class="input-xlarge ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('ccm_PopTenant_buildingYears')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
						</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<div>
						<label class="control-label">建筑类型：</label>
						<div class="controls">
						<form:select path="buildingType" disabled="true" class="input-xlarge ">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('ccm_PopTenant_buildingType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
						</div>
					</div>
				</td>
				<td>
					<div>
						<label class="control-label">备注信息：</label>
						<div class="controls">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" readonly="true" class="input-xlarge " />
						</div>
					</div>
				</td>
			</tr>
		</table>
		
	<%-- 	<table border="1px"
			style="border-color: #CCCCCC; border: 1px solid #CCCCCC; padding: 10px; width: 100%;">
			
          <%@include file="/WEB-INF/views/include/ccmlog.jsp" %>
		</table> --%>
	</form:form>
	</c:if>
	<br>
	<script type="text/javascript">
		$(function(){
			var buildDoorNumVal=$('#buildDoorNum').val();
			$.getJSON("${ctx}/house/ccmHouseBuildmanage/getBuildentrance?id=${ccmPopTenant.buildingId.id}",function(data){
				var html='<option value="0" class="required">请选择</option>';
				for(var i in data){
					html+='<option value="'+data[i].entranceNum+'" class="required">'+data[i].entranceName+'</option>'
				}
				$('#buildDoorNumSelect').html(html);
				if(buildDoorNumVal != ''){
					$("#buildDoorNumSelect").val(buildDoorNumVal).select2()
				}else{
					$("#buildDoorNumSelect").val('0').select2()
				}
			})
			$('#buildDoorNumSelect').change(function(){
				var buildDoorNumSelecVal= $('#buildDoorNumSelect').val();
				$('#buildDoorNum').val(buildDoorNumSelecVal);
			})
		})
	</script>
</body>
</html>