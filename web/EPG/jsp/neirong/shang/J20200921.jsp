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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000118120";
//    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
    Column[] subColumns = new Column[6];

    List<Column> columns = inner.getList(typeId, 6, 0 , new Column());//（id，查询数据条数，开始查询位置）
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
<div id="focus0" style="position: absolute;width: 600px;height: 300px;left: 60px;top: 380px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus1" style="position: absolute;width: 600px;height: 300px;left: 480px;top: 295px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus2" style="position: absolute;width: 600px;height: 300px;left: 860px;top: 320px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus3" style="position: absolute;width: 600px;height: 300px;left: 560px;top: 430px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus4" style="position: absolute;width: 600px;height: 300px;left: 790px;top: 530px; overflow:hidden; background: none no-repeat;" ></div>
<div id="focus5" style="position: absolute;width: 600px;height: 300px;left: 1000px;top: 450px; overflow:hidden; background: none no-repeat;" ></div>
</body>
<script language="javascript" type="text/javascript">

    <!--
    var subColumns = [];
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
            var j = 0;
            <%for (int i = 0 ;i <6; i++ ){%>
                subColumns[j] = <%= inner.writeObject(subColumns[i])%>;
                j++;
            <%}%>
            for (var i = 0 ;i <6; i++ ){
                <%--var column = <%= inner.writeObject(subColumns[j+1])%>;--%>
                if (typeof subColumns[i].posters !='undefined' && typeof subColumns[i].posters[3] !='undefined' && subColumns[i].posters[3].length > 0) {
                    focusPics[i] = subColumns[i].posters['3'];
                    if (subColumns[i].posters[3].length == 1) {
                        focusPics[i][1] = ["images/defaultImg.png"];
                    }
                }else {
                    focusPics[i] = ["images/defaultImg.png","images/defaultImg.png"];
                }
                $("focus"+String(i)).style.backgroundImage = "url("+focusPics[i][0]+")";
            }
            cursor.focusable[0].items[0] = {
                'name':'乐游六一',
                'linkto':"/EPG/jsp/neirong/shang/J20191217.jsp?typeId="+cursor.focusable[0].typeId+"&video=645,345,33,132"
            }
            cursor.focusable[0].items[1] = {
                'name':'乐看六一',
                'linkto':"/EPG/jsp/neirong/shang/J20191217.jsp?typeId="+cursor.focusable[1].typeId+"&video=645,345,33,132"
            }
            cursor.focusable[0].items[2] = {
                'name':'乐读六一',
                'linkto':"/EPG/jsp/neirong/shang/J20191217.jsp?typeId="+cursor.focusable[2].typeId+"&video=645,345,33,132"
            }
            cursor.focusable[0].items[3] = {
                'name':'乐吃六一',
                'linkto':"/EPG/jsp/neirong/shang/J20191217.jsp?typeId="+cursor.focusable[3].typeId+"&video=645,345,33,132"
            }
            cursor.focusable[0].items[4] = {
                'name':'乐读六一',
                'linkto':"/EPG/jsp/neirong/shang/J20191217.jsp?typeId="+cursor.focusable[4].typeId+"&video=645,345,33,132"
            }
            cursor.focusable[0].items[5] = {
                'name':'乐吃六一',
                'linkto':"/EPG/jsp/neirong/shang/J20191217.jsp?typeId="+cursor.focusable[5].typeId+"&video=645,345,33,132"
            }
            setTimeout(function(){ cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
            var focus = cursor.focusable[0].focus;
                cursor.call('loseFocus');
            if( focus != 2 && focus != 5 && index === 1 ) {
                focus++;
            } else if( focus > 0 && index == -1 && focus!=3) {
                focus--;
            }else if(focus == 3 && index == -1){
                focus = 0;
            }else if(focus == 1 && index == -11){
                focus = focus+2;
            }else if(focus == 2 && index == -11){
                focus = focus+3;
            }else if(focus == 5 && index == 11){
                focus = 2;
            }else if(focus > 2 && index == 11){
                focus = focus-2;
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