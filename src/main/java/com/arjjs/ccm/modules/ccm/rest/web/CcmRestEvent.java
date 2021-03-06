package com.arjjs.ccm.modules.ccm.rest.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.ccmsys.entity.CcmDevice;
import com.arjjs.ccm.modules.ccm.ccmsys.service.CcmDeviceService;
import com.arjjs.ccm.modules.ccm.event.entity.*;
import com.arjjs.ccm.modules.ccm.event.service.*;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.house.service.CcmHouseBuildmanageService;
import com.arjjs.ccm.modules.ccm.line.entity.CcmLineProtect;
import com.arjjs.ccm.modules.ccm.line.service.CcmLineProtectService;
import com.arjjs.ccm.modules.ccm.log.entity.CcmLogTail;
import com.arjjs.ccm.modules.ccm.log.service.CcmLogTailService;
import com.arjjs.ccm.modules.ccm.message.entity.CcmMessage;
import com.arjjs.ccm.modules.ccm.message.service.CcmMessageService;
import com.arjjs.ccm.modules.ccm.org.entity.SysArea;
import com.arjjs.ccm.modules.ccm.org.service.SysAreaService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.rest.service.CcmRestEventService;
import com.arjjs.ccm.modules.ccm.sys.entity.SysConfig;
import com.arjjs.ccm.modules.ccm.sys.service.SysConfigService;
import com.arjjs.ccm.modules.iot.warning.entity.CcmEarlyWarning;
import com.arjjs.ccm.modules.iot.warning.service.CcmEarlyWarningService;
import com.arjjs.ccm.modules.sys.entity.Area;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import com.arjjs.ccm.tool.*;
import com.arjjs.ccm.tool.gcj02_wgs84.Gps;
import com.arjjs.ccm.tool.gcj02_wgs84.PositionUtil;
import com.google.common.collect.Lists;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.PropertyFilter;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.jms.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;


/**
 * 事件接口类
 *
 * @author pengjianqiang
 * @version 2018-02-23
 */
@Controller
@RequestMapping(value = "${appPath}/rest/event")
public class CcmRestEvent extends BaseController {

    @Autowired
    private CcmEventIncidentService ccmEventIncidentService;
    @Autowired
    private CcmEventCasedealService ccmEventCasedealService;
    @Autowired
    private CcmEventKaccService ccmEventKaccService;
    @Autowired
    private CcmEventAmbiService ccmEventAmbiService;
    @Autowired
    private CcmEventRequestService ccmEventRequestService;
    @Autowired
    private CcmDeviceService ccmDeviceService;
    @Autowired
    private CcmRestEventService ccmRestEvent;
    @Autowired
    private CcmEarlyWarningService ccmEarlyWarningService;
    @Autowired
    private CcmPeopleService ccmPeopleService;
    @Autowired
    private CcmHouseBuildmanageService ccmHouseBuildmanageService;
    @Autowired
    private CcmLogTailService ccmLogTailService;
    @Autowired
    private CcmMessageService ccmMessageService;
    @Autowired
    private SysAreaService sysAreaService;
    @Autowired
    private CcmLineProtectService ccmLineProtectService;
	@Autowired
	private SysConfigService sysConfigService;

    /**
     * @param id ID
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 获取单个事件信息
     */
    @ResponseBody
    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public CcmRestResult get(String userId, HttpServletRequest req, HttpServletResponse resp, String id)
            throws IOException {
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
        if (id == null || "".equals(id)) {// 参数id不对
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }

        CcmEventIncident ccmEventIncident = ccmEventIncidentService.get(id);

        if (StringUtils.isNotEmpty(ccmEventIncident.getOtherId())) {
            CcmLineProtect ccmLineProtect = ccmLineProtectService.get(ccmEventIncident.getOtherId());
            ccmEventIncident.setLine(ccmLineProtect);
        }


        String file1 = ccmEventIncident.getFile1();
        if (StringUtils.isNotEmpty(file1)) {
            String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
            ccmEventIncident.setFile1(fileUrl + file1);
        }

        String file2 = ccmEventIncident.getFile2();
        if (StringUtils.isNotEmpty(file2)) {
            String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
            ccmEventIncident.setFile2(fileUrl + file2);
        }

        String file3 = ccmEventIncident.getFile3();
        if (StringUtils.isNotEmpty(file3)) {
            String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
            ccmEventIncident.setFile3(fileUrl + file3);
        }

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventIncident);

        return result;
    }

    /**
     * @param CcmEventIncident
     * @param pageNo           页码
     * @param pageSize         分页大小
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 查询事件信息
     */
    @ResponseBody
    @RequestMapping(value = "/query", method = RequestMethod.GET)
    public CcmRestResult query(String userId, CcmEventIncident ccmEventIncident, HttpServletRequest req,
                               HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        User sessionUser = (User) req.getSession().getAttribute("user");
        if (sessionUser == null) {
            result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
            return result;
        }
        String sessionUserId = sessionUser.getId();
        if (userId == null || "".equals(userId) || !userId.equals(sessionUserId)) {
            result.setCode(-10);
            return result;
        }

        ccmEventIncident.setCheckUser(sessionUser);
        ccmEventIncident.setCreateBy(sessionUser);
        Page<CcmEventIncident> page = null;
        if(StringUtils.isNotEmpty(ccmEventIncident.getEventKind()) && ccmEventIncident.getEventKind().equals("02")){  //涉及师生
            page = ccmEventIncidentService.findPageStudent(new Page<CcmEventIncident>(req, resp),
                    ccmEventIncident);
        } else if(StringUtils.isNotEmpty(ccmEventIncident.getEventKind()) && ccmEventIncident.getEventKind().equals("03")){ //涉及线路
            page = ccmEventIncidentService.findPageLine(new Page<CcmEventIncident>(req, resp),
                    ccmEventIncident);
        } else if(StringUtils.isNotEmpty(ccmEventIncident.getEventKind()) && ccmEventIncident.getEventKind().equals("04")){  //涉及命案
            page = ccmEventIncidentService.findPageMurder(new Page<CcmEventIncident>(req, resp),
                    ccmEventIncident);
        } else {
            page = ccmEventIncidentService.findPage(new Page<CcmEventIncident>(req, resp),
                    ccmEventIncident);
        }

        List<CcmEventIncident> list = page.getList();
        List<CcmEventIncident> resultList = Lists.newArrayList();
        list.forEach(eventIncident -> {
            String file1 = eventIncident.getFile1();
            if (StringUtils.isNotEmpty(file1)) {
                String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
                eventIncident.setFile1(fileUrl + file1);
            }
            resultList.add(eventIncident);
        });

        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * 保存对接的预警信息
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/saveWarning", method = RequestMethod.POST)
    public CcmRestResult saveWarning(String userId, HttpServletRequest req, CcmEarlyWarning ccmEarlyWarning,
                                     Model model, RedirectAttributes redirectAttributes) {

        CcmRestResult result = new CcmRestResult();
        // 数据校验
        if (!beanValidator(model, ccmEarlyWarning)) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }

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

        if (ccmEarlyWarning.getId() != null && !"".equals(ccmEarlyWarning.getId())) {
            CcmEarlyWarning earlyWarningDB = ccmEarlyWarningService.get(ccmEarlyWarning.getId());
            if (earlyWarningDB == null) {// 从数据库中没有取到对应数据
                result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            }
        }
        if (ccmEarlyWarning.getCreateBy() == null) {
            ccmEarlyWarning.setCreateBy(new User(userId));
        }

        ccmEarlyWarning.setUpdateBy(new User(userId));
        ccmEarlyWarningService.save(ccmEarlyWarning);

        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.setJsonPropertyFilter(new PropertyFilter() {
            @Override
            public boolean apply(Object source, String name, Object value) {
                if (name.equals("createBy") || name.equals("updateBy") || name.equals("currentUser")
                        || name.equals("page") || name.equals("sqlMap")) {
                    return true;
                } else {
                    return false;
                }
            }
        });

        jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("yyyy-MM-dd HH:mm:ss"));
        System.out.println(RabbitMQTools.orderRabbitMQInfoMap.entrySet());
        System.out.println(uuidList1.entrySet());
        for (Map.Entry<String, OrderRabbitMQInfo> entry : RabbitMQTools.orderRabbitMQInfoMap.entrySet()) {
            for (Entry<String, String> key : uuidList1.entrySet()) {
                if (key.getKey().equals(entry.getKey())) {
                    RabbitMQTools.sendMessage(entry.getKey(),
                            JSONObject.fromObject(ccmEarlyWarning, jsonConfig).toString());
                }
            }
        }

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEarlyWarning);
        return result;

    }

    //签收
    @ResponseBody
    @RequestMapping(value = "/signing", method = RequestMethod.POST)
    public CcmRestResult signing(String userId, CcmEventCasedeal ccmEventCasedeal, RedirectAttributes redirectAttributes) {
        CcmRestResult result = new CcmRestResult();
        if (ccmEventCasedeal.getId() == null || ccmEventCasedeal.getId().equals("")) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }

        CcmEventCasedeal ccmEventCasedeal1 = ccmEventCasedealService.get(ccmEventCasedeal.getId());
        if (ccmEventCasedeal1 == null) {
            result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            return result;
        }
        User user = new User(userId);
        ccmEventCasedeal1.setUpdateBy(user);
        ccmEventCasedeal1.setHandleStatus("02");//任务处理状态:处理中
        ccmEventCasedealService.save(ccmEventCasedeal1);
        User resuser = UserUtils.get(userId);
        //插入日志
        ccmLogTailService.signingLogTail(ccmEventCasedeal1,resuser);
        //消息和MQ
//        ccmMessageService.signingMessage(ccmEventCasedeal1,resuser);
        CcmMessage ccmMessage = new CcmMessage();
        ccmMessage.setCreateBy(user);
        ccmMessage.setUpdateBy(user);
        ccmMessage.setType("02");//事件上报消息
        Date createDate = ccmEventCasedeal1.getUpdateDate();
        String str = "MM-dd HH:mm:ss";
        SimpleDateFormat sdf = new SimpleDateFormat(str);
        ccmMessage.setContent(sdf.format(createDate) + "：" + ccmEventCasedeal1.getCaseName() + "事件已被" + resuser.getName() + "签收");
        ccmMessage.setReadFlag("0");//未读
        ccmMessage.setObjId(ccmEventCasedeal1.getId());
        ccmMessage.setUserId(ccmEventCasedeal1.getCreateBy().getId());

        //批量添加
        ccmMessageService.save(ccmMessage);
//        sendOneMessageToMq(ccmMessage);
        result.setResult("");
        result.setCode(CcmRestType.OK);
        return result;
//		return "ccm/event/eventCasedeal/ccmEventCasedealList";
    }

    @ResponseBody
    @RequestMapping(value = "/reject", method = RequestMethod.POST)
    public CcmRestResult reject(String userId, CcmEventCasedeal ccmEventCasedeal, RedirectAttributes redirectAttributes) {
        CcmRestResult result = new CcmRestResult();
        if (ccmEventCasedeal.getId() == null || ccmEventCasedeal.getId().equals("")) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }
        CcmEventCasedeal ccmEventCasedeal1 = ccmEventCasedealService.get(ccmEventCasedeal.getId());
        if (ccmEventCasedeal1 == null) {
            result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            return result;
        }
        User user = new User(userId);
        ccmEventCasedeal1.setUpdateBy(user);
        ccmEventCasedeal1.setHandleStatus("04");//任务处理状态:已拒绝
        ccmEventCasedealService.save(ccmEventCasedeal1);
        User resuser = UserUtils.get(userId);

        //插入日志
        ccmLogTailService.rejectLogTail(ccmEventCasedeal1,resuser);
        //消息和MQ
        ccmMessageService.rejectMessage(ccmEventCasedeal1,resuser);
        result.setResult("");
        result.setCode(CcmRestType.OK);
        return result;
    }

    /**
     * @param CcmEventIncident
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 保存事件信息
     */
    @ResponseBody
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public CcmRestResult save(String userId, HttpServletRequest req, CcmEventIncident ccmEventIncident, Model model,
                              RedirectAttributes redirectAttributes) {
        CcmRestResult result = new CcmRestResult();
        if(StringUtils.isEmpty(ccmEventIncident.getAreaMap())) {
        	if(StringUtils.isNotEmpty(ccmEventIncident.getAreaPoint())) {
        		ccmEventIncident.setAreaMap(ccmEventIncident.getAreaPoint());
        	}
        }
/*        if (!beanValidator(model, ccmEventIncident)) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }*/
        //
		/*User sessionUser = (User) req.getSession().getAttribute("user");
		if (sessionUser == null) {
			result.setCode(CcmRestType.ERROR_USER_NOT_EXIST);
			return result;
		}
		String sessionUserId = sessionUser.getId();*/

        if (ccmEventIncident.getId() != null && !"".equals(ccmEventIncident.getId())) {
            CcmEventIncident ccmEventIncidentDB = ccmEventIncidentService.get(ccmEventIncident.getId());
            if (ccmEventIncidentDB == null) {// 从数据库中没有取到对应数据
                result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            } else {
                if (!ccmEventIncidentDB.getAreaPoint().equals(ccmEventIncident.getAreaPoint())) {
                    // 坐标经纬度的转换（GCJ坐标 -> WGS-84坐标）
                    String piont = ccmEventIncident.getAreaPoint();
                    String areaPiont = "";
                    String[] pionts = piont.split(",");

                    Gps gps = PositionUtil.gcj_To_Gps84(Double.parseDouble(pionts[1]), Double.parseDouble(pionts[0]));
                   /* TransGPS ins = new TransGPS();
                    TransGPS.Location wcj = ins.new Location();
                    wcj.setLat(Double.parseDouble(pionts[1]));
                    wcj.setLng(Double.parseDouble(pionts[0]));

                    TransGPS.Location wgs = ins.transformFromGCJToWGS(wcj);
                    areaPiont = wgs.getLng() + ","  + wgs.getLat();*/
                    areaPiont = gps.getWgLon() + ","  + gps.getWgLat();
                    ccmEventIncident.setAreaPoint(areaPiont);
                }
            }


        } else {
            // 赋值事件初始处理状态-->未完结
            ccmEventIncident.setStatus("01");
            if (StringUtils.isNotEmpty(ccmEventIncident.getAreaPoint())) {
                // 坐标经纬度的转换（GCJ坐标 -> WGS-84坐标）
                String piont = ccmEventIncident.getAreaPoint();
                String areaPiont = "";
                String[] pionts = piont.split(",");
                Gps gps = PositionUtil.gcj_To_Gps84(Double.parseDouble(pionts[1]), Double.parseDouble(pionts[0]));
               /* TransGPS ins = new TransGPS();
                TransGPS.Location wcj = ins.new Location();
                wcj.setLat(Double.parseDouble(pionts[1]));
                wcj.setLng(Double.parseDouble(pionts[0]));

                TransGPS.Location wgs = ins.transformFromGCJToWGS(wcj);
                areaPiont = wgs.getLng() + ","  + wgs.getLat();*/
                areaPiont = gps.getWgLon() + ","  + gps.getWgLat();
                ccmEventIncident.setAreaPoint(areaPiont);
            }
        }
        if (ccmEventIncident.getCreateBy() == null) {
            ccmEventIncident.setCreateBy(new User(userId));
        }


        if ("".equals(ccmEventIncident.getAreaPoint()) || ccmEventIncident.getAreaPoint() == null) {// 没有传坐标点位时
            if (!"".equals(ccmEventIncident.getCameraCode()) && ccmEventIncident.getCameraCode() != null) {// 存在摄像机信息时，取摄像机的坐标作为事件的坐标，取摄像机的区域作为事件的区域
                CcmDevice camera = ccmDeviceService.getByCode(ccmEventIncident.getCameraCode());
                if (camera != null) {
                    ccmEventIncident.setAreaPoint(camera.getCoordinate());
                    Area area = new Area();
                    area.setId(camera.getArea().getId());
                    ccmEventIncident.setArea(area);
                    if (ccmEventIncident.getHappenPlace() == null) {
                        ccmEventIncident.setHappenPlace(camera.getArea().getName());
                    }

                }
            } else if (!"".equals(ccmEventIncident.getAlarmTvSn()) && ccmEventIncident.getAlarmTvSn() != null) {// 存在机顶盒信息时，取机顶盒楼栋的坐标作为事件的坐标，取机顶盒人员的区域作为事件的区域
                CcmPeople ccmPeople = ccmPeopleService.getInfoBySnNum(ccmEventIncident.getAlarmTvSn());
                CcmHouseBuildmanage ccmHouseBuildmanage = new CcmHouseBuildmanage();
                if (ccmPeople != null) {
                    ccmHouseBuildmanage = ccmHouseBuildmanageService.get(ccmPeople.getBuildId().getId());
                    ccmEventIncident.setAreaPoint(ccmHouseBuildmanage.getAreaPoint());
                    Area area = new Area();
                    area.setId(ccmPeople.getAreaGridId().getId());
                    ccmEventIncident.setArea(area);
                    if (ccmEventIncident.getHappenPlace() == null) {
                        ccmEventIncident.setHappenPlace(ccmPeople.getAreaGridId().getName());
                    }
                }
            }
        }

        // 返回报警人员信息
        if (ccmEventIncident.getAlarmTvSn() != null && !ccmEventIncident.getAlarmTvSn().equals("")) {
            CcmPeople ccmPeople = ccmPeopleService.getInfoBySnNum(ccmEventIncident.getAlarmTvSn());
            if (ccmPeople != null) {
                ccmEventIncident.setWhatType("1");
                ccmEventIncident.setAlarmPeopleId(ccmPeople.getId());
                ccmEventIncident.setAlarmPeopleName(ccmPeople.getName());
                ccmEventIncident.setAlarmPeopleTel(ccmPeople.getTelephone());
            }
        } else {
            User u = UserUtils.get(userId);
            ccmEventIncident.setCreateBy(new User(userId));
            ccmEventIncident.setReportPerson(u.getName());
            ccmEventIncident.setReportPersonPhone(u.getPhone());
        }
        if (StringUtils.isEmpty(ccmEventIncident.getStick()) || !ccmEventIncident.getStick().equals("1")) {
            ccmEventIncident.setStick("0");
        }
        if (StringUtils.isEmpty(ccmEventIncident.getUrgent()) || !ccmEventIncident.getUrgent().equals("1")) {
            ccmEventIncident.setUrgent("0");
        }
        if (StringUtils.isEmpty(ccmEventIncident.getHistoryLegacy()) || !ccmEventIncident.getHistoryLegacy().equals("1")) {
            ccmEventIncident.setHistoryLegacy("0");
        }
        ccmEventIncident.setUpdateDate(new Date());
        ccmEventIncident.setUpdateBy(new User(userId));

        if (ccmEventIncident.getHappenDate() == null || "".equals(ccmEventIncident.getHappenDate())) {// 无事件时间时，默认赋值当前时间
            ccmEventIncident.setHappenDate(new Date());
        }
        boolean flag = false;
        if (ccmEventIncident.getId() == null) {
            flag = true;
        }

        // 添加图片处理代码
        String file1 = ccmEventIncident.getFile1();
        if (StringUtils.isNotEmpty(file1)) {
            if(file1.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
                ccmEventIncident.setFile1(file1.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
            }else {
                ccmEventIncident.setFile1(file1);
            }
        }
        String file2 = ccmEventIncident.getFile2();
        if (StringUtils.isNotEmpty(file2)) {
            if(file2.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
                ccmEventIncident.setFile2(file2.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
            }else {
                ccmEventIncident.setFile2(file2);
            }
        }
        String file3 = ccmEventIncident.getFile3();
        if (StringUtils.isNotEmpty(file3)) {
            if(file3.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
                ccmEventIncident.setFile3(file3.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
            }else {
                ccmEventIncident.setFile3(file3);
            }
        }
        String image = ccmEventIncident.getImage();
        if(StringUtils.isNotEmpty(image)) {
            if(image.contains(Global.getConfig("FILE_UPLOAD_URL"))) {
                ccmEventIncident.setImage(image.split(Global.getConfig("FILE_UPLOAD_URL"))[1]);
            }else {
                ccmEventIncident.setImage(image);
            }
        }
        ccmEventIncidentService.save(ccmEventIncident,new User(userId));

		// 判断预处理系统是否开启
		SysConfig sysConfig = sysConfigService.get("preview_system_config");
		if (sysConfig.getParamInt() == 1) { // 开启的话，判断是否是纠纷，是纠纷的话则插入到矛盾纠纷调解中去

			// 判断事件类型是否是矛盾纠纷
			if (!ccmEventIncident.getEventKind().equals("99")) { // 是
				CcmEventAmbi ccmEventAmbi = new CcmEventAmbi();
				if (StringUtils.isNotEmpty(ccmEventIncident.getCaseName())) {
					ccmEventAmbi.setName(ccmEventIncident.getCaseName());
				}
				if (null != ccmEventIncident.getHappenDate()) {
					ccmEventAmbi.setSendDate(ccmEventIncident.getHappenDate());
				}
				if (StringUtils.isNoneEmpty(ccmEventIncident.getCaseCondition())) {
					ccmEventAmbi.setEventSket(ccmEventIncident.getCaseCondition());
				}
				if (null != ccmEventIncident.getArea()) {
					ccmEventAmbi.setArea(ccmEventIncident.getArea());
				}
				if (StringUtils.isNotEmpty(ccmEventIncident.getHappenPlace())) {
					ccmEventAmbi.setSendAdd(ccmEventIncident.getHappenPlace());
				}
				if (StringUtils.isNotEmpty(ccmEventIncident.getEventScale())) {
					ccmEventAmbi.setEventScale(ccmEventIncident.getEventScale());
				}
				if (StringUtils.isNotEmpty(ccmEventIncident.getEventSort())) {
					ccmEventAmbi.setEventType(ccmEventIncident.getEventSort());
				}
				if (StringUtils.isNotEmpty(ccmEventIncident.getFile1())) {
					ccmEventAmbi.setIcon(ccmEventIncident.getFile1());
				}
				ccmEventAmbi.setStatus("01");
				ccmEventAmbi.setId(UUID.randomUUID().toString());
				ccmEventAmbi.setIsNewRecord(true);
				ccmEventAmbi.setCreateBy(new User(userId));
				ccmEventAmbi.setUpdateBy(new User(userId));
				ccmEventAmbiService.save(ccmEventAmbi);
			}

		}
        
        
        // addMessage(redirectAttributes, "保存案事件登记成功");

        if (flag) {
            User user1 = UserUtils.get(userId);
            ccmLogTailService.addEventLogTail(ccmEventIncident,user1);
            SysArea entity = sysAreaService.get(ccmEventIncident.getArea().getId());
            List<String> parentIds = Arrays.asList(entity.getParentIds().split(","));
            // 查询需要发送的用户
            List<User> assignUser = ccmEventCasedealService.findAssignUser(ccmEventIncident.getArea().getId(), parentIds);
            //拼接数据
            if (assignUser.size() > 0) {
                List<CcmMessage> list = new ArrayList<CcmMessage>();
                for (User user : assignUser) {
                    CcmMessage ccmMessage = new CcmMessage();
                    ccmMessage.preInsert();
                    ccmMessage.setType("01");//事件上报消息

                    Date createDate = ccmEventIncident.getCreateDate();
                    String str = "MM-dd HH:mm:ss";
                    SimpleDateFormat sdf = new SimpleDateFormat(str);
                    ccmMessage.setContent("事件上报：" + sdf.format(createDate) + "：" + ccmEventIncident.getCaseName());
                    ccmMessage.setReadFlag("0");//未读
                    ccmMessage.setObjId(ccmEventIncident.getId());
                    ccmMessage.setCreateBy(ccmEventIncident.getCreateBy());
                    ccmMessage.setUpdateBy(ccmEventIncident.getCreateBy());
                    ccmMessage.setUserId(user.getId());
                    list.add(ccmMessage);
                }
                //批量添加
                ccmMessageService.insertEventAll(list);

                CcmRestEvent.sendMessageToMq(list);
            }
        }

//		if(uuidList.size() > 0){
	/*	JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new PropertyFilter() {
			@Override
			public boolean apply(Object source, String name, Object value) {
				if (name.equals("area") || name.equals("createBy") || name.equals("updateBy")
						|| name.equals("currentUser") || name.equals("page") || name.equals("sqlMap")) {
					return true;
				} else {
					return false;
				}
			}
		});
		jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("yyyy-MM-dd HH:mm:ss"));
		for (Map.Entry<String, OrderRabbitMQInfo> entry : RabbitMQTools.orderRabbitMQInfoMap.entrySet()) {
			for (Entry<String, String> key : uuidList.entrySet()) {
				if (key.getKey().equals(entry.getKey())) {
					RabbitMQTools.sendMessage(entry.getKey(),
							JSONObject.fromObject(ccmEventIncident, jsonConfig).toString());
				}
			}
		}*/
//			sendMessage(JSONObject.fromObject(ccmEventIncident, jsonConfig).toString());	
        // }

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventIncident);
        return result;
    }

    public static void sendMessageToMq(List<CcmMessage> list) {
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.setJsonPropertyFilter(new PropertyFilter() {
            @Override
            public boolean apply(Object source, String name, Object value) {
                if (name.equals("area") || name.equals("createBy") || name.equals("updateBy")
                        || name.equals("currentUser") || name.equals("page") || name.equals("sqlMap")) {
                    return true;
                } else {
                    return false;
                }
            }
        });
        jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("yyyy-MM-dd HH:mm:ss"));
        for (Entry<String, OrderRabbitMQInfo> entry : RabbitMQTools.orderRabbitMQInfoMap.entrySet()) {
            for (Entry<String, String[]> key : uuidList.entrySet()) {
                if (key.getKey().equals(entry.getKey())) {
                    for (CcmMessage ccmMessage : list) {
                        if (ccmMessage.getUserId().equals(key.getValue()[1])) {
                            RabbitMQTools.sendMessage(entry.getKey(),
                                    JSONObject.fromObject(ccmMessage, jsonConfig).toString());
                            break;
                        }
                    }
                }
            }
        }
    }

    public static void sendOneMessageToMq(CcmMessage ccmMessage) {
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.setJsonPropertyFilter(new PropertyFilter() {
            @Override
            public boolean apply(Object source, String name, Object value) {
                if (name.equals("area") || name.equals("createBy") || name.equals("updateBy")
                        || name.equals("currentUser") || name.equals("page") || name.equals("sqlMap")) {
                    return true;
                } else {
                    return false;
                }
            }
        });
        jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("yyyy-MM-dd HH:mm:ss"));
        for (Entry<String, OrderRabbitMQInfo> entry : RabbitMQTools.orderRabbitMQInfoMap.entrySet()) {
            for (Entry<String, String[]> key : uuidList.entrySet()) {
                if (key.getKey().equals(entry.getKey())) {
                    if (ccmMessage.getUserId().equals(key.getValue()[1])) {
                        RabbitMQTools.sendMessage(entry.getKey(),
                                JSONObject.fromObject(ccmMessage, jsonConfig).toString());
                    }
                }
            }
        }
    }

    /**
     * @param CcmEventIncident
     * @return
     * @author pengjianqiang
     * @version 2018-07-23
     * @see 上报警情事件信息（get接口，给杭州道人脸系统使用）
     */
    @ResponseBody
    @RequestMapping(value = "/saveGet", method = RequestMethod.GET)
    public CcmRestResult saveGet(String userId, String deviceIp, HttpServletRequest req,
                                 CcmEventIncident ccmEventIncident, Model model, RedirectAttributes redirectAttributes) {
        CcmRestResult result = new CcmRestResult();
        if (userId == null || "".equals(userId)) {
            userId = "1";
        }
        if (ccmEventIncident.getCreateBy() == null) {
            ccmEventIncident.setCreateBy(new User(userId));
        }
        if ("".equals(ccmEventIncident.getId()) || ccmEventIncident.getId() == null) {// 新增数据，默认事件状态为未处理
            ccmEventIncident.setStatus("01");
        }
        ccmEventIncident.setUpdateBy(new User(userId));

        if (ccmEventIncident.getHappenDate() == null || "".equals(ccmEventIncident.getHappenDate())) {// 无事件时间时，默认赋值当前时间
            ccmEventIncident.setHappenDate(new Date());
        }

        if ("".equals(ccmEventIncident.getAreaPoint()) || ccmEventIncident.getAreaPoint() == null) {// 无坐标时,去通过摄像机IP获取
            if (!"".equals(deviceIp) && deviceIp != null) {
                CcmDevice ccmDevice = ccmDeviceService.getByIp(deviceIp);
                if (ccmDevice != null) {
                    ccmEventIncident.setAreaPoint(ccmDevice.getCoordinate());
                    ccmEventIncident.setCasePlace(ccmDevice.getArea().getId());
                    ccmEventIncident.setArea(ccmDevice.getArea());
                    ccmEventIncident.setHappenPlace(ccmDevice.getAddress());
                }
            }
        }

        if (ccmEventIncident.getPeopleName() != null) {// 传人员姓名，赋值给嫌疑人姓名字段
            ccmEventIncident.setCulName(ccmEventIncident.getPeopleName());
        }
        if (ccmEventIncident.getEventScale() == null) {// 无事件分级时，默认04：一般
            ccmEventIncident.setEventScale("04");
        }
        if (ccmEventIncident.getProperty() == null) {// 无事件性质时，默认99：其他
            ccmEventIncident.setProperty("99");
        }
        if (ccmEventIncident.getEventType() == null) {// 无事件类型时，默认05：其他
            ccmEventIncident.setEventType("05");
        }
        if (ccmEventIncident.getEventKind() == null) {// 无事件种类时，默认09：其他
            ccmEventIncident.setEventKind("09");
        }
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        ccmEventIncident.setNumber(sdf.format(date));// 事件编号

        ccmEventIncidentService.save(ccmEventIncident,new User(userId));
        addMessage(redirectAttributes, "保存案事件登记成功");

        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.setJsonPropertyFilter(new PropertyFilter() {
            @Override
            public boolean apply(Object source, String name, Object value) {
                if (name.equals("area") || name.equals("createBy") || name.equals("updateBy")
                        || name.equals("currentUser") || name.equals("page") || name.equals("sqlMap")) {
                    return true;
                } else {
                    return false;
                }
            }
        });
        jsonConfig.registerJsonValueProcessor(Timestamp.class, new DateJsonValueProcessor("yyyy-MM-dd HH:mm:ss"));
        for (Map.Entry<String, OrderRabbitMQInfo> entry : RabbitMQTools.orderRabbitMQInfoMap.entrySet()) {
            for (Entry<String, String[]> key : uuidList.entrySet()) {
                if (key.getKey().equals(entry.getKey())) {
                    RabbitMQTools.sendMessage(entry.getKey(),
                            JSONObject.fromObject(ccmEventIncident, jsonConfig).toString());
                }
            }
        }
//		RabbitMQTools.sendMessage(clientId,JSONObject.fromObject(ccmEventIncident, jsonConfig).toString());
//		sendMessage(JSONObject.fromObject(ccmEventIncident, jsonConfig).toString());	

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventIncident);
        return result;
    }

    private static ConnectionFactory connectionFactory = null;
    private static Connection connection = null;
    private static Topic topic = null;
    private static Session session = null;
    private static boolean JMSStatus = false;
    private static Map<String, String[]> uuidList = new ConcurrentHashMap<String, String[]>();
    private static Map<String, String> uuidList1 = new ConcurrentHashMap<String, String>();

    private static MessageProducer producer = null;

    /**
     * @param uuid
     * @return
     * @author pengjianqiang
     * @version 2018-02-24
     * @see 订阅消息中间件
     */
    @ResponseBody
    @RequestMapping(value = "/subscribeAmq", method = RequestMethod.GET)
    public CcmRestResult subscribeAmq(String uuid) {
        CcmRestResult result = new CcmRestResult();
        if (uuid == null || "".equals(uuid)) {
            UUID id = UUID.randomUUID();
            SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            String[] value = new String[2];
            value[0] = formatDate.format(date);
            value[1] = UserUtils.getUser().getId();
            uuidList.put(id.toString(), value);
            result.setCode(CcmRestType.OK);
            result.setResult(id.toString());
        }
        return result;
    }

    @ResponseBody
    @RequestMapping(value = "/subscribeAmq1", method = RequestMethod.GET)
    public CcmRestResult subscribeAmq1(String uuid) {
        CcmRestResult result = new CcmRestResult();
        if (uuid == null || "".equals(uuid)) {
            UUID id = UUID.randomUUID();
            SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            uuidList1.put(id.toString(), formatDate.format(date));
            result.setCode(CcmRestType.OK);
            result.setResult(id.toString());
        }
        return result;
    }

    /**
     * 方法说明：发送心跳的接口
     *
     * @param uuid
     * @return
     * @author pengjianqiang
     * @version 2018-02-24
     */
    /*
     * @ResponseBody
     *
     * @RequestMapping(value="/sendHeartBeat", method = RequestMethod.GET) public
     * int sendHeartBeat(String uuid) { if(null != uuidList && uuidList.size() > 0){
     * if(uuidList.containsKey(uuid)){ SimpleDateFormat formatDate = new
     * SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); Date date =new Date(); String time =
     * formatDate.format(date); uuidList.put(uuid, time); return 0; } } return -1; }
     */

    /**
     * 方法说明：取消订阅
     *
     * @param uuid
     * @return
     * @author pengjianqiang
     * @version 2018-02-24
     */
    @ResponseBody
    @RequestMapping(value = "/unSubscribeAmq", method = RequestMethod.GET)
    public int unSubscribeAmq(String uuid) {
        if (null != uuidList && uuidList.size() > 0) {
            if (uuidList.containsKey(uuid)) {
                uuidList.remove(uuid);
                return 0;
            }
        }
        return -1;
    }

    @ResponseBody
    @RequestMapping(value = "/unSubscribeAmq1", method = RequestMethod.GET)
    public int unSubscribeAmq1(String uuid) {
        if (null != uuidList1 && uuidList1.size() > 0) {
            if (uuidList1.containsKey(uuid)) {
                uuidList1.remove(uuid);
                return 0;
            }
        }
        return -1;
    }

    /**
     * 方法说明：清除超时的客户端
     *
     * @return
     * @author pengjianqiang
     * @version 2018-02-24
     */
    public static void clearTimeoutClient() throws Exception {
//		 System.out.println("清除超时的客户端");
        for (Map.Entry<String, String[]> entry : uuidList.entrySet()) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date now = new Date();
            Date heartBeatTime = format.parse(entry.getValue()[0]);
            if ((now.getTime() - heartBeatTime.getTime()) > 1000 * 60 * 2) {// 超时超过2分钟
                uuidList.remove(entry.getKey());
            }
        }
    }

    public static List<String> clearTimeoutClient1() throws Exception {

        List<String> queueList = Lists.newArrayList();

        for (Map.Entry<String, String> entry : uuidList1.entrySet()) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date now = new Date();
            Date heartBeatTime = format.parse(entry.getValue());
            if ((now.getTime() - heartBeatTime.getTime()) > 1000 * 60 * 2) {// 超时超过2分钟
                System.out.println(now.getTime() - heartBeatTime.getTime());
                uuidList1.remove(entry.getKey());
                queueList.add(entry.getKey());
            }
        }

        return queueList;
    }

    public static void updateMqDate(String queueName) throws Exception {

        for (Map.Entry<String, String> entry : uuidList1.entrySet()) {
            if (entry.getKey().equals(queueName)) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                entry.setValue(sdf.format(new Date()));
            }

        }

    }

    /**
     * 方法说明：向消息中间件中插入信息
     *
     * @param info
     * @return
     * @author pengjianqiang
     * @version 2018-02-24
     */
    public void sendMessage(String info) {
        try {
            if (!JMSStatus) {
                System.out.println("消息中间件不在线，发送失败！");
                return;
            }
            TextMessage message = session.createTextMessage();
            info = CommUtil.encodeURL(info, "UTF-8");
            message.setText(info);
            producer.setTimeToLive(120 * 1000);
            producer.send(message);
            System.out.println("发送成功：" + message);
            // session.commit();
        } catch (Exception e) {
            System.out.println("发送异常！！！");
            JMSStatus = false;
            System.out.println(e.getMessage());
        }
    }

    /**
     * 方法说明：初始化消息中间件connection
     *
     * @return
     * @author pengjianqiang
     * @version 2018-02-24
     */
    public static void initializeAmq() throws Exception {
        String mq_path = Global.getConfig("ACTIVE_MQ_PATH");// 消息中间件地址
//		 System.out.println("初始化检测消息中间件......");
        clearTimeoutClient();
        clearTimeoutClient1();
        /*
         * if(JMSStatus){ return; }
         */

        try {
            if (connectionFactory == null) {
                connectionFactory = new ActiveMQConnectionFactory(mq_path);
            }
            if (connection != null) {
                connection.stop();
                connection.close();
                connection = null;
            }
            connection = connectionFactory.createConnection();
            connection.start();

            if (session != null) {
                session.close();
                session = null;
            }
            session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            topic = session.createTopic(CcmRestType.REAL_MONITOR_UUID);
            producer = session.createProducer(topic);
            producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);
            JMSStatus = true;
//			System.out.println("消息中间件初始化成功！");
        } catch (Exception e) {
            JMSStatus = false;
            System.out.println("消息中间件初始化失败:" + e.getMessage());
        }
    }

    /**
     * @param id 事件ID
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 查询单个事件的所有处理信息
     */
    @ResponseBody
    @RequestMapping(value = "/getEventDealList", method = RequestMethod.GET)
    public CcmRestResult getEventDealList(Page<CcmEventCasedeal> page, String userId, HttpServletRequest req,
                                          HttpServletResponse resp, String id) throws IOException {
        if (page.getPageSize() == -1) {
            page.setPageSize(30);
        }
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
        if (id == null || "".equals(id)) {// 参数id不对
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }
        CcmEventCasedeal ccmEventCasedeal = new CcmEventCasedeal();
        ccmEventCasedeal.setPage(page);
        List<CcmEventCasedeal> CcmEventCasedealList = ccmEventIncidentService.findList(id);
        String file = Global.getConfig("FILE_UPLOAD_URL");
        for(CcmEventCasedeal res : CcmEventCasedealList){
            if(StringUtils.isNotEmpty(res.getFile())){
                res.setFile(file + res.getFile());
            }
        }
        page.setList(CcmEventCasedealList);
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * @param id 事件处理ID
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 查询所有事件处理信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryEventCasedeal", method = RequestMethod.GET)
    public CcmRestResult queryEventCasedeal(String userId, CcmEventCasedeal ccmEventCasedeal, HttpServletRequest req,
                                            HttpServletResponse resp, String id) throws IOException {
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
        ccmEventCasedeal.setCurrentUser(sessionUser);
        Page<CcmEventCasedeal> page = ccmEventCasedealService.findPage(new Page<CcmEventCasedeal>(req, resp),
                ccmEventCasedeal);

        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * @param id 事件处理ID
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 查询单个事件处理信息
     */
    @ResponseBody
    @RequestMapping(value = "/getEventCasedeal", method = RequestMethod.GET)
    public CcmRestResult getEventCasedeal(String userId, HttpServletRequest req, HttpServletResponse resp, String id)
            throws IOException {
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
        if (id == null || "".equals(id)) {// 参数id不对
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }

        CcmEventCasedeal ccmEventCasedeal = ccmEventCasedealService.get(id);
        if (ccmEventCasedeal == null) {// 参数id不对
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }

        String file = ccmEventCasedeal.getFile();
        if (StringUtils.isNotEmpty(file)) {
            String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
            ccmEventCasedeal.setFile(fileUrl + file);
        }

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventCasedeal);

        return result;
    }

    /**
     * @param CcmEventCasedeal
     * @return
     * @author pengjianqiang
     * @version 2018-02-23
     * @see 保存事件处理信息
     */
    @ResponseBody
    @RequestMapping(value = "/saveEventCasedeal", method = RequestMethod.POST)
    public CcmRestResult saveEventCasedeal(String userId, HttpServletRequest req, CcmEventCasedeal ccmEventCasedeal,
                                           Model model, RedirectAttributes redirectAttributes) {
        CcmRestResult result = new CcmRestResult();
        if (!beanValidator(model, ccmEventCasedeal)) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }
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
        if (ccmEventCasedeal.getId() != null && !"".equals(ccmEventCasedeal.getId())) {
            CcmEventCasedeal ccmEventCasedealDB = ccmEventCasedealService.get(ccmEventCasedeal.getId());
            if (ccmEventCasedealDB == null) {// 从数据库中没有取到对应数据
                result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            } else {
                ccmEventCasedealDB.setHandleDate(ccmEventCasedeal.getHandleDate());
                ccmEventCasedealDB.setHandleStep(ccmEventCasedeal.getHandleStep());
                ccmEventCasedealDB.setHandleStatus("05");
                ccmEventCasedealDB.setHandleFeedback(ccmEventCasedeal.getHandleFeedback());
                ccmEventCasedealDB.setRemarks(ccmEventCasedeal.getRemarks());
                ccmEventCasedealDB.setFile(ccmEventCasedeal.getFile());
                ccmEventCasedealDB.setUpdateBy(new User(userId));
                ccmEventCasedealService.save(ccmEventCasedealDB);
                result.setCode(CcmRestType.OK);
                result.setResult("保存成功");
                User resuser = UserUtils.get(userId);
                User user = new User(userId);
                //添加日志
                ccmEventCasedeal.setCaseName(ccmEventCasedealDB.getCaseName());
                ccmEventCasedeal.setObjId(ccmEventCasedealDB.getObjId());
                ccmLogTailService.eventFeedBackLogTail(ccmEventCasedeal,resuser);
                //添加消息及MQ
                CcmMessage ccmMessage = new CcmMessage();
                ccmMessage.setCreateBy(user);
                ccmMessage.setUpdateBy(user);
                ccmMessage.setType("02");//事件上报消息
                Date createDate = ccmEventCasedealDB.getUpdateDate();
                String str = "MM-dd HH:mm:ss";
                SimpleDateFormat sdf = new SimpleDateFormat(str);
                ccmMessage.setContent(sdf.format(createDate) + "：" + ccmEventCasedealDB.getCaseName() + "事件已被" + resuser.getName() + "处理");
                ccmMessage.setReadFlag("0");//未读
                ccmMessage.setObjId(ccmEventCasedealDB.getId());
                ccmMessage.setUserId(ccmEventCasedealDB.getCreateBy().getId());
                //批量添加
                ccmMessageService.save(ccmMessage);
                sendOneMessageToMq(ccmMessage);
            }
        } else {
            result.setCode(CcmRestType.ERROR_NO_PERSSION);// 不允许app添加
        }
        /*
         * if (ccmEventCasedeal.getCreateBy()== null) { ccmEventCasedeal.setCreateBy(new
         * User(userId)); }
         */

        return result;
    }

    /**
     * @param
     * @return
     * @author fuxinshuang
     * @version 2018-03-07
     * @see 查询所有重点地区排查整治信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryEventKacc", method = RequestMethod.GET)
    public CcmRestResult queryEventKacc(String userId, CcmEventKacc ccmEventKacc, HttpServletRequest req,
                                        HttpServletResponse resp, String id) throws IOException {
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

        ccmEventKacc.setCheckUser(sessionUser);
        Page<CcmEventKacc> page = ccmEventKaccService.findPage(new Page<CcmEventKacc>(req, resp), ccmEventKacc);

        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * @param id 事件处理ID
     * @return
     * @author fuxinshuang
     * @version 2018-03-07
     * @see 查询单个重点地区排查整治信息
     */
    @ResponseBody
    @RequestMapping(value = "/getEventKacc", method = RequestMethod.GET)
    public CcmRestResult getEventKacc(String userId, HttpServletRequest req, HttpServletResponse resp, String id)
            throws IOException {
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
        if (id == null || "".equals(id)) {// 参数id不对
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }

        CcmEventKacc ccmEventKacc = ccmEventKaccService.get(id);

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventKacc);

        return result;
    }

    /**
     * @param
     * @return
     * @author fuxinshuang
     * @version 2018-03-07
     * @see 保存重点地区排查整治信息
     */
    @ResponseBody
    @RequestMapping(value = "/saveEventKacc", method = RequestMethod.POST)
    public CcmRestResult saveEventKacc(String userId, HttpServletRequest req, CcmEventKacc ccmEventKacc, Model model,
                                       RedirectAttributes redirectAttributes) {
        CcmRestResult result = new CcmRestResult();
        if (!beanValidator(model, ccmEventKacc)) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }
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
        if (ccmEventKacc.getId() != null && !"".equals(ccmEventKacc.getId())) {
            CcmEventKacc ccmEventKaccDB = ccmEventKaccService.get(ccmEventKacc.getId());
            if (ccmEventKaccDB == null) {// 从数据库中没有取到对应数据
                result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            }
        }
        if (ccmEventKacc.getCreateBy() == null) {
            ccmEventKacc.setCreateBy(new User(userId));
        }
        ccmEventKacc.setUpdateBy(new User(userId));
        ccmEventKaccService.save(ccmEventKacc);
        addMessage(redirectAttributes, "保存事件处理成功");

        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventKacc);
        return result;
    }

    /**
     * @param
     * @return
     * @author fuxinshuang
     * @version 2018-03-07
     * @see 查询所有命案防控管理信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryMurder", method = RequestMethod.GET)
    public CcmRestResult queryMurder(String userId, CcmEventIncident ccmEventIncident, HttpServletRequest req,
                                     HttpServletResponse resp, String id) throws IOException {
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
        ccmEventIncident.setCheckUser(sessionUser);
        Page<CcmEventIncident> page = ccmEventIncidentService.findPageMurder(new Page<CcmEventIncident>(req, resp),
                ccmEventIncident);

        String fileUrl = Global.getConfig("FILE_UPLOAD_URL");
        for (CcmEventIncident resccmEventIncident : page.getList()) {
            resccmEventIncident.setFile1(StringUtils.isNotEmpty(resccmEventIncident.getFile1()) ? fileUrl + resccmEventIncident.getFile1() : "");
            resccmEventIncident.setFile2(StringUtils.isNotEmpty(resccmEventIncident.getFile2()) ? fileUrl + resccmEventIncident.getFile2() : "");
            resccmEventIncident.setFile3(StringUtils.isNotEmpty(resccmEventIncident.getFile3()) ? fileUrl + resccmEventIncident.getFile3() : "");
        }
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * @param
     * @return
     * @author fuxinshuang
     * @version 2018-03-07
     * @see 查询所有涉及线、路案事件信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryLine", method = RequestMethod.GET)
    public CcmRestResult queryLine(String userId, CcmEventIncident ccmEventIncident, HttpServletRequest req,
                                   HttpServletResponse resp, String id) throws IOException {
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
        ccmEventIncident.setCheckUser(sessionUser);
        Page<CcmEventIncident> page = ccmEventIncidentService.findPageLine(new Page<CcmEventIncident>(req, resp),
                ccmEventIncident);
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * @param
     * @return
     * @author fuxinshuang
     * @version 2018-03-07
     * @see 查询所有涉及师生安全的案事件信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryStudent", method = RequestMethod.GET)
    public CcmRestResult queryStudent(String userId, CcmEventIncident ccmEventIncident, HttpServletRequest req,
                                      HttpServletResponse resp, String id) throws IOException {
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
        ccmEventIncident.setCheckUser(sessionUser);
        Page<CcmEventIncident> page = ccmEventIncidentService.findPageStudent(new Page<CcmEventIncident>(req, resp),
                ccmEventIncident);
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());

        return result;
    }

    /**
     * @param id 矛盾纠纷排查ID
     * @return
     * @author fuxinshuang
     * @version 2018-03-15
     * @see 获取单个矛盾纠纷排查
     */
    @ResponseBody
    @RequestMapping(value = "/getAmbi", method = RequestMethod.GET)
    public CcmRestResult getAmbi(String userId, HttpServletRequest req, HttpServletResponse resp, String id)
            throws IOException {
        // 获取results
        CcmRestResult result = CommUtilRest.getResult(userId, req, resp, id);
        // 如果当前的 flag 为返回
        if (result.isReturnFlag()) {
            return result;
        }
        // 当前 是否为空
        CcmEventAmbi ccmEventAmbi = ccmEventAmbiService.get(id);
        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventAmbi);

        return result;
    }

    /**
     * @param pageNo  页码
     * @param pageSiz 分页大小
     * @return
     * @author fuxinshuang
     * @version 2018-03-15
     * @see 查询矛盾纠纷排查信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryAmbi", method = RequestMethod.GET)
    public CcmRestResult queryAmbi(String userId, HttpServletRequest req, HttpServletResponse resp,
                                   CcmEventAmbi ccmEventAmbi) throws IOException {
        // 获取结果
        CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
        // 如果当前的 flag 为返回
        if (result.isReturnFlag()) {
            return result;
        }
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
        // 设置当前的 矛盾纠纷排查不为空
        ccmEventAmbi = (null == ccmEventAmbi) ? new CcmEventAmbi() : ccmEventAmbi;
        // 获取userId
        User userEntity = new User();
        userEntity.setId(userId);
        ccmEventAmbi.setCreateBy(userEntity);
        ccmEventAmbi.setCheckUser(sessionUser);
        Page<CcmEventAmbi> page = ccmEventAmbiService.findPage(new Page<CcmEventAmbi>(req, resp),
                (null == ccmEventAmbi) ? new CcmEventAmbi() : ccmEventAmbi);
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());
        // 输出结果
        return result;
    }

    /**
     * @param ccmEventAmbi 矛盾纠纷排查对象
     * @author fuxinshuang
     * @version 2018-03-13
     * @see 填加矛盾纠纷排查
     */
    @ResponseBody
    @RequestMapping(value = "/saveAmbi", method = RequestMethod.POST)
    public CcmRestResult saveAmbi(String userId, CcmEventAmbi ccmEventAmbi, HttpServletRequest req,
                                  HttpServletResponse resp) throws IOException {
        // 获取结果
        CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
        // 如果当前的 flag 为返回
        if (result.isReturnFlag()) {
            return result;
        }
        // 如果创建者为空
        if (null == ccmEventAmbi.getCreateBy()) {
            ccmEventAmbi.setCreateBy(new User(userId));
        }
        ccmEventAmbi.setUpdateBy(new User(userId));
        ccmEventAmbiService.save(ccmEventAmbi);
        // 返回
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;
    }

    /**
     * @param id 请求登记ID
     * @return
     * @author fuxinshuang
     * @version 2018-03-15
     * @see 获取单个请求登记
     */
    @ResponseBody
    @RequestMapping(value = "/getRequest", method = RequestMethod.GET)
    public CcmRestResult getRequest(String userId, HttpServletRequest req, HttpServletResponse resp, String id)
            throws IOException {
        // 获取results
        CcmRestResult result = CommUtilRest.getResult(userId, req, resp, id);
        // 如果当前的 flag 为返回
        if (result.isReturnFlag()) {
            return result;
        }
        // 当前 是否为空
        CcmEventRequest ccmEventRequest = ccmEventRequestService.get(id);
        result.setCode(CcmRestType.OK);
        result.setResult(ccmEventRequest);

        return result;
    }

    /**
     * @param pageNo  页码
     * @param pageSiz 分页大小
     * @return
     * @author fuxinshuang
     * @version 2018-03-15
     * @see 查询请求登记信息
     */
    @ResponseBody
    @RequestMapping(value = "/queryRequest", method = RequestMethod.GET)
    public CcmRestResult queryRequest(String userId, HttpServletRequest req, HttpServletResponse resp,
                                      CcmEventRequest ccmEventRequest) throws IOException {
        // 获取结果
        CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
        // 如果当前的 flag 为返回
        if (result.isReturnFlag()) {
            return result;
        }

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

        // 设置当前的 请求登记不为空
        ccmEventRequest = (null == ccmEventRequest) ? new CcmEventRequest() : ccmEventRequest;
        // 获取userId
        User userEntity = new User();
        userEntity.setId(userId);
        ccmEventRequest.setCreateBy(userEntity);
        ccmEventRequest.setCheckUser(sessionUser);
        Page<CcmEventRequest> page = ccmEventRequestService.findPage(new Page<CcmEventRequest>(req, resp),
                (null == ccmEventRequest) ? new CcmEventRequest() : ccmEventRequest);
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());
        // 输出结果
        return result;
    }

    /**
     * @param ccmEventRequest 请求登记对象
     * @author fuxinshuang
     * @version 2018-03-13
     * @see 填加请求登记
     */
    @ResponseBody
    @RequestMapping(value = "/saveRequest", method = RequestMethod.POST)
    public CcmRestResult saveRequest(String userId, CcmEventRequest ccmEventRequest, HttpServletRequest req,
                                     HttpServletResponse resp) throws IOException {
        // 获取结果
        CcmRestResult result = CommUtilRest.queryResult(userId, req, resp);
        // 如果当前的 flag 为返回
        if (result.isReturnFlag()) {
            return result;
        }
        // 如果创建者为空
        if (null == ccmEventRequest.getCreateBy()) {
            ccmEventRequest.setCreateBy(new User(userId));
        }
        ccmEventRequest.setUpdateBy(new User(userId));
        ccmEventRequestService.save(ccmEventRequest);
        // 返回
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;
    }

    /********** 以下是上下级平台数据同步用 ***************/

    /**
     * @author liangwanmin
     * @version 2018-05-29
     * @see 保存矛盾纠纷排查信息（支持新增和编辑,数据同步用）
     */
    @ResponseBody
    @RequestMapping(value = "/saveAmbiSyn", method = RequestMethod.POST)
    public CcmRestResult saveAmbiSyn(String userId, CcmEventAmbi ccmEventAmbi, HttpServletRequest req,
                                     HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        if (userId == null || "".equals(userId)) {
            userId = "1";
        }
        User user = new User(userId);
        ccmEventAmbi.setCreateBy(user);
        ccmEventAmbi.setUpdateBy(user);

        ccmEventAmbiService.save(ccmEventAmbi);
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;

    }

    /**
     * @author liangwanmin
     * @version 2018-05-29
     * @see 删除矛盾纠纷排查信息（数据同步用）
     */
    @ResponseBody
    @RequestMapping(value = "/deleteAmbiSyn", method = RequestMethod.POST)
    public CcmRestResult deleteAmbiSyn(String userId, CcmEventAmbi ccmEventAmbi, HttpServletRequest req,
                                       HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        ccmEventAmbiService.delete(ccmEventAmbi);
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;

    }

    /**
     * @param
     * @return
     * @author pengjianqiang
     * @version 2018-05-29
     * @see 保存案事件信息（支持新增和编辑,数据同步用）
     */
    @ResponseBody
    @RequestMapping(value = "/saveSyn", method = RequestMethod.POST)
    public CcmRestResult saveSyn(String userId, CcmEventIncident ccmEventIncident, HttpServletRequest req,
                                 HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        if (userId == null || "".equals(userId)) {
            userId = "1";
        }
        User user = new User(userId);
        ccmEventIncident.setCreateBy(user);
        ccmEventIncident.setUpdateBy(user);

        ccmEventIncidentService.save(ccmEventIncident,user);
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;

    }

    /**
     * @param
     * @return
     * @author pengjianqiang
     * @version 2018-05-29
     * @see 删除案事件信息（数据同步用）
     */
    @ResponseBody
    @RequestMapping(value = "/deleteSyn", method = RequestMethod.POST)
    public CcmRestResult deleteSyn(String userId, CcmEventIncident ccmEventIncident, HttpServletRequest req,
                                   HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        ccmEventIncidentService.delete(ccmEventIncident);
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;

    }

    /**
     * @author liangwanmin
     * @version 2018-05-29
     * @see 保存重点地区排查整治信息（支持新增和编辑,数据同步用）
     */
    @ResponseBody
    @RequestMapping(value = "/saveKaccSyn", method = RequestMethod.POST)
    public CcmRestResult saveKaccSyn(String userId, CcmEventKacc ccmEventKacc, HttpServletRequest req,
                                     HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        if (userId == null || "".equals(userId)) {
            userId = "1";
        }
        User user = new User(userId);
        ccmEventKacc.setCreateBy(user);
        ccmEventKacc.setUpdateBy(user);

        ccmEventKaccService.save(ccmEventKacc);
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;

    }

    /**
     * @author liangwanmin
     * @version 2018-05-29
     * @see 删除重点地区排查整治信息（数据同步用）
     */
    @ResponseBody
    @RequestMapping(value = "/deleteKaccSyn", method = RequestMethod.POST)
    public CcmRestResult deleteKaccSyn(String userId, CcmEventKacc ccmEventKacc, HttpServletRequest req,
                                       HttpServletResponse resp) throws IOException {
        CcmRestResult result = new CcmRestResult();
        ccmEventKaccService.delete(ccmEventKacc);
        result.setCode(CcmRestType.OK);
        result.setResult("成功");
        return result;

    }

    @ResponseBody
    @RequestMapping(value = "/incident", method = RequestMethod.POST)
    public CcmRestResult incident(String userId, String ids, CcmEventIncident ccmEventIncident, HttpServletRequest req, CcmLogTail ccmLogTail) {

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

        if (StringUtils.isEmpty(ids)) {
            result.setCode(CcmRestType.ERROR_PARAM);
            return result;
        }


        CcmEventIncident ccmEventIncidentDB = ccmEventIncidentService.get(ids);

        if (ccmEventIncidentDB == null) {
            result.setCode(CcmRestType.ERROR_DB_NOT_EXIST);
            return result;
        }

        if (StringUtils.isNotEmpty(ccmEventIncident.getUrgent())) {
            ccmEventIncidentDB.setUrgent(ccmEventIncident.getUrgent());
        }
        if (StringUtils.isNotEmpty(ccmEventIncident.getHistoryLegacy())) {
            ccmEventIncidentDB.setHistoryLegacy(ccmEventIncident.getHistoryLegacy());
        }
        if (StringUtils.isNotEmpty(ccmEventIncident.getStick())) {
            ccmEventIncidentDB.setStick(ccmEventIncident.getStick());
        }
        if (StringUtils.isNotEmpty(ccmEventIncident.getRatify())) {
            ccmEventIncidentDB.setRatify(ccmEventIncident.getRatify());
        }
        ccmEventIncidentDB.setIds(ids.split(","));
        ccmEventIncidentDB.setUpdateBy(sessionUser);
        ccmEventIncidentService.incident(ccmEventIncidentDB);

        if (null != ccmLogTail) {
            ccmLogTail.setUpdateBy(sessionUser);
            ccmLogTail.setCreateBy(sessionUser);
            ccmLogTailService.insertLogTail(ccmLogTail, ids);
        }

        result.setCode(CcmRestType.OK);
        result.setReturnFlag(true);
        result.setResult("成功");
        return result;
    }


    /**
     * @throws IOException
     * @方法描述：订阅rabbitMQ
     */
    @RequestMapping(value = "orderRabbitMQInfo")
    public void orderRabbitMQInfo(HttpServletRequest req, HttpServletResponse resp, String json) throws IOException {
        resp.getWriter().print(JSONObject.fromObject(ccmRestEvent.orderRabbitMQInfo(json)));

    }

    /**
     * @throws IOException
     * @方法描述：取消订阅rabbitMQ
     */
    @RequestMapping(value = "cancelOrderRabbitMQInfo")
    public void cancelOrderRabbitMQInfo(HttpServletRequest req, HttpServletResponse resp, String clientId)
            throws IOException {
        resp.getWriter().print(JSONObject.fromObject(ccmRestEvent.cancelOrderRabbitMQInfo(clientId)));
    }

    /**
     * @throws IOException
     * @方法描述：心跳
     */
    @RequestMapping(value = "sendFenceHeartBeat")
    public void sendFenceHeartBeat(HttpServletRequest req, HttpServletResponse resp, String json) throws IOException {
        resp.getWriter().print(JSONObject.fromObject(ccmRestEvent.sendHeartBeat(json)));
    }

}