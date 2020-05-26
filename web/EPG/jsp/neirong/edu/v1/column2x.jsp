<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //TODO:每次需要修改
    int focused = 0, area = 1;
    final int popItemMaxCharLength = 52;

    String backUrl = "";
    String fromEPG = "";
    String value = "";

    TurnPage turnPage = new TurnPage(request);

    //栏目顺序
    String currentPage = request.getParameter("page");
        if( StringUtils.isEmpty(currentPage) ) currentPage = "0";

    String idx = request.getParameter("idx");
    String typeId = request.getParameter("typeId");

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");
        String isGateway = request.getParameter("isGateway");

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
        String[] focus = null;
        value = request.getParameter("currFoucs");
        focus = StringUtils.isEmpty( value ) ? turnPage.getPreFoucs() : value.split("\\,");

        if(null != focus ){
            if( focus.length > 0 && focus[0] != null )
                area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                focused = Integer.parseInt(focus[1]);
            if( focus.length > 2 && focus[2] != null )
                currentPage = focus[2];
        }

        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>本周排行榜</title>
    <link type="text/css" rel="stylesheet" href="css/edu.css"/>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            {focus: 0, typeId:'', items:[]},
            {focus: 0, typeId:'', items:[]}
        ];
        var backUrl = '<%= backUrl %>';
        var page = <%= currentPage %>;          //当前页数
        var pageSize = 7;
        function loadVodList(){
            $.ajax("interface.jsp?id=<%= typeId %>&pic=1&col=2&size=" + pageSize + "&max=<%=popItemMaxCharLength%>&tp=vod&page=" + page, function( rst ){
                focusable[1].typeId = rst.typeId;
                focusable[1].length = rst.length;
                focusable[1].items = rst.items;

                if( focusable[1].picture != rst.picture ) {
                    focusable[1].picture = rst.picture;
                    $("column2RtImg").src = rst.picture;
                }

                if( focusable[1].name != rst.name ) {
                    focusable[1].name = rst.name;
                    $("column2RtTxt").innerHTML = rst.name;
                }

                if( focusable[1].length > pageSize ){
                    $("arrowUp").style.visibility = 'visible';
                    $("arrowDown").style.visibility = 'visible';
                    $("arrowUp").className = "absolute " + ( page > 0 ? "column2ArrowUpFocus" : "column2ArrowUp" );
                    $("arrowDown").className = "absolute " + ( ( page + 1 ) * pageSize < focusable[1].length ? "column2ArrowDownFocus" : "column2ArrowDown" );
                } else {
                    $("arrowUp").style.visibility = 'hidden';
                    $("arrowDown").style.visibility = 'hidden';
                }

                flowedShow( 1 );
            });
        }
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                if( blocked == 1 && ( index == -1 || index == 1 ) ) return;
                if( blocked == 1 ) {
                    focus += index > 0 ? -1 : 1;
                    if( focus >= focusable[1].length || focus < 0 ) return;
                }
                focusable[blocked].focus = focus;
                if( blocked == 1 && ( index == -11 && focus % pageSize == 0 || index == 11 && focus % pageSize == pageSize - 1 ) ) {
                    page += index > 0 ? -1 : 1;
                    loadVodList();
                    return;
                }
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
                loadVodList();
                return;
            }

            for( var o in focusable.flowed ) flowedShow(focusable.flowed[o]);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            var html = '';
            for(var i = 0; i < items.length; i += 1) {
                var item = items[i];
                html += "<div class='item'>";
                html += "<div class='icon'></div>";
                if( focus % pageSize == i ) {
                    html += "<div class='txt'></div>";
                    $("mask").className = "absolute maskColumn2xItem";
                    $("mask").style.top = (204 + focus %  pageSize * 62 ) +  "px";
                    $("mask").innerHTML = "<div class='icon'></div><div class='txt'>" + ( item.length >= <%=popItemMaxCharLength%> ? ( "<marquee class='column2xItemMarquee' scrollamount='5'>" + item.text + "</marquee>" ) : item.text) + "</div>";
                } else {
                    html += "<div class='txt'>" + item.shortText + "</div>";
                }
                html += "</div>";
            }
            $("flowed").innerHTML = html;
        }
        function init(){
            String.prototype.trim=function(){return this.replace(/(^\s*)|(\s*$)/g, "");}
            String.prototype.ltrim=function(){return this.replace(/(^\s*)/g,"");}
            String.prototype.rtrim=function(){return this.replace(/(\s*$)/g,"");}
            String.prototype.endWith=function(str){
                if(str==null||str==""||this.length==0||str.length>this.length)
                    return false;
                return this.substring(this.length-str.length) === str;
            }
            String.prototype.startWith=function(str){
                if(str==null||str==""||this.length==0||str.length>this.length)
                    return false;
                return  this.substr(0,str.length) === str;
            }
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
                        case 38: focused(11, false);break;      //上光标键
                        case 40:focused(-11, false);break;      //下光标键
                        case 37:focused(-1, false);break;       //左光标键
                        case 39:focused(1, false);break;        //右光标键
                        case 13: doEnter(); break;              //选择回车键
                        case 46:goBack(true);break;
                        case "KEY_EXIT":
                        case "KEY_MENU":top.window.location.href = iPanel.eventFrame.portalUrl; return 0;break;
                    }
                }
            }
            if( typeof $.ajax === 'undefined') {
                $.ajax = function(url,callback,options){
                    if( typeof  url === 'undefined' ) return;
                    if(typeof  options === 'undefined')options = {};

                    if(typeof options.method === 'undefined' ) options.method = "GET";
                    if( typeof options.async === 'undefined' ) options.async = true;
                    var request = new XMLHttpRequest();
                    request.onreadystatechange = function (){
                        if(request.readyState ===4){
                            if(request.status ===200 && typeof callback === 'function' ){
                                var responseText = request.responseText;
                                var result = (new Function("return " + responseText))();
                                callback( result );
                            }
                            else{request.abort();}
                        }
                    }
                    request.open(options.method, url, options.async);
                    request.send(null);
                };
            }
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "," + page +  "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='absolute column2xFlowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div class='absolute txtIcon txtIcon<%= idx %>'></div>";
                html += "<div class='absolute spBar'></div>";
                html += "<div id='mask'></div>";
                html += "<div id='arrowUp'></div>";
                html += "<div id='arrowDown'></div>";
                html += "<div class='absolute column2RtBorder'><img id='column2RtImg' /><div id='column2RtTxt' class='text'></div></div>";
                document.body.innerHTML = html;
            }
            $.bookmark = function(vodid){
                var marks = iPanel.ioctlRead("bookmark");
                if( marks != null ){
                    var overs = marks.split(";");
                    for(var i = 0; i < overs.length; i++){
                        var temp = overs[i].split(",");
                        if( temp[1] == "undefined" || temp[1] == undefined) return null;
                        if( temp[1] == 'vodid' ) return temp[4]; //将断点时间取出，其他字段不要
                    }
                }
                return null;
            }
            $.buildUserInterface({flowed:[1]});
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( ( EPGflag || typeof keyBack == 'boolean' && !keyBack ) && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            var item =  focusable[blocked].items[focusable[blocked].focus % pageSize];
            if(typeof item == 'undefined' || item.playType == 'undefined' || item.playType == -99 ) return;
            var typeId = focusable[blocked].typeId;
            switch(item.playType){
                case -3:
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        url += encodeURIComponent('<%= request.getRequestURL().toString() %>?currFoucs=' + blocked + "," + focusable[blocked].focus);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/vod/tv_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://去掉基本包检验 baseFlag=0
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
                    break;
            }
        }
        function eventHandler(eventObj, __type){
            switch(eventObj.code){
                case "KEY_UP":focused(11, false);break;
                case "KEY_DOWN":focused(-11, false);break;
                case "KEY_LEFT":focused(-1, false);break;
                case "KEY_RIGHT":focused(1, false);break;
                case "KEY_SELECT":doEnter();break;
                case "KEY_NUMERIC":break;
                case "KEY_BACK": goBack(true);break;
                case "KEY_EXIT":
                case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
                case "VOD_PREPAREPLAY_SUCCESS":break;
                case "EIS_VOD_PROGRAM_END":break;
            }
            return 	eventObj.args.type;
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/background.jpg') no-repeat left top;" onUnload="exit();"></body>
</html>