<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@	page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@	page import="java.util.List"%>
<%@	page import="java.util.Map"%>
<%@ include file="utiltf.jsp" %>

<% 
    
	String ifcor = request.getParameter("ifcor");
	String for_play_back = request.getParameter("for_play_back");
	String tmpFocus = request.getParameter("navPos");
	
	if(tmpFocus == null){
		tmpFocus = "0";
	}
	int navPos = Integer.parseInt(tmpFocus);
	TurnPage turnPage = new TurnPage(request);
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
	
	List tt = (List)turnPage.getTurnList();//屏蔽用搜索过来后，点播返回执行2次此页面导致返回历史数组出现问题
	int listSize = tt.size();
	
	String lastHistory = (String)tt.get(listSize-1);
	int strLen = lastHistory.length();
	String isNullHistory = lastHistory.substring(strLen-3,strLen);
	
	if(isNullHistory.equals("null")){
		turnPage.removeLast();
	}
	System.out.println("turnPage.go(-1)="+turnPage.go(-1));
	int areaFocus = 1;
	int boxFos = 0;
	//int bottomFos = 0;
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length ==2){
		areaFocus = Integer.parseInt(focus[0]);
		boxFos = Integer.parseInt(focus[1]);
		//bottomFos = Integer.parseInt(focus[2]);
	}
	
%>	
<script type="text/javascript">

    var vodList = [];

	var typeListArray = [];
	//错误提示页面链接地址
	var errorInfo = "";

<%	
	MetaData metaData = new MetaData(request);
	String leftTypeId = request.getParameter("typeId");
    //调用后台的接口来获得海报推荐的链表
    //ArrayList blockbusterList = null;
    //封装查询后的结果
    //ArrayList vodList = null;
    //将数据转换为js对象
    int vodCount = 0;
    String errorInfo = null;
    
    String defaultBigPic = "/EPG/jsp/defaultHD/en/iCatch_image/bigPic_0.gif";
	//如果没有广告，则放默认图片
 	String defaultSmallPic = "/EPG/jsp/defaultHD/en/images/icatch/defaultPic.jpg";
	String defaultIcon =  "img/global_tm.gif";
	int charLength = 500;
	
	int [] subjectTypes = {10,9999};
	ArrayList subTypeList = getSubTypeList(leftTypeId,20,0,subjectTypes,request);
	System.out.println("qycq subTypeList.size()=="+subTypeList.size());
	if(null != subTypeList && subTypeList.size() > 0){
		for(int i = 0;i < subTypeList.size();i++){
			HashMap typeMap = (HashMap)subTypeList.get(i);
			String stypeId = (String)typeMap.get("TYPE_ID");
			String ntypeName = (String)typeMap.get("TYPE_NAME");
		%>	
			var typeObj = {};
			typeObj.typeId = "<%= stypeId%>";
			typeObj.name = "<%= ntypeName%>";
			typeListArray.push(typeObj);
		<%
		}
	}
	
	
	HashMap typeMap = (HashMap)subTypeList.get(navPos);
	String stypeId = (String)typeMap.get("TYPE_ID");
   	//最多5条文字推荐
	
	System.out.println("qycq stypeId=="+stypeId);
	ArrayList smallImgList = metaData.getVodListByTypeId(stypeId,charLength,0);
	//如果没有广告，则放默认图片
	if(null != smallImgList && smallImgList.size() > 0){
		ArrayList imgDataList = (ArrayList)smallImgList.get(1);
		System.out.println("qycq imgDataList.size()=="+imgDataList.size());
		if(null != imgDataList && imgDataList.size() > 0){
			for(int i = 0;i < imgDataList.size();i++){
				HashMap imgMap = (HashMap)imgDataList.get(i);
				int vodId = ((Integer)imgMap.get("VODID")).intValue();
				HashMap vodMap = (HashMap)metaData.getVodDetailInfo(vodId);
				String picPath = ""; 
				String iconPath = "";
				String name = (String)vodMap.get("VODNAME"); 
				HashMap poster = (HashMap)imgMap.get("POSTERPATHS");
				if(poster.get("1") != null){
					String[] imgPath = (String[])poster.get("1");
					picPath = imgPath[0];
				};
				picPath = getPicPath(picPath,defaultSmallPic,0,request);
				
				/*if(poster.get("3") != null){
					String[] imgPath = (String[])poster.get("3");
					iconPath = imgPath[0];
				};*/
				//iconPath = getPicPath(iconPath,defaultIcon,0,request);	
				// 连续剧类型(0:非连续剧父集、1:连续剧父集)
				int playType = ((Integer)vodMap.get("ISSITCOM")).intValue(); 
			 %>
				var Obj = {};
				Obj.typeId ="<%= stypeId%>";
				Obj.vodId = <%= vodId%>;
				Obj.img = "<%= picPath%>";
				Obj.name = "<%= name%>";
				Obj.iconPath = "<%= iconPath%>";
				Obj.playType = <%= playType%>;
				vodList.push(Obj);		
			 <%	
			}
		}
	}
	else
	{   
        errorInfo = request.getContextPath() + "/jsp/defaultHD/en/InforDisplay.jsp?ERRORCODE=002";
%>       
        errorInfo = "<%=errorInfo%>";
        window.location.href = errorInfo;
<%       
		return;
    }  
	 
   //广告位
	//String poster = getPicPath(typeId, "/EPG/jsp/images/universal/default/defaultpic.gif", "5", request);
%>  
	
	var areaFocus = <%= areaFocus%>; 
	var boxFos = <%= boxFos%>;
	//var bottomFos ="<= bottomFos%>";
    //var posterImg = "<=poster %>";
	var typeId = "<%= stypeId%>";
</script>