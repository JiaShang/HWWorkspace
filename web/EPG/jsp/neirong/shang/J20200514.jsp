<%@ include file="../player/include.jsp" %>
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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114945";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .listName{
            position: absolute;
            color: #8b0000;
            font-size:24px;
            overflow: hidden;
            line-height: 43px;
            width: 204px;
            height: 43px;
            text-align: center;
            background-repeat: no-repeat;
        }
        #list{
            position: absolute;
            left: 90px;
            top: 570px;
            width: 800px;
            height: 60px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200227Bg.png)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 400px;height: 68px;left: 730px;top: 208px; overflow:hidden; background: url('images/J20200514Focus.png') no-repeat; visibility: visible; z-index: 1;" ></div>
<div id="list">
    <div id="list0" class="list0">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName"></div>
    </div>
    <div id="list1" class="list0">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName" style="left: 225px;"></div>
    </div>
    <div id="list2" class="list0">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName" style="left: 450px;"></div>
    </div>
    <div id="list3" class="list0">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName" style="left: 675px;"></div>
    </div>
    <div id="list4" class="list0">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName" style="left: 900px;"></div>
    </div>
</div>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data: [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused: [<%= inner.getPreFoucs() %>],
        init: function () {
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl = '<%= backUrl %>';
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = o["data"];
            }
            if(cursor.focusable[0].focus === 0){
                cursor.focusable[0].focus = 1;
            }
            cursor.call('show');
            setTimeout(function(){cursor.call('prepareVideo');},200);
        },
        move: function (index) {
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if (focus === 0) return;
            if (focus > 1 && index === 11 || focus < 5 && index === -11) {
                // cursor.call('loseFocus');
                focus += index > 0 ? -1 : 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');

        },
        show: function () {
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            if (items.length <= 0) return;
            var focus = cursor.focusable[blocked].focus;
            // $("listName"+String(focus-1)).style.backgroundImage = "url(images/J20200227Focus1.png)";
            // $("listName"+String(focus-1)).style.width = '212px';
            // $("listName"+String(focus-1)).style.height = '51px';
            $("focus").style.top = 208+79*(focus-1)+"px";
        },
        loseFocus: function () {
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            if (items.length <= 0) return;
            var focus = cursor.focusable[blocked].focus;
            // $("listName"+String(focus-1)).style.backgroundImage = "url(images/J20200227Focus0.png)";
            // $("listName"+String(focus-1)).style.width = '204px';
            // $("listName"+String(focus-1)).style.height = '43px';
        },
        nextVideo: function () {
            // var playIndex = cursor.playIndex;
            var playIndex = 0;
            // cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        prepareVideo: function () {
            //var playIndex = cursor.playIndex;
            var playIndex = 0;
            if (cursor.focusable[0].items.length <= 0) return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        playMovie: function (item) {
            // var pos = cursor.moviePos;
            var pos = [545, 361, 118, 213];
            player.exit();
            player.play({
                vodId: item.id,
                position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                callback: function () {
                    ///cursor.focusable[0].focus = cursor.playIndex;
                    // cursor.call('show');
                    //setTimeout(function(){cursor.call('lazyShow');},50);
                }
            });
        }
    });
    //cursor.initialize(initialize);
    -->
</script>
</html>