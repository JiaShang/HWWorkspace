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
    <meta charset="GB18030">
    <title><%=column == null ? "仅一张背景图,无任何元素的专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .mask {position:absolute;width:1094px;height:518px;left:96px;top:144px;background: transparent url("images/mask-2018-10-18-Detail.png") no-repeat left top; background-position: 42px 33px;}

        .mask1{background-position: 42px 33px;}
        .mask2{background-position: 42px -443px;}
        .mask3{background-position: 42px -954px;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:transparent url("images/bg-2018-10-18-Detail.jpg") no-repeat;' onUnload="exit();">
<div class="mask mask1" id="mask"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({init:function(){
        cursor.cc = 0;
        cursor.backUrl='<%= backUrl %>';
    }, move : function(index){
        if( index == 11 || index == -11 || index == -1 && cursor.cc <= 0 || index == 1 && cursor.cc >= 2 ) return;
        cursor.cc += index;
        $("mask").className = 'mask mask' + String(cursor.cc + 1);
        }});
    -->
</script>
</html>