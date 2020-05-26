<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGConstants" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage"%>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelp" %>
<%@ page import="com.huawei.iptvmw.epg.bean.ServiceHelpHWCTC" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="com.huawei.iptvmw.facade.bean.info.VODMediaFile"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="datajspHD/util_prePlay.jsp" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGUtil" %>
<%@ include file="../../common4dtv/jsp/config.jsp" %>
<%!

  /**
   * �жϵ�ǰ�û��Ƿ񶩹�����ҵ��� 1:���û�����û�����������Ϊ������֤����������Ȩ
   * @param basicProductIds :�������Ĳ�Ʒ�������:Ӧ���������ļ��д���
   * @return boolean
   */
  public boolean hasOrderBase(String[] basicProductIds,HttpServletRequest request)
  {
    // 2011-8-19����ѧ�������ӣ�����ѧ����ͬ���������жϻ�����
    String baseFlag = request.getParameter("baseFlag");
    baseFlag = baseFlag == null ? "" : baseFlag.trim();
    if("0".equals(baseFlag))
    {
      //baseFlag=0 ʱ����Ҫ�жϻ�������ֱ�ӷ���true
      return true;
    }
    //�������������Ϊ�ջ��߳���Ϊ0,��Ĭ��Ϊͨ����������Ȩ
    if ((null == basicProductIds) || basicProductIds.length == 0)
    {
      return true;
    }
    ServiceHelp help = new ServiceHelp(request);

    // ȡ���ֱ�־��������ֲ����л������ж�
    String rzFlag = (String) request.getSession(true).getAttribute("LOGINOCCASION");
    if ("1".equals(rzFlag))
    {
      return true;
    }
    //��ȡ�û��Ѷ����Ĳ�ƷID
    List productIdList = help.getMonthSuites(EPGConstants.USER_ORDERED_PRODUCT);
    //���л������жϣ�ֻҪ���õĻ�������������һ����ͬ��˵�������˻�������
    if(null != productIdList && productIdList.size() > 0)
    {
      for(int i = 0; i < productIdList.size(); i ++)
      {
        String prodId = (String)productIdList.get(i);
        for(int j = 0; j < basicProductIds.length; j ++)
        {
          //���û������Ĳ�Ʒ�а���������������,���������Ȩ�ɹ�
          if(prodId.equals(basicProductIds[j]))
          {
            return true;
          }
        }
      }
    }
    return true;
  }


  /**
   * �Ƿ�����ڿ���ѹۿ�����Ŀ�б���
   * @param freeTypeIdArr ��ʾ��ѵ���Ŀ�б�
   * @param typeIds ��ʾ��ǰ��Ҫ��֤����Ŀ�б�
   * @return
   */
  private boolean freeTypeCheck(String[] typeIds,String[] freeTypeIdArr)
  {
    //�����Ŀ������� freeTypeIdArr
    for(int i = 0; i < typeIds.length; i++)
    {
      for(int j = 0; j < freeTypeIdArr.length; j++)
      {
        //����IPTV����Ŀ�ṹ��DTV��Ŀ�ṹ��ͬ�����ж�������Ϊ��Ŀ�����ȣ��Ը���Ŀ�µ�����Ŀ��Ч
        if(typeIds[i].equals(freeTypeIdArr[j]))
        {
          return true;
        }
      }
    }
    return false;
  }


  //����TVOD�Ƿ����
  //1��tvod����Ŀ���
  //2���Ƿ񶨹�������
  public boolean tvodCheck(String typeId,String[] freeTypeIdArr,HttpServletRequest request)
  {
    if (!freeTypeCheck(new String[] {typeId},freeTypeIdArr))
    {
      //���û���ҵ���ѵ���Ŀ������Ҫ��鵱ǰ�û��Ƿ񶨹�������Ʒ��
      return hasOrderBase(BASIC_PRODUCT_IDS,request);
    }
    else//��Ŀ������Ŀ����Ҫ����û��Ƿ񶩹�������������
    {
      return true;
    }
  }

  //����VOD�Ƿ����
  //1��vod����Ŀ���
  //2���Ƿ񶨹�������
  public boolean vodCheck(String progId,String typeId,String[] freeTypeIdArr,HttpServletRequest request)
  {
    if (StringUtils.isEmpty(typeId))
    {
      MetaData metaData = new MetaData(request);
      int intProgId = Integer.parseInt(progId);
      Map filmInfoMap = metaData.getVodDetailInfo(intProgId);
      //��ȡ�ý�Ŀ�ĸ���Ŀ�������
      String[] parentIds = (String[])filmInfoMap.get("allTypeId");
      //�ж��Ƿ���ѣ�1������ѣ����Ž��л�������Ȩ��2����ѣ�ֱ����Ȩ�ɹ�
      if (!freeTypeCheck(parentIds,freeTypeIdArr))
      {
        //���û���ҵ���ѵ���Ŀ������Ҫ��鵱ǰ�û��Ƿ񶨹�������Ʒ��
        return hasOrderBase(BASIC_PRODUCT_IDS, request);
      }
      else
      {
        return true;
      }
    }
    else
    {
      if (!freeTypeCheck(new String[] {typeId},freeTypeIdArr))
      {
        //���û���ҵ���ѵ���Ŀ������Ҫ��鵱ǰ�û��Ƿ񶨹�������Ʒ��
        return hasOrderBase(BASIC_PRODUCT_IDS, request);
      }
      //��Ŀ������Ŀ����Ҫ����û��Ƿ񶩹�������������
      else
      {
        return true;
      }
    }
  }

 /**
   *  ��װ����֪ͨ��url
   * @param proId
   * @param playtype
   * @param typeid
   * @param chanId
   * @param starttime
   * @param vodname
   * @param elapsetime
   * @param rtspurl
   * @param ipqamUrl
   * @param mediaStyle
   * @param eartBeatPeriod
   * @param tkmode
   * @param osd
   * @param request
   * @return String
   */
  public String getPlayUrl(int proId, int playtype, String typeid, String chanId, String starttime,
                            String vodname, long elapsetime, String rtspurl, String ipqamUrl, String mediaStyle,
                            String eartBeatPeriod, String tkmode, String osd,HttpServletRequest request)
  {
    String serverIp = EPGUtil.getEPGAddress(request);
    if(ipqamUrl != null)
    {
      ipqamUrl = ipqamUrl.replaceFirst("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}:\\d{1,5}", serverIp);
    }

    ServiceHelpHWCTC serHelp = new ServiceHelpHWCTC(request);
    MetaData metaData = new MetaData(request);
    String playUrl = "";

    //��MPEG2����MPEG4ת����MPEG-2MPEG-4
    if("MPEG2".equals(mediaStyle))
    {
      mediaStyle = "MPEG-2";
    }
    else if("MPEG4".equals(mediaStyle))
    {
      mediaStyle = "MPEG-4";
    }
    //�����а汾��:1.0���°汾
    String isNewClient = (String)request.getSession().getAttribute("isNewVersion");
    switch (playtype)
    {
      //ӰƬ
      case PLAYTYPE_VOD:
      //Ƭ��
      case PLAYTYPE_ASSESS:
      //vod��ǩ
      case PLAYTYPE_BOOKMARK:
      // ������
      case PLAYTYPE_SITCOM:
      // ��������ǩ
      case 14:
            //�жϲ���·������IP����Cable�·��ġ���ipqamUrl�ǿ�������IP�·�
            if(null == ipqamUrl || "".equals(ipqamUrl))
            {
              rtspurl = eartBeatPeriod + "^" + rtspurl + "?/" + mediaStyle;
            }
            else
            {
              rtspurl = eartBeatPeriod + "^" + rtspurl + "?/" + ipqamUrl + "/" + mediaStyle;
            }
            playUrl = serHelp.getPlayUrl(proId, playtype, starttime,rtspurl);
            playUrl = playUrl + "^" + chanId + "^" + typeid + "^" + vodname + "^" + elapsetime + "^" + tkmode + "^" + osd;
            break;
      //���ӻؿ�
      case PLAYTYPE_TVOD:
            //��Ŀ������
            Map progMap = metaData.getProgDetailInfo(proId);
            //��Ŀ����ʼʱ��
            String startTime = (String)progMap.get("STARTTIME");
            String sTs = startTime.substring(0, 8);
            String sTe = startTime.substring(8);
            startTime = sTs + "T" + sTe;
            String endTime = (String)progMap.get("ENDTIME");
            String eTs = endTime.substring(0, 8);
            String eTe = endTime.substring(8);
            endTime = eTs + "T" + eTe;
      
            rtspurl = rtspurl + "&ServiceType=TVOD&startTime=" + startTime + "&endTime=" + endTime;
            if(null == ipqamUrl || "".equals(ipqamUrl))
            {
              rtspurl = eartBeatPeriod + "^" + rtspurl + "?/" + mediaStyle;
            }
            else
            {
              rtspurl = eartBeatPeriod + "^" + rtspurl + "?/" + ipqamUrl + "/" + mediaStyle;
            }
            playUrl = serHelp.getPlayUrl(proId, playtype, starttime,rtspurl);
            playUrl = playUrl + "^" + chanId + "^" + typeid + "^" + vodname + "^" + elapsetime + "^" + tkmode + "^" + osd;
            break;
    }

    return playUrl;
  }

  // ��ȡʱ��ĺ�����
  public long getLongMsec(String datestr)
  {
    long timelong = 0;
    SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
    try
    {
      timelong = df.parse(datestr).getTime();
    }
    catch (Exception pe)
    {
      ;
    }
    return timelong;
  }

  /**
   *
   * ��ȡSTB������Ϣ�ϱ��ĵ�ַ
   * @param sessid
   * @return String
   */
  public String getReportUrl(String requesturl, String sessid,HttpServletRequest request)
  {
    ServiceHelpHWCTC serHelp = new ServiceHelpHWCTC(request);
    int index = requesturl.indexOf("/EPG/");
    String srt = (String)serHelp.getReportUrl(sessid);
    return requesturl.substring(0, index + 5) + "jsp/" + serHelp.getReportUrl(sessid);
  }

  /**
   * ����JSON��ʽ��palyurl��ֻ�轫�������д��Client�ṩ��playurl�ֶμ���ʵ�ֲ��š�
   *
   * @param jsonRtsp��JSON��ʽ��rtsprul
   * @param starttime: ��Ŀ�Ŀ�ʼʱ��
   * @param startscale: ���ű���
   * @return
   */
  public String getJsonPlayUrl(int playtype, String jsonRtsp, String reporturl, String sessionid,
                                String starttime, String startscale)
  {
    //����rtsp��json��ʽ����
    JSONObject jsonPlayUrl = JSONObject.fromObject(jsonRtsp);
    JSONObject jsonPlay = new JSONObject();

    jsonPlay.accumulate("starttime", starttime);
    jsonPlay.accumulate("startscale", new Integer(startscale));

    if (playtype == PLAYTYPE_ASSESS)
    {
      jsonPlay.accumulate("mode", PLAY_MODEL_2);
    }
    else if(playtype == PLAYTYPE_VOD)
    {
      jsonPlay.accumulate("mode", PLAY_MODEL_1);
    }

    jsonPlayUrl.put("reporturl", reporturl);
    jsonPlayUrl.put("sessionid", sessionid);
    jsonPlayUrl.put("play", jsonPlay);

    //playurl����ð�ţ�ipanel�������Client����ʱ��Ҫ����ת�����
    //����iPanel.ioctWrite()ʱ��Ҫ����
    return jsonPlayUrl.toString().replaceAll("\"", "\\\\\"");
  }

  //��ȡvod��ý�����
  public VODMediaFile getVODMediaFile(int playType, Map mp, HttpServletRequest request)
  {
    MetaData meta = new MetaData(request);
    //vod���
    String proId = (String)mp.get("progId");
    int intProId = Integer.parseInt(proId);
    //vod����
    Map vodDetail = meta.getVodDetailInfo(intProId);
    //��ȡ������֧�ֲ��ŵ�ý���ʽ
    String decodemode = (String)mp.get("decodemode");

    //��vod������ý���ļ��б�
    List mediaList = null;

    // �ж���ȡ��Ƭ����ȡƬ��
    if (playType == 5)
    {
      mediaList = (List)vodDetail.get("CLIPFILES");
    }
    else
    {
      mediaList = (List)vodDetail.get("VODFILES");
    }

    //��ȡ�ƶ�ý���ʽ��ý���ļ�����
    if(null != mediaList && mediaList.size() > 0)
    {
      String[] decodemodes = decodemode.split(";");
      for(int i = 0; i < decodemodes.length; i ++)
      {
        //��ʶý���ʽ�Ƿ�֧�ָ���:1:����;2:����,Ĭ���Ǳ���
        int isHD = 2;
		
		/******* 20111122 ycg ����ͨ�����������Ƿ����264���жϸ��� *******/
//	System.out.println("=====================decodemodes=="+decodemodes[i]);	
		if(decodemodes[i].indexOf("264") != -1)
		{
		  isHD = 1;
		}
		
		/****************************** ���� ******************************/
		
		/*
        if(decodemodes[i].endsWith("HD"))
        {
          isHD = 1;
        }
		*/
        //����Ƶ��ʽMPEG-2�����MPEG2
        if(decodemodes[i].startsWith("MPEG-2"))
        {
          decodemodes[i] = "MPEG2";
        }
        for(int j = 0; j < mediaList.size(); j ++)
        {
          //��ý���ʽƥ�䵽һ��ʱ,�ͷ������ý���ý����
          VODMediaFile vodMediaFile = (VODMediaFile)mediaList.get(j);
          //ý���������
          int mediaHD = vodMediaFile.getDefinition();
          //ý������
          int type = vodMediaFile.getType();
          //ý��ı����ʽ
          String mediaDecode = vodMediaFile.getVideoType();

          if(null == mediaDecode || "".equals(mediaDecode))
          {
            mediaDecode = "MPEG2";
          }
          // System.out.println("=========mediaHD====isHD==="+mediaHD+"   "+isHD);
         // System.out.println("==========mediaDecode=====type=="+mediaDecode+"    "+type);
          boolean isHDtype = (isHD == 1 ? true : false);
          if(isHDtype)
          {
              if(decodemodes[i].startsWith(mediaDecode) && (type == 1 || type == 2))
              {
                return vodMediaFile;
              } 
          }
          else
          {
             if(mediaDecode.equals(decodemodes[i]) && (type == 1 || type == 2))
             {
                return vodMediaFile;
             } 
          }
          //if(mediaHD <= isHD && mediaDecode.equals(decodemodes[i]) && (type == 1 || type == 2))
         // if(mediaHD >= isHD && decodemodes[i].startsWith(mediaDecode) && (type == 1 || type == 2))
         // {
          //  return vodMediaFile;
         // }
        }
      }
    }
    return null;
  }

  //����ʵ�ʵ���Ȩ�ӿڶ��û������������Ȩ����
  public Map checkAuth(Map mp,HttpServletRequest request)
  {
	int bandwidth = -2;
	//String scode = "3000000120141204008100-30000001";
    ServiceHelpHWCTC help = new ServiceHelpHWCTC(request);
    String typeId = (String)mp.get("typeId");
	
    int intPlayType = Integer.parseInt((String)mp.get("playtype"));
    String proId = (String)mp.get("progId");
    int intProId = Integer.parseInt(proId);
	
	String neVodId = (String)mp.get("neVodId");
	//System.out.println("neVodId=="+neVodId);
    //ServiceGroupId
    String serviceGroupId = (String)mp.get("servicegpid");
    int intServiceGroupId = Integer.parseInt(serviceGroupId);
    //Ƶ�����
    String chanId = (String)mp.get("chanId");
    //ý����
    String mediaId = "";
    //ý�������
    int bitRate = 0;
    //rtsp·��
    String rtspUrl = "";
    //ý���ʽ,Ĭ�ϵ���MPEG2 
    String mediaStyle = "MPEG2";
    //ý�����
    VODMediaFile vodMediaFile = null;
    if(intPlayType == 1 || intPlayType == 6 || intPlayType == 11 || intPlayType == 14 || intPlayType == 5)
    {
      vodMediaFile = getVODMediaFile(intPlayType, mp, request);
      
      if(null != vodMediaFile)
      {
        mediaId = vodMediaFile.getMediaID();
        bitRate = vodMediaFile.getBitRate();
        rtspUrl = vodMediaFile.getPlayUrl();
        // mediaStyle = vodMediaFile.getVideoType();
      }
    }

    //����õ�ý���Ŵ���mp��,���û���������Ҫ�õ�
    mp.put("mediaId", mediaId);

    //��������
    int contentType = Integer.parseInt((String)mp.get("contentType"));
    //ҵ������
    int businessType = Integer.parseInt((String)mp.get("businessType"));
    //��Ȩ�ӿ�
	//System.out.println("Authorization intPlayType="+ intPlayType + ", typeId = "+ typeId+", neVodId=="+neVodId+", chanId=="+chanId);
	String extPar1 = "";
	String extPar2 = "";
	extPar2 = typeId;
	//�ⲿid
	if((null != neVodId) && !"null".equals(neVodId) && !"".equals(neVodId))
	{
		extPar1 = neVodId;
	}
	//�ؿ�Ƶ����
	else if((null != chanId) && !"null".equals(chanId) && !"".equals(chanId)) 
	{
		extPar1 = chanId;
	}
	//System.out.println("Authorization test extPar1 = "+ extPar1+", extPar2=="+extPar2);
	
	HashMap authMap = help.authorization4DTV(intProId,
										 mediaId,
										 intPlayType,
										 contentType,
										 businessType,
										 typeId,
										 Integer.parseInt((String)mp.get("parentVodId")),   //�������
										 bitRate,
										 intServiceGroupId,
										 bandwidth,
										 extPar1,
										 extPar2);
	
    if (authMap == null)
    {
      //��Ȩ�ӿڵ���ʧ�ܣ���soap�ӿڳ�ʱδ����
      authMap = new HashMap();
      authMap.put("retCode",new Integer(-101));
      return authMap;
    }

    //��Ŀ����
    String vodName   = null;

    //��Ŀʱ��
    long timeLength  = 0;

    //��Ŀ��ʼ����ʱ��
    String starttime = null;
    String reportUrl = null;
    String playUrl = null;
    //��Ȩ�ɹ�
    if (((Integer)authMap.get("RETCODE")).intValue() == 0)
    {
      Map loginVoMap = (Map)request.getSession().getAttribute("loginVo");
      rtspUrl = help.getRtspUrl4DTV((String)loginVoMap.get("icID"), (String)loginVoMap.get("ip"), authMap);
	  String duration = (String)mp.get("duration");
	  if(!"-1".equals(duration)){
		 duration = duration.replaceAll(":","");
	 	 rtspUrl += "&playseek="+duration;
	  }
      //�ϱ�url
      String sessId = (String)authMap.get("sessID");
      String requesturl =  (String)mp.get("requesturl");

      //��ѯ���ݷ���
      MetaData metaData = new MetaData(request);
      reportUrl = getReportUrl(requesturl, sessId, request);
      if((intPlayType == PLAYTYPE_ASSESS) || (intPlayType == PLAYTYPE_VOD)
        || (intPlayType == PLAYTYPE_BOOKMARK) || (intPlayType == PLAYTYPE_SITCOM)|| (intPlayType == 14))
      {
        Map vodHp = metaData.getVodDetailInfo(intProId);
        vodName = (String)vodHp.get("VODNAME");

        if(rtspUrl.indexOf("playseek=") != -1)
        {
          // ����ʱ����ʱ�Ĵ���
          String tempSeek = rtspUrl.replaceAll("^rtsp.*playseek=(\\d{1,6}-\\d{1,6}).*", "$1");
          String[] splitPlayseek_time = tempSeek.split("-");
          String strStartTime = splitPlayseek_time[0];
          String strEndTime = splitPlayseek_time[1];

          String strStartTime1 = strStartTime.substring(0, 2);
          String strStartTime2 = strStartTime.substring(2, 4);
          String strStartTime3 = strStartTime.substring(4, 6);
          strStartTime = (Integer.parseInt(strStartTime1) * 3600
                         + Integer.parseInt(strStartTime2) * 60 + Integer.parseInt(strStartTime3)) + "";

          String strEndTime1 = strEndTime.substring(0, 2);
          String strEndTime2 = strEndTime.substring(2, 4);
          String strEndTime3 = strEndTime.substring(4, 6);
          strEndTime = (Integer.parseInt(strEndTime1) * 3600
                       + Integer.parseInt(strEndTime2) * 60 + Integer.parseInt(strEndTime3)) + "";

          timeLength =(Long.valueOf(strEndTime)).intValue() - (Long.valueOf(strStartTime)).intValue();
        }
        else if (intPlayType == PLAYTYPE_ASSESS)
        {
          timeLength = (long) vodMediaFile.getDtvElapseTime();
        }
        else
        {
          timeLength = Long.parseLong(vodHp.get("DTVELAPSETIME").toString());
        }
      }
      else if ((intPlayType == PLAYTYPE_TVOD))
      {
        // ��ȡ��Ŀ������ϸ��Ϣ
        Map progMap = metaData.getProgDetailInfo(intProId);
        vodName = (String)progMap.get("PROGNAME");
        timeLength = (getLongMsec((String)progMap.get("ENDTIME"))- getLongMsec((String)progMap.get("STARTTIME"))) / 1000;
      }

      //���ζ�������Ҫ�õ��������
      mp.put("elapseTime", String.valueOf(timeLength));
      //����ʱ��
      String eartBeatPeriod = String.valueOf(authMap.get("HeartBeatPeriod"));
      int xintPlayType = 0;
      if(intPlayType == 14)
      {
        intPlayType = 11;
        xintPlayType = 14;
      }

      playUrl = getPlayUrl( intProId,
                            intPlayType,
                            typeId,
                            chanId,
                            (String)mp.get("starttime"),
                            vodName,
                            timeLength,
                            rtspUrl,
                            (String)authMap.get("IPQAMResURL"),
                            (String)authMap.get("CONTENTMEDIAFORMAT"),
                            eartBeatPeriod,
                            (String)mp.get("tkmode"),
                            (String)mp.get("osd"),request);

      if(xintPlayType == 14)
      {
       String[] playUrls = playUrl.split("\\^");
       playUrls[1] = String.valueOf(xintPlayType);
       StringBuffer sbPlayUrl = new StringBuffer();
       for(int pi = 0; pi < playUrls.length; pi++)
       {
         sbPlayUrl.append(playUrls[pi]);
         if(pi != playUrls.length - 1)
         {
           sbPlayUrl.append("^");
         }
       }
       playUrl = sbPlayUrl.toString();
      }

      authMap.put("emm",authMap.get("EMM"));
      authMap.put("typeId",typeId);
      authMap.put("playUrl",playUrl);
      authMap.put("retCode","0");
      authMap.put("reportUrl",reportUrl);

      //CA��ȨEMM��Ϣ��16�����ַ������ڲ��ż��ŵ�VODʱ��Ч�����ڷ���EMM����.buxiaopeng,20080704
      Object emm = authMap.get("EMM");
      if ((emm != null) && (!emm.equals("")))
      {
        authMap.put("emm",emm);
      }
    }
    //��Ȩʧ��
    else
    {
      authMap.put("retCode",(Integer)authMap.get("RETCODE"));
    }

    return authMap;
  }


  /**
   * �ӿڵ��÷�������������ʾ���������Ϣ
   */
  public Map DefaultResultDeal(Map codeMp,String message)
  {
      Map result = new HashMap();
      result.put("message",message);
      result.put("retCode", codeMp.get("retCode"));
      //������
      result.put("removeLastRequest", Boolean.TRUE);
      return result;
  }

  /**
   * �ӿڵ��÷�������������ʾ���������Ϣ
   */
  public Map vodNotExists(Map codeMp,String message)
  {
    Map result = new HashMap();
    result.put("message",message);
    result.put("retCode", codeMp.get("retCode"));
    //������
    result.put("removeLastRequest", Boolean.TRUE);
    return result;
  }

  /**
   * �ӿڵ��÷�������������ʾ���������Ϣ
   */
  public Map failQueryokIDeal(Map codeMp,String message)
  {
    Map result = new HashMap();
    result.put("message",message);
    result.put("retCode", codeMp.get("retCode"));
    //������
    result.put("removeLastRequest", Boolean.TRUE);
    return result;
  }

  /**
   * �ӿڵ��÷�������������ʾ���������Ϣ
   */
  public Map failNoOrderIDeal(Map codeMp,String message)
  {
    Map result = new HashMap();
    result.put("message",message);
    result.put("retCode", codeMp.get("retCode"));
    //������
    result.put("removeLastRequest", Boolean.TRUE);
    return result;
  }
  /**
   * �ӿڵ��÷�������������ʾ���������Ϣ
   */
  public Map authIsNullIDeal(Map codeMp,String message)
  {
    Map result = new HashMap();
    result.put("message",message);
    result.put("retCode", codeMp.get("retCode"));
    //������
    result.put("removeLastRequest", Boolean.TRUE);
    return result;
  }

  public Map defaultResultDeal(String message)
  {
   Map result = new HashMap();
   result.put("message",message);
   return result;
  }

  public Map operSucessIDeal(Map result,Map codeMp,String message)
  {
    //��Ȩ�Ľ��
    result.put("message",message);
    //����·����
    result.put("playurl", codeMp.get("playUrl"));
    //�ϱ�������·����
    result.put("reporturl", codeMp.get("reportUrl"));
    //CA��ȨEMM��Ϣ:
    result.put("emm", codeMp.get("emm"));
    //��ǰ��Ŀ���:
    result.put("proId", codeMp.get("proId"));
    //��ǰ��Ŀ���ڵ���Ŀ���:
    result.put("typeId", codeMp.get("typeId"));
    return result;
  }

  private String converArrayToString(Object[] objs)
  {
    StringBuffer buffer = new StringBuffer();

    for (int j = 0; j < objs.length; j++)
    {
      buffer.append(objs[j] + ",");
    }

    buffer.deleteCharAt(buffer.length() - 1);
    return buffer.toString();
  }

  /**
   *
   * ������������ۺϳ�����
   * ����һ��ʱ,��һ����
   * @param seconds
   * @return int
   */
   public static int getDaysBySecond(long seconds)
   {
     int hourseonds = 3600;
     int hours = (int) seconds / hourseonds;
     int hour = hours % 24;
     int dates = ((int) hours / 24);
     dates = hour > 0 ? (dates+ 1) : dates;
     return dates;
   }

  /**
   * ������Ŀ��ţ���ȡ��Ŀ����
   *
   * @param typeId
   *       ��Ŀ���
   * @param request
   *       �������
   * @return String
   */
  public String getTypeNameByTypeId(String typeId,HttpServletRequest request)
  {
    MetaData mt = new MetaData(request);
    String typeName = "";
    try
    {
      typeName = mt.getTypeNameByTypeId(typeId);
    }
    catch(Exception e)
    {}
    return typeName;
  }

  /**
   * ����������Ϊ���ӻؿ�ʱ��ҵ��
   *
   * @param vodid
   *            ��ǰ���ŵĽ�Ŀ�����
   * @param request
   *            �������
   * @param chanid
   *            ��ǰƵ�����
   * @param typename
   *            ��Ŀ����
   */
  public void operateTvod(String vodid, HttpServletRequest request,
                          String chanid)
  {
    Map chanMap = null;
    MetaData mt = new MetaData(request);
    // ���Ƶ����Ų�Ϊ��
    if ((null != chanid) && !"".equals(chanid))
    {
      chanMap = mt.getChannelInfo(chanid);
    }

    // ���Ƶ����Ϣ��Ϊ��
    if (chanMap != null)
    {
      // ��ǰƵ��֧�ֵĻؿ�����
      int scd = ((Integer)chanMap.get("RECORDLENGTH")).intValue();
      long scds = (long) scd;
      int dates = getDaysBySecond(scds);
      int progId = Integer.parseInt(vodid);
      Map progInfo = mt.getProgDetailInfo(progId);
      // ��ǰ��Ŀ��Ϊ��
      if (null != progInfo)
      {
        getNtBkTvodpro(progInfo, vodid, dates, request);
      }
    }
  }

  /**
   * ��ȡ��ǰTvod��Ŀ���½�Ŀ��Ϣ
   *
   * @param vodvo
   *            ��ǰ���ŵĽ�Ŀ����ϸ��Ϣ
   * @param dates
   *            ��ǰƵ������ؿ�������
   * @param request
   *            �������
   */
  public void getNtBkTvodpro(Map progBill, String progId, int dates,
                             HttpServletRequest request)
  {
    request.getSession().setAttribute("detailvo", progBill);

    // ��ǰƵ�����
    String currentchanid = (String)progBill.get("CHANNELID");
    Map nextpro = queryPronamebycurrentPor(progId, currentchanid, "backward", request);

    // ��һ��Ŀ��Ϊ��
    if (null != nextpro)
    {
      // �洢��һ��Ŀ��Ϣ
      request.getSession().setAttribute("nextpro", nextpro);
    }

    getBackTvodpro(progId, currentchanid, dates, request);
  }

  /**
   * ��ȡ��ǰ���Ž�Ŀ����һ��Ŀ��Ϣ
   *
   * @param currentproid
   *            ��ǰ��Ŀ���
   * @param currentchanid
   *            ��ǰƵ�����
   * @param dates
   *            ��ǰƵ������ؿ�������
   * @param request
   *            �������
   */
  public void getBackTvodpro(String currentproid, String currentchanid,
                             int dates, HttpServletRequest request)
  {
    Map progMap = queryPronamebycurrentPor(currentproid,
                                                    currentchanid, "forward", request);

    // ��һ��Ŀ��Ϊ��
    if (null != progMap)
    {
      // ��һ��Ŀ�Ŀ�ʼʱ��
      String starttime  = (String)progMap.get("STARTTIME");
      DateFormat format = new SimpleDateFormat("yyyyMMdd0000");
      Calendar rightNow = Calendar.getInstance();
      rightNow.add(Calendar.DAY_OF_MONTH, -dates);
      String nowdata = format.format(rightNow.getTime());
      if (starttime.substring(0, 8).equals(nowdata.substring(0, 8))) // �Ѿ�������
      {
        if (!starttime.substring(8, 10).equals("00"))
        {
          //"����������һ��Ŀ�Ѿ����ڣ�"
          progMap = null;
        }
      }
      // �洢��һ��Ŀ��Ϣ
      request.getSession().setAttribute("backpro", progMap);
    }
  }

  /**
   * ���ݵ�ǰ��Ŀ��Ų�ѯ��һ��Ŀ����һ��Ŀ����Ϣ
   *
   * @param ProgID
   *            ��ǰ��Ŀ���
   * @param ChannelID
   *            ��ǰƵ�����
   * @param Direction
   *            ����ķ���
   * @param request
   *            �������
   * @return
   */
  public Map queryPronamebycurrentPor(String ProgID,
                                               String ChannelID, String Direction, HttpServletRequest request)
  {
    MetaData mt = new MetaData(request);
    // �ع�����·��
    String playurl = request.getScheme() + "://" + request.getServerName()
                     + ":" + request.getServerPort() + request.getContextPath()
                     + "/jsp/TvodSkip.jsp?Direction=" + Direction + "&ProgID="
                     + ProgID + "&ChannelID=" + ChannelID;
    String info = remoteHttpService(playurl, request.getSession()
                                             .getId());

    String[] Skipinfos = info.split("\n");
    // ��ô���������ַ��� �� errorcode = 0
    String SkipErrorCode = Skipinfos[0];
    String[] SkipErrorCodes = SkipErrorCode.split("=");
    // ��ý�ȡ��ķ�����
    int Skiprecode = Integer.parseInt(SkipErrorCodes[1]);
    // 0�������󲥷���Դ�ɹ�
    if (Skiprecode == 0)
    {
      // ��ô����Ŀ��ŵ��ַ���, �� ProgID=24343;
      String ProgIDinfo = Skipinfos[2];
      String[] ProgIDs = ProgIDinfo.split("=");
       // ������Ľ�Ŀ�����
      String progid = ProgIDs[1];
      return mt.getProgDetailInfo(Integer.parseInt(progid));
    }
    else
    {
      // ������Դʧ��
      return null;
    }
  }

  /**
   * Զ��http�ӿڵ���
   * @param reqUrl
   * @param sessionId
   * @return
   */
  public static String remoteHttpService(String reqUrl, String sessionId)
  {
    StringBuffer info = new StringBuffer();
    String temp = "";
    BufferedReader in = null;
    try
    {
      URL url = new URL(reqUrl);
      URLConnection conn = url.openConnection();

      //���sessionId������null������sessionId����ָ���Ự
      if (null != sessionId)
      {
        conn.addRequestProperty("Cookie", "JSESSIONID=" + sessionId);
      }

      conn.connect();
      in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
      while (null != temp)
      {
        //��ȡ������Ϣ
        temp = in.readLine();
        //��ܵ���<br>��,��֪����β����ġ�
        if((temp != null) && temp.indexOf("<br>") > 0)
        {
          temp = temp.substring(0,temp.indexOf("<br>"));
        }
        if (null != temp)
        {
          info.append(temp + "\n");
        }
      }
    }
    catch (IOException e)
    {
      e.printStackTrace();
    }
    finally
    {
      try
      {
        in.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
    return info.toString();
  }

  /**����ѵ㲥�Ľ�Ŀ��������������Ӽ�����ͬʱ���Ϊ�ѵ㲥���������Ӽ�   */
  public void addPlayedVod(HttpServletRequest request, int vodId, int parentId, int playType)
  {
    //�ѵ㲥�Ľ�Ŀ
    ArrayList played = (ArrayList)request.getSession().getAttribute("playedFilms");
    if(null == played)
    {
      played = new ArrayList(20);
    }

    //�ѵ㲥������
    ArrayList sitcom = (ArrayList)request.getSession().getAttribute("playedSitcoms");
    if(null == sitcom)
    {
      sitcom = new ArrayList(20);
    }

    Integer sitId = new Integer(vodId);
    Integer parentVodId = new Integer(parentId);
    //����������Ӽ�
    if(!sitcom.contains(sitId) && parentId != -2)
    {
      sitcom.add(sitId);
    }
    if(sitcom.size() > 20)
    {
      sitcom.remove(0);
    }

    if(parentId != -2)
    {
      //��������Ӹ�ID
      if(played.contains(parentVodId))
      {
        played.remove(parentVodId);
      }
      played.add(0,parentVodId);
    }
    //��ӵ㲥��Ŀ
    else if(playType == 1)
    {
      //�㲥��Ŀ
      if(played.contains(sitId))
      {
        played.remove(sitId);
      }
      played.add(0,sitId);
    }

    if(played.size() > 20)
    {
      played.remove(20);
    }

    request.getSession().setAttribute("playedFilms", played);
    request.getSession().setAttribute("playedSitcoms", sitcom);
  }

  public static String getAssessTime(String mtime)
  {
    int nTime = Integer.valueOf(mtime).intValue();
    String newTime = "";
    String sHour = "";
    String sMinute = "";
    String sSecond = "";
    int hour = nTime/3600;
    if(hour < 10)
    {
      sHour = "0" + String.valueOf(hour);
    }
    else
    {
      sHour = String.valueOf(hour);
    }

    int minute = (nTime % 3600)/60;
    if(minute < 10)
    {
      sMinute = "0" + String.valueOf(minute);
    }
    else
    {
      sMinute = String.valueOf(minute);
    }
    int second = (nTime % 3600)%60;
    if(second < 10)
    {
      sSecond = "0" + String.valueOf(second);
    }
    else
    {
      sSecond = String.valueOf(second);
    }
    newTime = sHour + sMinute + sSecond;

    return newTime;
  }
%>
<html>
<head>
<title>������Ȩҳ��</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
</head>
<%
  // ת��·��
  String fowardpath = "go_geninfoPlay.jsp";
  String queryString=request.getQueryString();
  System.out.println("go_auth_xmpp queryString="+queryString);
  
  
  // ӰƬ���
  String progId = request.getParameter("progId");
  String neVodId = "";
  // �����縸��vodid
  String parentVodId = request.getParameter("parentVodId");
  
  String idType= request.getParameter("idType");//���������
   // ��������
  String playtype = request.getParameter("playType");
    // Ƶ�����,��û��ֱʱĬ��Ϊ0
  String chanId   = request.getParameter("chanId");
  int intChanId = StringToInt(chanId, 0);
  
   //���ŵ���������
  String contentType = request.getParameter("contentType");
  int intContentType = StringToInt(contentType, -1);
	
  if("FSN".equals(idType)){
	neVodId  = progId;
	ServiceHelp help = new ServiceHelp(request);
	MetaData metaData = new MetaData(request);
	List list = help.searchFilmsByKeywords(progId+"-cloudID",0,10);
	
	//System.out.println("go_authorization_xmpp list  = "+list);
	if(list != null){
		
		//Map map = (Map)list.get(0);
		List vodList = (List)list.get(1);
		//System.out.println("go_authorization_xmpp list in  vodList = "+vodList);
		if (null != vodList && 0 < vodList.size())
		{
			 Map vodMap = (Map) vodList.get(0);
			 //System.out.println("vodMap =="+vodMap.size());
			 progId  = String.valueOf(vodMap.get("VODID")); 
			 int vodId = ((Integer)vodMap.get("VODID")).intValue();
			 HashMap vodDetatlMap = (HashMap)metaData.getVodDetailInfo(vodId);
			 //System.out.println("go_authorization_xmpp list in  vodDetatlMap = "+vodDetatlMap);
			 Integer splayType = ((Integer)vodDetatlMap.get("ISSITCOM")).intValue();
			 int sparentVodId = ((Integer)vodDetatlMap.get("FATHERVODID")).intValue();
			 if(sparentVodId != -1){
			 	parentVodId = String.valueOf(sparentVodId);
			 }
			 //System.out.println("go_authorization_xmpp vodId  = "+vodId+",sjplaytype="+splayType+",sparentVodId="+sparentVodId);
		}
	}
  }
 
  int intProgId = StringToInt(progId, -1);
  int intParentVodId = StringToInt(parentVodId, -2);
  int intPlayType = StringToInt(playtype,-1);
  
  //System.out.println("go_authorization_xmpp intProgId  = "+intProgId+",intPlayType="+intPlayType+",intParentVodId="+intParentVodId);
  
  String duration = request.getParameter("duration");
  if(null == duration || "null".equals(duration) || "".equals(duration)){
	 duration = "-1";
  }
  
  String auth_next = request.getParameter("auth_next");
  if(null != auth_next && "" != auth_next){
	TurnPage turnPage = new TurnPage(request);
	turnPage.removeLast();
  } 
  
  String bytype = request.getParameter("bytype");//��ȡ��Ŀ����(�������ִ��ĸ���Ŀ����)
  String ishd = request.getParameter("isHd");
  int intishd =0;
  if(null == ishd || "null".equals(ishd) || "".equals(ishd)){
	 intishd = 0;
  }else{
	 intishd = StringToInt(ishd, -1);  
  }
  
   String tipType = request.getParameter("tipType");//�жϸ���
   
  // ��Ŀ���
  String typeId = request.getParameter("typeId");
  if(null == typeId || "null".equals(typeId) || "".equals(typeId))
  {
    typeId = "-1";
  }
  else
  {
    typeId = typeId.trim();
  }
  
  String comeType = request.getParameter("comeType");
  if(null == comeType || "null".equals(comeType) || "".equals(comeType))
  {
    comeType = "0";
  }
  // ��Ŀ����
  String typename = getTypeNameByTypeId(typeId,request);

 
 

  // ҵ������
  String businessType = request.getParameter("business");
  int intBusinessType = StringToInt(businessType, -1);

  //ý��֧�ָ�ʽ
  String decodemode = (String)session.getAttribute("decodemode");
  //ý��ID
  String smediaId = request.getParameter("mediaId");
  
  /*String smediaId = request.getParameter("mediaId");
  System.out.println("aaaa  tttt");
  if(("".equals(smediaId) || (null == smediaId)){
	  smediaId = "0";
  }
  System.out.println("zenglt auth smediaId="+smediaId);
  */
  // ��ǩ��ʼ����ʱ�� (ֻ�в���������VOD��ǩ�����ǵ��Ӿ���ǩ����Ч)
  String starttime = request.getParameter("startTime");
  if (("".equals(starttime) || (null == starttime)) && (intPlayType != 6 || intPlayType != 14))
  {
    starttime = "0";
  }

  // ��С���ڲ���Ƭ��ʱ�贫��˲�������trickmode�Ĳ���
  String tkmode = request.getParameter("tkmode");
  if(StringUtils.isEmpty(tkmode))
  {
    tkmode = "1";
  }

  // ��С���ڲ���Ƭ��ʱ�贫��˲�������osd����ʾ
  String osd = request.getParameter("osd");
  if(StringUtils.isEmpty(osd))
  {
    osd = "1";
  }

  // ��ǰ����·��
  String requesturl = request.getRequestURL().toString();

  /* ����ӵģ�ӰƬ���ڵ�ģ����Ϣ */
  String tw_record_template = request.getParameter("tw_record_template");
  if ("".equals(tw_record_template) || (null == tw_record_template))
  {
      tw_record_template = "template1";
  }

  /* ����ӵģ���ͼ����ҳ���б�ҳ�������Ȩ����ʱ�ı�ǣ����ڷ��� */
  String tw_record_flag = request.getParameter("tw_record_flag");
  if ("".equals(tw_record_flag) || (null == tw_record_flag))
  {
      tw_record_flag = "-1";
  }

  // SERVICEGROUPID
  int servicegpid =  new Integer(DEFAULT_SERVICE_GROUPID).intValue();
  Object objServicegpid = session.getAttribute("serviceGroupId");
  if(null!=objServicegpid)
  {
    servicegpid = Integer.parseInt(objServicegpid.toString());
  }

  Object objIsNewVersion  = session.getAttribute("isNewVersion");
  String isNewVersion = "0";
  if(null!=objIsNewVersion)
  {
    isNewVersion = String.valueOf(objIsNewVersion);
  }

  // ׼�����ݣ���ߺ���ʹ��
  Map mp = new HashMap();
  mp.put("progId", String.valueOf(intProgId));
  mp.put("parentVodId", String.valueOf(intParentVodId));
  mp.put("typeId", typeId);
  mp.put("chanId", String.valueOf(intChanId));
  mp.put("playtype", String.valueOf(intPlayType));
  mp.put("contentType", String.valueOf(intContentType));
  mp.put("businessType", String.valueOf(intBusinessType));
  mp.put("decodemode", decodemode);
  mp.put("starttime", starttime);
  mp.put("tkmode", tkmode);
  mp.put("osd", osd);
  mp.put("requesturl", requesturl);
  mp.put("servicegpid", String.valueOf(servicegpid));
  mp.put("isNewVersion", isNewVersion);
  mp.put("mediaId", smediaId);
  mp.put("neVodId", neVodId);//�ⲿID
  mp.put("duration", duration);

  /***********************************��ʼ����*******************************************************/

  //������ķ�����   0: ��Ȩ�ɹ�
  int resultCode = 0;

  Map authInfo = new HashMap();

  switch (intPlayType)
  {
    // ���ӻؿ�
    case 4:
          if (tvodCheck(typeId,FREE_TYPES,request))
          {
            authInfo = checkAuth(mp, request);
            resultCode = Integer.parseInt(authInfo.get("retCode").toString());
          }
          else
          {
            resultCode = AUTH_FAIL_NO_ORDERBASE;
          }
          break;

      // Ƭ��
      case 5:
          authInfo = checkAuth(mp, request);
          resultCode = Integer.parseInt(authInfo.get("retCode").toString());
          break;

      // ������ӰƬ�����Ӿ缰��ǩ��
      default:
          if(vodCheck(progId,typeId,FREE_TYPES,request))
          {
            authInfo = checkAuth(mp, request);
            resultCode = Integer.parseInt(authInfo.get("retCode").toString());
          }
          else
          {
            resultCode = AUTH_FAIL_NO_ORDERBASE;
          }
      break;
  }
  /***********************************�Է��ؽ�����д���*****************************************************/

  Map resultMp = new HashMap();
  resultMp.putAll(mp);
  String message = "";

  /* ��ͼ�����ҳ�洫�����Ĳ������з�װ������*/
  resultMp.put("tw_record_template", tw_record_template);
  resultMp.put("tw_record_flag", tw_record_flag);
  switch (resultCode)
  {
      /* û�ж�������ҵ�� */
    case AUTH_FAIL_NO_ORDERBASE:
    if(intishd == 1){
		message = "��ӭ����TV+�����㲥�ײͣ�39Ԫ/�£���ѯ96868.";
	}else{
		message = "��δ����������Ʒ�������ȵ�Ӫҵ������.";
	}
	if("rain".equals(tipType)){ //�ʺ�������ʾ
	   message = "�����趩������Ʒ���벦��96868��ѯ��";
    }
    resultMp.put("message",message);
    resultMp.put("retCode",new Integer(resultCode).toString());
    break;

    /* ��Ȩ���Ϊ�� */
    case AUTH_RESULT_ISNULL:
    message = "ϵͳæ�����Ժ�����.";
    resultMp.put("message",message);
    resultMp.put("retCode",new Integer(resultCode).toString());
    break;

    /* û�ж�����Ʒ */
    //����������¼��
    case AUTH_FAIL_NO_ORDER:
	
		message = "��û�ж�����Ʒ [";
		if(intPlayType == PLAYTYPE_TVOD)
		{
		message = message + "���ӻؿ�";
		}
		message = message + "],�뵽Ӫҵ������.";
		resultMp.put("message",message);
		resultMp.put("retCode",new Integer(resultCode).toString());
		break;

    /* ��Ȩʧ�ܣ�������ѯ�ɹ� */
    case AUTH_FAIL_QUERYOK:
    case AUTH_FAIL_QUERYOK_IPTV:
      resultMp.put("retCode",new Integer(resultCode).toString());

      //��Ʒ����
      Map prodObj = null;
      //���²�Ʒ�б�
      List monthList = (List)authInfo.get("MONTH_LIST");
      //���ζ�����Ʒ�б�
      List timesList = (List)authInfo.get("TIMES_LIST");
      // 2011-8-19����ѧ�������ӣ�����ѧ����ͬ������Ϊ���²�Ʒ
      String baseFlag = request.getParameter("baseFlag");
      baseFlag = baseFlag == null ? "" : baseFlag.trim();

      if("0".equals(baseFlag))
      {
        //baseFlag=0 �� orderType ����Ϊ���¶���
        orderType = "ByMonth";
      }
      else
      {
        orderType = "Bytimes";
      }


      if("Bytimes".equals(orderType))
      {
        if(null != timesList && timesList.size() > 0)
        {
          //���β�Ʒ����
          prodObj = (Map)timesList.get(0);
          //���β�Ʒ����
          String prodName = (String)prodObj.get("PROD_NAME");
          //��ʾ��Ϣ
          message = "�ý�Ŀ�����շ�,�۸�:";

          // ��ȡӰƬ�ļ۸�
          MetaData meta = new MetaData(request);
          // ��ȡVOD��������Ϣ
          Map vodDetail = meta.getVodDetailInfo(intProgId);
          String price = (String)vodDetail.get("VODPRICE");
          message = message + getPrice(price) + "Ԫ";
          //�����շѱ�ʶ
          resultMp.put("Anci_flag","Anci_flag");
        }
        else
        {
			int countNum = 0;
			for(int i=0;i<monthList.size();i++)
			{
				Map tmpObj = (Map)monthList.get(i);
				String prodName = (String)tmpObj.get("PROD_NAME");
				String prodCode = (String)tmpObj.get("PROD_CODE");
				if("100005".equals(prodCode)){
					countNum += 1;
				}else if("100374".equals(prodCode)){
					countNum += 2;
				}else if("100375".equals(prodCode)){
					countNum += 4;
				}else if("100376".equals(prodCode)){
					countNum += 8;
				}else if("100151".equals(prodCode)){
					countNum += 16;
				}
				//System.out.println("Bytimes prodCode=="+prodCode+",,prodName="+prodName);
			}

			//System.out.println("Bytimes countNum=="+countNum);

		 	if(countNum == 5){
				message = "�뿪ͨTV+��Ʒ���ɻؿ�����Ŀ��";
			}else if(countNum == 8 || countNum == 10){
				message = "������Ϊֱ����ǿ��Ʒ�����ɻؿ�����Ŀ��";
			}else if(countNum == 15 || countNum == 31){
				message = "������Ϊֱ����ǿ��Ʒ��ͨTV+��Ʒ�����ɻؿ�����Ŀ��";
			}else{
				//message = "��ӭ����TV+�����㲥�ײͣ�39Ԫ/�£���ѯ96868.";
				//message = "��û�ж������²�Ʒ [";
				boolean tmpFlag = false;
				for(int i=0;i<monthList.size();i++)
				{
					Map tmpObj = (Map)monthList.get(i);
					String prodName = (String)tmpObj.get("PROD_NAME");
					String prodCode = (String)tmpObj.get("PROD_CODE");
					//System.out.println("ByMonth2 prodCode=="+prodCode);
					if("100120".equals(prodCode) || "100000".equals(prodCode)){
						message = "�뿪ͨTV+������Ʒ���������ӱ���Ŀ��";
						tmpFlag = true;
					}else if("100185".equals(prodCode) || "100360".equals(prodCode) || "100359".equals(prodCode)){
						message = "��û�ж������²�Ʒ [" + prodName +"]���뵽Ӫҵ������.";
						break;
					}else{
						if(tmpFlag){
							message = "�뿪ͨTV+������Ʒ���������ӱ���Ŀ��";
						}else{
							message = "��û�ж������²�Ʒ [" + prodName +"]���뵽Ӫҵ������.";
						}
					}
				}
				/*//���²�Ʒ����
				prodObj = (Map)monthList.get(0);
				//���²�Ʒ����
				String prodName = (String)prodObj.get("PROD_NAME");
				String prodCode = (String)prodObj.get("PROD_CODE");
				if("100120".equals(prodCode) || "100000".equals(prodCode)){
					message = "�뿪ͨTV+������Ʒ���������ӱ���Ŀ��";
				}else{
					//��ʾ��Ϣ
					//message = "�����Զ������²�Ʒ " + prodName + ",�۸�";
					message = message + prodName +"]���뵽Ӫҵ������.";
					//�����շѱ�ʶ
				}*/
			}
          resultMp.put("Anci_flag","");
        }
      }
      else
      {
        if(null != monthList && monthList.size() > 0)
        {
			int countNum = 0;
			for(int i=0;i<monthList.size();i++)
			{
				Map tmpObj = (Map)monthList.get(i);
				String prodName = (String)tmpObj.get("PROD_NAME");
				String prodCode = (String)tmpObj.get("PROD_CODE");
				if("100005".equals(prodCode)){
					countNum += 1;
				}else if("100374".equals(prodCode)){
					countNum += 2;
				}else if("100375".equals(prodCode)){
					countNum += 4;
				}else if("100376".equals(prodCode)){
					countNum += 8;
				}else if("100151".equals(prodCode)){
					countNum += 16;
				}
				//System.out.println("ByMonth prodCode=="+prodCode+",,prodName="+prodName);
			}

			//System.out.println("ByMonth countNum=="+countNum);

		 	if(countNum == 5){
				message = "�뿪ͨTV+��Ʒ���ɻؿ�����Ŀ��";
			}else if(countNum == 8 || countNum == 10){
				message = "������Ϊֱ����ǿ��Ʒ�����ɻؿ�����Ŀ��";
			}else if(countNum == 15 || countNum == 31){
				message = "������Ϊֱ����ǿ��Ʒ��ͨTV+��Ʒ�����ɻؿ�����Ŀ��";
			}else{
				//message = "��û�ж������²�Ʒ [";
				boolean tmpFlag = false;
				for(int i=0;i<monthList.size();i++)
				{
					Map tmpObj = (Map)monthList.get(i);
					String prodName = (String)tmpObj.get("PROD_NAME");
					String prodCode = (String)tmpObj.get("PROD_CODE");
					//System.out.println("ByMonth2 prodCode=="+prodCode);
					if("100120".equals(prodCode) || "100000".equals(prodCode)){
						message = "�뿪ͨTV+������Ʒ���������ӱ���Ŀ��";
						tmpFlag = true;
					}else if("100185".equals(prodCode) || "100360".equals(prodCode) || "100359".equals(prodCode)){
						message = "��û�ж������²�Ʒ [" + prodName +"]���뵽Ӫҵ������.";
						break;
					}else{
						if(tmpFlag){
							message = "�뿪ͨTV+������Ʒ���������ӱ���Ŀ��";
						}else{
							message = "��û�ж������²�Ʒ [" + prodName +"]���뵽Ӫҵ������.";
						}
					}
				}
				
				
				/*//���²�Ʒ����
				prodObj = (Map)monthList.get(0);
				//���²�Ʒ����
				String prodName = (String)prodObj.get("PROD_NAME");
				String prodCode = (String)prodObj.get("PROD_CODE");
				if("100120".equals(prodCode) || "100000".equals(prodCode)){
					message = "�뿪ͨTV+������Ʒ���������ӱ���Ŀ��";
				}else{
					//��ʾ��Ϣ
					//message = "�����Զ������²�Ʒ " + prodName + ",�۸�";
					message = message + prodName +"]���뵽Ӫҵ������.";
					//��һ�����²�Ʒ�۸�
					//String price = (String)prodObj.get("PROD_PRICE");
					//message = message + getPrice(price) + "Ԫ";
					//�����շѱ�ʶ
				}*/
			}
			resultMp.put("Anci_flag","");
        }
        else
        {
          if(null != timesList && timesList.size() > 0)
          {
            //���β�Ʒ����
            prodObj = (Map)timesList.get(0);
            //���β�Ʒ����
            String prodName = (String)prodObj.get("PROD_NAME");
            //��ʾ��Ϣ
            message = "�ý�Ŀ�����շ�,�۸�:";

            // ��ȡӰƬ�ļ۸�
            MetaData meta = new MetaData(request);
            // ��ȡVOD��������Ϣ
            Map vodDetail = meta.getVodDetailInfo(intProgId);
            String price = (String)vodDetail.get("VODPRICE");
            message = message + getPrice(price) + "Ԫ";
            //�����շѱ�ʶ
            resultMp.put("Anci_flag","Anci_flag");
          }
        }
      }
      resultMp.put("prodObj", prodObj);
      resultMp.put("message",message);
          break;

        /* ӰƬ�Ѳ����� */
        case AUTH_VOD_NOTEXISTS:
           resultMp.put("retCode",new Integer(resultCode).toString());
           message = "ӰƬ�Ѳ�����";
           resultMp.put("message",message);
           break;

        /* �����ɹ� */
        case OPER_SUCESS:
           message = "�����ɹ�";
           /**����ѵ㲥�Ľ�Ŀ��������������Ӽ�����ͬʱ���Ϊ�ѵ㲥���������Ӽ�   */
           addPlayedVod(request,intProgId,intParentVodId,intPlayType);
           resultMp.putAll(authInfo);
           break;

        /* �������� */
        default:
            resultMp.put("retCode",new Integer(resultCode).toString());
            Object messObj = errorMap.get(new Integer(resultCode));
            //��ֹǰ̨ҳ��Ĵ����벻ȫ������ҳ�淢������
            if(null == messObj || "null".equals(messObj) || "".equals(messObj))
            {
              message = "����ʧ��";
            }
            else
            {
              message = messObj.toString();
            }
            resultMp.put("message",message);
            break;
  }
  request.setAttribute("resultMp",resultMp);
  request.setAttribute("comeType",comeType);  
%>
<jsp:forward page="<%= fowardpath%>"></jsp:forward>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#000000">
  <table width="720" height="340" border="0">
    <tr>
      <td width="720" height="300">&nbsp;</td>
    </tr>
    <tr>
      <td align="center" style="font-size:18px;color:#FFFFFF" valign="top">�����У����Ժ�...</td>
    </tr>
   </table>
</body>
</html>

