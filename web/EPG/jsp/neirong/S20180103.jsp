<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");

    //TODO: 此参数每次需要修改
    boolean isMultiColumns = true;

    //如果栏目ID为空
    if( ! isMultiColumns ){
        if( isEmpty(typeId) ) typeId = "10000100000000090000000000107189";
        ColumnInfo info = new ColumnInfo(typeId, 0, 10);
        infos.add(info);
    } else {
        typeId = "10000100000000090000000000107189";
        infos.add(new ColumnInfo("10000100000000090000000000108950", 0, 99));//卤味
        infos.add(new ColumnInfo("10000100000000090000000000108951", 0, 99));//火锅
        infos.add(new ColumnInfo("10000100000000090000000000108952", 0, 99));//小面
        infos.add(new ColumnInfo("10000100000000090000000000108953", 0, 99));//汤锅
        infos.add(new ColumnInfo("10000100000000090000000000108954", 0, 99));//江湖菜
        infos.add(new ColumnInfo("10000100000000090000000000108955", 0, 99));//毛血旺
        infos.add(new ColumnInfo("10000100000000090000000000108956", 0, 99));//豆花
        infos.add(new ColumnInfo("10000100000000090000000000108957", 0, 99));//抄手
        infos.add(new ColumnInfo("10000100000000090000000000108958", 0, 99));//烧鸡公
        infos.add(new ColumnInfo("10000100000000090000000000108959", 0, 99));//闷烧鸡
        infos.add(new ColumnInfo("10000100000000090000000000108960", 0, 99));//羊肉
        infos.add(new ColumnInfo("10000100000000090000000000108961", 0, 99));//烤鱼
        infos.add(new ColumnInfo("10000100000000090000000000108948", 0, 99));// 走进意大利
        infos.add(new ColumnInfo("10000100000000090000000000108949", 0, 99));// 冰与火的美食
    }
    //获取当前栏目的详细信息
    Column column = inner.getDetail(typeId, new Column());
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:115px;height:44px;position:absolute;background:transparent url('images/mask-2018-01-03.png') no-repeat;background-position: 0px 0px;}

        .mask11 {left:102px;top:185px;background-position:0px 0px;}
        .mask12 {left:771px;top:58px;background-position:0px -45px;}
        .mask13 {left:1102px;top:129px;background-position:0px -90px;}
        .mask14 {left:50px;top:285px;background-position:0px -135px;}
        .mask15 {left:655px;top:288px;background-position:0px -180px;}
        .mask16 {left:913px;top:361px;background-position:0px -225px;}
        .mask17 {left:184px;top:416px;background-position:0px -270px;}
        .mask18 {left:714px;top:447px;background-position:0px -315px;}
        .mask19 {left:1012px;top:476px;background-position:0px -360px;}
        .mask110 {left:24px;top:509px;background-position:0px -405px;}
        .mask111 {left:477px;top:618px;background-position:0px -450px;}
        .mask112 {left:899px;top:585px;background-position:0px -495px;}

        .mask21 {width:382px;height:64px;left:386px;top:336px;background-position: 0px -540px;}
        .mask22 {width:253px;height:64px;left:456px;top:383px;background-position: 0px -610px;}

        .flowed {}
        .layout {position:absolute;left:0px;top:0px;width:1280px;height:720px;}
        .layout1 {background: transparent url("images/focusBg-2018-01-03-1.png") no-repeat left top;}
        .layout2 {background: transparent url("images/focusBg-2018-01-03-2.png") no-repeat left top;}

        .layout1 .container {position:absolute;width:370px;height:480px;left:423px;top:129px;overflow: hidden;}
        .layout1 .container .item,.layout1 .container .itemFocus {width:370px;height:59px;float: left;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;font-size:20px;line-height: 52px; color:white;}
        .layout1 .container .itemFocus {color:#61c4f7;}
        .layout1 .container .itemFocus marquee {line-height: 52px;}

        .layout2 .container {position:absolute;width:284px;height:480px;left:461px;top:227px;overflow: hidden;}
        .layout2 .container .item,.layout2 .container .itemFocus {width:284px;height:83px;float: left;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;font-size:20px;line-height: 90px; color:white;}
        .layout2 .container .itemFocus {color:#61c4f7;}
        .layout2 .container .itemFocus marquee {line-height: 90px;font-size: 20px}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-01-03.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                html += inner.resultToString(new Result( typeId, infos)) + ",\n";
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
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                var ix = i + ( i == 0 ? 1 : 2);
                cursor.focusable[i].focus = this.focused.length > ix ? Number( this.focused[ ix] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable.insertAt(1,{focus : 0, items:[]});
            cursor.focusable[1].items.push(cursor.focusable[0].items[cursor.focusable[0].items.length - 2]);
            cursor.focusable[1].items.push(cursor.focusable[0].items[cursor.focusable[0].items.length - 1]);
            cursor.focusable[0].items.removeAt(cursor.focusable[0].items.length - 1);
            cursor.focusable[0].items.removeAt(cursor.focusable[0].items.length - 1);
            cursor.backUrl = "<%= backUrl%>";
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var pageCount = blocked >= cursor.focusable.length - 2 ? 8 : 5;

            if( blocked === 0 && (index == 11 && focus <= 2 || index == -11 && focus + 3 >= items.length || index == -1 && focus % 3 == 0 || index == 1 && focus % 3 == 2 ) ||
                ( blocked >= 2 ) && ( index == -1 && focus < pageCount || index === 1 && Math.ceil( focus / pageCount) >= Math.ceil(items.length / pageCount) || index == 11 && focus % pageCount == 0 || index == -11 && ( focus % pageCount >= pageCount - 1 || focus + 1 >= items.length))
            ) return;

            if( blocked === 0 ) {
                if( index == 1 || index == -1 ) {
                    if( index === 1 && focus == 6 || index === -1 && focus == 5 ){
                        blocked = 1; focus = cursor.focusable[blocked].focus;
                    } else
                        focus += index
                } else {
                    if( index === -11 && focus == 4 || index === 11 && focus == 7 ){
                        blocked = 1; focus = index === 11 ? 1 : 0;
                    } else
                        focus += index > 0 ? -3 : 3
                }
            } else if(blocked === 1){
                if( index === 11 ) {
                    if( focus == 0  ) {
                        blocked = 0; focus = 4;
                    } else focus = 0;
                } else if( index === -11 ){
                    if( focus == 1 ) {
                        blocked = 0; focus = 7;
                    } else focus = 1
                } else {
                    blocked = 0; focus = index === -1 ? 6 : 5;
                }
            } else {
                if( index === 1 || index === -1 ) {
                    focus += index * pageCount;
                    if( focus >= items.length ) focus = items.length - 1;
                } else focus += index > 0 ? -1 : 1;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked <= 1 ) {
                $("mask").className = "mask mask" + (blocked + 1) + "" + ( focus + 1);
                $("after").style.visibility = 'hidden';
                $("mask").style.visibility = 'visible';
                return;
            }

            var html = '';
            $("mask").style.visibility = 'hidden';
            $("after").className = "layout layout" + ( blocked >= cursor.focusable.length - 2 ? 1 : 2);
            $("after").style.visibility = 'visible';

            var pageCount = ( blocked >= cursor.focusable.length - 2 ? 8 : 5);

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            html = '<div class="container">';
            var items = cursor.focusable[blocked].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                if( i == focus ) {
                    var id = 'layout' + (blocked + '' + (i + 1)) ;
                    html += '<div class="itemFocus" id="' + id + '"></div>';
                    cursor.calcStringPixels(item.name, 20, function(pixelsWidth){
                        var o = cursor.focusable[cursor.blocked].items[focus];
                        var inner = pixelsWidth > ( cursor.blocked === 1 ? 370 : 350 ) ? ("<marquee>" + o.name + "</marquee>") : o.name ;
                        $(id).innerHTML = inner;
                    });
                } else {
                    html += '<div class="item">' + item.name + "</div>";
                }
            }
            html += '</div>';
            $("after").innerHTML = html;
        },
        onMoveUp    :   function(){cursor.call('move',11);},
        onMoveDown  :   function(){cursor.call('move',-11);},
        onMoveLeft  :   function(){cursor.call('move',-1);},
        onMoveRight :   function(){cursor.call('move',1);},
        select      :   function() {
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( blocked <= 1 ){
                cursor.blocked = 2 + focus +  ( blocked === 0 ? 0 :  cursor.focusable[0].items.length );
                cursor.call('show');
                return;
            }
            var typeId = cursor.focusable[blocked].typeId;
            var item = cursor.focusable[blocked].items[focus];
            var url = '';
            if( item.isSitcom === 0 ){
                url = cursor.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.id + "&contentType=0&startTime=0&business=1";
            } else {
                if( typeof item.linkto === 'string' ) {
                    var link = item.linkto;
                    if( ! link.startWith('http') ){
                        //url += cursor.current() + link;
                        url += link;
                    } else if( link.indexOf("wasu.cn/") > 0 ) {
                        //curr_url = "ui://portal1.htm?" + curr_url;
                        url = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + link;
                    } else {
                        url = link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        url += encodeURIComponent(top.window.location.href);
                    }
                } else {
                    var isKorean = <%= !isKorean %>;
                    var isWestern = <%= !isWestern %>;

                    var detailPage = 'vod/tv_detail.jsp';
                    if( isKorean ) detailPage = 'hjzq/hj_tvDetail.jsp';
                    else if( isWestern ) detailPage = 'western/eu_tvDetail.jsp';
                    url = cursor.current();
                    url += "/EPG/jsp/defaultHD/en/hddb/" + detailPage +  "?vodId=" + item.id + "&typeId=" + typeId;
                }
            }
            window.location.href = url;
        },
        goBack      :   function() {
            var blocked = cursor.blocked;
            if( blocked >= 2 ) {
                cursor.blocked = blocked >= cursor.focusable.length - 2 ? 1 : 0;
                cursor.call("show");
                return;
            }
            if(iPanel.eventFrame.systemId == 1 && <%= EPGflag %>) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }

            top.window.location.href = <%= EPGflag %> || cursor.backUrl.isEmpty() ? iPanel.eventFrame.portalUrl : cursor.backUrl;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>