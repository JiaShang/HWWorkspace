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
        .mask {width:395px;height:220px;position:absolute;background:transparent url('images/mask-2019-08-15.png') no-repeat;background-position: 0px 0px;}
        .mask1{left:41px;top:199px;}
        .mask2{left:443px;top:199px;}
        .mask3{left:845px;top:199px;}
        .mask4{left:41px;top:441px;}
        .mask5{left:443px;top:441px;}
        .mask6{left:845px;top:441px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-08-15.jpg') no-repeat;" onUnload="exit();">
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

            cursor.row = 2;
            cursor.column = 3;
            cursor.pageCount = cursor.row * cursor.column;

            cursor.focusable[0] = {
                focus : this.focused.length > 1 ? Number( this.focused[1] ) : 0,
                items : [
                    {name:'�ز�¯��Ƥ��Ʒ��Ѽ2-3�˲�',linkto:'http://link.cqjlt.net/uhome/go.html?type=4&no=1300110216'},
                    {name:'�Ҷ���ţ��ţ����45��50Ԫȯ',linkto:'http://link.cqjlt.net/uhome/go.html?type=4&no=1500100054'},
                    {name:'Open��ʽ��������298˫�˲�',linkto:'http://link.cqjlt.net/uhome/go.html?type=4&no=1500100036'},
                    {name:'���ڸֹܳ�����С���δ�����',linkto:'http://link.cqjlt.net/uhome/go.html?type=4&no=1500100028'},
                    {name:'Ȫζ����ϵ��֮��Ȫ������',linkto:'http://link.cqjlt.net/uhome/go.html?type=4&no=1400200028'},
                    {name:'Fish�� ����㳩��˫�˲�',linkto:'http://link.cqjlt.net/uhome/go.html?type=4&no=1500100015'}
                ]
            };

            cursor.call('show');
        },
        move        :   function(index){
            //�� 11���� -11���� -1���� 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var row = cursor.row; var column = cursor.column;
            var pageCount = cursor.pageCount;

            if( index == -1 ) {
                if( focus % column == 0 ) {
                    if( focus <= column ) return;
                    focus -= pageCount - column + 1;
                } else focus -= 1;
            } else if( index == 1 ) {
                if( focus % column == column - 1 ) {
                    if( Math.ceil( (focus + 1.0) / pageCount) * pageCount >= items.length ) return;
                    focus += pageCount - column + 1;
                    if( focus >= items.length ) focus = items.length - 1;
                } else if( focus + 1 >= items.length )
                    return;
                else  focus += 1;
            } else if( index == 11 ) {
                focus -= column;
                if( focus < 0 ) { return; }
            } else if( index == -11 ){
                if( focus + column >= items.length && Math.ceil( (focus + 1.0) / column) == Math.ceil( items.length * 1.0 / column)  )
                    return;
                focus += column;
                if( focus >= items.length ) focus = items.length - 1;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked === 0) {
                $("mask").className = "mask mask" + ( focus + 1);
                return;
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>