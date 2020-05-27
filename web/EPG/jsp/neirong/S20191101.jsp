<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    w:整个条目的宽度
    h:所有条目高度的和
    ih:元素的高度
    mr:两个条目之间的空隙
    fs:字体大小
    lft:文本块显示坐标 LEFT
    tp:文本块显示坐标 TOP
    cl:文字颜色
    al:文字对齐方式，0:左对齐，１:居中对齐, 2:右对齐
    bg:普通条目背景颜色
    fc:焦点文字颜色
    bc:焦点背景
    pg:页面显示内容条数
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top (如果没有表示无小窗口播放)
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 5));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail("10000100000000090000000000113104",column);
    String picture = column == null ? "" : inner.pictureUrl("images/bg-2019-11-01.png",column.getPosters(),"7");

    String[] sc = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null,   pg = null, mr = null;
    String cl = null, bc = null,fc = null,bg=null,al=null;
    List<List<Vod>> list = null;

    w = !isNumber( inner.get("w") ) ? 237 : Integer.valueOf(inner.get("w"));
    h = !isNumber( inner.get("h") ) ? 73 : Integer.valueOf(inner.get("h"));
    ih = !isNumber( inner.get("ih") ) ? 40 : Integer.valueOf(inner.get("ih"));
    fs = !isNumber( inner.get("fs") ) ? 22 : Integer.valueOf(inner.get("fs"));
    mr = !isNumber( inner.get("mr") ) ? 8 : Integer.valueOf(inner.get("mr"));

    lt = isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : ( isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : 73 );
    tp = !isNumber( inner.get("tp") ) ? 353 : Integer.valueOf(inner.get("tp"));
    cl = isEmpty( inner.get("cl") ) ? "ffffff" : inner.get("cl");
    fc = isEmpty( inner.get("fc") ) ? "ffffff" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "F29B87" : inner.get("bc");
    bg = isEmpty( inner.get("bg") ) ? "transparent" : inner.get("bg");
    al = isEmpty( inner.get("al") ) ? "0" : inner.get("al");
    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");

    pg = isEmpty( inner.get("pg") ) ? list.get(0).size() : Integer.valueOf( inner.get("pg") );

    if( al.equalsIgnoreCase("0")) al = "left";
    else if( al.equalsIgnoreCase("1")) al = "center";
    else al="right";

    h = pg * (ih + mr);

    String video = inner.get("video","");

%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .flowed {width:<%=w %>px;height:<%= h %>px;top:<%=tp%>px;left:<%=lt%>px;position:absolute;overflow:hidden;}
        .item .container,.focusItem .container{width:<%=w %>px;height:<%=ih %>px;overflow:hidden;background-color:#<%=bg%>;}
        .item,.focusItem{height:<%=ih + mr %>px; color:#<%=cl%>; overflow:hidden;}
        .item .container .inner,.focusItem .container .inner{width:<%= w-20 %>px; height:<%= ih%>px;font-size:<%=fs %>px;line-height:<%= ih-6 %>px; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .focusItem .container{background-color:#<%=bc%>;color:#<%=fc%>;}
        .item .container .inner,.focusItem .container .inner{margin:4px 0px 0px 10px;text-align: <%= al%>;}
        .focusItem .marquee{margin:0px 0px 0px 10px;font-size:<%=fs %>px;line-height:<%= ih-6 %>px; width:<%= w-20 %>px;}
        .scrollBar,#scrollBarContainer{position:absolute;width:6px;}

        .mask {position:absolute;background: transparent url("images/mask-2019-11-01.png") no-repeat left top; background-position: 0px 0px;}
        .mask2 {width:428px;height:52px;left:738px;top:474px;background-position:0px -150px;}

        .mask3 {width:562px;height:128px;top:537px;background-position:0px -150px;}
        .mask31 {left:80px;background-position:0px 0px;}
        .mask32 {left:637px;background-position:0px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "none" : (" url('" + picture + "')")%> no-repeat;"></div>
<%if( sc.length >= 5 ){%>
    <div id='scrollBarContainer' class='scrollBarContainer'><div id='scrollBar'></div></div>
<%}%>
    <div id='flowed' class='flowed'></div>
    <div id='mask'></div>
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
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            <% } %>
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[1] = {focus:0,items:[{'name':'更多','linkto':'/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000113120&lft=187&tp=229&w=893&ih=55&mr=14&fs=22&hm=1&al=0&pg=6&bc=fcc800&fc=000000&cl=000000&sc=1100,229,400,8e8e8e,fcc800'}]};
            cursor.focusable[2] = {focus:0,items:[
                {'name':'脱贫','linkto':'/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000113121&lft=187&tp=229&w=893&ih=55&mr=14&fs=22&hm=1&al=0&pg=6&bc=fcc800&fc=000000&cl=000000&sc=1100,229,400,8e8e8e,fcc800'},
                {'name':'扶贫','linkto':'http://192.168.17.235:82/theme-activity?backUrl=others&oprtCatNo=821&sp_code=cqccn_cq'}
            ]};
            for( var i = 0; i < cursor.focusable.length; i ++) cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            cursor.call('show');
            if( typeof cursor.moviePos != 'undefined' ) {
                cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                setTimeout(function(){cursor.call('prepareVideo');},200);
            } else {
                setTimeout(function(){cursor.call('lazyShow');},250);
            }
        },
        nextVideo   :   function () {
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.focusable[0].focus = cursor.playIndex;
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( cursor.focusable[0].items.length <= 0 )return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                    cursor.focusable[0].focus = cursor.playIndex;
                    cursor.call('show');
                    setTimeout(function(){cursor.call('lazyShow');},50);
                }
            });
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index === 1 || index === -1 || index === 11 && focus <= 0 ) ||
                blocked === 1 && ( index == 1 || index == -1 ) ||
                blocked === 2 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length )
            ) return;
            if( blocked === 0 ) {
                focus += index > 0 ? -1 : 1;
                if( focus >= items.length ) {
                    blocked = 1; focus = 0;
                }
            } else if( blocked == 1) {
                blocked = index == 11 ? 0 : 2;
                focus = cursor.focusable[blocked].focus;
            } else {
                if( index == 11 ) {
                    blocked = 1; focus = 0;
                } else {
                    focus += index;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                <% if( isEmpty(video) || video.split("\\,").length < 4 ){ %>
                cursor.call('lazyShow');
                <% } else {%>
                if( blocked == 0 && cursor.playIndex != focus ) {
                    cursor.playIndex = focus;
                    var item = cursor.focusable[blocked].items[focus];
                    cursor.call('playMovie',item);
                }
                <% }%>
            }, 1800);
            cursor.call('show');
        },
        lazyShow : function(){
            if( cursor.blocked != 0 ) return;
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String( focus + 1 );
            cursor.calcStringPixels(text, <%= fs %>, function(width){
                if( width <= <%= w-20 %> ) return;
                $('txt' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        show:function(){
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;
            var focus = cursor.focusable[0].focus;
            //每页显示数量
            var pageCount = <%= pg %>;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            <% if( sc.length >= 5 ) { %>
            if( items.length <= pageCount ) {
                $("scrollBarContainer").style.visibility = "hidden";
            } else {

                if(  flowCursorIndex + pageCount  >= items.length ) {
                    flowCursorIndex = items.length - pageCount ;
                }

                $("scrollBarContainer").style.visibility = "visible";

                $("scrollBar").className = "scrollBar";

                var scrollBarHeight = <%= sc[2]%>;
                var scrollTop = <%= sc[1]%>;
                var h = Math.ceil( pageCount * 1.0 / items.length * scrollBarHeight);
                $("scrollBar").style.height = h + "px";
                $("scrollBar").style.top = Math.ceil( focus * 1.0 / (items.length - 1) * ( scrollBarHeight - h ) ) + "px";
                $("scrollBar").style.backgroundColor = "#<%= sc[4]%>";
                $("scrollBarContainer").style.left = "<%= sc[0]%>px";
                $("scrollBarContainer").style.top = "<%= sc[1]%>px";
                $("scrollBarContainer").style.height = "<%= sc[2]%>px";
                $("scrollBarContainer").style.backgroundColor = "#<%= sc[3]%>";
            }
            <% } %>
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="' + ( cursor.blocked == 0 && i == focus ? 'focusItem' : 'item' ) + '"><div class="container" id="txt' + ( i + 1) + '">';
                html += '<div class="inner">' + item.name + '</div>';
                html +='</div></div>';
            }
            $("flowed").innerHTML = html;

            var blocked = cursor.blocked;
            focus = cursor.focusable[blocked].focus;

            if( blocked != 0 ) {
                $("mask").className = "mask mask" + String( blocked + 1) + " mask"  + String( blocked + 1) + String( focus + 1);
                $("mask").style.visibility = 'visible';

            } else {
                $("mask").style.visibility = 'hidden';
            }
        }
    });
    -->
</script>
</html>