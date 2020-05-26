<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "";

    //获取当前栏目的详细信息
    Column column = new Column();
    //column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2019-11-25-role.jpg" : inner.pictureUrl("images/bg-2019-11-25-role.jpg",column.getPosters(),"7");
%>
<html>
<head>
    <title>2019国际女子半马最美笑脸票选活动规则</title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:black url("<%= picture %>") no-repeat;' onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({init:function(){
        cursor.backUrl='<%= backUrl %>';
    }});
    -->
</script>
</html>