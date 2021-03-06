<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>网上论坛</title>
	<meta name="decorator" content="cms_default_${site.theme}"/>
	<meta name="description" content="JeeSite ${site.description}" />
	<meta name="keywords" content="JeeSite ${site.keywords}" />
	<link href="${ctxStatic}/jquery-validation/1.11.1/jquery.validate.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/jquery-validation/1.11.1/jquery.validate.js" type="text/javascript"></script>
	<script src="${ctxStatic}/jquery-validation/1.11.1/jquery.validate.method.js" type="text/javascript"></script>
	<script src="${ctxStatic}/layer-v3.1.1/layer/layer.js" type="text/javascript"></script>
    <link rel="stylesheet" href="${ctxStatic}/layer-v3.1.1/layer/theme/default/layer.css" />
    <script type="text/javascript" src="${ctxStatic}/dist/layui.js"></script>
	<link rel="stylesheet" href="${ctxStatic}/dist/css/layui.css" type="text/css"/>
	<link rel="stylesheet" href="${ctxStatic}/plm/email/emailReceive.css">
<%--<script type="text/javascript"--%>
	<%--src="${ctxStatic}/plm/email/plmWorkEmailinfo.js"></script>--%>
	<style>
		.photo {
			margin: 0 auto;
		}
		.fontsize{
			height: 50px;
			line-height: 50px;
			font-size: 20px;
		}
		.border_war{
			border: 1px solid #CCCCCC;
		}
	</style>
	<script type="text/javascript">

		$(document).ready(function() {
		    var dom=$(".content");
			for(var i=1;i<=dom.length;i++) {
                dom.eq(i).html(dom.eq(i).text());
			}
		});
		function page(n,s){
			location="${ctx}/bbsArticle?pageNo="+n+"&pageSize="+s;;
		}
		var index=0;
		function submitComment(){
			var fontUserId =  "${ccmFontUser.id}";

			var comContent=layedit.getContent(index); //评论内容
			console.log(comContent)
			if(comContent == null || comContent == ""|| comContent === undefined){
               layer.msg('请输入评论内容！');
               return false;
            }
			if(fontUserId == null || fontUserId == ""|| fontUserId === undefined){
				layer.msg('登陆之后可以评论！');
				return false;
			}
			//var commentUserName = ${ccmFontUser.name};
			var fontUserId = "${ccmFontUser.id}";
			var articleId = "${cmsBbsArticle.id }";
			var url = '/arjccm/f/bbsArticle/saveComment';
			// console.log(articleId);
			$.post(url,{
				'comContent':comContent,
				'fontUserId':fontUserId,
				'articleId':articleId
			}, function(data){
				window.location.reload()
			})
		}
		var layedit;
		layui.use('layedit', function(){
			 layedit = layui.layedit;
			 index=layedit.build('commentComtent',{
				tool: [
					'strong' //加粗
					,'italic' //斜体
					,'underline' //下划线
					,'del' //删除线
					,'|' //分割线
					,'left' //左对齐
					,'center' //居中对齐
					,'right' //右对齐
					,'link' //超链接
					,'unlink' //清除链接
					,'face' //表情
					// ,'image' //插入图片
					,'help' //帮助
				]
			}); //建立编辑器
		});
	</script>

</head>
<body>
	<div style="padding:0 0 20px;">
        <h4><a href="${ctx}/bbsArticle">网上论坛</a></h4>
    </div>
	<table style="border: 1px solid #CCCCCC;width:940px;">
		<tr>
			<td colspan="4" style="border: 1px solid #CCCCCC;border-bottom:0px;">
				<div >
					<div class="fontsize">
						 标题 : ${cmsBbsArticle.title}
					 </div>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				<div class="content">
					<div>
						<c:out value="${cmsBbsArticle.contentText}"  escapeXml="false"/>
					</div>
				</div>
			</td>
		</tr>
		<tr >
			<td  width= "25% " style="border-top: 0px;"></td>
			<td  width= "25% " style="border-top: 0px;"></td>
			<td  width= "25% " style="border-bottom: 1px solid #CCCCCC;border-top: 0px;"></td>
			<td  style="border-bottom: 1px solid #CCCCCC;border-top: 0px;">
				<div >
					${cmsBbsArticle.fontUserName}
					${cmsBbsArticle.createDate}

				</div>
			</td>

		</tr>
		<c:forEach items="${cmsBbsArticle.commentList}" var="commentInfo">
			<tr >
				<td class="border_war" rowspan="2">
					<div>
						<div class="photo" style="width: 100px;">
							<c:choose>
	    	 					<c:when test="${commentInfo.photo != null}">
	    	 						<img src="${commentInfo.photo}" style="width: 100%;height: 100%;" onerror="this.src='${ctxStatic}/images/bbs-default.png'"/>
	    	 					</c:when>
								<c:otherwise>
									<img src="${ctxStatic}/images/bbs-default.png"/>
								</c:otherwise>
							</c:choose>
							<p style="text-align: center;">${ not empty commentInfo.name? commentInfo.name:"匿名" }</p >
						</div>
					</div>
				</td>
				<td class="border_war" style="border-right: 0px;border-bottom: 0px;">
					<div  class="content">
						<div  >
							<%--<p>  ${commentInfo.comContent}</p >--%>
								<c:out value="${commentInfo.comContent}"  escapeXml="false"/>
								<%--${commentInfo.comContent}--%>
						</div>
					</div>
				</td>
				<td  width= "25% "></td>
				<td  width= "25% ">
				</td>
			</tr>
			<tr>
				<td style="border-bottom: 1px solid #CCCCCC;float:right;">
					<div>

					</div>
				</td>
				<td colspan="2" style="border-bottom: 1px solid #CCCCCC;" >
					<div style="float:right;margin-bottom: 0px;    padding-right: 85px;" >
                        <fmt:formatDate value="${commentInfo.comTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
						<%--<span> 消息（0） 点赞（0） </span>--%>
					</div>
				</td>
			</tr>
		</c:forEach>

	</table>
	<c:if test="${fn:length(cmsBbsArticle.commentList) eq 0}">
		<div class="fontsize border_war">
			<li>暂时还没有评论！</li>
		</div>
	</c:if>
	<div>
		<div  class="layui-row" >
			<div class="fontsize border_war">
				<p>评论区</p>
			</div>
		</div>
		<div  class="layui-row" >
			<div  class="border_war">
				<textarea placeholder="请输入内容" id="commentComtent"  class="layui-textarea"></textarea>
			</div>
		</div>
		<div  class="layui-row" >
			<div  class="border_war">
				<button onclick="submitComment()" type="button" class="btn btn-primary">提交回复</button>
			</div>
		</div>
	</div>

</body>
</html>