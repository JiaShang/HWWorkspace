<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="../../common4dtv/jsp/config.jsp" %>
<%@ page import="java.util.*"%>
<%!

public List getAllProdList(){
	StringBuffer strLists = new StringBuffer();
	
	strLists.append("prodCode:100473#comboId:1853#comboName:\"来点播开通产品\"#type:0;");	
	strLists.append("prodCode:100417#comboId:1543#comboName:\"优酷专区\"#type:0;");	strLists.append("prodCode:100464#comboId:1800#comboName:\"中国互联网电视\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1541#comboName:\"搜狐专区\"#type:0;");
	strLists.append("prodCode:100185#comboId:1155#comboName:\"韩剧专区\"#type:0;");
	strLists.append("prodCode:100186#comboId:1160#comboName:\"强档好莱坞\"#type:0;");
	strLists.append("prodCode:100359#comboId:1395#comboName:\"凤凰专区\"#type:0;");
	strLists.append("prodCode:100360#comboId:1382#comboName:\"英美剧专区\"#type:0;");	
	strLists.append("prodCode:100247#comboId:1361#comboName:\"TVB专区\"#type:0;");	
	strLists.append("prodCode:100326#comboId:1386#comboName:\"坝坝舞专区\"#type:0;");
	strLists.append("prodCode:100398#comboId:1529#comboName:\"芒果TV\"#type:0;");
	strLists.append("prodCode:100250#comboId:1418#comboName:\"1T云空间\"#type:0;");
	strLists.append("prodCode:100363#comboId:1418#comboName:\"1T云空间\"#type:0;");
	strLists.append("prodCode:100361#comboId:1419#comboName:\"2T云空间\"#type:0;");
	strLists.append("prodCode:100363#comboId:1419#comboName:\"2T云空间\"#type:0;");
	strLists.append("prodCode:100362#comboId:1420#comboName:\"5T云空间\"#type:0;");
	strLists.append("prodCode:100363#comboId:1420#comboName:\"5T云空间\"#type:0;");

	
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
	String comeType = (String) request.getAttribute("comeType"); //判断回看来源
	String mess = (String) resultMp.get("message");
	String FSNId = (String)resultMp.get("neVodId");
	//String price = (String)resultMp.get("price");
	//String spName = (String)resultMp.get("spName");
	//System.out.println("geninfo_nor FSNId =="+FSNId+",spName=="+spName);
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
		//媒体ID
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
	//Map prodObj = null;
	//String prodCode = "";
	
	
	 List allProdList = getAllProdList();
	 //System.out.println("allProdList="+allProdList);
	 //包月产品列表
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
 
	 
      //按次订购产品列表
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
            // 获取VOD的详情信息
			String proId = (String)resultMp.get("progId");
			int intProgId = Integer.parseInt(proId);
            Map vodDetail = meta.getVodDetailInfo(intProgId);
			//System.out.println("timesList vodDetail="+vodDetail);
            String price = (String)vodDetail.get("VODPRICE");
            price = getPrice(price) + "元";
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

