<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = inner.get("typeId","10000100000000090000000000112262");

    Column column = inner.getDetail(typeId,new Column());
    String body = "images/bg-2019-08-03.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );

    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList(typeId,1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "¿¼²ì" : column.getName()%></title>
    <style>
        .body {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:720px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div class='body'><img src="<%=body%>"/></div>
</div>
<div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        init : function(){
            cursor.backUrl='<%= backUrl %>';
            cursor.call("prepareVideo");
        },
        playMovie : function(){
            try{
                player.exit();
                var pos = {width:694,height:391,left:57,top:223};
                player.setPosition(pos.left,pos.top,pos.width,pos.height);
                player.play( {vodId: <%=vodId%> } );
            } catch (e){ }
        },
        nextVideo : function ( ){
            cursor.call("playMovie");
        },
        prepareVideo : function(){
            cursor.call("playMovie");
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>