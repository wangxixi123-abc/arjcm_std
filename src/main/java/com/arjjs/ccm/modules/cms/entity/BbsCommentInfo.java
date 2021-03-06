/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.arjjs.ccm.modules.cms.entity;

import java.util.Date;

/**
 * 网上论坛一级评论Entity
 * @author maoxb
 * @version 2019-08-01
 */
public class BbsCommentInfo  {

	private String comId;		// 评论ID
	private String comContent;		// 评论内容
	private String articleId;		// 文章id
	private String fontUserId;		// 评论用户的id
	private String name;		// 评论用户的名称
	private String photo;		// 评论用户的头像
	private Date comTime;		// 评论时间

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getComId() {
		return comId;
	}

	public void setComId(String comId) {
		this.comId = comId;
	}

	public String getComContent() {
		return comContent;
	}

	public void setComContent(String comContent) {
		this.comContent = comContent;
	}

	public String getArticleId() {
		return articleId;
	}

	public void setArticleId(String articleId) {
		this.articleId = articleId;
	}

	public String getFontUserId() {
		return fontUserId;
	}

	public void setFontUserId(String fontUserId) {
		this.fontUserId = fontUserId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getComTime() {
		return comTime;
	}

	public void setComTime(Date comTime) {
		this.comTime = comTime;
	}
}