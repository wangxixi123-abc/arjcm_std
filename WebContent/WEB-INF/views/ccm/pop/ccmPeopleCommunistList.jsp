<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>党员人口管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				$("#searchForm").submit();
			})
		});
		$(function() {
			$("#btnExport").click(
					function() {
						
						top.$.jBox.confirm("确认要导出数据吗？", "系统提示", function(v, h, f) {
							if (v == "ok") {
								$("#searchForm").attr("action",
										ctx + "/pop/ccmPeople/exportCommunist");
								$("#searchForm").submit();
								// 还原查询action 
								$("#searchForm").attr("action",
										ctx + "/pop/ccmPeople/listCommunist");
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
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
			return false;
		}
		function show(){
			var s = $("#che").prop('checked');
			if(s){
				$("#show").css("display","block");
			}else{
				$("#show").css("display","none");
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
		src="${ctxStatic}/ccm/pop/js/ccmCommon.js"></script>
	<style type="text/css">
		#show{display: none;}
		
	</style>
</head>
<body>
<div class="context" content="${ctx}"></div>
 <!-- 导入、导出模块 -->
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/pop/ccmPeople/import"
			method="post" enctype="multipart/form-data" class="form-search"
			style="padding-left: 20px; text-align: center;"
			onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file"
				style="width: 330px" /><br /> <br /> <input id="btnImportSubmit"
				class="btn btn-primary" type="submit" value="导  入 " />
		</form>
	</div>
	
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/report/ccmPeopleStat/statisticsPage?title=ccmPeopleStatCommunist">数据统计</a></li>
		<li class="active"><a href="${ctx}/pop/ccmPeople/listCommunist">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPeople" action="${ctx}/pop/ccmPeople/listCommunist" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
		
		
			<li><label>所属社区：</label>
				<sys:treeselect id="areaComId" name="areaComId.id" value="${ccmPeople.areaComId.id}" labelName="areaComId.name" labelValue="${ccmPeople.areaComId.name}"
					title="社区" url="/tree/ccmTree/treeDataArea?type=6" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>	
			<li><label>姓名：</label>
				<form:input path="name" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<li><label>公民身份号码：</label>
				<form:input path="ident" htmlEscape="false" maxlength="18" class="input-medium"/>
			</li>
			<li><label>是否常住：</label>
				<form:select path="isPermanent" class="input-small">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			<li/>
			<li class="btns">
				<shiro:hasPermission name="pop:ccmPeople:edit">
					<!-- <input id="btnExport" class="btn btn-primary" type="button" value="导出" /> -->
					<a href="javascript:;" id="btnExport" class="btn btn-export"> 
						<i class=" icon-reply"></i> 导出
					</a>
			    </shiro:hasPermission> 
			    <!-- <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();" /> -->
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
				<th>人员图片</th>
				<th>姓名</th>
				<th>性别</th>
				<th>党员类型</th>
				<th>出生日期</th>
				<th>公民身份号码</th>
				<th>是否常住</th>
				<th>所属社区</th>
				<th>现住门（楼）详址</th>
				<shiro:hasPermission name="pop:ccmPeople:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="ccmPeople">
			<tr>
				<td width="100px">
					<img src="${ccmPeople.images}" style="height:50px;" class="pimg"/>
				</td>
				<td class="tc"><a href="${ctx}/pop/ccmPeople/formCommunist?id=${ccmPeople.id}">
					${ccmPeople.name}</a>
				</td>
				<td class="tc">
					${fns:getDictLabel(ccmPeople.sex, 'sex', '')}
				</td>
				<td class="tc">
					${fns:getDictLabel(ccmPeople.politics, 'sys_ccm_poli_stat', '')}
				</td>
				<td class="tc">
					<fmt:formatDate value="${ccmPeople.birthday}" pattern="yyyy-MM-dd"/>
				</td>
				<td class="tc">
					${ccmPeople.ident}
				</td>
				<td class="tc">
					${fns:getDictLabel(ccmPeople.isPermanent, 'yes_no', '')}
				</td>
				<td class="tc">
					${ccmPeople.areaComId.name}
				</td>
				<td class="tp">
					${ccmPeople.residencedetail}
				</td>
				<td class="tc"><shiro:hasPermission name="pop:ccmPeople:edit">
	    				<a class="btnList"  href="${ctx}/pop/ccmPeople/formCommunist?id=${ccmPeople.id}"  title="修改"><i class="icon-pencil"></i></a>
						<a class="btnList" href="${ctx}/pop/ccmPeople/deleteCommunist?id=${ccmPeople.id}" onclick="return confirmx('确认要删除该实有人口吗？', this.href)"  title="删除"><i class="icon-remove-sign"></i></a>
				  		<a class="btnList"
								href="javascript:;" onclick="LocationOpen('${ccmPeople.id}')"  title="位置信息"><i class="icon-map-marker "></i></a>
						<a class="btnList" onclick="parent.LayerDialog('${ctx}/pop/ccmPeople/getSocialConnections?id=${ccmPeople.id}', '社交关系', '1000px', '700px')"
							  title="社交关系"><i class="icon-group"></i></a>
						<%-- <a class="btnList" onclick="parent.LayerDialog1('','${ctx}/work/ccmWorkTiming/form', '定时提醒', '700px', '500px')"
								  title="定时提醒"><i class="icon-bell"></i></a> --%>
				    </shiro:hasPermission> 
				    <shiro:hasPermission name="log:ccmLogTail:edit">
				  	<a class="btnList" onclick="parent.LayerDialog('${ctx}/log/ccmLogTail/list?relevance_id=${ccmPeople.id}&relevance_table=ccm_people', '记录信息', '800px', '660px')" 
								  title="记录信息"><i class="icon-print" style="color: cornflowerblue;"></i></a>
				  	<a class="btnList" onclick="parent.LayerDialog('${ctx}/log/ccmLogTail/formProCommunist?relevance_id=${ccmPeople.id}&relevance_table=ccm_people', '添加记录', '800px', '660px')"
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
	<div class="pagination">${page}</div>
</body>
</html>