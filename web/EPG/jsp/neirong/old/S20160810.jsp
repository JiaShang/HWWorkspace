<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //TODO:每次需要修改
    int focused = 0, area = 1;
    final int popItemMaxCharLength = 16;

    String backUrl = "";
    String fromEPG = "";
    String value = "";

    TurnPage turnPage = new TurnPage(request);

    //栏目顺序
    String currentPage = request.getParameter("page");
        if( StringUtils.isEmpty(currentPage) ) currentPage = "0";

    String typeId = "10000100000000090000000000106580";

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
    <title>视频列表</title>
    <style>
        .absolute { position:absolute;}
        .imageBg {background: transparent url('images/mask-2016-08-10.png') no-repeat 0px 0px;}
        .maskListTop {width:30px;height:80px;left:847px;top:581px;background-position: -300px 0px;}
        .ArrowUpFocus,.ArrowDownFocus {width:41px;height:27px;left:416px;top:72px; background-position:-300px -100px;}
        .ArrowUp,.ArrowDown{width:33px;height:18px;left:422px;top:78px; background-position:-300px -150px;}
        .ArrowDownFocus {top:663px; background-position:-300px -200px;}
        .ArrowDown{top:668px; background-position:-300px -250px;}
        .listContainer {width:800px;height:620px;left:50px;top:105px;}
        .listItemContainer {width:195px;height:288px;overflow:hidden;float: left;}
        .listItemImageBorder {width:179px;height:239px; margin:0px 0px 0px 8px;background-image:url('edu/v1/images/imgItemListItemBorder.png');}
        .listItemImageBorder img {width:177px;height:237px;margin:1px 0px 0px 1px;}
        .listItemContainer .txt {width:176px; margin:10px 0px 0px 12px; font-size:20px;line-height:20px;color:white; overflow: hidden;text-align: center;word-break: keep-all;white-space: nowrap;}
        .page {width:30px;height:30px; color:#ffffff;text-align: center;overflow: hidden;word-break: keep-all; font-size: 22px;}
        .listPageNum {left:847px; top:118px;}
        .listPageCount {left:847px; top:150px;}
        .maskListItem {width:277px;height:338px; background-position: 0px 0px}
    </style>
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
            {focus: 0, typeId:'', items:[]},
            {focus: 0, items:[{name:'回到顶部',style:'absolute imageBg maskListTop'}]}
        ];
        var backUrl = '<%= backUrl %>';
        var consign = undefined;                //用来缓存数据的
        var columns = 4; rows = 2;              //定义行列，　几行几列
        var page = <%= currentPage %>;          //当前页数
        var pageSize = columns * rows;
        function loadVodList(){
            $.ajax("edu/v1/interface.jsp?id=<%= typeId %>&list=1&size=" + pageSize + "&max=<%= popItemMaxCharLength%>&tp=vod&page=" + page, function( rst ){

                focusable[1].typeId = rst.typeId;
                focusable[1].length = rst.length;
                focusable[1].items = rst.items;

                if( focusable[1].length > pageSize ){
                    $("arrowUp").style.visibility = 'visible';
                    $("arrowDown").style.visibility = 'visible';
                    $("arrowUp").className = "absolute imageBg " + ( page > 0 ? "ArrowUpFocus" : "ArrowUp" );
                    $("arrowDown").className = "absolute imageBg " + ( ( page + 1 ) * pageSize < focusable[1].length ? "ArrowDownFocus" : "ArrowDown" );
                } else {
                    $("arrowUp").style.visibility = 'hidden';
                    $("arrowDown").style.visibility = 'hidden';
                }
                $("pageNum").innerHTML = page + 1;
                $("pageCount").innerHTML = Math.ceil(rst.length * 1.0 / pageSize);

                flowedShow( 1 );
            });
        }
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                if( blocked == 1 && ( focus % columns == 0 && index == -1 ||
                    index == 1 && focus % columns == columns - 1 && focusable[blocked].items.length > columns && focus < pageSize - 1 ||
                    index == 11 && focus < columns
                ) || blocked == focusable.length - 1 && index != -1) return;
                if( blocked == 1 ) {
                    if( index == -1 ) focus += index;
                    else if( index == 1 ) {
                        focus += 1;
                        if( focus % pageSize >= focusable[1].items.length || focus % pageSize == 0 && index == 1 ) { blocked = focusable.length - 1; focus = 0; }
                    } else focus += index > 0 ? -columns : columns;
                    if( index == -11 && focus >= focusable[1].length ) {
                        if( Math.floor( ( focus - columns ) * 1.0 / columns ) == Math.floor( ( focusable[1].length - 1 ) * 1.0 / columns ) || focus >= focusable[1].length + columns ) return;
                        focus = focusable[1].length - 1;
                    } else if( index == 11 && focus < 0 )
                        return;
                } else {
                    blocked = 1;
                    focus = focusable[blocked].focus;
                }
                focusable[blocked].focus = focus;

                if( blocked == 1 && ( index == -11 && focus >= ( page + 1 ) * pageSize || index == 11 && focus < page * pageSize ) ) {
                    page += index > 0 ? -1 : 1;
                    loadVodList();
                    return;
                }
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
                loadVodList();
                return;
            }

            if( blocked == focusable.length - 1 ) {
                var item =  focusable[blocked].items[focus];
                if(typeof item != 'undefined' && typeof item.style == 'string' )
                    $("mask").className = item.style;

                $("mask").style.visibility = 'visible';
            } else {
                $("mask").style.visibility = 'hidden';
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
                html += "<div class='listItemContainer'><div class='listItemImageBorder'><img src='" + item.picture + "' /></div>";
                html += "<div class='txt'>" + ( blocked == index && focus % pageSize == i && item.length >= <%= popItemMaxCharLength %> ? ( "<marquee class='listItemMarquee' scrollamount='5'>" + item.text + "</marquee>" ) : item.shortText  ) + "</div>";
                html += "</div>";
                if( focus % pageSize == i ) {
                    $("maskList").className = "absolute imageBg maskListItem";
                    $("maskList").style.top = ( 65 + Math.floor( focus % pageSize * 1.0 / columns ) * 288 ) +  "px";
                    $("maskList").style.left = ( 13 + focus % columns * 195 ) +  "px";
                }
            }
            $("maskList").style.visibility = blocked == 1 ? 'visible' : 'hidden';
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
                        case "KEY_BACK":goBack(true);break;
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
                    html += "<div id='flowed' class='absolute listContainer'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div id='maskList'></div>";
                html += "<div id='mask'></div>";
                html += "<div id='arrowUp'></div>";
                html += "<div id='arrowDown'></div>";
                html += "<div id='pageNum' class='absolute page listPageNum'></div>";
                html += "<div id='pageCount' class='absolute page listPageCount'></div>";
                document.body.innerHTML = html;
            }
            $.buildUserInterface({flowed:[1]});
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            top.window.location.href = typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            if( blocked == focusable.length - 1 ) {
                focusable[1].focus = 0;
                if( page != 0 ){
                    page = 0;
                    blocked = 1;
                    loadVodList();
                } else {
                    blocked = 1;
                    flowedShow( blocked );
                }
                $("mask").style.visibility = 'hidden';
                return;
            }
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/bg-2016-08-10.jpg') no-repeat left top;" onUnload="exit();"></body>
</html>