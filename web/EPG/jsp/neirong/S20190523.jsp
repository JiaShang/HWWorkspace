<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000111266";

    infos.add(new ColumnInfo(typeId, 0, 1));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2019-05-23.png" : inner.pictureUrl("images/bg-2019-05-23.png",column.getPosters(),"7");

    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList(typeId,1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }
%>
<html>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "100张忠县烽烟三国门票免费抢" : column.getName()%></title>
    <style>
        .voteBg{position:absolute;width:1280px;height:720px;left:0px;top:0px;background:transparent none no-repeat 0px 0px; background-position:0px 0px;}

        .phoneNumberInput{position:absolute; width:379px;height:50px; left:731px; top:546px; background-color:transparent;color:black;font-size:28px;line-height: 40px;}
        .txtTooltip{position: absolute;width: 595px;height: 80px;left: 347px;top: 314px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}

        .mask{position:absolute;background: transparent url("images/mask-2019-05-23.png") no-repeat left top;}
        .mask1 {width:378px;height:66px;left:710px;top:533px;background-position:0px 0px;}
        .mask2 {width:115px;height:58px;left:1105px;top:537px;background-position:-395px -4px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent <%= isEmpty(picture) ? "" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div class='phoneNumberInput' id='phoneNumberInput'></div>
<div id='mask'></div>
<div id='voteResultDialog' class='voteBg' style="visibility: hidden"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

            //-----------------------------------      投票功能        -----------------------------------------
            //当前焦点是否在投票按钮上
            cursor.voteBtnFocused = false;
            //是否显示投票提示框
            cursor.voteShowTootip = false;
            //输入的手机号码
            cursor.phoneNumber = '' ;
            //投票焦点所在块
            cursor.voteBlocked = 0;
            //-------------------------------------------------------------------------------------------------

            cursor.focusable[0] = {focus:0,items:[
                {name:"手机号输入"},
                {name:"投票"}
                ]};

            cursor.voteShowInput = true;
            cursor.call("preparePlay");
            cursor.call('show');
        },
        //-----------------------------------      投票功能        -----------------------------------------
        hideVoteToolTip : function () {
            $("voteResultDialog").style.visibility = "hidden";
            cursor.voteShowTootip = false;
            if( cursor.voteShowInput ) cursor.call("showVoteInput");
        },
        showVoteTooltip : function(message){
            cursor.voteShowTootip = true;
            $("voteResultDialog").className = "voteBg";
            $("voteResultDialog").style.backgroundImage = 'url("images/focusBg-2019-05-23-' + message + '.png")';
            $("voteResultDialog").style.visibility = "visible";
        },
        input : function(ch){
            if( !cursor.voteShowInput || cursor.phoneNumber.length >= 11 ) return;
            cursor.phoneNumber += ch;
            $("phoneNumberInput").innerText = cursor.phoneNumber;
        },
        select:function(){
            var blocked = cursor.blocked;
            //如果显示了提示框，隐藏提示框
            if( cursor.voteShowTootip ){cursor.call("hideVoteToolTip"); return;}
            if(blocked === cursor.voteBlocked ) {
                var current = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
                if( current >= '2019-06-02 23:59:59') {
                    cursor.call("showVoteTooltip",3);  return;//"当前活动已结束，谢谢参与！"
                }
                var validate = cursor.call("phoneValidate");
                //手机号码有误
                if( validate ) {
                    cursor.call("showVoteTooltip",4); return;//"手机号码输入错误, 请重新正确输入！"
                }
                (function(target){
                    cursor.call("sendVote",{
                        id:447,
                        target:'抢票',repeat:true,limit:1,limitPer:1,
                        callback: function(result){
                            cursor.voteShowInput = false;
                            if(result.recode != '002' || result.result == false ){
                                cursor.call("showVoteTooltip",2);//"您已参与过活动，不能重复参与！"
                            } else {
                                cursor.call("showVoteTooltip",1); //"感谢您参与抢票<br/><br/>请保持手机通畅 抢票成功后客户将与您联系"
                            }
                            return false;
                        }
                    });
                })();
                return;
            }
            cursor.call("selectAct");
        },
        preparePlay : function(){
            player.play({
                position: {left:613,top:122,width:608,height:375},
                vodId : <%=vodId%>
            });
        },
        nextVideo   :   function () {
            cursor.call("preparePlay");
        },
        goBack:function(){
            var blocked = cursor.blocked;
            if( cursor.voteShowTootip ) { cursor.call("hideVoteToolTip"); return; }
            if( cursor.voteShowInput && cursor.phoneNumber.length >= 0 ) {
                cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
                $("phoneNumberInput").innerText = cursor.phoneNumber;
                return;
            }
            var focus = cursor.focusable[0].focus;
            if( focus == 0 && cursor.phoneNumber.length <= 0 || focus == 1 ) cursor.call("goBackAct");
        },
        //------------------------------------------------------------------------------------------------

        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if(  blocked == 0 && ( index == 11 || index == -11 || index == -1 && focus <= 0 || index == 1 && focus >= 1 )) return;
            if( index == 1 || index == -1 ) {
                focus += index;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.voteShowInput = (blocked == 0 && focus == 0);
            cursor.call('show');
        },
        show:function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className= "mask mask" + (focus + 1);
        }
    });
    -->
</script>
</html>