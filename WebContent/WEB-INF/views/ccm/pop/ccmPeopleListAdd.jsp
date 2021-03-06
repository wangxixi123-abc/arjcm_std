<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>人员批量添加管理</title>
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
<div class="context" content="${ctx}"></div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/pop/ccmPeople/listPopAdd?houseId=${houseId}">数据列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmPeople" action="${ctx}/pop/ccmPeople/listPopAdd" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="houseId" name="houseId" type="hidden" value="${houseId}"/>
		
		<ul class="ul-form">
			<li><label>姓名：</label>
				<form:input path="name" htmlEscape="false" maxlength="50" class=""  cssStyle="width:107px"/>
			<li/>
			<li><label>公民身份号码：</label>
				<form:input path="ident" htmlEscape="false" maxlength="18" class="input-medium"/>
			<li/>
			<li><label>现住门（楼）详址：</label>
				<form:input path="residencedetail" htmlEscape="false" maxlength="50" class=""  cssStyle="width:300px"/>
			<li/>
			<%-- <li><label>所属社区：</label>
				<sys:treeselect id="areaComId" name="areaComId.id" value="${ccmPeople.areaComId.id}" 
					labelName="areaComId.name" 	labelValue="${ccmPeople.areaComId.name}"
					title="社区" url="/tree/ccmTree/treeDataArea?type=6" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			<li/>
			<li><label>所属网格：</label>
				<sys:treeselect id="areaGridId" name="areaGridId.id" value="${ccmPeople.areaGridId.id}" 
					labelName="areaGridId.name" labelValue="${ccmPeople.areaGridId.name}"
					title="网格" url="/tree/ccmTree/treeDataArea?type=7&areaid=" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			<li/>
			<li><label>出生日期：</label>
				<input name="beginBirthday" type="text" readonly="readonly" maxlength="20" class="input-small Wdate"
					value="<fmt:formatDate value="${ccmPeople.beginBirthday}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
				<input name="endBirthday" type="text" readonly="readonly" maxlength="20" class="input-small Wdate"
					value="<fmt:formatDate value="${ccmPeople.endBirthday}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			<li/> --%>	
	        <li class="btns">
			<!-- 	<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();" /> -->
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary">
                <i class="icon-search"></i> 查询 </a>
			</li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed" style="table-layout: fixed;word-break:break-all;">
		<thead>
			<tr>
				<th>人员图片</th>
				<th>人口类型</th>
				<th>姓名</th>
				<th>性别</th>
				<th>出生日期</th>
				<th>公民身份号码</th>
				<th>所属社区</th>
				<th>所属网格</th>
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
					<td>
						${fns:getDictLabel(ccmPeople.type, 'sys_ccm_people', '')}
					</td>
					<td>
						${ccmPeople.name}
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
					<td>
						${ccmPeople.areaComId.name}
					</td>
					<td>
						${ccmPeople.areaGridId.name}
					</td>
					<td>
						${ccmPeople.residencedetail}
					</td>
					<td>
						<shiro:hasPermission name="pop:ccmPeople:edit">
							<a class="btnList" href="javascript:;"  onclick="PopAdd(this,'${ccmPeople.id}','${houseId}')"  title="添加成员"><i class="icon-plus"></i></a>
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
	<script>
	function PopAdd(_this,popId,houseId){
		var context = $(".context").attr("content");
		$.get(context+"/pop/ccmPeople/savePopAdd?id="+popId+"&houseId="+houseId+"",function(data){
			
		var len=data.length;
			if(len>0){
				var id=data[0]
				top.$.jBox.tip(data[1])
				$(_this).unbind('click');
				$(_this).children('i').css('color',"#ccc");
				$(_this).removeAttr("onclick")
				$(_this).css('cursor','not-allowed')
			}
		})
	}
	</script>
</body>

</html>