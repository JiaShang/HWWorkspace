<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 1));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2018-09-05.png') no-repeat;background-position: 0px 0px;}
        .picture {width:662px;height:432px;left:92px;top:144px;position:absolute;}
        .picture img {width:662px;height:432px;}
        .desc { width:310px;height:500px;position:absolute;left:901px;top:89px;background:transparent url('<%= inner.pictureUrl("",column.getPosters(),"4")%>') no-repeat 0px 0px;}
        .arrow {width:797px;height:90px;left:25px;top:322px;background-position:0px -150px;}
        .page {width:60px;height:30px;line-height: 30px;color:white;font-size:22px;text-align: center;left:680px;top:590px;position:absolute;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/bg-2018-09-05.png') no-repeat;" onUnload="exit();">
<div id="picture" class="picture"></div>
<div class="desc"></div>
<div class="mask arrow" style="visibility: hidden" id="arrow"></div>
<div class="page" style="visibility: hidden" id="page"></div>
<div id="mask"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.column = <%= inner.writeObject(column)%>;
            cursor.pictures = cursor.column.posters["0"];
            cursor.isVod = this.data[0].data != undefined;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            if( !cursor.isVod ){
                $("arrow").style.visibility = 'visible';
                $("page").style.visibility = 'visible';
            }
            cursor.focusable[0] = cursor.focusable[0] || {focus:0};

            if( cursor.isVod ) cursor.call("preparePlay");
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;

            if( index == 11 || index == -11 || cursor.isVod || (index == -1 && focus <= 0 || index == 1 && focus + 1 >= cursor.pictures.length  )) return;
            focus += index;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        preparePlay : function(){
            var item = cursor.focusable[0].items[0];
            player.play({
                position: {left:92,top:144,width:662,height:432},
                vodId : item.id
            });
        },
        nextVideo   :   function () {
            cursor.call("preparePlay");
        },
        select : function(){
            cursor.call("goBackAct");
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( cursor.isVod ) return;
            var picture = cursor.pictures[focus];
            $("picture").innerHTML = "<img src='" + picture + "' />";
            $("page").innerHTML = String(focus + 1)  + " / " + String(cursor.pictures.length);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>