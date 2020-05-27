<%@page pageEncoding="GBK"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<html>
<head>
<meta name="history" content="no-history">
<!-- 
  影片、全屏片花、书签播放控制页面
-->
<%
	TurnPage turnPage = new TurnPage(request);
	turnPage.addUrl();
	String backUrl = turnPage.go(-1);
	
	
	
  String playurl = (String) request.getParameter("playUrl");
  String reporturl = (String) request.getParameter("reportUrl");
  String emm = (String) request.getParameter("emm");
  String comeType = (String) request.getParameter("comeType");
  String playtype = (String) request.getParameter("playtype");
  if(null != playurl)
 	{
 		playurl = URLDecoder.decode(playurl, "GBK");
 		playurl = URLDecoder.decode(playurl, "GBK");
 	}
 	if(null != reporturl)
 	{
 		reporturl = URLDecoder.decode(reporturl, "GBK");
 	}
 	
 		
 	/* 图文页面需要返回的参数  */
 	String tw_record_template = (String) request.getParameter("tw_record_template");
  String tw_record_flag = (String) request.getParameter("tw_record_flag");
  String tempurl = backUrl;
  
  if ("1".equals(tw_record_flag))
  {
    tempurl = tempurl.replace("/EPG/jsp/defaultHD/en/", "");
  	backUrl = request.getContextPath() + "/jsp/defaultHD/en/" + tempurl;  
  }else{
      tempurl = tempurl.replace("/EPG/jsp", "");
  }
%>
<script>
	iPanel.ioctlWrite("playinbrowser", 0);
	var playtype = <%=playtype%>;
	var comeType = <%=comeType%>;
	if(("<%=emm%>" != null)&&("<%= emm%>" != "null")&&("<%= emm%>" !=""))
	{
	     iPanel.ioctlWrite("emmdata", "<%= emm%>");
	}
	iPanel.ioctlWrite("hw_op_play_report", "<%= reporturl%>");
	iPanel.debug("cdq playfilm playtype = " + playtype+" comeType="+comeType);
	if(playtype == 4){ 
		iPanel.ioctlWrite("hw_op_play_fromrequest", "<%= playurl%>", comeType);
	}else iPanel.ioctlWrite("hw_op_play_fromrequest", "<%= playurl%>");
	
	if(navigator.appVersion.indexOf("iPanel 3.0") == -1) window.location.href = "<%= backUrl%>";
	else{
		var curr_back_url = "<%= tempurl%>";
		var curr_b_index = curr_back_url.indexOf("for_play_back");
		iPanel.debug("cdq curr_b_index = " + curr_b_index);
		if(curr_b_index == -1){
			if(curr_back_url.indexOf("?") > -1) curr_back_url = curr_back_url + "&for_play_back=1";
			else curr_back_url = curr_back_url + "?for_play_back=1";
		}
		var back_url =  iPanel.eventFrame.pre_epg_url+ curr_back_url;
		iPanel.debug("cdq playfilm back_url 22222 = " + back_url);
		iPanel.eventFrame.vod_back_url = back_url;
	}
</script>
</head> 
<body>
</body>
</html>
