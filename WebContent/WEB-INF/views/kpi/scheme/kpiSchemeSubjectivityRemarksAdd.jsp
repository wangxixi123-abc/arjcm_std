<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<html>
<head>
<title>绩效主观评分添加管理</title>
<meta name="decorator" content="default" />
<link
	href="${ctxStatic}/jquery-ztree/3.5.12/css/zTreeStyle/zTreeStyle.min.css"
	rel="stylesheet" type="text/css" />
<script src="${ctxStatic}/jquery/jquery-1.9.1.min.js"></script>
<script
	src="${ctxStatic}/jquery-ztree/3.5.12/js/jquery.ztree.all-3.5.js"
	type="text/javascript"></script>
	
<style>
.selects-tr.active{
cursor: pointer;
}
.selects-tr.active td{
 background:#1684c2!important;
 color: #fff!important;
 }

	  select {
	   width:auto;
	   min-height:190px!important;
	   border:none!important;
	   appearance:none!important;
       -moz-appearance:none!important;
      -webkit-appearance:none!important;
      outline: none;
      }
      select option{
      line-height: 20px!important;
      }
  
      select:FOCUS{
        outline: none;
      }
      select::-webkit-scrollbar {
      display: none
      }
        select::-moz-scrollbar {
      display: none
      }
          select::-ms-scrollbar {
      display: none
      }
          select::-o-scrollbar {
      display: none
      }
     select::scrollbar {
      display: none
      }
      #selectsTbody td input{
      margin-bottom: 2px;
      }
     
 </style>	
	
<script type="text/javascript">
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a
			href="${ctx}/scheme/kpiSchemeSubjectivity/remarksAdd?id=${id}&remarks=${remarks}">绩效主观评分添加</a></li>
	</ul>
	&nbsp;&nbsp;&nbsp;
	<label>姓&nbsp;&nbsp;&nbsp;名：</label>
	<input id="namePop" class="input-medium" />
	<input id="btnSubmit" class="btn btn-primary" onclick="seletePop()"
		type="button" value="查询" />
	<script>
		function seletePop() {
			var namePop = $("#namePop").val();
			$('#QrgPop').load(
					"${ctx}/scheme/kpiSchemeSubjectivity/pop?name=" + namePop);
		}
	</script>
	<br>

	<div class="row-fluid">
		<div class="span4" style="margin-left: 35px">
			<h4>部门</h4>
			<div style="height: 200px; overflow: auto; border: 1px solid #ccc;">
				<div id="QrgZtree" class="ztree"></div>
			</div>
			<h4>人员</h4>
			<div style="height: 200px; overflow: auto; border: 1px solid #ccc;">
				<div class="" id="QrgPop"></div>
			</div>
		</div>
		<div class="span1" style="height: 441px">
			<table style="width: 100%; height: 100%">
				<tr>
					<td align="center">
						<table>
							<tr>
								<td align="center"><input type="button" class="button"
									value=" -> " onclick="javascript:rightMove();" /><br /></td>
							</tr>
							<tr>
								<td align="center"><input type="button" class="button"
									value=" <- " onclick="javascript:leftMove();" /><br /></td>
							</tr>
							<tr>
								<td align="center"><input type="button" class="button"
									value="重置 " onclick="javascript:clean();" /></td>
							</tr>
						</table>

					</td>
				</tr>

			</table>
		</div>
		<div class="span6">

			<h4>已选择</h4>
			<div style="height: 420px; overflow: auto; border: 1px solid #ccc;">
				<div class="" id="selects"  style="height: 380px;overflow: auto;">
					<table id="contentTable"
						class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th>评分人</th>
								<th>权重</th>
							</tr>
						</thead>
						<tbody id="selectsTbody" ondblclick="javascript:leftMove();"></tbody>
					</table>
				</div>
			   <select id="choose_sel" multiple="true" 	ondblclick="javascript:leftMove();" style="display: none"></select>
	           <input id="" style="margin: 5px 5px;float: right;" class="btn btn-primary" onclick="saveBtn()" type="button" value="保 存 ">
			</div>
		</div>
	</div>
<script>
	//部门
	var setting = {
		data : {
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "pId",
				rootPId : '0'
			}
		},
		callback : {
			onClick : onClickTree
		}
	};
	function onClickTree(event, treeId, treeNode) {
		var id = treeNode.id == '0' ? '' : treeNode.id;
		$('#QrgPop').load("${ctx}/scheme/kpiSchemeSubjectivity/pop?office.id="+ id + "&office.name=" + treeNode.name+ "&office.parentIds=," + id + ",")
	}
	function refreshTree() {
		$.getJSON("${ctx}/view/vCcmTeam/treeData", function(data) {
			$.fn.zTree.init($("#QrgZtree"), setting, data).expandAll(true);
		});
	}
	var remarks = "${remarks}";
		$(function() {
			
			refreshTree();
			
			var html = "";
					if(remarks!=""){
						var ls = new Array();						
						ls = remarks.split(";");
						for(var i=0;i<ls.length-1;i++){
							var lss = new Array();
							lss = ls[i].substring(1, ls[i].length-1).split(",");
							html += '<tr id="'+lss[0]+'" class="selects-tr" onclick="CheckActive(this)" ondblclick="returnCheckActive();">';
							html += '<td width="50%" style="word-break:break-all;word-wrap:break-word;" class="val-td" data='+lss[0]+','+lss[1]+'>'+lss[1]+'</td>';
							html += '<td width="50%" valign="middle"><input type="text" value="'+lss[2]+'" class="input-mini val-input"></td>';
							html += '</tr>';
							
							var choose_sel = document.getElementById("choose_sel");
							var s = choose_sel.options.length;
							choose_sel.options[s++] = new Option(lss[0]+','+lss[1], lss[0]);

							
						}
					}
			$("#selectsTbody").html(html);
		})
		function rightMove() {
			debugger;
			var brand_sel = document.getElementById("brand_sel");
			var choose_sel = document.getElementById("choose_sel");

			var brand_options = brand_sel.options;
			var s = choose_sel.options.length;
			var html = "";
			for (var i = 0; i < brand_options.length; i++) {
				var is_selected = brand_options[i].selected;
				if (is_selected) {
					var option = new Option(brand_options[i].text,brand_options[i].value);
					if (!contains(choose_sel, option)) {
					    choose_sel.options[s++] = new Option(brand_options[i].text, brand_options[i].value);
					  	html += '<tr id="'+brand_options[i].value+'" class="selects-tr" onclick="CheckActive(this)" ondblclick="returnCheckActive();">';
						html += '<td width="50%" style="word-break:break-all;word-wrap:break-word;" class="val-td" data='+brand_options[i].value+','+brand_options[i].text+'>'+brand_options[i].text+ '</td>';
						html += '<td width="50%"><input type="text" value="0" class="input-mini val-input"></td>';
						html += '</tr>'; 
					}else{
						top.$.jBox.tip(brand_options[i].text+'已存在，请勿重复添加')
					}
				}
			}
			$('#selectsTbody').append(html)
		}
		function leftMove() {
			$('#selectsTbody tr.selects-tr.active').each(function(){
				var active=$(this);
				active.remove();
				$("#choose_sel>option").each(function() {
					var option = $(this);
					if(option.val()==active.attr('id')){
						option.remove();
					}
				})
			})
					
		/* 	$("#choose_sel>option").each(function() {
					var option = $(this);
					if (option[0].selected) {
						option.remove();
						$('#' + option.val()).remove()
					}
				}); */
	}
	function clean() {

		$("#choose_sel>option").each(function() {
			$(this).remove();
		});
		$("#selectsTbody tr.selects-tr").each(function(){
			$(this).remove();
		})

	}

	function selectChoose() {
		$("#choose_sel>option").attr("selected", "true");
		return true;
	}
	function contains(obj_sel, option) {
		var options = obj_sel.options;
		for (var i = 0; i < options.length; i++) {
			if (options[i].value == option.value) {
				return true;
			}
		}

		return false;
	}
	//定义setTimeout执行方法
	var time = null;
	function CheckActive(_this) {
		 // 取消上次延时未执行的方法
	    clearTimeout(time);
	    time = setTimeout(function(){
	    	if ($(_this).hasClass('active')) {
				$(_this).removeClass('active')
			} else {
				$(_this).addClass('active')
			}
	    },200);
		
	}
	function returnCheckActive(){
		 // 取消上次延时未执行的方法
	    clearTimeout(time);
	}
	//保存
	function saveBtn(){
		var valData="";
		var valData1="";
		var id="${id}";
		var sum = 0;
		$("#selectsTbody tr.selects-tr").each(function(){
			var val=$(this).children('.val-td').attr("data");
			var val1=$(this).children('.val-td').html();
			var valIndex=$(this).children().children('.val-input').val()||0
			valData+='['+val+','+valIndex+'];'
			valData1+='['+val1+','+valIndex+'];\n'
			sum+=valIndex*1.0;
		})
		if(sum==1){
			var frame = parent.document.getElementById("relationshipId").getElementsByTagName("iframe")[0].contentWindow;
			frame.document.getElementById(id).value=valData1;
			frame.document.getElementById(id).setAttribute("data", valData);
			var index = parent.layer.getFrameIndex(window.name); 
			parent.layer.close(index);
		}else{
			top.$.jBox.tip('权重和应该为1 ');
		}
		
	}
</script>
</body>
</html>