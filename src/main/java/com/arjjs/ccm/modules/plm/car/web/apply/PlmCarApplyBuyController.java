/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.car.web.apply;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.act.service.ActTaskService;
import com.arjjs.ccm.modules.plm.act.entity.PlmAct;
import com.arjjs.ccm.modules.plm.act.service.PlmActService;
import com.arjjs.ccm.modules.plm.car.entity.apply.PlmCarApplyBuy;
import com.arjjs.ccm.modules.plm.car.service.apply.PlmCarApplyBuyService;
import com.arjjs.ccm.modules.sys.utils.DictUtils;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.PlmTypes;
import com.arjjs.ccm.tool.pdf.PdfDocumentGenerator;
import com.arjjs.ccm.tool.pdf.ResourceUitle;
import com.arjjs.ccm.tool.pdf.exception.DocumentGeneratingException;

/**
 * 购车申请Controller
 * @author fu
 * @version 2018-07-07
 */
@Controller
@RequestMapping(value = "${adminPath}/car/apply/plmCarApplyBuy")
public class PlmCarApplyBuyController extends BaseController {

	@Autowired
	private PlmCarApplyBuyService plmCarApplyBuyService;
	@Autowired
	private ActTaskService actTaskService;
	@Autowired
	private PlmActService plmActService;	
	
	@ModelAttribute
	public PlmCarApplyBuy get(@RequestParam(required=false) String id) {
		PlmCarApplyBuy entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = plmCarApplyBuyService.get(id);
			//添加业务流程主表信息
			if(entity!=null) {
				PlmAct plmAct = plmActService.getByTable(entity.getId(), PlmTypes.CAR_APPLY_BUY_ID);
				if(plmAct!=null) {
					entity.setPlmAct(plmAct);
				}
			}
		}
		if (entity == null){
			entity = new PlmCarApplyBuy();
			entity.setUser(UserUtils.getUser());
		}
		return entity;
	}
	
	@RequestMapping(value = {"list", ""})
	public String list(PlmCarApplyBuy plmCarApplyBuy, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PlmCarApplyBuy> page = plmCarApplyBuyService.findPage(new Page<PlmCarApplyBuy>(request, response), plmCarApplyBuy); 
		model.addAttribute("page", page);
		return "plm/car/apply/plmCarApplyBuyList";
	}

	@RequestMapping(value = "form")
	public String form(PlmCarApplyBuy plmCarApplyBuy, Model model) {
		
		plmCarApplyBuy.getAct().setProcInsId(plmCarApplyBuy.getProcInsId());
		

		String view = "plmCarApplyBuyForm";
		
		// 查看审批申请单
		if (StringUtils.isNotBlank(plmCarApplyBuy.getProcInsId())){

			// 环节编号
			String taskDefKey = plmCarApplyBuy.getAct().getTaskDefKey();
			
			// 查看工单
			if(plmCarApplyBuy.getAct().isFinishTask()){
				view = "plmCarApplyBuyView";
			}
			// 修改环节
			else if ("modify".equals(taskDefKey)){
				view = "plmCarApplyBuyForm";
			}
			// 审核环节1
			else {
				view = "plmCarApplyBuyAudit";
			}
		}
		String cancelFlag = "0";
		if (StringUtils.isNotBlank(plmCarApplyBuy.getCancelFlag()) && "02".equals(plmCarApplyBuy.getCancelFlag())) {
			cancelFlag = "1";
		}
		model.addAttribute("cancelFlag", cancelFlag);
		model.addAttribute("plmCarApplyBuy", plmCarApplyBuy);
		return "plm/car/apply/" + view;
	}

	@RequestMapping(value = "save")
	public String save(PlmCarApplyBuy plmCarApplyBuy, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, plmCarApplyBuy)){
			return form(plmCarApplyBuy, model);
		}
		plmCarApplyBuyService.save(plmCarApplyBuy);
		addMessage(redirectAttributes, "保存购车申请成功");
		return "redirect:" + Global.getAdminPath() + "/act/task/apply/";
	}
	@RequestMapping(value = "apply")
	public String apply(PlmCarApplyBuy plmCarApplyBuy, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, plmCarApplyBuy)){
			return form(plmCarApplyBuy, model);
		}
		plmCarApplyBuyService.apply(plmCarApplyBuy);

		addMessage(redirectAttributes, "提交购车申请成功");
		return "redirect:" + Global.getAdminPath() + "/act/task/apply/";
	}
	/**
	 * 工单执行（完成任务）
	 * @param testAudit
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "saveAudit")
	public String saveAudit(PlmCarApplyBuy plmCarApplyBuy, Model model) {
		if (StringUtils.isBlank(plmCarApplyBuy.getAct().getFlag())
				|| StringUtils.isBlank(plmCarApplyBuy.getAct().getComment())){
			addMessage(model, "请填写审核意见。");
			return form(plmCarApplyBuy, model);
		}
		plmCarApplyBuyService.auditSave(plmCarApplyBuy);
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	@RequestMapping(value = "delete")
	public String delete(PlmCarApplyBuy plmCarApplyBuy, RedirectAttributes redirectAttributes) {
		plmCarApplyBuyService.delete(plmCarApplyBuy);
		addMessage(redirectAttributes, "删除购车申请成功");
		return "redirect:"+Global.getAdminPath()+"/car/apply/plmCarApplyBuy/?repage";
	}
	@ResponseBody
	@RequestMapping(value = "printPdfIo")
	public void printPdfIo(PlmCarApplyBuy plmCarApplyBuy, Model model, RedirectAttributes redirectAttributes ,HttpServletRequest request ,HttpServletResponse response ) throws DocumentGeneratingException{
		
		
		      //将对象转成map 并将时间类型格式化"yyyy-MM-dd"
		      Map<String, Object> purmap=ResourceUitle.transBean2Map(plmCarApplyBuy);	
		      
		      //有数据字典的  要换成名称
		      if(StringUtils.isNotBlank(plmCarApplyBuy.getPlmAct().getIsSup())){
		    	  purmap.put("isSup",DictUtils.getDictLabel(plmCarApplyBuy.getPlmAct().getIsSup(),"yes_no",""));
		      }
		      //流转信息  actProcIns
		      plmCarApplyBuy.getAct().setProcInsId(plmCarApplyBuy.getProcInsId());
		      
		      //1: ProcInsId   2审批内容跨列数Colspan      3审批标题跨列数titleColspan
		      purmap.put("actProcIns",actTaskService.histoicTable(plmCarApplyBuy.getProcInsId(), "6" ,"2"));
		      
		      
		     //获取项目根路径
		     String path=request.getSession().getServletContext().getRealPath("/");
		       // classpath 中模板路径
				String template = "WEB-INF/views/plm/car/apply/plmCarApplyBuyViewTemplate.html";
				PdfDocumentGenerator pdfGenerator = new PdfDocumentGenerator();
				// 生成pdf 返回流			
				pdfGenerator.generate(template, purmap, path,response);			          		            
		              
		            		
	}
}