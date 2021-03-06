<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>视频监控</title>
	
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="stylesheet" href="${ctxStatic}/ccm/liveVideo/css/livedemo.css">
    <link rel="stylesheet" href="${ctxStatic}/ccm/liveVideo/css/video-js.css">
    <link rel="stylesheet" href="${ctxStatic}/ccm/liveVideo/css/bootstrap.min.css">
    <link rel="stylesheet" href="${ctxStatic}/ccm/liveVideo/css/bootstrap-select.min.css">
	
    <script src="${ctxStatic}/ccm/liveVideo/js/jquery.min.js"></script>
    <%--<script src="${ctxStatic}/ccm/liveVideo/js/video.min.js"></script>
    <script src="${ctxStatic}/ccm/liveVideo/js/videojs5.flvjs.js"></script>
    <script src="${ctxStatic}/ccm/liveVideo/js/videojs-contrib-hls.js"></script>
    <script src="${ctxStatic}/ccm/liveVideo/js/videojs-ie8.min.js"></script>
    <script src="${ctxStatic}/ccm/liveVideo/js/livedemoDevice.js"></script> --%>
	<script src="${ctxStatic}/jquery/jquery.cookie.js" type="text/javascript"></script>
    <%--<script type="text/javascript">videojs.options.flash.swf = "${ctxStatic}/ccm/liveVideo/js/video-js.swf";</script>
	<script src="${ctxStatic}/Hk.WEB-SDK/CN_WEB3.0_Win32/demo/codebase/webVideoCtrl.js"></script> --%>
	<link rel="stylesheet" href="${ctxStatic}/Hk.WEB-SDK/ocx/ocx.css">
	<%--<script src="${ctxStatic}/Hk.WEB-SDK/ocx/ocx.js"></script> --%>
	<script src="${ctxStatic}/ccm/liveVideo/js/bootstrap.min.js"></script> 
	<script src="${ctxStatic}/ccm/liveVideo/js/bootstrap-select.min.js"></script> 
	<script>
		ctx="${ctx}";
		ctxStatic="${ctxStatic}";
	</script>
	<script type="text/javascript">
		window.onload = windowHeight;  //页面载入完毕执行函数
		function windowHeight(){
			var h = document.documentElement.clientHeight;   //获取当前窗口可视化操作区域高度
			var w = document.documentElement.clientWidth;   //获取当前窗口可视化操作区域宽度
			var divPlugin=document.getElementById("divPlugin");  //获取ID为divPlugin的对象
			var h1 = h - 142 ; //视频窗口可视化操作区域
			if(w>h1){
				divPlugin.style.height = (h1) + "px";  //你想要自适应高度的对象
				divPlugin.style.width = (h1* 16 / 9) + "px";  //你想要自适应宽度的对象
			}
			if(w<h1){
				divPlugin.style.height = (9 * w / 16 - 55) + "px";  //你想要自适应高度的对象
			}
		}
		setInterval(windowHeight, 300);  //每0.3秒执行一次windowHeight函数
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="ccmDevice" action="" method="post" class="form-horizontal">
		<br>
		<div id="divPlugin" style="width:100%;height:640px;background:#4C4B4B">
			<c:if test="${ccmDevice.typeVidicon == 2}">
				 <OBJECT classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" id="vlc" width="1030" height="640" id="vlc" events="True">
					<param name='mrl' value='${ccmDevice.param}' />
					<param name='volume' value='50' />
					<param name='autoplay' value='true' />
					<param name="toolbar" value="true" />
					<param name='loop' value='true' />
					<param name='fullscreen' value='false' />
			    </OBJECT>  
			</c:if>
			<c:if test="${ccmDevice.typeVidicon == 1}">
				<iframe name="ccmLiveVideo" id="ccmLiveVideoTest" src="${ctx}/ccmsys/ccmDevice/getDeviceMap?id=${ccmDevice.id}" style="overflow: visible;" scrolling="yes" frameborder="no" width="1030" height="640" allowfullscreen="true" allowtransparency="true"></iframe>
				<!-- <div class="form" style="display: none">
			        <label for="PalyType">PalyType:</label>
			        <br />
			        <input type="text" class="PalyType text" value="PlayReal" />
			        <br />
			        <label for="SvrIp">SvrIp:</label>
			        <br />
			        <input type="text" class="SvrIp text" value="" />
			        <br />
			        <label for="SvrPort">SvrPort:</label>
			        <br />
			        <input type="text" class="SvrPort text" value="443" />
			        <br />
			        <label for="appkey">appkey:</label>
			        <br />
			        <input type="text" class="appkey text" value="" />
			        <br />
			        <label for="appSecret">appSecret:</label>
			        <br />
			        <input type="text" class="appSecret text" />
			        <br />
			        <label for="time">time:</label>
			        <br />
			        <input type="text" class="time text" />
			        <br />
			        <label for="timeSecret">timeSecret:</label>
			        <br />
			        <input type="text" class="timeSecret text" />
			        <br />
			        <label for="httpsflag">httpsflag:</label>
			        <br />
			        <input type="text" class="httpsflag text" value="1" />
			        <br />
			        <label for="CamList">CamList:</label>
			        <br />
			        <input type="text" class="CamList text" value="" />
			        <br />
			        <input type="submit" class="playBtn" value="视频预览播放" />
			    </div>
				<div class="video-position" style="width:1030px; height:640px">
			        <p class="pop" style="display:block">加载中</p>
			        <input type="hidden" name="config" id="config" value="ReqType:PlayReal;wndcount:1" />
			        添加预览控件（需要先在windows下注册）
			        <object classid="CLSID:7E393848-7238-4CE3-82EE-44AF444B240A" id="PlayViewOCX" wmode="opaque" width="0" height="0" name="PlayViewOCX">
			        </object>
		        </div> -->
			</c:if>
			<c:if test="${ccmDevice.typeVidicon == 4}">
				<iframe name="ccmLiveVideo" id="ccmLiveVideoTest"  src="${ctx}/ccmsys/ccmDevice/getDeviceMap?id=${ccmDevice.id}" style="overflow: visible;" scrolling="yes" frameborder="no" width="1030" height="590" allowfullscreen="true" allowtransparency="true"></iframe>
			</c:if>
				<iframe name="ccmLiveVideo" id="ccmLiveVideoTest"  src="${ctx}/ccmsys/ccmDevice/getDeviceMap?id=${ccmDevice.id}" style="overflow: visible;" scrolling="yes" frameborder="no" width="1030" height="590" allowfullscreen="true" allowtransparency="true"></iframe>
		</div>
       	<div class="divStatusBar">
        </div>
		<br>
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<ul class="ul-form">
			<li style="float: left;">
				<label class="video-label" style="color: ${cookie.theme.value eq 'gradient' ? '#333' : '#fff'}">设备编号：</label>
				<form:input path="code" htmlEscape="false" maxlength="64" class="input-xlarge"/>&nbsp;&nbsp;&nbsp;&nbsp;
			</li>
			<li style="float: left;">
				<label class="video-label" style="color: ${cookie.theme.value eq 'gradient' ? '#333' : '#fff'}">设备名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="input-xlarge"/>&nbsp;&nbsp;&nbsp;&nbsp;
			</li>
			<li>
				<label class="video-label" style="color: ${cookie.theme.value eq 'gradient' ? '#333' : '#fff'}">网络地址：</label>
				<form:input path="ip" htmlEscape="false" maxlength="15" class="input-xlarge"/>
			</li>
			<%-- <li><label class="video-label">设备状态：</label>
				<form:select path="status" class="input-xlarge">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('ccm_device_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li> --%>
			<br>
			<li>
				<div >
					<div style="float:left;">
						<label class="video-label" style="color: ${cookie.theme.value eq 'gradient' ? '#333' : '#fff'};margin-right: 30px;">视频巡检：</label>
						<select class="selectpicker"  data-width="fit"  title="请选择" multiple="multiple" id="option">
						</select>
					</div>
					<div style="float: left" >
						<input id="btn" class="btn btn-primary" onclick="startOcx()"  type="button"   value="开始" />
						<input class="btn btn-primary" onclick="tostop()"  type="button"   value="结束" />
					</div>
				</div>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		var ccmDeviceProtocol = "${ccmDevice.protocol}";
		var ccmDeviceParaml = '${ccmDevice.param}';
		var ccmDeviceTypeVidicon='${ccmDevice.typeVidicon}'
		var ccmDeviceIp="${ccmDevice.ip}"//ip
		var ccmDevicePort="${ccmDevice.port}"//端口
		var ccmDeviceAccount="${ccmDevice.account}"//用户名
		var ccmDevicePassword="${ccmDevice.password}"//密码
		var CamList="${ccmDevice.code}"//编码
		//init(ccmDeviceProtocol,ccmDeviceParaml,ccmDeviceTypeVidicon,ccmDeviceIp,ccmDevicePort,ccmDeviceAccount,ccmDevicePassword,CamList);
		initselect();
	});
	function initselect(){
		var maplist = ${mapList};
		var str = '';
	 	for(var i=0;i<maplist.length;i++){
	 	   str += '<option value="'+ maplist[i].id +'">'+ maplist[i].name +'</option>'
		}
	 	$('#option').html(str);
	}
	var num = 0;
	var obj;
	var flag;
	function start(){
		var val = $('#option').val();
		var data = new Array();
		for(var i=0;i<val.length;i++){
			data.push({"id":val[i]});
		}	
		 $.ajax({
			url :  "${ctx}/ccmsys/ccmLiveVideo/getvedioPlay",
			type : "post",
			cache : false,
			data : {'param':JSON.stringify(data)},
			dataType : "text",
			success : function(result) {
				$("#btn").attr("disabled", false);
			    obj = JSON.parse(result);
			    flag = setInterval(getstart, 20000);
			},
			error : function() {
			}
		});
	}
	function getstart(){
		var ccmDeviceProtocol = obj[num].protocol;
		var ccmDeviceParaml = obj[num].param;
		var ccmDeviceTypeVidicon = obj[num].typeVidicon;
		var ccmDeviceIp = obj[num].ip;
		var ccmDevicePort = obj[num].port;
		var ccmDeviceAccount = obj[num].account;
		var ccmDevicePassword = obj[num].password;
		var CamList = obj[num].code;
		init(ccmDeviceProtocol,ccmDeviceParaml,ccmDeviceTypeVidicon,ccmDeviceIp,ccmDevicePort,ccmDeviceAccount,ccmDevicePassword,CamList);  
		num++;
		if(num == obj.length){
			num=0;
		}
	}
	function tostop(){
		clearInterval(flag);
	}
	function startOcx(){
		var val = $('#option').val();
		var data = new Array();
		for(var i=0;i<val.length;i++){
			data.push({"id":val[i]});
		}
		obj = data;
		flag = setInterval(getstartOcx, 20000);
	}
	function getstartOcx(){
		initOcx(obj[num].id);
		num++;
		if(num == obj.length){
			num=0;
		}
	}
	function initOcx(id){
		$('#ccmLiveVideoTest').attr("src","${ctx}/ccmsys/ccmDevice/getDeviceMap?id=" + id);
	}
	function init(ccmDeviceProtocol,ccmDeviceParaml,ccmDeviceTypeVidicon,ccmDeviceIp,ccmDevicePort,ccmDeviceAccount,ccmDevicePassword,CamList){
		var theme=$.cookie('theme');
		var scolorb="#4C4B4B"
		if(theme=="black"){
			scolorb="#fff"
		}
		$('.video-label').css("color",scolorb);
		if(ccmDeviceTypeVidicon==2){
		/*  var  mainOcxHtml = '	<video id="videoElement" class="video-js vjs-default-skin vjs-big-play-centered" controlspreload="auto" width="1140" height="640"> </video>';
		    document.getElementById('divPlugin').innerHTML = mainOcxHtml;
			LivePlayerInit();//初始化
			videoPlay(ccmDeviceProtocol, ccmDeviceParaml) */
		}else if(ccmDeviceTypeVidicon==1){
			//*****************海康视频OCX播放方式**************//
			//延迟初始化
		    $(document).ready(function () {
		        setTimeout(function () {
					initOcx();
		        }, 50); //这里设置延迟是为了正确加载OCX(取决于电脑性能,具体数值请根据实际情况设定,通常不需要修改 直接调用init()是可行的)
		        setTimeout(function () {
		            $('#PlayViewOCX').css({
		                'width': '100%',
		                'height': '100%'
		            });
		            $('.pop').hide();
					$.getJSON('/arjccm/app/rest/video/callApiGetSecurity',function(data){
						var appKey=data.result.appKey;
						var SvrIp=data.result.svrIp;
						var SvrPort=data.result.svrPort;
						var appKeyEncrypt=JSON.parse(data.result.appKeyEncrypt);
						var appSecret=appKeyEncrypt.data.appSecret;
						var time=appKeyEncrypt.data.time;
						var timeSecret=appKeyEncrypt.data.timeSecret;
						$('.SvrIp').val(SvrIp);
						$('.SvrPort').val(SvrPort);
						$('.appkey').val(appKey);
						$('.appSecret').val(appSecret);
						$('.time').val(time);
						$('.timeSecret').val(timeSecret);
						$('.CamList').val("${ccmDevice.code}");
						setTimeout(function () {
							$('.playBtn').click();
						}, 1000);
		            })
		        }, 500);//这里设置延迟(数值请根据实际情况来)是防止快速刷新页面导致进程残留  具体清楚进程方式请参考<关闭进程 云台控制>demo中的代码
		    });
		    //初始化
		    function initOcx() {
		        var OCXobj = document.getElementById("PlayViewOCX");
		        var txtInit = $("#config").val();
		        OCXobj.ContainOCX_Init(txtInit);
		    }
            //$('.playBtn').click();
            //提交按钮
		    $('.playBtn').on('click', function () {
		        var PalyType = $('.PalyType').val();
		        var SvrIp = $('.SvrIp').val();
		        var SvrPort = $('.SvrPort').val();
		        var appkey = $('.appkey').val();
		        var appSecret = $('.appSecret').val();
		        var time = $('.time').val();
		        var timeSecret = $('.timeSecret').val();
		        var httpsflag = $('.httpsflag').val();
		        var CamList = $('.CamList').val();
		        var param = 'ReqType:' + PalyType + ';' + 'SvrIp:' + SvrIp + ';'+'WndCount: 1'+';' + 'SvrPort:' + SvrPort + ';' + 'Appkey:' + appkey + ';' + 'AppSecret:' + appSecret + ';' + 'time:' + time + ';' + 'timesecret:' + timeSecret + ';' + 'httpsflag:' + httpsflag + ';' + 'CamList:' + CamList + ';';
		        //如果初始化传了WndCount值 这里也需要传 如demo中设置了WndCount:1  这里也要传WndCount:1  如果使用默认四窗口则可以不传
		        play_ocx_do(param);
		    });
	        ////OCX控件视频处理函数
	        function play_ocx_do(param) {
	            if ("null" == param || "" == param || null == param || "undefined" == typeof param) {
	                return;
	            } else {
	                var OCXobj = document.getElementById("PlayViewOCX");
	                OCXobj.ContainOCX_Do(param);
	            }
	        }
            // 关闭浏览器
		    // $(window).unload(function () {
			//	
		    // 	  var param = 'hikvideoclient://VersionTag:artemis;Exit:1;';
		    //       play_ocx_do(param);
		    // });
			//*****************海康视频OCX播放方式**************//
			//*****************海康视频直连摄像头**************//
			/*var iRet = WebVideoCtrl.I_CheckPluginInstall();
		    if (-1 == iRet) {
		        alert("您还未安装过插件，双击开发包目录里的WebComponentsKit.exe安装！");
		        return;
		    }
            
		    var oPlugin = {
		        iWidth: 1140,             // plugin width
		        iHeight: 640             // plugin height
		    };

		    var oLiveView = {
		        iProtocol: 1,            // protocol 1：http, 2:https
		        szIP: ccmDeviceIp,    // protocol ip
		        szPort: ccmDevicePort,            // protocol port
		        szUsername: ccmDeviceAccount,     // device username
		        szPassword: ccmDevicePassword, // device password
		        iStreamType: 1,          // stream 1：main stream  2：sub-stream  3：third stream  4：transcode stream
		        iChannelID: 1,           // channel no
		        bZeroChannel: false      // zero channel
		    };
		    // 初始化插件参数及插入插件
		    WebVideoCtrl.I_InitPlugin(oPlugin.iWidth, oPlugin.iHeight, {
		        bWndFull: true,//是否支持单窗口双击全屏，默认支持 true:支持 false:不支持
		        iWndowType: 1,
		        cbInitPluginComplete: function () {
		            WebVideoCtrl.I_InsertOBJECTPlugin("divPlugin");
		            // 检查插件是否最新
		            if (-1 == WebVideoCtrl.I_CheckPluginVersion()) {
		                alert("检测到新的插件版本，双击开发包目录里的WebComponentsKit.exe升级！");
		                return;
		            }

		            // 登录设备
		            WebVideoCtrl.I_Login(oLiveView.szIP, oLiveView.iProtocol, oLiveView.szPort, oLiveView.szUsername, oLiveView.szPassword, {
		                success: function (xmlDoc) {
		                    // 开始预览
		                    var szDeviceIdentify = oLiveView.szIP + "_" + oLiveView.szPort;
		                    setTimeout(function () {
		                        WebVideoCtrl.I_StartRealPlay(szDeviceIdentify, {
		                            iStreamType: oLiveView.iStreamType,
		                            iChannelID: oLiveView.iChannelID,
		                            bZeroChannel: oLiveView.bZeroChannel
		                        });
		                    }, 1000);
		                }
		            });
		        }
		    });
		    // 关闭浏览器
		    $(window).unload(function () {
		        WebVideoCtrl.I_Stop();
		    }); */
			//*****************海康视频直连摄像头**************//
		}else if(ccmDeviceTypeVidicon==3){
			//*****************大华视频**************//
			var Sys = {};
			var ua = navigator.userAgent.toLowerCase();
			var s;
			(s = ua.match(/(msie\s|trident.*rv:)([\d.]+)/)) ? Sys.ie = s[2] :
			    (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
			    (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
			    (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
			    (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;

			var hasPlugin = checkPlugins();

			var g_ocx; //控件对象，初始化完毕后，可以调用《二次开发使用 WEB32网页调用接口说明.doc》文档中的接口
			var g_PlayTime;
			var g_curSpeed = 4; //默认的正常速度
			var htmlStChn1 = '';
			var recInfosByFile = [];
		
			//加载插件到网页中去。
			loadPageOcx();
			
			//登录设备
			LoginDevice();
			RealPlay();
			
			/**
			 * 检测浏览器是否存在视频插件
			 * @return {Boolean}
			 */
			function checkPlugins() {
			    var PLUGINS_NAME = 'WebActiveEXE.Plugin.1';
			    var result;
			    if (Sys.ie) {
			        try {
			            result = new ActiveXObject(PLUGINS_NAME);
			            delete result;
			        } catch (e) {
			            return false;
			        }
			        return true;
			    } else {
			        navigator.plugins.refresh(false);
			        result = navigator.mimeTypes["application/media-plugin-version-3.1.0.2"];
			        return !!(result && result.enabledPlugin);
			    }
			}
			function loadPageOcx() {
			    var mainOcxHtml = '';
			    if (Sys.ie) {
			        mainOcxHtml = '<object id="ocx" width="100%" height="100%" classid="CLSID:7F9063B6-E081-49DB-9FEC-D72422F2727F"></object>';
			    } else {
			        mainOcxHtml = '<object id="ocx" width="100%" height="100%" type="application/media-plugin-version-3.1.0.2" VideoWindTextColor="9c9c9c" VideoWindBarColor="414141"></object>';
			    }
			    document.getElementById('divPlugin').innerHTML = mainOcxHtml;
			    g_ocx = document.getElementById('ocx');
			}
			function LoginDevice() {
			    var bRet = g_ocx.LoginDeviceEx(ccmDeviceIp, ccmDevicePort, ccmDeviceAccount, ccmDevicePassword, 0);
			    //登录后，默认四窗口显示。若需要自定义其他窗口数，可以调用g_ocx.SetWinBindedChannel
			    g_ocx.SetWinBindedChannel(1, 0, 0, 0); //这样调用可以切换为单窗口模式，参数意义详见《二次开发使用 WEB32网页调用接口说明.doc》
			    if (bRet == 0) {
			        //登录成功后
			    }
			}
			//实时监视
			function RealPlay() {
			//首先切换到监视模式
			g_ocx.SetModuleMode(1); //监视模式
			//打开通道视频
			g_ocx.ConnectRealVideo(0, 1);
			}
			//登出
			function LogoutDevice() {
			    g_ocx.LogoutDevice();
			}
			//关闭浏览器
		    $(window).unload(function () {
		    	LogoutDevice();
		    });
		}else if(ccmDeviceTypeVidicon==""){
		    document.getElementById('divPlugin').innerHTML = '<p style="color:#fff;text-align:center">请选择左侧视频监控设备</p>';
		}
	}
	</script>
</html>