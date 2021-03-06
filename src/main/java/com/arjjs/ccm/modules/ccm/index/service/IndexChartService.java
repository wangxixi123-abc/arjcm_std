package com.arjjs.ccm.modules.ccm.index.service;

import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.modules.ccm.event.dao.CcmEventAmbiDao;
import com.arjjs.ccm.modules.ccm.event.dao.CcmEventIncidentDao;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventAmbi;
import com.arjjs.ccm.modules.ccm.event.entity.CcmEventIncident;
import com.arjjs.ccm.modules.ccm.house.dao.CcmHouseBuildmanageDao;
import com.arjjs.ccm.modules.ccm.house.dao.CcmHouseSchoolrimDao;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseBuildmanage;
import com.arjjs.ccm.modules.ccm.house.entity.CcmHouseSchoolrim;
import com.arjjs.ccm.modules.ccm.line.dao.CcmLineProtectDao;
import com.arjjs.ccm.modules.ccm.line.entity.CcmLineProtect;
import com.arjjs.ccm.modules.ccm.org.dao.CcmOrgNpseDao;
import com.arjjs.ccm.modules.ccm.org.entity.CcmOrgNpse;
import com.arjjs.ccm.modules.ccm.place.dao.CcmBasePlaceDao;
import com.arjjs.ccm.modules.ccm.place.entity.CcmBasePlace;
import com.arjjs.ccm.modules.ccm.pop.dao.CcmPeopleDao;
import com.arjjs.ccm.modules.ccm.pop.dao.CcmPopTenantDao;
import com.arjjs.ccm.modules.ccm.pop.dao.CcmRoadAddressDao;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPopTenant;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmRoadAddress;
import com.arjjs.ccm.modules.ccm.view.dao.VCcmTeamDao;
import com.arjjs.ccm.modules.ccm.view.entity.VCcmTeam;
import com.arjjs.ccm.tool.EchartType;
import com.arjjs.ccm.tool.LayUIBean;
import com.google.common.collect.Lists;

@Service
@Transactional(readOnly = true)
public class IndexChartService {

	@Autowired
	private CcmEventAmbiDao ccmEventAmbiDao;
	@Autowired
	private VCcmTeamDao vCcmTeamDao;
	@Autowired
	private CcmOrgNpseDao ccmOrgNpseDao;
	@Autowired
	private CcmEventIncidentDao ccmEventIncidentDao;
	@Autowired
	private CcmLineProtectDao ccmLineProtectDao;
	@Autowired
	private CcmPeopleDao ccmPeopleDao;
	@Autowired
	private CcmPopTenantDao ccmPopTenantDao;
	@Autowired
	private CcmHouseBuildmanageDao buildmanageDao;
	@Autowired
	private CcmHouseSchoolrimDao ccmHouseSchoolrimDao;
	@Autowired
	private CcmRoadAddressDao ccmRoadAddressDao;
	@Autowired
	private CcmBasePlaceDao ccmBasePlaceDao;

	public List<EchartType> oneYearSolveEvent() {
		CcmEventAmbi ccmEventAmbi = new CcmEventAmbi();
		Calendar dateCalendar = Calendar.getInstance();
		dateCalendar.set(dateCalendar.get(Calendar.YEAR) - 1, dateCalendar.get(Calendar.MONTH) + 1, 1, 0, 0, 0);
		ccmEventAmbi.setBeginSendDate(dateCalendar.getTime());
		dateCalendar.add(Calendar.YEAR, 1);
		dateCalendar.add(Calendar.SECOND, -1);
		ccmEventAmbi.setEndSendDate(dateCalendar.getTime());
		List<EchartType> list = ccmEventAmbiDao.stateEventOneYear(ccmEventAmbi);
		List<EchartType> result = Lists.newArrayList();
		dateCalendar.setTime(ccmEventAmbi.getBeginSendDate());
		int count = 0;
		boolean flag = true;
		for (int i = 0; i < 12; i++) {
			StringBuffer t = new StringBuffer();
			t.append(dateCalendar.get(Calendar.YEAR));
			t.append("-");
			t.append(dateCalendar.get(Calendar.MONTH) + 1);
			dateCalendar.add(Calendar.MONTH, 1);
			if (flag && t.toString().equals(list.get(count).getType())) {
				result.add(list.get(count));
				if (count == list.size() - 1) {
					flag = false;
				}
				count++;
			} else {
				EchartType e = new EchartType();
				e.setType(t.toString());
				e.setValue("0");
				e.setValue1("0");
				result.add(e);
			}
		}
		return result;
	}

	public LayUIBean indexChartService() {
		LayUIBean result = new LayUIBean();
		List<CcmEventAmbi> list = ccmEventAmbiDao.findCountByStatus();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findOfficeCount() {
		LayUIBean result = new LayUIBean();
		List<CcmEventAmbi> list = ccmEventAmbiDao.findOfficeCount();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findTeamCount() {
		LayUIBean result = new LayUIBean();
		List<VCcmTeam> list = vCcmTeamDao.findTeamCount();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountByCompType() {
		LayUIBean result = new LayUIBean();
		List<CcmOrgNpse> list = ccmOrgNpseDao.findCountByCompType();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountLineProtect() {
		LayUIBean result = new LayUIBean();
		List<CcmEventIncident> list = ccmEventIncidentDao.findCountLineProtect();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountLine() {
		LayUIBean result = new LayUIBean();
		List<CcmLineProtect> list = ccmLineProtectDao.findCountLine();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountSchoolPeople() {
		LayUIBean result = new LayUIBean();
		List<CcmEventIncident> list = ccmEventIncidentDao.findCountSchoolPeople();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountSchool() {
		LayUIBean result = new LayUIBean();
		List<CcmHouseSchoolrim> list = ccmHouseSchoolrimDao.findList(new CcmHouseSchoolrim());
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountPeopleForType() {
		LayUIBean result = new LayUIBean();
		List<CcmPeople> list = ccmPeopleDao.findCountPeopleForType();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountByType() {
		LayUIBean result = new LayUIBean();
		List<CcmPeople> list = ccmPeopleDao.findCountByType();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountByUniformlogo() {
		LayUIBean result = new LayUIBean();
		List<CcmPeople> list = ccmPeopleDao.findCountByUniformlogo();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountByHouseType() {
		LayUIBean result = new LayUIBean();
		List<CcmPopTenant> list = ccmPopTenantDao.findCountByHouseType();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountByRentPur() {
		LayUIBean result = new LayUIBean();
		List<CcmPopTenant> list = ccmPopTenantDao.findCountByRentPur();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findCountAddressLibrary() {
		LayUIBean result = new LayUIBean();
		List<CcmHouseBuildmanage> list = buildmanageDao.findCountAddressLibrary();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

/*	public LayUIBean findCountByHousePrup() {
		LayUIBean result = new LayUIBean();
		List<CcmPopTenant> list = ccmPopTenantDao.findCountByHousePrup();
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}*/

	public LayUIBean findCountByconstruction() {
		LayUIBean result = new LayUIBean();
		List<CcmHouseBuildmanage> list = buildmanageDao.findCountAddressLibrary();
		result.setCode("0");
		for (CcmHouseBuildmanage ccmHouseBuildmanage : list) {
			if("buildmanage".equals(ccmHouseBuildmanage.getName())) {
				result.setCount(Integer.parseInt(ccmHouseBuildmanage.getCount()));
			}
		}
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean streetRoadLane() {
		LayUIBean result = new LayUIBean();
		List<CcmRoadAddress> list = ccmRoadAddressDao.findList(new CcmRoadAddress());
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

	public LayUIBean findKeyPlace() {
		LayUIBean result = new LayUIBean();
		List<CcmBasePlace> list = ccmBasePlaceDao.findList(new CcmBasePlace());
		result.setCode("0");
		result.setCount(list.size());
		result.setData(list);
		result.setMsg("");
		return result;
	}

}
