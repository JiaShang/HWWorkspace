<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104865";

    final String[] types = {"10000100000000090000000000104870","10000100000000090000000000104871","10000100000000090000000000104872","10000100000000090000000000104872"};

    int focused = 0, length = 10, start = 0, area = 2;
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
            List<Vod> ls = getVodList( metaHelper, type, i == 3 ? 7 : 100 ,  i == 2 ? 7: 0 );
            list.add( ls );
            i++;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>我是歌手4</title>
<style>
    .mask {position:absolute; background:transparent url('images/mask-2016-01-16.png') no-repeat fixed 0px 0px;}
    .beginJmp {position:absolute; background:transparent url('images/focus-2016-01-16.png') no-repeat fixed 0px 0px; width:230px;height:65px;left:960px;top:139px;}
    .more {width:73px;height:37px;left:265px;top:353px;background-position: 0px -750px;}
    .review {width:231px;height:62px;left:966px;top:75px;background-position: 0px -680px;}
    .bigger {width:478px;height:307px;left:11px;top:370px;background-position: 0px 0px;}
    .middle {width:307px;height:178px;background-position: 0px -310px;}
    .small {width:284px;height:186px;background-position: 0px -490px;}

    .blocked2 {width:973px;height:132px; left:154px;top:216px;overflow: hidden;position: absolute;}
    .image2 {width:230px;height:132px;position: absolute;border: none;}
    .marqued2 {color:#ffffff;font-size: 22px; line-height: 28px;margin:121px 28px 0px 28px; width:284px;}
    .blocked5 {width:1196px;height:254px; top:391px;left:38px;overflow: hidden;position: absolute;}
    .image51 {width:423px;height:253px;position: absolute;border: none; }
    .marqued51 {color:#ffffff;font-size: 22px; line-height: 28px;margin:242px 28px 0px 28px; width:478px;}
    .image5 {width:253px;height:123px;position: absolute;border: none;}
    .marqued5 {color:#ffffff;font-size: 22px; line-height: 28px;margin:114px 28px 0px 28px; width:307px;}

    .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
    .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
    .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
    .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
    .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
    .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
    .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:651px;left:1063px; width:161px;height:41px;background-position: 0px 0px;}
    .btnReturn {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:651px;left:1063px; width:161px; height:41px;background-position: 0px -42px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
    var popMaxItemsLength = 6;
    var blocked = blocked ? blocked : <%= area %>;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
        {focus:1,items:[{playType:-1,blocked:1,style:'mask review'},{playType:-3,style:'beginJmp',link:'http://192.168.48.217:8085/iptv/entrance.jsp?gpid=124'}]},
    <%
        final int popItemMaxCharLength = 36;
        if( list != null && list.size() > 0){
            for(int i = 0; i < list.size() ; i ++){
                out.write("{focus:0,items:[");
                List<Vod> vodList = list.get(i);
                for( int j = 0; j < vodList.size() ; j++ ){
                    Vod vod = vodList.get(j);
                    String str = "{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                             "length:" + StringUtil.length(vod.getName()) + "," +
                          "shortText:'" + StringUtil.limitStringLength(vod.getName(),popItemMaxCharLength) + "'," +
                           "playType:" + vod.getIsSitcom() ;

                    if(i == 1 || i == 3){
                        str += ",style:'mask " + ( i == 1 ? "small" : (j == 0 ? "bigger" : "middle" ) ) + "'";
                        str += ",picture:'" + Utils.pictureUrl("images/default-2015-01-16.jpg", vod.getPosters(), "1", request)  + "'";
                    }

                    str += "}" +  ( j + 1 < vodList.size()  ? "," : "");
                    out.write(str);
                }
                out.write("]},");
                if(i == 1) out.write("{focus:0,items:[{playType:-1,blocked:4,style:'mask more'}]},");
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
            if( ( blocked == 0 || blocked == 1 || blocked == 3 || blocked == 4 ) && ( index == -1 || index == 1 ) ||
                  blocked == 6 && index == -11 || blocked == 0 && focus == 0 && index == 11 ||
                  blocked == 5 && focus == 0 && index == -1 || blocked == 5 && ( focus == 3 || focus == 6 ) && index == 1 ||
                ( blocked == 1 || blocked == 4 ) && ( focus == 0 && index == 11 || focus == focusable[blocked].items.length - 1 ) && index == -11  ) return;

            switch (index){
                case 11:
                    if( (blocked == 0 || blocked == 1 || blocked == 4 ) && focus - 1 >= 0 ) { focus = focus - 1; }
                    else { var temp = blocked; switch ( blocked ){
                        case 2: blocked = 0; break;
                        case 3: blocked = 2; break;
                        case 5: if( focus < 4 ) blocked = 3; else focus = focus - 3; break;
                        case 6: blocked = 5; break;
                    }; if( temp != blocked ) focus = focusable[blocked].focus; }
                    break;
                case -11:
                    if( ( blocked == 0 || blocked == 1 || blocked == 4 ) && focus + 1 < focusable[blocked].items.length ) { focus = focus + 1; }
                    else { var temp = blocked; switch ( blocked ){
                        case 0: blocked = 2; break;
                        case 2: blocked = 3; break;
                        case 3: blocked = 5; break;
                        case 5: if( focus >= 4 || focus == 0) blocked = 6; else focus = focus + 3; break;
                    }; if( temp != blocked ) focus = focusable[blocked].focus; }
                    break;
                case 1:
                    if( blocked == 2 && focus + 1 < focusable[blocked].items.length ||
                        blocked == 5 && focus < 7 && ( focus != 3 || focus != 6 ) ||
                        blocked == 6 && focus == 0 ) { focus = focus + 1; }
                    break;
                case -1:
                    if( blocked == 2 && focus - 1 >= 0 ||
                        blocked == 6 && focus == 1 ||
                        blocked == 5 && focus < 7 &&  focus != 4
                    ) { focus = focus - 1; } else if( blocked == 5 && focus == 4  ) focus = 0;
                    break;
            }
            focusable[blocked].focus = focus;
        } else if( initilized ){
            focusable[blocked].focus = focus =  index;
        }
        item =  focusable[blocked].items[focus];
        if(blocked != 2 && blocked != 5 && blocked != 1 && blocked != 4 ) $("mask").innerHTML = "";
        if( blocked != 1 && blocked != 4){
            if( typeof item != 'undefined' && typeof item.style == 'string')
                $("mask").className = item.style;
            if( blocked == 0 || blocked == 3 || blocked == 6 ){ //最左上角，更多，首页返回
                $("mask").style.left = "";
                $("mask").style.top = "";
                $("mask").className = item.style;
            } else if( blocked == 2 ){
                initSideShow();
                $("mask").style.top = "195px";
                $("mask").style.left = ( 127 + ( focus % 4 ) * 247 ) + "px";
                $("mask").innerHTML = "<marquee class='marqued2'>" + item.text + "</marquee>";
            } else if ( blocked == 5 ){
                $("mask").style.top = focus < 4 ? "370px" : "498px";
                $("mask").style.left = focus == 0 ? "11px" : ( ( 439 + (focus - 1) % 3 * 258 ) + "px" ) ;
                $("mask").innerHTML = "<marquee class='" + ( focus == 0 ? "marqued51" : "marqued5") + "'>" + item.text + "</marquee>";
            }
        } else if(blocked == 1 || blocked == 4 ) {
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
        //首页，返回
        if( blocked == focusable.length - 1){
            if(focusable[blocked].focus == 1) goBack(); else top.window.location.href = iPanel.eventFrame.portalUrl;
        }
        var item =  focusable[blocked].items[focusable[blocked].focus];

        if( item.playType == -1){
            blocked = item.blocked;
            focused(focusable[blocked].focus, true);
            return;
        } else if( item.playType == -3 ) {
            top.window.location.href = focusURL() + item.link;
        } else if( item.playType == 1){
            top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
        } else {
            top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
        }
    }
    function goBack(){
        if( blocked == 1 || blocked == 4){
            $("popuped").style.visibility = "hidden";
            blocked = blocked == 1 ? 0 : 3;
            focused(0 ,true);
            return;
        }
        top.window.location.href = focusable[blocked].focus == 1 || EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
    }

    function initSideShow(focus){
        var items = focusable[2].items;
        if(typeof focus != 'number') focus = focusable[2].focus;
        var html = "";
        var i = focus - focus % 4; focus = i + 4 < items.length ? i + 4 : items.length;
        for(; i < focus; i++)
            html += "<img class='image2' id='" + i + "'" +
            ( typeof items[i].picture == 'string' && !items[i].picture.isEmpty() ? (" src='" + items[i].picture + "'") : "" )+
            " style='left:" + (i % 4 * 247) + "px;top:0px;' />";
        $("blocked2").innerHTML = html;
    }

    function initContent(){
        initSideShow();
        var items = focusable[5].items;
        var html = "";
        for( var i = 0; i < items.length; i++)
            html += "<img class='" + (i == 0 ? "image51" : "image5") + "'" +
            ( typeof items[i].picture == 'string' && !items[i].picture.isEmpty() ? (" src='" + items[i].picture + "'") : "" ) +
            " style='left:" + (i == 0 ? 0 : ( (i - 1) % 3 * 258) + 428) + "px;top:" + ( i < 4 ? 0 : 128 ) + "px;' />";
        $("blocked5").innerHTML = html;
    }
    function init(){
        String.prototype.isEmpty = function(){  return (/^\s*$/.test(this)); };
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
        initContent();
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2016-01-16.jpg') no-repeat;">
<div style="position:absolute;width:223px;height:65px;left:960px;top:139px;"><img src="images/focusBg-2016-01-16.png" /></div>
<div id="blocked2" class="blocked2" style="color: #ffffff"></div>
<div id="blocked5" class="blocked5" style="color: #ffffff"></div>
<div id="mask"></div>
<div class='popuped' id='popuped' style='visibility:hidden'>
    <div class='container' id='container'><div class='content' id='content'></div></div>
    <div class='page' id='page'>1/1</div>
</div>
<jsp:include page="../defaultHD/en/high_tips.jsp" ></jsp:include>
</body>
</html>