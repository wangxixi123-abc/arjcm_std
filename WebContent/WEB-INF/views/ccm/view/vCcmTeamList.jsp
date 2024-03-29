<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>综治队伍管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				$("#searchForm").submit();
			})
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, ids = [], rootIds = [];
			for (var i=0; i<data.length; i++){
				ids.push(data[i].id);
			}
			ids = ',' + ids.join(',') + ',';
			for (var i=0; i<data.length; i++){
				
				if (ids.indexOf(','+data[i].parentId+',') == -1){
					if ((','+rootIds.join(',')+',').indexOf(','+data[i].parentId+',') == -1){
						rootIds.push(data[i].parentId);
					}
				}
			}
			for (var i=0; i<rootIds.length; i++){
				addRow("#treeTableList", tpl, data, rootIds[i], true);
			}
			$("#treeTable").treeTable({expandLevel : 5});
			$("#btnExport").click(
					function() {

						top.$.jBox.confirm("确认要导出数据吗？", "系统提示", function(v, h, f) {
							if (v == "ok") {
								$("#searchForm").attr("action",
										ctx + "/view/vCcmTeam/export");
								$("#searchForm").submit();
								// 还原查询action
								$("#searchForm").attr("action",
										ctx + "/view/vCcmTeam/list");
							}
						}, {
							buttonsFocus : 1
						});
						top.$('.jbox-body .jbox-icon').css('top', '55px');
					});

			$("#btnImport").click(function() {
				$.jBox($("#importBox").html(), {
					title : "导入数据",
					buttons : {
						"关闭" : true
					},
					bottomText : "导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"
				});
			});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){

				var row = data[i];
				if(row.teamType=="01"){
					row.teamType="网格员"
				}else if(row.teamType=="02"){
					row.teamType="网格长"
				}else if(row.teamType=="03"){
					row.teamType="第一责任人"
				}else if(row.teamType=="04"){
					row.teamType="运维人员"
				}else if(row.teamType=="05"){
					row.teamType="其他工作人员"
				}
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
	</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">综治组织</span>--%>
<ul class="back-list" style="height: 100%">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 112px"><a class="nav-head" href="${ctx}/view/vCcmTeam/list?office.id=${office.id}&office.parentIds=,${office.id},">数据列表</a></li>
	</ul>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/view/vCcmTeam/import"
			  method="post" enctype="multipart/form-data" class="form-search"
			  style="padding-left: 20px; text-align: center;"
			  onsubmit="loading('正在导入，请稍等...');">
			<br/><input id="uploadFile" name="file" type="file"
						style="width: 330px" /><br /> <br />
			<input id="btnImportTemplate"
				   class="btn btn-primary"  type="button" value="模板下载 " onclick="location.href='${ctxStatic}/template/excel/socialTemplate.xlsx'"/>
			<input id="btnImportSubmit"
				   class="btn btn-primary" type="submit" value="导  入 " />
		</form>
	</div>
	<form:form id="searchForm" modelAttribute="vCcmTeam" action="${ctx}/view/vCcmTeam/findform" method="post" class="breadcrumb form-search clearfix">
		
		<ul class="ul-form pull-left">
			<!--  
			<li><label>归属机构：</label>
				<sys:treeselect id="company" name="company.id" value="${user.company.id}" labelName="company.name" labelValue="${user.company.name}"
					title="组织机构" url="/sys/office/treeData?type=1" cssClass="required" allowClear="true" notAllowSelectParent="true"  cssStyle="width: 150px"/>
			</li>
			<li><label>登录名：</label>
				<form:input path="loginName" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="clearfix"></li>
			-->
			<li class="first-line"><label>部门名称：</label>
				<sys:treeselect id="office" name="office.id" value="${vCcmTeam.office.id}" labelName="office.name" labelValue="${vCcmTeam.office.name}"
					title="部门" url="/view/vCcmTeam/treeData" cssClass="input-small" allowClear="true" notAllowSelectParent="false"  cssStyle="width: 150px"/>
			</li>
			<li class="first-line"><label>姓&nbsp;&nbsp;&nbsp;名：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li class="first-line"><label>人员类型：</label>
				<form:select path="teamType" class="input-medium ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('ccm_org_team_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
				
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->

<%--			<li class="clearfix"></li>--%>
		</ul>


	<div class="clearfix pull-right btn-box">

			<a href="javascript:void(0);" id="btnImport" class="btn btn-export" style="width: 49px;display:inline-block;float: right;">
				<i></i> <span style="font-size: 12px">导入</span>
			</a>
			<a href="javascript:void(0);" id="btnExport" class="btn btn-export" style="width: 49px;display:inline-block;float: right;">
				<i></i> <span style="font-size: 12px">导出</span>
			</a>
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
				<i></i> <span style="font-size: 12px">查询</span> </a>

	</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="treeTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>姓名</th>
				<th>机构名称</th>
				<th>部门名称</th>
				<th>人员类型</th>
				<th>登录名</th>
				<th>电话</th>
				<th>手机</th>
				<shiro:hasPermission name="view:vCcmTeam:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
		<!-- 
		<c:forEach items="${page.list}" var="user">
			<tr>
				<td>${user.company.name}</td>
				<td>${user.office.name}</td>
				<td><a href="${ctx}/view/vCcmTeam/form?id={{row.id}}">${user.loginName}</a></td>
				<td>${user.name}</td>
				<td>${user.phone}</td>
				<td>${user.mobile}</td><%--
				<td>${user.roleNames}</td> --%>
				<shiro:hasPermission name="view:vCcmTeam:edit"><td>
    				<a href="${ctx}/view/vCcmTeam/form?id={{row.id}}">修改</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		 -->
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td style="height: 50px"><a href="${ctx}/view/vCcmTeam/form?id={{row.id}}">
				{{row.name}}
			</a></td>
			<td style="height: 50px">
				{{row.companyId.name}}
			</td>
			<td style="height: 50px">
				{{row.office.name}}
			</td>
			<td style="height: 50px">
				{{row.teamType}}
			</td>
			<td style="height: 50px"><a href="${ctx}/view/vCcmTeam/form?id={{row.id}}">
				{{row.loginName}}
			</a></td>
			<td style="height: 50px">
				{{row.phone}}
			</td>
			<td style="height: 50px">
				{{row.mobile}}
			</td>
			<shiro:hasPermission name="view:vCcmTeam:edit"><td style="height: 50px">
   				<a class="btnList" href="${ctx}/view/vCcmTeam/form?id={{row.id}}"  title="修改"><i class="icon-pencil"></i></a>
			</td></shiro:hasPermission>
		</tr>
	</script>
</ul>
</body>
</html>