<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
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
        .mask {position:absolute;background:transparent url('images/mask-2019-01-22.png') no-repeat;background-position: 0px 0px;}
        .item {position:absolute;}
        .item1 {width:560px;height:185px;left:69px;top:136px;overflow: hidden;}
        .item2 {width:560px;height:185px;left:652px;top:136px;overflow: hidden;}
        .item3 {width:360px;height:162px;left:69px;top:339px;overflow: hidden;}
        .item4 {width:360px;height:162px;left:456px;top:339px;overflow: hidden;}
        .item5 {width:360px;height:162px;left:843px;top:339px;overflow: hidden;}
        .item6 {width:135px;height:187px;left:71px;top:513px;overflow: hidden;}
        .item7 {width:135px;height:187px;left:240px;top:513px;overflow: hidden;}
        .item8 {width:135px;height:187px;left:407px;top:513px;overflow: hidden;}
        .item9 {width:135px;height:187px;left:571px;top:513px;overflow: hidden;}
        .item10 {width:135px;height:187px;left:743px;top:513px;overflow: hidden;}
        .item11 {width:135px;height:187px;left:909px;top:513px;overflow: hidden;}
        .item12 {width:135px;height:187px;left:1075px;top:513px;overflow: hidden;}

        .mask1 {width:584px;height:209px;left:57px;top:124px;background-position: 0px 0px;}
        .mask2 {width:584px;height:209px;left:641px;top:124px;background-position: 0px 0px;}
        .mask3 {width:384px;height:186px;left:57px;top:327px;background-position: -600px 0px;}
        .mask4 {width:384px;height:186px;left:444px;top:327px;background-position: -600px 0px;}
        .mask5 {width:384px;height:186px;left:830px;top:327px;background-position: -600px 0px;}
        .mask6 {width:156px;height:156px;left:60px;top:521px;background-position: -1000px 0px;}
        .mask7 {width:156px;height:156px;left:229px;top:521px;background-position: -1000px 0px;}
        .mask8 {width:156px;height:156px;left:396px;top:521px;background-position: -1000px 0px;}
        .mask9 {width:156px;height:156px;left:563px;top:521px;background-position: -1000px 0px;}
        .mask10 {width:156px;height:156px;left:732px;top:521px;background-position: -1000px 0px;}
        .mask11 {width:156px;height:156px;left:899px;top:521px;background-position: -1000px 0px;}
        .mask12 {width:156px;height:156px;left:1066px;top:521px;background-position: -1000px 0px;}
        
        .item img{width:100%;height:100%;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-01-22.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="item1" class="item item1"></div>
<div id="item2" class="item item2"></div>
<div id="item3" class="item item3"></div>
<div id="item4" class="item item4"></div>
<div id="item5" class="item item5"></div>
<div id="item6" class="item item6"></div>
<div id="item7" class="item item7"></div>
<div id="item8" class="item item8"></div>
<div id="item9" class="item item9"></div>
<div id="item10" class="item item10"></div>
<div id="item11" class="item item11"></div>
<div id="item12" class="item item12"></div>
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

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('showUI');
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 1 || index == -11 && focus >= 5 || index == -1 && (focus == 0 || focus == 2 || focus == 5)|| index == 1 && (focus == 1 || focus == 4 || focus + 1 >= items.length)) return;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else if(index == 11){
                if( focus <= 2 ) focus -= 2;
                else if( focus <= 4 ) focus -= 3;
                else if(focus <= 6 ) focus = 2;
                else if( focus <= 9 ) focus = 3;
                else focus = 4;
            } else {
                if( focus == 0 ) focus = 2;
                else if( focus == 1 ) focus = 4;
                else if( focus == 2 ) focus = 5;
                else if( focus == 3 ) focus = 7;
                else focus = 10;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        showUI        :   function(){
            var blocked = 0;
            var items = cursor.focusable[0].items;
            for( var i = 0; i < items.length ; i ++ ){
                var img = cursor.pictureUrl(items[i].posters, 12);
                $("item" + String(i + 1)).innerHTML = '<img src="' + img + '" />';
            }
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask mask" + ( focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>