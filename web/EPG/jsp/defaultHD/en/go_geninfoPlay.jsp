<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.*"%>

<%
	Map resultMp = new HashMap();
	resultMp = (Map) request.getAttribute("resultMp");
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
	
			confirmUrl = request.getContextPath() + "/jsp/defaultHD/en/Confirm.jsp?"
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
						 + "&startTime=" + startTime;
					
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
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",message:\""+mess+"\""+",confirmUrl:\""+confirmUrl+"\"}";
	}else{
	    String splayFlag = Integer.toString(playFlag);
		json +="{playFlag:\""+splayFlag+"\""+",anCiFlag:\""+anCiFlag+"\""+",message:\""+mess+"\"}";
   }
%>

<%=json %>

