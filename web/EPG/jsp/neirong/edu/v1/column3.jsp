<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //TODO:每次需要修改
    int focused = 0, area = 1;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";

    TurnPage turnPage = new TurnPage(request);

    String idx = request.getParameter("idx");
    String typeId = request.getParameter("typeId");
    String subTypeId = request.getParameter("subTypeId");
    List<Column> list = null;
    // 返回时获取焦点信息数据
    String[] focus = null;
    int blocked1Focus = 0;

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

        MetaData metaHelper = new MetaData(request);
        list = getTypeList( metaHelper, typeId, 100, 0 );
        for( int i = 0; !StringUtils.isEmpty( subTypeId )  && list != null && i < list.size(); i ++ ){
            Column column = list.get( i );
            if( ! column.getId().equalsIgnoreCase( subTypeId ) ) continue;
            blocked1Focus = i;
            break;
        }

    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>三列列表页面</title>
    <link type="text/css" rel="stylesheet" href="css/edu.css"/>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;
        //所有焦点
        var xFocus = '<%= StringUtils.isEmpty(value) ? "" : value %>';
        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            {focus: 0, items:[]},
            {focus: 0, items:[
            <%
                value = "";
                String str = "";
                try {
                    if( list != null && list.size() > 0 ) {
                        for( int i = 0; i < list.size(); i++ ) {
                            Column column = list.get(i);
                            column.setName(column.getName() );
                            str += "{ id:'" + column.getId() + "'," +
                                    "text:\"" + column.getName() + "\"," +
                                  "length:" + StringUtil.length(column.getName()) + "," +
                               "shortText:\"" + StringUtil.limitStringLength(column.getName(), 21) + "\"";
                            str += "}" ;
                            str += ( i + 1 < list.size()  ? "," : "");
                          value += ",{focus:0, page:0, typeId:'" + column.getId() + "',picture:'" + Utils.pictureUrl("images/defaultImgColumn3.png", column.getPosters(), "5", request) + "',items:[]}";
                        }
                    }
                } catch ( Exception ex) {}
                out.println( str );
            %>
            ]}
            <%= value %>,
            {focus: 0, items:[{name:'回到顶部',style:'absolute maskColumn3Top'}]}
        ];
        var backUrl = '<%= backUrl %>';
        var pageSize = 10;
        function initializeData(){
            var focusAll = xFocus == '' ? [] : xFocus.split(",");
            var items = focusable[1].items;
            blocked = xFocus == '' ? blocked : Number(focusAll[0]);
            focusable[0].focus = xFocus == '' ? 0 : Number(focusAll[1]);
            focusable[1].focus = xFocus == '' ? <%= blocked1Focus %> : Number(focusAll[2]);
            for( var i = 0; i < items.length ; i++ ) {
                focusable[ i + 2].focus = xFocus == '' ? 0 : Number(focusAll[i + 3 ]);
                focusable[ i + 2].page = xFocus == '' ? 0 : Math.floor( Number(focusAll[i + 3]) * 1.0 / pageSize )
            }
        }
        function loadVodList(){
            var focus = focusable[1].focus;
            var typeId = focusable[focus + 2].typeId;
            var page = focusable[focus + 2].page;
            $.ajax("interface.jsp?id=" + typeId + "&pic=1&col=3&size=" + pageSize + "&max=<%=popItemMaxCharLength%>&tp=vod&page=" + page, function( rst ){
                focusable[focus + 2].length = rst.length;
                focusable[focus + 2].items = rst.items;

                if( focusable[focus + 2].picture != rst.picture ) {
                    focusable[focus + 2].picture = rst.picture;
                }
                if( focusable[focus + 2].name != rst.name ) {
                    focusable[focus + 2].name = rst.name;
                }
                $("column3RtImg").src = rst.picture;
                $("column3RtTxt").innerHTML = rst.name;

                if( focusable[ focus + 2 ].length > pageSize ){
                    $("arrowUp").style.visibility = 'visible';
                    $("arrowDown").style.visibility = 'visible';
                    $("arrowUp").className = "absolute " + ( page > 0 ? "column3ArrowUpFocus" : "column3ArrowUp" );
                    $("arrowDown").className = "absolute " + ( ( page + 1 ) * pageSize < focusable[ focus + 2 ].length ? "column3ArrowDownFocus" : "column3ArrowDown" );
                } else {
                    $("arrowUp").style.visibility = 'hidden';
                    $("arrowDown").style.visibility = 'hidden';
                }
                $("pageNum").innerHTML = page + 1;
                $("pageCount").innerHTML = Math.ceil(rst.length * 1.0 / pageSize);
                flowedShow( focus + 2 );
            });
        }
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = blocked;

            if(typeof index == "number" && !initilized){
                if( blocked == 1 && index == -1 || blocked == focusable.length - 1 && index != -1) return;
                if( blocked == 1 ) {
                    if( index == 1 ) {
                        blocked = focus + 2;
                        focus = focusable[blocked].focus;
                    } else
                        focus += index > 0 ? -1 : 1;
                    if( index != 1 && ( focus >= focusable[1].items.length || focus < 0 ) ) return;
                } else if( blocked > 1 && blocked < focusable.length - 1 ) {
                    if ( index == 11 || index == -11 ) {
                        focus += index > 0 ? -1 : 1;
                    } else {
                        if( index == 1 ){
                            focusable[focusable.length - 1].returnVal = blocked;
                            blocked = focusable.length - 1 ;
                        } else
                            blocked = 1;
                        focus = focusable[blocked].focus;
                    }
                    if( Math.abs ( index ) != 1 && ( focus >= focusable[blocked].length || focus < 0 ) ) return;
                } else if( blocked == focusable.length - 1 ){
                    blocked = focusable[focusable.length - 1].returnVal;
                    focus = focusable[blocked].focus;
                }
                focusable[blocked].focus = focus;

                if( ( blocked == 0 || blocked == 1 || blocked == focusable.length - 1 ) && ( previous != 0 && previous != 1 && previous != focusable.length - 1 ) )
                {
                    flowedShow( previous );
                    $("maskMiddle").style.visibility = 'hidden';
                }

                if( blocked > 1 && blocked < focusable.length - 1 && ( index == -11 && focus % pageSize == 0 || index == 11 && focus % pageSize == pageSize - 1 ) ) {
                    focusable[blocked].page += index > 0 ? -1 : 1;
                    loadVodList();
                    return;
                }

            } else if( initilized ){
                initializeData();
                flowedShow( 1 );
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

            if( blocked >= 1 && blocked < focusable.length - 1 ) flowedShow( blocked );
        }

        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            if( index == 1 && blocked == 1 ) {
                loadVodList();
            }
            var html = '';
            var start = index == 1 ? Math.floor ( focus * 1.0 / pageSize ) * pageSize : 0;
            for(var i = 0; i < pageSize && start + i < items.length ; i += 1) {
                var item = items[start + i];
                html += "<div class='item'>";
                if( index != 1) html += "<div class='icon'></div>";
                if( ( index == 1 || blocked == index  ) && focus % pageSize == i ) {
                    html += "<div class='txt'></div>";
                    $(index == 1 ? "maskLeft" : "maskMiddle").className = "absolute " + ( index == 1 ? "column3LftFocusItem" : "column3MidFocusItem");
                    $(index == 1 ? "maskLeft" : "maskMiddle").style.top = ( 131 + focus %  pageSize * 51 ) +  "px";
                    $(index == 1 ? "maskLeft" : "maskMiddle").innerHTML = ( index == 1 ? "" : "<div class='icon'></div>") + "<div class='txt'>" + ( item.length >= ( index != 1 ? <%=popItemMaxCharLength%> : 21 ) ? ( "<marquee class='" + ( index != 1 ? "column3ItemMarquee" : "column3LeftItemMarquee") +  "' scrollamount='5'>" + item.text + "</marquee>" ) : item.text) + "</div>";
                } else {
                    html += "<div class='txt'>" + item.shortText + "</div>";
                }
                html += "</div>";
            }
            $( index == 1 ? "flowedLeft" : "flowedMiddle").innerHTML = html;
            if(blocked == index && index != 1 ) $("maskMiddle").style.visibility = 'visible';
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
                html += "<div id='flowedLeft' class='absolute column3Left'></div>";
                html += "<div id='flowedMiddle' class='absolute column3Middle'></div>";
                html += "<div class='absolute txtIcon txtIcon<%= idx %>'></div>";
                html += "<div class='absolute spBar'></div>";
                html += "<div id='maskLeft'></div>";
                html += "<div id='maskMiddle'></div>";
                html += "<div id='arrowUp'></div>";
                html += "<div id='arrowDown'></div>";
                html += "<div class='absolute column3Page'><div id='column3PageCurrent' class='txt'></div><div id='column3PageCount' class='txt'></div></div>";
                html += "<div id='pageNum' class='absolute page column3PageNum'></div>";
                html += "<div id='pageCount' class='absolute page column3PageCount'></div>";
                html += "<div id='mask'></div>";
                html += "<div class='absolute column3RtBorder'><img id='column3RtImg' /><div id='column3RtTxt' class='text'></div></div>";
                document.body.innerHTML = html;
            }
            $.buildUserInterface({flowed:[1]});
            focusable.flowed = [];
            for( var i = 0; i < focusable.length - 2; i ++  ) focusable.flowed[i] = i + 1;
            focused(0 , true);
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
            if( blocked == 1 ) return;
            if( blocked == focusable.length - 1 ){
                var currentBlocked = focusable[1].focus + 2;
                focusable[currentBlocked].focus = 0;
                if( focusable[currentBlocked].page != 0 ){
                    focusable[currentBlocked].page = 0;
                    blocked = currentBlocked;
                    loadVodList();
                } else {
                    blocked = currentBlocked;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/background.jpg') no-repeat left top;" onUnload="exit();"></body>
</html>