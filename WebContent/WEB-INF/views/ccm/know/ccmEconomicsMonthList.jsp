<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经济运行数据-月管理</title>
	<meta name="decorator" content="default"/>
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
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/know/ccmEconomicsMonth/">数据列表</a></li>
		<shiro:hasPermission name="know:ccmEconomicsMonth:edit"><li><a href="${ctx}/know/ccmEconomicsMonth/form">数据添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmEconomicsMonth" action="${ctx}/know/ccmEconomicsMonth/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>年月：</label>
				<input name="beginMonths" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmEconomicsMonth.beginMonths}" pattern="yyyy-MM"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/> - 
				<input name="endMonths" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmEconomicsMonth.endMonths}" pattern="yyyy-MM"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/>
			</li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
			<li class="btns">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary">
                <i class="icon-search"></i> 查询 </a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>年月</th>
				<th>本年累计生产总值（亿元）</th>
				<th>失业率</th>
				<th>利率</th>
				<th>生产物价指数（PPI）</th>
				<th>消费物价指数（CPI）</th>
				<th>人均可支配收入（元）</th>
				<th>税收（万元）</th>
				<shiro:hasPermission name="know:ccmEconomicsMonth:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmEconomicsMonth">
			<tr>
				<td><a href="${ctx}/know/ccmEconomicsMonth/form?id=${ccmEconomicsMonth.id}">
					<fmt:formatDate value="${ccmEconomicsMonth.months}" pattern="yyyy-MM"/>
				</a></td>
				<td>
					${ccmEconomicsMonth.gdp}
				</td>
				<td>
					${ccmEconomicsMonth.unemploymentRate}
				</td>
				<td>
					${ccmEconomicsMonth.interestRate}
				</td>
				<td>
					${ccmEconomicsMonth.ppi}
				</td>
				<td>
					${ccmEconomicsMonth.cpi}
				</td>
				<td>
					${ccmEconomicsMonth.personalIncome}
				</td>
				<td>
					${ccmEconomicsMonth.revenue}
				</td>
				<shiro:hasPermission name="know:ccmEconomicsMonth:edit"><td>
    				<a class="btnList" href="${ctx}/know/ccmEconomicsMonth/form?id=${ccmEconomicsMonth.id}" title="修改"><i class="icon-pencil"></i></a>
					<a class="btnList" href="${ctx}/know/ccmEconomicsMonth/delete?id=${ccmEconomicsMonth.id}" onclick="return confirmx('确认要删除该经济运行数据-月吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>