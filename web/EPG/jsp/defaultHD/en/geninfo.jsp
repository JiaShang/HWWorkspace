<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.*"%>
<html>
	<%
		Map resultMp = new HashMap();
		resultMp = (Map) request.getAttribute("resultMp");
		String FSNId = (String) resultMp.get("neVodId");
		String comeType = (String) request.getAttribute("comeType"); //判断回看来源
		String mess = (String) resultMp.get("message");
		if(mess == null)
		{
			mess = "操作失败";
		}
			
		Object confirmMarkObj = resultMp.get("confirmMark");//标记是否走过按次订购流程
		boolean confirmMark = (null != confirmMarkObj);
		
		Object o = resultMp.get("Anci_flag");
		String Anci_flag = null;
		if(null != o)
		{
			Anci_flag = o.toString();
		}
        
   		String hj_yyt ="";
		Object hjyyt = resultMp.get("hj_yyt");//韩剧中跳转电视营业厅
		if(null != hjyyt)
		{
			hj_yyt = hjyyt.toString();
		}
        
        // 处理二次授权页面跳转路径
		String confirmUrl = "";
        
        //如果返回的错误码是需要订购的,则会进入用户订购流程
        if("Anci_flag".equals(Anci_flag))
        {
            //节目编号
            String vodId = (String) resultMp.get("progId");
            //父集编号(适用电视剧)
            String supVodId = (String) resultMp.get("parentVodId");
            //内容类型
            String contentType = (String) resultMp.get("contentType");
            //业务类型
            String businessType = (String) resultMp.get("businessType");
            //产品对象
            Map prodObj = (Map)resultMp.get("prodObj");
            //产品编号
            String prodcode = (String)prodObj.get("PROD_CODE");
            //服务编号
            String serviceId = (String)prodObj.get("SERVICE_CODE");
            //续订标识
            String continueType = ((Integer)prodObj.get("PROD_CONTINUEABLE")).toString();
            // 在小窗口播放片花时需传入此参数控制trickmode的操作
            String tkmode = (String)resultMp.get("tkmode");
            // 在小窗口播放片花时需传入此参数控制osd的显示
            String osd = (String)resultMp.get("osd");
            //播放类型
            String playType = (String)resultMp.get("playtype");
            //频道编号
            String chanId = (String)resultMp.get("chanId");
            //栏目编号
            String typeId = (String)resultMp.get("typeId");
            //播放的开始时间
            String startTime = (String)resultMp.get("starttime");
			//媒体ID
			String mediaId = (String)resultMp.get("mediaId");
			//System.out.println("geninfo mediaId=="+mediaId);
	    
		        confirmUrl = request.getScheme() + "://" + request.getServerName()
                     + ":" + request.getServerPort() + request.getContextPath() + "/jsp/defaultHD/en/Confirm.jsp?"
		                     + "prodcode=" + prodcode
		                     + "&serviceId=" + serviceId
		                     + "&continueType=" + continueType
		                     + "&contentType=" + contentType
		                     + "&vodId=" + vodId
		                     + "&businessType=" + businessType
		                     + "&supVodId=" + supVodId
		                     + "&tkmode=" + tkmode
		                     + "&osd=" + osd
		                     + "&playtype=" + playType
		                     + "&chanId=" + chanId
		                     + "&typeId=" + typeId
		                     + "&startTime=" + startTime
							  + "&mediaId=" + mediaId
							  + "&neVodId=" + FSNId;
		                
		       //System.out.println("geninfo Anci_flag confirmUrl = " + confirmUrl);         
        }
		 

    //是否可以播放标识
		int playFlag = 0;

		String url = "";
		
		/* 与图文相关页面返回需要的参数 */
    String tw_record_template = (String) resultMp.get("tw_record_template");
	  String tw_record_flag = (String) resultMp.get("tw_record_flag");

    //影片的播放地址
    String playUrl = (String)resultMp.get("playUrl");

		//影片可播放
		if (playUrl != null && !"".equals(playUrl))
		{
			playFlag = 1;
			//System.out.println("playUrl = " + playUrl);   
			playUrl = URLEncoder.encode(playUrl, "GBK");
			playUrl = URLEncoder.encode(playUrl, "GBK");
	    String reportUrl = (String) resultMp.get("reportUrl");
	    //直播统计上报路径
	    if (reportUrl != null) 
	    {
		     reportUrl = URLEncoder.encode(reportUrl, "GBK");
	    }
	    
	    String emm = (String) resultMp.get("emm");
			session.setAttribute("MEDIAPLAY", "1");
			url= request.getContextPath() + "/jsp/defaultHD/en/playfilm.jsp?playUrl=" + playUrl 
					+ "&reportUrl=" + reportUrl 
					+ "&emm=" + emm
					+ "&tw_record_template=" +tw_record_template
				  + "&tw_record_flag=" + tw_record_flag
				  + "&comeType=" + comeType;
		}
		//System.out.println("geninfo play url = " + url); 
		//测试数据
	//	playFlag = 0;
	%>
<head>
<title></title>
<SCRIPT language="javascript" type="text/javascript">
	
	//影片是否可播放标识
	var hj_yyt = "<%= hj_yyt%>";
	var playFlag = <%= playFlag%>; 
	var url = "<%= url%>";
	var Anci_flag = "<%= Anci_flag%>";
	window.top.confirmMark = <%= confirmMark%>;
	iPanel.eventFrame.comfirmUrl = "<%=confirmUrl%>";
	
	//播放前的授权返回信息
	function callparent()
	{
	//	var oper = "<1%= oper%>";
	//	var playtype= "<1%= playtype%>";
		
		if(Anci_flag == "Anci_flag") 
		{
			/* 按次收费标识  */
			window.top.anCiFlag = 1;
			/* 按次收费转发路径   */
			window.top.confirmUrl = "<%=confirmUrl%>";
			/* 显示提示层 */
			if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 2);
		}
		else /*显示提示层*/
		{
			if(hj_yyt == "hj_yyt"){
				if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 3);
			}else{
				if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 1);
			}
		}
	}
	
	/**播放*/
	function onplay()
	{
		window.top.location.href = url;
	}
	
	function init()
	{
		/**授权失败，弹出提示层*/
		if(playFlag == 0)
		{	
			callparent();
		}
		
		/**授权成功*/
		else if(playFlag == 1)
		{
			onplay();
		}
		else
		{
			if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 1);
		}
	}
</SCRIPT>
</head>
<body>
</body>
<script type="text/javascript">
	init();
</script>
</html>


