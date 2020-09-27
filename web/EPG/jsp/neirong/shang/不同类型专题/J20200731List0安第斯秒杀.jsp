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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000116602";
    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目
//    List<Column> columns = inner.getList(typeId, 3, 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
//    }

    //////////////////////////有二级栏目/////////////////////
//    Column column = new Column();
//    List<Column> columns = inner.getList(typeId, 3, 0, column);   //（id，查询数据条数，开始查询位置）
//    for( Column col : columns ) {
//        infos.add(new ColumnInfo(col.getId(), 0, 5));
//    }
//    Result result = new Result( typeId, columns );
    //////////////////////////////////////////////////////////

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
//    picture = "images/J20200731List0Bg.jpg";


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
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200730Bg.jpg)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="tooltip" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;">
    <div id="tip" style="position: absolute;left: 410px; top: 240px;width: 400px;height: 60px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #ffffff;font-size: 28px;">
    </div>
    <div id="phone" style="position: absolute;left: 420px; top: 326px;width: 420px;height: 50px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #0e0e0b;font-size: 26px;">
    </div>
    <div id="tipFlagFocus" style="position: absolute;left: 510px; top: 420px;width: 226px;height: 53px;visibility: hidden;overflow: hidden; background:transparent url('images/AnswerButton30.png') no-repeat;z-index: 2;">
    </div>
</div>
<div id="focus" style="position: absolute;width: 254px;height: 81px;left: 982px;top: 562px; overflow:hidden; background: url('images/J20200731List0Focus1.png') no-repeat;" ></div>
<div id="data" style="position: absolute;width: 484px;height: 361px;left: 139px;top: 294px; overflow:hidden; background: no-repeat;visibility: visible;" ></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var tipFlag = -1;
    var picPos = 1;
    var codePic = [];
    var startTime0 = new Date("2020-08-07 10:0:0").getTime();
    var startTime1 = new Date("2020-08-08 10:0:0").getTime();
    var startTime2 = new Date("2020-08-09 10:0:0").getTime();
    var startTime3 = new Date("2020-08-10 10:0:0").getTime();
    var startTime4 = new Date("2020-08-11 10:0:0").getTime();
    var endTime0 = new Date("2020-08-07 23:59:59").getTime();
    var endTime1 = new Date("2020-08-08 23:59:59").getTime();
    var endTime2 = new Date("2020-08-09 23:59:59").getTime();
    var endTime3 = new Date("2020-08-10 23:59:59").getTime();
    var endTime4 = new Date("2020-08-11 23:59:59").getTime();
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
                if(typeof o["data"] != 'undefined'){
                    cursor.focusable[i].items = o["data"];
                }else {
                    cursor.focusable[i].items = [];
                }

            }
            var column = <%= inner.writeObject(column)%>;
            var posters = column.posters['5'];
            codePic = column.posters['99'];
            cursor.focusable[0] = {focus:0,items:[]};
            for( var i = 0; i < posters.length; i ++ ){
                cursor.focusable[0].items[i] = {
                    'name':'pic' +String( i + 1),
                    'posters':{'5':[posters[i]]}
                };
            }
            // setInterval(cyclicPic,3000);
            $("data").style.backgroundImage = "url("+posters[0]+")";
            setInterval(function(){
                var length = posters.length;
                if (picPos < length-1){
                    picPos ++ ;
                } else {
                    picPos = 0 ;
                }
                $("data").style.backgroundImage = "url("+posters[picPos]+")"
            },3000);
        },
        select : function(){
            if (tipFlag == -1){
                var currentTime = new Date().getTime();
                if (currentTime < startTime0 || ( endTime0 < currentTime  && currentTime < startTime1) ||
                    ( endTime1 < currentTime  && currentTime < startTime2) || ( endTime2 < currentTime  && currentTime < startTime3)
                || ( endTime3 < currentTime  && currentTime < startTime4)) {
                    cursor.call('showTip',0);   //还未到时间
                }else if (currentTime > endTime4) {
                    cursor.call('showTip',3);   //已结束
                }else {
                    cursor.call('showTip',99);
                }
            } else {
                cursor.call('loseTip');
            }
        },
        goBack : function(){
            if (tipFlag > 0 ){
                    cursor.call('loseTip');
            }else {
                cursor.call('goBackAct');
            }
        },
        showTip : function(id){
            tipFlag = id;
            if (tipFlag == 99) {
                $("tooltip").style.backgroundImage = 'url(' + codePic[0] + ')';
                // $("tooltip").style.backgroundImage = 'url(images/codePic.jpg)';
                $("tooltip").style.visibility = 'visible';
            }else {
                $("tooltip").style.backgroundImage = 'url("images/Answer' + String(id) + '.png")';
                $("tooltip").style.visibility = 'visible';
            }
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                if(tipFlag >= 0 && tipFlag < 4){
                    cursor.call('loseTip');
                }
            }, 3000);
        },
        loseTip : function(){
            tipFlag = -1;
            $("tooltip").style.visibility = 'hidden';
        },
        cyclicPic : function () {
            var length = cursor.focusable[0].items[0].posters['5'].length;
            if (picPos < length-1){
                picPos ++ ;
            } else {
                picPos = 0 ;
            }
            $("data").style.backgroundImage = "url("+cursor.focusable[0].items[0].posters['5'][picPos]+")"

        }
    });
    -->
</script>
</html>