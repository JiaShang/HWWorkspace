<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000112068";
    infos.add(new ColumnInfo(typeId, 0, 199));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    int voteId = inner.getInteger("VOTEID",459);
    String body = "images/bg-2019-07-19.png";
    if( column != null ) body = inner.pictureUrl(body, column.getPosters(), "7",0 );
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2019-07-19.png') no-repeat;background-position: -700px 0px;}
        .after {width:1200px;height:600px;left:52px;top:193px;position:absolute; background-position: 0px 500px; }
        .item {width:236px;height:225px;overflow:hidden;float: left;position:relative}
        .focusItem,.imageBd {width:254px;height:156px;position:absolute;left:0px;top:0px;background-position: -400px 0px;}
        .imageBd {background-position: -700px 0px;}
        .image {width:219px;height:142px;position:absolute;left:5px;top:5px;overflow: hidden;}
        .image img {width:100%;height:100%;}

        .text{width:236px;height:30px;left:7px;top:146px;background-position:0px -500px;}
        .text .name{width:153px;height:30px;color:white;font-size:16px;line-height:30px;text-align: left;left:0px;top:0px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;position:absolute}
        .text .vote{width:90px;height:30px;color:white;font-size:16px;line-height:30px;text-align: left;left:154px;top:0px;overflow: hidden;position:absolute}
        .text .vote span{}
        .focusVote{width:220px;height:38px;background-position:-400px -220px;left:12px;top:172px;}
        .voteBtn{width:220px;height:38px;background-position:-400px -160px;left:12px;top:172px;overflow:hidden;}

        .page {width:23px;height:16px;left:1224px;position:absolute;color:white;font-size:14px;overflow: hidden;text-align: center;}
        .number {top:475px; border-bottom: 1px solid #ffffff;}
        .count {top:492px;}

        .mask1{width:166px;height:45px;left:1054px;top:144px;background-position: 0px 0px;}
        .tooltip{width: 1280px;height:720px;position:absolute;left:0px;top:0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('<%=body%>') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="after"></div>
<div id="pageNum" class="page number">0</div>
<div id="pageCount" class="page count">0</div>
<div id="tooltip" class="tooltip" style="visibility: hidden;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result).replaceAll("2019风云球王成年组-","");
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.voteId = <%= voteId %>;

            var now = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            var enable = '2019-07-24 12:00:00' <= now && now < "2019-07-29 23:59:59";
            debug("NOW: ", now);
            cursor.enabled = enable;
            cursor.row = 2;
            cursor.column = 5;
            cursor.pageCount = cursor.row * cursor.column;
            cursor.showTooltip = false;
            cursor.voteBtnFocused = false;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[1] = {
                focus : 0,
                items : [{'name':'投票规则'}]
            };
            cursor.call('show');
            cursor.call("showVoteResult");
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var row = cursor.row; var column = cursor.column;
            var pageCount = cursor.pageCount;
            if( blocked == 1 && index != -11 ) return;
            if( blocked == 0 ) {
                if( index == -1 ) {
                    if( focus % column == 0 ) {
                        if( /*focus % pageCount == 0 ||*/ focus - column - 1 < 0)  return;
                        focus -= column + 1;
                    } else focus -= 1;
                } else if( index == 1 ) {
                    if( focus % column == column - 1 ) {
                        if( Math.ceil( (focus + 1.0) / pageCount) * pageCount >= items.length ) return;
                        focus += column + 1;
                        if( focus >= items.length ) focus = items.length - 1;
                    } else if( focus + 1 >= items.length )
                        return;
                    else  focus += 1;
                } else if( index == 11 ) {
                    if( focus < column ) {
                        if( !cursor.enabled || cursor.enabled && !cursor.voteBtnFocused ) {
                            blocked = 1; focus = 0;
                        } else if ( cursor.enabled && cursor.voteBtnFocused ) {
                            cursor.voteBtnFocused = false;
                        }
                    } else {
                        if( !cursor.enabled || cursor.enabled && !cursor.voteBtnFocused ) {
                            focus -= column;
                            if(cursor.enabled && !cursor.voteBtnFocused) cursor.voteBtnFocused = true;
                        } else if( cursor.enabled && cursor.voteBtnFocused ) {
                            cursor.voteBtnFocused = false;
                        }
                    }
                } else if( index == -11 ){
                    if( focus + column >= items.length && Math.ceil( (focus + 1.0) / column) == Math.ceil( items.length * 1.0 / column)  )
                    {
                        if( !cursor.enabled || cursor.enabled && cursor.voteBtnFocused) {
                            return;
                        } else if(cursor.enabled && !cursor.voteBtnFocused)
                            cursor.voteBtnFocused = true;
                    } else {
                        if( !cursor.enabled || cursor.enabled && cursor.voteBtnFocused) {
                            focus += column;
                            if(cursor.enabled && cursor.voteBtnFocused) cursor.voteBtnFocused = false;
                        } else if( cursor.enabled && !cursor.voteBtnFocused) {
                            cursor.voteBtnFocused = true;
                        }
                    }
                    if( focus >= items.length ) focus = items.length - 1;
                }
            }  else {
                blocked = 0; focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        showTooltip : function(id){
            $("tooltip").style.backgroundImage = 'url("images/focusBg-2019-07-19-' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showTooltip = true;
        },
        select : function(){
            var blocked = cursor.blocked;
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            if( blocked == 1 ) return cursor.call('showTooltip', 4);

            if( blocked == 0 && cursor.voteBtnFocused ) {
                var focus = cursor.focusable[blocked].focus;
                var items = cursor.focusable[blocked].items;
                cursor.focusName = items[focus].name;
                (function(target){
                    var item = items[focus];
                    cursor.call("sendVote",{
                        id:cursor.voteId,
                        target:item.name,
                        repeat:true,
                        limit:10,　　//总投票数限制
                        limitPer:10,//每个人投票限制
                        callback: function(result){
                            if(result.recode != '002' || result.result == false ){
                                cursor.call('showTooltip', 2);
                            } else {
                                cursor.call('showTooltip', 3); cursor.call("showVoteResult");
                            }
                        }
                    });
                })();
                return;
            }
            cursor.call("selectAct");
        },
        goBack : function() {
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            cursor.call("goBackAct");
        },
        showVoteResult: function(){
            cursor.call("voteResult", {blocked : 0, callback: function(){
                cursor.focusable[0].items.sort(function (a, b) {
                    var a1 = a.voteCount || 0;
                    var b1 = b.voteCount || 0;
                    return b1 - a1;
                });
                if(typeof cursor.focusName != "undefined" ){
                    for( var i = 0 ; i < cursor.focusable[0].items.length; i ++) {
                        if( cursor.focusable[0].items[i].name != cursor.focusName ) continue;
                        cursor.focusable[0].focus = i;
                        break;
                    }
                }
                cursor.call("show");
            }});
        },
        show        :   function(){
            var blocked = cursor.blocked;

            if(blocked === 1) {
                $("mask").style.visibility = 'visible';
                $("mask").className = "mask mask1";
            } else {
                $("mask").style.visibility = 'hidden';
            }

            var html = '';

            blocked = 0;
            var pageCount = cursor.pageCount;
            var focus = cursor.focusable[blocked].focus;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[0].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '"/></div>';
                html += '<div class="mask text" style="background-repeat: no-repeat"><div class="name" id="txt' + String(i + 1) + '">' + item.name + '</div><div class="vote" id="vote' + String(i + 1) + '"><span>' + String((item.voteCount || 0) + 500) +  '</span></div></div>';
                if(cursor.enabled) html += '<div class="mask voteBtn" style="background-repeat: no-repeat"></div>';
                if( i == focus && blocked == cursor.blocked ) {
                    if( cursor.voteBtnFocused ) {
                        html += '<div class="mask focusVote"></div>';
                        html += '<div class="mask imageBd" style="background-repeat: no-repeat"></div>';
                    } else {
                        html += '<div class="mask focusItem"></div>';
                    }
                } else {
                    html += '<div class="mask imageBd" style="background-repeat: no-repeat"></div>';
                }
                html += '</div>';
            }
            html += '';
            $("after").innerHTML = html;
            if( blocked == 0 ) {
                $("pageNum").innerHTML = Math.ceil( ( focus + 1.0 ) / pageCount);
                $("pageCount").innerHTML = Math.ceil( ( items.length * 1.0 ) / pageCount);
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>