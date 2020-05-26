<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .item{ width:197px;height:237px;float:left;position:relative;}
        .container,.mask,.focus{width:170px;height:217px;left:0px;top:0px;position:relative;overflow: hidden;}
        .container .image{ width:154px;height:200px;left:8px;top:8px;position:absolute;}
        img { width:154px;height:200px;}

        .mask {background: transparent url("images/mask-2018-11-13.png") no-repeat 0px 0px;}
        .focus {background: transparent url("images/mask-2018-11-13.png") no-repeat -200px 0px;}
        .text {width:160px;height:35px;top:180px; font-size:20px; color:white; line-height:32px; position:absolute;left:4px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        marquee{line-height:32px;}

        .flowed {width:1000px;left:144px;top:214px;height:460px;overflow:hidden;position: absolute;}

        .mark {width:46px;height:110px;left:62px;position:absolute;background:transparent url("images/mask-2018-11-13.png") no-repeat;background-position: -100px -220px;}

        .mark1 {top:213px;}
        .mark2 {top:327px;}
        .mark3 {top:437px;}
        .mark4 {top:551px;}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-11-14.jpg') no-repeat left top;" onUnload="exit();">
<div id="bg" style="position:absolute;width:300px;height:720px;left:980px;top:0px;overflow: hidden"></div>
<div id="mark"></div>
<div id='flowed' class='flowed'></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
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
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var column = 5;

            if( blocked === 0 && ( index === 11 && focus < column || index === -1 && focus % column == 0 || index === 1 && ( focus % column == column - 1 ||  focus + 1 >= items.length || index === -11 && Math.floor( focus * 1.0 / column ) * column + column >= items.length ))) return;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else {
                focus += index > 0 ? -column : column;
                if( focus >= items.length ) focus = items.length - 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show:function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;

            //每页显示数量
            var pageCount = 10;

            var page = Math.ceil( ( focus + 1 ) / pageCount);
            var flowCursorIndex = ( page - 1 ) * pageCount;

            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item"><div class="container">';
                html += '<div class="image">';
                html += '<img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '"/>';
                html += '</div>';
                html += '<div class="' + ( i == focus ? 'focus' : 'mask' ) + '"></div>';
                html += '<div class="text" id="txt' + (i + 1) + '">';
                html += item.name;
                html +='</div></div></div>';
            }
            $("flowed").innerHTML = html;
            $("bg").style.backgroundImage = "url('images/item-2018-11-14-" + String( page ) + ".png')";
            $("mark").className = 'mark mark' + page;

            (function(id,value){
                cursor.calcStringPixels(value, 20, function(pixelsWidth){
                    if( pixelsWidth <= 160 ) return;
                    var innerHTML = '<marquee scrollamount="10">' + value + "</marquee>";
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    });
    -->
</script>
</html>