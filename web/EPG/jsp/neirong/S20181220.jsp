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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000110741";

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

            var links = [
                {name:'红海行动',posters:{"1":["images/item-2018-12-20-1.png"]},linkto:'http://192.168.18.75/dyyx/search_content.htm?vodId=PACKAGE201804000056-gehua'},
                {name:'我不是药神',posters:{"1":["images/item-2018-12-20-2.png"]},linkto:'http://192.168.18.75/dyyx/search_content.htm?vodId=PACKAGE201811000019-gehua'},
                {name:'西虹市首富',posters:{"1":["images/item-2018-12-20-3.png"]},linkto:'http://192.168.18.75/dyyx/search_content.htm?vodId=PACKAGE201811000001-gehua'},
                {name:'复仇战联盟3',posters:{"1":["images/item-2018-12-20-4.png"]},linkto:'http://192.168.42.52/epg/hollywood/biz_97740454/det/vod/program_ccms_750131.do'},
                {name:'捉妖记2',posters:{"1":["images/item-2018-12-20-5.png"]},linkto:'http://192.168.18.75/dyyx/search_content.htm?vodId=PACKAGE201804000003-gehua'},
                {name:'侏罗纪世界2',posters:{"1":["images/item-2018-12-20-6.png"]},linkto:'http://192.168.42.52/epg/hollywood/biz_97740454/det/vod/program_ccms_750074.do'},
                {name:'头号玩家',posters:{"1":["images/item-2018-12-20-7.png"]},linkto:'http://192.168.17.42:8100/cq_coshipdemo/detail.jsp?resultUrl=http://192.168.17.42:8100/cq_coshipdemo/index.jsp?&arg=3531996'}
            ];

            cursor.focusable[0] = {};
            cursor.focusable[0].focus = this.focused.length > 1 ? this.focused[1]: 0 ;
            var data = this.data.length > 0 ? this.data[0].data : [];
            if( typeof data == 'undefined' || data.length < 3 ) {
                data = links;
            } else {
                data.insertAt(0,links[0]);
                data.insertAt(2,links[1]);
                data.insertAt(3,links[2]);
                data.insertAt(4,links[3]);
                data.insertAt(5,links[4]);
                data.insertAt(7,links[5]);
                data.push(links[6]);
            }
            cursor.focusable[0].items = data;

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
            var defaultIndex = Math.floor(pageCount / 2.0);

            var flowCursorIndex = focus < defaultIndex ? 0 : focus - defaultIndex;
            if( flowCursorIndex + pageCount >= items.length ) flowCursorIndex = items.length - pageCount;
            if( flowCursorIndex < 0 ) flowCursorIndex = 0;

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