<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 99));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    int index = inner.getInteger("index" ,1);
    String titlePg  = inner.pictureUrl("none", column.getPosters(), "4");
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

        .flowed {position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;background-image: none;}
        .flowedBody {position:absolute;width:1048px;left:102px;top:225px;height:390px;overflow: hidden;}

        .flowedContainer,.flowedContainerFocus{width:1046px;height:69px;float:left;overflow: hidden;background-position: 0px 0px;}
        .flowedContainerFocus {background:transparent url('images/mask-2019-09-09.png') no-repeat; background-position:0px -296px;height:74px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;position:absolute;left:102px;}

        .flowedContainer .item,.flowedContainerFocus .item {width:985px;height:69px;line-height:50px;font-size: 24px;color:white;}
        .flowedContainer .item {overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 30px;}
        .flowedContainerFocus .item {margin:0px 0px 0px 30px;line-height:60px;}
        .title{width:200px;height: 45px; position: absolute; left:100px;top:165px; background:transparent url('images/mask-2019-09-09.png') no-repeat;background-position: 0px 0px;}

        .flowedContainerFocus .item .marquee {width:985px;height:69px;line-height:60px;font-size: 24px;}

        .page {width:22px;height:22px;left:1181px;position:absolute;color:#15172E;font-size:20px;overflow: hidden;text-align: center;}
        .number {top:323px;}
        .count {top:346px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-09-29-txt.jpg') no-repeat;" onUnload="exit();">
<div class="title" style="background:transparent url('<%=titlePg%>') no-repeat"></div>
<div class='flowed' id='flowed'></div>
<div id="pageNum" class="page number">0</div>
<div id="pageCount" class="page count">0</div>
<div id="mask"></div>
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
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
            cursor.call('lazyShow');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;

            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 || index == 1 || ( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) ) return;
            focus += index > 0 ? -1  : 1;
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            cursor.call('show');
        },
        show        :   function(){
            cursor.call('showItems');
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, 24, function(width){
                if( width <= 985 ) return;
                $('mask').innerHTML  = '<div class="item"><marquee class="marquee" scrollamount="8">' + text + "</marquee></div>";
            });
        },
        showItems   :   function(){
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;

            //每页显示数量
            var pageCount = 6;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '', id = '';
            var container = 'flowed';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='" + container + "Container'>";
                html += "<div class='item' id='item" + ( (blocked + 1) + "" + ( i - flowCursorIndex + 1 ) )+ "'>" + item.name;
                html += "</div></div>";
            }
            $(container).innerHTML = '<div class="flowedBody">' + html + "</div>";


            $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
            $("pageCount").innerHTML = Math.ceil( ( items.length * 1.0 ) / pageCount);
            $("pageNum").style.left = $("pageCount").style.left = '1178px';
            $("pageNum").style.top = '270px';
            $("pageCount").style.top = '300px';

            var title = items[focus].name;
            var current = focus % pageCount;

            $("mask").className = "mask flowedContainerFocus";
            $("mask").innerHTML = "<div class='item'>" + title + "</div>";
            $("mask").style.top = String(69 * current  + 220) + "px";
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>