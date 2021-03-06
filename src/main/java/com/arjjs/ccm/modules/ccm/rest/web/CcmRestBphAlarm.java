package com.arjjs.ccm.modules.ccm.rest.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.rest.entity.*;
import com.arjjs.ccm.modules.ccm.rest.service.AlarmHandleFileService;
import com.arjjs.ccm.modules.ccm.rest.service.AlarmNotifyService;
import com.arjjs.ccm.modules.ccm.sys.entity.SysDict;
import com.arjjs.ccm.modules.ccm.sys.service.SysConfigService;
import com.arjjs.ccm.modules.ccm.work.service.CcmWorkNoticeService;
import com.arjjs.ccm.modules.flat.alarm.entity.BphAlarmInfo;
import com.arjjs.ccm.modules.flat.alarm.service.BphAlarmInfoService;
import com.arjjs.ccm.modules.flat.alarmhandlelog.entity.BphAlarmHandleLog;
import com.arjjs.ccm.modules.flat.alarmhandlelog.service.BphAlarmHandleLogService;
import com.arjjs.ccm.modules.flat.handle.entity.AlarmHandleDayInfo;
import com.arjjs.ccm.modules.flat.handle.entity.BphAlarmHandle;
import com.arjjs.ccm.modules.flat.handle.service.BphAlarmHandleService;
import com.arjjs.ccm.modules.oa.service.OaNotifyService;
import com.arjjs.ccm.modules.sys.entity.Office;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.service.DictService;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.AmrFileTimeLengthSample;
import com.arjjs.ccm.tool.ShareUtil;
import groovy.util.logging.Slf4j;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import it.sauronsoftware.jave.Encoder;
import it.sauronsoftware.jave.MultimediaInfo;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * 指挥调度app
 * @author maoxiaobin
 * @version 2019-11-28
 * @author maoxiaobin
 * @version 2019-11-28 警情的查询，更新
 */
@RestController
@RequestMapping(value = "${appPath}/rest/bphAlarmService")
@Api(description = "指挥调度-警情相关-app接口类")
@Slf4j
public class CcmRestBphAlarm extends BaseController {


    public static final String PREFIX  = "/androidService/d/";

    private static final String IMAGEMAT = "png";

	@Autowired
	private BphAlarmHandleService handleService;
	@Autowired
	BphAlarmInfoService bphAlarmInfoService;
	@Autowired
	BphAlarmHandleLogService bphAlarmHandleLogService;
	@Autowired
	AlarmHandleFileService alarmHandleFileService;
	@Autowired
	DictService dictService;
	@Autowired
	SysConfigService sysConfigService;
	@Autowired
    OaNotifyService oaNotifyService;
    @Autowired
    AlarmNotifyService alarmNotifyService;
    @Autowired
    CcmWorkNoticeService ccmWorkNoticeService;

	/**
	 * 接处警（查询用户当天警情列表接口）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "1、接处警（查询用户当天警情列表接口）")
	@RequestMapping(value = "/queryDayAlarmInfoList", method = RequestMethod.GET)
	public CcmRestResult queryDayAlarmInfoList(@ModelAttribute @Valid CcmBphReceiveAlarmVo receiveAlarmVo,
                                               HttpServletRequest req, HttpServletResponse resp) {
		logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (receiveAlarmVo.getUserId()== null || "".equals(receiveAlarmVo.getUserId()) ||!receiveAlarmVo.getUserId().equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		List<AlarmHandleDayInfo> alarmInfoAndHandles = handleService.queryDayAlarmList(receiveAlarmVo);
		result.setCode(CcmRestType.OK);
		result.setResult(alarmInfoAndHandles);
		return result;
	}
	/**
	 * 接处警（查询处警详情接口）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "2、接处警（查询处警详情接口）")
	@RequestMapping(value = "/queryAlarmHandleInfo", method = RequestMethod.GET)
	public CcmRestResult queryAlarmHandleInfo(@ModelAttribute @Valid CcmBphDetailAlarmVo detailAlarmVo, HttpServletRequest req, HttpServletResponse resp) {
		logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (detailAlarmVo.getUserId()== null || "".equals(detailAlarmVo.getUserId()) ||!detailAlarmVo.getUserId().equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		AlarmHandleInfo alarmHandleInfo = handleService.queryAlarmHandleInfo(detailAlarmVo.getAlarmId(),detailAlarmVo.getHandleId(),detailAlarmVo.getHandlePoliceId());
		result.setCode(CcmRestType.OK);
		result.setResult(alarmHandleInfo);
		return result;
	}
	/**
	 * 签收-到达-反馈（更新处警信息）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "3、接处警 签收-到达-反馈（更新处警信息）")
	@RequestMapping(value = "/updateAlarmHandleById", method = RequestMethod.POST)
	public CcmRestResult updateAlarmHandleById(@ModelAttribute @Valid CcmBphUpdateAlarmVo updateAlarmVo, HttpServletRequest req, HttpServletResponse resp) {
		logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (updateAlarmVo.getUserId()== null || "".equals(updateAlarmVo.getUserId()) ||!updateAlarmVo.getUserId().equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		User userInfo = UserUtils.get(updateAlarmVo.getUserId());
		//
		//修改处理过程
		BphAlarmHandle bphAlarmHandle = new BphAlarmHandle();
		BeanUtils.copyProperties(updateAlarmVo,bphAlarmHandle);
        int dataStatus =  handleService.selectAlarmHandleByHandleIdAndPoiceId(updateAlarmVo);
        if (dataStatus > 0){
            result.setCode(CcmRestType.SUBMIT_REPEAT);
            result.setResult("重复提交");
            return result;
        }
		int updateNum = handleService.updateAlarmHandleById(bphAlarmHandle);
		if (updateNum > 0) {
			//修改警情
			//一条警情派发给多个人时，如果一个人先把警情反馈，则警情状态为反馈状态，其它人在后处理的过程中警情状态保持为反馈状态；
			BphAlarmInfo alarmInfo = bphAlarmInfoService.get(updateAlarmVo.getAlarmId());
			if (alarmInfo != null) {
                if (alarmInfo.getState() != "3") { //反馈状态
                    alarmInfo.setState(updateAlarmVo.getStatus());
                }
//				if (alarmInfo.getState() != "3") { //反馈状态
//					if (updateAlarmVo.getArriveX() != null && updateAlarmVo.getArriveY() != null) {
//						//log.debug("更新任务状态信息接口 反馈坐标状态x - y  : " + updateAlarmVo.getArriveX() + " - " + updateAlarmVo.getArriveY());
//						if (updateAlarmVo.getArriveX() != "0.0" && updateAlarmVo.getArriveY() != "0.0"
//							&& StringUtils.isNotEmpty(updateAlarmVo.getArriveX()) 
//							&& StringUtils.isNotEmpty(updateAlarmVo.getArriveY())) {
//							alarmInfo.setX(Double.parseDouble(updateAlarmVo.getArriveX()));
//							alarmInfo.setY(Double.parseDouble(updateAlarmVo.getArriveY()));
//						}
//					}
//				}
				alarmInfo.setGenreCode(updateAlarmVo.getAlarmGenerCode());//案件类别
				alarmInfo.setTypeCode(updateAlarmVo.getAlarmTypeCode());//案件类型
				alarmInfo.setClassCode(updateAlarmVo.getAlarmSmallTypeCode());//案件细类
				alarmInfo.setOfficeId(userInfo.getOffice().getId());  //更新案件处理部门为处警人部门
				Office office = userInfo.getOffice();
				if (office != null) {
					alarmInfo.setOfficeIds(office.getParentIds());  //更新案件处理部门为处警人部门
				}
				bphAlarmInfoService.updateBphAlarmInfo(alarmInfo);
			}
			// 添加处警过程记录
			BphAlarmHandleLog log = new BphAlarmHandleLog();
			log.setAlarmId(updateAlarmVo.getAlarmId());
			log.setHandleId(updateAlarmVo.getId());
			log.setUser(userInfo);
			if ("0".equals(updateAlarmVo.getStatus())) {
				log.setOperateDesc(userInfo.getName() + " : 任务获取");
			}
			if ("1".equals(updateAlarmVo.getStatus())) {
				log.setOperateDesc(userInfo.getName() + " : 任务签收");
			}
			if ("2".equals(updateAlarmVo.getStatus())) {
				log.setOperateDesc(userInfo.getName() + " : 到达现场");
			}
			if ("3".equals(updateAlarmVo.getStatus())) {
				log.setOperateDesc(userInfo.getName() + " : 任务反馈");
			}
			log.setOperateTime(new Date());
			log.setCreateBy(userInfo);
			log.setUpdateBy(userInfo);
			bphAlarmHandleLogService.save(log);
			//查询本部门非当前人的处警I记录，进行删除 （签收之后删除同部门人的处警记录）
			/**-- 1、发送给一个部门的多个人，一个人签收，其它人看不到；
			 *-- 2、指军调度 指派给一个部门的人 多个人，这些人都必须处理；
			 *  基于1，2点都得满足，所以暂时不进行以下删除操作
			 * * */
			/*if(StringUtils.isNotBlank(updateAlarmVo.getStatus()) && "1".equals(updateAlarmVo.getStatus())){//签收状态
				List<CurrentOffAlarmHandleInfo> currentOffAlarmHandles = handleService.queryCurrentOffHandleByAlarmIdAndOffId(updateAlarmVo.getAlarmId(),userInfo.getId(),userInfo.getOffice().getId());
				for (CurrentOffAlarmHandleInfo handleInfo:currentOffAlarmHandles) {
					BphAlarmHandle handle = new BphAlarmHandle();
					handle.setId(handleInfo.getHandleId());
					handle.setDelFlag("1");
					handleService.delete(handle);
				}
			}*/
			result.setCode(CcmRestType.OK);
			result.setResult("成功");
			return result;
		}else{
			result.setCode(CcmRestType.ERROR_DB_EXCEPTION);
			result.setResult("数据库异常");
			return result;
		}
	}

    /**
     * 接处警（警情反馈文件上传）
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
    @ApiOperation(value = "4、接处警（警情反馈文件上传）")
    @RequestMapping(value = "/fileupload", method = RequestMethod.POST)
/*    @ApiImplicitParams({@ApiImplicitParam(name = "alarmHandleId", value = "处警任务ID", paramType = "query", required = true),
			@ApiImplicitParam(name = "type", value = "文件类型：0图片；3音频；4视频", paramType = "query", required = true),
			@ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)})*/
    public CcmRestResult fileupload(MultipartFile file,@ModelAttribute CcmBphFileUploadVo fileUploadVo, HttpServletRequest req, HttpServletResponse resp) throws IOException {
		logger.info("当前正在执行的类名为》》》" + Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》" + Thread.currentThread().getStackTrace()[1].getMethodName());

        String  alarmHandleId = fileUploadVo.getAlarmHandleId();
        String  type = fileUploadVo.getType();
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (fileUploadVo.getUserId()== null || "".equals(fileUploadVo.getUserId()) ||!fileUploadVo.getUserId().equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		/*User userInfo = UserUtils.get(userId);*/

		//1、获取文件 存储路径
		//获取配置文件中的服务器域名
		//String httpPath = Global.getConfig("http_path") + PREFIX;
		String fileUrl = Global.getConfig("FILE_UPLOAD_URL");//文件上传URL地址
		String urlPath = Global.getConfig("url_file_path");//
		String path = Global.getConfig("FILE_UPLOAD_PATH");//文件上传存储路径
		String pathr = path.substring(path.indexOf(":")+2);
		pathr.replace("\\", "/");

		String[] temp = ShareUtil.getCurrentDate().split("-");

		// 获取文件新名字
		String attachmentId = ShareUtil.getUUID();
		// 获取文件的名字
		String attachmentName = file.getOriginalFilename();
		// 获取文件扩展名
		String suffix = attachmentName.substring(attachmentName.lastIndexOf(".") + 1);
		// 文件的大小
		//int fileSize = (int) file.getSize();
		// 创建附件实体
		AlarmHandleFile alarmHandleFile = new AlarmHandleFile();

		alarmHandleFile.setFileName(attachmentName);
		alarmHandleFile.setAlarmHandleId(alarmHandleId);
		alarmHandleFile.setPath(pathr.replace("\\", "/")+ attachmentName);
		alarmHandleFile.setType(type);
		alarmHandleFile.setUrlPath(fileUrl + pathr.replace("\\", "/")+ attachmentName);
		alarmHandleFile.setContentType(file.getContentType());
		alarmHandleFile.setExtension(suffix.toUpperCase());
		// 保存文件
		FileUtils.copyInputStreamToFile(file.getInputStream(), new File(path + attachmentName));
		if ("3".equals(type) || "4".equals(type)) {//3 音频，4 视频
			File newFile = new File(path + attachmentName);
			//获取视频文件时长
			Encoder encoder = new Encoder();
			try {
				MultimediaInfo m = encoder.getInfo(newFile);
				long ls = m.getDuration(); //获取视频时长
				alarmHandleFile.setDuration(String.valueOf(ls));
			} catch (Exception e) {
				System.out.println("获取视频时长--出现错误");
			}
			if("amr".equals(suffix)){
				long amrDuration = AmrFileTimeLengthSample.getAmrDuration(newFile);
				alarmHandleFile.setDuration(String.valueOf(amrDuration));
			}
		}
		// 保存实例
		alarmHandleFile.setId(attachmentId);
		alarmHandleFile.setCreateBy(fileUploadVo.getUserId());
		alarmHandleFile.setDelFlag("0");
		int i = alarmHandleFileService.insertAlarmHandleFile(alarmHandleFile);
		if (i>0){
			result.setCode(CcmRestType.OK);
			result.setResult(alarmHandleFile);
		}else{
			result.setCode(CcmRestType.ERROR_DB_EXCEPTION);
			result.setResult("添加数据库异常");
		}
		return result;
  	  }

	/**
	 * 接处警（反馈：案件三级联动）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "5、接处警（反馈：案件三级联动）")
	@RequestMapping(value = "/querySysDictAlarmType", method = RequestMethod.GET)
	@ApiImplicitParams({@ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)	})
	public CcmRestResult querySysDictAlarmType(String userId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》" + Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》" + Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser == null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId == null || "".equals(userId) || !userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        List<SysDictLbVo> sysDictLbVos = dictService.selectAlarmTypeInfo();
        result.setCode(CcmRestType.OK);
        result.setResult(sysDictLbVos);
        return result;
    }
	/**
	 * 接处警（明细：警情反馈信息）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "6、接处警（明细：警情反馈信息）")
	@RequestMapping(value = "/alarmHandleFeedback", method = RequestMethod.GET)
	public CcmRestResult alarmHandleFeedback(@ModelAttribute @Valid CcmBphDetailAlarmVo detailAlarmVo,HttpServletRequest req, HttpServletResponse resp) {
		logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (detailAlarmVo.getUserId()== null || "".equals(detailAlarmVo.getUserId()) ||!detailAlarmVo.getUserId().equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		//List<AlarmHandle> alarmHandleList = handleService.selectAlarmHandleByAlarmIdAndhandlePoliceId(detailAlarmVo.getAlarmId(),detailAlarmVo.getHandlePoliceId());
		//List<AlarmHandleFeedBack> feedBacks = new ArrayList<>();
		//alarmHandleList.forEach(alarmHandle -> {
			AlarmHandleFeedBack alarmHandleFeedBack = handleService.alarmHandleFeedback(detailAlarmVo.getHandleId()	);
			//feedBacks.add(alarmHandleFeedBack);
		//});
        result.setCode(CcmRestType.OK);
		result.setResult(alarmHandleFeedBack);
		return result;
	}
	/**
	 * 警情列表/我的警情（查询警情列表 (近一周，一个月，三个月 ，某个时间段，)）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "7、警情列表/我的警情（查询警情列表 (近一周，一个月，三个月 ，某个时间段，)")
	@RequestMapping(value = "/queryAlarmInfoList", method = RequestMethod.GET)
	public CcmRestResult queryAlarmInfoList(@ModelAttribute @Valid CcmBphQueryAlarmVo queryAlarmVo, HttpServletRequest req, HttpServletResponse resp) {
		logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (queryAlarmVo.getUserId()== null || "".equals(queryAlarmVo.getUserId()) ||!queryAlarmVo.getUserId().equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		User userInfo = UserUtils.get(queryAlarmVo.getUserId());
		queryAlarmVo.setOfficeId(userInfo.getOffice().getId());
		List<AlarmHandlEntity> alarmHandlEntities = handleService.queryAlarmList(queryAlarmVo);
		result.setCode(CcmRestType.OK);
		result.setResult(alarmHandlEntities);
		return result;
	}
    /**
     * 接处警（查询警情数量 根据handlePoliceId 查询当日未签收警情总数)）
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
    @ApiOperation(value = "8、接处警（查询警情数量 根据handlePoliceId 查询当日未签收警情总数)")
    @RequestMapping(value = "/queryAlarmInfoAndHandleCount", method = RequestMethod.GET)
    @ApiImplicitParams({@ApiImplicitParam(name = "handlePoliceId", value = "处警人ID", paramType = "query", required = true),
            @ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)})
    public CcmRestResult queryAlarmInfoAndHandleCount(String handlePoliceId,String userId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser== null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String status[]={"0","1","2","3"};
        List allStatusList = new ArrayList(Arrays.asList(status));
        int totalSize = handleService.queryAlarmCount(handlePoliceId,allStatusList);
        String noSigned[]={"0"};
        List noSignedStatusList = new ArrayList(Arrays.asList(noSigned));
        int num = handleService.queryAlarmCount(handlePoliceId,noSignedStatusList);
        Map<String,Object> resultInfo =  new HashMap<>();
        resultInfo.put("totalSize" ,totalSize);
        resultInfo.put("noSignedNum",num);

        result.setCode(CcmRestType.OK);
        result.setResult(resultInfo);
        return result;
    }
	/**
	 * 地图（获取地图配置项数据）
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException
	 * @author maoxb
	 * @version 2019-10-10
	 */
	@ApiOperation(value = "9、地图（获取地图配置项数据）" ,notes = " 地图配置ID : map_info_config ")
	@RequestMapping(value = "/getMapConfig", method = RequestMethod.GET)
	@ApiImplicitParams({@ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)	})
	public CcmRestResult getMapConfig(String userId, HttpServletRequest req, HttpServletResponse resp) {
		logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
		logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
		CcmRestResult result = new CcmRestResult();
		User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser== null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();
		if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}

		String imageMapUrl = sysConfigService.getImageMapConfig();
		Map<String,Object>  resultInfo = new HashMap<String,Object>();
		resultInfo.put("imageMapUrl",imageMapUrl);
		result.setCode(CcmRestType.OK);
		result.setResult(resultInfo);
		return result;
	}
    /**
     * 通知公告（警情通告列表)
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
    @ApiOperation(value = "10、通知公告（警情通告列表)")
    @RequestMapping(value = "/queryAlarmNotifyList", method = RequestMethod.GET)
    @ApiImplicitParams({@ApiImplicitParam(name = "handlePoliceId", value = "处警人ID", paramType = "query", required = true),
            @ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)})
    public CcmRestResult queryAlarmNotifyList(String handlePoliceId,String userId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser== null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        List<AlarmNotify> alarmNotifies = alarmNotifyService.queryAlarmNotifyList(handlePoliceId);
        result.setCode(CcmRestType.OK);
        result.setResult(alarmNotifies);
        return result;
    }  /**
     * 通知公告（警情通知详情： 根据alarmId查询警情详情)
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
    @ApiOperation(value = "11、通知公告（警情通知详情： 根据alarmId查询警情详情)")
    @RequestMapping(value = "/queryAlarmNotifyInfo", method = RequestMethod.GET)
    @ApiImplicitParams({@ApiImplicitParam(name = "alarmId", value = "案件ID", paramType = "query", required = true),
            @ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)})
    public CcmRestResult queryAlarmNotifyInfo(String alarmId,String userId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser== null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        AlarmNotifyInfo alarmNotifyInfo = bphAlarmInfoService.selectAlarmNotifyInfoById(alarmId);
        result.setCode(CcmRestType.OK);
        result.setResult(alarmNotifyInfo);
        return result;
    }

    /**
     * 通知公告：统计公告总数/未读数量
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
    @ApiOperation(value = "12、通知公告：统计公告总数/未读数量", notes = "通知通告/警情通告/求助")
    @RequestMapping(value = "/queryNoticeCount", method = RequestMethod.GET)
    @ApiImplicitParams({@ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)})
    public CcmRestResult queryNoticeCount(String userId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser== null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        int workNoticeTotal = ccmWorkNoticeService.selectWorkNoticeTotal();
        int workNoticeTodoCount = ccmWorkNoticeService.selectWorkNoticeTodoCount();
        int alarmNotifyTotal = alarmNotifyService.selectAlarmNotifyTotal(userId);
        int alarmNotifyTodoCount  = alarmNotifyService.selectAlarmNotifyTodoCount(userId);
        int notifyTotal = oaNotifyService.selectNotifyTotal(userId);
        int notifyTodoCount = oaNotifyService.selectNotifyTodoCount(userId);

        Map<String,Object>  resultInfo = new HashMap<String,Object>();
        resultInfo.put("workNoticeTotal",workNoticeTotal);
        resultInfo.put("workNoticeTodoCount",workNoticeTodoCount);
        resultInfo.put("alarmNotifyTotal",alarmNotifyTotal);
        resultInfo.put("alarmNotifyTodoCount",alarmNotifyTodoCount);
        resultInfo.put("notifyTotal",notifyTotal);
        resultInfo.put("notifyTodoCount",notifyTodoCount);
        result.setCode(CcmRestType.OK);
        result.setResult(resultInfo);
        return result;
    }
    /**
     * 通知公告：统计公告总数/未读数量
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
    @ApiOperation(value = "13、通知公告：更新公告阅读状态", notes = "通知通告(type:0)/警情通告(type:1)/求助(type:2)")
    @RequestMapping(value = "/updateReadStatus", method = RequestMethod.GET)
    @ApiImplicitParams({@ApiImplicitParam(name = "id", value = "公告ID", paramType = "query", required = true),
            @ApiImplicitParam(name = "type", value = "业务类型", paramType = "query", required = true),
            @ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true),
			@ApiImplicitParam(name = "alarmId", value = "警情ID", paramType = "query", required = true)})
    public CcmRestResult updateReadStatus(String id,String type,String userId,String alarmId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser== null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        int res = -1;
        int retCode = 0;
        if("0".equals(type)){
            res = oaNotifyService.updateSatausByIdAndUserId(id,userId);
        }else if("1".equals(type)){
            res = alarmNotifyService.updateSatausByIdAndUserId(id,userId);

			User userInfo = UserUtils.get(userId);
			// 添加处警过程记录
			BphAlarmHandleLog log = new BphAlarmHandleLog();
			log.setAlarmId(alarmId);
			log.setUser(userInfo);
			log.setOperateDesc(userInfo.getName() + " : 通知已阅");


			log.setOperateTime(new Date());
			log.setCreateBy(userInfo);
			log.setUpdateBy(userInfo);
			bphAlarmHandleLogService.save(log);
        }else if("2".equals(type)){
            res = ccmWorkNoticeService.updateSatausById(id);
        }


        if (res < 0){
            result.setCode(CcmRestType.ERROR_DB_EXCEPTION);
            result.setResult("数据库异常");
        }else{
            result.setCode(CcmRestType.OK);
            result.setResult("成功");
        }
        return result;
    } /**
     * 通知公告：统计公告总数/未读数量
     * @param req
     * @param resp
     * @return
     * @throws IOException
     * @author maoxb
     * @version 2019-10-10
     */
	@ApiOperation(value = "14 接处警 根据类别获取字典项", notes = " 警情状态 type : bph_alarm_info_state ")
    @RequestMapping(value = "/selectDictByType", method = RequestMethod.GET)
    @ApiImplicitParams({@ApiImplicitParam(name = "type", value = "字典类型", paramType = "query", required = true),
            @ApiImplicitParam(name = "userId", value = "登陆人ID", paramType = "query", required = true)})
    public CcmRestResult selectDictByType(String type,String userId, HttpServletRequest req, HttpServletResponse resp) {
        logger.info("当前正在执行的类名为》》》"+Thread.currentThread().getStackTrace()[1].getClassName());
        logger.info("当前正在执行的方法名为》》》"+Thread.currentThread().getStackTrace()[1].getMethodName());
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser== null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId== null || "".equals(userId) ||!userId.equals(sessionUserId)) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
		List<SysDict> sysDicts = dictService.selectDictByType(type);
		result.setCode(CcmRestType.OK);
		result.setResult(sysDicts);
        return result;
    }
}
