$.fn.fishBone = function(data, uri, permission) {
    var colors = ['#F89782', '#1A84CE', '#F7A259', '#43A6DA', '#F9BF3B','#88C7CC','#EF6D5F','#60A96E','#F03852','#3A9284'];

    /**入口*/
    //1.创建dom
    $(this).children().remove();
    $(this).append(creataFishBone(data));
    //2.自适应
    var rowcount = fixWindow();
    //3.翻页滚动效果
    jQuery(".fishBone").slide({
        titCell: ".hd ul",
        mainCell: ".bd>ul",
        autoPage: true,
        effect: "left",
        autoPlay: false,
        scroll: rowcount,
        vis: rowcount
    });


    /**自适应 平均分布*/
    function fixWindow() {
        //item所占的宽度 = 自身宽度+marginleft
        var item = $(".fishBone .bd .item");
        var marginleft = parseInt(item.css('margin-left'))
        var item_w = item.width() + marginleft;

        //显示区域
        var bd_w = $(".fishBone .bd").width();
        //能显示的个数 取整
        var rowcount = parseInt(bd_w / item_w);
        if (rowcount > item.size()) {
            //rowcount = item.size();
            $(".fishBone .prev,.fishBone .next").hide()
        }
        //设置新的宽度使其平均分布
        var item_w_temp = bd_w / rowcount - marginleft;
        item.width(item_w_temp);
        return rowcount;
    };
    /**li左边框线颜色 border-left-color 动态获取*/
    function getColor(i) {
        var length = colors.length;
        var color = 'gray';
        if (i <= length - 1) {
            color = colors[i];
        } else {
            color = colors[i % length];
        }
        return color;
    };
    /**轴线上圆点位置纵坐标，见图片line-point.png*/
    function getLinePointY(i) {
        var length = colors.length;
        var y = 0;
        if (i <= length - 1) {
            y = -i * 20;
        } else {
            y = -(i % length) * 20;
        }
        return y + "px";
    };
    /**第一行日期圆点位置纵坐标，图片line-first.png*/
    function getLineFirstY(i) {
        var length = colors.length;
        var y = 0;
        if (i <= length - 1) {
            y = -i * 60;
        } else {
            y = -(i % length) * 60;
        }
        return y + "px";
    };
    /** .title-left背景纵坐标，0px开始，见图片title.png*/
    function getTitleLeftY(i) {
        var length = colors.length;
        var y = 0;//图片位置
        if (i <= length - 1) {
            y += -i * 60;
        } else {
            y += -(i % length) * 60;
        }
        return y + "px";
    };
    /** .title-center背景纵坐标，600px开始，见图片title.png*/
    function getTitleCenterY(i) {
        var length = colors.length;
        var y = -598;//图片位置
        if (i <= length - 1) {
            y += -i * 60;
        } else {
            y += -(i % length) * 60;
        }
        return y + "px";
    };
    /**.title-right背景纵坐标，1200px开始，见图片title.png*/
    function getTitleRightY(i) {
        var length = colors.length;
        var y = -1200;//图片位置
        if (i <= length - 1) {
            y += -i * 60;
        } else {
            y += -(i % length) * 60;
        }
        return y + "px";
    };
    /**创建dom结构*/
    function creataFishBone(data) {
        var fishBone = $("<div class='fishBone'/>");
        var wrapper = $("<div class='wrapper'></div>");
        var bd = $("<div class='bd'></div>");
        var ul_item = $("<ul/>");
        //遍历数据
        $(data).each(function(index) {
            var itemclass=itemClass(index);//显示在轴上方或下方标识 top/bottom

            var color = getColor(index);
            var lineFirstY = getLineFirstY(index);

            var titleLeftY = getTitleLeftY(index);
            var titleCenterY = getTitleCenterY(index);
            var titleRightY = getTitleRightY(index);
            var id;
            var idx;
            var ul = $("<ul></ul>");
            $.each(this, function(name, value) {
                if (name == 'id') {
                    id = value;
                    return;
                }
            });
            //遍历封装属性
            //封装审理时间和案号
//            if(itemclass=='top'){
//                $.each(this, function(name, value) {
//                    if (name == 'dealDate') {
//                        var li = $("<li class='line-first'>" + value + "</li>")
//                                    .css('background-position-y', (parseInt(lineFirstY)+9)+"px");//9是原计算结果的偏移量，显示位置正合适
//                        li.appendTo(ul);
//                        return;
//                    }
//                });
//
//                $.each(this, function(name, value) {
//                    if (name == 'dealUnit') {
//                    	var li = $("<li class='title'></li>");
//                        var titleLeft =  $("<span class='title-left'>&nbsp;</span>").css('background-position-y',titleLeftY);
//                        var titleCenter ;
//                    	if(permission== 'deal'){
//
//                            titleCenter =  $("<span class='title-center'>" +
//                            		"<a	href='" + uri + "/event/ccmEventCasedeal/dealform?id="+id+"' style='color: #fff'>"+value+
//                            		"</a></span>").css('background-position-y',titleCenterY);
//                    	}
//                    	if(permission== 'read'){
//
//                            titleCenter =  $("<span class='title-center'>" +
//                            		"<a	href='" + uri + "/event/ccmEventCasedeal/readform?id="+id+"' style='color: #fff'>"+value+
//                            		"</a></span>").css('background-position-y',titleCenterY);
//                    	}
//                    	var titleRight =  $("<span class='title-right'>&nbsp;</span>").css('background-position-y',titleRightY);
//                    	li.append(titleLeft).append(titleCenter).append(titleRight);
//                        li.appendTo(ul);
//                        return;
//                    }
//                });
//            }
            var phoneLi ="";
            var handleDeadli = "";
            var isSuperviseli = ""
            var statusli = ""
            var handleUserli = ""
            var remarksli = ""

            //封装其他属性
            $.each(this, function(name, value) {
               /* if (name == 'telCom' || name == 'eventPrincipal' || name == 'telPerson' || name == 'remarks') {
                    var li = $("<li>" + name + "：" + value + "</li>").css("border-left","1px solid "+color);
                    li.appendTo(ul);
                }*/
            	if((value != null && value != '')||(name == 'remarks')){
            		if(name == 'tailTime'){
            			var clock="";
	                	var clock1="";
	                	var year,month,day,hh,mm,ss;
                        value = value.replace(/-/g,'/')
                        value = value.split(".0")[0];
                		var eventTime = new Date(value);
                		year = eventTime.getFullYear(); //年
                		month = eventTime.getMonth() + 1; //月
                		day = eventTime.getDate(); //日
                		hh = eventTime.getHours(); //时
                		mm = eventTime.getMinutes(); //分
                		ss = eventTime.getSeconds(); //秒

                		if (month < 10){
                			month = "0"+month;
                		}
                		if (day < 10){
                			day="0"+day;
                		}
                		if (hh < 10){
                			hh = "0"+hh;
                		}
                		if (mm < 10)
                			mm = '0'+mm;

                		if (ss < 10){
                			ss = '0'+ss;
                		}
                		clock = year + "-"+month+"-"+day+" "+hh+":"+mm+":"+ss;
                		clock1=year + "年"+month+"月"+day+"日 "+hh+"时"+mm+"分"+ss+"秒";
            			var li = $("<li>指派时间：" + clock + "</li>").css("border-left","1px solid "+color);
            			if(phoneLi!=""){
                            phoneLi.appendTo(ul);
                        }
            			li.appendTo(ul);
            		}
	            	if (name == 'tailCase') {
	            		var li = $("<li>指示内容：" + value + "</li>").css("border-left","1px solid "+color);
	            		li.appendTo(ul);
	            	}
	            	if (name == 'tailContent') {
	            		var li = $("<li>内容：" + value + "</li>").css("border-left","1px solid "+color);
	            		li.appendTo(ul);
	            	}
	            	if (name == 'tailPerson') {
	            		var li = $("<li>指派处理人员：" + value + "</li>").css("border-left","1px solid "+color);
	            		li.appendTo(ul);
	            	}
	            	if (name == 'more1') {
	            		var li = $("<li>处理人联系方式：" + value + "</li>").css("border-left","1px solid "+color);
                        phoneLi = li
	            	}
	                if (name == 'handleUser') {
	                    var li = $("<li>处理人员：" + value.name + "</li>").css("border-left","1px solid "+color);
	                    //li.appendTo(ul);
                        handleUserli = li;
	                }
	                if (name == 'handleDeadline') {

		                	var clock="";
		                	var clock1="";
		                	var year,month,day,hh,mm,ss;
	                		var eventTime = new Date(value.time);
	                		year = eventTime.getFullYear(); //年
	                		month = eventTime.getMonth() + 1; //月
	                		day = eventTime.getDate(); //日
	                		hh = eventTime.getHours(); //时
	                		mm = eventTime.getMinutes(); //分
	                		ss = eventTime.getSeconds(); //秒

	                		if (month < 10){
	                			month = "0"+month;
	                		}
	                		if (day < 10){
	                			day="0"+day;
	                		}
	                		if (hh < 10){
	                			hh = "0"+hh;
	                		}
	                		if (mm < 10)
	                			mm = '0'+mm;

	                		if (ss < 10){
	                			ss = '0'+ss;
	                		}
	                		clock = year + "-"+month+"-"+day+" "+hh+":"+mm+":"+ss;
	                		clock1=year + "年"+month+"月"+day+"日 "+hh+"时"+mm+"分"+ss+"秒";
	                		var li = $("<li>处理截至时间：" + clock + "</li>").css("border-left","1px solid "+color);
	                		//li.appendTo(ul);
                            handleDeadli = li;
	                }
	                if (name == 'isSupervise') {
	                	var y = value;
	                	if(y=="1"){
	                		y="是";
	                	}else{
	                		y="否";
	                	}
	                    var li = $("<li>是否督办：" + y + "</li>").css("border-left","1px solid "+color);
	                    //li.appendTo(ul);
                        isSuperviseli = li;
	                }
	                if (name == 'remarks' && value.length > 0) {
	                    var li = $("<li>事件说明：" + value + "</li>").css("border-left","1px solid "+color);
	                    li.appendTo(ul);
                        isSuperviseli.appendTo(ul);
                        handleUserli.appendTo(ul);
                        statusli.appendTo(ul);
                        handleDeadli.appendTo(ul);
	                }
	                if (name == 'id') {
	                	idx = value
	                }
	                if (name == 'status') {
	               	 	ul[0].id=idx
	                    ul[0].onclick=function(){
                            console.log(ctx+'/event/ccmEventCasedeal/detail');
	                    	parent.LayerDialog5('',ctx+'/event/ccmEventCasedeal/detail?id='+idx, '处理详情', '1400px', '800px')
	                    }
	                   var li = $("<li><a>处理详情</a></li>").css("border-left","1px solid "+color);
	                   //li.appendTo(ul);
                        statusli = li;
	               }else if(name == 'handleStatus'){
	            	   ul[0].id=idx
	                    ul[0].onclick=function(){
	            	       console.log(ctx+'/event/ccmEventCasedeal/detail');
	                    	parent.LayerDialog5('',ctx+'/event/ccmEventCasedeal/detail?id='+idx, '处理详情', '1400px', '800px')
	                    }
	                   var li = $("<li><a>处理详情</a></li>").css("border-left","1px solid "+color);
	                   //li.appendTo(ul);
                        statusli = li;
	               }
            	}

            });
          //封装审理时间和案号
//            if(itemclass=="bottom"){
//                $.each(this, function(name, value) {
//                    if (name == 'dealUnit') {
//                    	var li = $("<li class='title'></li>");
//                        var titleLeft =  $("<span class='title-left'>&nbsp;</span>").css('background-position-y',titleLeftY);
//                        var titleCenter ;
//                    	if(permission== 'deal'){
//
//                            titleCenter =  $("<span class='title-center'>" +
//                            		"<a	href='" + uri + "/event/ccmEventCasedeal/dealform?id="+id+"' style='color: #fff'>"+value+
//                            		"</a></span>").css('background-position-y',titleCenterY);
//                    	}
//                    	if(permission== 'read'){
//
//                            titleCenter =  $("<span class='title-center'>" +
//                            		"<a	href='" + uri + "/event/ccmEventCasedeal/readform?id="+id+"' style='color: #fff'>"+value+
//                            		"</a></span>").css('background-position-y',titleCenterY);
//                    	}
//                    	var titleRight =  $("<span class='title-right'>&nbsp;</span>").css('background-position-y',titleRightY);
//                    	li.append(titleLeft).append(titleCenter).append(titleRight);
//                        li.appendTo(ul);
//                        return;
//                    }
//                });
//                $.each(this, function(name, value) {
//                    if (name == 'dealDate') {
//                        var li = $("<li class='line-first'>" + value + "</li>")
//                        .css('background-position-y', (parseInt(lineFirstY)-33)+"px");//30是原计算结果的偏移量
//                        li.appendTo(ul);
//                        return;
//                    }
//                });
//            }
            //封装轴线上的圆点
            var linePointY = getLinePointY(index);
            var point = $("<li class='line-last line-point'></li>").css('background-position', '0px ' + linePointY);
            point.appendTo(ul);

            //生成一个item（一个完整的案事件）
            var li_item = $("<li class='item'></li>");
            var content = $("<div class='content'></div>");
            ul.appendTo(content);
            content.appendTo(li_item);
            li_item.addClass(itemClass(index)).appendTo(ul_item);
        });
        ul_item.appendTo(bd);
        bd.appendTo(wrapper);

        var prev = $("<a class='prev'></a>");
        var next = $("<a class='next'></a>");
        var line = $("<div class='line'/>")

        fishBone.append(wrapper).append(prev).append(next).append(line);
        return fishBone;
    };
    /**item添加样式，显示在上方或下方*/
    function itemClass(index) {
        index += 1;
        if (index % 2 == 0) {
            //偶数显示到下方
            return "bottom";
        } else {
            //奇数显示到上方
            return "top";
        }
    }
}