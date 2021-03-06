package com.arjjs.ccm.modules.pbs.task.web;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.DateUtils;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.pbs.common.web.BaseController;
import com.arjjs.ccm.modules.pbs.person.service.PbsPartymembindService;
import com.arjjs.ccm.modules.pbs.sys.utils.UserUtils;
import com.arjjs.ccm.modules.pbs.task.entity.PbsTaskevaluate;
import com.arjjs.ccm.modules.pbs.task.entity.PbsTaskoprec;
import com.arjjs.ccm.modules.pbs.task.entity.PbsTaskrec;
import com.arjjs.ccm.modules.pbs.task.service.PbsTaskevaluateService;
import com.arjjs.ccm.modules.pbs.task.service.PbsTaskoprecService;
import com.arjjs.ccm.modules.pbs.task.service.PbsTaskrecService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;


@Controller
@RequestMapping("${adminPath}/work/pbsWork")
public class PbsTaskPCController extends BaseController {
	
	@Autowired
	private PbsTaskrecService pbstaskrecservice;
	@Autowired
	private PbsTaskoprecService pbsTaskoprecService;
	@Autowired
	private PbsTaskevaluateService pbsTaskevaluateService;
	@Autowired
	private PbsPartymembindService pbsPartymembindService;
	
	@RequestMapping({"givemeList",""})
	public String dealtMyList(PbsTaskrec pbsTaskrec, Model model,HttpServletRequest request, HttpServletResponse response) {
		// 当前如果没有党员关系
		if (StringUtils.isNotBlank(UserUtils.getPartymem().getId())) {
			PbsTaskrec pbsTaskrecDto = new PbsTaskrec();
			pbsTaskrecDto.setsBindmember(UserUtils.getPartymem());
			pbsTaskrecDto.setSResume(pbsTaskrec.getSResume());
			pbsTaskrecDto.setCreateDate(pbsTaskrec.getCreateDate());
			pbsTaskrecDto.setsDeadline(pbsTaskrec.getsDeadline());
			pbsTaskrecDto.setsOptstatus(pbsTaskrec.getsOptstatus());
			Page<PbsTaskrec> page = pbstaskrecservice.findPage(new Page<PbsTaskrec>(request, response), pbsTaskrecDto);
			model.addAttribute("page",page);
		}
		return "pbs/work/pbsGivemeList";
	}
	
	//查询表单中的内容
	@RequestMapping("form")
	public String form(PbsTaskrec pbsTaskrec, Model model ) {
		model.addAttribute("pbsTaskrec",pbsTaskrec);
		return "/pbs/work/pbsAssign";
	}
	
	// 我派发的 任务列表
	@RequestMapping(value = "distributedList")
	public String distributedList(PbsTaskrec pbsTaskrec, Model model, HttpServletRequest request, HttpServletResponse response) {
		// 当前如果没有党员关系
//		if (StringUtils.isNotBlank(UserUtils.getPartymem().getId())) {
			PbsTaskrec pbsTaskrecDto = new PbsTaskrec();
//			pbsTaskrecDto.setsExecutor(UserUtils.getPartymem());
//			pbsTaskrecDto.setSResume(pbsTaskrec.getSResume());
//			pbsTaskrecDto.setCreateDate(pbsTaskrec.getCreateDate());
//			pbsTaskrecDto.setsDeadline(pbsTaskrec.getsDeadline());
//			pbsTaskrecDto.setsOptstatus(pbsTaskrec.getsOptstatus());
			pbsTaskrecDto.setCreateBy(UserUtils.getUser());
			Page<PbsTaskrec> page = pbstaskrecservice.findPage(new Page<PbsTaskrec>(request, response), pbsTaskrecDto);
			model.addAttribute("page",page);
//		}
		return "pbs/work/pbsDistributedList";
	}
	
	// 派发给我的 具体任务
	@RequestMapping(value = "givemeInfo")
	public String givemeInfo(String id, Model model) {
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		// 为了查询 接收时间
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		pbsTaskoprecDto.setsTaskid(new PbsTaskrec(id));
		pbsTaskoprecDto.setSOptstatus("ACCEPT");
		List<PbsTaskoprec> pbsTaskoprecs = pbsTaskoprecService.findList(pbsTaskoprecDto);
		if (pbsTaskoprecs.size() > 0) {
			model.addAttribute("taskoprecs", pbsTaskoprecs.get(0));
		}
		model.addAttribute("task", pbsTaskrec);
		return "/pbs/work/pbsGivemeInfo";
	}
	// 我派发的 具体任务
	@RequestMapping(value = "distributedInfo")
	public String distributedInfo(String id, Model model) {
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		model.addAttribute("pbsTaskrec", pbsTaskrec);
		boolean flag = false;
		// 查询 操作记录
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		pbsTaskoprecDto.setsTaskid(new PbsTaskrec(id));
		List<PbsTaskoprec> pbsTaskoprecs = pbsTaskoprecService.findList(pbsTaskoprecDto);
		// 返回
		for (PbsTaskoprec taskoprec : pbsTaskoprecs) {
			// 接收操作
			if (("1").equals(taskoprec.getSType())) {
				model.addAttribute("acceptoprecs", taskoprec);
			}
			// 反馈操作
			if (("2").equals(taskoprec.getSType())) {
				flag = true;
			}
		}
		model.addAttribute("feedbackoprecs", flag);
		return "pbs/work/pbsDistributedInfo";
	}
	// 查看评价结果
	@RequestMapping(value = "taskValueInfo")
	public String taskValueInfo(String id, Model model) {
		// 获取到 工作安排
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		model.addAttribute("pbsTaskrec", pbsTaskrec);
		// 获取到 任务
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		pbsTaskoprecDto.setsTaskid(new PbsTaskrec(id));
		// 返回反馈操作信息
		pbsTaskoprecDto.setSType("3");
		List<PbsTaskoprec> pbsTaskoprecs = pbsTaskoprecService.findList(pbsTaskoprecDto);
		if (pbsTaskoprecs.size() > 0) {
			model.addAttribute("taskoprecs", pbsTaskoprecs.get(0));
		}
		// 返回评价价值
		PbsTaskevaluate pbsTaskevaluateDto = new PbsTaskevaluate();
		pbsTaskevaluateDto.setsTaskid(pbsTaskrec);
		List<PbsTaskevaluate> pbsTaskevaluateList = pbsTaskevaluateService.findList(pbsTaskevaluateDto);
		if (pbsTaskevaluateList.size() > 0) {
			model.addAttribute("taskevaluate", pbsTaskevaluateList.get(0));
		}
		return "pbs/work/pbsTaskValue";
	}
	
	// 取消 工作安排
	@ResponseBody
	@RequestMapping(value = "cancelTask")
	public String cancelTask(String id, String handletype, Model model) {
		// 首先获取 当前 任务
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		// 赋值 操作
		pbsTaskoprecDto.setsTaskid(pbsTaskrec);
		pbsTaskoprecDto.setSSort("99");
		pbsTaskoprecDto.setSType("99");
		pbsTaskoprecDto.setSContent(UserUtils.getUser().getName() + "取消任务.");
		pbsTaskoprecDto.setsExecdepartment(pbsTaskrec.getsExecdepartment());
		pbsTaskoprecDto.setsExecutor(pbsTaskrec.getsExecutor());
		pbsTaskoprecDto.setsOperator(UserUtils.getUser());
		pbsTaskoprecDto.setsBindmember(pbsTaskrec.getsBindmember());
		// 取消 任务
		pbsTaskoprecDto.setSOptstatus("CANECL");
		pbsTaskoprecService.save(pbsTaskoprecDto);
		return handletype;
	}
	
	// 接收任务
	@ResponseBody
	@RequestMapping(value = "receiveTask")
	public String receiveTask(String id, String handletype, Model model) {
		// 查询该操作是否已经存在
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		pbsTaskoprecDto.setsOperator(UserUtils.getUser());
		pbsTaskoprecDto.setSOptstatus("ACCEPT");
		pbsTaskoprecDto.setsTaskid(new PbsTaskrec(id));
		// 如果存在则 返回失败
		if (pbsTaskoprecService.checkExist(pbsTaskoprecDto)) {
			return FAIL;
		}
		// 获取 记录 补充信息
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		// 接收操作
		pbsTaskoprecDto.setSContent(UserUtils.getUser().getName() + "于" + DateUtils.getDate() + "接受任务");
		pbsTaskoprecDto.setsExecdepartment(pbsTaskrec.getsExecdepartment());
		pbsTaskoprecDto.setsExecutor(pbsTaskrec.getsExecutor());
		pbsTaskoprecDto.setsBindmember(pbsTaskrec.getsBindmember());
		//
		pbsTaskoprecDto.setSSort("2");
		pbsTaskoprecDto.setSType("2");
		pbsTaskoprecService.save(pbsTaskoprecDto);
		return SUCCESS;
	}
	
	// 反馈任务完成度
	@RequestMapping(value = "givemefeedback")
	public String givemefeedback(String id, Model model) {
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		model.addAttribute("task", pbsTaskrec);
		return "pbs/work/pbsGivemeFeedback";
	}
	
	// 反馈任务完成情况
	@ResponseBody
	@RequestMapping(value = "applyFinish")
	public String applyFinish(PbsTaskoprec pbsTaskoprec, Model model) {
		pbsTaskoprec.setsOperator(UserUtils.getUser());
		// 获取 记录 补充信息
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(pbsTaskoprec.getsTaskid());
		pbsTaskoprec.setsExecdepartment(pbsTaskrec.getsExecdepartment());
		pbsTaskoprec.setsExecutor(pbsTaskrec.getsExecutor());
		pbsTaskoprec.setsBindmember(pbsTaskrec.getsBindmember());
		// 代表 反馈任务
		pbsTaskoprec.setSSort("3");
		pbsTaskoprec.setSType("3");
		// 如果存在则 返回失败
		if (pbsTaskoprecService.checkExist(pbsTaskoprec)) {
			return FAIL;
		}
		// 保存信息
		pbsTaskoprecService.save(pbsTaskoprec);
		return SUCCESS;
	}
	// 反馈任务
	@RequestMapping(value = "distributedfeedback")
	public String distributedfeedback(String id, Model model) {
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(id);
		model.addAttribute("pbsTaskrec", pbsTaskrec);
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		pbsTaskoprecDto.setsTaskid(new PbsTaskrec(id));
		// 返回反馈操作信息
		pbsTaskoprecDto.setSType("3");
		List<PbsTaskoprec> pbsTaskoprecs = pbsTaskoprecService.findList(pbsTaskoprecDto);
		if (pbsTaskoprecs.size() > 0) {
			model.addAttribute("taskoprecs", pbsTaskoprecs.get(0));
		}
		return "pbs/work/pbsDistributedFeedback";
	}
	// 评价任务完成情况
	@ResponseBody
	@RequestMapping(value = "applyValue")
	public String applyValue(PbsTaskevaluate pbsTaskevaluate, Model model) {
		// 获取 工作安排记录
		PbsTaskrec pbsTaskrec = pbstaskrecservice.get(pbsTaskevaluate.getsTaskid());
		// 创建 工作安排操作记录
		PbsTaskoprec pbsTaskoprecDto = new PbsTaskoprec();
		pbsTaskoprecDto.setsOperator(UserUtils.getUser());
		// 完成记录
		pbsTaskoprecDto.setSOptstatus("FINISH");
		pbsTaskoprecDto.setsTaskid(pbsTaskrec);
		// 如果存在则 返回失败
		if (pbsTaskoprecService.checkExist(pbsTaskoprecDto)) {
			return FAIL;
		}
		// 接收操作
		pbsTaskoprecDto.setSContent(UserUtils.getUser().getName() + "于" + DateUtils.getDate() + "完成评价记录");
		pbsTaskoprecDto.setsExecdepartment(pbsTaskrec.getsExecdepartment());
		pbsTaskoprecDto.setsExecutor(pbsTaskrec.getsExecutor());
		pbsTaskoprecDto.setsBindmember(pbsTaskrec.getsBindmember());
		// 评价记录
		pbsTaskoprecDto.setSSort("4");
		pbsTaskoprecDto.setSType("4");
		// 更新操作记录
		pbsTaskoprecService.save(pbsTaskoprecDto);
		// 评价记录 获取指定用户 的 党员信息
		pbsTaskevaluate.setsExecmember(pbsPartymembindService.getItemByUser(UserUtils.getUser().getId()));
		pbsTaskevaluate.setsOperator(UserUtils.getUser());
		pbsTaskevaluate.setsBindmember(pbsTaskrec.getsBindmember());
		// 更新 评价记录
		pbsTaskevaluateService.save(pbsTaskevaluate);
		return SUCCESS;
	}
	
	/**
	 * 工作任务
	 **/
	// 提交申请
	@ResponseBody
	@RequestMapping(value = "addapply")
	public String addapply(PbsTaskrec pbsTaskrec, Model model, RedirectAttributes redirectAttributes) {
		pbstaskrecservice.save(pbsTaskrec);
		return SUCCESS;
	}
}
