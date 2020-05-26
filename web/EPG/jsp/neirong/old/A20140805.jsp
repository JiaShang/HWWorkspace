<%@ page language="java" pageEncoding="GBK" %>
<%@ include file="util/util.jsp" %>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title></title>
<style>
    .mask1 {width:210px;height:210px;left:52px;top:200px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px 0px;position:absolute;}
    .mask2 {width:210px;height:210px;left:219px;top:28px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px 0px;position:absolute;}
    .mask3 {width:230px;height:230px;left:181px;top:455px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px -210px;position:absolute;}
    .mask4 {width:272px;height:272px;left:311px;top:217px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px -1212px;position:absolute;}
    .mask5 {width:250px;height:250px;left:608px;top:36px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px -440px;position:absolute;}
    .mask6 {width:264px;height:264px;left:568px;top:422px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px -948px;position:absolute;}
    .mask7 {width:258px;height:258px;left:969px;top:36px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px -690px;position:absolute;}
    .mask8 {width:210px;height:210px;left:900px;top:417px;background: transparent url("images/mask-2014-08-05.png") no-repeat 0px 0px;position:absolute;}
    .btnHome {position:absolute;background:transparent url("images/navBG.png") no-repeat 0px 0px; top:635px;left:1067px; width:161px;height:41px;}
    .btnReturn{position:absolute;background:transparent url("images/navBG.png") no-repeat 0px -42px; top:635px;left:1067px; width:161px; height:41px;}
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
            typeId = "10000100000000090000000000104410";

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
        {name:'夺宝联盟',position:[52,200,210], style:'mask1',action:[0,1,0,2,0,6,0,3]},
        {name:'C+侦探',position:[219,28,210], style:'mask2',action:[0,2,0,3,0,0,0,4]},
        {name:'惊天魔盗团',position:[181,455,230], style:'mask3',action:[0,3,0,1,0,0,0,5]},
        {name:'催眠大师',position:[311,217,272], style:'mask4',action:[0,1,0,2,0,0,0,5]},
        {name:'碟中谍4',position:[607,35,250], style:'mask5',action:[0,5,0,5,0,1,0,6,]},
        {name:'大侦探福尔摩斯',position:[568,422,264], style:'mask6',action:[0,4,0,4,0,2,0,7]},
        {name:'盗梦空间',position:[969,36,258], style:'mask7',action:[1,0,0,7,0,4,0,1]},
        {name:'白头神探',position:[900,417,210], style:'mask8',action:[0,6,1,0,0,5,1,0]}
    ]},
    { focus:0, items : [
        {name:'首页',style:'btnHome',action:[0,7,0,6,0,7,1,1]},
        {name:'返回',style:'btnReturn',action:[0,6,0,7,1,0,0,2]}
    ]}
];
var backUrl = '<%=turnPage.go(-1)%>';
var typeId = '<%=typeId%>';
function initData(){
    for(var i=0; i < vodList.length && i < areaFocusable[0].items[i].length; i++){
        areaFocusable[0].items[i].mid = vodList[i].id;
        areaFocusable[0].items[i].playType = vodList[i].playType;
    }
}
function focused(index){
    var item =  areaFocusable[areaFocused].items[areaFocusable[areaFocused].focus];
    if(typeof index == "number" && index != 0){
        //上:11,下:-11,左-1,右1
        var focus = 0;
        if(index == 11) {
            areaFocused = item.action[0];
            focus = item.action[1];
        } else if(index == -11){
            areaFocused = item.action[2];
            focus = item.action[3];
        } else if(index == -1){
            areaFocused = item.action[4];
            focus = item.action[5];
        } else {
            areaFocused = item.action[6];
            focus = item.action[7];
        }
        areaFocusable[areaFocused].focus = focus;
    }
    if( areaFocused == 0) {
        $("mask").style.display = "";
    }
    item =  areaFocusable[areaFocused].items[areaFocusable[areaFocused].focus];
    $("mask").className = item.style;
}
function doEnter(){
    if( typeof iPanel == "undefined" ){
        alert("");
        return;
    }

    try{ E.is_HD_vod = true; } catch (e) {}

    if(areaFocused == 0){
        if(vodList[areaFocusable[areaFocused].focus].playType == 1)
            top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + vodList[areaFocusable[areaFocused].focus].id + "&typeId=" + typeId;
        else {
            top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + vodList[areaFocusable[areaFocused].focus].id + "&contentType=0&startTime=0&business=1";
        }
    }
    else {
        if(areaFocusable[areaFocused].focus == 0)
            top.window.location.href = backUrl;
        else
            top.window.location.href = iPanel.eventFrame.portalUrl;

    }
}
function keyCodeAction(code){
    focused(code);
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
    if( typeof $.ajax === 'undefined') {
        $.ajax = function(url,callback,options){
            if( typeof  url === 'undefined' ) return;

            if(typeof  options === 'undefined')
                options = {};

            if(typeof options.method === 'undefined' ) options.method = "GET";
            if( typeof options.async === 'undefined' ) options.async = true;
            var request = new XMLHttpRequest();
            request.onreadystatechange = function (){
                if(request.readyState ===4){
                    if(request.status ===200 && typeof callback === 'function' ){
                        var result = eval("(" + request.responseText + ")");
                        callback( result );
                    }
                    else{
                        request.abort();
                    }
                }
            }
            request.open(options.method, url, options.async);
            request.send(null);
        }
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
                    top.window.location.href = backUrl;
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
    return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + areaFocused + "," + areaFocusable[areaFocused].focus + "," + 0 + "&url=";
}
window.onload = function(){
    setTimeout("init()",100);
}
-->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-08-05.jpg') no-repeat;">
<div id="mask"></div>
</body>
</html>
