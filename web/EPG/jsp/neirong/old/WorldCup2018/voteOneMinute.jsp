<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    //一分钟说世界杯，
    // 参数  voteId

    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109544";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    int voteId = inner.getInteger("voteId",420);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {width:526px;height:69px;top:551px;left:555px;position:absolute;background:transparent url('images/VoteOneMinuteMask.png') no-repeat 0px 0px;}
        .after {width:1188px;height:500px;left:52px;top:162px;position:absolute;overflow: hidden}
        .item {width:296px;height:243px;overflow: hidden;float:left;position:relative;}
        .container,.containerFocus {width:296px;height:210px;position:relative;left:0px;top:0px;background: transparent url("images/VoteOneMinuteMask.png") no-repeat 0px 0px;background-position: -400px 0px;z-index:0}
        .containerFocus {background-position: -1px -1px;z-index:99}
        .container .image,.containerFocus .image{width:270px;height:180px;position:absolute;left:13px;top:13px;overflow: hidden;}
        .container .image img,.containerFocus .image img {width:270px;height:180px;}
        .text,.textFocus{width:277px;height:39px;font-size:20px;line-height:35px;text-align:right;position:absolute;left:6px;top:196px;overflow: hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;color:white;padding:0px 15px 0px 0px; background: transparent url("images/VoteOneMinuteMask.png") no-repeat 0px -304px;z-index:0}
        .textFocus {background-position: 0px -250px;z-index: 99}
        .count {width:100px;height:20px;position:absolute;left:1110px;top:649px;font-size:20px;text-align: center;color:white;}
        .marqueed {width:346px;margin:0px 15px 0px 0px;}

        .maskVote {width:128px;height:32px;left:470px;top:523px;background-position:0px -350px;}


        .voteBg{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("../images/voteBg.png") no-repeat 0px 0px;}
        .voteBgTooltip{background-position:0px -400px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-size:22px;}
        .txtTooltip{position: absolute;width: 350px;height: 80px;left: 130px;top: 70px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}
        .voteSure{position:absolute;width:117px;height:42px;left:129px;top:179px;background: transparent url("../images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .voteCancel{position:absolute;width:116px;height:42px;left:342px;top:180px;background: transparent url("../images/voteBg.png") no-repeat;background-position: 0px -350px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/VoteOneMinute.jpg') no-repeat;" onUnload="exit();">
<div id="after" class="after"></div>
<div id="count" class="count"></div>
<div id='voteResultDialog' class='voteBg' style="visibility: hidden"></div>
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

            //-----------------------------------      投票功能        -----------------------------------------
            //是否显示投票提示框
            cursor.voteShowTootip = false;
            //投票ID
            cursor.voteId = <%= voteId %>;
            //投票焦点所在块
            cursor.voteBlocked = 1;
            //-------------------------------------------------------------------------------------------------


            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.rows = 2;
            cursor.columns = 4;
            cursor.voteFocused = false;
            cursor.pageSize = cursor.rows * cursor.columns;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.call('flowedShow');
            cursor.call('show');
            cursor.showVoteResult = function( results ){
                cursor.call("flowedShow", true );
            };
            cursor.call("voteResult",{callback:cursor.showVoteResult});
        },
        flowedShow : function(showResulted){
            var blocked = cursor.blocked;
            var pageCount = cursor.pageSize;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            var html = "";
            if( !showResulted ) {
                for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                    var item = items[i];
                    var id =  i + 1;
                    html += '<div class="item" id="item' + id +  '"><div id="container' + id + '" class="container">';
                    html += '<div class="image">';
                    html += "<img src='" + cursor.pictureUrl(item.posters,12) + "' />";
                    html += "</div></div><div class='text' id='text" + id +  "'>" +  (item.voteCount || 0) + "票</div></div>";
                }
                $("after").innerHTML = html;
                $("count").innerHTML = Math.ceil((focus  +  1.0) / pageCount) + " / " + Math.ceil(items.length  * 1.0 / pageCount);
            } else {
                for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                    var item = items[i];
                    var id =  i + 1;
                    $("text" + id).innerHTML = (item.voteCount || 0) + " 票";
                }
            }
        },
        //-----------------------------------      投票功能        -----------------------------------------
        hideVoteToolTip : function () {
            $("voteResultDialog").style.visibility = "hidden";
            cursor.voteShowTootip = false;
            if( cursor.voteShowInput ) cursor.call("showVoteInput");
        },
        showVoteTooltip : function(message){
            cursor.voteShowTootip = true;
            var html = "<div class='txtTooltip'>" + message + "</div>";
            $("voteResultDialog").innerHTML = html;
            $("voteResultDialog").className = "voteBg voteBgTooltip";
            $("voteResultDialog").style.visibility = "visible";
        },
        select:function(){
            var blocked = cursor.blocked;
            //如果显示了提示框，隐藏提示框
            if( cursor.voteShowTootip ){cursor.call("hideVoteToolTip"); return;}
            if(cursor.voteFocused === true) {
                if( ( new Date() ).Format("yyyy-MM-dd hh:mm:ss") >= '2018-06-20 00:00:00' ){
                    cursor.call("showVoteTooltip","投票活动已结束！"); return;
                }
                (function(item){
                    cursor.call("sendVote",{
                        limit:20,
                        limitPer:20,
                        target:item.name,
                        repeat:true,
                        callback: function(result){
                            if(result.recode != '002' || result.result == false ){
                                cursor.call("showVoteTooltip","您投票次数超出限制，您每天最多可投 20 票！");
                            } else {
                                cursor.call("voteResult",{callback:cursor.showVoteResult});
                                cursor.call("showVoteTooltip","您已投票成功！");
                            }
                        }
                    });
                })(cursor.focusable[0].items[cursor.focusable[0].focus]);
                return;
            }
            cursor.call("selectAct");
        },
        goBack:function(){
            if( cursor.voteShowTootip ) { cursor.call("hideVoteToolTip"); return; }
            cursor.call("goBackAct");
        },
        //------------------------------------------------------------------------------------------------
        move        :   function(index){

            //上 11，下 -11，左 -1，右 1
            //-----------------------------------      投票功能        -----------------------------------------
            if( cursor.voteShowTootip ) return;
            //------------------------------------------------------------------------------------------------

            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            var row = cursor.rows;
            var column =  cursor.columns;

            if( index == 11 && !cursor.voteFocused && focus < column || index == -11 && cursor.voteFocused && Math.ceil((focus + 1.0) / column) >= Math.ceil(items.length * 1.0 / column) || index == -1 && ( focus % column == 0 ) || index == 1 && ( focus % column == column - 1  || focus + 1 >= items.length )) return;

            var previous = focus;
            var voteFocused = cursor.voteFocused;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else {
                if( index == 11 ) {
                    if( ! cursor.voteFocused ) {
                        cursor.voteFocused = true;
                        focus -= column;
                    } else {
                        cursor.voteFocused = false;
                    }
                } else {
                    if( !cursor.voteFocused ) {
                        cursor.voteFocused = true;
                    } else {
                        cursor.voteFocused = false;
                        focus += column;
                    }
                }

                if( focus >= items.length ) focus = items.length - 1;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;

            if( Math.floor(focus * 1.0 / cursor.pageSize ) != Math.floor(previous * 1.0 / cursor.pageSize ))
                cursor.call('flowedShow');
            else {
                if ( voteFocused ) {
                    $("text" + (previous + 1)).className = "text";
                } else {
                    $("container" + (previous + 1)).className = "container";
                }
            }
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( cursor.voteFocused ) {
                $("text" + (focus + 1)).className = "textFocus";
            } else {
                $("container" + (focus + 1)).className = "containerFocus";
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>