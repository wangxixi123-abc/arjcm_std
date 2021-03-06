<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>值班管理本月值班</title>
<!-- <meta name="decorator" content="default"/> -->
<script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="${ctxStatic}/jquery/jquery.cookie.js" type="text/javascript"></script>
<link href="${ctxStatic}/bootstrap/2.3.1/css_${not empty cookie.theme.value ? cookie.theme.value : 'black'}/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="${ctxStatic}/bootstrap/2.3.1/css_${not empty cookie.theme.value ? cookie.theme.value : 'black'}/custom.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js" type="text/javascript"></script>
<link href="${ctxStatic}/layim/layui/css/layui.css" type="text/css" rel="stylesheet" />

<link href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome.min.css" type="text/css" rel="stylesheet" />
<link href="${ctxStatic}/bootstrap/checkbox-radio.css" type="text/css" rel="stylesheet" />
<link href="${ctxStatic}/iconfont/iconfont.css" type="text/css" rel="stylesheet" />
<!--[if lte IE 7]><link href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome-ie7.min.css" type="text/css" rel="stylesheet" /><![endif]-->
<!--[if lte IE 6]><link href="${ctxStatic}/bootstrap/bsie/css/bootstrap-ie6.min.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/bootstrap/bsie/js/bootstrap-ie.min.js" type="text/javascript"></script><![endif]-->
<link href="${ctxStatic}/jquery-select2/3.4/select2.min.css" rel="stylesheet" />
<script src="${ctxStatic}/stomp-websocket-master/stomp.js"></script>
<script src="${ctxStatic}/common/mustache.min.js" type="text/javascript"></script>
<link href="${ctxStatic}/common/jeesite.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/jeesite.js" type="text/javascript"></script>
<link href="${ctxStatic}/common/menu.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/pgwmenu.js" type="text/javascript"></script>
<link href="${ctxStatic}/bootstrap/bootstrapTable/css/bootstrap-table.min.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/bootstrap/bootstrapTable/js/bootstrap-table.js" type="text/javascript"></script>
<script src="${ctxStatic}/bootstrap/bootstrapTable/js/bootstrap-table-zh-CN.js" type="text/javascript"></script>
<link href="${ctxStatic}/mCustomScrollbar/jquery.mCustomScrollbar.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/mCustomScrollbar/jquery.mCustomScrollbar.js" type="text/javascript"></script>
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<link href="${ctxStatic}/calendar/css/main.css" rel="stylesheet" type="text/css" />
<link href="${ctxStatic}/calendar/css/dailog.css" rel="stylesheet" type="text/css" />
<link href="${ctxStatic}/calendar/css/calendar.css" rel="stylesheet" type="text/css" /> 
<link href="${ctxStatic}/calendar/css/dp.css" rel="stylesheet" type="text/css" />   
<link href="${ctxStatic}/calendar/css/alert.css" rel="stylesheet" type="text/css" />     
<link href="${ctxStatic}/calendar/css/blackbird.css" rel="stylesheet" type="text/css" />
<link href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome.min.css" type="text/css" rel="stylesheet">
<style>
.ul-form input{
height:30px;
}
</style>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">值班管理</span>--%>
<div class="back-list">
<div style="padding-top:50px;">  
	<form:form id="searchForm" modelAttribute="ccmWorkBeonduty" action="" method="post" class="breadcrumb form-search">
		<ul class="ul-form">
			<li><label>归属部门：</label>
				<sys:treeselect id="office" name="office" value="${ccmWorkBeonduty.office.id}" labelName="" labelValue="${ccmWorkBeonduty.office.name}"
					title="部门"  url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>值班负责人：</label>
				<sys:treeselect id="principal" name="principal" value="${ccmWorkBeonduty.principal.id}" labelName="" labelValue="${ccmWorkBeonduty.principal.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>值班队伍：</label>
				<form:input path="principalMans" htmlEscape="false" maxlength="1000" class="input-medium"/>
			</li>
			<li class="btns">
				<a href="javascript:;" onclick="initData()" id="btnSubmit" style="width: 49px;display:inline-block;float: right;color: #fff" class="btn btn-primary">
                <i style="font-size: 12px"></i>查询 </a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
</div>
<div>
<div id="calhead" style="padding-left:1px;padding-right:1px;">          
	<div class="cHead">
		<div class="ftitle">我的日程</div>
		<div id="loadingpannel" class="ptogtitle loadicon" style="display: none;">正在加载数据...</div>
		
	</div>          

	<div id="caltoolbar" class="ctoolbar">
		<div class="btnseparator"></div>         
		<div class="clear"></div>
	</div>
</div>

<div style="padding:1px;">
	<div class="t1 chromeColor">&nbsp;</div>
	<div class="t2 chromeColor">&nbsp;</div>
	<div id="dvCalMain" class="calmain printborder">
		<div id="gridcontainer" style="overflow-y: visible;"></div>
	</div>
	<div class="t2 chromeColor">&nbsp;</div>
	<div class="t1 chromeColor">&nbsp;</div>   
</div>
</div>

<div style="text-align:center;margin:50px 0; font:normal 14px/24px 'MicroSoft YaHei';">
</div>
</body>

<script src="${ctxStatic}/calendar/js/jquery.min.js" type="text/javascript"></script>  
<script src="${ctxStatic}/calendar/js/Common.js" type="text/javascript"></script>    
<script src="${ctxStatic}/calendar/js/blackbird.js" type="text/javascript"></script> 
<script src="${ctxStatic}/calendar/js/datepicker_lang_zh_CN.js" type="text/javascript"></script>     
<script src="${ctxStatic}/calendar/js/jquery.datepicker.js" type="text/javascript"></script>
<script src="${ctxStatic}/calendar/js/jquery.alert.js" type="text/javascript"></script>    
<script src="${ctxStatic}/calendar/js/jquery.ifrmdailog.js" defer="defer" type="text/javascript"></script>
<script src="${ctxStatic}/calendar/js/xgcalendar_lang_zh_CN.js" type="text/javascript"></script>  
<script src="${ctxStatic}/calendar/js/xgcalendar.js?v=1.2.0.4" type="text/javascript"></script> 
  
<script type="text/javascript">

$(document).ready(function() {
	var showdate='${date}';
	var keyList = eval('${list}'); 
    getData(showdate,keyList);
});


/*  var obj={
	office:$("#office").val(),
	principal:$("#principal").val(), 
	principalMans:$("#principalMans").val() 
}  */


function initData(){
     var obj = new Object();
	 obj.office = $("#officeId").val()
	 obj.principal = $("#principalId").val()
	 obj.principalMans = $("#principalMans").val() 
	 
   	$.post("getccmBeonduty",obj, function(data){
		data=JSON.parse(data);
		var showdate=data['date'];
		var keyList = data['list']; 
		getData(showdate,keyList)
	})   
}

function getData(showdate,keyList){
for (var i = 0; i < keyList.length; i++) {
	keyList[i][2]=new Date(keyList[i][2]+8*3600*1000);
	keyList[i][3]=new Date(keyList[i][3]+8*3600*1000);
}
	
//iframe去边距
$("#right", parent.document).css("padding","0px")
//[id,title,start,end，全天日程，跨日日程,循环日程,theme(颜色),'地点','参与人']          
var view="month";          
﻿ /* __CURRENTDATA=[['6147','你好啊',new Date(1531988321907),new Date(1531988421907),0,0,0,2,0,'21','']]; */

var op = {
	view: view,
	theme:3,
	showday: new Date(Number(showdate)),
	// EditCmdhandler:Edit,
	// DeleteCmdhandler:Delete,
	  ViewCmdhandler:View,
	 onWeekOrMonthToDay:wtd,
	onBeforeRequestData: cal_beforerequest,
	onAfterRequestData: cal_afterrequest,
	onRequestDataError: cal_onerror, 
	url: "calendar?mode=get" ,  
	// quickAddUrl: "${ctx}/calendar/plmCalendar/quickadd" ,
	// quickUpdateUrl: "calendar.php?mode=quickupdate" ,
	// quickDeleteUrl:  "calendar.php?mode=quickdelete" //快速删除日程的
   /* timeFormat:" hh:mm t", //t表示上午下午标识,h 表示12小时制的小时，H表示24小时制的小时,m表示分钟
	tgtimeFormat:"ht" //同上 */             
};
var $dv = $("#calhead");
var _MH = document.documentElement.clientHeight;
var dvH = $dv.height() + 2;
op.height = _MH - dvH;
op.eventItems = keyList;

var p = $("#gridcontainer").bcalendar(op).BcalGetOp();
if (p && p.datestrshow) {
	$("#txtdatetimeshow").text(p.datestrshow);
}
$("#caltoolbar").noSelect();

$("#hdtxtshow").datepicker({ picker: "#txtdatetimeshow", showtarget: $("#txtdatetimeshow"),
onReturn:function(r){                          
				var p = $("#gridcontainer").BCalGoToday(r).BcalGetOp();
				if (p && p.datestrshow) {
					$("#txtdatetimeshow").text(p.datestrshow);
				}
		 } 
});
Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o){
	    if (new RegExp("(" + k + ")").test(fmt)) {
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		}
    }
    return fmt;
}
function cal_beforerequest(type)
{
	var t="正在加载数据...";
	switch(type)
	{
		case 1:
			t="正在加载数据...";
			break;
		case 2:                      
		case 3:  
		case 4:    
			t="正在处理请求...";                                   
			break;
	}
	$("#errorpannel").hide();
	$("#loadingpannel").html(t).show();    
}
function cal_afterrequest(type)
{
	switch(type)
	{
		case 1:
			$("#loadingpannel").hide();
			break;
		case 2:
		case 3:
		case 4:
			$("#loadingpannel").html("操作成功!");
			window.setTimeout(function(){ $("#loadingpannel").hide();},2000);
		break;
	}              
   
}
function cal_onerror(type,data)
{
	$("#errorpannel").show();
}
function Edit(data)
{
   var eurl="${ctx}/calendar/plmCalendar/formdate?data="+data;   
	if(data)
	{     
		var url = StrFormat(eurl,data);
		
		OpenModelWindow(url,{ width: 1000, height: 450, caption:"管理日程",onclose:function(){
		   $("#gridcontainer").BCalReload();
		}});
	}
}    
function View(data)
{   
	var vurl="${ctx}/work/ccmWorkBeonduty/view?id="+data[0] + "&clickDate=" + data[2].Format("yyyy-MM-dd");
	if(data)
	{   
		var url = StrFormat(vurl,data);
		OpenModelWindow(url,{ width: 1000, height:450, caption: "查看日程"});
	}
}    
function Delete(data,callback)
{  
	$.alerts.okButton="确定";  
	$.alerts.cancelButton="取消";  
	hiConfirm("是否要删除该日程?", '确认',function(r){ r && callback(0);});           
}
function wtd(p)
{        
   if (p && p.datestrshow) {
		$("#txtdatetimeshow").text(p.datestrshow);
	}
	$("#caltoolbar div.fcurrent").each(function() {
		$(this).removeClass("fcurrent");
	})
	$("#showdaybtn").addClass("fcurrent");
}
//显示月视图
$("#showmonthbtn").click(function(e) {
	//document.location.href="#month";
	$("#caltoolbar div.fcurrent").each(function() {
		$(this).removeClass("fcurrent");
	})
	$(this).addClass("fcurrent");
	var p = $("#gridcontainer").BCalSwtichview("month").BcalGetOp();
	if (p && p.datestrshow) {
		$("#txtdatetimeshow").text(p.datestrshow);
	}
});

$("#showreflashbtn").click(function(e){
	$("#gridcontainer").BCalReload();
});


//点击回到今天
$("#showtodaybtn").click(function(e) {
	var p = $("#gridcontainer").BCalGoToday().BcalGetOp();
	if (p && p.datestrshow) {
		$("#txtdatetimeshow").text(p.datestrshow);
	}


});
//上一个
$("#sfprevbtn").click(function(e) {
	var p = $("#gridcontainer").BCalPrev().BcalGetOp();
	if (p && p.datestrshow) {
		$("#txtdatetimeshow").text(p.datestrshow);
	}

});
//下一个
$("#sfnextbtn").click(function(e) {
	var p = $("#gridcontainer").BCalNext().BcalGetOp();
	if (p && p.datestrshow) {
		$("#txtdatetimeshow").text(p.datestrshow);
	}
});
$("#changetochinese").click(function(e){
	location.href="?lang=zh-cn";
});
$("#changetoenglish").click(function(e){
	location.href="?lang=en-us";
});
 $("#changetoenglishau").click(function(e){
	location.href="?lang=en-au";
});

}
</script>
</html>