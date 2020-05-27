<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    final List<String[]> questions = new ArrayList<String[]>();
    final int popItemMaxCharLength = 12;
    String fromEPG = "";

    questions.add(new String[]{"��·���ڣ� ���л����ˡ�����֮����֮�Ƶ��վ��н����������н���","ƽ�͹ش��","���Źط���ս","������ս��","C","1"});
    questions.add(new String[]{"�й���������������ĵк��ո��ݵ��ǣ� ��","����³ԥ���ո��ݵ�","���翹�ո��ݵ�","���켽���ո��ݵ�","C","2"});
    questions.add(new String[]{"1946��4��29�գ����ڶ����ģ� ����28���ձ��׼�ս����ʽ���ߣ����д�����7���׼�ս��Ϊ���̡�","�������ʷ�ͥ","Ŧ�ױ����·�ͥ","Զ�����ʾ��·�ͥ","C","3"});
    questions.add(new String[]{"1942�꣬ë�󶫾Ϳ��ո��ݵصľ��ý��裬ָ�������� ���������ǵľ��ù����Ͳ����������ܷ��롱��","��ǰ�Ѻ��β�����","��չ���ã����Ϲ���","�����Ϣ","B","4"});
    questions.add(new String[]{"�ձ������ģ� �������й�������ս������㣬ͬʱ�ҿ������練����˹ս������Ļ��","��ɽ�¼�","��һ���±�","һ�����±�","B","5"});
    questions.add(new String[]{"1940��8�´���ģ� �������й���������ʷ�ϵ�һ�������Ƽ��˲ŵĴ�ѧ��","³Ѹ����ѧԺ","�Ӱ��ڱ�ѧУ","�Ӱ���Ȼ��ѧԺ","C","6"});
    questions.add(new String[]{"���翪ʼ������˹ս�����ǣ� ����","������","���������","�й�","C","7"});
    questions.add(new String[]{"1938��5�£�ë�󶫷����������ģ� ������Ϊָ���й���ս�ĸ��������ס�","���۳־�ս��","���й�����ս����ս�����⡷","��ʵ���ۡ�","A","8"});
    questions.add(new String[]{"1942��9��7�գ�ë����Ϊ������ձ���д�����ۡ�һ��������Ҫ�����ߡ��У��صر����ˣ� ���ġ�����������������","�¸�������","�������","����³ԥ����","A","9"});
    questions.add(new String[]{"1940��4�£�����ԥ���ո��ݵس������ԣ� ��Ϊ��ǵ�̫�о���ίԱ�ᣬͳһ�쵼̫�С�̫��������������","��Сƽ","������","������","A","10"});
    questions.add(new String[]{"1941��11�����¸��������ڶ��������һ�λ����ϣ��� �����ȳ���������������������ߡ�","������","���","����ͤ","B","11"});
    questions.add(new String[]{"��·����ʦ��������ǰ�߶��վ���սȡ�õ��״��ش�ʤ���ǣ� ����","ƽ�͹ش��","̨��ׯ���","���عش��","A","12"});
    questions.add(new String[]{"1937��9��22�գ���������ͨѶ�緢�� �������գ�����ʯ����̸������ʵ�ϳ������й���������ȫ���ĺϷ���λ����־�ſ�������ͳһս�ߵ��γɡ�","���й�����Ϊ�վ�����¬����ͨ�硷","���й�����Ϊ���������������ԡ�","���й����������վȹ�ʮ����졷","B","13"});
    questions.add(new String[]{"Ϊ�˹��̿��ո��ݵأ���һ�����̺�����������ͳһս�ߣ��й�����Ҫ������ݵ�����Ȩ�������ձ�ִ᳹�е�ԭ���ǣ� ����","����ѡ��ԭ��","ͳһս��ԭ��","�������ơ�ԭ��","C","14"});
    questions.add(new String[]{"��������ս���ڼ䣬�й��������������ڣ� �������ϣ�ֱ�Ӿ�����ʧ����1000����Ԫ����Ӿ�����ʧ5000����Ԫ��","2100","900","3500","C","15"});
    questions.add(new String[]{"��ë��˼����Ϊ����ָ��˼��д�뵳�µ��ǣ� ����","�������","�й��ߴ�","�й�����","B","16"});
    questions.add(new String[]{"�й��������ڿ���ս��ʱ��Ϊ���ڸ����ս׼����������ʵ�е����������ǣ� ����","����������","�����������","�����Ϣ","C","17"});
    questions.add(new String[]{"�� ���ǰ�·���ڵк�ս�������Ĺ�ģ��󡢳���ʱ�����ս����ս�ۣ�Ҳ���ڹ��ʷ���˹�������漫�����š��й���ս�����Ͼ�����Ĺؼ�ʱ�̵�һ�ξ����ش������ս���ж���","���Ŵ�ս","ƽ�͹ش��","����������һ������ɨ����ս��","A","18"});
    questions.add(new String[]{"1935��12�£����й����������쵼�£��ɱ�ƽѧ����֯��һ�δ��ģ�Ŀ��հ���ʾ�����У�ʷ�ƣ� ����","һ��һ�˶�","һ�����˶�","����������ս�˶�","B","19"});
    questions.add(new String[]{"1941��12��9�գ�����̫ƽ��ս����������Ͼ����ƣ��й��������ξ־������������⹤���Ļ����ǣ� ����","�й����뺣�⹤��ίԱ��","�������������","�Ϸ���������","A","20"});

    List<Integer> list = new ArrayList<Integer>();
    Random random = new Random(System.currentTimeMillis());
    while ( list.size() < 10 ) {
        int index = (int)Math.floor(random.nextDouble() * 20);
        if( list.indexOf( index ) >= 0 || index >= 20 ) continue;
        list.add( index );
    }
    Collections.sort(list);
    //TODO:ÿ����Ҫ�޸�
    int focused = 0, area = 0;

    String value = "";
    String backUrl = "";

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
        } else{
            turnPage.removeLast();
        }

        // ����ʱ��ȡ������Ϣ����
        String[] focus = turnPage.getPreFoucs();
        if(null != focus ){
            if( focus.length > 0 && focus[0] != null )
                area = Integer.parseInt(focus[0]);
            if( focus.length > 1 && focus[1] != null )
                focused = Integer.parseInt(focus[1]);
        }

        backUrl = turnPage.go(-1);

    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>�� �� �� ��</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2015-08-14-Act.png') no-repeat fixed;background-position: 0px 0px;}
        .btnICan {width:170px;height:44px;left:555px;top:562px;background-position: 0px 0px;}

        .flowed {width:1280px;height:720px;left:0px;top:0px;position:absolute;background:transparent url('images/focus-2015-08-14-Act.png') no-repeat fixed 0px 0px;}
        .flowedQuestionContainer {width:560px;height:263px;left:347px;top:213px;position:absolute;padding:22px;}

        .question { font-size:18px;line-height:28px; color: #333333; margin:0px 0px 10px 0px; }
        .answer {height: 34px; width:560px;}

        .answerItem {background:transparent url('images/mask-2015-08-14-Act.png') no-repeat fixed;background-position: 0px 0px;}
        .answerLeft,.answerFocusLeft {width:10px;height:34px;}
        .answerCenter,.answerFocusCenter{height:34px;color: #333333;line-height: 30px;}
        .answerRight,.answerFocusRight {width:10px;height:34px;}
        .answerFocusLeft {background-position:-4px -104px;}
        .answerFocusCenter{background-repeat: repeat-x;background-position:0px -55px;color: #ffffff;}
        .answerFocusRight {background-position:-156px -104px;}

        .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat fixed 0px 0px; overflow: hidden;}
        .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
        .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
        .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -426px; overflow: hidden;}
        .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat fixed 0px -477px; overflow: hidden;}
        .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
        .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat fixed 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"����";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat fixed;background-position: 0px -350px;}

        .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:120px; width:161px;height:41px; background-position: 0px 0px;}
        .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat fixed; top:636px;left:120px; width:161px; height:41px; background-position: 0px -42px;}
    </style>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //�����Ի���������б�����
        var popMaxItemsLength = 6;

        //�ɻ�ý�����������
        var focusable = focusable ? focusable : [
            { focus:0, items: [ {name:'��Ҫ����',style:'mask btnICan'} ]},
            <%
            value = "";
            if( list != null && list.size() > 0){
                value += "{focus:0,vote:true,items:[";
                for(int i = 0; i < list.size() ; i++){
                    String[] quest = questions.get(list.get(i));
                    String str = "{ question:\"" + (i + 1) + "��" + quest[0] + "\"," +
                                   "a:\"A��" + quest[1] + "\"," +
                                   "b:\"B��" + quest[2] + "\"," +
                                   "c:\"C��" + quest[3] + "\"," +
                                   "o:" + quest[5] + "," +
                              "answer:\"" + quest[4] + "\"" + "}" ;
                            str += ( i + 1 < list.size()  ? "," : "");
                    value += str;
                }
                value += "]},";
                out.write(value);
            }
            %>
            { focus:0, vote:true, items : [
                {name:'input'},
                {name:'ȷ��',style:'btnSure'},
                {name:'ȡ��',style:'btnCancel'}
            ]},
            { focus:0, items : [
                {name:'��ҳ',style:'btnHome'},
                {name:'����',style:'btnReturn'}
            ]}
        ];
        var backUrl = '<%= backUrl %>';
        var flowCursorIndex = 0;
        var consign = undefined;                //�����������ݵ�
        var isKorean = false;                   //�Ƿ�Ϊ����
        var columns = 0; rows = 0;              //�������У������м���
        var arrows = [1,0];                     //�����ƶ�����ҳ���ذ�ť�Ĺ������£��ҡ�
        function focused(index,initilized){
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //��:11,��:-11,��-1,��1
                if(
                    //���������ͶƱ�ķ��أ������½ǵķ����ϣ������ڸ�������ʱ,��갴�Ҽ�ֱ�ӷ���
                    blocked == focusable.length - 1 && (focus == 0 && arrows[1] == 0 && index == -1 || arrows[0] == 0 && index == 11 || index == -11 || focus == 1 && index == 1 ) ||
                    //���������ͶƱ��,���������Ҽ�ʱ
                    (blocked == focusable.length - 2 && ( $.vote.tooltiped || focus == 2 && index == 1 || focus <= 1 && index == -1 || focus == 0 && index == 11 || focus >= 1 && index == -11)) ||
                    //���߽����ڸ�������, ���������Ҽ�ʱ��
                    focusable[blocked].popuped && ( focus <= 0 && index == 11 || focus >= focusable[blocked].items.length - 1 && index == -11 || index == -1 || index == 1 )
                ) return;
                if( index == 1 && ( !$.vote.tooltiped && blocked == focusable.length - 2 && focus == 1 || blocked == focusable.length - 1 && focus == 0 ))
                    focus = focus + 1;
                else if( index == -1 && ( ! $.vote.tooltiped && blocked == focusable.length - 2 && focus == 2 || blocked == focusable.length - 1 && focus == 1))
                    focus = focus - 1;
                else if( focusable[blocked].popuped ) { focus += index > 0 ? -1 : 1;  }
                else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("mask").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0; $("mask").style.visibility = 'hidden';} }
                else {
                    if( blocked == 0 && ( index == 1 || index == -1 || index == 11 ) || blocked == 1 && ( index == 1 || index == -1 || index == 11 && focusable[1].index == 0 || index == -11 && focusable[1].index == 2 )) return;
                    if( blocked == 0 ) {
                        blocked = focusable.length - 1; focus = focusable[blocked].focus;
                    } else if(blocked == 1){
                        focusable[blocked].index += index > 0 ? -1 : 1;
                        flowedShow(blocked);
                    } else if ( blocked == focusable.length - 1 ){
                        blocked = 0; focus = 0;
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                //if(typeof focusable.flowed != 'undefined' ) for( var z = 0; z < focusable.flowed.length; z++ ) if( z != blocked) flowedShow(z);
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];
            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $('mask').className = item.style;
            if( focusable[blocked].popuped ) $.popupShow();
        }
        var flowedShow = function(index){
            var focus = focusable[1].focus;
            var item = focusable[1].items[focus];
            var index = focusable[1].index;
            var html = '';
            html += '<div class="question">' + item.question + '</div>';
            html += getAnswerHtml(item.a,0,index);
            html += getAnswerHtml(item.b,1,index);
            html += getAnswerHtml(item.c,2,index);
            $("flowedQuestionContainer").innerHTML = html;
        }
        var getAnswerHtml = function(answer, order ,index){
            var html = '<div class="answer">';
            if( order == index ){
                html += '<span class="answerItem answerFocusLeft"></span>';
                html += '<span class="answerItem answerFocusCenter">' + answer + '</span>';
                html += '<span class="answerItem answerFocusRight"></span>';
            } else {
                html += '<span class="answerLeft"></span>';
                html += '<span class="answerCenter">' + answer + '</span>';
                html += '<span class="answerRight"></span>';
            }
            html += '</div>'
            return html;
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
                        case 13: doEnter(); break;              //ѡ��س���
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
                //�����ʾ����ʾ��ȡ����ʾ�����ʾ��������ʾ�����
                if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 2 && focusable[focusable.length - 2].focus == focusable[focusable.length - 2].items.length - 1 ) { goBack(); return; }
                else {
                    if( $.vote.validate() ) {$.vote.tooltip(); return; }
                    //���� $.vote.current.message, $vote.current.id ����Ϊ��ʱ�Ž���ͶƱ
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
            $.vote.mask = 'visible';
            $.vote.phone = undefined;
            $.vote.tooltiped = false;
            $.vote.error = "�ֻ����벻��ȷ��";
            $.vote.fail = "���Ѳ����������";
            $.vote.success = "";
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
                $.vote.mask = $("mask").style.visibility;
                $("mask").style.visibility = "hidden";
                $("votePop").style.visibility = "visible";
                $("votePop").style.backgroundPosition = "0px 0px";
            };
            $.vote.hidden = function(className){
                $.vote.status = false;
                $.vote.tooltiped = false;
                $.vote.current = undefined;
                $("mask").style.visibility = $.vote.mask;
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
            //������¼����绰����������˳�򼰽���
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed' style='visibility: hidden'><div id='flowedQuestionContainer' class='flowedQuestionContainer'></div></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
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
            $.buildUserInterface({flowed:[1],popup:undefined,vote:[{blocked:1 ,item:undefined,id: 233}],video:undefined,position:undefined,external:{after:undefined,before:undefined}});
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}

            focused(<%= focused %>, true);
        }
        function goBack(keyBack){
            if( blocked == focusable.length - 2) {
                if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {
                    $.vote.delete("phoneNumber"); return;
                } else  $.vote.hidden();
            }
            if( blocked == 1 || blocked == focusable.length - 2) {
                $("flowed").style.visibility = 'hidden';
                focusable[1].focus = 0;
                focusable[1].index = 0;
                focusable[1].result = 0;
                blocked = 0;
                $("mask").style.visibility = 'visible';
                focused(0,true);
                return;
            }
            if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
            if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
                if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                blocked = focusable[blocked].backed;
                focused(focusable[blocked].focus, true);
                return;
            }
            top.window.location.href = blocked == focusable.length - 1 && focusable[blocked].focus == 0 || EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
            if( blocked == 0 ) {
                blocked = 1;
                $("mask").style.visibility = 'hidden';
                $("flowed").style.visibility = 'visible';
                focusable[1].index = 0;
                focusable[1].result = 0;
                flowedShow(1);
                return;
            }
            if( blocked == 1 ) {
                if( focusable[1].focus < 10 ) {
                    var ix = focusable[1].index;
                    var result = ix == 0 ? 'A' : ( ix == 1 ? 'B' : 'C' );
                    focusable[1].result += ( result == focusable[1].items[focusable[1].focus].answer ? 1 : 0);
                    focusable[1].focus += 1;
                    focusable[1].index = 0;
                    flowedShow(1);
                }
                if( focusable[1].focus >= 10 ) {

                    var message = "ȫ�����";
                    $.vote.success = "������ɣ���ϲ������ȫ�����⣡";

                    if( focusable[1].result < 10 ){
                        message = "δ��ȫ���";
                        $.vote.success = "������ɣ���ϲ������&nbsp;" + focusable[1].result + "&nbsp;�����⣡";
                    }

                    $.vote.current = {};
                    $.vote.current.id = 233;
                    $.vote.current.message = message;
                    focusable[focusable.length - 2].backed = 1;
                    blocked = focusable.length - 2;
                    focusable[blocked].focus = 0;
                    $.vote();
                    focused(0, true);
                }
                return;
            }
            //��ҳ������
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
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/" + (isKorean ? "hj" : "high" ) + "_TV_detail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2015-08-14-Act.jpg') no-repeat;" onUnload="exit();"></body>
</html>