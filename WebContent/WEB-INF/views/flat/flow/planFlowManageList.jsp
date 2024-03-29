<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>预案流程管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	   var ctx="${ctx}";var ctxStatic="${ctxStatic}";
	</script>
<link	href="${ctxStatic}/jquery-ztree/3.5.12/css/zTreeStyle/zTreeStyle.min.css"	rel="stylesheet" type="text/css" />
<script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
<script src="${ctxStatic}/common/alarm.js" type="text/javascript"></script>
<style type="text/css">
  .tree-left{
   background: #f0f3f4;
   width: 350px;
   float: left;
   margin-right: 10px;
   min-height: 600px;
  }
    .tree-right{
   background: #f0f3f4;
   width: 350px;
   float: left;
    min-height: 600px;
      margin-right: 10px;
  }
  .ztree{
  width: 100%;
 height: 600px;
  }
  .tree-action{
    background: #f0f3f4;
   width: 350px;
   float: left;
    min-height: 600px;
   
  }
  .domBtn {
    display: block;
    cursor: pointer;
    padding: 2px;
    margin: 2px 10px;
    border: 1px gray solid;
    background-color: #FFE6B0;
    float: left;
}
.dom_tmp {
  position: absolute;
}
</style>
<script src="${ctxStatic}/jquery-ztree/3.5.12/js/jquery.ztree.all-3.5.js"	type="text/javascript"></script>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body style="position: relative;">
    
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/fiow/planFlowManage/list">预案流程管理</a></li>
	</ul>
	<div class="tree-left" style="overflow-y:scroll;overflow-x:hidden;">
		<ul id="ReservePlanTree" class="ztree" style="height: 814px;"></ul>
	</div>
	<div class="tree-right" style="overflow-y:scroll;overflow-x:hidden;">
		<ul id="StepTree" class="ztree" style="height: 814px;"></ul>
	</div>
	<div class="tree-action">
		<div class="domBtnDiv">
			<div id="dom_1" class="categoryDiv" style="overflow-y:scroll;overflow-x:hidden;height: 814px;">
				<!-- <span class="domBtn" domId="11">动作1</span>
				<span class="domBtn" domId="12">动作2</span>
				<span class="domBtn" domId="13">动作3</span> -->
			</div>
		</div>
	</div>
	<script src="${ctxStatic}/flat/flow/planFlowManageList.js" type="text/javascript"></script>
</body>
</html>