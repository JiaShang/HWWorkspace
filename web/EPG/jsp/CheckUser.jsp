<%@ page contentType="text/html; charset=GBK" language="java" pageEncoding="GBK" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelpHWCTC" %>
<%@ page import="com.huawei.iptvmw.epg.bean.info.UserProfile" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGConstants"%>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
<title>��¼��Ȩ��֤ҳ��</title>
<%@ include file="common4dtv/jsp/config.jsp" %>
<%
	//	  ��Ȩ����Ϊ����STB�����󣬻�������֤һ�������Ƿ���ڣ�������ڣ�����֤����Ҫ�Ĳ�����װ����һ������EPG��
	//    			EPG�õ���һ�ε������ֻ��Ҫ����һ�����ӳɹ�������Ҫ���κ�ҵ�������ڶ�����ʽ����ʱ��EPG����
	//				ҵ���߼���
	//				�����õ�������Ҫ�Ĳ����������Ǻ��ּ�Ȩ��ʽ����ֱ�ӵ��ýӿڽ��м�Ȩ�����ݷ������ж��Ƿ��¼�ɹ���
	//				����ɹ�����ֱ����ת����ҳ�棻������ɹ�������Ҫ���ýӿ�getAuthStyle()������ȷ���Ǻ��ֵ�¼��ʽ
	//				�������ֵΪ1���������û��������¼����ʱ��Ҫ��ת����¼ҳ�棨login.jsp�������û������û���������
	//				�������ֵΪ2��������ic����¼����Ҫ��ʾ�û������Ŀ�δע��
	//				�������ֵΪ3��������mac��ַ��¼����Ҫ��ʾ�û���mac��ַδע��

	try 
	{
		// Client�жϣ������жϻ�����Client�汾�Ƿ�Ϊ3.0(�°汾)�����Ϊ�°汾���ǻ�ȡ����isNewClient����ֵӦ��Ϊ1��
		// ���isNewClientֵΪ1��������תҳ��transparency��������Ȩ��������ƴ�ӣ�Ȼ���ٷ��ص���ҳ����Ȩ��
		// ���isNewClientֵ��Ϊ1��ֱ�ӽ�����Ȩ����
		String vrn = request.getParameter("isNewClient");
		
		// �洢isNewClient����,�����û���Ȩʱ�İ汾�ж�
		if ((vrn != null) && ("1".equalsIgnoreCase(vrn)))
		{
			session.setAttribute("isNewVersion", "1");
			
			// ���Client�汾Ϊ3.0����transparency.jsp���в���ƴ�Ӳ���
			String transparency = request.getContextPath() + "/jsp/transparency.jsp";
%>
<jsp:forward page="<%= transparency%>" />
<%
		}
		else
		{
			session.setAttribute("isNewVersion", "0");
		}
		// Client�жϽ���������Ϊ������Ȩ�����̲���
		
		// �û����� 
		String pwd = request.getParameter("pwd");
		pwd = (null == pwd) ? "" : pwd.trim();
	
		// �û��ʺ�
		String userId = request.getParameter("User");
		userId = (null == userId) ? "" : userId.trim();
		userId="";
		
		// ������MAC��ַ
		String NTID = request.getParameter("NTID");
		NTID = (null == NTID) ? "" : NTID.trim();
		
		// IC����
		String icID = request.getParameter("CARDID");
		icID = (null == icID) ? "" : icID.trim();
		session.setAttribute(EPGConstants.KEY_AUTHICCARD, icID);
		
		// ������IP��ַ
		String stbip = request.getParameter("ip");
		stbip = (null == stbip) ? "" : stbip.trim();
		
		// ����������
		String lang = request.getParameter("lang");
		lang = (null == lang) ? "" : lang.trim();
		
		// �����а汾��
		String clientVersion = request.getParameter("Version");
		clientVersion = (null == clientVersion) ? "" : clientVersion.trim();
		
		// ������֧�ֵ���������
		String supportnet = request.getParameter("supportnet");
		supportnet = (null == supportnet) ? "" : supportnet.trim();
		
		// ������֧�ֵ�ý���ʽ
		String decodemode = request.getParameter("decodemode");
		decodemode = (null == decodemode) ? DEFAULT_RECORDFORMAT : decodemode.trim();
		session.setAttribute("decodemode", decodemode);
		
		// serviceGroupID
		String serviceGroupId = request.getParameter("ServiceGroupID");
		serviceGroupId = (null == serviceGroupId) ? "" : serviceGroupId.trim();
		serviceGroupId = ("".equals(serviceGroupId)) ? DEFAULT_SERVICE_GROUPID : serviceGroupId;
		session.setAttribute("serviceGroupId", serviceGroupId);
		
		// ���뷽ʽ
		String  connType = request.getParameter("connType");
		connType = (null == connType) ? "" : connType.trim();
		connType = ("".equals(connType)) ? DEFAULT_CONNTYPE : connType;
		
		// �����Ƿ����
		String encrypt = request.getParameter("encrypt");
		encrypt = (null == encrypt) ? "" : encrypt.trim();
		encrypt = ("".equals(encrypt)) ? DEFAULT_ENCRYPT : encrypt;
		
		session.setAttribute(EPGConstants.KEY_VERSIONTYPE,new Integer(EPGConstants.HWCTC_VERSION));
		
		// ����epg��ת·��
  	String forwardURL = "";
  	
		// ��Ȩ���ز���
		HashMap map = null;
		
		// �û���¼����
	  Map vo = new HashMap();
	
		// ����huawei��¼��Ȩ�ӿڣ����е�¼��Ȩ��֤
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
		
		// ����ķ���ֵ
		int retcode = ((Integer) map.get("RETCODE")).intValue();

		// ��������Ϊ0ʱ�������¼�ɹ�������������һ����Ϊ�ǵ�¼���ɹ������Ծ��巵������Ч��
		// ��֤�ɹ�
		
		if (retcode == 0) 
		{
			UserProfile userPro = new UserProfile(request);
			
			// ��UserProfileȡuserId
			userId = (String) userPro.getUserId();
			
			// ȡ�����е�ַ
			NTID = userPro.getStbId();
			
			// ��ȡ�û�ģ��
			String templateNameReal = userPro.getTemplate();
			
			// ���ģ��Ϊ�գ���Ĭ�ϵı���ģ��
			templateNameReal = (null == templateNameReal) ? "" : templateNameReal.trim();
			templateNameReal = ("".equals(templateNameReal.trim())) ? DEFAULT_TEMPLATE_NAME : templateNameReal.trim();
			request.getSession().setAttribute("userTemplate",templateNameReal);
			userPro.setTemplate(templateNameReal);
			userPro.setSTBMAC(NTID);

			/** Ŀǰ�ݲ������λ�ȡ���ԣ��˴�����Ϊ�������Լ��ϱ�������Ϣ **/
			/** ������lang��ֵΪ1ʱ��ʾΪ��һ���֣�ֵΪ2ʱ��ʾΪ�ڶ����� **/
			String language = DEFAULT_LANGUAGE;
			
			if ("1".equals(lang)) 
			{
				language = MODULE_LANGUAGES[0];
			}
			else if ("2".equals(lang)) 
			{
				language = MODULE_LANGUAGES[1];
			}
			
			// ����ģ�����ƺ�����ƴ��·��ͷ��
			String templateHead = request.getContextPath() + "/jsp/" + templateNameReal + "/" + language + "/";
			
			// ��������Ŀ�ַ�ҳ��
			String dispatcher = request.getContextPath() + "/jsp/common4dtv/jsp/dispatcher.jsp";
			
			// ����contentId�ж�ֱ�ӽ���ҳ���ǽ���Ŀ
			String contentId = (String) request.getParameter("contentId");
			forwardURL = (null == contentId) ? templateHead + EPG_CATEGORY : dispatcher + "?contentId=" + contentId;
			
			// ʹ��vo��װ����
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

			// ����Ȩͨ���ķ�����Ϣ���浽SESSION
			session.setAttribute("loginVo", vo);
			session.setAttribute("ntvuseraccount", userId);
		  session.setAttribute("ntvuserpassword", pwd);
		  session.setAttribute("templateName", templateNameReal);
			session.setAttribute("isNewVersion", vrn);
			
			// ƴ��httpͷ
			String httpHead = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
			String hwhomeurl = httpHead + templateHead + EPG_CATEGORY 
				+ "?bottomPoster=bottomPoster&rightPoster=rightPoster&fromplace=huashu";	

    	// ���ػ�Ϊ��ҳ
    	hwhomeurl = URLEncoder.encode(hwhomeurl, "UTF-8");

    	// ��ȡ��Ϊ������Դҳ�棬���봫������EPG
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
			
		  // д�������ڴ���Ϊ�˱��浱�û�������ʱʱ��ϵͳ�Զ���¼����Ҫ�Ĳ���
			// ��IE��¼��ʱ����
			iPanel.ioctlWrite("NTID", "<%= NTID%>");
			iPanel.ioctlWrite("ICID", "<%= icID%>");
			iPanel.ioctlWrite("IP", "<%= stbip%>");
			iPanel.ioctlWrite("Version", "<%= clientVersion%>");
			iPanel.ioctlWrite("supportnet", "<%= supportnet%>");
			iPanel.ioctlWrite("decodemode", "<%= decodemode%>");
			iPanel.ioctlWrite("connType", "<%= connType%>");
			iPanel.ioctlWrite("sessionid", "<%= session.getId()%>");
			
			// д�û���֤ͨ����־
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
	    	// ��¼ʧ�ܱ��������Ϊ�˱��浱��¼��ʽΪ�û������뷽ʽʱ��������������Ҫ�Ĳ���
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
		  	
		  	// ��֤���ͣ�1 user/pass��2 IC��3 MAC
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
		String resolve = URLEncoder.encode("���������������л��߲������ǵĿͷ��绰Ѱ�����", "UTF-8");
		String desc = URLEncoder.encode("����", "UTF-8");
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