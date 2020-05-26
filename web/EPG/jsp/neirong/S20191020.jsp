<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000112971";
    infos.add(new ColumnInfo("10000100000000090000000000112994", 0, 1));
    infos.add(new ColumnInfo("10000100000000090000000000112996", 0, 5));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = inner.pictureUrl("", column == null ? null : column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-10-20.png') no-repeat;background-position: 0px 0px;}
        .container {width:1280px;height:720px;left:0px;top:0px;position:absolute;overflow: hidden; background: transparent url('<%=picture%>') no-repeat left top;}

        .item01Focus{width:520px;height: 321px;left:43px;top:168px;background-position:0px 0px;}

        .item11Focus{width:303px;height: 460px;left:963px;top:46px;background-position:-550px 0px;}

        .item2 {width:288px;height:150px;top:522px;position:absolute;}
        .item21{left:43px;}
        .item22{left:347px;}
        .item23{left:651px;}
        .item24{left:955px;}

        .item2Focus {width:294px;height:156px;top:519px; background-position: 0px -350px;}
        .item21Focus{left:40px;}
        .item22Focus{left:344px;}
        .item23Focus{left:648px;}
        .item24Focus{left:952px;}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div class="container" id="container"></div>
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
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.fullmode = false;

            cursor.serviceId = 2602;
            cursor.frequency = 2750000;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.focusable[2] = {focus: this.focused.length > 3 ? Number( this.focused[3] ) : 0 };
            cursor.focusable[2].items = [];

            var html = '';
            var i = 1;
            while (cursor.focusable[1].items.length > 1) {
                var item = cursor.focusable[1].items[1];
                cursor.focusable[2].items.push(item);
                var bg = cursor.pictureUrl( item.posters, 1, 'none' );
                if( bg != 'none' ) bg = "url('" + bg + "')";
                html += '<div class="item2 item2' + String( i++ ) + '" style="background:transparent ' + bg +  ' no-repeat left top;"></div>';
                cursor.focusable[1].items.removeAt(1);
            }
            html += "<div id='mask'></div>";

            $("container").innerHTML = html;

            if( cursor.focusable[2].items[2] ) cursor.focusable[2].items[2].linkto = 'http://192.168.35.153:8080/common/program_theme_9.jsp?id=76&lcn=m';
            if( cursor.focusable[2].items[3] ) cursor.focusable[2].items[3].linkto = 'http://192.168.35.153:8080/common/program_theme_9.jsp?id=103&lcn=qb';

            setTimeout(function(){
                player.setPosition(46,171,514,315);
                cursor.call('playMovie');
            }, 500);

            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index == 11 || index == -1) || blocked === 1 && ( index == 11 || index == 1 ) || blocked == 2 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length )) return;

            if( index == -11 ) {
                blocked = 2; focus = cursor.focusable[blocked].focus;
            } else if( index == 11 ) {
                blocked = focus <= 1 ? 0 : 1;
                focus = 0;
            } else if( index == 1 || index == -1 ) {
                if( blocked != 2 ) {
                    blocked += index;
                    focus = 0;
                } else {
                    focus += index;
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        playMovie   :   function(){
            var blocked = 0;
            player.exit();

            //播放直播
            if( ! cursor.focusable[blocked].items ) {
                player.play(
                    {
                        serviceId: cursor.serviceId,
                        frequency: cursor.frequency
                    }
                );
            } else {//播放点播
                var item = cursor.focusable[blocked].items[0];
                player.play({ vodId: item.id });
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            if(blocked == 0 ) {
                if( !cursor.fullmode  ){
                    cursor.fullmode = true;
                    player.setPosition(0,0,1280,720);
                    $('container').style.display = 'none';
                }
                return;
            }
            cursor.call("selectAct");
        },
        goBack : function(){
            if( cursor.fullmode ) {
                $('container').style.display = 'block';
                player.setPosition(46,171,514,315);
                cursor.fullmode = false;
                return;
            }
            cursor.call('goBackAct');
        },
        nextVideo   :   function () {
            cursor.call('playMovie');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var clazz = 'mask item' + String(blocked)  +  'Focus item' + String(blocked) + String( focus + 1) + 'Focus';
            $("mask").className = clazz;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>