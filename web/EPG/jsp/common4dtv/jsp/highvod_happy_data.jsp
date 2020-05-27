<%@ page contentType="text/html; charset=GBK" import="java.util.*" language="java"%>
<%@ page import="java.io.*" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ include file="util.jsp" %>
<% 
    /**
     *�����ӽ�-->�������֣����������ļ�
     */
      
	//�������
	TurnPage turnPage = new TurnPage(request);
	turnPage.addUrl();
	
	//��ȡ����,������Ŀ
	String topTypeID = request.getParameter("topTypeID");
	//ͼƬ����vod��Ŀid
	String vodTypeID = request.getParameter("vodTypeID");
	//ͼƬ����Ŀid
	String imgTypeID = request.getParameter("imgTypeID");
	
    
	//���򼰽���λ��
	int fosArea = 0;
	int typelistFos = 0;
	int vodListFos = 0;
	int vodtypeListFos = 0;
	int currPage = 1;
	// ����ʱ��ȡ������Ϣ����
	String[] focus = turnPage.getPreFoucs();  
	if(null != focus && focus.length > 0){
		fosArea = Integer.parseInt(focus[0]);
		typelistFos = Integer.parseInt(focus[1]);
		vodListFos = Integer.parseInt(focus[2]);
		vodtypeListFos = Integer.parseInt(focus[3]);
		currPage = Integer.parseInt(focus[4]);
	}
	
	/* ������Ϣ*/
	String bull = null;
	
	// ��ȡ���� 
    bull = getBulletin(20,topTypeID,request,response);
    
    if(null == bull || "".equals(bull.trim()))
    {
		bull =  "���޹���";       
    }
    
    //ҳ���ļ��㣬��ʾͼƬ����vod��ͼƬ������Ŀҳ������
    //�����϶���2
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

	//ͼƬvod����
	var vodArray = [];
	
	//������Ŀ
	var topTypeArray = [];
	
	//ͼƬ��Ŀ����
	var imgTypeArray = [];
	
	
<%
	MetaData metaData = new MetaData(request);
 	/**
 	 *ͼƬ����vod��ȡ
 	 *����ȡ10��vod���ݣ�������5����ע��Ϊ����������Ļ����ȡ����Ӧ��Ϊ5�ı���
 	 */     
 	ArrayList vodList = metaData.getVodListByTypeId(vodTypeID,10,0);

 	//���û�й�棬���Ĭ��ͼƬ
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
 				
 				// ����������(0:�������縸����1:�����縸��)
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
 	* ������Ŀ
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
					// �Ƿ�������Ŀ��1��������Ŀ��0��������Ŀ
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
	* ͼƬ������Ŀ
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
					// �Ƿ�������Ŀ��1��������Ŀ��0��������Ŀ
					int hasSubType = metaData.getSubTypeOrVod(stypeId);//Integer.parseInt(typeMap.get("hasSubType").toString());
	%>	
					var typeObj = {};
					typeObj.typeId = "<%= stypeId%>";
					typeObj.name = "<%= typeName%>";
					typeObj.hasSubType = <%= hasSubType%>;
					typeObj.img = "<%= type_picpath%>";
					//typeObj.type = "ר��";
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
//������Ŀid
var topTypeID = "<%=topTypeID%>";
//ͼƬ����vod
var vodTypeID = "<%= vodTypeID%>";
//ͼƬ������Ŀ
var imgTypeID = "<%= imgTypeID%>";
//����
var content = "<%=bull%>";
//ҳ��
var javaNeedPage = "<%=needPage%>";
</script>