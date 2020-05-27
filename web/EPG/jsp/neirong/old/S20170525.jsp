<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000107720"};
    final int[] position = {8,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<List<Vod>> list = null;

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
    <title>守望尘世</title>
    <style>
        .mask {width:201px;height:30px;left:667px;position:absolute;background:transparent url('images/mask-2017-05-25.png') no-repeat;background-position: 0px -450px;}
        .mask1 {top:176px;}
        .mask2 {top:211px;}
        .mask3 {top:247px;}
        .mask4 {left:980px;top:457px;}
        .mask5 {left:980px;top:493px;}
        .mask6 {top:529px;left:980px;}
        .mask7 {top:565px;left:980px;}
        .mask8 {top:601px;left:980px;}

        .flowed {}
        .after {width:475px;height:449px;left:668px;top:179px;background-position: 0px 0px;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
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
           if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "style:'mask mask" + (j + 1) + "'" + "," +
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
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'确定',style:'btnSure'},
                {name:'取消',style:'btnCancel'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 1; rows = 8;              //定义行列，　几行几列
        var pageCount = columns * rows;
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                //如果焦点在投票上,按上下左右键时
                if( blocked == focusable.length - 1 && ( $.vote.tooltiped || index == 1 && focus == 2 || index == -1 && focus <= 1 || index == 11 && focus == 0 || index == -11 && focus >= 1 ) ) return;
                if( index == 1 && !$.vote.tooltiped && blocked == focusable.length - 1 && focus == 1 ) focus = focus + 1;
                else if( index == -1 && !$.vote.tooltiped && blocked == focusable.length - 1 && focus == 2 ) focus = focus - 1;
                else if( blocked == focusable.length - 1 ) { if (focus == 0 && index == -11 ) { focus = 1; $("maskVote").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0;$("maskVote").style.visibility = "hidden";} }
                else {
                     if( blocked < focusable.length - 1  && (
                         index == 11 && focus < columns || //按上光标键时
                         index == -1 && focus % columns == 0 || //按左光标键时
                         index == 1 && focus % columns == columns - 1 || //按右光标键时
                         index == -11 && ( ( columns == 1 && focus + 1 >= focusable[blocked].items.length ) || ( columns > 1 && ( Math.floor( focus / columns ) == Math.floor( focusable[blocked].items.length / columns ) )) ) //按下光标键时   && focus + columns != focusable[blocked].items.length (最后一个未对齐时)
                     ) ) return;
                     //TODO:当光标在首页、返回按钮上时，可同时按上，左键返回到列目中时，需要重写光标移动代码
                     if( index == 1 || index == -1 ) focus += index;
                     else if( index == 11 ) focus -= columns;
                     else if( index == -11 ) focus += columns;
                     if( focus >= focusable[blocked].items.length ) { focus = focusable[blocked].items.length - 1 ; }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 1 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $( blocked == focusable.length - 1 ? "maskVote" : "mask").className = item.style;

            $("mask").style.visibility = focusable[blocked].flowed ? "hidden" : "visible";
            for( var o in focusable.flowed ) flowedShow(focusable.flowed[o]);
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
        function queryVoteResult(block,voteColumnId, callback ){
            $.ajax('http://192.168.49.56:8080/voteNew/external/queryVoteDatas.ipanel?columnA=' + voteColumnId + '&isable=1&startIndex=0&pageSize=50&total=true',function(result){
                var columns = result.result;
                for( var i = 0; i < columns.length; i++ ){
                    if( typeof focusable[block].items[i].voteId === 'undefined' ){
                        focusable[block].items[i].voteId = columns[i].ID;
                    }
                    focusable[block].items[i].total = columns[i].total;
                }
                if( typeof callback === 'function' ) callback();
            });
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
            $.video = {};
            $.video.id = undefined;
            $.video.position = undefined;
            $.video.play = function(){
                try{
                    if(typeof $.video.id != "string" || $.video.id.isEmpty() || typeof iPanel === 'undefined') return;
                                                                //go_authorization.jsp??typeId=-1&playType=11&parentVodId="+parentVodId+"&progId="+freeVodId+"&baseFlag=0&contentType=0&startTime=0&business=1;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0";
                    $.ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.video.setPosition($.video.position[0],$.video.position[1],$.video.position[2],$.video.position[3]);
                            media.AV.open(rtsp,"VOD");
                        }
                    });
                } catch (e){}
            }

            $.vote = function (){
                if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    //点击量统计
                    //http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid=8230003190017318&classifyID=100&content=44
                    //专题投票排序
                    //var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=13999999999&classifyID=" + $.vote.current.id + "&voteCount=5&content=" + encodeURIComponent($.vote.current.message);
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote.ipanel?icid=" + cardId + "&repeat=false&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            $.vote.voted = result.result == false;
                            $.vote.tooltip($.vote.fail);
                        } else {
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.success);
                        }
                    });
                }
            };
            $.vote.voted = false;
            $.vote.current = undefined;
            $.vote.status = undefined;
            $.vote.phone = undefined;
            $.vote.maskStyle = undefined;
            $.vote.tooltiped = false;
            $.vote.error = "手机号码不正确！";
            $.vote.fail = "您已参与过投票！";
            $.vote.success = "投票成功！";
            $.vote.input = function (id ,num){
                if(typeof $.vote.status  != 'boolean' || !$.vote.status || $.vote.phone.length >=11)return;
                $.vote.phone += num;
                $(id).innerText = $.vote.phone;
            };
            $.vote.delete = function(id){
                if($.vote.phone.length==0)return;
                $.vote.phone = $.vote.phone.substr(0,$.vote.phone.length-1);
                $(id).innerText = $.vote.phone;
            };
            $.vote.validate = function(){
                var reg = /^1[3|4|5|8][0-9]\d{8}$/gi;
                return !reg.test($.vote.phone);
            };
            $.vote.show = function(){
                focusable[blocked].focus = 0;
                $.vote.phone = "";
                $.vote.tooltiped = false;
                $.vote.status = true;
                $("phoneNumber").innerHTML = "";
                if( typeof $.vote.maskStyle === 'undefined' && $("mask").style.visibility != 'hidden')
                {
                    $.vote.maskStyle = 'visible';
                    $("mask").style.visibility = "hidden";
                }
                $("votePop").style.visibility = "visible";
                $("votePop").style.backgroundPosition = "0px 0px";
            };
            $.vote.hidden = function(className){
                $.vote.status = false;
                $.vote.tooltiped = false;
                $.vote.current = undefined;
                if( typeof $.vote.maskStyle != 'undefined') {
                    $("mask").style.visibility = $.vote.maskStyle;
                    $.vote.maskStyle = undefined;
                }
                $("votePop").style.visibility = "hidden";
                $("maskVote").style.visibility = "hidden";
            };
            $.vote.tooltip = function(message){
                if( typeof  message == 'undefined' ) message = $.vote.error;
                $.vote.status = false;
                $.vote.tooltiped = true;
                $("phoneNumber").innerHTML = message;
                $("votePop").style.backgroundPosition = "0px -400px";
                $("votePop").style.visibility = "visible";
                $("maskVote").style.visibility = "hidden";
            };
            //用来记录输入电话号码框的数组顺序及焦点
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
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
                if( typeof option.vote != 'undefined' ){
                    html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                    html += "<div id='maskVote'><span>&nbsp;</span></div>";
                    for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else if( typeof focusable[option.vote[i].blocked].items[option.vote[i].item] != 'undefined')
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };
                }
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; $.video.play();}
                document.body.innerHTML = html;
                if( typeof option.vote != 'undefined' ) $("maskVote").style.visibility = "hidden";
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
            $.buildUserInterface({flowed:undefined,vote:undefined,video:undefined,position:undefined,external:{after:'<div class="mask after"></div>',before:undefined}}); //
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( focusable.length > 1 ) {
                if( blocked == focusable.length - 1 ) { if( focusable[focusable.length-1].focus == 0 && !$.vote.voted )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
                if( typeof focusable[blocked].vote == 'boolean'){
                    if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                    blocked = focusable[blocked].backed;
                    focused(focusable[blocked].focus, true);
                    return;
                }
            }
            if(typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            //首页，返回
            if( blocked == focusable.length - 1 ) { $.vote(); return; }
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
                    $.vote.current = {};
                    $.vote.current.id = typeof item.voteId == 'undefined' ? focusable[blocked].voteId : item.voteId;
                    $.vote.current.message = typeof item.text == 'undefined' ? item.name : item.text;
                    focusable[focusable.length - 1].backed = blocked;
                    blocked = focusable.length - 1;
                    focusable[blocked].focus = 0;
                    $.vote();
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
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'western/eu_tvD') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
                case "KEY_NUMERIC":$.vote.input("phoneNumber", eventObj.args.value);break;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-05-25.jpg') no-repeat;" onUnload="exit();"></body>
</html>