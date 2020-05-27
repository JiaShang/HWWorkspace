<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //冠军之路
    boolean isOfficial = !isEmpty(inner.get("official"));
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>冠军之路</title>
    <style>
        .groups {width:1100px;height:413px;left:113px;top:202px;position:absolute;overflow: hidden;}
        .split {width:540px;height:413px;position:relative;overflow: hidden;float:left;}
        .title {width:540px;height:75px;position:relative;overflow: hidden;}
        .title .name {width:100px;height:30px;position:relative;float:left;top:10px;left:10px}
        .title .name .icon {width:45px;height:30px;position:relative;background: transparent url("images/TourChampionMask.png") no-repeat 0px 0px;left:20px;}
        .title .name .icon1 {background-position:0px 0px;}
        .title .name .icon2 {background-position:-50px 0px;}
        .title .name .icon3 {background-position:-100px 0px;}
        .title .name .icon4 {background-position:-150px 0px;}
        .title .name .icon5 {background-position:-200px 0px;}
        .title .name .icon6 {background-position:-250px 0px;}
        .title .name .icon7 {background-position:-300px 0px;}
        .title .name .icon8 {background-position:-350px 0px;}
        .title .flags {width:221px;height:24px;position:relative;left:280px;float:left;top:15px;}
        .title .flags .flag {width:55px;height:24px;float:left;}
        .title .flags .flag img{width:35px;height:24px;}

        .content {width:540px;height:340px;position:relative;}
        .content .item,.content .itemFocus{width:540px;height:56px;position:relative;}
        .content .item div,.content .itemFocus div {height:34px;font-size:18px;line-height:34px; color:white;float:left;position:relative;}
        .content .itemFocus div {color:#F8E26E}
        .content .item .time,.content .itemFocus .time{width:135px;left:20px;overflow: hidden;}
        .content .item .camera,.content .itemFocus .camera{width:20px;background-position: -500px 0px;}
        .content .itemFocus .camera{background: transparent url("images/TourChampionMask.png") no-repeat left top;background-position: -450px -0px;}
        .content .item .compete,.content .itemFocus .compete{left:30px;width:215px;text-align: left;overflow: hidden;}
        .content .item .point1,.content .itemFocus .point1{left:13px;width:20px;text-align: center;}
        .content .item .point2,.content .itemFocus .point2{left:6px;width:20px;text-align: center;}
        .maskGroup {position:absolute;width:497px;height:67px;left:300px;top:20px;overflow: hidden;background: transparent url("images/TourChampionMask.png") no-repeat -20px -50px;}

        .group {width:126px;position:absolute;background:transparent url("images/TourChampionMask1.png") no-repeat 0px -200px; background-position:0px -200px;overflow: hidden;}
        .group1,.group1Focus {height:117px;left:66px;top:173px;background-position:0px -200px;}
        .group2,.group2Focus {height:117px;left:66px;top:297px;background-position:0px -200px;}
        .group3,.group3Focus {height:117px;left:1097px;top:173px;background-position:0px -200px;}
        .group4,.group4Focus {height:117px;left:1097px;top:297px;background-position:0px -200px;}
        .group5,.group5Focus {height:117px;left:66px;top:422px;background-position:0px -200px;}
        .group6,.group6Focus {height:117px;left:66px;top:550px;background-position:0px -200px;}
        .group7,.group7Focus {height:117px;left:1097px;top:424px;background-position:0px -200px;}
        .group8,.group8Focus {height:117px;left:1097px;top:551px;background-position:0px -200px;}
        .group9,.group9Focus {height:180px;left:212px;top:205px;background-position:0px -200px;}
        .group10,.group10Focus {height:180px;left:212px;top:458px;background-position:0px -200px;}
        .group11,.group11Focus {height:180px;left:951px;top:205px;background-position:0px -200px;}
        .group12,.group12Focus {height:180px;left:951px;top:458px;background-position:0px -200px;}
        .group13,.group13Focus {height:311px;left:362px;top:271px;background-position:0px -200px;}
        .group14,.group14Focus {height:311px;left:802px;top:271px;background-position:0px -200px;}
        .group15,.group15Focus {width:279px;height:98px;left:505px;top:460px;background-position:0px -200px;}
        .group16,.group16Focus {width:279px;height:98px;left:505px;top:357px;background-position:0px -200px;}
        
        .group1Focus,.group2Focus,.group5Focus,.group6Focus{background-position:0px 0px;}
        .group3Focus,.group4Focus,.group7Focus,.group8Focus{background-position:-140px 0px;}
        .group9Focus,.group10Focus {background-position:-280px 0px;}
        .group11Focus,.group12Focus {background-position:-420px 0px;}
        .group13Focus{background-position:-560px 0px;}
        .group14Focus{background-position:-700px 0px;}
        .group15Focus,.group16Focus {background-position:-280px -200px;}

        .group div {width:100px;height:25PX;left:15px;top:10px;color:white;font-size:13px;line-height:25px;position:absolute; text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;}
        .group .title1 {top:18px;}
        .group .time {top:48px;}
        .group .title2 {top:75px;}

        .group9 .title1,.group9Focus .title1,.group10 .title1,.group10Focus .title1,.group11 .title1,.group11Focus .title1,.group12 .title1,.group12Focus .title1{top:60px;}
        .group9 .time,.group9Focus .time,.group10 .time,.group10Focus .time,.group11 .time,.group11Focus .time,.group12 .time,.group12Focus .time{top:92px;}
        .group9 .title2,.group9Focus .title2,.group10 .title2,.group10Focus .title2,.group11 .title2,.group11Focus .title2,.group12 .title2,.group12Focus .title2{top:122px;}

        .group13 .title1,.group13Focus .title1,.group14 .title1,.group14Focus .title1{top:100px;}
        .group13 .time,.group13Focus .time,.group14 .time,.group14Focus .time{top:155px;}
        .group13 .title2,.group13Focus .title2,.group14 .title2,.group14Focus .title2{top:210px;}

        .group15 .title1,.group15Focus .title1,.group16 .title1,.group16Focus .title1{width:260px;top:20px;}
        .group15 .time,.group15Focus .time,.group16 .time,.group16Focus .time{width:260px;top:55px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/TourChampion.jpg') no-repeat;" onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        focused     :   [<%= inner.getPreFoucs() %>],
        init:function(){
            var isOffice = <%= isOfficial ? "true" : "false" %>;
            cursor.focused = this.focused;
            cursor.backUrl='<%= backUrl %>';
            var url = !isOffice ? "champion.js" : "http://192.168.89.23/worldCup/champion.js";
            var date = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            cursor.groupIsFirst = date < "2018-06-30 08:00:00";
            ajax( url, function( results ){
                var items = results.data;
                for( var i = 0; i < items.length; i ++ ) {
                    cursor.focusable.push(items[i]);
                    cursor.focusable[i].focus = cursor.focused.length > i + 1 ? Number( cursor.focused[ i + 1] ) : 0;
                }
                var lasts = [
                    {"time":"2018年06月30日22:00","compete":"1C:2D","vodId":null,"score": "- -"},
                    {"time":"2018年07月01日02:00","compete":"1A:2B","vodId":null,"score": "- -"},
                    {"time":"2018年07月01日22:00","compete":"1B:2A","vodId":null,"score": "- -"},
                    {"time":"2018年07月02日02:00","compete":"1D:2C","vodId":null,"score": "- -"},
                    {"time":"2018年07月02日22:00","compete":"1E:2F","vodId":null,"score": "- -"},
                    {"time":"2018年07月03日02:00","compete":"1G:2H","vodId":null,"score": "- -"},
                    {"time":"2018年07月03日22:00","compete":"1F:2E","vodId":null,"score": "- -"},
                    {"time":"2018年07月04日02:00","compete":"1H:2G","vodId":null,"score": "- -"},
                    {"time":"2018年07月06日22:00","compete":"1/4决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月07日02:00","compete":"1/4决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月07日22:00","compete":"1/4决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月08日02:00","compete":"1/4决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月11日02:00","compete":"1/2决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月12日02:00","compete":"1/2决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月14日22:00","compete":"3/4决赛","vodId":null,"score": "- -"},
                    {"time":"2018年07月15日23:00","compete":"总决赛","vodId":null,"score": "- -"}
                ];
                if( cursor.focusable.length > 8 ) {
                    for( var i = cursor.focusable[8].items.length; i < 16; i ++ )
                        cursor.focusable[8].items.push(lasts[i]);
                }
                cursor.blocked = cursor.focused.length > 0 ? Number(cursor.focused[0]) : (cursor.groupIsFirst ? 0 : cursor.focusable.length - 1);
                cursor.call(cursor.groupIsFirst ? "showGroups" : "showChampion", cursor.blocked);
            });
            cursor.call("visitedRecord");
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'冠军之路',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("冠军之路") + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },
        showGroups : function( block ){
            document.body.style.backgroundImage = "url('images/TourChampion.jpg')";
            var html = "";
            block = block || cursor.blocked;
            html = "<div class='groups'>";
            var flags = function ( item ) {
                var teams = item.teams;
                var str = "<div class='flags'>";
                for( var i = 0; i < teams.length; i ++ ){
                    var team = teams[i];
                    str += "<div class='flag'>";
                    str += "<img src='images/" + team.abbr  + ".png' />";
                    str += "</div>"
                }
                str += "</div>";
                return str;
            };
            var buildHtml = function(index){
                var group = cursor.focusable[index];
                var str = "<div class='split'><div class='title'>";
                str += "<div class='name'><div class='icon icon" + (index + 1) + "'></div></div>";
                str += flags(group);
                str += "</div><div class='content'> ";
                var items = group.items;
                for( var i = 0 ; i < items.length; i ++ ){
                    var item = items[i];
                    var id = String(index + 1) + String( i + 1);
                    str += "<div class='item' id='item" + id + "'>";
                    str += "<div class='time'>" + item.time.replace("2018年","") + "</div>";
                    str += "<div class='camera'></div>";
                    str += "<div class='compete'>" + item.compete.replace(":", " VS ") + "</div>";
                    var points = item.score.split(" ");
                    str += "<div class='point1'>" + points[0] + "</div>";
                    str += "<div class='point2'>" + points[1] + "</div>";
                    str += "</div>";
                }
                str += "</div></div>";
                return str;
            };

            var start = block - block % 2;
            html += buildHtml( start) + buildHtml( start + 1 );
            html += "</div>";
            html += "<div id='mask'></div>";
            document.body.innerHTML = html;
            setTimeout(function(){cursor.call("show");},50);
        },
        showChampion : function( ) {
            document.body.style.backgroundImage = "url('images/TourChampion-1.jpg')";
            var html = "";
            var focus = cursor.focusable[cursor.focusable.length - 1].focus;
            var items = cursor.focusable[cursor.focusable.length - 1].items;
            for( var i = 0; i < items.length; i ++ ) {
                var item = items[i];
                if( i >= 14 ) item.compete = item.compete.replace(':', " VS ");
                var teams = item.compete.split(':');
                var time = item.time.replace("2018年0","");
                html += "<div class='group group" + ( i + 1) + "' id='group" + ( i + 1) + "'>";
                html += "<div class='title1'>" + teams[0] + "</div>";
                html += "<div class='time'>" + time + "</div>";
                if(teams.length > 1)html += "<div class='title2'>" + teams[1] + "</div>";
                html += "</div>";
            }
            document.body.innerHTML = html;
            cursor.call("showChampionFocus");
        },
        move : function(index){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var lastBlock = blocked;
            var lastFocus = focus;
            if( blocked < cursor.focusable.length -1) {
                if( index == -1 && blocked % 2 == 0 || index == 1 && blocked % 2 == 1 || cursor.groupIsFirst && index == 11 && blocked <= 1 && focus == 0 ) return;
                if( index == 1 || index == -1 ) {
                    blocked += index;
                } else if( index == 11 || index == -11 ){
                    if(!cursor.groupIsFirst && index == 11 && blocked <= 1 && focus == 0) {
                        cursor.focusable[cursor.focusable.length - 1].from = blocked;
                        cursor.blocked = blocked = cursor.focusable.length - 1;
                        focus = cursor.focusable[blocked].focus;
                    } else {
                        focus += index > 0 ? -1 : 1;
                        if( focus >= items.length ) {
                            blocked = blocked += 2;
                            if( blocked >= cursor.focusable.length - 1 )
                            {
                                if(!cursor.groupIsFirst) return;
                                cursor.focusable[cursor.focusable.length - 1].from = blocked - 2;
                                blocked = cursor.focusable.length - 1;
                                cursor.call("showChampion");
                            }
                            focus = 0;
                        } else if( focus < 0 ) {
                            blocked -= 2;
                            focus = items.length - 1;
                        }
                    }
                }
            } else {
                if( !cursor.groupIsFirst && index == 11 && (  focus == 0 || focus == 8 || focus == 10 || index == 2 || focus >= 12 && focus != 14 ) || index == -1 && (focus == 0 || focus == 1 || focus == 4 || focus == 5 ) || index == 1 && ( focus == 2 || focus == 3 || focus == 6 || focus == 7 ) || cursor.groupIsFirst && index == -11 && ( focus == 5 || focus == 7 || focus == 9 || focus >= 11 && focus != 15 )) return;
                $("group" + (focus + 1)).className = "group group" + (focus + 1);
                $("group" + (focus + 1)).style.color = "white";
                if( index == 11 ) {
                    if( cursor.groupIsFirst &&  ( focus == 0 || focus == 8 || focus == 10 || index == 2 || focus >= 12 && focus != 14 )) {
                        cursor.blocked = blocked = cursor.focusable[cursor.focusable.length - 1].from || cursor.focusable.length - 2;
                        focus = cursor.focusable[cursor.blocked].focus;
                    } else if(focus == 14 ){
                        focus = 15;
                    } else {
                        focus += (focus == 4 || focus == 6 ) ? -3 : -1;
                    }
                } else if( index == -11 ) {
                    if( !cursor.groupIsFirst && ( focus == 5 || focus == 7 || focus == 9 || focus >= 12 && focus != 15 ) ) {
                        cursor.blocked = blocked = cursor.focusable[cursor.focusable.length - 1].from || 0;
                        focus = cursor.focusable[cursor.blocked].focus;
                    } else if(focus == 15 ) {
                        focus = 14;
                    } else {
                        focus += (focus == 1 || focus == 3) ? 3 : 1;
                    }
                } else if( index == 1 ) {
                    if( focus == 0 || focus == 1 ) focus = 8;
                    else if( focus == 4 || focus == 5 ) focus = 9;
                    else if( focus == 8 || focus == 9 ) focus = 12;
                    else if( focus == 12 ) focus = 15;
                    else if( focus == 14 || focus == 15 ) focus = 13;
                    else if( focus == 13 ) focus = 10;
                    else if( focus == 10 ) focus = 2;
                    else if( focus == 11 ) focus = 6;
                } else if( index == -1 ) {
                    if( focus == 2 || focus == 3 ) focus = 10;
                    else if( focus == 6 || focus == 7 ) focus = 11;
                    else if( focus == 10 || focus == 11 ) focus = 13;
                    else if( focus == 13 ) focus = 15;
                    else if( focus == 14 || focus == 15 ) focus = 12;
                    else if( focus == 12 ) focus = 8;
                    else if( focus == 8 ) focus = 0;
                    else if( focus == 9 ) focus = 4;
                }
                cursor.call( lastBlock == blocked ? "showChampionFocus" : "showGroups");
            }

            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;

            if( blocked == cursor.focusable.length - 1 && lastBlock != blocked ) {
                cursor.call("showChampion"); return;
            } else if( Math.floor(lastBlock / 2.0) != Math.floor(blocked / 2.0)){
                cursor.call("showGroups", blocked); return;
            }
            if( blocked < cursor.focusable.length - 1 )
                $("item" + String(lastBlock + 1 ) + String(lastFocus + 1)).className = "item";

            cursor.call("show");
        },
        showChampionFocus : function(){
            setTimeout(function(){
                if(cursor.blocked == cursor.focusable.length - 1 ) {
                    var focus = cursor.focusable[cursor.blocked].focus;
                    var item = cursor.focusable[cursor.blocked].items[focus];
                    $("group" + (focus + 1)).className = "group group" + (focus + 1) + "Focus";
                    if( item.vodId != null) $("group" + (focus + 1)).style.color = "#F8E26E";
                }
            },1);
        },
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];
            if( item.vodId == null) return;
            if( iPanel.eventFrame.systemId == 2 ) {
                var url = "http://192.168.14.156:8082/EPG/jsp/defaultHD/en/getContentId.jsp?vodId=" + item.vodId;
                iPanel.debug("COMMONJS -> " + url);
                ajax( url , function( results ){
                    iPanel.debug("COMMONJS -> " + results);
                });
            } else {
                var url = cursor.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=-1&playType=1&progId=" + item.vodId +"&contentType=0&startTime=0&business=1&idType=FSN";
                window.location.href = url;
            }
        },
        show : function (){
            var block = cursor.blocked;
            if( block <= 7 ) {
                var focus = cursor.focusable[block].focus;
                $("mask").className = "maskGroup";
                $("mask").style.left = (block % 2 == 0 ? "117" : "660") + "px";
                $("mask").style.top = (focus * 56 + 263) + "px";
                var item = cursor.focusable[block].items[focus];
                if( item.vodId != null) {
                    $("item" + String(block + 1 ) + String(focus + 1)).className = "itemFocus";
                }
            }
        }
    });
    -->
</script>
</html>