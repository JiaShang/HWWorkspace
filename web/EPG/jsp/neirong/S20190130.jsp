<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 10));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask11{width:384px;height:100px;left:686px;top:584px;background: transparent url("images/mask-2019-01-30.png") no-repeat left top;position:absolute;}
        .flowed {position:absolute;width: 460px;height: 243px;left: 650px;top: 325px;}
        .item,.focus {width:458px;height:60px;font-size: 18px;line-height:60px;color:#FEFBE1;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;text-align: left;}
        .focus {font-size:24px;color:#FAFF00;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/bg-2019-01-30.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;z-index:0;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="flowed" class="flowed"></div>
<div id="mask" style="visibility: hidden;" class="mask11"></div>
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
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o['id'];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o['data'];
            }
            cursor.focusable[1] = { focus : 0, items : [{'name':'幸福上新','linkto':'/EPG/jsp/neirong/S20190130-1.jsp?typeId=10000100000000090000000000111064'}]};
            cursor.call('show');
            cursor.call('playMovie');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( blocked == 1 && index != 11 || blocked == 0 && ( index == 1 || index == -1 || index == 11 && focus <= 0 )) return;
            if( blocked == 0 ) {
                focus += index > 0 ? -1 : 1;
                if( focus >= items.length  ) {
                    blocked = 1;focus = 0;
                }
            } else {
                blocked = 0; focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.call('playMovie');}, 1800);
            cursor.call('show');
        },
        playMovie   :   function(){
            if( cursor.currentPlay == cursor.focusable[0].focus ) return;
            cursor.currentPlay = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[cursor.focusable[0].focus];
            player.exit();
            player.play({
                position:{width:396,height:244,left:139,top:410},
                vodId : item.id,
                callback : function(){
                    cursor.calcStringPixels(item.name, 24, function(width){
                        if( width < 458 || cursor.blocked != 0 ) return;
                        $('item' + String(cursor.focusable[0].focus + 1)).innerHTML = '<marquee class="marqueeItem" scrollamount="8">' + item.name + '</marquee>';
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
        show        :   function(){
            var blocked  = cursor.blocked;
            $('mask').style.visibility = blocked == 1 ? 'visible' : 'hidden';
            var pageCount = 4;
            var focus = cursor.focusable[0].focus, items = null, html = '',cursorIndex = 0, length = 0;
            items = cursor.focusable[0].items;
            html = '';
            cursorIndex = Math.floor(focus / pageCount) * pageCount;
            length = items.length - cursorIndex >= pageCount ? pageCount : items.length - cursorIndex;
            for(var i = cursorIndex; i < cursorIndex + length; i += 1) {
                html += '<div id="item' + String( i + 1 ) + '" class="' + (blocked == 0 && i == focus ? 'focus' : 'item') + '">' + items[i].name + '</div>';
            }
            $("flowed").innerHTML = html;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>