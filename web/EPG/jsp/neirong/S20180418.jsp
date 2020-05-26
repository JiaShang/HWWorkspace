<%@ include file="player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%--
    w:宽度
    h:高度
    ih:条目的高度
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
    hm:是否显示首页，0:默认为空值，显示首页按钮，1:只要有任何值均不显示首页按钮
    sc:滚动条样式left,top,heihgt,bgColor,fcColor
--%>
<%
    //首先获取参数中的栏目ID
    String typeId = inner.get("typeId");
    if( isEmpty(typeId ) ) typeId = "10000100000000090000000000107189";

    infos.add(new ColumnInfo(typeId, 0, 99));

    //获取当前栏目的详细信息
    Column column = new Column();
    column = inner.getDetail(typeId,column);
    String picture = column == null ? "" : inner.pictureUrl("",column.getPosters(),"7");

    String[] sc = {};
    Integer w = null, h = null, ih = null, fs = null, lt = null,tp = null,   pg = null, mr = null;
    String cl = null, bc = null,fc = null,bg=null,al=null,hm = null;
    List<List<Vod>> list = null;

    w = !isNumber( inner.get("w") ) ? 237 : Integer.valueOf(inner.get("w"));
    h = !isNumber( inner.get("h") ) ? 73 : Integer.valueOf(inner.get("h"));
    ih = !isNumber( inner.get("ih") ) ? 40 : Integer.valueOf(inner.get("ih"));
    fs = !isNumber( inner.get("fs") ) ? 22 : Integer.valueOf(inner.get("fs"));
    mr = !isNumber( inner.get("mr") ) ? 8 : Integer.valueOf(inner.get("mr"));

    lt = isNumber( inner.get("lft")) ? Integer.valueOf(inner.get("lft")) : ( isNumber( inner.get("lt")) ? Integer.valueOf(inner.get("lt")) : 73 );
    tp = !isNumber( inner.get("tp") ) ? 353 : Integer.valueOf(inner.get("tp"));
    cl = isEmpty( inner.get("cl") ) ? "ffffff" : inner.get("cl");
    fc = isEmpty( inner.get("fc") ) ? "ffffff" : inner.get("fc");
    bc = isEmpty( inner.get("bc") ) ? "F29B87" : inner.get("bc");
    bg = isEmpty( inner.get("bg") ) ? "transparent" : inner.get("bg");
    al = isEmpty( inner.get("al") ) ? "0" : inner.get("al");
    sc = isEmpty( inner.get( "sc" )) ? new String[0] : inner.get("sc").split("\\,");

    pg = isEmpty( inner.get("pg") ) ? list.get(0).size() : Integer.valueOf( inner.get("pg") );
    if( al.equalsIgnoreCase("0")) al = "left";
    else if( al.equalsIgnoreCase("1")) al = "center";
    else al="right";
    h = pg * (ih + mr);
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "一竖排的纯文字列表专题（模板）" : column.getName()%></title>
    <style>
        .bgTop {position: absolute;z-index:0;overflow: hidden; left:0px;top:0px;width:1280px;height:113px;background:transparent url('images/bg-2018-04-18-top.jpg') no-repeat left top;}
        .bgLeft {position: absolute;z-index:0;overflow: hidden; left:0px;top:113px;width:711px;height:280px;background:transparent url('images/bg-2018-04-18-left.jpg') no-repeat left top;}
        .bgRight {position: absolute;z-index:0;overflow: hidden; left:1208px;top:113px;width:72px;height:280px;background:transparent url('images/bg-2018-04-18-right.jpg') no-repeat left top;}
        .bgBottom {position: absolute;z-index:0;overflow: hidden; left:0px;top:393px;width:1280px;height: 359px;background:transparent url('images/bg-2018-04-18-bottom.jpg') no-repeat left top;}

        .flowed {width:<%=w %>px;height:<%= h %>px;top:<%=tp%>px;left:<%=lt%>px;position:absolute;overflow:hidden;}
        .item .container,.focusItem .container{width:<%=w %>px;height:<%=ih %>px;overflow:hidden;background-color:#<%=bg%>;}
        .item,.focusItem{height:<%=ih + mr %>px; color:#<%=cl%>; overflow:hidden;}
        .item .container .inner,.focusItem .container .inner{width:<%= w-20 %>px; height:<%= ih%>px;font-size:<%=fs %>px;line-height:<%= ih-6 %>px; word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;}
        .focusItem .container{background-color:#<%=bc%>;color:#<%=fc%>;}
        .item .container .inner,.focusItem .container .inner{margin:4px 0px 0px 10px;text-align: <%= al%>;}
        .focusItem .marquee{margin:0px 0px 0px 10px;font-size:<%=fs %>px;line-height:<%= ih-6 %>px;}
        .scrollBar,#scrollBarContainer{position:absolute;width:6px;}

        .maskVote {position:absolute;width:166px;height:51px;left:54px;top:394px;background: transparent url('images/mask-2018-04-18.png') no-repeat left top;}

        .voteBg{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .voteBgTooltip{background-position:0px -400px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-size:22px;}
        .txtTooltip{position: absolute;width: 350px;height: 80px;left: 130px;top: 70px;background-color: transparent;color: #ffffff;font-size: 26px;line-height:40px;text-align: center;overflow: hidden;}
        .voteSure{position:absolute;width:117px;height:42px;left:129px;top:179px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .voteCancel{position:absolute;width:116px;height:42px;left:342px;top:180px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
    </style>
    <script language="javascript" type="text/javascript" src="player/common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();">
<div class="bgTop"></div><div class="bgLeft"></div><div class="bgRight"></div><div class="bgBottom"></div>
<%if( sc.length >= 5 ){%>
    <div id='scrollBarContainer' class='scrollBarContainer'><div id='scrollBar'></div></div>
<%}%>
    <div id='flowed' class='flowed'></div>
    <div id='mask' class='maskVote' style="visibility: hidden"></div>
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

            //-----------------------------------      投票功能        -----------------------------------------
            //当前焦点是否在投票按钮上
            cursor.voteBtnFocused = false;
            //当前是否显示投票输入框
            cursor.voteShowInput = false;
            //是否显示投票提示框
            cursor.voteShowTootip = false;
            //输入的手机号码
            cursor.phoneNumber = '' ;
            //-------------------------------------------------------------------------------------------------
            cursor.blocked = this.focused.length > 0 ? Number(this.focused[0]) : 0;
            cursor.backUrl='<%= backUrl %>';
            for( var i = 0; i < this.data.length; i ++){
                var o = this.data[i];
                cursor.focusable[i] = {};
                cursor.focusable[i].typeId = o["id"];
                cursor.focusable[i].focus = this.focused.length > i + 1 ? Number( this.focused[ i + 1] ) : 0;
                cursor.focusable[i].items = o["data"];
            }

            cursor.focusable[1] = {focus:0,items:[{name:'投票按钮',style:'mask'}]};
            cursor.call('show');
            setTimeout("cursor.call('playMovie')",50);
        },
        move : function(index){

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
            var focus = cursor.focusable[blocked].focus;
            var items = cursor.focusable[blocked].items;

            if( blocked === 0 && (index === 1 || index === 11 && focus <= 0 || index === -11 && focus + 1 >= items.length) ||
                blocked === 1 && index !== 1
            ) return;

            if( index === 11 || index === -11 ) {
                focus += index > 0 ? -1 : 1;
            } else if( index == -1 ) {
                blocked = 1; focus = 0;
            } else {
                blocked = 0; focus = cursor.focusable[0].focus;
            }

            cursor.focusable[blocked].focus = focus;
            cursor.blocked = blocked;
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
            if(blocked === 1) {
                if(cursor.voteBtnFocused === true) {
                    var validate = cursor.call("phoneValidate");
                    //手机号码有误
                    if( validate ) {
                        cursor.call("showVoteTooltip","手机号码输入错误！");
                        return;
                    }
                    (function(target){
                        cursor.call("sendVote",{
                            id:411,
                            target:'抢票',
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
            if( blocked === 1 ) {
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
        nextVideo : function (){
            cursor.call('playMovie');
        },
        playMovie : function () {
            try{
                media.video.setPosition(713,113,497,280);
                var id = cursor.focusable[0].items[0].id;
                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + id + "&contentType=0&business=1&baseFlag=0";
                ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        var rtsp = result.playUrl.split("^")[4];
                        media.AV.open(rtsp,"VOD");
                    }
                },{charset:'GBK'});
            } catch (e){}
        },
        show:function(){
            var blocked = cursor.blocked;
            $("mask").style.visibility = blocked === 1 ?'visible':'hidden';
            var items = cursor.focusable[0].items;
            if( items.length <= 0 ) return;
            var focus = cursor.focusable[0].focus;
            //每页显示数量
            var pageCount = <%= pg %>;
            //每页显示数量
            var flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            <% if( sc.length >= 5 ) { %>
            if( items.length <= pageCount ) {
                $("scrollBarContainer").style.visibility = "hidden";
            } else {

                if(  flowCursorIndex + pageCount  >= items.length ) {
                    flowCursorIndex = items.length - pageCount ;
                }

                $("scrollBarContainer").style.visibility = "visible";

                $("scrollBar").className = "scrollBar";

                var scrollBarHeight = <%= sc[2]%>;
                var scrollTop = <%= sc[1]%>;
                var h = Math.ceil( pageCount * 1.0 / items.length * scrollBarHeight);
                $("scrollBar").style.height = h + "px";
                $("scrollBar").style.top = Math.ceil( focus * 1.0 / (items.length - 1) * ( scrollBarHeight - h ) ) + "px";
                $("scrollBar").style.backgroundColor = "#<%= sc[4]%>";
                $("scrollBarContainer").style.left = "<%= sc[0]%>px";
                $("scrollBarContainer").style.top = "<%= sc[1]%>px";
                $("scrollBarContainer").style.height = "<%= sc[2]%>px";
                $("scrollBarContainer").style.backgroundColor = "#<%= sc[3]%>";
            }
            <% } %>
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="' + ( i == focus && blocked === 0 ? 'focusItem' : 'item' ) + '"><div class="container" id="txt' + ( i + 1) + '">';
                html += '<div class="inner">' + item.name + '</div>';
                html +='</div></div>';
            }
            $("flowed").innerHTML = html;
            if( blocked === 0 ) {
                (function(id,value){
                    cursor.calcStringPixels(value, <%= fs %>, function(pixelsWidth){
                        var innerHTML = pixelsWidth >  <%= w-20 %> ? ('<marquee class="marquee" scrollamount="10">' + value + "</marquee>") : '<div class="inner">' + value + '</div>' ;
                        $(id).innerHTML = innerHTML;
                    });
                })('txt' + (focus + 1),items[focus].name);
            }
        }
    });
    -->
</script>
</html>