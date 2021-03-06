<%@ taglib prefix="shiiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <meta name="decorator" content="default"/>
    <title>事件管理</title>
    <link href="${ctxStatic}/form/css/form.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctxStatic}/ccm/event/css/fishBone.css"/>
    <script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctxStatic}/ccm/event/js/fishBone.js"></script>
    <script type="text/javascript" src="${ctxStatic}/ccm/event/js/jquery.SuperSlide.2.1.1.js"></script>
    <script type="text/javascript">
        $(document).ready(
            function () {
                //$("#name").focus();
                if("${isDispatch}"=="1"){
                    $(".disabled1").attr("disabled", true);
                    $(".hide1").css('display','none');
                    $("#file1").attr("readonly",true);
                    $("#dealForm")
                        .validate(
                            {
                                submitHandler : function(form) {
                                    $("#btnDealSubmit").attr("disabled", true);
                                    loading('正在提交，请稍等...');
                                    form.submit();
                                },
                                errorContainer : "#messageBox",
                                errorPlacement : function(error, element) {
                                    $("#btnDealSubmit").removeAttr('disabled');
                                    $("#messageBox").text("输入有误，请先更正。");
                                    if (element.is(":checkbox")
                                        || element.is(":radio")
                                        || element.parent().is(
                                            ".input-append")) {
                                        error.appendTo(element.parent()
                                            .parent());
                                    } else {
                                        error.insertAfter(element);
                                    }
                                }
                            });
                }
                $("#EventDetailBtn").click(function () {
                    $("#EventDetailTable").toggle();
                });
                $("#inputForm").validate({
                    submitHandler: function (form) {
                        $("#btnSubmit").attr("disabled", true);
                        loading('正在提交，请稍等...');
                        form.submit();
                    },
                    errorContainer: "#messageBox",
                    errorPlacement: function (error, element) {
                        $("#btnSubmit").removeAttr('disabled');
                        $("#messageBox").text("输入有误，请先更正。");
                        if (element.is(":checkbox")
                            || element.is(":radio")
                            || element.parent().is(
                                ".input-append")) {
                            error.appendTo(element.parent()
                                .parent());
                        } else {
                            error.insertAfter(element);
                        }
                    }
                });
                $("td").css({"padding": "8px"});
                $("td").css({"border": "0px dashed #CCCCCC"});
                var jsonString = '${CcmEventCasedealList}';
                data = JSON.parse(jsonString);
                //创建事件历史
                $(".fishBone1").fishBone(data, '${ctx}', 'deal');
                $(".fishBone2").fishBone(data, '${ctx}', 'read');
            });


        // 选中涉及线路时显示所属线路字段
        function xianLu(value) {
            if (value == '03') {
                $("#xianlu").show();
            } else {
                $("#xianlu").hide();
            }
        }


        function selectChange() {
            var temp = $("#test1 option:selected").val();

            if (temp != '01') {
                $("#styleType").removeClass("input-xlarge ident0 card")
                $("#styleType").addClass('input-xlarge')
            } else {
                $("#styleType").removeClass('input-xlarge')
                $("#styleType").addClass('input-xlarge ident0 card')
            }

        }

        function saveForm() {
            var area = $("#areaId").val();
            var html1 = '<label for="" class="error">必选字段 *<label>';
            //alert(officeId.length);
            if (area.length != 0) {
                $("#show1").html("*");
            } else {
                $("#show1").html(html1);
            }

            if (area.length != 0) {
                $("#inputForm").submit();
            }

        }

        function ThisLayerDialog(src, title, height, width) {
            parent.drawForm = parent.layer.open({
                type: 2,
                title: title,
                area: [height, width],
                fixed: true, //固定
                maxmin: false,
                /*   btn: ['关闭'], //可以无限个按钮 */
                content: src,
                zIndex: '1992',
                cancel: function () {
                    //防止取消和删除效果一样
                    window.isCancel = true;
                },
                end: function () {
                    if (!window.isCancel) {
                        $("#areaPoint")[0].value = parent.areaPoint;
                        parent.areaPoint = null;
                        $("#areaMap")[0].value = parent.areaMap;
                        parent.areaMap = null;
                    }
                    window.isCancel = null;
                }
            });
        }
        function dealForm() {
            var handleUserId = $("#handleUserId").val();
            var html1 = '<label for="" class="error">必填信息 *<label>';
            //alert(officeId.length);
            if (handleUserId.length != 0) {
                $("#show2").html("*");
            } else {
                $("#show2").html(html1);
            }

            if (handleUserId.length != 0) {
                $("#dealForm").submit();
            }

        }
    </script>
    <link href="/arjccm/static/bootstrap/2.3.1/css_input/input_Custom.css" type="text/css" rel="stylesheet">
</head>
<body>
<ul class="nav nav-tabs">
    <li class="active"><a
            href="${ctx}/event/ccmEventIncident/form?id=${ccmEventIncident.id}">
<%--        <c:if name="event:ccmEventIncident:edit">--%>
        <shiro:hasPermission name="event:ccmEventIncident:edit">
            <c:if test="${not empty ccmEventIncident.id}">
                <c:if test="${isDispatch eq 1}">任务指派</c:if>
                <c:if test="${isDispatch ne 1}">事件修改</c:if>
            </c:if>
            <c:if test="${empty ccmEventIncident.id}">事件添加</c:if>
<%--        ${not empty ccmEventIncident.id?${isDispatch eq 1}?'指派':'修改':'添加'}--%>
        </shiro:hasPermission>
        <shiro:lacksPermission name="event:ccmEventIncident:edit">查看</shiro:lacksPermission></a></li>
</ul>
<form:form id="inputForm" modelAttribute="ccmEventIncident"
           action="${ctx}/event/ccmEventIncident/save" method="post"
           class="form-horizontal">
    <form:hidden path="id"/>
    <form:hidden path="otherId"/>
    <sys:message content="${message}"/>
    <table border="0px" style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
        <tr>
            <td colspan="2" style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件名称：</label>
                    <div class="controls">
                        <form:input path="caseName" htmlEscape="false"
                                    maxlength="100" class="input-xlarge disabled1 required"/>

                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件情况：</label>
                    <div class="controls">
                        <form:textarea path="caseCondition"
                                       htmlEscape="false" rows="2" maxlength="4000" class="input-xxlarge disabled1 required"/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div>
                    <label class="control-label">事件图标：</label>
                    <div class="controls">
                        <form:hidden id="file1" path="file1" htmlEscape="false" maxlength="200" class="input-xxlarge"/>
                        <sys:ckfinder input="file1" type="images" uploadPath="/event/ccmEventIncident"
                                      selectMultiple="false"/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red" id="show1">*</font></span>发案地：</label>
                    <div class="controls">
                        <sys:treeselect id="area" name="area.id"
                                        value="${ccmEventIncident.area.id}" labelName="area.name"
                                        labelValue="${ccmEventIncident.area.name}" title="区域"
                                        url="/event/ccmEventIncident/treeDataOfEvent" cssClass="" allowClear="true"
                                        notAllowSelectParent="true" cssStyle=""/>

                    </div>
                </div>
            </td>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"> <span class="help-inline"><font color="red">*</font></span>发生日期：</label>
                    <div class="controls">
                        <input name="happenDate" type="text"
                               readonly="readonly" maxlength="20" class="input-medium Wdate disabled1 required"
                               value="<fmt:formatDate value="${ccmEventIncident.happenDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>

                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label">发案地代码：</label>
                    <div class="controls">
                        <form:input path="address" htmlEscape="false" maxlength="6" class="disabled1 input-xlarge"/>
                    </div>
                </div>
            </td>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>发生地详址：</label>
                    <div class="controls">
                        <form:input path="happenPlace" htmlEscape="false" maxlength="200"
                                    class="input-xlarge disabled1 required"/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件模块分类：</label>
                    <div  class="controls">
                        <form:select onchange="xianLu(this.value)" path="eventKind" class="input-xlarge disabled1 required" style="width:284px">
                            <form:options items="${fns:getDictList('ccm_event_inci_kind')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label">事件编号：</label>
                    <div class="controls">
                        <form:input path="number" htmlEscape="false"
                                    maxlength="100" class="input-xlarge disabled1"/>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件类别：</label>
                    <div class="controls">
                        <form:select path="eventSort" class="input-xlarge disabled1 required" style="width:284px">
                            <form:options items="${fns:getDictList('ccm_event_sort')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label">事件规模：</label>
                    <div class="controls">
                        <form:select path="caseScope" class="input-xlarge disabled1 required" style="width:284px">
                            <form:options items="${fns:getDictList('ccm_event_scope')}"
                                          itemLabel="label" itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
                <%--				<td style="padding: 8px;border: 1px dashed #CCCCCC">
                                    <div>
                                        <label class="control-label">区域图：</label>
                                        <div class="controls">
                                            <form:input path="areaMap" readonly="true" htmlEscape="false"
                                        maxlength="2000" class="input-xlarge " />
                                        </div>
                                    </div>
                                </td>--%>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>中心点：</label>
                    <div class="controls">
                        <form:input path="areaPoint" readonly="true" htmlEscape="false"
                                    maxlength="40" class="input-xlarge disabled1 required"/>
                            <%--							<input id="draw" class="btn btn-primary" onclick="drawPoint()" type="button"--%>
                            <%--								   value="标 注" />--%>
                    </div>
                </div>
            </td>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>区域图：</label>
                    <div class="controls">
                        <form:input path="areaMap" readonly="true" htmlEscape="false"
                                     class="input-xlarge disabled1 required"/>
                        <a onclick="ThisLayerDialog('${ctx}/event/ccmEventIncident/drawForm?areaMap='+$('#areaMap').val()+'&areaPoint='+$('#areaPoint').val(), '标注', '1100px', '700px');"
                           class="btn hide1 btn-primary">标 注</a>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件分级：</label>
                    <div class="controls">
                        <form:radiobuttons path="eventScale"
                                           items="${fns:getDictList('ccm_case_grad')}" itemLabel="label"
                                           itemValue="value" htmlEscape="false" class="required disabled1"/>
                    </div>
                </div>
            </td>
            <td style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label">是否破案：</label>
                    <div class="controls">
                        <form:radiobuttons path="typeSolve"
                                           items="${fns:getDictList('yes_no')}" itemLabel="label"
                                           itemValue="value" htmlEscape="false" class="disabled1"/>
                    </div>
                </div>
            </td>
        </tr>
        <tr id="xianlu" hidden="hidden">
            <td colspan="2" style="padding: 8px;border: 0px dashed #CCCCCC">
                <div>
                    <label class="control-label">所属线、路：</label>
                    <div class="controls">
                        <sys:treeselect id="line" name="line.id" value="${ccmEventIncident.line.id}"
                                        labelName="line.name" labelValue="${ccmEventIncident.line.name}"
                                        title="线、路名称" url="/event/ccmEventIncident/treeData" cssClass=""
                                        allowClear="true" notAllowSelectParent="true" cssStyle="width: 220px"/>
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <br/>
    <div>
        <h4 class="tableNamefirst" id="EventDetailBtn"
            style="cursor: pointer;">
            高级<i class=" icon-share-alt"></i>
        </h4>
        <table id="EventDetailTable" border="0px"
               style="display: none;border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件性质：</label>
                        <div class="controls">
                            <form:select path="property" class="input-xlarge disabled1 required" style="width:284px">
                                <form:options items="${fns:getDictList('bph_alarm_info_typecode')}"
                                              itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label"><span class="help-inline"><font color="red">*</font></span>事件类型：</label>
                        <div class="controls">
                            <form:select path="eventType" class="input-xlarge disabled1 required" style="width:284px">
                                <form:options items="${fns:getDictList('ccm_case_type')}"
                                              itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">主犯（嫌疑人）姓名：</label>
                        <div class="controls">
                            <form:input path="culName" htmlEscape="false"
                                        maxlength="80" class="disabled1 input-xlarge "/>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">是否历史遗留：</label>
                        <div class="controls">
                            <form:radiobuttons path="historyLegacy"
                                               items="${fns:getDictList('yes_no')}" itemLabel="label"
                                               itemValue="value" htmlEscape="false" class="disabled1"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">是否置顶：</label>
                        <div class="controls">
                            <form:radiobuttons path="stick"
                                               items="${fns:getDictList('yes_no')}" itemLabel="label"
                                               itemValue="value" htmlEscape="false" class="disabled1"/>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">是否加急：</label>
                        <div class="controls">
                            <form:radiobuttons path="urgent" items="${fns:getDictList('yes_no')}" itemLabel="label"
                                               itemValue="value" htmlEscape="false" class="disabled1"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">主犯（嫌疑人）证件类型：</label>
                        <div class="controls">
                            <form:select id="test1" path="culPapercode" onchange="selectChange()" class="input-xlarge "
                                         items="${fns:getDictList('legal_person_certificate_type')}" itemLabel="label"
                                         itemValue="value" htmlEscape="false" style="width:284px">
                            </form:select>
                        </div>
                    </div>
                </td>

                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">主犯（嫌疑人）证件号码：</label>
                        <div class="controls">
                            <form:input path="culPaperid" id="styleType"
                                        htmlEscape="false" maxlength="50" class="input-xlarge disabled1 ident0 card"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">作案人数：</label>
                        <div class="controls">
                            <form:input path="numCrime" htmlEscape="false"
                                        maxlength="6" class="input-xlarge disabled1 digits" type="number"/>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">在逃人数：</label>
                        <div class="controls">
                            <form:input path="numFlee" htmlEscape="false"
                                        maxlength="6" class="input-xlarge disabled1 digits" type="number"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">抓捕人数：</label>
                        <div class="controls">
                            <form:input path="numArrest" htmlEscape="false"
                                        maxlength="6" class="input-xlarge disabled1 digits" type="number"/>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">侦查终结日期：</label>
                        <div class="controls">
                            <input name="caseOverDay" type="text"
                                   readonly="readonly" maxlength="20" class="input-medium disabled1 Wdate "
                                   value="<fmt:formatDate value="${ccmEventIncident.caseOverDay}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">事件上报人评价：</label>
                        <div class="controls">
                            <form:textarea path="caseSolve"
                                           htmlEscape="false" rows="4" maxlength="4000" class="disabled1 input-xlarge "/>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">处理状态：</label>
                        <div class="controls">
                            <form:select path="status" class="input-xlarge disabled1" style="width:284px">
                                <c:if test="${empty ccmEventIncident.id}"><form:option value="01" label="未处理"/></c:if>
                                <c:if test="${not empty ccmEventIncident.id}">
                                    <form:options items="${fns:getDictList('ccm_event_status')}" itemLabel="label"
                                                  itemValue="value" htmlEscape="false"/>
                                </c:if>
                            </form:select>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">附件一：</label>
                        <div class="controls">
                            <form:hidden id="file2" path="file2" htmlEscape="false" maxlength="24"
                                         class="input-xlarge"/>
                            <sys:ckfinder input="file2" type="files" uploadPath="/event/ccmEventIncident"
                                          selectMultiple="true"/>
                        </div>
                    </div>
                </td>
                <td style="padding: 8px;border: 0px dashed #CCCCCC">
                    <div>
                        <label class="control-label">附件二：</label>
                        <div class="controls">
                            <form:hidden id="file3" path="file3" htmlEscape="false" maxlength="24"
                                         class="input-xlarge"/>
                            <sys:ckfinder input="file3" type="files" uploadPath="/event/ccmEventIncident"
                                          selectMultiple="true"/>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2"><label class="control-label">备注信息：</label>
                    <div class="controls">
                        <form:textarea path="remarks" htmlEscape="false" rows="4"
                                       maxlength="255" class="input-xxlarge disabled1"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <c:if test="${isDispatch ne '1'}">
        <div class="form-actions">
            <shiro:hasPermission name="event:ccmEventIncident:edit">
                <input id="btnSubmit" class="btn btn-primary" onclick="saveForm()" type="button"
                       value="保 存"/>&nbsp;</shiro:hasPermission>
        </div>
    </c:if>
</form:form>
    <c:if test="${isDispatch eq '1'}">
        <br />
        事件指派信息：
        <br/>
        <form:form id="dealForm" modelAttribute="ccmEventCasedeal"
                   action="${ctx}/event/ccmEventCasedeal/saveCasedealCommon"
                   method="post" class="form-horizontal">
            <form:hidden path="id" />
            <form:hidden path="objId" value="${ccmEventIncident.id}" />
            <form:hidden path="objType" value="ccm_event_incident" />
            <form:hidden path="handleDate" />
            <form:hidden path="handleStep" />
            <input id="handleStatus" name="handleStatus" type="hidden" value="01" />
            <form:hidden path="handleFeedback" />
            <form:hidden path="checkDate" />
            <form:hidden path="checkUser" />
            <form:hidden path="checkOpinion" />
            <form:hidden path="checkScore" />
            <sys:message content="${message}" />
            <table border="0px"
                   style="border-color: #CCCCCC; border: 0px solid #CCCCCC; padding: 10px; width: 100%;">
                <tr>
                    <td><label class="control-label"><span class="help-inline"><font color="red" id="show2">*</font></span>处理人员：</label>
                        <div class="controls">
                            <sys:treeselect id="handleUser" name="handleUser.id"
                                            value="${ccmEventCasedeal.handleUser.id}"
                                            labelName="handleUser.name"
                                            labelValue="${ccmEventCasedeal.handleUser.name}" title="用户"
                                            url="/event/ccmEventIncident/officeTreeData?type=3" cssClass="" allowClear="true"
                                            notAllowSelectParent="true" />
						</span>
                        </div></td>
                </tr>
                <tr>
                    <td><label class="control-label"><span class="help-inline"><font color="red">*</font> </span>处理截至时间：</label>
                        <div class="controls">
                            <input name="handleDeadline" type="text" readonly="readonly"
                                   maxlength="20" class="input-medium Wdate required"
                                   value="<fmt:formatDate value="${ccmEventCasedeal.handleDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/>"
                                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
                        </div></td>
                </tr>
                <tr>
                    <td><label class="control-label"><span class="help-inline"><font color="red">*</font> </span>是否督办：</label>
                        <div class="controls">
                            <form:select path="isSupervise" class="input-xlarge required">
                                <form:options items="${fns:getDictList('yes_no')}"
                                              itemLabel="label" itemValue="value" htmlEscape="false" />
                            </form:select>
                        </div></td>
                </tr>
                <tr>
                    <td><label class="control-label"> <span class="help-inline"><font color="red">*</font> </span>事件说明及任务安排：</label>
                        <div class="controls">
                            <form:textarea path="remarks" htmlEscape="false" rows="8"
                                           maxlength="1000" class="input-xxlarge required" />
                        </div></td>
                </tr>


                <!--  进行事件分流处理时，下述不显示
			<div class="control-group">
				<label class="control-label">处理时间：</label>
				<div class="controls">
					<input name="handleDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${ccmEventCasedeal.handleDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">处理措施：</label>
				<div class="controls">
					<form:textarea path="handleStep" htmlEscape="false" rows="8" maxlength="256" class="input-xxlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">任务处理状态：</label>
				<div class="controls">
					<form:select path="handleStatus" class="input-xlarge ">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('ccm_event_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">案事件反馈：</label>
				<div class="controls">
					<form:textarea path="handleFeedback" htmlEscape="false" rows="8" maxlength="256" class="input-xxlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">考评日期：</label>
				<div class="controls">
					<input name="checkDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${ccmEventCasedeal.checkDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">考评人员：</label>
				<div class="controls">
					<form:input path="checkUser" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">考评意见：</label>
				<div class="controls">
					<form:input path="checkOpinion" htmlEscape="false" maxlength="256" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">得分：</label>
				<div class="controls">
					<form:input path="checkScore" htmlEscape="false" maxlength="4" class="input-xlarge "/>
				</div>
			</div>

			 -->

            </table>

            <div class="form-actions">
                <shiro:hasPermission name="event:ccmEventCasedeal:edit">
                    <input id="btnDealSubmit" class="btn btn-primary" onclick="dealForm()"
                           type="button" value="指 派" />&nbsp;</shiro:hasPermission>
            </div>
        </form:form>
<%--        <div class="form-actions">--%>
<%--            <shiro:hasPermission name="event:ccmEventIncident:edit">--%>
<%--                <input id="btnSubmit" class="btn btn-primary" onclick="LayerDialogCloseParent('${ctx}/event/ccmEventCasedeal/dealformCommon?objType=ccm_event_incident&objId=${ccmEventIncident.id}', '处理', '700px', '500px')"--%>
<%--                       type="button"  value="指 派"/>&nbsp;</shiro:hasPermission>--%>
<%--        </div>--%>
    </c:if>
<br>
<c:if test="${CasedealListNumber > 0}">
    <shiro:hasPermission name="event:ccmEventCasedeal:edit">
        <h4>&nbsp;修改处理信息：</h4>
        <div class="fishBone1"></div>
    </shiro:hasPermission>
    <shiro:lacksPermission name="event:ccmEventCasedeal:edit">
        <h4>&nbsp;查看处理信息：</h4>
        <div class="fishBone2"></div>
    </shiro:lacksPermission>
</c:if>


<script>
    var cardType = $.attr("test1");
</script>

</body>

</html>