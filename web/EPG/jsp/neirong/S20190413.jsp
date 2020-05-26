<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    infos.add(new ColumnInfo("10000100000000090000000000111404", 0, 1));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);

    String defaultPic = "images/bg-2019-04-13.png";
    String picture = column == null ? defaultPic : inner.pictureUrl(defaultPic,column.getPosters(),"7");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-04-13.png') no-repeat;background-position: 0px 0px;}
        .maskNone{width:1px;height:1px;left:-1px;top:-1px;}

        .mask11{width:735px;height:460px;left:48px;top:155px;background-position: 0px 0px;}
        .mask2{width:402px;height:156px;left:811px;background-position: -800px 0px;}

        .mask21{top:156px;}
        .mask23{top:459px;}
        .mask22{top:307px;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div id="listBody" style="position:absolute;width:1280px;height:720px;left:0px;top:0px;overflow: hidden;">
    <div style="background:transparent url('<%=picture%>') no-repeat;width:1280px;height:720px;left:0px;top:0px;position:absolute;"></div>
    <div id='mask'></div>
</div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
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
        moviePos : {width:709,height:436,left:60,top:167},
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.serviceId = 2603;
            cursor.frequency = 2750000;

            cursor.moviePos = this.moviePos;
            cursor.fullmode = false;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[0].items = cursor.focusable[0].items || [];
            cursor.focusable[0].items[0] = cursor.focusable[0].items[0] || {};
            cursor.focusable[0].items[0].style ='mask mask11';
            cursor.focusable[0].focus = 0;

            cursor.focusable[0].items[0].replay = typeof cursor.focusable[0].items[0].isSitcom !== 'undefined' ;
            cursor.focusable[0].items[0].linkto = '';

            cursor.focusable[1] = { focus:this.focused.length > 2 ? Number( this.focused[2] ) : 0,items:
                [
                    {name:'最美开州',linkto:'/EPG/jsp/neirong/S20190413Column.jsp?typeId=10000100000000090000000000111402&lt=580&tp=110&w=570&ih=39&mr=16&fs=24&hm=1&al=0&pg=10&fc=0c559f&cl=ffffff&sc=1160,110,530,8e8e8e,0c559f',style:'mask mask2 mask21'},
                    {name:'塞事详请',linkto:'/EPG/jsp/neirong/STemplateOnePicture.jsp?typeId=10000100000000090000000000111405',style:'mask mask2 mask22'},
                    {name:'塞事回顾',linkto:'/EPG/jsp/neirong/S20190413Column.jsp?typeId=10000100000000090000000000111403&lt=580&tp=110&w=570&ih=39&mr=16&fs=24&hm=1&al=0&pg=10&fc=0c559f&cl=ffffff&sc=1160,110,530,8e8e8e,0c559f',style:'mask mask2 mask23'}
                ]};
            cursor.call('show');
            setTimeout(function(){
                cursor.call('enterSmallMode');
                cursor.call('playMovie');
                setTimeout(function(){cursor.call('counter')}, 100);
            },50);
        },
        nextVideo : function (){
            cursor.call('playMovie');
        },
        playMovie : function () {
            try{
                if( cursor.focusable[0].items[0].replay ) {
                    var id = cursor.focusable[0].items[0].id;
                    player.play({vodId: id});
                } else {
                    player.play({
                        serviceId: cursor.serviceId,
                        frequency: cursor.frequency
                    });
                }
            } catch (e){}
        },
        select: function() {
            if( cursor.fullmode ) return;
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 0 ) return cursor.call('enterFullMode');
            cursor.call('selectAct');
        },
        goBack : function(){
            if( cursor.fullmode )  return cursor.call('enterSmallMode');
            cursor.call('goBackAct');
        },
        enterFullMode : function(){
            cursor.fullmode = true;
            $("listBody").style.display = 'none';
            player.fullScreen();
        },
        enterSmallMode : function(){
            cursor.fullmode = false;
            var pos = cursor.moviePos;
            player.setPosition(pos.left,pos.top,pos.width,pos.height);
            $("listBody").style.display = '';
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            if( cursor.fullmode ) return;
            var blocked = cursor.blocked;
            var previousBlocked = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = 4;

            if( blocked == 0 && index != 1 ||
                blocked == 1 && ( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length || index == 1 )) return;

            if( index == -1 || index == 1 ){
                blocked = index == 1 ? 1 : 0;
                focus = cursor.focusable[blocked].focus;
            } else {
                focus += index > 0 ? -1 : 1;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var item = items[focus];
            $("mask").className = item.style;
            $("mask").style.visibility = 'visible';
        },
        counter : function(){
            cursor.call("sendVote",{
                id:444,limit:999,limitPer:999,target:'1',repeat:true
            });
            if( !cursor.focusable[0].items[0].replay ){
                cursor.call("sendVote",{
                    id:445,limit:999,limitPer:999,target:'1',repeat:true
                });
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>