<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>流动人口管理</title>
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
		function show(){
			var s = $("#che").prop('checked');
			if(s){
				$(".selectHidden").show();
			}else{
				$(".selectHidden").hide();
			}
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
	<script type="text/javascript"
	      src="${ctxStatic}/ccm/pop/js/ccmPeopleInfo.js">
	</script>
		<script type="text/javascript"
		src="${ctxStatic}/ccm/pop/js/ccmCommon.js"></script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">人口管理</span>--%>
<div class="back-list">
<div class="context" content="${ctx}"></div>
 <!-- 导入、导出模块 -->
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/pop/ccmPermanent/import"
			method="post" enctype="multipart/form-data" class="form-search"
			style="padding-left: 20px; text-align: center;"
			onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file"
				style="width: 330px" /><br /> <br /> <input id="btnImportSubmit"
				class="btn btn-primary" type="submit" value="导  入 " />
		</form>
	</div>
	
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/pop/ccmWork/list/20">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPeople" action="${ctx}/pop/ccmWork/list/20" method="post" class="breadcrumb form-search clearfix">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="isPermanent" name="isPermanent" type="hidden" value="1"/>
		<input id="type" name="type" type="hidden" value="20"/>
		<ul class="ul-form pull-left">
			<li class="first-line"><label>姓名：</label>
				<form:input path="name" htmlEscape="false" maxlength="50" class=""  cssStyle="width:159px"/>
			</li>
			<li class="first-line"><label>公民身份号码：</label>
				<form:input path="ident" htmlEscape="false" maxlength="18" class="input-medium"/>
			</li>
			<li class="first-line"><label>更多</label>
				<input type="checkbox" id="che" onclick="show()">
			</li>

		<li class="clearfix selectHidden hide"></li>
			<li class="clearfix selectHidden hide"></li>

			
			<li class="selectHidden hide"><label>性别：</label>
				<form:select path="sex" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>
			<li class="selectHidden hide"><label style="width: 175px;">是否安置帮教：</label>
				<form:select path="isRelease" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>
			<li class="selectHidden hide"><label style="width: 175px;">是否社区矫正：</label>
				<form:select path="isRectification" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>
			<li class="selectHidden hide"><label style="width: 178px;">肇事肇祸等精神障碍：</label>
				<form:select path="isPsychogeny" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>


			<li class="selectHidden hide"><label style="width: 120px;">是否吸毒：</label>
				<form:select path="isDrugs" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>
			<li class="selectHidden hide"><label>是否艾滋病危险：</label>
				<form:select path="isAids" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>
			
			<li class="selectHidden hide"><label style="width: 175px;">是否留守：</label>
				<form:select path="isBehind" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>
			<li class="selectHidden hide"><label style="width: 175px;">是否重点青少年：</label>
				<form:select path="isKym" class="input-small ">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			    </form:select>
			</li>


			
			<li class="selectHidden hide"><label style="width: 178px;">所属社区：</label>
				<sys:treeselect id="areaComId" name="areaComId.id" value="${ccmPeople.areaComId.id}" 
					labelName="areaComId.name" 	labelValue="${ccmPeople.areaComId.name}"
					title="社区" url="/tree/ccmTree/treeDataArea?type=6" cssClass="input-medium" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li class="selectHidden hide"><label style="width: 60px;">所属网格：</label>
				<sys:treeselect id="areaGridId" name="areaGridId.id" value="${ccmPeople.areaGridId.id}" 
					labelName="areaGridId.name" labelValue="${ccmPeople.areaGridId.name}"
					title="网格" url="/tree/ccmTree/treeDataArea?type=7&areaid=" cssClass="input-medium" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li class="selectHidden hide"><label>出生开始日期：</label>
				<input name="beginBirthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPeople.beginBirthday}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> </li>
			<li class="selectHidden hide"><label style="width: 120px;">出生结束日期：</label>	<input name="endBirthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${ccmPeople.endBirthday}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
		<li class="clearfix selectHidden hide"></li>
	</ul>
		
		


	<div class="clearfix pull-right btn-box">

			<!-- <input id="btnSubmit" class="btn btn-primary"
				type="submit" value="查询" onclick="return page();" /> -->
		
			<shiro:hasPermission
					name="sys:user:edit">
				<!-- <input id="btnExport" class="btn btn-primary" type="button"
				value="导出" />
				<input id="btnImport" class="btn btn-primary" type="button"
				value="导入" /> -->
				<%--<a href="javascript:;" id="btnImport"  style="width: 49px;display:inline-block;float: right;margin-left: 20px;margin-bottom: 20px" class="btn  btn-export ">--%>
				<%--<i ></i> <span style="font-size: 12px">导入</span>--%>
				<%--</a>--%>
				<a href="javascript:;" id="btnExport" class="btn btn-export" style="width: 49px;display:inline-block;float: right;">
					<i></i> <span style="font-size: 12px">导出</span>
				</a>
			</shiro:hasPermission>
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: left;">
				<i></i><span style="font-size: 12px">查询</span>  </a>
	</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-gradient">
		<thead>
			<tr>
				<th>人员图片</th>
				<th>姓名</th>
				<th>人口类型</th>
				<th>性别</th>
				<th>出生日期</th>
				<th>公民身份号码</th>
				<shiro:hasPermission name="pop:ccmWork:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPeople">
			<tr>
				<td width="100px">
					<img src="${ccmPeople.images}" style="height:50px;" class="pimg"/>
				</td>
				<td><a href="${ctx}/pop/ccmWork/form/flow?id=${ccmPeople.id}">
					${ccmPeople.name}</a>
				</td>
				<td>
					${fns:getDictLabel(ccmPeople.type, 'sys_ccm_people', '')}
				</td>
				<td>
					${fns:getDictLabel(ccmPeople.sex, 'sex', '')}
				</td>
				<td>
					<fmt:formatDate value="${ccmPeople.birthday}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${ccmPeople.ident}
				</td>
				<td><shiro:hasPermission name="pop:ccmPermanent:edit">
	    				<a class="btnList"  href="${ctx}/pop/ccmWork/form/flow?id=${ccmPeople.id}"  title="修改"><i class="icon-pencil"></i></a>
						<a class="btnList" href="${ctx}/pop/ccmWork/delete/flow?id=${ccmPeople.id}" onclick="return confirmx('确认要删除该实有人口吗？', this.href)"  title="删除"><i class="icon-remove-sign"></i></a>
				   <a class="btnList"
								href="javascript:;" onclick="LocationOpen('${ccmPeople.id}')"  title="位置信息"><i class="icon-map-marker "></i></a>
					<%-- <a class="btnList" onclick="parent.LayerDialog1('','${ctx}/work/ccmWorkTiming/form', '定时提醒', '700px', '500px')"
						  title="定时提醒"><i class="icon-bell"></i></a> --%>
				    </shiro:hasPermission> 
				    <shiro:hasPermission name="log:ccmLogTail:edit">
				  	<a class="btnList" onclick="parent.LayerDialog('${ctx}/log/ccmLogTail/list?relevance_id=${ccmPeople.id}&relevance_table=ccm_people', '记录信息', '800px', '660px')" 
								  title="记录信息"><i class="icon-print" style="color: cornflowerblue;"></i></a>
				  	<a class="btnList" onclick="parent.LayerDialog('${ctx}/log/ccmLogTail/formProPermanent?relevance_id=${ccmPeople.id}&relevance_table=ccm_people', '添加记录', '800px', '660px')"
								  title="添加记录"><i class="icon-plus"></i></a>
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