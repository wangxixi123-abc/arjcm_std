package com.arjjs.ccm.modules.dma.orgAnalysis.web;

import com.arjjs.ccm.modules.ccm.event.service.CcmEventIncidentService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgLeaddutyService;
import com.arjjs.ccm.modules.ccm.org.service.CcmOrgOrgpreventService;
import com.arjjs.ccm.modules.ccm.view.service.VCcmOrgService;
import com.arjjs.ccm.modules.ccm.view.service.VCcmTeamService;
import com.arjjs.ccm.tool.EchartType;
import net.sf.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "${adminPath}/view/CcmOrgAnalysis")
public class CcmOrgAnalysisController {

    @Autowired
    private VCcmOrgService vCcmOrgService;
    @Autowired
    private VCcmTeamService vCcmTeamService;
    @Autowired
    private CcmOrgOrgpreventService ccmOrgOrgpreventService;
    @Autowired
    private CcmEventIncidentService ccmEventIncidentService;
    @Autowired
    private CcmOrgLeaddutyService ccmOrgLeaddutyService;

    // 跳转首页
    @RequestMapping(value = { "index", "" })
    public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
        return "dma/orgAnalysis/CcmOrgAnalysis";
    }

    /**
     * 根据综治机构统计情况
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"getByOrgType"})
    public JSONArray getByOrgType(HttpServletRequest request, HttpServletResponse response) {
        List<EchartType> list = vCcmOrgService.getByOrgType();

        JSONArray jsondata = JSONArray.fromObject(list);

        return jsondata;
    }

    /**
     * 根据综治组织队伍性别统计情况
     *
     * @param model
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "getBySex")
    public List<com.arjjs.ccm.tool.EchartType> getBySex(Model model) {
        // 返回对象结果
        List<EchartType> list = vCcmTeamService.getBySex();
        return list;
    }

    /**
     * 根据群防群治组织类型统计情况
     *
     * @param model
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "getByOrgpreventComType")
    public List<com.arjjs.ccm.tool.EchartType> getByOrgpreventComType(Model model) {
        // 返回对象结果
        List<EchartType> list = ccmOrgOrgpreventService.getByOrgpreventComType();
        return list;
    }




    /**
     * 根据综治领导责任制统计情况
     *
     * @param model
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "getByPolicyType")
    public List<com.arjjs.ccm.tool.EchartType> getByPolicyType(Model model) {
        // 返回对象结果
        List<EchartType> list = ccmOrgLeaddutyService.getByPolicyType();
        return list;
    }

    /**
     * @see 根据重大案件分级统计情况
     * @param model
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "getItemByScale")
    public Map<String, Object> getItemByScale(Model model) {
        // 返回对象结果
    	Map<String, Object> map = ccmEventIncidentService.getItemByScale();
        return map;
    }

    /**
     * 根据群防群治组织民族统计情况
     * @return
     */
    @ResponseBody
    @RequestMapping(value = {"getByNation"})
    public JSONArray getByNation(HttpServletRequest request, HttpServletResponse response) {
        List<EchartType> list = vCcmTeamService.getByNation();

        JSONArray jsondata = JSONArray.fromObject(list);

        return jsondata;
    }

}