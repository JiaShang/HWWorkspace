<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ page language="java" pageEncoding="GBK" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="../util.jsp" %>
<%
    /* 获取精彩推荐标志位  */
	String ifcor = request.getParameter("ifcor");
	String for_play_back = request.getParameter("for_play_back");
	TurnPage turnPage = new TurnPage(request);
	/* 如果是从精彩推荐返回的，直接返回到节目列表页面  */
	if(null == for_play_back){
		if(null == ifcor){
			turnPage.addUrl();
		}
		else{
			turnPage.removeLast();
			turnPage.addUrl();
		}
	}
	else{
		turnPage.removeLast();
	}
	
	/*String EPGflag = request.getParameter("EPGflag");
	String proFlag = request.getParameter("proFlag");
	String newSTBflag = request.getParameter("newSTBflag");*/

	int focusArea = 1;//区域
	int topButtonPos = 0;//
	int jishuButtonPos = 0;
	int jishulistFocusPos = 0;
	
	String[] focus = turnPage.getPreFoucs();
	if(null != focus && focus.length == 4)
	{
		focusArea = Integer.parseInt(focus[0]);
		topButtonPos = Integer.parseInt(focus[1]);
		jishuButtonPos = Integer.parseInt(focus[2]);
		jishulistFocusPos = Integer.parseInt(focus[3]);
	}
	
	/* 默认海报路径  */
	String defaultPic = "/EPG/jsp/images/universal/default/defaultpic.gif";	

	String typeId =  request.getParameter("typeId");
	String parenttempId =  request.getParameter("vodId");
	int parentId = 0;
	try
	{
		parentId = Integer.parseInt(parenttempId);
	}
	catch(Exception e)
	{
		//跳转到错误页面
		%>
		window.location.href = "/EPG/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=002";
		<%	
	}
	
	//logDebug("父栏目ID="+typeId,request);
	//以下是获取连续剧父级的信息
	MetaData mt = new MetaData(request);
	Map map = mt.getVodDetailInfo(parentId);
	String intr = null;
	String vodName = "";
	String director = "";
	String actor = "";
	String code = "";
	String lang = "";
	String picPath = "";
	String tag = "";
	int playType = 0;
	int fee = 0;
	int jstotal = 0;
	String defaultPath="/EPG/jsp/images/universal/default/defaultpic.gif";
	if(null != map)
	{
		/* 片名 */
		vodName = (String) map.get("VODNAME");
		vodName = subString1(vodName,20);
		if("".equals(vodName)){
			vodName = "暂无";
		}
		/* 导演 */
		director = (String) map.get("DIRECTOR");
		director = subString1(director,20);
		if("".equals(director)){
			director = "暂无";
		}
		/* 主演 */
		actor = (String) map.get("ACTOR");
		actor = subString1(actor,20);
		if("".equals(actor)){
			actor = "暂无";
		}
		
		code = (String) map.get("CODE");
		
		tag  = (String)map.get("TAGS");
		tag = subString1(tag,20);
		if("".equals(tag)){
			tag = "暂无";
		}

		
		/* 剧情 */
		intr = (String) map.get("INTRODUCE");
		defaultPath="/EPG/jsp/images/universal/default/defaultpic.gif";
		HashMap postershow = (HashMap)map.get("POSTERPATHS");
		if(postershow.get("1") != null){
			String[] imgPath = (String[])postershow.get("1");
			picPath = imgPath[0];
		}	
		
		picPath=getPicPath(picPath,defaultPath,0,request);
		
		//总集数
		jstotal = ((Integer) map.get("SITCOMNUM")).intValue();
		
		//流派
		String[] liupai =(String[])map.get("GENRE");
		if(liupai != null){
			for(int i=0;i<liupai.length;i++){
				//System.out.println("zenglt liupai=="+liupai[i]);
			}
		}
		
		//fee = ((Integer) map.get("VODPRICE")).intValue();
		
		// 影片类型：1、影片；10、广告；11、连续剧
		playType = ((Integer)map.get("ISSITCOM")).intValue();
	}
	if(null == intr)
	{
		intr = "暂无";
	}
	else
	{
		intr = subString1(intr,100);
	}
	
	int totalNum = 0;
	
	
	
	List dataList = (List) mt.getSitcomList(parenttempId , 999, 0);
	ArrayList sitcom = (ArrayList)request.getSession().getAttribute("playedSitcoms");
	if(null == sitcom)
	{
		sitcom = new ArrayList(0);
	}
	
	/* 精彩Map*/
    //Map vodMap = null;
    /* 精彩推荐 */
	String imgBigTypeId = "10000100000000090000000000105742";
	ArrayList bigImgList = mt.getVodListByTypeId(imgBigTypeId,150,0);
	//List vodList = getBlockbusterDataList(typeId, 7, 0, request, response);
%>
<script language="javascript">
var subList = new Array();
var dataList = new Array();
var vodList = new Array();
var corCountTotal = 0;

<%
	/* 精彩推荐 */
	if(null != bigImgList && bigImgList.size() > 0){
 		ArrayList imgDataList = (ArrayList)bigImgList.get(1);
		System.out.println("tvdetail imgDataList.size()=="+imgDataList.size());
 		if(null != imgDataList && imgDataList.size() > 0){
 			for(int i = 0;i < imgDataList.size();i++)	{
 				HashMap imgMap = (HashMap)imgDataList.get(i);
 				int svodId = ((Integer)imgMap.get("VODID")).intValue();
 				HashMap vodMap = (HashMap)mt.getVodDetailInfo(svodId);
 				String blockName = (String)vodMap.get("VODNAME"); 
				String spicPath = "";
				HashMap poster = (HashMap)imgMap.get("POSTERPATHS");
 				if(poster.get("1") != null){
 					String[] imgPath = (String[])poster.get("1");
 					spicPath = imgPath[0];
 				};
 				spicPath = getPicPath(spicPath,defaultPath,0,request);
 				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
 				int splayType = ((Integer)vodMap.get("ISSITCOM")).intValue(); 
 %>
 				var bigImgObj = {};
				bigImgObj.typeId = "<%= imgBigTypeId%>";
 				bigImgObj.vodId = <%= svodId%>;
 				bigImgObj.img = "<%= spicPath%>";
 				bigImgObj.name = "<%= blockName%>";
 				bigImgObj.playType = <%=splayType%>;
 				vodList.push(bigImgObj);
 <%				
 			}
 		}
 	}

	
	if(dataList != null && dataList.size() == 2)
	{
		//logDebug("dataList:"+dataList.toString(),request); 
		List sitList = (List)dataList.get(1);
		if(null == sitList || sitList.size() == 0)
		{
		%>
			window.location.href = "/EPG/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=002";
		<%	
		}
		else
		{
			Map countMap = (Map)dataList.get(0);
			totalNum = ((Integer) countMap.get("COUNTTOTAL")).intValue();
		}
		for(int i = 0; i < sitList.size(); i++)
		{
			//logDebug("连续剧子集信息:"+sitList.toString(),request); 
			//连续剧子集信息
			Map sit = (Map) sitList.get(i);
			//String format = (String) map.get("VODFORMAT");
			int vodId = ((Integer) sit.get("VODID")).intValue();
			Map sitvodMap = mt.getVodDetailInfo(vodId);
			String SitName = (String)sitvodMap.get("VODNAME");
			//int isFree = ((Integer) sit.get("ISFREE")).intValue();
			String scolor = "#f0f0f0";
			int isplayed = 0;
			if(sitcom.contains(new Integer(vodId)))
			{
				scolor = "#999999";
				isplayed = 1;
			}
		%>
			var sit = new Object();
			sit.name = "<%=SitName %>";
			sit.vodId = <%=vodId %>;
			sit.scolor = "<%=scolor %>";
			sit.isplayed= <%=isplayed%>;
			subList.push(sit);
		<%
		}
	}
	/**最近点播  */
	List played = (List)session.getAttribute("playedFilms");
	
	if(null != played)
	{
	    //logDebug("最近点播:"+played.toString(),request); 
		for(int i = 0; i < played.size(); i++)
		{
			Integer pid = (Integer)played.get(i);
			Map pvod = mt.getVodDetailInfo(pid.intValue());
			if(pvod.isEmpty()) continue;
			String pname = (String)pvod.get("VODNAME");
			Integer ptype = (Integer)pvod.get("ISSITCOM"); 
			//String format = (String) map.get("VODFORMAT");
			%>
				var pobj = new Object();
				pobj.vodId = <%=pid.intValue()%>;
				pobj.playType = <%=ptype.intValue()%>;
				pobj.vodName = "<%=pname%>";
				dataList.push(pobj);
			<%
		}
	}
%>



var saveId = <%=parenttempId %>
var typeId = "<%=typeId%>";
var parentId = "<%=parentId%>";
var playType = "<%=playType%>";

/**子集总数 */
var totalnum = <%=totalNum%>;
//总集数
var jstotal = <%=jstotal%>;
/**当前页  */
//var pageNo = <\%=pageNo%>;
/** 0：输入框 、1：底部菜单、2：顶部菜单、3：最近点播的数据区域；4：连续剧子集，5：上下页  ，6：精彩推荐区域 */
/*var dataArea = <\%=dataArea%>;
var jsNo = <\%=jsNo%>;
var pageNo = <\%=pageNo%>;
var tjNo = <\%=tjNo%>;*/

var vodname = "<%=vodName%>";
var director = "<%=director%>";
var actor = "<%=actor%>";
var for_play_back = <%=for_play_back%>;
var code = "<%=code%>";
var tagname =  "<%=tag%>";
var intr = "<%=intr%>";
var fee = (<%=fee%>/100);
var picPath = "<%=picPath%>";
</script>
