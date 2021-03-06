<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<meta http-equiv="x-ua-compatible" content="IE=edge, chrome=1">
<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8;">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href='http://fonts.googleapis.com/css?family=Roboto' rel='stylesheet' type='text/css'>
<title>首页日历</title>
<link rel="stylesheet" href="${ctxStatic}/calendar/xiaocalendar/calendar.css">
 <script src="${ctxStatic}/calendar/xiaocalendar/js/jquery.js"></script> 
<script src="${ctxStatic}/calendar/xiaocalendar/js/calendar.js"></script> 
<style type="text/css">
html {
	font: 500 14px 'roboto';
	color: #333;
	/* background-color: #fafafa; */
}
a {
	text-decoration: none;
}
#demo ul, ol, li {
	list-style: none;
	padding: 0;
	margin: 0;
}
  li ol {
    padding: 0;
    margin: 0 0 0px 0px; 
}
#demo {
	width: 100%;
	
}
p {
	margin: 0;
}
#dt {
   outline: none;
	margin: 30px ;
	height: auto;
	width: 200px;
	padding: 0 6px;
	border: 1px solid #ccc;
	
}
.calendar .calendar-views .now {
    color: #fff;
    background: #2fa4e7!important;
}
</style>
</head>
<body id="calendarBody">
<div id="demo">
  <div  id="calendar"></div>
</div>

<script>
$('#demo').parent().parent().css("overflow","inherit")
var widths=300;	
	widths="${porwidth}";
 var heights='${porheigh}'
	 var keyList = eval('${data}');   

    $('#calendar').calendar({
    	 width: widths-20,
    	 height:heights-60,
        date: new Date(),
        // 日期关联数据 [{ date: string, value: object }, ... ]
        // 日期格式与 format 一致
        // 如 [ {date: '2015-11-23', value: '面试'}]
        data: keyList,
        // 展示关联数据
        // 格式化参数：{m}视图，{d}日期，{v}value
        // 设置 false 表示不显示
        label: '{v}',
       
        onSelected: function (view, date, datav) {
            
          //  alert('date:' + datav)
            //window.location.href="/arjplm/a/calendar/plmCalendar/calendar?showdate="+date.getTime();
        }
   
    });
 
   
</script>


</body>
</html>