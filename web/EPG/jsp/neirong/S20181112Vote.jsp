<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109320";
    infos.add(new ColumnInfo(typeId, 0, 99));
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
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2018-11-12-Vote.png') no-repeat;background-position: 0px 0px;}
        .after {width:1130px;height:600px;left:91px;top:198px;position:absolute; background-position: 0px 500px; }
        .item {width:280px;height:246px;overflow:hidden;float: left;position:relative}
        .focusItem {width:279px;height:169px;position:absolute;left:0px;top:0px;background-position: 0 -50px;}
        .image {width:251px;height:141px;position:absolute;left:14px;top:13px;overflow: hidden;}
        .image img {width:251px;height:141px;}

        .text{width:252px;height:30px;left:14px;top:154px;background-position:0px -500px;}
        .text .name{width:170px;height:30px;color:white;font-size:18px;line-height:30px;text-align: left;left:0px;top:0px;overflow: hidden;position:absolute}
        .text .vote{width:80px;height:30px;color:white;font-size:18px;line-height:30px;text-align: right;left:170px;top:0px;overflow: hidden;position:absolute}

        .focusVote{width:280px;height:63px;background-position:-3px -299px;left:0px;top:178px;}
        .voteBtn{width:280px;height:63px;background-position:-3px -392px;left:0px;top:178px;overflow:hidden;}

        .mask1{width:130px;height: 41px;left:86px;top:133px;background-position: 0px 0px;}
        .tooltip{width: 1280px;height:720px;position:absolute;left:0px;top:0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-11-12-Vote.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="after"></div>
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
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.voteId = 435;
            cursor.enabled = (new Date()).Format("yyyy-MM-dd hh:mm:ss") < "2018-12-19 23:59:59";
            cursor.showTooltip = false;
            cursor.voteBtnFocused = false;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            for( var i = 0 ; i < cursor.focusable[0].items.length ; i ++ ) {
                var name = cursor.focusable[0].items[i].name;
                name = name.substr(name.indexOf('-') + 1);
                name = name.substr(0,name.indexOf("（"));
                cursor.focusable[0].items[i].name = name;
            }

            cursor.focusable[1] = {focus : 0 ,items:[ {name:'活动详情',linkto:'/EPG/jsp/neirong/S20181112Role.jsp'}]};

            cursor.call('show');
            cursor.call("showVoteResult");
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = column * row;
            if( blocked == 1 && index != -11 ) return;
            if( blocked == 0 ) {
                var row = 2;var column = 4;
                if( index == -1 ) {
                    if( focus % column == 0 ) {
                        if( focus <= column ) return;
                        focus -= column + 1;
                    } else focus -= 1;
                } else if( index == 1 ) {
                    if( focus % column == column - 1 ) {
                        if( Math.ceil(focus + 1.0 / pageCount) * pageCount >= items.length ) return;
                        focus += column + 1;
                        if( focus >= items.length ) focus = items.length - 1;
                    } else if( focus + 1 >= items.length )
                        return;
                    else  focus += 1;
                } else if( index == 11 ) {
                    if( focus % (row * column) < column && focus % column == 0 || focus < column ) {
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
            $("tooltip").style.backgroundImage = 'url("images/focusBg-2018-09-27-' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showTooltip = true;
        },
        select : function(){
            var blocked = cursor.blocked;
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
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
            var pageCount = 8;
            var focus = cursor.focusable[blocked].focus;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[0].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '"/></div>';
                html += '<div class="mask text" style="background-repeat: no-repeat"><div class="name" id="txt' + String(i + 1) + '">' + item.name + '</div><div class="vote" id="vote' + String(i + 1) + '">' + String(item.voteCount || 0) +  '</div></div>';
                if(cursor.enabled)html += '<div class="mask voteBtn" style="background-repeat: no-repeat"></div>';
                if( i == focus && blocked == cursor.blocked ) {
                    html += '<div class="mask ' + ( cursor.voteBtnFocused ? 'focusVote': 'focusItem' )  + '"></div>';
                }
                html += '</div>';
            }
            html += '';
            $("after").innerHTML = html;
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>