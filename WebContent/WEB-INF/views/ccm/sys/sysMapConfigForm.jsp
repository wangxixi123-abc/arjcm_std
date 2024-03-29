<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>地图信息配置管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			parent.$.jBox.tip('正在更新配置信息 ');
			$('#btnSubmit').click(function(){
				$('#inputFormSystemMapConfig').submit();
			});
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
	<style type="text/css">
		.lableStyle{width: 70px;margin-right: 10px;text-align: right;}
		.high{margin-bottom: 10px}
		.select2-container .select2-choice{
			width: 274px;
		}
		.control-group {
			border-bottom: 0px dotted #dddddd;
		}
		.form-horizontal {
			padding-top: 8px;
		}
</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active" style="width: 140px"><a class="nav-head" href="${ctx}/sys/sysConfig/listForm">地图信息配置</a></li>
	</ul>
	<!--<sys:message content="${message}"/>	-->
	<!-- 系统应用级别 -->
	<form:form id="inputFormSystemMapConfig" modelAttribute="systemMapConfig" action="${ctx}/sys/sysConfig/saveMapConfigInfo" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="remarks"/>
		<div class="control-group">
			<label class="control-label">默认显示：</label>
			<div class="controls">
				<form:radiobuttons path="sysMapConfig.showType" items="${fns:getDictList('url_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			</div>
		</div>
			<div class="control-group">
			<label class="control-label">地图投影：</label>
			<div class="controls">
				<form:radiobuttons path="sysMapConfig.projection" items="${fns:getDictList('projection_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">中心坐标：</label>
			<div class="controls">
				<form:input path="sysMapConfig.center" htmlEscape="false" maxlength="256" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">当前层级：</label>
			<div class="controls">
				<form:input path="sysMapConfig.zoom" htmlEscape="false" maxlength="256" class="input-xlarge digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">最小层级：</label>
			<div class="controls">
				<form:input path="sysMapConfig.min" htmlEscape="false" maxlength="256" class="input-xlarge digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">最大层级：</label>
			<div class="controls">
				<form:input path="sysMapConfig.max" htmlEscape="false" maxlength="256" class="input-xlarge digits"/>
			</div>
		</div>
		<div class="form-actions"  style="margin-bottom:15px">影像图信息</div>
		<div class="control-group">
			<label class="control-label">地图类型：</label>
			<div class="controls">
				<form:select path="sysMapConfig.imgType" class="input-xlarge">
					<form:options items="${fns:getDictList('map_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
	
		<div class="control-group">
			<label class="control-label">影像图URL：</label>
			<div class="controls">
				<form:input path="sysMapConfig.imageMapUrl" htmlEscape="false" maxlength="256" class="input-xlarge url"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">分辨率：</label>
			<div class="controls">
				<form:input path="sysMapConfig.imgResolutions" htmlEscape="false" maxlength="500" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">原点：</label>
			<div class="controls">
				<form:input path="sysMapConfig.imgOrigin" htmlEscape="false" maxlength="256" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">瓦片尺寸：</label>
			<div class="controls">
				<form:input path="sysMapConfig.imgTileSize" htmlEscape="false" maxlength="256" class="input-xlarge digits"/>
			</div>
		</div>
		<div class="form-actions" style="margin-bottom:15px">电子地图信息</div>
			<div class="control-group">
			<label class="control-label">地图类型：</label>
			<div class="controls">
				<form:select path="sysMapConfig.elcType" class="input-xlarge">
					<form:options items="${fns:getDictList('map_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
			<div class="control-group">
			<label class="control-label">电子地图URL：</label>
			<div class="controls">
				<form:input path="sysMapConfig.electronicMapUrl" htmlEscape="false" maxlength="256" class="input-xlarge url"/>
			</div>
		</div>
	
		<div class="control-group">
			<label class="control-label">分辨率：</label>
			<div class="controls">
				<form:input path="sysMapConfig.elcResolutions" htmlEscape="false" maxlength="500" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">原点：</label>
			<div class="controls">
				<form:input path="sysMapConfig.elcOrigin" htmlEscape="false" maxlength="256" class="input-xlarge number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">瓦片尺寸：</label>
			<div class="controls">
				<form:input path="sysMapConfig.elcTileSize" htmlEscape="false" maxlength="256" class="input-xlarge digits"/>
			</div>
		</div>

		<div class="form-actions" style="margin-bottom:15px">可视化地图信息</div>
		<div class="control-group">
			<label class="control-label">地图URL：</label>
			<div class="controls">
				<form:input path="sysMapConfig.keshihuaMapUrl" htmlEscape="false" maxlength="256" class="input-xlarge url"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="sys:sysConfig:edit">
				<!-- <input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保存" /> -->
					<a id="btnSubmit" class="btn btn-primary" href="javascript:;"><i class="icon-ok"></i>保存</a>
					&nbsp;
			</shiro:hasPermission>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" /> -->
				<a id="btnCancel" class="btn  btn-back" href="javascript:;"  onclick="history.go(-1)"><i class="icon-reply"></i>返回</a>
		</div>
	</form:form>
</body>
</html>