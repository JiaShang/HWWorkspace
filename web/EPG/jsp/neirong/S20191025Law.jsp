<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  背景全是图片的专题（模块）
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;
    direct:方向，默认为坚，当不为空时为横
    //背景绑定在每个条目的背景图上
--%>
<html>
<head>
    <title></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
    <style>
        .content {width:1280px;height:720px;left:0px;top:-10px;position:absolute; background: transparent none no-repeat left top;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;background:transparent url('images/bg-2019-10-25-law.png') no-repeat;" onUnload="exit();">
<div id="content" class="content"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.focusable[0] = {focus : 0, items : []};
            cursor.backUrl='<%= backUrl %>';
            cursor.call('show');
        },
        move        :   function(index){
            var focus = cursor.focusable[0].focus;
            if( (index == 11 || index == -1) && focus <= 0 || (index == -11 || index == 1) && focus + 1 >= 9 ) return;
            if( index == 11 || index == -1 )
                focus -= 1;
            else
                focus += 1;
            cursor.focusable[0].focus = focus;
            cursor.call('show');
        },
        select      :   function(){
            return;
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("content").style.backgroundImage = "url('images/item-2019-10-25-law-" + String(focus + 1) + ".png')";
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>