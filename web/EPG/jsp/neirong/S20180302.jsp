<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109120";
    List<Column> columns = inner.getList(typeId,5,0,new Column());
    Result parent = new Result(typeId,columns);
    for( Column col : columns ) infos.add(new ColumnInfo(col.id,0,99));

    Column column = new Column();
    column = inner.getDetail(typeId,column);

%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "两会专题" : column.getName()%></title>
    <style>
        .bodyTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:221px;background:transparent url('images/bg-2018-03-02-1.jpg') no-repeat left top;}
        .bodyLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:221px;width:627px;height:299px;background:transparent url('images/bg-2018-03-02-2.jpg') no-repeat left top;}
        .bodyRight {position: absolute;z-index:0;overflow: hidden; left:1167px;top:221px;width:113px;height: 299px;background:transparent url('images/bg-2018-03-02-3.jpg') no-repeat left top;}
        .bodyBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:520px;width:1280px;height:201px;background:transparent url('images/bg-2018-03-02-4.jpg') no-repeat left top;}


        .major {width:479px;height:360px;position:absolute;left:104px;top:242px;overflow: hidden;}
        .majorContainer,.majorContainerFocus{width:479px;height:59px;float: left;overflow: hidden;background:transparent url('images/mask-2018-03-02.png') no-repeat;background-position: 0px 0px;}
        .majorContainer {background-position:0px -61px;}
        .majorContainerFocus {background-position:0px -1px;}

        .majorContainer .item,.majorContainerFocus .item,.majorContainerFocus .item .marquee {width:450px;height:59px;line-height:62px;font-size: 22px;}
        .majorContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 40px;}
        .majorContainerFocus .item {color:red;margin:0px 0px 0px 40px;}

        .icons {width:623px;height:105px;left:630px;top:528px;overflow: hidden;position:absolute;}
        .iconsContainer,.iconsContainerFocus {width:135px;height: 100px;float: left;}
        .iconsContainer div,.iconsContainerFocus div {width:130px;height:99px;background:transparent url('images/mask-2018-03-02.png') no-repeat;background-position: 0px 0px;}

        .iconsContainer .item1 {background-position: 0px -510px;}
        .iconsContainerFocus .item1 {background-position: 0px -410px;}
        .iconsContainer .item2 {background-position: -200px -510px;}
        .iconsContainerFocus .item2 {background-position: -200px -410px;}
        .iconsContainer .item3 {background-position: -400px -510px;}
        .iconsContainerFocus .item3 {background-position: -400px -410px;}
        .iconsContainer .item4 {background-position: -600px -510px;}
        .iconsContainerFocus .item4 {background-position: -600px -410px;}

        .flowed {position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;background:transparent url('images/focusBg-2018-03-02.jpg') no-repeat;}
        .flowedBody {position:absolute;width:880px;left:205px;top:216px;height:390px;overflow: hidden;}

        .flowedContainer,.flowedContainerFocus{width:878px;height:63px;float:left;overflow: hidden;background:transparent url('images/mask-2018-03-02.png') no-repeat;background-position: 0px 0px;}
        .flowedContainer {background-position:0px -150px;}
        .flowedContainerFocus {background-position:0px -240px;}

        .flowedContainer .item,.flowedContainerFocus .item,.flowedContainerFocus .item .marquee {width:838px;height:63px;line-height:70px;font-size: 24px;}
        .flowedContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;margin:0px 0px 0px 40px;}
        .flowedContainerFocus .item {color:red;margin:0px 0px 0px 40px;}

        .title {width:200px;height:50px;position:absolute;left:270px;top:115px;background:transparent url('images/mask-2018-03-02.png') no-repeat;}
        .title2 {background-position: 0px -350px;}
        .title1 {background-position: -200px -350px;}
        .title3 {background-position: -400px -350px;}
        .title4 {background-position: -600px -350px;}

        .speed {width:300px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
        <div class='bodyTop'></div><div class='bodyLeft'></div><div class='bodyRight'></div><div class='bodyBottom'></div>
        <div class='major' id='major'></div>
        <div class='icons' id='icons'></div>
        <div class='flowed' id='flowed' style="visibility: hidden;"></div>
    </div>
    <div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        moviePos : {width:539,height:299,left:627,top:221},
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
            cursor.call('enterSmallMode');
            cursor.call('prepareVideo');
        },
        playMovie : function(item){
            if( typeof item === 'undefined' )return;
            try{
                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?";
                if(typeof item.parentId === 'undefined'){       //播放电影
                    rtspUrl += "playType=1&progId=" + item.id + "&contentType=0&business=1&baseFlag=0&startTime="
                } else { //播放电视剧
                    rtspUrl += "playType=11&typeId=-1&parentVodId=" + item.parentId + "&progId=" + item.id + "&baseFlag=0&contentType=0&business=1&startTime=";
                }

                startTime = cursor.consigned[0] === cursor.playIndex ? cursor.consigned[1] : 0;
                rtspUrl += startTime;

                ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        var rtsp = result.playUrl.split("^")[4];
                        media.AV.open(rtsp,"VOD");
                    } else {
                    }
                },{charset:'GBK'});
                if( ! cursor.fullmode )cursor.call('show');
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
            $("speed").innerHTML = cursor.speed == 1 ? "播放" : ( cursor.speed > 0 ? "快进 " : "快退 " ) + "x" + Math.abs(cursor.speed) ;
            $("speed").style.visibility = 'visible';
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            cursor.call('resumePlay');
            $("listBody").style.visibility = 'hidden';
            media.video.fullScreen();
            cursor.timer = setInterval(function(){cursor.call('interval');},500);
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = cursor.moviePos;
            media.video.setPosition(pos.left,pos.top,pos.width,pos.height);
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
            if( resume ) {
                cursor.speed = 1;
                media.AV.play();
            }
        },
        stop : function(){
            media.video.setPosition(0,0,1,1);DVB.stopAV(0);cursor.fullmode = false;
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
                return;
            }
            if( item.isSitcom === 0 ){
                media.AV.close();
                if(blocked === 0 && cursor.playIndex !== focus)
                    cursor.playIndex = focus;
                cursor.call("playMovie",item);
                cursor.call('enterFullMode');
                return;
            }

            cursor.consigned[0] = cursor.playIndex;
            cursor.consigned[1] = media.AV.elapsed;
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
            if( cursor.blocked >= 2 ) {
                cursor.call('goBack'); return;
            }
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[1].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[1].items[playIndex];
            cursor.call("playMovie",item);
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
                    media.AV.backward(cursor.speed);
                } else if( index == 1 && cursor.speed < 32 ){
                    cursor.speed = cursor.speed <= 1 ? 2 : Math.abs(cursor.speed) * 2;
                    media.AV.forward(cursor.speed);
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

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var focusd = blocked === cursor.blocked && focus === i ? 'Focus' : '';

                html += "<div class='" + container + "Container" + focusd + "'>";
                html += "<div class='item" + ( blocked === 0 ? String(i - flowCursorIndex + 1) : '' ) + "' id='item" + ( (blocked + 1) + "" + ( i - flowCursorIndex + 1 ) )+ "'>" + (blocked !== 0 && focusd === '' ? item.name : '') + "</div>";
                html += "</div>";
            }
            if( blocked >= 2 ) {
                html = '<div class="title title' + (blocked - 1) + '"></div><div class="flowedBody">' + html + "</div>";
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