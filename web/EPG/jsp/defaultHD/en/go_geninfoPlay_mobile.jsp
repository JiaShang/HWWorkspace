<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="../../common4dtv/jsp/config.jsp" %>
<%@ page import="java.util.*"%>
<%!

public List getAllProdList(){
	StringBuffer strLists = new StringBuffer();
	
	strLists.append("prodCode:100473#comboId:1853#comboName:\"���㲥��ͨ��Ʒ\"#type:0;");	
	strLists.append("prodCode:100417#comboId:1543#comboName:\"�ſ�ר��\"#type:0;");	strLists.append("prodCode:100464#comboId:1800#comboName:\"�й�����������\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1541#comboName:\"�Ѻ�ר��\"#type:0;");
	strLists.append("prodCode:100185#comboId:1155#comboName:\"����ר��\"#type:0;");
	strLists.append("prodCode:100186#comboId:1160#comboName:\"ǿ��������\"#type:0;");
	strLists.append("prodCode:100359#comboId:1395#comboName:\"���ר��\"#type:0;");
	strLists.append("prodCode:100360#comboId:1382#comboName:\"Ӣ����ר��\"#type:0;");	
	strLists.append("prodCode:100247#comboId:1361#comboName:\"TVBר��\"#type:0;");	
	strLists.append("prodCode:100326#comboId:1386#comboName:\"�Ӱ���ר��\"#type:0;");
	strLists.append("prodCode:100398#comboId:1529#comboName:\"â��TV\"#type:0;");
	strLists.append("prodCode:100250#comboId:1418#comboName:\"1T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100363#comboId:1418#comboName:\"1T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100361#comboId:1419#comboName:\"2T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100363#comboId:1419#comboName:\"2T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100362#comboId:1420#comboName:\"5T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100363#comboId:1420#comboName:\"5T�ƿռ�\"#type:0;");

	
	String[] array = (strLists.toString()).split(";");
	ArrayList<Map> tmpList = new ArrayList<Map>();
	for(int i = 0 ; i < array.length; i++){
		HashMap<String, String> tmpMap = new HashMap<String, String>();
		String[] tmparr = array[i].split("#");
		for(int j = 0; j < tmparr.length; j++){
			String[] curarr = tmparr[j].split(":");
			if(curarr[0].equals("webUrl"))curarr[1] = "\"http://"+curarr[1];
			tmpMap.put(curarr[0], curarr[1]);
		}
		tmpList.add(tmpMap);
	}
	return tmpList;
}

%>
<%
	//System.out.println("go geninfoPlayin=");
	Map resultMp = new HashMap();
	resultMp = (Map) request.getAttribute("resultMp");
	String comeType = (String) request.getAttribute("comeType"); //�жϻؿ���Դ
	String mess = (String) resultMp.get("message");
	String FSNId = (String)resultMp.get("neVodId");
	//String price = (String)resultMp.get("price");
	//String spName = (String)resultMp.get("spName");
	//System.out.println("geninfo_nor FSNId =="+FSNId+",spName=="+spName);
	if(mess == null)
	{
		mess = "����ʧ��";
	}
		
	Object confirmMarkObj = resultMp.get("confirmMark");//����Ƿ��߹����ζ�������
	boolean confirmMark = (null != confirmMarkObj);
	
	Object o = resultMp.get("Anci_flag");
	String Anci_flag = null;
	if(null != o)
	{
		Anci_flag = o.toString();
	}
	

	
	// ���������Ȩҳ����ת·��
	String confirmUrl = "";
	
	//������صĴ���������Ҫ������,�������û���������
	if("Anci_flag".equals(Anci_flag))
	{
		//��Ŀ���
		String vodId = (String) resultMp.get("progId");
		//�������(���õ��Ӿ�)
		String supVodId = (String) resultMp.get("parentVodId");
		//��������
		String contentType = (String) resultMp.get("contentType");
		//ҵ������
		String businessType = (String) resultMp.get("businessType");
		//��Ʒ����
		Map prodObj = (Map)resultMp.get("prodObj");
		//��Ʒ���
		String prodcode = (String)prodObj.get("PROD_CODE");
		//������
		String serviceId = (String)prodObj.get("SERVICE_CODE");
		//������ʶ
		String continueType = ((Integer)prodObj.get("PROD_CONTINUEABLE")).toString();
		// ��С���ڲ���Ƭ��ʱ�贫��˲�������trickmode�Ĳ���
		String tkmode = (String)resultMp.get("tkmode");
		// ��С���ڲ���Ƭ��ʱ�贫��˲�������osd����ʾ
		String osd = (String)resultMp.get("osd");
		//��������
		String playType = (String)resultMp.get("playtype");
		//Ƶ�����
		String chanId = (String)resultMp.get("chanId");
		//��Ŀ���
		String typeId = (String)resultMp.get("typeId");
		//���ŵĿ�ʼʱ��
		String startTime = (String)resultMp.get("starttime");
		//ý��ID
		String mediaId = (String)resultMp.get("mediaId");
	
		confirmUrl = request.getScheme() + "://" + request.getServerName()
                     + ":" + request.getServerPort() + request.getContextPath() + "/jsp/defaultHD/en/Confirm_nor.jsp?"
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
							 ;
		                
		       //System.out.println("geninfo_nor confirmUrl = " + confirmUrl);  
					
		   //System.out.println("confirmUrl = " + confirmUrl);         
	}
	 

	//�Ƿ���Բ��ű�ʶ
	int playFlag = 0;
	int anCiFlag = 0;
	String url = "";
	
	/* ��ͼ�����ҳ�淵����Ҫ�Ĳ��� */
	String tw_record_template = (String) resultMp.get("tw_record_template");
	String tw_record_flag = (String) resultMp.get("tw_record_flag");
	
	
	
	//ӰƬ�Ĳ��ŵ�ַ
	String playUrl = (String)resultMp.get("playUrl");
	String json ="";
	//Map prodObj = null;
	//String prodCode = "";
	
	
	 List allProdList = getAllProdList();
	 //System.out.println("allProdList="+allProdList);
	 //���²�Ʒ�б�
	 List monthList = (List)resultMp.get("MONTH_LIST");
	 //String prodList = "[";
	 ArrayList<Map> prodList = new ArrayList<Map>();
	 
	if(null != monthList && monthList.size() > 0)
	{
		//System.out.println("geninfo monthList.size()="+monthList.size());
		for(int i=0;i<monthList.size();i++)
		{
			Map tmpObj = (Map)monthList.get(i);
			String prodName = (String)tmpObj.get("PROD_NAME");
			String prodCode = (String)tmpObj.get("PROD_CODE");
			String serCode = (String)tmpObj.get("SERVICE_CODE");
			/*String tmpStr = "{prodName:\""+prodName+"\""+",prodCode:\""+prodCode+"\"}";
			if(i<monthList.size()-1) tmpStr +=",";
			prodList+=tmpStr;
			*/
			//System.out.println("ByMonth prodCode=="+prodCode+",,serCode="+serCode+",,prodName="+prodName);
			for(int j=0;j<allProdList.size();j++){
				Map tmpMap = (Map)allProdList.get(j);
				String tmpCode = (String)tmpMap.get("prodCode");
				if(prodCode.equals(tmpCode)){
					//System.out.println("prodCode="+prodCode+",tmpCode="+tmpCode);
					String vodId = (String) resultMp.get("progId");
					String typeId = (String)resultMp.get("typeId");
					String playType = (String)resultMp.get("playtype");
					String parentVodId = (String) resultMp.get("parentVodId");
					tmpMap.put("vodId",vodId);
					tmpMap.put("typeId","\""+typeId+"\"");
					tmpMap.put("playType",playType);
					tmpMap.put("parentVodId",parentVodId);
					tmpMap.put("FSNId","\""+FSNId+"\"");
					/*if("100185".equals(prodCode)||"100359".equals(prodCode)||"100360".equals(prodCode)){
						tmpMap.put("type","1");
					}else{
						tmpMap.put("type","0");
					}*/
					prodList.add(tmpMap);
				}
			}
		}	
	}
 
	 
      //���ζ�����Ʒ�б�
    List timesList = (List)resultMp.get("TIMES_LIST");
	if(null != timesList && timesList.size() > 0)
	{
		//System.out.println("timesList.size()="+timesList.size());
		for(int i=0;i<timesList.size();i++)
		{
			Map tmpObj = (Map)timesList.get(i);
			String prodCode = (String)tmpObj.get("PROD_CODE");
			
			//System.out.println("timeList="+tmpObj);
			MetaData meta = new MetaData(request);
            // ��ȡVOD��������Ϣ
			String proId = (String)resultMp.get("progId");
			int intProgId = Integer.parseInt(proId);
            Map vodDetail = meta.getVodDetailInfo(intProgId);
			//System.out.println("timesList vodDetail="+vodDetail);
            String price = (String)vodDetail.get("VODPRICE");
            price = getPrice(price) + "Ԫ";
			String spName = (String) vodDetail.get("SPNAME");
			spName = spName.trim();
			//System.out.println("price="+price+",spName=="+spName);
			String code = (String) vodDetail.get("CODE");
			
			//System.out.println("ByTimes prodCode=="+prodCode);
			for(int j=0;j<allProdList.size();j++){
				Map tmpMap = (Map)allProdList.get(j);
				String tmpCode = (String)tmpMap.get("prodCode");
				if(prodCode.equals(tmpCode)){
					//System.out.println("prodCode="+prodCode+",tmpCode="+tmpCode);
					tmpMap.put("price","\""+price+"\"");
					/*if(prodCode.equals("401000")){
						tmpMap.put("buyUrl",confirmUrl);
					}*/
					tmpMap.put("FSNId","\""+code+"\"");
					tmpMap.put("spName","\""+spName+"\"");
					prodList.add(tmpMap);
				}
			}
		}	
	}
	//System.out.println("prodList="+prodList);
	
	String vodId = (String) resultMp.get("progId");
	String typeId = (String)resultMp.get("typeId");
	//ӰƬ�ɲ���
	if (playUrl != null && !"".equals(playUrl))
	{
		playFlag = 1;
		String reportUrl = (String) resultMp.get("reportUrl");
		String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",playUrl:\""+playUrl+"\""+",reportUrl:\""+reportUrl+"\"}";
   }else if("Anci_flag".equals(Anci_flag)){
   		anCiFlag = 1;
	    String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",message:\""+mess+"\""+",prodList:"+prodList+"}";
		json = json.replaceAll("=",":");
   }else{
	    String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",message:\""+mess+"\""+",prodList:"+prodList+"}";
		json = json.replaceAll("=",":");
   }
   //System.out.println("json="+json);
%>
<%=json %>

