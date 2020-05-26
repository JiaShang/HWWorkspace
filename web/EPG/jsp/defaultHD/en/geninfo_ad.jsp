<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<html>
<%
	Map resultMp = new HashMap();
	resultMp = (Map) request.getAttribute("resultMp");
	Map authInfoMp = new HashMap();
	authInfoMp = (Map) request.getAttribute("authInfoMp");
	String FSNId = (String) resultMp.get("neVodId");
	String comeType = (String) request.getAttribute("comeType"); //判断回看来源
	String mess = (String) resultMp.get("message");
	
	MetaData meta = new MetaData(request);
	//栏目编号
	String param_typeId = (String)resultMp.get("typeId");
	String tmpvodId = (String) resultMp.get("progId");
	String tmpPlayType = (String)resultMp.get("playtype");
	//System.out.println("geninfo_ad in param_typeId=="+param_typeId+",tmpvodId="+tmpvodId+",tmpPlayType="+tmpPlayType+",mess="+mess);
	String vodName = "";
	if(!"4".equals(tmpPlayType)){
		
		Map vodMap = meta.getVodDetailInfo(Integer.parseInt(tmpvodId));
		vodName = (String)vodMap.get("VODNAME"); 
		vodName = URLEncoder.encode(vodName, "UTF-8");
	}
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
		playUrl = URLEncoder.encode(playUrl, "GBK");
		playUrl = URLEncoder.encode(playUrl, "GBK");
	    String reportUrl = (String) resultMp.get("reportUrl");
	    //直播统计上报路径
	    if (reportUrl != null) 
	    {
		     reportUrl = URLEncoder.encode(reportUrl, "GBK");
	    }
	    
		
		 //节目编号
        String param_vodId = (String)resultMp.get("progId");
		
		String initIPQAMUrl = (String)authInfoMp.get("IPQAMResURL");
	    String emm = (String) resultMp.get("emm");
		session.setAttribute("MEDIAPLAY", "1");
		url= request.getContextPath() + "/jsp/defaultHD/en/playfilm_ad.jsp?playUrl=" + playUrl 
				+ "&reportUrl=" + reportUrl 
				+ "&emm=" + emm
				+ "&tw_record_template=" +tw_record_template
				+ "&tw_record_flag=" + tw_record_flag
				+ "&comeType=" + comeType
				+ "&param_vodId="+param_vodId
				+ "&initIPQAMUrl="+initIPQAMUrl;
	}
	//request.setAttribute("authInfoMp",authInfoMp);
	//System.out.println("geninfo_ad===========mess"+mess+",playUrl=="+playUrl);
	//测试数据
	//	playFlag = 0;
%>
<head>
<title></title>
<SCRIPT language="javascript" type="text/javascript">
	//iPanel.eventFrame.initPage(window);	
	
	//正式环境 前贴片广告位代码：Pre-ad；后贴片广告位代码：Post-ad；暂停广告位代码：Pause-ad；音量广告位代码：Vol-ad
	var urlPATH = "http://192.168.204.13/communication/";
	var startAdCode = "Pre-ad";    //广告位 前贴片（视频）
	var endAdCode = "Post-ad";    //后贴片（视频）
	var pauseAdCode = "Pause-ad";   //暂停广告（图片）
	var volumeAdCode = "Vol-ad";   //音量广告(图片)
	
	var stbId = hardware.STB.serialNumber;     //机顶盒ID
	var logFlag = true;    //是否需要记录点播详单及广告计数  true: 需要  false: 不需要
	var cardId = CA.card.cardId;    //机顶盒卡号
	
	var ipAddress = network.ethernets[0].IPs[0].address;   //获取机顶盒ip
	var assetName = "<%= vodName%>";    // urlEncoder(utf-8) 转换
	var columnId = "<%= param_typeId%>";    //页面获取
	var smValue = network.ethernets[0].MACAddress;   //sm值
	
	var requestAjaxObj; //ajax请求对象 请求前贴片
	var startContentId = "";   //播放的startContentId  思华接口获取
	
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
		window.top.location.href = url+"&preId="+startContentId;
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
			getStartContentId();
			//onplay();
		}
		else
		{
			if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 1);
		}
	}
	
	
function getStartContentId(){
	iPanel.debug("geninfo_ad ajaxToGeHua in ");
	var abortFlag = false;
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function (){
		if(XHR.readyState == 4){
			if(XHR.status == 200){
				var tempArr = XHR.responseText.split(",");
				if(typeof(tempArr[1]) != "undefined"){
					startContentId = tempArr[1].replace(/( |　)/gi,'');   // 取到startContentId字段   "3000000120160325002800-30000001";
					//startContentId = "3000001520160520000700-30000015";
				}
				onplay();
			}else{//AJAX没有获取到数据
				abortFlag = true;
				XHR.abort();
				onplay();
			}
		}
	}
	//var url =iPanel.eventFrame.pre_epg_url+"/defaultHD/en/datajspHD/queryVodData.jsp?typeID=001000&start=0&size=5&platform=android";
	
	var tmpurl = urlPATH + "adveristing?adLocationCode="+startAdCode+"&oldAdList=&areaCode=&stbId="+stbId+"&ip="+ipAddress+"&assetName="+assetName+"&path=&serviceId=&logInfo="+logFlag+"&columnId="+columnId+"&cardNo="+cardId;
	iPanel.debug("geninfo_ad url=="+tmpurl);
	XHR.open("GET", tmpurl, true);
	XHR.send(null);
	setTimeout("onplay();",3000);
	
}
	
</SCRIPT>
</head>
<body>
</body>
<script type="text/javascript">
	init();
</script>
</html>


