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
/****************************** EPG系统参数配置 ******************************/
	
	/** EPG首页登录地址 */
	String EPG_CATEGORY = "Category.jsp";
	
	/** 默认SERVICE_GROUPID */
	String DEFAULT_SERVICE_GROUPID = "32768";
	
	/** 默认RECORDFORMAT */
	String DEFAULT_RECORDFORMAT = "MPEG-2";
	
	/** 机顶盒默认支持的网络能力 */
	String DEFAULT_SUPPORTNET = "Cable";
	
	/** 默认接入方式 */
	String DEFAULT_CONNTYPE = "2";
	
	/** 默认加密方式 */
	String DEFAULT_ENCRYPT = "0";
	
	/** EPG模板语言配置 */
	String[] MODULE_LANGUAGES = new String[] {"en", "cn"};
	
	/** EPG默认模板 */
	String DEFAULT_TEMPLATE_NAME = "defaultDTV";
	
	/** EPG高清模板 */
	String HIGHT_TEMPLATE_NAME = "hightDTV";
	
	/** EPG默认语言 */
	String DEFAULT_LANGUAGE = "en";
	
	/** 基本产品包编号 "005", "jysp1BTV", "jysp2BTV", "3214", "134334"*/ 
	String[] BASIC_PRODUCT_IDS = new String[] {"100000"};
	/** 跳过基本包验证的栏目编号 */
	String[] NOT_BASIC_TYPES = {"10000100000000090000000000001000","10000100000000090000000000100004"};
	
	/** 免费栏目编号 */
	String[] FREE_TYPES = new String[] {};
	
	/** 订购策略：默认订购为按次---按次:Bytimes,包月:ByMonth*/
	String orderType = "Bytimes";

	/** 默认的订购方式 */
	int DEFAULT_SUBSCRIBE_ORDER = 1;
	
	/** Client3.0时的参数 */
	/** 盒子播放模式 */
	/** 允许基本操作/非循环播放(VOD/时移) */
	int PLAY_MODEL_1 = 1;

	/** 允许播放/退出，不允许其他基本操作；/循环播放(片花播放) */
	int PLAY_MODEL_2 = 2;

	/** 允许快退/播放/暂停/退出，不允许其他基本操作；/非循环播放(广告播放) */
	int PLAY_MODEL_3 = 3;
	
 /************************* 播放类型 *****************************/
  public static final int PLAYTYPE_VOD = 1;   //vod播放
  public static final int PLAYTYPE_BOOKMARK = 6;   //书签
  public static final int PLAYTYPE_TVOD = 4;       //TVOD播放
  //public static final int PLAYTYPE_NPVR = 11;      //NPVR播放类型,暂用测试数据
  public static final int PLAYTYPE_ASSESS = 5;     //片花播放
  public static final int PLAYTYPE_SITCOM = 11;    //电视剧的播放类型,暂用测试数据代替
	
/************************* 登录授权错误信息返回码映射信息 ***************************/
	
	/** 认证失败 */
	int LOGIN_AUTH_FAIL = 0x07010001;
	String LOGIN_AUTH_FAIL_MESS = "认证失败";
	
  /** 用户状态不正常 */
  int LOGIN_USER_STATE_ABNORMAL = 0x07010002;
  String LOGIN_USER_STATE_ABNORMAL_MESS = "用户状态不正常";
	
  /** STB绑定校验失败 */
  int LOGIN_STB_VERIFY_FAIL = 0x07010003;
  String LOGIN_STB_VERIFY_FAIL_MESS = "STB绑定校验失败";
	
  /** STB绑定失败 */
  int LOGIN_STB_BIND_FAIL = 0x07010004;
  String LOGIN_STB_BIND_FAIL_MESS = "STB绑定失败";
	
  /** 用户信息查询失败 */
  int LOGIN_USEINFO_QUERY_FAIL = 0x07010006;
  String LOGIN_USEINFO_QUERY_FAIL_MESS = "用户信息查询失败";
	
  /** 机顶盒MAC地址不存在 */
  int LOGIN_MAC_ERROR = 0x07010007;
  String LOGIN_MAC_ERROR_MESS = "机顶盒MAC地址不存在";
    
  /** 用户IC卡不存在 */
  int LOGIN_CARD_ERROR = 0x07010008;
  String LOGIN_CARD_ERROR_MESS = "用户IC卡不存在";
    
  /** 用户不存在或密码错误 */
  int LOGIN_USERPWD_ERROR = 0x07010009;
  String LOGIN_USERPWD_ERROR_MESS = "用户不存在或密码错误";
    
  /** 数据库异常 */
  int LOGIN_DB_EXCEPTION = 0x07010100;
  String LOGIN_DB_EXCEPTION_MESS = "数据库异常";
    
	/** 网络异常 */
  int LOGIN_WEB_EXCEPTION = 0x07010200;
  String LOGIN_WEB_EXCEPTION_MESS = "网络异常";
	
	/** 机顶盒媒体格式和网络能力没有同时存在 */
  int LOGIN_STB_WEB = 0x07020009;
  String LOGIN_STB_WEB_MESS = "机顶盒媒体格式和网络能力没有同时存在";
	
	/** 机顶盒媒体格式和网络能力错误 */
  int LOGIN_STB_WEB_ERROR = 0x0716100A;
  String LOGIN_STB_WEB_ERROR_MESS = "机顶盒媒体格式或网络能力错误";
	
/************************* 播控授权错误信息返回码映射信息 ***************************/
	
	/** 没有订购基本包 */
	public static final int AUTH_FAIL_NO_ORDERBASE = -102;
	
	/** 授权结果为空 */
	public static final int AUTH_RESULT_ISNULL = -101;
	
	/** 授权失败，订购查询成功 */
  //public static final int AUTH_FAIL_QUERYOK = 0x07020002;
	
	//授权失败,但任然有产品可以订购
	public static final int AUTH_FAIL_QUERYOK = 0x07020002;
	
	//授权失败,但任然有产品可以订购,IPTV有重复错误代码
	public static final int AUTH_FAIL_QUERYOK_IPTV = 504;
	
	/* 影片不存在 */
	public final static int AUTH_VOD_NOTEXISTS = 0x07161001;
	
	/* 没有订购产品 */
	public final static int AUTH_FAIL_NO_ORDER = 0x07020005;
	
	/** 操作成功 */
	public static final int OPER_SUCESS = 0;
%>
<%

/************************** 播控授权错误返回码及信息映射 ****************************/
	
	/** 授权返回信息映射表 */
	Map errorMap = new HashMap();
	
	/** 临时计数变量 */
	int n = 0;
	
	String errorCode = "";
	
	n = 0x07010002;
	errorCode = "认证时用户状态非正常";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x0702000A;
	errorCode = "机顶盒不支持CA加扰";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010001;
	errorCode = "认证失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010007;
	errorCode = "机顶盒MAC地址不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010008;
	errorCode = "用户IC卡不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010200;
	errorCode = "时移请求操作超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07010009;
	errorCode = "用户名不存在或密码错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020001;
	errorCode = "无可订购产品";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020002;
	errorCode = "授权失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020003;
	errorCode = "授权查询失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020004;
	errorCode = "授权查询成功";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020005;
	errorCode = "授权失败，没有订购产品.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020006;
	errorCode = "资源分配时节目的资产不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020007;
	errorCode = "NGOD时移授权时，节目单的开始时间大于当前时间";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020008;
	errorCode = "用户未开通该种业务";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020100;
	errorCode = "数据库异常";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020200;
	errorCode = "操作超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120001;
	errorCode = "资源申请失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120002;
	errorCode = "资源申请超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120005;
	errorCode = "申请IPQAM资源失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120007;
	errorCode = "资源申请SOAP接口调用失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120009;
	errorCode = "没有找到对应的点播服务器";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120010;
	errorCode = "License已满,无法进行点播";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07150008;
	errorCode = "资源分配参数错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160001;
	errorCode = "授权点播失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160002;
	errorCode = "授权点播超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160007;
	errorCode = "播放类型错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160008;
	errorCode = "频道编号错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161001;
	errorCode = "影片不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161002;
	errorCode = "节目单不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161003;
	errorCode = "频道不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161004;
	errorCode = "频道不支持时移";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161005;
	errorCode = "频道不支持录播";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020009;
	errorCode = "机顶盒不支持该格式";
	errorMap.put(new Integer(n), errorCode);
	
  // 订购接口错误
	n = 0x07030001;
	errorCode = "订购失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030002;
	errorCode = "该产品必须为长期订购";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030003;
	errorCode = "产品不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030004;
	errorCode = "用户编号错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030005;
	errorCode = "用户编号不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030006;
	errorCode = "用户状态错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030007;
	errorCode = "未开通VOD服务";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030008;
	errorCode = "产品编号错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030009;
	errorCode = "产品类型错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07031000;
	errorCode = "用户已订购过该产品";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030011;
	errorCode = "续订标识错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030012;
	errorCode = "扣费时间错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030013;
	errorCode = "vod产品状态错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030014;
	errorCode = "请求参数为空";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030015;
	errorCode = "用户账户余额不足";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030016;
	errorCode = "该产品必须为当月订购";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07030017;
	errorCode = "用户订购超时，要重新授权";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030100;
	errorCode = "数据库异常";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07030200;
	errorCode = "网络异常";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020200;
	errorCode = "操作超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120001;
	errorCode = "资源申请失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120002;
	errorCode = "资源申请超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120003;
	errorCode = "影片不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120004;
	errorCode = "产品类型错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120005;
	errorCode = "申请IPQAM资源失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120006;
	errorCode = "预付费失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120007;
	errorCode = "资源申请SOAP接口调用失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120008;
	errorCode = "预付费接口时SOAP接口失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120009;
	errorCode = "没有找到对应的点播服务器";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07120010;
	errorCode = "License已满,无法再进行点播";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07150008;
	errorCode = "资源分配参数错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160007;
	errorCode = "播放类型错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020009;
	errorCode = "媒体格式错误";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07170001;
	errorCode = "录制失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170002;
	errorCode = "录制超时";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170003;
	errorCode = "录制参数错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170004;
	errorCode = "录制数据库查询错误";
	errorMap.put(new Integer(n), errorCode);
   
	n = 0x07170005;
	errorCode = "节目已不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170006;
	errorCode = "节目已被录制";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170007;
	errorCode = "节目已不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170008;
	errorCode = "您的录制空间不足";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170009;
	errorCode = "您没有订购[个人网络录像],请到营业厅办理.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170010;
	errorCode = "用户不存在.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170011;
	errorCode = "没有录制节目.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170012;
	errorCode = "用户状态不正常";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07170013;
	errorCode = "未开通[个人网络录像],请到营业厅办理.";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07160008;
	errorCode = "频道编号错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161002;
	errorCode = "节目单不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161003;
	errorCode = "频道不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161006;
	errorCode = "频道不支持个人网络录像";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07020009;
	errorCode = "机顶盒不支持该内容";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07161009;
	errorCode = "节目不支持个人网络录像";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200001;
	errorCode = "该用户没有订购产品的权限";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200002;
	errorCode = "无法查找到用户信息";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200003;
	errorCode = "用户信息过多";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200004;
	errorCode = "查找用户信息时出错";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200005;
	errorCode = "产品状态不正确";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200006;
	errorCode = "不存在此产品";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200007;
	errorCode = "查找产品信息时出错";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200008;
	errorCode = "预付费用户不能订购包月限次产品";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07200009;
	errorCode = "用户用来支付的余额不足";
	errorMap.put(new Integer(n), errorCode);

	n = 0x0720000A;
	errorCode = "VOD产品订购失败";
	errorMap.put(new Integer(n), errorCode);

	n = 0x0720000C;
	errorCode = "当月点播的费用已超出信用度等级所规定的限定点播额度";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130001;
	errorCode = "请求的参数错误";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130002;
	errorCode = "没有满足切换条件的节目单";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130003;
	errorCode = "频道不存在";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130004;
	errorCode = "频道不支持录播";
	errorMap.put(new Integer(n), errorCode);

	n = 0x07130005;
	errorCode = "系统处于容灾状态";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07130006;
	errorCode = "当前用户为容灾用户，请重新登录";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07140001;
	errorCode = "请求的参数错误";
	errorMap.put(new Integer(n), errorCode);
   
	n = 0x07140002;
	errorCode = "节目单不存在";
	errorMap.put(new Integer(n), errorCode);
   
	n = 0x08020005;
	errorCode = "广告暂不可用";
  errorMap.put(new Integer(n), errorCode);
   	
  n = 0x716100B;
  errorCode = "未知错误";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x07000005;
    errorCode = "参数错误";
	errorMap.put(new Integer(n), errorCode);
	
	n = -1;
    errorCode = "本地授权失败";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x02030001;
    errorCode = "订购失败";
	errorMap.put(new Integer(n), errorCode);
	
	n = 0x02150002;
    errorCode = "点播时, 获取IPQAM资源失败";
	errorMap.put(new Integer(n), errorCode);
%>
