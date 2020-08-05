<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    w:整个条目的宽度
    h:所有条目高度的和
    ih:元素的高度
    mr:两个条目之间的空隙
    fs:字体大小
    lft:文本块显示坐标 LEFT
    tp:文本块显示坐标 TOP
    cl:文字颜色
    al:文字对齐方式，0:左对齐，１:居中对齐, 2:右对齐
    bg:普通条目背景颜色
    fc:焦点文字颜色
    bc:焦点背景
    pg:页面显示内容条数
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
    video:视频窗位置，width,height,left,top (如果没有表示无小窗口播放)
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000116603";
    infos.add(new ColumnInfo(typeId,0, 99));
//    infos.add(new ColumnInfo("10000100000000090000000000113411", 1, 99));  //无二级栏目
//    infos.add(new ColumnInfo("10000100000000090000000000113412", 1, 99));  //无二级栏目
//    List<Column> columns = inner.getList(typeId, 3, 0 , new Column());
//    for( int i = 0 ; columns != null && i < columns.size(); i++ ) {
//        infos.add(new ColumnInfo(columns.get(i).id, 0, 99));
//    }

    //////////////////////////有二级栏目/////////////////////
//    Column column = new Column();
//    List<Column> columns = inner.getList(typeId, 3, 0, column);   //（id，查询数据条数，开始查询位置）
//    for( Column col : columns ) {
//        infos.add(new ColumnInfo(col.getId(), 0, 5));
//    }
//    Result result = new Result( typeId, columns );
    //////////////////////////////////////////////////////////

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = "";
    if( column != null ) {
        picture = inner.pictureUrl(picture, column.getPosters(), "7");
    }



%>
<html>
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <meta name="page-view-size" content="1280*720">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <script language="javascript" type="application/javascript" src="js/showList.js"></script>
</head>
<body id="bg" leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200730Bg.jpg)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="tooltip" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;">
    <div id="tip" style="position: absolute;left: 410px; top: 240px;width: 400px;height: 60px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #ffffff;font-size: 28px;">
    </div>
    <div id="phone" style="position: absolute;left: 420px; top: 326px;width: 420px;height: 50px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #0e0e0b;font-size: 26px;">
    </div>
    <div id="tipFlagFocus" style="position: absolute;left: 510px; top: 420px;width: 226px;height: 53px;visibility: hidden;overflow: hidden; background:transparent url('images/AnswerButton30.png') no-repeat;z-index: 2;">
    </div>
</div>
<div id="focus" style="position: absolute;width: 570px;height: 69px;left: 155px;top: 395px; overflow:hidden; background: url('images/J20200731List1Focus.png') no-repeat;" ></div>
<div id="answerFlag" style="position: absolute;width: 27px;height: 23px;left: 675px;top: 415px; overflow:hidden; background: url('images/AnswerFlag.png') no-repeat; visibility: hidden;" ></div>
<img id="button0" src="images/AnswerButton00.png" style="position: absolute;width: 160px;height: 53px;left: 780px;top: 590px; overflow:hidden; visibility: visible;" />
<img id="button1" src="images/AnswerButton10.png" style="position: absolute;width: 160px;height: 53px;left: 960px;top: 590px; overflow:hidden; visibility: visible;" />
<img id="button2" src="images/AnswerButton20.png" style="position: absolute;width: 160px;height: 53px;left: 960px;top: 590px; overflow:hidden; visibility: hidden;" />


</body>
<script language="javascript" type="text/javascript">
    <!--
    var focusArea = 0;
    var focusPos0 = 0;
    var focusPos1 = 0;
    var focusPos2 = 0;
    var answer = [1,1,0,0,2,0,2,2,1,0];
    var score = 0;
    var answerFlag = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    var tipFlag = -1;
    var tipFlagFocus = 0;
    var phoneNum = "0";
    var isPhoneError = true;
    var isFirstVote = true;
    var startTime = new Date("2020-09-24 0:0:0").getTime();
    var endTime = new Date("2020-08-12 10:0:0").getTime();

    cursor.initialize({
        data: [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused: [<%= inner.getPreFoucs() %>],
        init: function () {
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl = '<%= backUrl %>';
            cursor.voteId = 	490 ;
            cursor.trafficId = 	491 ;
            for (var i = 0; i < this.data.length; i++) {
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number(this.focused[i + 1]) : 0;
                if(typeof o["data"] != 'undefined'){
                    cursor.focusable[i].items = o["data"];
                }else {
                    cursor.focusable[i].items = [];
                }

            }
            var column = <%= inner.writeObject(column)%>;
            var posters = column.posters['7'];
            cursor.focusable[0] = {focus:0,items:[]};
            for( var i = 0; i < posters.length; i ++ ){
                cursor.focusable[0].items[i] = {
                    'name':'qiustion' +String( i + 1),
                    'posters':{'7':[posters[i]]}
                };
            }
            setTimeout(function(){
                cursor.call('show');},150);
        },
        move : function(index){
        //上 11，下 -11，左 -1，右 1
        var blocked = cursor.blocked;
        var focus = cursor.focusable[0].focus;
        var items = cursor.focusable[0].items;
        cursor.call('loseFocus');
        if (tipFlag < 0){
            if (focusArea == 0){
                if (focusPos0 > 0 && index == 11){  //上
                    focusPos0--;
                }else {
                    if (index == -11) {  //下
                        if (focusPos0 < 2) {
                            focusPos0++;
                        } else if (focusPos0 == 2) {
                            if (focus == 0 || focus == items.length-1){
                                focusPos1 = 1;
                            } else {
                                focusPos1 = 0;
                            }
                            focusArea = 1;
                        }
                    }
                }
            }else if (focusArea == 1){
                if (index == 11){
                    focusArea = 0;
                }else if (index == -1){  //左
                    if (focus > 0 && focusPos1 == 1) {
                        focusPos1 = 0;
                    }
                } else if (index == 1) {  //右
                    if (focus > 0 && focusPos1 == 0){
                        focusPos1 = 1;
                    }
                }
            }
        }else {
            if (tipFlag == 4){
                if (tipFlagFocus == 0 && index == -11) {
                    tipFlagFocus = 1;
                }else if (tipFlagFocus == 1 && index == 11) {
                    tipFlagFocus = 0;
                }
                cursor.call('showTip',tipFlag);
            }
        }
        cursor.call('show');
        },
        show : function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            $("bg").style.backgroundImage = "url("+items[focus].posters['7'][0]+")";
            if (answerFlag[focus] == -1){
                $("answerFlag").style.visibility = 'hidden';
            } else {
                $("answerFlag").style.visibility = 'visible';
                $("answerFlag").style.top = 415+answerFlag[focus]*60+"px";
            }

            if(tipFlag < 0 ){
                if (focusArea == 0){
                    $("focus").style.visibility = 'visible';
                    $("focus").style.top = 395+focusPos0*60+"px";
                    if (focus == 0){
                        $("button0").style.visibility = 'hidden';
                        $("button1").style.visibility = 'visible';
                        $("button0").src = "images/AnswerButton00.png";
                        $("button1").src = "images/AnswerButton10.png";
                    } else if (focus == items.length-1 ) {
                        $("button0").style.visibility = 'visible';
                        $("button1").style.visibility = 'visible';
                        $("button0").src = "images/AnswerButton10.png";
                        $("button1").src = "images/AnswerButton20.png";
                    } else {
                        $("button0").style.visibility = 'visible';
                        $("button1").style.visibility = 'visible';
                        $("button0").src = "images/AnswerButton00.png";
                        $("button1").src = "images/AnswerButton10.png";
                    }
                    $("button"+focusPos1).style.width = '160px';
                    $("button"+focusPos1).style.height = '53px';
                    $("button"+focusPos1).style.top = '590px';
                    $("button"+focusPos1).style.left = 780+focusPos1*190+'px';
                } else if (focusArea == 1){
                    $("button"+focusPos1).style.width = '186px';
                    $("button"+focusPos1).style.height = '79px';
                    $("button"+focusPos1).style.top = '575px';
                    $("button"+focusPos1).style.left = 770+focusPos1*190+'px';
                    $("focus").style.visibility = 'hidden';
                    if (focus == 0){
                        $("button0").style.visibility = 'hidden';
                        $("button1").style.visibility = 'visible';
                        $("button1").src = "images/AnswerButton11.png";
                        // if (focusPos1 == 0 ) {
                        //     $("button0").src = "images/AnswerButton01.png";
                        //     $("button1").src = "images/AnswerButton10.png";
                        // }else {
                        //     $("button0").src = "images/AnswerButton00.png";
                        //     $("button1").src = "images/AnswerButton11.png";
                        // }

                    } else if (focus == items.length-1 ) {
                        $("button0").style.visibility = 'visible';
                        $("button1").style.visibility = 'visible';
                        if (focusPos1 == 0 ) {
                            $("button0").src = "images/AnswerButton01.png";
                            $("button1").src = "images/AnswerButton20.png";
                        }else {
                            $("button0").src = "images/AnswerButton00.png";
                            $("button1").src = "images/AnswerButton21.png";
                        }
                    } else {
                        $("button0").style.visibility = 'visible';
                        $("button1").style.visibility = 'visible';
                        if (focusPos1 == 0 ) {
                            $("button0").src = "images/AnswerButton01.png";
                            $("button1").src = "images/AnswerButton10.png";
                        }else {
                            $("button0").src = "images/AnswerButton00.png";
                            $("button1").src = "images/AnswerButton11.png";
                        }
                    }

                }
            } else {
                if (tipFlag == 4){
                    if (tipFlagFocus == 0){
                        $("tipFlagFocus").style.backgroundImage = "url(images/AnswerButton30.png)"
                        $("tipFlagFocus").style.left = "510px";
                        $("tipFlagFocus").style.top = "420px";
                        $("tipFlagFocus").style.width = "226px";
                        $("tipFlagFocus").style.height = "53px";
                    } else {
                        $("tipFlagFocus").style.backgroundImage = "url(images/AnswerButton31.png)"
                        $("tipFlagFocus").style.left = "500px";
                        $("tipFlagFocus").style.top = "410px";
                        $("tipFlagFocus").style.width = "254px";
                        $("tipFlagFocus").style.height = "81px";
                    }
                }
            }
        },
        input : function(ch){
            if (tipFlag == 4 && tipFlagFocus == 0) {
                getInputNum(ch, "phone");
            }
        },
        loseFocus:function () {
            if (focusArea == 1) {
                // $("button"+focusPos1).src = "images/AnswerButton"+focusPos1+"0.png";
                $("button"+focusPos1).style.width = '160px';
                $("button"+focusPos1).style.height = '53px';
                $("button"+focusPos1).style.top = '590px';
                $("button"+focusPos1).style.left = 780+focusPos1*190+'px';
            }
        },
        select : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;
            if(tipFlag < 0 ){
                if (focusArea == 0){
                    if (answerFlag[focus] != -1 && answerFlag[focus] == focusPos0 ) {
                        answerFlag[focus] = -1;
                    }else {
                        answerFlag[focus] = focusPos0;
                    }
                } else if (focusArea == 1){
                    cursor.call('loseFocus');
                    if (focusPos1 == 0){
                        if (focus > 1) {
                            focus--;
                            focusArea = 0;
                            focusPos0 = 0;
                        }else if (focus == 1){
                            focus--;
                            focusPos1 = 1;
                            focusArea = 0;
                            focusPos0 = 0;
                        }
                    }else if (focusPos1 == 1){
                        if (focus < items.length-1) {
                            focus++;
                            focusArea = 0;
                            focusPos0 = 0;
                        }else {
                            cursor.call('showTip', 4);  //弹出输入电话号框
                            tipFlag = 4;
                            tipFlagFocus = 0;
                        }
                    }
                }
            }else {
                if (tipFlag == 4 && tipFlagFocus == 1 ){
                    if (!isPhoneError){
                        if (isFirstVote == true) {
                            phoneNum = $("phone").innerText;
                            getScore();
                            cursor.call('vote');  //提交电话号和得分
                            cursor.call('loseTip');
                        }
                    }
                }else{
                    cursor.call('loseTip');
                }
            }
            cursor.focusable[0].focus = focus;
            cursor.call('show');
            // if (cursor.blocked == 0){
            //     if (focusPic == 0){
            //         if(tipFlag < 0 ){
            //             var currentTime = new Date().getTime();
            //             if(currentTime < startTime){
            //                 cursor.call('showTip',0);   //还未到时间
            //             }else if (currentTime > endTime) {
            //                 cursor.call('showTip',3);   //已结束
            //             }else{
            //                 cursor.call('isFirstVote',cursor.trafficId);
            //                 setTimeout(function() {
            //                     if (!isFirstVote) {
            //                         cursor.call('vote');  //投票
            //                     } else {
            //                         cursor.call('showTip', 4);   //首次投票，需要输入电话号
            //                     }
            //                 },300);
            //             }
            //         }else {
            //             if( tipFlag == 4 ){
            //                 if ( tipFlagFocus == 1 ) {
            //                     cursor.call('showTip',4);
            //                     if (!isPhoneError){
            //                         phoneNum = $("phone").innerText;
            //                         cursor.call('vote');  //投票
            //                         cursor.call('loseTip');
            //                     }
            //                 }
            //             }else {
            //                 cursor.call('loseTip');
            //             }
            //         }
            //     } else {
            //         cursor.call('selectAct');
            //     }
            // }else {
            //     if( cursor.enlarged ==1 ) {
            //         cursor.enlarged = 0;
            //     }else{
            //         cursor.enlarged = 1;
            //     }
            // }
            cursor.call('show');
        },
        goBack : function(){
            // if( cursor.blocked == 1 && cursor.enlarged ==1 ) {
            //     cursor.enlarged = 0;
            //     cursor.call('show');
            // }else
            if (tipFlag > 0 ){
                var tmp = $("phone").innerText;
                if (tipFlag == 4 && tipFlagFocus ==0 && tmp.length > 1 ){
                    rollBackInputNum("phone");  //回滚手机号
                } else {
                    cursor.call('loseTip');
                }

            }else {
                cursor.call('goBackAct');
            }
        },
        showTip : function(id){
            tipFlag = id;
            $("tooltip").style.backgroundImage = 'url("images/Answer' + String(id) + '.png")';
            $("tooltip").style.visibility = 'visible';
            if ( tipFlag == 4 ){      //输入电话号时，按钮的样式
                var tmp = $("phone").innerText;
                $("tipFlagFocus").style.visibility = 'visible';
                $("tip").style.visibility = 'visible';
                $("tip").innerText = "请输入您的电话号码!";
                $("phone").style.visibility = 'visible';
                if (tmp.indexOf("|") < 0) {
                    if(tipFlagFocus == 0){
                        // if (tmp == " "){
                        tmp = "";
                        // }
                        tmp = tmp+"|";
                        $("phone").innerText = tmp;
                    }
                }else {
                    if(tipFlagFocus != 0){
                        tmp = tmp.substring(0,tmp.length-1);
                        $("phone").innerText = tmp;
                    }
                }
                if (tipFlagFocus == 1){
                    isPhoneError = checkInput("phone","tip");
                    if(!isPhoneError){
                        showTipText("请点击按钮提交!","tip");
                    }
                }
                $("tipFlagFocus").style.backgroundImage = 'url("images/tipFlagFocus' + String(tipFlagFocus) + '.png")';
            }
            // if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            // cursor.moveTimer = setTimeout(function(){
            //     clearTimeout(cursor.moveTimer);
            //     cursor.moveTimer = undefined;
            //     if(tipFlag >= 0 && tipFlag < 4){
            //         cursor.call('loseTip');
            //     }
            // }, 5000);
            if (tipFlag == 2){
                setTimeout(function(){cursor.call('goBackAct');},4000);
            }
        },
        loseTip : function(){
            tipFlag = -1;
            tipFlagFocus = 0;
            $("tooltip").style.visibility = 'hidden';
            $("tip").style.visibility = 'hidden';
            $("phone").style.visibility = 'hidden';
            $("phone").innerText = "";
            $("tipFlagFocus").style.visibility = 'hidden';
        },
        vote : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var currentTime = new Date().Format("yyyy-MM-dd hh:mm:ss");
            var content = "提交时间："+currentTime+"得分："+score;
            voteMsg = {
                // icid:iPanel.cardId,
                icid:iPanel.serialNumber,
                phone: phoneNum,
                total:"false",  //是否返回最新票数总数（可选）
                classifyID:cursor.voteId,  //投票id
                content:encodeURIComponent(content),     //投票内容，中文请通过encodeURIComponent编码（可选）
                voteCount:2,     //总投票数
                compare:"ture",   //比较值（可选，用于实现如指定用户可投票功能）
                contentNum:2,      //对同一内容投票数
                msgContent:""    //(可选，当存在这个值则向当前phone推送一条短信，中文请通过encodeURIComponent编码)
            };
            //     // cursor.focusName = items[focus].name;
            //     (function(target){
            //         var item = items[focus];
            //         cursor.call("sendVote",{
            //             id:cursor.voteId,
            //             target:item.name,
            //             repeat:true,
            //             limit:100,　　//总投票数限制
            //             limitPer:100,//每个人投票限制
            //             callback: function(result){
            // if(result.recode != '002' || result.result == false ) {
            // cursor.call('showTip', 2);  //投票失败,次数超过限制
            // }// } else {
            // cursor.call('showTip', 1);  //投票成功
            // items[focus].voteResult++;
            //     var lastPos = listBox.position;
            //     var lastName = cursor.focusable[0].items[listBox.position].name;
            //     cursor.call('getVoteResult');
            // setTimeout(function(){
            //     for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
            //         if (cursor.focusable[0].items[i].name == lastName) {
            //             listBox.changeList(i-lastPos);
            //             cursor.focusable[0].focus = listBox.position;
            //         }
            //     }
            //     initList(cursor.focusable[0].focus);
            //     $("listButton"+String(listBox.focusPos)).innerText = cursor.focusable[0].items[cursor.focusable[0].focus].voteResult;
            //     cursor.call('show');
            // },800);
            //             }
            //     });
            // })();
            // return;

            var url="http://192.168.18.249:8080/voteNew/external/addVote6.ipanel?icid="+voteMsg.icid+"&phone="+voteMsg.phone+"&classifyID="+voteMsg.classifyID+"&content="+voteMsg.content+"&voteCount="+voteMsg.voteCount+"&contentNum="+voteMsg.contentNum;
            ajax(url, function(result){
                    if( result.recode != "002" || result.result == false ) {
                        //tooltip( decodeURIComponent('投票失败') );  //统计失败
                        cursor.call('showTip', 2);
                        if (currentTime > endTime){
                            cursor.call('showTip', 2);  //投票成功
                        } else {
                            cursor.call('showTip', 22);  //投票成功
                        }
                        return;
                    }else{
                        // tooltip( decodeURIComponent('投票成功') );  //统计成功{"result":true,"recode":"002"}
                        var currentTime = new Date().getTime();
                        // cursor.call('showTip', 1);  //投票成功
                        if (currentTime > endTime){
                            cursor.call('showTip', 1);  //投票成功
                        } else {
                            cursor.call('showTip', 11);  //投票成功
                        }

                        // cursor.call('goBackAct');
                        // if (isFirstVote){
                        //     cursor.call('traffic',cursor.trafficId);
                        // }
                        // // $("phone").innerText = "";
                        // // items[focus].voteResult++;
                        // var lastPos = listBox.position;
                        // var lastName = cursor.focusable[0].items[listBox.position].name;
                        // cursor.call('getVoteResult',cursor.voteId);
                        // setTimeout(function(){
                        //     for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
                        //         if (cursor.focusable[0].items[i].name == lastName) {
                        //             cursor.call('loseFocus');
                        //             listBox.changeList(i-lastPos);
                        //             cursor.focusable[0].focus = listBox.position;
                        //         }
                        //     }
                        //     initList(cursor.focusable[0].focus);
                        //     $("listButton"+String(listBox.focusPos)).innerText = cursor.focusable[0].items[cursor.focusable[0].focus].voteResult;
                        //     cursor.call('show');
                        // },800);
                    }
                },
                {
                    fail:function( meg )
                    {
                        tooltip( decodeURIComponent("fail") );
                        return;
                    }
                }
            );
        },
        getVoteResult : function(voteId){
            var url="http://192.168.18.249:8989/VoteStatistics/getVoteInfo?classifyID="+voteId;
            ajax(url, function(rst){
                    if( rst != "" && rst != 'undefined') {
                        //tooltip( decodeURIComponent('获取投票结果成功') );  //成功
                        for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
                            for (var j = 0;j < rst.length ;j++){
                                // rst[j].name = decodeURIComponent(rst[j].name);
                                if(cursor.focusable[0].items[i].name == rst[j].name){
                                    cursor.focusable[0].items[i].voteResult = rst[j].num;
                                    break;
                                }
                            }
                        }
                        // cursor.focusable[0].items.sort(compare("voteResult",1));
                        sortByKey(cursor.focusable[0].items,"voteResult",1);
                        return true;
                    }else{
                        // tooltip( decodeURIComponent('获取投票结果失败') );  //失败
                        return false;
                    }
                },
                {
                    fail:function( meg )
                    {
                        // tooltip( decodeURIComponent("fail") );
                        return false;
                    }
                }
            );
        },
        isFirstVote : function(voteId){
            var url="http://192.168.18.249:8989/VoteStatistics/getVoteInfo?classifyID="+voteId;
            ajax(url, function(rst){
                    if( rst != "" && rst != 'undefined') {
                        //tooltip( decodeURIComponent('获取投票结果成功') );  //成功
                        for (var j = 0;j < rst.length ;j++){
                            // rst[j].name = decodeURIComponent(rst[j].name);
                            if(iPanel.serialNumber == rst[j].name){
                                isFirstVote = false;
                                break;
                            }
                        }
                        return true;
                    }else{
                        // tooltip( decodeURIComponent('获取投票结果失败') );  //失败或者
                        return false;
                    }
                },
                {
                    fail:function( meg )
                    {
                        // tooltip( decodeURIComponent("fail") );
                        return false;
                    }
                }
            );
        },

    });
    function checkInput(id1,id2){
        var obj = $(id1).innerText;
        // obj = obj.substring(0,obj.length-1)
        var isPhoneError = true;
        if(obj.length == 0 || obj == ""){
            var str = "请输入您的电话号码!";
            showTipText(str,id2);
        }else if(!isTelephone(obj)){
            var str = "号码有误,请重新输入!";
            showTipText(str,id2);
        }else{
            isPhoneError = false;
        }
        // return true;
        return isPhoneError;
    }
    //删除输入的数据
    function delInputNum(id){
        var temp = 	$(id).innerText;
        // if(temp.length  == 0) return;
        // var inputKey = temp.substr(0,temp.length-1);
        $(id).innerText = "请输入您的电话号码!";
    }
    function getScore() {
        for (var i = 0 ; i < answer.length; i++){
            if (answer[i]==answerFlag[i]){
                score=score+10;
            }
        }
        return score;
    }
    -->
</script>
</html>