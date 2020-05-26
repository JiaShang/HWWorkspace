<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";
    infos.add(new ColumnInfo(typeId, 0, 5));
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
        .mask {position:absolute;background:transparent url('images/mask-2018-10-19-Vote.png') no-repeat;background-position: 0px 0px;}
        .mask1 {width:77px;height:45px;left:188px;top:553px;background-position:0px -75px;}
        .mask2 {width:77px;height:45px;left:275px;top:553px;background-position:-87px -75px;}
        .mask3 {width:77px;height:45px;left:362px;top:553px;background-position:-174px -75px;}
        .mask4 {width:77px;height:45px;left:449px;top:553px;background-position:-261px -75px;}
        .mask5 {width:77px;height:45px;left:536px;top:553px;background-position:-348px -75px;}
        .mask6 {width:77px;height:45px;left:188px;top:608px;background-position:0px -130px;}
        .mask7 {width:77px;height:45px;left:275px;top:608px;background-position:-87px -130px;}
        .mask8 {width:77px;height:45px;left:362px;top:608px;background-position:-174px -130px;}
        .mask9 {width:77px;height:45px;left:449px;top:608px;background-position:-261px -130px;}
        .mask10 {width:77px;height:45px;left:536px;top:608px;background-position:-348px -130px;}
        .mask11 {width:65px;height:99px;left:623px;top:553px;background-position:-435px -75px;}
        .mask12 {width:65px;height:65px;left:623px;top:478px;background-position:-435px 0px;}

        .text {width:400px;height:61px;left:191px;top:480px; text-align:right;position:absolute;font-size:36px;line-height:60px;color:black; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .tooltip {width:1280px;height: 720px;left:0px;top:0px;overflow: hidden;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-10-19-Vote.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id="text" class="text"></div>
<div id="tooltip" class="tooltip"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        init        :   function(){
            cursor.backUrl='<%= backUrl %>';
            var buttons = [
                {'name' : '1'},
                {'name' : '2'},
                {'name' : '3'},
                {'name' : '4'},
                {'name' : '5'},
                {'name' : '6'},
                {'name' : '7'},
                {'name' : '8'},
                {'name' : '9'},
                {'name' : '0'},
                {'name' : 'ok'},
                {'name' : 'del'}
            ];
            cursor.phoneNumber = '';
            cursor.focusable[0] = { focus : 0, items : buttons};
            cursor.call('show');
        },
        move        :   function(index){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;

            if( index == 1 && focus >= 10 || index == -1 && (focus == 0 || focus == 5 || focus == 11 ) || index == -11 && ( focus >= 6 && focus <= 10 ) || index == 11 && focus == 11 ) return;
            if ( index == 1 ) {
                if( focus == 4 || index == 9 ) {
                    focus = 10;
                } else {
                    focus += 1;
                }
            } else if( index == -1 ) {
                if( focus == 10 ) focus = 4;
                else {
                    focus -= 1;
                }
            } else if( index == 11 ) {
                if( focus == 10 || focus < 5) focus = 11;
                else {
                    focus -= 5;
                }
            } else {
                if( focus == 11 ) focus = 10;
                else {
                    focus += 5;
                }
            }
            cursor.focusable[0].focus = focus;
            cursor.call('show');
        },
        showTooltip : function(index){
            $('tooltip').style.backgroundImage = 'url("images/focusBg-2018-10-19-' + String(index) + '.png")';
            $('tooltip').style.visibility = 'visible';
            cursor.showTootip = true;
        },
        hiddenTooltip : function(index){
            $('tooltip').style.visibility = 'hidden';
            cursor.showTootip = false;
        },
        select : function(){
            if( cursor.showTootip ) {
                cursor.call('hiddenTooltip'); return;
            }
            var focus = cursor.focusable[0].focus;
            var item = cursor.focusable[0].items[focus];
            switch (item.name){
                case 'ok' :
                    var validate = cursor.call("phoneValidate");
                    if( validate ) {
                        cursor.call("showTooltip",1);
                        return;
                    }
                    var date = (new Date()).Format('yyyy-MM-dd hh:mm:ss');
                    if ( date >= '2018-10-29 23:59:59') {
                        cursor.call("showTooltip",3);
                        return;
                    }
                    cursor.call("sendVote",{id:433, target:'join',repeat:false,callback: function(result){
                            cursor.call("showTooltip",result.recode != '002' || result.result == false ? 3 : 2);
                      }});
                    break;
                case 'del':
                    if( cursor.phoneNumber.length > 0 ) {
                        cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
                        $("text").innerHTML = cursor.phoneNumber;
                    }
                    break;
                default:
                    if( cursor.phoneNumber.length < 11 ) {
                        cursor.phoneNumber += item.name;
                        $("text").innerHTML = cursor.phoneNumber;
                    }
                    break;
            }
        },
        goBack : function(){
            if( cursor.showTootip ) {
                cursor.call('hiddenTooltip'); return;
            }
            cursor.call('goBackAct');
        },
        show        :   function(){
            var focus = cursor.focusable[0].focus;
            $("mask").className = 'mask mask' + String( focus + 1);
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>