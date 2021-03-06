<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>户籍人口统计</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/ccm/pop/css/ccmPepInfo.css" rel="stylesheet" />
<style>
#ech, #ech1, #ech2 {

	height:395px;
}
.ToAuto {
	overflow: auto;
	height: 395px;
}
</style>
<script type="text/javascript"
	src="${ctxStatic}/echarts/echarts.common.min.js"></script>
<script type="text/javascript" src="${ctxStatic}/echarts/walden.js"></script>
<script type="text/javascript"
	src="${ctxStatic}/echarts/echarsCommon.js"></script>
</head>
<body>
	<div class="context" content="${ctx}"></div>
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatPerson">数据统计</a></li>
		<li><a style="width: 140px;text-align:center" href="${ctx}/pop/ccmPeople/">数据列表</a></li>
	</ul>
	<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatPerson">户籍人口统计</a></li>
			<li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatFloat">流动人口统计</a></li>
			<li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatOverSea">境外人口统计</a></li>
			<li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatUnsettle">未落户人口统计</a></li>
		</ul>
	<div class="row-fluid">
		
		<div id="ech1" class="span9"></div>
		<div id="echList1" class="span3">
			<div class="ToAuto">
				<table class="table table-striped">
					<thead>
						<tr>
							<th>区域</th>
							<th title="本月户籍新增人数">本月户籍新增人数</th>
							<th title="本月户籍总数">本月户籍总数</th>
						</tr>
					</thead>
					<tbody class="body">
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<br>
	<div class="row-fluid">
		<div id="ech2" class="span9"></div>
		<div id="echList2" class="span3">
			<div class="ToAuto">
				<table class="table table-striped">
					<thead>
						<tr>
							<th>时间</th>
							<th title="新增户籍人数">新增户籍人数</th>
							<th title="户籍总人数">户籍总人数</th>
						</tr>
					</thead>
					<tbody class="body">
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript"
		src="${ctxStatic}/ccm/pop/js/ccmPersonInfo.js"></script>
</body>
</html>