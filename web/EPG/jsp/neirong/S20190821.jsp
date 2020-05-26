<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000112427";//

    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList(typeId,1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }

    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2019-08-21.png" : inner.pictureUrl("images/bg-2019-08-21.png",column.getPosters(),"7");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "绿水青山 美好家园" : column.getName()%></title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-08-21.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:568px;height:381px;left:93px;top:214px;background-position: 0px 0px;}
        .mask2 {width:190px;height:68px;left:287px;top:592px;background-position: 0px -400px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div style="background:transparent url('<%=picture%>') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
    <div id='mask' ></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.fullmode = false;

            cursor.focusable[0] = {
                focus : this.focused.length > 1 ? Number( this.focused[1] ) : 0,
                items : [
                    {name:'小窗口视频',vodid:'<%=vodId%>'},
                    {name:'活动页',linkto:'/EPG/jsp/neirong/S20190821Detail.jsp'}
                ]
            }

            setTimeout(function(){
                cursor.call('enterSmallMode');
                cursor.call('playMovie');
            },50);

            cursor.call('show');
        },
        playMovie : function(){
            try{
                var vodId = <%=vodId%>;
                if( vodId == 0 ) return;
                player.exit();
                player.play( {vodId: vodId} );
            } catch (e){ }
        },
        nextVideo : function ( ){
            cursor.call('playMovie');
        },
        prepareVideo : function(){
            cursor.call('playMovie');
        },
        goBack : function(){
            if( cursor.fullmode )  return cursor.call('enterSmallMode');
            cursor.call('goBackAct');
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            $("listBody").style.display = 'none';
            player.fullScreen();
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = {width:535,height:351,left:109,top:230};
            player.setPosition(pos.left,pos.top,pos.width,pos.height);
            $("listBody").style.display = '';
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            if( cursor.fullmode) return;
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus >= 1 ) return;
            focus += index > 0 ? -1 : 1;
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        select:function(){
            if( cursor.fullmode) return cursor.call('enterSmallMode');
            var focus = cursor.focusable[0].focus;
            if( focus == 0 ) return cursor.call('enterFullMode');
            cursor.call('selectAct');
        },
        show: function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className = "mask mask" + String(focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>