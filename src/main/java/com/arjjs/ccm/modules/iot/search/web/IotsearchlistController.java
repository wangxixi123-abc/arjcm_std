/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.iot.search.web;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.common.utils.StringUtils;
/*import com.arjjs.ccm.modules.ccm.carpass.entity.CcmCarPass;
import com.arjjs.ccm.modules.ccm.carpass.service.CcmCarPassService;*/
import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

/**
 * 过车查询Controller
 * @author liuyongjian
 * @version 2019-07-24
 */
@Controller
@RequestMapping(value = "${adminPath}/searchlist/iotSearchList")
public class IotsearchlistController extends BaseController {	
	@RequiresPermissions("searchlist:iotSearchList:view")
	@RequestMapping(value = {"list", ""})
	public String list() {
		
		return "iot/search/iotSearchList";
	}

}