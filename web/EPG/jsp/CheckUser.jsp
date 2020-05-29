<%@ page contentType="text/html; charset=GBK" language="java" pageEncoding="GBK" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelpHWCTC" %>
<%@ page import="com.huawei.iptvmw.epg.bean.info.UserProfile" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGConstants"%>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
<title>登录授权认证页面</title>
<%@ include file="common4dtv/jsp/config.jsp" %>
<%
	//	  鉴权流程为：当STB启动后，会首先验证一次链接是否存在，如果存在，则将验证所需要的参数组装后，再一次请求EPG；
	//    			EPG得到第一次的请求后，只需要返回一个链接成功，不需要做任何业务处理；当第二次正式请求时，EPG进入
	//				业务逻辑；
	//				首先拿到所有需要的参数，不管是何种鉴权方式，都直接调用接口进行鉴权，根据返回码判断是否登录成功，
	//				如果成功，则直接跳转到主页面；如果不成功，则需要调用接口getAuthStyle()方法来确定是何种登录方式
	//				如果返回值为1，代表是用户名密码登录，这时需要跳转到登录页面（login.jsp），让用户输入用户名和密码
	//				如果返回值为2，代表是ic卡登录，需要提示用户：您的卡未注册
	//				如果返回值为3，代表是mac地址登录，需要提示用户：mac地址未注册

	try 
	{
		// Client判断：首先判断机顶盒Client版本是否为3.0(新版本)；如果为新版本我们获取到的isNewClient参数值应该为1；
		// 如果isNewClient值为1：进入中转页面transparency，进行授权参数进行拼接，然后再返回到该页面授权；
		// 如果isNewClient值不为1：直接进行授权操作
		String vrn = request.getParameter("isNewClient");
		
		// 存储isNewClient参数,用于用户授权时的版本判断
		if ((vrn != null) && ("1".equalsIgnoreCase(vrn)))
		{
			session.setAttribute("isNewVersion", "1");
			
			// 如果Client版本为3.0，到transparency.jsp进行参数拼接操作
			String transparency = request.getContextPath() + "/jsp/transparency.jsp";
%>
<jsp:forward page="<%= transparency%>" />
<%
		}
		else
		{
			session.setAttribute("isNewVersion", "0");
		}
		// Client判断结束，以下为正常的权鉴流程操作
		
		// 用户密码 
		String pwd = request.getParameter("pwd");
		pwd = (null == pwd) ? "" : pwd.trim();
	
		// 用户帐号
		String userId = request.getParameter("User");
		userId = (null == userId) ? "" : userId.trim();
		userId="";
		
		// 机顶盒MAC地址
		String NTID = request.getParameter("NTID");
		NTID = (null == NTID) ? "" : NTID.trim();
		
		// IC卡号
		String icID = request.getParameter("CARDID");
		icID = (null == icID) ? "" : icID.trim();
		session.setAttribute(EPGConstants.KEY_AUTHICCARD, icID);
		
		// 机顶盒IP地址
		String stbip = request.getParameter("ip");
		stbip = (null == stbip) ? "" : stbip.trim();
		
		// 机顶盒语种
		String lang = request.getParameter("lang");
		lang = (null == lang) ? "" : lang.trim();
		
		// 机顶盒版本号
		String clientVersion = request.getParameter("Version");
		clientVersion = (null == clientVersion) ? "" : clientVersion.trim();
		
		// 机顶盒支持的网络能力
		String supportnet = request.getParameter("supportnet");
		supportnet = (null == supportnet) ? "" : supportnet.trim();
		
		// 机顶盒支持的媒体格式
		String decodemode = request.getParameter("decodemode");
		decodemode = (null == decodemode) ? DEFAULT_RECORDFORMAT : decodemode.trim();
		session.setAttribute("decodemode", decodemode);
		
		// serviceGroupID
		String serviceGroupId = request.getParameter("ServiceGroupID");
		serviceGroupId = (null == serviceGroupId) ? "" : serviceGroupId.trim();
		serviceGroupId = ("".equals(serviceGroupId)) ? DEFAULT_SERVICE_GROUPID : serviceGroupId;
		session.setAttribute("serviceGroupId", serviceGroupId);
		
		// 接入方式
		String  connType = request.getParameter("connType");
		connType = (null == connType) ? "" : connType.trim();
		connType = ("".equals(connType)) ? DEFAULT_CONNTYPE : connType;
		
		// 密码是否加密
		String encrypt = request.getParameter("encrypt");
		encrypt = (null == encrypt) ? "" : encrypt.trim();
		encrypt = ("".equals(encrypt)) ? DEFAULT_ENCRYPT : encrypt;
		
		session.setAttribute(EPGConstants.KEY_VERSIONTYPE,new Integer(EPGConstants.HWCTC_VERSION));
		
		// 进入epg跳转路径
  	String forwardURL = "";
  	
		// 授权返回参数
		HashMap map = null;
		
		// 用户登录对象
	  Map vo = new HashMap();
	
		// 调用huawei登录授权接口，进行登录授权认证
		ServiceHelpHWCTC sh = new ServiceHelpHWCTC(request);
		if (supportnet.equals("Cable") || supportnet.equals("IP")
				|| supportnet.equals("Cable;IP")) 
		{	
			if (decodemode.indexOf("MPEG-2") != -1
					|| decodemode.indexOf("H.264") != -1) 
			{
			    map = sh.login4DTV(NTID, userId, pwd, stbip, 
					lang, icID, decodemode, supportnet, 
					encrypt, serviceGroupId, clientVersion);
			}
		}
		
		// 结果的返回值
		int retcode = ((Integer) map.get("RETCODE")).intValue();

		// 当返回码为0时，代表登录成功，其他返回码一律认为是登录不成功，不对具体返回码做效验
		// 验证成功
		
		if (retcode == 0) 
		{
			UserProfile userPro = new UserProfile(request);
			
			// 从UserProfile取userId
			userId = (String) userPro.getUserId();
			
			// 取机顶盒地址
			NTID = userPro.getStbId();
			
			// 获取用户模板
			String templateNameReal = userPro.getTemplate();
			
			// 如果模板为空，走默认的标清模板
			templateNameReal = (null == templateNameReal) ? "" : templateNameReal.trim();
			templateNameReal = ("".equals(templateNameReal.trim())) ? DEFAULT_TEMPLATE_NAME : templateNameReal.trim();
			request.getSession().setAttribute("userTemplate",templateNameReal);
			userPro.setTemplate(templateNameReal);
			userPro.setSTBMAC(NTID);

			/** 目前暂不清楚如何获取语言，此处假设为机顶盒自己上报语言信息 **/
			/** 参数：lang，值为1时表示为第一语种；值为2时表示为第二语种 **/
			String language = DEFAULT_LANGUAGE;
			
			if ("1".equals(lang)) 
			{
				language = MODULE_LANGUAGES[0];
			}
			else if ("2".equals(lang)) 
			{
				language = MODULE_LANGUAGES[1];
			}
			
			// 根据模板名称和语言拼接路径头部
			String templateHead = request.getContextPath() + "/jsp/" + templateNameReal + "/" + language + "/";
			
			// 开机进栏目分发页面
			String dispatcher = request.getContextPath() + "/jsp/common4dtv/jsp/dispatcher.jsp";
			
			// 根据contentId判断直接进首页还是进栏目
			String contentId = (String) request.getParameter("contentId");
			forwardURL = (null == contentId) ? templateHead + EPG_CATEGORY : dispatcher + "?contentId=" + contentId;
			
			// 使用vo封装对象
			vo.put("account", String.valueOf(map.get("ACCESS_ACCOUNT")));
			vo.put("connType", connType);
			vo.put("icID", icID);
			vo.put("ip", stbip);
			vo.put("netType", supportnet);
			vo.put("password", pwd);
			vo.put("retcode", String.valueOf(map.get("RETCODE")));
			vo.put("retMsg", String.valueOf(map.get("RETMSG")));
			vo.put("serviceGroupId", serviceGroupId);
			vo.put("stbMac", NTID);
			vo.put("strLang", lang);
			vo.put("supportFormat", decodemode);
			vo.put("userid", userId);
			vo.put("sessionid", session.getId());
			vo.put("userstatus", "1");
			vo.put("userToken", String.valueOf(map.get("USERTOKEN")));
			vo.put("version", clientVersion);
			vo.put("encrypt", encrypt);

			// 将授权通过的返回信息保存到SESSION
			session.setAttribute("loginVo", vo);
			session.setAttribute("ntvuseraccount", userId);
		  session.setAttribute("ntvuserpassword", pwd);
		  session.setAttribute("templateName", templateNameReal);
			session.setAttribute("isNewVersion", vrn);
			
			// 拼接http头
			String httpHead = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
			String hwhomeurl = httpHead + templateHead + EPG_CATEGORY 
				+ "?bottomPoster=bottomPoster&rightPoster=rightPoster&fromplace=huashu";	

    	// 返回华为首页
    	hwhomeurl = URLEncoder.encode(hwhomeurl, "UTF-8");

    	// 获取华为申请资源页面，编码传给华数EPG
    	String preplayurl = httpHead + templateHead + "preplayurl.jsp?"
             	+ "userid=" + userId + "&decodemode=" + decodemode + "&supportnet=" + supportnet
             	+ "&serviceGroupID=" + serviceGroupId + "&iccard=" + icID + "&token=" + String.valueOf(map.get("USERTOKEN"));
		  //System.out.println("----------preplayurl---------"+preplayurl);
    	preplayurl = URLEncoder.encode(preplayurl, "UTF-8");

    	session.setAttribute("hwhomeurl", hwhomeurl);
    	session.setAttribute("preplayurl", preplayurl);
    	session.setAttribute("stbid", stbip);
%>
		<script language="javascript" type="text/javascript">
			
		  // 写机顶盒内存是为了保存当用户操作超时时，系统自动登录所需要的参数
			// 用IE登录暂时屏蔽
			iPanel.ioctlWrite("NTID", "<%= NTID%>");
			iPanel.ioctlWrite("ICID", "<%= icID%>");
			iPanel.ioctlWrite("IP", "<%= stbip%>");
			iPanel.ioctlWrite("Version", "<%= clientVersion%>");
			iPanel.ioctlWrite("supportnet", "<%= supportnet%>");
			iPanel.ioctlWrite("decodemode", "<%= decodemode%>");
			iPanel.ioctlWrite("connType", "<%= connType%>");
			iPanel.ioctlWrite("sessionid", "<%= session.getId()%>");
			
			// 写用户认证通过标志
			iPanel.ioctlWrite("userstatus", "1");
			iPanel.ioctlWrite("ServiceGroupID", "<%= serviceGroupId%>");
			iPanel.ioctlWrite("usertoken", "<%= String.valueOf(map.get("USERTOKEN"))%>");
			iPanel.ioctlWrite("ntvuseraccount", "<%= userId%>");
			iPanel.ioctlWrite("ntvuserpassword", "<%= pwd%>");
	
			window.location.href = "<%= forwardURL%>";
			
		</script>
<%
		} 
		else 
		{
	    	// 登录失败保存参数是为了保存当登录方式为用户名密码方式时，重新请求所需要的参数
	    	vo.put("connType", connType);
		  	vo.put("icID", icID);
		  	vo.put("ip", stbip);
		  	vo.put("netType", supportnet);
		  	vo.put("serviceGroupId", serviceGroupId);
		  	vo.put("stbMac", NTID);
		  	vo.put("strLang", lang);
		  	vo.put("supportFormat", decodemode);
		  	vo.put("version", clientVersion);
		  	
		  	session.setAttribute("loginVo", vo);
		  	
		  	// 认证类型：1 user/pass，2 IC，3 MAC
		  	String errorType = sh.getAuthStyle();
				String errorURL_0 = request.getContextPath() 
				+ "/jsp/ShowError.jsp?retcode=" + retcode 
				+ "&errorType=" + errorType;
%>
<script language="javascript">
	window.location.href = "<%= errorURL_0%>";
</script>
<%
		}
	}
	catch (Exception e) 
	{
		String resolve = URLEncoder.encode("请重新启动机顶盒或者拨打我们的客服电话寻求帮助", "UTF-8");
		String desc = URLEncoder.encode("错误", "UTF-8");
		String errorURL_1 = request.getContextPath() 
			+ "/jsp/ShowError.jsp?desc="+desc+"&resolve="+resolve;
%>
<script language="javascript">
	window.location.href = "<%= errorURL_1%>";
</script>
<%
	}
%>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</html>