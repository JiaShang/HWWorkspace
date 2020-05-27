<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104887";

    int focused = 0, length = 7, start = 0, area = 0;
    String backUrl = "", value = "", fromEPG = "";
    List<Vod> list = null;
    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");
        if(null == playBack){
            if(null == fcr)
                turnPage.addUrl();
            else{
                turnPage.removeLast();
                turnPage.addUrl();
            }
        }
        else{
            turnPage.removeLast();
        }

        // 返回时获取焦点信息数据
        String[] focus = turnPage.getPreFoucs();
        if(null != focus ){
            if( focus.length > 0 && focus[0] != null )
                area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                focused = Integer.parseInt(focus[1]);
        }

        backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        list = getVodList( metaHelper, typeId, length, start );
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>小儿不再“难养”</title>
<style>
    .mask {position:absolute;background:transparent url('images/mask-2015-01-27.png') no-repeat fixed 0px 0px;}
    .mask1 {width:238px; height:94px;left:278px; top:229px;background-position:-278px -229px; }
    .mask2 {width:229px; height:65px;left:95px; top:422px;background-position:-95px -422px;}
    .mask3 {width:235px; height:93px;left:623px; top:390px;background-position:-623px -390px;}
    .mask4 {width:233px; height:105px;left:1002px; top:389px;background-position:-1002px -389px;}
    .mask5 {width:247px; height:87px;left:370px; top:550px;background-position:-370px -550px;}
    .mask6 {width:216px; height:71px;left:837px; top:576px;background-position:-837px -576px;}
    .mask7 {width:324px; height:36px;left:47px; top:645px;background-position:-47px -645px;}
    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px;background-position: 0px 0px;}
    .btnReturn {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px;background-position: 0px -42px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

    var blocked = blocked ? blocked : <%= area %>;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
        { focus:0, items : [
            <%
                String[] actions = "[0,0,0,4,0,1,0,2]|[0,0,0,6,0,4,0,2]|[0,0,0,4,0,1,0,3]|[0,0,0,5,0,2,0,3]|[0,0,0,6,0,1,0,5]|[0,2,1,0,0,4,0,5]|[0,1,0,6,0,6,1,0]".split("\\|");
                if( list != null && list.size() > 0){
                  for( int i = 0; i< list.size() && i < 7; i ++) {
                     Vod vod = list.get(i);
                     out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                             "action:" + actions[i] + "," +
                              "style:'mask mask" + (i + 1) + "'" +
                         "}" +  ( i + 1 < list.size() ? "," : ""));
                  }
                  out.flush();
            }
            %>
        ]},
        { focus:0, items : [
            {name:'首页',style:'btnHome',action:[0,5,1,0,0,6,1,1]},
            {name:'返回',style:'btnReturn',action:[0,3,1,1,1,0,1,1]}
        ]}
    ];

    var backUrl = '<%= backUrl %>';
    var typeId = '<%= typeId %>';

    function focused(index,initilized){
        var item =  focusable[blocked].items[focusable[blocked].focus];
        var focus = 0;

        if(typeof index == "number" && !initilized){
            //上:11,下:-11,左-1,右1
            if(index == 11) {
                blocked = item.action[0]; focus = item.action[1];
            } else if(index == -11){
                blocked = item.action[2]; focus = item.action[3];
            } else if(index == -1){
                blocked = item.action[4]; focus = item.action[5];
            } else {
                blocked = item.action[6]; focus = item.action[7];
            }
            focusable[blocked].focus = focus;
        } else if( initilized )
            focusable[blocked].focus = focus =  index;

        item =  focusable[blocked].items[focus];
        if( typeof item != 'undefined' ) $("mask").className = item.style;
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}
        if(blocked == 0){
            var item =  focusable[blocked].items[focusable[blocked].focus];
            top.window.location.href = focusURL() + ( item.playType == 1 ? "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId : "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1");
        }
        else
            top.window.location.href =  focusable[blocked].focus == 1 ? backUrl : iPanel.eventFrame.portalUrl;
    }

    function init(){
        if( typeof $ == "undefined" ){
            $ = function (objectId) {
                if(document.getElementById && document.getElementById(objectId)) {
                    return document.getElementById(objectId);
                } else if (document.all && document.all(objectId)) {
                    return document.all(objectId);
                } else if (document.layers && document.layers[objectId]) {
                    return document.layers[objectId];
                } else {
                    return false;
                }
            };
        }
        if( typeof iPanel == "undefined" ) {
            document.onkeydown = function(event){
                switch (event.keyCode) {
                    case 38: focused(11, false); break;                        //上光标键
                    case 40: focused(-11, false); break;                        //下光标键
                    case 37: focused(-1, false); break;                        //左光标键
                    case 39: focused(1, false); break;                        //右光标键
                    case 13: doEnter(); break;                        //选择回车键
                    case "KEY_BACK": top.window.location.href = backUrl;  break;
                    case "KEY_EXIT":
                    case "KEY_MENU": top.window.location.href = iPanel.eventFrame.portalUrl; return 0; break;
                }
            }
        }
        focused(<%= focused %>, true);
    }
    function eventHandler(eventObj, __type){
        switch(eventObj.code){
            case "KEY_UP": focused(11, false); break;
            case "KEY_DOWN": focused(-11, false); break;
            case "KEY_LEFT": focused(-1, false); break;
            case "KEY_RIGHT": focused(1, false); break;
            case "KEY_SELECT":doEnter();break;
            case "KEY_BACK": window.location.href = EPGflag ? iPanel.eventFrame.portalUrl : backUrl; break;
            case "KEY_EXIT":
            case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
        }
        return 	eventObj.args.type;
    }
    function focusURL(){
        return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
    }
    window.onload = function(){
        setTimeout("init()",100);
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-01-27.jpg') no-repeat;">
<div id="mask"></div>
</body>
</html>