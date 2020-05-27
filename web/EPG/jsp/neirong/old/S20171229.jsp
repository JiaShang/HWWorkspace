<%--：
    typeId:栏目Id;华为CMS中，当前专题名称所应对的ID;;
    tp:TOP坐标;不填为默认坐标
    fc:焦点文字颜色;不填为默认为黄色
    bc:焦点框颜色;不填为默认为黄色
    ct:显示数量;每页显示条目个数，默认为５个;;
    kd:专题类型;当前专题类型;checkbox;1:为韩剧\2:为英美剧\0:其它为普通专题
--%>
<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000107189"};
    if( !StringUtils.isEmpty(typeId))
        types[0] = typeId;

    final int[] position = {10,0};
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 14;

    String backUrl = "",fromEPG = "",value = "", kd = "", bc = null,fc = null;
    Integer tp = null,ct=null;

    List<List<Vod>> list = null;
    Column column = new Column();
    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");

        kd = StringUtils.isEmpty(request.getParameter("kd"))? "0": request.getParameter("kd");
        if( kd.equalsIgnoreCase("1") )
            kd = "hjzq/hj_tvD";
        else if( kd.equalsIgnoreCase("2") )
            kd = "western/eu_tvD";
        else
            kd = "vod/tv_d";

        ct = StringUtils.isEmpty( request.getParameter("ct") ) ? 5 : Integer.valueOf(request.getParameter("ct"));
        tp = StringUtils.isEmpty( request.getParameter("tp") ) ? 383 : Integer.valueOf(request.getParameter("tp"));
        fc = StringUtils.isEmpty( request.getParameter("fc") ) ? "fdfa00" : request.getParameter("fc");
        bc = StringUtils.isEmpty( request.getParameter("bc") ) ? "fdfa00" : request.getParameter("bc");

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

        backUrl = request.getParameter("backURL");
        if( StringUtils.isEmpty( backUrl ) )
            backUrl = turnPage.go(-1);

        MetaData metaHelper = new MetaData(request);
        column = getDetailInfo( metaHelper, types[0], column );

        list = new ArrayList<List<Vod>>();
        int i = 0;
        for( String type : types ){
            List<Vod> ls = getVodList( metaHelper, type,position[i], position[i+1]);
            list.add( ls );
            i+=2;
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .item{ width:208px;height:285px;margin:0px 6px; float: left;}
        .itemContainer{width:200px;height:245px; position:relative;}
        .item .image{ width:200px;height:245px;left:0px;top:7px;position:relative;background:transparent url('images/mask-TempRowYellow.png') no-repeat -6px -10px;padding:3px 10px 3px 10px;}
        .maskImage{width:178px;height:232px;left:5px;top:5px;position:relative; border:solid 5px #<%=bc%>;}
        .text {width:190px;height:35px; font-size:22px; color:#fee5f0; line-height:30px; position:relative; overflow: hidden;left:5px;text-align: center;}

        .flowed {width:1200px;left:89px;top:<%=tp%>px;height:285px;overflow:hidden;position: absolute;}

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"宋体";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
    </style>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //弹出对话框中最大列表数量
        var popMaxItemsLength = 6;

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            <%
            value = "";
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                                 "length:" + StringUtil.length(vod.getName()) + "," +
                              "shortText:\"" + StringUtil.limitStringLength(vod.getName(), popItemMaxCharLength) + "\"" + "," +
                               "playType:" + vod.getIsSitcom() ;
                            str += "}" ;
                        str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]},";
                }
                out.write(value);
            }
            %>
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'确定',style:'btnSure'},
                {name:'取消',style:'btnCancel'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var columns = 1; rows = 1;      //定义行列，　几行几列
        var pageCount = columns * rows;
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                //如果焦点在投票上,按上下左右键时
                if( blocked == focusable.length - 1 && ( $.vote.tooltiped || index == 1 && focus == 2 || index == -1 && focus <= 1 || index == 11 && focus == 0 || index == -11 && focus >= 1 ) ) return;
                if( index == 1 && !$.vote.tooltiped && blocked == focusable.length - 1 && focus == 1 ) focus = focus + 1;
                else if( index == -1 && !$.vote.tooltiped && blocked == focusable.length - 1 && focus == 2 ) focus = focus - 1;
                else if( blocked == focusable.length - 1 ) { if (focus == 0 && index == -11 ) { focus = 1; $("maskVote").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0;$("maskVote").style.visibility = "hidden";} }
                else {
                    if( blocked == 0 && ( index == -1 || index == 1 || index == 11 && focus <= 0 || index == -11 && focus + 1 >= focusable[blocked].items.length )) return;
                    focus += index > 0 ? -1 : 1;
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                return;
            }
            document.body.style.backgroundImage = 'url("images/bg-2017-12-29-' + (focus + 1) + '.jpg")';
        }

        function queryVoteResult(block,voteColumnId, callback ){
            $.ajax('http://192.168.49.56:8080/voteNew/external/queryVoteDatas.ipanel?columnA=' + voteColumnId + '&isable=1&startIndex=0&pageSize=50&total=true',function(result){
                var columns = result.result;
                for( var i = 0; i < columns.length; i++ ){
                    if( typeof focusable[block].items[i].voteId === 'undefined' ){
                        focusable[block].items[i].voteId = columns[i].ID;
                    }
                    focusable[block].items[i].total = columns[i].total;
                }
                if( typeof callback === 'function' ) callback();
            });
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
            Array.prototype.insertAt = function(index, o ){ this.splice(index, 0, o ); }
            Array.prototype.removeAt = function(index){ this.splice(index,1); }
            Array.prototype.remove = function(o){ var index = this.indexOf( o ); if ( index >= 0) this.removeAt(index); }
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
                        case 13:doEnter(); break;              //选择回车键
                        case 46:goBack(true);break;
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
                                try {
                                    callback( (new Function("return " + responseText))() );
                                } catch ( e ) {
                                    callback( eval("(" + request.responseText + ")" ) );
                                }
                            }
                            else{request.abort();}
                        }
                    }
                    request.open(options.method, url, options.async);
                    request.send(null);
                };
            }
            $.video = {};
            $.video.id = undefined;
            $.video.position = undefined;
            $.video.play = function(){
                try{
                    if(typeof $.video.id != "string" || $.video.id.isEmpty() || typeof iPanel === 'undefined') return;
                    //go_authorization.jsp??typeId=-1&playType=11&parentVodId="+parentVodId+"&progId="+freeVodId+"&baseFlag=0&contentType=0&startTime=0&business=1;
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0";
                    $.ajax(rtspUrl,function(result){
                        if( result.playFlag === "1"){
                            var rtsp = result.playUrl.split("^")[4];
                            media.video.setPosition($.video.position[0],$.video.position[1],$.video.position[2],$.video.position[3]);
                            media.AV.open(rtsp,"VOD");
                        }
                    });
                } catch (e){}
            }

            $.vote = function (){
                if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //如果显示了提示框，取消提示框的显示，重新显示输入框
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    //点击量统计
                    //http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid=8230003190017318&classifyID=100&content=44
                    //专题投票排序
                    //var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=13999999999&classifyID=" + $.vote.current.id + "&voteCount=5&content=" + encodeURIComponent($.vote.current.message);
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote.ipanel?icid=" + cardId + "&repeat=false&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&content=" + encodeURIComponent($.vote.current.message);
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
            $.vote.maskStyle = undefined;
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
                if( typeof $.vote.maskStyle === 'undefined' && $("mask").style.visibility != 'hidden')
                {
                    $.vote.maskStyle = 'visible';
                    $("mask").style.visibility = "hidden";
                }
                $("votePop").style.visibility = "visible";
                $("votePop").style.backgroundPosition = "0px 0px";
            };
            $.vote.hidden = function(className){
                $.vote.status = false;
                $.vote.tooltiped = false;
                $.vote.current = undefined;
                if( typeof $.vote.maskStyle != 'undefined') {
                    $("mask").style.visibility = $.vote.maskStyle;
                    $.vote.maskStyle = undefined;
                }
                $("votePop").style.visibility = "hidden";
                $("maskVote").style.visibility = "hidden";
            };
            $.vote.tooltip = function(message){
                if( typeof  message == 'undefined' ) message = $.vote.error;
                $.vote.status = false;
                $.vote.tooltiped = true;
                $("phoneNumber").innerHTML = message;
                $("votePop").style.backgroundPosition = "0px -400px";
                $("votePop").style.visibility = "visible";
                $("maskVote").style.visibility = "hidden";
            };
            //用来记录输入电话号码框的数组顺序及焦点
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){

            }
            $.bookmark = function(vodid){
                var marks = iPanel.ioctlRead("bookmark");
                if( marks != null ){
                    var overs = marks.split(";");
                    for(var i = 0; i < overs.length; i++){
                        var temp = overs[i].split(",");
                        if( temp[1] == "undefined" || temp[1] == undefined) return null;
                        if( temp[1] == 'vodid' ) return temp[4]; //将断点时间取出，其他字段不要
                    }
                }
                return null;
            }
            var links = [{text:'战狼2',length:<%= StringUtil.length("战狼2")%>,shortText:'<%= StringUtil.limitStringLength("战狼2", popItemMaxCharLength)%>',playType:-3,link:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a1e0da3ea29c36292cf2d8efc3114ba',link1:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###4c2d4141d50fceb284767be99ff32253###video_type###0###video_ui_style###0'},
                         {text:'英伦对决',length:<%= StringUtil.length("英伦对决")%>,shortText:'<%= StringUtil.limitStringLength("英伦对决", popItemMaxCharLength)%>',playType:-3,link:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a275c4924ec56b127cd0296fbc9034a',link1:'cmd_ex###show_video_detail###video_id###223c74e43116e3a39e1dbf07c1a37135###video_type###0###video_ui_style###0'},
                         {text:'王牌特工2',length:<%= StringUtil.length("王牌特工2")%>,shortText:'<%= StringUtil.limitStringLength("王牌特工2", popItemMaxCharLength)%>',playType:-3,link:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a2515a22581872da8e92753b090aeda',link1:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###5412e023997a3ee06db7a2547cf576b3###video_type###0###video_ui_style###0'},
                         {text:'神奇女侠',length:<%= StringUtil.length("神奇女侠")%>,shortText:'<%= StringUtil.limitStringLength("神奇女侠", popItemMaxCharLength)%>',playType:-3,link:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a0ea0de21dacf263c859d4a913b36a0',link1:'com.hunantv.operator,com.starcor.hunan.SplashActivity,cmd_ex###show_video_detail###video_id###bf49688b06ad98a5da88a6c6d9b05b0f###video_type###0###video_ui_style###0'},
                         {text:'奇异博士',length:<%= StringUtil.length("奇异博士")%>,shortText:'<%= StringUtil.limitStringLength("奇异博士", popItemMaxCharLength)%>',playType:-3,link:'http://192.168.42.52/epg/hollywood/biz_35827560/category/ccms_category_68406178/item/vod/50993.do'},
                         {text:'敦刻尔克',length:<%= StringUtil.length("敦刻尔克")%>,shortText:'<%= StringUtil.limitStringLength("敦刻尔克", popItemMaxCharLength)%>',playType:-3,link:'http://192.168.17.155/nn_cms/web_template/index.html?nns_page_name=movie_detail&nns_video_id=5a2f3dc4b43cb01beba244d3357e36a7',link1:'cmd_ex###show_video_detail###video_id###f951ed6672f274fce49919a3bb5122c8###video_type###0###video_ui_style###0'},
                        ];

            focusable[0].items.insertAt(1,links[0]);
            focusable[0].items.insertAt(3,links[1]);
            focusable[0].items.insertAt(5,links[2]);
            focusable[0].items.insertAt(7,links[3]);
            focusable[0].items.insertAt(8,links[4]);
            focusable[0].items.insertAt(9,links[5]);
            $.buildUserInterface({flowed:undefined,vote:undefined,video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( focusable.length > 1 ) {
                if( blocked == focusable.length - 1 ) { if( focusable[focusable.length-1].focus == 0 && !$.vote.voted )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
                if( typeof focusable[blocked].vote == 'boolean'){
                    if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                    blocked = focusable[blocked].backed;
                    focused(focusable[blocked].focus, true);
                    return;
                }
            }
            if(typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1 && EPGflag) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            //首页，返回
            if( blocked == focusable.length - 1 ) { $.vote(); return; }
            var item =  focusable[blocked].items[focusable[blocked].focus];
            if(typeof item == 'undefined' || item.playType == 'undefined') return;
            var typeId = focusable[blocked].typeId;
            switch(item.playType){
                case -1:
                    focusable[item.blocked].backed = blocked;
                    blocked = item.blocked;
                    focused(focusable[blocked].focus, true);
                    break;
                case -2:
                    $.vote.current = {};
                    $.vote.current.id = typeof item.voteId == 'undefined' ? focusable[blocked].voteId : item.voteId;
                    $.vote.current.message = typeof item.text == 'undefined' ? item.name : item.text;
                    focusable[focusable.length - 1].backed = blocked;
                    blocked = focusable.length - 1;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                    break;
                case -3:
                    if( typeof iPanel != 'undefined' && typeof  item.link1 != 'undefined' && iPanel.eventFrame.systemId == 1 ) {
                        iPanel.IOControlWrite("startAPK",item.link1);
                    } else {
                        var url = '';
                        if( ! item.link.startWith('http') ){
                            url += $.current() + item.link;
                        } else {
                            url = item.link;
                            url += url.indexOf("?") > 0 ? '&' : '?';
                            url += 'backURL=';
                            if( url.startWith("http://epgServer") && typeof iPanel != 'undefined' ) url = url.replace( "http://epgServer", iPanel.eventFrame.pre_epg_url );
                            var requestUrl = "<%= request.getRequestURL().toString() %>";
                            var queryStr = "<%= request.getQueryString() %>";
                            if( queryStr == 'null' ) queryStr = '';
                            var focusStr = blocked + "," + focusable[blocked].focus;
                            if( ! queryStr.isEmpty() ) {
                                requestUrl += "?" + ( queryStr.indexOf( 'currFoucs=' ) < 0 ? ( queryStr + "&currFoucs=" + focusStr ) : queryStr.replace('currFoucs=' + getUrlParameters("currFoucs", queryStr), 'currFoucs=' + focusStr) );
                            } else {
                                requestUrl += '?currFoucs=' + focusStr;
                            }
                            url += encodeURIComponent(requestUrl);
                        }
                        top.window.location.href = url;
                    }
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/<%= kd%>etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://去掉基本包检验 baseFlag=0
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
                    break;
            }
        }
        function eventHandler(eventObj, __type){
            switch(eventObj.code){
                case "KEY_UP":focused(11, false);break;
                case "KEY_DOWN":focused(-11, false);break;
                case "KEY_LEFT":focused(-1, false);break;
                case "KEY_RIGHT":focused(1, false);break;
                case "KEY_SELECT":doEnter();break;
                case "KEY_NUMERIC":$.vote.input("phoneNumber", eventObj.args.value);break;
                case "KEY_BACK": goBack(true);break;
                case "KEY_EXIT":
                case "KEY_MENU":location.href = iPanel.eventFrame.portalUrl;return 0;break;
                case "VOD_PREPAREPLAY_SUCCESS":media.AV.play();break;
                case "EIS_VOD_PROGRAM_END":$.video.play();break;
            }
            return 	eventObj.args.type;
        }
        function getUrlParameters(str, link) {
            var rs = new RegExp("(\\?|&)?" + str + "=([^&]*?)(&|$)", "gi").exec(link);
            if (typeof rs === 'undefined' || rs === null ) return "";
            return rs[2];
        }
        function exit() { try {DVB.stopAV(0);media.AV.close();} catch (e) {}}
        window.onload = function(){setTimeout("init()",100);}
        -->
    </script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-12-29-<%= focused + 1 %>.jpg') no-repeat;" onUnload="exit();"></body>
</html>