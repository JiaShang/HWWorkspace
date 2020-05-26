<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../player/include.jsp" %>
<html>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    List<Column> columnList = null;
    //列表有几种情况，第一种，直接绑定内容
    List<Result> columns = new ArrayList<Result>();
    Result result = null;

    List<Result> withs = new ArrayList<Result>();
    String with = inner.get("with");
    if( isEmpty(with) ) with = "10000100000000090000000000108885";
    try {
        //获取栏目列表
        columnList = inner.getList(typeId, 99, 0, new Column());
        inner.setWithId( with );
        for (Column column : columnList ) {
            result = inner.getVodList(column.id,0, 199);
            List<Vod> vodList = (List<Vod>)(result.data);
            withs.addAll(queryWithSubscribe(vodList));
            columns.add(result);
        }
    } catch (Throwable e) {
        inner.setWithId( with );
        result = inner.getVodList(typeId, 0, 199);
        withs.addAll(queryWithSubscribe((List<Vod>)(result.data)));
        columns.add( result );
    }
    if( withs.size() > 0)columns.addAll(withs);


    Column column = inner.getDetail(typeId, new Column());
%>
<head>
    <title><%= column.getName() %></title>
    <style>
        body{width:1280px;height:720px;background:transparent url('../../images/translateBg.png') no-repeat left top;overflow: hidden;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;}
        .listBody{position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;}
        .bodyTop{position:absolute;left:0px; top:0px;width:1280px;height:130px;background:transparent url('images/list_body_bg_top.jpg') no-repeat left top;}
        .bodyLeft{position:absolute;left:0px; top:130px;width:521px;height:373px;background:transparent url('images/list_body_bg_left.jpg') no-repeat left top;}
        .bodyRight{position:absolute;left:1188px; top:130px;width:92px;height:373px;background:transparent url('images/list_body_bg_right.jpg') no-repeat left top;}
        .bodyBottom{position:absolute;left:0px; top:503px;width:1280px;height:217px;background:transparent url('images/list_body_bg_bottom.jpg') no-repeat left top;}

        .playerIcon {position:absolute;width:667px;height:374px;left:521px;top:130px;background:transparent url('images/list_player_icon.jpg') no-repeat left top;}
        .title {width:1000px;height:40px;font-size:32px;color:white;font-weight:bold; position:absolute;left:45px;top:34px;overflow: hidden;}

        .majorContent {width:147px;height:390px;left:0px;top:197px;overflow:hidden;position:absolute;}
        .majorContainer{width:147px;left:0px;top:0px;position:absolute;overflow: visible;}
        .majorItem,.majorItemFocus {width:147px;height:65px;float:left;}
        .majorItem div,.majorItemFocus div {width:147px;height: 54px;color:white;font-size:24px;line-height:45px;text-align: center; overflow:hidden;word-break:break-all;text-overflow:ellipsis;background-color: transparent;}
        .majorItemFocus div {color:black;background-color: yellow;font-size: 34px;}

        .content {width:349px;height:510px;left:149px;top:129px;overflow:hidden;position:absolute;}
        .container{width:349px;left:0px;top:0px;position:absolute;overflow: visible;}
        .subItem,.subItemFocus {width:349px;height:69px;float:left;}
        .subItem div,.subItemFocus div {width:349px;height: 52px;color:white;font-size:18px;line-height: 24px; padding:2px 20px 3px 20px; overflow:hidden;word-break:break-all;text-overflow:ellipsis;background-color: transparent;}
        .subItemFocus div {color:black;background-color: yellow;}
        .currentPlayTxt{width:505px;height:32px;left:531px;top:515px;color:white;position:absolute;font-size:24px;overflow:hidden;}

        .alertDialog{width:1280px;height:720px;left:0px;top:0px;background: transparent url('images/alertBg.png') no-repeat left top;overflow: hidden;position:absolute}
        .alertText{width:458px;height:100px;left:410px;top:316px;background: transparent;font-size:32px;color:white;overflow:hidden;text-align: center; line-height: 50px;position: absolute}
        .searchBtn{width:148px;left:0px;top:121px;height:56px;position:absolute;background: transparent url("images/mask_list.png") no-repeat 0px 0px;}
        .favoriteBtn{width:61px;left:1058px;top:515px;height:40px;position:absolute;background: transparent url("images/mask_list.png") no-repeat 0px -60px;}
        .fullScreenBtn{width:61px;left:1120px;top:515px;height:40px;position:absolute;background: transparent url("images/mask_list.png") no-repeat left -120px;}

        .speed {width:300px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}
    </style>
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body>
<div class="listBody" id="listBody">
    <div class="bodyTop"></div><div class="bodyLeft"></div><div class="bodyRight"></div><div class="bodyBottom"></div>
    <div class="majorContent"><div class="majorContainer" id="majorContainer"></div></div>
    <div class="title"><%= column.getName() %></div>
    <div class="content"><div class="container" id="container"></div></div>
    <div class="playerIcon" id="playerIcon"></div>
    <div id="maskMajor"></div>
    <div id="mask"></div>
    <div class="currentPlayTxt" id="currentPlayTxt"></div>
</div>
<div class="alertDialog" id="alertDialog" style="visibility: hidden"><div class="alertText" id="alertText"></div></div>
<div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript" defer="defer">
    <!--
    var initialize = {
        moviePos : {width:667,height:374,left:521,top:130},
        data : [<%
                String html = "";
                if( columnList != null )html += inner.resultToString(new Result( typeId, columnList)) + ",\n";
                for ( int i = 0; i < columns.size(); i++) {
                    html += inner.resultToString(columns.get(i));
                    if( i + 1 < columns.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        interval : function(){
            if( cursor.fullmode && cursor.speed === 1 ) {
                var elapsed = 6 - cursor.elapsedSeconds();
                if( elapsed <= 0 ) {
                    $("speed").style.visibility = 'hidden';
                    return;
                }
            }
            $("speed").innerHTML = cursor.speed == 1 ? "播放" : "x" + ( Math.abs(cursor.speed) + " "  + ( cursor.speed > 0 ? "快进 " : "快退 " )) ;
            $("speed").style.visibility = 'visible';
        },
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            //保存窗口坐标
            cursor.moviePos = this.moviePos;
            //初始化播放列表
            cursor.playList = cursor.call('getPlayList',this.data);
            //初始化数据
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                if( o.redirected ) continue;
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = 0;
                //有可能栏目下面没有绑定内容
                cursor.focusable[i].items = o["data"] || [];
            }
            //初始化时，有两种情况，一种是 data 只有一个元素，这时需要在 data 中 插入搜索
            if( cursor.focusable.length == 1 ) {
                var searchBtn = {id:'-1',focus:0,items:[{name:'search',className:'searchBtn'}]};
                cursor.focusable.insertAt(0,searchBtn);
            } else {
                //另一种情况是 data 有多个元素， 第一个元素是栏目列表，要在第一个元素中插入搜索
                var searchBtn = {name:'search',className:'searchBtn'};
                cursor.focusable[0].items.insertAt(0,searchBtn);
            }
            //初始化焦点
            if(this.focused.length == 0 ) cursor.blocked = 0;
            else {
                cursor.blocked = Number(this.focused[0]);
                for( var i = 0; i < cursor.focusable.length; i ++)
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            }
            //如果焦点在搜索框上时,返回后,焦点不在搜索框上
            if( cursor.blocked === 0 ) cursor.blocked = 1;
            if( cursor.focusable[0].focus === 0 && cursor.focusable.length > 2 ) cursor.focusable[0].focus = 1;

            //收藏按钮.
            var favoriteBtn = {id:'-1',focus:0,items:[{name:'favorite',className:'favoriteBtn'},{name:'fullscreen',className:'fullScreenBtn'}]};
            cursor.focusable.push(favoriteBtn);
            //初始化时，小屏播放。
            cursor.call("enterSmallMode");
            cursor.call("prepareVideo");
        },
        move : function(index){
            if( cursor.dialogShowed ) { return; }
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
            if( blocked === 0 && index == -1 || blocked === cursor.focusable.length - 1 && ( index == 11 || index == -11 || index == 1 && focus >= 1 ) ||
                ( blocked >= 0 && blocked < cursor.focusable.length - 1 ) && (index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length)) return;

            if( blocked === 0) {
                if( index == 11 || index == -11 ) {
                    //从搜索按钮 按下光标键时
                    if( index == -11 && focus == 0 ) {
                        $("maskMajor").style.visibility = 'hidden';
                    } else {
                        $("major" + focus ).className = 'majorItem';
                    }
                    focus += index > 0 ? -1 : 1;
                    if(focus !== 0 ){
                        $("major" + focus ).className = 'majorItemFocus';

                        var margin = (Math.ceil( focus  / 5) - 1) * 5 * 65;
                        $("majorContainer").style.top = "-" + margin + "px";

                        cursor.call('showSubContent', focus);
                    } else {
                        cursor.call("showSearchBtn");
                    }
                } else if( index == 1 ) {
                    if( cursor.focusable.length <= 3 ) {
                        if(cursor.focusable[blocked].items.length == 0) return;
                        blocked = cursor.focusable[0].focus = 1
                    } else {
                        if( focus === 0 ) return;
                        blocked = focus;
                    }
                    $("maskMajor").style.visibility = 'hidden';
                    if( cursor.focusable[blocked].items.length == 0 ){
                        cursor.consigned = 0;
                        blocked = cursor.focusable.length - 1; focus = 0;
                    } else
                        focus = cursor.focusable[blocked].focus;
                }
            } else if( blocked === cursor.focusable.length - 1 ) {
                if( index == -1 && focus == 0 ) {
                    blocked = cursor.consigned;
                    cursor.consigned = undefined;
                    focus = cursor.focusable[blocked].focus;
                } else
                    focus += index;
            } else {
                //首先去掉焦点的显示，再移动焦点
                $("item" + ( focus + 1) ).className = 'subItem';
                if( index == 11 || index == -11 ){
                    focus += index > 0 ? -1 : 1;
                }
                else if( index == -1 ){
                    blocked = 0;
                    if( cursor.focusable.length <= 3 ) {
                        focus = 0;
                        cursor.call("showSearchBtn");
                    } else {
                        focus = cursor.focusable[blocked].focus;
                    }
                } else {
                    cursor.consigned = blocked;
                    blocked = cursor.focusable.length - 1; focus = 0;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        showMajorContent : function(){
            if(cursor.focusable.length <= 3 ) return;
            var items = cursor.focusable[0].items;
            var html = '';
            for( var i = 1; i < items.length; i++ ){
                var item = items[i];
                html += '<div id="major' + i + '" class="majorItem"><div>' + item.name + "</div></div>";
            }
            $("majorContainer").innerHTML = html;

            var focus = cursor.focusable[0].focus;
                cursor.call("showSearchBtn");
            if( focus === 0 ) {
            } else {
                $("maskMajor").style.visibility = 'hidden';
                $("major" + focus).className = "majorItemFocus";
            }
        },
        showSubContent : function(blocked){
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var html = '';
            if( items.length > 0 ) {
                for( var i = 0; i < items.length; i ++ ){
                    var item = items[i];
                    html += '<div id="item' + ( i  + 1 ) + '" class="subItem"><div>' + item.name + "</div></div>";
                }
            } else {
                cursor.blocked = 0;
                if( cursor.focusable.length <= 3 ){
                    cursor.focusable[blocked].focus = 0;
                    cursor.call("showSearchBtn")
                }
            }
            $("container").innerHTML = html;
        },
        show : function(){
            var blocked = cursor.blocked;
            $("mask").style.visibility = ( blocked === cursor.focusable.length  - 1 ) ? 'visible' : 'hidden';
            if( blocked === 0 ) return;
            var focus = cursor.focusable[blocked].focus;
            if( blocked >0 && blocked < cursor.focusable.length - 1 ) {
                $("item" + (focus + 1)).className = 'subItemFocus';
                var margin = (Math.ceil( ( focus + 1 ) / 7) - 1) * 7 * 69;
                $("container").style.top = "-" + margin + "px";
            } else if( blocked === cursor.focusable.length - 1 ) {
                var item = cursor.focusable[blocked].items[focus];
                $("mask").className = item.className;
                $("mask").style.visibility = 'visible';
            }
        },
        showSearchBtn : function(){
            $("maskMajor").style.visibility = 'visible';
            $("maskMajor").className = cursor.focusable[0].items[0].className;
        },
        initCursor : function(){
            var blocked = cursor.blocked;
            //如果 cursor.focusable.length 大于3，第一个元素是栏目列表，这时需要初始化栏目列表
            if( cursor.focusable.length > 3 ){
                cursor.call('showMajorContent');
            } else {
                $("maskMajor").style.visibility = 'hidden';
            }
            cursor.call('showSubContent', blocked === 0 ? 1 : blocked);
            cursor.call('show');
        },
        select : function() {
            if( cursor.dialogShowed ) { cursor.call('hideDialog'); return; }
            if( cursor.fullmode ) { cursor.call('resumePlay',true); return;}
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var url = '';
            if( blocked === 0 ){
                if( focus == 0){  //焦点在左侧列表时,只响应搜索功能,其它是全自动显示
                    url = '<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getRequestURI()%>?';
                    var queryString = '<%= request.getQueryString()%>';
                    var currFoucs = cursor.getCurrFocus();
                    var currIndex = queryString.indexOf('currFoucs');
                    if( currIndex ){ //如果链接中包含 currFoucs
                       var currEnd = queryString.indexOf("&",currIndex);
                       if( currEnd < 0 ) queryString = queryString.substring(0, currIndex);
                       else queryString = queryString.replace(queryString.substring(currIndex,currEnd), 'currFoucs=' + currFoucs);
                    } else { //否则直接把 currFoucs 拼接上去
                        queryString = 'currFoucs=' + currFoucs + "&" + queryString;
                    }
                    url += queryString;
                    top.window.location.href = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/userInfo/searchIndex.jsp?epgBackurl=" + encodeURIComponent(top.window.location.href);
                }
            } else if( blocked > 0 && blocked < cursor.focusable.length - 1) {
                //找到当前焦点所在播放顺序,如果是连续剧,则播放第一集
                var selectIndex = 0;
                var item = cursor.focusable[blocked].items[focus];
                //如果 item.linkto 存在,说明是专题,直接跳转到专题页面
                if( typeof  item.linkto !== 'undefined' ) { top.window.location.href = cursor.linkto(item.linkto); return;}
                var found = false;
                for( var i = 0; i < cursor.playList.length; i ++ ){
                    var play = cursor.playList[i];
                    //从播放列表中,查找名字相同的电影,或者名字相同的电视剧或名字相同的专题系列的第一个视频
                    if( item.isSitcom === 0 && play.name === item.name || item.isSitcom === 1 && play.original === item.name ){
                        if( cursor.playIndex === i ) {cursor.call('enterFullMode'); return;}
                        found = true; cursor.playIndex = i; break;
                    }
                }
                //如果找到,全屏播放找到的视频
                if( found ) {cursor.call('enterFullMode');cursor.call("prepareVideo");}
                return;
            } else { //焦点在功能按钮上
                if( focus === 0 ){ //收藏按钮

                } else {  //全屏播放
                    cursor.call("enterFullMode");
                    return;
                }
            }
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            cursor.call('resumePlay');
            $("listBody").style.visibility = 'hidden';
            media.video.fullScreen();
            cursor.timer = setInterval(function(){cursor.call('interval');},1000);
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
        playMovie : function(item){
            if( typeof item === 'undefined' )return;
            try{

                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?";
                if(typeof item.parentId === 'undefined'){       //播放电影
                    rtspUrl += "playType=1&progId=" + item.id + "&contentType=0&business=1&baseFlag=0&startTime="
                } else { //播放电视剧
                    rtspUrl += "playType=11&typeId=-1&parentVodId=" + item.parentId + "&progId=" + item.id + "&baseFlag=0&contentType=0&business=1&startTime=";
                }

                //获取上次的播放时间
                var startTime = iPanel.getGlobalVar("CCN_PLAY_" + item.id);
                if( typeof startTime === 'undefined' ) startTime = 0;
                rtspUrl += startTime;

                ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        $("playerIcon").style.visibility = 'hidden';
                        var rtsp = result.playUrl.split("^")[4];
                        media.AV.open(rtsp,"VOD");
                    } else {
                        cursor.call("showDialog",result.message);
                    }
                },{charset:'GBK'});
                cursor.calcStringPixels(item.name, 24, function(pixelsWidth){
                    var innerHTML = pixelsWidth > 505 ? ("<marquee>" + item.name + "</marquee>") : item.name ;
                    $('currentPlayTxt').innerHTML = innerHTML;
                });
            } catch (e){ }
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( typeof cursor.playList === 'undefined' || cursor.playList === 0 ) return;
            var item = cursor.playList[playIndex];
            cursor.call('resumePlay',true);
            cursor.call("playMovie",item);
        },
        goBack : function() {
            if( cursor.dialogShowed ) { cursor.call('hideDialog'); return; }
            if( cursor.fullmode ) { cursor.call('enterSmallMode'); return; }
            cursor.call("goBackAct");
        },
        resumePlay : function(reset){
            cursor.starter = new Date().getTime();
            if( reset ) {
                cursor.speed = 1;
                media.AV.play();
            }
        },
        nextVideo : function () {
            $("playerIcon").style.visibility = 'visible';
            if( typeof cursor.playList === 'undefined' || cursor.playList === 0 ) return;
            var playIndex = cursor.playIndex;
            cursor.playIndex = playIndex = playIndex + 1 < cursor.playList.length ? playIndex + 1 : 0;
            var item = cursor.playList[playIndex];
            cursor.call("playMovie",item);
            cursor.call('resumePlay',true);
        },
        showDialog: function(message){
            cursor.dialogShowed = true;
            $("alertText").innerHTML = message;
            $("alertDialog").style.visibility = 'visible';
        },
        hideDialog:function(){
            cursor.dialogShowed = false;
            $("alertDialog").style.visibility = 'hidden';
            $("alertText").innerHTML = '';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>
