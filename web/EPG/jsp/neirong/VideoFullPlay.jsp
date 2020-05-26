<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
    <title>播放视频</title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent none no-repeat;" onUnload="exit();">
<script type="text/javascript" language="JavaScript">
    cursor.initialize({
        init: function(){
            cursor.backUrl='<%= backUrl %>';
            cursor.vodId = link.query("vodId");
            cursor.serviceId = link.query("serviceId");
            cursor.frequency = link.query("frequency");
            setTimeout(function(){
                cursor.call('prepare');
            },50);
        },
        prepare : function(){
            player.setPosition(0,0,1280,720);
            if( cursor.vodId.isEmpty() ) {
                player.play({
                    serviceId: Number(cursor.serviceId),
                    frequency: Number(cursor.frequency)
                });
            } else {
                player.play({ vodId: cursor.vodId });
            }
        },
        nextVideo : function (){
            cursor.call('prepare');
        }
    });
</script>
</html>