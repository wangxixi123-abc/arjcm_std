<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>地图</title>
<script type="text/javascript">
	var ctx = '${ctx}', ctxStatic = '${ctxStatic}';
</script>
<link rel="stylesheet" href="${ctxStatic}/ol/ol.css" type="text/css">
<link
	href="${ctxStatic}/jquery-ztree/3.5.12/css/zTreeStyle/zTreeStyle.min.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="${ctxStatic}/ccm/liveVideo/css/livedemo.css">
<link rel="stylesheet"
	href="${ctxStatic}/ccm/liveVideo/css/video-js.css">
<link rel="stylesheet"
	href="${ctxStatic}/modules/map/js/draw/css/p-ol3.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${ctxStatic}/modules/map/js/draw/css/defaults.css"
	type="text/css">
<link rel="stylesheet" href="${ctxStatic}/modules/map/css/map.css"
	type="text/css">
<link rel="stylesheet" href="${ctxStatic}/modules/map/css/house.css"
	type="text/css">
<script src="${ctxStatic}/jquery/jquery-1.8.3.min.js"></script>
<link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css"
	rel="stylesheet" />

<script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js"
	type="text/javascript"></script>
<script src="${ctxStatic}/ol/ol.js"></script>

<%-- <script src="${ctxStatic}/ccm/liveVideo/js/video.min.js"></script>
<script src="${ctxStatic}/ccm/liveVideo/js/videojs5.flvjs.js"></script>
<script src="${ctxStatic}/ccm/liveVideo/js/videojs-contrib-hls.js"></script>
<script src="${ctxStatic}/ccm/liveVideo/js/videojs-ie8.min.js"></script>
<script src="${ctxStatic}/ccm/liveVideo/js/livedemo.js"></script>
<script type="text/javascript">
	videojs.options.flash.swf = "${ctxStatic}/ccm/liveVideo/js/video-js.swf";
</script> --%>

<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"
	type="text/javascript"></script>
<script
	src="${ctxStatic}/jquery-ztree/3.5.12/js/jquery.ztree.all-3.5.js"
	type="text/javascript"></script>
<script src="${ctxStatic}/modules/map/js/draw/js/p-ol3.debug.js"></script>
<script src="${ctxStatic}/jquery-ui-1.12.1/jquery-ui.min.js"
	type="text/javascript"></script>
<link href="${ctxStatic}/modules/map/css/pop-info-animate.css"
	rel="stylesheet" />
<link href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css"
	rel="stylesheet" />
	<link href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome.min.css" type="text/css" rel="stylesheet">
<link rel="stylesheet"
	href="${ctxStatic}/modules/map/css/publicinstitutions.css">
<link rel="stylesheet" href="${ctxStatic}/flat/commandDispatch/css/index.css" />
<script src="${ctxStatic}/layer-v3.1.1/layer/layer.js"></script>
<script src="${ctxStatic}/modules/map/js/mapconfig.js"></script>
<script src="${ctxStatic}/modules/map/js/commonMap.js"></script>
<script src="${ctxStatic}/modules/map/js/QianXi.js"></script>
<script src="${ctxStatic}/ccm/sys/js/mapIndex.js"></script>
<script src="${ctxStatic}/modules/map/js/draw/js/appIndex.js"></script>
<script src="${ctxStatic}/modules/map/js/mapBuildSpe.js"></script>
<script src="${ctxStatic}/ccm/sys/js/mapCollectTree.js"></script>
 <script src="${ctxStatic}/ccm/sys/js/mapBusinessTree.js"></script>

<style>
#tool {
	right: 71px;
}
#toolCenter {
	width: 250px;
}
#DrawFlag .tool-gap {
	left: -1px;
}
.layer-common {
	width: 100%;
	height: 100%;
	position: relative;
	padding: 10px;
}
.layer-common-header {
	display: inline-block;
	padding: 5px 30px;
	border: 1px solid #0343a3;
	transform: skew(-20deg);
	background: #0343a3;
	color: #fff;
	font-weight: bold;
	position: absolute;
	z-index: 9999;
}
.layer-show {
	border: 1px solid #10559a;
}
#ztreeLeft li ul.line {
    background: inherit;
}
#treeLeft_1_ul{
 background: inherit;
 padding-left: 8px
}
#treeLeft_1_switch{
 background: inherit;
}
#treeLeft_1_ul li .switch {
   display: none;
}
#treeLeft_1 >span ,#treeLeft_1_a{
 display: none;
}
#treeLeft_1_ul li{
  display: inline;
}
.nav-tabsLeft li{
   width: 33.333%;
   text-align: center;
}
 #addBtn{
  float: right;
   position: relative;
  left:-5px;
  top:3px;
 }
 #addBtn i{
  font-size: 14px;
 }
 #collectZtree_1{
 position: relative;
  top:-15px;
 }
.diyBtn1{
   position: relative;
    float: inherit;
   color: #2fa0d7;
   margin-top: 3px;
    z-index:500;
   left:0px;
}
.diyBtn1 i{
  margin: 3 0px;
   z-index:0;
   position: relative;
}
.ztree li span{
  max-width:200px;
}
.collectType div{
    overflow: hidden;
    text-overflow: ellipsis;
    white-space:nowrap;
}
.collectType{
     font-size:12;
     width: 110px;
    position: relative;
    z-index: 999;
    box-shadow: 1px 2px 1px rgba(0, 0, 0, .15);
    float: right;
    top:2px;
    color: white;
    padding: 10px  0 0 0;
    border-radius: 10px;
}
.collectTypeBtn{
  height: 20px;
  padding: 3px;
  text-align: center;
/*   background-color: #bee1eb; */
border-top:0.6px solid  #efefef;
  border-bottom-right-radius: 10px;
   border-bottom-left-radius: 10px;
}
.collectType .radio{
 margin: 5px 3px 0 8px;
}
.businessZtree{ width: 100%;}
.business_list_div{
  float: left;
    width: 78px;
    text-align: center;
    margin: 7px;
     padding-bottom:10px;
    cursor: pointer;
}
.business_list_div:hover{
  background-color: #005580;
}
.business_list_img{
  width: 42px;
  height: 42px;
  margin-left:20;

  background-size: 90% 90%;
}
#businessDiv .businessZtree .business_choose{
   background-color: #1684c2;
}

#keyPerson_div  .keyPerson_choose{
   background-color: #1684c2;
}
 #keyPerson_div .keyPerson_list_div:hover{
  background-color: #005580;
}
#keyPerson_div{
  width: 264px;
  margin: 8px;
  height: 284px;
  position: absolute;
  top:80px;
  border-radius: 10px;
}
.keyPerson_list_div{
   float: left;
    width: 62px;
    text-align: center;
    padding:3px;
    margin-left: 14px;
     margin-bottom:8px;
     padding-bottom:10px;
    cursor: pointer;
     font-size: 12;
}
.keyPerson_list_img{
  width: 30px;
  height: 30px;
  margin-left:15;
  background-size: 80% 80%;
}
#keyPersonCountry_div  .keyPersonCountry_choose{
   background-color: #1684c2;
}
#keyPersonCountry_div .keyPersonCountry_list_div:hover{
  background-color: #005580;
}
#keyPersonCountry_div{
  width: 304px;
  margin: 8px;
  height:260px;
  position: absolute;
  top:80px;
  border-radius: 10px;
}
.keyPersonCountry_list_div{
   float: left;
    width: 62px;
    text-align: center;
    padding:3px;
    margin-left: 8px;
    margin-bottom:8px;
     padding-bottom:10px;
    cursor: pointer;
    font-size: 12;
}
.keyPersonCountry_list_img{
  width: 30px;
  height: 30px;
  margin-left:15;
  background-size: 80% 80%;
}
.nav-tabs>li>a:hover, .nav-tabs>li>a:focus {
    border-color: #005580 #005580 #1684c2;
}
.nav>li>a:hover, .nav>li>a:focus {
    text-decoration: none;
    background-color: #005580;
}
/* .accordion-heading a:hover, .dropdown a:hover {
    text-decoration: none;
    background: none;
} */
/*比例尺自定义样式*/
.ol-custom-scale-line,
.ol-custom-scale-line.ol-unselectable {
	bottom: auto;
    left: 3%;
    right: auto;
    /*右侧显示*/
    top: auto;
    /*顶部显示*/
}
.radio label::after {
    display: inline-block;
    position: absolute;
    content: " ";
    width: 11px;
    height: 11px;
    left: 3px;
    top: 3px;
}

.checkbox label::after {
    left: -1px;
    top: -2px;
}

#delete-wrapper {
    position: absolute;
    bottom: 0px;
    width: 100%;
    text-align: center;
    padding-bottom: 8px;
    z-index: 9;
}

#delete-wrapper #btn-delete {
    display: inline-block;
    color: rgb(255, 255, 255);
    cursor: pointer;
    padding: 8px 16px;
    background: #19a7f0;
}

#delete-wrapper #btn-cancle {
    display: inline-block;
    color: rgb(255, 255, 255);
    cursor: pointer;
    padding: 8px 16px;
    background: #19a7f0;
}

.tooltip {
    position: relative;
    background: rgba(0, 0, 0, 0.5);
    border-radius: 4px;
    color: white;
    padding: 4px 8px;
    opacity: 0.7;
    white-space: nowrap;
}

.tooltip-measure {
    opacity: 1;
    font-weight: bold;
}

.tooltip-static {
    background-color: #ffcc33;
    color: black;
    border: 1px solid white;
}

.tooltip-measure:before, .tooltip-static:before {
    border-top: 6px solid rgba(0, 0, 0, 0.5);
    border-right: 6px solid transparent;
    border-left: 6px solid transparent;
    content: "";
    position: absolute;
    bottom: -6px;
    margin-left: -7px;
    left: 50%;
}

.tooltip-static:before {
    border-top-color: #ffcc33;
}

.ztree {
    margin: 0;
    _margin-top: 10px;
    padding: 10px 0 0 10px;
}

#left {
    background: none;
}

.accordion-heading {
    background-image: none;
}

.checkbox .police-type {
    display: inline-block;
}

.checkbox label.police-label {
    padding-left: 0px;
    width: 45px;
}

.checkbox label.police-label::before {
    display: block;
    position: relative;
    width: 20px;
    height: 20px;
    left: 38px;
    margin-left: -34px;
    border: 1px solid #cccccc;
    border-radius: 25%;
}

.checkbox label.police-label::after {
    width: 25px;
    height: 25px;
    left: 36px;
    margin-left: -34px;
    border-radius: 50%;
    font-size: 20px;
    padding-top: 2px;
}
</style>

</head>
<body  style="overflow: hidden;"   onload="init()">
    <div id="content" class="row-fluid">
     <div id="left" class="accordion-group mapIndex">
			<div class="accordion-heading">
			<ul  class="nav nav-tabs nav-tabsLeft">
				<li id="resource"  class="active" ><a>资&nbsp;&nbsp;&nbsp;源</a></li>
				<li id="business"  ><a>业&nbsp;&nbsp;&nbsp;务</a></li>
				<li  id="collect"  ><a>收藏夹</a></li>
				</ul>
			</div>
			          <div style="float: left; border-bottom: 1px solid #5b6e84;width: 100%;margin-top: 32px;">
						 <div  id="treeLeft" class="ztree" style="overflow: auto; float: left; width: 100px;height: 100px;margin-bottom: 2px"> </div>
						 <br>
				        </div>
					  <div id="resourceDiv">

						<div >
							<select id="treeType"  style="margin-top: 10px" class="form-control">
							   	 <option value="">全部</option>
								 <%-- <option value="build">楼栋</option>--%>
								<option value="commonality">公共机构</option>
								<option value="npse">重点及风险单位</option>
								<option value="school">学校</option>
								<option value="citycomponents">城市部件</option>
								<option value="land">土地</option>
								<option value="camera">视频监控</option>
								</optgroup>
							</select>
						</div>

					   <div class="input-append" style="margin-top: 0px">
							<input id="secuPlace" name="secuPlace" class="input-medium"
								type="text" value="" maxlength="100"
								style="width: 172px; height: 30px; margin-left: 1px;">
							<a id="areaButton" href="javascript:" class="btn"
								style="border-radius: 0 14px 14px 0;display: inline-block;">&nbsp;<i
								class="icon-search"></i>&nbsp;
							</a>&nbsp;&nbsp;
						</div>

					<div id="assetTree" class="ztree"  style="overflow: auto;"></div>
				</div>

				<div id="businessDiv" style="display: none;">
                   <div id="businessZtree" class="businessZtree"  style="overflow: auto;">

                   </div>
                </div>

				<div id="collectDiv" style="display: none;">
				   <div id="collectZtree" class="ztree"  style="overflow: auto;"></div>
				</div>
		</div>
		<div id="openClose" class="close">&nbsp;</div>
     <div  id="right" style="overflow: hidden;">
	<!-- 人员定位信息  -->
	<input type="hidden" value="${areaPoint}" id="areaPoint" />
	<input type="hidden" value="${ccmPeople.name}" id="ccmPeopleName" />
	<input type="hidden" value="${ccmPeople.sex}" id="ccmPeopleSex" />
	<input type="hidden" value="${ccmPeople.birthday}"
		id="ccmPeopleBirthday" />
	<input type="hidden" value="${ccmPeople.areaComId}"
		id="ccmPeopleareaComId" />
	<input type="hidden" value="${ccmPeople.areaGridId}"
		id="ccmPeopleareaGridId" />
	<input type="hidden" value="${ccmPeople.ident}" id="ccmPeopleIdent" />
	<input type="hidden" value="${ccmPeople.residencedetail}"
		id="ccmPeopleresidencedetail" />
	<!-- 人员定位信息   -->
	<!-- 案事件定位信息 -->
	<input type="hidden" value="${areaPointIncident}" id="AlarmAreaPoint" />
	<input type="hidden" value="${ccmEventIncidentAll.caseName}"
		id="ccmEventIncidentCaseName" />
	<input type="hidden" value="${ccmEventIncidentAll.culName}"
		id="ccmEventIncidentCulName" />
	<input type="hidden" value="${ccmEventIncidentAll.happenDate}"
		id="ccmEventIncidentHappenDate" />
	<input type="hidden" value="${ccmEventIncidentAll.casePlace}"
		id="ccmEventIncidentCasePlace" />
	<input type="hidden" value="${ccmEventIncidentAll.happenPlace}"
		id="ccmEventIncidentHappenPlace" />
	<input type="hidden" value="${ccmEventIncidentAll.caseCondition}"
		id="ccmEventIncidentCaseCondition" />
    <input type="hidden" value='${geoJSONIncidentBuildmanage}'
		id="geoJSONIncidentBuildmanage"/>
	<input type="hidden" value='${geoJSONIncidentCcmDevice}'
		id="geoJSONIncidentCcmDevice"/>

	<!-- 案事件定位信息 -->

	<!-- 今日案事件定位信息 -->

	<div id="layEventIncident" attrName="${caseName}"
		attrCoordinates="${areaPointIncidentMap}" attrid="${eventIncidentId}"
		attrccmEventIncident='${ccmEventIncident}' happenDate="${happenDate}"
		style="display: none"></div>


	<input type="hidden" value="${caseName}" id="TodayCaseName" />
	<input type="hidden" value="${eventIncidentId}" id="eventIncidentId" />
	<input type="hidden" value="${ccmEventIncident.culName}"
		id="TodayCulName" />
	<input type="hidden" value="${ccmEventIncident.happenDate}"
		id="TodayHappenDate" />
	<input type="hidden" value="${ccmEventIncident.casePlace}"
		id="TodayCasePlace" />
	<input type="hidden" value="${ccmEventIncident.happenPlace}"
		id="TodayHappenPlace" />
	<input type="hidden" value="${ccmEventIncident.caseCondition}"
		id="TodayCaseCondition" />
	<input type="hidden" value="${ccmEventIncident.file1}" id="TodatFile" />
	<input type="hidden" value="${ccmEventIncident.status}"
		id="TodatStatus" />
	<input type="hidden" value="${ccmEventIncident.eventScale}"
		id="TodatEventScale" />
	<input type="hidden" value="${ccmPeopleIncident.name}"
		id="ccmPeopleIncidentName" />
	<input type="hidden" value="${ccmPeopleIncident.sex}"
		id="ccmPeopleIncidentSex" />
	<input type="hidden" value="${ccmPeopleIncident.birthday}"
		id="ccmPeopleIncidentBirthday" />
	<input type="hidden" value="${ccmPeopleIncident.images}"
		id="ccmPeopleIncidentImages" />
	<!--视频id  -->
	<input type="hidden" value="${ccmDeviceIncident.id}"
		id="ccmDeviceIncidentId" />

	 <c:forEach items="${reslistccmDeviceIncident}" var="resccmDeviceIncident">
		 <input type="hidden"
				data-id="${resccmDeviceIncident.id}"
				data-name="${resccmDeviceIncident.name}"
				name="resccmDeviceIncidentname" />
	 </c:forEach>

 	<input type="hidden" value="${reslistccmDeviceIncident}"
		id="listccmDeviceIncidentId" />

	<!--网格信息  -->
	<input type="hidden" value="${areaIncident.name}" id="areaIncidentName" />
	<input type="hidden" value="${ccmOrgAreaIncident.netManName}"
		id="ccmOrgAreaIncidentNetManName" />
	<input type="hidden" value="${ccmOrgAreaIncident.telephone}"
		id="ccmOrgAreaIncidentNetManTelephone" />
	<input type="hidden" value="${ccmOrgAreaIncident.netNum}"
		id="ccmOrgAreaIncidentNetManNetNum" />
	<input type="hidden" value="${ccmOrgAreaIncident.mannum}"
		id="ccmOrgAreaIncidentNetManMannum" />
	<input type="hidden" value="${ccmOrgAreaIncident.icon}"
		id="ccmOrgAreaIncidentNetManManIcon" />
	<input type="hidden" value="${netMapIncident}" id="netMapIncident" />
	<input type="hidden" value="${ccmOrgAreaIncident.videoSafetyNum}"
		id="videoSafetyNum" />
	<input type="hidden" value="${ccmOrgAreaIncident.definitionNum}"
		id="definitionNum" />
	<input type="hidden" value="${ccmOrgAreaIncident.netPeoName}"
		id="netPeoName" />
	<input type="hidden" value="${ccmOrgAreaIncident.netPeoNum}"
		id="netPeoNum" />

	<!--处置信息  -->

	<input type="hidden" value="${areaLiveIncident}" id="areaLiveIncident" />

	<input type="hidden" value="${ccmOrgAreaLiveIncident.netManName}"
		id="ccmOrgAreaLiveIncidentnetManName" />
	<input type="hidden" value="${ccmOrgAreaLiveIncident.telephone}"
		id="ccmOrgAreaLiveIncidenttelephone" />

	<input type="hidden" value="${ccmOrgAreaLiveIncident}"
		id="ccmOrgAreaLiveIncident" />
	<!--处置信息--当前网格  -->
	<c:forEach items="${vCcmTeamListIncident}" var="vLIs">

		<input type="hidden" value="${vLIs.name}" attrid="${vLIs.id}"
			attrtel="${vLIs.phone}" attrphoto="${vLIs.photo}" name="vLIsname" />
	</c:forEach>

	<c:forEach items="${vCcmOrgListIncident}" var="vCcmOrgListIncident">
		<input type="hidden" value="${vCcmOrgListIncident.primaryPerson.name}"
			attrid="${vCcmOrgListIncident.primaryPerson.id }"
			attrtel="${vCcmOrgListIncident.phone}"
			attrphoto="${vCcmOrgListIncident.primaryPerson.remarks}"
			name="vLIsname" />
	</c:forEach>
	<!--处置信息--当前网格  -->

	<!--处置信息--所属网格  -->
	<c:forEach items="${vCcmTeamLiveListIncident}" var="suoshuvLIs">
		<input type="hidden" value="${suoshuvLIs.name}"
			attrtel="${suoshuvLIs.phone}" attrid="${suoshuvLIs.id}"
			attrphoto="${suoshuvLIs.photo}" name="suoshuvLIs" />
	</c:forEach>

	<c:forEach items="${vCcmOrgLiveListIncident}"
		var="vCcmOrgLiveListIncident">
		<input type="hidden"
			value="${vCcmOrgLiveListIncident.primaryPerson.name}"
			attrid="${vCcmOrgLiveListIncident.primaryPerson.id}"
			attrtel="${vCcmOrgLiveListIncident.phone}"
			attrphoto="${vCcmOrgLiveListIncident.primaryPerson.remarks}"
			name="suoshuvLIs" />
	</c:forEach>
	<!--处置信息--所属网格  -->
	<!--处置信息  -->
	<input type="hidden" value="${vCcmTeamListIncident}"
		id="vCcmOrgLiveListIncident" />
	<input type="hidden" value="${vCcmTeamLiveListIncident}"
		id="vCcmTeamLiveListIncident" />

	<!-- 今日案事件定位信息 -->

	<div id="FullBody" style="position: relative;">
		<!-- 缩放控件 -->
		<div id="zoombar" class="zoombar"
			style="position: absolute; top: 24px; left: 7px; height: 300px; z-index: 9">
			<div style="position: absolute; width: 63px; height: 62px;">
				<img style="position: relative; width: 63px; height: 62px"
					src="${ctxStatic}/modules/map/images/zoom/zoompanbar_bg.png" />
				<div id="Control.PanZoomBar.panup"
					style="position: absolute; left: 24px; top: 5px; width: 16px; height: 16px; cursor: pointer;"
					class="olButton olpanup" onclick="Map.panDirection('north')">
					<img id="Control.PanZoomBar.panup_innerImage"
						style="position: relative; width: 16px; height: 16px;"
						class="olAlphaImg"
						src="${ctxStatic}/modules/map/images/zoom/north-mini.png">
				</div>
				<div id="Control.PanZoomBar.panleft"
					style="position: absolute; left: 6px; top: 23px; width: 16px; height: 16px; cursor: pointer;"
					class="olButton olpanleft" onclick="Map.panDirection('west')">
					<img id="Control.PanZoomBar.panleft_innerImage"
						style="position: relative; width: 16px; height: 16px;"
						class="olAlphaImg"
						src="${ctxStatic}/modules/map/images/zoom/west-mini.png">
				</div>
				<div id="Control.PanZoomBar.panright"
					style="position: absolute; left: 42px; top: 23px; width: 16px; height: 16px; cursor: pointer;"
					class="olButton olpanright" onclick="Map.panDirection('east')">
					<img id="Control.PanZoomBar.panright_innerImage"
						style="position: relative; width: 16px; height: 16px;"
						class="olAlphaImg"
						src="${ctxStatic}/modules/map/images/zoom/east-mini.png">
				</div>
				<div id="Control.PanZoomBar.pandown"
					style="position: absolute; left: 24px; top: 39px; width: 16px; height: 16px; cursor: pointer;"
					class="olButton olpandown" onclick="Map.panDirection('south')">
					<img id="Control.PanZoomBar.pandown_innerImage"
						style="position: relative; width: 16px; height: 16px;"
						class="olAlphaImg"
						src="${ctxStatic}/modules/map/images/zoom/south-mini.png">
				</div>
			</div>
			<div id="Control.PanZoomBar.zoomin"
				style="position: absolute; left: 24px; top: 63px; width: 16px; height: 16px; cursor: pointer;"
				class="olButton olzoomin" onclick="Map.zoomInOut('in')">
				<img id="Control.PanZoomBar.zoomin_innerImage"
					style="position: relative; width: 16px; height: 16px;"
					class="olAlphaImg"
					src="${ctxStatic}/modules/map/images/zoom/zoom-plus-mini.png">
			</div>
			<div
				style="background-image: url(&quot;${ctxStatic}/modules/map/images/zoom/zoombar.png&quot;); left: 24px; top: 79px; width: 16px; height: 150px; position: absolute; cursor: pointer;"
				id="ControlPanZoomBar" class="olButton olPanZoomBar">
				<div id="PanZoomBar" class="PanZoomBar"
					style="position: absolute; left: 0px; top: 108px; width: 16px; height: 16px; cursor: move;">
					<img id="Control.PanZoomBar.OpenLayers.Map_7_innerImage"
						style="position: relative; width: 16px; height: 16px;"
						class="olAlphaImg"
						src="${ctxStatic}/modules/map/images/zoom/slider.png" />
				</div>
				<div id="ControlPanZoomIndex"
					style="position: absolute; width: 66px; height: 161px; left: 17px; top: 0px; overflow: hidden">
					<img id=""
						style="position: absolute; left: 0px; top: 133px; width: 65px; height: 16px; display: none"
						src="${ctxStatic}/modules/map/images/zoom/city-index.png" /> <img
						id=""
						style="position: absolute; left: 0px; top: 108px; width: 65px; height: 16px;"
						src="${ctxStatic}/modules/map/images/zoom/district-index.png" />
					<img id=""
						style="position: absolute; left: 0px; top: 82px; width: 65px; height: 16px;"
						src="${ctxStatic}/modules/map/images/zoom/street-index.png" /> <img
						id=""
						style="position: absolute; left: 0px; top: 55px; width: 65px; height: 16px;"
						src="${ctxStatic}/modules/map/images/zoom/community-index.png" />
					<img id=""
						style="position: absolute; left: 0px; top: 29px; width: 65px; height: 16px;"
						src="${ctxStatic}/modules/map/images/zoom/grid-index.png" />
				</div>
			</div>
			<div id="Control.PanZoomBar.zoomout"
				style="position: absolute; left: 24px; top: 227px; width: 16px; height: 16px; cursor: pointer;"
				class="olButton olzoomout" onclick="Map.zoomInOut('out')">
				<img id="Control.PanZoomBar.zoomout_innerImage"
					style="position: relative; width: 16px; height: 16px;"
					class="olAlphaImg"
					src="${ctxStatic}/modules/map/images/zoom/zoom-minus-mini.png">
			</div>
		</div>
		<div id="overly" class="overlay"></div>
		<!-- 缩放控件 -->

		<button type="button" data-toggle="modal" data-target="#myModal1"
			id="videoBtn" style="display: none"></button>
		<div id="myModal1" class="modal hide fade" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close video-close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h3 id="myModalLabel">视频监控</h3>
			</div>
			<div class="modal-body">
				<div id="video">
					<!-- <video id="videoElement"
					class="video-js vjs-default-skin vjs-big-play-centered"
					controlspreload="auto" width="540" height="400">
				</video> -->
					<!-- <video id="videoHtml5"
				autoplay	controls width="540" height="400">
				</video> -->

				</div>
			</div>
			<div class="modal-footer">
				<button class="btn video-close" data-dismiss="modal"
					aria-hidden="true">关闭</button>
			</div>
		</div>
		<!--  工具栏-->
        <%----------------------老工具栏Start----------------------%>
<%--		<div id="tool">--%>
<%--			<div id="toolCenter">--%>
<%--				<div class="row-fluid tool-container">--%>
<%--				<!-- 	<div class="span2  tool-list" onclick="LayersBox()" id="switchMap" style="width: 18%;">--%>
<%--						<i class="tool-icon tool-layers"></i><span>图层</span> <b--%>
<%--							class="tool-gap"></b>--%>
<%--					</div> -->--%>
<%--					<div class="span3 tool-list" id="DrawFlag"  style="width: 27%;">--%>
<%--						<i class="tool-icon tool-draw"></i><span>标绘</span> <i--%>
<%--							class="tool-icon tool-arrow-up"></i> <b class="tool-gap"></b>--%>
<%--					</div>--%>
<%--				    <div class="span2  tool-list" onclick="Map.selectQuery('Polygon')"  style="width: 23%;"--%>
<%--						id="switchMap">--%>
<%--						<i class="tool-icon tool-select"></i><span>框选</span> <b--%>
<%--							class="tool-gap"></b>--%>
<%--					</div>--%>
<%--					<div class="span2  tool-list" onclick="Map.switchMap()"  style="width: 23%;"--%>
<%--						id="switchMap">--%>
<%--						<i class="tool-icon tool-map"></i><span>切换</span> <b--%>
<%--							class="tool-gap"></b>--%>
<%--					</div>--%>
<%--					<div class="span2 tool-list" onclick="Map.fullScreen()"  style="width: 20%;"--%>
<%--						id="fullScreen">--%>
<%--						<i class="tool-icon tool-full"></i><span>全屏</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--			<div class="detail-box" id="toolDetailBox">--%>
<%--				<ul id="boxul" class="boxinfo">--%>
<%--					<li class="clearfix tool-list" onclick="PointBox()"><i--%>
<%--						class="tool-icon tool-point"></i><span>点标</span></li>--%>
<%--					<li class="clearfix tool-list" onclick="LineBox()"><i--%>
<%--						class="tool-icon tool-line"></i><span>线标</span></li>--%>
<%--					<li class="clearfix tool-list" onclick="PolygonBox()"><i--%>
<%--						class="tool-icon tool-polygon"></i><span>面标</span></li>--%>
<%--					<li class="clearfix tool-list" onclick="ArrowBox()"><i--%>
<%--						class="tool-icon tool-arrow"></i><span>箭头</span></li>--%>
<%--					<li class="clearfix tool-list" onclick="TextBox()"><i--%>
<%--						class="tool-icon tool-text"></i><span>文字</span></li>--%>

<%--				</ul>--%>
<%--			</div>--%>
<%--			<!-- 点 -->--%>
<%--			<div class="tag-panl" id="PointBox">--%>
<%--				<div class="row-fluid tag-panl-header">--%>
<%--					<div class="span10">--%>
<%--						<span style="margin-left: 5px">标绘</span>--%>
<%--					</div>--%>
<%--					<div class="span2 tag-panl-close">--%>
<%--						<i class="icon-remove"></i>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>
<%--					<div class="span4"></div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="点标绘"--%>
<%--							onclick="activate(P.PlotTypes.MARKER)"> <i--%>
<%--							class="tool-icon  tool-point"></i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span4"></div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--			<!-- 线 -->--%>
<%--			<div class="tag-panl" id="LineBox">--%>
<%--				<div class="row-fluid tag-panl-header">--%>
<%--					<div class="span10">--%>
<%--						<span style="margin-left: 5px">标绘</span>--%>
<%--					</div>--%>
<%--					<div class="span2 tag-panl-close">--%>
<%--						<i class="icon-remove"></i>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="弧线标绘"--%>
<%--							onclick="activate(P.PlotTypes.ARC)"> <i class="tool-icon ">弧</i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="曲线标绘"--%>
<%--							onclick="activate(P.PlotTypes.CURVE)"> <i--%>
<%--							class="tool-icon">曲</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="折线标绘"--%>
<%--							onclick="activate(P.PlotTypes.POLYLINE)"> <i--%>
<%--							class="tool-icon">折</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="自由线标绘"--%>
<%--							style="margin-left: -3px;"--%>
<%--							onclick="activate(P.PlotTypes.FREEHAND_LINE)"> <i--%>
<%--							class="tool-icon">自</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--			<!-- 面 -->--%>
<%--			<div class="tag-panl" id="PolygonBox">--%>
<%--				<div class="row-fluid tag-panl-header">--%>
<%--					<div class="span10">--%>
<%--						<span style="margin-left: 5px">标绘</span>--%>
<%--					</div>--%>
<%--					<div class="span2 tag-panl-close">--%>
<%--						<i class="icon-remove"></i>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="圆标绘"--%>
<%--							onclick="activate(P.PlotTypes.CIRCLE)"> <i--%>
<%--							class="tool-icon ">圆</i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="椭圆标绘"--%>
<%--							onclick="activate(P.PlotTypes.ELLIPSE)"> <i--%>
<%--							class="tool-icon">椭</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="弓形标绘"--%>
<%--							onclick="activate(P.PlotTypes.LUNE)"> <i class="tool-icon">弓</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="扇形标绘"--%>
<%--							style="margin-left: -3px;" onclick="activate(P.PlotTypes.SECTOR)">--%>
<%--							<i class="tool-icon">扇</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="曲线面标绘"--%>
<%--							onclick="activate(P.PlotTypes.CLOSED_CURVE)"> <i--%>
<%--							class="tool-icon ">曲</i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="多边形标绘"--%>
<%--							onclick="activate(P.PlotTypes.POLYGON)"> <i--%>
<%--							class="tool-icon">多</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>

<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="矩形标绘"--%>
<%--							onclick="activate(P.PlotTypes.RECTANGLE)"> <i--%>
<%--							class="tool-icon">矩</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="自由面标绘"--%>
<%--							onclick="activate(P.PlotTypes.FREEHAND_POLYGON)"> <i--%>
<%--							class="tool-icon">自</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="聚集地标绘"--%>
<%--							onclick="activate(P.PlotTypes.GATHERING_PLACE)"> <i--%>
<%--							class="tool-icon">聚</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--			<!-- 箭头 -->--%>
<%--			<div class="tag-panl" id="ArrowBox">--%>
<%--				<div class="row-fluid tag-panl-header">--%>
<%--					<div class="span10">--%>
<%--						<span style="margin-left: 5px">标绘</span>--%>
<%--					</div>--%>
<%--					<div class="span2 tag-panl-close">--%>
<%--						<i class="icon-remove"></i>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="钳击标绘"--%>
<%--							onclick="activate(P.PlotTypes.DOUBLE_ARROW)"> <i--%>
<%--							class="tool-icon ">钳</i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="直箭头圆标绘"--%>
<%--							onclick="activate(P.PlotTypes.STRAIGHT_ARROW)"> <i--%>
<%--							class="tool-icon">直</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="细直箭头标绘"--%>
<%--							onclick="activate(P.PlotTypes.FINE_ARROW)"> <i--%>
<%--							class="tool-icon">细</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="突击方向标绘"--%>
<%--							style="margin-left: -3px;"--%>
<%--							onclick="activate(P.PlotTypes.ASSAULT_DIRECTION)"> <i--%>
<%--							class="tool-icon">突</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>

<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="进攻方向面标绘"--%>
<%--							onclick="activate(P.PlotTypes.ATTACK_ARROW)"> <i--%>
<%--							class="tool-icon ">进</i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="进攻方向（尾）标绘"--%>
<%--							onclick="activate(P.PlotTypes.TAILED_ATTACK_ARROW)"> <i--%>
<%--							class="tool-icon">尾</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="分队战斗行动标绘"--%>
<%--							onclick="activate(P.PlotTypes.SQUAD_COMBAT)"> <i--%>
<%--							class="tool-icon">分</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--					<div class="span3">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="分队战斗行动（尾）标绘"--%>
<%--							onclick="activate(P.PlotTypes.TAILED_SQUAD_COMBAT)"> <i--%>
<%--							class="tool-icon">尾</i>--%>
<%--						</span>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--			</div>--%>

<%--			<!-- 文字  -->--%>
<%--			<div class="tag-panl" id="TextBox">--%>
<%--				<div class="row-fluid tag-panl-header">--%>
<%--					<div class="span10">--%>
<%--						<span style="margin-left: 5px">文字</span>--%>
<%--					</div>--%>
<%--					<div class="span2 tag-panl-close">--%>
<%--						<i class="icon-remove"></i>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<div class="row-fluid tag-panl-center">--%>
<%--					<div class="span4"></div>--%>
<%--					<div class="span4">--%>
<%--						<span class="tag-panl-polygon tag-panl-span" title="文字标绘"--%>
<%--							onclick="Map.drawText(true)"> <i--%>
<%--							class="tool-icon  tool-text"></i>--%>
<%--						</span>--%>

<%--					</div>--%>
<%--					<div class="span4"></div>--%>
<%--				</div>--%>
<%--			</div>--%>

			<!-- 图层列表 -->
			<!-- <div class="tag-panl" id="LayersBox"
				style="min-width: 250px; width: 250px;">
				<div class="row-fluid tag-panl-header">
					<div class="span10">
						<span style="margin-left: 5px">图层列表</span>
					</div>
					<div class="span2 tag-panl-close">
						<i class="icon-remove"></i>
					</div>
				</div>
				<div class="row-fluid tag-panl-center">
					<div class="span1"></div>
					<div class="span11">
						<ul id="tree" class="ztree"></ul>
					</div>
				</div>
			</div> -->
			<!-- 图层列表 -->
<%--		</div>--%>
		<!-- 工具栏 -->
        <%----------------------老工具栏END----------------------%>
<%--		<div id="delete-wrapper">--%>
<%--			<div id="btn-delete" style="display: none;">删 除</div>--%>
<%--		</div>--%>
		<!--  工具栏-->
		<div id="map" class="map" tabindex="0">
            <span id="floatingLayer">工具</span> <span class="refurbish left-length" style="display: none;" onclick="window.location.reload()">刷新</span>
            <div class="mymovement">
                <div class="movement"></div>
            </div>
            <div class="toolmenu" id="toolMenu">
                <div class="toolbar" id="toolbar">
                    <div class="all-map">
                        <span>全屏</span>
                    </div>
                    <div class="return-map">
                        <span>返回</span>
                    </div>
                    <div class="Tools">
                        <span>工具</span>
                    </div>
                    <div class="range" id="range">
                        <span>范围</span>
                    </div>
                    <div class="plotting" id="plotting">
                        <span>标绘</span>
                    </div>
                    <div class="historyCoordinate" id="historyCoordinate">
                        <span>暂无</span>
                    </div>
                    <div id="clear">
                        <span onclick="clearAllGraphic()">清除</span>
                    </div>
                    <div id="turn-off">
                        <span>关闭</span>
                    </div>
                </div>
                <div class="inner-menu">
                    <ul class="toolbars">
                        <li><span id="lengthMeasure" title="测线" onclick="Map.measureMap('length')"></span></li>
                        <li><span id="pointMeasure" title="测面" onclick="Map.measureMap('area')"></span></li>
                        <li><span id="vector" title="地图切换" onclick="Map.switchMap()"></span></li>
                    </ul>
                    <ul class="range-query">
                        <li><span id="circleSelect" title="圈选" onclick="Map.selectQuery('Circle')"></span></li>
                        <li><span id="rectangSelect" title="框选" onclick="Map.selectQuery('Box')"></span></li>
                        <li><span id="polygonSelect" title="多边形选" onclick="Map.selectQuery('Polygon')"></span></li>
                        <li></li>
                        <li></li>
                    </ul>
                    <ul class="plottingbar">
                        <li><span id="labelCircle" title="圆形" onclick="activate(P.PlotTypes.CIRCLE)"></span></li>
                        <li><span id="labelEclipse" title="椭圆" onclick="activate(P.PlotTypes.ELLIPSE)"></span></li>
                        <li><span id="labelRect" title="矩形" onclick="activate(P.PlotTypes.RECTANGLE)"></span></li>
                        <li><span id="labelFreePolygon" title="自由面" onclick="activate(P.PlotTypes.FREEHAND_POLYGON)"></span></li>
                        <li><span id="labelFreePolyline" title="自由线" onclick="activate(P.PlotTypes.FREEHAND_LINE)"></span></li>
                        <li><span id="labelLeftArrow" title="细直箭头" onclick="activate(P.PlotTypes.FINE_ARROW)"></span></li>
                        <li><span id="labelRightArrow" title="钳击" onclick="activate(P.PlotTypes.DOUBLE_ARROW)"></span></li>
                        <li><span id="labelUpArrow" title="直箭头" onclick="activate(P.PlotTypes.STRAIGHT_ARROW)"></span></li>
                        <li><span id="labelDownArrow" title="突击方向标绘" onclick="activate(P.PlotTypes.ASSAULT_DIRECTION)"></span></li>
                        <li><span id="labelSave" title="弧线" onclick="activate(P.PlotTypes.ARC)"></span></li>
                        <li><span id="labelHistory" title="折线" onclick="activate(P.PlotTypes.POLYLINE)"></span></li>
                        <li><span id="labelStop" title="曲线" onclick="activate(P.PlotTypes.CURVE)"></span></li>
                    </ul>
                </div>
            </div>
			<div id="btn-delete" style="display: none;!important"></div>
			<!-- 	<div id="layerControl" class="layerControl">
			<div class="title">
				<label>图层列表</label>
			</div>
			<ul id="tree" class="ztree"></ul>
		</div> -->
			<div id="detailsDialog"></div>

		</div>
		<!-- 动态添加文字 -->
		<!-- <div id="TextOverlay" onclick="activeDelBtn()">

	</div> -->
		<!-- 	<div id="popup" class="ol-popup jbox">
		<div class="jbox-container">
			<a href="#" id="popup-closer" class="ol-popup-closer jbox-close"
				title="关闭" onmouseover="$(this).addClass('jbox-close-hover');"
				onmouseout="$(this).removeClass('jbox-close-hover');"
				style="position: absolute; display: block; cursor: pointer; top: 11px; right: 11px; width: 15px; height: 15px;"></a>
			<div class="jbox-title-panel" style="height: 25px;">
				<div class="jbox-title">信息</div>
			</div>
			<div class="jbox-state">
				<div id="popup-content" style="padding: 8px 15px;"></div>
				<div class="jbox-button-panel"
					style="height: 25px; padding: 5px 0 5px 0; text-align: right;">
					<span class="jbox-bottom-text"
						style="float: left; display: block; line-height: 25px;"></span>
					<button class="jbox-button" id="popup-closer1"
						style="padding: 0px 10px 0px 10px;">关闭</button>
				</div>
			</div>
		</div>

	</div> -->

		<div id="popup" class="ol-popup  bb">
			<div class="">
				<a href="#" id="popup-closer" class="ol-popup-closer  icon-remove "
					title="关闭" onmouseover="$(this).addClass('jbox-close-hover');"
					onmouseout="$(this).removeClass('jbox-close-hover');"
					style="position: absolute; display: block; cursor: pointer; top: 4px; right: 11px; width: 15px; height: 15px; color: #fff"></a>
				<div class="jbox-title-panel" style="height: 25px;">
					<div class="jbox-title">信息</div>
				</div>
				<div class="jbox-state">
					<div id="popup-content" style="padding: 8px 15px;"></div>
				</div>
			</div>
		</div>

		<div id="pubMap" ></div>
		<!-- 楼栋住户信息 -->
		<button type="button" data-toggle="modal" data-target="#myModal"
			id="buildBtn" style="display: none"></button>
		<div id="myModal" class="modal hide fade jbox" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
			style="width: 1300px; margin-left: -33.85%;">
			<div class="jbox-container">
				<a href="#" id="popup-closer" class="ol-popup-closer jbox-close"
					title="关闭" onmouseover="$(this).addClass('jbox-close-hover');"
					onmouseout="$(this).removeClass('jbox-close-hover');"
					style="position: absolute; display: block; cursor: pointer; top: 4px; right: 11px; width: 15px; height: 15px;"
					data-dismiss="modal" aria-hidden="true"></a>
				<div class="jbox-title-panel" style="height: 25px;">
					<div class="jbox-title">信息</div>
				</div>
				<!-- 楼栋 -->
				<div class="jbox-state">
					<div id="popup-content">
						<div class="modal-body" id="build-details"
							style="padding: 3px 0px 0 0;"></div>
						<!-- 房屋 -->
						<div class="modal-body" id="house-details"
							style="padding: 3px 15px;"></div>
						<!--人口-->
						<div class="modal-body" id="pop-details"></div>
					</div>
					<div class="jbox-button-panel"
						style="height: 4px; padding: 0 15px 20px; text-align: right;"
						id="modal-footer">
						<button class="jbox-button" style="padding: 0px 10px 0px 10px;"
							data-dismiss="modal" aria-hidden="true">关闭</button>
					</div>
				</div>
			</div>

		</div>
		<!-- 楼栋住户信息 -->
		<!-- 公共机构 -->
		<div class="unfold">
			<div class="relevance-bg" style="display: block;">
				<div class="br-yuan"></div>
			</div>
			<div class="relevance"
				style="width: 0; height: 0;">
				<div class="re-header">
					<div class="re-close"></div>
				</div>
				<div class="re-center clearfix">
					<div>
						<!--学校  -->
						<div class="pub-flag" onclick="xuexiaoFun(this)">
							<span class="pub-icon icon-xuexiao"></span> <span
								class="pub-name">学校</span>
						</div>
						<!-- 医院 -->
						<div class="pub-flag" onclick="yiyuanFun(this)">
							<span class="pub-icon icon-yiyuan"></span> <span class="pub-name">医院</span>
						</div>
						<!-- 加油站 -->
						<div class="pub-flag" onclick="jiayouzhanFun(this)">
							<span class="pub-icon icon-jiayouzhans"></span> <span
								class="pub-name">加油站</span>
						</div>
						<!-- 商场超市 -->
						<div class="pub-flag" onclick="shangchangFun(this)">
							<span class="pub-icon icon-shangchang"></span> <span
								class="pub-name">商场超市</span>
						</div>
						<!-- 娱乐场所 -->
						<div class="pub-flag" onclick="yuleFun(this)">
							<span class="pub-icon icon-yule"></span> <span class="pub-name">娱乐场所</span>
						</div>
						<!-- 宾馆 -->
						<div class="pub-flag" onclick="binguanFun(this)">
							<span class="pub-icon icon-bingguan"></span> <span
								class="pub-name">酒店宾馆</span>
						</div>
						<!-- 涉危涉爆单位 -->
						<div class="pub-flag" onclick="sheweishebaoFun(this)">
							<span class="pub-icon icon-sheweishebao"></span> <span
								class="pub-name">涉危涉爆</span>
						</div>

						<!-- 视频监控 -->
						<div class="pub-flag" onclick="shipinjiankongFun(this)" id="VideoFlag" VideoFlagAttr="false">
							<span class="pub-icon icon-shipins"></span> <span class="pub-name">视频监控</span>
						</div>
						<!-- 警员-->
						<div class="pub-flag" onclick="jingyuanFun(this)">
							<span class="pub-icon icon-jingyuan"></span> <span
								class="pub-name">工作人员</span>
						</div>
						<%--<c:if test="${sysConfig.objId eq 'xinmishi'}">--%>
						<!-- 警务室-->
						<div class="pub-flag" onclick="jingwushiFun(this)">
							<span class="pub-icon icon-jingwushi"></span> <span
								class="pub-name">警务室</span>
						</div>
						<!-- 工作站-->
						<div class="pub-flag" onclick="gongzuozhanFun(this)">
							<span class="pub-icon icon-gongzuozhan"></span> <span
								class="pub-name">工作站</span>
						</div>
						<!-- 广播站-->
						<div class="pub-flag" onclick="guangbozhanFun(this)">
							<span class="pub-icon icon-guangbozhan"></span> <span
								class="pub-name">广播站</span>
						</div>
						<!-- 警车-->
						 <!-- <div class="pub-flag" onclick="jingcheFun(this)">
							<span class="pub-icon icon-jingche"></span> <span
								class="pub-name">警车</span>
						</div>  -->
						<%--</c:if>--%>
						<!--机顶盒  -->
						<div class="pub-flag" onclick="SetTopBoxFun(this)">
							<span class="pub-icon icon-Settopbox"></span> <span
								class="pub-name">机顶盒</span>
						</div>

					</div>
				</div>
			</div>
		</div>

		<!-- 公共机构 -->
	</div>
	</div>
     <!-- /content -->
    </div>
  <script src="${ctxStatic}/ccm/sys/js/mapLeftTree.js"></script>

	<script type="text/javascript">
	   // 人员定位
		var leftWidth = 280; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		var areaPoint = $('#areaPoint').val()
		var ccmPeopleName = $('#ccmPeopleName').val()
		// 事件定位
	var AlarmAreaPoint = $('#AlarmAreaPoint').val()
		if ((areaPoint != "" && ccmPeopleName != "")||(AlarmAreaPoint != "")) {
			// leftWidth=0;
			$("#left").css("display","none");
		}
		function wSize() {
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({
				"overflow-x" : "auto",
				"overflow-y" : "auto"
			});
			mainObj.css("width", "auto");
			frameObj.height(strs[0] - 5);
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			$("#right").width(
					$("#content").width() - leftWidth - $("#openClose").width()
							- 5);
			/* $("#hideOrShowDiv").width(
					$("#content").width() - leftWidth - $("#openClose").width()
							- 5); */
			$(".ztree").width(leftWidth - 10).height(frameObj.height() - 160);
							wSizeWidth();
			$("#treeLeft").width('auto').height('auto');
		}
		function wSizeWidth() {
			if (!$("#openClose").is(":hidden")) {
				var leftWidth = ($("#left").width() < 0 ? 0 : $("#left")
						.width());
				$("#right").width(
						$("#content").width() - leftWidth
								- $("#openClose").width() - 4);
			} else {
				$("#right").width("100%");
			}
		}// <c:if test="${tabmode eq '1'}">
		function openCloseClickCallBack(b) {
			$.fn.jerichoTab.resize();
		} // </c:if>

		$(function() {
			$("#treeLeft").width('auto').height('auto');
		})

	</script>
     <script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>