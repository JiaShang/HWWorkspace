<%@ include file="../../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<html lang="zh">
<meta name="page-view-size" content="1280*720">
<head>
    <title>党教2018版首页</title>
    <style>
        body{width:1280px;height:720px;background:transparent url('../../images/translateBg.png') no-repeat left top;overflow: hidden;}
        .bodyTop{position:absolute;left:0px; top:0px;width:1280px;height:98px;background:transparent url('images/index_body_bg_top.jpg') no-repeat left top;}
        .bodyLeft{position:absolute;left:0px; top:97px;width:246px;height:272px;background:transparent url('images/index_body_bg_left.png') no-repeat left top;}
        .bodyRight{position:absolute;left:646px; top:97px;width:634px;height:272px;background:transparent url('images/index_body_bg_right.png') no-repeat left top;}
        .bodyBottom{position:absolute;left:0px; top:369px;width:1280px;height:351px;background:transparent url('images/index_body_bg_bottom.jpg') no-repeat left top;}

        .maskVideo{position:absolute;left:245px; top:96px;width:403px;height:275px;background:transparent url('images/index_mask_video.png') no-repeat left top;}
        .leftList {width:223px;height:500px;position: absolute;left:0px;top:121px;overflow: hidden;}
        .itemLeft {width:223px;height:48px;overflow: hidden;background: transparent no-repeat left top; float: left;}
        .itemLeft1 {height:64px;}
        .maskLeft {width:223px;height:42px;position:absolute;left:0px;top:-50px;overflow: hidden;background: #EC9F00 none no-repeat;}

        .subContant {width:1035px;height:617px;top:98px;left:244px; overflow: hidden;position:absolute;}
        .content,.layout{width:1030px;position:relative;left:0px;top:0px;}
        .txt{background-color: white; color:black;font-size: 18px;text-align: center;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;line-height: 38px;margin:0px 0px 0px 3px}
        .border{background-color:#DE9014;margin:3px 0px 0px 3px}
        .layout{float:left;}

        /*首页推荐的最后8个长,宽*/
        .sub1 .border,.sub1 .border img{ width:316px;height:214px; }
        /*.sub1.item1{ width:414px;height:285px; position: absolute;left:0px;top:0px;}*/
        .sub1.item1,.sub1.item2,.sub1.item5,.sub1.item6{ width:284px;height:216px;position:absolute;}
        .sub1.item1 .border,.sub1.item2 .border,.sub1.item5 .border,.sub1.item6 .border{ width:270px;height:203px;}
        .sub1.item1 .border img,.sub1.item2 .border img,.sub1.item5 .border img,.sub1.item6 .border img{ width:270px;height:203px;}
        .sub1.item3,.sub1.item4 { width:207px;height:148px;top:285px;position:absolute;}
        .sub1.item3 .border,.sub1.item4 .border { width:193px;height:134px;top:285px;}
        .sub1.item3 .border img,.sub1.item4 .border img { width:193px;height:134px;}
        .sub1.item1 { left:414px; top:0px; }
        .sub1.item2 { left:698px; top:0px;}
        .sub1.item3 { left:0px;}
        .sub1.item4 { left:207px;}
        .sub1.item5 { left:414px; top:216px;}
        .sub1.item6 { left:698px; top:216px; }
        .sub1.split{position:absolute;left:0px;width:970px;height:49px;top:433px;}

        .sub1.item7,.sub1.item8,.sub1.item9{width:333px;height:234px;top:482px; position:absolute;}
        .sub1.item10,.sub1.item11,.sub1.item12{width:333px;height:234px;top:720px;position:absolute;}
        .sub1.item7,.sub1.item10{left:0px;}
        .sub1.item8,.sub1.item11{left:333px;}
        .sub1.item9,.sub1.item12{left:666px;}

        .sub2.contant1 {width:333px;height:332px;float:left;position:relative;}
        .sub2.contant1 .border,.sub2.contant1 .border img {width:315px;height:274px;}
        .sub2.contant1 .txt {width:315px;height:38px;}
        .sub2.contant2 {width:248px;height:273px;float:left;position:relative;}
        .sub2.contant2 .border,.sub2.contant2 .border img {width:234px;height:215px;}
        .sub2.contant2 .txt {width:234px;height:38px;}

        .sub3.contant1 {width:333px;height:236px;overflow:hidden;float: left;position:relative;}
        .sub3.contant1 .border,.sub3.contant1 .border img {width:315px;height:172px;}
        .sub3.contant1 .txt {width:315px;height:38px;}
        .sub3.contant2 {width:252px;height:80px;overflow:hidden;float: left;position:relative;}
        .sub3.contant2 .txt {width:222px;height:64px;background-color:#075aaf;color:white;line-height: 58px;font-size: 24px;}
        .sub3.contant3 {width:248px;height:260px;float:left;position:relative;}
        .sub3.contant3 .border,.sub3.contant3 .border img {width:234px;height:202px;}
        .sub3.contant3 .txt {width:234px;height:38px;}
        .sub3.split{width:1030px;height:82px;float:left;position:relative;}

        .sub4.contant{width:333px;height:269px;overflow:hidden;float: left;position:relative;}
        .sub4 .border,.sub4 .border img {width:316px;height:211px;}
        .sub4 .txt {width:316px;height:38px;}

        .sub5.contant{width:196px;height:298px;overflow:hidden;float: left;position:relative;}
        .sub5 .border,.sub5 .border img {width:176px;height:242px;}
        .sub5 .txt {width:176px;height:38px; }
    </style>
    <script language="javascript" type="text/javascript" src="../../player/common.js"></script>
</head>
<body>
<div class="bodyTop"></div><div class="bodyLeft"></div><div class="bodyRight"></div><div class="bodyBottom"></div>
<div class="maskVideo" id="maskVideo"></div>
<div id="maskMajor" class="maskLeft maskLeft2"></div>
<div class="leftList" id="leftList"></div>
<div class="subContant">
    <div id="content" class="content"></div>
</div>
<%
    //栏目ID：﻿10000100000000090000000000108858
    List<Result> columns = new ArrayList<Result>();

    //此栏目下面会有专题系列存在
    inner.setWithId("10000100000000090000000000108885");
    //允许查询专题
    inner.setSpecial(true);

    //首页推荐
    ColumnInfo info = new ColumnInfo("10000100000000090000000000108859", 0, 12);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );
    //学习时间
    info = new ColumnInfo("10000100000000090000000000108860", 0, 99);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );
    //基层党建的推荐
    info = new ColumnInfo("10000100000000090000000000108862", 0, 99);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );
    //政论专题
    info = new ColumnInfo("10000100000000090000000000108867", 0, 99);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );
    //党建课堂的推荐
    info = new ColumnInfo("10000100000000090000000000108869", 0, 99);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );
    //党建在身边
    info = new ColumnInfo("10000100000000090000000000108873", 0, 99);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );

    //后面2个不需要去查询专题和专题片
    inner.setWithId(null);
    inner.setSpecial(false);
    //重温经典
    info = new ColumnInfo("10000100000000090000000000108875", 0, 200);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );

    //警钟长鸣
    info = new ColumnInfo("10000100000000090000000000108876", 0, 200);
    columns.add( inner.getVodList(info.getTypeId(), info.getStation(), info.getLength()) );
%>
</body>
    <script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        focused     : [<%= inner.getPreFoucs() %>],
        data        : [<%
                String html = "";
                for ( int i = 0; i < columns.size(); i++) {
                    Result result = columns.get(i);
                    html += inner.resultToString(result);
                    if( i + 1 < columns.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        init        : function(){
            cursor.withId = '10000100000000090000000000108885';
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.focusable[0] = {
                focus:      this.focused.length > 1 ? Number( this.focused[ 1] ) : 1,
                items:      [
                    {name:'返回首页',isSitcom : 1},
                    {name:'首页推荐',typeId:'10000100000000090000000000108859',layout: 1},
                    {name:'学习时间',typeId:'10000100000000090000000000108860', layout: 2},
                    {name:'基层党建',typeId:'10000100000000090000000000108862', layout: 3},
                    {name:'政论专题',typeId:'10000100000000090000000000108867', layout: 4},
                    {name:'党建课堂',typeId:'10000100000000090000000000108869', layout: 3},
                    {name:'党建在身边',typeId:'10000100000000090000000000108873', layout: 2},
                    {name:'重温经典',typeId:'10000100000000090000000000108875', layout: 5},
                    {name:'警钟长鸣',typeId:'10000100000000090000000000108876', layout: 5},
                    {name:'重庆群工',linkto:'http://192.168.33.92/cqqg/index.htm',isSitcom : 1}
                ]
            };
            if( iPanel.eventFrame.systemId === 1 ) {
                cursor.focusable[0].items.removeAt(1);
                this.data.removeAt(0);
            }
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i + 1] = {};
                cursor.focusable[i + 1].typeId = o["id"];
                cursor.focusable[i + 1].focus = this.focused.length > i + 2 ? Number( this.focused[ i + 2] ) : 0;
                cursor.focusable[i + 1].items = o["data"];
            }
            //搜索和收藏
            cursor.focusable.push( {focus : 0, items:[{},{}]});

            var types = [<%
            //基层党建和党建课堂有子栏目
            //基层党建10000100000000090000000000108861
            //党建课堂10000100000000090000000000108868
             html = "";
             String typeId = "10000100000000090000000000108861";
             html = inner.resultToString(inner.getTypeList(typeId,1,4));
             html += ",";
             typeId = "10000100000000090000000000108868";
             html += inner.resultToString(inner.getTypeList(typeId,1,4));
             out.write(html);
            %>];
            for( var j = 0; j < 2; j ++){
                var items = types[j].data;
                for(var i = items.length - 1; i >= 0; i --){
                    var item = items[i];
                    cursor.focusable[(j == 0 ? 3 : 5) - (iPanel.eventFrame.systemId === 1 ? 1 :0 ) ].items.insertAt(3, item);
                }
            }
            if( iPanel.eventFrame.portalUrl === '' ) iPanel.eventFrame.portalUrl = top.window.location.href;
        },
        move        : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length || index == -1) ) return;
            if( blocked == 0 ) {
                if( index == 11 || index == -11 ) {
                    if( focus == 0 && index == -11 ){   //当光标从进入重庆有线移动到首页推荐时,不需要重新加载内容
                        cursor.focusable[blocked].focus = 1;cursor.call("showLeftFocus"); return;
                    } else  focus += index > 0 ? -1 : 1;
                } else if( index == 1 ) {
                    if( focus == 0 || focus == items.length - 1 ) {
                        cursor.focusable[0].focus = focus  = focus == 0 ? 1 : focus == items.length - 2;
                        cursor.call("showLeftFocus");
                    }
                    blocked = focus; focus = cursor.focusable[blocked].focus;
                }
            } else {
                var sub = cursor.focusable[0].items[blocked].layout;
                if( index == 1 && focus + 1 >= items.length ) return;
                switch (sub){
                    case 1:
                        if( index == 11 && focus <= 1 || index == 1 && ( focus == 1 || focus == 5 || focus == 8 || focus == 11 )) return;
                        if( index == -1 ) {
                            //TODO:当 focus == -1 时,焦点在视频播放上
                            if( focus == 0 || focus == 2 || focus == 6 || focus == 9 ){
                                cursor.blocked = 0; cursor.call('removeBlockFocus'); return;
                            }
                            focus --
                        } else if( index == 1 ) {
                            focus ++;
                        } else if( index == 11 ){
                            if( focus >= 6 ) focus -= 3;
                            else if( focus >= 4 ) focus -= 4;
                            else {
                                //TODO:当 focus == -1 时,焦点在视频播放上
                                return;
                            }
                        } else {
                            if( focus >= 10 ){
                                //TODO:移动到一下块位置
                                return;
                            }
                            focus += focus <= 2 ? 4 : 3 ;
                            if( focus >= items.length ) focus = items.length - 1;
                        }
                        break;
                    case 2:
                    case 3:
                        if( index == 1 && ( focus == 2 || ( focus - 3) % 4 == 3 ) ) return;
                        if( index == 11) {
                            if( focus <= 2 ){
                                //TODO: 光标移动到上一块位置
                                return;
                            }
                            if(focus == 5) focus = 1;
                            else focus -= focus >= 6 ? 4 : 3;
                        } else if( index == 1 ){
                            focus ++;
                        } else if( index == -1 ){
                            if( focus == 0 || ( focus - 3 ) % 4 == 0 ){
                                cursor.blocked = 0; cursor.call('removeBlockFocus'); return;
                            }
                            focus --;
                        } else if( index == -11 ){
                            if( focus <= 2 ) {
                                focus += focus == 2 ? 4 : 3;
                            } else {
                                var tmp = focus - 3;
                                if( Math.ceil( (tmp + 1.0) / 4 ) >=  Math.ceil( (items.length - 3.0) / 4 ) ){
                                    //TODO:移动到一下块位置
                                    return;
                                }
                                focus += 4;
                            }
                            if( focus >= items.length ) focus = items.length - 1;
                        }
                        break;
                    case 4:
                    case 5:
                        var rows = 2, cols = sub == 4 ? 3 : 5;
                        if( index == 1 && focus % cols == cols - 1 ) return;
                        if( index == 1 ) focus ++;
                        else if( index == -1 ) {
                            if( focus % cols == 0 ) {
                                cursor.blocked = 0; cursor.call('removeBlockFocus'); return;
                            }
                            focus --;
                        } else {
                            if( index == 11 ) {
                                if( focus <= cols - 1 ) {
                                    //TODO: 移动到上一块位置
                                    return;
                                }
                                focus -= cols;
                            } else {
                                if( Math.ceil( (focus + 1.0) / cols ) >=  Math.ceil( items.length * 1.0 / cols ) ){
                                    //最后一块, 按下光标键无效.
                                    if( blocked == cursor.focusable.length - 2 ) return;
                                    //TODO:移动到一下块位置
                                    return;
                                }
                                focus += cols;
                                if( focus >= items.length ) focus = items.length - 1;
                            }
                            cursor.call('showBlockPos');
                        }
                        break;
                    default: return;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            //显示左侧焦点
            if( cursor.blocked === 0 ) {
                cursor.call('showLeftFocus');
                if( focus > 0 && focus < cursor.focusable[0].items.length - 1 ){
                    cursor.call('showBlockContent', focus);
                    cursor.call('showBlockPos',focus);
                }
                return;
            } else {
                cursor.call('removeBlockFocus');
                cursor.call('showBlockPos');
                cursor.call('showBlockFocus');
            }
        },
        showBlockPos  : function (blocked) {
            blocked = blocked || cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var sub = cursor.focusable[0].items[blocked].layout;
            switch (sub) {
                case 1:
                    $("sub" + blocked ).style.top = ( focus >= 6 ? -482 : 0) + "px";
                    cursor.call(focus >= 6 ? "stop" : "play");
                    break;
                case 2://TODO:分页处理
                case 3:break;
                case 4:
                case 5:
                    var rows = 2, cols = sub == 4 ? 3 : 5;
                    var page = Math.ceil( ( focus + 1.0 ) / ( cols * rows) ) - 1;
                    $("sub" + blocked ).style.top = "-" + ( (sub == 4 ? 538 : 596) * page ) + "px";
                    break;
                default:break;
            }
        },
        showBlockFocus : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var sub = cursor.focusable[blocked].layout;
            var htmlId = 'subItem' + (blocked + 1) + '' + ( focus  + 1);
            var el = $(htmlId);
            if( ! el ) return;
            setTimeout(function () {
                var fc = document.createElement('div');
                fc.id = htmlId + "Focus";
                fc.style.position = 'absolute';
                fc.style.left = fc.style.top = '0px';
                fc.style.border = "6px solid #fff200";
                fc.style.width = (el.children[0].clientWidth + 3) + "px";
                fc.style.height = (el.children[0].clientHeight + (el.children.length > 1 ? el.children[1].clientHeight : -3) - 3) + "px";
                el.appendChild(fc);
            },10);
            cursor.previousFocus = htmlId;
        },
        removeBlockFocus : function(){
            if(typeof cursor.previousFocus === 'undefined') return;
            var el = $(cursor.previousFocus);
            if( ! el ) return;
            var children = el.children;
            //如果从元素中找到焦点DIV，移除焦点DIV
            if( el.children.length >= 2 ){
                var child = el.children[el.children.length - 1];
                if( child.id .endWith("Focus") ) el.removeChild(child);
                //TODO：去掉游走字幕
            } else {
                var sub = cursor.focusable[cursor.blocked].layout;
                //第三种布局页面中，第
                if( sub == 3 && el.children[0].className.indexOf("txtFocus") >= 0 ){
                    el.children[0].className = 'txt';
                }
            }
        },
        showLeftFocus : function () {
            var focus = cursor.focusable[0].focus;
            if( focus == 0 ) { $("maskMajor").style.top = "123px"; }
            else {
                $("maskMajor").style.top = 189 + (focus - 1) * 48 + "px";
            }
        },
        showBlockContent : function(blocked){
            var sub = cursor.focusable[0].items[blocked].layout;

            var items = cursor.focusable[blocked].items;
            var html = "<div id='sub" + blocked + "' class='layout sub" + sub + "'>";
            var posters = undefined,item = undefined;
            var simple = function(i){
                var item = items[i];
                item.htmlId = 'subItem' + (blocked + 1) + '' + ( i  + 1);
                return item;
            };
            if( typeof items != 'undefined')
            switch (sub){
                case 1:
                    for( var i = 0; i < items.length; i ++){
                        item = simple(i);
                        html += ( i != 6 ? "" : "<div class='split'></div>" )  + "<div id='" + item.htmlId + "' class='sub" + sub  +" item" + ( i + 1 ) + "'><div class='border'><img /></div></div>";
                    }
                    break;
                case 2:
                    for( var i = 0; i < items.length; i ++){
                        item = simple(i);
                        html += "<div id='" + item.htmlId + "' class='sub" + sub  + " contant" + (i < 3 ? 1 : 2) + "'><div class='border'><img /></div><div class='txt'>" + item.name + "</div></div>";
                    }
                    break;
                case 3:
                    for( var i = 0; i < items.length; i ++){
                        item = simple(i);
                        if( i === 3 ){
                            html += "<div class='sub" + sub + " split'>";
                        }
                        if( typeof item.childrenType !== 'undefined' ){
                            html += "<div id='" + item.htmlId + "' class='sub" + sub  + " contant2'><div class='txt'>" + item.name + "</div></div>";
                            if( i+1 >= items.length || typeof items[i + 1].childrenType === 'undefined' ){
                                html += "</div>";
                            }
                        } else {
                            html += "<div id='" + item.htmlId + "' class='sub" +  sub +" contant" + ( i <= 2 ? 1 : 3) + "'><div class='border'><img /></div><div class='txt'>" + item.name + "</div></div>";
                        }
                    }
                    break;
                case 4:
                case 5:
                    for(var i = 0; i < items.length; i += 1) {
                        item = simple(i);
                        html += "<div id='" + item.htmlId + "' class='sub" +  sub +" contant'><div class='border'><img /></div>";
                        html += "<div class='txt'>" + item.name + "</div>";
                        html += "</div>";
                    }
                    break;
                default: break;
            }
            html += "</div>";
            //当图片加载完成后,或者栏目快速移动栏目时,取消延时加载图片
            if( ! isNaN(cursor.lazier) ) clearTimeout(cursor.lazier);
            if( sub === 1 ){
                cursor.call("prepareVideo");
            } else {
                cursor.call("stop");
            }
            $("content").innerHTML = html;
            cursor.call("lazyLoad", {items:items, type:sub === 1 ? 9 : (sub === 5 ? 1 : 99)});
        },
        initCursor : function(){
            var html = '';
            var added = iPanel.eventFrame.systemId === 1 ? 2 : 1;
            for( var i = 0; i < cursor.focusable[0].items.length; i++) {
                html += "<div class='itemLeft" + ( i == 0 ? " itemLeft1" : "") + "' style='background-image:url(images/index_left_" + ( i + ( i == 0 ? 1 : added)) + ".png);'></div>";
            }

            $("leftList").innerHTML = html;

            if( cursor.blocked !== 0) {
                cursor.call('showLeftFocus');
                cursor.call('showBlockContent', cursor.blocked);
            }
            cursor.call('show');
        },
        /**
         * 延时加载
         * @param items
         * @param type
         */
        lazyLoad : function(obj){
            var items = obj.items;
            var type = obj.type;
            if(typeof items === 'undefined') return;
            var traversal = function(el){
                if( typeof el === 'undefined' ) return;
                var children = el.children;
                for( var i = 0; i < children.length ; i ++){
                    var child = children[i];
                    //IMAGE 是机顶盒返回的类型
                    if( child.tagName == "IMAGE" || child.tagName == "IMG" ) return child;
                    if(child.children.length == 0 ) continue;
                    child = traversal(child);
                    if( child.tagName != "IMAGE" && child.tagName != "IMG" ) continue;
                    return child;
                }
            };
            var defaultImage = 'images/defaultPic.jpg';
            var index = 0;
            var timeOut = iPanel.eventFrame.systemId === 0 ? 300 : 150;
            var load = function() {
                var item = undefined;
                while (typeof (item = items[index++]).isRequiredCourse !== 'undefined');
                var img = traversal($(item.htmlId));
                if( typeof img !== 'undefined' ){
                    img.src = cursor.pictureUrl(item.posters,type,defaultImage);
                }
                if( index >= items.length ) { cursor.lazier = undefined; return; }
                cursor.lazier = setTimeout(load,timeOut);
            }
            cursor.lazier = setTimeout(load,timeOut);
        },
        select : function() {
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked === 0 ){
                if( focus === 0 || focus == cursor.focusable[blocked].items.length - 1)
                    top.window.location.href = 'http://192.168.33.92/cqqg/index.htm';
                return;
            }
            var typeId = cursor.focusable[0].items[blocked].typeId;
            var item = cursor.focusable[blocked].items[focus];
            var url = '';
            if( item.isSitcom === 0 ){
                url = cursor.current() + '/EPG/jsp/neirong/edu/v2/player.jsp?id=' + item.id + "&typeId=" + typeId;
            } else {
                if( typeof item.linkto === 'string' ) {
                    url = cursor.linkto( item.linkto );
                } else if( typeof item.redirect  === 'string' || typeof item.isRequiredCourse !== 'undefined'){
                    url = cursor.current() + '/EPG/jsp/neirong/edu/v2/list.jsp?typeId=' + (typeof item.redirect  === 'string' ? item.redirect : item.id);
                } else {
                    url = cursor.current() + '/EPG/jsp/neirong/edu/v2/player.jsp?id=' + item.id + "&typeId=" + typeId;
                }
            }
            top.window.location.href = url;
            return;
        },
        stop : function(){
            media.video.setPosition(0,0,1,1);DVB.stopAV(0);
            $("maskVideo").style.visibility = 'visible';
        },
        prepareVideo : function () {
            if( cursor.blocked > 1 || cursor.focusable[1].focus > 6 ) return;
            var play850 = function(){
                $("maskVideo").style.visibility = 'hidden';
                media.video.setPosition(245,98,401,273);
                DVB.playAV(2590000,701);  //频点，ServiceId
            };
            setTimeout(play850,100);
        }
    };
    cursor.initialize(initialize);
    -->
    </script>
</html>