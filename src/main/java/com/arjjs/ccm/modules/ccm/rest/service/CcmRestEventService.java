package com.arjjs.ccm.modules.ccm.rest.service;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.modules.ccm.rest.web.CcmRestEvent;
import com.arjjs.ccm.tool.OrderRabbitMQInfo;
import com.arjjs.ccm.tool.RabbitMQTools;
import com.arjjs.ccm.tool.Result;
import com.rabbitmq.client.Channel;

import net.sf.json.JSONObject;

@Service
@Transactional(readOnly = true)
public class CcmRestEventService {

	/**
	 * @方法描述：初始化往设备Map中加入clientId
	 */
	public Result orderRabbitMQInfo(String json) {
		try {
			json = java.net.URLDecoder.decode(json, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		Result result = new Result();
		OrderRabbitMQInfo orderRabbitMQInfo = new OrderRabbitMQInfo();
		JSONObject jsonObject = JSONObject.fromObject(json);
		if (null != jsonObject) {
			String clientId = null;
			String userId = null;
			if (jsonObject.containsKey("clientId")) {
				clientId = jsonObject.getString("clientId");
				orderRabbitMQInfo.setClientId(clientId);
			}
			if (jsonObject.containsKey("userId")) {
				userId = jsonObject.getString("userId");
				orderRabbitMQInfo.setUserId(userId);
			}
			orderRabbitMQInfo.setHeartBeatTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
			RabbitMQTools.orderRabbitMQInfoMap.put(clientId, orderRabbitMQInfo);
			result.setRet("0");
			return result;
		}
		result.setRet("-1");
		result.setContent("参数错误");
		return result;
	}

	/**
	 * @方法描述：关闭或者跳转页面时从设备Map中移除clientId
	 */
	public Result cancelOrderRabbitMQInfo(String clientId) {
		Result result = new Result();
		if (null != RabbitMQTools.orderRabbitMQInfoMap && RabbitMQTools.orderRabbitMQInfoMap.size() > 0
				&& StringUtils.isNotBlank(clientId)) {
			if (RabbitMQTools.orderRabbitMQInfoMap.containsKey(clientId)) {
				Channel channel = RabbitMQTools.orderRabbitMQInfoMap.get(clientId).getChannel();
				try {
					if (channel != null) {
						channel.close();
					}
				} catch (Exception e) {
					System.out.println("关闭rabbitMQ通道失败!");
					e.printStackTrace();
				}
				RabbitMQTools.orderRabbitMQInfoMap.remove(clientId);
				result.setRet("0");
				return result;
			}
		}
		result.setRet("-1");
		result.setContent("参数错误");
		return result;
	}

	/**
	 * @方法描述：设备Map心跳
	 */
	public Result sendHeartBeat(String json) {
		try {
			json = java.net.URLDecoder.decode(json, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		Result result = new Result();
		JSONObject jsonObject = JSONObject.fromObject(json);
		if (null != jsonObject) {
			String clientId = null;
			if (jsonObject.containsKey("clientId")) {
				clientId = jsonObject.getString("clientId");
			}
			if (null != RabbitMQTools.orderRabbitMQInfoMap && RabbitMQTools.orderRabbitMQInfoMap.size() > 0) {
				if (RabbitMQTools.orderRabbitMQInfoMap.containsKey(clientId)) {
					RabbitMQTools.orderRabbitMQInfoMap.get(clientId)
							.setHeartBeatTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

					try {
						CcmRestEvent.updateMqDate(clientId);
					} catch (Exception e) {
						e.printStackTrace();
					}

					result.setRet("0");
					return result;
				} else {
					result = orderRabbitMQInfo(json);// 如果不存在该clientId,就订阅
				}
			} else {
				result = orderRabbitMQInfo(json);// 如果不存在该clientId,就订阅
			}
			return result;
		}
		result.setRet("-1");
		result.setContent("参数错误");
		return result;
	}

	/**
	 * @方法描述：添加订阅的设备
	 */
	public Result addOrderDevice(String json) {
		try {
			json = java.net.URLDecoder.decode(json, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		Result result = new Result();
		JSONObject jsonObject = JSONObject.fromObject(json);
		if (null != jsonObject) {
			String clientId = null;
			if (jsonObject.containsKey("clientId")) {
				clientId = jsonObject.getString("clientId");
			}
			if (null != RabbitMQTools.orderRabbitMQInfoMap && RabbitMQTools.orderRabbitMQInfoMap.size() > 0) {
				if (RabbitMQTools.orderRabbitMQInfoMap.containsKey(clientId)) {
					result.setRet("0");
					return result;
				}
			}
		}
		result.setRet("-1");
		result.setContent("参数错误");
		return result;
	}

	/**
	 * @方法描述：移除订阅的设备
	 */
	public Result removeOrderDevice(String json) {
		try {
			json = java.net.URLDecoder.decode(json, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		Result result = new Result();
		JSONObject jsonObject = JSONObject.fromObject(json);
		if (null != jsonObject) {
			String clientId = null;
			if (jsonObject.containsKey("clientId")) {
				clientId = jsonObject.getString("clientId");
			}
			if (null != RabbitMQTools.orderRabbitMQInfoMap && RabbitMQTools.orderRabbitMQInfoMap.size() > 0) {
				if (RabbitMQTools.orderRabbitMQInfoMap.containsKey(clientId)) {
					result.setRet("0");
					return result;
				}
			}
		}
		result.setRet("-1");
		result.setContent("参数错误");
		return result;
	}

}
