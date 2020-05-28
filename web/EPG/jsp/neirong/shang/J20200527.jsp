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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000115221";
//    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
    Column[] subColumns = new Column[4];

    List<Column> columns = inner.getList(typeId, 4, 0 , new Column());//（id，查询数据条数，开始查询位置）
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
        subColumns[i] = new Column();
        subColumns[i] = inner.getDetail(columns.get(i).id,subColumns[i]);

    }

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
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200514_3Bg.jpg)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="focus0" style="position: absolute;width: 300px;height: 300px;left: 170px;top: 80px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus1" style="position: absolute;width: 300px;height: 300px;left: 420px;top: 125px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus2" style="position: absolute;width: 300px;height: 300px;left: 650px;top: 50px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus3" style="position: absolute;width: 300px;height: 300px;left: 850px;top: 150px; overflow:hidden; background: none no-repeat;" ></div>
</body>
<script language="javascript" type="text/javascript">

    <!--
    var focusPics = [];
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
            <% int j=0;%>
            for (var i = 0 ;i <4; i++ ){
                <%  j++;%>
                var column =  <%= inner.writeObject(subColumns[j])%>;
                if (typeof column.posters !='undefined' && typeof column.posters[3] !='undefined' && column.posters[3].length > 0) {
                    focusPics[i] = column.posters['3'];
                    if (column.posters[3].length == 1) {
                        focusPics[i][1] = ["images/defaultImg.png"];
                    }
                }else {
                    focusPics[i] = ["images/defaultImg.png","images/defaultImg.png"];
                }
                $("focus"+String(i)).style.backgroundImage = "url("+focusPics[i][0]+")";
            }
            cursor.focusable[0].items[0] = {
                'name':'乐游六一',
                'linkto':'http://125.62.26.147:82/topic/topic.html?classId=153&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[1] = {
                'name':'乐看六一',
                'linkto':'/EPG/jsp/neirong/shang/J20200514_3List.jsp?typeId=10000100000000090000000000115223&lft=165&tp=225&pg=5&w=400&ih=55&mr=9&fs=24&hm=1&fs=24&ftop=0&fleft=3&fc=ffffff&bc=68c2e5&cl=000000&sc=1,300,ffffff,68c2e5'
            }
            cursor.focusable[0].items[2] = {
                'name':'乐读六一',
                'linkto':'http://125.62.26.147:82/topic/topic.html?classId=157&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[3] = {
                'name':'乐吃六一',
                'linkto':'http://125.62.26.147:82/topic/topic.html?classId=155&rank=2&urlType=TOPIC'
            }
            setTimeout(function(){ cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
            var focus = cursor.focusable[0].focus;
                cursor.call('loseFocus');
            if( focus < 3 && index === 1 ) {
                focus++;
            }else if( focus > 0 && index === -1 ) {
                focus--;
            }
            cursor.focusable[0].focus = focus;
            cursor.call('show');
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            $("focus"+String(focus)).style.backgroundImage = "url("+focusPics[focus][1]+")";
        },
        loseFocus : function(){
            var focus = cursor.focusable[0].focus;
            $("focus"+String(focus)).style.backgroundImage = "url("+focusPics[focus][0]+")";
        }
    });
    -->
</script>
</html>