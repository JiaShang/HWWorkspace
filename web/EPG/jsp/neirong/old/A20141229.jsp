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
    final String[] types = {"10000100000000090000000000104750", "10000100000000090000000000104751","10000100000000090000000000104752"};

    //TODO:每次需要修改
    int length = 50, start = 0;
    //区块中当前被选择的顺序
    int focused = 0;
    //选择的区块 0:普通焦点，1:首页，返回按钮，2:弹出对话框中的上一页，下一页，返回，3:弹出对话框中的列表中的条目
    int area = 0;

    String backUrl = "";
    String value = "";
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
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type, length, start );
            list.add( ls );
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>2014电影点播岁末盘点</title>
<style>
    .mask {position:absolute;background:transparent url('images/mask-2014-12-29.png') no-repeat fixed;background-position: 0px 0px;}
    #focusBg{width: 1280px;height:720px;position: absolute;left: 0px; top:0px;}
    .focusBg1 {background: transparent url('images/focus1-2014-12-29.png') no-repeat fixed 0px 0px;}
    .focusBg2 {background: transparent url('images/focus2-2014-12-29.png') no-repeat fixed 0px 0px;}
    .focusBg3 {background: transparent url('images/focus3-2014-12-29.png') no-repeat fixed 0px 0px;}

    .mask11 {width:285px; height:25px; left:225px; top:424px;background-position: 0px -429px;}
    .mask12 {width:285px; height:25px; left:226px; top:456px;background-position: 0px -461px;}
    .mask13 {width:307px; height:25px; left:225px; top:487px;background-position: 0px -493px;}
    .mask14 {width:304px; height:25px; left:226px; top:520px;background-position: 0px -525px;}
    .mask15 {width:285px; height:25px; left:226px; top:552px;background-position: 0px -557px;}
    .mask16 {width:305px; height:25px; left:226px; top:583px;background-position: 0px -589px;}
    .mask17 {width:454px; height:25px; left:598px; top:424px;background-position: -549px -429px;}
    .mask18 {width:338px; height:25px; left:598px; top:456px;background-position: -549px -461px;}
    .mask19 {width:294px; height:25px; left:598px; top:488px;background-position: -549px -493px;}
    .mask110 {width:355px; height:25px; left:598px; top:520px;background-position: -549px -525px;}
    .mask111 {width:420px; height:25px; left:598px; top:551px;background-position: -549px -557px;}
    .mask112 {width:240px; height:37px; left:494px; top:638px;background-position: -4px -649px;}
    .mask113 {width:240px; height:37px; left:752px; top:638px;background-position: -309px -649px;}

    .mask21 {width:145px; height:25px; left:449px; top:207px;background-position: 0px 0px;}
    .mask22 {width:147px; height:25px; left:449px; top:247px;background-position: 0px -40px;}
    .mask23 {width:146px; height:25px; left:449px; top:287px;background-position: 0px -80px;}
    .mask24 {width:147px; height:25px; left:449px; top:327px;background-position: 0px -120px;}
    .mask25 {width:248px; height:25px; left:449px; top:367px;background-position: 0px -160px;}
    .mask26 {width:146px; height:25px; left:449px; top:407px;background-position: 0px -200px;}
    .mask27 {width:217px; height:25px; left:449px; top:447px;background-position: 0px -240px;}
    .mask28 {width:145px; height:25px; left:449px; top:487px;background-position: 0px -280px;}
    .mask29 {width:144px; height:25px; left:449px; top:527px;background-position: 0px -320px;}
    .mask210 {width:144px; height:25px; left:449px; top:567px;background-position: 0px -360px;}
    .mask211 {width:148px; height:25px; left:853px; top:207px;background-position: -282px -0px;}
    .mask212 {width:145px; height:25px; left:853px; top:247px;background-position: -282px -40px;}
    .mask213 {width:143px; height:25px; left:853px; top:287px;background-position: -282px -80px;}
    .mask214 {width:143px; height:25px; left:853px; top:327px;background-position: -282px -120px;}
    .mask215 {width:170px; height:25px; left:853px; top:367px;background-position: -282px -160px;}
    .mask216 {width:134px; height:25px; left:853px; top:407px;background-position: -282px -200px;}
    .mask217 {width:145px; height:25px; left:853px; top:447px;background-position: -282px -240px;}
    .mask218 {width:143px; height:25px; left:853px; top:487px;background-position: -282px -280px;}
    .mask219 {width:141px; height:25px; left:853px; top:527px;background-position: -282px -320px;}
    .mask220 {width:249px; height:25px; left:853px; top:567px;background-position: -282px -360px;}

    .mask31 {width:347px; height:25px; left:449px; top:207px;background-position: -549px -7px;}
    .mask32 {width:347px; height:25px; left:449px; top:247px;background-position: -549px -47px;}
    .mask33 {width:347px; height:25px; left:449px; top:287px;background-position: -549px -87px;}
    .mask34 {width:347px; height:25px; left:449px; top:327px;background-position: -549px -127px;}
    .mask35 {width:347px; height:25px; left:449px; top:367px;background-position: -549px -167px;}
    .mask36 {width:347px; height:25px; left:449px; top:407px;background-position: -549px -207px;}
    .mask37 {width:347px; height:25px; left:449px; top:447px;background-position: -549px -247px;}
    .mask38 {width:347px; height:25px; left:449px; top:487px;background-position: -549px -287px;}
    .mask39 {width:347px; height:25px; left:449px; top:527px;background-position: -549px -327px;}
    .mask310 {width:347px; height:25px; left:449px; top:567px;background-position: -549px -367px;}
    .mask311 {width:347px; height:25px; left:853px; top:207px;background-position: -953px -7px;}
    .mask312 {width:347px; height:25px; left:853px; top:247px;background-position: -953px -47px;}
    .mask313 {width:347px; height:25px; left:853px; top:287px;background-position: -953px -87px;}
    .mask314 {width:347px; height:25px; left:853px; top:327px;background-position: -953px -127px;}
    .mask315 {width:347px; height:25px; left:853px; top:367px;background-position: -953px -167px;}
    .mask316 {width:347px; height:25px; left:853px; top:407px;background-position: -953px -207px;}
    .mask317 {width:347px; height:25px; left:853px; top:447px;background-position: -953px -247px;}
    .mask318 {width:347px; height:25px; left:853px; top:487px;background-position: -953px -287px;}
    .mask319 {width:347px; height:25px; left:853px; top:527px;background-position: -953px -327px;}
    .mask320 {width:347px; height:25px; left:853px; top:567px;background-position: -953px -367px;}
    
    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
    .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

    var blocked = blocked ? blocked : <%= area %>;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;

    var lastFocused = blocked;

    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
    <%
        String[] actions = new String[3];
        actions[0] = "[0,0,0,1,0,0,0,6]|[0,0,0,2,0,1,0,7]|[0,1,0,3,0,2,0,8]|[0,2,0,4,0,3,0,9]|[0,3,0,5,0,4,0,10]|[0,4,0,11,0,5,0,12]|[0,6,0,7,0,0,0,6]|[0,6,0,8,0,1,0,7]|[0,7,0,9,0,2,0,8]|[0,8,0,10,0,3,0,9]|[0,9,0,12,0,4,0,10]";
        actions[1] = "[1,0,1,1,1,0,1,10]|[1,0,1,2,1,1,1,11]|[1,1,1,3,1,2,1,12]|[1,2,1,4,1,3,1,13]|[1,3,1,5,1,4,1,14]|[1,4,1,6,1,5,1,15]|[1,5,1,7,1,6,1,16]|[1,6,1,8,1,7,1,17]|[1,7,1,9,1,8,1,18]|[1,8,1,9,1,9,1,19]|[1,10,1,11,1,0,1,10]|[1,10,1,12,1,1,1,11]|[1,11,1,13,1,2,1,12]|[1,12,1,14,1,3,1,13]|[1,13,1,15,1,4,1,14]|[1,14,1,16,1,5,1,15]|[1,15,1,17,1,6,1,16]|[1,16,1,18,1,7,1,17]|[1,17,1,19,1,8,1,18]|[1,18,3,0,1,9,1,19]";
        actions[2] = "[2,0,2,1,2,0,2,10]|[2,0,2,2,2,1,2,11]|[2,1,2,3,2,2,2,12]|[2,2,2,4,2,3,2,13]|[2,3,2,5,2,4,2,14]|[2,4,2,6,2,5,2,15]|[2,5,2,7,2,6,2,16]|[2,6,2,8,2,7,2,17]|[2,7,2,9,2,8,2,18]|[2,8,2,9,2,9,2,19]|[2,10,2,11,2,0,2,10]|[2,10,2,12,2,1,2,11]|[2,11,2,13,2,2,2,12]|[2,12,2,14,2,3,2,13]|[2,13,2,15,2,4,2,14]|[2,14,2,16,2,5,2,15]|[2,15,2,17,2,6,2,16]|[2,16,2,18,2,7,2,17]|[2,17,2,19,2,8,2,18]|[2,18,3,0,2,9,2,19]";
        if( list != null && list.size() > 0){
            for(int i = 0; i < list.size() ; i ++){
                out.write("{focus:0,style:'focusBg" + (i + 1) + "',items:[");
                String[] action = actions[i].split("\\|");
                List<Vod> vodList = list.get(i);
                for( int j = 0; j < vodList.size() && ( i == 0 && j < 11 || i > 0 && j < 20); j++ ){
                    Vod vod = vodList.get(j);
                    out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                             "action:" + action[j] + "," +
                              "style:'mask mask" + (i + 1) + (j + 1) + "'" +
                         "}" +  ( (j + 1 < vodList.size() && ( i == 0 && j +1 <  11 || i > 0 && j +1 < 20) ) ? "," : ""));
                }
                if( i == 0) {
                    out.write(",{playType:-1,action:[0,5,0,11,0,5,0,12],blocked:1,style:'mask mask112'}");
                    out.write(",{playType:-1,action:[0,10,0,12,0,11,3,0],blocked:2,style:'mask mask113'}");
                }
                out.write("]},");
            }
        }
    %>
        { focus:0, items : [
            {name:'首页',style:'btnHome',actions:[[0,10,3,0,0,12,3,1],[1,19,3,0,3,0,3,1],[2,19,3,0,3,0,3,1]]},
            {name:'返回',style:'btnReturn',actions:[[0,10,3,1,3,0,3,1],[1,19,3,1,3,0,3,1],[2,19,3,1,3,0,3,1]]}
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
                blocked = item.action[0];
                focus = item.action[1];
            } else if(index == -11){
                blocked = item.action[2];
                focus = item.action[3];
            } else if(index == -1){
                blocked = item.action[4];
                focus = item.action[5];
            } else {
                blocked = item.action[6];
                focus = item.action[7];
            }
            focusable[blocked].focus = focus;
        } else if( initilized ){
            lastFocused = blocked;
            $("focusBg").className = focusable[blocked].style;
            focusable[blocked].focus = focus =  index;
            focusable[focusable.length - 1].items[0].action = focusable[focusable.length - 1].items[0].actions[blocked];
            focusable[focusable.length - 1].items[1].action = focusable[focusable.length - 1].items[1].actions[blocked];
        }
        item =  focusable[blocked].items[focus];
        $("mask").className = item.style;
    }
    function goBack(){
        if( lastFocused === 0 ) {
            window.location.href = EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
        } else {
            blocked = 0;
            focused(focusable[blocked].focus ,true);
        }
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}

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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-12-29.jpg') no-repeat;">
<div id="focusBg"></div>
<div id="mask"></div>
</body>
</html>