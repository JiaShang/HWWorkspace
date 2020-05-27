<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000109522";
    infos.add(new ColumnInfo(typeId, 0, 2));
    infos.add(new ColumnInfo(typeId, 2, 2));
    infos.add(new ColumnInfo(typeId, 4, 5));
    int block = 0;
    String saved =  inner.getPreFoucs();
    if( !isEmpty( saved )) block = Integer.parseInt(saved.split(",")[0]);
    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask{width:279px;height:341px;position:absolute;background:transparent url("images/mask-2018-05-11.png") no-repeat 0px 0px; background-position: 0px 0px;}
        .mask11 {left:798px;top:355px;}
        .mask12 {left:991px;top:355px;}

        .mask21 {left:798px;top:355px;}
        .mask22 {left:991px;top:355px;}

        .mask31 {left:605px;top:355px;}
        .mask32 {left:798px;top:355px;}
        .mask33 {left:991px;top:355px;}

        .mask41 {left:605px;top:84px;}
        .mask42 {left:798px;top:84px;}
        .mask43 {left:991px;top:84px;}
        .mask44 {left:605px;top:355px;}
        .mask45 {left:798px;top:355px;}
        .mask46 {left:991px;top:355px;}

        .maskVote {width:128px;height:32px;left:470px;top:523px;background-position:0px -350px;}


        .voteBg{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .voteBgTooltip{background-position:0px -400px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-size:22px;}
        .txtTooltip{position: absolute;width: 350px;height: 80px;left: 130px;top: 70px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}
        .voteSure{position:absolute;width:117px;height:42px;left:129px;top:179px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .voteCancel{position:absolute;width:116px;height:42px;left:342px;top:180px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2018-05-11-<%=block + 1%>.jpg') no-repeat;" onUnload="exit();">
<div id="mask"></div>
<div id='voteResultDialog' class='voteBg' style="visibility: hidden"></div>
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
            //-----------------------------------      投票功能        -----------------------------------------
            //当前焦点是否在投票按钮上
            cursor.voteBtnFocused = false;
            //当前是否显示投票输入框
            cursor.voteShowInput = false;
            //是否显示投票提示框
            cursor.voteShowTootip = false;
            //输入的手机号码
            cursor.phoneNumber = '' ;
            //投票焦点所在块
            cursor.voteBlocked = 4;
            //-------------------------------------------------------------------------------------------------


            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            cursor.pageSize = 5;
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].items = o["data"];
            }

            var links = [
                {name:'妈妈是超人3',linkto:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=bc5da60f5bab9d5d214bed9fa0baf796', linkandr:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###E1102319###video_type###0###video_ui_style###0'},
                {name:'妈妈是超人2',linkto:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=49c7b8ba1ba7b8c2b1446aeeaf9ebad2', linkandr:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###E1590461###video_type###0###video_ui_style###0'},
                {name:'妈妈是超人1',linkto:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5aaf70961bf59b7e61058dc7006a0733', linkandr:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###E2112583###video_type###0###video_ui_style###0'},
                {name:'神秘巨星',linkto:'http://192.168.17.42:8100/cq_coshipdemo/detail.jsp?arg=3467430&resultUrl=http://192.168.17.42:8100/cq_coshipdemo/index.jsp'}
            ];

            var o = {focus: 0, items : []};
            o.items.push(links[0]);
            o.items.push(links[1]);
            o.items.push(links[2]);

            cursor.focusable.insertAt(2,o);
            cursor.focusable[cursor.focusable.length - 1].items.push(links[3]);
            cursor.focusable.push({focus:0,items:[{"name":"投票"}]});
            for(var i = 0 ; i < cursor.focusable.length; i ++){
                cursor.focusable[i].focus = this.focused[i + 1] || 0;
            }
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
        hideVoteInput : function () {
            $("voteResultDialog").style.visibility = "hidden";
            cursor.voteShowInput = false;
            cursor.voteBtnFocused = false;
            cursor.voteShowTootip = false;
        },
        showVoteInput : function(message){
            cursor.voteShowInput = true;
            var html = "<div class='phoneNumberInput' id='phoneNumberInput'>" + cursor.phoneNumber + "</div>";
            html += "<div class='" + (cursor.voteBtnFocused ? 'voteSure' : 'voteCancel') + "'></div>";
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
            //如果显示了提示框，隐藏提示框
            if( cursor.voteShowTootip ){cursor.call("hideVoteToolTip"); return;}
            if(blocked === cursor.voteBlocked) {
                if(cursor.voteBtnFocused === true) {
                    var validate = cursor.call("phoneValidate");
                    //手机号码有误
                    if( validate ) {
                        cursor.call("showVoteTooltip","手机号码输入错误！");
                        return;
                    }
                    (function(target){
                        cursor.call("sendVote",{
                            id:418,
                            target:'母亲节',
                            repeat:false,
                            callback: function(result){
                                cursor.voteShowInput = false;
                                if(result.recode != '002' || result.result == false ){
                                    cursor.call("showVoteTooltip","您已参与过活动，不能重复参与！");
                                } else {
                                    cursor.call("showVoteTooltip","您已成功对参与活动！");
                                }
                            }
                        });
                    })();
                    return;
                }
                if( cursor.voteShowInput && cursor.voteBtnFocused === false ) {
                    cursor.call("hideVoteInput");
                    return;
                }
                cursor.voteBtnFocused = true;
                if( !cursor.voteShowInput) cursor.call("showVoteInput");
                return;
            }
            cursor.call("selectAct");
        },
        goBack:function(){
            var blocked = cursor.blocked;
            if( cursor.voteShowTootip ) { cursor.call("hideVoteToolTip"); return; }
            if( blocked === cursor.voteBlocked ) {
                if( cursor.voteShowInput && ( !cursor.voteBtnFocused || cursor.phoneNumber.length <= 0 ) ){ cursor.call("hideVoteInput"); return;}
                if( cursor.voteShowInput ) {
                    cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1)
                    cursor.call("showVoteInput");
                    return;
                }
            }
            cursor.call("goBackAct");
        },
        //------------------------------------------------------------------------------------------------
        move        :   function(index){
            //上 11，下 -11，左 -1，右 1
            //-----------------------------------      投票功能        -----------------------------------------
            if( cursor.voteShowTootip ) return;
            if( cursor.voteShowInput ) {
                cursor.voteBtnFocused = !cursor.voteBtnFocused;
                cursor.call("showVoteInput");
                return;
            }
            //------------------------------------------------------------------------------------------------

            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var previous = blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked <= 2 && ( index == -1 && focus <= 0 || index == 1 && focus + 1 >= items.length ) || index == 11 && blocked == 0 || index == -11 && blocked == 3 && focus >= 3  || index == 1 && (blocked == 3 && ( focus == 2 || focus + 1 >= items.length ) || blocked == 4 && index != 1) ) return;
            if( index == 1 || index == -1 ) {
                if( index == -1 && blocked == 3 && (focus == 0 || focus == 3) ) {
                    blocked = 4; focus = 0;
                } else if(blocked == 4 && index == 1){
                    blocked = 3; focus = cursor.focusable[blocked].focus;
                } else
                    focus += index;
            } else if( index == 11 ){
                if( blocked == 3 && focus >= 3 ) {
                    focus -= 3;
                } else {
                    blocked -= 1; focus = cursor.focusable[blocked].focus;
                }
            } else if( index == -11 ) {
                if( blocked == 3 && focus < 3 ) {
                    focus += 3;
                } else {
                    blocked += 1; focus = cursor.focusable[blocked].focus;
                }
            }

            if( previous != blocked && blocked != 4 ) {
                document.body.style.backgroundImage = 'url("images/bg-2018-05-11-' + (blocked + 1) + '.jpg")';
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.call('show');
        },
        show        :   function(){
            var block = cursor.blocked;
            var focus = cursor.focusable[block].focus;
            $("mask").className = block == 4 ? ("mask maskVote") : ("mask mask" + (block + 1) + (focus + 1));
        }
    };
    cursor.initialize(initialize);
    -->
</script>
</html>