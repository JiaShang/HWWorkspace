<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = "10000100000000090000000000107561";
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
        .mask {position:absolute;background:transparent url('images/mask-2018-09-14.png') no-repeat;background-position: 0px 0px;}

        .icon {width:165px;height:75px;left:80px;}
        .cursor1 {top:281px;background-position:0px 0px;}
        .cursor2 {top:362px;background-position:0px -81px;}
        .cursor3 {top:446px;background-position:0px -165px;}
        .cursor4 {top:530px;background-position:0px -249px;}
        .focus1 {top:281px;background-position:-200px 0px;}
        .focus2 {top:362px;background-position:-200px -81px;}
        .focus3 {top:446px;background-position:-200px -165px;}
        .focus4 {top:530px;background-position:-200px -249px;}

        .after {width: 900px;height:330px;left:246px;top:293px; position:absolute; overflow: hidden;}
        .item {width:430px;height:60px;overflow: hidden;float: left;position:relative;background:transparent url('images/mask-2018-09-14.png') no-repeat;background-position:0px -450px;}
        .focus {background-position:-15px -351px;}
        .text {position:absolute;left:30px;top:0px;width:370px;height:60px;text-align:left;color:#4a4a4a;line-height: 60px;font-size:24px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-09-14.jpg') no-repeat;" onUnload="exit();">
<div id="cursor"></div>
<div id="after" class="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
            String html = "";
            html += inner.resultToString(parent) + ",\n";
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            cursor.rows = 5;
            cursor.columns = 2;
            cursor.pageSize = cursor.rows * cursor.columns;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            for( var i = 1; i < cursor.focusable.length; i ++) {
                var items = cursor.focusable[i].items;
                for( var j = 0; j < items.length; j ++ ) {
                    var regex = new RegExp('^(.*?)（.*）', "gi");
                    var text = regex.exec(items[j].name);
                    if (typeof text !== 'undefined' && text !== null )
                        items[j].name = text[1];
                }
            }

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index == -1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) || blocked >= 1 && (
                index == 11 && blocked == 1 && focus <= 1 || index == 1 && ( focus % cursor.columns ==  cursor.columns - 1 || focus + 1 >= items.length ) ||
                index == -11 && blocked == cursor.focusable.length -1 && (focus + 1 >= items.length && focus + cursor.columns >= items.length)
            )) return;

            if( blocked == 0 ) {
                if( index == 11 || index == -11 ) {
                    focus += index > 0 ? -1 : 1;
                } else {
                    blocked = focus + 1;
                    focus = 0;
                }
            } else {
                if( index == 1 ) {
                    focus += 1
                } else if(index == -1) {
                    if( focus % cursor.columns == 0 ) {
                        focus = blocked - 1;
                        blocked = 0;
                    } else
                        focus -=1 ;
                } else if( index == 11 ){
                    focus -= 2;
                    if( focus < 0 ) {
                        focus = cursor.focusable[blocked - 1].items.length - ( (focus + 2) % cursor.columns == ( cursor.focusable[blocked - 1].items.length - 1  )% cursor.columns  ? 1 : 2 );
                        blocked -= 1;
                        cursor.focusable[0].focus = blocked - 1;
                    }
                } else {
                    if( focus + 1 >= items.length ) {
                        focus = focus % cursor.columns;
                        cursor.focusable[0].focus = blocked;
                        blocked +=1 ;
                    } else {
                        focus += 2;
                        if( focus >= items.length ) focus = items.length - 1;
                    }
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.focusable[0].focus + 1;
            $("cursor").className = "mask icon " + ( cursor.blocked == 0 ? 'focus' : 'cursor' ) + String( blocked );
            var focus = cursor.focusable[blocked].focus;

            var html = '';
            var pageCount = cursor.pageSize;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id = String(blocked) + String(i + 1);
                html += '<div class="item' + ( blocked == cursor.blocked && i == focus ? ' focus' : '' ) + '" id="item' + id + '">';
                html += '<div class="text" id="txt' + id + '">' + item.name + '</div>';
                html += '</div>';
            }
            html += '</div>';
            $("after").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, 24, function(pixelsWidth){
                    if(pixelsWidth < 370 ) return;
                    $(id).innerHTML = '<marquee class="marquee" scrollamount="10">' + value + "</marquee>";
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>