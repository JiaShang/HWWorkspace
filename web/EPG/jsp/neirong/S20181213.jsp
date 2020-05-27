<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="GB18030"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000110720";

    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <title>2018感动重庆十大人物</title>
    <meta charset="GB18030">
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style>
        .mask {width:61PX;height:30px;position:absolute;background:transparent url('images/mask-2017-12-22.png') no-repeat;background-position: 0px 0px;}
        .mask1 {left:225px;top:345px;}
        .mask2 {left:440px;top:345px;}
        .mask3 {left:655px;top:345px;}
        .mask4 {left:869px;top:345px;}
        .mask5 {left:1084px;top:345px;}
        .mask6 {left:225px;top:561px;}
        .mask7 {left:440px;top:561px;}
        .mask8 {left:655px;top:561px;}
        .mask9 {left:869px;top:561px;}
        .mask10 {left:1084px;top:561px;}

        .vote {width:100px;height:21px;position:absolute;font-size:18px;color:white;text-align:left; line-height: 21px;}
        .vote1{left:100px;top:312px;}
        .vote2{left:315px;top:312px;}
        .vote3{left:530px;top:312px;}
        .vote4{left:744px;top:312px;}
        .vote5{left:959px;top:312px;}
        .vote6{left:100px;top:528px;}
        .vote7{left:315px;top:528px;}
        .vote8{left:530px;top:528px;}
        .vote9{left:742px;top:528px;}
        .vote10{left:959px;top:528px;}

        .tooltip{width: 1280px;height:720px;position:absolute;left:0px;top:0px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black none no-repeat;" onUnload="exit();">
<div id='vote1' class='vote vote1'></div>
<div id='vote2' class='vote vote2'></div>
<div id='vote3' class='vote vote3'></div>
<div id='vote4' class='vote vote4'></div>
<div id='vote5' class='vote vote5'></div>
<div id='vote6' class='vote vote6'></div>
<div id='vote7' class='vote vote7'></div>
<div id='vote8' class='vote vote8'></div>
<div id='vote9' class='vote vote9'></div>
<div id='vote10' class='vote vote10'></div>
<div id='mask'></div>
<div id="tooltip" class="tooltip" style="visibility: hidden;"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
               String html = "";
               String[] names = "邓林明 王恒清 刘佳 刘彦 刘鸿 吴贵生 吴晓凡 何夕瑞 何波 陈久述 陈永昌 李则民 杨德兵 封宇恒 高万录 唐帅 曾令华 程绍光 谢彬蓉 廖良琼".split(" ");
               html += "{data:[";
               for( int j = 0; j < names.length ; j++ ){
                   String name = names[j];
                   String str = "{ name:\"" + name + "\"," +
                          "voteCount:0,playType:-2" ;
                       str += "}" ;
                   str += ( j + 1 < names.length  ? "," : "");
                   html += str;
               }
               html += "]}";
               out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.voteId = 436;//正式ID436

            cursor.columns = 5;
            cursor.rows = 2;
            cursor.pageCount = cursor.columns * cursor.rows;
            cursor.column = <%= inner.writeObject(column)%>;

            var currentTime = (new Date()).Format("yyyy-MM-dd hh:mm:ss");
            cursor.enabled = currentTime >= '2018-12-17 09:00:00' && currentTime < "2018-12-23 18:00:00";
            cursor.showTooltip = false;

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.call('show');
            cursor.call("showVoteResult");
        },
        move        :   function(index){
            if( cursor.showTooltip ) return;
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var pageCount = cursor.pageCount;

            var rows = cursor.rows;var columns = cursor.columns;
            if( index == 11 && focus < columns || //按上光标键时
                index == -1 && focus % columns == 0 || //按左光标键时
                index == 1 && (focus % columns == columns - 1 || focus + 1 >= items.length ) || //按右光标键时
                index == -11 && ( Math.ceil((focus + 1.0) / columns ) >= Math.ceil( items.length * 1.0 ) / columns )
            ) return;

            if( index == 1 || index == -1 ) focus += index;
            else if( index == 11 ) focus -= columns;
            else if( index == -11 ) focus += columns;
            if( focus >= items.length ) { focus = items.length - 1 ; }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        showTooltip : function(id){
            $("tooltip").style.backgroundImage = 'url("images/focusBg-2018-09-27-' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            cursor.showTooltip = true;
        },
        select : function(){
            var blocked = cursor.blocked;
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            if( !cursor.enabled ) return;
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
                            cursor.call('showTooltip', 2);
                        } else {
                            cursor.call('showTooltip', 3); cursor.call("showVoteResult");
                        }
                    }
                });
            })();
            return;
        },
        goBack : function() {
            if( cursor.showTooltip ) {
                $("tooltip").style.visibility = 'hidden'; cursor.showTooltip = false;return;
            }
            cursor.call("goBackAct");
        },
        showVoteResult: function(){
            cursor.call("voteResult", {blocked : 0, callback: function(){
                /*cursor.focusable[0].items.sort(function (a, b) {
                    var a1 = a.voteCount || 0;
                    var b1 = b.voteCount || 0;
                    return b1 - a1;
                });*/
                /*if(typeof cursor.focusName != "undefined" ){
                    for( var i = 0 ; i < cursor.focusable[0].items.length; i ++) {
                        if( cursor.focusable[0].items[i].name != cursor.focusName ) continue;
                        cursor.focusable[0].focus = i;
                        break;
                    }
                }*/
                cursor.call("show");
            }});
        },
        show        :   function(){
            var html = '';
            var blocked = 0;
            var pageCount = cursor.pageCount;
            var focus = cursor.focusable[blocked].focus;

            $("mask").className  = "mask mask" + (focus % 10 + 1);
            var backBg = 'url("' + cursor.pictureUrl(cursor.column.posters,7,'', Math.floor( (focus * 1.0) / 10 ) )  + '")';
            document.body.style.backgroundImage =  backBg;

            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var items = cursor.focusable[0].items;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + pageCount; i += 1) {
                $("vote" + (i - flowCursorIndex + 1) ).innerHTML =  i < items.length ? String( items[i].voteCount ) + ' 票' : '';
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>