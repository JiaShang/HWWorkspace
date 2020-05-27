<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000112222";//
    Vod vod = new Vod();
    Integer vodId = null;
    List<Vod> vods = inner.getList(typeId,1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }

    infos.add(new ColumnInfo(typeId, 1, 2));


    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String body = "images/bg-2019-07-31.png";
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
        .mask {position:absolute;background:transparent url('images/mask-2019-07-31.png') no-repeat;background-position: 0px 0px;}
        .mask11 {width:731px;height:399px;left:125px;top:143px;background-position:0px 0px;}

        .mask21{width:229px;height:139px;left:144px;top:544px;background-position:-800px -200px;}
        .mask22{width:229px;height:139px;left:377px;top:544px;background-position:-800px -200px;}
        .mask23{width:229px;height:139px;left:609px;top:544px;background-position:-800px -200px;}

        .mask31{width:243px;height:173px;left:863px;top:143px;background-position:-800px 0px;}
        .mask32{width:243px;height:173px;left:863px;top:329px;background-position:-800px 0px;}
        .mask33{width:243px;height:173px;left:863px;top:510px;background-position:-800px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="overflow:hidden;position: absolute;left:0px;top:0px; width:1280px;height:1280px; background:transparent url('<%=body%>') no-repeat;" id="listBody">
    <div id='mask'></div></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result,new String[]{"[\\(\\（].*?[\\)\\）]"});
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';

            cursor.focusable[0] = {
                focus : 0 , items : [ {'name':'全屏视频'}]
            };

            //10000100000000090000000000112223
            //10000100000000090000000000112224
            //10000100000000090000000000112225
            cursor.focusable[1] = {
                focus : this.focused.length > 2 ? Number(this.focused[2]) : 0,
                items : [
                    {'name':'军人风采','linkto':'/EPG/jsp/neirong/S20190731List.jsp?currFoucs=1,0,0,0,0,0'},
                    {'name':'新闻报道','linkto':'/EPG/jsp/neirong/S20190731List.jsp?currFoucs=2,1,0,0,0,0'},
                    {'name':'经典影视','linkto':'/EPG/jsp/neirong/S20190731List.jsp?currFoucs=3,2,0,0,0,0'}
                ]
            };

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[2] = {};
                cursor.focusable[2].typeId = o["id"];
                cursor.focusable[2].focus = this.focused.length > 3 ? Number( this.focused[ 3 ] ) : 0;
                cursor.focusable[2].items = o["data"];
            }
            cursor.focusable[2].items[2] ={'name':'答题','linkto':'/EPG/jsp/neirong/S20190731Que.jsp' };
            cursor.call('show');
            cursor.call('prepare');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked == 0 && ( index == 11 || index == -1 ) ||
                blocked == 1 && ( index == -11 || index == -1 && focus <= 0  ) ||
                blocked == 2 && ( index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) ) return;

            if( blocked == 0 ) {
                blocked = index == -11 ? 1 : 2; focus = cursor.focusable[blocked].focus;
            } else if( blocked == 1 ){
                if( index == 11 ) {
                    blocked = 0; focus = 0;
                } else {
                    focus += index;
                    if( focus >= items.length ) {
                        blocked = 2; focus = 2;
                    }
                }
            } else {
                if( index == -1 ) {
                    if( focus == 2 ) {
                        blocked = 1; focus = 2;
                    } else {
                        blocked = 0; focus = 0;
                    }
                } else {
                    focus += index > 0 ? -1 : 1;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = 'mask mask' + String(blocked + 1) +   String( focus + 1 );
        },
        prepare :function(){
            var vodId = <%=vodId%>;
            if( vodId == 0 ) return;
            player.play({position:{width:716,height:384,left:133,top:150}, vodId: vodId });
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            $("listBody").style.display = 'none';
            player.fullScreen();
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = cursor.moviePos;
            player.setPosition(133,150,716,384);
            $("listBody").style.display = '';
        },
        goBack : function(){
            if( cursor.fullmode )  return cursor.call('enterSmallMode');
            cursor.call('goBackAct');
        },
        select: function() {
            if( cursor.fullmode ) return;
            var blocked = cursor.blocked;
            if( blocked == 0 ) return cursor.call('enterFullMode');
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 0 && focus != cursor.focusable[blocked].items.length - 1 ) return;
            cursor.call("selectAct");
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>