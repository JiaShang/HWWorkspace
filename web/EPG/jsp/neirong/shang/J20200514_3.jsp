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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114947";
//    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
    List<Column> columns = inner.getList(typeId, 4, 0 , new Column());//（id，查询数据条数，开始查询位置）
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
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
<div id="focus0" style="position: absolute;width: 126px;height: 72px;left: 240px;top: 110px; overflow:hidden; background: url('images/J20200514_3Focus00.png') no-repeat;" ></div>
<div id="focus1" style="position: absolute;width: 137px;height: 77px;left: 490px;top: 250px; overflow:hidden; background: url('images/J20200514_3Focus10.png') no-repeat;" ></div>
<div id="focus2" style="position: absolute;width: 158px;height: 71px;left: 100px;top: 480px; overflow:hidden; background: url('images/J20200514_3Focus20.png') no-repeat;" ></div>
<div id="focus3" style="position: absolute;width: 125px;height: 72px;left: 500px;top: 470px; overflow:hidden; background: url('images/J20200514_3Focus30.png') no-repeat;" ></div>
</body>
<script language="javascript" type="text/javascript">

    <!--
    var listData = [["images/J20200514_3Focus00.png","images/J20200514_3Focus01.png"],
        ["images/J20200514_3Focus10.png","images/J20200514_3Focus11.png"],
        ["images/J20200514_3Focus20.png","images/J20200514_3Focus21.png"],
        ["images/J20200514_3Focus30.png","images/J20200514_3Focus31.png"]];
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
                'name':'博物馆的故事',
                'linkto':'/EPG/jsp/neirong/shang/J20200514_3List.jsp?typeId='+cursor.focusable[0].typeId+'&lft=165&tp=227&pg=5&w=400&ih=60&mr=5&fs=24&hm=1&fs=22&ftop=0&fleft=3&fc=3a8086&bc=fff1c0&cl=000000&sc=1,380,ffffff,fff1c0'
            }
            cursor.focusable[0].items[1] = {
                'name':'博物馆活动指南',
                'linkto':'http://125.62.26.147:82/topic/topic.html?classId=149&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[2] = {
                'name':'非去不可的博物馆',
                'linkto':'http://125.62.26.147:82/topic/topic.html?classId=147&rank=2&urlType=TOPIC'
            }
            cursor.focusable[0].items[3] = {
                'name':'博物馆有好货',
                'linkto':'http://125.62.26.147:82/topic/topic.html?classId=151&rank=2&urlType=TOPIC'
            }
            setTimeout(function(){ cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var focus = cursor.focusable[0].focus;
            cursor.call('loseFocus');
        if( focus < 2 && index === -11 ){
            focus = focus+2;
        }else if ( focus > 1 && index === 11 ) {
            focus = focus-2;
        }else if( focus%2 == 0 && index === 1 ) {
            focus++;
        }else if( focus%2 == 1 && index === -1 ) {
            focus--;
        }
            cursor.focusable[0].focus = focus;
        cursor.call('show');
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            $("focus"+String(focus)).style.backgroundImage = "url(images/J20200514_3Focus"+String(focus)+"1.png)";
        },
        loseFocus : function(){
            var focus = cursor.focusable[0].focus;
            $("focus"+String(focus)).style.backgroundImage = "url(images/J20200514_3Focus"+String(focus)+"0.png)";
        }
    });
    -->
</script>
</html>