<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000110841";
    infos.add(new ColumnInfo(typeId, 0, 99));
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
        .after {width:1134px;height:514px;position:absolute;left:115px;top:206px;overflow: hidden;}
        .container {width:274px;height:245px;float: left;position:relative;}
        .image {width:235px;height:132px;position:absolute;left:8px;top:0px;overflow: hidden;}
        .image img {width:100%;height:100%;border:none;}

        .text,.focus{width:251px;height:59px;position:absolute;left:0px;top:166px;overflow: hidden;background: transparent url("images/mask-2018-12-22-Video.png") no-repeat left top; background-position: 0px 0px;}
        .focus {background-position: 0px -80px;}
        .txt {width:235px;top:8px;left:8px;height:44px;position:absolute;overflow: hidden;text-align: center;font-size:22px;line-height:44px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .text .txt {color:black;}
        .focus .txt {color:white;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-12-22-Video.jpg') no-repeat;" onUnload="exit();">
<div id="after" class="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.moveTimer = undefined;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var row = 2;var column = 4;
            var pageCount = row * column;
            if( blocked == 0 ) {
                if( index == -1 ) {
                    if( focus % column == 0 ) {
                        if( focus <= column ) return;
                        focus -= column + 1;
                    } else focus -= 1;
                } else if( index == 1 ) {
                    if( focus % column == column - 1 ) {
                        if( Math.ceil( (focus + 1.0) / pageCount) * pageCount >= items.length ) return;
                        focus += column + 1;
                        if( focus >= items.length ) focus = items.length - 1;
                    } else if( focus + 1 >= items.length )
                        return;
                    else  focus += 1;
                } else if( index == 11 ) {
                    if( focus < column ) return;
                    focus -= column;
                } else if( index == -11 ){
                    if( focus + column >= items.length && Math.ceil( (focus + 1.0) / column) == Math.ceil( items.length * 1.0 / column)  )
                        return;
                    focus += column;
                    if( focus >= items.length ) focus = items.length - 1;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;

            var html = '';

            var pageCount = 8;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id = 'item' + String(i + 1) ;
                html += '<div class="container">';
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '" /></div>';
                html += '<div class="' + ( i == focus ? 'focus' : 'text') + '"><div class="txt">' + item.name + '</div></div>';
                html += '</div>';
            }
            $("after").innerHTML = html;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                var focus = cursor.focusable[cursor.blocked].focus;
                var item = cursor.focusable[cursor.blocked].items[focus];
                (function(id,value){
                    cursor.calcStringPixels(value, 22, function(width){
                        if( focus != cursor.focusable[cursor.blocked].focus || width < 235 ) return;
                        $(id).innerHTML = '<marquee class="marquee" scrollamount="10">' + value + "</marquee>";
                    });
                })('txt' + (focus + 1),item.name);
            }, 1500);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>