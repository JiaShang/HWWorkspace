<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  一横排专区模板, 默认5个方框
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;;
    lt:LEFT坐标;不填为默认坐标
    tp:TOP坐标;不填为默认坐标
    fc:焦点文字颜色;不填为默认为黄色
    bc:焦点框颜色;不填为默认为黄色
    ct:显示数量;每页显示条目个数，默认为５个;;
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 8));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");

    String bc = null,fc = null,cl = null;
    Integer tp = null,ct=null,lt=null;
    lt = isEmpty( inner.get("lt") ) ? 89 : Integer.valueOf( inner.get("lt") );
    ct = isEmpty( inner.get("ct") ) ? 5 : Integer.valueOf( inner.get("ct") );
    tp = isEmpty( inner.get("tp") ) ? 383 : Integer.valueOf( inner.get("tp") );
    fc = isEmpty( inner.get("fc") ) ? "292929" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "013d77" : inner.get("bc");
    cl = isEmpty( inner.get("cl") ) ? "292929" : inner.get("cl");
%>
<html>
<head>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "一横排专区模板, 默认5个方框" : column.getName()%></title>
    <style>
        .item{ width:208px;height:250px;margin:0px 6px; float: left;overflow:hidden;}
        .itemContainer{width:200px;height:222px; position:relative;}
        .item .image{ width:200px;height:222px;left:0px;top:7px;position:relative;background:transparent none no-repeat -6px -10px;padding:3px 10px 3px 10px;}
        .item .image img{border: solid 1px #<%=bc%>;}
        .maskImage{width:178px;height:209px;left:5px;top:5px;position:relative; border:solid 5px #<%=bc%>;}
        .text {width:190px;height:35px;top:-6px;font-size:22px; color:#<%=cl%>; line-height:32px; position:relative;left:5px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .flowed {width:900px;left:212px;top:210px;height:500px;overflow:hidden;position: absolute;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-01-24.jpg') no-repeat;" onUnload="exit();">
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

            var row = 2;var column = 4;
            var pageCount = row * column;

            if( index == -1 ) {
                if( focus % column == 0 ) {
                    if( focus <= column ) return;
                    focus -= column + 1;
                } else focus -= 1;
            } else if( index == 1 ) {
                if( focus % column == column - 1 ) {
                    if( Math.ceil( (focus + 1.0) / pageCount) * pageCount >= items.length ) return;
                    focus += column + 1;
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

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show:function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;
            //每页显示数量
            var pageCount = 8;
            var defaultIndex = Math.floor(pageCount / 2.0);
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            var html = '';
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item"><div class="itemContainer">';
                html += '<div class="' + ( i == focus ? 'maskImage' : 'image' ) + '">';
                html += '<img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '" style="width:178px;height:209px;"/>'
                html += '</div>';
                html += '<div class="text" id="txt' + (i + 1) + '"' + ( i == focus ? ' style="color:#<%=fc%>;top:3px;line-height:32px;"' : '' ) + '>';
                html += item.name;
                html +='</div></div></div>';
            }
            $("flowed").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, 22, function(pixelsWidth){
                    if( pixelsWidth <= 190 ) return;
                    var innerHTML = '<marquee class="maskMarquee" scrollamount="10">' + value + "</marquee>";
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    });
    -->
</script>
</html>