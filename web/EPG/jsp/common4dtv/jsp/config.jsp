<%@ page contentType="text/html; charset=GBK" language="java" pageEncoding="GBK" %>
<%@ page import="java.util.*" %>
<%!
  public String getPrice(String price)
	{
		String realPrice = "0";
		if(null != price && !"".equals(price))
		{
			float tempPrice = Float.valueOf(price);
			tempPrice = tempPrice / 100;
			realPrice = String.valueOf(tempPrice);
		}
		return realPrice;
	}
/****************************** EPGϵͳ�������� ******************************/
	
	/** EPG��ҳ��¼��ַ */
	String EPG_CATEGORY = "Category.jsp";
	
	/** Ĭ��SERVICE_GROUPID */
	String DEFAULT_SERVICE_GROUPID = "32768";
	
	/** Ĭ��RECORDFORMAT */
	String DEFAULT_RECORDFORMAT = "MPEG-2";
	
	/** ������Ĭ��֧�ֵ��������� */
	String DEFAULT_SUPPORTNET = "Cable";
	
	/** Ĭ�Ͻ��뷽ʽ */
	String DEFAULT_CONNTYPE = "2";
	
	/** Ĭ�ϼ��ܷ�ʽ */
	String DEFAULT_ENCRYPT = "0";
	
	/** EPGģ���������� */
	String[] MODULE_LANGUAGES = new String[] {"en", "cn"};
	
	/** EPGĬ��ģ�� */
	String DEFAULT_TEMPLATE_NAME = "defaultDTV";
	
	/** EPG����ģ�� */
	String HIGHT_TEMPLATE_NAME = "hightDTV";
	
	/** EPGĬ������ */
	String DEFAULT_LANGUAGE = "en";
	
	/** ������Ʒ����� "005", "jysp1BTV", "jysp2BTV", "3214", "134334"*/ 
	String[] BASIC_PRODUCT_IDS = new String[] {"100000"};
	/** ������������֤����Ŀ��� */
	String[] NOT_BASIC_TYPES = {"10000100000000090000000000001000","10000100000000090000000000100004"};
	
	/** �����Ŀ��� */
	String[] FREE_TYPES = new String[] {};
	
	/** �������ԣ�Ĭ�϶���Ϊ����---����:Bytimes,����:ByMonth*/
	String orderType = "Bytimes";

	/** Ĭ�ϵĶ�����ʽ */
	int DEFAULT_SUBSCRIBE_ORDER = 1;
	
	/** Client3.0ʱ�Ĳ��� */
	/** ���Ӳ���ģʽ */
	/** �����������/��ѭ������(VOD/ʱ��) */
	int PLAY_MODEL_1 = 1;

	/** ������/�˳�����������������������/ѭ������(Ƭ������) */
	int PLAY_MODEL_2 = 2;

	/** �������/����/��ͣ/�˳�����������������������/��ѭ������(��沥��) */
	int PLAY_MODEL_3 = 3;
	
 /************************* �������� *****************************/
  public static final int PLAYTYPE_VOD = 1;   //vod����
  public static final int PLAYTYPE_BOOKMARK = 6;   //��ǩ
  public static final int PLAYTYPE_TVOD = 4;       //TVOD����
  //public static final int PLAYTYPE_NPVR = 11;      //NPVR��������,���ò�������
  public static final int PLAYTYPE_ASSESS = 5;     //Ƭ������
  public static final int PLAYTYPE_SITCOM = 11;    //���Ӿ�Ĳ�������,���ò������ݴ���
	
/************************* ��¼��Ȩ������Ϣ������ӳ����Ϣ ***************************/
	
	/** ��֤ʧ�� */
	int LOGIN_AUTH_FAIL = 0x07010001;
	String LOGIN_AUTH_FAIL_MESS = "��֤ʧ��";
	
  /** �û�״̬������ */
  int LOGIN_USER_STATE_ABNORMAL = 0x07010002;
  String LOGIN_USER_STATE_ABNORMAL_MESS = "�û�״̬������";
	
  /** STB��У��ʧ�� */
  int LOGIN_STB_VERIFY_FAIL = 0x07010003;
  String LOGIN_STB_VERIFY_FAIL_MESS = "STB��У��ʧ��";
	
  /** STB��ʧ�� */
  int LOGIN_STB_BIND_FAIL = 0x07010004;
  String LOGIN_STB_BIND_FAIL_MESS = "STB��ʧ��";
	
  /** �û���Ϣ��ѯʧ�� */
  int LOGIN_USEINFO_QUERY_FAIL = 0x07010006;
  String LOGIN_USEINFO_QUERY_FAIL_MESS = "�û���Ϣ��ѯʧ��";
	
  /** ������MAC��ַ������ */
  int LOGIN_MAC_ERROR = 0x07010007;
  String LOGIN_MAC_ERROR_MESS = "������MAC��ַ������";
    
  /** �û�IC�������� */
  int LOGIN_CARD_ERROR = 0x07010008;
  String LOGIN_CARD_ERROR_MESS = "�û�IC��������";
    
  /** �û������ڻ�������� */
  int LOGIN_USERPWD_ERROR = 0x07010009;
  String LOGIN_USERPWD_ERROR_MESS = "�û������ڻ��������";
    
  /** ���ݿ��쳣 */
  int LOGIN_DB_EXCEPTION = 0x07010100;
  String LOGIN_DB_EXCEPTION_MESS = "���ݿ��쳣";
    
	/** �����쳣 */
  int LOGIN_WEB_EXCEPTION = 0x07010200;
  String LOGIN_WEB_EXCEPTION_MESS = "�����쳣";
	
	/** ������ý���ʽ����������û��ͬʱ���� */
  int LOGIN_STB_WEB = 0x07020009;
  String LOGIN_STB_WEB_MESS = "������ý���ʽ����������û��ͬʱ����";
	
	/** ������ý���ʽ�������������� */
  int LOGIN_STB_WEB_ERROR = 0x0716100A;
  String LOGIN_STB_WEB_ERROR_MESS = "������ý���ʽ��������������";
	
/************************* ������Ȩ������Ϣ������ӳ����Ϣ ***************************/
	
	/** û�ж��������� */
	public static final int AUTH_FAIL_NO_ORDERBASE = -102;
	
	/** ��Ȩ���Ϊ�� */
	public static final int AUTH_RESULT_ISNULL = -101;
	
	/** ��Ȩʧ�ܣ�������ѯ�ɹ� */
  //public static final int AUTH_FAIL_QUERYOK = 0x07020002;
	
	//��Ȩʧ��,����Ȼ�в�Ʒ���Զ���
	public static final int AUTH_FAIL_QUERYOK = 0x07020002;
	
	//��Ȩʧ��,����Ȼ�в�Ʒ���Զ���,IPTV���ظ��������
	public static final int AUTH_FAIL_QUERYOK_IPTV = 504;
	
	/* ӰƬ������ */
	public final static int AUTH_VOD_NOTEXISTS = 0x07161001;
	
	/* û�ж�����Ʒ */
	public final static int AUTH_FAIL_NO_ORDER = 0x07020005;
	
	/** �����ɹ� */
	public static final int OPER_SUCESS = 0;
%>
<%

/************************** ������Ȩ���󷵻��뼰��Ϣӳ�� ****************************/
	
	/** ��Ȩ������Ϣӳ��� */
	Map errorMap = new HashMap();
	
	/** ��ʱ�������� */
	int n = 0;
	
	String errorCode = "";
	
	n = 0x07010002;
	errorCode = "��֤ʱ�û�״̬������";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x0702000A;
	errorCode = "�����в�֧��CA����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010001;
	errorCode = "��֤ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010007;
	errorCode = "������MAC��ַ������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010008;
	errorCode = "�û�IC��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010200;
	errorCode = "ʱ�����������ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010009;
	errorCode = "�û��������ڻ��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020001;
	errorCode = "�޿ɶ�����Ʒ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020002;
	errorCode = "��Ȩʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020003;
	errorCode = "��Ȩ��ѯʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020004;
	errorCode = "��Ȩ��ѯ�ɹ�";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020005;
	errorCode = "��Ȩʧ�ܣ�û�ж�����Ʒ.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020006;
	errorCode = "��Դ����ʱ��Ŀ���ʲ�������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020007;
	errorCode = "NGODʱ����Ȩʱ����Ŀ���Ŀ�ʼʱ����ڵ�ǰʱ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020008;
	errorCode = "�û�δ��ͨ����ҵ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020100;
	errorCode = "���ݿ��쳣";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020200;
	errorCode = "������ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120001;
	errorCode = "��Դ����ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120002;
	errorCode = "��Դ���볬ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120005;
	errorCode = "����IPQAM��Դʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120007;
	errorCode = "��Դ����SOAP�ӿڵ���ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120009;
	errorCode = "û���ҵ���Ӧ�ĵ㲥������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120010;
	errorCode = "License����,�޷����е㲥";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07150008;
	errorCode = "��Դ�����������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160001;
	errorCode = "��Ȩ�㲥ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160002;
	errorCode = "��Ȩ�㲥��ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160007;
	errorCode = "�������ʹ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160008;
	errorCode = "Ƶ����Ŵ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161001;
	errorCode = "ӰƬ������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161002;
	errorCode = "��Ŀ��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161003;
	errorCode = "Ƶ��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161004;
	errorCode = "Ƶ����֧��ʱ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161005;
	errorCode = "Ƶ����֧��¼��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020009;
	errorCode = "�����в�֧�ָø�ʽ";
	errorMap.put(new Integer(n), errorCode);
	
  // �����ӿڴ���
	n = 0x07030001;
	errorCode = "����ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030002;
	errorCode = "�ò�Ʒ����Ϊ���ڶ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030003;
	errorCode = "��Ʒ������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030004;
	errorCode = "�û���Ŵ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030005;
	errorCode = "�û���Ų�����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030006;
	errorCode = "�û�״̬����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030007;
	errorCode = "δ��ͨVOD����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030008;
	errorCode = "��Ʒ��Ŵ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030009;
	errorCode = "��Ʒ���ʹ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07031000;
	errorCode = "�û��Ѷ������ò�Ʒ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030011;
	errorCode = "������ʶ����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030012;
	errorCode = "�۷�ʱ�����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030013;
	errorCode = "vod��Ʒ״̬����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030014;
	errorCode = "�������Ϊ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030015;
	errorCode = "�û��˻�����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030016;
	errorCode = "�ò�Ʒ����Ϊ���¶���";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07030017;
	errorCode = "�û�������ʱ��Ҫ������Ȩ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030100;
	errorCode = "���ݿ��쳣";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030200;
	errorCode = "�����쳣";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020200;
	errorCode = "������ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120001;
	errorCode = "��Դ����ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120002;
	errorCode = "��Դ���볬ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120003;
	errorCode = "ӰƬ������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120004;
	errorCode = "��Ʒ���ʹ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120005;
	errorCode = "����IPQAM��Դʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120006;
	errorCode = "Ԥ����ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120007;
	errorCode = "��Դ����SOAP�ӿڵ���ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120008;
	errorCode = "Ԥ���ѽӿ�ʱSOAP�ӿ�ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120009;
	errorCode = "û���ҵ���Ӧ�ĵ㲥������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120010;
	errorCode = "License����,�޷��ٽ��е㲥";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07150008;
	errorCode = "��Դ�����������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160007;
	errorCode = "�������ʹ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020009;
	errorCode = "ý���ʽ����";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07170001;
	errorCode = "¼��ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170002;
	errorCode = "¼�Ƴ�ʱ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170003;
	errorCode = "¼�Ʋ�������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170004;
	errorCode = "¼�����ݿ��ѯ����";
	errorMap.put(new Integer(n), errorCode);
   
	n = 0x07170005;
	errorCode = "��Ŀ�Ѳ�����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170006;
	errorCode = "��Ŀ�ѱ�¼��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170007;
	errorCode = "��Ŀ�Ѳ�����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170008;
	errorCode = "����¼�ƿռ䲻��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170009;
	errorCode = "��û�ж���[��������¼��],�뵽Ӫҵ������.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170010;
	errorCode = "�û�������.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170011;
	errorCode = "û��¼�ƽ�Ŀ.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170012;
	errorCode = "�û�״̬������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170013;
	errorCode = "δ��ͨ[��������¼��],�뵽Ӫҵ������.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160008;
	errorCode = "Ƶ����Ŵ���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161002;
	errorCode = "��Ŀ��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161003;
	errorCode = "Ƶ��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161006;
	errorCode = "Ƶ����֧�ָ�������¼��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020009;
	errorCode = "�����в�֧�ָ�����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161009;
	errorCode = "��Ŀ��֧�ָ�������¼��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200001;
	errorCode = "���û�û�ж�����Ʒ��Ȩ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200002;
	errorCode = "�޷����ҵ��û���Ϣ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200003;
	errorCode = "�û���Ϣ����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200004;
	errorCode = "�����û���Ϣʱ����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200005;
	errorCode = "��Ʒ״̬����ȷ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200006;
	errorCode = "�����ڴ˲�Ʒ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200007;
	errorCode = "���Ҳ�Ʒ��Ϣʱ����";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200008;
	errorCode = "Ԥ�����û����ܶ��������޴β�Ʒ";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200009;
	errorCode = "�û�����֧��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x0720000A;
	errorCode = "VOD��Ʒ����ʧ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x0720000C;
	errorCode = "���µ㲥�ķ����ѳ������öȵȼ����涨���޶��㲥���";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130001;
	errorCode = "����Ĳ�������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130002;
	errorCode = "û�������л������Ľ�Ŀ��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130003;
	errorCode = "Ƶ��������";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130004;
	errorCode = "Ƶ����֧��¼��";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130005;
	errorCode = "ϵͳ��������״̬";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07130006;
	errorCode = "��ǰ�û�Ϊ�����û��������µ�¼";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07140001;
	errorCode = "����Ĳ�������";
	errorMap.put(new Integer(n), errorCode);
   
	n = 0x07140002;
	errorCode = "��Ŀ��������";
	errorMap.put(new Integer(n), errorCode);
   
	n = 0x08020005;
	errorCode = "����ݲ�����";
  errorMap.put(new Integer(n), errorCode);
   	
  n = 0x716100B;
  errorCode = "δ֪����";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07000005;
    errorCode = "��������";
	errorMap.put(new Integer(n), errorCode);
	
	n = -1;
    errorCode = "������Ȩʧ��";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x02030001;
    errorCode = "����ʧ��";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x02150002;
    errorCode = "�㲥ʱ, ��ȡIPQAM��Դʧ��";
	errorMap.put(new Integer(n), errorCode);
%>
