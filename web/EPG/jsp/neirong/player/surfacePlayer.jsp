<%@ page import="java.util.regex.Pattern.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="include.jsp" %>
<html lang="zh">
<%
    /**
     *  播放器页面参数说明：
     *  适用于外部调用的播放器（使用外部ID），可循环播放，支持电视剧播放
     *  请求地址说明：http://host:port/{chunk}/{columnId}{pageable}.html
     *             http%3A%2F%2Fhost%3Aport%2F%7Bchunk%7D%2F%7BcolumnId%7D%7Bpageable%7D.html
     *  invokeUrl：获取视频列表的URL地址格式，其中地址用上面形式表示，其中{chunk},{columnId},可自定义名字，但传递的参数必须包含相同名称的参数
     *  page : 每页page条数据，当页面参数中带有{pageable}时，必须指定page参数.
     *  backURL: 影片播放完以后，返回地址。需要使用 encodeURIComponent()编码.
     *  statistics: 是否统计点播数据，每请求一次点播，统计一次
     *  index:当前播放的顺序位置，在整个栏目中的顺序.
     */
%>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta http-equiv="charset" content="UTF-8">
    <title>适用于外部调用的播放器（使用外部ID），可循环播放</title>
    <style>
        body{width:1280px;height:720px;background:transparent url('../images/translateBg.png') no-repeat left top;overflow: hidden;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;}

        .button {width:83px;height:46px;top:40px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 100px 50px;}
        .previousBtn {left:743px;background-position:0px 0px}
        .previousBtnFocus {left:743px;background-position:0px -50px}
        .backwardBtn {left:848px;background-position:-100px 0px}
        .backwardBtnFocus {left:848px;background-position:-100px -50px}
        .playBtn {left:954px;background-position:-200px 0px}
        .playBtnFocus {left:954px;background-position:-200px -50px}
        .pauseBtn {left:954px;background-position:-300px 0px}
        .pauseBtnFocus {left:954px;background-position:-300px -50px}
        .forwardBtn {left:1057px;background-position:-400px 0px}
        .forwardBtnFocus {left:1057px;background-position:-400px -50px}
        .nextBtn {left:1160px;background-position:-500px 0px}
        .nextBtnFocus {left:1160px;background-position:-500px -50px}

        .containerBtn{width:1280px;top:622px;height:98px;left:0px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 0px -120px;overflow:hidden;}

        .sitcomChoice{width:1280px;padding:2px 0px 3px 0px;top:528px;height:95px;left:0px;position:absolute;background: transparent url("images/player_mask.png") no-repeat 0px -220px;overflow:hidden;}
        .tableContainer{position:absolute;top:0px;left:132px;width:1110px;height:92px;overflow: hidden;}
        .choiceTable{position:absolute;top:0px;left:0px;width:1110px;height:90px;overflow:visible;}
        .sitcomChoice table {border-collapse:collapse;border:1px solid #A67F7E;}
        .sitcomChoice table td{width:110px;height:44px;text-align: center;font-size: 20px;border:1px solid #A67F7E;color:#A67F7E; font-size:22px;line-height: 36px;background-color: transparent;}
        .sitcomChoice table td.focus {background-color: #FFD100;font-size: 28px;color:black;}

        .progressBar{height:10px;left:777px;top:15px;background: transparent url("images/player_mask.png") no-repeat 0px -100px;overflow:hidden;position:absolute;}
        .circle{position:absolute;width:24px;height:24px;top:8px;left:765px;background: transparent url("images/player_mask.png") no-repeat -700px -70px;}
        .currentPlayTxt,.tooltip{position:absolute;width:690px;height:26px;left:33px;color:white;font-size:20px;line-height:24px;color:white;background-color:transparent;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .currentPlayTxt {top:10px;}
        .tooltip{top:50px;}
        .speed {width:300px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}

        .alertDialog{z-index: 99; width:1280px;height:720px;left:0px;top:0px;background: transparent url('images/alertBg.png') no-repeat 0px 0px;overflow: hidden;position:absolute}
        .alertText{width:458px;height:100px;left:410px;top:316px;background: transparent;font-size:32px;color:white;overflow:hidden;text-align: center; line-height: 50px;position: absolute}

        .articles{width:622px;height:622px;position:absolute;left:50px;top:0px; overflow:hidden;background:transparent url('images/articleBg.png') no-repeat left top;}

        .artContainer {width:580px;position:absolute;left:42px;top:62px;height:580px;overflow: hidden;}
        .focusItem,.item{width:580px;height:50px;overflow:hidden;background-color: transparent;}
        .focusItem {background-color: #ffd400;}
        .container {width:540px;margin:0px 0px 0px 21px;height:50px;font-size: 22px;line-height: 48px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .item .container { color:white;}
        .focusItem .container { color:black;}

        .artScroll {width:8px;height:500px;position:absolute;left:15px;top:62px;background-color: #000000;overflow: hidden;}
        .artScrollBar {width:6px;background-color:#ffd400;height:1px;position:absolute;left:1px;top:1px;overflow:hidden;}
    </style>
    <script language="javascript" type="text/javascript" src="common.js" charset="UTF-8"></script>
</head>
<body leftmargin="0" topmargin="0" onUnload="exit();">
<div id="containerBtn" class="containerBtn">
    <div id="previousBtn" class="button previousBtn"></div>
    <div id="backwardBtn" class="button backwardBtn"></div>
    <div id="playBtn" class="button playBtn"></div>
    <div id="forwardBtn" class="button forwardBtn"></div>
    <div id="nextBtn" class="button nextBtn"></div>
    <div id="progressBar" class="progressBar" style="width:200px;"></div>
    <div id="circle" class="circle" style="left:957px;"></div>
    <div id="currentPlayTxt" class="currentPlayTxt"></div>
    <div id="tooltip" class="tooltip"></div>
</div>
<div class="articles" id="articles" style="visibility:hidden;">
    <div id="artScroll" class="artScroll" style="visibility: hidden"><div id="artScrollBar" class="artScrollBar"></div></div>
    <div class="artContainer" id="artContainer"></div>
</div>
<div class="sitcomChoice" id="sitcomChoice" style="visibility: hidden;">
    <div class="tableContainer">
        <div id="choiceTable" class="choiceTable"></div>
    </div>
    <div id="arrowUp" class="arrow arrowUp" style="visibility: hidden;"></div>
    <div id="arrowDown" class="arrow arrowDown" style="visibility: hidden;"></div>
</div>
<div class="alertDialog" id="alertDialog" style="visibility: hidden"><div class="alertText" id="alertText">视频播放结束，<span style='font-size: 40px;'>6</span> 秒后返回！</div></div>
<div class="speed" id="speed"></div>
</body>
<%
    String invokeUrl = inner.get("invokeUrl");
    Pattern pattern = Pattern.compile("\\{(.*?)\\}", Pattern.CASE_INSENSITIVE);
    Matcher matcher = pattern.matcher(invokeUrl);
    inner.debug("invokeUrl:" + invokeUrl);

    ArrayList<String> replaceList = new ArrayList<String>();
    Map<String,String> hashtable = new HashMap<String, String>();
    while(matcher.find()) {
        String key = matcher.group(1);
        if( ! replaceList.contains(key) )
        {
            inner.debug("invokeUrl parameters : " + key );
            replaceList.add(key);
            continue;
        }
        inner.debug("duplicate parameters : " + key );
    }

    if( replaceList.size() > 0 ) {
        inner.debug( "invokeUrl 解析完成！");
        for ( String replace : replaceList ) {
            String value = inner.get(replace);
            if( isEmpty(value) ) {
                inner.debug("未找到传递的参数：" + replace );
                continue;
            }
            inner.debug( replace + "参数取值：" + value );
            hashtable.put( replace, value);
        }
        inner.debug( "参数解析完成！" );
    } else {
        inner.debug( "未从 invokeUrl 参数中检测到需要替换的参数" );
    }

    boolean isPageable = replaceList.contains("pageable");
    boolean statistics = !isEmpty(inner.get("statistics"));
    int pageSize = inner.getInteger("page",80);
    int index = inner.getInteger("index",0);
    //backUrl 不需要显示调用，系统默认自动调用
%>
<script language="javascript" type="text/javascript">
    cursor.initialize({
        init : function(){
            cursor.playCompleted = false;
            cursor.invokeUrl = decodeURIComponent("<%= invokeUrl%>");
            cursor.backURL =  decodeURIComponent("<%= backUrl %>");
            cursor.isPageable = <%=isPageable%>;
            cursor.pageSize = <%=pageSize %>;
            cursor.statistics = <%=statistics %>;
            cursor.invokeObj = <%= inner.writeObject(hashtable) %>;
            cursor.playIndex = <%= index %>;
            cursor.speed = 1;
            //播放状态, play, pause,seek, stop
            cursor.status = 'stop';
            cursor.showArticle = 'hide';
            cursor.showSitcom = 'hide';
            cursor.showBtns = 'show';
            cursor.focusable = [
                {focus:2,
                 items:[{name : 'previousBtn'},
                 {name : 'backwardBtn'},
                 {name : 'playBtn'},
                 {name : 'forwardBtn'},
                 {name : 'nextBtn'},
                 {name : 'favoriteBtn'}]
                },{focus:0,
                   items:[]
                }
            ];
            cursor.starter = new Date().getTime();
            cursor.timer = setInterval(function(){cursor.call('interval');},1000);

            cursor.call("loadItems", true);

            cursor.call("show");
        },
        interval : function(){
            try{
                var elapsed = 0;
                if( cursor.playCompleted) {
                    var message = "";
                    if(!cursor.dialogShowed){
                        cursor.call("showDialog", "");
                    }
                    var secReturn = 6;
                    elapsed = secReturn - cursor.elapsedSeconds();
                    if( elapsed <= 0 ) {cursor.call("goBack"); return;}
                    message =  "视频播放结束，<span style='font-size: 40px;'>" + elapsed + "</span> 秒后返回！";
                    $("alertText").innerHTML = message;
                    return;
                }
                if(cursor.showArticle == 'hide' && cursor.blocked == 0 ){
                    //正常播放状态时,7秒后关闭功能键区
                    if( cursor.status == 'play' ){
                        var secHiddenBtn  = 6;
                        elapsed = secHiddenBtn - cursor.elapsedSeconds();
                        if( elapsed <= 0 && elapsed >= -1) {
                            $("speed").style.visibility = 'hidden';
                            cursor.call('hideBtnContainer'); return;
                        } else if( elapsed < -1 ) return;
                    } else { //快进快退时，显示快进快退字样
                        $("speed").style.visibility = 'visible';
                    }
                    if( $("speed").style.visibility == 'visible' ) $("speed").innerHTML = cursor.speed == 1 ? "播放" : "x" + ( Math.abs(cursor.speed) + " "  + ( cursor.speed > 0 ? "快进 " : "快退 " )) ;
                }
                cursor.call('showBtnContainer');
            } catch (e){}
        },
        move : function(index){
            if( cursor.showBtns == 'hide' ) {cursor.call('actionShowBtnContainer');return;}

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = undefined;
            if( blocked == 0 ) {
                if( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= 5  ) return;
                if( index == 1 || index == -1){
                    item = cursor.focusable[blocked].items[focus];
                    if( focus != 2 ) {
                        $(item.name).className = "button " + item.name;
                    } else {
                        $(item.name).className = "button " + ( cursor.status == 'play' ? 'pauseBtn' : 'playBtn');
                    }
                    focus += index;
                } else if( index == 11 ) {
                    if( cursor.status !== 'play' ) return;      //在非播放状态下，不能调出列表
                    cursor.call('showArticles');
                    return;
                }
            } else if( blocked == 1 ) {
                if( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= cursor.itemCount ) return;
                cursor.index = focus += index > 0 ? -1 : 1;
                // ----------------- 注释代码用来显示连续剧选集代码 ---------------------
                /*var items = cursor.focusable[1].items;
                var rows = 2, cols = 10;
                if(index == 11 && focus < cols || index == -1 && focus % cols == 0 || index == 1 && ( focus + 1 >= items.length || focus % cols == cols -1) ) return;
                if( index == 1 || index == -1 ) focus += index;
                else if( index == 11 ) {
                    focus -= cols;
                } else {
                    if( Math.ceil( (focus + 1.0) / cols ) >=  Math.ceil( items.length * 1.0 / cols ) ) return;
                    focus += cols;
                    if( focus >= items.length ) focus = items.length - 1;
                }*/
            }
            cursor.blocked = blocked;
            cursor.focusable[blocked].focus = focus;
            //每执行一次遥控器操作均重新记时.
            cursor.starter = new Date().getTime();
            cursor.call("show");
        },
        select : function() {
            if( cursor.dialogShowed ) { cursor.call('hideDialog'); return; }
            if( cursor.showBtns == 'hide' ) {cursor.call('actionShowBtnContainer');return;}
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked === 0 ) {
                if( cursor.status == 'stop' ) return;
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
            } else {
                if( cursor.showArticle === 'visible' ) {
                    if( Math.floor( cursor.playIndex * 1.0 / cursor.pageSize ) != cursor.page ) {
                        cursor.items = cursor.playList = cursor.focusable[1].items;
                    }
                    cursor.playIndex = cursor.index;
                    cursor.call('prepareVideo');
                }
                //以下代码播放连续剧选集
                /*var itemId = cursor.focusable[blocked].childrenList[focus];
                var parentId = cursor.focusable[blocked].id;
                for( var i = 0; i < cursor.playList.length; i ++) {
                    var item = cursor.playList[i];
                    if(parentId === item.parentId && itemId === item.id){
                        cursor.playIndex = i; break;
                    }
                }
                cursor.call("prepareVideo");
                cursor.call("hideSitcoms");*/
            }
            cursor.starter = new Date().getTime();
            cursor.call("show");
        },
        goBack : function() {
            //如果 没有数据或者焦点在 功能按钮上.
            var blocked = cursor.blocked;
            if( !cursor.playCompleted ) {
                if( cursor.dialogShowed ) { cursor.call('hideDialog'); return; }
                //焦点在 选集列表上, 隐藏选集列表
                if( cursor.showArticle == 'visible' ) { cursor.call('hideArticles'); return; }
                if( cursor.showSitcom == 'visible' ) { cursor.call('hideSitcoms'); return; }
                if( cursor.showBtns == 'hide' ) { cursor.call('actionShowBtnContainer');return; }
            }
            clearInterval(cursor.timer);
            var backUrl = "<%= inner.getBackUrl() %>";
            backUrl += backUrl.indexOf("?") > 0 ? "&" : "?";
            //此参数主要针对华为返回的问题
            backUrl += "for_play_back=1";
            var EPGflag = cursor.EPGflag;
            if(!EPGflag.isEmpty() || backUrl.indexOf('Category.jsp') >= 0 ) {
                if( typeof iPanel.eventFrame.systemId !== 'undefined' )
                    iPanel.eventFrame.exitToHomePage();
                else
                    top.window.location.href = iPanel.eventFrame.portalUrl;
                return ;
            }
            top.window.location.href = backUrl;
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[focus];

            $(item.name).className = "button " + ( focus != 2 ? item.name : ( cursor.status != 'play' ? 'playBtn' : 'pauseBtn') ) + ( cursor.showSitcom == 'hide' ? "Focus" : "" );
            if( cursor.blocked == 0 ) return;
            if( cursor.showArticle == 'visible' ){
                cursor.call('showArticleList');
            }
            if( cursor.showSitcom == 'visible' ) {
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
            }
        },
        playVideo : function(item){
            if( typeof item === 'undefined' )return;
            try{
                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/neirong/player/authorization.jsp?playType=1&progId=" + item.video + "&contentType=0&business=1&baseFlag=0&idType=FSN";
                ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        var rtsp = result.playUrl.split("^")[4];
                        media.video.setPosition(0,0,1280,720);
                        media.AV.open(rtsp,"VOD");
                        if( cursor.statistics ) {
                            //回调统计
                            setTimeout(function(){
                                var p = {
                                    id: item.id,
                                    col:item.id,
                                    card:CA.card.serialNumber,
                                    stage:2,
                                    tp:'video'
                                };
                                var url = cursor.invokedUrl;
                                url = url.substr(0, url.lastIndexOf("/articles/") + 1) + "visited.do?";
                                for( var o in p) if( o != 'extend' ) url += o + "=" + p[o] + "&";
                                url = url.substr(0, url.length - 1);
                                ajax(url, function( r ){iPanel.debug(r);});
                            },200);
                        }
                        if( cursor.focusable[0].focus !== 2) {
                            var item = cursor.focusable[0].items[cursor.focusable[0].focus];
                            $(item.name).className = "button " + item.name;
                            cursor.focusable[0].focus = 2;
                        }
                        cursor.call("play");
                        cursor.call("show");
                    } else {
                        cursor.call("showDialog", result.message);
                    }
                },{charset:'GBK'});

                var txt = cursor.playIndex + 1 < cursor.playList.length ? ("即将播放 ：" + (  cursor.playList[cursor.playIndex + 1].fullName || cursor.playList[cursor.playIndex + 1].name ) ) : "";
                $('tooltip').innerHTML = txt;

                txt = "正在播放 ：" + (item.fullName || item.name);
                $('currentPlayTxt').innerHTML = '';
                cursor.marquee( txt ,20, 'currentPlayTxt',690);

                $('currentPlayTxt').className = 'currentPlayTxt';
                $('tooltip').className = 'tooltip';
            } catch (e){ }
        },
        prepareVideo : function(){
            if( Math.floor( cursor.playIndex * 1.0 / cursor.pageSize ) != cursor.page ){ cursor.call('loadItems', true); return; }
            var index = cursor.playIndex % cursor.pageSize;
            var item = undefined;
            while (typeof item === "undefined" || typeof item.video !== 'string' || item.video.isEmpty() ) {
                if( index >= cursor.playList.length ) {
                    if( cursor.playIndex >= cursor.itemCount ){
                        cursor.playCompleted = true;
                        cursor.starter = new Date().getTime();
                    } else {
                        cursor.playIndex = index;
                        cursor.call("loadItems", true);
                    }
                    return;
                }
                item = cursor.playList[index++];
            }
            cursor.playIndex = index - 1;
            cursor.call("playVideo", item);
        },
        searchForNextPlay : function ( action) {
            //TODO:查找下一条播放记录，向上搜索，向下搜索，自动播放时翻页操作
        },
        nextVideo : function() {

            cursor.playIndex ++;
            cursor.call("prepareVideo");
        },
        play : function(){
            cursor.speed = 1;
            media.AV.play();
            cursor.status = 'play';
            cursor.starter = new Date().getTime();
        },
        loadItems : function( isPlayList /*是否播放列表，或者在显示界面翻页数据*/ ){
            var url = cursor.invokeUrl;
            var prefix = cursor.invokeObj.prefix || '';

            for(var p in cursor.invokeObj )
                if( p !== 'prefix' && p !== 'pageable' ) url = url.replace('{' + p + '}', cursor.invokeObj[p] || '');

            var page = Math.floor( ( cursor.showArticle === 'visible' ? cursor.index : cursor.playIndex ) / cursor.pageSize );
            url = url.replace("{pageable}" , page === 0 ? "" : page );
            url = url.replace("{prefix}" , page === 0 ? "" : prefix );

            if( url.indexOf('{') >= 0 || url.indexOf('}') >= 0 ) {
                alert("播放器调用格式错误，无法请求播放数据！");
                return false;
            }

            cursor.invokedUrl = url;
            ajax(url,function(result){
                if(isPlayList){
                    cursor.items = cursor.playList = result.items;
                    cursor.itemCount = cursor.playCount = result.count;
                    cursor.page = cursor.focusable[0].page = Math.floor( cursor.playIndex / cursor.pageSize );
                    cursor.call("prepareVideo");
                } else {
                    cursor.focusable[1].items = result.items;
                    cursor.itemCount = result.count;
                    cursor.page = cursor.focusable[1].page = Math.floor( cursor.index / cursor.pageSize );
                    cursor.call("showArticleList");
                }
            },{charset:'utf-8'});
        },
        actionShowBtnContainer : function(){
            cursor.starter = new Date().getTime();
            cursor.call('showBtnContainer');
        },
        showBtnContainer:function(){
            cursor.showBtns = 'show';
            $("containerBtn").style.visibility = 'visible';
            var progressBar = cursor.status == 'stop' ? 0 : ((media.AV.elapsed * 1.0 / media.AV.duration) * 446);
            if( String(progressBar) == 'NaN' ) progressBar = 0;
            $("progressBar").style.width = progressBar + "px";
            $("circle").style.left = ( progressBar + 765) + "px";
        },
        hideBtnContainer:function(){
            cursor.showBtns = 'hide';
            $("containerBtn").style.visibility = 'hidden';
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
            cursor.starter = new Date().getTime();
        },
        showArticleList : function(){
            cursor.showArticle = 'visible';
            var focus = cursor.focusable[1].focus;
            var items = cursor.focusable[1].items;

            if( Math.floor( focus * 1.0 / cursor.pageSize ) != cursor.page ){
                cursor.call('loadItems', false); return;
            }
            var pageCount = 10;
            if( cursor.itemCount <= pageCount ){
                $("artScroll").style.visibility = 'hidden';
            } else {
                var scrollHeight = 500;
                var height = Math.ceil(pageCount * 1.0 / cursor.itemCount * scrollHeight);
                if( height < 30 ) height = 30;
                var margTop = Math.floor( focus * 1.0 / cursor.itemCount * (scrollHeight - height - 1) ) + 1;
                $("artScrollBar").style.height = height + "px";
                $("artScrollBar").style.top = margTop + "px";
                $("artScroll").style.visibility = 'visible';
            }
            //每页显示数量
            var flowCursorIndex = Math.floor( focus % cursor.pageSize / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="' + ( cursor.page * cursor.pageSize + i == focus ? 'focusItem' : 'item' ) + '"><div class="container" id="txt' + ( i + 1) + '">';
                html += item.fullName || item.name;
                html +='</div></div>';
            }
            $("artContainer").innerHTML = html;
            cursor.marquee( ( items[focus % cursor.pageSize].fullName || items[focus % cursor.pageSize].name  ),22, 'txt' + ( focus % cursor.pageSize + 1),530);
            $("articles").style.visibility = 'visible';
            cursor.call('switchCurrentPlayTxt');
        },
        showArticles : function(){//显示文章列表
            cursor.focusable[1] = {};
            cursor.focusable[1].items = cursor.items;
            cursor.page = cursor.focusable[1].page = Math.floor( (cursor.playIndex + 1.0) / cursor.pageSize );
            cursor.focusable[1].focus = cursor.playIndex;
            cursor.blocked = 1;
            cursor.call('showArticleList');
        },
        hideArticles : function(){//关闭文章列表
            cursor.showArticle = 'hide';
            cursor.blocked = 0;
            $("articles").style.visibility = 'hidden';
            $("artScroll").style.visibility = 'hidden';
            cursor.starter = new Date().getTime();
            cursor.call('switchCurrentPlayTxt');
        },
        switchCurrentPlayTxt: function(){//当两个都游走时,界面会很卡,所以显示文章标题时,当前播放则不游走
            var item = cursor.playList[cursor.playIndex];
            var txt = "正在播放 ：" + (item.fullName || item.name);
            if( cursor.showArticle == 'visible' )
                $('currentPlayTxt').innerHTML = txt;
            else
                cursor.marquee( txt ,20, 'currentPlayTxt',690);
            $('currentPlayTxt').className = 'currentPlayTxt';
        },
        showSitcoms : function () {//连续剧选集
            cursor.showSitcom = 'visible';
            $("sitcomChoice").style.visibility = 'visible';
        },
        hideSitcoms : function () {//关闭连续剧选集
            cursor.showSitcom = 'hide';
            $("sitcomChoice").style.visibility = 'hidden';
            cursor.starter = new Date().getTime();
        }
    });
</script>
</html>