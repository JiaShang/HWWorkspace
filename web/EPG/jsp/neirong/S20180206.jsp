<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:68px;height:82px;top:214px;position:absolute;background:transparent url('images/mask-2018-02-06.png') no-repeat;background-position: 0px 0px;}

        .mask1 {left:89px;top:387px}
        .mask2 {left:190px;top:252px}
        .mask3 {left:368px;top:460px}
        .mask4 {left:319px;top:156px}
        .mask5 {left:421px;top:278px}
        .mask6 {left:606px;top:360px}
        .mask7 {left:810px;top:473px}
        .mask8 {left:1078px;top:493px}
        .mask9 {left:469px;top:99px}
        .mask10 {left:596px;top:170px}
        .mask11 {left:765px;top:252px}
        .mask12 {left:936px;top:299px}
        .mask13 {left:1146px;top:350px}
        .mask14 {left:688px;top:64px}
        .mask15 {left:856px;top:133px}
        .mask16 {left:1067px;top:229px}
        .mask17 {left:910px;top:45px}
        .mask18 {left:1067px;top:111px}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-02-06.jpg') no-repeat;" onUnload="exit();">
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

            cursor.focusable[0] = {};
            cursor.focusable[0].focus = this.focused.length > 1 ? Number( this.focused[ 1] ) : 5;
            //action:上下左右
            cursor.focusable[0].items = [
                {name:'捉妖记2',linkto:'/EPG/jsp/neirong/STemplateOneRow.jsp?typeId=10000100000000090000000000109089',action:[1,2,0,4]},
                {name:'明星齐贺岁',linkto:'/EPG/jsp/neirong/STemplateSquarenePersonage.jsp?typeId=10000100000000090000000000109070&row=4&col=2&squarePos=71,72,162,143',action:[3,2,0,4]},
                {name:'贺岁大片一键开启',linkto:'/EPG/jsp/neirong/STemplateOneRow.jsp?typeId=10000100000000090000000000109047',action:[1,2,0,5]},
                {name:'寒假动画连连看',linkto:'/EPG/jsp/neirong/SRowTemplate.jsp?typeId=10000100000000090000000000109024',action:[3,4,1,8]},
                {name:'宝宝回来了',linkto:'/EPG/jsp/neirong/S20180209.jsp?typeId=10000100000000090000000000109067&fc=f12e00&bc=f12e00',action:[3,5,0,9]},
                {name:'2018春节联欢晚会',linkto:'http://192.168.17.42:8100/cq_coshipdemo/index.jsp?navPs=2',action:[4,6,2,10]},
                {name:'放下手机一起看剧',linkto:'/EPG/jsp/neirong/STemplateAllPicture.jsp?typeId=10000100000000090000000000109074',action:[5,7,2,11]},
                {name:'2018院线大片提前看',linkto:'/EPG/jsp/neirong/SRowTemplate.jsp?typeId=10000100000000090000000000109000',action:[6,7,6,12]},
                {name:'挑个角色陪你过年男友篇',linkto:'/EPG/jsp/neirong/STemplateAllPicture.jsp?typeId=10000100000000090000000000109046',action:[8,9,3,13]},
                {name:'挑个角色陪你过年女友篇',linkto:'/EPG/jsp/neirong/STemplateAllPicture.jsp?typeId=10000100000000090000000000109065',action:[8,10,4,14]},
                {name:'动漫就要中国STYLE',linkto:'/EPG/jsp/neirong/STemplateOneRow.jsp?typeId=10000100000000090000000000109071',action:[9,11,5,14]},
                {name:'2017哪些无法分辨真假的消息',linkto:'/EPG/jsp/neirong/STempOneColumnPlayLoop.jsp?typeId=10000100000000090000000000109022&ps=494,310,712,207&bp=506,115,130,FFFFFF&loop=0&pg=8&fc=FFFFFF&split=0&mk=56,45,FFFF,1&fcbr=1,FF0000&item=610,500,36,160,504,34,transparent,FFFFFF,18',action:[10,12,6,15]},
                {name:'谁是年度剧王',linkto:'/EPG/jsp/neirong/STemplateOneRow.jsp?typeId=10000100000000090000000000109045',action:[11,12,7,15]},
                {name:'春运回家安全路',linkto:'/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000109064&tp=160&fs=22&hm=1&w=452&mr=13&lt=728&ih=45&al=0&bc=fc0000&fc=ffffff&cl=ffffff&pg=8&sc=1194,151,488,8e0000,FFE400',action:[13,14,8,16]},
                {name:'红海行动',linkto:'/EPG/jsp/neirong/STemplateOneRow.jsp?typeId=10000100000000090000000000109088',action:[13,15,9,17]},
                {name:'春运那些事',linkto:'/EPG/jsp/neirong/STempOneColumnPlayLoop.jsp?typeId=10000100000000090000000000109044&ps=493,311,712,134&bp=506,115,170,ffffff&loop=0&pg=8&fc=ffffff&split=0&mk=56,45,ffffff,1&fcbr=1,FF0000&item=610,500,36,190,504,34,transparent,ffffff,18',action:[14,12,11,17]},
                {name:'胃,一起过年吧',linkto:'/EPG/jsp/neirong/STemplateOneTextColumn.jsp?typeId=10000100000000090000000000109072&tp=166&fs=22&hm=1&w=387&mr=9&lt=793&ih=45&al=0&bc=d72300&fc=ffffff&cl=6B2E27&pg=9&sc=1194,151,488,B38B00,FFE400',action:[16,17,13,17]},
                {name:'假期必看',linkto:'/EPG/jsp/neirong/SRowTemplate.jsp?typeId=10000100000000090000000000109021',action:[16,15,14,17]}
            ];
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var item = items[focus];
            var action = item.action;

            if( index == 11 ) focus = action[0];
            else if( index == -11) focus = action[1];
            else if( index == -1 ) focus = action[2];
            else focus = action[3];

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