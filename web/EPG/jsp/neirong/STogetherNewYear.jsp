<%!
    /**
     * 模板文件说明： 此模板针对新春大联欢，界面中只有一竖行，显示4条内容
     */
%>
<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    ColumnInfo info = new ColumnInfo(typeId, 0, 99);
    infos.add(info);

    //获取当前栏目的详细信息
    Column column = inner.getDetail(typeId, new Column());
%>
<html>
<head>
    <title><%=column == null ? "读者新春大联欢海选启动（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-STogetherNewYear.png') no-repeat;background-position: 0px 0px;}
        .mask11 {width:278px;height:187px;left:46px;top:448px;background-position: -50px 0px;}
        .arrowUp,.arrowDown {width:19px;height:13px;left:789px;}
        .arrowUp {top:315px;background-position: -10px 0px;}
        .arrowDown { top:605px;background-position: -10px -30px;}

        .scrollBar{position:absolute;width:5px;left:1094px;}
        .scrollBarTop,.scrollBarBottom{width:5px;left:0px;height:4px; border:none;}
        .scrollBarTop {top:0px;background-position: 0px 0px;}
        .scrollBarMiddle{width:5px;left:0px;border:none;top:4px;background-position: -10px 0px;background-repeat: repeat-y;}
        .scrollBarBottom{bottom:0px;background-position: 0px -51px;}

        .scrollBarBorder {width:7px;left:1093px;height:192px;top:420px;position:absolute;background-color: white;}

        .flowedItem {padding:0px 16px;font-style:italic; width:574px;height:56px; position: absolute;font-size: 28px; font-weight: bold; left:441px;line-height:56px;background-position: -20px 0px;background-repeat: no-repeat;}
        .item1 { top:411px; }
        .item2 { top:467px; }
        .item3 { top:523px; }
        .item4 { top:579px; }
        .flowedItem .inner{width:522px;height:56px; font-size: 28px;overflow: hidden;word-break:keep-all;white-space:nowrap; line-height:56px;text-overflow:ellipsis;}
        .flowedItem marquee {width:522px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('<%= inner.pictureUrl("", column != null ? column.getPosters() : null, "7") %>') no-repeat;"  onUnload="exit();">
<div class='scrollBarBorder'></div>
<div id='scrollBar' class='scrollBar'>
    <div class='mask scrollBarTop'></div>
    <div id='scrollBarMiddle' class='mask scrollBarMiddle'></div>
    <div class='mask scrollBarBottom'></div>
</div>
<div id='flowedItem1'></div>
<div id='flowedItem2'></div>
<div id='flowedItem3'></div>
<div id='flowedItem4'></div>
</body>
<script language="javascript" type="text/javascript" defer="defer">
    <!--
    var initialize = {
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        move : function(index){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            cursor.focusable[0].focus = focus += index > 0 ? -1 : 1;
            cursor.call('show');
        },
        focused : [<%= inner.getPreFoucs() %>],
        show : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = 4;
            $("scrollBar").style.visibility = items.length > pageCount ? "visible" : "hidden";
            var h = Math.ceil( pageCount * 1.0 / items.length * 190);
            var le = 190 - h;
            $("scrollBar").style.height = h + "px";
            $("scrollBarMiddle").style.height = ( h - 8 < 8 ? 8  : h - 8) + "px";

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            if( flowCursorIndex + pageCount  >= items.length ) {
                flowCursorIndex = items.length - pageCount ;
                flowCursorIndex = flowCursorIndex <= 0 ? 0 : flowCursorIndex;
            }
            $("scrollBar").style.top = Math.ceil( focus * 1.0 / (items.length - 1) * le  + 421 ) + "px";
            for(var i = flowCursorIndex, j = 1; i < flowCursorIndex + pageCount && i < items.length; i += 1, j++) {
                var item = items[i];
                $("flowedItem" + j).className = "flowedItem item" + j;
                if( i == focus ) {
                    $("flowedItem" + j).style.color = "#FFFFFF";
                    $("flowedItem" + j).style.backgroundImage = "url('images/mask-STogetherNewYear.png')";
                    (function(id,el) {
                        cursor.calcStringPixels(el.name, 20, function(pixelsWidth){
                            var inner = pixelsWidth > 570? ("<marquee scrollamount='10'>" + el.name + "</marquee>") : el.name ;
                            $(id).innerHTML = inner;
                        });
                    })("flowedItem" + j,item);
                } else {
                    $("flowedItem" + j).style.color = "#FFFFFF";
                    $("flowedItem" + j).innerHTML = "<div class='inner'>" + item.name + "</div>";
                    $("flowedItem" + j).style.backgroundImage = "none";
                }
            }
        },
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl = "<%= backUrl%>";

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.call('show');
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>