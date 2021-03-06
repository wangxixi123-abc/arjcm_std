<%@page import="com.arjjs.ccm.modules.sys.entity.User"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp"%>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<!DOCTYPE html>
<html>
<head>
<title><sitemesh:title default="欢迎光临"/> - ${site.title} - Powered By JeeSite</title>
<%@include file="/WEB-INF/views/modules/cms/front/include/head.jsp" %>
<script src="${ctxStatic}/jquery/jquery-1.9.1.js" type="text/javascript"></script>
<script src="${ctxStatic}/jquery/jquery-1.8.3.min.js"></script>
<script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js"  type="text/javascript"></script>
<link id="Bootstrap" href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css" rel="stylesheet" />
<link rel="stylesheet" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css" />
<script src="${ctxStatic}/layer-v3.1.1/layer/layer.js" type="text/javascript"></script>
<link rel="stylesheet" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css" />
<script type="text/javascript" src="${ctxStatic}/common/jeesite.js"></script>
<script type="text/javascript" src="${ctxStatic}/dist/layui.js"></script>
	<script type="text/javascript" src="${ctxStatic}/dist/layui.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnSubmit").on("click" ,function(){
				$("#searchForm").submit();
			})
            //$.post("/arjccm/a/login",{username:"user1",password:"user1"},function(){});
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		//详情弹框--不刷新父页面
		function LayerDialog(src, title, height, width){
			 layerIndex=parent.layer.open({
			  type: 2,
			  title: title,
			  area: [height, width],
			  fixed: true, //固定
			  maxmin: true,
			  id:'LayerDialog',
			   //btn: [ '确定',  '关闭'], //可以无限个按钮
			  content: src,
			  zIndex:'3'
			});
		}
		function alertInfo(strInfo) {
			top.$.jBox.tip(strInfo);
		}
	</script>
	<%-- <script src="${ctxStatic}/bootstrap/bootstrap3.0/js/bootstrap.js" type="text/javascript"></script> --%>
	<!-- Baidu tongji analytics -->
<!-- 	<script>var _hmt=_hmt||[];(function(){var hm=document.createElement("script");hm.src="//hm.baidu.com/hm.js?82116c626a8d504a5c0675073362ef6f";var s=document.getElementsByTagName("script")[0];s.parentNode.insertBefore(hm,s);})();</script>
 -->
 <sitemesh:head/>
</head>
<body>
<div class="header">
		<div id="messageBox" class="alert alert-error ${empty message ? 'hide' : ''}"><button data-dismiss="alert" class="close">×</button>
			<label id="loginError" class="error">${message}</label>
		</div>
	</div>
	<div class="navbar navbar-fixed-top" style="position:static;margin-bottom:10px;">
      <div class="navbar-inner">
        <div class="container">
          <c:choose>
   			<c:when test="${not empty site.logo}">
   				<img alt="${site.title}" src="${site.logo}" class="container" onclick="location='${ctx}/index-${site.id}${fns:getUrlSuffix()}'">
   			</c:when>
   			<c:otherwise><a class="brand" style="padding-top: 20px;" href="${ctx}/index-${site.id}${fns:getUrlSuffix()}">${site.title}</a></c:otherwise>
   		  </c:choose>
          <div class="nav-collapse">
            <ul id="main_nav" class="nav nav-pills">
             	<li class="${not empty isIndex && isIndex ? 'active' : ''}"><a href="${ctx}/index-1${fns:getUrlSuffix()}"><span>${site.id eq '1'?'首　 页':'返回主站'}</span></a></li>
				<c:forEach items="${fnc:getMainNavList(site.id)}" var="category" varStatus="status"><c:if test="${status.index lt 6}">
                    <c:set var="menuCategoryId" value=",${category.id},"/>
		    		<li class="${requestScope.category.id eq category.id||fn:indexOf(requestScope.category.parentIds,menuCategoryId) ge 1?'active':''}"><a href="${category.url}" target="${category.target}"><span>${category.name}</span></a></li>
		    	</c:if></c:forEach>
			    <%-- <li id="siteSwitch" class="dropdown">
			       	<a class="dropdown-toggle" data-toggle="dropdown" href="#" title="站点"><i class="icon-retweet"></i></a>
					<ul class="dropdown-menu">
					  <c:forEach items="${fnc:getSiteList()}" var="site"><li><a href="#" onclick="location='${ctx}/index-${site.id}${urlSuffix}'">${site.title}</a></li></c:forEach>
					</ul>
				</li> --%>
		    	<li id="themeSwitch" class="dropdown">
			       	<a class="dropdown-toggle" data-toggle="dropdown" href="#" title="主题切换"><i class="icon-th-large"></i></a>
				    <ul class="dropdown-menu">
				      <c:forEach items="${fns:getDictList('theme')}" var="dict"><li><a href="#" onclick="location='${pageContext.request.contextPath}/theme/${dict.value}?url='+location.href">${dict.label}</a></li></c:forEach>
				    </ul>
				    <!--[if lte IE 6]><script type="text/javascript">$('#themeSwitch').hide();</script><![endif]-->
			    </li>
			    <c:if test="${ccmFontUser.name == null}">
			    	<!-- <li  class="dropdown">
			    	<button id="bt1" type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#myModal">注册</button>
				    </li> -->
				     <li  class="dropdown">
				    	<a id="bt2"  style="cursor:pointer;" data-toggle="modal" data-target="#myModal1">请登录</a>
				    </li>
			    </c:if>
			    <c:if test="${ccmFontUser.name != null}">
				    	<li>
							<select style="width: 66px;margin-top: 10px;">
								<c:forEach items="${fns:getDictList('login_type')}" var="dict">
									<option><a href="javascript:void(0)"  data-val="${dict}">${dict.label}</a></option>
								</c:forEach>
							</select>
						</li>
						<li class="dropdown">
							<%--<c:forEach items="${fns:getDictList('login_type')}" var="dict"><li><a href="javascript:void(0)" onclick="changevalue(this)" data-val="${dict}">${dict.label}</a></li></c:forEach>--%>
							<a id="a1" class="dropdown-toggle" data-toggle="dropdown" href="#" title="站点">
									${ccmFontUser.name}，您好！
							</a>
							<ul class="dropdown-menu">
								<li>
								<a onclick="LayerDialog('${ctx}/Fx?id=${ccmFontUser.id}&updateStatus=0', '个人信息', '700px', '750px')"><i class="icon-user"></i>&nbsp;个人信息</a>
								</li>
								<li>
								<a onclick="LayerDialog('${ctx}/Ex', '共享信息', '900px', '700px')"><i class="icon-share"></i>&nbsp;共享信息</a>
								</li>
								<li>
								<a onclick="LayerDialog('${ctx}/Fx?id=${ccmFontUser.id}&updateStatus=1', '个人信息', '700px', '300px')"><i class="icon-lock"></i>&nbsp;修改密码</a>
								</li>
								<li><a href="#" id=exit><i class="icon-off"></i>&nbsp;注销 <span id="notifyNum2" class="label label-info hide"></span></a></li>
							</ul>
						</li>
				    </li>
			    </c:if>
            </ul>
           <%--  <form class="navbar-form pull-right" action="${ctx}/search" method="get">
              	<input type="text" name="q" maxlength="20" style="width:65px;" placeholder="全站搜索..." value="${q}">
            </form> --%>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
	<div class="container">
		<div class="content">
			<sitemesh:body/>
		</div>
		<hr style="margin:20px 0 10px;">
		<footer>
			<div class="footer_nav"><a href="${ctx}/guestbook" target="_blank">公共留言</a> <%-- | <a href="${ctx}/search" target="_blank">全站搜索</a> --%> | <a href="${ctx}/map-${site.id}${fns:getUrlSuffix()}" target="_blank">站点地图</a> | <a href="mailto:thinkgem@163.com">技术支持</a> | <a href="${pageContext.request.contextPath}${fns:getAdminPath()}" target="_blank">后台管理</a><div class="pull-right">${fns:getDate('yyyy年MM月dd日 E')}</div></div>
			<%-- <div class="copyright">${site.copyright}</div> --%>
      	</footer>
    </div> <!-- /container -->
    <!-- --------------------------------------------------------新加代码------------------------------------------------------------------- -->
		<!-- 模态框 -->
	<!-- <div style="margin-top: 100px; display: none;" class="modal fade" id="myModal" tabindex="-1" role="dialog" -->
	<div style="width: 1000px; height: 600px; display: none;"
		class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<div style="font-weight: 900;" class="modal-title"
						id="myModalLabel">居民注册</div>
				</div>
				<div class="modal-body">

					<table class="table table-bordered">
						<tr>
							<td>登录名&nbsp; &nbsp; <input id="td3" type="text"
								maxlength="100" onkeyup="loginNameKeyup()">&nbsp; &nbsp;<font color="red">*</font>
								<div id="loginName" style="color:red;"></div>
							</td>
							<td rowspan="3">
								<label class="control-label">头&nbsp; &nbsp;像:</label>
								<div class="control-group">
									<div class="controls">
										<input type="hidden" id="nameImage" path="photo"
											htmlEscape="false" maxlength="255" class="input-xlarge" />
										<sys:ckfinder input="nameImage" type="images"
											uploadPath="/photo" selectMultiple="false" maxWidth="100"
											maxHeight="100" />
									</div>
								</div> 
							</td>
						</tr>

						<tr>
							<td>密&nbsp; &nbsp;码&nbsp; &nbsp; <input id="td4" type="password"
								maxlength="50" minlength="3">&nbsp;&nbsp;<font color="red">*</font>
							</td>
						</tr>
						<tr>
							<td>确认密码&nbsp; &nbsp;<input id="td6" type="password"
								maxlength="50" minlength="3">
							</td>
						</tr>
						<tr>
							<td>姓&nbsp; &nbsp;名&nbsp; &nbsp;<input id="td7" type="text"
								maxlength="100"><font color="red">*</font>
								<div class="layui-form">
									<!-- <label class="layui-form-label"></label>  -->
									<div class="layui-input-block">
										<input type="checkbox" name="checkName" id="checkName" title="可见" checked value="0">
									</div>
								</div>
							</td>
							<td>手&nbsp; &nbsp;机&nbsp; &nbsp;&nbsp; &nbsp;<input
								id="td10" type="text" maxlength="200" onkeyup="mobileKeyup()">&nbsp; &nbsp;
								<font color="red">*</font>
								<div class="layui-form">
									<div class="layui-input-block">
										<input type="checkbox" name="checkMobile" id="checkMobile" title="可见" checked value="0">
									</div>
								</div>
								<div id="mobile" style="color:red;"></div>
							</td>
						</tr>
						<tr>
							<td>
								身份证号&nbsp; &nbsp; 
								<input id="td8" type="text" maxlength="100" onkeyup="idCardKeyup()">&nbsp;&nbsp; 
								<font color="red">*</font>
								<div class="layui-form">
									<div class="layui-input-block">
										<input type="checkbox" name="checkNo" id="checkNo" title="可见" checked value="0">
									</div>
								</div>
								<div id="idCard" style="color:red;"></div>
							</td>
							<td>邮&nbsp; &nbsp;箱&nbsp; &nbsp;<input id="td9" type="text"
								maxlength="200" onkeyup="emailKeyup()">&nbsp; &nbsp;<font color="red">*</font>
								<div class="layui-form">
									<div class="layui-input-block">
										<input type="checkbox" name="checkEmail" id="checkEmail" title="可见" checked value="0">
									</div>
								</div>
								<div id="email" style="color:red;"></div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="control-group">
									<label class="control-label">归属区域:</label>
									<div class="controls">
										<sys:treeselectWebsite id="areaCom" name="areaCom" value=""
											labelName="areaComname" labelValue="" title="区域"
											url="/tag/treeData?type=3" cssClass=""/>
										<span class="help-inline"><font color="red" id="show1">*</font></span>
									</div>
								</div>
							</td>
							<td>电&nbsp; &nbsp;话&nbsp; &nbsp;&nbsp; &nbsp;<input
								id="phone" type="text" maxlength="200" onkeyup="phoneKeyup()">&nbsp; &nbsp;
								<div id="phoneDiv" style="color:red;"></div>
							</td>
						</tr>
					</table>
				</div>
				<div class="modal-footer">
					<button onclick="save()" type="button" class="btn btn-primary">注册</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 模态框 -->

		<!-- 模态框 -->
		<div  style="margin-top: 100px; display: none;" class="modal fade" id="myModal1" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<div style="font-weight: 900;" class="modal-title" id="myModalLabel">居民登录</div>
					</div>
					<div class="modal-body">
						<table class="table table-bordered">
							<tr>
								<td>登录名</td>
								<td><input id="td13"  type="text" style="border: none" class="required">&nbsp; &nbsp;<font color="red">*</font></td>
							</tr>
							<tr>
								<td>密码</td>
								<td><input id="td14" type="password" style="border: none" class="required">&nbsp;&nbsp;<font color="red">*</font>
								</td>
							</tr>
						</table>
						<a id="bt1"   data-toggle="modal" data-dismiss="modal" data-target="#myModal" style="cursor:pointer;">请点击注册</a>
						<font color="red"><span id="errer" style="display: none;">用户名或密码错误</span></font>
					</div>
					<div class="modal-footer">
						<button onclick="login()" type="button" class="btn btn-primary">登录</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
	<script type="text/javascript">
	    $(function() {
	    	$("#exit").on('click', function() {
	    		location.href='/arjccm/f/exit'
			})
		})
		function login(){
			var loginName=$("#td13").val();
			var password=$("#td14").val();  //密码
			$.post('/arjccm/f/loginUserDetail',{'loginName':loginName,'password':password},function(data){
				//alert(data.name);
				if(data == "200"){
					history.go(0)
					$("#errer").hide();
				}else if (data == "notLoginFlag") {
					$("#errer").show();
					$("#errer").html("请等待管理员进行审核");
				} else{
					$("#errer").show();
					$("#errer").html("用户名或密码错误");
				}
			})
		}
	    function loginNameKeyup(){
	    	var loginName = $("#td3").val(); //登录名
	    	if(loginName == null || loginName == ''){
	    		$("#loginName").html("抱歉，用户名不能为空，请重新输入！");
	    		return false;
	    	}else{	    		
	    		var tel = /^[a-zA-Z0-9][a-zA-Z0-9_]{2,19}$/;
		    	if(tel.test(loginName)){
		    		$("#loginName").html("");
		    		return true;
		    	}else{
		    		$("#loginName").html("3-20位字母或数字开头，允许字母数字下划线");
		    		return false;
		    	}
	    	}
	    }
	    function idCardKeyup(){
	    	var no = $("#td8").val(); //身份证号
	    	if(no == null || no == ''){
	    		$("#idCard").html("抱歉，身份证号不能为空，请重新输入！");
	    		return false;
	    	}else{	    		
	    		var tel=/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/;
		    	if(tel.test(no)){
		    		$("#idCard").html("");
		    		return true;
		    	}else{
		    		$("#idCard").html("请输入正确的身份证号码");
		    		return false;
		    	}
	    	}
	    }
	    function emailKeyup(){
	    	var email = $("#td9").val(); //邮箱
	    	if(email == null || email == ''){
	    		$("#email").html("抱歉，邮箱不能为空，请重新输入！");
	    		return false;
	    	}else{	    		
		    	var tel = /(^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$)/g;
		    	if(tel.test(email)){
		    		$("#email").html("");
		    		return true;
		    	}else{
		    		$("#email").html("请输入正确格式的电子邮件");
		    		return false;
		    	}
	    	}
	    }
	    function phoneKeyup(){
	    	var phone = $("#phone").val(); //电话
	    	if(phone == null || phone == ''){
	    		//$("#phoneDiv").html("抱歉，电话号不能为空，请重新输入！");
	    		return true;
	    	}else{	    		
	    		var tel = /^(\d{3,4}-?)?\d{7,9}$/g;
		    	if(tel.test(phone)){
		    		$("#phoneDiv").html("");
		    		return true;
		    	}else{
		    		$("#phoneDiv").html("请正确填写您的电话号码");
		    		return false;
		    	}
	    	}
	    }
	    function mobileKeyup(){
	    	var mobile = $("#td10").val(); //手机
	    	if(mobile == null || mobile == ''){
	    		$("#mobile").html("抱歉，手机号不能为空，请重新输入！");
	    		return false;
	    	}else{	    		
		    	var tel = /(^0[1-9]{1}\d{9,10}$)|(^1[3,4,5,6,7,8,9]\d{9}$)/g;
		    	if(tel.test(mobile)){
		    		$("#mobile").html("");
		    		return true;
		    	}else{
		    		$("#mobile").html("固话为:区号(3-4位)号码(7-9位),手机为:13,14,15,16,17,18,19号段");
		    		return false;
		    	}
	    	}
	    }
	    function save() {
			var loginName = $("#td3").val(); //登录名
			if(!loginNameKeyup()){
				$("#td3").select();
				return;
			}
			var password = $("#td4").val(); //密码
			if (password == null || password == '') {
				alert("抱歉，密码不能为空，请重新输入！");
				$("#td4").select();
				return;
			}
			if(password.length < 3 || password.length > 50){
				alert("抱歉，密码长度不符，请重新输入！");
				$("#td4").select();
				return;
			}
			var secondPwd = $("#td6").val(); //确认密码
			if (secondPwd == null || secondPwd == '') {
				alert("抱歉，确认密码不能为空，请重新输入！");
				$("#td6").select();
				return;
			}
			if (password != secondPwd) {
				alert("两次输入密码不一致，请重新输入！");
				return;
			}
			var nameImage = $("#nameImage").val(); //头像
			var areaId = $('input[name="areaCom"]').val(); //所属区域
			if (areaId == null || areaId == '') {
				alert("抱歉，所属区域不能为空，请重新输入！");
				return;
			}
			var name = $("#td7").val(); //姓名
			if (name == null || name == '') {
				alert("抱歉，姓名不能为空，请重新输入！");
				$("#td7").select();
				return;
			}
			var no = $("#td8").val(); //身份证号
			if(!idCardKeyup()){
				$("#td8").select();
				return;
			}
			var email = $("#td9").val(); //邮箱
			if(!emailKeyup()){
				$("#td9").select();
				return;
			}
			var mobile = $("#td10").val(); //手机
			if(!mobileKeyup()){
				$("#td10").select();
				return;
			}
			var phone = $("#phone").val(); //电话
			if(!phoneKeyup()){
				$("#phone").select();
				return;
			}
			var loginFlag = '03'; //是否允许登录，默认为否

			if($('#checkName').is(':checked')) {
				var isNameVisable = $("#checkName").val();
			} else{
				var isNameVisable = 1;
			}

			if($('#checkNo').is(':checked')) {
				var isNoVisable= $("#checkNo").val();
			} else{
				var isNoVisable = 1;
			}

			if($('#checkEmail').is(':checked')) {
				var isEmailVisable= $("#checkEmail").val();
			} else{
				var isEmailVisable = 1;
			}

			if($('#checkMobile').is(':checked')) {
				var isMobileVisable= $("#checkMobile").val();
			} else{
				var isMobileVisable = 1;
			}
			$.post( '/arjccm/f/RegisterUser',
				{
					'loginName' : loginName,
					'password' : password,
					'photo' : nameImage,
					'areaComId.id' : areaId,
					'name' : name,
					'no' : no,
					'email' : email,
					'mobile' : mobile,
					'phone' : phone,
					'loginFlag' : loginFlag,
					'isNameVisable' : isNameVisable,
					'isNoVisable' : isNoVisable,
					'isEmailVisable' : isEmailVisable,
					'isMobileVisable' : isMobileVisable
				},
				function(data) {
					if (data == "200") {
						alert('恭喜您，注册成功，请等待管理员进行审核！');
						$("#myModal").css("display","none");
						top.location = "${ctx}";
					} else if (data == "cycloginname") {
						alert('用户名已存在，请重新输入！');
					} else {
						alert('注册失败，请重新注册！');
					}
				})
		}
	</script>


</body>
</html>