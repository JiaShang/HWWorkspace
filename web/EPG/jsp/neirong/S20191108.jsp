<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113180";

    Column column = new Column();
    List<Column> columns = inner.getList(typeId, 4, 0, column);
    for( Column col : columns ) {
        infos.add(new ColumnInfo(col.getId(), 0, 5));
    }
    Result result = new Result( typeId, columns );
    //获取当前栏目的详细信息
    column = inner.getDetail(typeId,column);
    String picture = "images/bg-2019-11-08.png";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }
%>
<html>
<head>
    <title><%=column == null ? "“双11” 我们玩真的！" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-11-08.png') no-repeat;background-position: 0px 0px;}
        .container {width: 1280px;height:720px;left:0px;top:0px; position:absolute; background: transparent url("<%=picture%>") no-repeat left top;}

        .title{width:600px;height:49px;position:absolute;left:622px;top:183px;}
        .titleBd{width:148px;height:49px;float: left;position:relative;}
        .titleBg,.titleTxt{width:140px;height:43px;position:absolute;left:0px;top:0px;}
        .titleBg{background-color:#b64033;}
        .titleFocus{width:140px;height:49px;left:0px;top:0px;background-position: -600px 0px;}
        .titleTxt {text-align: center; color:white; font-size:20px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden; line-height: 38px;}

        .blocked6 {width:360px;height:138px;top:518px;}
        .item1 {left:75px;background-position:0px -300px}
        .item2 {left:462px;background-position:0px -150px}
        .item3 {left:848px;background-position:0px 0px}

        .flowed{width:548px;height:269px;left:641px;top:232px;position:absolute;}
        .item {width:548px;height:46px; position:relative; }
        .focus {background:transparent url('images/mask-2019-11-08.png') no-repeat;background-position: -400px -408px;}
        .text {width:520px;height:46px;left:14px;top:0px; color:#6C413E;font-size: 20px; position:absolute; line-height: 43px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}

        .activity {width:166px;height:24px;background-position: -400px 0px;left:269px;top:525px;}

        .mask6 {width:382px;height:161px;top:507px;background-position:0px -470px;}
        .item61 {left:64px;}
        .item62 {left:451px;}
        .item63 {left:837px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="width: 2500px; height: 45px; left: 0px; top: -50px; position: absolute; z-index: 0; overflow: hidden; visibility: hidden; background-color: transparent; color: transparent;"><span id="calcPixels" style="visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size: 22px"></span><span id="calcOffsetLeft">&nbsp;</span></div>
<div id="container" class="container"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            cursor.activity = (new Date()).Format("yyyy-MM-dd hh:mm:ss") >= '2019-11-11 08:00:00';
            cursor.playIndex = '';

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            var links = {
                focus : 0,
                items:[
                    {name:'一元秒杀',linkto:'http://125.62.26.147:82/topic/topic.html?classId=97&rank=2'},
                    {name:'5折抢购',linkto:'http://192.168.17.235:82/theme-activity?backUrl=others&oprtCatNo=822&sp_code=cqccn_cq'},
                    {name:'华夏航鲜',linkto:'/EPG/jsp/neirong/S20191108Pic.jsp'}
                ]
            };
            cursor.focusable.push(links);
            for( var i = 0; i < cursor.focusable.length; i++){
                var items = cursor.focusable[i].items;
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[i + 1]) : 0;
                if(i == 0 || i == cursor.focusable.length - 1 || items.length < 5 ) continue;
                cursor.focusable[i].items[items.length] = {
                    'name':'更多 ......',
                    'linkto':'/EPG/jsp/neirong/S20191108List.jsp?lft=152&tp=239&w=967&h=387&ih=48&mr=0&fs=22&al=0&pg=8&bc=fff141&fc=444444&cl=444444&sc=1145,245,373,dccfb9,cf181d&typeId=' + cursor.focusable[i].typeId
                }
            }
            if( this.focused.length > 0 ) cursor.consigned = this.focused[this.focused.length -1];
            cursor.call('InitUI');
            setTimeout(function(){ cursor.call('show');},50);
            setTimeout(function(){ cursor.call('lazyShow');},150);
        },
        InitUI      :   function(){
            var html = '<div id="title" class="title">';
            var items = cursor.focusable[0].items;
            var focus = cursor.focusable[0].focus;
            for( var i = 0; i < items.length; i ++) {
                var item = items[i];
                html += '<div class="titleBd">';
                html += '<div class="titleBg"></div>';
                html += '<div class="mask titleFocus" id="title' + String(i + 1) + '" style="' + ( i == focus ? '' : 'visibility:hidden' ) + '"></div>';
                html += '<div class="titleTxt">' + item.name + '</div></div>';
            }
            html += '</div>';
            html += '<div id="mask"></div>';
            html += '<div id="flowed" class="flowed"></div>';
            for( var i = 0; i < 3; i ++ ){
                html += '<div class="mask blocked6 item' + String(i + 1) + '"></div>';
            }
            if( ! cursor.activity ) {
                html += '<div class="mask activity"></div>';
            }
            $('container').innerHTML = html;
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if(
                index == -1 && ( blocked == 1 || blocked == cursor.focusable.length - 1 && focus <= 0 ) ||
                index == 1 && ( blocked == cursor.focusable.length - 2 || blocked == cursor.focusable.length - 1 && focus + 1 >= items.length ) ||
                index == 11 && ( blocked > 0 && blocked < cursor.focusable.length - 1 && focus <= 0 ) ||
                index == -11 && blocked == cursor.focusable.length - 1
            ) return;
            if( index == 1 || index == -1 ){
                if( blocked != cursor.focusable.length - 1 ) {
                    blocked += index;
                    cursor.focusable[0].focus = blocked - 1;
                    focus = cursor.focusable[blocked].focus;
                } else {
                    focus += index;
                }
            } else {
                if( blocked != cursor.focusable.length - 1 ) {
                    focus += index > 0 ? -1 : 1;
                    if( focus >= items.length ) {
                        cursor.consigned = blocked;
                        blocked = cursor.focusable.length - 1;
                        focus = cursor.focusable[blocked].focus;
                    }
                } else {
                    blocked = cursor.consigned || 0;
                    focus = cursor.focusable[blocked].focus;
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            cursor.call('show');
        },
        lazyShow    :   function(){
            if( cursor.blocked == 0 || cursor.blocked == cursor.focusable.length - 1 ) return;
            var blocked = cursor.focusable[0].focus + 1;
            var focus = cursor.focusable[blocked].focus;
            if( String( blocked + 1 ) + String( focus + 1 ) != cursor.playIndex ) {
                cursor.playIndex == '';
                cursor.call('prepareVideo');
            }
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(blocked + 1) + String( focus + 1 );
            cursor.calcStringPixels(text, 20, function(width){
                if( width <= 520 ) return;
                $('txt' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
            });
        },
        nextVideo   :   function () {
            var blocked = cursor.focusable[0].focus + 1;
            var focus = Number(playIndex.substring(1)) + 1;
            var items = cursor.focusable[blocked].items;
            if( items.length > 5 && focus == 5 ) focus = 0;
            cursor.playIndex = String( blocked + 1) + String( focus + 1);
            cursor.call('prepareVideo');
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( playIndex == '' && ( cursor.blocked == 0 || cursor.blocked == cursor.focusable.length - 1 ) ) return;
            var blocked = cursor.focusable[0].focus + 1;
            var focus = playIndex == '' ? cursor.focusable[blocked].focus : Number(playIndex.substring(1));
            var items = cursor.focusable[blocked].items;
            if( items.length > 5 && focus == 5 ) focus = 0;
            var cIdx = String( blocked + 1) + String( focus + 1);
            if( cIdx == playIndex ) return;
            var item = cursor.focusable[blocked].items[ focus ];
            player.exit();
            player.play({
                vodId:item.id,
                position:{width:516,height:316,left:78,top:186},
                callback:function(){
                    cursor.playIndex = cIdx;
                }
            });
        },
        select      :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == cursor.focusable.length - 1 && focus == 0 && !cursor.activity) return;
            cursor.call('selectAct');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == cursor.focusable.length - 1 ) {
                $("mask").className = "mask mask" + (blocked + 1) + " item" + String(blocked + 1) + ( focus + 1);
                $("mask").style.visibility = 'visible';
            } else {
                $("mask").style.visibility = 'hidden';
            }

            for( var i = 0; i < cursor.focusable[0].items.length; i ++ ) {
                $('title' + ( i + 1)).style.visibility = i == cursor.focusable[0].focus ?  'visible' : 'hidden';
            }

            blocked = cursor.focusable[0].focus + 1;
            var html = '';
            var pageCount = 5;
            var items = cursor.focusable[blocked].items;
            focus = cursor.focusable[blocked].focus;
            for( var i = 0; i < items.length; i += 1) {
                var item = items[i];
                var text = item.name;
                html += '<div class="item' + ( cursor.blocked == blocked && focus == i ? ' focus' : '' ) + '">';
                html += '<div class="text" id="txt' + ( String( blocked + 1) + String(i + 1) )  + '" style="' + ( text.indexOf('更多 .') >= 0 ? 'text-align:center' : ''  ) + '">';
                html += text;
                html += '</div></div>';
            }
            $("flowed").innerHTML = html;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>