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
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "images/bg-2018-06-19.jpg" : inner.pictureUrl("images/bg-2018-06-19.jpg",column.getPosters(),"7");

    String bc = null,fc = null;
    Integer tp = null,ct=null;
    ct = isEmpty( inner.get("ct") ) ? 5 : Integer.valueOf( inner.get("ct") );
    tp = isEmpty( inner.get("tp") ) ? 383 : Integer.valueOf( inner.get("tp") );
    fc = isEmpty( inner.get("fc") ) ? "fdfa00" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "fdfa00" : inner.get("bc");
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "一横排专区模板, 默认5个方框" : column.getName()%></title>
    <style>
        .item{ width:208px;height:285px;margin:0px 6px; float: left;}
        .itemContainer{width:200px;height:245px; position:relative;}
        .item .image{ width:200px;height:245px;left:0px;top:7px;position:relative;background:transparent url('images/mask-TempRowYellow.png') no-repeat -6px -10px;padding:3px 10px 3px 10px;}
        .maskImage{width:178px;height:232px;left:5px;top:5px;position:relative; border:solid 5px #<%=bc%>;}
        .text {width:190px;height:35px; font-size:22px; color:#fee5f0; line-height:32px; position:relative;left:5px;text-align: center;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .flowed {width:1200px;left:89px;top:<%=tp %>px;height:285px;overflow:hidden;position: absolute;}

        .mask {position:absolute;height:60px;top:283px;background:transparent url('images/mask-2018-06-19.png') no-repeat 0px 0px;background-position: 0px 0px;}
        .mask1 {width:428px;left:628px;background-position: 0px 0px;}
        .mask2 {width:92px;left:1068px;top:285px;background-position: 0px -80px;}


        .voteBg{position:absolute;width:1280px;height:720px;left:0px;top:0px;background:transparent url("images/forcusBg-2018-06-19-1.png") no-repeat 0px 0px; background-position:0px 0px;}
        .voteBgTooltip{background:transparent url("images/forcusBg-2018-06-19-2.png") no-repeat 0px 0px; }
        .phoneNumberInput{position:absolute; width:404px;height:41px; left:643px; top:292px; background-color:transparent;color:black;font-size:28px;line-height: 40px;}
        .txtTooltip{position: absolute;width: 595px;height: 80px;left: 347px;top: 314px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black<%= isEmpty(picture) ? "" : (" url(" + picture + ")")%> no-repeat;" onUnload="exit();">
<div id='flowed' class='flowed'></div>
<div class='phoneNumberInput' id='phoneNumberInput'></div>
<div id='mask'></div>
<div id='voteResultDialog' class='voteBg' style="visibility: hidden"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        data : [<%
                String html = "";
                for ( int i = 0; i < infos.size(); i++) {
                    ColumnInfo info = infos.get(i);
                    Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
                    html += inner.resultToString(result);
                    if( i + 1 < infos.size() ) html += ",\n";
                }
                out.write(html);
            %>],
        focused : [<%= inner.getPreFoucs() %>],
        init : function(){
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';

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
            cursor.voteBlocked = 1;
            //-------------------------------------------------------------------------------------------------

            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }
            cursor.focusable[1] = {focus:0,items:[
                {name:"手机号输入"},
                {name:"投票"}
                ]};
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
                /*if( current >= '2018-06-27 00:00:00') {
                    cursor.call("showVoteTooltip","当前活动已结束，谢谢参与！");  return;
                }*/
                var validate = cursor.call("phoneValidate");
                //手机号码有误
                if( validate ) {
                    cursor.call("showVoteTooltip","手机号码输入错误, 请重新正确输入！");
                    return;
                }
                (function(target){
                    cursor.call("sendVote",{
                        id:421,
                        target:'母亲节',
                        repeat:false,
                        callback: function(result){
                            cursor.voteShowInput = false;
                            if(result.recode != '002' || result.result == false ){
                                cursor.call("showVoteTooltip","您已参与过活动，不能重复参与！");
                            } else {
                                cursor.call("showVoteTooltip","您已成功对参与活动！");
                            }
                            return false;
                        }
                    });
                })();
                return;
            }
            cursor.call("selectAct");
        },
        goBack:function(){
            var blocked = cursor.blocked;
            if( cursor.voteShowTootip ) { cursor.call("hideVoteToolTip"); return; }
            if( cursor.voteShowInput && cursor.phoneNumber.length >= 0 ) {
                cursor.phoneNumber = cursor.phoneNumber.substr(0, cursor.phoneNumber.length - 1);
                $("phoneNumberInput").innerText = cursor.phoneNumber;
                return;
            }
            if( cursor.blocked === 1 ) return;
            cursor.call("goBackAct");
        },
        //------------------------------------------------------------------------------------------------

        move : function(index){
            //上 11，下 -11，左 -1，右 1
            var blocked = cursor.blocked;
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && ( index === -11 || index === -1 && focus <= 0 || index === 1 && focus + 1 >= items.length) || blocked == 1 && ( index == 11 || index == -1 && focus <= 0 || index == 1 && focus >= 1 )) return;
            if( index == 1 || index == -1 ) {
                focus += index;
            } else {
                blocked = index == 11 ? 1 : 0;
                focus = cursor.focusable[blocked].focus;
            }
            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
            cursor.voteShowInput = (blocked == 1 && focus == 0);
            cursor.call('show');
        },
        show:function(){
            var focus = cursor.focusable[0].focus;
            var items = cursor.focusable[0].items;

            $("mask").className = "mask mask" + (cursor.focusable[1].focus + 1);
            $("mask").style.visibility =  cursor.blocked == 0 ? "hidden" : "visible";

            if( items.length <= 0 ) return;

            //每页显示数量
            var pageCount = <%= ct %>;
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item"><div class="itemContainer">';
                html += '<div class="' + ( cursor.blocked == 0 && i == focus ? 'maskImage' : 'image' ) + '">';
                html += '<img src="' + cursor.pictureUrl(item.posters,1) + '" style="width:178px;height:232px;"/>'
                html += '</div>';
                html += '<div class="text" id="txt' + (i + 1) + '"' + ( cursor.blocked == 0 && i == focus ? ' style="color:#<%=fc%>;top:6px;"' : '' ) + '>';
                html += item.name;
                html +='</div></div></div>';
            }
            $("flowed").innerHTML = html;

            if( cursor.blocked == 0 ){
                (function(id,value){
                    cursor.calcStringPixels(value, 22, function(pixelsWidth){
                        var innerHTML = pixelsWidth > 190 ? ('<marquee class="maskMarquee" scrollamount="10">' + value + "</marquee>") : value ;
                        $(id).innerHTML = innerHTML;
                    });
                })('txt' + (focus + 1),items[focus].name);
            }
        }
    });
    -->
</script>
</html>