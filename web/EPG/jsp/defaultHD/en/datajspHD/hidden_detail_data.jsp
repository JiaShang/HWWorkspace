<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ page language="java" pageEncoding="GBK" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@	page import="java.util.List"%>
<%@	page import="java.util.Map"%>
<%@ include file="util.jsp" %>
<script language="javascript">
<%
    String for_back_flag = request.getParameter("for_play_back");
	
	if("1".equals(for_back_flag)){
		String back_url = request.getParameter("appBackUrl");
%>
		window.location.href = "<%=back_url%>";
<%
	}
	else{
	
		/*  ��ȡ�����Ƽ���־λ  */
		TurnPage turnPage = new TurnPage(request);
		turnPage.addUrl();
		
		/*  ��ȡ��Ŀ���  */
		String vodTempId = request.getParameter("vodId");
		/*  ��ȡ��Ŀ���  */
		String typeId = request.getParameter("typeId");
		
		if(null == typeId || "".equals(typeId)){
			typeId = "-1";
		}
		/*��ȡ��ǩ*/
		String starttime = request.getParameter("startTime");
		if(null == starttime || "".equals(starttime)){
			starttime = "0";
		}
		/*���ӽ���*/
		String baseFlag = request.getParameter("baseFlag");
        if(baseFlag == null || !"0".equals(baseFlag))
        {
            //baseFlag="0" ʱ����Ҫ�жϻ�������ֱ�ӷ���true
           baseFlag = "";
        }
		/*��ȡ��������*/
		String playType = request.getParameter("playType");
		if(null == playType || "".equals(playType)){
			playType = "1";
		}
		
		
		/*�Ƿ�����idת��*/
		String idType = request.getParameter("idType");
		
		if(null == idType || "".equals(idType)){
			idType = "";
		}
		
		String FSNTypeId = request.getParameter("FSNTypeId");
		
		if(null == FSNTypeId || "".equals(FSNTypeId)){
			FSNTypeId = "";
		}
		
		String go_url = "";
		if(playType.equals("11") && !idType.equals("FSN")){//���ݵ��Ӿ��Ӽ�һ����ת;
			MetaData meta = new MetaData(request);
			int vodId = Integer.parseInt(vodTempId);
			meta.getVodDetailInfo(vodId);
			//System.out.println("zenglt hidden vodId"+vodId);
			HashMap vodDetatlMap = (HashMap)meta.getVodDetailInfo(vodId);
			Integer parentId = ((Integer)vodDetatlMap.get("FATHERVODID")).intValue();
			String fjid = Integer.toString(parentId);
			go_url = "/EPG/jsp/defaultHD/en/Authorization.jsp?idType="+idType+"&typeId="+typeId + "&playType="+playType
						+"&progId="+vodTempId +"&parentVodId="+ fjid+"&contentType=0&business=1&startTime="+starttime+"&FSNTypeId="+FSNTypeId;  
		}else{
			go_url = "/EPG/jsp/defaultHD/en/Authorization.jsp?idType="+idType+"&typeId="+typeId + "&playType="+playType
						+"&progId="+vodTempId + "&contentType=0&business=1&startTime="+starttime+"&FSNTypeId="+FSNTypeId;
		}
						
		if("0".equals(baseFlag)){
			go_url += "&baseFlag="+baseFlag;
		}
		
	
%>
		iPanel.eventFrame.is_HD_vod = true;
		window.location.href = "<%=go_url%>";
<%
	}
%>
</script>