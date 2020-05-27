<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113580";
    infos.add(new ColumnInfo(typeId, 0, 12));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .bg{width:1280px;height:1882px;top:0px;left:0px;position:relative;background:transparent none no-repeat;background-position: 0px 0px;}
        .bg1{width:1280px;height: 668px;top:0px;left:0px;position:absolute;background:transparent url("images/bg-2019-12-25-1.png") no-repeat 0px 0px;}
        .bg2{width:1280px;height: 1215px;top:667px;left:0px;position:absolute;background:transparent url("images/bg-2019-12-25-2.jpg") no-repeat 0px 0px;}

        .item3 {width:377px;height:210px;position:absolute;}
        .item31 {left:60px;top:689px;}
        .item32 {left:452px;top:689px;}
        .item33 {left:844px;top:689px;}
        .item34 {left:60px;top:925px;}
        .item35 {left:452px;top:925px;}
        .item36 {left:844px;top:925px;}

        .item4 {width:1159px;height:225px;left:60px;top:1163px;position:absolute;}
        .item41 {}

        .item5 {width:570px;height:210px;top:1400px;position:absolute;}
        .item51 {left:60px;}
        .item52 {left:649px;}

        .item6 {width:377px;height:212px;top:1635px;position:absolute;}
        .item61 {left:60px;}
        .item62 {left:453px;}
        .item63 {left:843px;}

        img {width:100%;height:100%;}

        .mask {position:absolute; background: transparent url("images/mask-2019-12-25.png") no-repeat left top; background-position: 0px 0px; }
        .mask1 {width:608px;height:357px;left:317px;top:178px; background-position: 0px 0px;}
        .mask11 {}

        .mask2 {width:221px;height:117px;top:553px; background-position: -650px 0px;}
        .mask21 {left:212px;}
        .mask22 {left:425px;}
        .mask23 {left:629px;}
        .mask24 {left:839px;}

        .mask3 {width:388px;height:222px;background-position: -650px -130px;}
        .mask31 {left:54px;top:683px; }
        .mask32 {left:446px;top:683px; }
        .mask33 {left:838px;top:683px; }
        .mask34 {left:54px;top:919px;}
        .mask35 {left:446px;top:919px;}
        .mask36 {left:838px;top:919px;}

        .mask4 {width:1172px;height:238px;left:54px;top:1156px; background-position: 0px -380px;}
        .mask41 {}

        .mask5 {width:586px;height:224px;top:1400px; background-position: 0px -640px;}
        .mask51 {left:54px;}
        .mask52 {left:640px;}

        .mask6 {width:390px;height:223px;top:1629px; background-position: -650px -640px;}
        .mask61 {left:54px;}
        .mask62 {left:446px;}
        .mask63 {left:836px;}

        /*word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;*/
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div class="bg" id="bg"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    inner.special = true;
                    Result result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            cursor.fullmode = false;
            cursor.isPlaying = false;

            cursor.focusable[0] = {focus:0, items:[], name:"直播窗口"};
            cursor.focusable[1] = {focus:0, items:[], name:"直播频道列表"};
            cursor.focusable[2] = {focus:0, items:[], name:"六个小方块", length: 6};
            cursor.focusable[3] = {focus:0, items:[], name:"一横排最大的", length: 1};
            cursor.focusable[4] = {focus:0, items:[], name:"倒数第二排两个", length: 2};
            cursor.focusable[5] = {focus:0, items:[], name:"倒数第一排三个", length: 3};

            var items = this.data[0]["data"];

            cursor.focusable[1].items = [{
               name: 'CCTV1',frequency: 5060000,serviceId: 3901
            },{
                name: '湖南卫视',frequency: 4980000,serviceId: 3702
            },{
                name: '江苏卫视',frequency: 2030000,serviceId: 3002
            },{
                name: '东方卫视',frequency: 4900000,serviceId: 3602
            }];

            var count = 0;
            for(var index = 2; index < cursor.focusable.length; index ++ ){
                var limit = cursor.focusable[index].length;
                for( var i = 0; i < limit; i ++ ){
                    cursor.focusable[index].items[i] = items[count + i];
                }
                count += limit;
            }

            //赋值焦点
            for( var i = 0 ; i < cursor.focusable.length; i ++ )
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;

            cursor.call('showUI');
            setTimeout(function(){cursor.call('show');}, 100);
        },
        move        :   function(index){
            if( cursor.fullmode ) return;
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 1 && focus + 1 >= items.length || index == -1 && focus - 1 < 0 || index == 11 && blocked <= 0 || index == -11 && blocked + 1 > cursor.focusable.length - 1 ) return;
            if( index == 1 || index == -1 ) focus += index;
            else {
                if( index == -11 && blocked == 2 && focus <= 2 || index == 11 && blocked == 2 && focus > 2  ){
                     focus += index > 0 ? -3 : 3;
                } else {
                    blocked += index > 0 ? -1 : 1;
                    focus = cursor.focusable[blocked].focus;
                }
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        playMovie   :   function(){
            player.exit();
            var focus = cursor.focusable[1].focus;
            var item = cursor.focusable[1].items[focus];
            player.play({ frequency:item.frequency, serviceId:item.serviceId, position:{width:593,height:343,left:325 ,top:185} });
            cursor.isPlaying = true;
        },
        showUI        :   function(){
            var html = '<div class="bg1" id="bg1"></div><div class="bg2" id="bg2"></div>';
            var count = 0;
            for( var i = 2; i < cursor.focusable.length; i ++){
                var items = cursor.focusable[i].items;
                for( var j = 0; j < items.length; j ++ ) {
                    var item = items[j];
                    html += '<div class="item' + String( i + 1 ) + ' item' + String( i + 1 ) + String( j + 1 ) + '" id="item' + String(++count) + '">';
                    html += '<img src="' + cursor.pictureUrl(item.posters, 1, 'images/defaultImg.png') + '" />';
                    html += '</div>';
                }
            }
            html += '<div id="mask" />';
            $("bg").innerHTML = html;
        },
        smallVideo: function(){
            cursor.fullmode = false;
            $("bg").style.visibility = 'visible';
            return player.setPosition(325,185,593,343);
        },
        fullVideo:function(){
            cursor.fullmode = true;
            $("bg").style.visibility = 'hidden';
            return player.fullScreen();
        },
        select : function(){
            var blocked = cursor.blocked;
            if( blocked == 0 ) {
                return cursor.call( cursor.fullmode ? 'smallVideo' : 'fullVideo' )
            }
            var focus = cursor.focusable[blocked].focus;
            if( blocked == 1 ) return cursor.call('playMovie');
            cursor.call('selectAct');
        },
        goBack      :   function(){
            var blocked = cursor.blocked;
            if( blocked == 0 ) {
                return cursor.call( cursor.fullmode ? 'smallVideo' : 'fullVideo' )
            }
            cursor.call('goBackAct');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;

            if( blocked == 0 || blocked == 1 ) {
                $("bg").style.top = "0px";
                if( !cursor.isPlaying ) cursor.call('playMovie');
            } else {
                if( blocked >= 4 ) {
                    $("bg").style.top = String( 720 - 1882 ) + "px";
                } else {
                    $("bg").style.top = "-668px";
                }
                if( cursor.isPlaying ) {
                    player.exit();
                    cursor.isPlaying = false;
                }
            }
            $("mask").className = "mask mask" + String(blocked + 1) + " mask" + String( blocked + 1) + String( focus + 1);

        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>