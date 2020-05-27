<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = "10000100000000090000000000111165";
    infos.add(new ColumnInfo("10000100000000090000000000111166", 0, 5));
    infos.add(new ColumnInfo("10000100000000090000000000111167", 0, 4));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    
    String bodyLeft = "images/bg-2019-02-26-left.jpg",
           bodyTop = "images/bg-2019-02-26-top.jpg",
           bodyRight = "images/bg-2019-02-26-right.jpg",
           bodyBottom = "images/bg-2019-02-26-bottom.jpg";

    if( column != null ) {
        bodyTop = inner.pictureUrl(bodyTop, column.getPosters(), "7",0 );
        bodyLeft = inner.pictureUrl(bodyLeft, column.getPosters(), "7",1 );
        bodyRight = inner.pictureUrl(bodyRight, column.getPosters(), "7",2 );
        bodyBottom = inner.pictureUrl(bodyBottom, column.getPosters(), "7",3 );
    }
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .bodyTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:198px;}
        .bodyLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:197px;width:57px;height:265px;}
        .bodyRight {position: absolute;z-index:0;overflow: hidden; left:522px;top:197px;width:758px;height:265px;}
        .bodyBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:459px;width:1280px;height:261px;}

        .flowed {position:absolute;width: 380px;height: 194px;left: 584px;top: 256px;}
        .flowed .item{width:360px;height:38px;font-size: 18px;line-height:16px;color:black;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;text-align: left;}

        .flowed1 {position:absolute;width: 1200px;height:175px;left: 57px;top: 485px; overflow: hidden;}
        .flowed1 .item{width:295px;height:175px; float: left;}
        .flowed1 .item img{width:281px;height:175px;}

        .flowed3 {position:absolute;width: 1200px;height:175px;left: 57px;top: 485px; overflow: hidden;}
        .more { position:absolute;width:231px;height:262px;left:992px;top:197px;overflow: hidden; }
        .bodyTop img,.bodyLeft img,.bodyRight img,.bodyBottom img, .more img{width:100%;height:100%;}

        .mask {background: transparent url("images/mask-2019-02-26.png") no-repeat left top;position:absolute;}
        .mask1{width:416px;height:53px;left:549px;top:238px;background-position:-300px -200px;}
        .mask2{width:301px;height:195px;left:932px;top:475px;background-position:-300px 0px;}
        .mask3{width:252px;height:284px;left:982px;top:186px;background-position:0px 0px;}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;z-index:0;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div class='bodyTop'><img src="<%=bodyTop%>"/></div><div class='bodyLeft'><img src="<%=bodyLeft%>"/></div><div class='bodyRight'><img src="<%=bodyRight%>"/></div><div class='bodyBottom'><img src="<%=bodyBottom%>"/></div>
    <div class='split'></div>
    <div class='flowed' id='flowed'></div>
    <div class='more' id='more'></div>
    <div class='flowed1' id='flowed1'></div>
    <div id="mask"></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    html += ",\n";
                }
                List<Column> columns = new ArrayList<Column>();
                columns.add(inner.getDetail("10000100000000090000000000111168", new Column()));
                Result result = new Result("10000100000000090000000000111168", columns);
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
                cursor.focusable[i].typeId = -1;
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o['data'];
            }
            cursor.focusable[2].items[0].linkto = '/EPG/jsp/neirong/S20190226More.jsp';
            cursor.call('show' , true);
            cursor.call('playMovie');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( blocked == 0 && (index == -1 || index == 11 && focus <= 0 ) ||
                blocked == 1 && (index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) ||
                blocked == 2 && (index == 11 || index == 1 )
             ) return;

            if( blocked == 2 ) {
                blocked = index == -1 ? 0 : 1;
                focus = blocked == 1 ? 3 : cursor.focusable[blocked].focus;
            } else if( blocked == 0 ) {
                if ( index == 1 ) focus = cursor.focusable[blocked = 2].focus;
                else if( index == 11 ) focus -= 1;
                else {
                    if( focus + 1 >= items.length ) {
                        blocked = 1; focus = cursor.focusable[blocked].focus;
                    } else focus += 1;
                }
            } else {
                if( index == 11 ) {
                    blocked = focus + 1 == items.length ? 2 : 0;
                    focus = cursor.focusable[blocked].focus;
                } else
                    focus += index;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.call('playMovie');}, 1500);
            cursor.call('show');
        },
        playMovie   :   function(){
            if( cursor.currentPlay == cursor.focusable[0].focus ) return;
            cursor.currentPlay = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[cursor.focusable[0].focus];
            player.exit();
            player.play({
                position:{width:465,height:261,left:57,top:198},
                vodId : item.id,
                callback : function(){
                    cursor.calcStringPixels(item.name, 24, function(width){
                        if( width < 360 || cursor.blocked != 0 ) return;
                        $('item1' + String(cursor.focusable[0].focus + 1)).innerHTML = '<marquee class="marqueeItem" scrollamount="8">' + item.name + '</marquee>';
                    });
                }
            });
        },
        nextVideo   :   function () {
            cursor.focusable[0].focus += 1;
            if( cursor.focusable[0].focus >= cursor.focusable[0].items.length ) cursor.focusable[0].focus = 0;
            cursor.call('show');
            cursor.call('playMovie');
        },
        show        :   function( init ){
            var blocked  = cursor.blocked;
            var pageCount = 5;
            var focus = cursor.focusable[0].focus, items = null, html = '',cursorIndex = 0, length = 0;
            if( init || blocked == 0 ) {
                items = cursor.focusable[0].items;
                html = '';
                cursorIndex = Math.floor(focus / pageCount) * pageCount;
                length = items.length - cursorIndex >= pageCount ? pageCount : items.length - cursorIndex;
                for(var i = cursorIndex; i < cursorIndex + length; i += 1) {
                    html += '<div id="item1' + String( i + 1 ) + '" class="item">' + items[i].name + '</div>';
                }
                $("flowed").innerHTML = html;
            }
            if( init ) {
                html = '';
                items = cursor.focusable[1].items;
                for( var i = 0; i < items.length; i ++ ) {
                    html += '<div id="item2' + String( i + 1 ) + '" class="item"><img src="' + cursor.pictureUrl(items[i].posters,0,'images/defaultImg.png') + '" /></div>';
                }
                $("flowed1").innerHTML = html;
            }
            if( init ) {
                $("more").innerHTML = '<img src="' +  cursor.pictureUrl(cursor.focusable[2].items[0].posters,0,'images/defaultImg.png')  + '" />';
            }
            var focus = cursor.focusable[blocked].focus;
            var left = '', top= '';
            switch (blocked ) {
                case 0: left = '549';top = String( focus % 5 * 38 + 236 ); break;
                case 1: left = String( focus % 4 * 295 + 46 ); top = '475'; break;
                case 2: left = '982'; top = '186';break;
            }
            $("mask").className = "mask mask" + String(blocked + 1);
            $("mask").style.top = top != '' ? (top + 'px') : '';
            $("mask").style.left = left != '' ? (left + 'px') : '';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>