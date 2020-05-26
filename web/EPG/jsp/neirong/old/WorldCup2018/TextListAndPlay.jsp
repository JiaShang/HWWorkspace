<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //赛场内外 & 精彩集锦

    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109544";
    infos.add(new ColumnInfo(typeId, 0, 99));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);

    //kd 为空时，为赛场内外，否则为精彩集锦。
    String kd = inner.get("kd");
    if( isEmpty(kd) ) kd = "1";
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:476px;height:65px;top:551px;left:140px;position:absolute;background:transparent url('images/TextListAndPlayMask.png') no-repeat;background-position: 0px -100px;}
        .bgTop {width:1280px;height:294px;position:absolute;left:0px;top:0px;background: transparent url("images/TextListAndPlayTop.jpg") no-repeat left top; overflow: hidden;}
        .bgLeft {width:637px;height:300px;position:absolute;left:0px;top:294px;background: transparent url("images/TextListAndPlayLeft.jpg") no-repeat left top; overflow: hidden;}
        .bgRight {width:104px;height:300px;position:absolute;left:1176px;top:294px;background: transparent url("images/TextListAndPlayRight.jpg") no-repeat left top; overflow: hidden;}
        .bgBottom {width:1280px;height:126px;position:absolute;left:0px;top:594px;background: transparent url("images/TextListAndPlayBottom.jpg") no-repeat left top; overflow: hidden;}

        .title {width:120px;height:30px;left:76px;top:116px;position:absolute;overflow: hidden; background: url('images/TextListAndPlayMask.png') no-repeat;background-position: 0px 0px; }
        .title1 {background-position: 0px 0px;}
        .title2 {background-position: 0px -50px;}
        .title3 {background-position: -200px 0px;}

        .after {width:450px;height:348px;left:150px;top:276px;position:absolute;overflow: hidden}
        .item,.itemFocus {width:439px;height:57px;line-height: 47px;font-size:20px;color:white;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .itemFocus {color:#C8B133;}
        .marqueed {width:439px;color:#C8B133;line-height: 47px;}
        .page,.count {width:29px;height:20px;position:absolute;left:88px;top:328px;font-size:16px;text-align: center;color:black;}
        .count {top:350px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('../images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:1920px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div class="bgTop"></div><div class="bgLeft"></div><div class="bgRight"></div><div class="bgBottom"></div>
<div class="title title<%=kd%>"></div>
<div id="mask" class="mask"></div>
<div id="after" class="after"></div>
<div id="page" class="page"></div>
<div id="count" class="count"></div>
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
            cursor.pageSize = 6;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('flowedShow');
            cursor.call("visitedRecord");
            cursor.call('show');
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'<%=column == null ? "" : column.getName()%>',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent('<%=column == null ? "" : column.getName()%>') + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },
        flowedShow : function(){
            var blocked = cursor.blocked;
            var pageCount = cursor.pageSize;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            var html = "";
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id = "item" + ( i + 1);
                html += '<div class="item" id="' + id +  '">' + item.name + "</div>";
            }
            $("after").innerHTML = html;

            $("page").innerHTML = Math.ceil((focus  +  1.0) / pageCount);
            $("count").innerHTML = Math.ceil(items.length  * 1.0 / pageCount);

        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length ) return;
            if( index == 1 || index == -1 ) {
                return;
            }
            var previous = focus;
            focus += index > 0 ? -1 : 1;
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( Math.floor(focus * 1.0 / cursor.pageSize ) != Math.floor(previous * 1.0 / cursor.pageSize ))
                cursor.call('flowedShow');
            else {
                $("item" + (previous + 1)).className = "item";
                $("item" + (previous + 1)).innerHTML = items[previous].name;
            }
            cursor.call('show');
        },
        playMovie   :   function(item){
            if( typeof item === 'undefined' )return;
            try{
                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?";
                if(typeof item.parentId === 'undefined'){       //播放电影
                    rtspUrl += "playType=1&progId=" + item.id + "&contentType=0&business=1&baseFlag=0&startTime=0"
                } else { //播放电视剧
                    rtspUrl += "playType=11&typeId=-1&parentVodId=" + item.parentId + "&progId=" + item.id + "&baseFlag=0&contentType=0&business=1&startTime=0";
                }

                ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        var rtsp = result.playUrl.split("^")[4];
                        media.video.setPosition(637,294,539,300);
                        media.AV.open(rtsp,"VOD");
                    }
                });
            } catch (e){ alert(e); }
        },
        nextVideo   :   function () {
            cursor.call("move",-11);
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").style.top = (268 + focus % cursor.pageSize * 57) + "px";
            $("item" + (focus + 1)).className = "itemFocus";

            if( cursor.scrollTimer ) clearTimeout( cursor.scrollTimer );
            cursor.scrollTimer = setTimeout(function(){
                var item = cursor.focusable[blocked].items[focus];
                cursor.calcStringPixels( item.name,20, function(width){
                    if(width < 439) return;
                    $("item" + (focus + 1)).innerHTML = '<marquee class="marqueed" scrollamount="8">' + item.name + "</marquee>";
                });
                cursor.call("playMovie",item);
            }, 1000);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>