<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../player/include.jsp" %>
<html>
<%
    /**
     * 参数说明:
     * id, 栏目ID,或连续剧id,或电影id
     */
    String id = inner.get("id");
    String with = inner.get("with");
    String typeId = inner.get("typeId");
    if( isEmpty(with) ) with = "10000100000000090000000000108885";
    int parentId = 0;
    long startTime = 0;

    List<Result> list = new ArrayList<Result>();

    // 如果 typeId 和 id 两个参数一个都没有，程序报无效参数错误
    if( !isNumber(id) && !isNumber(typeId) ) {
        id = "";
    } else {
        String value = inner.get("startTime");
        if( isNumber( value )) startTime = Long.parseLong(value);
        value = inner.get("parentId");
        if(isNumber(value)) parentId = Integer.getInteger(value);

        Result result = null;
        List<Result> withs = new ArrayList<Result>();

        //当id为栏目ID时，取栏目下的内容、或栏目下子栏目的内容
        if( !isEmpty(id) && id.length() > 8 ){
            inner.debug("ID:" + id);
            //如果栏目下面绑定的是内容,此时通过获取子栏目的方式会返回错误
            result = inner.getTypeList(id,0,199);

            inner.setWithId(with);
            if( ! result.isSuccess() ) {//错误,说明栏目下面绑定的内容
                result = inner.getVodList(id,0,199);
                withs.addAll(queryWithSubscribe((List<Vod>)(result.data)));
                list.add(result);
            } else {//栏目下面绑定的是子栏目,获取子栏目中的内容
                List<Column> columns = (List<Column>)result.data;
                for (Column column : columns ){
                    Result vodResult = inner.getVodList(column.id,0, 199);
                    List<Vod> vodList = (List<Vod>)(vodResult.data);
                    withs.addAll(queryWithSubscribe(vodList));
                    list.add(vodResult);
                }
            }
            if( withs.size() > 0)list.addAll(withs);
        } else { //如果有id不为空，或者parentId 不为空时，肯定带有参数typeId
            result = inner.getVodList(typeId,0,199);
            withs.addAll(queryWithSubscribe((List<Vod>)(result.data)));
            list.add(result);
        }
    }
%>
<head>
    <title>党教播放器页面</title>
    <style>
        body{width:1280px;height:720px;background:transparent url('../../images/translateBg.png') no-repeat left top;overflow: hidden;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;}

        .playBg{z-index:0;width:1280px;height:720px;background: transparent url("images/playerBg.jpg") no-repeat left top;position:absolute;left:0px;top:0px;overflow: hidden;}

        .button {width:83px;height:46px;top:40px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 100px 50px;}
        .previousBtn {left:746px;background-position:0px 0px}
        .previousBtnFocus {left:746px;background-position:0px -50px}
        .backwardBtn {left:828px;background-position:-100px 0px}
        .backwardBtnFocus {left:828px;background-position:-100px -50px}
        .playBtn {left:910px;background-position:-200px 0px}
        .playBtnFocus {left:910px;background-position:-200px -50px}
        .pauseBtn {left:910px;background-position:-300px 0px}
        .pauseBtnFocus {left:910px;background-position:-300px -50px}
        .forwardBtn {left:992px;background-position:-400px 0px}
        .forwardBtnFocus {left:992px;background-position:-400px -50px}
        .nextBtn {left:1074px;background-position:-500px 0px}
        .nextBtnFocus {left:1074px;background-position:-500px -50px}
        .favoriteBtn {left:1156px;background-position:-600px 0px}
        .favoriteBtnFocus {left:1156px;background-position:-600px -50px}

        .arrow {width:13px;height:14px;left:1249px;top:528px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 100px 50px;}
        .arrowUp {top:3px;background-position:-700px -50px}
        .arrowDown {top:77px;background-position:-720px -50px}
        .progressBar{height:10px;left:742px;top:26px;background: transparent url("images/player_mask.png") no-repeat 0px -100px;overflow:hidden;position:absolute;}
        .circle{width:24px;height:24px;top:19px;background: transparent url("images/player_mask.png") no-repeat -700px -70px;position:absolute;}

        .containerBtn{width:1280px;top:622px;height:98px;left:0px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 0px -120px;overflow:hidden;}

        .containerChoice{width:1280px;padding:2px 0px 3px 0px;top:528px;height:95px;left:0px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 0px -220px;overflow:hidden;}
        .tableContainer{position:absolute;top:0px;left:132px;width:1110px;height:92px;overflow: hidden;}
        .choiceTable{position:absolute;top:0px;left:0px;width:1110px;height:90px;overflow:visible;}
        .containerChoice table {border-collapse:collapse;border:1px solid #A67F7E;}
        .containerChoice table td{width:110px;height:44px;text-align: center;font-size: 20px;border:1px solid #A67F7E;color:#A67F7E; font-size:22px;line-height: 36px;background-color: transparent;}
        .containerChoice table td.focus {background-color: #FFD100;font-size: 28px;color:black;}

        .alertDialog{z-index: 99; width:1280px;height:720px;left:0px;top:0px;background: transparent url('images/alertBg.png') no-repeat 0px 0px;overflow: hidden;position:absolute}
        .alertText{width:458px;height:100px;left:410px;top:316px;background: transparent;font-size:32px;color:white;overflow:hidden;text-align: center; line-height: 50px;position: absolute}
        .currentPlayTxt,.tooltip {width:690px;height:26px;left:33px;position:absolute;color:white;font-size: 20px;line-height:24px;color:white;background-color:transparent;overflow: hidden;}
        .currentPlayTxt {top:20px;}
        .tooltip{top:50px;}

        .speed {width:300px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}
    </style>
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body>
<div id="playBg" class="playBg"></div>
<div id="containerBtn" class="containerBtn">
    <div id="previousBtn" class="button previousBtn"></div>
    <div id="backwardBtn" class="button backwardBtn"></div>
    <div id="playBtn" class="button playBtn"></div>
    <div id="forwardBtn" class="button forwardBtn"></div>
    <div id="nextBtn" class="button nextBtn"></div>
    <div id="favoriteBtn" class="button favoriteBtn"></div>
    <div id="progressBar" class="progressBar" style="width:200px;"></div>
    <div id="circle" class="circle" style="left:922px;"></div>
    <div id="currentPlayTxt" class="currentPlayTxt">正在播放 ：电影片段(1)</div>
    <div id="tooltip" class="tooltip">即将播放 ：电影片段(2)</div>
</div>
<div class="containerChoice" id="containerChoice" style="visibility: hidden;">
    <div class="tableContainer">
        <div id="choiceTable" class="choiceTable"></div>
    </div>
    <div id="arrowUp" class="arrow arrowUp" style="visibility: hidden;"></div>
    <div id="arrowDown" class="arrow arrowDown" style="visibility: hidden;"></div>
</div>
<div class="speed" id="speed"></div>
<div class="alertDialog" id="alertDialog" style="visibility: hidden"><div class="alertText" id="alertText"></div></div>
</body>
<script language="javascript" type="text/javascript" defer="defer">
    <!--
    var initialize = {
        moviePos : {width:1280,height:720,left:0,top:0},
        data : [<%
            String html = "";
            for ( int i = 0; i < list.size(); i++) {
                html += inner.resultToString(list.get(i));
                if( i + 1 < list.size() ) html += ",\n";
            }
            out.write(html);
        %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            //此处ID仅可能为空，或栏目ID
            cursor.id = '<%= isNumber(typeId) ? typeId : id %>';
            if( cursor.id.isEmpty() ) return;

            cursor.playCompleted = false;
            cursor.playIndex = 0;
            cursor.speed = 1;
            //播放状态, play, pause,seek, stop
            cursor.status = 'stop';
            cursor.showBtns = 'show';

            cursor.playList = cursor.call('getPlayList',this.data);
            var parentId = <%= parentId %>;
            //如果有typeId,肯定会有id
            var id = <%= isNumber(typeId) && isNumber(id) ? id : "0" %>;

            for( var i = 0; i < cursor.playList.length; i ++) {
                var item = cursor.playList[i];
                if( parentId == 0 && (item.id === id || id === item.parentId) || parentId === item.parentId && id === item.id){
                    cursor.playIndex = i; break;
                }
            }
            var startTime = <%= startTime %>;
            if( startTime != 0 ) cursor.playList[cursor.playIndex].startTime = startTime;

            //播放控制焦点
            cursor.focusable[0] = {
                focus:2,
                items:[
                    {name : 'previousBtn'},
                    {name : 'backwardBtn'},
                    {name : 'playBtn'},
                    {name : 'forwardBtn'},
                    {name : 'nextBtn'},
                    {name : 'favoriteBtn'}]
            };
            //初始化播放视频。
            cursor.moviePos = this.moviePos;
            cursor.call("enterSmallMode",this.moviePos);
            cursor.call("prepareVideo");
        },
        move : function(index){
            if( cursor.showBtns == 'hide' ) {cursor.call('actionShowBtnContainer');return;}

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked === 0 && (index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= 5 ) ) return;
            var item = undefined;
            if( blocked == 0 ) {
                if( index == 1 || index == -1){
                    item = cursor.focusable[blocked].items[focus];
                    if( focus != 2 ) {
                        $(item.name).className = "button " + item.name;
                    } else {
                        $(item.name).className = "button " + ( cursor.status == 'play' ? 'pauseBtn' : 'playBtn');
                    }
                    focus += index;
                } else if( index == 11 ) {
                    cursor.call('showSitcomSelector');
                    return;
                }
            } else if( blocked == 1 ) {
                var items = cursor.focusable[1].items;
                var rows = 2, cols = 10;
                if(index == 11 && focus < cols || index == -1 && focus % cols == 0 || index == 1 && ( focus + 1 >= items.length || focus % cols == cols -1) ) return;
                if( index == 1 || index == -1 ) focus += index;
                else if( index == 11 ) {
                    focus -= cols;
                } else {
                    if( Math.ceil( (focus + 1.0) / cols ) >=  Math.ceil( items.length * 1.0 / cols ) ) return;
                    focus += cols;
                    if( focus >= items.length ) focus = items.length - 1;
                }
            }
            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;
            //每执行一次遥控器操作均重新记时.
            cursor.starter = new Date().getTime();
            cursor.call("show");
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[focus];

            $(item.name).className = "button " + ( focus != 2 ? item.name : ( cursor.status != 'play' ? 'playBtn' : 'pauseBtn') ) + ( cursor.blocked === 0 ? "Focus" : "" );
            if( cursor.blocked == 0 ) return;
            var choisorId = "choisor" + ( cursor.focusable[1].choise + 1  );
            $(choisorId).className = '';
            choisorId = "choisor" + ( cursor.focusable[1].focus + 1 );
            var focus = cursor.focusable[1].choise = cursor.focusable[1].focus;
            var items = cursor.focusable[1].items;
            $(choisorId).className = 'focus';

            var cols = 2,rows = 10;
            var pageSize = cols * rows;
            var page = Math.ceil( ( focus + 1.0 ) / pageSize ) - 1;
            $("arrowUp").style.visibility = focus >= pageSize ? "visible" : "hidden";
            $("arrowDown").style.visibility = items.length > pageSize * ( page + 1 ) ? "visible" : "hidden";
            $("choiceTable").style.top = "-" + ( page * 90 ) + "px";
        },
        interval : function(){
            try{
                var elapsed = 0;
                if( cursor.id.isEmpty() || cursor.playCompleted) {
                    var message = "";
                    if(!cursor.dialogShowed){
                        cursor.call("showDialog", "");
                    }
                    var secReturn = 6;
                    elapsed = secReturn - cursor.elapsedSeconds();
                    if( elapsed <= 0 ) {cursor.call("goBack"); return;}
                    message =  ( cursor.id.isEmpty() ? "视频参数ID为空，或参数错误！<br/>播放器将在 " : "视频播放结束，" ) + "<span style='font-size: 40px;'>" + elapsed + "</span> 秒后返回！";
                    $("alertText").innerHTML = message;
                    return;
                }
                if(cursor.blocked == 0 ){
                    //正常播放状态时,7秒后关闭功能键区
                    if( cursor.status == 'play' ){
                        var secHiddenBtn  = 7;
                        elapsed = secHiddenBtn - cursor.elapsedSeconds();
                        $("speed").style.visibility = 'hidden';
                        if( elapsed <= 0) {cursor.call('hideBtnContainer'); return;}
                    } else { //快进快退时，显示快进快退字样
                        $("speed").style.visibility = 'visible';
                        $("speed").innerHTML = cursor.speed == 1 ? "播放" : "x" + ( Math.abs(cursor.speed) + " "  + ( cursor.speed > 0 ? "快进 " : "快退 " )) ;
                    }
                }
                cursor.call('showBtnContainer');
            } catch (e){}
        },
        initCursor : function(){
            cursor.starter = new Date().getTime();
            cursor.timer = setInterval(function(){cursor.call('interval');},1000);
            cursor.call("show");
        },
        select : function() {
            if( cursor.showBtns == 'hide' ) {cursor.call('actionShowBtnContainer');return;}
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked === 0 ) {
                if( focus === 0 ){//播放上一节目
                    if( cursor.playIndex == 0 ) return;
                    cursor.playIndex --;
                    cursor.call("prepareVideo");
                } else if( focus === 1 ) { //快退
                    cursor.status = 'seek';
                    if( cursor.speed >= -32){
                        cursor.speed = cursor.speed > 1 ? -2 : Math.abs(cursor.speed) * -2;
                        media.AV.backward(cursor.speed);
                    }
                    $("playBtn").className = 'button playBtn';
                } else if( focus === 2 ) {  //暂停或播放
                    cursor.status = cursor.status !== 'play' ? 'play' : 'pause';
                    if( cursor.status == 'play') {
                        cursor.speed = 1;
                        media.AV.play();
                    } else {
                        media.AV.pause();
                    }
                } else if( focus === 3) {
                    cursor.status = 'seek';
                    if( cursor.speed < 32 ){
                        cursor.speed = cursor.speed <= 1 ? cursor.speed = 2 : Math.abs(cursor.speed) * 2;
                        media.AV.forward(cursor.speed);
                    }
                    $("playBtn").className = 'button playBtn';
                } else if( focus === 4 ){ //下一节目
                    if( cursor.playIndex + 1 < cursor.playList.length ) {
                        cursor.playIndex ++;
                        cursor.call("prepareVideo");
                    }
                } else if( focus === 5 ){ //收藏功能暂不可用.

                }
            } else {// 播放连续剧选集
                var itemId = cursor.focusable[blocked].childrenList[focus];
                var parentId = cursor.focusable[blocked].id;
                for( var i = 0; i < cursor.playList.length; i ++) {
                    var item = cursor.playList[i];
                    if(parentId === item.parentId && itemId === item.id){
                        cursor.playIndex = i; break;
                    }
                }
                cursor.call("prepareVideo");
                cursor.call("hideSitcomSelector");
            }
            cursor.starter = new Date().getTime();
            cursor.call("show");
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
                var startTime = item.startTime;
                if( typeof startTime === 'undefined' ) startTime = 0;
                rtspUrl += startTime;

                ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        $("playBg").style.visibility = 'hidden';
                        var rtsp = result.playUrl.split("^")[4];
                        media.AV.open(rtsp,"VOD");
                        cursor.call("play");
                    } else {
                        cursor.call("showDialog",result.message);
                    }
                },{charset:'GBK'});

                cursor.marquee("正在播放 ：" + item.fullName || item.name,20, 'currentPlayTxt',690);

                var txt = cursor.playIndex + 1 < cursor.playList.length ? ("即将播放 ：" +  cursor.playList[cursor.playIndex + 1].fullName || cursor.playList[cursor.playIndex + 1].name ) : "";
                $('tooltip').innerHTML = txt;
            } catch (e){ }
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            cursor.status = 'stop';
            if( typeof cursor.playList === 'undefined' || cursor.playList === 0 ) return;
            var item = cursor.playList[playIndex];
            cursor.call("playMovie",item);
        },
        play : function(){
            cursor.speed = 1;
            media.AV.play();
            cursor.status = 'play';
            cursor.starter = new Date().getTime();
        },
        goBack : function() {
            //如果 没有数据或者焦点在 功能按钮上.
            var blocked = cursor.blocked;
            if( !cursor.id.isEmpty() && !cursor.playCompleted ) {
                if( cursor.dialogShowed ) { cursor.call('hideDialog'); return; }
                //焦点在 选集列表上, 隐藏选集列表
                if( blocked === 1 ) {cursor.call('hideSitcomSelector'); return; }
                if( cursor.showBtns == 'hide' ) {cursor.call('actionShowBtnContainer');return;}
            }
            clearInterval(cursor.timer);
            var backUrl = "<%= inner.getBackUrl() %>";
            backUrl += backUrl.indexOf("?") > 0 ? "&" : "?";
            //此参数主要针对华为返回的问题
            backUrl += "for_play_back=1";
            var EPGflag = cursor.EPGflag;
            if(iPanel.eventFrame.systemId == 1 && !EPGflag.isEmpty()) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = !EPGflag.isEmpty() ? iPanel.eventFrame.portalUrl : backUrl;
        },
        nextVideo : function () {
            cursor.status = 'stop';
            $("speed").style.visibility = 'hidden';
            $("playBg").style.visibility = 'visible';
            cursor.call("show");
            if( typeof cursor.playList === 'undefined' || cursor.playList === 0 ) return;
            var playIndex = cursor.playIndex;
            //列表全部播放完成
            if( playIndex + 1 >= cursor.playList.length ){
                cursor.playCompleted = true;
                cursor.starter = new Date().getTime();
                return;
            }
            cursor.playIndex = playIndex = playIndex + 1;
            var item = cursor.playList[playIndex];
            cursor.call("playMovie",item);
        },
        enterFullMode: function(){
            cursor.fullmode = true;
            media.video.fullScreen();
        },
        enterSmallMode: function(pos){
            pos = pos || (typeof cursor.moviePos === 'undefined' ? this.moviePos : cursor.moviePos);
            media.video.setPosition(pos.left,pos.top,pos.width,pos.height);
        },
        hideSitcomSelector:function(){
            $("choiceTable").innerHTML = '';
            $("containerChoice").style.visibility = 'hidden';
            cursor.blocked = 0;
            cursor.starter = new Date().getTime();
            cursor.choisorId = undefined;
            cursor.choisor = undefined;
            cursor.call('show');
        },
        getCurrentSitcom:function(){
            var pl = cursor.playList[cursor.playIndex];
            if( typeof pl.parentId === 'undefined' ) return;
            var itemId = pl.parentId;
            var item = undefined;
            for( var i = 0; i < cursor.sitcoms.length ; i ++ ){
                if( cursor.sitcoms[i].id !== itemId ) continue;
                item = cursor.sitcoms[i];
                break;
            }
            if( typeof item === 'undefined' ) return;
            return {current: pl, item: item};
        },
        showSitcomSelector:function( ){
            var obj = cursor.call('getCurrentSitcom');
            if( ! obj || !obj.item || !obj.item.childrenIdList) return;
            var pl = obj.current;
            var childrenIdList = obj.item.childrenIdList;
            var html = '';
            var cells = 10.0;
            var rows = Math.ceil(childrenIdList.length / cells);
            var tdLen = rows * (cells * 2);
            html += '<table cellpadding="0" cellspacing="0">';
            for( var i = 0 ; i < tdLen ; i ++ ){
                if( i % cells == 0 ) html += (i == 0 ? '' : '</tr>') + '<tr>';
                html += "<td id='choisor" + (i + 1) + "'>" + ( childrenIdList[i] || '') + "</td>";
                if( i + 1 >= tdLen ) html += '</tr>';
            }
            html += '</table>';
            $("choiceTable").innerHTML = html;
            $("containerChoice").style.visibility = 'visible';
            cursor.blocked = 1;
            cursor.choisor = true;
            cursor.starter = new Date().getTime();
            cursor.focusable[1] = {
                choise: pl.index,
                focus : pl.index,
                id    : obj.item.id,
                items : childrenIdList,
                childrenList:obj.item.childrenList
            };
            //隐藏焦点
            cursor.call('show');
        },
        hideBtnContainer:function(){
            cursor.showBtns = 'hide';
            $("containerBtn").style.visibility = 'hidden';
        },
        showBtnContainer:function(){
            cursor.showBtns = 'show';
            $("containerBtn").style.visibility = 'visible';
            var progressBar = cursor.status == 'stop' ? 0 : ((media.AV.elapsed * 1.0 / media.AV.duration) * 501);
            $("progressBar").style.width = progressBar + "px";
            $("circle").style.left = ( progressBar + 730) + "px";
        },
        actionShowBtnContainer : function(){
            cursor.starter = new Date().getTime();
            cursor.call('showBtnContainer');
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
