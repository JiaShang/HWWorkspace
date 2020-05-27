<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000111282";
    infos.add(new ColumnInfo(typeId, 0, 99));
    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList("10000100000000090000000000111281",1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }

    Column column = inner.getDetail("10000100000000090000000000111280",new Column());
    String bodyLeft = "images/bg-2019-03-22-left.jpg",
           bodyTop = "images/bg-2019-03-22-top.jpg",
           bodyRight = "images/bg-2019-03-22-right.jpg",
           bodyBottom = "images/bg-2019-03-22-bottom.jpg";
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
        .bodyTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:139px;}
        .bodyLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:139px;width:594px;height:324px;}
        .bodyRight {position: absolute;z-index:0;overflow: hidden; left:1168px;top:139px;width:112px;height:324px;}
        .bodyBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:463px;width:1280px;height:257px;}

        .flowed {position:absolute; width:526px;height:129px;left:656px;top:486px;background:transparent url("images/mask-2019-03-22.png") no-repeat -700px -250px;}

        .mask{position:absolute;background:transparent url("images/mask-2019-03-22.png") no-repeat 0px 0px; background-position:0px 0px;}
        .mask11 {width:596px;height:349px;left:583px;top:126px;}

        .mask2 {width:197px;height:146px;top:474px;background-position:0px -400px;}

        .mask21 {left:578px;}
        .mask22 {left:775px;}
        .mask23 {left:972px;}

        .item {width:197px;height:128px;overflow: hidden;position:relative; float:left;}
        .img {width:179px;height:128px;position:absolute;left: 0px;top:0px;}
        .img img{width:100%;height:100%;}
        .after{width:600px;height:150px;overflow: hidden;position:absolute;left:587px;top:483px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
        <div class='bodyTop'><img src="<%=bodyTop%>"/></div><div class='bodyLeft'><img src="<%=bodyLeft%>"/></div><div class='bodyRight'><img src="<%=bodyRight%>"/></div><div class='bodyBottom'><img src="<%=bodyBottom%>"/></div>
        <div id='mask'></div>
        <div class='after' id="after"></div>
    </div>
    <div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        moviePos : {width:574,height:324,left:594,top:139},
        data        : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
        %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            //这个用来存放当前播放影片的播放时间
            cursor.moviePos = this.moviePos;

            cursor.focusable[0] = {focus:0,items:[{name:'首页视频',id:<%=vodId%>,style:'mask mask1 mask11'}]};
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i + 1] = {};
                cursor.focusable[i + 1].typeId = o["id"];
                cursor.focusable[i + 1].focus = this.focused.length > i + 2 ? Number( this.focused[ i + 2] ) : 0;
                cursor.focusable[i + 1].items = o["data"];
            }
            cursor.call('showUI');
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
        showUI : function(){
            var blocked = 1;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var html = '';
            var pageCount = 3;
            var defaultIndex = Math.floor(pageCount / 2.0);
            var flowCursorIndex = focus < defaultIndex ? 0 : focus - defaultIndex;
            if( flowCursorIndex + pageCount >= items.length ) flowCursorIndex = items.length - pageCount;
            if( flowCursorIndex < 0 ) flowCursorIndex = 0;

            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var picture = cursor.pictureUrl(item.posters,0,'');
                html += '<div class="item"><div class="img">' + ( picture.isEmpty() ? '' : ('<img src="' + picture + '" />')) + "</div></div>";
            }
            $("after").innerHTML = html;
        },
        show: function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 1 ) cursor.call('showUI');
            var items = cursor.focusable[blocked].items;
            $("mask").className= "mask mask" + String(blocked + 1) + " mask" + String(blocked + 1) + String( ( blocked == 0 ? focus : ( focus == 0 ? 0 : focus + 1 >= items.length ? 2 : 1 )) + 1 );
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>