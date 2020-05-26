<%@ page import="jxl.write.DateTime" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109643";

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/matchVibeBg.jpg",column.getPosters(),"12");
    Calendar calendar = Calendar.getInstance();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    Boolean enabled = true;//format.parse("2018-06-14 00:00:00").getTime() <= calendar.getTime().getTime() && calendar.getTime().getTime() <= format.parse("2018-07-16 00:00:00").getTime()
    if( enabled )
        picture = "images/matchVibeBg.jpg";
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>全民拼手气</title>
    <style>
        .realTimes {width: 30px;position: absolute;font-size: 24px;top: 407px;color: white;left: 388px;}
        .prizeList{left:762px;position:absolute;width:386px;height:300px;top:280px;}
        .item {height:40px;}
        .item div {float:left;height:40px;line-height: 40px; font-size:16px;color:white;overflow: hidden;}
        .item .phone {width:150px;text-align: left}
        .item .name {width:236px;text-align: center;}

        .mask {position:absolute;width:206px;height: 179px;background:url('images/matchVibeMask.png') no-repeat left top; background-position: 0px 0px;overflow:hidden;}
        .mask11 {width:295px;height:87px;left:790px;top:542px;background-position: -300px 0px;}

        .mask21 {left:281px;top:312px;}
        .mask31 {left:116px;top:176px;}
        .mask32 {left:281px;top:176px;}
        .mask33 {left:446px;top:176px;}
        .mask34 {left:446px;top:312px;}
        .mask35 {left:446px;top:448px;}
        .mask36 {left:281px;top:448px;}
        .mask37 {left:116px;top:448px;}
        .mask38 {left:116px;top:312px;}

        .voteBg{width:550px;height:350px;left:375px;top:199px;position:absolute;background:transparent url('images/QuizGuessingMask.png') no-repeat -570px 0px;background-position: -570px 0px;overflow:hidden;}
        .voteBgTooltip{width:550px;height:350px;left:375px;top:199px;position:absolute;background:transparent url('images/matchVibeMask.png') no-repeat -570px 0px; background-position:0px -200px;overflow:hidden;}
        .voteTooltipInput,.voteTooltip {width:350px;position:absolute;left:100px;top:70px;height:60px; text-align: center; font-size: 28px;line-height: 30px; color:#AE2C2C;overflow:hidden;}
        .phoneNumberInput{position:absolute; width:300px;height:26px; left:100px; top:148px; background-color:transparent;color:#5C5488;font-size:22px;overflow:hidden;}
        .voteTooltip {top:100px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:transparent url("<%=picture%>") no-repeat;' onUnload="exit();">
<div id="mask"></div>
<div class="prizeList" id="prizeList"></div>
<div class="realTimes" id="realTimes"></div>
<div id='voteResultDialog' style="visibility: hidden;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        focused     :   [<%= inner.getPreFoucs() %>],
        init:function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';
            cursor.realTimes = 0;
            var time = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            cursor.call("visitedRecord");
            cursor.enabled = <%= enabled %>;
            if( ! cursor.enabled ) return;

            //-----------------------------------      投票功能        -----------------------------------------
            //当前焦点是否在投票按钮上
            cursor.voteShowError = false;
            //当前是否显示投票输入框
            cursor.voteShowInput = false;
            //是否显示投票提示框
            cursor.voteShowTootip = false;
            //焦点是否在投票上
            cursor.voteShowDialog = false;
            //输入的手机号码
            cursor.phoneNumber = '' ;
            //投票焦点所在块
            cursor.voteBlocked = 1;
            //-------------------------------------------------------------------------------------------------

            if( cursor.enabled ) {
                cursor.call("queryCardNoAndPhone");
            }
            cursor.focusable[0] = {focus:0,items:[{"name":"我的奖品","linkto":"/EPG/jsp/neirong/WorldCup2018/PrizeBox.jsp"}]};
            cursor.focusable[1] = {focus:0,items:[{"name":"抽奖"}]};
            cursor.focusable[2] = {focus:0,items:[
                {"name":"现金2018","trophyId":1},
                {"name":"500元充值卡","trophyId":3},
                {"name":"200元充值卡","trophyId":5},
                {"name":"世界杯正版足球","trophyId":7},
                {"name":"聚体育1个月体验包","trophyId":9},
                {"name":"搜狐1个月体验包","trophyId":11},
                {"name":"暂未中奖","trophyId":15},
                {"name":"i12亲子社区1个月体验包","trophyId":13}
             ]};
            cursor.call("show");
        },
        queryCardNoAndPhone : function(){
            cursor.phoneNumber = iPanel.getGlobalVar("__WorldCupBindingPhone__");
            if( cursor.call("phoneValidate") ){
                var url = "http://192.168.89.23/worldCup/phone.do?cardNo=" + CA.card.serialNumber;
                //返回结果格式：{"cardNo":null,"phone":null}";
                ajax( url, function( result ){
                    if( result.phone != null )
                    {
                        iPanel.setGlobalVar("__WorldCupBindingPhone__",cursor.phoneNumber = result.phone);
                    }
                    cursor.call("QueryPrizeInfo");
                });
            } else {
                cursor.call("QueryPrizeInfo");
            }
        },
        QueryPrizeInfo : function(){
            var url = "http://192.168.89.23/worldCup/prizeInfo.do?cardNo=" + CA.card.serialNumber;
            if(typeof cursor.phoneNumber !== "undefined") url += '&phone=' + cursor.phoneNumber;
            var maskPhone = function(str){
                return str.substr(0,3) + "****" + str.substr(8);
            };
            ajax(url, function(result){
                result = result.data[0];
                cursor.realTimes = result.count;
                $("realTimes").innerHTML = cursor.realTimes;
                var items = result.items;
                items = items || [];
                var html = '';
                for( var i = 0; i < 6; i ++ ){
                    if( i >= items.length ) {
                        html += '<div class="item"><div class="phone">-</div><div class="name">-</div></div>';
                    } else {
                        var item = items[i];
                        html += '<div class="item"><div class="phone">' + maskPhone(item.phone) + '</div><div class="name">' + item.name + '</div></div>';
                    }
                }
                $("prizeList").innerHTML = html;
            })
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'全民拼手气',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("全民拼手气") + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },

        //-----------------------------------      投票功能        -----------------------------------------
        hideVoteToolTip : function () {
            $("voteResultDialog").style.visibility = "hidden";
            cursor.voteShowDialog = cursor.voteShowTootip = cursor.voteShowError = false;
        },
        showVoteTooltip : function(o){
            cursor.voteShowDialog = cursor.voteShowTootip = true;
            cursor.voteShowInput = false;
            cursor.voteShowError = o.isError == true;
            var html = "<div class='voteTooltip'>" + o.message + "</div>";
            $("voteResultDialog").innerHTML = html;
            $("voteResultDialog").className = "voteBgTooltip";
            $("voteResultDialog").style.visibility = "visible";
        },
        hideVoteInput : function () {
            $("voteResultDialog").style.visibility = "hidden";
            cursor.voteShowDialog = cursor.voteShowTootip  = cursor.voteShowInput = cursor.voteShowError = false;
        },
        showVoteInput : function(message){
            cursor.voteShowDialog = cursor.voteShowInput = true;
            cursor.voteShowTootip  = cursor.voteShowError = false;
            var html = "<div class='voteTooltipInput'>" + message + "</div>";
            html += "<div class='phoneNumberInput' id='phoneNumberInput'>请输入正确的手机号码</div>";
            cursor.phoneNumber = '';
            $("voteResultDialog").innerHTML = html;
            $("voteResultDialog").className = "voteBg";
            $("voteResultDialog").style.visibility = "visible";
        },
        input : function(ch){
            if( !cursor.voteShowInput || cursor.phoneNumber.length >= 11 ) return;
            cursor.phoneNumber += ch;
            $("phoneNumberInput").innerText = cursor.phoneNumber;
        },
        select:function(){
            if( !cursor.enabled ) {
                cursor.call("goBackAct"); return;
            }

            //如果显示了错误提示框，隐藏提示框
            if( cursor.voteShowError ){cursor.call("hideVoteToolTip"); return;}
            if( cursor.voteShowInput ) {
                //验证电话号码, 如果电话号码错误
                if( cursor.call("phoneValidate") ) {
                    //否则显示了电话号码输入框，则显示错误提示
                    cursor.phoneNumber = undefined;
                    cursor.call("showVoteTooltip",{ message : "手机号码输入错误！", isError : true }); return;
                }
                cursor.call("hideVoteInput");
                return;
            }

            var blocked = cursor.blocked;
            if( blocked == 2 ) return;
            if( blocked == 0 ) {
                cursor.call("selectAct"); return;
            }
            if(blocked === 1 && cursor.realTimes == 0 ) {
                cursor.call("showVoteTooltip",{ message : "您今天的抽奖次数已用完", isError : true });
                return;
            }
            if(cursor.call("phoneValidate")) {
                cursor.call("showVoteInput","抽奖活动需设置手机号码");
                return;
            }

            var prized = -1;
            var prize = function(){
                var url = "http://192.168.89.23/worldCup/prize.do?cardNo=" + CA.card.serialNumber;
                if(typeof cursor.phoneNumber !== "undefined") url += '&phone=' + cursor.phoneNumber;
                ajax(url, function(result){
                    prized = result.trophyId;
                })
            };
            setTimeout(function(){prize();},200);

            var index = 0; var loopTimes = Math.random() * 100 % 5 + 8;
            var counter = 0;
            var items = cursor.focusable[2].items;
            var loopPrize = function(){
                if( index > 7 ) index = 0;
                $("mask").className = "mask mask3" + (index + 1);
                if( counter > loopTimes ){
                    if( items[index].trophyId == prized ) {
                        if( timer ) clearTimeout( timer);
                        $("realTimes").innerHTML = cursor.realTimes = 0;
                        var message = "";
                        if( items[index].name == '暂未中奖' ) {
                            message = "暂未中奖 明天继续加油";
                        } else {
                            message = "您已抽中 " + items[index].name;
                        }
                        cursor.call("showVoteTooltip",{ message : message, isError : true });
                        return;
                    }
                }
                index += 1;
                counter += 1;
                timer = setTimeout(function(){loopPrize();},50);
            };
            var timer = setTimeout(function(){loopPrize();},50);
        },
        goBack:function(){
            if( cursor.enabled ){
                var blocked = cursor.blocked;
                if( cursor.voteShowTootip ) { cursor.call("hideVoteToolTip"); return false; }
                if( cursor.voteShowInput ){
                    if ( cursor.phoneNumber.length <= 0 ){ cursor.call("hideVoteInput"); return false;}
                    $("phoneNumberInput").innerText = cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
                    return false;
                }
            }
            cursor.call("goBackAct");
        },
        //------------------------------------------------------------------------------------------------
        move        :   function(index){
            if( ! cursor.enabled ) {
                return;
            }

            //-----------------------------------      投票功能        -----------------------------------------
            if( cursor.voteShowDialog ) return;
            //------------------------------------------------------------------------------------------------

            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked == 0 && index != -1 || blocked >= 1 && index != 1  ) return;
            if( blocked ==  0 ) {
                blocked = 1; focus = 0;
            } else {
                blocked = 0; focus = 0;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( previous == 1 && blocked == 0 ) cursor.call("showGuessing");
            cursor.call('show');
        },
        show:function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").className = "mask " + "mask" + String(blocked + 1) + String( focus + 1);
        }
    });
    -->
</script>
</html>