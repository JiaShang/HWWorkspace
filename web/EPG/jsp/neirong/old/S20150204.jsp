<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000104906"};
    final int[] position = {9,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    List<List<Vod>> list = null;

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");

        if(null == playBack){
            if(null == fcr)
                turnPage.addUrl();
            else{
                turnPage.removeLast();
                turnPage.addUrl();
            }
        }
        else{
            turnPage.removeLast();
        }

        // 返回时获取焦点信息数据
        String[] focus = turnPage.getPreFoucs();
        if(null != focus ){
            if( focus.length > 0 && focus[0] != null )
                area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                focused = Integer.parseInt(focus[1]);
        }

        backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        list = new ArrayList<List<Vod>>();
        int i = 0;
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type,position[i], position[i+1]);
            list.add( ls );
            i++;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>寒假补剧班之青春欧巴</title>
<style>
    .mask {height: 30px;position:absolute;background:transparent url('images/mask-2015-02-04.png') no-repeat fixed;background-position: 0px 0px;}
    .mask1{width: 95px;left:91px; top:234px;background-position: 0px 0px;}
    .mask2{width: 142px;left:302px; top:234px;background-position: 0px -30px;}
    .mask3{width: 97px;left:1021px; top:232px;background-position: 0px -60px;}
    .mask4{width: 97px;left:544px; top:331px;background-position: 0px -90px;}
    .mask5{width: 97px;left:768px; top:364px;background-position: 0px -120px;}
    .mask6{width: 119px;left:972px; top:365px;background-position: 0px -150px;}
    .mask7{width: 120px;left:594px; top:491px;background-position: 0px -180px;}
    .mask8{width: 163px;left:794px; top:490px;background-position: 0px -210px;}
    .mask9{width: 96px;left:1042px; top:491px;background-position: 0px -240px;}

    .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
    .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
    .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
    .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
    .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
    .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
    .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

    .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat fixed 0px 0px;}
    .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
    .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -300px;}
    .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -350px;}

    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
    .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
    var blocked = blocked ? blocked : <%= area %>;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
    //弹出对话框中最大列表数量
    var popMaxItemsLength = 6;
    //是否包含小视频
    var hasSmallVideo = false;
    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
        <%
        value = "";
        final String[][] actions = {"[0,0,0,3,0,0,0,1]|[0,1,0,3,0,0,0,2]|[0,2,0,5,0,1,0,2]|[0,1,0,6,0,3,0,4]|[0,1,0,7,0,3,0,5]|[0,2,0,8,0,4,0,5]|[0,3,0,6,0,6,0,7]|[0,4,0,7,0,6,0,8]|[0,5,2,0,0,7,0,8]".split("\\|")};
        if( list != null && list.size() > 0){
            for(int i = 0; i < list.size() ; i ++){
                value += "{focus:0,typeId:'" + types[i] + "',items:[";
                List<Vod> vodList = list.get(i);
                for( int j = 0; j < vodList.size() && j < 9 ; j++ ){
                    Vod vod = vodList.get(j);
                    String str = "{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                             "length:" + StringUtil.length(vod.getName()) + "," +
                          "shortText:'" + StringUtil.limitStringLength(vod.getName(),popItemMaxCharLength) + "'," +
                             "action:" + actions[i][j] + "," +
                              "style:'mask mask" + (j + 1) + "'" +
                           "playType:" + vod.getIsSitcom() ;
                    str += "}" + ( j + 1 < vodList.size()  ? "," : "");
                    value += str;
                }
                value += "]},";
                out.write(value);
            }
        }
        %>
        { focus:0, vote:true, items : [
            {name:'input'},
            {name:'确定',style:'btnSure'},
            {name:'取消',style:'btnCancel'}
        ]},
        { focus:0, items : [
            {name:'首页',style:'btnHome',action:[0,8,2,0,2,0,2,1]},
            {name:'返回',style:'btnReturn',action:[0,8,2,1,2,0,2,1]}
        ]}
    ];
    var backUrl = '<%= backUrl %>';
    function focused(index,initilized){
        var focus = focusable[blocked].focus, previous = 0;
        var item =  focusable[blocked].items[focus];
        if(typeof index == "number" && !initilized){
            //上:11,下:-11,左-1,右1
            if(
                //如果焦点在投票的返回，或右下角的返回上，或者在浮动层上时,光标按右键直接返回
                blocked == focusable.length - 1 && (index == -11 || focus == 1 && index == 1 || focus == 0 && index == -1 /*|| index == 11 */) ||
                //如果焦点在投票上,按上下左右键时
                (blocked == focusable.length - 2 && ( $.vote.tooltiped || focus == 2 && index == 1 || focus <= 1 && index == -1 || focus == 0 && index == 11 || focus >= 1 && index == -11)) ||
                //或者焦点在浮动层上, 按上下左右键时，
                focusable[blocked].popuped && ( focus <= 0 && index == 11 || focus >= focusable[blocked].items.length - 1 && index == -11 || index == -1 || index == 1 )
            ) return;
            if( index == 1 && ( !$.vote.tooltiped && blocked == focusable.length - 2 && focus == 1 || blocked == focusable.length - 1 && focus == 0 ))
                focus = focus + 1;
            else if( index == -1 && ( ! $.vote.tooltiped && blocked == focusable.length - 2 && focus == 2 || blocked == focusable.length - 1 && focus == 1))
                focus = focus - 1;
            else if( focusable[blocked].popuped ) { focus += index > 0 ? -1 : 1;  }
            else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("mask").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0; $("mask").style.visibility = 'hidden';} ;}
            else {
                if(index == 11) {
                    blocked = item.action[0];
                    focus = item.action[1];
                } else if(index == -11){
                    blocked = item.action[2];
                    focus = item.action[3];
                } else if(index == -1){
                    blocked = item.action[4];
                    focus = item.action[5];
                } else {
                    blocked = item.action[6];
                    focus = item.action[7];
                }
            }
            focusable[blocked].focus = focus;
        } else if( initilized ){
            if( blocked == focusable.length - 2 && $.vote.voted ) return;
            focusable[blocked].focus = focus = previous = index;
        }
        var item =  focusable[blocked].items[focus];
        if(typeof item != 'undefined' && typeof item.style == 'string' )
            $('mask').className = item.style;
    }
    function goBack(){
        if( blocked == focusable.length - 2) {if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();};
        if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
        if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
            blocked = focusable[blocked].backed;
            focused(focusable[blocked].focus, true);
            return;
        }
        top.window.location.href = focusable[blocked].focus == 0 || EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}
        //首页，返回
        if( blocked == focusable.length - 1) { goBack(); return;}
        if( blocked == focusable.length - 2 ) { $.vote(); return; }
        var item =  focusable[blocked].items[focusable[blocked].focus];
        if( item.playType == -1){
            focusable[item.blocked].backed = blocked;
            blocked = item.blocked;
            focused(focusable[blocked].focus, true);
            return;
        } else if( item.playType == -2){
            $.vote.current = {};
            $.vote.current.id = typeof item.voteId == 'undefined' ? focusable[blocked].voteId : item.voteId;
            $.vote.current.message = typeof item.text == 'undefined' ? item.name : item.text;
            focusable[focusable.length - 2].backed = blocked;
            blocked = focusable.length - 2;
            $.vote();
            focused(focusable[blocked].focus, true);
        } else {
            var typeId = focusable[blocked].typeId;
            if( item.playType == 1)
                top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/hjzq/hj_tvDetail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
            else {
                top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
            }
        }
    }
    function init(){
        String.prototype.trim=function(){return this.replace(/(^\s*)|(\s*$)/g, "");}
        String.prototype.ltrim=function(){return this.replace(/(^\s*)/g,"");}
        String.prototype.rtrim=function(){return this.replace(/(\s*$)/g,"");}
        String.prototype.endWith=function(str){
            if(str==null||str==""||this.length==0||str.length>this.length)
                return false;
            return this.substring(this.length-str.length) === str;
        }
        String.prototype.startWith=function(str){
            if(str==null||str==""||this.length==0||str.length>this.length)
                return false;
            return  this.substr(0,str.length) === str;
        }
        String.prototype.isEmpty = function(){  return (/^\s*$/.test(this)); };
        if( typeof $ == "undefined" ){
            $ = function (objectId) {
                if(document.getElementById && document.getElementById(objectId)) {
                    return document.getElementById(objectId);
                } else if (document.all && document.all(objectId)) {
                    return document.all(objectId);
                } else if (document.layers && document.layers[objectId]) {
                    return document.layers[objectId];
                } else {
                    return false;
                }
            };
        }
        if( typeof iPanel == "undefined" ) {
            document.onkeydown = function(event){
                switch (event.keyCode) {
                    case 38: focused(11, false);break;      //上光标键
                    case 40:focused(-11, false);break;      //下光标键
                    case 37:focused(-1, false);break;       //左光标键
                    case 39:focused(1, false);break;        //右光标键
                    case 13: doEnter(); break;              //选择回车键
                    case "KEY_BACK":goBack();break;
                    case "KEY_EXIT":
                    case "KEY_MENU":top.window.location.href = iPanel.eventFrame.portalUrl; return 0;break;
                }
            }
        }
        if( typeof $.ajax === 'undefined') {
            $.ajax = function(url,callback,options){
                if( typeof  url === 'undefined' ) return;
                if(typeof  options === 'undefined')options = {};

                if(typeof options.method === 'undefined' ) options.method = "GET";
                if( typeof options.async === 'undefined' ) options.async = true;
                var request = new XMLHttpRequest();
                request.onreadystatechange = function (){
                    if(request.readyState ===4){
                        if(request.status ===200 && typeof callback === 'function' ){
                            var responseText = request.responseText;
                            var result = (new Function("return " + responseText))();
                            callback( result );
                        }
                        else{request.abort();}
                    }
                }
                request.open(options.method, url, options.async);
                request.send(null);
            };
        }
        $.popupShow = function(){
            var focus =  focusable[blocked].focus;
            var items = focusable[blocked].items;
            $("page").innerText = (Math.ceil((focus + 1) / popMaxItemsLength) + "/" + Math.ceil(items.length / popMaxItemsLength));
            if($("popuped").style.visibility == "hidden") $("popuped").style.visibility = "visible";
            var html = "";
            for(var i = 0; i < items.length ; i ++ ){
                var vod = items[i];
                html += "<div class='" + ( focus == i ? "maskItem" : "item") + "'>" +
                (vod.length <= <%= popItemMaxCharLength %> || focus != i ? vod.shortText : ("<marquee class='marqueed'>" + vod.text + "</marquee>")) +
                "</div>";
            }
            $("popupContent").innerHTML = html;
            $("popupContent").style.marginTop = "-" + (Math.floor(focus / popMaxItemsLength) * popMaxItemsLength * 51) + "px";
        }
        $.video = {};
        $.video.id = undefined;
        $.video.position = undefined;
        $.video.play = function(){
            try{
                if(typeof $.video.id != "string" || $.video.id.isEmpty() || typeof iPanel === 'undefined') return;
                var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0&idType=FSN";
                $.ajax(rtspUrl,function(result){
                    if( result.playFlag === "1"){
                        var rtsp = result.playUrl.split("^")[4];
                        media.AV.open(rtsp,"VOD");
                    }
                });
            } catch (e){}
        }
        $.video.start = function(){
            try { if(typeof ($.video.id) === "string" && !$.video.id.isEmpty()) media.AV.play(); } catch (e) {}
        };
        $.vote = function (){
            if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
            //如果显示了提示框，取消提示框的显示，重新显示输入框
            if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
            if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) {goBack(); return; }
            else {
                if( $.vote.validate() ) {$.vote.tooltip(); return; }
                //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                var cardId = CA.card.serialNumber;
                var url = "http://192.168.9.79:8021/voteNew/external/addVote.ipanel?icid=" + cardId + "&repeat=false&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&content=" + encodeURIComponent($.vote.current.message);
                $.ajax(url,function(result){
                    if(result.recode != '002' || result.result == false ){
                        $.vote.voted = result.result == false;
                        $.vote.tooltip($.vote.fail);
                    } else {
                        $.vote.voted = true;
                        $.vote.tooltip($.vote.success);
                    }
                });
            }
        };
        $.vote.voted = false;
        $.vote.current = undefined;
        $.vote.status = undefined;
        $.vote.phone = undefined;
        $.vote.tooltiped = false;
        $.vote.error = "手机号码不正确！";
        $.vote.fail = "您已参与过投票！";
        $.vote.success = "投票成功！";
        $.vote.input = function (id ,num){
            if(typeof $.vote.status  != 'boolean' || !$.vote.status || $.vote.phone.length >=11)return;
            $.vote.phone += num;
            $(id).innerText = $.vote.phone;
        };
        $.vote.delete = function(id){
            if($.vote.phone.length==0)return;
            $.vote.phone = $.vote.phone.substr(0,$.vote.phone.length-1);
            $(id).innerText = $.vote.phone;
        };
        $.vote.validate = function(){
            var reg = /^1[3|4|5|8][0-9]\d{8}$/gi;
            return !reg.test($.vote.phone);
        };
        $.vote.show = function(){
            focusable[blocked].focus = 0;
            $.vote.phone = "";
            $.vote.tooltiped = false;
            $.vote.status = true;
            $("phoneNumber").innerHTML = "";
            $("mask").style.visibility = "hidden";
            $("votePop").style.visibility = "visible";
            $("votePop").style.backgroundPosition = "0px 0px";
        };
        $.vote.hidden = function(className){
            $.vote.status = false;
            $.vote.tooltiped = false;
            $.vote.current = undefined;
            $("mask").style.visibility = "visible";
            $("votePop").style.visibility = "hidden";
        };
        $.vote.tooltip = function(message){
            if( typeof  message == 'undefined' ) message = $.vote.error;
            $.vote.status = false;
            $.vote.tooltiped = true;
            $("phoneNumber").innerHTML = message;
            $("votePop").style.backgroundPosition = "0px -400px";
            $("votePop").style.visibility = "visible";
            $("mask").style.visibility = "hidden";
        };
        //用来记录输入电话号码框的数组顺序及焦点
        $.vote.focus = {}
        $.current = function (){
            return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
        };
        $.buildUserInterface = function(option){
            var html = "";
            if( typeof option.vote != 'undefined' ){
                html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                for(var i=0; i < option.vote.length; i++) {
                    if(typeof option.vote[i].item == 'undefined' )
                        focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                    else
                        focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                };
            }
            html += "<div id='mask'></div>";
            if(typeof option.popup != 'undefined'  ){
                html += "<div class='popuped' id='popuped' style='visibility:hidden'><div class='container'  id='popupContainer'><div class='content' id='popupContent'></div></div><div class='page' id='page'>1/1</div></div>";
                for(var i = 0; i< option.popup.length; i++) focusable[option.popup[i]].popuped = true;
            }
            if ( typeof option.video != 'undefined' ){
                $.video.id = option.video;
                $.video.position = option.position;
            }
            document.body.innerHTML = html;
        }
        //video:'视频ID'
        //position:[0,0,0,0]:视频显示坐标
        //vote:[0,0] ,投票ID,0:0
        //popup:是否包含弹出对话框
        $.buildUserInterface({popup:undefined,vote:undefined,video:undefined,position:undefined});
        focused(<%= focused %>, true);
    }
    function eventHandler(eventObj, __type){
        switch(eventObj.code){
            case "KEY_UP":focused(11, false);break;
            case "KEY_DOWN":focused(-11, false);break;
            case "KEY_LEFT":focused(-1, false);break;
            case "KEY_RIGHT":focused(1, false);break;
            case "KEY_SELECT":doEnter();break;
            case "KEY_NUMERIC":$.vote.input("phoneNumber", eventObj.args.value);break;
            case "KEY_BACK": goBack();break;
            case "KEY_EXIT":
            case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
            case "VOD_PREPAREPLAY_SUCCESS":$.video.start();break;
            case "EIS_VOD_PROGRAM_END":$.video.play();break;
        }
        return 	eventObj.args.type;
    }
    function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
    window.onload = function(){setTimeout("init()",100);}
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-02-04.jpg') no-repeat;" onUnload="exit();"></body>
</html>