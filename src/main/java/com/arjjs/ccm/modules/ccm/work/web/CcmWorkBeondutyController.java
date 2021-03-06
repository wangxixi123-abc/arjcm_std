/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.ccm.work.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.utils.excel.ExportExcel;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeonduty;
import com.arjjs.ccm.modules.ccm.work.entity.CcmWorkBeondutyExport;
import com.arjjs.ccm.modules.ccm.work.service.CcmWorkBeondutyService;
import com.arjjs.ccm.modules.plm.calendar.service.PlmCalendarService;
import com.arjjs.ccm.modules.sys.utils.UserUtils;

import net.sf.json.JSONArray;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 值班表Controller
 * @author liang
 * @version 2018-06-12
 */
@Controller
@RequestMapping(value = "${adminPath}/work/ccmWorkBeonduty")
public class CcmWorkBeondutyController extends BaseController {

	@Autowired
	private CcmWorkBeondutyService ccmWorkBeondutyService;
	
	@Autowired
	private PlmCalendarService plmCalendarService;
	
	@ModelAttribute
	public CcmWorkBeonduty get(@RequestParam(required=false) String id) {
		CcmWorkBeonduty entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = ccmWorkBeondutyService.get(id);
		}
		if (entity == null){
			entity = new CcmWorkBeonduty();
		}
		return entity;
	}
	//值班批量添加
	@RequiresPermissions("work:ccmWorkBeonduty:view")
	@RequestMapping(value = "ccmWorkBeondutyPage")
	public String ccmWorkBeondutyPage(CcmWorkBeonduty ccmWorkBeonduty, Model model) {
		model.addAttribute("ccmWorkBeonduty", ccmWorkBeonduty);
		return "ccm/work/ccmWorkBeondutyPage";
	}
	//值班批量添加保存
	@RequiresPermissions("work:ccmWorkBeonduty:edit")
	@RequestMapping(value = "copySave")
	public void copySave(CcmWorkBeonduty ccmWorkBeonduty, Model model, RedirectAttributes redirectAttributes, HttpServletResponse response) throws IOException {
		CcmWorkBeonduty e = new CcmWorkBeonduty();
		e.setMonths(ccmWorkBeonduty.getBeginMonths());
		List<CcmWorkBeonduty> list = ccmWorkBeondutyService.findByYearMonth(e);
		for(CcmWorkBeonduty l:list){
			l.setMonths(ccmWorkBeonduty.getEndMonths());
			l.setId(UUID.randomUUID().toString());
			l.setIsNewRecord(true);
			ccmWorkBeondutyService.save(l);
		}
		addMessage(redirectAttributes, "批量添加成功");
		PrintWriter out = response.getWriter();
		out.println("<script language='javascript'>parent.layer.close(parent.layer.getFrameIndex(window.name));</script>");	//关闭jBox
		out.println("<script language='javascript'>top.$.jBox.tip('批量添加成功 ');</script>");									//提示	
		out.println("<script language='javascript'>parent.document.getElementById('mainFrame').src='/arjccm/a/work/ccmWorkBeonduty/'</script>");		//刷新	
	}
	
	
	
	
	
	
	//
	@RequiresPermissions("work:ccmWorkBeonduty:view")
	@RequestMapping(value = {"list", ""})
	public String list(CcmWorkBeonduty ccmWorkBeonduty, HttpServletRequest request, HttpServletResponse response, Model model) {
		if (ccmWorkBeonduty.getBeginDatas() != null && ccmWorkBeonduty.getEndDatas() != null) {
			SimpleDateFormat df = new SimpleDateFormat("HH:mm");
			String begin = df.format(ccmWorkBeonduty.getBeginDatas());
			String end = df.format(ccmWorkBeonduty.getEndDatas());
			String time = begin + "-" + end;
			ccmWorkBeonduty.setDatas(time);
		}
		Page<CcmWorkBeonduty> page = ccmWorkBeondutyService.findPage(new Page<CcmWorkBeonduty>(request, response), ccmWorkBeonduty); 
		model.addAttribute("page", page);
		return "ccm/work/ccmWorkBeondutyList";
	}
	/**
	 *
	 * 导出
	 */
	@RequiresPermissions("work:ccmWorkBeonduty:view")
	@RequestMapping(value = { "exportWorkBeonduty" })
	public void exportWorkBeonduty(CcmWorkBeonduty ccmWorkBeonduty, HttpServletRequest request, HttpServletResponse response,
							Model model) {
		try {
			String fileName = "值班管理"  + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<CcmWorkBeondutyExport> list = ccmWorkBeondutyService.exportList(ccmWorkBeonduty);
			new ExportExcel("值班管理", CcmWorkBeondutyExport.class).setDataList(list).write(response, fileName).dispose();
		} catch (Exception e) {
			System.out.println("导出事件处理数据失败！失败信息：" + e.getMessage());
		}
	}

	@RequiresPermissions("work:ccmWorkBeonduty:view")
	@RequestMapping(value = "form")
	public String form(String isinsert, CcmWorkBeonduty ccmWorkBeonduty, Model model) throws Exception {
		if(StringUtils.isNotEmpty(isinsert)) {
			ccmWorkBeonduty.setOffice(UserUtils.getUser().getOffice());
		}
		if (StringUtils.isNotBlank(ccmWorkBeonduty.getDatas())) {
			String time = ccmWorkBeonduty.getDatas();
			SimpleDateFormat format1 = new SimpleDateFormat("HH:mm");         
			String beginDatas = time.substring(0, time.indexOf("-")); 
			String endDatas = time.substring(beginDatas.length()+1, time.length());
			Date date1 = format1.parse(beginDatas);   
			Date date2 = format1.parse(endDatas);
			model.addAttribute("beginDatas", date1);
			model.addAttribute("endDatas", date2);
		}
		
		model.addAttribute("ccmWorkBeonduty", ccmWorkBeonduty);
		return "ccm/work/ccmWorkBeondutyForm";
	}
	
	@RequestMapping(value = "view")
	public String view(CcmWorkBeonduty ccmWorkBeonduty, Model model) throws Exception {
		if (StringUtils.isNotBlank(ccmWorkBeonduty.getDatas())) {
			String time = ccmWorkBeonduty.getDatas();
			SimpleDateFormat format1 = new SimpleDateFormat("HH:mm");         
			String beginDatas = time.substring(0, time.indexOf("-")); 
			String endDatas = time.substring(beginDatas.length()+1, time.length());
			Date date1 = format1.parse(beginDatas);   
			Date date2 = format1.parse(endDatas);
			model.addAttribute("beginDatas", date1);
			model.addAttribute("endDatas", date2);
		}
		model.addAttribute("ccmWorkBeonduty", ccmWorkBeonduty);
		return "ccm/work/ccmWorkBeondutyView";
	}

	@RequiresPermissions("work:ccmWorkBeonduty:edit")
	@RequestMapping(value = "save")
	public String save(@RequestParam(required=false) String beginDatas,String endDatas, CcmWorkBeonduty ccmWorkBeonduty, Model model, RedirectAttributes redirectAttributes) throws Exception {
		if (!beanValidator(model, ccmWorkBeonduty)){
			return form("1", ccmWorkBeonduty, model);
		}
		String time = beginDatas + "-" + endDatas;
		ccmWorkBeonduty.setDatas(time);
		ccmWorkBeondutyService.save(ccmWorkBeonduty);
		addMessage(redirectAttributes, "保存值班表成功");
		return "redirect:"+Global.getAdminPath()+"/work/ccmWorkBeonduty/?repage";
	}
	
	@RequiresPermissions("work:ccmWorkBeonduty:edit")
	@RequestMapping(value = "delete")
	public String delete(CcmWorkBeonduty ccmWorkBeonduty, RedirectAttributes redirectAttributes) {
		ccmWorkBeondutyService.delete(ccmWorkBeonduty);
		addMessage(redirectAttributes, "删除值班表成功");
		return "redirect:"+Global.getAdminPath()+"/work/ccmWorkBeonduty/?repage";
	}

	
	
	
	@SuppressWarnings("deprecation")
	@RequiresPermissions("calendar:plmCalendar:view")
	@RequestMapping(value = {"ccmBeonduty"})
	public String ccmBeonduty(CcmWorkBeonduty ccmWorkBeonduty, HttpServletRequest request, HttpServletResponse response, Model model, String showdate) {
		CcmWorkBeonduty e = new CcmWorkBeonduty();
		e.setMonths(ccmWorkBeonduty.getBeginMonths());
		List<CcmWorkBeonduty> list = ccmWorkBeondutyService.findList(e);
		
		//[id,title,start,end，全天日程，跨日日程,循环日程,theme,'地址','']          
	    //[['6147','你好啊',new Date(1338427800000),new Date(1338431400000),0,0,0,0,1,'']];
		List<List<Object>> list2=new ArrayList<List<Object>>();
		
		if(list.size()>0) {
			for (CcmWorkBeonduty res : list) {
				Calendar c = Calendar.getInstance();
				c.setTime(res.getMonths());
				int totalDays = c.getActualMaximum(Calendar.DAY_OF_MONTH);
				for(int i=1; i<=totalDays; i++) {
					c.set(Calendar.DAY_OF_MONTH, i);
					Date date = c.getTime();

					List<Object>  list3=new ArrayList<Object>();
					list3.add(0, res.getId()); //id

					String subjec=res.getDetails().replaceAll("\'(.*?)\'", "‘$1’").replaceAll("\'", "‘");
					list3.add(1, subjec); //内容

					long begindata=date.getTime();
					list3.add(2, begindata); //开始时间

					list3.add(3, begindata);  //结束时间

					list3.add(4,1);
					list3.add(5,0);
					list3.add(6,0);
					list3.add(7,0);
					list3.add(8,0);

					if(StringUtils.isNotBlank(res.getAdds())) {
						list3.add(9,res.getAdds().replaceAll("\'(.*?)\'", "‘$1’").replaceAll("\'", "‘"));
					}
					//将list3加入list2中
					list2.add(list3);

				}
			}
		}
		
		JSONArray json = JSONArray.fromObject(list2);  
		model.addAttribute("list", json);	
		if(showdate==null||showdate.equals("")) {
			showdate=String.valueOf(System.currentTimeMillis());
		}
		
		model.addAttribute("date", showdate);	
		return "ccm/work/ccmBeonduty";
	}
	
	
	
	@RequestMapping(value = {"getccmBeonduty"})
	@ResponseBody
	public Map<String,Object> getccmBeonduty(CcmWorkBeonduty ccmWorkBeonduty, HttpServletRequest request, HttpServletResponse response, Model model, String showdate) {
		CcmWorkBeonduty e = new CcmWorkBeonduty();
		e.setOffice(ccmWorkBeonduty.getOffice());
		e.setPrincipal(ccmWorkBeonduty.getPrincipal());
		e.setPrincipalMans(ccmWorkBeonduty.getPrincipalMans());
		List<CcmWorkBeonduty> list = ccmWorkBeondutyService.findList(e);
		
		//[id,title,start,end，全天日程，跨日日程,循环日程,theme,'地址','']          
	    //[['6147','你好啊',new Date(1338427800000),new Date(1338431400000),0,0,0,0,1,'']];
		List<List<Object>> list2=new ArrayList<List<Object>>();
		
		if(list.size()>0) {
			for (CcmWorkBeonduty res : list) {

				Calendar c = Calendar.getInstance();
				c.setTime(res.getMonths());
				int totalDays = c.getActualMaximum(Calendar.DAY_OF_MONTH);
				for(int i=1; i<=totalDays; i++) {
					c.set(Calendar.DAY_OF_MONTH, i);
					Date date = c.getTime();
					List<Object>  list3=new ArrayList<Object>();
					list3.add(0, res.getId()); //id

					String subjec=res.getDetails().replaceAll("\'(.*?)\'", "‘$1’").replaceAll("\'", "‘");
					list3.add(1, subjec); //内容

//					long begindata=res.getMonths().getTime();
					long begindata=date.getTime();
					list3.add(2, begindata); //开始时间

					list3.add(3, begindata);  //结束时间

					list3.add(4,1);
					list3.add(5,0);
					list3.add(6,0);
					list3.add(7,0);
					list3.add(8,0);

					if(StringUtils.isNotBlank(res.getAdds())) {
						list3.add(9,res.getAdds().replaceAll("\'(.*?)\'", "‘$1’").replaceAll("\'", "‘"));
					}
					//将list3加入list2中
					list2.add(list3);
				}
			}
		}
		
		JSONArray json = JSONArray.fromObject(list2);  
		model.addAttribute("list", json);	
		if(showdate==null||showdate.equals("")) {
			showdate=String.valueOf(System.currentTimeMillis());
		}
		
		model.addAttribute("date", showdate);	
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("list", json);
		map.put("date", showdate);
		return map;
	}
}
