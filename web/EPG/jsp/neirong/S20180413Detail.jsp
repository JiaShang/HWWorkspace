<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  背景全是图片的专题（模块）
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
    direct:方向，默认为坚，当不为空时为横
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "背景全是图片的专题（模块）" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;background:transparent none no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        init        :   function(){
            cursor.blocked = 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.focusable[0] = {focus:0,items:[{"posters":{"7":["images/bg-2018-04-13-Detail-1.jpg"]}},{"posters":{"7":["images/bg-2018-04-13-Detail-2.jpg"]}}]};
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            //为空时，上下移动，不为空时，左右移动
            var direct = <%= isEmpty(inner.get("direct")) %>;

            if( direct && (index === -1 || index === 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length) ||
               !direct && (index === -11 || index === 11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length)) return;
            focus += (index == 1 || index == -11) ? 1 : -1 ;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },select:function(){return;},
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[focus];
            var picture = cursor.pictureUrl(item.posters,7);
            document.body.style.backgroundImage = 'url("' + picture + '")';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>