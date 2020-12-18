<%@ page language="java" import="com.huawei.iptvmw.epg.bean.MetaData" pageEncoding="UTF-8" %>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%!
    /**
     *
     * @param posterMap
     * @param type  //图片类型有:  0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
     * @param index
     * @return
     */
    private String getPicture(Object posterMap, int type, int index) {
        String defaultPic = "../../neirong/images/default_preview_lb.png";
        //如果没有取到任何图片时,返回一张默认图片.
        if (posterMap == null) {
            return defaultPic;
        } else {
            Map posterPath = (HashMap) posterMap;
            //图片类型有:  0 缩略图，1 海报 ，2 剧照 ，3 图标, 4 标题图 ，5 广告图 ， 6 草图 ， 7 背景图 ， 8 频道图片 ， 9 频道黑白图片 ， 10 频道名字图片 ， 11 其他
            String[] picArray = (String[]) posterPath.get(String.valueOf(type));
            //每一种图片可能会传多个图片,如果传多个图片时 index 值有效,
            //默认取第一张图片. 索引下村为:  0, 当 index = 1时,表示取第二张图片
            //此下标 和 后台无关,后台可以设置图片顺序,实际使用时, 如果只上传一张图片,即使后台上传图片时设置 大于 1的顺序时, 也用 0 来取.
            if (null == picArray || picArray.length <= index) return defaultPic;
            return picArray[index];
        }
    }

    private void print(JspWriter out, String message) {
        try {
            out.println("<!-- " + message + " -->");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>
<%
    String typeId = "10000100000000090000000000108721";
    MetaData meta = new MetaData(request);
    TurnPage turnPage = new TurnPage(request);
    try {
        String fcr = request.getParameter("ifcor");
        String playBack = request.getParameter("for_play_back");
        if (null == playBack) {
            if (null == fcr) {
                turnPage.addUrl();
            } else {
                turnPage.removeLast();
                turnPage.addUrl();
            }
        } else {
            turnPage.removeLast();
        }
    } catch (Exception e) {
    }

    List result = meta.getVodListByTypeId(typeId, 13, 0);//接口2.11    vod栏目下列表数据接口

    List vodList = (result != null && result.size() > 1) ? (List) result.get(1) : Collections.emptyList();

    //以下代码没有任何作用，所以注释
    //获取子栏目图标海报
    Map<String, String> subTypesPosters = new HashMap<String, String>();
    List subTypesResult = meta.getTypeListByTypeId(typeId, 99, 0);//接口2.14     vod栏目下栏目
    if (subTypesResult != null && subTypesResult.size() > 1) {
        for (int i = 0; i < ((List) subTypesResult.get(1)).size(); i++) {
            Map temp = (Map) ((List) subTypesResult.get(1)).get(i);
            subTypesPosters.put(temp.get("TYPE_ID").toString(), getPicture(temp.get("POSTERPATHS"), 5, 0));
        }
    }

    String filePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/" + "jsp/";
    Map typeMap = meta.getTypeInfoByTypeId(typeId);//接口2.14
    String titleName = typeMap.get("INTRODUCE") == null ? "" : typeMap.get("INTRODUCE").toString();

    for (int i = 0; i < vodList.size(); i++) {
        Map vodMap = (Map) vodList.get(i);
        String defaultPath = getPicture(vodMap.get("POSTERPATHS"), i <= 6 ? 5 : 1, 0);
        defaultPath = filePath + defaultPath.replace("../../", "");
        vodMap.put("PICPATH", defaultPath);
    }
%>
<!DOCTYPE html>
<html lang="en">
<meta name="page-view-size" content="1280*720">
<head>
    <meta charset="UTF-8">
    <title>免费专区</title>
    <style>
        body {
            width: 1280px;
            height: 720px;
            background: url("images/free/bg.jpg") no-repeat;
            position: relative;
            margin: 0;
            padding: 0;
        }
    </style>
    <script type="text/javascript" language="javascript">
        try{
            function debug(message, recall) {
                message = "FREEJS :" + message;
                if( typeof console !== 'undefined' ) {
                    console.log (message);
                } else if( typeof iPanel !== 'undefined' ) {
                    iPanel.debug (message);
                }
            };

            var isP60 =  typeof sysmisc != 'undefined';
            if( isP60 ) {
                var appendJS = function(path){
                    var script = document.createElement('script');
                    script.src = path;
                    script.type = 'text/javascript';
                    document.getElementsByTagName('head')[0].appendChild(script);
                };
                appendJS("js/bridge.js");
                appendJS("js/getUrl.js");
            }
        } catch( e ) {};
    </script>
</head>
<body leftmargin="0" topmargin="0" bottommargin="0">
<div style="width:1280px;height:720px;position: absolute;">
    <img src="images/free/top-bg.png" style="position: absolute;top: 0;left: 0;"/>
    <img src="images/free/logo.png" style="position:absolute;top: 30px;left: 86px;"/>
    <div id="titleName" style="position: absolute;width:780px;top: 32px;left: 216px;font-size: 18px;color: #BCCDF9;"></div>
    <div style="position: absolute;height: 580px;width: 1145px;overflow: hidden;top: 90px;left: 79px;">
        <div id="moveMain" style="width:100%;position: absolute;top: 0;left: 0;">
            <div id="vod_2" class="focus" style="position: absolute;top: 403px;left: 9px;width: 365px;height: 208px;">
                <div id="vod_2_1" style="position: absolute;top: -9px;left: -9px;width: 382px;height: 224px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_3" class="focus" style="position: absolute;top: 403px;left: 391px;width: 365px;height: 208px;">
                <div id="vod_3_1" style="position: absolute;top: -9px;left: -9px;width: 382px;height: 224px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_4" class="focus" style="position: absolute;top: 403px;left: 769px;width: 365px;height: 208px;">
                <div id="vod_4_1" style="position: absolute;top: -9px;left: -9px;width: 382px;height: 224px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_5" class="focus" style="position: absolute;top: 686px;left: 9px;width: 555px;height: 195px;">
                <div id="vod_5_1" style="position: absolute;top: -9px;left: -9px;width: 572px;height: 211px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_6" class="focus" style="position: absolute;top: 686px;left: 579px;width: 555px;height: 195px;">
                <div id="vod_6_1" style="position: absolute;top: -9px;left: -9px;width: 572px;height: 211px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_7" class="focus" style="position: absolute;top: 901px;left: 9px;width: 157px;height: 225px;">
                <img id="vod_7_2" src="/EPG/jsp/neirong/images/translateBg.png" style="width: 157px;height: 225px;position: absolute;top: 0;left: 0;">
                <div id="vod_7_0" style="position: absolute;top: 193px;left: 0;width: 157px;height: 32px;background: url('images/free/opacity.png') no-repeat;line-height: 32px;text-align: center;color: white;overflow: hidden;"></div>
                <div id="vod_7_1" style="position: absolute;top: -9px;left: -9px;width: 174px;height: 241px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_8" class="focus" style="position: absolute;top: 901px;left: 201px;width: 157px;height: 225px;">
                <img id="vod_8_2" src="/EPG/jsp/neirong/images/translateBg.png" style="width: 157px;height: 225px;position: absolute;top: 0;left: 0;">
                <div id="vod_8_0" style="position: absolute;top: 193px;left: 0;width: 157px;height: 32px;background: url('images/free/opacity.png') no-repeat;line-height: 32px;text-align: center;color: white;overflow: hidden;"></div>
                <div id="vod_8_1" style="position: absolute;top: -9px;left: -9px;width: 174px;height: 241px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_9" class="focus" style="position: absolute;top: 901px;left: 389px;width: 157px;height: 225px;">
                <img id="vod_9_2" src="/EPG/jsp/neirong/images/translateBg.png" style="width: 157px;height: 225px;position: absolute;top: 0;left: 0;">
                <div id="vod_9_0" style="position: absolute;top: 193px;left: 0;width: 157px;height: 32px;background: url('images/free/opacity.png') no-repeat;line-height: 32px;text-align: center;color: white;overflow: hidden;"></div>
                <div id="vod_9_1" style="position: absolute;top: -9px;left: -9px;width: 174px;height: 241px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_10" class="focus" style="position: absolute;top: 901px;left: 581px;width: 157px;height: 225px;">
                <img id="vod_10_2" src="/EPG/jsp/neirong/images/translateBg.png" style="width: 157px;height: 225px;position: absolute;top: 0;left: 0;">
                <div id="vod_10_0" style="position: absolute;top: 193px;left: 0;width: 157px;height: 32px;background: url('images/free/opacity.png') no-repeat;line-height: 32px;text-align: center;color: white;overflow: hidden;"></div>
                <div id="vod_10_1" style="position: absolute;top: -9px;left: -9px;width: 174px;height: 241px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_11" class="focus" style="position: absolute;top: 901px;left: 771px;width: 157px;height: 225px;">
                <img id="vod_11_2" src="/EPG/jsp/neirong/images/translateBg.png" style="width: 157px;height: 225px;position: absolute;top: 0;left: 0;">
                <div id="vod_11_0" style="position: absolute;top: 193px;left: 0;width: 157px;height: 32px;background: url('images/free/opacity.png') no-repeat;line-height: 32px;text-align: center;color: white;overflow: hidden;"></div>
                <div id="vod_11_1" style="position: absolute;top: -9px;left: -9px;width: 174px;height: 241px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_12" class="focus" style="position: absolute;top: 901px;left: 959px;width: 157px;height: 225px;">
                <img id="vod_12_2" src="/EPG/jsp/neirong/images/translateBg.png" style="width: 157px;height: 225px;position: absolute;top: 0;left: 0;">
                <div id="vod_12_0" style="position: absolute;top: 193px;left: 0;width: 157px;height: 32px;background: url('images/free/opacity.png') no-repeat;line-height: 32px;text-align: center;color: white;overflow: hidden;"></div>
                <div id="vod_12_1" style="position: absolute;top: -9px;left: -9px;width: 174px;height: 241px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>

            <div id="type_0" class="focus" style="position: absolute;width: 129px;height: 73px;left: 9px;top: 318px;background: url('images/free/f6.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_0_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_0_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="type_1" class="focus" style="position: absolute;width: 129px;height: 73px;left: 171px;top: 318px;background: url('images/free/f7.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_1_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_1_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="type_2" class="focus" style="position: absolute;width: 129px;height: 73px;left: 335px;top: 318px;background: url('images/free/f8.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_2_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_2_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="type_3" class="focus" style="position: absolute;width: 129px;height: 73px;left: 497px;top: 318px;background: url('images/free/f5.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_3_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_3_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="type_4" class="focus" style="position: absolute;width: 129px;height: 73px;left: 661px;top: 318px;background: url('images/free/f9.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_4_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_4_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="type_5" class="focus" style="position: absolute;width: 129px;height: 73px;left: 823px;top: 318px;background: url('images/free/f3.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_5_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_5_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="type_6" class="focus" style="position: absolute;width: 129px;height: 73px;left: 985px;top: 318px;background: url('images/free/f4.png') no-repeat;">
                <img src="/EPG/jsp/neirong/images/translateBg.png" id="type_6_0" style="position: absolute;width: 37px;height: 21px;top: -10px;left: 88px;visibility: hidden;">
                <div id="type_6_1" style="position: absolute;top: -9px;left: -9px;width: 146px;height: 89px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_0" class="focus" style="position: absolute;top: 9px;left: 9px;width: 555px;height: 300px;">
                <div id="vod_0_1" style="position: absolute;top: -9px;left: -9px;width: 572px;height: 316px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div id="vod_1" class="focus" style="position: absolute;top: 9px;left: 577px;width: 555px;height: 300px;">
                <div id="vod_1_1" style="position: absolute;top: -9px;left: -9px;width: 572px;height: 316px;border: 3px solid white;border-radius: 5px;visibility: hidden;"></div>
            </div>
            <div style="width: 325px;height: 24px;position: absolute;left: 9px;top: 643px;background: url('images/free/zuixin.png') no-repeat;"></div>
        </div>
    </div>
</div>
<div id="tgo_tan" style="position: absolute;width: 1280px;height: 720px;background: url(images/background.png) no-repeat;visibility: hidden;">
    <div id="tgo_tan_1" style="width: 200px;height: 82px;background: url(images/free/go_focus.png) no-repeat;position: absolute;top: 504px;left: 560px;"></div>
    <div id="tgo_tan_2" style="width: 200px;height: 82px;background: url(images/free/no.png) no-repeat;position: absolute;top: 504px;left: 780px;"></div>
</div>

<script type="application/javascript" src="js/global.js"></script>
<script>
    var typeId = '<%=typeId%>';
    var titleName = '<%=titleName%>';
    var linkStr = '/EPG/jsp/neirong/free/v1/free2.jsp';
    var vodArray = [];
    var isBooks = true;
    var fousIndex = 0;
    <% for(int i = 0; i < vodList.size(); i++){
        Map vodMap = (Map)vodList.get(i);
    %>
    vodArray.push({
        id: <%=vodMap.get("VODID").toString()%>,
        name: '<%=vodMap.get("VODNAME").toString()%>',
        pic: '<%=vodMap.get("PICPATH").toString()%>',
        isSitcom: '<%=vodMap.get("ISSITCOM").toString()%>'
    });
    <%} %>
    //icon海报-图标
    var typeArray = [
        {typeId: '10000100000000090000000000108723', icon: '<%=subTypesPosters.get("10000100000000090000000000108723")%>'},//电影
        {typeId: '10000100000000090000000000108724', icon: '<%=subTypesPosters.get("10000100000000090000000000108724")%>'},//电视剧
        {typeId: '10000100000000090000000000108725', icon: '<%=subTypesPosters.get("10000100000000090000000000108725")%>'},//综艺
        {typeId: '10000100000000090000000000108722', icon: '<%=subTypesPosters.get("10000100000000090000000000108722")%>'},//纪实
        {typeId: '10000100000000090000000000108806', icon: '<%=subTypesPosters.get("10000100000000090000000000108806")%>'},//少儿
        {url: 'http://192.168.17.131:8181/health-epg-gd-hd/index.jsp?entry=freeRecommend&code=20170207_mxjl_column&backURL=' + encodeURIComponent(window.top.location.href), p60Url : 'http://192.168.17.131:8181/health-epg-gd-hd/index.jsp?entry=ptfreeRecommend&code=20170207_mxjl_column&backURL=' + encodeURIComponent(window.top.location.href)},//健身
        {url: 'http://192.168.18.146:8082/mo_msc/index_mfzq.h?backURL=' + encodeURIComponent(window.top.location.href)}//音乐
    ];

    function current() {
        return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?url=";
    }

    String.prototype.startWith = function (str) {
        if (str == null || str == "" || this.length == 0 || str.length > this.length)
            return false;
        return this.substr(0, str.length) === str;
    }

    function playMovie(item) {
        /*if ( isP60 ) { //P60的播放方式
            try {
                getRTSP(item.name, String(item.id), '-1', 1);
            } catch( e ) { };
        } else if(iPanel.eventFrame.systemId == undefined ) { // 3.0 和来点的播放调用
            //top.window.location.href = current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.id + "&contentType=0&startTime=0&business=1";
        } else if(iPanel.eventFrame.systemId == 1 ) {
            top.window.location.href = current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.id + "&contentType=0&startTime=0&business=1";   电影播放
        } else { //网关，播放的调用方式不同
            iPanelGatewayHelper.play(String(item.id));
        }*/
        if ( isP60 ) { //P60的播放方式
            try {
                getRTSP(item.name, String(item.id), '-1', 1);
            } catch( e ) { }
        } else { // 3.0 和来点的播放调用
            //贴片广告正式部署时，需要重新部署文件： defaultHD/en/geninfo_ad.jsp，此文件修改了思华接口地址
            //注释为贴片广告处理，暂未使用
            top.window.location.href = current() + "/EPG/jsp/neirong/player/playerAd.jsp?typeId=" + typeId + "&playType=1" + "&progId=" + item.id + "&baseFlag=0&contentType=0&business=1";
        }
    }
    window.onload = function () {
        if ( typeof iPanel === 'undefined') iPanel = { eventFrame : {} };

        tgo.init({});

        tgo.$keyEvent.up = function () {
            <%--if(!isBooks){--%>
                <%--return--%>
            <%--}--%>
            var nextFocus = tgo.focusMove({
                axis: 'y', direction: 'reduce'
            });
            if (nextFocus) {
                focus(nextFocus)
            }
        };
        tgo.$keyEvent.down = function () {
            <%--if(!isBooks){--%>
                <%--return--%>
            <%--}--%>
            var nextFocus = tgo.focusMove({
                axis: 'y', direction: 'add'
            });
            if (nextFocus) {
                focus(nextFocus);
            }
        };
        tgo.$keyEvent.left = function () {
            <%--if(isBooks){--%>
                var nextFocus = tgo.focusMove({
                    axis: 'x', direction: 'reduce'
                });
                if (nextFocus) {
                    focus(nextFocus)
                }
            <%--}else{--%>
                <%--$("tgo_tan_1").style.background = "url(images/free/go_focus.png) no-repeat";--%>
                <%--$("tgo_tan_2").style.background = "url(images/free/no.png) no-repeat";--%>
                <%--fousIndex = 0;--%>
            <%--}--%>
        };
        tgo.$keyEvent.right = function () {
            <%--if(isBooks){--%>
                var nextFocus = tgo.focusMove({
                    axis: 'x', direction: 'add'
                });
                if (nextFocus) {
                    focus(nextFocus)
                }
            <%--}else{--%>
                <%--$("tgo_tan_2").style.background = "url(images/free/no_focus.png) no-repeat";--%>
                <%--$("tgo_tan_1").style.background = "url(images/free/go.png) no-repeat";--%>
                <%--fousIndex = 1;--%>
            <%--}--%>
        };
        tgo.$keyEvent.back = function () {
            <%--if(isBooks){--%>
                <%--isBooks = false;--%>
                <%--$("tgo_tan").style.visibility = "visible";--%>
            <%--}else{--%>
                <%--isBooks = true;--%>
                <%--$("tgo_tan").style.visibility = "hidden";--%>
            <%--}--%>
            back();
        };
        function back(){
            if( isP60 ) { // P60终端
                sysmisc.finish();
            } else if (typeof iPanel != 'undefined') {
                // 来点，或者网关
                if (iPanel.eventFrame.systemId == 1 || iPanel.eventFrame.systemId == 2 ) {
                    iPanel.eventFrame.exitToHomePage();
                } else {
                    top.window.location.href = iPanel.eventFrame.portalUrl;
                }
            }
            return false;
        }
        tgo.$keyEvent.ok = function () {
            <%--if(!isBooks){--%>
                <%--if(fousIndex == 0){//去答题--%>
    <%--alert("http://192.168.17.235:82/answer-index");--%>
                    <%--window.location.href = "http://192.168.17.235:82/answer-index?homeUrl=" + encodeURIComponent(window.location.href);--%>
                <%--}else if(fousIndex == 1){--%>
                    <%--back();--%>
                <%--}--%>
                <%--return;--%>
            <%--}--%>
            var focusedIndex = Number(tgo.currentFocus.title.replace(/[^0-9]/ig, ""));
            if (tgo.currentFocus.title.indexOf("vodArray") >= 0) {
                if (vodArray[focusedIndex].isSitcom == 0) {
                    playMovie(vodArray[focusedIndex]);
                } else if (vodArray[focusedIndex].isSitcom == 1) {
                    var url = '';
                    var detail = function(){//跳转电视剧详情页
                        if( !isP60 ) {
                            //注释为贴片广告
                            //top.window.location.href = current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail" + ( iPanel.eventFrame.systemId == undefined ? '_ad' : '')  + ".jsp?vodId=" + vodArray[focusedIndex].id + "&typeId=" + typeId;
                            //top.window.location.href = current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail.jsp?vodId=" + vodArray[focusedIndex].id + "&typeId=" + typeId;
                            top.window.location.href = current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail_ad.jsp?vodId=" + vodArray[focusedIndex].id + "&typeId=" + typeId;
                        } else {
                            sysmisc.path_sav(location.href);
                            top.window.location.href = "http://aoh5.cqccn.com/h5_vod/vod/detail.html?vod_id=" + vodArray[focusedIndex].id;
                        }
                    };
                    var sitcom = function( data ){
                        var is = true;
                        debug("IN SITCOM ==> " + data.length);
                        for (var i = 0; i < data.length; i++) {
                            if (vodArray[focusedIndex].name == data[i].name) {
                                var link = data[i].url;
                                if (!link.startWith('http')) {
                                    top.window.location.href = current() + link;
                                } else if (link.indexOf("wasu.cn/") > 0) {
                                    top.window.location.href = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + link;
                                } else {//跳转链接
                                    url = '';
                                    url = link;
                                    url += url.indexOf("?") > 0 ? '&' : '?';
                                    url += 'backURL=';
                                    if (url.startWith("http://epgServer") && typeof iPanel != 'undefined') url = url.replace("http://epgServer", iPanel.eventFrame.pre_epg_url);
                                    var requestUrl = window.location.href;
                                    url += encodeURIComponent(requestUrl);
                                    top.window.location.href = url;
                                }
                                is = false;
                                break;
                            }
                        }
                        if (is) detail();
                    };
                    url = '/EPG/jsp/defaultHD/en/hddb/hddb_topic_andr.txt';
                    if( isP60 ) {
                        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
                        url = sysmisc.getEnv('epg_address', '') + url;
                        //method,url,mediatype,header,body,success,fail
                        bridge.ajax('post', url, 'text/xml', cookie, '', function (resp) {
                            if( /\<html\>/g.test(resp) ) {
                                detail();
                                sysmisc.showToast('请求服务器异常!');
                            } else {
                                resp = resp.trim().replace(/[\r\n]/g, "");
                                resp = eval('(' + resp + ')');
                                sitcom(resp.data);
                            }
                        },function(){ sysmisc.showToast('请求服务器异常!'); });
                    } else {
                        var xhr = new XMLHttpRequest();
                        xhr.open('get', url );
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState == 4 && xhr.status == 200) {
                                var data = xhr.responseText;
                                var length = data.length;
                                var start = data.indexOf("{");
                                data = data.substr(start, length - start);
                                data = eval('(' + data + ')');
                                sitcom(data.data);
                            }
                        };
                        xhr.send(null);
                    }
                }
            }
            if (tgo.currentFocus.title.indexOf("typeArray") >= 0) {
                var data = eval("(" + tgo.currentFocus.title + ")");
                //胡总添加， 综艺跳转到最强综艺全收录
                if( typeof data.p60Url == 'string' && isP60 ) {
                    location.href = data.p60Url;
                    //胡总添加， 综艺跳转到最强综艺全收录
                } else if (data.typeId === '10000100000000090000000000108725') {
                    window.location.href = "/EPG/jsp/neirong/S20180813.jsp";
                } else if (!!data.url && data.url != undefined && data.url != "undefined") {
                    window.location.href = data.url;
                } else if (!!data.typeId && data.typeId != undefined && data.typeId != "undefined") {
                    window.location.href = linkStr + "?typeId=" + data.typeId;
                }
            }
        };
        tgo.currentFocus = $("vod_0");
        focus(tgo.currentFocus);
        for (var i = 0; i < vodArray.length; i++) {
            loadVod(
                i,
                vodArray[i].pic,
                i > 6 ? vodArray[i].name : ""
            );
        }
        for (i = 0; i < typeArray.length; i++) {
            loadType(
                i,
                (function () {
                    if (!!typeArray[i].url && typeArray[i].url != undefined && typeArray[i].url != "undefined") {
                        return typeArray[i].url
                    }
                    return ""
                })(),
                (function () {
                    if (!!typeArray[i].typeId && typeArray[i].typeId != undefined && typeArray[i].typeId != "undefined") {
                        return typeArray[i].typeId
                    }
                    return ""
                })(), (function () {
                    if (!!typeArray[i].icon && typeArray[i].icon != undefined && typeArray[i].icon != "undefined") {
                        return typeArray[i].icon
                    }
                    return ""
                })(),
                "typeArray"
            );
        }
        $("titleName").innerHTML = '<marquee>' + titleName + "</marquee>";
    };

    function loadType(num, url, typeId, icon, str) {
        var strData = {};
        if (url != "") {
            strData.url = url;
        } else if (typeId != "") {
            strData.typeId = typeId;
        }
        if (icon != "" && icon != "null") {
            $("type_" + num + "_0").style.visibility = "visible";
            $("type_" + num + "_0").src = icon;
        }
        strData.title = str;
        $("type_" + num).title = jsonToString(strData);
    }

    function loadVod(num, imgUrl, str) {
        if (str != "") {
            $("vod_" + num + "_0").innerText = str;
        }
        try {
            if (typeof $("vod_" + num + "_2").src !== 'undefined') {
                if( imgUrl != "" && imgUrl != "null" )$("vod_" + num + "_2").src = imgUrl;
            } else {
                $("vod_" + num).style.backgroundImage = "url(" + imgUrl + ")";
            }
        } catch (e) {
            $("vod_" + num).style.backgroundImage = "url(" + imgUrl + ")";
        }
        $("vod_" + num).title = "vodArray" + num;
    }

    function focus(ele) {
        $(tgo.currentFocus.id + "_1").style.visibility = "hidden";
        $(ele.id + "_1").style.visibility = "visible";
        tgo.currentFocus = ele;
        move(ele);
    }

    function move(ele) {
        var Top = getOffsetTopByBody(ele) + getOffsetHeightByBody(ele) - 90;
        if (Top - 561 > 0) {
            $("moveMain").style.top = (parseFloat($("moveMain").style.top) - (Top - 561)) - 30 + "px";
        } else if (getOffsetTopByBody(ele) - 99 < 0) {
            var res = parseFloat($("moveMain").style.top) - (getOffsetTopByBody(ele) - 99);
            $("moveMain").style.top = res > 0 ? 0 : res + "px";
        }
    }
</script>
</body>
</html>