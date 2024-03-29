var uuidKeyProple = "";
var rmqUrl = ""
var timer;
var mqFlagKeyProple = true;
function initRabbitMQKeyProple(){
	alarmVerifyKeyProple();
	RaMqKeyProple();
}
function connectStatusHandlerKeyProple(connected) {
	if (!connected) {
		if (!mqFlagKeyProple) {
			return;
		}
		mqFlagKeyProple = false;
		setTimeout(function() {
			// initActiveMQ();
			window.onload();
			mqFlagKeyProple = true;
		}, 70000);
	}
}
var webServicePathKeyProple = window.location.href.substring(0, window.location.href
		.indexOf("arjccm"))
		+ "arjccm/a/";
// 注册uuid
function alarmVerifyKeyProple() {

	$.ajax({
		async : false,
		type : "get",
		cache : false,
		url : webServicePathKeyProple + "house/ccmHouseRmqController/subscribeAmq",
		success : function(data) {
			if (data) {
				uuidKeyProple = data.result;// 获取到uuid
				console.info("uuidKeyProple----",uuidKeyProple);
			}
		}
	});
}
function getRmqInfo(){
	$.ajax({
		async : false,
		type : "get",
		cache : false,
		url : webServicePathKeyProple + "house/ccmHouseRmqController/getRmqUrl",
		success : function(data) {
			if (data) {
				rmqUrl = data;
			}
		}
	});
}
function RaMqKeyProple(){
	getRmqInfo();
	// 初始化 ws 对象
	var ws = new WebSocket(rmqUrl);
	// 获得Stomp client对象
	var client = Stomp.over(ws);
	client.heartbeat.outgoing = 10000;//mq心跳
	client.heartbeat.incoming = 0;
	// 定义连接成功回调函数
	var on_connect = function(x) {
		orderRabbitMQInfoKeyProple();
	    client.subscribe("/queue/"+uuidKeyProple+"", function(msg) {
			// 解析对象字符串
			console.info("收到消息...");
			var msgObj = (msg.body).replace(/"(\w+)"(\s*:\s*)/g, "$1$2");
			var obj = eval('(' + msgObj + ')');
			var areaGridId = {
				id : obj.areaGridId.id
			}
			//判断用户是否属于该网格
			$.ajax({
				async : false,
				type : "post",
				cache : false,
				data : {areaGridId:obj.areaGridId.id},
				url : webServicePathKeyProple + "house/ccmHouseRmqController/judgeUserAreaPermission",
				success : function(data) {
					if(data){
						var title = "新增重点人员";
						if(obj.mqTitle){
							title = obj.mqTitle;
						}
						parent.LayerDialog1(obj.id,ctx+'/house/ccmHouseRmqController/form?id='+obj.id, title, '1100px', '300px');
					}
				}
			});
	    // 	// layer.restore(layerIndex1);
	    // 	top.$.jBox.tip('有新事件上报，请您查收！');
	    // 	if($('#layui-layer1 .layui-layer-ico').hasClass("layui-layer-maxmin")){
	    // 		$('#layui-layer1 .layui-layer-ico').click()
	    // 	}
	    // 	$(".def").hide();
	    // 	var clock="";
	    // 	var clock1="";
	    // 	var year,month,day,hh,mm,ss;
	    // 	var eventTime = new Date(obj["happenDate"].time);
	    // 	year = eventTime.getFullYear(); //年
	    // 	month = eventTime.getMonth() + 1; //月
	    // 	day = eventTime.getDate(); //日
	    // 	hh = eventTime.getHours(); //时
	    // 	mm = eventTime.getMinutes(); //分
	    // 	ss = eventTime.getSeconds(); //秒
	    //
	    // 	if (month < 10){
	    // 		month = "0"+month;
	    // 	}
	    // 	if (day < 10){
	    // 		day="0"+day;
	    // 	}
	    // 	if (hh < 10){
	    // 		hh = "0"+hh;
	    // 	}
	    // 	if (mm < 10)
	    // 		mm = '0'+mm;
		//
	    // 	if (ss < 10){
	    // 		ss = '0'+ss;
	    // 	}
	    // 	clock = year + "-"+month+"-"+day+" "+hh+":"+mm+":"+ss;
	    // 	clock1=year + "年"+month+"月"+day+"日 "+hh+"时"+mm+"分"+ss+"秒";
	    // 	var name=decodeURIComponent(obj["caseName"]);
	    // 	// 生成新的文字插入对话框中
	    // 	var htmlM = '<tr><td><a title="'+clock1+name+'" onclick="re(\'' + obj["id"]
	    // 			+ '\')" class="ccmEventLayer' + obj["id"] + ' masked active"  attrid="'
	    // 			+ obj["id"] + '" attpoint="' + obj["areaPoint"] + '" attname="'
	    // 			+ obj["caseName"] + '" > ' + clock+ '：' + name + '</a></td></tr>';
	    // 	// 插入
	    // 	$("#eventTbody tr:first-child").before(htmlM);
	    //
	    // 	var  textNAme=clock1+name
	    // 	speak(textNAme)
	    });
	};
	// 定义错误时回调函数
	var on_error =  function() {
	    console.error('error');
	};
	// 连接RabbitMQ
	client.connect('arj', '123456', on_connect, on_error, '/');
}
//订阅设备
function orderRabbitMQInfoKeyProple(){
	var userId=$('#userid').val();
	var json={'clientId':uuidKeyProple,'userId':userId};
	var param = encodeURI(JSON.stringify(json));
	$.post(webServicePathKeyProple+'house/ccmHouseRmqController/orderRabbitMQInfo',{'json':param},function(data){
		var data=JSON.parse(data);
		if(data.ret=='0'){
			// 开启心跳
			timer=window.setInterval('sendHeartBeatKeyProple()',120000)
		}
	})
}
//心跳
function sendHeartBeatKeyProple(){
	var userId=$('#userid').val();
	var json={'clientId':uuidKeyProple,'userId':userId};
	var param = encodeURI(JSON.stringify(json));
	var dateTime=new Date()
	$.post(webServicePathKeyProple+'house/ccmHouseRmqController/sendFenceHeartBeat?date='+dateTime+'',{'json':param},function(data){
		var data=JSON.parse(data);
		if(data.ret=='0'){
		}
	})
}
//取消订阅设备
function cancelOrderRabbitMQInfoKeyProple(){
	$.post(webServicePathKeyProple+'house/ccmHouseRmqController/cancelOrderRabbitMQInfo',{'clientId':uuidKeyProple},function(data){
		var data=JSON.parse(data);
		if(data.ret=='0'){
		}
	})
}