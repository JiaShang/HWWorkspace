<%@ include file="../../player/include.jsp" %>
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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000115680";
//    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 3, 0, column);   //（id，查询数据条数，开始查询位置）
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 5));
    }
//    Result result = new Result( typeId, columns );
    //////////////////////////////////////////////////////////

    //获取当前栏目的详细信息
//    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "images/J20191120Bg.png";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }

    Integer playFlag = null,direct = null;
    playFlag = inner.getInteger("playFlag", inner.getInteger("playFlag", 1));  //playFlag=0时放大图片，为1时播视频
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200102Bg.png)" : " url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="focus" style="position: absolute;width: 511px;height: 234px;left: 120px;top: 410px; overflow:hidden; background: url('../images/J20191120Focus0.png') no-repeat;visibility: hidden;" ></div>
</body>
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
                cursor.focusable[i].items = [];
            }
            cursor.focusable[0].items[0] = {
                'name':'查看图片',
                'linkto':'/EPG/jsp/neirong/shang/J20200619List.jsp?typeId='+cursor.focusable[1].typeId+'&playFlag='+<%=playFlag%>
            }
        }
    });
    -->
</script>
</html>