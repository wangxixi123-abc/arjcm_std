package com.arjjs.ccm.modules.ccm.house.web;

import com.arjjs.ccm.common.config.Global;
import com.arjjs.ccm.common.utils.StringUtils;
import com.arjjs.ccm.common.web.BaseController;
import com.arjjs.ccm.modules.ccm.org.entity.SysArea;
import com.arjjs.ccm.modules.ccm.org.service.SysAreaService;
import com.arjjs.ccm.modules.ccm.pop.entity.CcmPeople;
import com.arjjs.ccm.modules.ccm.pop.service.CcmPeopleService;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestResult;
import com.arjjs.ccm.modules.ccm.rest.entity.CcmRestType;
import com.arjjs.ccm.modules.ccm.rest.web.CcmRestEvent;
import com.arjjs.ccm.modules.pbs.sys.utils.UserUtils;
import com.arjjs.ccm.modules.sys.entity.User;
import com.arjjs.ccm.tool.*;
import com.rabbitmq.client.Channel;
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

import javax.jms.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
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
@RequestMapping(value = "${adminPath}/house/ccmHouseRmqController")
public class CcmHouseRmqController extends BaseController {

    @Autowired
    private CcmPeopleService ccmPeopleService;
	@Autowired
	private SysAreaService sysAreaService;

	private static ConnectionFactory connectionFactory = null;
	private static Connection connection = null;
	private static Topic topic = null;
	private static Session session = null;
	private static boolean JMSStatus = false;
	private static Map<String, String> uuidList = new ConcurrentHashMap<String, String>();

	private static MessageProducer producer = null;

	/**
	 * @see 订阅消息中间件
	 * @param uuid
	 * @return
	 * @author pengjianqiang
	 * @version 2018-02-24
	 */
	@ResponseBody
	@RequestMapping(value = "/subscribeAmq", method = RequestMethod.GET)
	public CcmRestResult subscribeAmq(String uuid) {
		CcmRestResult result = new CcmRestResult();
		if (uuid == null || "".equals(uuid)) {
			UUID id = UUID.randomUUID();
			SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = new Date();
			uuidList.put(id.toString(), formatDate.format(date));
			result.setCode(CcmRestType.OK);
			result.setResult(id.toString());
		}
		return result;
	}


	@RequestMapping(value = "form")
	public String form(CcmPeople ccmPeople, HttpServletRequest request, HttpServletResponse response, Model model) {
        ccmPeople = ccmPeopleService.get(ccmPeople.getId());
        model.addAttribute("ccmPeople", ccmPeople);
		return "ccm/house/ccmHouseRmqForm";
	}

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


	/**
	 * 方法说明：清除超时的客户端
	 *
	 * @return
	 * @author pengjianqiang
	 * @version 2018-02-24
	 */
	public static void clearTimeoutClient() throws Exception {
//		 System.out.println("清除超时的客户端");
		for (Entry<String, String> entry : uuidList.entrySet()) {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = new Date();
			Date heartBeatTime = format.parse(entry.getValue());
			if ((now.getTime() - heartBeatTime.getTime()) > 1000 * 60 * 2) {// 超时超过2分钟
				uuidList.remove(entry.getKey());
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
	 * @throws IOException
	 * @方法描述：订阅rabbitMQ
	 */
	@RequestMapping(value = "orderRabbitMQInfo")
	public void orderRabbitMQInfo(HttpServletRequest req, HttpServletResponse resp, String json) throws IOException {
		resp.getWriter().print(JSONObject.fromObject(orderRabbitMQInfo(json)));

	}

	/**
	 * @throws IOException
	 * @方法描述：取消订阅rabbitMQ
	 */
	@RequestMapping(value = "cancelOrderRabbitMQInfo")
	public void cancelOrderRabbitMQInfo(HttpServletRequest req, HttpServletResponse resp, String clientId)
			throws IOException {
		resp.getWriter().print(JSONObject.fromObject(cancelOrderRabbitMQInfo(clientId)));
	}

	/**
	 * @throws IOException
	 * @方法描述：心跳
	 */
	@RequestMapping(value = "sendFenceHeartBeat")
	public void sendFenceHeartBeat(HttpServletRequest req, HttpServletResponse resp, String json) throws IOException {
		resp.getWriter().print(JSONObject.fromObject(sendHeartBeat(json)));
	}
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

	public static void commonsendMessage(Object obj){
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
			for (Map.Entry<String, String> key : uuidList.entrySet()) {
				if (key.getKey().equals(entry.getKey())) {
					RabbitMQTools.sendMessage(entry.getKey(),
							JSONObject.fromObject(obj, jsonConfig).toString());
				}
			}
		}
	}

	@ResponseBody
	@RequestMapping(value = "/getRmqUrl")
	public String getRmqUrl(String uuid) {
		return  RabbitMQTools.getRmqUrl();
	}

	@ResponseBody
	@RequestMapping(value = "/judgeUserAreaPermission")
	public boolean judgeUserAreaPermission(String areaGridId) {
		SysArea sysArea = sysAreaService.get(areaGridId);
		List parentIds = Arrays.asList(sysArea.getParentIds().split(","));
		User user = ccmPeopleService.judgeUserAreaPermission(UserUtils.getUser().getId(),areaGridId,parentIds);
//		CcmEventIncident ccmEventIncident = ccmEventIncidentService.judgeUserAreaPermission(id);
		if(user!=null){
			return true;
		}
		return false;
	}
}