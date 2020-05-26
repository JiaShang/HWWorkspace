<%--
    专题名称:   扒皮最火电视剧的“前世今生”
    上线时间:   2014-07-31 或 2014-08-01
--%>
<%@ page language="java" pageEncoding="GBK" %>
<%@ include file="util/util.jsp" %>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title></title>
    <style>
        .mask {position:absolute;background:transparent url("images/mask-2014-08-01.png") no-repeat 0px -5px; top:413px;left:84px; width:147px; height:56px}
        .maskTenYear {position:absolute;background:transparent url("images/mask-2014-08-01.png") no-repeat 0px -67px; top:547px;left:386px; width:147px; height:83px}
        .maskLove {position:absolute;background:transparent url("images/mask-2014-08-01.png") no-repeat 0px -159px; top:518px;left:745px; width:151px; height:53px}
        .maskEnd {position:absolute;background:transparent url("images/mask-2014-08-01.png") no-repeat 0px -224px; top:257px;left:855px; width:81px; height:55px}
        .btnHome {position:absolute;background:transparent url("images/navBG.png") no-repeat 0px 0px; top:635px;left:1067px; width:161px; height:41px}
        .btnReturn{position:absolute;background:transparent url("images/navBG.png") no-repeat 0px -42px; top:635px;left:1067px; width:161px; height:41px}
    </style>
    <script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); } catch (e) {};

    var vodList = [
    <%
        String typeId = request.getParameter("typeId");
        String value = request.getParameter("pageSize");
        int length = 50, start = 0;
        if( ! ( value == null || value.trim().length() == 0 ) )
            length = Integer.parseInt(value);

        value = request.getParameter("startIndex");
        if(! ( value == null || value.trim().length() == 0 ))
            start = Integer.parseInt(value);

        if(  typeId == null || typeId.trim().length() == 0 )
            typeId = "10000100000000090000000000104386";

        String ifcor = request.getParameter("ifcor");
        String for_play_back = request.getParameter("for_play_back");
        TurnPage turnPage = new TurnPage(request);
        try {
            if(null == for_play_back){
                if(null == ifcor){
                    turnPage.addUrl();
                }
                else{
                    turnPage.removeLast();
                    turnPage.addUrl();
                }
            }
            else{
                turnPage.removeLast();
            }
            MetaData metaHelper = new MetaData(request);
            List<Vod> list = getVodList( metaHelper, typeId, length, start );
            if( list != null && list.size() > 0){
              for( int i = 0; i< list.size(); i ++)
                  out.write("{ id : " + list.get(i).getId() + ", playType : " + list.get(i).getIsSitcom() + "}" +  ( i + 1 < list.size() ? "," : "") + "\n");
              }
        } catch (Exception e){}
    %> ];
    var areaFocused = areaFocused ? areaFocused : 0;
    //可获得焦点的区域个数
    var areaFocusable = areaFocusable ? areaFocusable : [
        { focus:0, items : [
            {name:'杉杉来了',style:'mask'},
            {name:'相爱十年',style:'maskTenYear'},
            {name:'恋恋不忘',style:'maskLove'},
            {name:'绝爱',style:'maskEnd'}
        ]},
        { focus:0, items : [
            {name:'首页',style:'btnHome'},
            {name:'返回',style:'btnReturn'}
        ]}
    ];
    function initData(){
        for(var i=0; i < vodList.length && i < areaFocusable[0].items[i].length; i++){
            areaFocusable[0].items[i].mid = vodList[i];
        }
    }
    function focused(index){
        if(typeof index == "number"){
            areaFocusable[areaFocused].focus += index;
            if(index < 0 && areaFocusable[areaFocused].focus < 0)
                areaFocusable[areaFocused].focus = areaFocusable[areaFocused].items.length - 1;
            else if(index > 0 && areaFocusable[areaFocused].focus >= areaFocusable[areaFocused].items.length)
                areaFocusable[areaFocused].focus = 0;
        }
        if( areaFocused == 0) {
            $("mask").style.display = "";
        }
        var item =  areaFocusable[areaFocused].items[areaFocusable[areaFocused].focus];
        $("mask").className = item.style;
    }

    function doEnter(){
        if( typeof iPanel == "undefined" ){
            alert("");
            return;
        }
        if(areaFocused == 0){
            if(vodList[areaFocusable[areaFocused].focus].playType == 1)
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + vodList[areaFocusable[areaFocused].focus].id + "&typeId=<%=typeId%>";
            else {
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=<%=typeId%>&playType=1&progId=" + vodList[areaFocusable[areaFocused].focus].id + "&contentType=0&startTime=0&business=1";
            }
        }
        else {
            if(areaFocusable[areaFocused].focus == 0)
                top.window.location.href = '<%=turnPage.go(-1)%>';
            else
                top.window.location.href = iPanel.eventFrame.portalUrl;

        }
    }

    function keyCodeAction(code){
        if ( code == 11 || code == -11 ){
            if( code > 0)
            {
                areaFocused += 1;
                if(areaFocused >= areaFocusable.length) areaFocused = 0;
            } else {
                areaFocused -= 1;
                if(areaFocused < 0) areaFocused = areaFocusable.length - 1;
            }
            focused();
        }
        else {
            focused(code);
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
                        keyCodeAction(11);
                        break;
                    case 40:                        //下光标键
                        keyCodeAction(-11);
                        break;
                    case 37:                        //左光标键
                        keyCodeAction(-1);
                        break;
                    case 39:                        //右光标键
                        keyCodeAction(1);
                        break;
                    case 13:                        //选择回车键
                        doEnter();
                        break;
                    case "KEY_BACK":
                        top.window.location.href = '<%=turnPage.go(-1)%>';
                        break;
                    case "KEY_EXIT":
                    case "KEY_MENU":
                        top.window.location.href = iPanel.eventFrame.portalUrl;
                        return 0;
                        break;
                }
            }
        } else {
            iPanel.eventFrame.initPage(window);
        }

        initData();

        focused(0);
    }

    function eventHandler(eventObj, __type){
        switch(eventObj.code){
            case "KEY_UP":
                keyCodeAction(11);
                break;
            case "KEY_DOWN":
                keyCodeAction(-11);
                break;
            case "KEY_LEFT":
                keyCodeAction(-1);
                break;
            case "KEY_RIGHT":
                keyCodeAction(1);
                break;
            case "KEY_SELECT":
                doEnter();
                break;
            case "KEY_BACK":
                window.location.href = '<%=turnPage.go(-1)%>';
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
        return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + areaFocused + "," + areaFocusable[areaFocused].focus + "," + 0 + "&url=";
    }

    window.onload = function(){
        E.is_HD_vod = true;
        setTimeout("init()",100);
    }
    -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-08-01.jpg') no-repeat;">
<div id="mask"></div>
</body>
</html>
