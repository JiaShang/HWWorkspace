<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //竞猜规则
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109642";

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("images/QuizGuessingTooltip.jpg",column.getPosters(),"12");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>竞猜享好礼</title>
    <style>
        .mask{width:295px;height:87px;left:607px;top:563px;position:absolute;overflow: hidden;background:transparent url('images/QuizGuessingMask.png') no-repeat 0px 0px;}
        .arrowDown {width:42px;height:27px;left:308px;top:649px;background:transparent url('images/QuizGuessingMask.png') no-repeat;position:absolute;background-position:-300px 0px;}
        .mask1 {left:607px;background-position:0px 0px;}
        .mask2 {left:898px;background-position:0px -100px;}

        .guessContainer {width:468px;height:475px;position:absolute;left:97px;top:187px;overflow: hidden;}
        .guessItemContainer {width:468px;height:158px;position: relative;}
        .guessItemBody{width:468px;height:136px;left:0px;top:0px;position:relative;background:transparent url('images/QuizGuessingMask.png') no-repeat -580px -720px; }

        .choiceTable {width:376px;height:39px;left:58px;top:90px;position:absolute;}
        .choiceItemContainer {width:125px;height:39px;float:left;}

        .team {width:100px;height:55px;position:absolute;top:20px}
        .team1 {left:70px}
        .team2 {left:320px}
        .team .flag{ width:87px; height:30px;text-align: center;}
        .team .flag img {width:34px;height:24px;}
        .team .name{ width:87px;color:white;font-size: 14px;line-height: 25px;height:25px;text-align: center;}

        .time {width:171px;height:35px;position:absolute;top:17px;left:147px;line-height: 35px;color:white;font-size: 16px;text-align: center;overflow: hidden;}
        .choiceItem,.choiceItemFocus,.choiceItemSelected{width:113px;height:39px;font-size:13px;line-height:35px;color:white; text-align: center;background:transparent url('images/QuizGuessingMask.png') no-repeat -830px -890px; }
        .choiceItem {background-position: -830px -890px;}
        .choiceItemFocus {background-position: -703px -890px;color:#414679;}
        .choiceItemSelected {background-position: -585px -890px;}

        .guessRankingRole {width:564px;height:374px;left:618px;top:188px;background-position:0px -600px;}
        .guessRankingList {width:564px;height:374px;left:618px;top:188px;background-position:0px -200px;}

        .ranking{width: 200px;height: 300px;position: absolute;top: 80px;left: 80px;overflow: hidden;}
        .rankItem {width: 200px; height: 40px;line-height: 40px; font-size: 18px; color: white;}
        .ranking div{float:left;}
        .ranking .phone {width:150px;}
        .ranking .ticket {width:50px;}
        .voteBg{width:550px;height:350px;left:375px;top:199px;position:absolute;background:transparent url('images/QuizGuessingMask.png') no-repeat -570px 0px;;overflow:hidden;}
        .voteBgTooltip{background-position:-571px -361px;}
        .voteTooltipInput,.voteTooltip {width:350px;position:absolute;left:100px;top:70px;height:60px; text-align: center; font-size: 28px;line-height: 30px; color:#AE2C2C;overflow:hidden;}
        .phoneNumberInput{position:absolute; width:300px;height:26px; left:100px; top:148px; background-color:transparent;color:#5C5488;font-size:22px;;overflow:hidden;}
        .voteTooltip {top:100px;}
    </style>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:transparent url("images/QuizGuessingBg.jpg") no-repeat;' onUnload="exit();">
<div id="guessContainer" class="guessContainer"></div>
<div id="guessRanking" ></div>
<div id="arrowDown" style="visibility: hidden;" class="arrowDown"></div>
<div id="mask" ></div>
<div id='voteResultDialog' class='voteBg' style="visibility: hidden"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        focused     :   [<%= inner.getPreFoucs() %>],
        init:function(){
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

            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            cursor.pageSize = 3;
            cursor.focusable[0] = {focus:(this.focused.length > 1 ? Number(this.focused[1]) : 0), items:[
                { name:"竞猜规则",linkto:'/EPG/jsp/neirong/WorldCup2018/QuizRole.jsp'},
                { name:"全民拼手气",linkto:'/EPG/jsp/neirong/WorldCup2018/matchVibe.jsp'}
            ]};
            cursor.focusable[1] = {focus:0, items:[]};
            cursor.call("visitedRecord");
            cursor.call("queryCardNoAndPhone");
            cursor.call("queryGuessingRanking");
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
                    cursor.call("queryGuessingStatus");
                });
            } else {
                cursor.call("queryGuessingStatus");
            }
        },
        queryGuessingStatus : function(){
            var url = "http://192.168.89.23/worldCup/guessing.do?cardNo=" + CA.card.serialNumber;
            if(typeof cursor.phoneNumber !== "undefined") url += '&phone=' + cursor.phoneNumber;
            var time = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            url += "&time = " + time;
            ajax( url, function( results ){
                var items = results.data;
                cursor.focusable[1].items.pushAll(items);
                cursor.call("showGuessing");
            });
        },

        showGuessing : function(){
            var items = cursor.focusable[1].items;
            var focus = cursor.focusable[1].focus;
            $("arrowDown").style.visibility = items.length > cursor.pageSize ? "visible" : "hidden";

            var pageCount = cursor.pageSize;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;

            var html = "";
            var calcClazz = function(index, pos, fcs,guess){
                if(cursor.blocked == 1 && index == focus && pos == fcs) return "choiceItemFocus";
                if( pos == 0 && guess == 1 || pos == 1 && guess == 0 || pos == 2 && guess == -1 ) return "choiceItemSelected";
                return "choiceItem";
            };
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                var id = "guess" + ( i + 1);
                html += '<div class="guessItemContainer"><div class="guessItemBody">';
                html += "<div class='team team1'>";
                html += "<div class='flag'><img src='images/" + item.teamAAbbr + ".png' /></div>";
                html += "<div class='name'>" + item.teamACountry + "</div>";
                html += "</div>";
                var date = (new Date(item.startTime)).Format("MM月dd日 hh:mm");
                html += '<div class="time">' + date + "</div>";
                html += "<div class='team team2'>";
                html += "<div class='flag'><img src='images/" + item.teamBAbbr + ".png' /></div>";
                html += "<div class='name'>" + item.teamBCountry + "</div>";
                html += "</div>";
                html += '<div class="choiceTable">';
                html += '<div class="choiceItemContainer"><div class="' + calcClazz(i,0,typeof item.focus == 'undefined' ? 0 : item.focus , typeof item.value == 'undefined' ? 99 : item.value ) + '">' + item.teamACountry + " 胜</div></div>";
                html += '<div class="choiceItemContainer"><div class="' + calcClazz(i,1,typeof item.focus == 'undefined' ? 0 : item.focus , typeof item.value == 'undefined' ? 99 : item.value ) + '"> 平 </div></div>';
                html += '<div class="choiceItemContainer"><div class="' + calcClazz(i,2,typeof item.focus == 'undefined' ? 0 : item.focus , typeof item.value == 'undefined' ? 99 : item.value ) + '">' + item.teamBCountry + ' 胜</div></div>';
                html += '</div>';
                html += '</div></div>';
            }
            $("guessContainer").innerHTML = html;
        },
        queryGuessingRanking : function(){
            $("guessRanking").className = "mask guessRankingRole";
            var time = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            var maskPhone = function(str){
                return str.substr(0,3) + "****" + str.substr(8);
            };
            //if( time <= '2018-06-15 00:00:00') return;
            if( typeof html === 'undefined' ){
                var url = "http://192.168.89.23/worldCup/guessRanking.do?time=" + new Date().getTime();
                //返回结果格式：{"status":null,"data":[]}";
                ajax( url, function( result ){
                    if(typeof result.data === 'undefined' || result.data.length == 0 ) return;
                    var html = '<div class="ranking">';
                    for(var i = 0; i < 14; i ++){
                        if( i >= result.data.length ){
                            html += '<div class="rankItem"><div class="phone">-</div><div class="ticket">-</div></div>';
                        } else {
                            var item = result.data[i];
                            html += '<div class="rankItem"><div class="phone">' + maskPhone(item.phone) + '</div><div class="ticket">' + item.surmise + '</div></div>';
                        }
                        if( i == 6 ) html += "</div><div class='ranking' style='left:365px;'>";
                    }
                    html += "</div>";
                    $("guessRanking").innerHTML = html;
                    $("guessRanking").className = "mask guessRankingList";
                });
            }
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'竞猜享好礼',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("竞猜享好礼") + "&cardNo=" + CA.card.serialNumber;
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
            $("voteResultDialog").className = "voteBg voteBgTooltip";
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
            var blocked = cursor.blocked;

            if(blocked === cursor.voteBlocked ) {
                //如果显示了错误提示框，隐藏提示框
                if( cursor.voteShowError ){cursor.call("hideVoteToolTip"); return;}

                var item = cursor.focusable[1].items[cursor.focusable[1].focus];
                //检测用户是否有参与投票, 如果有，显示错误
                if( typeof item.value != 'undefined' )
                {
                    cursor.call("showVoteTooltip",{ message : "您已参与此场比赛的竞猜", isError : true });
                    return;
                }
                //否则用户为未参与过当前投票的用户
                var getSelectedMessage = function(){
                    var message = "您已选择 " ;
                    if( item.focus == 0 ){
                        item.selected = 1;
                        message += item.teamACountry + " 胜";
                    } else if( item.focus == 1 ) {
                        item.selected = 0;
                        message += "平";
                    } else {
                        item.selected = -1;
                        message += item.teamBCountry + " 胜";
                    }
                    return message;
                };

                //验证电话号码, 如果电话号码错误
                if( cursor.call("phoneValidate") ) {
                    //并且未显示电话号码输入框
                    if( ! cursor.voteShowInput ) {
                        cursor.phoneNumber = '';
                        cursor.call("showVoteInput", getSelectedMessage());
                        return;
                    }
                    //否则显示了电话号码输入框，则显示错误提示
                    cursor.call("showVoteTooltip",{ message : "手机号码输入错误！", isError : true });
                    return;
                }
                //如果电话号码正确，但是未显示提示框，显示提示框
                if( !cursor.voteShowDialog ) {
                    cursor.call("showVoteTooltip",{ message : getSelectedMessage(), isError : false });
                    return;
                }

                var cardNo = CA.card.serialNumber;
                var phone = cursor.phoneNumber;
                var time = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
                var contestId = item.contestId;
                var value = item.selected;

                var url = "http://192.168.89.23/worldCup/guess.do?contestId=" + contestId +
                        "&phone=" + phone + "&cardNo=" + cardNo + "&value=" + value + "&time=" + encodeURIComponent(time);
                ajax(url, function( result ) {
                    if(result.status == 0 ) {
                        item.value = item.selected;
                    }
                    cursor.call("showVoteTooltip",{ message : ( result.status == 0 ? "您已成功参与本次竞猜" : result.message ), isError : true });
                });
                return;
            }
            cursor.call("selectAct");
        },
        goBack:function(){
            var blocked = cursor.blocked;
            if( cursor.voteShowTootip ) { cursor.call("hideVoteToolTip"); return false; }
            if( cursor.voteShowInput ){
                if ( cursor.phoneNumber.length <= 0 ){ cursor.call("hideVoteInput"); return false;}
                $("phoneNumberInput").innerText = cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
                return false;
            }
            cursor.call("goBackAct");
        },
        //------------------------------------------------------------------------------------------------
        move        :   function(index){
            //-----------------------------------      投票功能        -----------------------------------------
            if( cursor.voteShowDialog ) return;
            //------------------------------------------------------------------------------------------------

            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked == 0 && (index == 11 || index == -11 || index == 1 && focus + 1 >= items.length ) ||
                blocked == 1 && ( index == 11 && focus <= 0 || index == -11 && focus + 1 >= items.length || index == -1 && items[focus].focus == 0 )
            ) return;

            if( blocked == 0 ) {
                focus += index;
                if( focus < 0 ){
                    blocked = 1;
                    focus = cursor.focusable[blocked].focus;
                    cursor.focusable[blocked].items[focus].focus = 2;
                }
            } else {
                if( index == 11 || index == -11 ){
                    items[focus + (index > 0 ? -1 : 1)].focus = items[focus].focus;
                    focus += (index > 0 ? -1 : 1);
                } else {
                    if( items[focus].focus + index > 2 ){
                        blocked = 0; focus = 0;
                    } else
                        items[focus].focus += index;
                }
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            if( previous == 1 && blocked == 0 ) cursor.call("showGuessing");
            cursor.call('show');
        },
        show:function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            $("mask").style.visibility = blocked == 0 ? "visible" : "hidden";
            if( blocked == 0 ) {
                $("mask").className = "mask mask" + (focus + 1);
                return;
            }
            cursor.call("showGuessing");
        }
    });
    -->
</script>
</html>