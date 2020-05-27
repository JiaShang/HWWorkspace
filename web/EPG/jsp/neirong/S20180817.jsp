<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000110023";
    List<Column> columns = inner.getList(typeId,5,0,new Column());
    Result parent = new Result(typeId,columns);
    for( Column col : columns ) infos.add(new ColumnInfo(col.id,0,99));

    Column column = new Column();
    column = inner.getDetail(typeId,column);

%>
<html>
<head>
    <title><%=column == null ? "两会专题" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .major {width:479px;height:360px;position:absolute;left:104px;top:282px;overflow: hidden;}
        .majorContainer,.majorContainerFocus{width:479px;height:59px;float: left;overflow: hidden;background:transparent url('images/mask-2018-08-17.png') no-repeat;background-position: 0px 0px;}
        .majorContainer {background-position:0px -61px;}
        .majorContainerFocus {background-position:0px -1px;}

        .majorContainer .item,.majorContainerFocus .item,.majorContainerFocus .item .marquee {width:450px;height:59px;line-height:62px;font-size: 22px;}
        .majorContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 40px;}
        .majorContainerFocus .item {color:red;margin:0px 0px 0px 40px;}

        .icons {width:623px;height:104px;left:652px;top:545px;overflow: hidden;position:absolute;}
        .iconsContainer,.iconsContainerFocus {width:136px;height: 104px;float: left;}
        .iconsContainer div,.iconsContainerFocus div {width:130px;height:104px;background:transparent url('images/mask-2018-08-17.png') no-repeat;background-position: 0px 0px;}

        .iconsContainer .item1 {background-position: 0px -380px;}
        .iconsContainerFocus .item1 {background-position: 0px -500px;}
        .iconsContainer .item2 {background-position: -200px -380px;}
        .iconsContainerFocus .item2 {background-position: -150px -500px;}
        .iconsContainer .item3 {background-position: -400px -380px;}
        .iconsContainerFocus .item3 {background-position: -300px -500px;}
        .iconsContainer .item4 {background-position: -600px -380px;}
        .iconsContainerFocus .item4 {background-position: -450px -500px;}

        .flowed {position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;background:transparent url('images/bg-2018-08-17-2.jpg') no-repeat;}
        .flowedBody {position:absolute;width:880px;left:205px;top:256px;height:390px;overflow: hidden;}

        .flowedContainer,.flowedContainerFocus{width:878px;height:63px;float:left;overflow: hidden;background:transparent url('images/mask-2018-08-17.png') no-repeat;background-position: 0px 0px;}
        .flowedContainer {background-position:0px -150px;}
        .flowedContainerFocus {background-position:0px -240px;}

        .flowedContainer .item,.flowedContainerFocus .item,.flowedContainerFocus .item .marquee {width:838px;height:63px;line-height:70px;font-size: 24px;}
        .flowedContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 40px;}
        .flowedContainerFocus .item {color:red;margin:0px 0px 0px 40px;}

        .title {width:200px;height:50px;position:absolute;left:250px;top:185px;background:transparent url('images/mask-2018-08-17.png') no-repeat;}
        .title1 {background-position: 0px -320px;}
        .title2 {background-position: -200px -320px;}
        .title3 {background-position: -400px -320px;}
        .title4 {background-position: -600px -320px;}

        .speed {width:300px;height:40px;font-size:32px;top:20px;left:900px;position:absolute;color:white;overflow:hidden;text-align:right;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/

        .page,.page1 {width:22px;height:16px;left:80px;position:absolute;color:#fdfdfd;font-size:16px;overflow: hidden;text-align: center;}
        .number,.number1 {top:317px;}
        .count,.count1 {top:346px;}
        .page1{left:1107px;}
        .number1{top:280px;}
        .count1{top:310px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div class="speed" id="speed"></div>
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;background:transparent url('images/bg-2018-08-17.png') no-repeat;">
        <div class='major' id='major'></div>
        <div class='icons' id='icons'></div>
        <div id="pageNum" class="page number">0</div>
        <div id="pageCount" class="page count">0</div>
        <div class='flowed' id='flowed' style="visibility: hidden;">
        </div>
    </div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        moviePos : {width:538,height:315,left:651,top:222},
        data : [<%
                String html = "";
                html += inner.resultToString(parent) + ",\n";
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.playIndex = this.focused.length > 2 ? Number(this.focused[2]) : 0;
            //这个用来存放当前播放影片的播放时间
            cursor.consigned = [(this.focused.length > 3 ? Number(this.focused[3]) : 0),(this.focused.length > 4 ? Number(this.focused[4]) : 0)];
            cursor.moviePos = this.moviePos;
            cursor.pageCount = 5;
            cursor.speed = 1;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            //删除第一个, 第一个是两会头条
            cursor.focusable[0].items.removeAt(0);

            cursor.call('show');
            cursor.call('prepareVideo');
            cursor.call('enterSmallMode');
        },
        playMovie : function(item){
            if( typeof item === 'undefined' )return;
            debug("CALL PLAY: " + item.id);
            player.play({
                position:cursor.moviePos,vodId:item.id
            });
            if( ! cursor.fullmode )cursor.call('show');
        },
        goBack : function(){
            debug("Cursor.Blocked : " + cursor.blocked);
            if( cursor.fullmode ){
                cursor.call(cursor.blocked >= 2 ? 'stop' : "enterSmallMode");
                $("listBody").style.visibility = 'visible';
                $("flowed").style.visibility = cursor.blocked >= 2 ? "visible" : "hidden";
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
            $("speed").innerHTML = cursor.speed == 1 ? "播放" : ( cursor.speed > 0 ? "快进 " : "快退 " ) + "x" + Math.abs(cursor.speed) ;
            $("speed").style.visibility = 'visible';
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            cursor.call('resumePlay');
            $("listBody").style.visibility = 'hidden';
            $("flowed").style.visibility = "hidden";
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
            $("speed").style.visibility = 'hidden';
            if( resume ) {
                cursor.speed = 1;
                player.resume();
            }
        },
        stop : function(){
            cursor.fullmode = false;
            player.close();
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
                cursor.call('stop'); cursor.call('show'); return;
            }
            if( item.isSitcom === 0 ){
                if(blocked !== cursor.playBlocked || cursor.playIndex !== focus) {
                    player.close();
                    cursor.playIndex = focus; cursor.playBlocked = blocked;
                    cursor.call("playMovie",item);
                }
                if(cursor.speed != 1 ) cursor.call('resumePlay',true);
                cursor.call('enterFullMode');
                return;
            }
            cursor.consigned[0] = cursor.playIndex;
            cursor.consigned[1] = player.elapsed();
            var typeId = cursor.focusable[blocked].typeId;
            if( typeof item.linkto === 'string' ) {
                var link = item.linkto;
                if( ! link.startWith('http') ){
                    url += cursor.current() + link;
                } else if( link.indexOf("wasu.cn/") > 0 ) {
                    url = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + link;
                } else {
                    url = link;
                    url += url.indexOf("?") > 0 ? '&' : '?';
                    url += 'backURL=';
                    url += encodeURIComponent(top.window.location.href);
                }
            } else {
                var detailPage = 'vod/tv_detail.jsp';
                if( cursor.isKorean ) detailPage = 'hjzq/hj_tvDetail.jsp';
                else if( cursor.isWestern ) detailPage = 'western/eu_tvDetail.jsp';

                url = cursor.current() + "/EPG/jsp/defaultHD/en/hddb/" + detailPage +  "?vodId=" + item.id + "&typeId=" + typeId;
            }
            window.location.href = url;
        },
        nextVideo   :   function () {
            var blocked = cursor.playBlocked = cursor.blocked || 1;
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[blocked].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var blocked = cursor.playBlocked = cursor.blocked || 1;
            var playIndex = cursor.playIndex;
            if( cursor.focusable[blocked].items.length <= 0 )return;
            var item = cursor.focusable[blocked].items[playIndex];
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
            cursor.call('show');
        },
        show: function(){
            var blocked = cursor.blocked;
            if( blocked === 0 || blocked === 1 ) {
                cursor.call('showItems', 0 );
                cursor.call('showItems', 1 );
            } else {
                cursor.call('showItems', blocked );
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

            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            if( blocked !== 0 && blocked === cursor.blocked )
                id = "item" + (blocked + 1) + "" + (focus % pageCount + 1 ) ;
            if ( blocked == 1 ) {
                $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
                $("pageCount").innerHTML = Math.ceil( ( items.length * 1.0 ) / pageCount);
            }
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var focusd = blocked === cursor.blocked && focus === i ? 'Focus' : '';

                html += "<div class='" + container + "Container" + focusd + "'>";
                html += "<div class='item" + ( blocked === 0 ? String(i - flowCursorIndex + 1) : '' ) + "' id='item" + ( (blocked + 1) + "" + ( i - flowCursorIndex + 1 ) )+ "'>" + (blocked !== 0 && focusd === '' ? item.name : '') + "</div>";
                html += "</div>";
            }
            if( blocked >= 2 ) {
                html = '<div class="title title' + (blocked - 1) + '"></div><div class="flowedBody">' + html + "</div>";
                html += '<div class="page1 number1">' + Math.ceil( ( focus + 1.0 ) / pageCount) +  '</div><div class="page1 count1">' + Math.ceil( ( items.length * 1.0 ) / pageCount) + '</div>';
                $("flowed").style.visibility  = 'visible';
            } else {
                $("flowed").style.visibility  = 'hidden';
            }
            $(container).innerHTML = html;

            if( id != ''){
                (function(id,value){
                    var fontsize = blocked === 1 ? 22 : 24;
                    var width = blocked === 1 ? 450 : 848;
                    cursor.calcStringPixels(value, fontsize, function(pixelsWidth){
                        var innerHTML = pixelsWidth > width ? ('<marquee class="marquee" scrollamount="10">' + value + "</marquee>") : '<div class="inner">' + value + '</div>' ;
                        $(id).innerHTML = innerHTML;
                    });
                })(id,items[focus].name);
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>