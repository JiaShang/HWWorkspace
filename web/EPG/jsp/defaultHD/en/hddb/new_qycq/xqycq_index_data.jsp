<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ page language="java" pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ include file="../util.jsp" %>

<% 
	//�������
	String ifcor = request.getParameter("ifcor");
	String for_play_back = request.getParameter("for_play_back");
	
	TurnPage turnPage = new TurnPage(request);
	/*List list1 = (List)turnPage.getTurnList();
	for(int i = 0;i<list1.size(); i++){
		System.out.println("index_ifeng_data 1 turnPage = "+i+":"+list1.get(i));
	}*/
	
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
	/*List list2 = (List)turnPage.getTurnList();
	for(int i = 0;i<list2.size(); i++){
		System.out.println("index_ifeng_data 2 turnPage = "+i+":"+list2.get(i));
	}*/
	
	
	//����
	int focusArea = 7;  // 0���ϵ������� 1�����Ŀ���� 2 �м���Ƶ 3�м�ͼƬ����  4�����Ƽ����� 5�ұߺ��� 6���½���
	
	// ����ʱ��ȡ������Ϣ����
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length > 0){
		focusArea = Integer.parseInt(focus[0]);
	}
	

%>
<script type="text/javascript">

	//�����Ƶ
	var vodArray = [];
	//�Ƽ�λ5��
	var vodImgArray = [];	
	
	
<%
	MetaData metaData = new MetaData(request);

	//�м������Ƽ�����Ŀ��ţ���vod,ֱ�Ӳ���
	//String charTypeId = "10000100000000090000000000105544";
	
	//�ұߺ���ͼƬ����Ŀ���,��vod,ֱ�Ӳ���
	String vodTypeId = "10000100000000090000000000107023";
	
	String imgTypeId = "10000100000000090000000000107049";
	
	/* ������Ϣ*/
	String bull = null;
	//��ȡ��Ŀ����,��һ����Ŀ����id
	String bullTypeId = "001001";
	// ��ȡ���� 
    bull = getBulletin(20,bullTypeId,request,response);
    
    if(null == bull || "".equals(bull.trim()))
    {
		bull =  "���޹���";       
    }
 	
 	
 	/**
 	 *�����Ƶvod
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
				
 				// ����������(0:�������縸����1:�����縸��)
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
 	//ȡ�Ƽ�ͼƬ,ͼƬ�Ƽ�����
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
 				// ����������(0:�������縸����1:�����縸��)
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
 	

//����
var content = "<%=bull%>";
</script>