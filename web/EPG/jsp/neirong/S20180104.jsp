<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId) ) typeId = "10000100000000090000000000108942";

    //TODO: 此参数每次需要修改
    boolean isMultiColumns = true;

    //如果栏目ID为空
    if( isMultiColumns ){
        ColumnInfo info = new ColumnInfo(typeId, 0, 6);
        infos.add(info);
    } else {
        infos.add(new ColumnInfo(typeId, 0, 12));
    }

    //获取当前栏目的详细信息
    Column column = inner.getDetail(typeId, new Column());
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2018-01-04.png') no-repeat;background-position: 0px 0px;}

        .mask1 {left:475px;background-position:0px 0px;}
        .mask2 {left:547px;background-position:-60px 0px;}
        .mask3 {left:627px;background-position:-120px 0px;}
        .mask4 {left:706px;background-position:-240px 0px;}
        .mask5 {left:779px;background-position:-180px 0px;}
        .mask6 {left:858px;background-position:-300px 0px;}

    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-01-04.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
</body>
<script language="javascript" type="text/javascript" defer="defer">
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
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.backUrl = "<%= backUrl%>";
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index == -11 || index == 11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length  )) return;
            focus += index ;

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask mask" + ( focus + 1);
            return;
        },
        onMoveUp    :   function(){cursor.call('move',11);},
        onMoveDown  :   function(){cursor.call('move',-11);},
        onMoveLeft  :   function(){cursor.call('move',-1);},
        onMoveRight :   function(){cursor.call('move',1);},
        select      :   function() {
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
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
                    var isKorean = <%= isKorean %>;
                    var isWestern = <%= isWestern %>;

                    var detailPage = 'vod/tv_detail.jsp';
                    if( isKorean ) detailPage = 'hjzq/hj_tvDetail.jsp';
                    else if( isWestern ) detailPage = 'western/eu_tvDetail.jsp';

                    url = cursor.current() + "/EPG/jsp/defaultHD/en/hddb/" + detailPage +  "?vodId=" + item.id + "&typeId=" + typeId;
                }
            }
            window.location.href = url;
        },
        goBack      :   function() {
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