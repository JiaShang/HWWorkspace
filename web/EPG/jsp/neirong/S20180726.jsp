<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  一横排专区模板, 默认5个方框
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;;
    tp:TOP坐标;不填为默认坐标
    fc:焦点文字颜色;不填为默认为黄色
    bc:焦点框颜色;不填为默认为黄色
    ct:显示数量;每页显示条目个数，默认为５个;;
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 2));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2018-07-26.jpg" : inner.pictureUrl("images/bg-2018-07-26.jpg",column.getPosters(),"7");

    String bc = null,fc = null;
    Integer tp = null,ct=null,lt=null;
    ct = isEmpty( inner.get("ct") ) ? 5 : Integer.valueOf( inner.get("ct") );
    lt = isEmpty( inner.get("lft") ) ? 89 : Integer.valueOf( inner.get("lft") );
    tp = isEmpty( inner.get("tp") ) ? 383 : Integer.valueOf( inner.get("tp") );
    fc = isEmpty( inner.get("fc") ) ? "fdfa00" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "fdfa00" : inner.get("bc");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "一横排专区模板" : column.getName()%></title>
    <style>
        .item{ width:208px;height:255px;margin:0px 6px; float: left;}
        .itemContainer{width:200px;height:215px; position:relative;}
        .item .image{ width:200px;height:215px;left:0px;top:7px;position:relative;background:transparent url('images/mask-2018-07-26.png') no-repeat -6px -10px;padding:3px 10px 3px 10px;}
        .maskImage{width:178px;height:202px;left:5px;top:5px;position:relative; border:solid 5px #<%=bc%>;}
        .text {width:190px;height:35px; font-size:22px; color:#fee5f0; line-height:32px; position:relative;left:5px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .messages {width:631px;left:92px;top:346px;height:300px;overflow:hidden;position: absolute;}
        .container {width:631px;height:100px;overflow:hidden;float: left; font-size:17px;}
        .phone {color:#D2A00C;height:60px;overflow: hidden;line-height: 70px;}
        .message {color:white;height:40px;overflow: hidden;}
        .flowed {width:1200px;left:<%=lt%>px;top:<%=tp%>px;height:285px;overflow:hidden;position: absolute;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black<%= isEmpty(picture) ? "" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div id='messages' class='messages'></div>
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
            cursor.messages = [
                {id:"13637983371", message: "张铁林呀！他饰演的乾隆皇帝也被观众熟知"},
                {id:"15223467629", message: "顶延禧攻略的乾隆，大猪蹄子的名号也不是白叫的"},
                {id:"13527455090", message: "这周二刷甄嬛传，喜欢陈建斌的皇帝"},
                {id:"15213132451", message: "张铁林“乾隆专业户”名副其实"},
                {id:"15111958309", message: "两个皇帝我都喜欢~~"}
            ];
            cursor.call("showMessage");
            cursor.call('show');
        },
        showMessage : function() {
            var focus = 0;
            var items = cursor.messages;
            var pageCount = 3;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '',item = null;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            var phone = function(n) {
                return n.substr(0,3) + "****" + n.substr(7);
            }
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                item = items[i];
                html += '<div class="container">';
                html += '<div class="phone">用户ID ' + phone(item.id) + '</div>';
                html += '<div class="message">' + item.message + '</div>';
                html +='</div>';
            }
            $("messages").innerHTML = html;
            item = items[0]; items.removeAt(0);
            items.push(item);
            setTimeout(function(){cursor.call("showMessage");}, 4000);
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
                html += '<img src="' + cursor.pictureUrl(item.posters,1) + '" style="width:178px;height:202px;"/>'
                html += '</div>';
                html += '<div class="text" id="txt' + (i + 1) + '"' + ( i == focus ? ' style="color:#<%=fc%>;top:6px;"' : '' ) + '>';
                html += item.name;
                html +='</div></div></div>';
            }
            $("flowed").innerHTML = html;

            (function(id,value){
                cursor.calcStringPixels(value, 22, function(pixelsWidth){
                    var innerHTML = pixelsWidth > 190 ? ('<marquee class="maskMarquee" scrollamount="10">' + value + "</marquee>") : value ;
                    $(id).innerHTML = innerHTML;
                });
            })('txt' + (focus + 1),items[focus].name);
        }
    });
    -->
</script>
</html>