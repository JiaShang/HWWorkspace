<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "仅一张背景图,无任何元素的专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:black  url("images/bg-2019-03-21-Vote.jpg") no-repeat;' onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({init:function(){
        cursor.backUrl='<%= backUrl %>';
    }});
    -->
</script>
</html>