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
        .mask {width:703px;height:52px; left:288px; position:absolute;background:transparent url('images/mask-2019-10-23.png') no-repeat;background-position: 0px -320px;}

        .title {width:1280px;height:80px;position: absolute;left:0px; top:60px; overflow: hidden;}
        .container {width:704px;height:390px;left:288px;top:190px;position: absolute; }

        .item {width:700px;height:60px;}
        .dot {width: 30px;height:60px;float: left;background:transparent url('images/mask-2019-10-23.png') no-repeat -10px -540px;}
        .redDot {width: 30px;height:60px;float: left;background:transparent url('images/mask-2019-10-23.png') no-repeat -10px -430px;}
        .text {width:670px;height:60px;float: left;color:#404040; font-size:22px; text-align:left;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}

        .marquee {width:660px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black none no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after"></div>
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
            var url = EPGUrl + '/neirong/player/detail.jsp?id=' + typeId + '&act=0' + enc;
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

                    cursor.focusable[0] = { items : list, focus: that.focused.length > 1 ? Number(that.focused[1]) : 0, typeId: column.id };

                    var html = '';
                    var bg = cursor.pictureUrl(column.posters, 7, '');

                    if( ! bg.isEmpty() ) {
                        document.body.style.backgroundImage = 'url("' +  bg +  '")';
                    }

                    html += '<div class="title" style="background-image: url(\'' +  cursor.pictureUrl(column.posters, 4, '') + '\')"></div>';
                    html += '<div class="container" id="container"></div>';
                    html += '<div id="mask"></div>';
                    document.body.innerHTML = html;

                    setTimeout(function(){ cursor.call('show'); }, 50);
                    setTimeout(function(){ cursor.call('lazyShow');  }, 100 );
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
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            focus += index == 11 ? -1 : 1;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( cursor.moveTimer ) clearTimeout( cursor.moveTimer );
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                setTimeout(function(){ cursor.call('lazyShow');  }, 100 );
            }, 1300);

            cursor.call('show');
        },
        lazyShow    :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var item = cursor.focusable[blocked].items[focus];
            var id = 'item' + String(focus + 1);
            cursor.calcStringPixels ( item.name, 22, function ( width ) {
                if( width <= 670) return;
                var html = '<marquee class="marquee" scrollamount="8">' + item.name + '</marquee>';
                $(id).innerHTML = html;
            });
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var pageCount = 7;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            /*if(  flowCursorIndex + pageCount  >= items.length ) {
                flowCursorIndex = items.length - pageCount ;
            }*/

            var html = '';  var position = 0;
            for ( var i = flowCursorIndex; i < flowCursorIndex + pageCount && i < items.length; i ++){
                var item = items[i];
                html += '<div class="item">';
                if( i == focus ) {
                    html += '<div class="redDot"></div>';
                    html += '<div id="item' + String( i + 1) + '" class="text" style="color:#B41B00">';
                    position = i - flowCursorIndex;
                } else {
                    html += '<div class="dot"></div>';
                    html += '<div id="item' + String( i + 1) + '" class="text">';
                }
                html += item.name;
                html += '</div>';
                html += '</div>';
            }

            $('container').innerHTML = html;
            $('mask').className = 'mask';
            $('mask').style.top =  String(position * 60 + 173) + 'px';
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>