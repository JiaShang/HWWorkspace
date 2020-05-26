<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000107091","10000100000000090000000000107093"};
    final int[] position = {99,0,99,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 20;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String savedFocus = "";
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

        if(null == focus ){
            savedFocus  = "";
        } else if( focus.length > 0 ){
            for(String f : focus )
                savedFocus += f + ",";
            savedFocus = savedFocus.substring(0, savedFocus.length() - 1);
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
    } catch (Exception e){ e.printStackTrace(); }
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>“科宇杯”唱响潼南电视歌唱大赛</title>
    <style>
        .mask {width:156px;height:50px;top:100px;position:absolute;background:transparent url('images/mask-2016-12-31.png') no-repeat;background-position: 0px 0px;}
        .mask1{left:118px;background-position: 0px 0px;}
        .mask2{left:271px;background-position: -160px 0px;}

        .itemContainer {width:315px;height:239px;float:left;position:relative;overflow: hidden;}
        .imgDiv {position:absolute;height:183px;width:310px;left:2px;top:2px;}
        .imgDiv img {height:183px;width:310px;}
        .focusItem{width:315px;height:189px;position:absolute;left:0px;top:0px;background-position:0 -60px;}
        .item{width:309px;height:33px;background-color:#004719;left:3px;top:191px;overflow: hidden;position: absolute;line-height:32px;font-size:22px;color:#ffffff;}
        .text {width:222px;height:33px;line-height:32px;font-size:22px;color:#ffffff;text-align: center;}
        .vote,.voteFocus {width:96px;height:40px;left:222px;top:188px;}
        .voteFocus{background-position: 0px -300px;}
        .vote{background-position: -100px -300px;}

        .scrollBarBg{width:7px;height:176px;background-position: -380px 0px; left:724px;top:414px;}
        .scrollBar{width:5px;position:absolute;left:1px;top:0px;}
        .scrollBarTop,.scrollBarBottom{width:5px;left:0px;height:4px; border:none;}
        .scrollBarTop {top:0px;background-position: -400px 0px;}
        .scrollBarMiddle{width:5px;left:0px;border:none;top:4px;background-position: -400px -4px;background-repeat: repeat-y;}
        .scrollBarBottom{bottom:0px;background-position: -400px -172px;}

        .flowed {width:970px;height:600px;position:absolute;left:47px;top:147px;}

        .ranking {width:191px;height:180px;position:absolute;left:1080px;}
        .rankingItem {width:190px;height:59px;float:left;position:relative;}
        .rankingName {width:118px;left:0px;top:16px;height:27px;line-height:25px;font-size:20px;color:#D5F1E5; overflow: hidden;text-align:left; position:absolute;}
        .rankingTotal {color:#cccccc;position:absolute;top:26px;font-size:18px;text-align:left;overflow: hidden;width:80px;left:120px;}
        .pageNum,.pageCount{width:21px;height: 22px;font-size:20px;color: white;position:absolute;overflow: hidden;left:1003px;top:175px;line-height: 22px; text-align: center;}
        .pageCount {top:208px;}

        .after {}

        .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat 0px 0px; overflow: hidden;}
        .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
        .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
        .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat 0px -426px; overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat 0px -477px; overflow: hidden;}
        .popuped .maskItem .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
        .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}

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

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            { focus:0, items : [
                {name:'成年组',style:'mask mask1'},
                {name:'少儿组',style:'mask mask2'}
            ]},
            <%
            value = "";
            String[][] addons = new String[][] {
               "536,536,536,536,536,536,536,536,536,536,536,536,536,536,536,536".split(","),
               "536,536,536,536,536,536,536,536,536,536,536,536,536,536,536,536".split(",")
            };
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                              "shortText:\"" + StringUtil.limitStringLength(vod.getName(), popItemMaxCharLength) + "\"" + "," +
                                 "length:" + StringUtil.length(vod.getName()) + "," +
                                "picture:'" + Utils.pictureUrl("images/default_preview_lb.png", vod.getPosters(), "0", request)+ "'" + "," +
                                  "addon:" + addons[i][j] + "," +
                                  "count:0," +
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
            ]},
            { focus:0, items : [
                {name:'首页',style:'btnHome'},
                {name:'返回',style:'btnReturn'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var voteSwitch = (new Date()).Format("yyyy-MM-dd hh:mm:ss") < "2017-01-10 18:00:00";
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;          //是否为韩剧
        var columns = 3; rows = 2;              //定义行列，　几行几列
        var pageCount = columns * rows;
        var arrows = [1,0];                     //可以移动到首页返回按钮的光标键「下，右」
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                if(
                    //如果焦点在投票的返回，或右下角的返回上，或者在浮动层上时,光标按右键直接返回
                    blocked == focusable.length - 1 && (focus == 0 && arrows[1] == 0 && index == -1 || arrows[0] == 0 && index == 11 || index == -11 || focus == 1 && index == 1 ) ||
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
                    if( blocked == 0 && ( index == 11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= focusable[blocked].items.length ) ||
                        blocked >= 1 && blocked <= 2 && ( index == -1 && focus % columns == 0 || index == 1 && focus % columns == ( columns - 1 ) || index == -11 && !voteSwitch && focus + 1 >= focusable[blocked].items.length )
                    ) return;

                    if( blocked == 0 ) {
                        if( index == -11 ) {
                            blocked = focusable[0].focus + 1;
                            focus = focusable[blocked].focus;
                        } else {
                            focus += index;
                        }
                    } else if( blocked >= 1 && blocked <= 2) {
                        if( index == 11 && focus < columns && !focusable[blocked].focusVote ) {
                            blocked = 0; focus = focusable[blocked].focus;
                        } else if( index == 1 || index == -1 )
                            focus += index;
                        else {
                            if( voteSwitch ) {
                                var focusVote = !(typeof focusable[blocked].focusVote == 'undefined' || focusable[blocked].focusVote == false);
                                if( index == 11 ) {
                                    focusable[blocked].focusVote = !focusVote;
                                    if( ! focusVote ) {
                                        focus -= columns;
                                    }
                                } else {
                                    focusable[blocked].focusVote = !focusVote;
                                    if( focusVote ) {
                                        focus += columns;
                                    }
                                }
                            } else {
                                focus += index > 0 ? -columns : columns;
                            }
                        }
                        if( focus >= focusable[blocked].items.length ) focus = focusable[blocked].items.length - 1;
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[0].items[focusable[0].focus];
            $("mask").className = item.style;

            flowedShow(focusable[0].focus >= 2 ? 3 : ( focusable[0].focus + 1 ));
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
                html += "<div class='itemContainer'>";
                html += '<div class="imgDiv"><img src="' + item.picture + '" /></div>';

                if( i == focus && blocked == index && !focusable[index].focusVote )
                    html += "<div class='mask focusItem'></div>";

                if( ! voteSwitch ) {
                    html += "<div class='item' style='text-align: center;'>" + item.shortText +  "</div></div>";
                } else {
                    html += "<div class='item'><div class='text'>" + item.shortText +  "</div></div>";
                    html += "<div class='mask " +  ( i == focus && blocked == index && focusable[index].focusVote ? "voteFocus" : "vote") + "'></div>";
                }
                html += "</div>";
            }
            $("flowed").innerHTML = html;

            $("pageNum").innerHTML = Math.floor( focus / pageCount) + 1;
            $("pageCount").innerHTML =  Math.ceil( items.length / pageCount);
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
                if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                //if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                var cardId = CA.card.serialNumber;
                var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=13999999999&classifyID=" + $.vote.current.id + "&voteCount=5&content=" + encodeURIComponent($.vote.current.message);
                $.ajax(url,function(result){
                    if(result.recode != '002' || result.result == false ){
                        $.vote.moreVote = result.result == false;
                        $.vote.voted = true;
                        $.vote.tooltip($.vote.fail);
                    } else {
                        $.vote.voted = true;
                        $.vote.tooltip($.vote.success);
                        queryVoteResult(focusable[focusable.length - 2].backed);
                    }
                });
            };
            $.vote.voted = false;
            $.vote.current = undefined;
            $.vote.status = undefined;
            $.vote.phone = undefined;
            $.vote.maskStyle = undefined;
            $.vote.tooltiped = false;
            $.vote.error = "手机号码不正确！";
            $.vote.fail = "失败,您点赞过多！";
            $.vote.success = "您已点赞成功！";
            $.vote.moreVote = false;
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
                var str = '';
                for( var i = 0; i <= 2; i++) str += focusable[i].focus + ",";
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + str.substr(0, str.length - 1) + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div class='ranking' id='ranking1' style='top:282px'></div><div class='ranking' id='ranking2' style='top:516px;'></div><div id='mask'></div>";
                html += "<div id='pageNum' class='pageNum'>0</div><div id='pageCount' class='pageCount'>0</div>";
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
                    for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else if( typeof focusable[option.vote[i].blocked].items[option.vote[i].item] != 'undefined')
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };
                }
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; }
                document.body.innerHTML = html;
                if( typeof option.vote != 'undefined' ) $("maskVote").style.visibility = "hidden";
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
            $.buildUserInterface({flowed:[0,1],popup:undefined,vote:[{blocked:1,item:undefined,id:387},{blocked:2,item:undefined,id:388}],video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}
            var strFocus = '<%= savedFocus%>';
            if( !strFocus.isEmpty() )
            {
                strFocus = strFocus.split(",");
                blocked = Number(strFocus[0]);
                focusable[0].focus = Number(strFocus[1]);
                focusable[1].focus = Number(strFocus[2]);
                focusable[2].focus = Number(strFocus[3]);
            } else {
                blocked = 1;
            }
            focusable[1].voteId = 387;focusable[2].voteId = 388;
            focused(focusable[blocked].focus, true);
            sortAndShow(1, []);
            sortAndShow(2, []);
            queryVoteResult(1);
            queryVoteResult(2);
        }
        function goBack(keyBack){
            if( blocked == focusable.length - 2) { if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
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
            if( blocked == 0 && focus <= 2)  return;
            //首页，返回
            if( blocked == focusable.length - 1 ) { goBack(); return;}
            if( blocked == focusable.length - 2 ) { $.vote(); return; }
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
                    focusable[focusable.length - 2].backed = blocked;
                    blocked = focusable.length - 2;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                    break;
                case -3:
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        var str = '';
                        for( var i = 0; i <= 3; i++) str += focusable[i].focus + ",";
                        url += encodeURIComponent('<%= request.getRequestURL().toString() %>?currFoucs=' + blocked + "," + str);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://去掉基本包检验 baseFlag=0
                    if( voteSwitch && blocked >= 1 && blocked <= 2 && focusable[blocked].focusVote ) {
                        $.vote.voted = $.vote.moreVote = false;
                        $.vote.current = {};
                        $.vote.current.id = focusable[blocked].voteId;
                        $.vote.current.message = typeof item.text == 'undefined' ? item.vote : item.text;
                        focusable[focusable.length - 2].backed = blocked;
                        blocked = focusable.length - 2;
                        focusable[blocked].focus = 0;
                        $.vote();
                        focused(0, true);
                    } else {
                        if ( item.mid == 0 ) return;
                        top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
                    }
                    break;
            }
        }

        var sortAndShow = function (index, results){
            var sortByCount = function( x, y ) {
                return (y.count + y.addon) - (x.count + x.addon);
            };
            for( var i = 0 ; i < results.length; i++ ) {
                var name = results[i].name;
                for( var j = 0; j < focusable[index].items.length ; j ++ ) {
                    if( name != focusable[index].items[j].text ) continue;
                    focusable[index].items[j].count = results[i].num;
                    break;
                }
            }
            var sortArray = focusable[index].items.concat([]);
            sortArray.sort(sortByCount);
            var html = "";
            for( var i = 0 ; i < 3 ; i++ ) {
                var item = sortArray[i];
                html += "<div class='rankingItem'>";
                html += "<div class='rankingName'>" + item.text + "</div>";
                html += "<div class='rankingTotal'>" + ( item.count + item.addon  ) + "</div>";
                html += "</div>";
            }
            $("ranking" +  index ).innerHTML = html;
        }
        function queryVoteResult(block){
            $.ajax('http://192.168.49.56:8989/VoteStatistics/getVoteInfo?classifyID=' + focusable[block].voteId,function(result){
                sortAndShow(block, result);
            });
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2016-12-31.jpg') no-repeat;" onUnload="exit();"></body>
</html>