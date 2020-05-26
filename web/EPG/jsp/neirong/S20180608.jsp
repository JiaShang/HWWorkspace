<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
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
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .container{ width:180px;height:250px;float: left; position:relative;overflow: hidden;}
        .item,.itemFocus {width:165px;height:250px; position:relative;background:transparent url('images/mask-2018-06-08.png') no-repeat left top; background-position:0px 0px;}
        .image{ width:147px;height:200px;left:9px;top:9px;position:relative;}
        .itemFocus {background-position:-200px 0px;}
        .image img {width:147px;height:200px;}
        .text {width:147px;top:15px;height:35px; font-size:18px; color:black; line-height:32px; position:relative;left:9px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .flowed {width:400px;left:731px;top:409px;height:250px;overflow:hidden;position: absolute;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black none no-repeat;" onUnload="exit();">
<div id="flowed" class="flowed"></div>
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

            var links = [
                {name:'流金岁月',posters:{"1":["images/bg-2018-06-08-item-1.jpg"]},linkto:'http://chongqingtvb-utc.wasu.cn/a?f=72502&t=37&a=69202323&profile=CHONGQNEWSCENARIO'},
                {name:'天地男儿',posters:{"1":["images/bg-2018-06-08-item-2.jpg"]},linkto:'http://chongqingtvb-utc.wasu.cn/a?f=72502&t=37&a=10649450&profile=CHONGQNEWSCENARIO'}
            ];
            if( typeof cursor.focusable[0].items == 'undefined' )  cursor.focusable[0].items = [];
            cursor.focusable[0].items.pushAll(links);

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 && focus % 2 == 0 || index == 1 && focus % 2 == 1 ) return;

            if( index == 1 || index == -1 ) focus += index;
            else {
                focus += index > 0 ? -2 : 2;
                if( focus >= items.length ) focus = focus - items.length;
                else if( focus < 0 ) focus = focus + items.length;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;
            //每页显示数量
            var pageCount = 2;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="container"><div class="item' + ( i == focus ? "Focus" : "" ) + '" + ><div class="image">';
                html += '<img src="' + cursor.pictureUrl(item.posters,1) + '"/>';
                html += '</div><div class="text" style="' + (Math.floor(i / 2) == 3 ?  "color:white;" : "") + '" id="txt' + (i + 1) + '">';
                html += item.name;
                html +='</div></div></div>';
            }
            $("flowed").innerHTML = html;
            document.body.style.backgroundImage = 'url("images/bg-2018-06-08-' + (Math.floor(focus / 2) + 1) + '.jpg")';
            (function(id,value){
                cursor.calcStringPixels(value, 18, function(pixelsWidth){
                    var innerHTML = pixelsWidth > 147 ? ('<marquee class="maskMarquee" scrollamount="10">' + value + "</marquee>") : value ;
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>