<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.*"%>
<html>
	<%
		Map resultMp = new HashMap();
		resultMp = (Map) request.getAttribute("resultMp");
		String FSNId = (String) resultMp.get("neVodId");
		String comeType = (String) request.getAttribute("comeType"); //�жϻؿ���Դ
		String mess = (String) resultMp.get("message");
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
        
   		String hj_yyt ="";
		Object hjyyt = resultMp.get("hj_yyt");//��������ת����Ӫҵ��
		if(null != hjyyt)
		{
			hj_yyt = hjyyt.toString();
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
			//System.out.println("geninfo mediaId=="+mediaId);
	    
		        confirmUrl = request.getScheme() + "://" + request.getServerName()
                     + ":" + request.getServerPort() + request.getContextPath() + "/jsp/defaultHD/en/Confirm.jsp?"
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
							  + "&neVodId=" + FSNId;
		                
		       //System.out.println("geninfo Anci_flag confirmUrl = " + confirmUrl);         
        }
		 

    //�Ƿ���Բ��ű�ʶ
		int playFlag = 0;

		String url = "";
		
		/* ��ͼ�����ҳ�淵����Ҫ�Ĳ��� */
    String tw_record_template = (String) resultMp.get("tw_record_template");
	  String tw_record_flag = (String) resultMp.get("tw_record_flag");

    //ӰƬ�Ĳ��ŵ�ַ
    String playUrl = (String)resultMp.get("playUrl");

		//ӰƬ�ɲ���
		if (playUrl != null && !"".equals(playUrl))
		{
			playFlag = 1;
			//System.out.println("playUrl = " + playUrl);   
			playUrl = URLEncoder.encode(playUrl, "GBK");
			playUrl = URLEncoder.encode(playUrl, "GBK");
	    String reportUrl = (String) resultMp.get("reportUrl");
	    //ֱ��ͳ���ϱ�·��
	    if (reportUrl != null) 
	    {
		     reportUrl = URLEncoder.encode(reportUrl, "GBK");
	    }
	    
	    String emm = (String) resultMp.get("emm");
			session.setAttribute("MEDIAPLAY", "1");
			url= request.getContextPath() + "/jsp/defaultHD/en/playfilm.jsp?playUrl=" + playUrl 
					+ "&reportUrl=" + reportUrl 
					+ "&emm=" + emm
					+ "&tw_record_template=" +tw_record_template
				  + "&tw_record_flag=" + tw_record_flag
				  + "&comeType=" + comeType;
		}
		//System.out.println("geninfo play url = " + url); 
		//��������
	//	playFlag = 0;
	%>
<head>
<title></title>
<SCRIPT language="javascript" type="text/javascript">
	
	//ӰƬ�Ƿ�ɲ��ű�ʶ
	var hj_yyt = "<%= hj_yyt%>";
	var playFlag = <%= playFlag%>; 
	var url = "<%= url%>";
	var Anci_flag = "<%= Anci_flag%>";
	window.top.confirmMark = <%= confirmMark%>;
	iPanel.eventFrame.comfirmUrl = "<%=confirmUrl%>";
	
	//����ǰ����Ȩ������Ϣ
	function callparent()
	{
	//	var oper = "<1%= oper%>";
	//	var playtype= "<1%= playtype%>";
		
		if(Anci_flag == "Anci_flag") 
		{
			/* �����շѱ�ʶ  */
			window.top.anCiFlag = 1;
			/* �����շ�ת��·��   */
			window.top.confirmUrl = "<%=confirmUrl%>";
			/* ��ʾ��ʾ�� */
			if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 2);
		}
		else /*��ʾ��ʾ��*/
		{
			if(hj_yyt == "hj_yyt"){
				if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 3);
			}else{
				if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 1);
			}
		}
	}
	
	/**����*/
	function onplay()
	{
		window.top.location.href = url;
	}
	
	function init()
	{
		/**��Ȩʧ�ܣ�������ʾ��*/
		if(playFlag == 0)
		{	
			callparent();
		}
		
		/**��Ȩ�ɹ�*/
		else if(playFlag == 1)
		{
			onplay();
		}
		else
		{
			if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 1);
		}
	}
</SCRIPT>
</head>
<body>
</body>
<script type="text/javascript">
	init();
</script>
</html>


