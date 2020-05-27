<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104521";

    int length = 7, start = 0;
    int focused = 4;
    int area = 0;
    String backUrl = "";
    String value = "";

    List<Vod> list = null;

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");

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
<title>夏日出走吧</title>
<style>
    .mask {height: 40px;position:absolute;background:transparent url('images/mask-2014-09-04.png') no-repeat fixed;}
    .mask1 {width:190px;left:726px;top:124px; background-position: 0px 0px;}
    .mask2 {width:190px;left:712px;top:174px; background-position: 0px -51px;}
    .mask3 {width:130px;left:684px;top:228px; background-position: 0px -105px;}
    .mask4 {width:240px;left:645px;top:280px; background-position: 0px -157px;}
    .mask5 {width:265px;left:600px;top:333px; background-position: 0px -210px;}
    .mask6 {width:190px;left:552px;top:385px; background-position: 0px -262px;}
    .mask7 {width:218px;left:520px;top:438px; background-position: 0px -315px;}
    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed 0px 0px; top:636px;left:1066px; width:161px;height:41px;}
    .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed 0px -42px; top:636px;left:1066px; width:161px; height:41px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

    var blocked = blocked ? blocked : <%= area %>;

    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
        { focus:0, items : [
            <%
                if( list != null && list.size() > 0){
                  for( int i = 0; i< list.size() && i < 7; i ++) {
                     Vod vod = list.get(i);
                     out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                              "style:'mask mask" + (i + 1) + "'" +
                         "}" +  ( i + 1 < list.size() ? "," : ""));
                  }
                  out.flush();
            }
            %>
        ]},
        { focus:0, items : [
            {name:'首页',style:'btnHome'},
            {name:'返回',style:'btnReturn'}
        ]}
    ];

    var backUrl = '<%= backUrl %>';
    var typeId = '<%= typeId %>';

    function focused(index,initilized){
        var focus = focusable[blocked].focus;
        var item =  focusable[blocked].items[focus];
        if(typeof index == "number" && !initilized){
            //上:11,下:-11,左-1,右1
            if(index == -1 || index == 1){
                if( blocked == 0 )return;
                if(index == -1) {
                    focus = focus - 1;
                    if(focus < 0) focus = focusable[blocked].items.length - 1;
                } else {
                    focus = focus +1;
                    if(focus >= focusable[blocked].items.length){
                        focus = 0;
                    }
                }
            } else {
                if(blocked == 1 && index == -11)
                    return;
                else if( blocked == 1 ){
                    blocked = 0;
                    focus = focusable[blocked].items.length - 1;
                } else {
                    if(index == 11) {
                        focus = focus -1;
                        if(focus < 0) focus = 0;
                    } else {
                        focus = focus +1;
                        if(focus >= focusable[blocked].items.length){
                            blocked = 1;
                            focus = focusable[blocked].focus;
                        }
                    }
                }
            }
            focusable[blocked].focus = focus;
        } else if( initilized )
            focusable[blocked].focus = focus =  index;

        item =  focusable[blocked].items[focus];
        $("mask").className = item.style;
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}

        if(blocked == 0){
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if( item.playType == 1)
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
            else {
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
            }
        }
        else {
            if(focusable[blocked].focus == 0)
                top.window.location.href = backUrl;
            else
                top.window.location.href = iPanel.eventFrame.portalUrl;

        }
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
                    case 38:                        //上光标键
                        focused(11, false);
                        break;
                    case 40:                        //下光标键
                        focused(-11, false);
                        break;
                    case 37:                        //左光标键
                        focused(-1, false);
                        break;
                    case 39:                        //右光标键
                        focused(1, false);
                        break;
                    case 13:                        //选择回车键
                        doEnter();
                        break;
                    case "KEY_BACK":
                        top.window.location.href = backUrl;
                        break;
                    case "KEY_EXIT":
                    case "KEY_MENU":
                        top.window.location.href = iPanel.eventFrame.portalUrl;
                        return 0;
                        break;
                }
            }
        }

        focused(<%= focused %>, true);
    }
    function eventHandler(eventObj, __type){
        switch(eventObj.code){
            case "KEY_UP":
                focused(11, false);
                break;
            case "KEY_DOWN":
                focused(-11, false);
                break;
            case "KEY_LEFT":
                focused(-1, false);
                break;
            case "KEY_RIGHT":
                focused(1, false);
                break;
            case "KEY_SELECT":
                doEnter();
                break;
            case "KEY_BACK":
                window.location.href = backUrl;
                break;
            case "KEY_EXIT":
            case "KEY_MENU":
                location.href = iPanel.eventFrame.portalUrl;
                return 0;
                break;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-09-04.jpg') no-repeat;">
<div id="mask"></div>
</body>
</html>