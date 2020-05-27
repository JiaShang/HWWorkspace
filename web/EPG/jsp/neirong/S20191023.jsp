<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<html>
<head>
    <title></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-10-23.png') no-repeat;background-position: 0px 0px;}

        .bg {width:1280px;height: 720px; position: absolute; left:0px; top:0px; overflow: hidden;}

        .items {left:191px;top:477px;width:1091px;height:167px;position: absolute; }
        .item { width:190px;height:155px;float: left;background-repeat: no-repeat; overflow: hidden; }
        
        .blocked1 {width:450px;height: 307px;left:651px;top:144px; background-position: 0px 0px;}

        .blocked0 {width:161px;height: 179px; top:465px; background-position: -500px 0px;}
        .item01 {left:179px;}
        .item02 {left:369px;}
        .item03 {left:559px;}
        .item04 {left:749px;}
        .item05 {left:939px;}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            //取参数 typeId
            var typeId = query("typeId");
            if( typeId.isEmpty() ) { tooltip( decodeURIComponent('%E5%BD%93%E5%89%8DtypeId%E5%8F%82%E6%95%B0%E4%B8%BA%E7%A9%BA') ); return; }
            var that = this;

            // mediaType
            var enc = '&enc=1';
            if( iPanel.HD30Adv ) enc = '';
            var url = EPGUrl + '/neirong/player/detail.jsp?id=' + typeId + '&act=2&cn=5' + enc;

            ajax(url,
                function(rst){
                    var success = rst.success;
                    if( ! success ) {
                        tooltip( decodeURIComponent('%E8%AF%B7%E6%B1%82%E6%A0%8F%E7%9B%AE%E6%95%B0%E6%8D%AE%E6%97%B6%EF%BC%8C%E5%87%BA%E7%8E%B0%E9%94%99%E8%AF%AF%EF%BC%81') );
                        return;
                    }
                    rst = rst.data;
                    var column = rst.column;
                    var list = rst.list;

                    var html  = '<div id="bg" class="bg" ';
                    var bg = cursor.pictureUrl(column.posters, 7, '');
                    if( ! bg.isEmpty() ) html += ' style="background:url(' + bg + ');"';
                    html += '>';

                    var items = list[0].data;
                    html += '<div class="items">';
                    for( var i = 0 ; i < items.length; i ++ ){
                        var item = items[i];
                        html += '<div class="item" style="background-image: url(' + cursor.pictureUrl(item.posters, 3, 'images/defaultImg.png') + ')"></div>';

                        items[i].linkto = '/EPG/jsp/neirong/S20191023List.jsp?typeId=' + item.id;
                    }

                    cursor.focusable[0] = { items: items };
                    cursor.focusable[0].focus = that.focused.length > 1 ? Number( that.focused[1] ) : 0;

                    list.removeAt(0);

                    for(var i = 0; i < list.length; i++ ) {
                        items = list[i].data;
                        cursor.focusable[i + 1] = { items: items, focus : 0, typeId: list[i].id };
                    }

                    html += '</div><div id="mask"></div></div>';
                    document.body.innerHTML = html;

                    setTimeout( function(){ cursor.call('show'); }, 40);
                    setTimeout( function(){
                        cursor.call('smallVideo');
                        cursor.call('prepare');
                    }, 100);
                },
                {
                    fail:function( meg )
                    {
                        tooltip( decodeURIComponent('%E5%BD%93%E5%89%8DtypeId%E5%8F%82%E6%95%B0%E4%B8%BA%E7%A9%BA') );
                        return;
                    }
                }
            );
        },
        smallVideo  :   function(){
            cursor.fullmode = false;
            $('bg').style.visibility = 'visible';
            player.setPosition(669,161,414,273);
        },
        fullVideo   :   function(){
            cursor.fullmode = true;
            $('bg').style.visibility = 'hidden';
            player.fullScreen();
        },
        prepare     :   function(){
            var focus = cursor.focusable[0].focus;
            cursor.lastIndex = focus;
            var item = cursor.focusable[focus + 1].items[0];
            player.exit();
            player.play( { vodId : item.id } );
        },
        move        :   function(index){
            if( cursor.fullmode )  return;
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 1 && index != -11 || blocked === 0 && ( index == -11 || index == -1 && focus <= 0  || index == 1 && focus + 1 >= cursor.focusable[0].items.length )) return;
            if( index === 11 ) {
                blocked = 1;
                focus = cursor.focusable[blocked].focus;
            } else if( index === -11 ){
                blocked = 0;
                focus = cursor.focusable[blocked].focus;
            } else {
                focus += index;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( cursor.moveTimer ) clearTimeout( cursor.moveTimer );
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                if( blocked == 1 || cursor.lastIndex == cursor.focusable[0].focus ) return;
                cursor.call('prepare');
            }, 1300);

            cursor.call('show');
        },
        select      :   function(){
            if( cursor.fullmode ) return;
            if( cursor.blocked === 1 ) return cursor.call('fullVideo');
            cursor.call('selectAct');
        },
        goBack      :   function(){
            if( cursor.fullmode ) return cursor.call('smallVideo');
            cursor.call('goBackAct');
        },
        nextVideo   :   function () {
            cursor.call('prepare');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask blocked" + String(blocked) + " item" + String( blocked) + String(focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>