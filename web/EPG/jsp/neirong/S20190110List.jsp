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
    int voteId = inner.getInteger("voteId");
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2019-01-10.png') no-repeat;background-position: 0px 0px;}
        .after {width:1180px;height:600px;left:65px;top:183px;position:absolute; background-position: 0px 500px; }
        .item {width:288px;height:246px;overflow:hidden;float: left;position:relative;}
        .bg {width:279px;height:190px;position:absolute;left:0px;top:0px;background:transparent url('images/mask-2019-01-10.png') no-repeat;background-position: 0px 0px;}
        .image {width:272px;height:153px;position:absolute;left:3px;top:3px;overflow: hidden;}
        .image img {width:272px;height:153px;}

        .text{width:272px;height:30px;left:3px;top:158px;background-position:0px -500px;}
        .text .name{width:272px;height:30px;color:black;font-size:18px;line-height:30px;text-align: left;left:0px;top:0px;overflow: hidden;position:absolute}

        .focusVote{width:105px;height:35px;background-position:0px -200px;left:0px;top:198px;}
        .voteBtn{width:105px;height:35px;background-position:-300px -200px;left:0px;top:198px;}
        .count {width:165px;height:35px;background-position:-105px -200px;left:105px;top:198px;}

        .tooltip{width: 720px;height:480px;position:absolute;left:280px;top:120px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-01-10.jpg') no-repeat;" onUnload="exit();">
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
            out.write(html.replaceAll("100秒看重庆·",""));
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.voteId = <%= voteId %>;
            cursor.enabled = (new Date()).Format("yyyy-MM-dd hh:mm:ss") < "2019-12-31 23:59:59";
            cursor.showTooltip = false;
            cursor.voteBtnFocused = false;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            /*for( var i = 0 ; i < cursor.focusable[0].items.length ; i ++ ) {
                var name = cursor.focusable[0].items[i].name;
                name = name.substr(name.indexOf('-') + 1);
                name = name.substr(0,name.indexOf("（"));
                cursor.focusable[0].items[i].name = name;
            }*/

            //cursor.focusable[1] = {focus : 0 ,items:[ {name:'活动详情',linkto:'/EPG/jsp/neirong/S20181112Role.jsp'}]};

            cursor.call('show');
            cursor.call("showVoteResult");
        },
        move        :   function(index){
            if( cursor.showTooltip ) return;
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = column * row;
            if( blocked == 1 && index != -11 ) return;
            cursor.enabled = true;
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
                    /*　注释的代码因为，此专题没有活动规则按钮　*/
                    /*if( focus % (row * column) < column && focus % column == 0 || focus < column ) {
                        if( !cursor.enabled || cursor.enabled && !cursor.voteBtnFocused ) {
                            blocked = 1; focus = 0;
                        } else if ( cursor.enabled && cursor.voteBtnFocused ) {
                            cursor.voteBtnFocused = false;
                        }
                    } else {*/
                        if( !cursor.enabled || cursor.enabled && !cursor.voteBtnFocused ) {
                            focus -= column;
                            if(cursor.enabled && !cursor.voteBtnFocused) cursor.voteBtnFocused = true;
                        } else if( cursor.enabled && cursor.voteBtnFocused ) {
                            cursor.voteBtnFocused = false;
                        }

                        if( focus < 0 ) return;
                    /*}*/
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
            $("tooltip").style.backgroundImage = 'url("images/focusBg-2019-01-10.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showTooltip = true;
        },
        select : function(){
            var blocked = cursor.blocked;
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            if( blocked == 0 && cursor.voteBtnFocused ) {
                if( ! cursor.enabled ) {
                    cursor.call('showTooltip', 2);return;
                }
                var focus = cursor.focusable[blocked].focus;
                var items = cursor.focusable[blocked].items;
                cursor.focusName = items[focus].name;
                (function(target){
                    var item = items[focus];
                    cursor.call("sendVote",{
                        id:cursor.voteId,
                        target:item.name,
                        repeat:true,
                        limit:5,　　//总投票数限制
                        limitPer:5,//每个人投票限制
                        callback: function(result){
                            if(result.recode != '002' || result.result == false ){
                                cursor.call('showTooltip', 2);
                            } else {
                                cursor.call("showVoteResult"); //cursor.call('showTooltip', 3);
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
                // 没有说要排序
                /*cursor.focusable[0].items.sort(function (a, b) {
                    var a1 = a.voteCount || 0;
                    var b1 = b.voteCount || 0;
                    return b1 - a1;
                });*/
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
                html += '<div class="item"><div class="bg" style="background-position:' + ( i == focus && blocked == cursor.blocked && !cursor.voteBtnFocused ? "-300px" : "0px") + ' 0px">';
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '"/></div>';
                html += '<div class="mask text" style="background-repeat: no-repeat"><div class="name" id="txt' + String(i + 1) + '">' + item.name + '</div></div></div>';
                if( i == focus && blocked == cursor.blocked && cursor.voteBtnFocused ) {
                    html += '<div class="mask voteBtn" style="background-repeat: no-repeat"></div>';
                } else {
                    html += '<div class="mask focusVote" style="background-repeat: no-repeat"></div>';
                }
                html += '<div class="mask count" style="text-align:right;font-size:20px;line-height:32px;">' + String(item.voteCount || 0) + '</div>';
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