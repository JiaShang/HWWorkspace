<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String id = inner.get("id", "1");
%>
<html>
<head>
    <title></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:black url("images/bg-2019-07-01-<%=id%>.jpg") no-repeat left top;' onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({init:function(){
        cursor.backUrl='<%= backUrl %>';
    }});
    -->
</script>
</html>