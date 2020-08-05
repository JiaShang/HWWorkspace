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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000114402";
    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目

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
    String picture = "images/J20200721ListBg.jpg";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
    Integer direct = null;
    direct = !isNumber( inner.get("direct") ) ? 0 : Integer.valueOf(inner.get("direct"));
%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        #list{
            position: absolute;
            width: 1220px;
            height: 455px;
            left: 0px;
            top:  180px;
        }
        .listName{
            position: absolute;
            width: 233px;
            height: 455px;
            <%--left: <%=bd %>px;--%>
        }
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200721ListBg.jpg)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<%--<div id="focus" style="position: absolute;width: 323px;height: 60px;left: 855px;top: 108px; overflow:hidden; background: url('images/J20200325Focus.png') no-repeat;" ></div>--%>
<div id="list">
    <div id="list0" class="list0">
        <img id="listImg0" class="listImg"/>
        <div id="listName0" class="listName" style="left: 40px;"></div>
    </div>
    <div id="list1" class="list0">
        <img id="listImg1" class="listImg"/>
        <div id="listName1" class="listName" style="left: 225px;"></div>
    </div>
    <div id="list2" class="list0">
        <img id="listImg2" class="listImg"/>
        <div id="listName2" class="listName" style="left: 410px;"></div>
    </div>
    <div id="list3" class="list0">
        <img id="listImg3" class="listImg"/>
        <div id="listName3" class="listName" style="left: 595px;"></div>
    </div>
    <div id="list4" class="list0">
        <img id="listImg4" class="listImg"/>
        <div id="listName4" class="listName" style="left: 780px;"></div>
    </div>
    <div id="list5" class="list0">
        <img id="listImg5" class="listImg"/>
        <div id="listName5" class="listName" style="left: 965px;"></div>
    </div>
</div>
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
                if (typeof o["data"] != 'undefined') {
                    cursor.focusable[i].items = o["data"];
                    for ( var j=0 ; j < cursor.focusable[i].items.length && j < 6 ; j++ ){
                        $("listName"+String(j)).style.backgroundImage = "url("+cursor.focusable[i].items[j].posters[3][0]+")";
                        if (typeof cursor.focusable[i].items[j].posters['5'] != 'undefined') {
                            cursor.focusable[i].items[j] = {
                                'name': o["data"][j].name,
                                'linkto': '/EPG/jsp/neirong/shang/J20200420List.jsp?typeId=' + o["id"] + '&blocked=' + i + '&focus=' + j + "&direct=" +<%=direct%>,
                                'posters': o["data"][j].posters
                            };
                            // adBgImgs = cursor.focusable[i].items[j].posters['5'];
                        } else if (typeof cursor.focusable[i].items[j].posters['99'] != 'undefined') {
                            var namePos = cursor.focusable[i].items[j].name.indexOf("&name=");
                            var name = cursor.focusable[i].items[j].name.substring(namePos + 6);
                            var linkTo = cursor.focusable[i].items[j].name.substring(0, namePos);
                            cursor.focusable[i].items[j] = {
                                'name': name,
                                'linkto': linkTo,
                                'posters': o["data"][j].posters
                            };
                        }
                    }
                    setTimeout(function(){ cursor.call('show');},50);
                }else {
                    cursor.focusable[i].items = [];
                    return;
                }

            }
            // cursor.focusable[0].items[0] = {
            //     'name':'查看图片',
            //     'linkto':'/EPG/jsp/neirong/shang/J20191120List纯图片列表+放大不切换.jsp?typeId=' + cursor.focusable[0].typeId
            // }
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if (items.length == 0) {
                return;
            }
            if( focus < items.length-1 && index === 1 ){
                $("listName"+String(focus)).style.backgroundImage = "url("+cursor.focusable[0].items[focus].posters[3][0]+")";
                focus++;
            }else if ( focus > 0 && index === -1 ) {
                $("listName"+String(focus)).style.backgroundImage = "url("+cursor.focusable[0].items[focus].posters[3][0]+")";
                focus--;
            }
            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;
            cursor.call('show');
        },
        show : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("listName"+String(focus)).style.backgroundImage = "url("+cursor.focusable[0].items[focus].posters[3][1]+")";
        }
    });
    -->
</script>
</html>