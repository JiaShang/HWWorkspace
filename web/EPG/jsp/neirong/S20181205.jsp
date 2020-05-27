<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail("10000100000000090000000000110642",column);
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

        .left{width:433px;height:260px;left:94px;top:295px;position:absolute;overflow:hidden;}
        .right{width:619px;height:397px;left:600px;top:235px;position:absolute;overflow:hidden;}

        .cornerLT {width:6px;height:6px;left:0px;top:0px;background-position:-100px 0px}
        .cornerRT {width:6px;height:6px;top:0px;background-position:-782px 0px}
        .cornerLB {width:6px;height:6px;left:0px;background-position:-100px -402px}
        .cornerRB {width:6px;height:6px;background-position:-782px -402px}
        .leftBd {left:0px;top:6px;width:6px;background-position:-100px -6px; background-repeat: repeat-y;}
        .rightBd {top:6px;width:6px;background-position:-100px -6px; background-repeat: repeat-y;}
        .topBd {height:6px;left:6px;top:0px;background-position:-106px 0px; background-repeat: repeat-x;}
        .bottomBd {height:6px;left:6px;background-position:-106px 0px; background-repeat: repeat-x;}

        .container {width:433px;height:51px;float: left; position: relative;}
        .item {width:413px;position:absolute;left:20px;top:0px;font-size:22px;line-height:49px; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}

        .mask11,.mask12,.mask13,.mask14,.mask15{width:453px;height:55px;left:87px;top:292px;}
        .mask12{top:343px;}
        .mask13{top:394px;}
        .mask14{top:445px;}
        .mask15{top:496px;}


        .mask21 {width:418px;height:207px;left:594px;top:229px;}
        .mask22 {width:207px;height:201px;left:594px;top:439px;}
        .mask23 {width:207px;height:201px;left:804px;top:439px;}
        .mask24 {width:218px;height:409px;left:1006px;top:229px;}

        .item21 {width:406px;height:195px;left:0px;top:0px;position:absolute;}
        .item22 {width:195px;height:189px;left:0px;top:210px;position:absolute;}
        .item23 {width:195px;height:189px;left:210px;top:210px;position:absolute;}
        .item24 {width:202px;height:397px;left:415px;top:0px;position:absolute;}

        .mask31,.mask32 {width:252px;height:76px;top:564px;}
        .mask31{left:63px;}
        .mask32{left:310px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-12-05.jpg') no-repeat;" onUnload="exit();">
<div id="left" class="left"></div>
<div id="right" class="right"></div>
<div id="mask"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
            String html = "";
            Result result = inner.getVodList("10000100000000090000000000110647",0, 5 );
            html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
            result = inner.getTypeList("10000100000000090000000000110642",1, 4 );
            html += inner.resultToString(result);
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

            cursor.focusable[2] = { focus : this.focused.length > 2 ? Number( this.focused[ 2 + 1 ] ) : 0, items : [
                {name:'四十周年 四十部剧',linkto:'/EPG/jsp/neirong/S20181113.jsp?typeId=10000100000000090000000000107601'},
                {name:'四十周年 四十部电影',linkto:'/EPG/jsp/neirong/S20181114.jsp?typeId=10000100000000090000000000106222'}
            ]};

            cursor.call('show', 0);
            cursor.call('show', 1);
            if(cursor.blocked == 0) setTimeout(function(){cursor.call('lazyShow');},1000);
            if(cursor.blocked == 2)cursor.call('show', 2);
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked =  cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index == -1  || index == 11 && focus <= 0 ) ||
                blocked === 2 && ( index == -11 || index == -1 && focus <= 0 ) ||
                blocked === 1 && ( index == 11 && ( focus == 0 || focus == 3 ) || index == -11 && focus >= 1 || index == 1 && focus == 3 )
            ) return;

            if( blocked == 0 ) {
                if( index == 11 || index == -11 ) {
                    if( index == -11 && focus + 1 >= items.length ) {
                        blocked = 2; focus = cursor.focusable[blocked].focus;
                    } else
                        focus += index > 0 ? -1 : 1;
                } else if( index == 1 ) {
                    blocked = 1;
                    focus = focus <= 2 ? 0 : 1;
                }
            } else if( blocked == 1 ) {
                if( index == 1 ) {
                   if( focus == 0 ) focus = 3; else focus ++;
                } else if( index ==  -1 ) {
                    if( focus <= 1 ) { blocked = 0; focus = cursor.focusable[blocked].focus; }
                    focus = focus == items.length -1 ? 0 : 1;
                } else focus = index == 11 ? 0 : 1;
            } else {
                if( index == 11 ) {
                    blocked = 0; focus = cursor.focusable[blocked].items.length - 1;
                } else {
                    if( index == 1 && focus + 1 >= items.length ) {
                        blocked = 1; focus = 1;
                    } else {
                        focus += index;
                    }
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            if( blocked == 0 ) cursor.moveTimer = setTimeout(function(){ cursor.call('lazyShow');clearTimeout(cursor.moveTimer);}, 1500);
            if( blocked != previous ) cursor.call('show', previous );
            cursor.call('show', blocked );
        },
        lazyShow : function(){
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(blocked + 1) + String( focus + 1 );
            cursor.calcStringPixels(text, 22, function(width){
                if( width <= 413 || cursor.blocked != blocked ) return;
                $('item' + id).innerHTML = '<marquee class="marqueeItem" scrollamount="10">' + text + '</marquee>';
            });
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

            $("mask").innerHTML = '';
            $("mask").className = "mask mask" + (cursor.blocked + 1) + "" + ( focus + 1);
            if( cursor.blocked == blocked ) cursor.call('calcMask', {blocked : blocked , focus : focus } );
            if( cursor.blocked === 3 ) return;

            var html = '';
            var items = cursor.focusable[blocked].items;
            if( blocked == 0 ) {
                for( var i = 0; i < items.length; i ++ ) {
                    html += '<div class="container"><div class="item" id="item' + String(blocked + 1) + String(i + 1) + '">' + items[i].name + "</div></div>";
                }
                $("left").innerHTML = html;
            } else if( blocked == 1 ) {
                for( var i = 0; i < items.length; i ++ ) {
                    html += '<div class="item' + String(blocked + 1) + String(i + 1) + '"><img src="' + cursor.pictureUrl(items[i].posters,6,'images/defaultImg.png') + '" style="width:100%;height:100%"/></div>';
                }
                $("right").innerHTML = html;
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            if( blocked == 1 ) {
                var focus = cursor.focusable[blocked].focus;
                var item = cursor.focusable[blocked].items[focus];
                var url = '/EPG/jsp/neirong/S20181205List.jsp?typeId=' + item.id + "&pos=" + String(focus + 2);
                window.location.href = cursor.linkto(url);
                return;
            }
            cursor.call('selectAct');
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>