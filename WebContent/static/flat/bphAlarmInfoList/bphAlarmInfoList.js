$(document).ready(function() {
	if($.cookie('querySon')==undefined){
    	$.cookie('querySon',false);
	};
	init();//初始化赋值
	initTable();// 初始化表格
	$('#btnSubmit').click(function() {
		initTable();// 初始化表格
	})
});
function init(){
	var beginAlarmDate = today()+" 00:00:00";
	var endAlarmDate = today()+" 23:59:59"
	$('#beginAlarmTime').val(beginAlarmDate);
	$('#endAlarmTime').val(endAlarmDate);
}
// 初始化表格
function initTable() {
	var beginAlarmTime = $('#beginAlarmTime').val();
	var endAlarmTime = $('#endAlarmTime').val();
	var beginDateNew = Date.parse(new Date(beginAlarmTime.replace(/-/g, "/")));
	var endDateNew = Date.parse(new Date(endAlarmTime.replace(/-/g, "/")));
	var time = endDateNew - beginDateNew;
	if (time < 0) {
		$.jBox.tip("开始时间必须小于结束时间", "警告");
		return;
	}
	var orderNum = $('#orderNum').val();
	var policeName = $('#policeName').val();
	var place = $('#place').val();
	var typeCode = $('#typeCode').val();
	var area = $('#areaId').val();
	var isImportant = $('#isImportant').val();
	var state = $('#state').val();
	var handleStatus = $('#handleStatus').val();
	var incSubset=$.cookie('querySon');//是否查询下级
	layui.use('table', function() {
		var table = layui.table;
		table.render({
			elem : '#contentTable',
			url : ctx + '/alarm/bphAlarmInfo/list',
			where : {
				'orderNum' : orderNum,
				'policeName' : policeName,
				'place' : place,
				'typeCode' : typeCode,
				'area' : area,
				'beginAlarmTime' : beginAlarmTime,
				'endAlarmTime' : endAlarmTime,
				'isImportant' : isImportant,
				'state' : state,
				'handleStatus' : handleStatus,
				'incSubset' : incSubset
			},
			request : {
				pageName : 'currentPage',// 页码的参数名称，默认：page
				limitName : 'pageSize' // 每页数据量的参数名，默认：limit
			},
			limit:15,
			limits:[15,30,45,60],
			height : tableHeight,
			cols : [ [ 
				{
					field : 'orderNum',
					width : '8%',
					title : '接警单号',
				},{
				field : 'content',
				width : '20%',
				title : '警情',
			}, {
				field : 'alarmTime',
				width : '10%',
				title : '日期',
				sort : true
			}, {
				field : 'place',
				width : '18%',
				title : '地点',
			}, {
				field : 'typeName',
				width : '10%',
				title : '警情类型'
			}, {
				field : 'office',
				title : '处理单位',
				width : '10%',
				templet: function(val){
					if(val.office&&val.office.id&&val.office.name){
						return val.office.name;
					}else{
						return '';
					}
				}
			}, {
				field : 'state',
				width : '8%',
				title : '警情状态',
				sort : true,
				templet: function(val){
					var html='';
					if(val.state=='0'){
						html='<span class="alarmstatus_0">未处理</span>';
					}else if(val.state=='1'){
						html='<span class="alarmstatus_1">已派发</span>';
					}else if(val.state=='2'){
						html='<span class="alarmstatus_2">处理中</span>';
					}else if(val.state=='3'){
						html='<span class="alarmstatus_3">已完成</span>';
					}else{
						html='<span></span>';
					}
			        return html;
			      }
			}, {
				field : 'state',
				width : '8%',
				title : '处置状态',
				sort : true,
				templet: function(val){
					var html='';
					if(val.handleStatus=='0'){
						html='<span class="alarmstatus_0">未处理</span>';
					}else if(val.handleStatus=='1'){
						html='<span class="alarmstatus_1">已签收</span>';
					}else if(val.handleStatus=='2'){
						html='<span class="alarmstatus_2">已到达</span>';
					}else if(val.handleStatus=='3'){
						html='<span class="alarmstatus_3">已反馈</span>';
					}else{
						html='<span></span>';
					}
			        return html;
			      }
			}, {
				field : 'id',
				width : '8%',
				title : '操作',
				templet: function(val){
					var html='<a href="'+ctx+'/alarm/bphAlarmInfo/form?id='+val.id+'"><i style="color:#2fa4e7;" class="icon-pencil" title="修改"></i></a>' +
						'<a style="padding-left: 13px;" href="'+ctx+'/alarm/bphAlarmInfo/deleteAlarm?id='+val.id+'"' +
						' onclick="return confirmx(\'确认要删除该实时警情吗？\', this.href)"><i style="color:red;" class="icon-trash" title="删除"></i></a>'
					return html;
			      }
			}] ],
			page : true,
			done: function(res, curr, count){
			    $('#content').find('.layui-table-body').find("table" ).find("tbody").children("tr").on('click',function(){
			        var id = JSON.stringify($('#content').find('.layui-table-body').find("table" ).find("tbody").find(".layui-table-hover").data('index'));
			        var objId = res.data[id].id;
			    })
			}
		});
	});
	var incSubset=$.cookie('querySon');
	if(incSubset=='true'){
		$('#querySon').attr('checked',true);
	}else{
		$('#querySon').attr('checked',false);
	}
	
	$('#querySon').change(function(){
		if($(this).is(':checked')){
			$.cookie('querySon',true);
		}else{
			$.cookie('querySon',false);
		}
	})
}

function initTableAlarmType() {
	var alarmTypeSelectNode = $("<select id='stateTd'></select>");
	$.getJSON(ctx + '/sys/dict/listData?type=bph_alarm_info_state', function(datas) {
		for (var i = 0; i < datas.length; i++) {
			alarmTypeSelectNode.append("<option value='" + datas[i].value + "'>" + datas[i].label + "</option>");
		}
	})
	$("#alarmStateFromTd").append(alarmTypeSelectNode);
}

function deleteAlarm(id){
	layer.open({
		skin: 'layui-layer-lan',
		type : 1,
		title : "提示信息",
		area : [ "200px" , "140px" ],
		maxmin : false,
		btn : [ "确定" , "取消" ], // /可以无限个按钮
		content :'<div><span style="font-size:14px;color:red;"><b>确定将该警情改成无效警情？</b></span></div>',
		cancel : function() {
		},
		end : function() {
		},
		yes : function(index, layero) {
			var bphAlarmInfo = {};
			bphAlarmInfo.id = id;
			$.getJSON(ctx+ '/alarm/bphAlarmInfo/delete',bphAlarmInfo,function(data) {
				if(data == '1'){
					$('#alarmTable').remove();
					$('#orderSubmit').remove();
					$('#deleteAlarm').remove();
					$.jBox.tip('操作成功！');
					initTable();// 初始化表格
				}else{
					$.jBox.tip('操作失败！');
				}
			})
			layer.close(index); // 如果设定了yes回调，需进行手工关闭
		}
	});
	$(".layui-layer").css("border-radius", "10px");
	$(".layui-layer-title").css("border-radius", "10px 10px 0 0");
}
