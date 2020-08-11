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
//    typeId = "10000100000000090000000000116604";
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
        picture = inner.pictureUrl(picture, column.getPosters(), "4");
    }
//    picture = "images/J20200731List1Rule.jpg";


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
<body leftmargin="0" topmargin="0" style="  overflow:hidden; background: transparent <%= isEmpty(picture) ? "url(images/J20200730Bg.jpg)":" url('" + picture + "')" %> no-repeat;" onUnload="exit();">
<div id="tooltip" style="position: absolute;left: 0px; top: 0px;width: 1280px;height: 720px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;">
    <div id="tip" style="position: absolute;left: 410px; top: 240px;width: 400px;height: 60px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #ffffff;font-size: 28px;">
    </div>
    <div id="phone" style="position: absolute;left: 420px; top: 326px;width: 420px;height: 50px;visibility: visible;overflow: hidden; background: no-repeat;z-index: 2;color: #0e0e0b;font-size: 26px;">
    </div>
    <div id="tipFlagFocus" style="position: absolute;left: 510px; top: 420px;width: 226px;height: 53px;visibility: hidden;overflow: hidden; background:transparent url('images/AnswerButton30.png') no-repeat;z-index: 2;">
    </div>
</div>
<div id="focus" style="position: absolute;width: 254px;height: 81px;left: 242px;top: 582px; overflow:hidden; background: url('images/J20200731List1RuleFocus.png') no-repeat;" ></div>
<div id="data" style="position: absolute;width: 521px;height: 292px;left: 698px;top: 90px; overflow:hidden; background: no-repeat;visibility: visible;" ></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    var tipFlag = -1;
    var picPos = 1;
    var codePic = [];
    var startTime = new Date("2020-08-11 0:0:0").getTime();
    var endTime = new Date("2020-08-13 23:59:59").getTime();
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
            cursor.voteId = 490 ;
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
            var posters = column.posters['5'];
            codePic = column.posters['99'];
            // cursor.focusable[0] = {focus:0,typeId:'10000100000000090000000000116603',items:[]};
            for( var i = 0; i < posters.length; i ++ ){
                cursor.focusable[0].items[i] = {
                    'name':'pic' +String( i + 1),
                    'posters':{'5':[posters[i]]},
                    'linkto':'/EPG/jsp/neirong/shang/J20200731List1.jsp?playFlag=1&typeId=10000100000000090000000000116603'
                };
            }
            // cursor.focusable[0].items[0] = {
            //     'name':'答题',
            //     'typeId':'',
            //     'linkto':'/EPG/jsp/neirong/shang/J20200731List1.jsp?playFlag=1&typeId=10000100000000090000000000116603'
            // }
            $("data").style.backgroundImage = "url("+posters[0]+")";
            setInterval(function(){
                var length = posters.length;
                if (picPos < length-1){
                    picPos ++ ;
                } else {
                    picPos = 0 ;
                }
                $("data").style.backgroundImage = "url("+posters[picPos]+")"
            },3000);
        },
        select : function(){
            if (tipFlag == -1){
                var currentTime = new Date().getTime();
                if (currentTime < startTime) {
                    cursor.call('showTip',0);   //还未到时间
                }else if (currentTime > endTime) {
                    cursor.call('showTip',3);   //已结束
                }else {
                    cursor.call('vote');  //判断是否是第一次
                }
            } else {
                cursor.call('loseTip');
            }
        },
        goBack : function(){
            if (tipFlag > 0 ){
                    cursor.call('loseTip');
            }else {
                cursor.call('goBackAct');
            }
        },
        showTip : function(id){
            tipFlag = id;
            if (tipFlag == 99) {
                $("tooltip").style.backgroundImage = 'url(' + codePic[0] + ')';
                // $("tooltip").style.backgroundImage = 'url(images/codePic.jpg)';
                $("tooltip").style.visibility = 'visible';
            }else {
                $("tooltip").style.backgroundImage = 'url("images/Answer' + String(id) + '.png")';
                $("tooltip").style.visibility = 'visible';
            }
            if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
            cursor.moveTimer = setTimeout(function(){
                clearTimeout(cursor.moveTimer);
                cursor.moveTimer = undefined;
                if(tipFlag >= 0 && tipFlag < 4){
                    cursor.call('loseTip');
                }
            }, 3000);
            // cursor.call('show');
        },
        loseTip : function(){
            tipFlag = -1;
            $("tooltip").style.visibility = 'hidden';
        },
        vote : function(){
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;
            var currentTime = new Date().Format("yyyy-MM-dd hh:mm:ss");
            var content = "开始答题时间："+currentTime;
            voteMsg = {
                // icid:iPanel.cardId,
                icid:iPanel.serialNumber,
                phone: "0",
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
                        if( cursor.moveTimer ) clearTimeout(cursor.moveTimer);
                        cursor.moveTimer = setTimeout(function(){
                            clearTimeout(cursor.moveTimer);
                            cursor.moveTimer = undefined;
                            if(tipFlag > 0 && tipFlag < 4){
                                cursor.call('loseTip');
                            }
                        }, 3000);
                        // cursor.call('show');
                        return;
                    }else{
                        cursor.call('selectAct');  //进入答题
                        // tooltip( decodeURIComponent('投票成功') );  //统计成功{"result":true,"recode":"002"}
                        // cursor.call('showTip', 1);  //投票成功
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
        cyclicPic : function () {
            var length = cursor.focusable[0].items[0].posters['5'].length;
            if (picPos < length-1){
                picPos ++ ;
            } else {
                picPos = 0 ;
            }
            $("data").style.backgroundImage = "url("+cursor.focusable[0].items[0].posters['5'][picPos]+")"

        }
    });
    -->
</script>
</html>