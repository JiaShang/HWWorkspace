<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="../../util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 26;

    String backUrl = "";
    String fromEPG = "";
    String value = "";

    TurnPage turnPage = new TurnPage(request);

    Vod vod = new Vod();

    String scrollText = "";
    String defaultText = "暂无数据";

    String ztName = defaultText,ztPicture = "",recName = defaultText, recPicture = "";

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
        //专题ID
        //
        String eduTypeId = "10000100000000090000000000106149";
        String ztTypeId = "10000100000000090000000000107182";
        String recTypeId = "10000100000000090000000000106150";
        //10000100000000090000000000106151
        //取专题的图片及名称
        Column column = getDetailInfo(metaHelper, ztTypeId, new Column() );
        if( column != null ) {
            ztName = column.getName();
            ztPicture = Utils.pictureUrl("", column.getPosters(), "0", request);
        }

        column = getDetailInfo(metaHelper, recTypeId, new Column() );
        if( column != null ) {
            recName = column.getName();
            recPicture = Utils.pictureUrl("", column.getPosters(), "0", request);
        }

        column = getDetailInfo( metaHelper , eduTypeId, new Column() );
        if( column != null ) scrollText = column.getIntroduce();

        if( StringUtils.isEmpty( scrollText )) scrollText =  "党教游走字幕，通过党教栏目的第一语言描述设置。";
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>党教首页</title>
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
            {
                focus: 0, items:[
                //{name:'学系列讲话',text:'<%= ztName %>',length:<%= StringUtil.length(ztName) %> , shortText:'<%= StringUtil.limitStringLength(ztName, popItemMaxCharLength) %>',style:'absolute maskIxLft maskIxLftTop',playType:-3, link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000107182&idx=14'},
                //{name:'两学一做',text:'<%= recName %>',length:<%= StringUtil.length(recName) %> , shortText:'<%= StringUtil.limitStringLength(recName, popItemMaxCharLength) %>',style:'absolute maskIxLft maskIxLftBottom',playType:-3, link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106150&idx=13'}
                {name:'新征程 中国共产党第十九次全国代表大会',text:'<%= ztName %>',length:<%= StringUtil.length(ztName) %> , shortText:'<%= StringUtil.limitStringLength(ztName, popItemMaxCharLength) %>',style:'absolute maskIxLft maskIxLftTop',playType:-3, link:'/EPG/jsp/neirong/S20170922.jsp'},
                {name:'两学一做常态化制度化',text:'<%= recName %>',length:<%= StringUtil.length(recName) %> , shortText:'<%= StringUtil.limitStringLength(recName, popItemMaxCharLength) %>',style:'absolute maskIxLft maskIxLftBottom',playType:-3, link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106150&idx=13'}
            ]},
            { focus:0, vote:true, items : [
                {name:'政策解读',style:'absolute maskIxIcon maskIxIcon1',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column2.jsp?typeId=10000100000000090000000000106151&idx=2'},
                {name:'身边系列',style:'absolute maskIxIcon maskIxIcon2',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column2.jsp?typeId=10000100000000090000000000106153&idx=4'},
                {name:'精品推荐',style:'absolute maskIxIcon maskIxIcon3',playType:-3,link:'/EPG/jsp/neirong/edu/v1/stage2.jsp?typeId=10000100000000090000000000106152&idx=3'},
                {name:'经典影视',style:'absolute maskIxIcon maskIxIcon4',playType:-3,link:'/EPG/jsp/neirong/edu/v1/listImage.jsp?typeId=10000100000000090000000000106155&idx=6'},
                {name:'综合荟萃',style:'absolute maskIxIcon maskIxIcon5',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column3.jsp?typeId=10000100000000090000000000106154&idx=5'},
                {name:'健康顾问',style:'absolute maskIxIcon maskIxIcon6',playType:-3,link:'/EPG/jsp/neirong/edu/v1/column2.jsp?typeId=10000100000000090000000000106156&idx=7'},
                {name:'文献纪录',style:'absolute maskIxIcon maskIxIcon7',playType:-3,link:'/EPG/jsp/neirong/edu/v1/listImage.jsp?typeId=10000100000000090000000000106157&idx=8'},
                {name:'重庆群工',style:'absolute maskIxIcon maskIxIcon8',playType:-3,link:'http://192.168.33.92/cqqg/index.htm'},
                {name:'微信关注',style:'absolute maskIxIcon maskIxIcon9',playType:-3,link:'/EPG/jsp/neirong/edu/v1/qrcode.jsp'}
            ]},
            { focus:0, items : [
                {name:'视频播放',style:'absolute maskVideo',playType:-3,link:'/EPG/jsp/neirong/edu/v1/playVideo.jsp'}
            ]},
            { focus:0, items : [
                {name:'首页',style:'absolute maskHome'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = blocked;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
               //上:11,下:-11,左-1,右1
                if( blocked == 0 && ( index == -1 || focus == 0 && index == 11 ) ||
                    blocked == 1 && ( focus <= 1 && index == 11 || focus >= 4 && index == -11 || index == 1 && focus == 8 ) ||
                    blocked == 2 && ( index == 11 || index == 1 ) || blocked == 3 && index != 11  ) return;
                if( blocked == 0 ){
                    if( index == 11 ) focus -= 1;
                    else if( index == -11 ) {
                        focus += 1;
                        if( focus >= focusable[blocked].items.length ) { blocked = focusable.length - 1; focus = 0; }
                    } else if ( index == 1 ) {
                        blocked = 1;
                        focus = focus == 0 ? 0 : 4;
                    }
                } else if( blocked == 1 ){
                    if( index == 1 && ( focus == 1 || focus == 3 ) || focus >= 6 && index == 11 ) {
                        blocked = 2; focus = 0;
                    } else if( index == 1)  focus += 1;
                    else if( index == -1 ) {
                        if( focus == 0 || focus == 2 || focus == 4 ) {
                            blocked = 0;
                            focus = focus == 4 ? focusable[blocked].items.length - 1 : 0 ;
                        } else focus -= 1;
                    } else focus += index > 0 ? -2 : 2;
                } else if( blocked == 2) {
                   blocked = 1;
                    var foc = focusable[blocked].focus;
                    if( index == -11 && ( foc == 1 || foc == 3 || foc == 0) ) foc = 6;
                    else if( index == -1 && foc >= 6 || foc == 0) foc = 1;
                    focus = foc;
                } else {
                    blocked = 0;
                    focus = focusable[blocked].items.length - 1;
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                focusable[blocked].focus = focus = index;
            }

            item =  focusable[blocked].items[focus];

            /* 2017年10月18日,十九大修改
            if( previous == 0) for( var i = 0; i < focusable[0].items.length; i++ )
                $('txtLft' + i).innerHTML = focusable[0].items[i].shortText;

            if( blocked == 0 && focusable[previous].items[focusable[previous].focus].length >= <%= popItemMaxCharLength %> )
                $('txtLft' + focusable[previous].focus).innerHTML = "<marquee class='txtLftMarquee'>" + focusable[previous].items[focusable[previous].focus].text + "</marquee>";
            */

            if( previous == 0 ) $('txtLft1').innerHTML = focusable[0].items[1].shortText;
            if( blocked == 0 && focusable[blocked].focus == 1 && focusable[blocked].items[1].length >= <%= popItemMaxCharLength %>) {
                $('txtLft1').innerHTML = "<marquee class='txtLftMarquee'>" + focusable[blocked].items[1].text + "</marquee>";
            }

            if(typeof item != 'undefined' && typeof item.style == 'string' ) $("mask").className = item.style;
        }
        function playMovie(){
            try {
                media.video.setPosition(722,122,484,319);
                DVB.playAV(2590000,701);       //频点，ServiceId
            } catch (e) {}
        }
        var flowedShow = function(index){
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
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "<div class='absolute ixBgTop'></div><div class='absolute ixBgLeft'></div><div class='absolute ixBgRight'></div><div class='absolute ixBgBottom'></div>";
                html += "<div id='ixLftTop' class='absolute ixLftBorder ixLftTop'><img src='<%= StringUtils.isEmpty(ztPicture) ? "images/defaultImg1.jpg" : ztPicture %>' /><!-- <div id='txtLft0' class='text'></div> --></div>";
                html += "<div id='ixLftBottom' class='absolute ixLftBorder ixLftBottom'><img src='<%= StringUtils.isEmpty(recPicture) ? "images/defaultImg1.jpg" : recPicture %>' /><div id='txtLft1' class='text'></div></div>";
                html += "<div id='ixIcon1' class='absolute ixIcon ixIcon1'></div>";
                html += "<div id='ixIcon2' class='absolute ixIcon ixIcon2'></div>";
                html += "<div id='ixIcon3' class='absolute ixIcon ixIcon3'></div>";
                html += "<div id='ixIcon4' class='absolute ixIcon ixIcon4'></div>";
                html += "<div id='ixIcon5' class='absolute ixIcon ixIcon5'></div>";
                html += "<div id='ixIcon6' class='absolute ixIcon ixIcon6'></div>";
                html += "<div id='ixIcon7' class='absolute ixIcon ixIcon7'></div>";
                html += "<div id='ixIcon8' class='absolute ixIcon ixIcon8'></div>";
                html += "<div id='ixIcon9' class='absolute ixIcon ixIcon9'></div>";
                html += "<div class='absolute scrollText'><marquee class='marquee' scrollamount='6'><%= scrollText %></marquee></div>";
                html += "<div id='mask'></div>";
                html += "<div id='ixIconZt' class='absolute ixIcon ixIconZt'></div>";
                document.body.innerHTML = html;
                //$("txtLft0").innerHTML = focusable[0].items[0].shortText;
                $("txtLft1").innerHTML = focusable[0].items[1].shortText;
            }
            playMovie();
            $.buildUserInterface();
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
            //首页，返回
            if( blocked == focusable.length - 1 ) { goBack(); return;}
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
                case "DVB_EIT_REQUEST_DATA_FINISHED":break;
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
<body leftmargin="0" topmargin="0" style="background: transparent url('images/ixBg.png') no-repeat; overflow:hidden;" onUnload="exit();"></body>
</html>