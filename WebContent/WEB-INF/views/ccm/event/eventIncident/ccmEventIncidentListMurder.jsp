<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>命案防控管理</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btnSubmit").on("click" ,function(){
			$("#searchForm").submit();
		})
	});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
	$(function(){
		$(".pimg").click(function(){
			var _this = $(this);//将当前的pimg元素作为_this传入函数
			imgShow("#outerdiv", "#innerdiv", "#bigimg", _this);
		});
	});
	function imgShow(outerdiv, innerdiv, bigimg, _this){
		var src = _this.attr("src");//获取当前点击的pimg元素中的src属性
		$(bigimg).attr("src", src);//设置#bigimg元素的src属性
		/*获取当前点击图片的真实大小，并显示弹出层及大图*/
		$("<img/>").attr("src", src).load(function(){
			var windowW = $(window).width();//获取当前窗口宽度
			var windowH = $(window).height();//获取当前窗口高度
			var realWidth = this.width;//获取图片真实宽度
			var realHeight = this.height;//获取图片真实高度
			var imgWidth, imgHeight;
			var scale = 0.8;//缩放尺寸，当图片真实宽度和高度大于窗口宽度和高度时进行缩放
			if(realHeight>windowH*scale) {//判断图片高度
				imgHeight = windowH*scale;//如大于窗口高度，图片高度进行缩放
				imgWidth = imgHeight/realHeight*realWidth;//等比例缩放宽度
				if(imgWidth>windowW*scale) {//如宽度扔大于窗口宽度
					imgWidth = windowW*scale;//再对宽度进行缩放
				}
			} else if(realWidth>windowW*scale) {//如图片高度合适，判断图片宽度
				imgWidth = windowW*scale;//如大于窗口宽度，图片宽度进行缩放
				imgHeight = imgWidth/realWidth*realHeight;//等比例缩放高度
			} else {//如果图片真实高度和宽度都符合要求，高宽不变
				imgWidth = realWidth;
				imgHeight = realHeight;
			}
			$(bigimg).css("width",imgWidth);//以最终的宽度对图片缩放
			var w = (windowW-imgWidth)/2;//计算图片与窗口左边距
			var h = (windowH-imgHeight)/2;//计算图片与窗口上边距
			$(innerdiv).css({"top":h, "left":w});//设置#innerdiv的top和left属性
			$(outerdiv).fadeIn("fast");//淡入显示#outerdiv及.pimg
		});
		$(outerdiv).click(function(){//再次点击淡出消失弹出层
			$(this).fadeOut("fast");
		});
	}
</script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">社会治安</span>--%>
<div class="back-list">
<div class="context" content="${ctx}"></div>
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/event/ccmEventIncident/listMurder">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmEventIncident"
		action="${ctx}/event/ccmEventIncident/listMurder" method="post"
		class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden"
			value="${page.pageSize}" />
		<ul class="ul-form pull-left">
			<li class="first-line"><label>案件名称：</label> <form:input path="caseName"
					htmlEscape="false" maxlength="100" class="input-medium" /></li>
			<%-- <li><label>发案地：</label> <form:input path="casePlace"
					htmlEscape="false" maxlength="6" class="input-medium" /></li> --%>
			<li class="first-line"><label>发案地：</label>
				<sys:treeselect id="area" name="area.id"
					value="${ccmEventIncident.area.id}" labelName="area.name"
					labelValue="${ccmEventIncident.area.name}" title="区域"
					url="/sys/area/treeData" cssClass="" allowClear="true"
					notAllowSelectParent="false" cssStyle="width: 150px" />
			</li>		
			<li class="first-line"><label >发生日期：</label> <input
				name="beginHappenDate" type="text" readonly="readonly"
				maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${ccmEventIncident.beginHappenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" /></li>
			<li class="first-line"><label>结束日期:</label> <input name="endHappenDate" type="text" readonly="readonly"
				maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${ccmEventIncident.endHappenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</li>		
			<li class="first-line"><label>案（事）件级别：</label> <form:select path="eventScale"
					class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_case_grad')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" /></li> -->
			<li class="second-line"><label>案（事）件类型：</label> <form:select path="eventType"
					class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('ccm_case_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select></li>
			<li class="second-line"><label>案（事）件性质：</label>
				<form:select path="property" class="input-medium">
					<form:option value="" label="全部" />
					<form:options items="${fns:getDictList('bph_alarm_info_typecode')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</li>

		</ul>


	<div class="clearfix pull-right btn-box">
		<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
			<i></i><span style="font-size: 12px">查询</span>  </a>
	</div>
	</form:form>
	<sys:message content="${message}" />
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>图片</th>
				<th width="15%">案（事）件名称</th>
				<th>案（事）件编号</th>
				<th>发生日期</th>
				<!-- <th>发案地</th> -->
				<th>案（事）件级别</th>
				<th>案（事）件类型</th>
				<th>案（事）件性质</th>
			    <th width="10%">发案地</th>
			    <th>发生地详址</th>
				<shiro:hasPermission name="event:ccmEventIncident:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="ccmEventIncident">
				<tr>
					<td width="150px">
						<img src="${ccmEventIncident.file1}" style="height:50px;" class="pimg"/>
					</td>
					<td><a href="${ctx}/event/ccmEventIncident/formMurder?id=${ccmEventIncident.id}">
							${ccmEventIncident.caseName} </a></td>
					<td>${ccmEventIncident.number}</td>	
					<td><fmt:formatDate value="${ccmEventIncident.happenDate}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<%-- <td>${ccmEventIncident.casePlace}</td> --%>
					<td>${fns:getDictLabel(ccmEventIncident.eventScale, 'ccm_case_grad', '')}
					</td>
					<td>${fns:getDictLabel(ccmEventIncident.eventType, 'ccm_case_type', '')}
					</td>
					 <td>${fns:getDictLabel(ccmEventIncident.property, 'bph_alarm_info_typecode', '')}</td>	
					 <td>${ccmEventIncident.area.name}</td>	
					 <td class="tp">${ccmEventIncident.happenPlace}</td>	
					<td>
						<!-- 案（事）件登记编辑权限  --> <shiro:hasPermission
							name="event:ccmEventIncident:edit">
							<a  class="btnList" 
								href="${ctx}/event/ccmEventIncident/formMurder?id=${ccmEventIncident.id}" title="修改"><i class="icon-pencil"></i></a>
							<a  class="btnList"
								href="${ctx}/event/ccmEventIncident/deleteMurder?id=${ccmEventIncident.id}"
								onclick="return confirmx('确认要删除该案案（事）件吗？', this.href)" title="删除"><i class="icon-remove-sign"></i></a>
										<a class="btnList" href="javascript:;" onclick="LocationOpen('${ccmEventIncident.id}')"  title="位置信息"><i class="icon-map-marker "></i></a>
					
						</shiro:hasPermission> <!-- 事件处理 编辑权限  --> <shiro:hasPermission
							name="event:ccmEventCasedeal:edit">
						<!--	<a class="btnList" href="${ctx}/event/ccmEventCasedeal/dealformMurder?eventIncidentId=${ccmEventIncident.id}" title="添加处理信息"><i class="icon-plus"></i></a>    -->
							<a class="btnList" onclick="LayerDialogWithReload('${ctx}/event/ccmEventCasedeal/dealformCommon?objType=ccm_event_incident&objId=${ccmEventIncident.id}', '处理', '700px', '500px')" title="添加处理"><i class="icon-plus"></i></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="event:ccmEventStakeholder:view">
							<%-- <a class="btnList" href="${ctx}/event/ccmEventStakeholder/list?incidentId=${ccmEventIncident.id}" title="干系人"><i class="icon-user"></i></a> --%>
							<a class="btnList" onclick="parent.LayerDialog1('','${ctx}/event/ccmEventStakeholder/list?incidentId=${ccmEventIncident.id}', '干系人', '1300px', '700px')"
								 title="干系人"><i class="icon-user"></i></a>
						</shiro:hasPermission>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
		<div id="outerdiv" style="position:fixed;top:0;left:0;background:rgba(0,0,0,0.7);z-index:2;width:100%;height:100%;display:none;">
			<div id="innerdiv" style="position:absolute;">
				<img id="bigimg" style="border:5px solid #fff;" src="" />
			</div>
		</div>
	<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</body>
</html>