<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104842";

    int focused = 0, length = 13, start = 0, area = 0;
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
<title>星际科幻大作战</title>
<style>
    .mask {position:absolute;width:266px; height:37px;background:transparent url('images/mask-2015-01-09.png') no-repeat fixed;background-position: 0px -279px;}
    .focusBg{width:512px;height:252px;left: 77px;top:210px;position: absolute;background:transparent url('images/mask-2015-01-09.png') no-repeat fixed -21px -8px;}
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
                if( list != null && list.size() > 0){
                  for( int i = 0; i< list.size() && i < 13; i ++) {
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
        var item =  focusable[blocked].items[focusable[blocked].focus];
        var focus = 0;

        if(typeof index == "number" && !initilized){
            focus = focusable[blocked].focus;
            //上:11,下:-11,左-1,右1
            if(index == 11) {
                if( blocked === 0 && (focus == 0 || focus == 7) ) return;
                if( blocked === 1 ) {
                    blocked = 0;
                    focus = focusable[0].focus;
                } else  focus = focus - 1;
            } else if(index == -11){
                if(blocked === 1 ) return;
                if( blocked === 0 && ( focus == 6 || focus == 12 ) ) {
                    blocked = 1;
                    focus = focusable[blocked].focus;
                } else
                    focus = focus + 1;
            } else if(index == -1){
                if(focus <= 6 && blocked === 0 ) return;
                if(blocked === 1) {
                    if( focus == 1 ) focus = 0; else { blocked = 0; focus = focusable[blocked].focus;}
                }  else focus -= 6;
            } else {
                if( blocked === 0 && focus >= 7  ) {
                    blocked = 1;
                    focus = focusable[blocked].focus;
                } else if( blocked === 1 && focus === 0 ) {
                    focus = 1;
                } else if( blocked === 0)
                    focus += focus === 0 ? 7 : 6;
            }
            focusable[blocked].focus = focus;
        } else if( initilized )
            focusable[blocked].focus = focus =  index;

        item =  focusable[blocked].items[focus];
        if( typeof item != 'undefined'  ) {
            if( blocked === 1) { $("mask").className = item.style; $("mask").style.left = ''; $("mask").style.top = '';return; }
            $("mask").className = "mask";
            if( focus <= 6 ){
                $("mask").style.left = '58px';
                $("mask").style.top = (205 + 38 * focus) + "px";
            } else {
                $("mask").style.left = '330px';
                $("mask").style.top = (205 + 38 * ( focus - 6 )) + "px";
            }
        };
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-01-09.jpg') no-repeat;">
<div id="mask"></div>
<div id="focusBg" class="focusBg"></div>
</body>
</html>