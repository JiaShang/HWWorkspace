<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {};
    final int[] position = {11,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

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
    <title>2017感动重庆十大人物</title>
    <style>
        .mask {width:61PX;height:30px;position:absolute;background:transparent url('images/mask-2017-12-22.png') no-repeat;background-position: 0px 0px;}
        .mask1 {left:225px;top:345px;}
        .mask2 {left:440px;top:345px;}
        .mask3 {left:655px;top:345px;}
        .mask4 {left:869px;top:345px;}
        .mask5 {left:1084px;top:345px;}
        .mask6 {left:225px;top:561px;}
        .mask7 {left:440px;top:561px;}
        .mask8 {left:655px;top:561px;}
        .mask9 {left:869px;top:561px;}
        .mask10 {left:1084px;top:561px;}

        .vote {width:50px;height:17px;position:absolute;font-size: 12px;color:white;text-align: center;line-height: 15px;}
        .vote1{left:94px;top:324px;}
        .vote2{left:309px;top:324px;}
        .vote3{left:524px;top:324px;}
        .vote4{left:738px;top:324px;}
        .vote5{left:953px;top:324px;}
        .vote6{left:94px;top:540px;}
        .vote7{left:309px;top:540px;}
        .vote8{left:524px;top:540px;}
        .vote9{left:738px;top:540px;}
        .vote10{left:953px;top:540px;}

        .flowed {}
        .after {}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
    </style>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

        Date.prototype.Format = function(fmt)
        {
            var o = {
                "M+" : this.getMonth()+1,
                "d+" : this.getDate(),
                "h+" : this.getHours(),
                "m+" : this.getMinutes(),
                "s+" : this.getSeconds(),
                "q+" : Math.floor((this.getMonth()+3)/3),
                "S"  : this.getMilliseconds()
            };
            if(/(y+)/.test(fmt))
                fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
            for(var k in o)
                if(new RegExp("("+ k +")").test(fmt))
                    fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
            return fmt;
        };
        var currentTime = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
        var voteStart = '2017-12-25 09:00:00' <= currentTime;
        var voteEnd = currentTime <= "2017-12-29 12:00:00";
        var voteSwitch = voteStart && voteEnd;



        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            <%
           value = "";
           String[] names = "蔡芝兵 曹光富 许厚碧 陈腊娥 陈明益 陈鸣凤 陈容 戴前锋 何舒培 梁新宇 廖良开 罗倩 彭阳 邵智 熊军 徐白惠 徐前凯 严克美 杨扬 游建平".split(" ");
           value += "{focus:0,items:[";
           for( int j = 0; j < names.length ; j++ ){
               String name = names[j];
               String str = "{ text:\"" + name + "\"," +
                      "count:0,playType:-2" ;
                   str += "}" ;
               str += ( j + 1 < names.length  ? "," : "");
               value += str;
           }
           value += "]},";
           out.write(value);
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
        var columns = 5; rows = 2;              //定义行列，　几行几列
        var pageCount = columns * rows;
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = Math.ceil((focus + 1.0) / 10);
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

            if(blocked == 0 ){

                var className = "mask mask" + (focus % 10 + 1);
                $("mask").className  = className;

                if( Math.ceil( (focus + 1.0) / 10 ) != previous ) {
                    document.body.style.backgroundImage = "url('images/bg-2017-12-22-" + Math.ceil( (focus + 1.0) / 10 ) + ".jpg')";
                    sortAndShow(0);
                }
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
        var sortAndShow = function (index, results){
            if(typeof results != 'undefined')
            {
                for( var j = 0 ; j < results.length; j++ ) {
                    var name = results[j].name;
                    for( var i = 0; i < focusable[0].items.length ; i ++ ) {
                        if( name != focusable[0].items[i].text ) continue;
                        focusable[0].items[i].count = results[j].num;
                        break;
                    }
                }

            }
            var focus = focusable[0].focus;
            var items = focusable[0].items;
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i ++) {
                $("vote" + (i - flowCursorIndex + 1) ).innerHTML = items[i].count;
            }
        }
        function queryVoteResult(){
            try {
                $.ajax('http://192.168.49.56:8989/VoteStatistics/getVoteInfo?classifyID=401',function(result){
                    sortAndShow(0,result);
                });
            } catch ( e ) {};
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
                                                                //go_authorization.jsp?typeId=-1&playType=11&parentVodId="+parentVodId+"&progId="+freeVodId+"&baseFlag=0&contentType=0&startTime=0&business=1;
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
                if( $.vote.voted == true ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                //if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 1 && focusable[focusable.length - 1].focus == focusable[focusable.length - 1].items.length - 1 ) { goBack(); return; }
                else {
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = typeof CA != 'undefined' ? CA.card.serialNumber : "1111111111";
                    //点击量统计
                    //http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid=8230003190017318&classifyID=100&content=44
                    //专题投票排序
                    //var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=13999999999&classifyID=" + $.vote.current.id + "&voteCount=5&content=" + encodeURIComponent($.vote.current.message);
                    //投票，每天投指定票数，每个限投N票
                    //addVote6.ipanel?icid=1111111111&phone=00000000000&classifyID=401&content="+wrapContent+"&voteCount=10&contentNum=1

                    var url = "http://192.168.49.56:8080/voteNew/external/addVote6.ipanel?icid=" + cardId + "&phone=00000000000&classifyID=401&voteCount=10&contentNum=1&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            $.vote.voted = true;
                            $.vote.tooltip("重复投票或投票过多！");
                        } else {
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.success);
                            queryVoteResult();
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
            $.vote.fail = "重复投票或投票过多！";
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
                html += "<div id='vote1' class='vote vote1'></div>";
                html += "<div id='vote2' class='vote vote2'></div>";
                html += "<div id='vote3' class='vote vote3'></div>";
                html += "<div id='vote4' class='vote vote4'></div>";
                html += "<div id='vote5' class='vote vote5'></div>";
                html += "<div id='vote6' class='vote vote6'></div>";
                html += "<div id='vote7' class='vote vote7'></div>";
                html += "<div id='vote8' class='vote vote8'></div>";
                html += "<div id='vote9' class='vote vote9'></div>";
                html += "<div id='vote10' class='vote vote10'></div>";
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
            $.buildUserInterface({flowed:undefined,vote:[{blocked:0,item:undefined,id: 401}],video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            focused(<%= focused %>, true);
            queryVoteResult();
            sortAndShow(0);
        }
        function goBack(keyBack){
            if( focusable.length > 1 ) {
                if( blocked == focusable.length - 1 ) { if( focusable[blocked].focus == 0 && !$.vote.voted )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
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
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if(typeof item == 'undefined' || item.playType == 'undefined') return;
            if( blocked == 0 )
            {
                $.vote.voted = $.vote.moreVote = false;
                if(!voteStart || !voteEnd) {
                    $.vote.current = {};
                    $.vote.current.id = focusable[blocked].voteId;
                    $.vote.current.message = typeof item.text == 'undefined' ? item.vote : item.text;
                    focusable[focusable.length - 1].backed = blocked;
                    blocked = focusable.length - 1;
                    focusable[blocked].focus = 0;
                    if( !voteSwitch ) {
                        $.vote.voted = true;
                        $.vote.fail = !voteStart ? "活动暂未开始!" : "本次活动已结束";
                    }
                    $.vote();
                    return;
                }
            }

            if( blocked == focusable.length - 1 ) { $.vote(); return; }
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-12-22-1.jpg') no-repeat;" onUnload="exit();"></body>
</html>