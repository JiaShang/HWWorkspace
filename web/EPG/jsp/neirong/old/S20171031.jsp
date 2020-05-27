<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");
    final String[] types = {"10000100000000090000000000106723","10000100000000090000000000106721"};
    final int[] position = {2,0,99,0};
    //TODO:ÿ����Ҫ�޸�
    int focused = 0, area = 3;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    String autoPlayId = "0";
    String vodMid = "0";

    List<List<Vod>> list = null;
    Column column = new Column();

    TurnPage turnPage = new TurnPage(request);

    try {

        String playBack = request.getParameter("for_play_back");
        String fcr = request.getParameter("ifcor");
        fromEPG = request.getParameter("EPGflag");
        isKorean = StringUtils.isEmpty(request.getParameter("isKorean"))? isKorean : request.getParameter("isKorean");

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

        // ����ʱ��ȡ������Ϣ����
        String[] focus = null;
        value = request.getParameter("currFoucs");
        focus = StringUtils.isEmpty( value ) ? turnPage.getPreFoucs() : value.split("\\,");

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

        if( list.size() > 0 ) {
            List<Vod> prepare = list.get(0);
            if( prepare.size() > 0 ) vodMid = String.valueOf(prepare.get(0).getId());
            if( prepare.size() > 1 ) autoPlayId = String.valueOf(prepare.get(1).getId());
        }
    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title><%=column == null ? "" : column.getName()%></title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2017-10-31.png') no-repeat;background-position: 0px 0px;}

        .bgTop {width:1280px;height:148px;position:absolute;left:0px;top:0px;background:transparent url('images/bg-2017-10-31-Top.png') no-repeat left top;}
        .bgLeft {width:40px;height:315px;position:absolute;left:0px;top:148px;background:transparent url('images/bg-2017-10-31-Left.png') no-repeat left top;}
        .bgRight {width:726px;height:315px;position:absolute;left:554px;top:148px;background:transparent url('images/bg-2017-10-31-Right.png') no-repeat left top;}
        .bgBottom {width:1280px;height:257px;position:absolute;left:0px;top:463px;background:transparent url('images/bg-2017-10-31-Bottom.png') no-repeat left top;}

        .remainderDays {width:116px;height:97px;left:769px; top:137px; color:white;font-size:84px;text-align: center; overflow: hidden;line-height: 97px; position:absolute;}

        .mask11{width:76px;height:76px;left:263px;top:280px;background-position: -220px 0px;}
        .mask21{width:635px;height:78px;left:557px;top:256px;background-position: -300px 0px;}

        .mask3 {width:203px;height:157px;top:343px;}
        .mask31 {left: 550px;background-position: -220px -120px;}
        .mask32 {left: 720px;background-position: -420px -120px;}
        .mask33 {left: 889px;background-position: -620px -120px;}
        .mask34 {left: 1060px;background-position: -820px -120px;}

        .flowed {width:1100px;height:140px;position:absolute;left:104px;top:526px;overflow: hidden;}

        .item {width:219px;height:139px;position:relative;float: left; overflow: hidden;}
        .itemImg {width:208px;height:137px;position:absolute;left:1px;top:1px;overflow: hidden;}
        .itemImg img{width:208px;height:137px;}
        .itemMask,.itemFocus{width:210px;height:139px;position:absolute;left:0px;top:0px;overflow: hidden;}
        .itemMask {background-position: 0px 0px;}
        .itemFocus {background-position: 0px -140px;}

        .after {}
        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"����";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
    </style>
    <script type="text/javascript" src="js/ajax.js"></script>
    <script language="javascript" type="text/javascript">
	
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //�����Ի���������б�����
        var popMaxItemsLength = 6;

        //�ɻ�ý�����������
        var focusable = focusable ? focusable : [
            { focus:0,typeId:'<%= types[0] %>',items : [{name:'ֱ����Ƶ',style:'mask mask11',<%= autoPlayId.equalsIgnoreCase("0") ? "playType:-3,link:'/EPG/jsp/neirong/VideoFullPlay.jsp?vodid=0'" : "playType:0,mid:" + autoPlayId%>}]},
            { focus:0,items : [{name:'���������ɻع�',style:'mask mask21',playType:-3,link:'/EPG/jsp/neirong/S20171031Review.jsp?typeId=10000100000000090000000000106719'}]},
            { focus:0,typeId:'<%= types[0] %>',items : [
                {name:'��������',style:'mask mask3 mask31',playType:-3,link:'/EPG/jsp/neirong/S20171031Detail.jsp'},
                {name:'�����ܰ���',style:'mask mask3 mask32',playType:-3,link:'http://192.168.35.153:8080/huoDong_malasong.jsp?lcn=malas'},
                {name:'�ۺ�ѵ��Ӫ',style:'mask mask3 mask33',playType:-3,link:'http://192.168.35.153:8080/huoDong_banma.jsp?lcn=mls'},
                {name:'����������',style:'mask mask3 mask34',playType:0,mid:<%= vodMid %>},
            ]},
            <%
            value = "";
            if( list != null && list.size() > 0){
                for(int i = 1; i < list.size() ; i++){
                    value += "{focus:0,typeId:'" + types[i] + "',items:[";
                    List<Vod> vodList = list.get(i);
                    for( int j = 0; j < vodList.size() ; j++ ){
                        Vod vod = vodList.get(j);
                        String str = "{ mid:'" + vod.getId() + "'," +
                                   "text:\"" + vod.getName() + "\"," +
                                   "picture:'" + Utils.pictureUrl("images/default_preview_lb.png", vod.getPosters(), "1", request)+ "'" + "," +
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
                {name:'ȷ��',style:'btnSure'},
                {name:'ȡ��',style:'btnCancel'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //�����������ݵ�
        var isKorean = <%= isKorean%>;                   //�Ƿ�Ϊ����
        var columns = 5; rows = 1;              //�������У������м���
        var pageCount = columns * rows;
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = blocked;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                if( blocked == 0 && (index == -1 || index == 11) ||
                    blocked == 1 && (index == 1 || index == 11) ||
                    blocked == 2 && ( index == 1 && focus >= 3) ||
                    blocked == 3 && ( index == -11 || index == -1 && focus <= 0 || index == 1 && focus + 1 >= focusable[blocked].items.length )) return;
                if( index == 1 ) {
                    if( blocked == 0 ){
                        blocked = 1; focus = 0;
                    } else {
                        focus += 1;
                    }
                } else if( index == -1 ) {
                    if( blocked == 1 || blocked == 2 && focus == 0 ) {
                        blocked = 0;
                    } else {
                        focus -= 1;
                    }
                } else if( index == 11 ) {
                    if( blocked == 3) {
                        blocked = focus % pageCount <= 1 ? 0 : 2; focus = focusable[blocked].focus;
                    } else if( blocked == 2 ) {
                        blocked = 1;focus = focusable[blocked].focus;
                    }
                } else {
                    if( blocked == 1 ) {
                        blocked = 2; focus = focusable[blocked].focus;
                    } else if( blocked == 2 ) {
                        blocked = 3;
                        if( focusable[blocked].focus % pageCount >= 2 )
                            focus = focusable[blocked].focus;
                        else {
                            var sub = 2 - focusable[blocked].focus % pageCount;
                            focus = focusable[blocked].focus + sub >= focusable[blocked].items.length ? focusable[blocked].items.length - 1 : focusable[blocked].focus + sub;
                        }
                    } else if( blocked == 0 ) {
                        blocked = 3;
                        if( focusable[blocked].focus % pageCount < 2 )
                            focus = focusable[blocked].focus;
                        else {
                            focus = focusable[blocked].focus % pageCount - 2 ;
                        }
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 1 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $( blocked == focusable.length - 1 ? "maskVote" : "mask").className = item.style;

            $("mask").style.visibility = focusable[blocked].flowed ? "hidden" : "visible";

            if( previous == 3 || blocked == 3 || initilized) flowedShow(3);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            //ÿҳ��ʾ����
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += '<div class="item">';
                html += '<div class="mask itemImg"><img src="' + item.picture + '"/></div>';
                html += '<div class="mask ' + ( ( i == focus && blocked == index ) ? "itemFocus" : "itemMask" )  + '"></div>';
                html += '</div>';
            }
            $("flowed").innerHTML = html;
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
                        case 38: focused(11, false);break;      //�Ϲ���
                        case 40:focused(-11, false);break;      //�¹���
                        case 37:focused(-1, false);break;       //�����
                        case 39:focused(1, false);break;        //�ҹ���
                        case 13:doEnter(); break;              //ѡ��س���
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
                    if( $.video.id != '0' ) {
                        var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0";
                        $.ajax(rtspUrl,function(result){
                            if( result.playFlag === "1"){
                                var rtsp = result.playUrl.split("^")[4];
                                media.video.setPosition($.video.position[0],$.video.position[1],$.video.position[2],$.video.position[3]);
                                media.AV.open(rtsp,"VOD");
                            }
                        });
                    } else {
                        media.video.setPosition($.video.position[0],$.video.position[1],$.video.position[2],$.video.position[3]);
                        DVB.playAV(2750000,2602);       //Ƶ�㣬ServiceId
                    }
                } catch (e){}
            }

            $.vote = function (){
                if( $.vote.voted ) { if( !$.vote.tooltiped ) $.vote.tooltip($.vote.fail); else goBack();return; }
                //�����ʾ����ʾ��ȡ����ʾ�����ʾ��������ʾ�����
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 1 && focusable[focusable.length - 1].focus == focusable[focusable.length - 1].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //���� $.vote.current.message, $vote.current.id ����Ϊ��ʱ�Ž���ͶƱ
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    //�����ͳ��
                    //http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid=8230003190017318&classifyID=100&content=44
                    //ר��ͶƱ����
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
            $.vote.error = "�ֻ����벻��ȷ��";
            $.vote.fail = "���Ѳ����ͶƱ��";
            $.vote.success = "ͶƱ�ɹ���";
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
			
			//�������ͳ��
			var isComplete = true;
			var caid = CA.card.serialNumber;
			var currUrl = window.location.search.split("?")[1].split("&")[0];
			var tmpStr = currUrl.split("=")[1];
			if(tmpStr=="Zcq"||tmpStr=="Android"||tmpStr=="3.0"){
				voteAction(tmpStr);
			}
			
            //������¼����绰����������˳�򼰽���
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                html += "<div class='bgTop'></div>";
                html += "<div class='bgLeft'></div>";
                html += "<div class='bgRight'></div>";
                html += "<div class='bgBottom'></div>";

                var startTime = Date.parse("2017-11-05T08:00:00-08:00");
                var currentTime = new Date();
                var num = 0;
                if( currentTime < startTime )
                {
                    num = Math.ceil(( startTime - currentTime ) / ( 60 * 60 * 1000 ));
                    num = num <= 8 ? 0 : Math.ceil( ( num - 8 ) / 24 ) ;
                }
                html += '<div class="remainderDays">0' + num + '</div>';

                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div id='mask'></div>";
                if(typeof option.external.after == 'string' ) html += option.external.after;
                if( typeof option.vote != 'undefined' ){
                    html += "<div id='votePop' class='voteContainer' style='visibility:hidden'><div id='phoneNumber' class='phoneNumberInput' ></div></div>";
                    html += "<div id='maskVote'><span>&nbsp;</span></div>";
                    for(var i=0; i < option.vote.length; i++) {
                        if(typeof option.vote[i].item == 'undefined' )
                            focusable[option.vote[i].blocked].voteId = option.vote[i].id;
                        else if( typeof focusable[option.vote[i].blocked].items[option.vote[i].item] != 'undefined')
                            focusable[option.vote[i].blocked].items[option.vote[i].item].voteId = option.vote[i].id;
                    };
                }
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; $.video.play();}
                document.body.innerHTML = html;
                if( typeof option.vote != 'undefined' ) $("maskVote").style.visibility = "hidden";
                if( focusable[0].flowed ) $("mask").style.visibility = "hidden";
            }
            $.bookmark = function(vodid){
                var marks = iPanel.ioctlRead("bookmark");
                if( marks != null ){
                    var overs = marks.split(";");
                    for(var i = 0; i < overs.length; i++){
                        var temp = overs[i].split(",");
                        if( temp[1] == "undefined" || temp[1] == undefined) return null;
                        if( temp[1] == 'vodid' ) return temp[4]; //���ϵ�ʱ��ȡ���������ֶβ�Ҫ
                    }
                }
                return null;
            }
            $.buildUserInterface({flowed:[3],vote:undefined,video:'<%= autoPlayId %>',position:[40,148,515,316],external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            focused(<%= focused %>, true);
        }



        function voteAction(__content){
            var url = "http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid="+caid+"&classifyID=399&content="+__content+"";
            //var url = "http://192.168.49.56:8989/VoteStatistics/getVoteSum?content="+wrapContent+"&classifyID=376";
            iPanel.debug("fighting.html getZanNum url ===" + url);
            isComplete = false;
            ajax({
                url: url,
                type: "POST",
                dataType: "html",
                onSuccess: function(html){
                    iPanel.debug("fighting.html onSuccess  voteAction html ===" + html);

                    isComplete = true;

                },
                onError:function(){
                    iPanel.debug("fighting.html onError  voteAction  ");
                }
            });
        }

        function goBack(keyBack){
            if( focusable.length > 1 ) {
                if( blocked == focusable.length - 1 ) { if( focusable[blocked].focus == 0 && !$.vote.voted )  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
                if( typeof focusable[blocked].vote == 'boolean'){
                    if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                    blocked = focusable[blocked].backed;
                    focused(focusable[blocked].focus, true);
                    return;
                }
            }
            if(typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            //��ҳ������
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
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else if( item.link.indexOf("wasu.cn/") > 0 ) {
                        //curr_url = "ui://portal1.htm?" + curr_url;
                        url = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/Category.jsp?url=" + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
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
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d'/*'western/eu_tvD'*/) + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://ȥ������������ baseFlag=0
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:transparent url('images/translateBg.png') no-repeat;" onUnload="exit();"></body>
</html>