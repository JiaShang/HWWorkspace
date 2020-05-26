<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    w:宽度
    h:高度
    ih:条目的高度
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
    hm:是否显示首页，0:默认为空值，显示首页按钮，1:只要有任何值均不显示首页按钮
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top,
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113203";
    List<Column> columns = inner.getList(typeId, 3, 0 , new Column());
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
    }

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");

    String[] sc = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null,   pg = null, mr = null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
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
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>

</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent <%= isEmpty(picture) ? "url(images/J20191204bg-2.png)" : (" url('" + picture + "')")%> no-repeat;"></div>
<%if( sc.length >= 5 ){%>
    <div id='scrollBarContainer' class='scrollBarContainer'><div id='scrollBar'></div></div>
<%}%>
    <div id="focus" style="position: absolute;width: 180px;height: 81px;left: 677px;top: 63px; background: url('images/J20191204focus.png') no-repeat;" ></div>
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
            <% if( !isEmpty(video) && video.split("\\,").length > 3 ){ %>
            cursor.moviePos = [<%=video%>];
            <% } %>
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
            cursor.lastBlocked = 0;
            if( typeof cursor.moviePos != 'undefined' ) {
                cursor.playIndex = cursor.focusable[cursor.blocked].focus;
                setTimeout(function(){cursor.call('prepareVideo');},200);
            } else {
                setTimeout(function(){cursor.call('lazyShow');},250);
            }
            
        },
        nextVideo   :   function () {
            var blocked = cursor.blocked;
            cursor.playIndex = cursor.focusable[blocked].focus;
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex || 0;
            var blocked = cursor.blocked;
            if( cursor.focusable[blocked].items.length <= 0 )return;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            var pos = cursor.moviePos;
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                    cursor.focusable[cursor.blocked].focus = cursor.playIndex;
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

            if( blocked <= 0 && index === -1 || blocked >= 2 && index === 1 || index === 11 && focus <= 0 || index === -11 && focus + 1 >= items.length ) return;
            if( index == 11 || index == -11 ) {
                focus += index > 0 ? -1 : 1;
            } else {
                blocked += index;
                focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                <% if( isEmpty(video) || video.split("\\,").length < 4 ){ %>
                cursor.call('lazyShow');
                <% } else {%>
                cursor.moveTimer = undefined;
                if( blocked == cursor.lastBlocked && cursor.playIndex == cursor.focusable[blocked].focus ) return;
                cursor.playIndex = focus;
                cursor.lastBlocked = cursor.blocked;
                var item = cursor.focusable[blocked].items[focus];
                cursor.call('playMovie',item);
                <% }%>
            }, 1800);
            cursor.call('show');
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String( focus + 1 );
            cursor.calcStringPixels(text, <%= fs %>, function(width){
                if( width <= <%= w-20 %> ) return;
                $('txt' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        show:function(){
            var  blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            if( items.length <= 0 ) return;
            var focus = cursor.focusable[blocked].focus;
            //每页显示数量
            var pageCount = <%= pg %>;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            $("focus").style.left=String(677+196*blocked-blocked)+"px";

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
                html += '<div class="' + ( i == focus ? 'focusItem' : 'item' ) + '"><div class="container" id="txt' + ( i + 1) + '">';
                html += '<div class="inner">' + item.name + '</div>';
                html +='</div></div>';
            }
            $("flowed").innerHTML = html;
        }
    });
    -->
</script>
</html>