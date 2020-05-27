<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ include file="util.jsp" %>

<% 
	//焦点记忆
	String ifcor = request.getParameter("ifcor");
	String for_play_back = request.getParameter("for_play_back");
	//int menuPos = Integer.parseInt(request.getParameter("menuPos"));
	
	TurnPage turnPage = new TurnPage(request);
	List list1 = (List)turnPage.getTurnList();
	for(int i = 0;i<list1.size(); i++){
		System.out.println("index_ifeng_data 1 turnPage = "+i+":"+list1.get(i));
	}
	
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
	
	//区域，typeArea：左侧栏目  topButtonFocusPos:搜索栏 menuFocusPos：菜单栏 listFocusPos：左边文字 picFocusPos：右边图片
	int focusArea = 2;
	int topButtonPos = 0;
	int picPos = 0;
	int listFocusPos = 0;
	// 返回时获取焦点信息数据
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length > 0){
		focusArea    = Integer.parseInt(focus[0]);
		topButtonPos = Integer.parseInt(focus[1]);
		picPos   	 = Integer.parseInt(focus[2]);
		listFocusPos = Integer.parseInt(focus[3]);
	}
	

%>
<script type="text/javascript">

	//左侧文字推荐数据
	var vodTextArray = [];
	//中间大图推荐vod
	var vodImgArray = [];
	//右边小图片推荐数据
	var vodSmallImgArray = [];
	
<%
	MetaData metaData = new MetaData(request);

	//左边文字推荐，栏目编号，是vod,直接播放
	//String charTypeId = "10000100000000090000000000105323";
	String charTypeId = request.getParameter("typeId");


   /*
    *左侧文字vod文字推荐区
    */
    //文字推荐总数
 	int charCountTotal = 0;
 	
 	//最多5条文字推荐
 	int charLength = 20;
	
 	ArrayList chaList = metaData.getVodListByTypeId(charTypeId,charLength,0);
 	if(null != chaList && chaList.size() > 0){
 		HashMap map1 = (HashMap)chaList.get(0);
 		ArrayList chaDaList = (ArrayList)chaList.get(1);
		System.out.println("chaDaList.size()=="+chaDaList.size());
 		if(null != chaDaList && chaDaList.size() > 0){
 			charCountTotal = chaDaList.size();
 			for(int i = 0;i < chaDaList.size();i++){
 				HashMap chaMap = (HashMap)chaDaList.get(i);
 				int vodId = ((Integer)chaMap.get("VODID")).intValue();
 				HashMap vodMap = (HashMap)metaData.getVodDetailInfo(vodId); 
 				String vodName = (String)vodMap.get("VODNAME");
			    String tag  = (String)vodMap.get("TAGS");
 				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
 				int playType = ((Integer)vodMap.get("ISSITCOM")).intValue();
 %>
 				var charObj = {};
 				charObj.vodId = <%= vodId%>;
 				charObj.name = "<%= vodName%>";
 				charObj.playType = <%= playType%>;
				charObj.type = "<%=tag%>";
				charObj.url = "";
 				vodTextArray.push(charObj);				
 <%	
 			}
 		}
 	}
 	
 	
 	
 	/**
 	 *右边小图推荐区域vod
 	 */
	
 	//取推荐图片,图片推荐总数
 	int smallImgCountTotal = 2;
     
 	ArrayList smallImgList = metaData.getVodListByTypeId(charTypeId,3,0);
 	//如果没有广告，则放默认图片
 	String defaultSmallPic = "/EPG/jsp/defaultHD/en/images/icatch/defaultPic.jpg";
 	if(null != smallImgList && smallImgList.size() > 0){
 		ArrayList imgDataList = (ArrayList)smallImgList.get(1);
		System.out.println("small imgDataList.size()=="+imgDataList.size());
 		if(null != imgDataList && imgDataList.size() > 0){
 			for(int i = 0;i < imgDataList.size();i++)	{
 				HashMap imgMap = (HashMap)imgDataList.get(i);
 				int vodId = ((Integer)imgMap.get("VODID")).intValue();
 				HashMap vodMap = (HashMap)metaData.getVodDetailInfo(vodId);
 				String picPath = ""; 
 				String blockName = (String)vodMap.get("VODNAME"); 
				HashMap poster = (HashMap)imgMap.get("POSTERPATHS");
 				if(poster.get("1") != null){
 					String[] imgPath = (String[])poster.get("1");
 					picPath = imgPath[0];
 				};
 				picPath = getPicPath(picPath,defaultSmallPic,0,request);	
 				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
 				int playType = ((Integer)vodMap.get("ISSITCOM")).intValue(); 
 %>
 				var smallImgObj = {};
 				smallImgObj.vodId = <%= vodId%>;
 				smallImgObj.img = "<%= picPath%>";
 				smallImgObj.name = "<%= blockName%>";
				smallImgObj.url = "";
 				smallImgObj.playType = <%= playType%>;
 				vodSmallImgArray.push(smallImgObj);
 <%				
 			}
 		}
 	}
%> 	
 	

//左边文字推荐，栏目编号，是vod,直接播放
var charTypeId = "<%= charTypeId%>";



</script>