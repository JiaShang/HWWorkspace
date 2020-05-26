<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../../player/include.jsp" %>
<html>
<%
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    List<Column> columnList = null;
    //列表有几种情况，第一种，直接绑定内容
    List<Result> columns = new ArrayList<Result>();
    Result result = null;
    try {
        columnList = inner.getList(typeId, 99, 0, new Column());
        for (Column column : columnList ) {
            result = inner.getTypeList(column.id,0, 1);
            List<Column> cols = (List<Column>)result.data;
            for( int x = 0; x < cols.size(); x++ ){
                Column col = cols.get(x);
                Result rst = inner.getVodList(col.id,0, 99);
                rst.setMessage(column.name + "|||" + col.name);
                columns.add(rst);
            }
        }

    } catch (Throwable e) {
        result = inner.getVodList(typeId, 0, 199);
        columns.add( result );
    }

    Column column = new Column();
    if( !isEmpty(inner.get("parentId")) ) typeId = inner.get("parentId");
    column = inner.getDetail(typeId, column);
    int majorWidth = 140;
%>
<head>
    <title><%= column.getName() %></title>
    <style>
        body{width:1280px;height:720px;background:transparent url('../../images/translateBg.png') no-repeat left top;overflow: hidden;margin:0px 0px 0px 0px;padding:0px 0px 0px 0px;}
        .listBody{position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;}
        .bodyTop{position:absolute;left:0px; top:0px;width:1280px;height:132px;background:transparent url('images/list_body_bg_top.png') no-repeat left top;}
        .bodyLeft{position:absolute;left:0px; top:131px;width:97px;height:183px;background:transparent url('images/list_body_bg_left.jpg') no-repeat left top;}
        .bodyRight{position:absolute;left:424px; top:131px;width:856px;height:183px;background:transparent url('images/list_body_bg_right.jpg') no-repeat left top;}
        .bodyBottom{position:absolute;left:0px; top:314px;width:1280px;height:406px;background:transparent url('images/list_body_bg_bottom.jpg') no-repeat left top;}

        .playerIcon {position:absolute;width:327px;height:183px;left:97px;top:131px;background:transparent none no-repeat left top;}
        .playerIcon img{width:327px;height:183px;left:97px;top:131px;border:none;}

        .title {width:1000px;height:40px;font-size:28px;color:white;font-weight:bold; position:absolute;left:72px;top:47px;overflow: hidden;}

        .majorContent {width:240px;height:300px;left:185px;top:400px;overflow:hidden;position:absolute;}
        .majorContainer{width:240px;left:0px;top:0px;position:absolute;overflow: visible;}
        .majorItem,.majorItemFocus {width:<%=majorWidth%>px;height:54px;float:right;background-color: transparent;overflow: visible;}
        .majorItem div,.majorItemFocus div {color:white;font-size:24px;padding:8px 15px 8px 15px;text-align: right; overflow:visible;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;background-color: transparent;}
        .majorItemFocus div {background-color: #c4c4c4;color:#ba0101;}

        .content {width:710px;height:510px;left:470px;top:129px;overflow:hidden;position:absolute;}
        .container{width:680px;left:0px;top:0px;position:absolute;overflow: visible;}
        .subItem,.subItemFocus {width:680px;height:69px;float:left;background-color: transparent;overflow: hidden;}
        .subItem .text,.subItemFocus .text { float:left;width:500px;height: 52px;color:white;font-size:20px;line-height: 45px; padding:0px 20px 0px 20px;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;background-color: transparent;}
        .subItemFocus .text {color:black;background-color: yellow;}
        .subItemFocus .marqueed {width:490px;}
        .subItem .time,.subItemFocus .time { float:left;width:140px;height: 52px;color:white;font-size:22px;line-height: 45px;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;background-color: transparent;}
        .subItemFocus .time {color:black;background-color: yellow;}

        .alertDialog{width:1280px;height:720px;left:0px;top:0px;background: transparent url('images/alertBg.png') no-repeat left top;overflow: hidden;position:absolute}
        .alertText{width:458px;height:100px;left:410px;top:316px;background: transparent;font-size:32px;color:white;overflow:hidden;text-align: center; line-height: 50px;position: absolute}
        .searchBtn{width:170px;height:53px;left:255px;top:334px;position:absolute;background: transparent url("images/mask_list.png") no-repeat 0px 0px;}
        .favoriteBtn{width:61px;left:1058px;top:515px;height:40px;position:absolute;background: transparent url("images/mask_list.png") no-repeat 0px -60px;}
        .fullScreenBtn{width:61px;left:1120px;top:515px;height:40px;position:absolute;background: transparent url("images/mask_list.png") no-repeat left -120px;}

        .speed {width:260px;height:40px;font-size:32px;top:20px;left:960px;position:absolute;color:white;overflow:hidden;text-align:right;}
        .arrowUp {width:42px;height:19px;position:relative;left:300px;top:370px;background: transparent url('images/mask_list.png') no-repeat -120px -70px;}
        .arrowDown {width:42px;height:19px;position:relative;left:300px;top:660px;background: transparent url('images/mask_list.png') no-repeat -120px -100px;}
    </style>
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div class="listBody" id="listBody">
    <div class="bodyTop"></div><div class="bodyLeft"></div><div class="bodyRight"></div><div class="bodyBottom"></div>
    <div class="majorContent"><div class="majorContainer" id="majorContainer"></div></div>
    <div class="title"><%= column.getName() %></div>
    <div class="content"><div class="container" id="container"></div></div>
    <div class="playerIcon" id="playerIcon"><img src="images/list_player_icon.jpg" /></div>
    <div id="maskMajor"></div>
    <div class="arrowUp" id="arrowUp" style="visibility: hidden;"></div>
    <div class="arrowDown" id="arrowDown" style="visibility: hidden;"></div>
    <div id="mask"></div>
</div>
<div class="alertDialog" id="alertDialog" style="visibility: hidden"><div class="alertText" id="alertText"></div></div>
<div class="speed" id="speed"></div>
</body>
<script language="javascript" type="text/javascript" defer="defer">
    <!--
    var initialize = {
        moviePos : {width:327,height:183,left:97,top:131},
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
            $("speed").style.visibility = cursor.fullmode ? 'visible' : 'hidden';
        },
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            //保存窗口坐标
            cursor.moviePos = this.moviePos;
            cursor.backUrl='<%= backUrl %>';
            //初始化数据
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                if( o.redirected ) continue;
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].message = o["message"];
                cursor.focusable[i].focus = 0;
                //有可能栏目下面没有绑定内容
                cursor.focusable[i].items = o["data"] || [];
            }
            var items = this.data.length > 1 ? cursor.focusable[0].items : [];
            var children = [];
            var o = 0;
            for( var i = 0; i < items.length; i ++ ){
                var item = items[i];
                for( var j = 1; j < cursor.focusable.length; j ++ ){
                    var child = cursor.focusable[j].items;
                    for( var x = 0; x < child.length; x ++){
                        child[x].typeId = cursor.focusable[j].typeId;
                        var name = child[x].name;
                        var regex = new RegExp("^(.*)(\\(|（).*?(HD)?(20)?(\\d{6}).*(\\)|）)$","gi");
                        var text = regex.exec(name);
                        if (typeof text !== 'undefined' && text !== null ) {
                            child[x].name = text[1];
                            var time = "20" + text[5];
                            time = time.substr(0,4) + "." + time.substr(4,2) + "." + time.substr(6);
                            child[x].time = time;
                        }
                    }
                    var columnName = (cursor.focusable[j].message || '').split('|||');
                    var name = item.name;
                    //如果当前栏目的5条数据和父栏目名称相同则放在一起
                    if( columnName[0] === name ){
                        children[name] = children[name] || [];
                        children[name].pushAll(child);
                    } else o = 0;
                }
            }

            for( var i = 0; i < items.length; i ++)  cursor.focusable[i + 1].items = children[items[i].name];
            for( var i = cursor.focusable.length - 2; i > items.length ;i -- )cursor.focusable.removeAt(i);
            
            //初始化播放列表
            cursor.playList = cursor.call('getPlayList',cursor.focusable);

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
            if(this.focused.length == 0 ){
                var index = cursor.href.query('index');
                if( index.isEmpty() || isNaN(Number(index)) ) {
                    cursor.blocked = 0;
                } else {
                    cursor.focusable[0].focus = cursor.blocked = (Number(index) + 1);
                }
            } else {
                cursor.blocked = Number(this.focused[0]);
                for( var i = 0; i < cursor.focusable.length; i ++)
                    cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
            }
            //如果焦点在搜索框上时,返回后,焦点不在搜索框上
            if( cursor.blocked === 0 ) cursor.blocked = 1;
            if( cursor.focusable[0].focus === 0 && cursor.focusable.length > 2 ) cursor.focusable[0].focus = 1;

            //收藏按钮.
            var favoriteBtn = {id:'-1',focus:0,items:[/*{name:'favorite',className:'favoriteBtn'},{name:'fullscreen',className:'fullScreenBtn'}*/]};
            cursor.focusable.push(favoriteBtn);
            cursor.initilized = false;
            //初始化时，小屏播放。
            cursor.call("enterSmallMode");
            cursor.call('initCursor');
            setTimeout(function(){
                var blocked = cursor.focusable[0].focus;
                var focus = cursor.focusable[blocked].focus;
                var item = cursor.focusable[blocked].items[focus];
                cursor.call('searchForPlay', item );
                cursor.call("prepareVideo");
            }, 100);
        },
        move : function(index){
            if( cursor.dialogShowed ) { return; }
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
            if( index == -1 && ( blocked === 0 || cursor.focusable[0].items.length == 1 ) || blocked === cursor.focusable.length - 1 && ( index == 11 || index == -11 || index == 1 && focus >= 1 ) ||
              ( blocked >= 0 && blocked < cursor.focusable.length - 1 ) && (index == 11 &&  ( blocked === 0 && focus <= 1 || focus <= 0)|| index == -11 && focus + 1 >= items.length ) ||
                blocked >= 1 && index === 1  ) return;

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
                    cursor.call("showMajorArrow");
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
                var id = focus + 1;
                $("item" + id ).className = 'subItem';
                var item = cursor.focusable[blocked].items[focus];
                $("item" + id ).innerHTML = '<div class="text" id="text' + id + '">' + item.name + "</div><div class='time'>" + (item.time || "") + "</div>";
                if( index == 11 || index == -11 ){
                    focus += index > 0 ? -1 : 1;
                }
                else if( index == -1 ){
                    blocked = 0;
                    if( cursor.focusable.length <= 3 ) {
                        //此处代码，注释原因，当子栏目只有一个时，左移动光标，焦点会在搜索按钮上。
                        //focus = 0;
                        //cursor.call("showSearchBtn");
                        focus = 1;
                    } else {
                        focus = cursor.focusable[blocked].focus;
                    }
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if (cursor.moveTimer) clearTimeout(cursor.moveTimer);
            (function(blocked,focus){
                cursor.moveTimer = setTimeout(function(){
                    var item = cursor.focusable[blocked].items[focus];
                    if( cursor.call('searchForPlay', item) ) {cursor.call("prepareVideo");}
                    if(cursor.moveTimer)clearTimeout(cursor.moveTimer);
                    cursor.moveTimer = undefined;
                    cursor.calcStringPixels(item.name, 22, function(pixelsWidth){
                        if( pixelsWidth >= 490 && cursor.blocked === blocked && cursor.focusable[cursor.blocked].focus === focus ){
                            $("text" + ( focus + 1)).innerHTML = '<marquee class="marqueed" scrollamount="10">' + item.name + "</marquee>";
                        }
                    });
                },1500);
            }(blocked, focus));
            cursor.call('show');
        },
        showMajorContent : function(){
            if(cursor.focusable.length < 3 || cursor.focusable[0].items[0].name == 'search' && cursor.focusable[0].items.length == 1) return;
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

                var margin = (Math.ceil( focus  / 5) - 1) * 4 * 65;
                $("majorContainer").style.top = "-" + margin + "px";
            }
            cursor.call("showMajorArrow");
        },
        showSubContent : function(blocked){
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items || [];
            var html = '';
            if( items.length > 0 ) {
                for( var i = 0; i < items.length; i ++ ){
                    var item = items[i];
                    var id = i + 1;
                    html += '<div id="item' + id + '" class="subItem"><div class="text" id="text' + id + '">' + item.name + "</div><div class='time'>" + (item.time || "") + "</div></div>";
                }
            } else {
                cursor.blocked = 0;
                if( cursor.focusable.length <= 3 ){
                    cursor.focusable[blocked].focus = 0;
                    cursor.call("showSearchBtn")
                }
            }
            $("container").innerHTML = html;
            var margin = (Math.ceil( ( focus + 1 ) / 7) - 1) * 7 * 69;
            $("container").style.top = "-" + margin + "px";
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
            if( cursor.focusable.length >= 3 ){
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
                    //for_play_back 加上ifcor参数的作用是删除服务器缓存
                    var queryString = '<%= request.getQueryString()%>&ifcor=1';
                    var currFoucs = cursor.getCurrFocus();
                    var currIndex = queryString.indexOf('currFoucs');
                    if( currIndex > 0 ){ //如果链接中包含 currFoucs
                       var currEnd = queryString.indexOf("&",currIndex);
                       if( currEnd < 0 ) queryString = queryString.substring(0, currIndex);
                       else queryString = queryString.replace(queryString.substring(currIndex,currEnd), 'currFoucs=' + currFoucs);
                    } else { //否则直接把 currFoucs 拼接上去
                        queryString = 'currFoucs=' + currFoucs + "&" + queryString;
                    }
                    url = url + queryString;
                    top.window.location.href = cursor.current() + "/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp?epgBackurl="+ url;
                }
            } else if( blocked > 0 && blocked < cursor.focusable.length - 1) {
                //找到当前焦点所在播放顺序,如果是连续剧,则播放第一集
                var item = cursor.focusable[blocked].items[focus];
                //如果 item.linkto 存在,说明是专题,直接跳转到专题页面
                if( typeof  item.linkto !== 'undefined' ) { top.window.location.href = cursor.linkto(item.linkto); return;}
                //如果找到,全屏播放找到的视频
                if( cursor.call('searchForPlay', item) ) { cursor.call('enterFullMode'); cursor.call("prepareVideo"); }
                return;
            } else { //焦点在功能按钮上
                if( focus === 0 ){ //收藏按钮

                } else {  //全屏播放
                    cursor.call("enterFullMode");
                    return;
                }
            }
        },
        searchForPlay : function( item ){
            var found = false;
            for( var i = 0; i < cursor.playList.length; i ++ ){
                var play = cursor.playList[i];
                //从播放列表中,查找名字相同的电影,或者名字相同的电视剧或名字相同的专题系列的第一个视频
                if( item.isSitcom === 0 && play.name === item.name || item.isSitcom === 1 && play.original === item.name ){
                    if(cursor.initilized && cursor.playIndex === i ) {cursor.call('enterFullMode');cursor.initilized = true; return true;}
                    found = true; cursor.playIndex = i; break;
                }
            }
            return found;
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            cursor.call('resumePlay');
            $("listBody").style.visibility = 'hidden';
            $("arrowUp").style.visibility = "hidden";
            $("arrowDown").style.visibility = "hidden";
            player.fullScreen();
            if(! cursor.timer ) cursor.timer = setInterval(function(){cursor.call('interval');},1000);
        },
        showMajorArrow : function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            $("arrowUp").style.visibility = focus >= 6 ? "visible" : "hidden";
            $("arrowDown").style.visibility = Math.ceil((focus * 1.0) / 5) * 5 + 1 <= items.length ? "visible" : "hidden";
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = cursor.moviePos;
            player.setPosition(pos.left,pos.top,pos.width,pos.height);
            $("listBody").style.visibility = 'visible';
            cursor.call("showMajorArrow");
            cursor.call('resumePlay',true);
            if( cursor.timer ) {
                clearInterval(cursor.timer);
                cursor.timer = undefined;
                $("speed").style.visibility = 'hidden';
            }
        },
        playMovie : function(item){
            if( typeof item === 'undefined' )return;
            player.exit();
            player.play({
                vodId : item.id,
                parentId : item.parentId,
                typeId: item.typeId,
                callback : function(){
                    $("playerIcon").style.visibility = 'hidden';
                    var commit = '{"ServiceType":"0104","user_id":"' + String(iPanel.serialNumber) + '","Time":' + String(new Date().getTime()) + ',"Protocol":"http","Name":"' + encodeURIComponent('党教点播') + '","playType":"demand","LabelId":"' + String(item.typeId) + '","VideoName":"' + encodeURIComponent(item.name) + '","ProgramId":"' + String(item.id) + '","Action":"2","Rate":"hd","Ipqam":"1","Qamname":"","Provider":"chongqing","Publisher":"chongqing","Actors":"","Status":"2"}';
                    if(typeof iPanel.IOControlWrite != 'undefined') iPanel.IOControlWrite("chongqing_collection", commit);
                }
            });
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
            if( cursor.fullmode ) {cursor.call('enterSmallMode'); return; }
            cursor.call("goBackAct");
        },
        resumePlay : function(reset){
            cursor.starter = new Date().getTime();
            if( reset ) {
                cursor.speed = 1;
                player.resume();
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
