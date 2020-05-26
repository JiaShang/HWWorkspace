<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  一横排专区模板, 默认5个方框
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
    lft:LEFT坐标;不填为默认坐标
    tp:TOP坐标;不填为默认坐标
    cl:文字颜色;不填为默认为 fee5f0
    fc:焦点文字颜色;不填为默认为 fdfa00
    bo:背景框颜色;不填为默认为 ffffff
    bc:焦点框颜色;不填为默认为 fdfa00
    ct:显示数量;每行显示条目个数，默认为５个;
    st:样式，如果 st 为1时，焦点文字背景为黑色，盖住了图片;
    wh: 元素图片的宽度
    ht: 元素图片的高度
    ml: 两个元素之间的距离
    mt: 元素和文字之间的距离
    mh: 上下两排元素之间的高度
    bd: 边框的宽度，默认为 6
    row:多少行，pageCount 显示结果为 row * ct
    bg:背景图片，如果带bg参数时，不需要加 images/ 系统自动加上
    fs:font-size， 字体大小
    pic:图片类型，默认为海报.
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);

    String picture = inner.pictureUrl("", column == null ? null : column.getPosters(),"7");
    if( isEmpty( picture ) ) {
        picture = inner.get("bg", "");
        picture = isEmpty( picture ) ? "none" : "images/" + picture;
    }



    String bo = null,bc = null,fc = null,cl = null;
    Integer tp = null,ct=null,lt=null,st=null,wh=null,ht=null,ml=null,mh = null,mt=null,bd = null, row = null, fs = null,pic=null;
    lt = inner.getInteger("lft", inner.getInteger("lt", 89));
    ct = inner.getInteger("ct", 5);
    tp = inner.getInteger("tp", 383);
    cl = inner.get("cl", "fee5f0");
    fc = inner.get("fc", "fdfa00");
    bo = inner.get("bo", "ffffff");
    bc = inner.get("bc", "fdfa00");
    st = inner.getInteger("st", 0);
    wh = inner.getInteger("wh",178);
    ht = inner.getInteger("ht",232);
    ml = inner.getInteger("ml",18);
    mh = inner.getInteger("mh",35);
    mt = inner.getInteger("mt",st == 1 ? -33 : 8);
    bd = inner.getInteger("bd",6);
    fs = inner.getInteger("fs",22);
    row = inner.getInteger("row",1);
    pic = inner.getInteger("pic",1);
%>
<html>
<head>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "一横排专区模板, 默认5个方框" : column.getName()%></title>
    <style>
        .item{ width:<%=wh+bd*2+ml%>px;height:<%=ht+bd*2+mh%>px;margin:0px 6px; float: left;position:relative; }
        .itemContainer{width:<%=wh+bd*2%>px;height:<%=ht+bd*2+mh%>px; position:absolute;left:0px;top:0px;}
        .image{width:<%=wh+2%>px;height:<%=ht+2%>px;left:<%=4+bd-1%>px;top:<%=bd-1%>px;position:relative;background-color:#<%=bo%>;}
        .mask{width:<%=wh+bd*2%>px;height:<%=ht+bd*2%>px;left:4px;top:0px;position:relative;background-color:#<%=bc%>;}
        .image .img,.mask .img {width:<%=wh%>px;height:<%=ht%>px;position:relative;}
        .image .img {left:1px;top:1px;position:relative;}
        .mask .img {left:<%=bd%>px;top:<%=bd%>px;position:relative;}
        .img img {width:100%;height:100%}
        .text {width:<%=wh+bd*2%>px;height:<%=fs + 5%>px; font-size:<%=fs%>px; color:#<%=cl%>; line-height:<%=fs+3%>px; position:absolute;left:3px;top:<%=ht+mt+bd*2-1%>px; text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .flowed {width:<%=(wh+bd*2+ml+18)*ct%>px;left:<%=lt%>px;top:<%=tp%>px;height:<%= ( ht+bd*2+mh ) * row %>px;overflow:hidden;position: absolute;}
        .textBg {background:transparent url("images/mask-TemplateRow.png") no-repeat -1px 0px;position:absolute;left:0px;top:0px;width:200px;top:205px;height:45px;left:0px;}
        .inner {height:<%=fs+5%>px;line-height: <%=fs+3%>px;width:<%=wh+bd*2%>px;font-size:<%=fs%>px; text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .maskMarquee {height:<%=fs+5%>px;line-height:<%=fs+3%>px;width:<%=wh+bd*2%>px;font-size:<%=fs%>px; }

        .page{width:100px;left:590px;top:660px;height:24px;font-size:24px; color:#<%=cl%>;text-align: center;line-height:20px;position:absolute;}
        .number{color:#<%=fc%>;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black<%= isEmpty(picture) ? "" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div id='flowed' class='flowed'></div>
<div id="page" class="page" style="visibility: hidden"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.row = <%= row %>;
            cursor.column = <%= ct %>;
            cursor.pageCount = cursor.row * cursor.column;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
            setTimeout(function(){cursor.call('lazyShow');}, 40);
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( <%=row%> === 1 ){
                if( index === 11 || index === -11 || index === -1 && focus <= 0 || index === 1 && focus + 1 >= items.length ) return;
                focus += index;
            } else {
                var column = cursor.column;
                var pageCount = cursor.pageCount;
                if( index == -1 ) {
                    if( focus % column == 0 ) {
                        if( focus <= column ) return;
                        focus -= pageCount - column + 1;
                    } else focus -= 1;
                } else if( index == 1 ) {
                    if( focus % column == column - 1 ) {
                        if( Math.ceil( (focus + 1.0) / pageCount) * pageCount >= items.length ) return;
                        focus += pageCount - column + 1;
                        if( focus >= items.length ) focus = items.length - 1;
                    } else if( focus + 1 >= items.length )
                        return;
                    else  focus += 1;
                } else if( index == 11 ) {
                    if( focus < column ) return;
                    focus -= column;
                } else if( index == -11 ){
                    if( focus + column >= items.length && Math.ceil( (focus + 1.0) / column) == Math.ceil( items.length * 1.0 / column)  )
                        return;
                    focus += column;
                    if( focus >= items.length ) focus = items.length - 1;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            cursor.call('show');
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, <%=fs%>, function(width){
                if( width <= 190 ) return;
                $('txt' + (focus + 1)).innerHTML  = '<marquee class="marquee" scrollamount="8">' + text + "</marquee>";
            });
        },
        show:function(){
            setTimeout(function(){
                var focus = cursor.focusable[0].focus;
                var items = cursor.focusable[0].items;
                if( items.length <= 0 ) return;
                //每页显示数量
                var pageCount = cursor.pageCount;
                var defaultIndex = Math.floor(pageCount / 2.0);

                var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
                if( cursor.row == 1 ) {
                    flowCursorIndex = focus < defaultIndex ? 0 : focus - defaultIndex;
                    if( flowCursorIndex + pageCount >= items.length ) flowCursorIndex = items.length - pageCount;
                    if( flowCursorIndex < 0 ) flowCursorIndex = 0;
                }

                var html = '';
                var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
                for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                    var item = items[i];
                    html += '<div class="item"><div class="itemContainer">';
                    html += '<div class="' + ( i == focus ? 'mask' : 'image' ) + '"><div class="img"> ';
                    html += '<img src="' + cursor.pictureUrl(item.posters,<%=pic%>,'images/defaultImg.png') + '"/>';
                    html += '</div></div>';
                    <% if( st == 1) {%>
                    html += '<div class="textBg"></div>';
                    <% }%>
                    html += '<div class="text" id="txt' + (i + 1) + '"' + ( i == focus ? ' style="color:#<%=fc%>;"' : '' ) + '><div class="inner">';
                    html += item.name;
                    html +='</div></div></div></div>';
                }
                $("flowed").innerHTML = html;

                if( <%= row%> !== 1 ){
                    $("page").style.visibility = 'visible';
                    $("page").innerHTML = '<span class="number">'+ String(Math.ceil( ( focus + 1.0 ) / pageCount)) + '</span> / ' + Math.ceil( ( items.length * 1.0 ) / pageCount);
                }
            },40);
        }
    });
    -->
</script>
</html>