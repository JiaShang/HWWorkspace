<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {"10000100000000090000000000106963","10000100000000090000000000106964","10000100000000090000000000106965","10000100000000090000000000106966"};
    final int[] position = {50,0,50,0,50,0,50,0};
    //TODO:ÿ����Ҫ�޸�
    int focused = 0, area = 0;
    final int popItemMaxCharLength = 36;

    String backUrl = "";
    String fromEPG = "";
    String value = "";
    String isKorean = "false";

    List<List<Vod>> list = null;

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

        if( !StringUtils.isEmpty( request.getParameter("group") ) )
            area = Integer.parseInt( request.getParameter("group") );

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
        list = new ArrayList<List<Vod>>();
        if( area == 0 ) area = 1;
        List<Vod> ls = getVodList( metaHelper, types[area - 1],position[( area - 1 ) * 2], position[( area - 1 ) * 2 + 1]);
        list.add( ls );


    } catch (Exception e){}
%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>�����赸����ͶƱҳ��</title>
    <style>
        .mask {position:absolute;background:transparent url('images/mask-2016-11-27-Vote.png') no-repeat;background-position: 0px 0px;}

        .title {width:130px;height:20px;left:387px;top:99px;background-position:0px 0px;}
        .title1{background-position:0px 0px;}
        .title2{background-position:0px -30px;}
        .title3{background-position:0px -90px;}
        .title4{background-position:0px -60px;}

        .flowed {width:750px;height:460px;position:absolute;left:53px;top:138px;}
        .flowedItem,.flowedItemFocus{width:750px;height:91px;float: left;position:relative;background-position: 0px -339px;}
        .flowedItemFocus{background-position: 0px -243px;}
        .name{position:absolute;width:350px;height:35px;font-size:28px;line-height: 32px;left:10px;top:10px;color:#bfa5b4;overflow: hidden;}
        .actor{position:absolute;width:350px;height:30px;font-size:20px;line-height: 28px;left:24px;top:50px;color:#bfa5b4;overflow: hidden;}
        .total{position:absolute;width:134px;height:25px;font-size:20px;line-height:25px;left:373px;top:37px;color:#bfa5b4;}
        .focus {color:white;}
        .vote,.voteFocus{width:203px;height:57px;left:524px;top:18px;position:absolute;background-position: 0px -120px;}
        .voteFocus{background-position:0px -180px;}

        .ranking{position:absolute;left:945px;top:122px;height:465px;width:300px;}
        .rankingItem{width:299px;height:76px;float:left;position:relative;}
        .rankingName,.rankingActor,.rankingTotal{position:absolute;color:#cccccc;left:3px;top:13px;width:210px;height:25px;font-size:18px;line-height: 22px;overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .rankingActor{top:40px;left:13px;font-size:16px;}
        .rankingTotal {width:70px;left:220px;top:38px; text-align: center;}
        .after {}

        .pageNum,.pageCount{width:21px;height: 22px;font-size:20px;color: white;position:absolute;overflow: hidden;left:817px;top:160px;line-height: 22px; text-align: center;}
        .pageCount {top:190px;}

        .popuped {width:633px;height: 426px;left:320px;top:187px;position:absolute;background:transparent url('images/popup.png') no-repeat 0px 0px; overflow: hidden;}
        .popuped .container{width:543px;height:298px;left:45px;top:38px;overflow:hidden;position: absolute;}
        .popuped .content{width:543px;height:auto;top:0px;left:0px;position: relative;}
        .popuped .item{width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #313131; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat 0px -426px; overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;}
        .popuped .maskItem {width:542px;font-size: 24px; height: 51px;padding-left: 56px; color: #fefefe; position:static;line-height:45px; background:transparent url('images/popup.png') no-repeat 0px -477px; overflow: hidden;}
        .popuped .maskItem .marqueed {font-size: 24px; height: 44px; width: 460px;color: #fefefe;line-height:44px;}
        .page {width:70px;height:22px;left:516px;top:348px;font-size:22px;text-align:right;line-height:22px;position:absolute; color: white; }

        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"����";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}

        .btnHome {position:absolute;background: transparent url("images/navBG.png") no-repeat; top:636px;left:1066px; width:161px;height:41px; background-position: 0px 0px;}
        .btnReturn{position:absolute;background: transparent url("images/navBG.png") no-repeat; top:636px;left:1066px; width:161px; height:41px; background-position: 0px -42px;}
    </style>
    <script language="javascript" type="text/javascript">
        <!--
        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};
        var blocked = blocked ? blocked : <%= area %>;

        var EPGflag = <%= "EPGflag".equalsIgnoreCase(fromEPG) ? "true" : "false" %>;
        //�����Ի���������б�����
        var popMaxItemsLength = 6;
        Date.prototype.Format = function(fmt)
        {
            var o = {
                "M+" : this.getMonth()+1,
                "d+" : this.getDate(),
                "h+" : this.getHours(),
                "m+" : this.getMinutes(),
                "s+" : this.getSeconds(),
                "q+" : Math.floor((this.getMonth()+3)/3),
                "S"  : this.getMilliseconds()
            };
            if(/(y+)/.test(fmt)) fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
            for(var k in o) if(new RegExp("("+ k +")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
            return fmt;
        };

        //�ɻ�ý�����������
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
                               "name:'" + vod.getName() + "'";
                            str += "}" ;
                            str += ( j + 1 < vodList.size()  ? "," : "");
                        value += str;
                    }
                    value += "]},";
                }
                out.write(value);
            }
            %>
            { focus:0,focusVote: false,voteId:383,groupName:'������������',items : [
                {actor:'����Ь����ѧУ',name:'���Ž����������',vote:'tjjl',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'����������Ρ�',vote:'xzlm',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'������С�ӡ�',vote:'xgxz',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'���¿�ʮ���ӡ�',vote:'xksz',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'��Wonderful dance��',vote:'wond',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'��bangbangbang��',vote:'bbbg',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'��ɺ���̡�',vote:'shsg',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'�����ֲ��ȡ�',vote:'klbg',mid:0,addon:500,count:0,playType:0},
                {actor:'�Ļ��ݴ��������ѵ����',name:'��ң������ҥ��',vote:'yyy',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'��С���������',vote:'xbdq',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'���Բ�ʿ����',vote:'mcsb',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'����÷�ޡ�',vote:'hmzn',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'���������ա�',vote:'mtdd',mid:0,addon:500,count:0,playType:0},
                {actor:'�Ļ��ݴ��������ѵ����',name:'���衷',vote:'xiag',mid:0,addon:500,count:0,playType:0},
                {actor:'�����������ѵѧУ',name:'��barbarbar��',vote:'bbbr',mid:0,addon:500,count:0,playType:0}
            ]},
            { focus:0,focusVote: false,voteId:384,groupName:'����������',items : [
                {actor:'����������ѵѧУ',name:'������֮�',vote:'lyzb',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'����Ƥ�衷',vote:'dpwu',mid:0,addon:500,count:0,playType:0},
                {actor:'�Ļ��ݴ��������ѵ����',name:'��Anaconda��',vote:'anaa',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'���������ѡ�',vote:'yylc',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'��Say My Name��',vote:'smne',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'�����꡷',vote:'qnin',mid:0,addon:500,count:0,playType:0},
                {actor:'�Ļ��ݴ��������ѵ����',name:'���ҵ���ա�',vote:'qdtk',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'��Dance��',vote:'dane',mid:0,addon:500,count:0,playType:0},
                {actor:'����������',name:'���ɹ��ˡ�',vote:'mgrn',mid:0,addon:500,count:0,playType:0},
                {actor:'�����ѧ',name:'����Ͽ��������̫��',vote:'sxjt',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'��Danceholic��',vote:'danc',mid:0,addon:500,count:0,playType:0},
                {actor:'�����ѧ',name:'��ϴ�¸衷',vote:'xyge',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'���ٻ�������',vote:'bhzy',mid:0,addon:500,count:0,playType:0},
                {actor:'�����ѧ',name:'�����㡷',vote:'hyan',mid:0,addon:500,count:0,playType:0},
                {actor:'����Ь����ѧУ',name:'����������',vote:'wmha',mid:0,addon:500,count:0,playType:0},
                {actor:'����������ѵѧУ',name:'�����ס�',vote:'fqig',mid:0,addon:500,count:0,playType:0}
            ]},
            { focus:0,focusVote: false,voteId:381,groupName:'������������',items : [
                {actor:'��ɽ��',name:'���������ˡ�',vote:'dtll',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'������ĺ������',vote:'mmdl',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'��С���衷',vote:'xjwu',mid:0,addon:500,count:0,playType:0},
                {actor:'�ٰ���',name:'��������ɱ䡷',vote:'zmdb',mid:0,addon:500,count:0,playType:0},
                {actor:'�׹��ֵ�',name:'������Ϊʲô�����졷',vote:'hrwh',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'����ѽ�ɡ�',vote:'fyfi',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'���ٻ����ޡ�',vote:'bhzy',mid:0,addon:500,count:0,playType:0},
                {actor:'Ұ����',name:'���Ȼ�����',vote:'shha',mid:0,addon:500,count:0,playType:0},
                {actor:'�ƽ���',name:'������������Ѳɽ��',vote:'dwjs',mid:0,addon:500,count:0,playType:0},
                {actor:'�׹��ֵ�',name:'��ϲ������꡷',vote:'xqfn',mid:0,addon:500,count:0,playType:0},
                {actor:'�˷���',name:'�����̡�',vote:'chhe',mid:0,addon:500,count:0,playType:0},
                {actor:'���ݽֵ�',name:'�����ݻ꡷',vote:'zzhn',mid:0,addon:500,count:0,playType:0},
                {actor:'���ݽֵ�',name:'�����硷',vote:'gfeg',mid:0,addon:500,count:0,playType:0},
                {actor:'�ƹ���',name:'��С���ڡ�',vote:'xmbt',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'����ʦ�������ס�',vote:'lsqq',mid:0,addon:500,count:0,playType:0},
                {actor:'ĥ����',name:'���ճ��ĺ��ӡ�',vote:'kqdz',mid:0,addon:500,count:0,playType:0},
                {actor:'�μ���',name:'������������',vote:'fdss',mid:0,addon:500,count:0,playType:0},
                {actor:'ʯ����',name:'�����������顷',vote:'ssbq',mid:0,addon:500,count:0,playType:0},
                {actor:'��Ϫ��',name:'�����Ϸ��顷',vote:'gyfq',mid:0,addon:500,count:0,playType:0},
                {actor:'��ʯ��',name:'���ɲ��衷',vote:'ccwu',mid:0,addon:500,count:0,playType:0}
            ]},
            { focus:0,voteId:382,focusVote: false,groupName:'���������',items : [
                {actor:'��ɽ��',name:'���ؼҵ�·��',vote:'hjdl',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'����ͬ��ԡ�',vote:'gtmd',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'�����˻���',vote:'fzha',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'�����˶��ܿ�ѷ����',vote:'mkew',mid:0,addon:500,count:0,playType:0},
                {actor:'�μ���',name:'��Ϧ���졷',vote:'xyhg',mid:0,addon:500,count:0,playType:0},
                {actor:'���ݽֵ�',name:'���������ϡ�',vote:'zzqy',mid:0,addon:500,count:0,playType:0},
                {actor:'�׹��ֵ�',name:'�����ݺö��ɡ�',vote:'zzhl',mid:0,addon:500,count:0,playType:0},
                {actor:'���ݽֵ�',name:'���޷��С�',vote:'lfxg',mid:0,addon:500,count:0,playType:0},
                {actor:'��Ϫ��',name:'��ӭ���衷',vote:'ycge',mid:0,addon:500,count:0,playType:0},
                {actor:'ʯ����',name:'������ɽ�顷',vote:'llsq',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'��˵�����ס�',vote:'scnp',mid:0,addon:500,count:0,playType:0},
                {actor:'�׹��ֵ�',name:'�������衷',vote:'kzwu',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'���̲���ȸ��',vote:'bbkq',mid:0,addon:500,count:0,playType:0},
                {actor:'�ٰ���',name:'�����㡷',vote:'aini',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'�����꽭�ϡ�',vote:'yyjn',mid:0,addon:500,count:0,playType:0},
                {actor:'������',name:'���ε�ҡ����',vote:'mdyl',mid:0,addon:500,count:0,playType:0}
            ]},
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
        var voteSwitch = (new Date()).Format("yyyy-MM-dd hh:mm:ss") < "2016-12-13 12:00:00";
        var flowCursorIndex = 0;
        var consign = undefined;                //�����������ݵ�
        var isKorean = <%= isKorean%>;                   //�Ƿ�Ϊ����
        var columns = 1; rows = 5;              //�������У������м���
        var pageCount = columns * rows;
        var arrows = [0,1];                     //�����ƶ�����ҳ���ذ�ť�Ĺ������£��ҡ�
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
                else if( blocked == focusable.length - 2 ) { if (focus == 0 && index == -11 ) {focus = 1; $("maskVote").style.visibility = "visible";} else if( focus >= 1 && index == 11) {focus = 0;$("maskVote").style.visibility = "hidden";} }
                else {
                    if( blocked == 0 || blocked >= 1 && blocked <= 4 && ( index == 11 && focus <= 0 || index == -11 && focus + 1 >= focusable[blocked].items.length || index == -1 && !voteSwitch  ) ) return;
                    if( blocked >= 1 && blocked <= 4 ) {
                        if ( index == 11 || index == -11 ) focus += index > 0 ? -1 : 1;
                        else if( voteSwitch ) {
                            if( index == 1 ) {
                                if( !focusable[blocked].focusVote ) focusable[blocked].focusVote = true;
                                else {
                                    focusable[focusable.length - 1].from = blocked;
                                    blocked = focusable.length - 1;
                                    focus = 0;
                                }
                            } else if( index == -1 ) {
                                if( !focusable[blocked].focusVote ) return;
                                focusable[blocked].focusVote = false;
                            }
                        } else {
                            focusable[focusable.length - 1].from = blocked;
                            blocked = focusable.length - 1;
                            focus = 0;
                        }
                    } else if( blocked == focusable.length -1 ) {
                        blocked = focusable[blocked].from;
                        focus = focusable[blocked].focus;
                    }
                }
                focusable[blocked].focus = focus;
            } else if( initilized ){
                if( blocked == focusable.length - 2 && $.vote.voted ) return;
                focusable[blocked].focus = focus = previous = index;
            }

            item =  focusable[blocked].items[focus];

            if(typeof item != 'undefined' && typeof item.style == 'string' )
                $( blocked == focusable.length - 2 ? "maskVote" : "mask").className = item.style;

            $("mask").style.visibility = blocked >= 1 && blocked <= 5 ? "hidden" : "visible";
            flowedShow(blocked >= 1 && blocked <= 4 ? blocked : focusable[focusable.length - 1].from);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            //ÿҳ��ʾ����
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            var stClass = "";
            var focusVote = focusable[index].focusVote;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='mask " + ( i == focus && blocked == index ? "flowedItemFocus" : "flowedItem" ) + "'>";
                stClass = i == focus && blocked == index && !focusVote ? " focus" : "";
                html += "<div class='name" + stClass + "'>" + item.name + "</div>";
                html += "<div class='actor" + stClass + "'>" + item.actor + "</div>";
                html += "<div class='total" + stClass + "'>��Ʊ��:" + ( item.count + item.addon  ) + "</div>";
                if( voteSwitch ) html += "<div class='mask " + ( i == focus && blocked == index && focusVote ? "voteFocus" : "vote" ) + "'></div>";
                html += "</div>";
                // ����
            }
            $("flowed").innerHTML = html;

            $("pageNum").innerHTML = Math.floor( focus / pageCount) + 1;
            $("pageCount").innerHTML =  Math.ceil( items.length / pageCount);
        }
        var sortAndShow = function (index, results){
            var sortByCount = function( x, y ) {
                return (y.count + y.addon) - (x.count + x.addon);
            };
            for( var i = 0 ; i < results.length; i++ ) {
                var name = results[i].name;
                for( var j = 0; j < focusable[index].items.length ; j ++ ) {
                    if( name != focusable[index].items[j].vote ) continue;
                    focusable[index].items[j].count = results[i].num;
                    break;
                }
            }
            var sortArray = focusable[index].items.concat([]);
            sortArray.sort(sortByCount);
            var html = "";
            for( var i = 0 ; i < 6 ; i++ ) {
                var item = sortArray[i];
                html += "<div class='rankingItem'>";
                html += "<div class='rankingName'>" + item.name + "</div>";
                html += "<div class='rankingActor'>" + item.actor + "</div>";
                html += "<div class='rankingTotal'>" + ( item.count + item.addon  ) + "</div>";
                html += "</div>";
            }
            $("ranking").innerHTML = html;
        }
        function queryVoteResult(voteId){
            $.ajax('http://192.168.49.56:8989/VoteStatistics/getVoteInfo?classifyID=' + voteId,function(result){
                sortAndShow(<%= area %>, result);
                flowedShow(<%= area %>);
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
                    var rtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_actorization.jsp?playType=1&progId=" + $.video.id + "&contentType=0&business=1&baseFlag=0&idType=FSN";
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
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=" + $.vote.phone +"&classifyID=" + $.vote.current.id + "&voteCount=10&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            $.vote.moreVote = result.result == false;
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.fail);
                        } else {
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.success);
                            queryVoteResult(focusable[<%= area %>].voteId);
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
            $.vote.fail = "��ͶƱ���࣡";
            $.vote.success = "ͶƱ�ɹ���";
            $.vote.moreVote = false;
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
            //������¼����绰����������˳�򼰽���
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "<div class='mask title title<%=area%>'></div>";
                if(typeof option.external.before == 'string') html += option.external.before;
                html += "<div id='flowed' class='flowed'></div>";
                html += "<div id='ranking' class='ranking'></div>";
                html += "<div id='pageNum' class='pageNum'>0</div><div id='pageCount' class='pageCount'>0</div>";
                if(typeof option.flowed != 'undefined' ) {
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                html += "<div id='mask'></div>";
                if(typeof option.external.after == 'string' ) html += option.external.after;
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
                if ( typeof option.video != 'undefined' ){ $.video.id = option.video; $.video.position = option.position; }
                document.body.innerHTML = html;
                if( typeof option.vote != 'undefined' ) $("maskVote").style.visibility = "hidden";
                $("mask").style.visibility = "hidden";
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

            for( var i = 0; i < focusable[blocked].items.length ; i++ )
                focusable[blocked].items[i].mid = typeof focusable[0].items[i] != 'undefined' ? focusable[0].items[i].mid : 0;

            focusable[blocked].typeId = focusable[0].typeId;

            var vote = [{ blocked: <%= area %>,item:undefined,id: focusable[<%= area %>].voteId }];
            $.buildUserInterface({flowed:undefined,popup:undefined,vote:vote,video:undefined,position:undefined,external:{after:undefined,before:undefined}}); //'<div class="after"></div>'
            if( focusable.length == 2 ) {blocked = focusable.length - 1;}
            focused(<%= focused %>, true);
            sortAndShow(<%= area %>, []);
            queryVoteResult(focusable[<%= area %>].voteId);
        }
        function goBack(keyBack){
            if( blocked == focusable.length - 2) { if(focusable[focusable.length-2].focus == 0 && !$.vote.voted)  {$.vote.delete("phoneNumber"); return;} else $.vote.hidden();}
            if( typeof focusable[blocked].popuped == 'boolean' ) $("popuped").style.visibility = "hidden";
            if( typeof focusable[blocked].vote == 'boolean' || typeof focusable[blocked].popuped == 'boolean' ){
                if(typeof focusable[blocked].previous != 'undefined') focusable[focusable[blocked].backed].focus = focusable[blocked].previous;
                blocked = focusable[blocked].backed;
                focused(focusable[blocked].focus, true);
                return;
            }
            if(typeof iPanel != 'undefined' && blocked == focusable.length - 1 && focus == 0 && iPanel.eventFrame.systemId == 1 ) {
                iPanel.eventFrame.exitToHomePage();
                return ;
            }
            top.window.location.href = blocked == focusable.length - 1 && focusable[blocked].focus == 0 || EPGflag || typeof keyBack == 'boolean' && !keyBack ? iPanel.eventFrame.portalUrl : backUrl;
        }
        function doEnter(){
            try{ E.is_HD_vod = true; } catch (e) {}
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
                case -3:
                    var url = '';
                    if( ! item.link.startWith('http') ){
                        url += $.current() + item.link;
                    } else {
                        url = item.link;
                        url += url.indexOf("?") > 0 ? '&' : '?';
                        url += 'backURL=';
                        url += encodeURIComponent('<%= request.getRequestURL().toString() %>?currFoucs=' + blocked + "," + focusable[blocked].focus);
                    }
                    top.window.location.href = url;
                    break;
                case 1:
                    top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/hddb/" + ( isKorean ? "hjzq/hj_tvD" : 'vod/tv_d') + "etail.jsp?vodId=" + item.mid + "&typeId=" + typeId;
                    break;
                case 0://ȥ������������ baseFlag=0
                    if( voteSwitch && blocked >= 1 && blocked <= 4 && focusable[blocked].focusVote ) {
                        $.vote.voted = $.vote.moreVote;
                        $.vote.current = {};
                        $.vote.current.id = typeof item.voteId == 'undefined' ? focusable[blocked].voteId : item.voteId;
                        $.vote.current.message = typeof item.text == 'undefined' ? item.vote : item.text;
                        focusable[focusable.length - 2].backed = blocked;
                        blocked = focusable.length - 2;
                        focusable[blocked].focus = 0;
                        $.vote();
                        focused(0, true);
                    } else {
                        if ( item.mid == 0 ) return;
                        top.window.location.href = $.current() + "/EPG/jsp/defaultHD/en/Authorization.jsp?typeId=" + typeId + "&playType=1&progId=" + item.mid + "&contentType=0&startTime=0&business=1";
                    }
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2016-11-27-Vote.jpg') no-repeat;" onUnload="exit();"></body>
</html>