<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
	Map resultMp = new HashMap();
	resultMp = (Map) request.getAttribute("resultMp");
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

		confirmUrl = request.getContextPath() + "/jsp/defaultHD/en/Confirm.jsp?"
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
				+ "&startTime=" + startTime;

		//System.out.println("confirmUrl = " + confirmUrl);
	}


	//是否可以播放标识
	int playFlag = 0;

	int anCiFlag = 0;
	String url = "";

	/* 与图文相关页面返回需要的参数 */
	String tw_record_template = (String) resultMp.get("tw_record_template");
	String tw_record_flag = (String) resultMp.get("tw_record_flag");

	//影片的播放地址
	String playUrl = (String)resultMp.get("playUrl");
	String json ="";
	//影片可播放
	if (playUrl != null && !"".equals(playUrl))
	{
		playFlag = 1;
		String reportUrl = (String) resultMp.get("reportUrl");
		String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",playUrl:\""+playUrl+"\""+",reportUrl:\""+reportUrl+"\"}";
	}else if("Anci_flag".equals(Anci_flag)){
		anCiFlag = 1;
		String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",message:\""+mess+"\""+",confirmUrl:\""+confirmUrl+"\"}";
	}else{
		String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",message:\""+mess+"\"}";
	}
%>
<%=json %>