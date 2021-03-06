/**
 * Copyright &copy; 2012-2018 All rights reserved.
 */
package com.arjjs.ccm.modules.plm.allot.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
import com.arjjs.ccm.modules.act.entity.Act;
import com.arjjs.ccm.modules.act.service.ActTaskService;
import com.arjjs.ccm.modules.act.service.ActUtConfigService;
import com.arjjs.ccm.modules.plm.act.entity.PlmAct;
import com.arjjs.ccm.modules.plm.act.service.PlmActService;
import com.arjjs.ccm.modules.plm.allot.entity.PlmAllot;
import com.arjjs.ccm.modules.plm.allot.entity.PlmAllotDetail;
import com.arjjs.ccm.modules.plm.allot.service.PlmAllotDetailService;
import com.arjjs.ccm.modules.plm.allot.service.PlmAllotService;
import com.arjjs.ccm.modules.plm.storage.entity.AjaxResultEntity;
import com.arjjs.ccm.modules.plm.storage.entity.PlmEquipment;
import com.arjjs.ccm.modules.plm.storage.service.PlmEquipmentService;
import com.arjjs.ccm.modules.plm.storage.service.PlmMinusandAddDetailService;
import com.arjjs.ccm.modules.plm.storage.web.PlmOutController;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.OfficeService;
import com.arjjs.ccm.modules.sys.utils.DictUtils;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.PlmTypes;
import com.arjjs.ccm.tool.pdf.PdfDocumentGenerator;
import com.arjjs.ccm.tool.pdf.ResourceUitle;
import com.arjjs.ccm.tool.pdf.exception.DocumentGeneratingException;
import com.google.common.collect.Maps;

/**
 * 内部调拨Controller
 * @author dongqikai
 * @version 2018-08-16
 */
@Controller
@RequestMapping(value = "${adminPath}/allot/plmAllot")
public class PlmAllotController extends BaseController {

	@Autowired
	private PlmAllotService plmAllotService;
	@Autowired
	private PlmActService plmActService;
	@Autowired
	private ActTaskService actTaskService;
	@Autowired
	private ActUtConfigService<PlmAllot> actUtConfigService;
	@Autowired
	private OfficeService officeService;
	@Autowired
	private PlmEquipmentService plmEquipmentService;
	@Autowired
	private PlmMinusandAddDetailService plmMinusandAddDetailService;
	@Autowired
	private PlmAllotDetailService plmAllotDetailService;
	
	@ModelAttribute
	public PlmAllot get(@RequestParam(required=false) String id) {
		PlmAllot entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = plmAllotService.get(id);
			//添加业务流程主表信息
			if(entity!=null) {
				PlmAct plmAct = plmActService.getByTable(entity.getId(), PlmTypes.ALLOT_APPLY);
				if(plmAct!=null) {
					entity.setPlmAct(plmAct);
				}
			}
		}
		if (entity == null){
			entity = new PlmAllot();
		}
		return entity;
	}
	
	@RequestMapping(value = {"list", ""})
	public String list(PlmAllot plmAllot, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PlmAllot> page = plmAllotService.findPage(new Page<PlmAllot>(request, response), plmAllot); 
		model.addAttribute("page", page);
		return "plm/allot/plmAllotList";
	}

	@RequestMapping(value = "form")
	public String form(PlmAllot plmAllot, Model model) {
		String viewPage = "plmAllotForm";
		List<PlmAllotDetail> detailList = new ArrayList<>();
		if (StringUtils.isBlank(plmAllot.getId())) {
			plmAllot.setApplyer(UserUtils.getUser());
			plmAllot.setAddDate(new Date());
		} else {
			PlmAllotDetail plmAllotDetail = new PlmAllotDetail();
			plmAllotDetail.setAllotId(plmAllot.getId());
			detailList = plmAllotDetailService.findList(plmAllotDetail);
		}
		model.addAttribute("detailList", detailList);
		StringBuffer selectRemarks = new StringBuffer();
		if (detailList != null && detailList.size() > 0) {//将物资id和备注拼接
			for (int i = 0; i < detailList.size(); i++) {
				if (i != 0) {
					selectRemarks.append("@");
				}
				selectRemarks.append(detailList.get(i).getEquCode()+":"+detailList.get(i).getRemarks());
			}
		}
		plmAllot.setSelectRemarks(selectRemarks.toString());
		if (StringUtils.isNotBlank(plmAllot.getProcInsId())) {
			Act act = plmAllot.getAct();
			String taskDefKey = act.getTaskDefKey();
			if (act.isFinishTask()) {
				viewPage = "plmAllotFormView";
			} else if ("modify".equals(taskDefKey)) {
				viewPage = "plmAllotForm";
			} else if ("processEnd".equals(taskDefKey)) {
				viewPage = "plmAllotFormAudit";
				//终点无审核 去掉驳回按钮
				model.addAttribute("rejectedBtn", false);
			}else {
				viewPage = "plmAllotFormAudit";
				//终点审核 加驳回按钮
				model.addAttribute("rejectedBtn", true);
			} 
		}
		String cancelFlag = "0";
		if (StringUtils.isNotBlank(plmAllot.getCancelFlag()) && "02".equals(plmAllot.getCancelFlag())) {
			cancelFlag = "1";
		}
		model.addAttribute("cancelFlag", cancelFlag);
		model.addAttribute("plmAllot", plmAllot);
		model.addAttribute("page", new Page<>().toString());
		return "plm/allot/" + viewPage;
	}

	@RequestMapping(value = "save")
	public String save(PlmAllot plmAllot, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, plmAllot)){
			return form(plmAllot, model);
		}
		plmAllotService.save(plmAllot);

		//parameter ： 1、业务流程主表  2、流程配置id 3、业务表*
		plmActService.save(plmAllot.getPlmAct(),PlmTypes.ALLOT_APPLY,plmAllot.getId());
		addMessage(redirectAttributes, "保存调拨单成功");
		return "redirect:" + Global.getAdminPath() + "/act/task/apply/";
	}
	
	@RequestMapping(value = "apply")
	public String apply(PlmAllot plmAllot, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, plmAllot)){
			return form(plmAllot, model);
		}
		plmAllotService.save(plmAllot);
		if (StringUtils.isBlank(plmAllot.getProcInsId())) {
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("outsidePerson", UserUtils.get(plmAllot.getOutManager().getId()).getLoginName());
			
			vars.put("outsideManager", officeService.get(plmAllot.getOutDep().getId()).getPrimaryPerson().getLoginName());
			vars.put("insideManager", officeService.get(plmAllot.getInDep().getId()).getPrimaryPerson().getLoginName());
			Map<String, String> returnMap = actUtConfigService.getProcInsId(PlmTypes.ALLOT_APPLY, plmAllot, plmAllot.getId(), vars);
			plmAllot.setProcInsId(returnMap.get("procInsId"));
			plmAllotService.save(plmAllot);
			//保存业务流程主表*
			plmAllot.getPlmAct().setTitle(returnMap.get("title"));
			plmActService.save(plmAllot.getPlmAct(),PlmTypes.ALLOT_APPLY,plmAllot.getId(),plmAllot.getProcInsId());
			
		} else {
			plmAllot.getAct().setComment(("yes".equals(plmAllot.getAct().getFlag())?"[重申] ":"[撤销] ")
					+ plmAllot.getAct().getComment());
			Map<String, Object> vars = Maps.newHashMap();
			
			vars.put("pass", "yes".equals(plmAllot.getAct().getFlag())? "1" : "0");
			actTaskService.complete(plmAllot.getAct().getTaskId(), plmAllot.getAct().getProcInsId(),
					plmAllot.getAct().getComment(), "", vars);
			//如果销毁，将业务流程主表状态置位“已销毁”*
			if(!"yes".equals(plmAllot.getAct().getFlag())){				
				plmActService.updateStatusToDestory(plmAllot.getPlmAct());
			}
			
		}
		addMessage(redirectAttributes, "提交调拨申请成功");
		return "redirect:" + Global.getAdminPath() + "/act/task/apply/";
	}
	

	@RequestMapping(value = "saveAudit")
	public String saveAudit(PlmAllot plmAllot, Model model) {
		if (StringUtils.isBlank(plmAllot.getAct().getFlag())
				|| StringUtils.isBlank(plmAllot.getAct().getComment())){
			addMessage(model, "请填写审核意见。");
			return form(plmAllot, model);
		}
		// 对不同环节的业务逻辑进行操作*
		String taskDefKey = plmAllot.getAct().getTaskDefKey();
		
		
		
		// 最后一步流程且   需要审核
				if ("auditEnd".equals(taskDefKey)) {							
					// 若为最后一步审核，通过，将业务流程主表状态置位“已结束”
					if ("yes".equals(plmAllot.getAct().getFlag())) {
						plmActService.updateStatusToEnd(plmAllot.getPlmAct());   
						//调拨流程结束后  改变使用物品部分 和使用人
						Office 	inDep=plmAllot.getInDep();
						User inManager=plmAllot.getInManager();
						PlmAllotDetail plmAllotDetail = new PlmAllotDetail();
						plmAllotDetail.setAllotId(plmAllot.getId());
						List<PlmAllotDetail> detailList  = plmAllotDetailService.findList(plmAllotDetail);					
					for (PlmAllotDetail plmAllotDetail2 : detailList) {
						PlmEquipment	plmEquipment=new PlmEquipment();
						plmEquipment.setCode(plmAllotDetail2.getCode());
						plmEquipment.setUserJob(inDep);
						plmEquipment.setUser(inManager);
						plmEquipmentService.updateUserAndUserJob(plmEquipment);
					}
						
					}
				}
				// 最后一步流程  不需要审核
				else if ("processEnd".equals(taskDefKey)) {				
					// 将业务流程主表状态置位“已结束”			
						plmActService.updateStatusToEnd(plmAllot.getPlmAct()); 
						//调拨流程结束后  改变使用物品部分 和使用人
						Office 	inDep=plmAllot.getInDep();
						User inManager=plmAllot.getInManager();
						PlmAllotDetail plmAllotDetail = new PlmAllotDetail();
						plmAllotDetail.setAllotId(plmAllot.getId());
						List<PlmAllotDetail> detailList  = plmAllotDetailService.findList(plmAllotDetail);					
					for (PlmAllotDetail plmAllotDetail2 : detailList) {
						PlmEquipment	plmEquipment=new PlmEquipment();
						plmEquipment.setCode(plmAllotDetail2.getCode());
						plmEquipment.setUserJob(inDep);
						plmEquipment.setUser(inManager);
						plmEquipmentService.updateUserAndUserJob(plmEquipment);
					}
				}
				// 未知环节，直接返回
				else if (StringUtils.isBlank(taskDefKey)) {
					return "redirect:" + adminPath + "/act/task/todo/";
				}
				 // 针对所有具有添加督办的环节，若为isSup字段不为空，添加督办信息
				if (StringUtils.isNotBlank(plmAllot.getPlmAct().getIsSup())) {
					plmActService.updateSup(plmAllot.getPlmAct());
				}
		
		plmAllotService.auditSave(plmAllot);
		return "redirect:" + adminPath + "/act/task/todo/";
	}
	
	@RequestMapping(value = "delete")
	public String delete(PlmAllot plmAllot, RedirectAttributes redirectAttributes) {
		plmAllotService.delete(plmAllot);
		addMessage(redirectAttributes, "删除调拨单成功");
		return "redirect:"+Global.getAdminPath()+"/allot/plmAllot/?repage";
	}
	
	/**
	 * 加载物资选择
	 * @param plmEquipment
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "equipmentSelect")
	public AjaxResultEntity equipmentSelect(PlmEquipment plmEquipment, HttpServletRequest request, HttpServletResponse response, Model model) {
		AjaxResultEntity ajaxResultEntity = new AjaxResultEntity();
		plmEquipment.setType(PlmEquipment.USING_STATUS);
		ajaxResultEntity.setMessage("保存成功");
		List<PlmEquipment> list = plmEquipmentService.findList(plmEquipment);
		StringBuffer html = new StringBuffer();
		for(int i = 0; i < list.size(); i++) {
			PlmEquipment equ = list.get(i);
			html.append("<tr>");
			html.append(PlmOutController.getTd("<input name='checkItem' type='checkbox' value='"+equ.getId()+"'/>"));
			html.append(PlmOutController.getTd(equ.getName()));
			html.append(PlmOutController.getTd(equ.getCode()));
			html.append(PlmOutController.getTd(equ.getSpec()));
			html.append(PlmOutController.getTd(DictUtils.getDictLabel(equ.getTypeId(), "plm_equipment_type", "未知")));
			html.append(PlmOutController.getTd(DictUtils.getDictLabel(equ.getTypeChild(), "plm_equipment_type_child", "未知")));
			html.append(PlmOutController.getTd(equ.getUser().getName()));
			html.append("<td style='display:none'><input id='"+equ.getId()+"' type='hidden' value=\""+getEquHTML(equ)+"\"/></td>");
			html.append("</tr>");
		}
		ajaxResultEntity.setResult(html.toString());
		ajaxResultEntity.setRet(AjaxResultEntity.ERROR_OK);
		return ajaxResultEntity;
	}
	
	public String getEquHTML(PlmEquipment plmEquipment) {
		StringBuffer htmlBuffer = new StringBuffer();
		htmlBuffer.append("<tr>");
		htmlBuffer.append(PlmOutController.getTd(plmEquipment.getName()));
		htmlBuffer.append(PlmOutController.getTd(plmEquipment.getSpec()));
		htmlBuffer.append(PlmOutController.getTd(plmEquipment.getUnit()));
		htmlBuffer.append(PlmOutController.getTd(plmEquipment.getErialNumber().toString()));
		if (StringUtils.isNotBlank(plmEquipment.getPrice())) {
			htmlBuffer.append(PlmOutController.getTd(plmEquipment.getPrice()));
			int erialNumber = plmEquipment.getErialNumber();
			double price = Double.parseDouble(plmEquipment.getPrice());
			double sum = erialNumber*price;
			htmlBuffer.append("<td class='detailSum'>" + sum + "</td>");
		} else {
			htmlBuffer.append(PlmOutController.getTd(""));
			htmlBuffer.append(PlmOutController.getTd(""));
		}
		try {
			htmlBuffer.append(PlmOutController.getTd("<img src='data:image/jpeg;base64,"+plmMinusandAddDetailService.qrCodeWithBase64(plmEquipment.getCode())+"'/>"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		htmlBuffer.append(PlmOutController.getTd("<input id='"+plmEquipment.getId()+"' type='text' value='' onchange='updateRemark(this);'/>"));
		htmlBuffer.append(PlmOutController.getTd("<a href='javascript:void(0);' onclick='removeSelect(this);'><i title='删除' class='icon-trash'></i></a>"));
		htmlBuffer.append("</tr>");
		return htmlBuffer.toString();
	}
	
	/**
	 * 保存选择的调拨物资
	 * @param ids
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveEquipment")
	public AjaxResultEntity saveEquipment(String[] ids, HttpServletRequest request, HttpServletResponse response) {
		AjaxResultEntity ajaxResultEntity = new AjaxResultEntity();
		if (ids == null || !(ids.length > 0)) {
			ajaxResultEntity.setMessage("参数错误！");
			ajaxResultEntity.setRet(AjaxResultEntity.ERROR_PARAM);
		}
		ajaxResultEntity.setMessage("保存成功");
		ajaxResultEntity.setRet(AjaxResultEntity.ERROR_OK);
		return ajaxResultEntity;
	}
	/**
     * 生成pdf  (返回流)
     * @param plmAllot
     * @param model
     * @param redirectAttributes
     * @return
	 * @throws DocumentGeneratingException 
	 * @throws IOException 
     */
	@ResponseBody
	@RequestMapping(value = "printPdfIo")
	public void printPdfIo(PlmAllot plmAllot, Model model, RedirectAttributes redirectAttributes ,HttpServletRequest request ,HttpServletResponse response ) throws DocumentGeneratingException {
		
		
		      //将对象转成map 并将时间类型格式化"yyyy-MM-dd"
		      Map<String, Object> purmap=ResourceUitle.transBean2Map(plmAllot);	
		      
		      if(StringUtils.isNotBlank(plmAllot.getPlmAct().getIsSup())){
		    	  purmap.put("isSup",DictUtils.getDictLabel(plmAllot.getPlmAct().getIsSup(),"yes_no",""));
		      }	
	          
		      PlmAllotDetail plmAllotDetail = new PlmAllotDetail();
				plmAllotDetail.setAllotId(plmAllot.getId());
				 List<PlmAllotDetail> detlist = plmAllotDetailService.findList(plmAllotDetail);
		      
		
		      String detail="";
		      
		      for (PlmAllotDetail plmAllotDetail2 : detlist) {
		    	 
		    	  
				detail+="<tr >						\n" + 
						"							<td style='border-left: 0px; '>\n" + 
						                           plmAllotDetail2.getName()+
						"							</td>\n" + 
						"							<td>\n" + 
						                              plmAllotDetail2.getSpec()  + 
						"							</td>\n" + 
						"							<td>\n" + 
													 plmAllotDetail2.getUnit()  + 
						"							</td>\n" + 
						"							<td>\n" + 
														 plmAllotDetail2.getErialNumber()  + 
						"							</td>\n" + 
						"							<td>\n" + 
														 plmAllotDetail2.getPrice() + 
						"							</td>\n" + 
						"							<td>\n" + 
														 plmAllotDetail2.getSum() + 
						"							</td>\n" + 
						"							<td>\n<img src='data:image/jpeg;base64,"+ plmAllotDetail2.getQrCode()+"'/>" + 
						"							</td>													\n" + 
						"							<td>\n" + 
						                                   plmAllotDetail2.getRemarks()  + 
                        "							</td>													\n" + 
						"							\n" + 
						"						</tr>";
			}
		      
		         
		      purmap.put("detail", detail.replaceAll("null", ""));
		      
		      
		      //流转信息  actProcIns
		      plmAllot.getAct().setProcInsId(plmAllot.getProcInsId());		      
		      //1: ProcInsId   2审批内容跨列数Colspan      3审批标题跨列数titleColspan
		      purmap.put("actProcIns",actTaskService.histoicTable(plmAllot.getProcInsId(), "5" ,"1"));
		      
		      
		     //获取项目根路径
		     String path=request.getSession().getServletContext().getRealPath("/");
		       // classpath 中模板路径
				String template = "WEB-INF/views/plm/allot/plmAllotViewTemplate.html";
				PdfDocumentGenerator pdfGenerator = new PdfDocumentGenerator();
				// 生成pdf 返回流			
			    pdfGenerator.generate(template, purmap, path,response);		            		
	}

}