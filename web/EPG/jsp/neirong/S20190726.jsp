<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000112180";
    List<Column> columns = inner.getList(typeId,4,0,new Column());
    Result parent = new Result(typeId,columns);
    for( Column col : columns ) infos.add(new ColumnInfo(col.id,0,99));

    Column column = inner.getDetail(typeId,new Column());
    String body = "images/bg-2019-07-26.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "绿水青山 美好家园" : column.getName()%></title>
    <style>
        .body {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:720px;}

        .major {width:479px;height:360px;position:absolute;left:104px;top:223px;overflow: hidden;}
        .majorContainer,.majorContainerFocus{width:479px;height:59px;float: left;overflow: hidden;background:transparent url('images/mask-2019-07-26.png') no-repeat;background-position: 0px 0px;}
        .majorContainer {background-position:0px -70px;}
        .majorContainerFocus {background-position:0px -9px;}

        .majorContainer .item,.majorContainerFocus .item,.majorContainerFocus .item .marquee {width:450px;height:59px;line-height:62px;font-size: 22px;}
        .majorContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 40px;}
        .majorContainerFocus .item {color:red;margin:0px 0px 0px 40px;}

        .icons {width:623px;height:105px;left:650px;top:540px;overflow: hidden;position:absolute;}
        .iconsContainer,.iconsContainerFocus {width:135px;height: 103px;float: left;}
        .iconsContainer div,.iconsContainerFocus div {width:130px;height:103px;}
        .iconsContainer div img,.iconsContainerFocus div img{width:100%;height:100%;}

        .flowed {position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;background-image: none;}
        .flowedBody {position:absolute;width:883px;left:204px;top:236px;height:390px;overflow: hidden;}

        .flowedContainer,.flowedContainerFocus{width:882px;height:63px;float:left;overflow: hidden;background:transparent url('images/mask-2019-07-26.png') no-repeat;background-position: 0px 0px;}
        .flowedContainer {background-position:0px -250px;}
        .flowedContainerFocus {background-position:0px -160px;background-color: white;}

        .flowedContainer .item,.flowedContainerFocus .item,.flowedContainerFocus .item .marquee {width:841px;height:63px;line-height:60px;font-size: 24px;}
        .flowedContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 40px;}
        .flowedContainerFocus .item {color:red;margin:0px 0px 0px 40px;}

        .mask{position:absolute;background:transparent url('images/mask-2019-07-26.png') no-repeat;background-position: 0px 0px;}

        .mask1{width:196px;height:119px;}
        .mask11{background-position: 0px -550px;}
        .mask12{background-position: -250px -550px;}
        .mask13{background-position: -500px -550px;}

        .mask2{width:510px;height:72px;background-position: -20px -350px;}
        .mask3,.mask4,.mask5,.mask6{width:910px;height:72px;background-position: -20px -450px;}

        .bodyTop img,.bodyLeft img,.bodyRight img,.bodyBottom img,.mask img{width:100%;height:100%;}
        .speed {width:300px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}

        .page {width:22px;height:16px;left:1181px;position:absolute;color:#cecece;font-size:16px;overflow: hidden;text-align: center;}
        .number {top:323px;}
        .count {top:346px;}

        .title{width:600px;height: 50px; position: absolute; left:250px;top:165px; background:transparent url('images/mask-2019-07-26.png') no-repeat;background-position: 0px 0px;}
        .title1{background-position: 0px -700px; }
        .title2{background-position: 0px -750px; }
        .title3{background-position: 0px -800px; }

        .icons{left: 681px;top: 540px;width: 477px;height: 74px;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div style="position:absolute;z-index:0;width:2500px;height:45px;top:0px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
        <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
    </div>
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
        <div class='body'><img src="<%=body%>"/></div>
        <div class='major' id='major'></div>
        <div class='flowed' id='flowed' style="visibility: hidden;"></div>
        <div id="pageNum" class="page number">0</div>
        <div id="pageCount" class="page count">0</div>
        <div id='mask'></div>
    </div>
    <div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        moviePos : {width:538,height:315,left:651,top:202},
        data : [<%
                String html = "";
                html += inner.resultToString(parent,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            //这个用来存放当前播放影片的播放时间
            cursor.moviePos = this.moviePos;
            cursor.speed = 1;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = -1;
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            //删除第一个
            cursor.focusable[0].items.removeAt(0);
            //第三个是专题连接
            cursor.playIndex = cursor.focusable[0].focus;


            for( var i = 0; i < this.data.length; i ++)
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;

            cursor.call('show');
            cursor.call('enterSmallMode');
            cursor.call('lazyShow');
        },
        playMovie : function(item){
            if( typeof item === 'undefined' )return;
            try{
                player.exit();
                debug("S20190528 ==> Before call player.play({vodId: ", item.id,'});');
                player.play( {vodId: item.id} );
            } catch (e){ }
        },
        goBack : function(){
            if( cursor.fullmode ){
                cursor.call(cursor.blocked >= 2 ? 'stop' : "enterSmallMode");
                $("listBody").style.visibility = 'visible';
                cursor.call("show");
                return;
            }
            if( cursor.blocked >= 2 ) {
                cursor.blocked = 0;
                cursor.call('prepareVideo');
                cursor.call('enterSmallMode');
                cursor.call('show');
                return;
            }
            cursor.call("goBackAct");
        },
        interval : function(){
            if( cursor.fullmode && cursor.speed === 1 ) {
                var elapsed = 6 - cursor.elapsedSeconds();
                if( elapsed <= 0 ) {
                    $("speed").style.visibility = 'hidden';
                    return;
                }
            }
            $("speed").innerHTML = cursor.speed == 1 ? "播放" : "x" + ( Math.abs(cursor.speed) + " "  + ( cursor.speed > 0 ? "快进 " : "快退 " )) ;
            $("speed").style.visibility = cursor.fullmode ? 'visible' : 'hidden';
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            cursor.call('resumePlay');
            $("listBody").style.visibility = 'hidden';
            player.fullScreen();
            cursor.timer = setInterval(function(){cursor.call('interval');},1000);
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = cursor.moviePos;
            player.setPosition(pos.left,pos.top,pos.width,pos.height);
            $("listBody").style.visibility = 'visible';
            cursor.call('resumePlay',true);
            if( cursor.timer ) {
                clearInterval(cursor.timer);
                cursor.timer = undefined;
                $("speed").style.visibility = 'hidden';
            }
        },
        resumePlay : function(resume){
            cursor.starter = new Date().getTime();
            if( resume ) { cursor.speed = 1; player.resume(); }
        },
        stop : function(){
            player.setPosition(1280,720,1,1);
            player.pause();
            if( iPanel.mediaType == 'P60' ) sysmisc.bringToForeground("web");
            cursor.fullmode = false;
        },
        select: function() {
            if( cursor.focusable.length <= 0 ) return;
            if( cursor.fullmode ) { if(cursor.speed != 1 ) cursor.call('resumePlay',true); return;}

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];
            var url = '';
            if( blocked === 0 ) {
                cursor.blocked = focus + 2;
                cursor.call('stop');
                cursor.call('show');
                cursor.call('lazyShow');
                return;
            }
            if(blocked === 1){
                debug("S20190528 ==> cursor.fullmode : ", cursor.fullmode );
                cursor.call('enterFullMode');
                if( cursor.playIndex !== focus ) {
                    cursor.playIndex = focus;
                    cursor.call("playMovie",item);
                }
                return;
            }
            cursor.call('selectAct');
        },
        nextVideo : function ( ){
            if( cursor.blocked >= 2 ) { cursor.call('goBack'); return; }
            if( !cursor.moveTimer ) {
                var playIndex = cursor.playIndex;
                playIndex = playIndex + 1 < cursor.focusable[1].items.length ? playIndex + 1 : 0;
                cursor.focusable[1].focus = cursor.playIndex = playIndex;
                if( !cursor.fullmode ) cursor.call('show');
                debug("S20190528 ==> nextVideo -> lazyShow ");
                cursor.call('lazyShow');
            }
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( cursor.focusable[1].items.length <= 0 )return;
            var item = cursor.focusable[1].items[playIndex];
            cursor.call("playMovie",item);
        },
        move : function(index){
            //上 11，下 -11，左 -1，右 1
            if( cursor.fullmode ) {
                if( index === 11 || index == -11 ) return;
                if( index == -1 && cursor.speed > -32) {
                    cursor.speed = cursor.speed >= 1 ? -2 : Math.abs(cursor.speed) * -2;
                    player.backward(cursor.speed);
                } else if( index == 1 && cursor.speed < 32 ){
                    cursor.speed = cursor.speed <= 1 ? 2 : Math.abs(cursor.speed) * 2;
                    player.forward(cursor.speed);
                }
                cursor.call('resumePlay');
                return;
            }

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked !== 0 && ( index === 11 && focus <= 0 || index === -11 && focus + 1 >= items.length  ) ||
                blocked >= 2 && (index === -1 || index === 1 ) ||
                blocked === 1 && ( index === -1 ) ||
                blocked === 0 && ( index === 11 || index === -11 || index === 1 && focus + 1 >= items.length )
            ) return;
            if( blocked != 0 ) {
                if( index === 11 || index === -11 ) {
                    focus += index > 0 ? -1 : 1;
                } else if( blocked === 1 && index === 1 ){
                    blocked = 0; focus = 0;
                }
            } else {
                focus += index;
                if( focus < 0 ) {
                    blocked = 1; focus = cursor.focusable[blocked].focus;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('clearMoveTimer');
            cursor.moveTimer = setTimeout(function(){ cursor.call('clearMoveTimer');cursor.call('lazyShow');}, 1500);
            cursor.call('show');
        },
        clearMoveTimer : function(){
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = undefined;
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            if( blocked == 0 ) blocked = 1;

            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(blocked + 1) + String( focus + 1 );
            var fontsize = blocked === 1 ? 22 : 24;
            var width = blocked === 1 ? 450 : 848;
            if( cursor.played == '' || cursor.blocked <= 1 && cursor.played != id ) {
                cursor.playIndex = focus;
                cursor.call('prepareVideo');
                cursor.calcStringPixels(text, fontsize, function(pixelsWidth){
                    if( pixelsWidth <= width || cursor.blocked != blocked ) return;
                    $('item' + id).innerHTML  = '<marquee class="marquee" scrollamount="8">' + text + "</marquee>";
                });
                cursor.played = id;
            }
        },
        show: function(){
            var blocked = cursor.blocked;
            if( blocked === 0 || blocked === 1 ) {
                cursor.call('showItems', 0 );
                cursor.call('showItems', 1 );
            } else {
                cursor.call('showItems', blocked );
            }

            var focus = cursor.focusable[blocked].focus;
            var index = focus % (blocked === 0 ? 4 : 6);
            var left = 0, top = 0;

            switch (blocked) {
                case 0 : top = 520;
                    if( focus == 0 ) left = 642;
                    else if( focus == 1 ) left = 821;
                    else left = 1002;
                    break;
                case 1 : left = 100; top = index * 59 + 218; break;
                default : left = 193; top = index * 63 + 232;break;
            }
            $("mask").className = "mask mask" + String( blocked + 1 ) + (blocked != 0 ? '' : ' mask' + String(blocked + 1) + String(focus + 1));
            $("mask").style.left = String( left ) + 'px';
            $("mask").style.top = String( top ) + 'px';

            var length = cursor.blocked <= 1 ? cursor.focusable[1].items.length : cursor.focusable[cursor.blocked].items.length;
            focus = cursor.blocked <= 1 ? cursor.focusable[1].focus : cursor.focusable[cursor.blocked].focus;

            var pageCount = blocked === 0 ? 4 : 6;
            $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
            $("pageCount").innerHTML = Math.ceil( ( length * 1.0 ) / pageCount);
            if( blocked == 0 || blocked == 1 ) {
                $("pageNum").style.left = $("pageCount").style.left = '81px';
                $("pageNum").style.top = '263px';
                $("pageCount").style.top = '287px';
            } else {
                $("pageNum").style.left = $("pageCount").style.left = '1108px';
                $("pageNum").style.top = '264px';
                $("pageCount").style.top = '289px';
            }
        },
        showItems : function(blocked){
            var items = cursor.focusable[blocked].items;
            if( items.length <= 0 ) return;
            var focus = cursor.focusable[blocked].focus;

            //每页显示数量
            var pageCount = blocked === 0 ? 4 : 6;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            var html = '', id = '';

            var container = blocked == 0 ? 'icons' : blocked === 1 ? 'major' : 'flowed';
            //$("icons").style.visibility = (cursor.fullmode || blocked >= 2) ? 'hidden' : 'visible';

            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            if( blocked !== 0 && blocked === cursor.blocked )
                id = "item" + (blocked + 1) + "" + (focus % pageCount + 1 ) ;

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var focusd = blocked === cursor.blocked && focus === i ? 'Focus' : '';

                html += "<div class='" + container + "Container" + focusd + "'>";
                html += "<div class='item" + ( blocked === 0 ? String(i - flowCursorIndex + 1) : '' ) + "' id='item" + ( (blocked + 1) + "" + ( i - flowCursorIndex + 1 ) )+ "'>" + (blocked !== 0 ? item.name : '');
                if( blocked == 0 ) html += '<img src="' + cursor.pictureUrl(item.posters, '3','', 0 ) +  '" />';
                html += "</div>";
                html += "</div>";
            }
            if( blocked >= 2 ) {
                $("flowed").style.backgroundImage = 'url("images/focusBg-2019-07-26.jpg")';
                html = '<div class="title title' + String(blocked - 1) + '"></div><div class="flowedBody">' + html + "</div>";
                $("flowed").style.visibility  = 'visible';
            } else {
                $("flowed").style.visibility  = 'hidden';
            }
            if(blocked != 0 ) $(container).innerHTML = html;

        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>