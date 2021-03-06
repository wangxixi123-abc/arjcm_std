<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效客观KPI得分管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					$("#btnSubmit").attr("disabled", true);
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#btnSubmit").removeAttr('disabled');
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			
			

			$(".update").click(function(){
				var kid = $(this).attr("id");
				var schemeId=$("#schemeId").val();
				var tdLst=$(this).parents(".tr").children(".ftd");
			    /* var magnum=0; */
			    var flag=true;
				parent.$.jBox.confirm("是否确认修改分数？", "系统提示", function(v, h, f) {
					if (v == "ok") {
						$.each(tdLst,function(i,item){
							var userId = $(item).children("[name=userId]").val();
							var kpiScore = $(item).children("[name=kpiScore]").val();
							var kpiId= $(item).children("[name=kpiId]").val();
							var MaxScore=$(item).children("[name=maxScore]").val();

                            if(Number(kpiScore)>Number(MaxScore)){//如果当前分数大于满分，禁止提交
                            	parent.$.jBox.tip('打分不能超过最高分值！ ');
                            	$(item).children("[name=kpiScore]").focus();
                            	flag=false;
                            	return false
                            }
						    $.post('${ctx}/score/kpiSchemeScore/save/', {
						    	"userId.id": userId, 
						    	kpiId: kpiId, 
						    	score: kpiScore, 
						    	schemeId: schemeId, 
						    	date: new Date().getTime()
						    }, function(mag) {
						    	/* magnum+=mag; */
						    	flag=true;
						    });
						});
						if(flag){
							parent.$.jBox.tip('打分成功！ ');
						}
					/* 	if(magnum>0){
							parent.$.jBox.tip('打分成功！ ');
						}else{
							parent.$.jBox.tip('打分失败！ ');
						} */
					} else {
						
					}
				}, {
					buttonsFocus : 1
				});
			});
		
			//批量修改
			$("#alltj").click(function(){
				var alltr = $("#ttt").children(".tr");
				var flag=true;
				var schemeId=$("#schemeId").val();
				$(alltr).each(function(i,dome){
					var tdLst=$(dome).children(".ftd");
					var kid = $(dome).children(".update").attr("id");			
					$.each(tdLst,function(j,item){
						var userId = $(item).children("[name=userId]").val();			
						var kpiScore = $(item).children("[name=kpiScore]").val();
						var kpiId=$(item).children("[name=kpiId]").val();
						var MaxScore=$(item).children("[name=maxScore]").val();

                        if(Number(kpiScore)>Number(MaxScore)){//如果当前分数大于满分，禁止提交
                        	parent.$.jBox.tip('打分不能超过最高分值！ ');
                        	$(item).children("[name=kpiScore]").focus();
                        	flag=false;
                        	return false
                        }

					    $.post('${ctx}/score/kpiSchemeScore/save/', {
					    	"userId.id": userId, 
					    	kpiId: kpiId, 
					    	score: kpiScore, 
					    	schemeId: schemeId, 
					    	date: new Date().getTime()
					    }, function(mag) {
					    	magnum+=mag;
					    });
					});
				});
				if(flag){
					parent.$.jBox.tip('打分成功！ ');
				}
			});
			
			
		});
		

		//验证提醒改变	
		function checkChange(obj) {
			var now = $(obj).val();
			var old = $(obj).parents("td").children(".hidval").val();
			if(parseFloat(now)!=parseFloat(old)){
				$(obj).css("border-color","#2d6aed");
			}else{
				$(obj).css("border-color","#ece9d8");
			}
		}
		
		
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/score/kpiSchemeScore/">数据列表</a></li>
		<li class="active"><a href="${ctx}/score/kpiSchemeScore/form?id=${kpiScheme.id}">数据录入</a></li>
	</ul><br/>
	
	<div id="pw_search_table">
		    <table id="pw_table" class="table table-striped table-bordered table-condensed">
		    	<thead>
					<tr>
						<th colspan="9" id="pw_result_title" class="pw_background">
							<div id="pw_page_wrapper">
								<div id="pw_page_left">
									<span>正在为【${kpiScheme.name}】打分!</span>
								</div>
								<c:if test="${kpiScheme.state eq '1'}">
									<button type="button" id="alltj" class="button positive" style="float: right;" >
	    									提交所有数据
	   								</button>
									
   								</c:if>
						    </div>
						    <input type="hidden" name="schemeId" id="schemeId" value="${kpiScheme.id}"/>
					  </th>
				</tr>
				</thead>
				<tbody id="ttt">
			    	<tr id="pw_result_title"  class="pw_text_center">
						<td width="10%">工号</td>
						<td width="15%">姓名</td>
							<c:forEach items="${kpirow}" var="kpi">
							   <td width="15%">${kpi.name}&nbsp;&#40;${kpi.score}&#41;
									<button onclick="parent.LayerDialog1('','${ctx}/report/ccmReportOthers/logBookOffice?kpiSchemeId=${kpiScheme.id}&kpiId=${kpi.id}', '日常工作数据详情', '1800px', '700px')" type="button" class="button positive" style="margin: 0px 20px" >
	    									日常数据录入
	   								</button>
								</td>
							</c:forEach>
						<td width="20%">操作</td>
					</tr>
					<c:forEach items="${lstScore}" varStatus="i" var="staffScore">
						<c:if test="${i.index%2==0}">
						 	<tr class="pw_background odd tr">
						</c:if> 
						<c:if test="${i.index%2!=0}">
						  	<tr class="even tr">
						</c:if>   
		                	<td class="staffNo">${staffScore.user.no }</td>
		                    <td>${staffScore.user.name }</td>
		                    <c:forEach items="${kpirow}" var="kpis">
			                    <td class="ftd">
				                    <input maxlength="6"  type="text" id="${kpis.id}-${staffScore.user.id}" max-score="${kpis.score}" class="${staffScore.user.no}_score" onchange="checkChange(this);" name="kpiScore"  
				                    <c:forEach items="${staffScore.kpiScoreList}" var="score">
				                    	<c:if test="${score.kpiId eq kpis.id}">value='${score.score}'</c:if>
				                    </c:forEach>  
				                    style="width:100px; border-color:#ece9d8"> 
				                    
		                   			<input type="hidden"  class="hidval" 
		                   				<c:forEach items="${staffScore.kpiScoreList}" var="score">
		                   					<c:if test="${score.kpiId eq kpis.id}">value='${score.score}'</c:if>
		                   				</c:forEach> />
				                    <input type="hidden" value="${kpis.score}" name="maxScore"/>
				                    <input type="hidden" value="${kpis.id}" name="kpiId"/>
				                    <input type="hidden" value="${staffScore.user.id}" name="userId"/>
			                    </td>
		                    </c:forEach>
		                    <td>
		                    	<c:if test="${kpiScheme.state eq '1'}">
		                   			<input class="update" type="button" id="${staffScore.user.id}" value="确认修改"/>
		                   		</c:if>
		                   		<c:if test="${kpiScheme.state eq '2'}">
		                   			<span style='color:red'>${fns:getDictLabel(kpiScheme.state, 'kpi_scheme_state', '')}</span>
		                   		</c:if>
						    </td>               
					</c:forEach>
				</tbody>
			</table>
         		<div class="pw_clear"></div>
		</div>



</body>
</html>