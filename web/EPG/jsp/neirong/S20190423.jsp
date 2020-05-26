<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%--
    参数说明：
    当左侧有文字显示时, 整个条目的宽度为: [条目宽度] + [左侧标签的宽度] + [与右边条目之间的距离]
    bp: height,left,top,color   背景竖条参数
    ps: width,height,left,top   视频位置.通过视频位置计算背景图片的坐标
    loop:                       是否循环播放. 不循环播放时，只播放第一条视频，否则循环播放,0,循环，1，不循环，2，使用图片
    pg:                         当前页显示多少条视频
    item:[整个条目容器的Width],[整个条目容器的Height],[整个条目容器的LEFT],[整个条目容器的TOP],[条目宽度],[条目高度],[背景颜色],[字体颜色],[字体大小]， 单条目容器的高度用计算方式获得
    fc:                         焦点字体颜色
    fcbr:[宽度]，[颜色]            获得焦点后条目边框颜色
    fcbg:                        当获得焦点后背景颜色
    split:                      是否显示左侧文字, 0 为无文字显示,1为有文字显示
    mk:[与右边条目之间的距离],[宽度]:[颜色]:[对齐方式]    当左侧显示文字时，显示左侧文字内容，对齐方式为：0，左对齐，1：右对齐，2：居中对齐
--%>
<%
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109025";

    infos.add(new ColumnInfo(typeId, 0, 99));

    String value = "";
    int slitWidth = 2, slitHeight = 0,slitLeft = 0,slitTop = 0;
    int videoWidth = 0,videoHeight = 0,videoLeft = 0,videoTop = 0;
    int loop = 0,focusBorderWidth = 0,fontSize = 0;
    String slitColor = "",itemBackgroundColor = "",itemColor = "",focusColor = "",focusBorderColor = "",focusBackgroundColor = "";
    int containerWidth = 0,containerHeight = 0,containerLeft = 0,containerTop = 0,itemContainerWidth = 0,itemContainerHeight = 0,itemWidth = 0,itemHeight = 0;
    int rows = 5, split = 3, markWidth = 0,markMarginRight = 0;
    String markAlign = "0", markColor = "";

    String bodyLeft = "",bodyTop = "", bodyRight = "", bodyBottom = "";
    int played = 0, playIndex = 0,playTime = 0;

    //背景竖条
    String outString = inner.get("bp");
    inner.debug("slit position:" + outString);
    String[] parameters = outString.split("\\,");
    slitHeight = parameters.length > 0 && isNumber(parameters[0]) ? Integer.parseInt(parameters[0]) : 3;
    slitLeft = parameters.length > 1 && isNumber(parameters[1]) ? Integer.parseInt(parameters[1]) : 500;
    slitTop = parameters.length > 2 && isNumber(parameters[2]) ? Integer.parseInt(parameters[2]) : 500;
    slitColor = parameters.length > 3 && !isEmpty(parameters[3]) ? "#" + parameters[3] : "transparent";

    //视频框
    outString = inner.get("ps");
    inner.debug("video position:" + outString);
    parameters = outString.split("\\,");
    videoWidth = parameters.length > 0 && isNumber(parameters[0]) ? Integer.parseInt(parameters[0]) : 493;
    videoHeight = parameters.length > 1 && isNumber(parameters[1]) ? Integer.parseInt(parameters[1]) : 310;
    videoLeft = parameters.length > 2 && isNumber(parameters[2]) ? Integer.parseInt(parameters[2]) : 712;
    videoTop = parameters.length > 3 && isNumber(parameters[3]) ? Integer.parseInt(parameters[3]) : 206;

    rows = inner.getInteger("pg") == 0 ? 8 : inner.getInteger("pg");
    loop = inner.getInteger("loop");

    outString = inner.get("item");
    inner.debug("item attributes:" + outString);
    parameters = outString.split("\\,");
    containerWidth = parameters.length > 0 && isNumber(parameters[0]) ? Integer.parseInt(parameters[0]) : 3;
    containerHeight = parameters.length > 1 && isNumber(parameters[1]) ? Integer.parseInt(parameters[1]) : 500;
    containerLeft = parameters.length > 2 && isNumber(parameters[2]) ? Integer.parseInt(parameters[2]) : 500;
    containerTop = parameters.length > 3 && isNumber(parameters[3]) ? Integer.parseInt(parameters[3]) : 500;
    itemWidth = parameters.length > 4 && isNumber(parameters[4]) ? Integer.parseInt(parameters[4]) : 3;
    itemHeight = parameters.length > 5 && isNumber(parameters[5]) ? Integer.parseInt(parameters[5]) : 500;
    itemBackgroundColor = parameters.length > 6 && !isEmpty(parameters[6]) ? "#" + parameters[6] : "transparent";
    itemColor = parameters.length > 7 && !isEmpty(parameters[7]) ? "#" + parameters[7] : "transparent";
    fontSize = parameters.length > 8 && isNumber(parameters[8]) ? Integer.parseInt(parameters[8]) : 22;

    focusBackgroundColor = inner.get("fcbg");
    focusBackgroundColor =  !isEmpty(focusBackgroundColor) ? "#" + focusBackgroundColor : "transparent";

    outString = inner.get("fcbr");
    parameters = outString.split("\\,");
    inner.debug("focused border attributes:" + outString + ", length : " + parameters.length);
    focusBorderWidth = parameters.length > 0 && isNumber(parameters[0]) ? Integer.parseInt(parameters[0]) : 1;
    focusBorderColor = parameters.length > 1 && !isEmpty(parameters[1]) ? "#" + parameters[1] : "transparent";

    focusColor = inner.get("fc");
    focusColor =  !isEmpty(focusColor) ? "#" + focusColor : "transparent";

    split = inner.getInteger("split");
    inner.debug("split attributes:" + split );

    outString = inner.get("mk");
    parameters = outString.split("\\,");
    //[与右边条目之间的距离],[宽度]:[颜色]:[对齐方式]0，左对齐，1：右对齐，2：居中对齐
    inner.debug("focused border attributes:" + outString + ", length : " + parameters.length);
    markMarginRight = parameters.length > 0 && isNumber(parameters[0]) ? Integer.parseInt(parameters[0]) : 0;
    markWidth = parameters.length > 1 && isNumber(parameters[1]) ? Integer.parseInt(parameters[1]) : 0;
    markColor = parameters.length > 2 && !isEmpty(parameters[2]) ? "#" + parameters[2] : "transparent";
    markAlign = parameters.length > 3 && !isEmpty(parameters[3]) ? parameters[3] : "";
    markAlign = markAlign.equalsIgnoreCase("0")?"left":markAlign.equalsIgnoreCase("1")?"right":"center";

    Column column = inner.getDetail(typeId,new Column());
    bodyLeft = "";
    bodyTop = "";
    bodyRight = "";
    bodyBottom = "";
    if( column != null ) {
        bodyTop = inner.pictureUrl(bodyTop, column.getPosters(), "7",0 );
        bodyLeft = inner.pictureUrl(bodyLeft, column.getPosters(), "7",1 );
        bodyRight = inner.pictureUrl(bodyRight, column.getPosters(), "7",2 );
        bodyBottom = inner.pictureUrl(bodyBottom, column.getPosters(), "7",3 );
    }
%>
<html>
<head>
    <title><%=column == null ? "带播放标记，一坚排继续播放（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat;background-position: 0px 0px;}

        .bodyTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height: <%=videoTop%>px;}
        .bodyLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:<%=videoTop - 1 %>px;width:<%= videoLeft %>px;height: <%=videoHeight + 2 %>px;}
        .bodyRight {position: absolute;z-index:0;overflow: hidden; left:<%=videoWidth + videoLeft%>px;top:<%=videoTop - 1 %>px;width:<%= 1280-videoLeft-videoWidth %>px;height: <%=videoHeight + 2%>px;}
        .bodyBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:<%=videoTop + videoHeight%>px;width:1280px;height: <%=720-videoTop-videoHeight%>px;}
        .bodyTop img,.bodyLeft img,.bodyRight img,.bodyBottom img{width:100%;height:100%;}

        .split { position:absolute;z-index:1; overflow: hidden;width:<%= slitWidth%>px;height:<%=slitHeight%>px;left:<%=slitLeft%>px;top:<%=slitTop%>px;background-color:<%=slitColor%>;}

        .flowed {position:absolute;z-index:5;left:<%=containerLeft%>px;top:<%=containerTop%>px;width:<%=containerWidth%>px;height:<%=containerHeight%>px;}

        .itemContainer{width:<%=containerWidth%>px;height:<%=containerHeight / rows%>px; float:left;position: relative;overflow: hidden;}
        .itemMarket{position:absolute;width:<%=markWidth%>px;height:<%=itemHeight%>px;left:0px;top:0px;text-align: <%=markAlign%>;font-size: <%=fontSize%>px;line-height:<%=itemHeight - 5%>px;overflow:hidden;color: <%=markColor%>; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .itemIcon,.itemIconFocus {position:absolute;width:<%=markMarginRight%>px;left:<%=markWidth%>px;top:7px;height:<%=itemHeight%>px;}

        .itemIcon{background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -<%=300 - markMarginRight / 2 + 2 %>px -100px;}
        .itemIconFocus{background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -<%=100 - markMarginRight / 2 + 2 %>px -100px;}

        .item{position:absolute;width:<%=itemWidth%>px;height:<%=itemHeight%>px;left:<%=markMarginRight + markWidth%>px;top:0px;text-align: left;font-size: <%=fontSize%>;line-height:<%=itemHeight - focusBorderWidth * 3 + 1%>px;color: <%=markColor%>; }
        .itemPlayFocusedText,.itemPlayText,.itemFocusText,.itemText{width:<%= itemWidth - 30 %>px;padding:0px 8px;float: left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .itemText,.itemPlayText {border:solid <%=focusBorderWidth%>px transparent;color:<%=itemColor%>;background-color:<%=itemBackgroundColor%>}

        .inner {width:<%= itemWidth - 16 - 30 %>px;}
        .itemPlayFocusedText,.itemFocusText{border:solid <%=focusBorderWidth%>px <%=focusBorderColor%>;background-color:<%= focusBackgroundColor%>;color:<%= focusColor%>}
        .marquee {line-height: <%=itemHeight - focusBorderWidth * 5 - 1%>px; height:<%=itemHeight - focusBorderWidth * 5 - 1%>px;width:<%= itemWidth - 50 %>px;}
        .itemPlayed{margin:0px 0px 0px 10px;float: left;height:<%=itemHeight%>px;width:50px;background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -300px -296px;}

        .arrowDown {position:absolute;left:352px;top:662px;width:30px;height:23px;background:transparent url('images/mask-TempOneColumnPlayLoop.png') no-repeat -100px -300px;}

        .speed {width:300px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
        <div class='bodyTop'><img src="<%=bodyTop%>"/></div><div class='bodyLeft'><img src="<%=bodyLeft%>"/></div><div class='bodyRight'><img src="<%=bodyRight%>"/></div><div class='bodyBottom'><img src="<%=bodyBottom%>"/></div>
        <div class='flowed' id='flowed'></div>
    </div>
    <div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        moviePos : {width:<%=videoWidth%>,height:<%=videoHeight%>,left:<%=videoLeft%>,top:<%=videoTop%>},
        data : [<%
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
            cursor.playIndex = this.focused.length > 2 ? Number(this.focused[2]) : 0;
            //这个用来存放当前播放影片的播放时间
            cursor.consigned = [(this.focused.length > 3 ? Number(this.focused[3]) : 0),(this.focused.length > 4 ? Number(this.focused[4]) : 0)];
            cursor.moviePos = this.moviePos;
            cursor.pageCount = <%= rows %>;
            cursor.speed = 1;
            cursor.split = <%= split %>;
            cursor.backUrl='<%= backUrl %>';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('show');
            cursor.call('enterSmallMode');
            cursor.call('lazyShow')
        },
        playMovie : function(item){
            player.play({vodId:item.id});
        },
        goBack : function(){
            if( cursor.fullmode ){ cursor.call("enterSmallMode");cursor.call("show"); return;}
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
            player.fullScreen();
            cursor.timer = setInterval(function(){cursor.call('interval');},500);
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
            if( resume ) {
                cursor.speed = 1;
                player.resume();
            }
        },
        select: function() {
            if( cursor.focusable.length <= 0 ) return;
            if( cursor.fullmode ) { if(cursor.speed != 1 ) cursor.call('resumePlay',true); return;}

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];
            var url = '';
            if( item.isSitcom === 0 ){
                debug("cursor.playIndex !== focus  =>  ", cursor.playIndex !== focus);
                if(cursor.playIndex !== focus) {
                    cursor.call('enterFullMode');
                    cursor.playIndex = focus;
                    player.exit();
                    cursor.call("playMovie",item);
                    return;
                }
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
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( cursor.focusable[0].items.length <= 0 )return;
            var item = cursor.focusable[0].items[playIndex];
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

            if( blocked === 0 && (index === -1 || index === 11 && focus <= 0 || index === -11 && focus + 1 >= items.length || index === 1)) return;
            focus += index > 0 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);

            cursor.call('show');
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            cursor.playIndex = focus;

            cursor.call('prepareVideo');

            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, <%= fontSize %>, function(width){
                var fus = cursor.focusable[cursor.blocked].focus
                if( cursor.blocked != blocked || focus != fus || width <= <%= itemWidth - 50 - 16 %> ) return;
                $('txt' + String(focus + 1)).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        show : function(){
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;
            var focus = cursor.focusable[0].focus;
            var played = cursor.playIndex;

            //每页显示数量
            var pageCount = cursor.pageCount;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='itemContainer'>";

                if( cursor.split != 0) html += "<div class='itemMarket'>" + item.mark + "</div>";
                var id = i + 1;
                if( i === played && i === focus ) {
                    html += "<div class='item'>";
                    html += "<span class='itemPlayFocusedText' id='txt" + id + "'>" + item.name + "</span>";//<span class='itemPlayed'></span>
                } else if(i === played ) {
                    html += "<div class='item'>";
                    html += "<span class='itemPlayText' id='txt" + id + "'>" + item.name + "</span>";//<span class='itemPlayed'></span>
                } else if(i === focus ) {
                    html += "<div class='item'>";
                    html += "<div class='itemFocusText' id='txt" + id + "'>" + item.name + "</div>";
                } else {
                    html += "<div class='item'>";
                    html += "<div class='itemText' id='txt" + id + "'>" + item.name + "</div>";
                }
                html += "</div></div>";
            }
            $("flowed").innerHTML = html;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>