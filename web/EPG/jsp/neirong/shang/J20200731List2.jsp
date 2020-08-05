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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000116604";
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
<div id="focus0" style="position: absolute;width: 297px;height: 81px;left: 325px;top: 352px; overflow:hidden; background: url('images/J20200730Focus01.png') no-repeat;visibility: hidden;" ></div>
<div id="focus1" style="position: absolute;width: 297px;height: 81px;left: 659px;top: 352px; overflow:hidden; background: url('images/J20200730Focus10.png') no-repeat;visibility: hidden;" ></div>
<div id="data" style="position: absolute;width: 650px;height: 680px;left: 690px;top: 70px; overflow:hidden; background: no-repeat;" ></div>
<div id="page" style="position: absolute;left: 1120px;top: 650px;width: 100px;height: 80px;font-size: 40px;color:#FFCC00;z-index: 2;text-align: center;line-height: 60px;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var picPos = 0;
    var posters = [];
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
            posters = column.posters['5'];
            setTimeout(function(){
                cursor.call('prepareVideo');
                cursor.call('show');},200);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        // var blocked = cursor.blocked;
        // var focus = cursor.focusable[blocked].focus;
        // var items = cursor.focusable[blocked].items;
        var length = posters.length;
        // cursor.call('loseFocus');
        if( index === -11 ){ // 下
            if(picPos < length -1 ){
                picPos++;
            } else{
                picPos = 0;
            }
        }else if ( index === 11 ) { //上
            if(picPos > 0 ){
                picPos--;
            } else{
                picPos = 0;
            }
        }
        cursor.call('show');
        },
        show : function(){
            // var blocked = cursor.blocked;
            $("data").style.backgroundImage = "url("+posters[picPos]+")";
            $("page").innerText = picPos+1+"/"+posters.length;
        },
        loseFocus:function () {
            var blocked = cursor.blocked;
            $("data").style.backgroundImage = "url(images/J20200730Focus"+blocked+"0.png)";
        },
        nextVideo: function () {
            // var playIndex = cursor.playIndex;
            var playIndex = 0;
            // cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        prepareVideo: function () {
            // var playIndex = cursor.playIndex;
            var playIndex = 0;
            if (cursor.focusable[0].items.length <= 0) return;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie", item);
        },
        playMovie: function (item) {
            var pos = [614,350,70,308];
            var items = cursor.focusable[0].items;
            player.exit();
            // alert("iPanel.HD30Adv==="+iPanel.HD30Adv+",,,,items.length =="+items.length);
            var VODflag = getStrParams("VODflag",items[0].name);
            if (items.length ==2 && !iPanel.HD30Adv) {
                if (VODflag == 1){
                    player.play({
                        position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                        channelId: cursor.channelId,
                        program: cursor.program
                    });
                } else {
                    player.play({
                        position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                        serviceId: cursor.serviceId,
                        frequency: cursor.frequency
                    });
                }

            }else {
                player.play({
                    vodId: item.id,
                    position: {width: pos[0], height: pos[1], left: pos[2], top: pos[3]},
                    callback: function () {
                        // cursor.focusable[cursor.blocked].focus = cursor.playIndex;
                        //cursor.call('show');
                        //setTimeout(function(){cursor.call('lazyShow');},50);
                    }
                });
            }
        }
    });
    -->
</script>
</html>