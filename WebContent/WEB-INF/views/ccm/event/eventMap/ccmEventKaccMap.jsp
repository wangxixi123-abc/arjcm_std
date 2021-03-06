<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>重点地区排查整治分析</title>
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
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active" style="width: 160px"><a class="nav-head" href="${ctx}/event/ccmEventKacc/map">排查整治分析</a></li>
		<li><a style="width: 140px;text-align:center" href="${ctx}/event/ccmEventKacc/">排查整治列表</a></li>
	</ul>
	<div class="context" content="${ctx}"></div>
	<form:form id="searchForm" modelAttribute="ccmEventKacc" action="${ctx}/event/ccmEventKacc/map" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label >开始日期：</label> <input
				name="beginCreateDate" type="text" readonly="readonly" id="beginCreateDate"
				maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${ccmEventKacc.beginCreateDate}" pattern="yyyy-MM-dd"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" /></li>
				<li><label>结束日期：</label> <input name="endCreateDate" type="text" readonly="readonly" id="endCreateDate"
				maxlength="20" class="input-medium Wdate"
				value="<fmt:formatDate value="${ccmEventKacc.endCreateDate}" pattern="yyyy-MM-dd"/>"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
			</li>
			<c:if test="${level eq '1'}">
			<li><label>所属社区：</label>
				<sys:treeselect id="area" name="area.id" value="${ccmEventKacc.area.id}" labelName="area.name" labelValue="${ccmEventKacc.area.name}"
					title="区域" url="/tree/ccmTree/treeDataArea?type=6" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			</c:if>
			<c:if test="${level eq '2'}">
			<li><label>所属街道：</label>
				<sys:treeselect id="area" name="area.id" value="${ccmEventKacc.area.id}" labelName="area.name" labelValue="${ccmEventKacc.area.name}"
					title="街道" url="/tree/ccmTree/treeDataArea?type=5" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			</c:if>
			<!-- <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li> -->
			<li class="btns">
			<a href="javascript:;" id="btnSubmit" class="btn btn-primary">
                <i ></i> 查询 </a>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	    <div class="row-fluid">
		      <div class="span6" ><h4 style="top: 25px;
    position: relative;">治安突出问题类型</h4>
		      <div class="common-pading common-pading1" style="height:350px">
					<div id="ccmEventKaccSafe" class="echarts" style="height:240px;margin-top: 50px;" ></div>
				</div>
		      </div>
		     <div class="span6" >
			 <h4 style="top: 25px;
    position: relative;">涉及区域类型</h4>
		     <div class="common-pading common-pading1" style="height:350px">
					<div id="ccmEventKaccArea" class="echarts" style="height:240px;margin-top: 50px;"></div>
				</div>
		     </div>
		    
	    </div>
	    <br>
	     <div class="row-fluid">
		   <div class="span6" >
		   <h4 style="top: 25px;
    position: relative;">整治效果评估</h4>
		      <div class="common-pading common-pading1" style="height:350px">
					<div id="ccmEventKaccAssess" class="echarts" style="height:240px;margin-top: 50px;"></div>
				</div>
		      </div>
		      <div class="span6" ><h4 style="top: 25px;
    position: relative;">重点地区排查整治近六个月上报趋势图</h4>
		         <div class="common-pading common-pading1" style="height:350px">
					<div id="ccmEventKaccLine" class="echarts" style="height:240px;margin-top: 50px;"></div>
				 </div>
		      </div>
	    </div>
<script src="${ctxStatic}/jquery/jquery-1.9.1.min.js"></script>
<script src="${ctxStatic}/jquery/jquery.cookie.js" type="text/javascript"></script>
<script src="${ctxStatic}/common/index/Scripts/js/echarts.min.js"></script>
<script>
    var theme=$.cookie('theme');
	if (theme=="gradient"){
		var color = [ '#E84442','#1F8BFA','#2CC189', '#07BEE6', '#16DDD3',  '#FDB733', '#FF7453', '#9E56E9', '#F9A388', '#77E7F1'];
	}else{
		var color = [ '#4573a7', '#89a54e', '#71588f', '#4298af', '#db843d', '#93a9d0', '#d09392', '#b9ce96', '#a99bbc', '#92c3d4'];	
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
	var theme=$.cookie('theme');
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
	   
		var beginCreateDate = $("#beginCreateDate").val();
	    var endCreateDate = $("#endCreateDate").val();
	    var areaId = $("#areaId").val();
	    //alert(areaId);
		//治安突出问题统计
		$.getJSON(context + "/event/ccmEventKacc/findSafePage?area.id="+areaId+"&beginCreateDate="+beginCreateDate+"&endCreateDate="+endCreateDate, function(
				data) {
			// 接收参数
			$.GetWorkSheets("ccmEventKaccSafe", $.ToConvertA(data));
		});
		//涉及区域类型统计
		$.getJSON(context + "/event/ccmEventKacc/findAreaPage?area.id="+areaId+"&beginCreateDate="+beginCreateDate+"&endCreateDate="+endCreateDate, function(
				data) {
			// 接收参数
			$.GetWorkSheets("ccmEventKaccArea", $.ToConvertA(data));
		});
		//效果评估统计
		$.getJSON(context + "/event/ccmEventKacc/findAssessPage?area.id="+areaId+"&beginCreateDate="+beginCreateDate+"&endCreateDate="+endCreateDate, function(
				data) {
			// 接收参数
			$.GetWorkSheets("ccmEventKaccAssess", $.ToConvertA(data));
		});
		//总数统计
		$.getJSON(context + "/event/ccmEventKacc/findLinePage?area.id="+areaId+"&beginCreateDate="+beginCreateDate+"&endCreateDate="+endCreateDate, function(
				data) {
			// 接收参数
			$.GetChangeSheets("ccmEventKaccLine", data);
		});
		
		
		
		
	})	
	
	
	
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
			backgroundColor: backgroundColor,	
            tooltip: {
                trigger: 'item',
                formatter: "{b} :<br/> {c}件 ({d}%)",
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
                radius : ['50%', '80%'],
                center: ['35%', '50%'],
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
				 backgroundColor: backgroundColor,	
				   tooltip : {
	        	        trigger: 'item',
	        	        formatter: "{b} :<br/> {c}件",
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
					 formatter: '{value}件',
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
	   	        barWidth: '40%',
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