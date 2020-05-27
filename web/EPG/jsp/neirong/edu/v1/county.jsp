<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //TODO:每次需要修改
    int focused = 0, area = 1;
    final int popItemMaxCharLength = 38;

    String backUrl = "";
    String fromEPG = "";
    String value = "";

    TurnPage turnPage = new TurnPage(request);

    String idx = request.getParameter("idx");

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

        value = StringUtils.isEmpty( request.getParameter("currFoucs") ) ? request.getParameter("PREFOUCS") : request.getParameter("currFoucs");

        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>区县视窗</title>
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
            {focus: 0, items:[]},
            {focus: 0, fixed:false ,items:[
                { name : "万州区", typeId : "10000100000000090000000000104760"},
                { name : "黔江区", typeId : "10000100000000090000000000104772"},
                { name : "涪陵区", typeId : "10000100000000090000000000104782"},
                { name : "渝中区", typeId : "10000100000000090000000000104786"},
                { name : "大渡口区", typeId : "10000100000000090000000000104787"},
                { name : "江北区", typeId : "10000100000000090000000000104793"},
                { name : "沙坪坝区", typeId : "10000100000000090000000000104781"},
                { name : "九龙坡区", typeId : "10000100000000090000000000104775"},
                { name : "南岸区", typeId : "10000100000000090000000000104770"},
                { name : "北碚区", typeId : "10000100000000090000000000104766"},
                { name : "渝北区", typeId : "10000100000000090000000000104763"},
                { name : "巴南区", typeId : "10000100000000090000000000104774"},
                { name : "长寿区", typeId : "10000100000000090000000000104794"},
                { name : "江津区", typeId : "10000100000000090000000000104783"},
                { name : "合川区", typeId : "10000100000000090000000000104788"},
                { name : "永川区", typeId : "10000100000000090000000000104795"},
                { name : "南川县", typeId : "10000100000000090000000000104780"},
                { name : "綦江区", typeId : "10000100000000090000000000104761"},
                { name : "大足区", typeId : "10000100000000090000000000104769"},
                { name : "潼南县", typeId : "10000100000000090000000000104764"},
                { name : "铜梁县", typeId : "10000100000000090000000000104765"},
                { name : "荣昌县", typeId : "10000100000000090000000000104776"},
                { name : "璧山县", typeId : "10000100000000090000000000104791"},
                { name : "梁平县", typeId : "10000100000000090000000000104784"},
                { name : "城口县", typeId : "10000100000000090000000000104790"},
                { name : "丰都县", typeId : "10000100000000090000000000104796"},
                { name : "垫江县", typeId : "10000100000000090000000000104777"},
                { name : "武隆县", typeId : "10000100000000090000000000104773"},
                { name : "忠县", typeId : "10000100000000090000000000104767"},
                { name : "开县", typeId : "10000100000000090000000000104762"},
                { name : "云阳县", typeId : "10000100000000090000000000104768"},
                { name : "奉节县", typeId : "10000100000000090000000000104779"},
                { name : "巫山县", typeId : "10000100000000090000000000104789"},
                { name : "巫溪县", typeId : "10000100000000090000000000104785"},
                { name : "石柱县", typeId : "10000100000000090000000000104792"},
                { name : "秀山县", typeId : "10000100000000090000000000104797"},
                { name : "酉阳县", typeId : "10000100000000090000000000104778"},
                { name : "彭水县", typeId : "10000100000000090000000000104771"}
                //{ name : "万盛区", typeId : "10000100000000090000000000104809"}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var pageSize = 9;
        function initializeData() {
            var html = "<div id='maskLeft'></div>";
            var xFocus = '<%= StringUtils.isEmpty(value) ? "" : value %>';
            var focusAll = xFocus == '' ? [] : xFocus.split(",");
            var items = focusable[1].items;
            blocked = xFocus == '' ? blocked : Number(focusAll[0]);
            focusable[0].focus = xFocus == '' ? 0 : Number(focusAll[1]);
            focusable[1].focus = xFocus == '' ? 0 : Number(focusAll[2]);
            for( var i = 0; i < items.length ; i++ ) {
                focusable[ i + 2 ] = {focus: xFocus == '' ? 0 : Number(focusAll[i + 3 ]),typeId: items[i].typeId , page: xFocus == '' ? 0 : Math.floor( Number(focusAll[i + 3]) * 1.0 / pageSize ) }
            }
            for( var i = 0; i < items.length ;i ++){
                var item = items[i];
                html += "<div id='qxLftItem" + i + "' class='qxItem qxItemNormal' style='left:" + ( 20 + Math.floor( i * 1.0 / 10) * 120 ) + "px;top:" +
                    ( 20 + i % 10 * 43 ) + "px'>" + item.name + "</div>";
            }
            $("flowedLeft").innerHTML = html;
        }
        function loadVodList(){
            var focus = focusable[1].focus;
            var typeId = focusable[1].items[focus].typeId;
            var page = focusable[focus + 2].page;

            $.ajax("interface.jsp?id=" + typeId + "&size=" + pageSize + "&max=<%=popItemMaxCharLength %>&tp=vod&page=" + page, function( rst ){
                focusable[focus + 2].length = rst.length;
                focusable[focus + 2].items = rst.items;

                if( focusable[focus + 2].name != rst.name )
                    focusable[focus + 2].name = rst.name;

                if( page == 0 ) {
                    for( var i = 0; i < 3; i ++ )
                        $("qxIconNew" + ( i + 1 ) ).style.visibility = rst.items.length > i ? 'visible' : 'hidden';
                } else {
                    $("qxIconNew1").style.visibility = 'hidden';
                    $("qxIconNew2").style.visibility = 'hidden';
                    $("qxIconNew3").style.visibility = 'hidden';
                }

                if( focusable[ focus + 2 ].length > pageSize ){
                    $("arrowUp").style.visibility = 'visible';
                    $("arrowDown").style.visibility = 'visible';
                    $("arrowUp").className = "absolute bigArrow qxArrow qxArrowUp " + ( page > 0 ? "bigArrowUpFocus" : "bigArrowUp" );
                    $("arrowDown").className = "absolute bigArrow qxArrow qxArrowDown  " + ( ( page + 1 ) * pageSize < focusable[ focus + 2 ].length ? "bigArrowDownFocus" : "bigArrowDown" );
                } else {
                    $("arrowUp").style.visibility = 'hidden';
                    $("arrowDown").style.visibility = 'hidden';
                }

                flowedShow( focus + 2 );
            });
        }
        function blocked1Focus(){
            var focus = focusable[1].focus;
            $("qxLftItem" + focus).className = 'qxItem qxItemFocus';
            $("maskLeft").className="absolute maskQxLft";
            $("maskLeft").style.left = ( 32 + Math.floor( focus * 1.0 / 10) * 120 ) + "px";
            $("maskLeft").style.top = ( 17 + focus % 10 * 43 ) + "px";
            loadVodList();
        }
        function focused(index,initilized){
            var previous = blocked, focus = focusable[blocked].focus;

            if(typeof index == "number" && !initilized){
                if( blocked == 0 || blocked == 1 && (index == -1 && focus < 10 || index == 11 && focus % 10 == 0 || index == -11 && ( focus % 10 == 9 || focus + 1 >= focusable[1].items.length ) ) ||
                    blocked > 1 && index == 1 ) return;
                if( blocked == 1 ) {
                    $("qxLftItem" + focus).className = 'qxItem qxItemNormal';
                    if( index == 1 ){
                        if( Math.floor( focus * 1.0 / 10 ) >= 3 ){ $("qxLftItem" + focus).className = 'qxItem qxItemFocus'; return; }
                        focus += 10;
                        if( focus >= focusable[ 1].items.length ) focus = focusable[ 1].items.length - 1;
                    } else if( index == -1 ) {
                        focus -= 10;
                    } else {
                        focus += index > 1 ?  -1 : 1;
                    }
                } else if ( blocked == 0 ) {

                } else if ( blocked > 1 ) {
                    if ( index == 11 || index == -11 ) {
                        focus += index > 0 ? -1 : 1;
                    } else if( index == -1 ) {
                        blocked = 1;
                        focus = focusable[blocked].focus;
                    }
                    if( Math.abs ( index ) != 1 && ( focus >= focusable[blocked].length || focus < 0 ) ) return;
                }
                focusable[blocked].focus = focus;
                if( blocked > 1 && blocked < focusable.length - 1 && ( index == -11 && focus % pageSize == 0 || index == 11 && focus % pageSize == pageSize - 1 ) ) {
                    focusable[blocked].page += index > 0 ? -1 : 1;
                    loadVodList();
                    return;
                }
            } else if( initilized ){
                initializeData();
                blocked1Focus();
                return;
            }
            if( previous > 1 && blocked <= 1 ) flowedShow ( previous );
            if( blocked == 1 ) { blocked1Focus(); return; }
            if( blocked >= 1 && blocked < focusable.length - 2 ) flowedShow( blocked );
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            var html = "<div class='item' style='height: 42px;'></div>";
            $("maskRight").style.visibility = blocked == index ? 'visible' : 'hidden';
            for(var i = 0; i < items.length; i += 1) {
                var item = items[i];
                html += "<div class='item'>";
                if(blocked == index && focus % pageSize == i ) {
                    $("maskRight").className = "absolute maskQxRight";
                    $("maskRight").style.top = ( 199 + focus %  pageSize * 43 ) +  "px";
                    $("maskRight").innerHTML = "<div class='txt'>" + ( item.length >= <%=popItemMaxCharLength%> ? ( "<marquee class='qxItemMarquee' scrollamount='5'>" + item.text + "</marquee>" ) : item.text) + "</div>";
                } else {
                    html += item.shortText;
                }
                html += "</div>";
            }
            $( 'flowedRight' ).innerHTML = html;
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
                var all = '';
                for ( var i = 0; i < focusable.length; i++)
                    all += "," + focusable[i].focus;
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + all +  "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                html += "<div id='flowedLeft' class='absolute qxLeft'></div>";
                html += "<div id='flowedRight' class='absolute qxRight'></div>";
                html += "<div class='absolute qxIcon txtIcon<%= idx %>'></div>";
                html += "<div class='absolute qxBar'></div>";
                html += "<div id='maskRight'></div>";
                html += "<div id='qxIconNew1' class='absolute qxIconNew qxIconNew1'></div>";
                html += "<div id='qxIconNew2' class='absolute qxIconNew qxIconNew2'></div>";
                html += "<div id='qxIconNew3' class='absolute qxIconNew qxIconNew3'></div>";
                html += "<div id='arrowUp'></div>";
                html += "<div id='arrowDown'></div>";
                document.body.innerHTML = html;
                $("qxIconNew1").style.visibility = 'hidden';
                $("qxIconNew2").style.visibility = 'hidden';
                $("qxIconNew3").style.visibility = 'hidden';
            }
            $.buildUserInterface();
            focusable.flowed = [];
            for( var i = 0; i < focusable.length - 1; i ++  ) focusable.flowed[i] = i + 1;
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
            if( blocked == 1 ) {
                blocked = focusable[1].focus + 2;
                flowedShow( blocked );
                return;
            }
            var item =  focusable[blocked].items[ focusable[blocked].focus % pageSize ];
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