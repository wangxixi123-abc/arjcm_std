<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>事件管理-事件归档</title>
    <meta name="decorator" content="default"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/ccm/event/css/ccmEventIncident.css"/>
    <script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
    <script src="${ctxStatic}/layer-v3.1.1/layer/layer.js" type="text/javascript"></script>
    <script src="${ctxStatic}/ccm/event/js/ccmEventIncident.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctxStatic}/plm/storage/ajaxMessageAlert.js"></script>
	<script>
		$(function(){
			$(".pimg").click(function(){
				var _this = $(this);//将当前的pimg元素作为_this传入函数
				imgShow("#outerdiv", "#innerdiv", "#bigimg", _this);
			});
		});
		function imgShow(outerdiv, innerdiv, bigimg, _this){
			var src = _this.attr("src");//获取当前点击的pimg元素中的src属性
			$(bigimg).attr("src", src);//设置#bigimg元素的src属性
			/*获取当前点击图片的真实大小，并显示弹出层及大图*/
			$("<img/>").attr("src", src).load(function(){
				var windowW = $(window).width();//获取当前窗口宽度
				var windowH = $(window).height();//获取当前窗口高度
				var realWidth = this.width;//获取图片真实宽度
				var realHeight = this.height;//获取图片真实高度
				var imgWidth, imgHeight;
				var scale = 0.8;//缩放尺寸，当图片真实宽度和高度大于窗口宽度和高度时进行缩放
				if(realHeight>windowH*scale) {//判断图片高度
					imgHeight = windowH*scale;//如大于窗口高度，图片高度进行缩放
					imgWidth = imgHeight/realHeight*realWidth;//等比例缩放宽度
					if(imgWidth>windowW*scale) {//如宽度扔大于窗口宽度
						imgWidth = windowW*scale;//再对宽度进行缩放
					}
				} else if(realWidth>windowW*scale) {//如图片高度合适，判断图片宽度
					imgWidth = windowW*scale;//如大于窗口宽度，图片宽度进行缩放
					imgHeight = imgWidth/realWidth*realHeight;//等比例缩放高度
				} else {//如果图片真实高度和宽度都符合要求，高宽不变
					imgWidth = realWidth;
					imgHeight = realHeight;
				}
				$(bigimg).css("width",imgWidth);//以最终的宽度对图片缩放
				var w = (windowW-imgWidth)/2;//计算图片与窗口左边距
				var h = (windowH-imgHeight)/2;//计算图片与窗口上边距
				$(innerdiv).css({"top":h, "left":w});//设置#innerdiv的top和left属性
				$(outerdiv).fadeIn("fast");//淡入显示#outerdiv及.pimg
			});
			$(outerdiv).click(function(){//再次点击淡出消失弹出层
				$(this).fadeOut("fast");
			});
		}
        function HandleTips(_this, id) {
            var html = '';
            html += '<div style="padding:10px;" >';
            html += '<p style="margin-botom:20px;">将事件发送至警情</p>';
            html += '<div>';
            html += '<input id="btnSuccess" onclick="Pass('
                + "&quot;"
                + id
                + "&quot;"
                + ')" class="btn btn-primary " type="button" value="确认" style="background: #73a839">';
            html += '<input id="btnPass"  onclick="NoPass('
                + "&quot;"
                + id
                + "&quot;"
                + ')" class="btn btn-primary" type="button" value="取消" style="background: #c71c22">';
            html += '</div>';
            html += '</div>';
            tip_index = layer.tips(html, _this, {
                tips : [ 1, '#20c694' ],
                time : 3000,
            });
        }
        function Pass(eventId) {
            $.post('${ctx}/alarm/bphAlarmInfo/eventToAlarmInfo?eventId='+ eventId,function(data){
                if(data.code == '200'){
                    debugger
                    setTimeout(function () {
                        window.location.reload();
                    }, 1000);

                    $.jBox.tip('操作成功！');

                }else{
                    $.jBox.tip('操作失败！');
                }
                layer.close(tip_index);
            })
        }
        function NoPass(id) {
            layer.close(tip_index);
        }
	</script>
    <script>
        //加急记录展示弹框
        function showRecord(id,tailCase) {

            var html = '';

            $.ajax({
                url: ctx + "/log/ccmLogTail/queryRecord?relevanceTable=ccm_event_incident&relevanceId=" + id + "&tailCase=" + tailCase,
                async : false,
                success: function (data) {
                    console.log("data长度---------------",data.length);
                    for (var i = 0; i < data.length; i++) {
                        html += '<div id="showRecord"><table class="table table-striped table-bordered table-condensed"><tr>';
                        html += '<td><label><span class="help-inline"></span>处理人姓名：</label>';
                        html += '<input id="tailPerson" readonly="readonly" value="' + data[i].tailPerson +'" style="width:170px;border: 1px solid #ccc;border-radius: 4px;padding: 4px 6px;color: white;" htmlEscape="false"  class="input-xlarge" /></td>';
                        html += '<td><label><span class="help-inline"></span>联系方式：</label>';
                        html += '<input id="more1" readonly="readonly" value="' + data[i].more1 +'" style="width:170px;border: 1px solid #ccc;border-radius: 4px;padding: 4px 6px;color: white;" htmlEscape="false"  class="input-xlarge" />';
                        html += '</td></tr><tr>';
                        html += '<td colspan="2"><label><span class="help-inline"></span>反馈信息：</label>';
                        html += '<input id="tailContent" readonly="readonly" value="' + data[i].tailContent +'" style="height: 100px;border: 1px solid #ccc;border-radius: 4px;padding: 4px 6px;color: white;" htmlEscape="false"  class="input-xxlarge" />';
                        html += '</td></tr></table></div>';
                        if (data.length > 1){
                            html += '<span>-----------------------------------------------------------------------------------------------------------------------------------------------<span>';
                        }
                    }

                    console.log("html----------------",html);

                    layer.open({
                        type: 1
                        , id: 'showRecord' //防止重复弹出
                        , content: html
                        , btn: ['关闭']
                        , area: ['625px;', '300px']
                        , shade: 0 //不显示遮罩
                        , title: data[0].tailCase + '记录'
                        , yes: function (index) {
                            layer.close(index);
                        }
                    });

                },error:function () {
                    alert("error!")
                }

            })



        }
    </script>
</head>
<body>
<%--<img  src="${ctxStatic}/images/shouyedaohang.png"; class="nav-home">--%>
<%--<span class="nav-position">当前位置 ：</span><span class="nav-menu"><%=session.getAttribute("activeMenuName")%>></span><span class="nav-menu2">事件管理</span>--%>
<ul class="back-list">
<div class="context" content="${ctx}"></div>
<ul class="nav nav-tabs">
    <li class="active" ><a class="nav-head" href="${ctx}/event/ccmEventIncident/archive">事件归档列表</a></li>
</ul>
<form:form id="searchForm" modelAttribute="ccmEventIncident"
           action="${ctx}/event/ccmEventIncident/archive" method="post"
           class="breadcrumb form-search clearfix">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden"
           value="${page.pageSize}"/>
    <ul class="ul-form pull-left">
        <li class="first-line"><label>发生时间：</label>
            <input name="beginHappenDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${ccmEventIncident.beginHappenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
        </li>
        <li class="first-line"><label>结束时间：</label> <input name="endHappenDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                     value="<fmt:formatDate value="${ccmEventIncident.endHappenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                     onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
        </li>
        <li class="first-line"><label>事件名称：</label> <form:input path="caseName"
                                             htmlEscape="false" maxlength="100" class="input-medium"/></li>
        <li class="first-line"><label>事件分级：</label> <form:select path="eventScale"
                                              class="input-medium">
            <form:option value="" label="全部"/>
            <form:options items="${fns:getDictList('ccm_case_grad')}"
                          itemLabel="label" itemValue="value" htmlEscape="false"/>
        </form:select></li>
        <li class="first-line"><label>事件性质：</label>
            <form:select path="property" class="input-medium">
                <form:option value="" label="全部"/>
                <form:options items="${fns:getDictList('bph_alarm_info_typecode')}"
                              itemLabel="label" itemValue="value" htmlEscape="false"/>
            </form:select>
        </li>
        <li class="second-line"><label>事件类型：</label> <form:select path="eventType"
                                              class="input-medium">
            <form:option value="" label="全部"/>
            <form:options items="${fns:getDictList('ccm_case_type')}" itemLabel="label" itemValue="value"
                          htmlEscape="false"/>
        </form:select></li>
        <li class="second-line"><label>事件模块分类：</label> <form:select path="eventKind"
                                                class="input-medium">
            <form:option value="" label="全部"/>
            <form:options items="${fns:getDictList('ccm_event_inci_kind')}" itemLabel="label" itemValue="value"
                          htmlEscape="false"/>
        </form:select></li>
        <li class="second-line"><label>发案地：</label>
            <sys:treeselect id="area" name="area.id" value="${ccmEventIncident.area.id}" labelName="area.name"
                            labelValue="${ccmEventIncident.area.name}" title="区域" url="/sys/area/treeData" cssClass=""
                            allowClear="true" notAllowSelectParent="true" cssStyle="width: 158px"/>
        </li>

<%--        <li class="clearfix"></li>--%>
    </ul>

<sys:message content="${message}"/>
    <div class="clearfix pull-right btn-box">

            <a href="javascript:;" id="btnSubmit" class="btn btn-primary" style="width: 49px;display:inline-block;float: right;">
                <i></i> <span style="font-size: 12px">查询</span> </a>

    </div>
</form:form>
<table id="contentTable"
       class="table table-striped table-bordered table-condensed table-gradient">
    <thead>
    <tr>
        <th><input id="allboxs" onclick="allcheck()" type="checkbox"/></th>
        <th>图片</th>
        <th width="14%">事件名称</th>
        <th>发生日期</th>
        <!-- <th>发案地</th> -->
        <th>事件分级</th>
        <th>事件类型</th>
        <th>事件性质</th>
        <th width="6%">发案地</th>
        <th>发生地详址</th>
        <th>事件模块分类</th>
        <shiro:hasPermission name="event:ccmEventIncident:edit">
            <th>操作</th>
        </shiro:hasPermission>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.list}" var="ccmEventIncident">
        <tr>
            <td><input name="boxs" type="checkbox" value="${ccmEventIncident.id}"/></td>
            <td width="100px">
						<img src="${ccmEventIncident.file1}"   class="pic-size pimg" <%--onclick="openPhoto('${ccmEventIncident.file1}')" --%>/>
            </td>
            <td style="white-space: nowrap;
overflow: hidden;
text-overflow: ellipsis; text-align: left;">
                <c:if test="${ccmEventIncident.stick eq 1}" var="zhiding">
                    <div class="stick"></div>
                </c:if>
                <c:if test="${not zhiding}">
                    <div class="nostick"></div>
                </c:if>
                <c:if test="${ccmEventIncident.ratify eq 1}" var="flag">
                    <div onclick="showRecord('${ccmEventIncident.id}','领导批示')" class="ratify" title="领导批示"></div>
                </c:if>
                <c:if test="${not flag}">
                    <div onclick="showRecord('${ccmEventIncident.id}','领导批示')" class="noratify" ></div>
                </c:if>
                <c:if test="${ccmEventIncident.historyLegacy eq 1}" var="lishi">
                    <div class="historyLegacy" title="历史遗留"></div>
                </c:if>
                <c:if test="${not lishi}">
                    <div class="nohistoryLegacy" ></div>
                </c:if>
                <c:if test="${ccmEventIncident.urgent eq 1}" var="jiaji">
                    <div onclick="showRecord1('${ccmEventIncident.id}','加急')" class="urgent" title="加急"></div>
                </c:if>
                <c:if test="${not jiaji}" >
                    <div onclick="showRecord1('${ccmEventIncident.id}','加急')" class="nourgent" ></div>
                </c:if>
<%--                <a style="padding-left: 10px;"--%>
<%--                   onclick="parent.LayerDialog('${ctx}/event/ccmEventIncident/form?id=${ccmEventIncident.id}', '','1200px', '800px')">--%>
                        ${ccmEventIncident.caseName}
<%--                </a>--%>
            </td>
            <td><fmt:formatDate value="${ccmEventIncident.happenDate}"
                                pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <%-- <td>${ccmEventIncident.casePlace}</td> --%>
            <td><span
                    class="eventScaleCss eventScaleCss-${ccmEventIncident.eventScale}">${fns:getDictLabel(ccmEventIncident.eventScale, 'ccm_case_grad', '')}</span>
            </td>
            <td>${fns:getDictLabel(ccmEventIncident.eventType, 'ccm_case_type', '')}
            </td>
            <td>${fns:getDictLabel(ccmEventIncident.property, 'bph_alarm_info_typecode', '')}</td>
            <td>${ccmEventIncident.area.name}</td>
            <td class="tp">${ccmEventIncident.happenPlace}</td>
            <th>${fns:getDictLabel(ccmEventIncident.eventKind, 'ccm_event_inci_kind', '')}</th>
            <td>
                <!-- 事件登记编辑权限  --> <shiro:hasPermission
                    name="event:ccmEventIncident:view">

                <a class="btnList" href="${ctx}/event/ccmEventIncident/archiveForm?id=${ccmEventIncident.id}"><i class="icon-list-alt"></i></a>
            </shiro:hasPermission>

            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
	<div id="outerdiv" style="position:fixed;top:0;left:0;background:rgba(0,0,0,0.7);z-index:2;width:100%;height:100%;display:none;">
		<div id="innerdiv" style="position:absolute;">
			<img id="bigimg" style="border:5px solid #fff;" src="" />
		</div>
	</div>
<div class="pagination" style="float: right; margin-top: 12px">${page}</div>
</ul>
</body>
</html>