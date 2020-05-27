<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000113246";
    infos.add(new ColumnInfo(typeId, 0, 199));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2019-11-25.jpg" : inner.pictureUrl("images/bg-2019-11-25.jpg",column.getPosters(),"7");
%>
<html>
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2019-11-25.png') no-repeat;background-position: -700px 0px;}
        .after {width:1180px;height:540px;left:69px;top:141px;position:absolute;}
        .item {width:391px;height:268px;overflow:hidden;float: left;position:relative}
        .image {width:360px;height:210px;position:absolute;left:0px;top:0px;overflow: hidden;}
        .image img {width:360px;height:210px;}

        .text{width:360px;height:42px;left:0px;top:213px;background-position:0px -350px;}
        .text .vote{width:90px;height:42px;color:white;font-size:18px;line-height:40px;text-align: right;left:0px;top:0px;overflow: hidden;position:absolute}
        .text .vote span{}

        .page {width:26px;height:26px;left:1217px;position:absolute;color:white;font-size:22px;overflow: hidden;text-align: center;line-height: 26px;overflow: hidden;}
        .number {top:600px;color:#fff961; }
        .count {top:631px;}
        .range {width:53px;height:37px;left:12px;top:12px;}
        .rang1 {background-position:0px -470px;}
        .rang2 {background-position:-100px -470px;}
        .rang3 {background-position:-200px -470px;}

        .mask1{width:149px;height: 52px;left:1069px;top:54px;background-position: 0px -400px;}

        .maskBtn {width:376px;height:52px;background-position:0px -250px;}
        .maskImg {width:376px;height:226px;background-position:0px 0px;}

        .image1{left:61px;top:133px;}
        .image2{left:452px;top:133px;}
        .image3{left:843px;top:133px;}
        .image4{left:61px;top:401px;}
        .image5{left:452px;top:401px;}
        .image6{left:843px;top:401px;}
        
        .button1{left:61px;top:348px;}
        .button2{left:452px;top:348px;}
        .button3{left:843px;top:348px;}
        .button4{left:61px;top:616px;}
        .button5{left:452px;top:616px;}
        .button6{left:843px;top:616px;}

        .tooltip{width: 1280px;height:720px;position:absolute;left:0px;top:0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('<%= picture %>') no-repeat;" onUnload="exit();">
<div id="after" class="after"></div>
<div id="pageNum" class="page number">0</div><div id="pageCount" class="page count">0</div>
<div id="mask"></div>
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
            cursor.backUrl='<%= backUrl %>';
            cursor.voteId = 469;

            cursor.row = 2;
            cursor.column = 3;
            cursor.pageCount = cursor.row * cursor.column;
            cursor.showTooltip = false;
            cursor.voteBtnFocused = false;
            cursor.enabled = true;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            for( var i = 0; i < cursor.focusable[0].items.length; i ++){
                cursor.focusable[0].items[i].linkto = '/EPG/jsp/neirong/S20191125Pics.jsp?direct=1&typeId=' + cursor.focusable[0].items[i].id;
                cursor.focusable[0].items[i].voteCount = 0;
            }
            cursor.focusable[1] = {focus : 0 ,items:[ {name:'活动详情',linkto:'/EPG/jsp/neirong/S20191125Role.jsp'}]};

            setTimeout(function(){cursor.call("showVoteResult")},100);
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
                        if( focus % pageCount == 0 || focus - column - 1 < 0)  return;
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
            $("tooltip").style.backgroundImage = 'url("images/focusBg-Vote-' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showTooltip = true;
        },
        select : function(){
            var blocked = cursor.blocked;
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            if( blocked == 0 && cursor.voteBtnFocused ) {
                var now = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
                if( now <= "2019-11-25 16:00:00") return cursor.call('showTooltip',1);
                if( now > "2019-11-29 16:00:00" ) return cursor.call('showTooltip',3);
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
                for( var i = 0; i < cursor.focusable[0].items.length; i ++ ){
                    cursor.focusable[0].items[i].voteCount = (cursor.focusable[0].items[i].voteCount || 0 );
                }
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
            var html = '';
            var blocked = 0;
            var focus = cursor.focusable[blocked].focus;
            var pageCount = cursor.pageCount;

            if(cursor.blocked === 1) {
                $("mask").className = "mask mask1";
            } else {
                $("mask").className = "mask " + ( cursor.voteBtnFocused ? 'maskBtn button' : 'maskImg image' ) + String( focus % pageCount + 1 );
            }
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[0].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="image"><img src="' + cursor.pictureUrl(item.posters,1,'images/defaultImg.png') + '"/></div>';
                if( i <= 2 ) html += '<div class="mask range rang' + String( i + 1) + '"></div>';
                html += '<div class="mask text" style="background-repeat: no-repeat"><div class="vote" id="vote' + String(i + 1) + '"><span>' + String( ( item.voteCount || 0 ) + 500 ) +  '</span></div></div>';
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