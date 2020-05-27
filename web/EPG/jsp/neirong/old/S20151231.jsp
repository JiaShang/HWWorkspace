<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104806";

    //
    //父栏目：
    //1415跨年演唱会  10000100000000090000000000104806
    //子栏目：
    //1415跨年演唱会  10000100000000090000000000104821
    //全场完整回放  10000100000000090000000000104822
    //精彩看点  10000100000000090000000000104823
    //更多巨星演唱会  10000100000000090000000000104824

    final String[] types = {"10000100000000090000000000104822","10000100000000090000000000104823","10000100000000090000000000104823","10000100000000090000000000104824"};
    final int[] lengths = {6,6,100,100};
    //TODO:每次需要修改
    int length = 50, start = 0;
    //区块中当前被选择的顺序
    int focused = 1;
    //选择的区块 0:普通焦点，1:首页，返回按钮，2:弹出对话框中的上一页，下一页，返回，3:弹出对话框中的列表中的条目
    int area = 0;

    String backUrl = "";
    String fromEPG = "";

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
            List<Vod> ls = getVodList( metaHelper, type, lengths[i], i == 2 ? 6 : 0 );
            list.add( ls );
            i ++;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>1516跨年演唱会</title>
<style>
    .mask {position:absolute;background:transparent url('images/mask-2014-12-31.png') no-repeat fixed;background-position: 0px 0px;}
    .mask1 {width:535px; height:41px; left:704px; background-position: 0px 0px;}
    .mask11 {width:320px;height:60px;left:908px;top:82px;background-position: 0px -350px;}
    .mask12 {top:349px;}
    .mask13 {top:390px;}
    .mask14 {top:431px;}
    .mask15 {top:472px;}
    .mask16 {top:513px;}
    .mask17 {top:554px;}
    .mask2 {position:static; width:523px; height:48px; left:55px;background-position: 0px -450px;color:#ffffff;font-size: 24px; line-height: 40px; padding:0 30px;}
    .item2 { position:static; width:523px; height:48px; left:55px;background-position: 0px -500px; color:black;font-size: 24px; line-height: 40px; padding:0 30px;}
    .mask21,.mask22,.mask23,.mask24,.mask25,.mask26 {}
    .mask27 {width:73px;height:37px; left:453px;top:644px;background-position: 0px -50px;}/* more */
    .beaut {width:560px;height:286px;left:55px; top:350px;position: absolute;}

    .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
    .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
    .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
    .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
    .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
    .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
    .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
    .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}

</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

    var blocked = blocked ? blocked : <%= area %>;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;

    //弹出对话框中最大列表数量
    var popMaxItemsLength = 6;

    var isPopUP = blocked == 1;

    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
    <%
        final int popItemMaxCharLength = 36;
        if( list != null && list.size() > 0){
            for(int i = 0; i < list.size() ; i ++){
                out.write("{focus:" + (i == 0 ? 1 : 0) + ",items:[");
                List<Vod> vodList = list.get(i);
                if(i == 0) out.write("{playType:-1,style:'mask mask11'}");
                for( int j = 0; j < vodList.size() ; j++ ){
                    Vod vod = vodList.get(j);
                    out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                             "length:" + StringUtil.length(vod.getName()) + "," +
                          "shortText:'" + StringUtil.limitStringLength(vod.getName(),popItemMaxCharLength) + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                           ( i < 1 ? "style:'mask mask" + (i + 1) + " mask" + (i + 1) + ( j + (i == 0 ? 2 : 1)) + "'" : "" ) +
                         "}" +  ( j + 1 < vodList.size()  ? "," : ""));
                }
                if(i == 1) out.write(",{playType:-1,style:'mask mask27'}");
                out.write("]},");
            }
        }
    %>
        { focus:0, items :[{name:'首页',style:'btnHome'},{name:'返回',style:'btnReturn'}]}
    ];

    var backUrl = '<%= backUrl %>';
    var typeId = '<%= typeId %>';

    function focused(index,initilized){
        var item =  focusable[blocked].items[focusable[blocked].focus];
        var focus = 0, previous = 0;
        if(typeof index == "number" && !initilized){
            //上:11,下:-11,左-1,右1
            previous = focus = focusable[blocked].focus;
            if(index == -1 || index == 1){
                if(blocked == 2 || blocked == 3 || (blocked == 4 && focus == 1 || blocked == 0) && index == 1 || blocked == 1 && index == -1 ) return;
                if( blocked == 0 || blocked == 4 && index == -1 && focus == 0) {blocked = 1;initBeaut(focusable[blocked].focus);}
                else if( blocked == 1 && index == 1 ) {initBeaut();blocked = 0;}
                else if( blocked == 4 ) {focus = index == -1 ? 0 : 1;}
                if( blocked != 4 ) { focus = focusable[blocked].focus; }
            } else {
                if(index == 11 ) {
                    if( blocked == 4 && focus == 1) return;
                    focus = focus - 1;
                    if( focus < 0) {
                        if( blocked == 4 ){
                            blocked = 0;
                            focus = focusable[blocked].focus;
                        } else  return;
                    }
                }
                if( index == -11 ){
                    if( blocked == 4 ) return;
                    focus = focus + 1;
                    if( focus >= focusable[blocked].items.length ){
                        if( blocked == 0) {
                            blocked = 4;
                            focus = focusable[blocked].focus;
                        } else return;
                    }
                }
            }
            focusable[blocked].focus = focus;
        } else if( initilized ){
            focusable[blocked].focus = focus = previous = index;
        }

        item =  focusable[blocked].items[focus];

        if( (blocked == 2 || blocked == 3) && $("popuped").style.visibility == 'hidden' ) {
            $("popuped").style.visibility = "visible";
            $("mask").style.visibility = "hidden";
        }

        if( (blocked == 1 && focus < 6 || blocked == 2 || blocked == 3) && $("mask").style.visibility != "hidden" ) { $("mask").style.visibility = "hidden" }
        else if( blocked == 0 && $("mask").style.visibility == "hidden")  $("mask").style.visible = "visible";
        if( typeof item.style != 'undefined' || blocked == 1) {
            if( blocked == 1 && focus < 6 ){
                initBeaut(focus);
            } else {
                if(blocked == 1 && !initilized) initBeaut();
                if( $("mask").style.visibility == "hidden" ) $("mask").style.visibility = "visible";
                $("mask").className = item.style;
            }
        } else {
            var items = focusable[blocked].items;
            $("page").innerText = (Math.ceil((focus + 1) / popMaxItemsLength) + "/" + Math.ceil(items.length / popMaxItemsLength));
            if($("popuped").style.visibility == "hidden") $("popuped").style.visibility = "visible";
            var html = "";
            for(i = 0; i < items.length ; i ++ ){
                var vod = items[i];
                html += "<div class='" + ( focus == i ? "maskItem" : "item") + "'>" +
                    (vod.length <= <%= popItemMaxCharLength %> || focus != i ? vod.shortText : ("<marquee class='marqueed'>" + vod.text + "</marquee>")) +
                    "</div>";
            }
            $("content").innerHTML = html;
            $("content").style.marginTop = "-" + (Math.floor(focus / popMaxItemsLength) * popMaxItemsLength * 51) + "px";
        }
    }
    function goBack(){
        if( blocked == 3 || blocked == 2 ){
            $("popuped").style.visibility = "hidden";
            blocked = blocked == 3 ? 0 : 1;
            focused(blocked == 0 ? 0 : 6,true);
            return;
        }
        window.location.href = EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
    }

    function initBeaut (focus){
        if(typeof focus == 'undefined') focus = -1;
        var items = focusable[1].items;
        var html = "",i = 0, item = undefined;
        for(i = 0; i < items.length - 1; i ++ ){
            item = items[i];
            html += "<div class='mask " +
                (focus == i ? "mask2" : "item2") + "'>" +
                (item.length <= <%= popItemMaxCharLength %> || focus != i ? item.shortText : ("<marquee class='marqueed'>" +
                item.text + "</marquee>")) + "</div>";
        }
        $("beaut").innerHTML = html;
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
        } else if( item.playType == 1)
            top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
        else {
            top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
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
                        goBack();
                        break;
                    case "KEY_EXIT":
                    case "KEY_MENU":
                        top.window.location.href = iPanel.eventFrame.portalUrl;
                        return 0;
                        break;
                }
            }
        }

        //设置弹出框参数
        focusable[0].items[0].blocked = 3;
        focusable[1].items[6].blocked = 2;
        initBeaut();
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
                    goBack();
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-12-31.jpg') no-repeat;">
<div id="mask"></div>
<div id="beaut" class="beaut"></div>
<div style="width:777px;height:578px;left:546px;top:142px;background:transparent url('images/focus-2015-12-31.png');position: absolute"></div>
<div class='popuped' id='popuped'  style='visibility:hidden'><div class='container' id='container'><div class='content' id='content'></div></div><div class='page' id='page'>1/1</div></div>
</body>
</html>