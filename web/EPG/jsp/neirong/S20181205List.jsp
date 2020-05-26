<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId) ) typeId = "10000100000000090000000000110647";
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId, column);

    String pos = inner.get("pos","1");
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2018-12-05.png') no-repeat;background-position: 0px -600px; overflow: hidden;}
        .title{width:86px;height:51px;left:133px;top:233px;}
        .title1 {background-position: 0px 0px}
        .title2 {background-position: 0px -60px}
        .title3 {background-position: 0px -120px}
        .title4 {background-position: 0px -180px}
        .title5 {background-position: 0px -240px}

        .top {width:1280px;height:256px;left:0px;top:0px;position:absolute;background:transparent url('images/bg-2018-12-05-top.jpg') no-repeat left top;}
        .middle {width:1280px;height:379px;left:0px;top:255px;position:absolute;background:transparent url('images/bg-2018-12-05-middle.png') no-repeat left top;}
        .bottom {width:1280px;height:87px;left:0px;top:633px;position:absolute;background:transparent url('images/bg-2018-12-05-bottom.jpg') no-repeat left top;}

        .left{width:433px;height:320px;left:94px;top:302px;position:absolute;overflow:hidden;}

        .cornerLT {width:6px;height:6px;left:0px;top:0px;background-position:-100px 0px}
        .cornerRT {width:6px;height:6px;top:0px;background-position:-782px 0px}
        .cornerLB {width:6px;height:6px;left:0px;background-position:-100px -402px}
        .cornerRB {width:6px;height:6px;background-position:-782px -402px}
        .leftBd {left:0px;top:6px;width:6px;background-position:-100px -6px; background-repeat: repeat-y;}
        .rightBd {top:6px;width:6px;background-position:-100px -6px; background-repeat: repeat-y;}
        .topBd {height:6px;left:6px;top:0px;background-position:-106px 0px; background-repeat: repeat-x;}
        .bottomBd {height:6px;left:6px;background-position:-106px 0px; background-repeat: repeat-x;}

        .container {width:423px;height:62px;float: left; position: relative;}
        .item {width:403px;position:absolute;left:20px;top:0px;font-size:22px;line-height:60px; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}

        .mask11,.mask12,.mask13,.mask14,.mask15{width:443px;height:55px;left:87px;top:309px;}
        .mask12{top:370px;}
        .mask13{top:431px;}
        .mask14{top:491px;}
        .mask15{top:550px;}

        .playerBg {width:669px;height:377px;left:566px;top:256px;position:absolute;}

        .page {width:23px;height:22px;left:530px;position:absolute;color:white;font-size:18px;overflow: hidden;text-align: center;}
        .number {top:295px;}
        .count {top:318px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="playerBg" class="playerBg"></div>
<div class="top"></div><div class="middle"></div><div class="bottom"></div>
<div class="mask title title<%=pos%>"></div>
<div id="left" class="left"></div>
<div id="right" class="right"></div>
<div id="mask"></div>
<div id="pageNum" class="page number">0</div>
<div id="pageCount" class="page count">0</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
            String html = "";
            Result result = inner.getVodList(typeId,0, 99);
            html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
            out.write(html);
        %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
            setTimeout(function(){cursor.call('lazyShow');},1000);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked =  cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) ) return;
            focus += index > 0 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ cursor.call('lazyShow');clearTimeout(cursor.moveTimer);}, 1500);
            cursor.call('show');
        },
        prepareMedia : function(next){
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            if( next ) {
                focus += 1;
                if( focus >= cursor.focusable[blocked].items.length ) focus = 0;
                cursor.focusable[blocked].focus = focus;
            }
            var item = cursor.focusable[blocked].items[focus];
            player.exit();
            if( item.isSitcom == 1 ) {
                var picture = cursor.pictureUrl(item.posters, 6 , 'images/defaultImg.png');
                $("playerBg").innerHTML = "<img src='" + picture + "' style='width:100%;height:100%' />";
                $("playerBg").style.top = '256px';
                return;
            }
            $("playerBg").innerHTML = '';
            $("playerBg").style.top = '-600px';
            player.play( {
                position:{left:566,top:256,width:669,height:377},
                vodId: item.id
            });
            if(typeof next != 'undefined') cursor.call('show');
        },
        nextVideo : function ( ){
            if( cursor.moveTimer ) cursor.call('prepareMedia', true);
        },
        lazyShow : function(){
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(blocked + 1) + String( focus + 1 );
            if( cursor.played != id ){
                cursor.call('prepareMedia');
                cursor.calcStringPixels(text, 22, function(width){
                    if( width <= 403 || cursor.blocked != blocked ) return;
                    $('item' + id).innerHTML = '<marquee class="marqueeItem" scrollamount="10">' + text + '</marquee>';
                });
                cursor.played = id;
            };
        },
        calcMask : function( o ) {
            var blocked  = o.blocked;
            var focus = o.focus;
            var calc = function(){
                var element = $("mask");
                var height = element.clientHeight;
                var width = element.clientWidth;
                width -= 12;height -= 12;
                var html = '<div class="mask cornerLT"></div>';
                html += '<div class="mask cornerRT" style="left:' + String( width + 6) + 'px"></div>';
                html += '<div class="mask cornerLB" style="top:' + String(height + 6) + 'px"></div>';
                html += '<div class="mask cornerRB" style="left:' + String( width + 6) + 'px;top:' + String(height + 6) + 'px"></div>';
                html += '<div class="mask leftBd" style="height:' + String(height) + 'px"></div>';
                html += '<div class="mask rightBd" style="left:' + String( width + 6) + 'px;height:' + String(height) + 'px"></div>';
                html += '<div class="mask topBd" style="width:' + String(width) + 'px"></div>';
                html += '<div class="mask bottomBd" style="width:' + String(width) + 'px;top:' + String(height + 6) + 'px"></div>';
                element.innerHTML = html;
            };
            setTimeout( calc, 50);
        },
        show        :   function( block ){
            var blocked = typeof block === 'undefined' ? cursor.blocked : block;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var pageCount = 5;
            var defaultIndex = Math.floor(pageCount / 2.0);

            var flowCursorIndex = focus < defaultIndex ? 0 : focus - defaultIndex;
            if( flowCursorIndex + pageCount >= items.length ) flowCursorIndex = items.length - pageCount;
            if( flowCursorIndex < 0 ) flowCursorIndex = 0;

            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                if( i === focus ) {
                    $("mask").className = "mask mask" + (cursor.blocked + 1) + "" + ( i - flowCursorIndex  + 1);
                    cursor.call('calcMask', {blocked : blocked , focus : focus } );
                }
                html += '<div class="container"><div class="item" id="item' + String(blocked + 1) + String(i + 1) + '">' + items[i].name + "</div></div>";
            }
            $("left").innerHTML = html;
            $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
            $("pageCount").innerHTML = Math.ceil( ( items.length * 1.0 ) / pageCount);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>