<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000108352"};
    final int[] position = {10,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    // 返回时获取焦点信息数据
    String[] focus = null;

    List<List<Vod>> list = null;
    Column column = new Column();

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");
        isKorean = StringUtils.isEmpty(request.getParameter("isKorean"))? isKorean : request.getParameter("isKorean");

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
        column = getDetailInfo( metaHelper, types[0], column );

        list = new ArrayList<List<Vod>>();
        int i = 0;
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type,position[i], position[i+1]);
            list.add( ls );
            i+=2;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2017-09-11.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:130px;height:74px;left:183px;top:135px;background-position: 0px 0px;}
        .mask2 {width:167px;height:23px;left:481px;top:161px;background-position: -150px 0px;}
        .mask3 {width:172px;height:49px;left:679px;top:54px;background-position: -330px 0px;}
        .mask4 {width:151px;height:74px;left:856px;top:135px;background-position: 0px -80px;}
        .mask5 {width:152px;height:49px;left:986px;top:274px;background-position: -150px -30px;}
        .mask6 {width:151px;height:49px;left:151px;top:345px;background-position: -150px -80px;}
        .mask7 {width:109px;height:49px;left:271px;top:479px;background-position: -330px -50px;}
        .mask8 {width:161px;height:49px;left:465px;top:554px;background-position: -330px -100px;}
        .mask9 {width:130px;height:49px;left:649px;top:542px;background-position: 0px -160px;}
        .mask10 {width:172px;height:49px;left:870px;top:581px;background-position: -150px -130px;}

        .ans {width:49px;height: 49px;}
        .ansTrue {background-position: -330px -150px;}
        .ansFalse {background-position: -400px -150px;}
        .ans10{left:178px;top:210px;}
        .ans11{left:230px;top:210px;}

        .ans20{left:516px;top:190px;}
        .ans21{left:568px;top:190px;}

        .ans30{left:718px;top:115px;}
        .ans31{left:770px;top:115px;}

        .ans40{left:878px;top:217px;}
        .ans41{left:930px;top:217px;}

        .ans50{left:1049px;top:327px;}
        .ans51{left:1101px;top:327px;}

        .ans60{left:157px;top:412px;}
        .ans61{left:209px;top:412px;}

        .ans70{left:310px;top:540px;}
        .ans71{left:362px;top:540px;}

        .ans80{left:514px;top:612px;}
        .ans81{left:566px;top:612px;}

        .ans90{left:682px;top:612px;}
        .ans91{left:734px;top:612px;}

        .ans100{left:904px;top:641px;}
        .ans101{left:956px;top:641px;}

        .rule {width:164px;height:49px;left:75px;top:592px;background-position: -469px -150px;}
        .answer {width:633px;height:363px;left:363px;top:189px;}
        .allRight {background-position: 0px -210px;}
        .allError {background-position: 0px -580px;}
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
            <%
            value = "";
            final int[] answers = {1,1,0,1,1,0,0,1,1,0};
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:" + (focus == null || focus.length < 2 ? 0 : focus[1]) + ",selected:" + (focus == null || focus.length < 4 || focus[3].equals("") ? 0 : focus[3] ) +  ",typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                                 "style:'mask mask" + (j + 1) + "'" + "," +
                                 "anwser:" + answers[j] + "," +
                                 "selected:" + (focus == null || focus.length < j * 2 + 5 || focus[j * 2 + 4].equals("") ? "undefined" : "1") + "," +
                                 "value:" + (focus == null || focus.length < j * 2 + 6 || focus[j * 2 + 4].equals("") || focus[j * 2 + 5].equals("") ? -1 : focus[j * 2 + 5]) + "," +
                                "playType:" + vod.getIsSitcom() ;
                            str += "}" ;
                            str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]},";
                }
                out.write(value);
            }
            %>
            { focus:0, items : [
                {name:'rule',style:"mask rule",playType:-3,link:'/EPG/jsp/neirong/S20170911Rule.jsp'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 0; rows = 0;              //定义行列，　几行几列
        var pageCount = columns * rows;
        var answerFocused = <%= (focus == null || focus.length < 3 || focus[2].equals("0") ? "false" : "true")%>,showPop = false;
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                //如果焦点在投票上,按上下左右键时
                if( blocked == 0 && !answerFocused && (index == 11 && focus <=3 || index == -1 && (focus == 0 || focus == 5 ) || index == 1 && (focus == 4 || focus +1 >= focusable[0].items.length)) || answerFocused && index == -11 && focus >= 6  ||
                    blocked == 1 && (showPop || index == -11 || index == -1 )) return;
                if( blocked == 0 ) {
                    previous = focus;
                    if( index == 1 || index == -1) {
                        if( index == -1 && focus == 6 && ( focusable[0].items[focus].selected || answerFocused && focusable[0].items[focus].value != 0  ) ) {
                            blocked = 1;focus = 0;
                        } else if( answerFocused && (focusable[0].items[focus].selected && ( index == -1 && ( focus == 0 || focus == 5) || index == 1 && (focus == 4 || focus + 1 >= focusable[0].items.length )) || index == -1 && ( focus == 0 || focus == 5 ) && focusable[0].items[focus].value != 0 || index == 1 && ( focus == 4 || focus + 1 >= focusable[0].items.length ) && focusable[0].items[focus].value == 0)){
                            return;
                        } else if( answerFocused && !focusable[0].items[focus].selected && ( index == 1 && focusable[0].items[focus].value != 0 || index == -1 && focusable[0].items[focus].value == 0 ) ) {
                            focusable[0].items[focus].value = index == 1 && focusable[0].items[focus].value != 0 ? 0 : 1;
                        } else {
                            var tmp = focus + index;
                            if( answerFocused && focusable[0].items[tmp].selected ){
                                answerFocused = false;
                            }
                            focus += index;
                        }
                    } else if( index == 11 ) {
                        if( answerFocused ) {
                            answerFocused = false;
                        } else {
                            if( focus == 4 ) focus = 3;
                            else if(focus == 9 ) focus = 4;
                            else if( focus == 5 ) focus = 0;
                            else if( focus == 6 ) focus = 5;
                            else focus -= 6;
                            if( focus < 0 ) return;
                            if( focusable[0].items[focus].selected ) {
                                answerFocused = false;
                            } else {
                                answerFocused = true;
                                if( focusable[0].items[focus].value == -1 ) focusable[0].items[focus].value = 1;
                            }
                        }
                    } else {
                        if( focus == 5 && (answerFocused && !focusable[0].items[focus].selected || focusable[0].items[focus].selected)) {
                            blocked = 1;focus = 0;
                        } else if( 1 == focusable[0].items[focus].selected || answerFocused ){
                            answerFocused = false;
                            if( focus == 0 ) focus = 5;
                            else if( focus == 5 ) focus = 6;
                            else if( focus == 4 ) focus = focusable[blocked].items.length -1;
                            else focus += 6;
                            if( focus >= focusable[0].items.length ) return;
                        } else {
                            if( focusable[0].items[focus].selected ) {
                                answerFocused = false;
                            } else {
                                answerFocused = true;
                                if( focusable[0].items[focus].value == -1 ) focusable[0].items[focus].value = 1;
                            }
                        }
                    }
                } else {
                    blocked = 0; focus = index == 11 ? 5 : 6;
                    if( focusable[0].items[focus].selected ) answerFocused = false;
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
                for( var i = 0; i < focusable[0].items.length ; i ++ )
                    $("answer" + (i + 1)).className =  focusable[0].items[i].value == -1 ? "" : ( "mask ans ans" + ( i + 1 ) + (focusable[0].items[i].value == 0 ? "1 ansFalse" : "0 ansTrue"));
            }

            item =  focusable[blocked].items[focus];
            if( previous != focus && !focusable[0].items[previous].selected )
                $("answer" + (previous + 1)).style.visibility = 'hidden';

            if(blocked == 0 && answerFocused){
                $("mask").style.visibility =  "hidden";
                $("answer" + (focusable[0].focus + 1)).style.visibility = 'visible';
                $("answer" + (focusable[0].focus + 1)).className = "mask ans ans" + (focus + 1) + (item.value != 0 ? "0 ansTrue" : "1 ansFalse" );
            } else {
                $("answer" + (focusable[0].focus + 1)).style.visibility = focusable[0].items[focusable[0].focus].selected ? 'visible' : 'hidden';
                $("mask").style.visibility =  "visible";
                $("mask").className = item.style;
            }
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            //每页显示数量
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                //if( i == focus && blocked == index ) 焦点
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
                        case 13:doEnter(); break;              //选择回车键
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
                                try {
                                    callback( (new Function("return " + responseText))() );
                                } catch ( e ) {
                                    callback( eval("(" + request.responseText + ")" ) );
                                }
                            }
                            else{request.abort();}
                        }
                    }
                    request.open(options.method, url, options.async);
                    request.send(null);
                };
            }
            $.current = function (){
                var para = blocked + "," + focusable[0].focus + "," + ( answerFocused ? 1 : 0 ) + "," + (typeof focusable[0].selected == undefined ? "" : focusable[0].selected);
                for( var i = 0; i < focusable[0].items.length; i ++ )
                    para += focusable[0].items[i].selected  ?  ",1," + focusable[0].items[i].value : ",,";
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + para + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div id='mask'></div>";
                if(typeof option.external.after == 'string' ) html += option.external.after;

                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; $.video.play();}
                for( var i = 0; i < focusable[0].items.length ; i++ ) {
                    html += "<div id='answer" + ( i + 1 ) + "'></div>";
                }
                html += '<div id="after"></div>';
                document.body.innerHTML = html;

                if( focusable[0].flowed ) $("mask").style.visibility = "hidden";
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
            $.buildUserInterface({flowed:undefined,vote:undefined,video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //
            focused(blocked == 1 ? 0 : focusable[0].focus, true);
        }
        function goBack(keyBack){
            if( showPop ) {
                cleanSelected();
                return;
            }
            if(typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function cleanSelected(){
            focusable[0].selected = 0;
            focusable[0].allRight = undefined;
            for( var i = 0; i < focusable[0].items.length ;i ++ ){
                $("answer" + (i + 1)).style.visibility = 'hidden';
                focusable[0].items[i].value = -1;
                focusable[0].items[i].selected = undefined;
            }
            $("after").style.visibility = "hidden";
            blocked = 0;answerFocused = false;showPop = false;
            focusable[0].focus = 0;
            focused(0, true);
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            if( blocked == 0 && ( showPop || answerFocused )) {
                if( showPop ) { //如果显示错误弹窗
                    if( !focusable[0].allRight ) //没有全选正确的情况下按确定则返回
                        cleanSelected();
                    else { //全选正确的情况下按确定则跳转
                        top.window.location.href = "http://192.168.33.75/TGO/redwas.html?backURL=" + encodeURIComponent("<%= request.getRequestURL().toString() %>");;
                    }
                } else if( answerFocused ) {
                    focusable[0].items[focusable[0].focus].selected = 1;
                    focusable[0].selected += 1;
                    focusable[0].items[focusable[0].focus].value = $("answer" + ( focusable[0].focus + 1)).className.indexOf("True") > 0 ? 1 : 0;
                    if ( focusable[0].selected < 10 ) return;
                    var allRignt = true;
                    for( var i = 0; i < focusable[0].items.length ;i ++ )
                        allRignt =  allRignt && focusable[0].items[i].value == focusable[0].items[i].anwser;
                    showPop = true;
                    focusable[0].allRight = allRignt;
                    $("after").style.visibility = "visible";
                    $("after").className = "mask answer " + ( allRignt ? "allRight" : "allError");
                }
                return;
            }
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if(typeof item == 'undefined' || item.playType == 'undefined') return;
            var typeId = focusable[blocked].typeId;
            switch(item.playType){
                case -1:
                    focusable[item.blocked].backed = blocked;
                    blocked = item.blocked;
                    focused(focusable[blocked].focus, true);
                    break;
                case -2:
                    focused(0, true);
                    break;
                case -3:
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else if( item.link.indexOf("wasu.cn/") > 0 ) {
                        //curr_url = "ui://portal1.htm?" + curr_url;
                        url = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        var requestUrl = "<%= request.getRequestURL().toString() %>";
                        var queryStr = "<%= request.getQueryString() %>";
                        if( queryStr == 'null' ) queryStr = '';
                        var focusStr = blocked + "," + focusable[blocked].focus;
                        if( ! queryStr.isEmpty() ) {
                            requestUrl += "?" + ( queryStr.indexOf( 'currFoucs=' ) < 0 ? ( queryStr + "&currFoucs=" + focusStr ) : queryStr.replace('currFoucs=' + getUrlParameters("currFoucs", queryStr), 'currFoucs=' + focusStr) );
                        } else {
                            requestUrl += '?currFoucs=' + focusStr;
                        }
                        url += encodeURIComponent(requestUrl);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d'/*'western/eu_tvD'*/) + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
                case "VOD_PREPAREPLAY_SUCCESS":media.AV.play();break;
                case "EIS_VOD_PROGRAM_END":$.video.play();break;
            }
            return 	eventObj.args.type;
        }
        function getUrlParameters(str, link) {
            var rs = new RegExp("(\\?|&)?" + str + "=([^&]*?)(&|$)", "gi").exec(link);
            if (typeof rs === 'undefined' || rs === null ) return "";
            return rs[2];
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-09-11.jpg') no-repeat;" onUnload="exit();"></body>
</html>