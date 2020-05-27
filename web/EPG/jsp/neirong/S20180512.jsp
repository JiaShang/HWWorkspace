<%@ include file="player/include.jsp" %>
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
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

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

    lt = isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : ( isNumber( inner.get("lt")) ? Integer.valueOf(inner.get("lt")) : 73 );
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
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <style>
        .flowed {width:<%=w %>px;height:<%= h %>px;top:<%=tp%>px;left:<%=lt%>px;position:absolute;overflow:hidden;}
        .item .container,.focusItem .container{width:<%=w %>px;height:<%=ih %>px;overflow:hidden;background-color:#<%=bg%>;}
        .item,.focusItem{height:<%=ih + mr %>px; color:#<%=cl%>; overflow:hidden;}
        .item .container .inner,.focusItem .container .inner{width:<%= w-20 %>px; height:<%= ih%>px;font-size:<%=fs %>px;line-height:<%= ih-6 %>px; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .focusItem .container{background-color:#<%=bc%>;color:#<%=fc%>;}
        .item .container .inner,.focusItem .container .inner{margin:4px 0px 0px 10px;text-align: <%= al%>;}
        .focusItem .marquee{margin:0px 0px 0px 10px;font-size:<%=fs %>px;line-height:<%= ih-6 %>px;}
        .scrollBar,#scrollBarContainer{position:absolute;width:6px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-05-12.jpg') no-repeat;" onUnload="exit();">
<%if( sc.length >= 5 ){%>
    <div id='scrollBarContainer' class='scrollBarContainer'><div id='scrollBar'></div></div>
<%}%>
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

            if( blocked === 0 && (index === 1 || index === -1 || index === 11 && focus <= 0 || index === -11 && focus + 1 >= items.length)) return;
            if( blocked === 0 ) {
                focus += index > 0 ? -1 : 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
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
                html += '<div class="' + ( i == focus ? 'focusItem' : 'item' ) + '"><div class="container" id="txt' + ( i + 1) + '">';
                html += '<div class="inner">' + item.name + '</div>';
                html +='</div></div>';
            }
            $("flowed").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, <%= fs %>, function(pixelsWidth){
                    var innerHTML = pixelsWidth >  <%= w-20 %> ? ('<marquee class="marquee" scrollamount="10">' + value + "</marquee>") : '<div class="inner">' + value + '</div>' ;
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    });
    -->
</script>
</html>