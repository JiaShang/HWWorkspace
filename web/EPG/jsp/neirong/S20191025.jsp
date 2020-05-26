<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    String typeId = "10000100000000090000000000113067";
    List<Column> columns = inner.getList(typeId, 5, 0 , new Column());

    Column column = null;
    if( columns != null && columns.size() > 2 ){

        column = columns.get(1);
        infos.add(new ColumnInfo(column.id, 0, 6));

        column = columns.get(0);
        infos.add(new ColumnInfo(column.id, 0, 2));

        columns.remove(0);
        columns.remove(0);
    }

    column = inner.getDetail(typeId,new Column());
    String body = "images/bg-2019-10-25.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-09-09.png') no-repeat;background-position: 0px 0px;}
        .flowed {width:1280px;height:133px;left:93px;top:515px;position:absolute;}

        .list{width:326px;height:340px;left:890px;top:235px;position:absolute;}
        .ItemContainer,.ItemContainerFocus{width:570px;height:53px;float:left;overflow: hidden;background-position: 0px 0px;}
        .ItemContainer {position:relative;}
        .ItemContainerFocus {background:transparent url('images/mask-2019-09-09.png') no-repeat;background-position:0px 0px;height:74px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;position:absolute;left:182px;}

        .ItemContainer .item,.ItemContainerFocus .item,.ItemContainer .item .marquee {width:290px;height:53px;line-height:52px;font-size: 20px;position:absolute;}
        .ItemContainer .item {color:white;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;left:20px;}
        .ItemContainerFocus .item {color:white;left:20px;line-height:52px;}
        .icon {position:absolute;left:0px;width:20px;height:53px;top:0px;background:transparent url('images/mask-2019-09-09.png') no-repeat;background-position: -840px -129px;}

        .mask1 {width:326px;height:53px;left:890px; background-position:0px 0px;}
        .mask11 {top:235px;}
        .mask12 {top:288px;}
        .mask13 {top:341px;}
        .mask14 {top:394px;}
        .mask15 {top:447px;}
        .mask16 {top:500px;}

        .mask2 {width:193px;height:193px;left:680px;}
        .mask21 {top:167px; background-position:0px -100px;}
        .mask22 {top:371px; background-position:0px -100px;}

        .mask3 {width:391px;height:104px;top:566px; background-position:-300px -150px;}
        .mask31 {left:51px;}
        .mask32 {left:445px;}
        .mask33 {left:839px;}

        .mask4 {width:58px;height:28px;left:1151px;top:197px; background-position:-600px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('<%=body%>') no-repeat;" onUnload="exit();">
<div style="position:absolute;z-index:0;width:2500px;height:45px;top:0px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="list" class="list"></div>
<div id="mask"></div>
<div id="flowed" class="flowed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
            String html = "";
            Result result = null;
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                html += ",\n";
            }
            result = new Result(typeId); result.setData(columns);
            html += inner.resultToString(result);
            out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.consigned = [<%=columns.size()%>];
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = 0;
                cursor.focusable[i].items = o["data"];
            }
            if( ! cursor.focusable[1].items[1] ) cursor.focusable[1].items[1] = {};
            cursor.focusable[1].items[0].linkto = '/EPG/jsp/neirong/S20191025Txt.jsp?typeId=10000100000000090000000000113068';
            cursor.focusable[1].items[1].linkto = '/EPG/jsp/neirong/S20191025Law.jsp';

            for( var i = 0;i < cursor.focusable[2].items.length; i ++ ){
                cursor.focusable[2].items[i].linkto = i != 2 ? ( "/EPG/jsp/neirong/S20191025Txt.jsp?typeId=" + cursor.focusable[2].items[i].id ) : '/EPG/jsp/neirong/S20191025Que.jsp';
            }
            cursor.focusable[3] = {
                focus : 0,
                items : [
                    {name : "头条(更多)", "linkto":"/EPG/jsp/neirong/S20191025Txt.jsp?typeId=" + cursor.focusable[0].typeId}
                ]
            };

            for( var i = 0; i < cursor.focusable.length; i ++) cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            cursor.consigned[0] = this.focused.length == 0 ? 0 : Number( this.focused[ this.focused.length - 1] );

            cursor.call('showItems');
            cursor.call('show');
            setTimeout(function(){cursor.call('lazyShow', true);}, 40);
            cursor.call('prepareVideo');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var previousFocus = focus;
            var items = cursor.focusable[blocked].items;

            if( blocked == 0 && index == 1 || blocked == 1 && ( index == -1 || index == 11 && focus <= 0 ) ||
                blocked == 2 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) ||
                blocked == 3 && (index != -11 && index != -1)
              ) return;

            if( blocked == 0 ) {
                if( index == 11 || index == -11 ) {
                    focus += index > 0 ? -1 : 1;
                    if( focus < 0 ) {  blocked = 3 ; focus = cursor.focusable[blocked].focus; }
                    if( focus >= items.length ) {
                       cursor.consigned[0] = 0; blocked = 2 ; focus = cursor.focusable[blocked].focus;
                    }
                } else {
                    blocked = 1;focus = cursor.focusable[blocked].focus;
                }
            } else if( blocked == 1) {
                if( index == -11 || index == 11  ) {
                    focus += index > 0 ? -1 : 1;
                    if( focus >= items.length ) {
                        cursor.consigned[0] = 1; blocked = 2 ; focus = cursor.focusable[blocked].focus;
                    }
                } else {
                    blocked = 0; focus = cursor.focusable[blocked].focus;
                }
            } else if( blocked == 2) {
                if( index == -1 || index == 1  ) {
                    focus += index;
                } else {
                    blocked = cursor.consigned[0]; focus = cursor.focusable[blocked].focus;
                }
            } else {
                blocked = index == -11 ? 0 : 1; focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            if( previous == 0 || blocked == 0 ) cursor.call('showItems');
            if( previous == 2 ) cursor.call('hiddenPicture', previousFocus);
            cursor.call('show');
        },
        lazyShow : function(init){
            var blocked = cursor.blocked;
            if( blocked != 0 ) return;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, 20, function(width){
                if( cursor.blocked != 0 || width <= 290 ) return;
                $('item' + String(focus + 1)).innerHTML  = '<marquee class="marquee" scrollamount="8">' + text + "</marquee>";
            });
            if( init ) return;
            cursor.call('prepareVideo');
        },
        showItems     :   function(){
            var blocked = 0;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;

            //每页显示数量
            var pageCount = 6;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '', id = '';
            var container = 'list';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='ItemContainer' id='txt" + ( i - flowCursorIndex + 1 ) + "'>";
                html += "<div class='icon'></div>";
				html += "<div class='item' id='item" +  String( i - flowCursorIndex + 1 ) + "'>" + item.name;
				html += "</div></div>";
            }
            $(container).innerHTML = html;
        },
        nextVideo   :   function () {
            var playIndex = cursor.focusable[0].focus;
            cursor.focusable[0].focus = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var focus = cursor.focusable[0].focus;
            if( cursor.focusable[0].items.length <= 0 )return;
            var item = cursor.focusable[0].items[focus];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            player.setPosition(58,176,611,379);
            if( typeof item === 'undefined' ) return;
            player.play({vodId:item.id});
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 0 ) {
                $("mask").className = 'mask ItemContainerFocus mask1 mask' + String(blocked + 1) + String( focus + 1 );
            } else {
                $("mask").className = 'mask mask' + String(blocked + 1) + " mask" + String(blocked + 1) + String( focus + 1 );
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>