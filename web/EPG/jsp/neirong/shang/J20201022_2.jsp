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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000118983";
    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
//    Column[] subColumns = new Column[4];
//
//    List<Column> columns = inner.getList(typeId, 4, 0 , new Column());//（id，查询数据条数，开始查询位置）
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
//        subColumns[i] = new Column();
//        subColumns[i] = inner.getDetail(columns.get(i).id,subColumns[i]);
//
//    }

    //////////////////////////////////////////////////////////
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "images/J20200514_3Bg.jpg";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }

%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        #focus{
            position: absolute;
            width: 200px;
            height: 82px;
            top: 300px;
            left: 100px;
            background-image: url("images/J20201022_2Focus.png");
            overflow: hidden;
            background-repeat: no-repeat;
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200514_3Bg.jpg)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="focus"></div>
</body>

<script language="javascript" type="text/javascript">

    <!--
    var subColumns = [];
    var focusXY = [["90px","300px"],["420px","350px"],["1000px","300px"],["100px","578px"],["450px","578px"],["720px","480px"],["990px","600px"]];
    var focusBgXY = ["0px 0px","-320px -55px","-890px 0px","0px -280px","-350px -280px","-620px -190px","-880px -300px"];

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
                'name':'城口',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18715&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[1] = {
                'name':'南川',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18717&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[2] = {
                'name':'南岸',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18719&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[3] = {
                'name':'涪陵',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18723&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[4] = {
                'name':'荣昌',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18725&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[5] = {
                'name':'北碚',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18721&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[6] = {
                'name':'巫山',
                'linkto':'http://125.62.26.147:82/detail/tour/hotel_deail.html?dataId=18727&rank=2&urlType=TOPIC'
            }
            setTimeout(function(){ cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
            var focus = cursor.focusable[0].focus;
                // cursor.call('loseFocus');
            if( focus != 2 && focus != 6 && index === 1 ) {
                focus++;
            }else if( focus != 0 && focus != 3 && index === -1 ) {
                focus--;
            }else if( index === 11 ){
                if (focus == 3 || focus == 4) {
                    focus = focus - 3;
                }else if (focus == 6) {
                    focus = focus - 4;
                }
            }else if( index === -11 ){
                if (focus == 0 || focus == 1) {
                    focus = focus + 3;
                }else if (focus == 2) {
                    focus = focus + 4;
                }
            }
            cursor.focusable[0].focus = focus;
            cursor.call('show');
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            $("focus").style.left = focusXY[focus][0];
            $("focus").style.top = focusXY[focus][1];
            $("focus").style.backgroundPosition = focusBgXY[focus];
        }
        // loseFocus : function(){
        //     var focus = cursor.focusable[0].focus;
        //     $("focus"+String(focus)).style.backgroundImage = "url("+focusPics[focus][0]+")";
        // }
    });
    -->
</script>
</html>