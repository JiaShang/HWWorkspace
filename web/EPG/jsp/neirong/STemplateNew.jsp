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

            //ȡ���� typeId
            var typeId = query("typeId");
            //��ʾ����ǰtypeId����Ϊ��
            if( typeId.isEmpty() ) { tooltip( decodeURIComponent('%E5%BD%93%E5%89%8DtypeId%E5%8F%82%E6%95%B0%E4%B8%BA%E7%A9%BA') ); return; }
            var that = this;

            // mediaType
            var enc = '&enc=1';
            if( iPanel.HD30Adv ) enc = '';
            var url = EPGUrl + '/neirong/player/detail.jsp?id=' + typeId + '&act=0' + enc;

            ajax(url,
                function(rst){
                    var success = rst.success;
                    if( ! success ) {   //��ʾ��������Ŀ����ʱ�����ִ���
                        tooltip( decodeURIComponent('%E8%AF%B7%E6%B1%82%E6%A0%8F%E7%9B%AE%E6%95%B0%E6%8D%AE%E6%97%B6%EF%BC%8C%E5%87%BA%E7%8E%B0%E9%94%99%E8%AF%AF%EF%BC%81') );
                        return;
                    }
                    rst = rst.data;
                    var column = rst.column;
                    var list = rst.list;
                    //ÿ���б��е���Ƶ����Ҫ�������Ӧ����ĿID
                    //���ֻ��һ����Ŀʱ��д��Ϊ��
                    //cursor.focusable[0] = { items : list, focus: that.focused.length > 1 ? Number(that.focused[1]) : 0, typeId: column.id };
                    //����ж����Ŀʱ��д��Ϊ��
                    //list[0] Ϊ��Ŀ�б����鴦�����Ƿ���Ҫɾ������Ŀ�б�����
                    //list.removeAt(0);
                    //���ɾ��������Ŀ�б�ʱ��������� i �� 0 ��ʼ����Ϊÿ����Ŀ�б�����
                    //���δɾ����Ŀ�б�ʱ��������� i �� 1 ��ʼ����Ϊÿ����Ŀ�б�����
                    // list[i].id Ϊ��Ŀ�� id
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
            //�� 11���� -11���� -1���� 1
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