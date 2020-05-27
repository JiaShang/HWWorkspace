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
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");

    String bc = null,fc = null;
    Integer tp = null,ct=null,lt=null;
    lt = isEmpty( inner.get("lt") ) ? 89 : Integer.valueOf( inner.get("lt") );
    ct = isEmpty( inner.get("ct") ) ? 5 : Integer.valueOf( inner.get("ct") );
    tp = isEmpty( inner.get("tp") ) ? 383 : Integer.valueOf( inner.get("tp") );
    fc = isEmpty( inner.get("fc") ) ? "fdfa00" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "fdfa00" : inner.get("bc");
%>
<html>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "一横排专区模板, 默认5个方框" : column.getName()%></title>
    <style>
        .item{ width:208px;height:285px;margin:0px 6px; float: left;}
        .itemContainer{width:200px;height:245px; position:relative;}
        .item .image{ width:200px;height:245px;left:0px;top:7px;position:relative;background:transparent url('images/mask-TempRowYellow.png') no-repeat -6px -10px;padding:3px 10px 3px 10px;}
        .maskImage{width:178px;height:232px;left:5px;top:5px;position:relative; border:solid 5px #<%=bc%>;}
        .text {width:190px;height:35px; font-size:22px; color:#fee5f0; line-height:32px; position:relative;left:5px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .flowed {width:1200px;left:<%=lt%>px;top:<%=tp %>px;height:285px;overflow:hidden;position: absolute;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black<%= isEmpty(picture) ? "" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div id='flowed' class='flowed'></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            var links = [
                {name:'再创世纪',posters:{"1":["images/item-2018-09-06-1.jpg"]},linkto:'http://192.168.17.42:8100/cq_coshipdemo/detail.jsp?resultUrl=http://192.168.17.42:8100/cq_coshipdemo/index.jsp?&arg=3570460'},
                {name:'创世纪',posters:{"1":["images/item-2018-09-06-2.jpg"]},linkto:'http://chongqingtvb-utc.wasu.cn/a?f=72502&t=37&a=17656817&profile=CHONGQNEWSCENARIO'},
                {name:'夸世代',posters:{"1":["images/item-2018-09-06-3.jpg"]},linkto:'http://chongqingtvb-utc.wasu.cn/a?f=72502&t=37&a=68287424&profile=CHONGQNEWSCENARIO'},
                {name:'岁月风云',posters:{"1":["images/item-2018-09-06-4.jpg"]},linkto:'http://chongqingtvb-utc.wasu.cn/a?f=72502&t=37&a=81913898&profile=CHONGQNEWSCENARIO'},
                {name:'流金岁月',posters:{"1":["images/item-2018-09-06-5.jpg"]},linkto:'http://chongqingtvb-utc.wasu.cn/a?f=72502&t=37&a=69202323&profile=CHONGQNEWSCENARIO'}
            ];

            cursor.focusable[0] = {};
            cursor.focusable[0].focus = this.focused.length > 0 ? this.focused[0]: 0 ;
            cursor.focusable[0].items = links;

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
            var pageCount = <%= ct %>;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item"><div class="itemContainer">';
                html += '<div class="' + ( i == focus ? 'maskImage' : 'image' ) + '">';
                html += '<img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '" style="width:178px;height:232px;"/>'
                html += '</div>';
                html += '<div class="text" id="txt' + (i + 1) + '"' + ( i == focus ? ' style="color:#<%=fc%>;top:6px;line-height:32px;"' : '' ) + '>';
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