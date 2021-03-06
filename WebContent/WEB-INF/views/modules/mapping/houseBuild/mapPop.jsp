<%@ page contentType="text/htmlcharset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<ul id="myTab" class="nav nav-tabs">
	<li class="active"><a href="#homePop" data-toggle="tab">人员基础信息</a></li>
	<li><a href="#otherPop" data-toggle="tab">家庭人员 </a></li>
</ul>
<div id="myTabContent" class="tab-content">
	<div class="tab-pane fade in active" id="homePop">
		<table class="table table-striped table-bordered table-condensed">
			<tr>
				<td>姓名</td>
				<td colspan="3">${ccmPeople.name}</td>
				<td rowspan="5" style="width: 20%"><img style="width: 100%"
					src="${ccmPeople.images}" /></td>
			</tr>
			<tr>
				<td style="width: 15%">性别</td>
				<td style="width: 25%">
					${fns:getDictLabel(ccmPeople.sex,'sex',"")}</td>
				<td style="width: 15%">民族</td>
				<td style="width: 25%">
					${fns:getDictLabel(ccmPeople.nation,'sys_volk',"")}</td>
			</tr>
			<tr>
				<td style="width: 15%">出生</td>
				<td  style="width: 25%"><fmt:formatDate value="${ccmPeople.birthday}"
						pattern="yyyy-MM-dd" /></td>
				<td style="width: 15%">职业：</td>
				<td  style="width: 25%">${ccmPeople.profession}</td>
			</tr>
			<tr>
				<td>住址</td>
				<td colspan="3">${ccmPeople.residencedetail}</td>
			</tr>
			<tr>
				<td colspan="1">公民身份证号码</td>
				<td colspan="3">${ccmPeople.ident}</td>
			</tr>
		</table>
	</div>
	<div class="tab-pane fade" id="otherPop">
		<table class="table table-striped table-bordered table-condensed">
			<tr>
				<td>姓名</td>
				<td>公民身份号码</td>
				<td>联系方式</td>
				<td>与户主关系</td>
				<td>操作</td>
			</tr>
			<c:forEach items="${listAccount}" var="ccmpop">
				<tr>
					<td>${ccmpop.name}</td>
					<td>${ccmpop.ident}</td>
					<td>${ccmpop.telephone}</td>
					<td>${fns:getDictLabel(ccmpop.accountrelation,'sys_ccm_fami_ties',"")}
					</td>

					<td><a class="popclick btn btn-success" href="###"
						popId="${ccmpop.id}" buildName="${buildName}" elemNum="${elemNum}"
						pilesNum="${pilesNum}">查看</a></td>
				</tr>
			</c:forEach>
			<c:if test="${  empty listAccount}">
				<tr>
					<td>暂无数据</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</c:if>
		</table>
	</div>
</div>
