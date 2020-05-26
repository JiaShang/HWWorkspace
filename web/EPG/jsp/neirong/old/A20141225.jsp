<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104749";

    // 1  2014电影点播岁末盘点（绑定首页内容）  10000100000000090000000000104750 点播   未激活 所有区域 2014-12-24 17:52:35
    // 2  标清电影点播排行榜  10000100000000090000000000104751 点播   未激活 所有区域 2014-12-24 17:53:30
    // 3  高清电影点播排行榜  10000100000000090000000000104752 点播   未激活 所有区域 2014-12-24 17:53:55
    final String[] types = {"10000100000000090000000000104758","10000100000000090000000000104757"};

    //TODO:每次需要修改
    int length = 50, start = 0;
    //区块中当前被选择的顺序
    int focused = 0;
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
            List<Vod> ls = getVodList( metaHelper, type, (i == 0 ? 10 : 20), start );
            list.add( ls );
            i ++;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>2014年超人气点播热剧</title>
<style>
    .mask {position:absolute;background:transparent url('images/mask-2014-12-25.png') no-repeat fixed;background-position: 0px 0px;}
    .mask1 {width:238px; height:31px; left:899px; top:88px;background-position: 0px 0px;}
    .mask2 {width:238px; height:31px; left:899px; top:120px;background-position: 0px -40px;}
    .mask3 {width:238px; height:31px; left:899px; top:199px;background-position: 0px -80px;}
    .mask4 {width:238px; height:31px; left:899px; top:233px;background-position: 0px -120px;}
    .mask5 {width:238px; height:31px; left:899px; top:312px;background-position: 0px -160px;}
    .mask6 {width:238px; height:31px; left:899px; top:344px;background-position: 0px -200px;}
    .mask7 {width:238px; height:31px; left:899px; top:424px;background-position: 0px -240px;}
    .mask8 {width:238px; height:31px; left:899px; top:452px;background-position: 0px -280px;}
    .mask9 {width:238px; height:31px; left:899px; top:527px;background-position: 0px -320px;}
    .mask10 {width:238px; height:31px; left:899px; top:561px;background-position: 0px -360px;}
    .mask11 {width:218px; height:77px; left:234px; top:600px;background-position: 0px -400px;}
    .focusBg {position:absolute;left:0px;top:0px; width: 1280px;height:720px;background:transparent url('images/focusBg-2014-12-25.png') no-repeat fixed;}
    .itemContainer {position: absolute;width: 880px;height:373px;left :325px;top:227px;}
    .item {height: 38px;width:318px;background:transparent url('images/focusMask-2014-12-25.png') no-repeat fixed ;float: left;}
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

    var isPopUP = blocked === 1;

    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
    <%
        final int popItemMaxCharLength = 8;
        if( list != null && list.size() > 0){
            for(int i = 0; i < list.size() ; i ++){
                out.write("{focus:0,items:[");
                List<Vod> vodList = list.get(i);
                for( int j = 0; j < vodList.size() ; j++ ){
                    Vod vod = vodList.get(j);
                    out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                          "shortText:'" + StringUtil.limitStringLength(vod.getName(),popItemMaxCharLength) + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                           (i == 0  ? "style:'mask mask" + (j + 1) + "'" : "" ) +
                         "}" +  ( j + 1 < vodList.size()  ? "," : ""));
                }
                out.write("]},");
            }
        }
    %>
        { focus:0, items :[{name:'浮动层',playType:-1,style:'mask mask11'}]},
        { focus:0, items :[{name:'首页',style:'btnHome'},{name:'返回',style:'btnReturn'}]}
    ];

    var backUrl = '<%= backUrl %>';
    var typeId = '<%= typeId %>';

    function focused(index,initilized){
        var item =  focusable[blocked].items[focusable[blocked].focus];
        var focus = 0, previous = 0;
        if(typeof index == "number" && !initilized){
            //上:11,下:-11,左-1,右1
            if(index == -1 || index == 1){
                if( blocked === 1 ){
                    focus = focusable[blocked].focus;
                    if( focus < 10 && index === -1 || focus >= 10 && index === 1) return;
                    focus = focus + (index > 0 ? 10 : -10);
                } else {
                    if( index == 1 ){
                        if( blocked === 0 || blocked === 3 &&  focusable[blocked].focus == 1) return;
                        if( blocked === 2 ) {
                            blocked = 0;
                            focus = focusable[blocked].focus;
                        } else if( blocked === 3 ) {
                            focus = 1;
                        }
                    }
                    if( index == -1 ){
                        if(blocked === 2) return;
                        if( blocked == 0 || blocked  == 3  && focusable[blocked].focus === 0 ) {
                            if(! isPopUP) {
                                focus = 0 ; blocked = 2;
                            }
                            else
                                return;
                        } else if ( blocked == 3 ){
                            focus = 0;
                        }
                    }
                }
            } else {
                if ( blocked === 2 ) return;
                if( index === 11 ) {
                    if( blocked != 3 && focusable[blocked].focus === 0 || blocked === 1 && (focusable[blocked].focus === 0 || focusable[blocked].focus == 10)) return;
                    focus = focusable[blocked].focus;
                    focus = focus - 1;
                    if( focus <= 0  ) {
                        if(  blocked === 3 ) {
                            if(isPopUP){
                                blocked = 2;
                                focused(0,true);
                            }
                            blocked = isPopUP ? 1 : 0;
                            focus = focusable[blocked].focus;
                        } else
                            focus = 0;
                    }
                }
                if( index === -11 ) {
                    if (blocked == 3 ) return;
                    focus = focusable[blocked].focus;
                    focus = focus + 1;
                    if ( focus >= focusable[blocked].items.length && blocked != 1 || blocked === 1 && (focus == 10 || focus == 20)) {
                        if (blocked === 0 || blocked === 1) {
                            if( isPopUP) {
                                focus = focus - 1;
                                $("item1" + (focus + 1)).style.backgroundPosition = (focus < 10 ? 0 : -320) + "px -" + ((focus - ( focus >= 10 ? 10 : 0)) * 38 ) + "px";
                            }
                            blocked = 3;
                            focus = focusable[blocked].focus;
                        }
                        else
                            focus = focusable[blocked].items.length - 1;
                    }
                }
            }
            previous = focusable[blocked].focus ;
            focusable[blocked].focus = focus;
        } else if( initilized ){
            focusable[blocked].focus = focus = previous = index;
        }
        item =  focusable[blocked].items[focus];
        if( typeof item.style != 'undefined' ) {
            $("mask").className = item.style;
        } else {
            if($("focusBg").style.display === "none") $("focusBg").style.display = "";
            if( previous != focus )
                $("item1" + (previous + 1)).style.backgroundPosition = (previous < 10 ? 0 : -320) + "px -" + ((previous - ( previous >= 10 ? 10 : 0)) * 38) + "px";
            $("item1" + (focus + 1)).style.backgroundPosition = (focus < 10 ? 0 : -320) + "px -" + ((focus - ( focus >= 10 ? 10 : 0)) * 38 + 381) + "px";

        }
    }
    function goBack(){
        if( blocked === 1) {
            $("focusBg").style.display = "none";
            blocked = 2;
            isPopUP = false;
            focused(0,true);
            return;
        }
        window.location.href = EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}
        if( blocked === 2) {
            blocked = 1;
            isPopUP = true;
            $("focusBg").style.display = "";
            focused(focusable[blocked].focus,true);
            return;
        }
        if(blocked < 3){
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
        else {
            if(focusable[blocked].focus == 1)
                goBack();
            else
                top.window.location.href = iPanel.eventFrame.portalUrl;
        }
    }
    function initVodList(){
        var list = focusable[1].items;
        var end = Math.ceil(list.length / 2);
        var html = "";
        for(var i = 0; i < end; i++){
            var item = list[i];
            html += "<div class='item' id='item1" + (i + 1) + "' style='background-position:0px -" + (i * 38) + "px'>&nbsp;</div>";
            item = list[i + end];
            if( typeof  item != "undefined")
                html += "<div class='item' id='item1" + (i + end + 1) + "' style='background-position:-320px -" + (i * 38) + "px'>&nbsp;</div>";
        }
        $("itemContainer").innerHTML = html;
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
        initVodList();
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-12-25.jpg') no-repeat;">
<div id="mask"></div>
<div id="focusBg" style="display: none;" class="focusBg">
    <div id="itemContainer" class="itemContainer"></div>
</div>
</body>
</html>