<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000111274";
    infos.add(new ColumnInfo(typeId, 0, 1));
    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList(typeId,1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }

    Column column = inner.getDetail("10000100000000090000000000111273",new Column());
    String bodyLeft = "images/bg-2019-03-21-left.jpg",
           bodyTop = "images/bg-2019-03-21-top.jpg",
           bodyRight = "images/bg-2019-03-21-right.jpg",
           bodyBottom = "images/bg-2019-03-21-bottom.jpg";
    if( column != null ) {
        bodyTop = inner.pictureUrl(bodyTop, column.getPosters(), "7",0 );
        bodyLeft = inner.pictureUrl(bodyLeft, column.getPosters(), "7",1 );
        bodyRight = inner.pictureUrl(bodyRight, column.getPosters(), "7",2 );
        bodyBottom = inner.pictureUrl(bodyBottom, column.getPosters(), "7",3 );
    }

%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "晒文化 晒风景" : column.getName()%></title>
    <style>
        .bodyTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:103px;}
        .bodyLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:103px;width:633px;height:345px;}
        .bodyRight {position: absolute;z-index:0;overflow: hidden; left:1222px;top:103px;width:58px;height:345px;}
        .bodyBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:448px;width:1280px;height:272px;}

        .icons {position:absolute; width:526px;height:129px;left:656px;top:486px;background:transparent url("images/mask-2019-03-21.png") no-repeat -700px -250px;}

        .mask{position:absolute;background:transparent url("images/mask-2019-03-21.png") no-repeat 0px 0px; background-position:0px 0px;}
        .mask11 {width:651px;height:408px;left:602px;top:71px;}

        .mask2 {width:161px;height:176px;top:460px;background-position:-1250px 0px;}

        .mask21 {left:625px;}
        .mask22 {left:773px;}
        .mask23 {left:921px;}
        .mask24 {left:1069px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
        <div class='bodyTop'><img src="<%=bodyTop%>"/></div><div class='bodyLeft'><img src="<%=bodyLeft%>"/></div><div class='bodyRight'><img src="<%=bodyRight%>"/></div><div class='bodyBottom'><img src="<%=bodyBottom%>"/></div>
        <div id='mask'></div>
        <div class='icons'></div>
    </div>
    <div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        moviePos : {width:589,height:345,left:633,top:103},
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            //这个用来存放当前播放影片的播放时间
            cursor.focusable[0] = {focus:0,items:[{name:'首页视频',id:<%=vodId%>,style:'mask mask1 mask11'}]};
            cursor.focusable[1] = {focus:this.focused.length > 2 ? Number( this.focused[2] ) : 0,items:[
                {name:'投票通道',linkto:'/EPG/jsp/neirong/S20190321Vote.jsp',style:'mask mask2 mask21'},
                {name:'晒文旅',linkto:'/EPG/jsp/neirong/S20190321List.jsp?typeId=10000100000000090000000000111275&ord=1',style:'mask mask2 mask22'},
                {name:'炫彩60秒',linkto:'/EPG/jsp/neirong/S20190321List.jsp?typeId=10000100000000090000000000111276&ord=2',style:'mask mask2 mask23'},
                {name:'活动介绍',linkto:'/EPG/jsp/neirong/S20190321Act.jsp',style:'mask mask2 mask24'}
            ]};
            cursor.moviePos = this.moviePos;
            cursor.call('show');
            cursor.call('enterSmallMode');
            cursor.call('playMovie');
        },
        playMovie : function(){
            if( <%= vodId %> == 0 ) return;
            try{
                player.exit();
                player.play( {vodId: <%= vodId %>} );
            } catch (e){ }
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
            var pos = cursor.moviePos;
            player.setPosition(pos.left,pos.top,pos.width,pos.height);
            $("listBody").style.display = '';
        },
        select: function() {
            if( cursor.fullmode ) return;
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 0 ) return cursor.call('enterFullMode');
            cursor.call('selectAct');
        },
        nextVideo : function ( ){
            cursor.call('playMovie');
        },
        move : function(index){
            if( cursor.fullmode ) return;
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( blocked == 0 && index != -11 || blocked == 1 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length) ) return;
            if( index == -11 || index == 11) {
                blocked = index == -11 ? 1 : 0; focus = cursor.focusable[blocked].focus;
            } else {
                focus += index;
            }
            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;
            cursor.call('show');
        },
        show: function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className= "mask mask" + String(blocked + 1) + " mask" + String(blocked + 1) + String( focus + 1 );
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>