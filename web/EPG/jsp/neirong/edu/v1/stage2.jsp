<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //TODO:每次需要修改
    int focused = 0, area = 1;
    final int popItemMaxCharLength = 26;

    String backUrl = "";
    String fromEPG = "";
    String value = "";

    TurnPage turnPage = new TurnPage(request);

    String idx = request.getParameter("idx");


    //党教栏目ID
    final String eduTypeId = "10000100000000090000000000106149";
    //本周排行的栏目ID
    final String weekTypeId = "10000100000000090000000000106206";
    //精品推荐的栏目ID
    String typeId = request.getParameter("typeId");

    //精品推荐的栏目名称和图片
    String recName = "";String recPicture = "images/defaultImgJDLft.jpg";
    List<Column> list = new ArrayList<Column>();
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
        }

        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        //取本周排行的图片及名称
        Column column = getDetailInfo( metaHelper, weekTypeId, new Column());
        if( column != null ) {
            recName = column.getName();
            recPicture = Utils.pictureUrl(recPicture, column.getPosters(), "0", request);
        }
        list = getTypeList( metaHelper, typeId, 99, 0 );
        if( list == null || list.size() == 0 ) list = null;
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>精品推荐</title>
    <link type="text/css" rel="stylesheet" href="css/edu.css"/>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;

        <%
            if( list != null ) {
                value = "";
                for (Column column : list ) {
                    value += ",{ ";
                    try {
                        value += "id:\"" + column.getId() + "\"," +
                            "text:\"" + column.getName() + "\"," +
                          "length:" + StringUtil.length(column.getName()) + "," +
                       "shortText:\"" + StringUtil.limitStringLength(column.getName(), popItemMaxCharLength) + "\"" + "," +
                         "picture:'" + Utils.pictureUrl("", column.getPosters(), "0", request)+ "'";
                    } catch ( Throwable e ) {}
                    value += "}";
                }
                value = "var data = [" + value.substring(1) + "];";
            }
        %>
        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            {focus: 0, items:[]},
            { focus:0, vote:true, items : [
                {name:'本周排行',typeId:'<%= weekTypeId%>',style:'absolute maskJdLft',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column2x.jsp?typeId=<%= weekTypeId %>&idx=12',picture:'<%= recPicture%>', text:'<%= recName%>', length:<%= StringUtil.length(recName) %>, shortText:'<%= StringUtil.limitStringLength( recName, 20 )%>' },
                {name:'老马大图',typeId:'10000100000000090000000000106166',style:'absolute maskJdLarge',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106152&subTypeId=10000100000000090000000000106166&idx=3'},
                {name:'党建要闻',typeId:'10000100000000090000000000106169',style:'absolute maskIxIcon maskJdIcon1',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106152&subTypeId=10000100000000090000000000106169&idx=3'},
                {name:'共产党员',typeId:'10000100000000090000000000106168',style:'absolute maskIxIcon maskJdIcon2',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106152&subTypeId=10000100000000090000000000106168&idx=3'},
                {name:'红岩本色',typeId:'10000100000000090000000000106170',style:'absolute maskIxIcon maskJdIcon3',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106152&subTypeId=10000100000000090000000000106170&idx=3'},
                {name:'右上图',typeId:'10000100000000090000000000106165',style:'absolute maskJdRt maskJdRtTop',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106152&subTypeId=10000100000000090000000000106165&idx=3'},
                {name:'右下图',typeId:'10000100000000090000000000106167',style:'absolute maskJdRt maskJdRtBottom',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106152&subTypeId=10000100000000090000000000106167&idx=3'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        <%= value %>
        function initializeData(){
            $("jdLftImg").src = focusable[1].items[0].picture;
            $("txtStage0").innerHTML = focusable[1].items[0].shortText;
            for( var i = 1; i < focusable[1].items.length; i++ ) {
                var prop = {};
                var item = focusable[1].items[i];
                for( var o = 0; o < data.length; o++){
                    if( data[o].id != item.typeId ) continue;
                    prop = data[o];
                    break;
                }

                focusable[1].items[i].text = prop.text;
                focusable[1].items[i].length = prop.length;
                focusable[1].items[i].shortText = prop.shortText;

                if( item.typeId == '10000100000000090000000000106166' ) {
                    focusable[1].items[i].picture = ( typeof prop.picture == 'undefined' || prop.picture == '' ) ? 'images/defaultImgJDTop.jpg' : prop.picture;
                    $("jdLargeTopImg").src = focusable[1].items[i].picture;
                } else if ( item.typeId == '10000100000000090000000000106165' || item.typeId == '10000100000000090000000000106167' ) {
                    focusable[1].items[i].picture = ( typeof prop.picture == 'undefined' || prop.picture == '' ) ? 'images/defaultImgJDRt.jpg' : prop.picture;
                    if( item.typeId == '10000100000000090000000000106165' ) //左上图
                    {
                        $("jdRtTopImg").src = focusable[1].items[i].picture;
                        $("txtStage5").innerHTML = focusable[1].items[i].shortText;
                    } else {
                        $("jdRtBottomImg").src = focusable[1].items[i].picture;
                        $("txtStage6").innerHTML = focusable[1].items[i].shortText;
                    }
                }
            }
        }
        function focused(index,initilized){
            var focus = focusable[blocked].focus;
            var previousFocus = focus, previousBlocked = blocked;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
               //上:11,下:-11,左-1,右1
                if( blocked == 0 ||
                   blocked == 1 && ( focus == 0 && index != 1 || ( focus == 1 || focus == 5 ) && index == 11 || ( focus >= 2 && focus <= 4 || focus == 6 ) && index == -11 || focus > 4 && index == 1 )
                ) return;
                if( blocked == 0 ){

                } else if( blocked == 1 ){
                    if( index == 1 ) {
                        if( focus == 0 ) focus = 1;
                        else if( focus == 1 ) focus = 5;
                        else if( focus == 4 ) focus = 6;
                        else focus += 1;
                    } else if( index == -1 ) {
                        if( focus == 5 ) focus = 1;
                        else if( focus == 6 ) focus = 4;
                        else if( focus == 1 || focus == 2 ) focus = 0;
                        else focus -= 1;
                    } else if( index == -11 ) {
                        if( focus == 1 ) focus = 2;
                        else focus = 6;
                    } else {
                        if( focus == 6 ) focus = 5;
                        else focus = 1;
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
            }


            item =  focusable[blocked].items[focus];
            if( previousBlocked == 1 ) {
                if (( previousFocus == 0 || previousFocus == 5 || previousFocus == 6 ) && focusable[1].items[previousFocus].length >= <%= popItemMaxCharLength %>) {
                    $("txtStage" + previousFocus).innerHTML = focusable[1].items[previousFocus].shortText;
                } else if( ( focus == 0 || focus == 5 || focus == 6 ) && item.length >= <%= popItemMaxCharLength %> ) {
                    $("txtStage" + focus).innerHTML = "<marquee class='txtStageMarquee' scrollamount='5'>" + item.text + "</marquee>";
                }
            }
            $("mask").className = item.style;
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
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                html += "<div class='absolute txtIcon txtIcon<%= idx %>'></div>";
                html += "<div class='absolute spBar'></div>";
                html += "<div class='absolute jdLeftBorder'><img id='jdLftImg' /><div id='txtStage0' class='text'></div></div>";
                html += "<div class='absolute jdLargeTopBorder'><img id='jdLargeTopImg' /></div>";
                html += "<div id='jdIcon1' class='absolute ixIcon jdIcon1'></div>";
                html += "<div id='jdIcon2' class='absolute ixIcon jdIcon2'></div>";
                html += "<div id='jdIcon3' class='absolute ixIcon jdIcon3'></div>";
                html += "<div id='jdRtTop' class='absolute jdRtBorder jdRtTop'><img id='jdRtTopImg' /><div id='txtStage5' class='text'></div></div>";
                html += "<div id='jdRtBottom' class='absolute jdRtBorder jdRtBottom'><img id='jdRtBottomImg' /><div id='txtStage6' class='text'></div></div>";
                html += "<div id='mask'></div>";
                document.body.innerHTML = html;
                if( focusable[0].flowed ) $("mask").style.visibility = "hidden";
            }
            $.buildUserInterface();
            initializeData();
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
            var item =  focusable[blocked].items[focusable[blocked].focus];
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