<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = "10000100000000090000000000110561";
    List<Column> columns = inner.getList(typeId,5,0,new Column());
    Result parent = new Result(typeId,columns);
    for( Column col : columns ) infos.add(new ColumnInfo(col.id,0,99));
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
        .bg {background:transparent url('images/mask-2018-11-19.png') no-repeat;background-position: 0px 0px;}
        .header {width:600px;height:109px;left:580px;top:58px;position:absolute;}
        .header .item {width:120px;height:109px;float:left;}
        .item1 {background-position: 0px -130px;}
        .item2 {background-position: -150px -130px;}
        .item3 {background-position: -300px -130px;}
        .item4 {background-position: -450px -130px;}
        .item5 {background-position: -600px -130px;}

        .focus1 {background-position: 0px 0px;}
        .focus2 {background-position: -150px 0px;}
        .focus3 {background-position: -300px 0px;}
        .focus4 {background-position: -450px 0px;}
        .focus5 {background-position: -600px 0px;}

        .after {width:534px;height:480px;position:absolute;left:590px;top:186px;overflow: hidden;}
        .after .item,.focus {width:534px;height:56px; background-position: 0px -310px;position:relative;}
        .container {position:absolute;width:500px;left:17px;top:0px;height:56px;font-size:22px;line-height: 56px;color:#4A4A4A;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .after .focus {background-position: 0px -250px;}
        .after .focus .container{color:white;}

        .page {width:23px;height:22px;left:1168px;position:absolute;color:#4A4A4A;font-size:20px;overflow: hidden;text-align: center;}
        .number {top:554px;}
        .count {top:590px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-11-19.jpg') no-repeat;" onUnload="exit();">
<div id="header" class="header"></div>
<div id="after" class="after"></div>
<div id="pageNum" class="page number">0</div>
<div id="pageCount" class="page count">0</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
            String html = "";
            html += inner.resultToString(parent, rmChars) + ",\n";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result, rmChars);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            cursor.moveTimer = undefined;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show', true);
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.focusable[0].focus + 1;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 && blocked <= 1 || index == 1 && blocked + 1 >= cursor.focusable.length || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length  ) return;
            if( index == 1 || index == -1 ) {
                blocked += index;
                cursor.focusable[0].focus = blocked - 1;
                focus = cursor.focusable[blocked].focus;
            } else {
                focus += index >= 0 ? -1 : 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show', index == -1 || index == 1 );
            cursor.call('show');
        },
        show : function( head ){
            var blocked = head ? 0 : (cursor.focusable[0].focus + 1);
            var focus = cursor.focusable[blocked].focus;

            var html = '';

            var pageCount = blocked == 0 ? 5 : 8;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            var prefix = blocked == 0 ? 'header' : 'txt';
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id = String(blocked + 1) + '' + String(i + 1);
                html += '<div class="bg item ' + ( i == focus ? 'focus' : 'item')  +  (blocked == 0 ? String( i + 1 ) : '') + '" id="' + prefix + id + '">';
                if( blocked != 0 ) html += '<div class="container">' + item.name + "</div>";
                html += '</div>';
            }
            $(blocked == 0 ? 'header' : "after").innerHTML = html;
            if( blocked != 0 ) {
                $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
                $("pageCount").innerHTML = Math.ceil( ( items.length * 1.0 ) / pageCount);
            }
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ cursor.call('lazyShow');clearTimeout(cursor.moveTimer);}, 1500);
        },
        lazyShow : function(){
            var blocked = cursor.focusable[0].focus + 1;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(blocked + 1) + String( focus + 1 );
            cursor.calcStringPixels(text, 22, function(width){
                if( width <= 500 || cursor.blocked != blocked ) return;
                $('txt' + id).innerHTML = '<marquee class="marqueeItem" scrollamount="10">' + text + '</marquee>';
            });
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>