<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000105901"};
    final int[] position = {9,0};
    //TODO:每次需要修改
    int focused = 0, area = 1;
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
        isKorean = StringUtils.isEmpty(request.getParameter("isKorean"))? "false": "true";

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
    <title>票选重庆避暑胜地</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2016-07-22.png') no-repeat;background-position: 0px -200px;}

        .showResult{width:1280px;height:720px;top:0px;left:0px;position:absolute;background:transparent none no-repeat 0px 0px;}
        .maskRole {width:157px;height:34px;left:43px;top:120px; background-position: -300px 0px;}
        .showResultBg{width:209px;height:44px;left:978px;top:554px; background-position: -296px -35px;}
        .maskView {width:201px;height:40px;left:982px;top:556px; background-position: -300px -80px;}

        .textContainer {width:990px;height:225px;left:115px;top:309px; position:absolute;}
        .text{width:120px;height:30px;line-height: 30px;font-size: 22px;position:absolute;color:white;}
        .text1 {left:0px;top:0px;}
        .text2 {left:218px;top:0px;}
        .text3 {left:438px;top:0px;}
        .text4 {left:656px;top:0px;}
        .text5 {left:861px;top:1px;}
        .text6 {left:0px;top:212px;}
        .text7 {left:218px;top:212px;}
        .text8 {left:438px;top:212px;}
        .text9 {left:656px;top:212px;}

        .maskSort1 {width:81px;height:81px;background-position: -510px 0px;}
        .maskSort2 {width:81px;height:81px;background-position: -610px 0px;}
        .maskSort3 {width:81px;height:81px;background-position: -710px 0px;}
        .maskItem1 {left:73px;top:161px;}
        .maskItem2 {left:291px;top:161px;}
        .maskItem3 {left:511px;top:161px;}
        .maskItem4 {left:729px;top:161px;}
        .maskItem5 {left:943px;top:162px;}
        .maskItem6 {left:73px;top:373px;}
        .maskItem7 {left:291px;top:373px;}
        .maskItem8 {left:511px;top:373px;}
        .maskItem9 {left:729px;top:373px;}

        .maskVideo {width:199px;height:119px;background-position: 0px 0px;}
        .maskVideo1 {left:100px;top:189px;}
        .maskVideo2 {left:318px;top:189px;}
        .maskVideo3 {left:538px;top:189px;}
        .maskVideo4 {left:756px;top:189px;}
        .maskVideo5 {left:971px;top:190px;}
        .maskVideo6 {left:100px;top:401px;}
        .maskVideo7 {left:318px;top:401px;}
        .maskVideo8 {left:538px;top:401px;}
        .maskVideo9 {left:756px;top:401px;}

        .maskVote {width:63px;height:32px;background-position: -200px 0px;}
        .maskVote1 {left:236px;top:308px;}
        .maskVote2 {left:454px;top:308px;}
        .maskVote3 {left:674px;top:308px;}
        .maskVote4 {left:892px;top:308px;}
        .maskVote5 {left:1107px;top:309px;}
        .maskVote6 {left:236px;top:520px;}
        .maskVote7 {left:454px;top:520px;}
        .maskVote8 {left:674px;top:520px;}
        .maskVote9 {left:892px;top:520px;}

        .flowed {}
        .after {}

        .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
        .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
        .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
        .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
        .popuped .maskItem .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
        .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat fixed 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -350px;}

        .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
        .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}
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
            { focus:0,items : [{name:'活动细则',style:'mask maskRole',playType:-3,link:'http://192.168.98.67:9988/ggly-gd-hd/index.jsp?entry=recommend1&code=20160730_hlpzyqtz_album'}]},
            <%
            value = "";
            String[] names = "武陵山,八斗台,观音塘,龙头嘴,金刀峡,天下龙缸,黑山谷,仙女山,荼山竹海".split("\\,");
            String[] voteIds = {"335","336","337","338","339","340","341","342","343"};
            String[] backUrls = {"","zhongx","bishan","kaizh","beibei","yuny","wansh","wulong",""};
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                  "style:'mask maskVideo maskVideo" + (j + 1) + "'," +
                                  "back:'" + backUrls[j] + "'," +
                                 "playType:" + vod.getIsSitcom() ;
                            str += "}" ;
                        if(i == 0) str += ",{text:'投票',name:'" + names[j] + "',voteId:" + voteIds[j] + ",style:'mask maskVote maskVote" + (j+1) + "',playType:-2,total:0}";
                            str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]},";
                }
                out.write(value);
            }
            %>
            { focus:0,items : [{name:'查看中奖名单按钮',style:'mask maskView'}]},
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'确定',style:'btnSure'},
                {name:'取消',style:'btnCancel'}
            ]},
            { focus:0, items : [
                {name:'首页',style:'btnHome'},
                {name:'返回',style:'btnReturn'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var enabledResult = true;
        var showResult = false;
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 0; rows = 0;              //定义行列，　几行几列
        var pageCount = columns * rows;
        var arrows = [1,1];                     //可以移动到首页返回按钮的光标键「下，右」
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                if(
                    //如果焦点在投票的返回，或右下角的返回上，或者在浮动层上时,光标按右键直接返回
                    blocked == focusable.length - 1 && ( index == -11 || focus == 1 && index == 1 ) ||
                    //如果焦点在投票上,按上下左右键时
                    (blocked == focusable.length - 2 && ( $.vote.tooltiped || focus == 2 && index == 1 || focus <= 1 && index == -1 || focus == 0 && index == 11 || focus >= 1 && index == -11)) ||
                    //或者焦点在浮动层上, 按上下左右键时，
                    focusable[blocked].popuped && ( focus <= 0 && index == 11 || focus >= focusable[blocked].items.length - 1 && index == -11 || index == -1 || index == 1 )
                ) return;
                if( index == 1 && ( !$.vote.tooltiped && blocked == focusable.length - 2 && focus == 1 || blocked == focusable.length - 1 && focus == 0 ))
                    focus = focus + 1;
                else if( index == -1 && ( ! $.vote.tooltiped && blocked == focusable.length - 2 && focus == 2 || blocked == focusable.length - 1 && focus == 1))
                    focus = focus - 1;
                else if( focusable[blocked].popuped ) { focus += index > 0 ? -1 : 1;  }
                else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("maskVote").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0;$("maskVote").style.visibility = "hidden";} }
                else {
                    if( blocked == 0 && index != -11 || blocked == 1 && (
                        focus % 2 == 0 && focus != 0 && focus < 10 && index == 11 || (focus % 10 == 0 || focus % 10 == 1) && index == -1 ||
                        ( focus == 8 || focus == 9 ) && index == 1 ||
                        ( ( focus >= 11 && focus % 2 == 1 )) && index == -11 ) ||
                        blocked == 2 && ( showResult || enabledResult && index == 1)
                    ) return;
                    if( blocked == 0 ) {
                        blocked = 1; focus = 0;
                    } else if( blocked == 1 ) {
                        if( index == 1 || index == -1) {
                            if( ( focus == 16 || focus == 17 ) && index == 1 ) {
                                blocked = enabledResult ? 2 : focusable.length - 1; focus = 0;
                            } else {
                                focus += index * 2;
                            }
                        } else if( index == 11 ){
                            if( focus == 0 ) { blocked = 0; focus = 0; }
                            else if( focus % 2 == 0 && focus >= 10 ) focus -= 9;
                            else focus -= 1;
                        } else if( index == -11 ){
                            if( focus == 9 ) {
                                if( enabledResult ){
                                    blocked = 2; focus = 0;
                                } else {
                                    blocked = focusable.length - 1;
                                    focus = focusable[blocked].focus;
                                }
                            }
                            else if( focus % 2 == 1 && focus <= 7 )
                                    focus += 9;
                            else focus += 1;
                        }
                    } else if( blocked == 2 ) {
                        if( index == -11 ) {
                            blocked = focusable.length - 1;
                            focus = focusable[blocked].focus;
                        } else {
                            blocked = 1;
                            focus = index == 11 ? 9 : ( focusable[1].focus == 9 ? 16 : focusable[1].focus );
                        }
                    } else if( blocked == focusable.length - 1 ) {
                        if( index == 11 ) {
                            if( enabledResult ) {
                                blocked = 2;
                                focus = 0;
                            } else {
                                blocked = 1;
                                focus = 9;
                            }
                        } else if( index == -1 ) {
                            if( enabledResult ) return;
                            else {
                                blocked = 1; focus = focusable[1].focus == 9 ? 17 : focusable[1].focus;
                            }
                        }
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $( blocked == focusable.length - 2 ? "maskVote" : "mask").className = item.style;

            $("mask").style.visibility = focusable[blocked].flowed ? "hidden" : "visible";
            for( var o in focusable.flowed ) flowedShow(focusable.flowed[o]);

            if( focusable[blocked].popuped ) $.popupShow();
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
        function showVoteResult(showOrder){
            var items = focusable[1].items;
            var html = "";
            for( var i = 0; i < items.length / 2; i ++ ) {
                html += "<div class='text text" + ( i + 1) +"'>" + items[i * 2 + 1].total + "</div>";
            }
            $("textContainer").innerHTML = html;
            if( showOrder == false || ! enabledResult) return;
            var first = 0, second = 0; third = 0;
            for( var i = 0; i < 3 ; i++){
                var curr = 0; max = 9999999;
                if( i == 1 || i == 2 ) max = i == 1 ? first : second;
                for( var j = 0; j < items.length / 2; j++ ) {
                    var total = items[j * 2 + 1].total;
                    if( curr < total && total < max ) curr = total;
                }
                if( i == 0 ) first = curr;
                else if( i == 1 ) second = curr;
                else third = curr;
            }
            for( var i = 0; i < items.length / 2 ; i ++ ){
                var total = items[i * 2 + 1].total;
                if( total == first ) {
                    $("sortOd" + ( i + 1)).style.visibility = 'visible';
                    $("sortOd" + ( i + 1)).className = "mask maskSort1 maskItem" + ( i + 1);
                } else if( total == second ) {
                    $("sortOd" + ( i + 1)).style.visibility = 'visible';
                    $("sortOd" + ( i + 1)).className = "mask maskSort2 maskItem" + ( i + 1);
                } else if( total == third ) {
                    $("sortOd" + ( i + 1)).style.visibility = 'visible';
                    $("sortOd" + ( i + 1)).className = "mask maskSort3 maskItem" + ( i + 1);
                } else {
                    $("sortOd" + ( i + 1)).style.visibility = 'hidden';
                }
            }
        }
        function queryVoteResult(block,voteColumnId, callback ){
            $.ajax('http://192.168.49.56:8080/voteNew/external/queryVoteDatas.ipanel?columnA=' + voteColumnId + '&isable=1&startIndex=0&pageSize=50&total=true',function(result){
                var columns = result.result;
                for( var i = 0; i < columns.length; i ++ ){
                    if( typeof focusable[block].items[i * 2 + 1].voteId === 'undefined' ){
                        focusable[block].items[i * 2 + 1].voteId = columns[i].ID;
                    }
                    focusable[block].items[i * 2 + 1].total = columns[i].total;
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
                    request.timeout = 60 * 1000;
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
            $.popupShow = function(){
                var focus =  focusable[blocked].focus;
                var items = focusable[blocked].items;
                $("page").innerText = (Math.ceil((focus + 1) / popMaxItemsLength) + "/" + Math.ceil(items.length / popMaxItemsLength));
                if($("popuped").style.visibility == "hidden") $("popuped").style.visibility = "visible";
                var html = "";
                for(var i = 0; i < items.length ; i ++ ){
                    var vod = items[i];
                    html += "<div class='" + ( focus == i ? "maskItem" : "item") + "'>" +
                    (vod.length <= <%= popItemMaxCharLength %> || focus != i ? vod.shortText : ("<marquee class='marqueed'>" + vod.text + "</marquee>")) +
                    "</div>";
                }
                $("popupContent").innerHTML = html;
                $("popupContent").style.marginTop = "-" + (Math.floor(focus / popMaxItemsLength) * popMaxItemsLength * 51) + "px";
            }
            $.video = {};
            $.video.id = undefined;
            $.video.position = undefined;
            $.video.play = function(){
                try{
                    if(typeof $.video.id != "string" || $.video.id.isEmpty() || typeof iPanel === 'undefined') return;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0&idType=FSN";
                    $.ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.AV.open(rtsp,"VOD");
                        }
                    });
                } catch (e){}
            }
            $.video.start = function(){
                try { if(typeof ($.video.id) === "string" && !$.video.id.isEmpty()) media.AV.play(); } catch (e) {}
            };
            $.vote = function (){
                var item = focusable[1].items[focusable[1].focus];
                if( typeof item.voted == 'boolean' && item.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip("您已对" + item.name + "投票！"); else goBack();return; }
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote.ipanel?icid=" + cardId + "&repeat=false&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            focusable[1].items[focusable[1].focus].voted = result.result == false;
                            $.vote.tooltip("您已对" + item.name + "投票！");
                        } else {
                            focusable[1].items[focusable[1].focus].voted = true;
                            queryVoteResult(1,"2016djsd",showVoteResult);
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
                queryVoteResult(1,"2016djsd",showVoteResult);
                var html = "<div class='textContainer' id='textContainer'></div>";
                if(typeof option.external.before == 'string') html += option.external.before;
                if( enabledResult ) html += "<div class='mask showResultBg'></div>";
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div id='mask'></div>";
                if( enabledResult ) {
                    html += "<div id='sortOd1'></div>";
                    html += "<div id='sortOd2'></div>";
                    html += "<div id='sortOd3'></div>";
                    html += "<div id='sortOd4'></div>";
                    html += "<div id='sortOd5'></div>";
                    html += "<div id='sortOd6'></div>";
                    html += "<div id='sortOd7'></div>";
                    html += "<div id='sortOd8'></div>";
                    html += "<div id='sortOd9'></div>";
                }
                if(typeof option.external.after == 'string' ) html += option.external.after;
                if(typeof option.popup != 'undefined'  ){
                    html += "<div class='popuped' id='popuped' style='visibility:hidden'><div class='container'  id='popupContainer'><div class='content' id='popupContent'></div></div><div class='page' id='page'>1/1</div></div>";
                    for(var i = 0; i< option.popup.length; i++) {
                        if( typeof focusable[option.popup[i].blocked].items[option.popup[i].item] == 'undefined' )
                            focusable[option.popup[i].blocked].items[option.popup[i].item] = {};
                        focusable[option.popup[i].blocked].items[option.popup[i].item].blocked = option.popup[i].target;
                        focusable[option.popup[i].blocked].items[option.popup[i].item].playType = -1;
                        if(typeof option.popup[i].style == 'string')  focusable[option.popup[i].blocked].items[option.popup[i].item].style = option.popup[i].style;
                        focusable[option.popup[i].target].popuped = true;
                        focusable[option.popup[i].target].backed = option.popup[i].blocked;
                        focusable[option.popup[i].target].previous = option.popup[i].item;
                    }
                }
                if( typeof option.vote != 'undefined' ){
                    html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                    html += "<div id='maskVote'><span>&nbsp;</span></div>";
                    /*for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else if( typeof focusable[option.vote[i].blocked].items[option.vote[i].item] != 'undefined')
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };*/
                }
                html += "<div class='showResult' id='showResult' style='visibility: hidden;'></div>";
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; }
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
            $.buildUserInterface({flowed:undefined,popup:undefined,vote:[{blocked:1,item:undefined,id:0}],video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}
            showVoteResult(false);
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( blocked == 2 && enabledResult && showResult ) {
                showResult = false;
                $("showResult").style.visibility = "hidden";
                return;
            }
            if( blocked == focusable.length - 2) { var voted = focusable[1].items[focusable[1].focus].voted; if( (typeof voted != "boolean" || !voted) && focusable[focusable.length-2].focus == 0 )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
            if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
            if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
                if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                blocked = focusable[blocked].backed;
                focused(focusable[blocked].focus, true);
                return;
            }
            if(typeof iPanel != 'undefined' && blocked == focusable.length - 1 && focus == 0 && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = blocked == focusable.length - 1 && focusable[blocked].focus == 0 || EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            //首页，返回
            if( blocked == 2 ) {
                if( ! enabledResult ) return;
                if( !showResult) {
                    showResult = true;
                    $("showResult").style.visibility = "visible";
                    $("showResult").style.backgroundImage = "url('images/focusBg-2016-07-22.png?t=" + new Date().getDate() + "')";
                } else {
                    showResult = false;
                    $("showResult").style.visibility = "hidden";
                }
                return;
            }
            if( blocked == focusable.length - 1 ) { goBack(); return;}
            if( blocked == focusable.length - 2 ) { $.vote(); return; }
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if(typeof item == 'undefined' || item.playType == 'undefined') return;
            var typeId = focusable[blocked].typeId;
            var url = '';
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
                    focusable[focusable.length - 2].backed = blocked;
                    blocked = focusable.length - 2;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                    break;
                case -3:
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
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://去掉基本包检验 baseFlag=0
                    url = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
                    if( item.back != '') {
                        url = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/hidden_detail.jsp?typeId=" + typeId + "&vodId=" + item.mid + "&playType=1&idType=FSN&baseFlag=0&appBackUrl=" + encodeURIComponent("http://192.168.42.60/" + item.back + "/index.html?backUrl=<%= request.getRequestURL().toString() %>?currFoucs="+ blocked + "," + focusable[blocked].focus);
                    }
                    top.window.location.href = url;
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
                case "VOD_PREPAREPLAY_SUCCESS":$.video.start();break;
                case "EIS_VOD_PROGRAM_END":$.video.play();break;
            }
            return 	eventObj.args.type;
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2016-07-22.jpg') no-repeat;" onUnload="exit();"></body>
</html>