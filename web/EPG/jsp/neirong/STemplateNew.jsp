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
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2019-03-22.png') no-repeat;background-position: 0px 0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-03-22.jpg') no-repeat;" onUnload="exit();">
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
            //提示：当前typeId参数为空
            if( typeId.isEmpty() ) { tooltip( decodeURIComponent('%E5%BD%93%E5%89%8DtypeId%E5%8F%82%E6%95%B0%E4%B8%BA%E7%A9%BA') ); return; }
            var that = this;

            // mediaType
            var enc = '&enc=1';
            if( iPanel.HD30Adv ) enc = '';
            var url = EPGUrl + '/neirong/player/detail.jsp?id=' + typeId + '&act=0' + enc;

            ajax(url,
                function(rst){
                    var success = rst.success;
                    if( ! success ) {   //提示：请求栏目数据时，出现错误！
                        tooltip( decodeURIComponent('%E8%AF%B7%E6%B1%82%E6%A0%8F%E7%9B%AE%E6%95%B0%E6%8D%AE%E6%97%B6%EF%BC%8C%E5%87%BA%E7%8E%B0%E9%94%99%E8%AF%AF%EF%BC%81') );
                        return;
                    }
                    rst = rst.data;
                    var column = rst.column;
                    var list = rst.list;
                    //每个列表中的视频，都要加上其对应的栏目ID
                    //如果只有一个栏目时，写法为：
                    //cursor.focusable[0] = { items : list, focus: that.focused.length > 1 ? Number(that.focused[1]) : 0, typeId: column.id };
                    //如果有多个栏目时，写法为：
                    //list[0] 为栏目列表，酌情处理，看是否需要删除掉栏目列表数据
                    //list.removeAt(0);
                    //如果删除掉了栏目列表时，下面代码 i 从 0 开始计数为每个栏目列表数据
                    //如果未删除栏目列表时，下面代码 i 从 1 开始计数为每个栏目列表数据
                    // list[i].id 为栏目的 id
                    //for(var i = 0; i < list.length; i++ ) {
                    //    var items = list[i].data;
                    //    cursor.focusable[i + 1] = { items: items, focus : 0, typeId: list[i].id };
                    //}
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

            //if( blocked === 0 && ()) return;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        playMovie   :   function(){

        },
        nextVideo   :   function () {

        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 0) {
                $("mask").className = "mask mask" + (blocked + 1) + "" + ( focus + 1);
                return;
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>