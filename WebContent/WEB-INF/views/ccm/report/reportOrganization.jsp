<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构组织分析</title>
	<meta name="decorator" content="default"/>
	<style>
	.common-pading{
	  width:100%;
	  height:200px;
	  padding:5px;
	}
	.echarts{
	  width:100%;
	  height:100%;
	}
	
	
	</style>
	<script type="text/javascript">
		$(document).ready(function() {
			$("td").css({"padding":"2px"});
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
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/report/ccmReportOthers/organization">机构组织分析</a></li>
		<li><a style="width: 140px;text-align:center" href="${ctx}/org/ccmOrgNpse/list">机构组织列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="ccmEventKacc" action="${ctx}/event/ccmEventKacc/map" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table style="width: 60%;" id="tbody">
		</table>	
		
	</form:form>
	<div class="context" content="${ctx}"></div>
	<sys:message content="${message}"/>
	    <div class="row-fluid">
		 <div class="span6" >
		     <div class="common-pading"><h4>控股情况类型统计</h4>
					<div id="ccmOrgNpseHoldCase" class="echarts" ></div>
				</div>
		     </div>
		      <div class="span6" ><h4>机构组织类型统计</h4>
		      <div class="common-pading">
					<div id="ccmOrgNpseCompType" class="echarts" ></div>
				</div>
		      </div>
		    
		      
	    </div>
	    <br>
	     <div class="row-fluid">
   <div class="span6" ><h4>安全隐患类型统计图</h4>
		         <div class="common-pading">
					<div id="ccmOrgNpseSafeHazaType" class="echarts" ></div>
				 </div>
		      </div>
	     	  <div class="span6" >
		      <div class="common-pading"><h4>重点类型统计</h4>
					<div id="ccmOrgNpseCompImpoType" class="echarts" ></div>
				</div>
		      </div>
		   
		    
	    </div>
		<br>
		 <div class="row-fluid">
		 <div class="span6" ><h4>关注程度统计图</h4>
		         <div class="common-pading">
					<div id="ccmOrgNpseConcExte" class="echarts" ></div>
				 </div>
		      </div>
			    <div class="span6" >
		      <div class="common-pading"><h4>危化企业统计</h4>
					<div id="ccmOrgNpseDangComp" class="echarts" ></div>
				</div>
		      </div>
		 </div>
<script src="${ctxStatic}/jquery/jquery-1.9.1.min.js"></script>
<script src="${ctxStatic}/jquery/jquery.cookie.js" type="text/javascript"></script>
<script src="${ctxStatic}/common/index/Scripts/js/echarts.min.js"></script>
<script>
var theme=$.cookie('theme');
if(theme=='gradient'){
var color = [ '#1F8BFA', '#E84442', '#FAB736', '#2CC189', '#F9A388', '#77E7F1', '#9E56E9', '#FF7453', '#16DDD3', '#FDB733'];
}
else{
	var color = [ '#4573a7', '#89a54e', '#71588f', '#4298af', '#db843d', '#93a9d0', '#d09392', '#b9ce96', '#a99bbc', '#92c3d4', '#ffdf5f','#aa4644'];
}
	//基础参数
	var windowsHeight, _fontSize = 14,

	_fontSize1 = 26,
	breakData = 8;
	legendTop = '30%',
	radiusData = [90, 65],
	lengthECharts = 30;
	var context = $(".context").attr("content");
	var FontColor="#999",backgroundColor="#fff";
/* 	var theme=$.cookie('theme') */;
	if(theme=="black"){
		FontColor="#fff";
		backgroundColor="#0e2a4c";
	}
	
	$(function(){
	    windowsHeight= $(window).width();

	    if (windowsHeight >= 1600) {
	    	
	        _fontSize = 14;
	        legendTop = '15%';
	        radiusData = [90, 65];
	        lengthECharts = 20;
	        _fontSize1 = 26;
	        breakData = 8;
	        legendRight="8%"
	    }else {
	    	
	        _fontSize = 12;
	        legendTop = '15%';
	        radiusData = [60, 45];
	        lengthECharts = 5;
	        _fontSize1 = 12;
	        breakData = 6;
	        legendRight="5%"
	    }
	   
	    $.getJSON(context + "/report/ccmReportOthers/getOrganizationList", function(
				data) {
			// 接收参数
			$.GetListSheets("tbody", data);
		});
		//
		$.getJSON(context + "/report/ccmReportOthers/findCompTypeAndCompImpoType", function(
				data) {
			// 接收参数
			$.GetWorkSheets("ccmOrgNpseCompType", $.ToConvertA(JSON.parse(data[0])));
			$.GetWorkSheets("ccmOrgNpseCompImpoType", $.ToConvertA(JSON.parse(data[1])));
		
		});
		//
		$.getJSON(context + "/report/ccmReportOthers/findHoldCaseAndSafeHazaType", function(
				data) {
			// 接收参数
			$.GetWorkSheets("ccmOrgNpseHoldCase", $.ToConvertA(JSON.parse(data[0])));
			$.GetWorkSheets("ccmOrgNpseSafeHazaType", $.ToConvertA(JSON.parse(data[1])));
		
		});
		//
		$.getJSON(context + "/report/ccmReportOthers/findDangCompAndConcExte", function(
				data) {
			// 接收参数
			$.GetChangeSheets("ccmOrgNpseDangComp", JSON.parse(data[0]));
			$.GetChangeSheets("ccmOrgNpseConcExte", JSON.parse(data[1]));
		
		});
		
		
		
		
	})	
	
	
	// list
	$.GetListSheets = function(model, tbodyList) {
        // 拼接 table内容
        var tableContent = "";
        tableContent += "<tr><td><div><label class='control-label'>员工总数：</label>"+tbodyList["value1"]+"人</div></td></tr>";
        tableContent += "<tr>";
        tableContent += "<td><div><label class='control-label'>中共党组织数量：</label>"+tbodyList["value2"]+"个</div></td>";
        tableContent += "<td><div><label class='control-label'>中共党员数量：</label>"+tbodyList["value3"]+"人</div></td>";
        tableContent += "<td><div><label class='control-label'>工会数量：</label>"+tbodyList["value4"]+"个</div></td>";
        tableContent += "<td><div><label class='control-label'>工会会员数量：</label>"+tbodyList["value5"]+"人</div></td>";
        tableContent += "</tr>";
        tableContent += "<tr>";
        tableContent += "<td><div><label class='control-label'>共青团组织数量：</label>"+tbodyList["value6"]+"个</div></td>";
        tableContent += "<td><div><label class='control-label'>共青团员数量：</label>"+tbodyList["value7"]+"人</div></td>";
        tableContent += "<td><div><label class='control-label'>妇联组织数量：</label>"+tbodyList["value8"]+"个</div></td>";
        tableContent += "<td><div><label class='control-label'>妇女数量：</label>"+tbodyList["value9"]+"人</div></td>";
        tableContent += "</tr>";
        // 添加内容 到页面
        $("#"+model).html(tableContent);
    } 
	
	// 饼图pingJson况
	$.ToConvertA = function(object) {
        var ajaxData = new Array();
        for (var one in object) {
            ajaxData.push({
                "name": object[one]["type"],
                "value": Number(object[one]["value"])
            });
        }
        return ajaxData;
    } 
	
	
	//饼图统计情况
	$.GetWorkSheets = function(model,data) {
		
        var nameArr = [],
        DataArr = [];
        
        var option = {
        	backgroundColor:backgroundColor,
            tooltip: {
                trigger: 'item',
                formatter: "{b} :<br/> {c}家 ({d}%)",
		        confine:true
            },
            legend: {
                
                type: 'scroll',
                orient: 'vertical',
                left:'70%',
                top:'middle',
                textStyle: {
                    color: FontColor,
                    fontSize: _fontSize,
                },
                data: data
            }, 
            series: [{
                name: '特殊人群类型',
                type: 'pie',
                radius : ['45%', '75%'],
                center: ['40%', '50%'],
                color: color,
                label: {
                    normal: {
						  formatter: "{b}：{c}",
                        show: true
                    }

                },
                labelLine: {
                    normal: {
                        show: true
                    }
                },
                data: data
            }]
        };
        var Barchart = echarts.init(document.getElementById(model));
        Barchart.setOption(option);

    }
	//柱状图统计情况
	$.GetChangeSheets =function(model,data){
		   var type=[];
		   var value=[];
		   for(var i=0;i<data.length;i++){ 
			   type.push(data[i]['type']);
			   value.push(data[i]['value']);
			}

		 var   option = {
				  backgroundColor:backgroundColor,
				   tooltip : {
	        	        trigger: 'item',
	        	        formatter: "{b} :<br/> {c}家",
				        confine:true
	        	    },
	        	     grid: {
		                    left: '3%',
		                    right: '3%',
		                    bottom: '3%',
		                    top: '5%',
		                    containLabel: true
		                },
		                
	   	    yAxis: {
	   	        type: 'value',
		   	     axisLabel : {
					 formatter: '{value}家',
						textStyle : {
							color : FontColor,
						}
				},
	   	        axisLine: {
	                    lineStyle: {
	                        color: '#808080'
	                    }
	                },
	                splitLine: {
	                    show: false
	                }
	   	    },
	   	    
	   	    xAxis: {
	   	        type: 'category',
	   	        data: type,
	   	     axisLabel : {
					textStyle : {
						color : FontColor,
					}
				},
	   	        axisLine: {
	                    lineStyle: {
	                        color: '#808080'
	                    }
	                },
	                splitLine: {
	                    show: false
	                }
	   	    },
	   	    series: [{
	   	        data: value,
	   	        type: 'bar',
	   	        barWidth: '30%',
	   	        //配置样式
	   	        itemStyle: {   
	   	            //通常情况下：
	   	            normal:{  
	   	                color: function (params){
	   	                    var colorList = color;
	   	                    return colorList[params.dataIndex];
	   	                }
	   	            },
	   	            //鼠标悬停时：
	   	            emphasis: {
	   	                    shadowBlur: 10,
	   	                    shadowOffsetX: 0,
	   	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	   	            }
	   	        },
	   	    }]
		   }

		    var Barchart = echarts.init(document.getElementById(model));
	        Barchart.setOption(option);
	   }
	 
		
</script>
</body>
</html>