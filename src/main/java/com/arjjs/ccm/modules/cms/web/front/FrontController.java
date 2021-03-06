/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.cms.web.front;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.servlet.ValidateCodeServlet;
import com.arjjs.ccm.common.utils.IdGen;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.cms.entity.Article;
import com.arjjs.ccm.modules.cms.entity.Category;
import com.arjjs.ccm.modules.cms.entity.CcmFontUser;
import com.arjjs.ccm.modules.cms.entity.Comment;
import com.arjjs.ccm.modules.cms.entity.Link;
import com.arjjs.ccm.modules.cms.entity.Site;
import com.arjjs.ccm.modules.cms.service.ArticleDataService;
import com.arjjs.ccm.modules.cms.service.ArticleService;
import com.arjjs.ccm.modules.cms.service.CategoryService;
import com.arjjs.ccm.modules.cms.service.CcmFontUserService;
import com.arjjs.ccm.modules.cms.service.CommentService;
import com.arjjs.ccm.modules.cms.service.LinkService;
import com.arjjs.ccm.modules.cms.service.SiteService;
import com.arjjs.ccm.modules.cms.utils.CmsUtils;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.service.AreaService;
import com.arjjs.ccm.tool.CommUtil;
import com.arjjs.ccm.tool.PasswordUtils;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 * 网站Controller
 * @author admin001
 * @version 2013-5-29
 */
@Controller
@RequestMapping(value = "${frontPath}")
public class FrontController extends BaseController{
	
	@Autowired
	private ArticleService articleService;
	@Autowired
	private ArticleDataService articleDataService;
	@Autowired
	private LinkService linkService;
	@Autowired
	private CommentService commentService;
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private SiteService siteService;
	@Autowired
	private CcmFontUserService ccmFontUserService;
	@Autowired
	private AreaService areaService;
	/**
	 * 发送登陆的用户信息到网站首页
	 */
	@ResponseBody
	@RequestMapping(value = "/loginUserDetail")
	public String loginUserDetail(String loginName,String password, HttpServletRequest request, HttpServletResponse response)throws IOException {
		CcmFontUser cmFontUser =new CcmFontUser();
		cmFontUser.setLoginName(loginName);
		
		CcmFontUser cmFontUser2= ccmFontUserService.getByLoginName(cmFontUser);
	
		HttpSession session=request.getSession();
        if(cmFontUser2!=null ){       	
		    if(cmFontUser2.getLoginFlag().equals("02")){
		     if(PasswordUtils.isPasswordInvalid(cmFontUser2.getPassword(), password)){
				 String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
				 cmFontUser2.setPhoto(fileUrl + cmFontUser2.getPhoto());
        	 session.setAttribute("ccmFontUser", cmFontUser2);
		     return "200";
		     }else{
		    	 return "500";
		     }
		    }else{
		    	return "notLoginFlag";
		    }
		}else{
		return "500";
		}
		
		
	}
	/**
	 * 注销
	 */
	@RequestMapping(value = "/exit")
	public String exit( HttpServletRequest request, HttpServletResponse response)throws IOException {
		
		HttpSession session=request.getSession();
		session.removeAttribute("ccmFontUser");
		System.out.println("redirect:"+Global.getFrontPath());
		return "redirect:"+Global.getFrontPath();
	}
	
	@RequestMapping(value = "default")
	public String form(CcmFontUser ccmFontUser, Model model) {
		model.addAttribute("ccmFontUser", ccmFontUser);
		return "/cms/front/themes/basic/layouts/default";
	}

	
	/**
	 * 验证登录名是否有效
	 * 
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/checkLoginName", method = RequestMethod.POST)
	public String queryDevice(String loginName,CcmFontUser ccmFontUser, HttpServletRequest req, HttpServletResponse resp, String userId)
			throws IOException {
		
		if (loginName != null && ccmFontUserService.getByLoginName(ccmFontUser) == null) {
			return "true";
		}
		return "false";
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/RegisterUser", method = RequestMethod.POST)
	public String RegisterUser(CcmFontUser ccmFontUser) {
		if(ccmFontUserService.getByLoginName(ccmFontUser) != null){
			return "cycloginname";
		}
		ccmFontUser.setId(IdGen.uuid());
		ccmFontUser.setCreateDate(new Date());
		ccmFontUser.setUpdateDate(new Date());
		ccmFontUser.setLoginFlag("03");
		ccmFontUser.setDelFlag("0");
		ccmFontUser.setIsNewRecord(true);
		ccmFontUser.setPassword(PasswordUtils.createPassword(ccmFontUser.getPassword()));
		int insertcount=ccmFontUserService.insert(ccmFontUser);
		if(insertcount==1){
			return "200";
		}
		return "500";
	}
	
	@RequestMapping(value = {"Ex"})
	public String Exlist(CcmFontUser ccmFontUser, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CcmFontUser> page = ccmFontUserService.findPage(new Page<CcmFontUser>(request, response), ccmFontUser); 
		model.addAttribute("page", page);
		return "modules/cms/ccmFontUserExList";
	}
	
	@RequestMapping(value = {"Fx"})
	public String Fxlist(CcmFontUser ccmFontUser, HttpServletRequest request, HttpServletResponse response, Model model) {
		CcmFontUser ccmFontUserRes = ccmFontUserService.get(ccmFontUser.getId()); 
		ccmFontUserRes.setUpdateStatus(ccmFontUser.getUpdateStatus());
		model.addAttribute("ccmFontUser", ccmFontUserRes);
		return "modules/cms/ccmFontUserFxList";
	}
	
	@ResponseBody
	@RequestMapping(value = "save")
	public void save(CcmFontUser ccmFontUser, Model model, RedirectAttributes redirectAttributes,HttpServletResponse response) {
		if (!beanValidator(model, ccmFontUser)){
			form(ccmFontUser, model);
			return;
		}
		if(StringUtils.isNotBlank(ccmFontUser.getNewPassword())){
			ccmFontUser.setPassword(PasswordUtils.createPassword(ccmFontUser.getNewPassword()));
		}
		PrintWriter out = null;
		try {
			out = response.getWriter();
			String userId = ccmFontUser.getId();
			String loginName = ccmFontUser.getLoginName();
			boolean bool = false;
			if(StringUtils.isNotBlank(userId)) {
				CcmFontUser ccmFontUserGet = ccmFontUserService.get(userId);
				if(ccmFontUserGet != null) {
					if(!loginName.equals(ccmFontUserGet.getLoginName())){
						if(ccmFontUserService.getByLoginName(ccmFontUser) != null){
							bool = true;
						}
					}
				}
			}
			if(bool) {				
				CommUtil.openWinExpDiv(out, "该登录名已存在");
			}else {
				ccmFontUserService.save(ccmFontUser);
				CommUtil.openWinExpDiv(out, "保存居民用户管理成功");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/tag/treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) { 
		List mapList = Lists.newArrayList();
		List list = areaService.findAll();
		for (int i = 0; i < list.size(); i++) {
			Area e = (Area)list.get(i);
			if ((StringUtils.isBlank(extId)) || ((extId != null) && (!extId.equals(e.getId())) && (e.getParentIds().indexOf("," + extId + ",") == -1))) {
				Map map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				mapList.add(map);
			}
		}
		return mapList;
	}
	
	@RequestMapping(value = "/tag/treeselect")
	public String treeselect(HttpServletRequest request, Model model){
		model.addAttribute("url", request.getParameter("url"));
		model.addAttribute("extId", request.getParameter("extId"));
		model.addAttribute("checked", request.getParameter("checked"));
		model.addAttribute("selectIds", request.getParameter("selectIds"));
		model.addAttribute("isAll", request.getParameter("isAll"));
		model.addAttribute("module", request.getParameter("module"));
		Site site = CmsUtils.getSite(Site.defaultSiteId());	
		return "modules/cms/front/themes/"+site.getTheme()+"/layouts/tagTreeselect";
	}

	@RequestMapping(value = "/tag/newtreeselect")
	public String newtreeselect(HttpServletRequest request, Model model){
		model.addAttribute("url", request.getParameter("url"));
		model.addAttribute("extId", request.getParameter("extId"));
		model.addAttribute("checked", request.getParameter("checked"));
		model.addAttribute("selectIds", request.getParameter("selectIds"));
		model.addAttribute("isAll", request.getParameter("isAll"));
		model.addAttribute("module", request.getParameter("module"));
		Site site = CmsUtils.getSite(Site.defaultSiteId());
		return "modules/cms/front/themes/"+site.getTheme()+"/layouts/tagTreeselectnew";
	}
	
	@RequestMapping(value = "/tag/iconselect")
	public String iconselect(HttpServletRequest request, Model model){
		model.addAttribute("value", request.getParameter("value"));
		Site site = CmsUtils.getSite(Site.defaultSiteId());	
		return "modules/cms/front/themes/"+site.getTheme()+"/layouts/tagIconselect";
	}
	
	/**
	 * 网站首页
	 */
	@RequestMapping
	public String index(String loginName,Model model, HttpServletRequest request, HttpServletResponse response) {
		Site site = CmsUtils.getSite(Site.defaultSiteId());	
		HttpSession session=request.getSession();	
		model.addAttribute("site", site);
		model.addAttribute("isIndex", true);
		
		return "modules/cms/front/themes/"+site.getTheme()+"/frontIndex";
	}
	
	/**
	 * 网站首页
	 */
	@RequestMapping(value = "index-{siteId}${urlSuffix}")
	public String index(@PathVariable String siteId, Model model) {
		if (siteId.equals("1")){
			return "redirect:"+Global.getFrontPath();
		}
		Site site = CmsUtils.getSite(siteId);
		// 子站有独立页面，则显示独立页面
		if (StringUtils.isNotBlank(site.getCustomIndexView())){
			model.addAttribute("site", site);
			model.addAttribute("isIndex", true);
			return "modules/cms/front/themes/"+site.getTheme()+"/frontIndex"+site.getCustomIndexView();
		}
		// 否则显示子站第一个栏目
		List<Category> mainNavList = CmsUtils.getMainNavList(siteId);
		if (mainNavList.size() > 0){
			String firstCategoryId = CmsUtils.getMainNavList(siteId).get(0).getId();
			return "redirect:"+Global.getFrontPath()+"/list-"+firstCategoryId+Global.getUrlSuffix();
		}else{
			model.addAttribute("site", site);
			return "modules/cms/front/themes/"+site.getTheme()+"/frontListCategory";
		}
	}
	
	/**
	 * 内容列表
	 */
	@RequestMapping(value = "list-{categoryId}${urlSuffix}")
	public String list(@PathVariable String categoryId, @RequestParam(required=false, defaultValue="1") Integer pageNo,
			@RequestParam(required=false, defaultValue="15") Integer pageSize, Model model) {
		Category category = categoryService.get(categoryId);
		if (category==null){
			Site site = CmsUtils.getSite(Site.defaultSiteId());
			model.addAttribute("site", site);
			return "error/404";
		}
		Site site = siteService.get(category.getSite().getId());
		model.addAttribute("site", site);
		// 2：简介类栏目，栏目第一条内容
		if("2".equals(category.getShowModes()) && "article".equals(category.getModule())){
			// 如果没有子栏目，并父节点为跟节点的，栏目列表为当前栏目。
			List<Category> categoryList = Lists.newArrayList();
			if (category.getParent().getId().equals("1")){
				categoryList.add(category);
			}else{
				categoryList = categoryService.findByParentId(category.getParent().getId(), category.getSite().getId());
			}
			model.addAttribute("category", category);
			model.addAttribute("categoryList", categoryList);
			// 获取文章内容
			Page<Article> page = new Page<Article>(1, 1, -1);
			Article article = new Article(category);
			page = articleService.findPage(page, article, false);
			if (page.getList().size()>0){
				article = page.getList().get(0);
				article.setArticleData(articleDataService.get(article.getId()));
				articleService.updateHitsAddOne(article.getId());
			}
			model.addAttribute("article", article);
            CmsUtils.addViewConfigAttribute(model, category);
            CmsUtils.addViewConfigAttribute(model, article.getViewConfig());
			return "modules/cms/front/themes/"+site.getTheme()+"/"+getTpl(article);
		}else{
			List<Category> categoryList = categoryService.findByParentId(category.getId(), category.getSite().getId());
			// 展现方式为1 、无子栏目或公共模型，显示栏目内容列表
			if("1".equals(category.getShowModes())||categoryList.size()==0){
				// 有子栏目并展现方式为1，则获取第一个子栏目；无子栏目，则获取同级分类列表。
				if(categoryList.size()>0){
					category = categoryList.get(0);
				}else{
					// 如果没有子栏目，并父节点为跟节点的，栏目列表为当前栏目。
					if (category.getParent().getId().equals("1")){
						categoryList.add(category);
					}else{
						categoryList = categoryService.findByParentId(category.getParent().getId(), category.getSite().getId());
					}
				}
				model.addAttribute("category", category);
				model.addAttribute("categoryList", categoryList);
				// 获取内容列表
				if ("article".equals(category.getModule())){
					Page<Article> page = new Page<Article>(pageNo, pageSize);
					//System.out.println(page.getPageNo());
					page = articleService.findPage(page, new Article(category), false);
					model.addAttribute("page", page);
					// 如果第一个子栏目为简介类栏目，则获取该栏目第一篇文章
					if ("2".equals(category.getShowModes())){
						Article article = new Article(category);
						if (page.getList().size()>0){
							article = page.getList().get(0);
							article.setArticleData(articleDataService.get(article.getId()));
							articleService.updateHitsAddOne(article.getId());
						}
						model.addAttribute("article", article);
			            CmsUtils.addViewConfigAttribute(model, category);
			            CmsUtils.addViewConfigAttribute(model, article.getViewConfig());
						return "modules/cms/front/themes/"+site.getTheme()+"/"+getTpl(article);
					}
				}else if ("link".equals(category.getModule())){
					Page<Link> page = new Page<Link>(1, -1);
					page = linkService.findPage(page, new Link(category), false);
					model.addAttribute("page", page);
				}
				String view = "/frontList";
				if (StringUtils.isNotBlank(category.getCustomListView())){
					view = "/"+category.getCustomListView();
				}
	            CmsUtils.addViewConfigAttribute(model, category);
                site =siteService.get(category.getSite().getId());
                //System.out.println("else 栏目第一条内容 _2 :"+category.getSite().getTheme()+","+site.getTheme());
				return "modules/cms/front/themes/"+siteService.get(category.getSite().getId()).getTheme()+view;
				//return "modules/cms/front/themes/"+category.getSite().getTheme()+view;
			}
			// 有子栏目：显示子栏目列表
			else{
				model.addAttribute("category", category);
				model.addAttribute("categoryList", categoryList);
				String view = "/frontListCategory";
				if (StringUtils.isNotBlank(category.getCustomListView())){
					view = "/"+category.getCustomListView();
				}
	            CmsUtils.addViewConfigAttribute(model, category);
				return "modules/cms/front/themes/"+site.getTheme()+view;
			}
		}
	}

	/**
	 * 内容列表（通过url自定义视图）
	 */
	@RequestMapping(value = "listc-{categoryId}-{customView}${urlSuffix}")
	public String listCustom(@PathVariable String categoryId, @PathVariable String customView, @RequestParam(required=false, defaultValue="1") Integer pageNo,
			@RequestParam(required=false, defaultValue="15") Integer pageSize, Model model) {
		Category category = categoryService.get(categoryId);
		if (category==null){
			Site site = CmsUtils.getSite(Site.defaultSiteId());
			model.addAttribute("site", site);
			return "error/404";
		}
		Site site = siteService.get(category.getSite().getId());
		model.addAttribute("site", site);
		List<Category> categoryList = categoryService.findByParentId(category.getId(), category.getSite().getId());
		model.addAttribute("category", category);
		model.addAttribute("categoryList", categoryList);
        CmsUtils.addViewConfigAttribute(model, category);
		return "modules/cms/front/themes/"+site.getTheme()+"/frontListCategory"+customView;
	}

	/**
	 * 显示内容
	 */
	@RequestMapping(value = "view-{categoryId}-{contentId}${urlSuffix}")
	public String view(@PathVariable String categoryId, @PathVariable String contentId, Model model) {
		Category category = categoryService.get(categoryId);
		if (category==null){
			Site site = CmsUtils.getSite(Site.defaultSiteId());
			model.addAttribute("site", site);
			return "error/404";
		}
		model.addAttribute("site", category.getSite());
		if ("article".equals(category.getModule())){
			// 如果没有子栏目，并父节点为跟节点的，栏目列表为当前栏目。
			List<Category> categoryList = Lists.newArrayList();
			if (category.getParent().getId().equals("1")){
				categoryList.add(category);
			}else{
				categoryList = categoryService.findByParentId(category.getParent().getId(), category.getSite().getId());
			}
			// 获取文章内容
			Article article = articleService.get(contentId);
			if (article==null || !Article.DEL_FLAG_NORMAL.equals(article.getDelFlag())){
				return "error/404";
			}
			// 文章阅读次数+1
			articleService.updateHitsAddOne(contentId);
			// 获取推荐文章列表
			List<Object[]> relationList = articleService.findByIds(articleDataService.get(article.getId()).getRelation());
			// 将数据传递到视图
			model.addAttribute("category", categoryService.get(article.getCategory().getId()));
			model.addAttribute("categoryList", categoryList);
			article.setArticleData(articleDataService.get(article.getId()));
			model.addAttribute("article", article);
			model.addAttribute("relationList", relationList); 
            CmsUtils.addViewConfigAttribute(model, article.getCategory());
            CmsUtils.addViewConfigAttribute(model, article.getViewConfig());
            Site site = siteService.get(category.getSite().getId());
            model.addAttribute("site", site);
//			return "modules/cms/front/themes/"+category.getSite().getTheme()+"/"+getTpl(article);
            return "modules/cms/front/themes/"+site.getTheme()+"/"+getTpl(article);
		}
		return "error/404";
	}
	
	/**
	 * 内容评论
	 */
	@RequestMapping(value = "comment", method=RequestMethod.GET)
	public String comment(String theme, Comment comment, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Comment> page = new Page<Comment>(request, response);
		Comment c = new Comment();
		c.setCategory(comment.getCategory());
		c.setContentId(comment.getContentId());
		c.setDelFlag(Comment.DEL_FLAG_NORMAL);
		page = commentService.findPage(page, c);
		model.addAttribute("page", page);
		model.addAttribute("comment", comment);
		return "modules/cms/front/themes/"+theme+"/frontComment";
	}
	
	/**
	 * 内容评论保存
	 */
	@ResponseBody
	@RequestMapping(value = "comment", method=RequestMethod.POST)
	public String commentSave(Comment comment, String validateCode,@RequestParam(required=false) String replyId, HttpServletRequest request) {
		if (StringUtils.isNotBlank(validateCode)){
			if (ValidateCodeServlet.validate(request, validateCode)){
				if (StringUtils.isNotBlank(replyId)){
					Comment replyComment = commentService.get(replyId);
					if (replyComment != null){
						comment.setContent("<div class=\"reply\">"+replyComment.getName()+":<br/>"
								+replyComment.getContent()+"</div>"+comment.getContent());
					}
				}
				comment.setIp(request.getRemoteAddr());
				comment.setCreateDate(new Date());
				comment.setDelFlag(Comment.DEL_FLAG_AUDIT);
				commentService.save(comment);
				return "{result:1, message:'提交成功。'}";
			}else{
				return "{result:2, message:'验证码不正确。'}";
			}
		}else{
			return "{result:2, message:'验证码不能为空。'}";
		}
	}
	
	/**
	 * 站点地图
	 */
	@RequestMapping(value = "map-{siteId}${urlSuffix}")
	public String map(@PathVariable String siteId, Model model) {
		Site site = CmsUtils.getSite(siteId!=null?siteId:Site.defaultSiteId());
		model.addAttribute("site", site);
		return "modules/cms/front/themes/"+site.getTheme()+"/frontMap";
	}

    private String getTpl(Article article){
        if(StringUtils.isBlank(article.getCustomContentView())){
            String view = null;
            Category c = article.getCategory();
            boolean goon = true;
            do{
                if(StringUtils.isNotBlank(c.getCustomContentView())){
                    view = c.getCustomContentView();
                    goon = false;
                }else if(c.getParent() == null || c.getParent().isRoot()){
                    goon = false;
                }else{
                    c = c.getParent();
                }
            }while(goon);
            return StringUtils.isBlank(view) ? Article.DEFAULT_TEMPLATE : view;
        }else{
            return article.getCustomContentView();
        }
    }
	
}
