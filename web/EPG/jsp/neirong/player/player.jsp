<%@ page pageEncoding="UTF-8"%>
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
<%@ include file="../../defaultHD/en/datajspHD/util_prePlay.jsp" %>
<%@ page import="com.huawei.iptvmw.epg.util.EPGUtil" %>
<%@ include file="../../common4dtv/jsp/config.jsp" %>
<%!

    /**
     * 判断当前用户是否订购基本业务包 1:如果没有配置基本包，则认为不用验证基本包的授权
     * @param basicProductIds :基本包的产品编号数组:应该在配置文件中存在
     * @return boolean
     */
    public boolean hasOrderBase(String[] basicProductIds,HttpServletRequest request)
    {
        // 2011-8-19宽视学堂新增加，宽视学堂下同步辅导不判断基本包
        String baseFlag = request.getParameter("baseFlag");
        baseFlag = baseFlag == null ? "" : baseFlag.trim();
        if("0".equals(baseFlag))
        {
            //baseFlag=0 时不需要判断基本包，直接返回true
            return true;
        }
        //如果基本包配置为空或者长度为0,则默认为通过基本包授权
        if ((null == basicProductIds) || basicProductIds.length == 0)
        {
            return true;
        }
        ServiceHelp help = new ServiceHelp(request);

        // 取容灾标志，如果容灾不进行基本包判断
        String rzFlag = (String) request.getSession(true).getAttribute("LOGINOCCASION");
        if ("1".equals(rzFlag))
        {
            return true;
        }
        //获取用户已订购的产品ID
        List productIdList = help.getMonthSuites(EPGConstants.USER_ORDERED_PRODUCT);
        //进行基本包判断（只要配置的基本包数组有有一个相同就说明配置了基本包）
        if(null != productIdList && productIdList.size() > 0)
        {
            for(int i = 0; i < productIdList.size(); i ++)
            {
                String prodId = (String)productIdList.get(i);
                for(int j = 0; j < basicProductIds.length; j ++)
                {
                    //当用户订购的产品中包含基本包的配置,则基本包授权成功
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
     * 是否包含在可免费观看的栏目列表内
     * @param freeTypeIdArr 表示免费的栏目列表
     * @param typeIds 表示当前需要验证的栏目列表
     * @return
     */
    private boolean freeTypeCheck(String[] typeIds,String[] freeTypeIdArr)
    {
        //免费栏目编号数组 freeTypeIdArr
        for(int i = 0; i < typeIds.length; i++)
        {
            for(int j = 0; j < freeTypeIdArr.length; j++)
            {
                //由于IPTV的栏目结构和DTV栏目结构不同，故判断条件改为栏目编号相等，对该栏目下的子栏目无效
                if(typeIds[i].equals(freeTypeIdArr[j]))
                {
                    return true;
                }
            }
        }
        return false;
    }


    //检查该TVOD是否免费
    //1：tvod的栏目免费
    //2：是否定购基本包
    public boolean tvodCheck(String typeId,String[] freeTypeIdArr,HttpServletRequest request)
    {
        if (!freeTypeCheck(new String[] {typeId},freeTypeIdArr))
        {
            //如果没有找到免费的栏目，则需要检查当前用户是否定购基本产品包
            return hasOrderBase(BASIC_PRODUCT_IDS,request);
        }
        else//节目所在栏目不需要检查用户是否订购基本包基本包
        {
            return true;
        }
    }

    //检查该VOD是否免费
    //1：vod的栏目免费
    //2：是否定购基本包
    public boolean vodCheck(String progId,String typeId,String[] freeTypeIdArr,HttpServletRequest request)
    {
        if (StringUtils.isEmpty(typeId))
        {
            MetaData metaData = new MetaData(request);
            int intProgId = Integer.parseInt(progId);
            Map filmInfoMap = metaData.getVodDetailInfo(intProgId);
            //获取该节目的父栏目编号数组
            String[] parentIds = (String[])filmInfoMap.get("allTypeId");
            //判断是否免费：1：不免费，接着进行基本包授权；2：免费，直接授权成功
            if (!freeTypeCheck(parentIds,freeTypeIdArr))
            {
                //如果没有找到免费的栏目，则需要检查当前用户是否定购基本产品包
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
                //如果没有找到免费的栏目，则需要检查当前用户是否定购基本产品包
                return hasOrderBase(BASIC_PRODUCT_IDS, request);
            }
            //节目所在栏目不需要检查用户是否订购基本包基本包
            else
            {
                return true;
            }
        }
    }

    /**
     *  组装播放通知的url
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

        //将MPEG2或者MPEG4转化成MPEG-2MPEG-4
        if("MPEG2".equals(mediaStyle))
        {
            mediaStyle = "MPEG-2";
        }
        else if("MPEG4".equals(mediaStyle))
        {
            mediaStyle = "MPEG-4";
        }
        //机顶盒版本号:1.0：新版本
        String isNewClient = (String)request.getSession().getAttribute("isNewVersion");
        switch (playtype)
        {
            //影片
            case PLAYTYPE_VOD:
                //片花
            case PLAYTYPE_ASSESS:
                //vod书签
            case PLAYTYPE_BOOKMARK:
                // 连续剧
            case PLAYTYPE_SITCOM:
                // 连续剧书签
            case 14:
                //判断播放路径是用IP或者Cable下发的。若ipqamUrl是空则是用IP下发
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
            //电视回看
            case PLAYTYPE_TVOD:
                //节目单对象
                Map progMap = metaData.getProgDetailInfo(proId);
                //节目单开始时间
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

    // 获取时间的毫秒数
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
     * 获取STB播放信息上报的地址
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
     * 返回JSON格式的palyurl，只需将这个参数写入Client提供的playurl字段即可实现播放。
     *
     * @param jsonRtsp：JSON格式的rtsprul
     * @param starttime: 节目的开始时间
     * @param startscale: 播放倍速
     * @return
     */
    public String getJsonPlayUrl(int playtype, String jsonRtsp, String reporturl, String sessionid,
                                 String starttime, String startscale)
    {
        //创建rtsp的json格式对象
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

        //playurl中有冒号，ipanel浏览器和Client解析时需要两个转意符，
        //调用iPanel.ioctWrite()时需要解析
        return jsonPlayUrl.toString().replaceAll("\"", "\\\\\"");
    }

    //获取vod的媒体对象
    public VODMediaFile getVODMediaFile(int playType, Map mp, HttpServletRequest request)
    {
        MetaData meta = new MetaData(request);
        //vod编号
        String proId = (String)mp.get("progId");
        int intProId = Integer.parseInt(proId);
        //vod对象
        Map vodDetail = meta.getVodDetailInfo(intProId);
        //获取机顶盒支持播放的媒体格式
        String decodemode = (String)mp.get("decodemode");

        //与vod关联的媒体文件列表
        List mediaList = null;

        // 判断是取正片还是取片花
        if (playType == 5)
        {
            mediaList = (List)vodDetail.get("CLIPFILES");
        }
        else
        {
            mediaList = (List)vodDetail.get("VODFILES");
        }

        //获取制定媒体格式的媒体文件对象
        if(null != mediaList && mediaList.size() > 0)
        {
            String[] decodemodes = decodemode.split(";");
            for(int i = 0; i < decodemodes.length; i ++)
            {
                //标识媒体格式是否支持高清:1:高清;2:标清,默认是标清
                int isHD = 2;

                /******* 20111122 ycg 重庆通过解码能力是否包含264来判断高清 *******/
//	System.out.println("=====================decodemodes=="+decodemodes[i]);
                if(decodemodes[i].indexOf("264") != -1 || decodemodes[i].indexOf("265") != -1)
                {
                    isHD = 1;
                }

                /****************************** 结束 ******************************/

		/*
        if(decodemodes[i].endsWith("HD"))
        {
          isHD = 1;
        }
		*/
                //将视频格式MPEG-2适配成MPEG2
                if(decodemodes[i].startsWith("MPEG-2"))
                {
                    decodemodes[i] = "MPEG2";
                }
                for(int j = 0; j < mediaList.size(); j ++)
                {
                    //当媒体格式匹配到一个时,就返回这个媒体的媒体编号
                    VODMediaFile vodMediaFile = (VODMediaFile)mediaList.get(j);
                    //媒体的清晰度
                    int mediaHD = vodMediaFile.getDefinition();
                    //媒体类型
                    int type = vodMediaFile.getType();
                    //媒体的编码格式
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

    //调用实际的授权接口对用户的请求进行授权操作
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
        String FSNTypeId = (String)mp.get("FSNTypeId");
        //System.out.println("neVodId=="+neVodId);
        //ServiceGroupId
        String serviceGroupId = (String)mp.get("servicegpid");
        int intServiceGroupId = Integer.parseInt(serviceGroupId);
        //频道编号
        String chanId = (String)mp.get("chanId");
        //媒体编号
        String mediaId = "";
        //媒体的码率
        int bitRate = 0;
        //rtsp路径
        String rtspUrl = "";
        //媒体格式,默认的是MPEG2
        String mediaStyle = "MPEG2";
        //媒体对象
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

        //将获得的媒体编号存入mp中,在用户订购中需要用到
        mp.put("mediaId", mediaId);

        //内容类型
        int contentType = Integer.parseInt((String)mp.get("contentType"));
        //业务类型
        int businessType = Integer.parseInt((String)mp.get("businessType"));
        //授权接口
        //System.out.println("Authorization intPlayType="+ intPlayType + ", typeId = "+ typeId+", neVodId=="+neVodId+", chanId=="+chanId);
        String extPar1 = "";
        String extPar2 = "";
        if("".equals(FSNTypeId)){
            extPar2 = typeId;
        }else{
            extPar2 = FSNTypeId;
        }
        //外部id
        if((null != neVodId) && !"null".equals(neVodId) && !"".equals(neVodId))
        {
            extPar1 = neVodId;
        }
        //回看频道号
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
                Integer.parseInt((String)mp.get("parentVodId")),   //父集编号
                bitRate,
                intServiceGroupId,
                bandwidth,
                extPar1,
                extPar2);

        if (authMap == null)
        {
            //授权接口调用失败，或soap接口超时未返回
            authMap = new HashMap();
            authMap.put("retCode",new Integer(-101));
            return authMap;
        }

        //节目名称
        String vodName   = null;

        //节目时长
        long timeLength  = 0;

        //节目开始播放时间
        String starttime = null;
        String reportUrl = null;
        String playUrl = null;
        //授权成功
        if (((Integer)authMap.get("RETCODE")).intValue() == 0)
        {
            Map loginVoMap = (Map)request.getSession().getAttribute("loginVo");
            rtspUrl = help.getRtspUrl4DTV((String)loginVoMap.get("icID"), (String)loginVoMap.get("ip"), authMap);

            //上报url
            String sessId = (String)authMap.get("sessID");
            String requesturl =  (String)mp.get("requesturl");

            //查询数据方法
            MetaData metaData = new MetaData(request);
            reportUrl = getReportUrl(requesturl, sessId, request);
            if((intPlayType == PLAYTYPE_ASSESS) || (intPlayType == PLAYTYPE_VOD)
                    || (intPlayType == PLAYTYPE_BOOKMARK) || (intPlayType == PLAYTYPE_SITCOM)|| (intPlayType == 14))
            {
                Map vodHp = metaData.getVodDetailInfo(intProId);
                vodName = (String)vodHp.get("VODNAME");

                if(rtspUrl.indexOf("playseek=") != -1)
                {
                    // 当有时间打点时的处理
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
                // 读取节目单的详细信息
                Map progMap = metaData.getProgDetailInfo(intProId);
                vodName = (String)progMap.get("PROGNAME");
                timeLength = (getLongMsec((String)progMap.get("ENDTIME"))- getLongMsec((String)progMap.get("STARTTIME"))) / 1000;
            }

            //按次订购中需要用到这个参数
            mp.put("elapseTime", String.valueOf(timeLength));
            //心跳时间
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

            //CA授权EMM信息（16进制字符串）在播放加扰的VOD时有效，用于返回EMM数据.buxiaopeng,20080704
            Object emm = authMap.get("EMM");
            if ((emm != null) && (!emm.equals("")))
            {
                authMap.put("emm",emm);
            }
        }
        //授权失败
        else
        {
            authMap.put("retCode",(Integer)authMap.get("RETCODE"));
        }

        return authMap;
    }


    /**
     * 接口调用发生其他错误，显示具体错误信息
     */
    public Map DefaultResultDeal(Map codeMp,String message)
    {
        Map result = new HashMap();
        result.put("message",message);
        result.put("retCode", codeMp.get("retCode"));
        //处理返回
        result.put("removeLastRequest", Boolean.TRUE);
        return result;
    }

    /**
     * 接口调用发生其他错误，显示具体错误信息
     */
    public Map vodNotExists(Map codeMp,String message)
    {
        Map result = new HashMap();
        result.put("message",message);
        result.put("retCode", codeMp.get("retCode"));
        //处理返回
        result.put("removeLastRequest", Boolean.TRUE);
        return result;
    }

    /**
     * 接口调用发生其他错误，显示具体错误信息
     */
    public Map failQueryokIDeal(Map codeMp,String message)
    {
        Map result = new HashMap();
        result.put("message",message);
        result.put("retCode", codeMp.get("retCode"));
        //处理返回
        result.put("removeLastRequest", Boolean.TRUE);
        return result;
    }

    /**
     * 接口调用发生其他错误，显示具体错误信息
     */
    public Map failNoOrderIDeal(Map codeMp,String message)
    {
        Map result = new HashMap();
        result.put("message",message);
        result.put("retCode", codeMp.get("retCode"));
        //处理返回
        result.put("removeLastRequest", Boolean.TRUE);
        return result;
    }
    /**
     * 接口调用发生其他错误，显示具体错误信息
     */
    public Map authIsNullIDeal(Map codeMp,String message)
    {
        Map result = new HashMap();
        result.put("message",message);
        result.put("retCode", codeMp.get("retCode"));
        //处理返回
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
        //授权的结果
        result.put("message",message);
        //播放路径：
        result.put("playurl", codeMp.get("playUrl"));
        //上报机顶盒路径：
        result.put("reporturl", codeMp.get("reportUrl"));
        //CA授权EMM信息:
        result.put("emm", codeMp.get("emm"));
        //当前节目编号:
        result.put("proId", codeMp.get("proId"));
        //当前节目所在的栏目编号:
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
     * 将传入的秒数折合成天数
     * 不足一天时,按一天算
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
     * 根据栏目编号，获取栏目名称
     *
     * @param typeId
     *       栏目编号
     * @param request
     *       请求对象
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
     * 处理播放类型为电视回看时的业务
     *
     * @param vodid
     *            当前播放的节目单编号
     * @param request
     *            请求对象
     * @param chanid
     *            当前频道编号
     * @param typename
     *            栏目名称
     */
    public void operateTvod(String vodid, HttpServletRequest request,
                            String chanid)
    {
        Map chanMap = null;
        MetaData mt = new MetaData(request);
        // 如果频道编号不为空
        if ((null != chanid) && !"".equals(chanid))
        {
            chanMap = mt.getChannelInfo(chanid);
        }

        // 如果频道信息不为空
        if (chanMap != null)
        {
            // 当前频道支持的回看天数
            int scd = ((Integer)chanMap.get("RECORDLENGTH")).intValue();
            long scds = (long) scd;
            int dates = getDaysBySecond(scds);
            int progId = Integer.parseInt(vodid);
            Map progInfo = mt.getProgDetailInfo(progId);
            // 当前节目不为空
            if (null != progInfo)
            {
                getNtBkTvodpro(progInfo, vodid, dates, request);
            }
        }
    }

    /**
     * 获取当前Tvod节目上下节目信息
     *
     * @param vodvo
     *            当前播放的节目的详细信息
     * @param dates
     *            当前频道允许回看的天数
     * @param request
     *            请求对象
     */
    public void getNtBkTvodpro(Map progBill, String progId, int dates,
                               HttpServletRequest request)
    {
        request.getSession().setAttribute("detailvo", progBill);

        // 当前频道编号
        String currentchanid = (String)progBill.get("CHANNELID");
        Map nextpro = queryPronamebycurrentPor(progId, currentchanid, "backward", request);

        // 下一节目不为空
        if (null != nextpro)
        {
            // 存储下一节目信息
            request.getSession().setAttribute("nextpro", nextpro);
        }

        getBackTvodpro(progId, currentchanid, dates, request);
    }

    /**
     * 获取当前播放节目的上一节目信息
     *
     * @param currentproid
     *            当前节目编号
     * @param currentchanid
     *            当前频道编号
     * @param dates
     *            当前频道允许回看的天数
     * @param request
     *            请求对象
     */
    public void getBackTvodpro(String currentproid, String currentchanid,
                               int dates, HttpServletRequest request)
    {
        Map progMap = queryPronamebycurrentPor(currentproid,
                currentchanid, "forward", request);

        // 上一节目不为空
        if (null != progMap)
        {
            // 上一节目的开始时间
            String starttime  = (String)progMap.get("STARTTIME");
            DateFormat format = new SimpleDateFormat("yyyyMMdd0000");
            Calendar rightNow = Calendar.getInstance();
            rightNow.add(Calendar.DAY_OF_MONTH, -dates);
            String nowdata = format.format(rightNow.getTime());
            if (starttime.substring(0, 8).equals(nowdata.substring(0, 8))) // 已经过期了
            {
                if (!starttime.substring(8, 10).equals("00"))
                {
                    //"请求至的上一节目已经过期！"
                    progMap = null;
                }
            }
            // 存储上一节目信息
            request.getSession().setAttribute("backpro", progMap);
        }
    }

    /**
     * 根据当前节目编号查询上一节目和下一节目的信息
     *
     * @param ProgID
     *            当前节目编号
     * @param ChannelID
     *            当前频道编号
     * @param Direction
     *            请求的方向
     * @param request
     *            请求对象
     * @return
     */
    public Map queryPronamebycurrentPor(String ProgID,
                                        String ChannelID, String Direction, HttpServletRequest request)
    {
        MetaData mt = new MetaData(request);
        // 重构请求路径
        String playurl = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort() + request.getContextPath()
                + "/jsp/TvodSkip.jsp?Direction=" + Direction + "&ProgID="
                + ProgID + "&ChannelID=" + ChannelID;
        String info = remoteHttpService(playurl, request.getSession()
                .getId());

        String[] Skipinfos = info.split("\n");
        // 获得代表返回码的字符串 如 errorcode = 0
        String SkipErrorCode = Skipinfos[0];
        String[] SkipErrorCodes = SkipErrorCode.split("=");
        // 获得截取后的返回码
        int Skiprecode = Integer.parseInt(SkipErrorCodes[1]);
        // 0代表请求播放资源成功
        if (Skiprecode == 0)
        {
            // 获得代表节目编号的字符串, 如 ProgID=24343;
            String ProgIDinfo = Skipinfos[2];
            String[] ProgIDs = ProgIDinfo.split("=");
            // 获得最后的节目单编号
            String progid = ProgIDs[1];
            return mt.getProgDetailInfo(Integer.parseInt(progid));
        }
        else
        {
            // 请求资源失败
            return null;
        }
    }

    /**
     * 远程http接口调用
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

            //如果sessionId不等于null，设置sessionId用于指定会话
            if (null != sessionId)
            {
                conn.addRequestProperty("Cookie", "JSESSIONID=" + sessionId);
            }

            conn.connect();
            in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            while (null != temp)
            {
                //读取返回信息
                temp = in.readLine();
                //规避掉“<br>”,不知道如何产生的。
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

    /**添加已点播的节目，如果是连续剧子集，则同时添加为已点播的连续剧子集   */
    public void addPlayedVod(HttpServletRequest request, int vodId, int parentId, int playType)
    {
        //已点播的节目
        ArrayList played = (ArrayList)request.getSession().getAttribute("playedFilms");
        if(null == played)
        {
            played = new ArrayList(20);
        }

        //已点播连续剧
        ArrayList sitcom = (ArrayList)request.getSession().getAttribute("playedSitcoms");
        if(null == sitcom)
        {
            sitcom = new ArrayList(20);
        }

        Integer sitId = new Integer(vodId);
        Integer parentVodId = new Integer(parentId);
        //添加连续剧子集
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
            //连续剧添加父ID
            if(played.contains(parentVodId))
            {
                played.remove(parentVodId);
            }
            played.add(0,parentVodId);
        }
        //添加点播节目
        else if(playType == 1)
        {
            //点播节目
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
    <title>播控授权页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<%
    // 转发路径
    String fowardpath = "geninfo.jsp";
    String queryString=request.getQueryString();
    //System.out.println("authorization queryString="+queryString);
    // 影片编号
    String progId = request.getParameter("progId");
    String neVodId = "";
    // 连续剧父集vodid
    String parentVodId = request.getParameter("parentVodId");

    String idType = request.getParameter("idType");//第三方标记
    // 播放类型
    String playtype = request.getParameter("playType");

    if ("FSN".equals(idType)){
        neVodId  = progId;
        MetaData md = new MetaData(request);
        Map vodMap = md.getContentDetailInfoByForeignSN(progId, 0);
        if (null != vodMap)  {
            progId  = String.valueOf(vodMap.get("VODID"));
            if(playtype.equals("11")){//兼容电视剧子集一键跳转;
                parentVodId = String.valueOf(vodMap.get("FATHERVODID"));
            }
        }
    }

    int intProgId = StringToInt(progId, -1);
    int intParentVodId = StringToInt(parentVodId, -2);
    int intPlayType = StringToInt(playtype,-1);

    //System.out.println("authorization progId="+progId+",intParentVodId="+intParentVodId+",intPlayType="+intPlayType);

    String auth_next = request.getParameter("auth_next");
    if(null != auth_next && "" != auth_next){
        TurnPage turnPage = new TurnPage(request);
        turnPage.removeLast();
    }


    String bytype = request.getParameter("bytype");//获取栏目类型(用于区分从哪个栏目进来)
    String ishd = request.getParameter("isHd");
    int intishd =0;
    if(null == ishd || "null".equals(ishd) || "".equals(ishd)){
        intishd = 0;
    }else{
        intishd = StringToInt(ishd, -1);
    }

    // 栏目编号
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
    // 栏目名称
    String typename = getTypeNameByTypeId(typeId,request);

    // 频道编号,若没有直时默认为空
    String chanId   = request.getParameter("chanId");
    // int intChanId = StringToInt(chanId, 0);



    //播放的内容类型
    String contentType = request.getParameter("contentType");
    int intContentType = StringToInt(contentType, -1);

    // 业务类型
    String businessType = request.getParameter("business");
    int intBusinessType = StringToInt(businessType, -1);

    //媒体支持格式
    String decodemode = (String)session.getAttribute("decodemode");
    //媒体ID
    String smediaId = request.getParameter("mediaId");

  /*String smediaId = request.getParameter("mediaId");
  System.out.println("aaaa  tttt");
  if(("".equals(smediaId) || (null == smediaId)){
	  smediaId = "0";
  }
  System.out.println("zenglt auth smediaId="+smediaId);
  */
    // 书签开始播放时间 (只有播放类型是VOD书签或者是电视剧书签才有效)
    String starttime = request.getParameter("startTime");
    if (("".equals(starttime) || (null == starttime)) && (intPlayType != 6 || intPlayType != 14))
    {
        starttime = "0";
    }

    // 在小窗口播放片花时需传入此参数控制trickmode的操作
    String tkmode = request.getParameter("tkmode");
    if(StringUtils.isEmpty(tkmode))
    {
        tkmode = "1";
    }

    // 在小窗口播放片花时需传入此参数控制osd的显示
    String osd = request.getParameter("osd");
    if(StringUtils.isEmpty(osd))
    {
        osd = "1";
    }

    // 当前请求路径
    String requesturl = request.getRequestURL().toString();

    /* 新添加的，影片所在的模板信息 */
    String tw_record_template = request.getParameter("tw_record_template");
    if ("".equals(tw_record_template) || (null == tw_record_template))
    {
        tw_record_template = "template1";
    }

    /* 新添加的，从图文首页和列表页面进入授权播放时的标记，便于返回 */
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
    String FSNTypeId = request.getParameter("FSNTypeId");
    if(null == FSNTypeId || "".equals(FSNTypeId)){
        FSNTypeId = "";
    }

    // 准备数据，后边函数使用
    Map mp = new HashMap();
    mp.put("progId", String.valueOf(intProgId));
    mp.put("parentVodId", String.valueOf(intParentVodId));
    mp.put("typeId", typeId);
    mp.put("chanId", String.valueOf(chanId));
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
    mp.put("neVodId", neVodId);//外部ID
    mp.put("FSNTypeId", FSNTypeId);


    /***********************************开始审批*******************************************************/

    //审批后的返回码   0: 授权成功
    int resultCode = 0;

    Map authInfo = new HashMap();

    switch (intPlayType)
    {
        // 电视回看
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

        // 片花
        case 5:
            authInfo = checkAuth(mp, request);
            resultCode = Integer.parseInt(authInfo.get("retCode").toString());
            break;

        // 其他（影片，电视剧及书签）
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
    /***********************************对返回结果进行处理*****************************************************/

    Map resultMp = new HashMap();
    resultMp.putAll(mp);
    String message = "";

    /* 将图文相关页面传进来的参数进行封装，传递*/
    resultMp.put("tw_record_template", tw_record_template);
    resultMp.put("tw_record_flag", tw_record_flag);
    switch (resultCode)
    {
        /* 没有订购基本业务 */
        case AUTH_FAIL_NO_ORDERBASE:
            if(intishd == 1){
                message = "欢迎订购TV+高清版点播套餐，39元/月，详询96868.";
            }else{
                message = "您未订购基本产品包，请先到营业厅订购.";
            }

            resultMp.put("message",message);
            resultMp.put("retCode",new Integer(resultCode).toString());
            break;

        /* 鉴权结果为空 */
        case AUTH_RESULT_ISNULL:
            message = "系统忙，请稍候再试.";
            resultMp.put("message",message);
            resultMp.put("retCode",new Integer(resultCode).toString());
            break;

        /* 没有订购产品 */
        //重庆无网络录像
        case AUTH_FAIL_NO_ORDER:

            message = "您没有订购产品 [";
            if(intPlayType == PLAYTYPE_TVOD)
            {
                message = message + "电视回看";
            }
            message = message + "],请到营业厅办理.";
            resultMp.put("message",message);
            resultMp.put("retCode",new Integer(resultCode).toString());
            break;

        /* 授权失败，订购查询成功 */
        case AUTH_FAIL_QUERYOK:
        case AUTH_FAIL_QUERYOK_IPTV:
            resultMp.put("retCode",new Integer(resultCode).toString());

            //产品对象
            Map prodObj = null;
            //包月产品列表
            List monthList = (List)authInfo.get("MONTH_LIST");
            //按次订购产品列表
            List timesList = (List)authInfo.get("TIMES_LIST");
            // 2011-8-19宽视学堂新增加，宽视学堂下同步辅导为包月产品
            String baseFlag = request.getParameter("baseFlag");
            baseFlag = baseFlag == null ? "" : baseFlag.trim();
            if("0".equals(baseFlag))
            {
                //baseFlag=0 将 orderType 设置为包月订购
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
                    //按次产品对象
                    prodObj = (Map)timesList.get(0);
                    //按次产品名称
                    String prodName = (String)prodObj.get("PROD_NAME");
                    //提示信息
                    message = "该节目按次收费,价格:";

                    // 获取影片的价格
                    MetaData meta = new MetaData(request);
                    // 获取VOD的详情信息
                    Map vodDetail = meta.getVodDetailInfo(intProgId);
                    String price = (String)vodDetail.get("VODPRICE");
                    message = message + getPrice(price) + "元";
                    //按次收费标识
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
                        }else if("100473".equals(prodCode)){
                            countNum += 32;
                        }else if("100359".equals(prodCode)){
                            countNum += 64;
                        }else if("100185".equals(prodCode)){
                            countNum += 128;
                        }
                        //System.out.println("prodCode=="+prodCode+",,prodName="+prodName);
                        //prodCodeList.add(prodCode);
                    }
                    //System.out.println("countNum=="+countNum);
                    if(countNum == 5){
                        message = "请开通TV+产品即可回看本节目。";
                    }else if(countNum == 8 || countNum == 10){
                        message = "请升级为直播增强产品，即可回看本节目。";
                    }else if(countNum == 15 || countNum == 31){
                        message = "请升级为直播增强产品或开通TV+产品，即可回看本节目。";
                    }else if(countNum == 36 || countNum == 32){
                        message = "您没有订购包月产品[来点播],请到营业厅办理.";
                    }else if(countNum == 64){
                        message = "您没有订购包月产品[凤凰专区],请到营业厅办理.";
                    }else if(countNum == 128){
                        message = "您没有订购包月产品[韩剧专区],请到营业厅办理.";
                    }else{
                        //message = "欢迎订购TV+高清版点播套餐，39元/月，详询96868.";
                        message = "您没有订购包月产品 [";
                        //包月产品对象
                        prodObj = (Map)monthList.get(0);
                        //包月产品名称
                        String prodName = (String)prodObj.get("PROD_NAME");
                        //System.out.println("prodName=="+prodName);
                        //提示信息
                        //message = "您可以订购包月产品 " + prodName + ",价格：";
                        if(bytype == null || bytype.equals("")){
                            message = message + prodName +"]，请到营业厅办理.";
                        }else if(bytype.equals("hj")){
                            message = message + prodName +"]，请在“电视营业厅”—“点播电视”里在线订购或到营业厅办理.";
                            resultMp.put("hj_yyt","hj_yyt");//韩剧专区跳转电视营业厅特殊处理
                        }
                    }
                    //按次收费标识
                    resultMp.put("Anci_flag","");
                }
            }
            else
            {
                if(null != monthList && monthList.size() > 0)
                {
                    //List<String>  prodCodeList = new ArrayList<String>();

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
                        }else if("100473".equals(prodCode)){
                            countNum += 32;
                        }else if("100359".equals(prodCode)){
                            countNum += 64;
                        }else if("100185".equals(prodCode)){
                            countNum += 128;
                        }
                        //System.out.println("prodCode=="+prodCode+",,prodName="+prodName);
                        //prodCodeList.add(prodCode);
                    }
                    //System.out.println("countNum=="+countNum);
                    if(countNum == 5){
                        message = "请开通TV+产品即可回看本节目。";
                    }else if(countNum == 8 || countNum == 10){
                        message = "请升级为直播增强产品，即可回看本节目。";
                    }else if(countNum == 15 || countNum == 31){
                        message = "请升级为直播增强产品或开通TV+产品，即可回看本节目。";
                    }else if(countNum == 36 || countNum == 32){
                        message = "您没有订购包月产品[来点播],请到营业厅办理.";
                    }else if(countNum == 64){
                        message = "您没有订购包月产品[凤凰专区],请到营业厅办理.";
                    }else if(countNum == 128){
                        message = "您没有订购包月产品[韩剧专区],请到营业厅办理.";
                    }else{
                        message = "您没有订购包月产品 [";
                        //包月产品对象
                        prodObj = (Map)monthList.get(0);
                        //包月产品名称
                        String prodName = (String)prodObj.get("PROD_NAME");
                        //提示信息
                        //message = "您可以订购包月产品 " + prodName + ",价格：";
                        if(bytype == null || bytype.equals("")){
                            message = message + prodName +"]，请到营业厅办理.";
                        }else if(bytype.equals("hj")){
                            message = message + prodName +"]，请在“电视营业厅”—“点播电视”里在线订购或到营业厅办理.";
                            resultMp.put("hj_yyt","hj_yyt");//韩剧专区跳转电视营业厅特殊处理
                        }
                    }
                    //第一个包月产品价格
                    //String price = (String)prodObj.get("PROD_PRICE");
                    //message = message + getPrice(price) + "元";
                    //按次收费标识
                    resultMp.put("Anci_flag","");
                }
                else
                {
                    if(null != timesList && timesList.size() > 0)
                    {
                        //按次产品对象
                        prodObj = (Map)timesList.get(0);
                        //按次产品名称
                        String prodName = (String)prodObj.get("PROD_NAME");
                        //提示信息
                        message = "该节目按次收费,价格:";

                        // 获取影片的价格
                        MetaData meta = new MetaData(request);
                        // 获取VOD的详情信息
                        Map vodDetail = meta.getVodDetailInfo(intProgId);
                        String price = (String)vodDetail.get("VODPRICE");
                        message = message + getPrice(price) + "元";
                        //按次收费标识
                        resultMp.put("Anci_flag","Anci_flag");
                    }
                }
            }
            resultMp.put("prodObj", prodObj);
            resultMp.put("message",message);
            break;

        /* 影片已不存在 */
        case AUTH_VOD_NOTEXISTS:
            resultMp.put("retCode",new Integer(resultCode).toString());
            message = "影片已不存在";
            resultMp.put("message",message);
            break;

        /* 操作成功 */
        case OPER_SUCESS:
            message = "操作成功";
            /**添加已点播的节目，如果是连续剧子集，则同时添加为已点播的连续剧子集   */
            addPlayedVod(request,intProgId,intParentVodId,intPlayType);
            resultMp.putAll(authInfo);
            break;

        /* 其它错误 */
        default:
            resultMp.put("retCode",new Integer(resultCode).toString());
            Object messObj = errorMap.get(new Integer(resultCode));
            //防止前台页面的错误码不全，导致页面发生错误
            if(null == messObj || "null".equals(messObj) || "".equals(messObj))
            {
                message = "操作失败";
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
        <td align="center" style="font-size:18px;color:#FFFFFF" valign="top">处理中，请稍候...</td>
    </tr>
</table>
</body>
</html>
