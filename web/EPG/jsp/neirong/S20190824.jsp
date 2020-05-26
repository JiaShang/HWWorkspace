<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    String typeId = "10000100000000090000000000112443";
    List<Column> columns = inner.getList(typeId, 4, 0 , new Column());

    inner.special = true;
    Result innerTypeList = inner.getTypeList(typeId,0,4);
    inner.special = false;

    Column column = inner.getDetail(typeId,new Column());
    String body = "images/bg-2019-08-24.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-08-24.png') no-repeat;background-position: 0px 0px;}
        .flowed {width:1280px;height:133px;left:93px;top:515px;position:absolute;}

        .list{width:570px;height:340px;left:590px;top:230px;position:absolute;}
        .ItemContainer,.ItemContainerFocus{width:570px;height:61px;float:left;overflow: hidden;background-position: 0px 0px;}
        .ItemContainer {position:relative;}
        .ItemContainerFocus {background:transparent url('images/mask-2019-08-24.png') no-repeat;background-position:0px 0px;height:74px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;position:absolute;left:182px;}

        .ItemContainer .item,.ItemContainerFocus .item,.ItemContainer .item .marquee {width:535px;height:61px;line-height:60px;font-size: 20px;position:absolute;}
        .ItemContainer .item {color:black;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;left:30px;}
        .ItemContainerFocus .item {color:red;left:30px;line-height:80px;}
        .icon {position:absolute;left:0px;width:30px;height:61px;top:0px;background:transparent url('images/mask-2019-08-24.png') no-repeat;background-position: -840px -129px;}

        .image2 {position:absolute;width:570px;left:618px;}
        .image21 {height:217px;top:169px;}
        .image22 {height:125px;top:402px;}

        .image3{width:221px;height:132px;top:0px;position:absolute;}
        .image31 {left:0px;}
        .image32 {left:240px;}
        .image33 {width:605px;left:487px;}
        img {width:100%;height:100%}

        .mask1 {width:584px;height:74px;left:590px; background-position:0px -160px;}
        .mask11 {top:220px;}
        .mask12 {top:281px;}
        .mask13 {top:342px;}

        .mask2 {width:295px;height:68px;top:422px;}
        .mask21 {left:580px; background-position:0px 0px;}
        .mask22 {left:890px; background-position:0px -80px;}

        .mask3 {width:229px;height:134px;top:538px; background-position:-600px -100px;}
        .mask31 {left:65px;}
        .mask32 {left:290px;}
        .mask33 {left:515px;}

        .mask4 {width:81px;height:50px;left:1118px;top:177px; background-position:-300px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('<%=body%>') no-repeat;" onUnload="exit();">
<div style="position:absolute;z-index:0;width:2500px;height:45px;top:0px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div id="list" class="list"></div>
<div id="mask"></div>
<div id="flowed" class="flowed"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                Result result = null;
                for ( int i = 0; i < 1; i++) {
                    Column info = columns.get(i);
                    result = inner.getVodList( info.getId(), 0, 3 );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    html += ",\n";
                }
                html += inner.resultToString(innerTypeList,new String[]{"[\\(\\（].*?[\\)\\）]"});
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.consigned = [];
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.focusable.insertAt(1, {
                focus:0,
                items: [
                    {"name":"交通","linkto":"/EPG/jsp/neirong/S20190824Traf.jsp"},
                    {"name":"区域","linkto":"/EPG/jsp/neirong/S20190824Area.jsp"}
                ]
            });
            cursor.focusable[3] = {
                focus : 0,
                items : []
            };
            cursor.focusable[3].items[0] = cursor.focusable[2].items[0];
            cursor.focusable[2].items.removeAt(0);

            for( var i = 0; i < cursor.focusable.length; i ++) cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;

            cursor.call('showUI');
            cursor.call('show');
            setTimeout(function(){cursor.call('lazyShow', true);}, 40);
            cursor.call('prepareVideo');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var previousFocus = focus;
            var items = cursor.focusable[blocked].items;

            if( blocked == 0 && ( index == -1 || index == -1) ||
                blocked == 1 && ( index == -1 && focus <= 0 || index == 1 && focus >= 1 ) ||
                blocked == 2 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) ||
                blocked == 3 && index != -11
              ) return;

            if( blocked == 0 ) {
                if( index == 11 ) {
                    focus -= 1;
                    if( focus < 0 ) {  blocked = 3 ; focus = cursor.focusable[blocked].focus; }
                } else {
                    focus += 1;
                    if( focus >= items.length ) { blocked = 1 ; focus = cursor.focusable[blocked].focus; }
                }
            } else if( blocked == 1) {
                if( index == -1 || index == 1  ) {
                    focus += index;
                } else {
                    blocked = index == 11 ? 0 : 2; focus = cursor.focusable[blocked].focus;
                }
            } else if( blocked == 2) {
                if( index == -1 || index == 1  ) {
                    focus += index;
                } else {
                    blocked = 1; focus = cursor.focusable[blocked].focus;
                }
            } else {
                blocked = 0; focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){ clearTimeout(cursor.moveTimer);cursor.moveTimer = undefined;cursor.call('lazyShow');}, 1300);
            if( previous == 0 || blocked == 0 ) cursor.call('showItems');
            if( previous == 2 ) cursor.call('hiddenPicture', previousFocus);
            cursor.call('show');
        },
        lazyShow : function(init){
            var blocked = cursor.blocked;
            if( blocked != 0 ) return;
            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            cursor.calcStringPixels(text, 20, function(width){
                if( cursor.blocked != 0 || width <= 535 ) return;
                $('itemMask').innerHTML  = '<marquee class="marquee" scrollamount="8">' + text + "</marquee>";
            });
            if( init ) return;
            cursor.call('prepareVideo');
        },
        showItems     :   function(){
            var blocked = 0;
            var items = cursor.focusable[blocked].items;
            var focus = cursor.focusable[blocked].focus;

            //每页显示数量
            var pageCount = 3;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '', id = '';
            var container = 'list';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='ItemContainer' id='txt" + ( i - flowCursorIndex + 1 ) + "'>";
                html += "<div class='icon'></div>";
                html += "<div class='item' id='item" +  String( i - flowCursorIndex + 1 ) + "'>" + item.name;
                html += "</div></div>";
            }
            $(container).innerHTML = html;
        },
        showUI        :   function(){
            cursor.call("showItems");
            var html = "";
            var blocked = 2;
            var items = cursor.focusable[ blocked ].items;
            for( var i = 0; i < items.length ; i ++){
                html += '<div class="image' + String(blocked + 1) + ' image' + String(blocked + 1) + String( i + 1) + '" id="img' + String(blocked + 1) + String( i + 1) + '">';
                html += '<img src="' + cursor.pictureUrl(items[i].posters, 2, 'images/defaultImg.png') +  '"/>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
        },
        select      :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var item = items[focus];
            if( blocked == 3 || blocked == 2 && focus <= 1 ) {
                if( typeof item.linkto === 'undefined' ) {
                    cursor.focusable[blocked].items[focus].linkto = '/EPG/jsp/neirong/S20190824Txt.jsp?typeId=' + item.id;
                }
            }
            cursor.call('selectAct');
        },
        nextVideo   :   function () {
            var playIndex = cursor.focusable[0].focus;
            cursor.focusable[0].focus = playIndex = playIndex + 1 < cursor.focusable[0].items.length ? playIndex + 1 : 0;
            var item = cursor.focusable[0].items[playIndex];
            cursor.call("playMovie",item);
        },
        prepareVideo : function(){
            var focus = cursor.focusable[0].focus;
            if( cursor.focusable[0].items.length <= 0 )return;
            var item = cursor.focusable[0].items[focus];
            cursor.call("playMovie",item);
        },
        playMovie : function(item){
            player.setPosition(89,202,470,288);
            if( typeof item === 'undefined' ) return;
            player.play({vodId:item.id});
        },
        hiddenPicture : function(focus){
            var blocked = 2;
            var item = cursor.focusable[blocked].items[focus];
            $("img" + String( blocked + 1) + String(focus + 1)).innerHTML = '<img src="' + cursor.pictureUrl(item.posters,2) + '" />';
        },
        showPicture : function(){
            var blocked = 2;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];
            $("img" + String( blocked + 1) + String(focus + 1)).innerHTML = '<img src="' + cursor.pictureUrl(item.posters,3) + '" />';
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 2 ) {
                $("mask").innerHTML = "";
                $("mask").style.visibility = "hidden";
                cursor.call('showPicture');
            } else {
                if( blocked == 0 ) {
                    $("mask").className = 'mask ItemContainerFocus mask1 mask' + String(blocked + 1) + String( focus + 1 );
                    var html = "<div class='icon' style='width:60px;'></div>";
                    var item = cursor.focusable[blocked].items[focus];
                    $("mask").innerHTML = html + "<div class='item' id='itemMask'>" + item.name + '</div>';
                } else {
                    $("mask").innerHTML = "";
                    $("mask").className = 'mask mask' + String(blocked + 1) + " mask" + String(blocked + 1) + String( focus + 1 );
                }
                $("mask").style.visibility = "visible";
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>