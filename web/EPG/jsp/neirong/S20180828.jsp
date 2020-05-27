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

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "一横排专区模板" : column.getName()%></title>
    <style>
        .item{ width:200px;height:168px;float: left;position:relative;}
        .container,.containerFocus{width:177px;height:168px; position:absolute;left:0px;top:0px;overflow: hidden;background:transparent url('images/mask-2018-08-28.png') no-repeat 0px 0px;}
        .containerFocus{background-position:-200px 0px;}
        .image{ width:165px;height:154px;left:7px;top:6px;position:absolute;}
        .text {width:160px;height:35px; font-size:22px; color:#fee5f0; line-height:32px; position:relative;left:8px;top:126px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .flowed {width:1200px;left:55px;top:501px;height:285px;overflow:hidden;position: absolute;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-08-28.jpg') no-repeat;" onUnload="exit();">
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

            for( var i = 0; i < cursor.focusable[0].items.length; i ++){
                var rs = /：(.*?)（/gi.exec(cursor.focusable[0].items[i].name);
                cursor.focusable[0].items[i].name = rs == 'undefined' || rs == null || rs.length <= 1 ? '' : rs[1];
            }
            cursor.call('show');
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index === 11 || index === -11 || index === -1 && focus <= 0 || index === 1 && focus + 1 >= items.length)) return;
            if( blocked === 0 ) {
                focus += index;
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
            var pageCount = 6;

            var flowCursorIndex = focus < 2 ? 0 : focus - 2;
            if( flowCursorIndex + pageCount >= items.length ) flowCursorIndex = items.length - pageCount;
            if( flowCursorIndex < 0 ) flowCursorIndex = 0;

            var html = '';
            for(var i = flowCursorIndex; i < flowCursorIndex + pageCount; i ++) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="image">';
                html += '<img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '" style="width:163px;height:119px;"/>';
                html += '</div>';
                html += '<div class="' + ( i == focus ? 'containerFocus' : 'container' ) + '"></div>';
                html += '<div class="text" id="txt' + (i + 1) + '"' + ( i == focus ? ' style="color:#000000;"' : '' ) + '>';
                html += item.name;
                html +='</div></div>';
            }
            $("flowed").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, 22, function(pixelsWidth){
                    if( pixelsWidth <= 160 ) return;
                    var innerHTML = '<marquee scrollamount="10">' + value + "</marquee>";
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    });
    -->
</script>
</html>