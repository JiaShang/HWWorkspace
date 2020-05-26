<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104885";

    int focused = 0, length = 1000, start = 0, area = 0;
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
<title>H264网视频测试</title>
<style>
    .item {color: olivedrab;font-size: 16px; height: 26px; line-height: 24px;  width: 380px; margin: 5px 5px; overflow: hidden; float: left}
    .focus {color: dodgerblue; font-size: 16px; height: 26px; line-height: 24px;width: 380px; margin: 5px 5px; overflow: hidden;float: left}
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
            value = "";
            if( list != null && list.size() > 0){
              for( int i = 0; i< list.size(); i ++) {
                 Vod vod = list.get(i);
                 value += "{ mid:'" + vod.getId() + "'," +
                           "text:'" + vod.getName() + "'," +
                       "playType:" + vod.getIsSitcom() + "," +
                     "}" +  ( i + 1 < list.size() ? "," : "");
              }
              out.write(value);
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
            if(index == 11 && focus < 3 || index == -11 && focus >= focusable[blocked].items.length -3 || index == 1 && focus >= focusable[blocked].items.length -1 || index == -1 && focus <= 0) return;
            if( index == 11 ) focus = focus - 3;
            else if( index == -11 ) focus = focus + 3;
            else focus += index;
            focusable[blocked].focus = focus;
        } else if( initilized )
            focusable[blocked].focus = focus =  index;

        show ();
    }
    function show (){
        var html = "";
        var items = focusable[blocked].items;
        var focus = focusable[blocked].focus;
        for(var i = 0; i< items.length; i++){
            html += "<div class='" + (focus == i ? "focus" : "item") + "'>" + items[i].text + "</div>";
        }
        $("container").innerHTML = html;
        $("container").style.marginTop = "-" + ( Math.floor( focus / 75 ) * 26 * 24  ) + "px";
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
<body leftmargin="0" topmargin="0" style="overflow:hidden;margin:20px 40px; ">
<div id="container" style="color: #ffffff"></div>
</body>
</html>