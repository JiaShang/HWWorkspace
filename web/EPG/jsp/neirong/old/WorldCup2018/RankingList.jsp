<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //积分榜，射手榜
    boolean isOfficial = !isEmpty(inner.get("official"));
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>积分榜，射手榜</title>
    <style>
        .groups {width:837px;height:31px;left:232px;top:157px;position:absolute;background: transparent url('images/RankingListMask.png') no-repeat -52px -15px;}
        .group {width:120px;height:40px;top:155px;position:absolute;background: transparent url('images/RankingListMask.png') no-repeat 0px -60px;}

        .group1 {left:195px;}
        .group2 {left:308px;}
        .group3 {left:420px;}
        .group4 {left:533px;}
        .group5 {left:645px;}
        .group6 {left:758px;}
        .group7 {left:870px;}
        .group8 {left:983px;}

        .rank {position:absolute;width:809px;height:290px;left:304px;top:317px;overflow: hidden;}
        .sorted {width:859px;height:376px;left:231px;top:258px;position: absolute;overflow: hidden;}
        .rank .item {width:809px;height:75px;}
        .sorted .item {width:859px;height:48px;}
        .rank .item div,.sorted .item div{float: left;text-align:left;color:white;font-size: 18px;height:24px;line-height: 22px;}
        .rank .item .flag,.sorted .item .flag{width:51px;}
        .rank .item .flag img,.sorted .item .flag img{width:34px;height:24px;}
        .rank .item .country,.sorted .item .country{width:150px;}
        .rank .item .session {width:88px;}
        .rank .item .win {width:48px;}
        .rank .item .tie {width:56px;}
        .rank .item .lost{width:82px;}
        .rank .item .score{width:88px;}
        .rank .item .fumble{width:98px;}
        .rank .item .netball{width:86px;}
        .rank .item .point{width:38px; text-align: center;}

        .sorted .item .sort{width:30px;text-align: center; line-height: 30px;height:30px;}
        .sort1 {background: transparent url("images/RankingListMask.png") no-repeat -300px -70px;}
        .sort2 {background: transparent url("images/RankingListMask.png") no-repeat -400px -70px;}
        .sorted .item .name{width:290px;text-align: center;}
        .sorted .item .country{width:190px;}
        .sorted .item .score{width:50px;}
        .sorted .item .ball{width:28px;height:23px;background: transparent url("images/RankingListMask.png") no-repeat -171px -70px;}

        .page,.count {width:29px;height:20px;position:absolute;left:1092px;top:282px;font-size:16px;text-align: center;color:black;}
        .count {top:310px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:transparent url("images/RankingList.jpg") no-repeat;' onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        focused     :   [<%= inner.getPreFoucs() %>],
        init:function(){
            var isOffice = <%= isOfficial ? "true" : "false" %>;
            cursor.backUrl='<%= backUrl %>';
            cursor.focused = this.focused;
            var url = !isOffice ? "ranking.js" : "http://192.168.89.23/worldCup/ranking.js";
            ajax( url, function( results ){
                var items = results.data;
                for( var i = 0; i < items.length; i ++ ) {
                    cursor.focusable[i] = {focus:0,items: items[i].items};
                    cursor.focusable[i].focus = cursor.focused.length > i + 1 ? Number( cursor.focused[ i + 1] ) : 0;
                }
                cursor.blocked = cursor.focused.length > 0 ? Number(cursor.focused[0]) : 0;
                cursor.call("show");
                cursor.call("visitedRecord");
            })
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'积分榜，射手榜',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("积分榜，射手榜") + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },
        showRanking : function( block ){
            document.body.style.backgroundImage = "url('images/RankingList.jpg')";
            var html = "<div class='groups'></div>";
            html += "<div class='group group" + (block + 1) +"'></div>";
            html += "<div class='rank'>";
            var items = cursor.focusable[block].items;
            for( var i = 0; i < items.length; i ++ ){
                var item = items[i];
                html += "<div class='item'>";
                html += "<div class='flag'><img src='images/" + item.abbr + ".png' /></div>";
                html += "<div class='country'>" + item.country + "</div>";
                html += "<div class='session'>" + item.session + "</div>";
                html += "<div class='win'>" + item.win + "</div>";
                html += "<div class='tie'>" + item.tie + "</div>";
                html += "<div class='lost'>" + item.lost + "</div>";
                html += "<div class='score'>" + item.score + "</div>";
                html += "<div class='fumble'>" + item.fumble + "</div>";
                html += "<div class='netball'>" + item.netball + "</div>";
                html += "<div class='point'>" + item.point + "</div>";
                html += "</div>";
            }
            html += "</div>";
            document.body.innerHTML = html;
        },
        showScoredIn : function( ) {

            document.body.style.backgroundImage = "url('images/RankingList-1.jpg')";

            var blocked = 8;
            var pageCount = 8;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            var ball = function( num ){
                var str = "";
                if( !num ) return str;
                for( var i = 0; i < num && i < 7; i ++ )
                    str += "<div class='ball'></div>";
                return str;
            };
            var html = "<div class='sorted'>";
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id = "item" + ( i + 1);
                html += "<div class='item'>";
                html += "<div class='sort sort" + ( i + 1) + "'>" + ( i + 1) + "</div>";
                html += "<div class='name'>" + item.name + "</div>";
                html += "<div class='flag'><img src='images/" + item.abbr + ".png' /></div>";
                html += "<div class='country'>" + item.country + "</div>";
                html += "<div class='score'>" + item.score + "</div>";
                html += ball(item.score);
                html += "</div>";
            }
            html += "</div>";
            html += "<div class='page'>" + Math.ceil((focus  +  1.0) / pageCount) + "</div>";
            html += "<div class='count'>" + Math.ceil(items.length  * 1.0 / pageCount) + "</div>";
            document.body.innerHTML = html;
        },
        move : function(index){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked <= 7 && index == 11 || index == -1 && (blocked <= 0 || blocked > 7 ) || index == 1 && blocked >= 7 ) return;
            if( blocked <= 7 ) {
                if(index == 1 || index == -1 ) {
                    blocked += index;
                } else {
                    cursor.focusable[cursor.focusable.length  - 1].from = blocked;
                    blocked = cursor.focusable.length  - 1; focus = 0;
                }
            } else {
                if( index == -11 && focus + 8 >= items.length ) return;
                if( index == 11 && focus - 8 < 0 ) {
                    blocked = cursor.focusable[blocked].from;
                    focus = 0;
                } else {
                    focus += index > 0 ? -8 : 8;
                }
            }

            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;

            cursor.call("show");
        },
        show : function (){
            var block = cursor.blocked;
            if( block <= 7 ) cursor.call("showRanking", block);
            else cursor.call("showScoredIn");
        }
    });
    -->
</script>
</html>