<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ include file="util.jsp" %>

<% 
	//�������
	String ifcor = request.getParameter("ifcor");
	String for_play_back = request.getParameter("for_play_back");
	//int menuPos = Integer.parseInt(request.getParameter("menuPos"));
	
	TurnPage turnPage = new TurnPage(request);
	List list1 = (List)turnPage.getTurnList();
	for(int i = 0;i<list1.size(); i++){
		System.out.println("index_ifeng_data 1 turnPage = "+i+":"+list1.get(i));
	}
	
	/*  ����ǴӾ����Ƽ����صģ�ֱ�ӷ��ص���Ŀ�б�ҳ��  */
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
	
	//����typeArea�������Ŀ  topButtonFocusPos:������ menuFocusPos���˵��� listFocusPos��������� picFocusPos���ұ�ͼƬ
	int focusArea = 2;
	int topButtonPos = 0;
	int picPos = 0;
	int listFocusPos = 0;
	// ����ʱ��ȡ������Ϣ����
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length > 0){
		focusArea    = Integer.parseInt(focus[0]);
		topButtonPos = Integer.parseInt(focus[1]);
		picPos   	 = Integer.parseInt(focus[2]);
		listFocusPos = Integer.parseInt(focus[3]);
	}
	

%>
<script type="text/javascript">

	//��������Ƽ�����
	var vodTextArray = [];
	//�м��ͼ�Ƽ�vod
	var vodImgArray = [];
	//�ұ�СͼƬ�Ƽ�����
	var vodSmallImgArray = [];
	
<%
	MetaData metaData = new MetaData(request);

	//��������Ƽ�����Ŀ��ţ���vod,ֱ�Ӳ���
	//String charTypeId = "10000100000000090000000000105323";
	String charTypeId = request.getParameter("typeId");


   /*
    *�������vod�����Ƽ���
    */
    //�����Ƽ�����
 	int charCountTotal = 0;
 	
 	//���5�������Ƽ�
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
 				// ����������(0:�������縸����1:�����縸��)
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
 	 *�ұ�Сͼ�Ƽ�����vod
 	 */
	
 	//ȡ�Ƽ�ͼƬ,ͼƬ�Ƽ�����
 	int smallImgCountTotal = 2;
     
 	ArrayList smallImgList = metaData.getVodListByTypeId(charTypeId,3,0);
 	//���û�й�棬���Ĭ��ͼƬ
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
 				// ����������(0:�������縸����1:�����縸��)
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
 	

//��������Ƽ�����Ŀ��ţ���vod,ֱ�Ӳ���
var charTypeId = "<%= charTypeId%>";



</script>