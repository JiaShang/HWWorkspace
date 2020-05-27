<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
    <title></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:black url("images/bg-2019-09-24.jpg") no-repeat;' onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        init:function(){
            cursor.backUrl='<%= backUrl %>';
            if( query('isBack').isEmpty() ) setTimeout(function(){ cursor.call('select') }, 15 * 1000);
        },
        select:function(){
            //10000100000000090000000000112741
            //10000100000000090000000000112741
            window.location.href = cursor.linkto("/EPG/jsp/neirong/STemplateOneRow.jsp?typeId=10000100000000090000000000112741&row=2&tp=206&bd=5&fs=18&lft=84&row=2&ct=4&wh=242&ht=130&mh=90&mt=10&cl=ffffff&fc=00ffff&bc=00ffff");
        }
    });
    -->
</script>
</html>