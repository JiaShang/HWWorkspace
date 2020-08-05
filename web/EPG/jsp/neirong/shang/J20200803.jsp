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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000116660";
//    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

    //////////////////////////有二级栏目/////////////////////
    Column[] subColumns = new Column[5];

    List<Column> columns = inner.getList(typeId, 5, 0 , new Column());//（id，查询数据条数，开始查询位置）
    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
        subColumns[i] = new Column();
        subColumns[i] = inner.getDetail(columns.get(i).id,subColumns[i]);

    }

    //////////////////////////////////////////////////////////
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "images/J20200617Bg.png";
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
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200617Bg.png)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="focus0" style="position: absolute;width: 231px;height: 179px;left: 139px;top: 220px; overflow:hidden; background: url(images/J20200803Focus0.png) no-repeat;" ></div>
<div id="focus1" style="position: absolute;width: 570px;height: 369px;left: 606px;top: 214px; overflow:hidden; background: url(images/J20200803Focus1.png) no-repeat; visibility: hidden;" ></div>
<div id="focus2" style="position: absolute;width: 600px;height: 400px;left: 230px;top: 410px; overflow:hidden; background: none no-repeat;visibility: hidden;" ></div>
<div id="focus3" style="position: absolute;width: 600px;height: 400px;left: 130px;top: 520px; overflow:hidden; background: none no-repeat;visibility: hidden;" ></div>
</body>
<script language="javascript" type="text/javascript">

    <!--
    var subColumns = [];
    var focusPics = [];
    var focusArea = 0;
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
            cursor.lastFocus = 1;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                cursor.focusable[i].items = [];
            }
            var j = 0;
            <%for (int i = 0 ;i <4; i++ ){%>
            subColumns[j] = <%= inner.writeObject(subColumns[i])%>;
            j++;
            <%}%>
            for (var i = 0 ;i <4; i++ ){
                <%--var column = <%= inner.writeObject(subColumns[j+1])%>;--%>
                if (typeof subColumns[i].posters !='undefined' && typeof subColumns[i].posters[3] !='undefined' && subColumns[i].posters[3].length > 0) {
                    focusPics[i] = subColumns[i].posters['3'];
                    if (subColumns[i].posters[3].length == 1) {
                        focusPics[i][1] = ["images/defaultImg.png"];
                    }
                }else {
                    focusPics[i] = ["images/defaultImg.png","images/defaultImg.png"];
                }
                if (i != 0){
                    // $("focus"+String(i)).style.backgroundImage = "url("+focusPics[i][0]+")";
                }
            }
            cursor.focusable[0].items[0] = this.data[0]["data"][0];
            cursor.focusable[1].items[0] = {
                'name':'讲红色故事 讲革命精神',
                'linkto':'/EPG/jsp/neirong/shang/J20200803List.jsp?typeId='+this.data[1]["id"]+'&lft=92&tp=295&w=395&ih=40&mr=1&fs=24&hm=1&pg=8&bc=fce422&fc=000000&cl=000000&sc=530,290,340,d8dddf,fde422&video=590,371,610,274'
            }
            cursor.focusable[2].items[0] = {
                'name':'党史中的六大纪律小故事',
                'linkto':'/EPG/jsp/neirong/shang/J20200803List.jsp?typeId='+this.data[2]["id"]
            }
            cursor.focusable[3].items[0] = {
                'name':'新中国故事汇',
                'linkto':'/EPG/jsp/neirong/shang/J20200803List.jsp?typeId='+this.data[3]["id"]
            }
            cursor.focusable[4].items[0] = {
                'name':'社会主义核心价值观小故事36则',
                'linkto':'/EPG/jsp/neirong/shang/J20200803List.jsp?typeId='+this.data[4]["id"]
            }
            setTimeout(function(){ cursor.call('show');cursor.call('prepareVideo');},150);
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
        playMovie : function(item){
            var pos = [544,345,620,225];
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:pos[0],height:pos[1],left:pos[2],top:pos[3]},
                callback:function(){
                    // cursor.focusable[cursor.blocked].focus = cursor.playIndex;
                    //cursor.call('show');
                    //setTimeout(function(){cursor.call('lazyShow');},50);
                }
            });
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            // cursor.call('loseFocus');
                if( blocked>0 && blocked < 3 && index === -11 ) {
                    blocked = blocked+2;
                }else if( blocked > 2 && index === 11 ) {
                    blocked = blocked-2;
                }else if (index === 1) {  //右
                    if (blocked%2 == 1){
                        blocked ++;
                    }else if (blocked%2 == 0 && blocked !=0 ){
                        cursor.lastFocus = blocked;
                        blocked = 0;
                    }
                }else if (index === -1) {  //左
                    if (blocked%2 == 0 && blocked != 0) {
                        blocked --;
                    }else if (blocked == 0) {
                        blocked = cursor.lastFocus;
                    }
                }
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show : function(){
            var blocked = cursor.blocked;
            if (blocked >0){
                var i = (blocked+1)%2;
                $("focus1").style.visibility = "hidden";
                $("focus0").style.visibility = "visible";
                $("focus0").style.left = String(139+236*i)+"px";
                $("focus0").style.top = String(220+181*Math.floor((blocked-1)/2))+"px";
            } else {
                $("focus1").style.visibility = "visible";
                $("focus0").style.visibility = "hidden";
            }

        },
        loseFocus : function(){
            var focus = cursor.focusable[0].focus;
            if (focus >0){
                $("focus"+String(focus)).style.backgroundImage = "url("+focusPics[focus][0]+")";
            } else {
                $("focus"+String(focus)).style.visibility = "hidden";
            }
        }
    });
    -->
</script>
</html>