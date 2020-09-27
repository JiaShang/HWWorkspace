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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000115000";

    Integer blocked = null;
    blocked = !isNumber( inner.get("blocked") ) ? 1 : Integer.valueOf(inner.get("blocked"));
    if(blocked == 1){
        infos.add(new ColumnInfo(typeId, 0, 99));
    }else {
        List<Column> columns = inner.getList(typeId, blocked, 0 , new Column());
        for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
            infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
        }
    }

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    Integer  serviceId = null,frequency=null;
    String channelId = null,program=null,VODflag = null;
    List<List<Vod>> list = null;

    serviceId = !isNumber( inner.get("serviceId") ) ? 2603 : Integer.valueOf(inner.get("serviceId"));
    frequency = !isNumber( inner.get("frequency") ) ? 2750000 : Integer.valueOf(inner.get("frequency"));
    channelId = isEmpty( inner.get("channelId") ) ? "" : inner.get("channelId");
    program = isEmpty( inner.get("program") ) ? "" : inner.get("program");
    VODflag = isEmpty( inner.get("VODflag") ) ? "" : inner.get("VODflag");

%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<script language="javascript" type="text/javascript">
    <!--
    <%--var blocked = <%= blocked%>;--%>
    cursor.initialize({
        init : function(){
            cursor.backUrl = '<%= backUrl %>';
            cursor.call('playMovie');
        },
        goBack : function(){
            player.exit();
            cursor.call('goBackAct');
        },
        nextVideo   :   function () {
            var playIndex = 0;
            var blocked = 0;
            // cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = 0;
            var blocked = 0;
            if( cursor.focusable[blocked].items.length <= 0 )return;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        playMovie : function(){
            player.exit();
            var VODflag = <%=VODflag %>;
            if (VODflag == 1) {
                player.play({
                    position: {width: 1280, height: 720, left: 0, top: 0},
                    channelId: <%=channelId %>,
                    program: <%=program %>
                });
            }else if (VODflag == 2) {
                player.play({'url':'rtsp://192.168.14.60/PLTV/88888888/224/3221227603/10000100000000060000000004489947_0.smil'});
            }else {
                player.play({
                    position: {width: 1280, height: 720, left: 0, top: 0},
                    serviceId: <%=serviceId %>,
                    frequency: <%=frequency %>
                });
            }

        }
    });
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background: transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div style="width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"></div>
</body>
</html>