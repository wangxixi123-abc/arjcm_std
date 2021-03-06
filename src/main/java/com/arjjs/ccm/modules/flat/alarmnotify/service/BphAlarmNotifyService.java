/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.flat.alarmnotify.service;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.flat.alarmnotify.dao.BphAlarmNotifyDao;
import com.arjjs.ccm.modules.flat.alarmnotify.entity.BphAlarmNotify;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 警情通知记录Service
 * @author maoxb
 * @version 2019-05-05
 */
@Service
@Transactional(readOnly = true)
public class BphAlarmNotifyService extends CrudService<BphAlarmNotifyDao, BphAlarmNotify> {


	
	public BphAlarmNotify get(String id) {
		return super.get(id);
	}
	
	public List<BphAlarmNotify> findList(BphAlarmNotify bphAlarmNotify) {
		return super.findList(bphAlarmNotify);
	}
	
	public Page<BphAlarmNotify> findPage(Page<BphAlarmNotify> page, BphAlarmNotify bphAlarmNotify) {
		Page<BphAlarmNotify> findPage = super.findPage(page, bphAlarmNotify);
		return findPage;
	}
	
	@Transactional(readOnly = false)
	public void save(BphAlarmNotify bphAlarmNotify) {
		super.save(bphAlarmNotify);
	}
	
	@Transactional(readOnly = false)
	public void delete(BphAlarmNotify bphAlarmNotify) {
		super.delete(bphAlarmNotify);
	}
	
}