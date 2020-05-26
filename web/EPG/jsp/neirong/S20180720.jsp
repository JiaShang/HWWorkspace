<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    //  一横排专区模板, 默认5个方框
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;;
    tp:TOP坐标;不填为默认坐标
    fc:焦点文字颜色;不填为默认为黄色
    bc:焦点框颜色;不填为默认为黄色
    ct:显示数量;每页显示条目个数，默认为５个;;
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109845";

    infos.add(new ColumnInfo(typeId, 0, 1));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2018-07-20.png" : inner.pictureUrl("images/bg-2018-07-20.png",column.getPosters(),"7");

    int vodId = 0;
    Vod vod = new Vod();
    List<Vod> vods = inner.getList(typeId,1,0,vod);
    if( vods != null && vods.size() > 0) {
        vodId = vods.get(0).getId();
    }

    String bc = null,fc = null;
    Integer tp = null,ct=null;
    ct = isEmpty( inner.get("ct") ) ? 5 : Integer.valueOf( inner.get("ct") );
    tp = isEmpty( inner.get("tp") ) ? 383 : Integer.valueOf( inner.get("tp") );
    fc = isEmpty( inner.get("fc") ) ? "fdfa00" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "fdfa00" : inner.get("bc");
%>
<html>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "宣传片，投票" : column.getName()%></title>
    <style>
        .voteBg{position:absolute;width:1280px;height:720px;left:0px;top:0px;background:transparent url("images/forcusBg-2018-06-19-1.png") no-repeat 0px 0px; background-position:0px 0px;}
        .voteBgTooltip{background:transparent url("images/forcusBg-2018-06-19-2.png") no-repeat 0px 0px; }
        .phoneNumberInput{position:absolute; width:379px;height:50px; left:751px; top:526px; background-color:transparent;color:black;font-size:28px;line-height: 40px;}
        .txtTooltip{position: absolute;width: 595px;height: 80px;left: 347px;top: 314px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}

        .mask{position:absolute;background: transparent url("images/mask-2018-07-20.png") no-repeat left top;}
        .mask1 {width:411px;height:61px;left:725px;top:520px;background-position:0px 0px;}
        .mask2 {width:91px;height:59px;left:1140px;top:522px;background-position:-420px 0px;}
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
            var html = "<div class='txtTooltip'>" + message + "</div>";
            $("voteResultDialog").innerHTML = html;
            $("voteResultDialog").className = "voteBg voteBgTooltip";
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
                if( current >= '2018-07-26 00:00:00') {
                    cursor.call("showVoteTooltip","当前活动已结束，谢谢参与！");  return;
                }
                var validate = cursor.call("phoneValidate");
                //手机号码有误
                if( validate ) {
                    cursor.call("showVoteTooltip","手机号码输入错误, 请重新正确输入！");
                    return;
                }
                (function(target){
                    cursor.call("sendVote",{
                        id:426,
                        target:'报名',
                        repeat:false,
                        callback: function(result){
                            cursor.voteShowInput = false;
                            if(result.recode != '002' || result.result == false ){
                                cursor.call("showVoteTooltip","您已参与过活动，不能重复参与！");
                            } else {
                                cursor.call("showVoteTooltip","感谢您参与抢票<br/><br/>请保持手机通畅 抢票成功后客户将与您联系");
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
                position: {left:599,top:87,width:619,height:354},
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