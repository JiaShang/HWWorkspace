<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000108008";
    List<Column> list = inner.getList(typeId,4,0, new Column());
    for( Column col : list) infos.add(new ColumnInfo(col.getId(), 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url("images/mask-2018-09-21.png") no-repeat;background-position: 0px 0px;}
        .icon {width:92px;height:299px;top:0px;}
        .icon1 {left:99px;background-position:0px 0px;}
        .icon2 {left:279px;background-position:-100px 0px;}
        .icon3 {left:880px;background-position:-200px 0px;}
        .icon4 {left:1064px;background-position:-300px 0px;}

        .row {width:1080px;height:320px;left:100px;top:336px; text-align:center;overflow: hidden;background-position: 0px -700px;}
        .row .item{width:270px;height:320px;float: left;position:relative;}
        .row .item .image{width:195px;height:244px;position:absolute;left:37px;top:10px;border:none;}
        .row .item .image img{width:195px;height:244px;}
        .row .item .text {width:195px;height:22px; font-size:22px; color:#da9c00; line-height:22px; position:absolute;left:37px;top:270px;text-align:center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}
        .row .item .focused {width:215px;height:262px;left:27px;top:0px;background-position:-400px -10px;}

        .column {width:968px;height:300px;top:340px;left:153px;background-position:0px -300px;}
        .column .item{width:967px;height:50px;position:absolute;left:0px;}
        .column .item .text{width:860px;height:50px;position:absolute;left:63px;top:0px;color:#da9c00;font-size:22px;line-height: 50px;text-align:left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}
        .column .item .focused {width:925px;height:59px;left:20px;top:0px;background-position:-20px -600px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-09-21.jpg') no-repeat;" onUnload="exit();">
<div id="after"></div>
<div id="title"></div>
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

            if( blocked == 2 && (index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) ||
                blocked == 0 && index == -1 && focus <= 0 || blocked != 2 && ( index == 11 || index == -11 ) || blocked == 3 && index == 1 && focus + 1 >= items.length
            ) return;
            if( index == 1) {
                if( blocked == 2 ) {
                    blocked = 3 ; focus = 0;
                } else {
                    focus += 1;
                    if( focus >= items.length ) {
                        blocked = blocked + 1;
                        focus = blocked == 2 ? cursor.focusable[blocked].focus : 0;
                    }
                }
            } else if(index == -1){
                if( blocked == 2 ) {
                    blocked = 1 ;
                } else {
                    focus -= 1;
                    if( focus < 0 )  blocked = blocked - 1;
                }
                if( blocked != cursor.blocked ) focus = blocked == 2 ? cursor.focusable[blocked].focus : cursor.focusable[blocked].items.length - 1;
            } else {
                focus += index > 0 ? -1 : 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;

            var html = '';
            var pageCount = blocked == 2 ? 5 : 4;
            var layout = blocked == 2 ? 'column' : 'row';
            $("title").className = 'mask icon icon' + String(blocked + 1);
            $("after").className = "mask " + layout;
            var items = cursor.focusable[blocked].items;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            if( blocked != 2  && length < pageCount) {
                $("after").style.left = String((pageCount - length) * 270 / 2 + 100) + "px";
            } else {
                $("after").style.left = String( blocked == 2 ? 153 : 100) + "px";
            }

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item"' + ( blocked == 2 ? ' style="top:' + String( ( i - flowCursorIndex ) * 50 + 25) + 'px;background:transparent url(images/mask-2018-09-21.png) no-repeat 0px -670px;"' : '' )  + '>';
                if( blocked != 2 ) html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '"/></div>';
                html += '<div class="text" id="txt' + String(i + 1) + '">' + item.name + '</div>';
                if( i == focus ) html += '<div class="mask focused"></div>';
                html += '</div>';
            }
            $("after").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, 22, function(pixelsWidth){
                    var width = cursor.blocked == 2 ? 860 : 300;
                    if(pixelsWidth < width ) return;
                    $(id).innerHTML = '<marquee class="marquee" scrollamount="10">' + value + "</marquee>";
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>