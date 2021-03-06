<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>方案KPI管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/jquery-ztree/3.5.12/css/zTreeStyle/zTreeStyle.min.css" rel="stylesheet" type="text/css" />
    <link href="${ctxStatic}/kpi/css/kpiSchemeTreeList.css" rel="stylesheet" type="text/css" />
    <style>
     .kpi-bg{
       background: #f5f5f5
       }
    </style>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				$("#searchForm").submit();
			})
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		var ctx = '${ctx}', ctxStatic = '${ctxStatic}';
	</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">专项考核管理</span>--%>
<div class="back-list">
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/scheme/kpiScheme/treeList">方案KPI管理</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="kpiScheme" action="${ctx}/scheme/kpiScheme/treeList" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>方案名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li class="first-line"><label>所属部门：</label>
				<sys:treeselect id="office" name="office.id" value="${kpiScheme.office.id}" labelName="office.name" labelValue="${kpiScheme.office.name}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li class="first-line"><label>考核人员类别：</label>
				<form:select path="userType" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->


			<li class="first-line"><label>开始时间：</label>
				<input name="startTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${kpiScheme.startTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});"/>
			</li>
			<li class="first-line"><label>结束时间：</label>
				<input name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${kpiScheme.endTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});"/>
			</li>
			<li class="second-line"><label>方案状态：</label>
				<form:select path="state" class="input-medium">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('kpi_scheme_state')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
<%--			<li class="clearfix"></li>--%>
			</li>
		</ul>

	<div class="clearfix pull-right btn-box">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;margin-left: 20px;margin-right: 14px;margin-bottom: 20px">
				<i></i><span style="font-size: 12px">查询</span>  </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>
	    <div class="row-fluid" style="margin-top: 60px">
			<div class="span4 kpi-bg">
				<h4 class="padding-style">方案KPI</h4>
				<div style="height:650px;overflow: auto">
					<div class="index-style" id="index-tree">
						<ul id="assetTree" class="ztree" style="margin-top: 10px;"></ul>
					</div>
				</div>
			</div>
		    <div class="span8 kpi-bg" >
				<!-- <h4 class="padding-style">详情</h4> -->
				<div style="height:650px;overflow: hidden;width:100%">
					<div class="index-style2" id="index-details" style="margin-left:5%;width:88%;height:100%;overflow: auto"> 
						
				<iframe id="indexDetailsIframe" name="indexDetailsIframe" src="${ctx}/scheme/kpiScheme/formDap"
				<%--<iframe id="indexDetailsIframe" name="indexDetailsIframe" src="${ctx}/scheme/kpiScheme/formDap?id=f6e70eca9d8148dbb27a399ecca2e167"--%>
						 style="overflow: visible;" scrolling="yes" frameborder="no" 	width="100%" height="90%" allowfullscreen="true" allowtransparency="true"></iframe>
					</div>
				</div>
			</div>
	    </div>
	    
	    
	    <!-- 右键菜单 -->
	    <div id="rMenu">
			<ul>
				<li id="m_add" onclick="addTreeNode();" style="background: #094067;color: #fff;">增加</li>
				<!-- <li id="m_del" onclick="removeTreeNode();">删除</li> -->
			</ul>
        </div>
	    <!-- 右键菜单 -->
	    <script src="${ctxStatic}/jquery/jquery-1.9.1.min.js"></script>
		<script src="${ctxStatic}/jquery-ztree/3.5.12/js/jquery.ztree.all-3.5.js"	type="text/javascript"></script>
		<script>
			var treeData=${mapList};
			var len=treeData.length;
			var treeArr=[];
			if(len>0){
				for(var i=0;i<len;i++){
					treeArr.push({
						"id":treeData[i].type,
						"pId":treeData[i].typeO,
						"name":treeData[i].value,
						"icon":treeData[i].typeO=="0"?ctxStatic+"/kpi/images/scheme_fangan.png":ctxStatic+"/kpi/images/scheme_kpi.png"
						
					})
				}
			}


		</script>
		<script src="${ctxStatic}/kpi/kpiSchemeTreeList.js"></script>
</body>
</html>