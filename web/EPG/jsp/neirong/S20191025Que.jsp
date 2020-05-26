<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<html>
<head>
    <title>答题</title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {width:38px;height:38px;left:867px;position:absolute;background:transparent url('images/mask-2019-07-31.png') no-repeat;background-position: 0px 0px;}
        .after {width:1280px;height:720px;left:0px;top:0px;background:transparent none no-repeat;background-position: 0px 0px;}
        .mask11 {top:337px;}
        .mask12 {top:408px;}
        .mask13 {top:487px;}
        .mask14 {width:96px;height:40px;left:592px;top:578px;background-position: -1100px -200px;}

        .focus{background-position: -1100px 0px;}
        .selectedFocus{background-position: -1100px -50px;}
        .selected{background-position: -1100px -100px;}

        .tooltip{width: 1280px;height:720px;position:absolute;left:0px;top:0px;}
        .sure,.back{width:77px;height:55px;top:289px;}
        .sure{left:722px;background-position: -800px -400px;}
        .back{left:804px;background-position: -900px -400px;}

        .phoneNumber{ position: absolute;width: 218px;height: 22px;left: 400px;top: 304px;background-color: transparent;color: black;font-size: 26px;letter-spacing: 6px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2019-10-25-Que.jpg') no-repeat;" onUnload="exit();">
<div id="after" class="after">
    <div id="mask"></div>
</div>
<div id="tooltip" class="tooltip" style="visibility: hidden;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.voteId = 460;
            cursor.phoneNumber = '';
            cursor.showToolTip = false;
            cursor.focusable[0] = {
                focus:0, items:[
                    {"name:":"题一","answer":"1"},
                    {"name:":"题二","answer":"2"},
                    {"name:":"题三","answer":"2"},
                    {"name:":"题四","answer":"0"},
                    {"name:":"题五","answer":"2"},
                    {"name:":"题六","answer":"0"},
                    {"name:":"题七","answer":"1"},
                    {"name:":"题八","answer":"0"}
                ]
            },
            cursor.focusable[1] = {
                focus:0, items:[
                    {"name:":"提交答案"}
                ]
            };
            cursor.focusable[2] = {
                focus:0, items:[
                    {"name:":"确认"},
                    {"name:":"返回"}
                ]
            };
            cursor.call('show');
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            if( cursor.showToolTip ) return;
            var blocked = cursor.blocked;
            var focusP = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( blocked == 0 ) {
                var focus = items[focusP].focus || 0;
                if( index == -1 && focusP <= 0 ||  index == 1 && focusP + 1 >= items.length || index == 11 && focus <= 0 || index == -11 && focus + 1 >= 4 ) return;
                if( index == 11 || index == -11 ) {
                    focus += index > 0 ? -1 : 1;
                    items[focusP].focus = focus;
                } else {
                    focusP += index;
                }
            } else if( blocked == 1) {
                return;
            } else {
                if( index == 11 || index == -11 || index == -1 && focusP <= 0 || index == 1 && focusP + 1 >= 2 ) return;
                focusP += index;
            }
            cursor.focusable[blocked].focus = focusP;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var background = '';
            var html = "";
            if( blocked == 0 ) {
                background = "url('images/item-2019-10-25-" + String( focus + 1 ) +  ".png')";
                $("after").style.backgroundImage = background;
                var items = cursor.focusable[blocked].items;
                var selected = items[focus].selected;
                focus = items[focus].focus || 0;
                if( typeof selected != 'undefined' && selected != focus) {
                    html = '<div class="mask mask1' + String(selected + 1) + ' selected"></div>';
                }
                if( focus != 3 ) {
                    html += '<div class="mask mask1' + String(focus + 1) + ( selected != focus ? " focus" : " selectedFocus") + '"></div>';
                } else {
                    html += '<div class="mask mask14"></div>';
                }
            } else if(blocked == 1){
                background = "url('images/item-2019-10-25-9.png')";
                $("after").style.backgroundImage = background;
                html += '<div class="mask mask14"></div>';
            } else {
                background = "url('images/item-2019-10-25-10.png')";
                $("after").style.backgroundImage = background;
                html = '<div class="phoneNumber">' + cursor.phoneNumber + "</div>";
                html += '<div class="mask ' + (focus == 0 ? "sure" : "back")  +  '"></div>';
            }
            $("after").innerHTML = html;
        },
        showTooltip : function(id){
            $("tooltip").style.backgroundImage = 'url("images/focusBg-2019-07-31-' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showToolTip = true;
        },
        hiddenTooltip : function(){
            $('tooltip').style.visibility = 'hidden';
            cursor.showToolTip = false;
        },
        input : function(ch){
            var blocked = cursor.blocked;
            if( blocked != 2 || cursor.phoneNumber.length >= 11 ) return;
            cursor.phoneNumber += ch;
            var focus = cursor.focusable[blocked].focus;
            var html = '<div class="phoneNumber">' + cursor.phoneNumber + "</div>";
            html += '<div class="mask ' + (focus == 0 ? "sure" : "back")  +  '"></div>';
            $("after").innerHTML = html;
        },
        goBack : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if( cursor.showToolTip ) return cursor.call('hiddenTooltip');
            if( blocked == 2 && cursor.phoneNumber.length > 0) {
                cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
                var html = '<div class="phoneNumber">' + cursor.phoneNumber + "</div>";
                html += '<div class="mask ' + (focus == 0 ? "sure" : "back")  +  '"></div>';
                $("after").innerHTML = html;
                return;
            }
            cursor.call('goBackAct');
        },
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            if( cursor.showToolTip ) {
                if( !cursor.validated ) {
                    cursor.validated = true;
                    cursor.blocked = 1;
                    cursor.focusable[blocked].focus = 0;
                    cursor.call('hiddenTooltip');
                    return cursor.call("show");
                }
                return cursor.call('hiddenTooltip');
            }
            if( blocked == 0 ) {
                focus = items[focus].focus || 0;
                if( focus == 3 ) {
                    if( cursor.focusable[blocked].focus + 1 < items.length ) {
                        cursor.focusable[blocked].focus += 1;
                    } else {
                        cursor.selectAll = true;
                        for( var i = 0; i < items.length && cursor.selectAll; i ++) cursor.selectAll &= typeof items[i].selected != 'undefined';
                        //当题没有全部做完时，提示未选完所有题目。
                        if( !cursor.selectAll ) {
                            cursor.validated = false;
                            return cursor.call('showTooltip', 2);
                        }
                        cursor.validated = true;
                        cursor.blocked = 1;
                        cursor.focusable[blocked].focus = 0;
                    }
                } else {
                    var selected = items[cursor.focusable[blocked].focus].selected;
                    items[cursor.focusable[blocked].focus].selected = typeof selected != 'undefined' && focus == selected ? undefined : focus;
                }
            } else if( blocked == 1 ) {
                cursor.blocked = 2;
                cursor.focusable[blocked].focus = 0;
            } else {
                if( focus == 1 ) return cursor.call('goBackAct');
                if( cursor.call("phoneValidate") ) return cursor.call("showTooltip",4);
                var date = (new Date()).Format('yyyy-MM-dd hh:mm:ss');
                if ( date >= '2019-11-03 23:59:59') {
                    cursor.call("showTooltip",3);
                    return;
                }
                var items = cursor.focusable[0].items;
                var course =  0;
                for( var i = 0; i < items.length ; i ++) course += items[i].selected == items[i].answer ? 12.5 : 0;
                cursor.call("sendVote",{id:467,target:String(course),repeat:false,callback: function(result){
                      cursor.call("showTooltip", 1);
                }});
            }

            cursor.call("show");
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>