<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ include file="../util.jsp" %>

<% 
	//焦点记忆
	String ifcor = request.getParameter("ifcor");
	String for_play_back = request.getParameter("for_play_back");
	
	TurnPage turnPage = new TurnPage(request);
	/*List list1 = (List)turnPage.getTurnList();
	for(int i = 0;i<list1.size(); i++){
		System.out.println("index_ifeng_data 1 turnPage = "+i+":"+list1.get(i));
	}*/
	
	/*  如果是从精彩推荐返回的，直接返回到节目列表页面  */
	if(null == for_play_back){
		if(null == ifcor){
			turnPage.addUrl();
		}
		else{
			turnPage.removeLast();
			turnPage.addUrl();
		}
	}else{
		turnPage.removeLast();
	}
	/*List list2 = (List)turnPage.getTurnList();
	for(int i = 0;i<list2.size(); i++){
		System.out.println("index_ifeng_data 2 turnPage = "+i+":"+list2.get(i));
	}*/
	
	
	//区域
	int focusArea = 7;  // 0右上导航区域 1左边栏目区域 2 中间视频 3中间图片区域  4文字推荐焦点 5右边海报 6右下焦点
	
	// 返回时获取焦点信息数据
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length > 0){
		focusArea = Integer.parseInt(focus[0]);
	}
	

%>
<script type="text/javascript">

	//左边视频
	var vodArray = [];
	//推荐位5个
	var vodImgArray = [];	
	
	
<%
	MetaData metaData = new MetaData(request);

	//中间文字推荐，栏目编号，是vod,直接播放
	//String charTypeId = "10000100000000090000000000105544";
	
	//右边海报图片，栏目编号,是vod,直接播放
	String vodTypeId = "10000100000000090000000000107023";
	
	String imgTypeId = "10000100000000090000000000107049";
	
	/* 公告信息*/
	String bull = null;
	//获取栏目公告,是一个栏目类型id
	String bullTypeId = "001001";
	// 获取公告 
    bull = getBulletin(20,bullTypeId,request,response);
    
    if(null == bull || "".equals(bull.trim()))
    {
		bull =  "暂无公告";       
    }
 	
 	
 	/**
 	 *左边视频vod
 	 */
	
     
 	ArrayList vodList = metaData.getVodListByTypeId(vodTypeId,5,0);

 	if(null != vodList && vodList.size() > 0){
 		ArrayList imgDataList = (ArrayList)vodList.get(1);
		//System.out.println("big imgDataList.size()=="+imgDataList.size());
 		if(null != imgDataList && imgDataList.size() > 0){
 			for(int i = 0;i < imgDataList.size();i++)	{
 				HashMap imgMap = (HashMap)imgDataList.get(i);
 				int vodId = ((Integer)imgMap.get("VODID")).intValue();
 				HashMap vodMap = (HashMap)metaData.getVodDetailInfo(vodId);
 				String blockName = (String)vodMap.get("VODNAME"); 
				
 				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
 				int playType = ((Integer)vodMap.get("ISSITCOM")).intValue(); 
 			%>
 				var bigImgObj = {};
				bigImgObj.typeId = "<%= vodTypeId%>";
 				bigImgObj.vodId = <%= vodId%>;
 				bigImgObj.name = "<%= blockName%>";
 				bigImgObj.playType = <%= playType%>;
 				vodArray.push(bigImgObj);
			<%				
 			}
 		}
 	}
 	
 	
	
	
	String defaultBigPic = "/EPG/jsp/defaultHD/en/iCatch_image/bigPic_0.gif";
	String defaultIcon =  "img/global_tm.gif";
 	//取推荐图片,图片推荐总数
 	//int bigImgCountTotal = 1;
     
 	ArrayList bigImgList = metaData.getVodListByTypeId(imgTypeId,5,0);

 	if(null != bigImgList && bigImgList.size() > 0){
 		ArrayList imgDataList = (ArrayList)bigImgList.get(1);
		//System.out.println("big22 imgDataList.size()=="+imgDataList.size());
 		if(null != imgDataList && imgDataList.size() > 0){
 			for(int i = 0;i < imgDataList.size();i++)	{
 				HashMap imgMap = (HashMap)imgDataList.get(i);
 				int vodId = ((Integer)imgMap.get("VODID")).intValue();
 				HashMap vodMap = (HashMap)metaData.getVodDetailInfo(vodId);
 				String blockName = (String)vodMap.get("VODNAME"); 
				String tag  = (String)vodMap.get("TAGS");
				String picPath = "";
				HashMap poster = (HashMap)imgMap.get("POSTERPATHS");
 				if(poster.get("1") != null){
 					String[] imgPath = (String[])poster.get("1");
 					picPath = imgPath[0];
 				};
 				picPath = getPicPath(picPath,defaultBigPic,0,request);	
 				String iconPath = "";
				if(poster.get("3") != null){
 					String[] imgPath = (String[])poster.get("3");
 					iconPath = imgPath[0];
 				};
 				iconPath = getPicPath(iconPath,defaultIcon,0,request);	
 				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
 				int playType = ((Integer)vodMap.get("ISSITCOM")).intValue(); 
 			%>
 				var bigImgObj = {};
				bigImgObj.typeId = "<%= imgTypeId%>";
 				bigImgObj.vodId = <%= vodId%>;
 				bigImgObj.id = "bigPic";
 				bigImgObj.img = "<%= picPath%>";
 				bigImgObj.name = "<%= blockName%>";
 				bigImgObj.playType = <%= playType%>;
				bigImgObj.type = "<%= tag%>";
 				bigImgObj.iconPath = "<%= iconPath%>";
				bigImgObj.url = "";
 				vodImgArray.push(bigImgObj);
			<%				
 			}
 		}
 	}
	

%> 	
 	

//公告
var content = "<%=bull%>";
</script>