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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000117945";
//    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 2, 0, column);   //（id，查询数据条数，开始查询位置）
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
    Integer  direct = null;
    String[] focusPic = {};
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct")); //默认左右移动
    focusPic = isEmpty( inner.get( "focusPic" )) ? new String[0] : inner.get("focusPic").split("\\,");
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        #focus{
            position:absolute;
            overflow:hidden;
            left: <%= focusPic[0]%>px;
            top: <%= focusPic[1]%>px;
            width: <%= focusPic[2]%>px;
            height: <%= focusPic[3]%>px;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200102Bg.png)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="focus" style="background:transparent no-repeat;" ></div>
</body>
<script language="javascript" type="text/javascript">

    <!--
    var direct = <%=direct%>;
    var focusFlag = <%=focusPic[6]%>;
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
                if (typeof o["data"] != 'undefined') {
                    cursor.focusable[i].items = o["data"];
                }else {
                    cursor.focusable[i].items = [];
                }

            }
            // cursor.focusable[0].items[0] = {
            //     'name':'视频',
            //     'linkto':'/EPG/jsp/neirong/shang/J20200915List.jsp?typeId='+cursor.focusable[0].typeId+'&lft=925&tp=50&pg=5&w=400&ih=60&mr=5&fs=24&hm=1&fs=22&ftop=0&fleft=3&fc=3a8086&bc=fff1c0&cl=000000&sc=0,380,ffffff,fff1c0'
            // }
            cursor.focusable[1].items[0] = {
                'name':'图集',
                'linkto':'/EPG/jsp/neirong/shang/J20201105List.jsp?typeId='+cursor.focusable[1].typeId+'&focusPic=188,325,380,235,20201105List&sc=1220,150,490,584d42,d0a96f,1,2,0'
            }
            cursor.call('show');

        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var blocked = cursor.blocked;
        if (direct == 0){
            if( blocked == 1 && index === -1 ){
                blocked = 0;
            }else if ( blocked == 0 && index === 1 ) {
                blocked = 1;
            }
        }else if (direct == 1) {
            if( blocked == 1 && index === 11 ){
                blocked = 0;
            }else if ( blocked == 0 && index === -11 ) {
                blocked = 1;
            }
        }
        cursor.blocked = blocked;
        cursor.call('show');
        },
        show : function(){
            var blocked = cursor.blocked;
            if (focusFlag == 1) {  //上下移动焦点框
                $("focus").style.backgroundImage = "url(images/J<%=focusPic[5]%>Focus.png)";
                $("focus").style.top =String(blocked*(<%=focusPic[4]%>)+<%=focusPic[1]%>)+"px";
            }else if (focusFlag == 2) {  //左右移动焦点框
                $("focus").style.backgroundImage = "url(images/J<%=focusPic[5]%>Focus.png)";
                $("focus").style.left =String(blocked*(<%=focusPic[4]%>)+<%=focusPic[0]%>)+"px";
            }else if (focusFlag == 0) {  //切换焦点图
                $("focus").style.backgroundImage = "url(images/J<%=focusPic[5]%>Focus"+blocked+".png)";
            }
        }
    });
    -->
</script>
</html>