<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109540";
    infos.add(new ColumnInfo("10000100000000090000000000109542", 0, 1));
    infos.add(new ColumnInfo("10000100000000090000000000109543", 0, 5));
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<head>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .bgTop {width:1280px;left:0px;top:0px;background:transparent url('images/bg-2018-05-16-top.jpg') no-repeat left top;height:181px;position:absolute;}
        .bgMiddle {width:1280px;left:0px;top:181px;background:transparent url('images/bg-2018-05-16-middle.png') no-repeat left top;height:334px;position:absolute;}
        .bgBottom {width:1280px;left:0px;top:515px;background:transparent url('images/bg-2018-05-16-bottom.jpg') no-repeat left top;height:245px;position:absolute;}

        .mask {position:absolute;border:6px #F1422A solid;background: transparent url("images/mask-2018-05-16.png") no-repeat 0px 0px;background-position: -200px -150px;}
        .mask11 {width:605px;height:341px;left:69px;top:175px;}

        .mask21 {width:220px;height:145px;left:69px;top:535px;}
        .mask22 {width:220px;height:145px;left:299px;top:535px;}
        .mask23 {width:220px;height:145px;left:529px;top:535px;}
        .mask24 {width:220px;height:145px;left:759px;top:535px;}
        .mask25 {width:220px;height:145px;left:989px;top:535px;}

        .mask41 {width:41px;height:145px;left:1168px;top:535px;background-position: -1px -39px;border:0px transparent solid;}

        .questions {width:495px;height:270px;left:700px;top:235px;position:absolute;overflow: hidden;}
        .container {width:495px;height: auto;}
        .questions .question {width:495px;height:90px;overflow: hidden;}
        .questions .question .title {width:495px;height:38px;line-height: 45px;color:white;font-size:16px;overflow: hidden;text-align: left;overflow: hidden;}
        .questions .question .choices {width:495px;height:42px;overflow: hidden;}
        .questions .question .item {width:120px;color:white;height:42px;overflow: hidden;float:left;background:transparent url("images/mask-2018-05-16.png") no-repeat 0px -190px;font-size:16px;text-align: center;line-height: 40px;}
        .questions .question .choice {width:120px;color:white;height:42px;overflow: hidden;float:left;background:transparent url("images/mask-2018-05-16.png") no-repeat 0px -296px;font-size:16px;text-align: center;line-height: 40px;}
        .questions .question .selected {width:120px;color:white;height:42px;overflow: hidden;float:left;background:transparent url("images/mask-2018-05-16.png") no-repeat 0px -240px;font-size:16px;text-align: center;line-height: 40px;}
        .questionsPage {width:79px;height:29px;font-size:26px;color:#F1422A;position:absolute;left:1028px;top:192px;overflow: hidden;}

        .answerRight,.answerError {width:555px;height:403px;top:201px;left:356px;position:absolute;visibility: hidden;}
        .answerRight {background: transparent url("images/mask-2018-05-16-1.jpg") no-repeat left top;}
        .answerError {background: transparent url("images/mask-2018-05-16-2.jpg") no-repeat left top;}
        .answerTootip {width:200px;height:27px;color:white;position:absolute;left:249px;top:307px;font-size: 22px;}
        .flowed {width:1155px;height:139px;position:absolute;left:74px;top:540px;position:absolute;}
        .flowed .item{width:230px;height:139px;position:relative;float:left;overflow: hidden;}
        .flowed .item .image{width:210px;height:139px;position:absolute;left:0px;top:0px;overflow: hidden;}
        .flowed .item .image img {width:210px;height:139px;}
        .flowed .item .text {background:transparent url("images/mask-2018-05-16.png") no-repeat left top;font-size: 17px;width:210px;height:26px;color:white;position:absolute;left:0px;top:113px;overflow:hidden;line-height: 26px;text-align: left; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .marqueed {width:210px;line-height: 26px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div style="position:absolute;width:2500px;height:45px;top:-50px;left:0px;background-color: transparent;color:transparent;visibility: hidden;">
    <span id='calcPixels' style='visibility: visible;overflow: visible;word-break: keep-all;white-space: nowrap;color:transparent;background-color:transparent;font-size:20px'></span><span id='calcOffsetLeft'>&nbsp;</span>
</div>
<div class="bgTop"></div><div class="bgMiddle"></div><div class="bgBottom"></div>
<div class="flowed" id="flowed"></div>
<div class="questions" id="questions"></div>
<div class="questionsPage" id="questionsPage"></div>
<div class="answerRight" id="answerRight"></div>
<div class="answerError" id="answerError">
    <div class="answerTootip" id="answerTootip"></div>
</div>
<div id="mask"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var initialize = {
        data        : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused     :   [<%= inner.getPreFoucs() %>],
        init        :   function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 1;
            cursor.backUrl='<%= backUrl %>';

            cursor.frequency = 2190000;
            cursor.serviceId = 4102;

            cursor.answer = undefined;
            cursor.showTootip = false;

            var date = new Date();
            cursor.playLive = date.getDay() != 0 && date.getHours() >= 20 && date.getHours() < 21;

            var questions = [
                {question:'1、缙云寺在古代为因为什么又被叫做相思寺？',choices:["A、爱情传说","B、佛教故事","C、相思籽"],answer:2},
                {question:'2、巫溪大宁河畔盐民古时候是用什么工具来烤鱼的？',choices:["A、木板","B、石板","C、铁板"],answer:1},
                {question:'3、重庆的第一家室内真冰滑冰场在哪里？',choices:["A、万象城","B、北城天街","C、大都会"],answer:2},
                {question:'4、可口可乐刚被研制出来的时候，是在什么场所售卖的？',choices:["A、路边摊","B、服装店","C、药店","D、甜品店"],answer:2},
                {question:'5、2008年北京奥运会火炬接力服上的图案与哪位重庆名人有关？',choices:["A、巴曼子","B、秦良玉","C、罗中立","D、张一白"],answer:1}
            ];
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[0].items[0].linkto = "/EPG/jsp/neirong/VideoFullPlay.jsp?" + (
                ! cursor.playLive
                    ? "vodId=" + cursor.focusable[0].items[0].id
                    : "serviceId=" + cursor.serviceId + "&frequency=" + cursor.frequency
            );
            cursor.focusable.push({focus:0,items:questions});
            cursor.focusable[2].focus = this.focused.length > 3 ? Number( this.focused[3] ) : 0;
            cursor.focusable.push({focus:0,items:[{name:"更多视频",linkto:"/EPG/jsp/neirong/S20180516More.jsp"}]});

            cursor.call("preparePlay");
            cursor.call("showQuestions");
            cursor.call("visitedCount");
            cursor.call("showItems");
            cursor.call('show');
        },
        visitedCount : function(){
            if( iPanel.mediaType === 'PC' ) return;
            setTimeout(function(){
                cursor.call("sendVote",{
                    id:434,limit:9999,limitPer:9999,target:'+1',repeat:true
                });
            }, 2000 );
        },
        showQuestions : function(){
            var html = "";
            var items = cursor.focusable[2].items;
            html += "<div id='container' class='container'>";
            for( var i = 0; i < items.length; i ++){
                var id  = i + 1;
                var item = items[i];
                html += "<div class='question'>";
                html += "<div class='title'>" + item.question + "</div>";
                html += "<div class='choices'>";
                var choices = item.choices;
                for(var j = 0; j < choices.length; j ++ ) {
                    var choice = choices[j];
                    html += "<div id='choice" + id + (j + 1) + "' class='item'>" + choice + "</div>";
                }
                html += "</div></div>";
            }
            html += "</div>";
            $("questions").innerHTML = html;
            var focus = cursor.focusable[2].focus;
            $("questionsPage").innerHTML =  Math.ceil((focus + 1.0) / 3) + " / " + Math.ceil((items.length * 1.0) / 3);
        },
        focusQuestions : function(index){
            var focus = cursor.focusable[2].focus;
            var items = cursor.focusable[2].items;
            var item = items[focus];
            var selected  = typeof item.selected == "undefined" ? 0 : item.selected;
            var current  = typeof item.current == "undefined" ? 0 : item.current;
            $("choice" + (focus + 1) + (current + 1)).className = "choice";
            var margin = Math.floor((focus * 1.0) / 3) * -270;
            $("container").style.marginTop = margin + "px";
            $("questionsPage").innerHTML =  Math.ceil((focus + 1.0) / 3) + " / " + Math.ceil((items.length * 1.0) / 3);
        },
        showItems:function () {
            var html = '';
            var items = cursor.focusable[1].items;
            for(var i = 0; i < items.length; i ++) {
                var item = items[i];
                var id = i + 1;
                html += "<div class='item'>";
                html += "<div class='image'><img src='" + cursor.pictureUrl(item.posters,1) + "'></div>";
                html += "<div class='text' id='text" + id + "'>" + item.name + "</div>";
                html += "</div>";
            }
            $("flowed").innerHTML = html;
        },
        select : function(){
            if(cursor.blocked === 2 ) {
                if( cursor.showTootip ) {
                    $(cursor.answer == true  ? "answerRight" : "answerError" ).style.visibility = "hidden";
                    cursor.showTootip = false;
                    return;
                }
                var focus = cursor.focusable[2].focus;
                var items = cursor.focusable[2].items;
                var item = items[focus];
                var current  = typeof item.current == "undefined" ? 0 : item.current;
                if( typeof item.selected != "undefined" && item.selected != current ){
                    $("choice" + (focus + 1) + (item.selected + 1)).className = "item";
                }
                item.selected = current;
                $("choice" + (focus + 1) + (current + 1)).className = "selected";
                cursor.answer = item.selected == item.answer;
                if( cursor.answer == true ) {
                    cursor.showTootip = true;
                    $("answerRight").style.visibility = "visible";
                } else {
                    var choice = item.choices[item.answer];
                    cursor.showTootip = true;
                    $("answerTootip").innerHTML = choice;
                    $("answerError").style.visibility = "visible";
                }
                return;
            }
            cursor.call("selectAct");
        },
        goBack : function(){
            if(cursor.blocked === 2 &&cursor.showTootip ) {
                cursor.showTootip = false;
                $(cursor.answer == true ? "answerRight" : "answerError" ).style.visibility = "hidden";
                return;
            }
            cursor.call("goBackAct");
        },
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index == 11 || index == -1 ) ||
                blocked === 1 && (index == -1 && focus <= 0 || index == -11 || index == 1 && focus + 1 >= items.length) ||
                blocked === 2 && (cursor.showTootip || index == 11 && focus <= 0) ||
                blocked === 3 && (index == 1 || index == -11 )
            ) return;

            if( blocked == 0 ) {
                if( index == -11 ) {
                    blocked = 1; focus = 0;
                } else {
                    blocked = 2; focus = cursor.focusable[blocked].focus;
                }
            } else if( blocked == 1 ) {
                $("text" + (focus + 1)).innerHTML = cursor.focusable[blocked].items[focus].name;
                if( index == -1 ) focus -= 1;
                else if( index == 1 ) {
                    focus += 1;
                    if( focus >= items.length ) {
                        blocked = 3; focus = 0;
                    }
                } else {
                    if( focus <= 2 ) {
                        blocked = 0; focus = 0;
                    } else {
                        blocked = 2;focus = cursor.focusable[blocked].focus;
                    }
                }
            } else if( blocked == 3 ) {
                if( index == -1 ) {
                    blocked = 1; focus = cursor.focusable[blocked].items.length -1 ;
                } else {
                    blocked = 2; focus = cursor.focusable[blocked].focus;
                }
            } else {
                var selected = typeof items[focus].selected == 'undefined' ? 0 : items[focus].selected;
                if( typeof items[focus].current !== 'undefined' ) selected = items[focus].current;
                var choices = items[focus].choices;
                if( index == 1 && selected + 1 >= choices.length ) return;

                $("choice" + (focus + 1) + (selected + 1)).className = selected == items[focus].selected ?"selected" : "item";

                if( index == -11 || index == 11 ) {
                    focus += index > 0 ? -1 : 1;
                    if( focus >= items.length ) {
                        blocked = 1; focus = cursor.focusable[blocked].focus;
                    }
                } else {
                    selected += index;
                    if( selected < 0 ) {
                        blocked = 0; focus = 0; selected = 0;
                    }
                }
                if( selected >= items[focus].choices.length ) selected = items[focus].choices.length - 1;
                items[focus].current = selected;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        preparePlay : function(){
            player.setPosition(75,181,593,334);
            if( cursor.playLive ) {
                player.play({frequency: cursor.frequency,serviceId: cursor.serviceId});
            } else {
                var item = cursor.focusable[0].items[0];
                player.play({vodId : item.id});
            }
        },
        nextVideo   :   function () {
            cursor.call("preparePlay");
        },
        show        :   function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            if(blocked !== 2) {
                $("mask").style.visibility = "visible";
                $("mask").className = "mask mask" + (blocked + 1) + "" + ( focus + 1);
                if(iPanel.mediaType == "GW" || iPanel.mediaType == "P60") {
                    if( blocked != 2 ) {
                        $("mask").style.width = (blocked == 0 ? 590 : 205) + "px";
                        $("mask").style.height = (blocked == 0 ? 330 : 135) +"px";
                    } else {
                        $("mask").style.width = $("mask").style.height = "";
                    }
                }
                if( blocked == 1 ){
                    if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
                    cursor.moveTimer = setTimeout(function(){
                        var item = cursor.focusable[blocked].items[focus];
                        cursor.calcStringPixels(item.name,17,function(width){
                           if(width < 210) return;
                           $("text" + (focus + 1)).innerHTML = ('<marquee class="marqueed" scrollamount="10">' + item.name + "</marquee>")
                        });
                    },200);
                }

                return;
            } else {
                $("mask").style.visibility = "hidden";
                cursor.call("focusQuestions");
            }
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>