<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    if(  typeId == null || typeId.trim().length() == 0 )
        typeId = "10000100000000090000000000104727";

    int length = 7, start = 0;
    int focused = 0;
    int area = 0;
    String backUrl = "";
    String value = "";
    String fromEPG = "";
    List<Vod> list = null;

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
        list = getVodList( metaHelper, typeId, length, start );
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
<title>我们一起过暖冬</title>
<style>
    .mask {position:absolute;background:transparent url('images/mask-2014-12-15.png') no-repeat fixed 0px 0px;}
    .mask1 {width:314px;height:54px;left:363px; top:147px;background-position: 0px 0px;}
    .mask2 {width:323px;height:60px;left:849px; top:142px;background-position: 0px -60px;}
    .mask3 {width:254px;height:51px;left:359px; top:212px;background-position: 0px -120px;}
    .mask4 {width:358px;height:62px;left:852px; top:201px;background-position: 0px -180px;}
    .mask5 {width:254px;height:48px;left:364px; top:494px;background-position: 0px -240px;}
    .mask6 {width:324px;height:51px;left:369px; top:550px;background-position: 0px -300px;}
    .mask7 {width:289px;height:50px;left:369px; top:611px;background-position: 0px -360px;}
    .maskX1 {width:233px;height:86px;left:781px; top:429px;background-position: 0px -420px;}
    .maskX2 {width:233px;height:86px;left:999px; top:439px;background-position: 0px -520px;}

    .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat fixed; background-position:0px 0px;}
    .btnSure{position:absolute;width:117px;height:42px;left:491px;top:379px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -300px;}
    .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -350px;}
    .phoneNumberInput{position:absolute; width:218px;height:22px; left:192px; top:120px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}

    .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px;height:41px;background-position: 0px 0px;}
    .btnReturn {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:1066px; width:161px; height:41px;background-position: 0px -42px;}
</style>
<script language="javascript" type="text/javascript">
    <!--
    try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

    var blocked = blocked ? blocked : <%= area %>;
    var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
    //可获得焦点的区域个数
    var focusable = focusable ? focusable : [
        { focus:0, items : [
            <%
                String[] actions = "[0,0,0,2,0,0,0,1]|[0,1,0,3,0,0,0,1]|[0,0,0,4,0,2,0,3]|[0,1,1,0,0,2,0,3]|[0,2,0,5,0,4,1,0]|[0,4,0,6,0,5,0,5]|[0,5,0,6,0,6,2,0]".split("\\|");
                if( list != null && list.size() > 0){
                  for( int i = 0; i< list.size() && i < 8; i ++) {
                     Vod vod = list.get(i);
                     out.write("{ mid:'" + vod.getId() + "'," +
                               "text:'" + vod.getName() + "'," +
                           "playType:" + vod.getIsSitcom() + "," +
                             "action:" + actions[i] + "," +
                              "style:'mask mask" + (i + 1) + "'" +
                         "}" +  ( i + 1 < list.size() ? "," : ""));
                  }
                  out.flush();
            }
            %>
        ]},
        { focus:0, items : [
            {name:'百科学苑',style:'mask maskX1',action:[0,3,2,0,0,4,1,1],url:"/defaultHD/en/zylp_index.jsp?typeId=10000100000000090000000000102640&pageLength=12",vote:"178"},
            {name:'养老789',style:'mask maskX2',action:[0,3,2,1,1,0,1,1],url:"http://192.168.9.75/cms/yl789/index.htm",vote:"179"}
        ]},
        { focus:0, items : [
            {name:'首页',style:'btnHome',action:[1,0,2,0,0,6,2,1]},
            {name:'返回',style:'btnReturn',action:[1,1,2,1,2,0,2,1]}
        ]},
        { focus:0, items : [
            {name:'Input',action:[3,0,4,0,3,0,3,0]}
        ]},
        { focus:0, items : [
            {name:'BtnOK',style:'btnSure',action:[3,0,4,0,4,0,4,1]},
            {name:'BtnCancel',style:'btnCancel',action:[3,0,4,1,4,0,4,1]}
        ]}
    ];
    var backUrl = '<%= backUrl %>';
    var typeId = '<%= typeId %>';
    function focused(index,initilized){
        if($.showTootiped ) return;
        var item =  focusable[blocked].items[focusable[blocked].focus];
        var focus = 0;
        if(typeof index == "number" && !initilized ){
            //上:11,下:-11,左-1,右1
            if(index == 11) {
                blocked = item.action[0]; focus = item.action[1];
            } else if(index == -11){
                blocked = item.action[2]; focus = item.action[3];
            } else if(index == -1 && blocked != 3){
                blocked = item.action[4]; focus = item.action[5];
            } else if( index == 1 && blocked != 3) {
                blocked = item.action[6]; focus = item.action[7];
            }
            focusable[blocked].focus = focus;
        } else if( initilized )
            focusable[blocked].focus = focus =  index;

        $("mask").style.display = blocked == 3 ? "none" : "block";
        item =  focusable[blocked].items[focus];
        if( typeof item.style === 'string') $("mask").className = item.style;
    }
    function doEnter(){
        try{ E.is_HD_vod = true; } catch (e) {}

        if(blocked == 0){
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if( item.playType == 1)
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/high_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
            else {
                top.window.location.href = focusURL() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
            }
        }
        else if( blocked == 1 ){
            blocked = 3;
            $.showInput();
        } else if( blocked == 2 ){
            if(focusable[blocked].focus == 0)
                top.window.location.href = backUrl;
            else
                top.window.location.href = iPanel.eventFrame.portalUrl;
        }
        else if( blocked == 3 || blocked == 4 ) {
            var block = 4;
            if($.showTootiped) {blocked = 3; $.showInput(); return;}
            if( focusable[block].focus === 1) {
                blocked = 1;
                $.hideInput(focusable[blocked].items[focusable[blocked].focus].style);
            } else {
                if( $.phoneValidate() ) {$.showTooltip(); return;}
                var cardId = CA.card.serialNumber;
                var url = "http://192.168.9.79:8021/voteNew/external/addVote.ipanel?icid=" + cardId + "&phone=" + $.phone +"&classifyID=" + focusable[1].items[focusable[1].focus].vote + "&content=" + encodeURIComponent("进入" + focusable[1].items[focusable[1].focus].name);
                $.ajax(url,function(result){
                    url = focusable[1].items[focusable[1].focus].url;
                    if(url.startWith("/defaultHD") || url.startWith("/neirong")) url = iPanel.eventFrame.pre_epg_url + url;
                    top.window.location.href = url;
                });
                return;
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
                    case 38:                        //上光标键
                        focused(11, false);
                        break;
                    case 40:                        //下光标键
                        focused(-11, false);
                        break;
                    case 37:                        //左光标键
                        focused(-1, false);
                        break;
                    case 39:                        //右光标键
                        focused(1, false);
                        break;
                    case 13:                        //选择回车键
                        doEnter();
                        break;
                    case "KEY_BACK":
                        top.window.location.href = backUrl;
                        break;
                    case "KEY_EXIT":
                    case "KEY_MENU":
                        top.window.location.href = iPanel.eventFrame.portalUrl;
                        return 0;
                        break;
                }
            }
        }
        if( typeof $.ajax === 'undefined') {
            $.ajax = function(url,callback,options){
                if( typeof  url === 'undefined' ) return;

                if(typeof  options === 'undefined')
                    options = {};

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
                        else{
                            request.abort();
                        }
                    }
                }
                request.open(options.method, url, options.async);
                request.send(null);
            };
        }
        $.phone = "";
        $.showTootiped = false;
        $.errorMessage = "手机号码不正确！";
        $.numberInput = function (id ,num){
            if($.phone.length >=11)return;
            $.phone += num;
            $(id).innerText = $.phone;
        };
        $.numberDelete = function(id){
            if($.phone.length==0)return;
            $.phone = $.phone.substr(0,$.phone.length-1);
            $(id).innerText =$.phone;
        };
        $.phoneValidate = function(){
            var reg = /^1[3|4|5|8][0-9]\d{8}$/gi;
            return ! reg.test($.phone);
        };
        $.showInput = function(){
            $.showTootiped = false;
            $.phone = "";
            $("phoneNumber").innerHTML = "";
            $("votePop").style.display = "block";
            $("votePop").style.backgroundPosition = "0px 0px";
            $("mask").style.display = "none";
        };
        $.hideInput = function(className){
            $("mask").className = className;
            $("mask").style.display = "";
            $("votePop").style.display = "none";
        };
        $.showTooltip = function(message){
            if( typeof  message === 'undefined' ) message = $.errorMessage;
            $.showTootiped = true;
            $("phoneNumber").innerHTML = message;
            $("votePop").style.display = "block";
            $("votePop").style.backgroundPosition = "0px -400px";
            $("mask").style.display = "none";
        };
        focused(<%= focused %>, true);
    }

    function eventHandler(eventObj, __type){
        switch(eventObj.code){
            case "KEY_UP":
                focused(11, false);
                break;
            case "KEY_DOWN":
                focused(-11, false);
                break;
            case "KEY_NUMERIC":
                if(blocked == 3){
                    $.numberInput("phoneNumber", eventObj.args.value);
                }
                break;
            case "KEY_LEFT":
                focused(-1, false);
                break;
            case "KEY_RIGHT":
                focused(1, false);
                break;
            case "KEY_SELECT":
                doEnter();
                break;
            case "KEY_BACK":
                if(blocked === 3){
                    $.numberDelete("phoneNumber");
                } else {
                    window.location.href = EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
                }
                break;
            case "KEY_EXIT":
            case "KEY_MENU":
                window.location.href = iPanel.eventFrame.portalUrl;
                return 0;
                break;
        }
        return 	eventObj.args.type;
    }
    function focusURL(){
        return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
    }
    window.onload = function(){
        setTimeout("init()",100);
    }
    -->
</script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2014-12-15.jpg') no-repeat;">
<div id="votePop" class="voteContainer" style="visibility:hidden"><div id="phoneNumber" class="phoneNumberInput" ></div></div>
<div id="mask"></div>
</body>
</html>