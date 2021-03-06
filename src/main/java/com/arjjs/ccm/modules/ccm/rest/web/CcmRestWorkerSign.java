package com.arjjs.ccm.modules.ccm.rest.web;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.worker.entity.CcmWorkerSign;
import com.arjjs.ccm.modules.ccm.worker.service.CcmWorkerSignService;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * @author
 * @title: CcmRestWorkerSign
 * @description: TODO
 * @date 2019/10/28 17:50
 */
@Controller
@RequestMapping(value = "${appPath}/rest/service/ccmWorkerSign")
public class CcmRestWorkerSign {

    @Autowired
    private CcmWorkerSignService ccmWorkerSignService;


    //获取详情
    @ResponseBody
    @RequestMapping(value = "/getinfo", method = RequestMethod.GET)
    public CcmRestResult getinfo(String id) {
        CcmRestResult result = new CcmRestResult();
        CcmWorkerSign entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = ccmWorkerSignService.get(id);
        }
        if (entity == null){
            entity = new CcmWorkerSign();
        }
        result.setCode(CcmRestType.OK);
        result.setResult(entity);
        return result;
    }


    //获取列表
    @ResponseBody
    @RequestMapping(value = "/getList", method = RequestMethod.GET)
    public CcmRestResult getList(String userId,CcmWorkerSign ccmWorkerSign, HttpServletRequest request, HttpServletResponse response) {
        CcmRestResult result = new CcmRestResult();
        User user = UserUtils.get(userId);
        if(!user.isAdmin()){
            ccmWorkerSign.setUser(user);
        }
        Page<CcmWorkerSign> page = ccmWorkerSignService.findPage(new Page<CcmWorkerSign>(request, response), ccmWorkerSign);
        result.setCode(CcmRestType.OK);
        result.setResult(page.getList());
        return result;
    }


    //签到
    @ResponseBody
    @RequestMapping(value = "/getform", method = RequestMethod.GET)
    public CcmRestResult getform(String userId,CcmWorkerSign ccmWorkerSign) {
        CcmRestResult result = new CcmRestResult();
        User user = UserUtils.get(userId);
        ccmWorkerSign.setUser(user);
        ccmWorkerSign.setContent("日常签到");
        ccmWorkerSign.setType("10");
        ccmWorkerSign.setStatus("10");
        ccmWorkerSign.setSignDate(new Date());
        ccmWorkerSign.setCreateBy(user);
        ccmWorkerSign.setUpdateBy(user);
        if(StringUtils.isNotEmpty(ccmWorkerSign.getAreaPoint()) && ccmWorkerSign.getAreaPoint().contains(",")){
            String x = ccmWorkerSign.getAreaPoint().split(",")[0];
            String y = ccmWorkerSign.getAreaPoint().split(",")[1];
            ccmWorkerSign.setAreaPoint(y+","+x);
        }
        ccmWorkerSignService.save(ccmWorkerSign);
        result.setCode(CcmRestType.OK);
        result.setMsg("OK");
        result.setResult("OK");
        return result;
    }


    //签退
    @ResponseBody
    @RequestMapping(value = "/resform", method = RequestMethod.GET)
    public CcmRestResult resform(String userId,CcmWorkerSign ccmWorkerSign) {
        CcmRestResult result = new CcmRestResult();
        User user = UserUtils.get(userId);
        ccmWorkerSign.setUser(user);
        ccmWorkerSign.setContent("日常签退");
        ccmWorkerSign.setType("20");
        ccmWorkerSign.setStatus("10");
        ccmWorkerSign.setSignDate(new Date());
        ccmWorkerSign.setCreateBy(user);
        ccmWorkerSign.setUpdateBy(user);
        if(StringUtils.isNotEmpty(ccmWorkerSign.getAreaPoint()) && ccmWorkerSign.getAreaPoint().contains(",")){
            String x = ccmWorkerSign.getAreaPoint().split(",")[0];
            String y = ccmWorkerSign.getAreaPoint().split(",")[1];
            ccmWorkerSign.setAreaPoint(y+","+x);
        }
        ccmWorkerSignService.save(ccmWorkerSign);
        result.setCode(CcmRestType.OK);
        result.setMsg("OK");
        result.setResult("OK");
        return result;
    }



}

    
    
    
