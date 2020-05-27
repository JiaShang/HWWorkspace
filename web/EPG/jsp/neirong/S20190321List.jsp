<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 199));
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
        .mask {width:262px;height:222px;position:absolute;background:transparent url('images/mask-2019-03-21.png') no-repeat;background-position: -700px 0px;}
        .item {width:228px;height:199px;overflow: hidden;position:relative; float:left;}
        .img {width:200px;height:160px;position:absolute;left: 0px;top:0px;background:transparent url('images/mask-2019-03-21.png') no-repeat;background-position: -1000px 0px;}
        .img img{width:100%;height:100%;}
        .after{width:1150px;height:400px;overflow: hidden;position:absolute;left:80px;top:250px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-03-21-List.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var row = 2;var column = 5;
    var pageCount = row * column;

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

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            //cursor.focusable[0].items.push({"name":"敬请期待"});
            cursor.call('show');
        },
        move        :   function(index){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

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

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var html = '';

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var picture = cursor.pictureUrl(item.posters,1,'');
                html += '<div class="item"><div class="img">' + ( picture.isEmpty() ? '' : ('<img src="' + picture + '" />')) + "</div></div>";
            }
            $("after").innerHTML = html;
            $("mask").className = 'mask';
            $("mask").style.left = String( focus % 5 * 228 + 49 ) + 'px';
            $("mask").style.top = String( ( Math.ceil( ( focus + 1 ) / 5.0 ) - 1 ) % 2 * 199 + 219 ) + 'px';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>