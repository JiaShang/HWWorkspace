<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000112853";
    infos.add(new ColumnInfo(typeId, 0, 199));
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
        .mask {width:59px;height:437px;top:214px;position:absolute;background:transparent url('images/mask-2019-08-10.png') no-repeat;background-position: -700px 0px;}
        .after {width:1170px;height:600px;left:83px;top:174px;position:absolute; background-position: 0px 500px; }
        .item {width:286px;height:260px;overflow:hidden;float: left;position:relative}
        .focusItem,.imageBd {width:254px;height:140px;position:absolute;left:0px;top:0px;background-position: -400px 0px;}
        .imageBd {background-position: -700px 0px;}
        .image {width:244px;height:130px;position:absolute;left:6px;top:6px;overflow: hidden;}
        .image img {width:244px;height:130px;}

        .text{width:244px;height:30px;left:7px;top:145px;background-position:0px -500px;}
        .text .name{width:153px;height:30px;color:white;font-size:16px;line-height:30px;text-align: left;left:0px;top:0px;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;position:absolute}
        .text .vote{width:90px;height:30px;color:white;font-size:16px;line-height:30px;text-align: left;left:154px;top:0px;overflow: hidden;position:absolute}
        .text .vote span{}
        .focusVote{width:256px;height:51px;background-position:-700px -201px;left:0px;top:181px;}
        .voteBtn{width:256px;height:51px;background-position:-400px -200px;left:0px;top:181px;overflow:hidden;}

        .page {width:26px;height:26px;left:1220px;position:absolute;color:white;font-size:22px;overflow: hidden;text-align: center;line-height: 26px;overflow: hidden;}
        .number {top:571px; }
        .split {top:597px; height: 2px; background-color: white;}
        .count {top:598px;}

        .mask1{width:148px;height: 63px;left:1067px;top:92px;background-position: 0px -300px;}
        .tooltip{width: 1280px;height:720px;position:absolute;left:0px;top:0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-09-31-2.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="after" class="after"></div>
<div id="pageNum" class="page number">0</div><div class="page split"></div><div id="pageCount" class="page count">0</div>
<div id="tooltip" class="tooltip" style="visibility: hidden;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    /*
     关于投票弹框的ID，及对应的说明
     1. 投票活动暂未开始
     2. 抢票活动暂未开始
     3. 投票活动已结束
     4. 抢票活动已结束
     5. 投票次数已用完，请明日再来
     6. 抢票活动已结束，请明日再来
     7. 手机号码输入错误，请重新输入
     8. 投票成功.
     9. 抢票成功.
     10. 参与成功.敬请观注中奖名单
     */
    var initialize = {
        data        : [<%
            String html = "";
            for ( int i = 0; i < infos.size(); i++) {
                ColumnInfo info = infos.get(i);
                Result result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
                html += inner.resultToString(result);
                if( i + 1 < infos.size() ) html += ",\n";
            }
            out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>&isBack=true';
            cursor.voteId = 466;

            cursor.row = 2;
            cursor.column = 4;
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
            cursor.focusable[1] = {focus : 0 ,items:[ {name:'活动详情',linkto:'/EPG/jsp/neirong/S20190931Detail.jsp'}]};

            cursor.call('show');
            cursor.call("showVoteResult");
        },
        move        :   function(index){
            if( cursor.showTooltip ) return;
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
                    if( focus < 0 ) { blocked = 1; focus = 0 }
                } else if( index == -11 ){
                    if( focus + column >= items.length && Math.ceil( (focus + 1.0) / column) == Math.ceil( items.length * 1.0 / column)  )
                        return;
                    focus += column;
                    if( focus >= items.length ) focus = items.length - 1;
                }
            } else {
                blocked = 0; focus = cursor.focusable[0].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        showTooltip : function(id){
            $("tooltip").style.backgroundImage = 'url("images/focusBg-Vote-' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showTooltip = true;
        },
        select : function(){
            var blocked = cursor.blocked;
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            if( blocked == 0 ) {
                var now = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
                if( now <= "2019-10-01 00:00:00") return cursor.call('showTooltip',1);
                if( now > "2019-10-09 00:00:00" ) return cursor.call('showTooltip',3);
                var focus = cursor.focusable[blocked].focus;
                var items = cursor.focusable[blocked].items;
                cursor.focusName = items[focus].name;
                (function(target){
                    var item = items[focus];
                    cursor.call("sendVote",{
                        id:cursor.voteId,
                        target:item.name,
                        repeat:true,
                        limit:15,　　//总投票数限制
                        limitPer:15,//每个人投票限制
                        callback: function(result){
                            if(result.recode != '002' || result.result == false ){
                                cursor.call('showTooltip', 5);
                            } else {
                                cursor.call('showTooltip', 8); cursor.call("showVoteResult");
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
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,2,'images/defaultImg.png') + '"/></div>';
                html += '<div class="mask text" style="background-repeat: no-repeat"><div class="name" id="txt' + String(i + 1) + '">' + item.name + '</div><div class="vote" id="vote' + String(i + 1) + '"><span>' + String(item.voteCount || 0) +  '</span></div></div>';
                html += '<div class="mask imageBd" style="background-repeat: no-repeat"></div>';
                if( i == focus && blocked == cursor.blocked ) {
                    html += '<div class="mask focusVote"></div>';
                } else {
                    html += '<div class="mask voteBtn" style="background-repeat: no-repeat"></div>';
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