<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109070";
    infos.add(new ColumnInfo(typeId, 0, 99));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .after {width:405px;height:280px;left:720px;top:175px;position: absolute;overflow: hidden;}
        .item {width:405px;height:74px; line-height:74px; text-align:left;color:white;float:left;overflow:hidden;font-size:24px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        marquee {line-height: 74px;}
        .mask {width:429px;height:62px;position:absolute;background:transparent url('images/mask-2018-11-12.png') no-repeat;background-position: 0px -70px;}
        .mask11 {left:710px;top:186px;}
        .mask12 {left:710px;top:258px;}
        .mask13 {left:710px;top:332px;}
        .mask14 {left:710px;top:406px;}

        .mask21 {width:484px;height:56px;left:688px;top:502px;background-position:0px 0px;}

        .page {width:23px;height:16px;left:1137px;position:absolute;color:#571F1F;font-size:16px;overflow: hidden;text-align: center;}
        .number {top:224px;}
        .count {top:244px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-11-12.jpg') no-repeat;" onUnload="exit();">
<div id="after" class="after"></div>
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
            cursor.focusable[1] = {
                focus: 0,
                items : [
                    {name:'活动详情',linkto:'/EPG/jsp/neirong/S20181112Vote.jsp'}
                ]
            };

            cursor.call('show',0);
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index == -1 || index == 1 || index == 11 && focus <= 0 ) || blocked == 1 && index != 11 ) return;

            if( index == 11 ) {
                if( blocked == 1 ) {
                    blocked = 0; focus = cursor.focusable[blocked].items.length - 1;
                } else
                    focus -= 1;
            } else {
                focus += 1;
                if ( focus + 1 > items.length ) {
                    cursor.blocked = blocked = 1 ; focus = 0;
                    cursor.call('show', 0);
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(index){
            var blocked = typeof index === "undefined" ? cursor.blocked : index;
            var focus = cursor.focusable[blocked].focus;

            var pageCount = 4;

            $("mask").className = "mask mask" + (blocked + 1) + "" + ( focus % pageCount + 1) ;
            if(blocked === 1) { return; }

            var html = '';

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                html += '<div class="item" id="txt' + (i + 1) + '">' + items[i].name + "</div>";
            }
            $("after").innerHTML = html;
            if( blocked == 0 ) {
                $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
                $("pageCount").innerHTML = Math.ceil( ( items.length * 1.0 ) / pageCount);
            }
            if ( blocked === cursor.blocked  && blocked == 0) {
                (function(id,value){
                    cursor.calcStringPixels(value, 24, function(pixelsWidth){
                        if( pixelsWidth <= 405) return;
                        $(id).innerHTML = '<marquee class="marquee" scrollamount="10">' + value + "</marquee>";
                    });
                })('txt' + (focus + 1),items[focus].name);
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>