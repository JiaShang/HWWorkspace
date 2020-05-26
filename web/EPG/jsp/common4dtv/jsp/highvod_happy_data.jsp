<%@ page contentType="text/html; charset=GBK" import="java.util.*" language="java"%>
<%@ page import="java.io.*" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ include file="util.jsp" %>
<% 
    /**
     *高清视界-->高清娱乐，数据请求文件
     */
      
	//焦点记忆
	TurnPage turnPage = new TurnPage(request);
	turnPage.addUrl();
	
	//获取参数,顶部栏目
	String topTypeID = request.getParameter("topTypeID");
	//图片区域vod栏目id
	String vodTypeID = request.getParameter("vodTypeID");
	//图片区栏目id
	String imgTypeID = request.getParameter("imgTypeID");
	
    
	//区域及焦点位置
	int fosArea = 0;
	int typelistFos = 0;
	int vodListFos = 0;
	int vodtypeListFos = 0;
	int currPage = 1;
	// 返回时获取焦点信息数据
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length > 0){
		fosArea = Integer.parseInt(focus[0]);
		typelistFos = Integer.parseInt(focus[1]);
		vodListFos = Integer.parseInt(focus[2]);
		vodtypeListFos = Integer.parseInt(focus[3]);
		currPage = Integer.parseInt(focus[4]);
	}
	
	/* 公告信息*/
	String bull = null;
	
	// 获取公告 
    bull = getBulletin(20,topTypeID,request,response);
    
    if(null == bull || "".equals(bull.trim()))
    {
		bull =  "暂无公告";       
    }
    
    //页数的计算，表示图片区域vod和图片区域栏目页数数量
    //理论上都是2
    int vodPage = 0;
    int typePage = 0;
    int needPage = 0;
 %>
<script type="text/javascript">
   	var highvodFosArea = <%= fosArea%>; 
   	var highvodTypelistFos = <%= typelistFos%>;
   	var highvodVodListFos = <%= vodListFos%>;
   	var highvodVodtypeListFos = <%= vodtypeListFos%>;
   	var highvodCurrPage = <%=currPage%>;

	//图片vod部分
	var vodArray = [];
	
	//顶部栏目
	var topTypeArray = [];
	
	//图片栏目部分
	var imgTypeArray = [];
	
	
<%
	MetaData metaData = new MetaData(request);
 	/**
 	 *图片区域vod获取
 	 *最多获取10个vod数据，最少是5个，注意为了能铺满屏幕，获取个数应该为5的倍数
 	 */     
 	ArrayList vodList = metaData.getVodListByTypeId(vodTypeID,10,0);

 	//如果没有广告，则放默认图片
 	String defaultPic = "/EPG/jsp/defaultHD/en/images/icatch/defaultPic.jpg";
 	if(null != vodList && vodList.size() > 0){
 		ArrayList imgDataList = (ArrayList)vodList.get(1);
 		if(null != imgDataList && imgDataList.size() >= 5){
 			int size  =  imgDataList.size();
 			vodPage = size / 5;
 			int needSize = size - (size % 5);
 			for(int i = 0;i < needSize;i++)	{
 				HashMap imgMap = (HashMap)imgDataList.get(i);
 				int vodId = ((Integer)imgMap.get("VODID")).intValue();
 				HashMap vodMap = (HashMap)metaData.getVodDetailInfo(vodId);
 				String picPath = ""; 
 				String blockName = (String)vodMap.get("VODNAME"); 
				
				HashMap poster = (HashMap)imgMap.get("POSTERPATHS");
 				if(poster.get("0") != null){
 					String[] imgPath = (String[])poster.get("0");
 					picPath = imgPath[0];
 				};
				
 				picPath = getPicPath(picPath,defaultPic,0,request);	
 				
 				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
 				int playType = ((Integer)vodMap.get("ISSITCOM")).intValue(); 
 %>
 				var vodObj = {};
 				vodObj.vodId = <%= vodId%>;
 				vodObj.img = "<%= picPath%>";
 				vodObj.name = "<%= blockName%>";
				vodObj.url = "";
 				vodObj.playType = <%= playType%>;
 				vodArray.push(vodObj);
 <%				
 			}
 		}else{
 			String errorURL = request.getContextPath()+"/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=014";
		   // response.sendRedirect(errorURL);
 		}
 	}
 	
 	
 	
 	/**
 	* 顶部栏目
 	*/
 	int [] subjectTypes = {10,9999};
	ArrayList topTypeList = metaData.getTypeListByTypeId(topTypeID,5,0,subjectTypes);
	
	if(null != topTypeList && topTypeList.size() > 0){
		HashMap map0 = (HashMap)topTypeList.get(0);
		int count = ((Integer)map0.get("COUNTTOTAL")).intValue();
		if(count>0){
			ArrayList typeDataList = (ArrayList)topTypeList.get(1);
			if(null != typeDataList && typeDataList.size() > 0){
				for(int i = 0;i < typeDataList.size();i++){
					HashMap typeMap = (HashMap)typeDataList.get(i);
					String stypeId = (String)typeMap.get("TYPE_ID");
					String typeName = (String)typeMap.get("TYPE_NAME");
					
					String type_picpath =  "";
					
					HashMap poster = (HashMap)typeMap.get("POSTERPATHS");
					if(poster.get("0") != null){
						String[] imgPath = (String[])poster.get("0");
						type_picpath = imgPath[0];
					};
					
					type_picpath = getPicPath(type_picpath,defaultPic,0,request);	
					// 是否有子栏目：1：有子栏目、0：无子栏目
					int hasSubType = metaData.getSubTypeOrVod(stypeId);
	%>	
					var typeObj = {};
					typeObj.typeId = "<%= stypeId%>";
					typeObj.name = "<%= typeName%>";
					typeObj.hasSubType = <%= hasSubType%>;
					typeObj.img = "<%= type_picpath%>";
					typeObj.url = "";
					topTypeArray.push(typeObj);
	<%
				}
			}
			
		}else{
			String errorURL = request.getContextPath()+"/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=014";
		    //response.sendRedirect(errorURL);
		}
	 }
	
	
	
	/**
	* 图片区域栏目
	*/
	ArrayList imgTypeList = metaData.getTypeListByTypeId(imgTypeID,4,0,subjectTypes);
	if(null != imgTypeList && imgTypeList.size() > 0){
		HashMap map0 = (HashMap)imgTypeList.get(0);
		int count = ((Integer)map0.get("COUNTTOTAL")).intValue();
		if(count>0){
			ArrayList typeDataList = (ArrayList)imgTypeList.get(1);
			if(null != typeDataList && typeDataList.size() >=2){
				int size  =  typeDataList.size();
				typePage = size / 2;
	 			int needSize = size - (size % 2);
				for(int i = 0;i < needSize;i++){
					HashMap typeMap = (HashMap)typeDataList.get(i);
					String stypeId = (String)typeMap.get("TYPE_ID");
					String typeName = (String)typeMap.get("TYPE_NAME");
					String type_picpath =  "";
					
					HashMap poster = (HashMap)typeMap.get("POSTERPATHS");
					if(poster.get("0") != null){
						String[] imgPath = (String[])poster.get("0");
						type_picpath = imgPath[0];
					};
					
					type_picpath = getPicPath(type_picpath,defaultPic,0,request);	
					// 是否有子栏目：1：有子栏目、0：无子栏目
					int hasSubType = metaData.getSubTypeOrVod(stypeId);//Integer.parseInt(typeMap.get("hasSubType").toString());
	%>	
					var typeObj = {};
					typeObj.typeId = "<%= stypeId%>";
					typeObj.name = "<%= typeName%>";
					typeObj.hasSubType = <%= hasSubType%>;
					typeObj.img = "<%= type_picpath%>";
					//typeObj.type = "专题";
					typeObj.url = "";
					imgTypeArray.push(typeObj);
	<%
				}
			}
			
		}else{
			String errorURL = request.getContextPath()+"/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=014";
		    //response.sendRedirect(errorURL);
		}
	 }
	
	needPage = (vodPage<=typePage)? vodPage:typePage;
%>
//顶部栏目id
var topTypeID = "<%=topTypeID%>";
//图片部分vod
var vodTypeID = "<%= vodTypeID%>";
//图片部分栏目
var imgTypeID = "<%= imgTypeID%>";
//公告
var content = "<%=bull%>";
//页数
var javaNeedPage = "<%=needPage%>";
</script>