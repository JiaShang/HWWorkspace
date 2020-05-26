<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<html>
<head>
    <title></title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {width:96px;height:93px;position:absolute;background:transparent url('images/focusBg-2019-04-02-dragon.png') no-repeat;background-position: 0px 0px;}
        .dragon1 {left:62px;top:14px;}
        .dragon2 {left:135px;top:91px;}
        .dragon3 {left:299px;top:286px;}
        .dragon4 {left:491px;top:305px;}
        .dragon5 {left:541px;top:165px;}
        .dragon6 {left:847px;top:148px;}
        .dragon7 {left:1077px;top:244px;}

        .phoneNumberInput {position: absolute;width: 250px;height: 40px;left: 110px;top: 125px;background-color: transparent;color: #D27700;font-size: 28px;line-height: 40px;letter-spacing:4px; }
        .tooltip{width:436px;height:280px;position:absolute;left:422px;top:240px;background-position: center center;}
        .vote{width:486px;height:330px;position:absolute;left:397px;top:215px; background: transparent url("images/focusBg-2019-04-02-inputBg.png") no-repeat center center;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-04-02.jpg') no-repeat;" onUnload="exit();">
<div id="dragon"></div>
<div id="vote" class="vote" style="visibility: hidden"><div class="phoneNumberInput" id="phoneNumberInput"></div></div>
<div id="tooltip"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        focused     :   [],
        init        :   function(){
            cursor.backUrl='<%= backUrl %>';

            var current = (new Date()).Format("yyyy-MM-dd");
            if(  current < '2019-04-08' || current >= '2019-04-15') {
                cursor.enabled = false;
                cursor.index = current < '2019-04-08' ? 0 : 1;
            } else {
                cursor.enabled = true;
                cursor.days = (Date.parse( current + 'T00:00:00-06:00' ) - Date.parse( '2019-04-08T00:00:00-06:00' ) ) / (24*3600*1000);
            }

            //是否显示投票提示框
            cursor.voteShowTootip = false;
            //是否显示输入框
            cursor.voteShowInput = false;
            //输入的手机号码
            cursor.phoneNumber = '' ;
            cursor.call('show');
        },
        //-----------------------------------      投票功能        -----------------------------------------
        /**
         * index 定义
         * 0: 还未开始，
         * 1: 已结束
         * 2: 电话号码错误
         * 3: 重复投票
         * 4: 投票成功
         * @param index
         */
        showVoteTooltip : function(){
            cursor.voteShowTootip = true;
            $("tooltip").className = "tooltip";
            var pic = '';
            switch (cursor.index){
                case 0: pic = 'beginErr'; break;
                case 1: pic = 'endErr'; break;
                case 2: pic = 'phoneErr'; break;
                case 3: pic = 'replayErr'; break;
                case 4: pic = 'successBg'; break;
                default: pic = 'endErr'; break;
            }
            $("tooltip").style.backgroundImage = 'url("images/focusBg-2019-04-02-' + pic + '.png")';
            $("tooltip").style.visibility = "visible";
        },
        hideVoteToolTip : function () {
            $("tooltip").style.visibility = "hidden";
            cursor.voteShowTootip = false;
        },
        showInputDialog: function(){
            cursor.voteShowInput = true;
            $("vote").style.visibility = 'visible';
            $("phoneNumberInput").innerText = cursor.phoneNumber = '';
        },
        hideInputDialog: function(){
            cursor.voteShowInput = false;
            $("vote").style.visibility = 'hidden';
            cursor.index = -1;
        },
        input : function(ch){
            if( ! cursor.enabled ||  ! cursor.voteShowInput || cursor.phoneNumber.length >= 11 ) return;
            cursor.phoneNumber += ch;
            $("phoneNumberInput").innerText = cursor.phoneNumber;
        },
        deletePhoneNumber : function(ch){
            if( ! cursor.enabled ||  ! cursor.voteShowInput || cursor.phoneNumber.length <= 0 ) return;
            cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
            $("phoneNumberInput").innerText = cursor.phoneNumber;
        },
        select:function(){
            //如果显示了提示框，隐藏提示框
            if( ! cursor.enabled ) return cursor.call('goBackAct');
            if( cursor.voteShowTootip ) {
                cursor.call("hideVoteToolTip");
                if( cursor.index == 3 || cursor.index == 4 ) cursor.call('hideInputDialog');
                return;
            }            if( ! cursor.voteShowInput ) return cursor.call("showInputDialog");
            if( cursor.phoneNumber.length == 0 ) return;
            //"手机号码输入错误, 请重新正确输入！"
            if( cursor.call("phoneValidate") ) {
                cursor.index = 2; return cursor.call("showVoteTooltip");
            }
            cursor.call("sendVote",{
                id:446,
                target:'签到',repeat:true,limit:1,limitPer:1,
                callback: function(result){
                    cursor.voteShowInput = false;
                    if(result.recode != '002' || result.result == false ){
                        //"您已参与过活动，不能重复参与！"
                        cursor.index = 3;
                        cursor.call("showVoteTooltip");
                    } else {
                        //"感谢您参与抢票<br/><br/>请保持手机通畅 抢票成功后客户将与您联系"
                        cursor.index = 4;
                        cursor.call("showVoteTooltip");
                    }
                }
            });
        },
        goBack:function(){
            if( ! cursor.enabled ) return cursor.call('goBackAct');
            if( cursor.voteShowTootip ) {
                cursor.call("hideVoteToolTip");
                if( cursor.index == 3 || cursor.index == 4 ) cursor.call('hideInputDialog');
                return;
            }
            if( cursor.voteShowInput ) {
                if( cursor.phoneNumber.length >= 1 ) return cursor.call("deletePhoneNumber");
                return cursor.call("hideInputDialog");
            }
            cursor.call('goBackAct');
        },
        move        :   function(index){
            return;
        },
        show        :   function(){
            if( ! cursor.enabled ) { cursor.call("showVoteTooltip"); return;}
            if( typeof cursor.days != 'undefined' ) { $("dragon").className = "mask dragon" + String( cursor.days + 1); }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>