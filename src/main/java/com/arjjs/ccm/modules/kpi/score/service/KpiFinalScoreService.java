/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.kpi.score.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.persistence.Page;
import com.arjjs.ccm.common.service.CrudService;
import com.arjjs.ccm.modules.kpi.score.entity.KpiFinalScore;
import com.arjjs.ccm.modules.kpi.scheme.entity.KpiScheme;
import com.arjjs.ccm.modules.kpi.score.dao.KpiFinalScoreDao;

/**
 * 绩效总成绩Service
 * @author pjq
 * @version 2018-04-11
 */
@Service
@Transactional(readOnly = true)
public class KpiFinalScoreService extends CrudService<KpiFinalScoreDao, KpiFinalScore> {

	@Autowired
	private KpiFinalScoreDao kpiFinalScoreDao;

	public KpiFinalScore get(String id) {
		return super.get(id);
	}
	
	public List<KpiFinalScore> findList(KpiFinalScore kpiFinalScore) {
		return super.findList(kpiFinalScore);
	}
	
	public Page<KpiFinalScore> findPage(Page<KpiFinalScore> page, KpiFinalScore kpiFinalScore) {
		return super.findPage(page, kpiFinalScore);
	}

	// 查询方案
	public List<KpiScheme> findKpiScheme(KpiFinalScore kpiFinalScore) {
		List<KpiScheme> kpiList = kpiFinalScoreDao.findKpiScheme(kpiFinalScore);
		
		return kpiList;
	}

	// 查询表格的数据
	public Page<KpiFinalScore> findScoreList(Page<KpiFinalScore> page, KpiFinalScore kpiFinalScore) {
		kpiFinalScore.setPage(page);
		
		List resultList = new ArrayList();
		List<KpiFinalScore> finalScoreUserLst = kpiFinalScoreDao.getFinalScoreUser(kpiFinalScore); //根据查询条件查询所有的人员信息
		
		
		for (int i = 0; i < finalScoreUserLst.size(); i++) {
			try {
				KpiFinalScore finalScoreUser = finalScoreUserLst.get(i);
				List<KpiFinalScore> kpiFinalScoreLst = kpiFinalScoreDao.findList(finalScoreUser);
				List<String> score = new ArrayList<String>();
				if (kpiFinalScoreLst == null || kpiFinalScoreLst.size() <= 0) {
					finalScoreUser.setFinalScore(new Double("0"));
					finalScoreUser.setJournalScore(new Double("0"));
					for (int j = 0; j < kpiFinalScore.getKpiList().size(); j++) {
						score.add("未评分");
					}
				} else {
					boolean isuse = false;
					for(int k = 0; k < kpiFinalScore.getKpiList().size(); k++) {
						boolean isgive = false;
						for (int j = 0; j < kpiFinalScoreLst.size(); j++) {
							KpiFinalScore scoreBean = kpiFinalScoreLst.get(j);
							if ("0".equals(scoreBean.getKpiId()) && isuse!=true) {
								finalScoreUser.setFinalScore(scoreBean.getFinalScore());
								finalScoreUser.setJournalScore(scoreBean.getJournalScore());
								isuse = true;
							} else {
								if(kpiFinalScore.getKpiList().get(k).getId().equals(scoreBean.getKpiId())) {
									score.add(String.valueOf(scoreBean.getFinalScore()));
									isgive = true;
								}
							}
						}
						if(isgive!=true) {
							score.add("未评分");
						}
					}
				}
				finalScoreUser.setScoreList(score);
				resultList.add(finalScoreUser);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		page.setList(resultList);
		return page;
	}
	
	@Transactional(readOnly = false)
	public void save(KpiFinalScore kpiFinalScore) {
		super.save(kpiFinalScore);
	}
	
	@Transactional(readOnly = false)
	public void delete(KpiFinalScore kpiFinalScore) {
		super.delete(kpiFinalScore);
	}

	//添加绩效总得分，相对应的方案,各个kpi
	public List<KpiFinalScore> findSumAll(KpiFinalScore kpiFinalScore) {
		return kpiFinalScoreDao.findSumAll(kpiFinalScore);
	}

	//添加绩效总得分，相对应的方案,总绩效
	public List<KpiFinalScore> findSum(KpiFinalScore kpiFinalScore) {
		return kpiFinalScoreDao.findSum(kpiFinalScore);
	}
	
}