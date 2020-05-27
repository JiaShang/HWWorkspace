<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000105833";

    //TODO:每次需要修改
    int focused = 0, block = 0, month = -1, day = -1;
    final int popItemMaxCharLength = 12;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<String> list = new ArrayList<String>();
    List<Column> columns = new ArrayList<Column>();
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
                month = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                day = Integer.parseInt(focus[1]);
            if( focus.length > 2 && focus[2] != null )
                block = Integer.parseInt(focus[2]);
            if( focus.length > 3 && focus[3] != null )
                focused = Integer.parseInt(focus[3]);
        }

        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        Column column = getDetailInfo(metaHelper, typeId, new Column() );
        if( column != null ) {
            for( int i = 0; i < 12; i ++ )
            {
                String picture = Utils.pictureUrl( "", column.getPosters(), "7", i, request);
                list.add( picture );
            }
        }
        columns = getTypeList(metaHelper,typeId,365,0);
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>2016暑期观影指南</title>
    <style>
        .absolute {position:absolute;overflow: hidden;}

        .calendar {width:682px;height:373px;left:66px;top:103px;background:transparent url('images/20160705/calendar.png') no-repeat 0px 0px; text-align: center;}
        .calendarContainer{width: 640px;height:330px;margin:55px auto 0px auto;}
        .month1 {width:181px;height:100px;left:354px;top:50px;background:transparent url('images/20160705/1.png') no-repeat 0px 0px; }
        .month2 {width:184px;height:96px;left:361px;top:50px;background:transparent url('images/20160705/2.png') no-repeat 0px 0px; }
        .month3 {width:150px;height:97px;left:362px;top:53px;background:transparent url('images/20160705/3.png') no-repeat 0px 0px; }
        .month4 {width:137px;height:99px;left:353px;top:49px;background:transparent url('images/20160705/4.png') no-repeat 0px 0px; }
        .month5 {width:122px;height:106px;left:356px;top:42px;background:transparent url('images/20160705/5.png') no-repeat 0px 0px; }
        .month6 {width:127px;height:98px;left:356px;top:49px;background:transparent url('images/20160705/6.png') no-repeat 0px 0px; }
        .month7 {width:114px;height:96px;left:363px;top:51px;background:transparent url('images/20160705/7.png') no-repeat 0px 0px; }
        .month8 {width:160px;height:98px;left:361px;top:50px;background:transparent url('images/20160705/8.png') no-repeat 0px 0px; }
        .month9 {width:203px;height:95px;left:357px;top:53px;background:transparent url('images/20160705/9.png') no-repeat 0px 0px; }
        .month10 {width:242px;height:100px;left:294px;top:50px;background:transparent url('images/20160705/10.png') no-repeat 0px 0px; }
        .month11 {width:237px;height:100px;left:323px;top:50px;background:transparent url('images/20160705/11.png') no-repeat 0px 0px; }
        .month12 {width:239px;height:100px;left:313px;top:50px;background:transparent url('images/20160705/12.png') no-repeat 0px 0px; }

        .circleContainer{width:180px;height:15px;left:660px;top:78px;clear:both;}
        .circle,.circleActive {width:30px;height:15px;float:left;}
        .circle{background:transparent url('images/20160705/circle.png') no-repeat center center;}
        .circleActive{background:transparent url('images/20160705/circleFocus.png') no-repeat center center;}

        .calendarItem{width:85px;height:60px;float:left;overflow: hidden;font-size:36px;font-weight: bold; text-align: center; color:#ffffff;margin:0px 2px 2px 2px;}
        .calendarItem div { margin:8px 0px 0px 0px;}
        .Normal {background:transparent url('images/20160705/calendarItemBg.png') no-repeat 0px -200px;}
        .Active {background:transparent url('images/20160705/calendarItemBg.png') no-repeat 0px 0px; color:#F19076;}
        .Hover {background:transparent url('images/20160705/calendarItemFocus.png') no-repeat 0px 0px;}

        .flowedItem,.flowedFocusItem {width:140px;height:189px;margin:0px 29px 0px 0px;background:transparent url('images/20160705/ItemBg.png') no-repeat 0px 0px; text-align: center;position:relative; overflow: hidden; float:left;}
        .flowedFocusItem{background:transparent url('images/20160705/itemFocusBg.png') no-repeat 0px 0px;}
        .flowedImg{width:118px;height:153px;top:8px;left:12px;position:absolute;}
        .flowedImg img{width:118px;height:153px;top:8px;left:12px;}
        .flowedText,.flowedFocusText{width:130px;height:22px;font-size:18px;left:5px;top:163px;color:#629C98; font-weight: bold;}
        .flowedFocusText {color:#ffffff;}
        .backNormal{position:absolute;width:251px;height:52px;left:1003px;top:629px;background:transparent url('images/mask-Template3.png') no-repeat -200px -400px;}

        .flowed {width:682px;height:189px;left:65px;top:484px;position:absolute;}

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
        var blocked = blocked ? blocked : <%= block %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;
        <%
            value = "";
            Collections.sort(columns, new Comparator<Column>() {
                public int compare(Column a, Column b) {
                    return a.getName().compareTo(b.getName());
                }
            });
            for( int i = 0; i < columns.size(); i++){
                Column column = columns.get(i);
                String[] da = column.getName().split("\\-");
                value += "{name:\"" + column.getName() + "\",id:\"" + column.getId() + "\",month:" + da[0] + ", day:" + da[1] + "},";
            }
            if( !StringUtils.isEmpty( value ) )  value = value.substring(0,value.length() - 1);
            out.println("var cols = [" + value + "];");
            value = "";
            for( int i = 0; i < 12; i++){
                String pic = list.get(i);
                value += "\"" + pic + "\",";
            }
            value = "var pictures = ["  + value.substring(0, value.length() - 1) + "];";
            out.println( value );
            if( list.size() > block ) value = list.get( month == -1 ? 0 : month );
        %>
        var currentMonth = <%= month%>;
        var currentDay = <%= day %>;
        var months = [];

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            { focus:0, items : []},{ focus:0, items : []},
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
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 4; rows = 1;              //定义行列，　几行几列
        var pageCount = columns * rows;
        var arrows = [0,1];                     //可以移动到首页返回按钮的光标键「下，右」
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
                    if( blocked == 1 && ( focus == 0 && index == -1 || index == -11 )) return;
                    if( blocked == 0 ) {
                        var day = cursors[focus];
                        var nextDay = undefined;
                        var nextFocus = undefined;
                        if( index == 1 || index == -1 ) {
                            nextFocus = focus + index;
                            if( nextFocus < 0 && index == -1 || index == 1 && nextFocus >= focusable[0].items.length )
                                return;
                            nextDay = focusable[0].items[nextFocus].day;
                            if( Math.floor( ( day - 1) / 7.0) != Math.floor( ( nextDay - 1 ) / 7.0) ) return;
                            $("day" + cursors[focus]).className = "calendarItem Active";
                            focus = nextFocus;
                        } else if( index == 11 || index == -11 ) {
                            nextDay = day + (index > 0 ? -7 : 7);
                            if( nextDay <= 0 && index == 11 || nextDay > totalDays && index == -11 ){
                                if(  currentMonth == 0 && index == 11 || currentMonth + 1 >= months.length && index == -11 ) return;
                                months[currentMonth].focus = focus;
                                currentMonth += index > 0 ? -1 : 1;
                                buildUserInterface();
                                focused(months[currentMonth].focus, true);
                                return;
                            } else {
                                var sub = 31; pre = 31;
                                if( index == 11 ){
                                    for( var i = focus; i >= -1 ; i-- ){
                                        if( i == -1 ){
                                            if( currentMonth == 0 ) return;
                                            currentMonth --;
                                            buildUserInterface();
                                            focused(months[currentMonth].focus, true);
                                            return;
                                        }
                                        var day = cursors[i];
                                        var sub = Math.abs( day - nextDay );
                                        if( sub == 0 ) {
                                            $("day" + cursors[focus]).className = "calendarItem Active";
                                            focus = i;
                                            break;
                                        }
                                        if( pre > sub ) pre = sub;
                                        else {
                                            $("day" + cursors[focus]).className = "calendarItem Active";
                                            focus = i + 1; break;
                                        }
                                    }
                                } else {
                                    for( var i = focus; i <= focusable[0].items.length ; i++ ){
                                        if( i == focusable[0].items.length ) {
                                            if( currentMonth + 1 >= months.length  ) return;
                                            currentMonth ++;
                                            buildUserInterface();
                                            focused(months[currentMonth].focus, true);
                                            return;
                                        }
                                        var day = cursors[i];
                                        var sub = Math.abs( nextDay - day );
                                        if( sub == 0 ) {
                                            $("day" + cursors[focus]).className = "calendarItem Active";
                                            focus = i;
                                            break;
                                        }
                                        if( pre > sub ) {
                                            pre = sub;
                                            if( i + 1 >= focusable[0].items.length && currentMonth + 1 >= months.length ){
                                                $("day" + cursors[focus]).className = "calendarItem Active";
                                                focus = i; break;
                                            }
                                        } else {
                                            $("day" + cursors[focus]).className = "calendarItem Active";
                                            focus = i - 1; break;
                                        }
                                    }
                                }
                            }
                        }

                    } else if( blocked == 1 ){
                        if( index == 1 || index == -1 ){
                            focus += index;
                            if( focus >= focusable[blocked].items.length ) { blocked = focusable.length -1 ; focus = 0;}
                        } else if( index == 11 ){
                            blocked = 0; focus = focusable[blocked].focus;
                        }
                    } else if( blocked == focusable.length - 1 ) { blocked = 1; focus = focusable[blocked].focus; }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            $("mask").style.visibility = (blocked == 0 || blocked == 1) ? "hidden" : "visible";
            if( blocked == 0 || initilized && blocked === 1 ) {
                var day = cursors[focusable[0].focus];
                $("day" + ( day ) ).className = "calendarItem Hover";
                if( typeof item == 'undefined' || typeof item.typeId == 'undefined' ) item = focusable[0].items[focusable[0].focus];
                loadVodContent(item.typeId);
                return;
            }
            for( var o in focusable.flowed ) flowedShow(focusable.flowed[o]);
            if(typeof item != 'undefined' && typeof item.style == 'string' ) $( "mask").className = item.style;
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
                html += "<div class='" + ( blocked == index && i == focus ? "flowedFocusItem" : "flowedItem") + "'><div class='flowedImg'><img src='" + item.picture + "' /></div>" ;
                html += "<div class='absolute " + ( blocked == index && i == focus ? "flowedFocusText" : "flowedText") + "'>" + ( blocked == index && item.text != item.shortText && i == focus ? ( "<marquee scrollamount='5'>" + item.text + "</marquee>" ) : item.shortText  ) + "</div>";
                html += "</div>";
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
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + currentMonth + "," + focusable[0].focus + "," + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "<div class='absolute calendar'><div id='calendar' class='calendarContainer'></div></div>";
                html += "<div id='month' class='absolute'></div>";
                html += "<div id='circleContainer' class='absolute circleContainer'></div>";
                html += "<div class='backNormal'></div>"
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div id='mask'></div>";
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
            $.buildUserInterface({flowed:[1],popup:undefined,vote:undefined,video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}
            initData();
            focused(<%= focused %>, true);
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
            //首页，返回
            if( blocked == 0 ) { blocked  = 1; flowedShow( 1); return;}
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
                        url += encodeURIComponent('<%= request.getRequestURL().toString() %>?currFoucs=' + blocked + "," + focusable[blocked].focus);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
                case "VOD_PREPAREPLAY_SUCCESS":$.video.start();break;
                case "EIS_VOD_PROGRAM_END":$.video.play();break;
            }
            return 	eventObj.args.type;
        }

        var currentDate = new Date();
        var totalDays = 0;
        var cursors = [];
        function loadVodContent(id) {
            var url = "/EPG/jsp/neirong/edu/v1/interface.jsp?id=" + id + "&tp=vod&max=<%= popItemMaxCharLength %>&pg=1&list=1";
            $.ajax( url, function( rst ){
                if( typeof focusable[1].focus == 'undefined' ) focusable[1].focus = 0;
                focusable[1].typeId = rst.typeId;
                focusable[1].length = rst.length;
                focusable[1].items = rst.items;
                flowedShow( 1 );
            });
        }
        function buildUserInterface(){
            focusable[0] = months[currentMonth];
            $("month").className = "absolute month" + months[currentMonth].month;
            var year = currentDate.getYear();
            var m = currentDate.getMonth();
            var date = new Date( year, m , 0);
            var eDate = new Date ( year + ( m == 11 ? 1 : 0), ( m == 11 ? 0 : m + 1), 0);
            totalDays = (eDate-date)/(24*60*60*1000);
            var html = "";
            for( var i = 0; i < totalDays; i ++ ){
                html += "<div id='day" +  ( i + 1 ) + "' class='calendarItem Normal' ><div>" + ( i + 1 ) + "</div></div>";
            }
            cursors = [];
            $("calendar").innerHTML = html;
            for( var i = 0; i < focusable[0].items.length; i++){
                var item = focusable[0].items[i];
                var id = 'day' + item.day;
                $( id ).className = "calendarItem Active";
                cursors[i] = item.day;
            }
            html = '';
            for( var i = 0; i < months.length ; i++ )
                html += "<div class='" + ( i == currentMonth ? "circleActive" : "circle") + "'></div>";
            $("circleContainer").innerHTML = html;
            document.body.style.backgroundImage = "url('" + pictures[currentMonth] + "')";
        }
        function initData(){
            var current = -1,m = 0, d = 0;
            for( var i = 0; i < cols.length; i ++){
                var c = cols[i];
                if( current != c.month ) {
                    if(current != -1)m ++;
                    current = c.month;
                    months[m] = {};
                    months[m].focus = 0;
                    months[m].month = c.month;
                    months[m].items = [];
                    d = 0;
                }
                months[m].items[d] = {};
                months[m].items[d].typeId = c.id;
                months[m].items[d].day = c.day;
                months[m].items[d].focus = 0;
                months[m].items[d].items = [];
                d ++;
            }
            if( currentMonth == -1 ) {
                var mon = currentDate.getMonth() + 1;
                for( var i = 0; i < months.length; i ++ ){
                    if( mon != months[i].month ) continue;
                    currentMonth = i;
                    break;
                }
            }
            if( currentDay == -1 ) currentDay = 0;
            buildUserInterface();
            focusable[0].focus = currentDay;
        };
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('<%= value %>') no-repeat;" onUnload="exit();"></body>
</html>