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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114809";

    List<Column> columns = inner.getList(typeId, 7, 0 , new Column());
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
    }
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
            background-image: none;
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
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200414Bg.png)" : (" url('" + picture + "')")%> no-repeat;" onUnload="exit();">
<%--<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent url(images/J20200414Bg.png) no-repeat;" onUnload="exit();">--%>
<div id="focus" style="width:265px;height:86px;left:777px;top:95px;position:absolute;overflow:hidden; background:transparent no-repeat;" ></div>
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
    var rul = ["/EPG/jsp/neirong/shang/J20200408.jsp?typeId=10000100000000090000000000114810&cat=1&lft=735&tp=190&w=440&ih=50&mr=5&fs=22&hm=1&pg=8&cl=725f51&sc=1205,193,430,d1dde9,ff6108,1,1,0&video=620,353,68,288&focusPic=20200429&maxTitleLen=22",
                "/EPG/jsp/neirong/shang/J20200421.jsp?typeId=10000100000000090000000000114724&focusTop=258&focusLeft=710&titleTop=540&titleLeft=685&titlePic=20200421&focusPic=20200421&blocked=4&cl=000000&fc=b30000&cat=1&lft=720&tp=253&w=455&ih=45&mr=5&fs=24&hm=1&pg=5&cl=725f51&sc=940,255,390,d1dde9,c88bad,0,1,0&video=610,345,40,262",
                "http://125.62.26.147:82/topic/topic.html?classId=143&rank=2&urlType=TOPIC",
                "http://125.62.26.147:82/topic/topic.html?classId=135&rank=2&urlType=TOPIC",
                "http://125.62.26.147:82/topic/topic.html?classId=141&rank=2&urlType=TOPIC",
                "http://125.62.26.147:82/topic/topic.html?classId=137&rank=2&urlType=TOPIC"];
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl = '<%= backUrl %>';
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = [];
                // cursor.focusable[i].items = o["data"];
                if( i != 0){
                    cursor.focusable[i].items[0]={
                        'linkto': rul[i-1]
                    };
                }else{
                    cursor.focusable[i].items = o["data"];
                }
            }
            cursor.call('show');
            setTimeout(function(){cursor.call('prepareVideo');},200);
        },
        move: function (index) {
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            // var focus = cursor.focusable[blocked].focus;
            // var items = cursor.focusable[blocked].items;

            if (blocked > 0 && blocked % 2 == 1 ){
                if (index === 1){
                    blocked ++ ;
                }else if (blocked > 2 && index === 11) {
                    blocked = blocked - 2;
                }else if (blocked < 5 && index === -11){
                    blocked = blocked + 2;
                }
            }else if (blocked > 0 && blocked % 2 == 0) {
                if (index === -1){
                    blocked -- ;
                }else if (blocked > 2 && index === 11) {
                    blocked = blocked - 2;
                }else if (blocked < 5 && index === -11){
                    blocked = blocked + 2;
                }
            }
            cursor.blocked = blocked;
            cursor.call('show');

        },
        show: function () {
            var blocked = cursor.blocked;
            if (blocked%2 == 1){
                $("focus").style.left = "777px";
                $("focus").style.top = String(95+138*Math.floor(blocked/2))+"px";
            } else {
                $("focus").style.left = "942px";
                $("focus").style.top = String(22+140*Math.floor(blocked/2)-4*Math.floor(blocked/6))+"px";
            }
            $("focus").style.backgroundImage = "url(images/J20200429Focus"+blocked%2+".png)";

        },
        loseFocus: function () {
            var blocked = cursor.blocked;
            var items = cursor.focusable[blocked].items;
            if (items.length <= 0) return;
            var focus = cursor.focusable[blocked].focus;
            $("listName"+String(focus-1)).style.backgroundImage = "url(images/J20200227Focus0.png)";
            $("listName"+String(focus-1)).style.width = '204px';
            $("listName"+String(focus-1)).style.height = '43px';
        },
        nextVideo: function () {
            var playIndex = cursor.playIndex;
            // var playIndex = 0;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        prepareVideo: function () {
            var playIndex = cursor.playIndex;
            // var playIndex = 0;
            if (cursor.focusable[0].items.length <= 0) return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        playMovie: function (item) {
            // var pos = cursor.moviePos;
            var pos = [603, 353, 105, 290];
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