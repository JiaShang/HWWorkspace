<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData"%>
<html>
<%
	Map resultMp = new HashMap();
	resultMp = (Map) request.getAttribute("resultMp");
	Map authInfoMp = new HashMap();
	authInfoMp = (Map) request.getAttribute("authInfoMp");
	String FSNId = (String) resultMp.get("neVodId");
	String comeType = (String) request.getAttribute("comeType"); //�жϻؿ���Դ
	String mess = (String) resultMp.get("message");
	
	MetaData meta = new MetaData(request);
	//��Ŀ���
	String param_typeId = (String)resultMp.get("typeId");
	String tmpvodId = (String) resultMp.get("progId");
	String tmpPlayType = (String)resultMp.get("playtype");
	//System.out.println("geninfo_ad in param_typeId=="+param_typeId+",tmpvodId="+tmpvodId+",tmpPlayType="+tmpPlayType+",mess="+mess);
	String vodName = "";
	if(!"4".equals(tmpPlayType)){
		
		Map vodMap = meta.getVodDetailInfo(Integer.parseInt(tmpvodId));
		vodName = (String)vodMap.get("VODNAME"); 
		vodName = URLEncoder.encode(vodName, "UTF-8");
	}
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
		playUrl = URLEncoder.encode(playUrl, "GBK");
		playUrl = URLEncoder.encode(playUrl, "GBK");
	    String reportUrl = (String) resultMp.get("reportUrl");
	    //ֱ��ͳ���ϱ�·��
	    if (reportUrl != null) 
	    {
		     reportUrl = URLEncoder.encode(reportUrl, "GBK");
	    }
	    
		
		 //��Ŀ���
        String param_vodId = (String)resultMp.get("progId");
		
		String initIPQAMUrl = (String)authInfoMp.get("IPQAMResURL");
	    String emm = (String) resultMp.get("emm");
		session.setAttribute("MEDIAPLAY", "1");
		url= request.getContextPath() + "/jsp/defaultHD/en/playfilm_ad.jsp?playUrl=" + playUrl 
				+ "&reportUrl=" + reportUrl 
				+ "&emm=" + emm
				+ "&tw_record_template=" +tw_record_template
				+ "&tw_record_flag=" + tw_record_flag
				+ "&comeType=" + comeType
				+ "&param_vodId="+param_vodId
				+ "&initIPQAMUrl="+initIPQAMUrl;
	}
	//request.setAttribute("authInfoMp",authInfoMp);
	//System.out.println("geninfo_ad===========mess"+mess+",playUrl=="+playUrl);
	//��������
	//	playFlag = 0;
%>
<head>
<title></title>
<SCRIPT language="javascript" type="text/javascript">
	//iPanel.eventFrame.initPage(window);	
	
	//��ʽ���� ǰ��Ƭ���λ���룺Pre-ad������Ƭ���λ���룺Post-ad����ͣ���λ���룺Pause-ad���������λ���룺Vol-ad
	var urlPATH = "http://192.168.204.13/communication/";
	var startAdCode = "Pre-ad";    //���λ ǰ��Ƭ����Ƶ��
	var endAdCode = "Post-ad";    //����Ƭ����Ƶ��
	var pauseAdCode = "Pause-ad";   //��ͣ��棨ͼƬ��
	var volumeAdCode = "Vol-ad";   //�������(ͼƬ)
	
	var stbId = hardware.STB.serialNumber;     //������ID
	var logFlag = true;    //�Ƿ���Ҫ��¼�㲥�굥��������  true: ��Ҫ  false: ����Ҫ
	var cardId = CA.card.cardId;    //�����п���
	
	var ipAddress = network.ethernets[0].IPs[0].address;   //��ȡ������ip
	var assetName = "<%= vodName%>";    // urlEncoder(utf-8) ת��
	var columnId = "<%= param_typeId%>";    //ҳ���ȡ
	var smValue = network.ethernets[0].MACAddress;   //smֵ
	
	var requestAjaxObj; //ajax������� ����ǰ��Ƭ
	var startContentId = "";   //���ŵ�startContentId  ˼���ӿڻ�ȡ
	
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
		window.top.location.href = url+"&preId="+startContentId;
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
			getStartContentId();
			//onplay();
		}
		else
		{
			if(window.top.showTipWindow)window.top.showTipWindow("<%=mess%>", 1);
		}
	}
	
	
function getStartContentId(){
	iPanel.debug("geninfo_ad ajaxToGeHua in ");
	var abortFlag = false;
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function (){
		if(XHR.readyState == 4){
			if(XHR.status == 200){
				var tempArr = XHR.responseText.split(",");
				if(typeof(tempArr[1]) != "undefined"){
					startContentId = tempArr[1].replace(/( |��)/gi,'');   // ȡ��startContentId�ֶ�   "3000000120160325002800-30000001";
					//startContentId = "3000001520160520000700-30000015";
				}
				onplay();
			}else{//AJAXû�л�ȡ������
				abortFlag = true;
				XHR.abort();
				onplay();
			}
		}
	}
	//var url =iPanel.eventFrame.pre_epg_url+"/defaultHD/en/datajspHD/queryVodData.jsp?typeID=001000&start=0&size=5&platform=android";
	
	var tmpurl = urlPATH + "adveristing?adLocationCode="+startAdCode+"&oldAdList=&areaCode=&stbId="+stbId+"&ip="+ipAddress+"&assetName="+assetName+"&path=&serviceId=&logInfo="+logFlag+"&columnId="+columnId+"&cardNo="+cardId;
	iPanel.debug("geninfo_ad url=="+tmpurl);
	XHR.open("GET", tmpurl, true);
	XHR.send(null);
	setTimeout("onplay();",3000);
	
}
	
</SCRIPT>
</head>
<body>
</body>
<script type="text/javascript">
	init();
</script>
</html>


