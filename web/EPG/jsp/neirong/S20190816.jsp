<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = "10000100000000090000000000112351";
    List<Column> columns = inner.getList(typeId,6,0,new Column());
    Result parent = new Result(typeId,columns);
    for( Column col : columns ) infos.add(new ColumnInfo(col.id,0,99));

    Column column = inner.getDetail(typeId,new Column());
    String body = "images/bg-2019-08-16.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "绿水青山 美好家园" : column.getName()%></title>
    <style>
        .body {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:720px;}

        .major {width:174px;height:360px;position:absolute;left:32px;top:153px;overflow: hidden;}
        .majorContainer,.majorContainerFocus,.majorContainerActive{width:174px;height:54px;float: left;overflow: hidden;background:transparent url('images/mask-2019-08-16.png') no-repeat;background-position: 0px -200px;position:relative;}
        .majorContainer,.majorContainerActive {background-position:0px -200px;}
        .majorContainerFocus {background-position:0px 0px;}

        .majorContainer .item,.majorContainerActive .item,.majorContainerFocus .item {width:144px;height:54px;line-height:50px;font-size: 22px;text-align: left;position:absolute; position:absolute;left:15px;}
        .majorContainerFocus .item .marquee {width:144px;height:54px;line-height:50px;font-size: 22px;}
        .majorContainer .item ,.majorContainerActive .item{color:white;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .majorContainerFocus .item {color:black;}
        .majorContainerActive .item {color:#FAEA00;}

        .flowed {position:absolute;width:261px;height:480px;left:236px;top:153px;overflow: hidden;background-image: none;}

        .flowedContainer,.flowedContainerFocus,.flowedContainerActive{width:261px;height:50px;float:left;overflow: hidden;background:transparent url('images/mask-2019-08-16.png') no-repeat;background-position: 0px -200px;}
        .flowedContainer {background-position:0px -200px;}
        .flowedContainerFocus {background-position:0px -100px;}

        .flowedContainer .item,.flowedContainerFocus .item,.flowedContainerActive .item{width:221px;height:50px;line-height:48px;font-size: 20px;position:absolute;left:20px;}
        .flowedContainerFocus .item .marquee {width:221px;height:50px;line-height:48px;font-size: 20px;}
        .flowedContainer .item,.flowedContainerActive .item {color:white;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .flowedContainerFocus .item {color:black;}
        .flowedContainerActive .item {color:#FAEA00;}

        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;"  onUnload="exit();">
    <div style="position:absolute;z-index:0;width:2500px;height:45px;top:0px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
        <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
    </div>
    <div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
        <div class='body'><img src="<%=body%>"/></div>
        <div class='major' id='major'></div>
        <div class='flowed' id='flowed'></div>
        <div id='mask'></div>
    </div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data : [<%
                String html = "";
                html += inner.resultToString(parent,new String[]{"[\\(\\（].*?[\\)\\）]"}) + ",\n";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            //这个用来存放当前播放影片的播放时间
            cursor.moviePos = this.moviePos;
            cursor.speed = 1;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = -1;
                cursor.focusable[i].focus = 0;
                cursor.focusable[i].items = o["data"];
            }

            for( var i = 0; i < this.data.length; i ++)
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;

            cursor.call('show');
            cursor.call('lazyShow');
        },
        playMovie : function(item){
            if( typeof item === 'undefined' )return;
            try{
                player.exit();
                var pos = {width:622,height:329,left:600,top:229};
                player.setPosition(pos.left,pos.top,pos.width,pos.height);
                debug("S20190528 ==> Before call player.play({vodId: ", item.id,'});');
                player.play( {vodId: item.id} );
            } catch (e){ }
        },
        nextVideo : function ( ){
            if( !cursor.moveTimer ) {
                var playIndex = cursor.playIndex;
                var blocked = cursor.focusable[0].focus + 1;
                var items = cursor.focusable[blocked].items;
                playIndex = playIndex + 1 < items.length ? playIndex + 1 : 0;
                cursor.focusable[blocked].focus = cursor.playIndex = playIndex;
                cursor.call('show');
                cursor.call('lazyShow');
            }
        },
        prepareVideo : function(){
            var playIndex = cursor.playIndex;
            if( cursor.focusable[0].items.length <= 0 )return;
            var blocked = cursor.focusable[0].focus + 1;
            var item = cursor.focusable[blocked].items[playIndex];
            cursor.call("playMovie",item);
        },
        move : function(index){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length || index == -1 && blocked == 0 || index == 1 && blocked != 0 ) return;
            if( index == 11 || index == -11 ) {
                focus += index > 0 ? -1 : 1;
            } else {
                blocked = index == -1 ? 0 : cursor.focusable[0].focus + 1;
                focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('clearMoveTimer');
            cursor.moveTimer = setTimeout(function(){ cursor.call('clearMoveTimer');cursor.call('lazyShow');}, 1500);
            cursor.call('show');
        },
        clearMoveTimer : function(){
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = undefined;
        },
        lazyShow : function(){
            var blocked = cursor.blocked;
            if( blocked == 0 ) blocked = cursor.focusable[0].focus + 1;

            var focus = cursor.focusable[blocked].focus;
            var text = cursor.focusable[blocked].items[focus].name;
            var id = String(blocked + 1) + String( focus + 1 );
            var fontsize = blocked === 0 ? 22 : 20;
            var width = blocked === 0 ? 144 : 221;
            if( cursor.played == '' || cursor.played != id ) {
                cursor.playIndex = focus;
                cursor.call('prepareVideo');
                cursor.calcStringPixels(text, fontsize, function(pixelsWidth){
                    if( pixelsWidth <= width || cursor.blocked != blocked ) return;
                    $('item' + id).innerHTML  = '<marquee class="marquee" scrollamount="8">' + text + "</marquee>";
                });
                cursor.played = id;
            }
        },
        show: function(){
            var blocked = 0;
            cursor.call("showItems", 0);

            blocked = cursor.focusable[blocked].focus + 1;
            cursor.call("showItems", blocked);
        },
        showItems : function(blocked){
            var items = cursor.focusable[blocked].items;
            if( items.length <= 0 ) return;
            var focus = cursor.focusable[blocked].focus;

            //每页显示数量
            var pageCount = 8;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            var html = '', id = '';

            var container = blocked == 0 ? 'major' : 'flowed';

            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            if( blocked !== 0 && blocked === cursor.blocked )
                id = "item" + (blocked + 1) + "" + (focus % pageCount + 1 ) ;

            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var clazz = container + "Container";
                if( focus === i )  clazz += blocked === cursor.blocked ? "Focus" : "Active";
                html += "<div class='" + clazz + "'>";
                html += "<div class='item' id='item" + ( (blocked + 1) + "" + ( i - flowCursorIndex + 1 ) )+ "'>" + item.name.replace(/^.*：/gi,"");
                html += "</div></div>";
            }
            $(container).innerHTML = html;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>