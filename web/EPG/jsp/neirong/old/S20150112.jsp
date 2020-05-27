<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104845";

    final String[] types = {"10000100000000090000000000104855","10000100000000090000000000104856"};
    final int[] lengths = {8,100};

    int focused = 0, length = 10, start = 0, area = 0;
    String backUrl = "", value = "", fromEPG = "";
    List<List<Vod>> list = null;
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
        list = new ArrayList<List<Vod>>();
        int i = 0;
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type, lengths[i++], 0 );
            list.add( ls );
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>多面暖男钟汉良</title>
<style>
    .mask {position:absolute; height:31px;background:transparent url('images/mask-2015-01-12.png') no-repeat fixed;background-position: 0px 0px;}
    .mask1 {width:140px;left:70px; top:431px;background-position:0px 0px;}
    .mask2 {width:192px;left:72px; top:466px;background-position:-2px -35px;}
    .mask3 {width:138px;left:71px; top:500px;background-position:-1px -69px;}
    .mask4 {width:112px;left:71px; top:535px;background-position:-1px -104px;}
    .mask5 {width:138px;left:70px; top:569px;background-position:0px -138px;}
    .mask6 {width:112px;left:70px; top:604px;background-position:0px -173px;}
    .mask7 {width:57px;left:317px; top:431px;background-position:-246px 0px;}
    .mask8 {width:110px;left:316px; top:465px;background-position:-245px -34px;}
    .mask9 {width:112px;left:481px; top:431px;background-position:-411px 0px;}

    .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
    .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
    .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
    .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
    .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
    .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
    .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }


    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px;background-position: 0px 0px;}
    .btnReturn {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px;background-position: 0px -42px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
    var popMaxItemsLength = 6;
    var blocked = blocked ? blocked : <%= area %>;
    var saved = [0,0,0];
    var indexSaved = 0;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
    <%
        final int popItemMaxCharLength = 36;
        if( list != null && list.size() > 0){
            for(int i = 0; i < list.size() ; i ++){
                out.write("{focus:0,items:[");
                List<Vod> vodList = list.get(i);
                for( int j = 0; j < vodList.size() ; j++ ){
                    Vod vod = vodList.get(j);
                    out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                             "length:" + StringUtil.length(vod.getName()) + "," +
                          "shortText:'" + StringUtil.limitStringLength(vod.getName(),popItemMaxCharLength) + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                           ( i < 1 ? "style:'mask mask" + (j + 1) + "'" : "" ) +
                         "}" +  ( j + 1 < vodList.size()  ? "," : ""));
                }
                if(i == 0) out.write(",{playType:-1,blocked:1,style:'mask mask9'}");
                out.write("]},");
            }
        }
    %>
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
            //上:11,下:-11,左-1,右1
            focus = focusable[blocked].focus;
            if(blocked != 1) {
                switch (index){
                    case 11:
                        if(blocked === 0 && ( focus == 0 || focus == 6 || focus ==  8 )) return;
                        if( blocked === 2) {
                            blocked = 0;
                            focus = indexSaved;
                        } else
                            focus = focus - 1;
                        break;
                    case -11:
                        if( blocked === 2 )return;
                        if(blocked === 0 && ( focus == 5 || focus == 7 || focus ==  8 )) {
                            indexSaved = focus;
                            blocked = 2;
                            focus = focusable[blocked].focus;
                        } else
                            focus = focus + 1;
                        break;
                    case 1:
                        if( blocked == 2 && focus == 1 ) return;
                        if( blocked == 2 ) focus = 1;
                        if( blocked == 0 ) {
                            if(focus == 5 || focus == 8) {
                                indexSaved = focus;
                                blocked = 2;
                                focus = focusable[blocked].focus;
                            }
                            else if( focus == 6 || focus == 7 )
                            {
                                saved[1] = focus;
                                focus = saved[2] == 0 ? 8 : saved[2];
                            }
                            else
                            {
                                saved[0] = focus;
                                focus = saved[1] == 0 ? 6 : saved[1];
                            }
                        }
                        break;
                    case -1:
                        if( blocked == 0 && focus <= 5 ) return;
                        if( blocked == 2 ){
                            if( focus == 1)
                                focus = 0;
                            else {
                                blocked = 0;
                                focus = indexSaved;
                            }
                        } else  if( blocked == 0 ) {
                            if( focus == 6 || focus == 7 )
                            {saved[1] = focus; focus = saved[0]; }
                            else
                            {saved[2] = focus; focus = saved[1] == 0 ? 6 : saved[1];}
                        }
                        break;
                }
            } else {
                if(index === -1 || index === 1 || focus < 1 && index == 11 || focus >= focusable[1].items.length - 1 && index == -11 ) return;
                focus += index < 0 ? 1 : -1;
            }
            focusable[blocked].focus = focus;
        } else if( initilized ){
            focusable[blocked].focus = focus =  index;
            if(blocked == 1) focusable[0].focus = focusable[0].items.length - 1;
        }

        item =  focusable[blocked].items[focus];
        if( blocked == 1 && $("popuped").style.visibility == 'hidden' ) {
            $("popuped").style.visibility = "visible";
            $("mask").style.visibility = "hidden";
        } else if( blocked != 1 && $("mask").style.visibility == 'hidden' ) {
            $("popuped").style.visibility = "hidden";
            $("mask").style.visibility = "visible";
        }

        if( blocked != 1 ){
            if( typeof item != 'undefined' ) $("mask").className = item.style;
        } else {
            var items = focusable[blocked].items;
            $("page").innerText = (Math.ceil((focus + 1) / popMaxItemsLength) + "/" + Math.ceil(items.length / popMaxItemsLength));
            if($("popuped").style.visibility == "hidden") $("popuped").style.visibility = "visible";
            var html = "";
            for(var i = 0; i < items.length ; i ++ ){
                var vod = items[i];
                html += "<div class='" + ( focus == i ? "maskItem" : "item") + "'>" +
                (vod.length <= <%= popItemMaxCharLength %> || focus != i ? vod.shortText : ("<marquee class='marqueed'>" + vod.text + "</marquee>")) +
                "</div>";
            }
            $("content").innerHTML = html;
            $("content").style.marginTop = "-" + (Math.floor(focus / popMaxItemsLength) * popMaxItemsLength * 51) + "px";
        }
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}
        if(blocked < 2){
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if( item.playType == -1){
                blocked = item.blocked;
                focused(focusable[blocked].focus, true);
                return;
            }
            top.window.location.href = focusURL() + ( item.playType == 1 ? "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId : "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1");
        }
        else
            goBack();
    }
    function goBack(){
        if( blocked == 1){
            blocked = 0 ;
            focused(focusable[blocked].focus ,true);
            return;
        }
        top.window.location.href = focusable[blocked].focus == 0 || EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
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
            case "KEY_BACK": goBack(); break;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-01-12.jpg') no-repeat;">
<div id="mask"></div>
<div class='popuped' id='popuped' style='visibility:hidden'><div class='container' id='container'><div class='content' id='content'></div></div><div class='page' id='page'>1/1</div></div>
</body>
</html>