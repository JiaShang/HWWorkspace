<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000105525"};
    if(StringUtils.isEmpty(typeId)) typeId = types[0];
    //TODO:每次需要修改
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<List<Film>> list = null;
    List<Column> columns = new ArrayList<Column>();

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");
        isKorean = StringUtils.isEmpty(request.getParameter("isKorean"))? "false": "true";

        if(null == playBack){
            if(null == fcr)
                turnPage.addUrl();
            else{
                turnPage.removeLast();
                turnPage.addUrl();
            }
        } else{
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
        Column column = new Column();
        column = getDetailInfo( metaHelper, typeId, column );
        columns.add( column );
        columns.addAll( getTypeList( metaHelper, typeId, 4, 0) );

        int i = 1;
        list = new ArrayList<List<Film>>();
        for( ; i < 5; i++ ){
            String type = columns.get(i).getId();
            List<Vod> ls = getVodList( metaHelper, type, i == 1 ? 2 : 3, 0);
            List<Film> films = new ArrayList<Film>();
            for (Vod vod : ls)  films.add( getDetailInfo( metaHelper, String.valueOf(vod.getId()), new Film() ) );
            list.add ( films );
        }
    } catch (Exception e){  }
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>最重庆的模板</title>
    <style>

        .mask {position:absolute;}
        .tbody {overflow:hidden; background:black url('<%= Utils.pictureUrl("", columns.get(0).getPosters(), "7", request) %>') no-repeat;}
        .ticon { width:560px;height:140px;position: absolute;left:0px;top:0px;background:transparent url('<%= Utils.pictureUrl("", columns.get(0).getPosters(), "3", request) %>') no-repeat;}

        .area1{width:450px;height:130px;left:64px;top:383px;position: absolute;}
        .area2,.area3,.area4 {width:485px; height:135px;overflow: hidden;position: absolute; left:205px;top:90px;}
        .area3 {top:80px;left:15px;}
        .area4{top:79px;}

        .areaItems{height:45px;position: absolute; left:0px;}
        .area1 .areaItems {height: 50px;}
        .areaItemIcon {width:60px;height:45px;left:0px;top:0px;position: absolute; font-size:22px; color:#eeeeee; text-align: center; line-height: 44px;}
        .areaFocus,.areaItem {width:425px;height:45px;line-height: 42px;position: absolute;left:60px;top:0px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis; color:#000000;font-size: 22px;padding:0px 5px 0px 10px;}
        .areaFocus {color:#ffffff;}
        .area1 .areaItems .areaItem,.area1 .areaItems .areaFocus{width: 450px;height:50px;left:0px; color:#ffffff; padding:0px 20px 0px 53px; line-height: 45px;}
        .areaMarqueed {width:410px;height:45px;line-height: 42px;}
        .area1 .areaItems .areaFocus .areaMarqueed{width:377px;height:50px;line-height: 45px;}

        .area1Bg { width:560px;height:580px;position: absolute;left:0px;top:140px;background:transparent url('<%= Utils.pictureUrl("", columns.get(1).getPosters(), "7", request) %>') no-repeat;}
        .area2Bg { width:720px;height:240px;position: absolute;left:560px;top:0px;background:transparent url('<%= Utils.pictureUrl("", columns.get(2).getPosters(), "7", request) %>') no-repeat;}
        .area3Bg { width:720px;height:230px;position: absolute;left:560px;top:240px;background:transparent url('<%= Utils.pictureUrl("", columns.get(3).getPosters(), "7", request) %>') no-repeat;}
        .area4Bg { width:720px;height:249px;position: absolute;left:560px;top:471px;background:transparent url('<%= Utils.pictureUrl("", columns.get(4).getPosters(), "7", request) %>') no-repeat;}

        .area2Icon,.area3Icon,.area4Icon {width:200px;height: 30px; left:601px;position:absolute;}
        .area2Icon {top:31px;background:transparent url('<%= Utils.pictureUrl("", columns.get(2).getPosters(), "3", request) %>') no-repeat;}
        .area3Icon {top:261px;background:transparent url('<%= Utils.pictureUrl("", columns.get(3).getPosters(), "3", request) %>') no-repeat;}
        .area4Icon {top:491px;background:transparent url('<%= Utils.pictureUrl("", columns.get(4).getPosters(), "3", request) %>') no-repeat;}

        .area2Img,.area3Img,.area4Img {width:180px;height: 135px;position:absolute;}
        .area2Img {left:575px;top:90px;background:transparent url('<%= Utils.pictureUrl("", columns.get(2).getPosters(), "3", 1, request) %>') no-repeat;}
        .area3Img {left:1070px;top:320px;background:transparent url('<%= Utils.pictureUrl("", columns.get(3).getPosters(), "3", 1, request) %>') no-repeat;}
        .area4Img {left:575px;top:550px;background:transparent url('<%= Utils.pictureUrl("", columns.get(4).getPosters(), "3", 1, request) %>') no-repeat;}

        .flowed {}

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

        //可获得焦点的区域个数
        var focusable = focusable ? focusable : [
            <%
            value = "";
            if( list != null && list.size() > 0){
                for(int i = 0; i < list.size() ; i++){
                    Column column = columns.get( i + 1 );
                    value += "{focus:0,typeId:'" + column.getId() + "',pictures:[" ;
                    String pic = Utils.pictureUrl("", column.getPosters(), "4", 0, request);
                    String pic1 = Utils.pictureUrl("", column.getPosters(), "4", 1, request);

                    if( ! pic.equalsIgnoreCase("") ){
                        value += "'" + pic + "'";
                        if( ! pic1.equalsIgnoreCase("") ) value += ",";
                    }
                    if( ! pic1.equalsIgnoreCase("") )
                        value += "'" + pic1 + "'";
                    value += "],items:[";
                    List<Film> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Film vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                                   "tag:\"" + vod.getTags() + "\"," +
                                 "length:" + StringUtil.length(vod.getName()) + "," +
                              "picture:'" + Utils.pictureUrl("", vod.getPosters(), "3", request) + "'" + "," +
                                "playType:" + vod.getIsSitcom() ;
                            str += "}" ;
                            str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]},";
                }
                out.write( value );
            }
            %>
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'确定',style:'btnSure'},
                {name:'取消',style:'btnCancel'}
            ]},
            { focus:0, items : [
                {name:'首页',style:'btnHome'},
                {name:'返回',style:'btnReturn'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //用来缓存数据的
        var isKorean = <%= isKorean%>;                   //是否为韩剧
        var columns = 0; rows = 0;              //定义行列，　几行几列
        var arrows = [1,0];                     //可以移动到首页返回按钮的光标键「下，右」
        function focused(index,initilized){
            if( blocked == -1 )return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //上:11,下:-11,左-1,右1
                if(
                    //如果焦点在投票的返回，或右下角的返回上，或者在浮动层上时,光标按右键直接返回
                    blocked == focusable.length - 1 && (focus == 0 && arrows[1] == 0 && index == -1 || arrows[0] == 0 && index == 11 || index == -11 || focus == 1 && index == 1 ) ||
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
                else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("mask").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0; $("mask").style.visibility = 'hidden';} }
                else {
                    if( blocked === 0 && ( index === -1 || focus === 0 && index === 11 || focus >= focusable[0].items.length - 1 && index === -11 ) ||
                        blocked >= 1 && index === 1 || blocked === 1 && focus === 0 && index === 11 || blocked >= 3 && focus >= focusable[3].items.length - 1 && index === -11 ) return;

                    if( index === 11 ) {
                        focus = focus - 1;
                        if( focus < 0 ) { blocked = blocked - 1; focus = focusable[blocked].items.length - 1; flowedShow( blocked + 1 );}
                    } else if( index === -11 ) {
                        focus = focus + 1;
                        if( focus >= focusable[blocked].items.length ) { blocked = blocked + 1; focus = 0; flowedShow( blocked - 1 );}
                    } else if( index === -1 ) {
                        focusable[0].previous = blocked;
                        blocked = 0; focus = focusable[blocked].focus;
                        flowedShow( focusable[0].previous );
                    } else {
                        blocked = typeof focusable[0].previous === 'undefined' ? 1 : focusable[0].previous;
                        focus = focusable[blocked].focus;
                        flowedShow( 0 );
                    }
                }
                focusable[blocked].focus = focus;
                flowedShow( blocked );
            } else if( initilized ){
                focusable[blocked].focus = focus = previous = index;
                if(typeof focusable.flowed != 'undefined' ) for( var z = 0; z < focusable.flowed.length; z++ ) flowedShow( focusable.flowed[z] );
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $('mask').className = item.style;
            if( focusable[blocked].popuped ) $.popupShow();
        }
        function flowedShow(index){
            if( typeof index == 'undefined' ) return;
            var area = focusable[index];
            var items = area.items;
            var focus = area.focus;
            var html = '';
            for( var i = 0; i < items.length; i++ ){
                html += '<div class="areaItems" style="top:' + ( i * ( index === 0 ? 80 : 45 ) ) + 'px">';
                if( index != 0 ) html += '<div class="areaItemIcon" style="background-image: url(images/tempate1Icon' + ( ( index - 1 ) * 3 + i + 1 ) + '.jpg)">' + items[i].tag +  '</div>';
                html += '<div class=';

                if( blocked === index && i == focus )
                {
                    html += '"areaFocus" style="background-image:url(\'' + ( area.pictures.length > 1 ? area.pictures[1] : area.pictures[0] ) + '\');"';
                    html += '>' + ( items[i].length > ( index === 0 ? 32 : 34) ? ( "<marquee class='areaMarqueed'>" + items[i].text + "</marquee>" ) : items[i].text) + "</div>";
                } else  {
                    html += '"areaItem"' + ( area.pictures.length > 1 ? ( ' style="background-image:url(\'' + area.pictures[0] + '\');"' ) : "" );
                    html += '>' + items[i].text + "</div>";
                }
                html += "</div>";
            }
            $("area" + ( index + 1 )).innerHTML = html;
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
                        case "KEY_BACK":goBack(true);break;
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
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //必须 $.vote.current.message, $vote.current.id 都不为空时才进行投票
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
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
                $("mask").style.visibility = "hidden";
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
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
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
                    for(var i = 0; i< option.popup.length; i++) {
                        if( typeof focusable[option.popup[i].blocked].items[option.popup[i].item] == 'undefined' )
                            focusable[option.popup[i].blocked].items[option.popup[i].item] = {};
                        focusable[option.popup[i].blocked].items[option.popup[i].item].blocked = option.popup[i].target;
                        focusable[option.popup[i].blocked].items[option.popup[i].item].playType = -1;
                        if(typeof option.popup[i].style == 'string')  focusable[option.popup[i].blocked].items[option.popup[i].item].style = option.popup[i].style;
                        focusable[option.popup[i].target].popuped = true;
                        focusable[option.popup[i].target].backed = option.popup[i].blocked;
                        focusable[option.popup[i].target].previous = option.popup[i].item;
                    }
                }
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; }
                if(typeof option.external.after == 'string' ) html += option.external.after;
                document.body.innerHTML = html;
            }
            $.bookmark = function(vodid){
                var marks = iPanel.ioctlRead("bookmark");
                if( marks != null ){
                    var overs = marks.split(";");
                    for(var i = 0; i < overs.length; i++){
                        var temp = overs[i].split(",");
                        if( temp[1] == "undefined" || temp[1] == undefined) return null;
                        if( temp[1] == vodid ) return temp[4]; //将断点时间取出，其他字段不要
                    }
                }
                return null;
            }
            $.buildUserInterface({flowed:[0,1,2,3],popup:undefined,vote:undefined,video:undefined,position:undefined,gatewayCheck:undefined,external:{
                after:undefined,
                before:'<div class="ticon"></div>' +
                '<div class="area1Bg"><div class="area1" id="area1"></div></div>' +
                '<div class="area2Bg"><div class="area2" id="area2"></div></div>' +
                '<div class="area3Bg"><div class="area3" id="area3"></div></div>' +
                '<div class="area4Bg"><div class="area4" id="area4"></div></div>' +
                '<div class="area2Img"></div><div class="area3Img"></div><div class="area4Img"></div>' +
                '<div class="area2Icon"></div><div class="area3Icon"></div><div class="area4Icon"></div>'
            }});
            if( focusable.length == 2 ) {blocked = -1;}
            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( blocked >= 0 ) {
                if( blocked == focusable.length - 2) { if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
                if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
                if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
                    if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                    blocked = focusable[blocked].backed;
                    focused(focusable[blocked].focus, true);
                    return;
                }
            }
            top.window.location.href = blocked == focusable.length - 1 && focusable[blocked].focus == 0 || EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            //首页，返回
            if( blocked == focusable.length - 1 ) { goBack(); return;}
            if( blocked == focusable.length - 2 ) { $.vote(); return; }
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
                    focusable[focusable.length - 2].backed = blocked;
                    blocked = focusable.length - 2;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                    break;
                case -3:
                    top.window.location.href = $.current() + item.link;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
<body leftmargin="0" topmargin="0" class="tbody" onUnload="exit();"></body>
</html>