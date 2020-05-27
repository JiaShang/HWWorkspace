<%@ page import="com.huawei.iptvmw.epg.bean.TurnPage" %>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ include file="util/util.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<%
    String typeId = request.getParameter("typeId");

    final String[] types = {};
    final int[] position = {11,0};
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
    <title>��¡����һ������֮����ѡ</title>
    <style>
        .mask {width:202px;height:236px;position:absolute;background:transparent url('images/mask-2017-07-08.png') no-repeat;background-position: 0px 0px;}

        .mask1 {left:272px;top:177px;}
        .mask2 {left:459px;top:177px;}
        .mask3 {left:646px;top:177px;}
        .mask4 {left:832px;top:177px;}
        .mask5 {left:1019px;top:177px;}
        .mask6 {left:272px;top:435px;}
        .mask7 {left:459px;top:435px;}
        .mask8 {left:646px;top:435px;}
        .mask9 {left:832px;top:435px;}
        .mask10 {left:1019px;top:435px;}

        .text {width:81px;height:22px;font-size:22px;color:white;text-align:right;position:absolute;background:transparent none no-repeat 0px 0px;overflow: hidden;}
        .text1 {left:360px;top:398px;}
        .text2 {left:551px;top:398px;}
        .text3 {left:737px;top:398px;}
        .text4 {left:928px;top:398px;}
        .text5 {left:1112px;top:398px;}
        .text6 {left:360px;top:656px;}
        .text7 {left:551px;top:656px;}
        .text8 {left:737px;top:656px;}
        .text9 {left:928px;top:656px;}
        .text10 {left:1112px;top:656px;}

        .flowed {left: 0px;top:0px;width:1280px;height:720px;background:transparent none;position:absolute;}

        .after {left: 0px;top:0px;width:1280px;height:720px;background:transparent url('images/focusBg-2017-07-08.png') no-repeat 0px 0px;position:absolute;}
        .descript {position:absolute;width:421px;height: 383px;font-size:18px;line-height:20px;color:black;left:440px;top:151px;overflow: hidden;}

        .btnVoteNormal{width:129px;height:44px;left:499px;top:593px;background-position: -210px 0px;}
        .btnReturnNormal{width:129px;height:44px;left:653px;top:593px;background-position: -210px -100px;}
        .btnVote{width:129px;height:44px;left:499px;top:593px;background-position: -210px -50px;}
        .btnReturn{width:129px;height:44px;left:653px;top:593px;background-position: -210px -150px;}
        /*overflow:hidden;word-break:keep-all;white-space:nowrap;text-overflow:ellipsis;*/
        .voteContainer{position:absolute;width:590px;height:299px;left:362px;top:198px;background: transparent url("images/voteBg.png") no-repeat 0px 0px;}
        .phoneNumberInput{position:absolute; width:218px;height:22px; left:190px; top:118px; background-color:transparent;color:#ffffff;font-family:"����";font-size:22px;}
        .btnSure{position:absolute;width:117px;height:42px;left:492px;top:379px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -300px;}
        .btnCancel{position:absolute;width:116px;height:42px;left:704px;top:378px;background: transparent url("images/voteBg.png") no-repeat;background-position: 0px -350px;}
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
            { focus:0,items : [
                {name:'������',count:0,descript:'���������У��������������Ĳ��������ڹ�����Ա�������������Ǽ����Ľ���һ��࣬������һ��ര�ڹ�����ʱ�����Ϊ���Ⱥ�ڷ�����Ϊ�Լ����Ҫ�������ϼ�ǿѧϰ������ҵ�� ������Ĳ����ܿ��Ϊ��ͨҵ��ĹǸɣ����������������Ǳ�͹淶�����ķ�������չʾ�Լ��ķ���ˮƽ�����ڹ����в��ϴ��¹�����������ȫ��ȫ��Ϊ���������ں�������ʵ��ʵ�ʹ�����ȥ��������ýڼ���Ϊ�����㵽���ڰ��µ�Ⱥ�����ŷ����ⲻ����������Ⱥ��֮��ĸ��飬�����ܵ�Ⱥ�ڵĸ߶Ⱥ�����2016������ݵǼ�2500������Ȩ�Ǽ�280����'},
                {name:'���',count:0,descript:'��责�Ů����ѧ�Ļ�����¡���������Ǽ����ĳ����ݳ�ʼ�ǼǴ��ڹ�����Ա�����ڹ��������������������ļ�ֵ�ۣ�����ʱʱ���ϸ�ķ����׼�淶�Լ������У�����ϵķ���̬�ȽӴ�����Ⱥ�ڡ��Ž�ͬ�£����ϼ�ǿѧϰ����������Լ���ҵ��ˮƽ��������������Ⱥ�ڣ��ù�Ӳ��ҵ��֪ʶ��ʵ���ж����������������ĸ�Ч������ʵ�᳹���Źܷ������������������Ȩ���Źܽ�ϡ��Ż�������2016�깤���У����1574�ʴ���ҵ�����У������ݳ�ʼ�ǼǽӼ�64�ʡ�ת�ƵǼ�1499�ʡ��ڽ����̱���Ǽ�11�ʵȡ�������������µ�ͬʱ����Ч���񣬾������������ҵȺ���������ȣ������õľ����ò���������ķ����������ϸ�Ĵ��ڷ������ߡ�'},
                {name:'��С��',count:0,descript:'��С�����У���2005���������������Ĵ��ڹ�����ʮ����������ƾ��ᶨ������������ھ�ҵ�����ʷ�����Ⱥ�ڣ����Ϲִ᳹�й��Һ��м���˰���뷨�ɷ����Լ�������Ʊ�ݹ���취������ʵ�淶�˲���Ʊ��ʹ�ã�Ԥ�����շѵ���Ϊ�������ϸ����߱�׼������������շ�˰������Ӧ�վ�������ַ����˷�˰����Ϊ�����۲ơ�������ã�Ϊȫ�����÷�չ������һ���Ĺ��ס���2016�꣬��װ����ϵͳ��������ҵ��λ��Ʊ��63���������Ų���Ʊ��1��490��474��(��������������Ʊ��878��535��(������ȫ����˰�����ܼ�138��016��Ԫ(����������)�����ڹ����ɼ�ͻ�����Ⱥ��α��������������Ļ�����������Ϊ����������Աʾ���ڡ����㹫��Ա��'},
                {name:'����',count:0,descript:'���٣�Ů����ѧ�Ļ����й���Ա�����罨ί���ڹ�����Ա����ͬ־����¡�����������������Ĵ��ڹ���9����������ģ��ִ�е���·�ߡ����롢���ߡ�����һ�а�һ�У�Ǳ�����У���ʵ�ʹ���ҵ��������Ϊ���黳������Ŀǰ�ۼư��3000�������ȡ���н������׷�2��8ǧ����Ԫ������ʴﵽ100�������õ���������������������Ա������Ҳ�õ���������ĺ�������α���Ϊ�������Ƚ����ˡ���������֮�ǡ������ڳ��罨ί����Ҳ��α���Ϊ�����촰�ڡ�������Աʾ���ڡ���'},
                {name:'������',count:0,descript:'��������Ů��2016��9�½�����������¡���ط�˰�����˰�������Ĺ���������ȫ�ظ�����Ʊ֤����Ͱ칫�����ڡ��ϰ�ʱ�������渺���̬�Ȱ��ÿ���£��°������ҵ��ʱ����ѧ˰�����ƻ�Ȼ���֪ʶ���ڹ���ѧϰһ���º󣬱�˳��ͨ����˰��ִ���ʸ��ԣ���Ϊ��һ��˰�����ߡ�ȥ����ĩ��Ԫ���ڷ�������������������Ĳ�Ʊ��Ʊ�жȹ�����һֱ���ڿҿҡ�������Թ�Ĺ������ѳ�ԭ��:�����뷨������˽�Ľ�֯��ײ�У�������ң�Ŭ�����ﰮ�ھ�ҵ����˽���׵ľ�����������׷���������˼����Ѱ��������'},
                {name:'������',count:0,descript:'�����֣��У���פ��������ί���ڶ��ꡣ�����ڼ䣬�ϸ����ظ�������ƶȣ���������ҵҵ�������Ч������Ϊ������ҵȺ��������������������ڴ��ڱ�׼�������У��ϸ�淶����������Ϊ������һ���Ը�֪������������̣����̰���ʱ�ޣ�Ŭ�����¹���ģʽ���Է������ع滮��չ����Ŀʵ�и�֪��ŵ��ʵʩ������ĿԤԼ����2016�����ȫ������Ͷ����Ŀ189���������ص���Ŀ����������86����'},
                {name:'��Ǭ��',count:0,descript:'��Ǭ����Ů����ѧ�Ļ����������������Ĺ��̴��ڹ�����Ա���ڴ��ڹ����н���Χ�ơ�315��Ŀ�꣬��֡������İ��������㡱�����ŵ��������Ϊ��ȷ���˸���ĸ�����������ĸ��ʩ�ƽ��������ٽ��г�����ӿ췢չ�����������ƶȸĸ��аѼ���ǰ����Ŀ��ʵ����ҵ����֤��һ�����塰��֤��һ����������������ϵͳ���Ż�����ʽ�����и��幤�̻�����ע����������ȫ���Ե�ʵʩ��ҵ����ע����Ϊ�ĸ�ͷ���Ⱥ�ڵ��ص㡣��ֹĿǰ��Ϊȫ����������г�����3884�����ۼƷ�չ27410���������������'},
                {name:'������',count:0,descript:'�����ã�Ů���������������������ڹ�����Ա�����¹��¿���ҵ��������ҵ��ɡ����ñ�ը��Ʒ���̻�������������ɼ����������߾�֤���������������������������������������ڹ��������������Ч�ܡ����±����������Ϊ����㣬�����и�����������ʩΪץ�֣�����߷���������ʵ��Ⱥ������ΪĿ�ꡣ��2016�꣬������������������6313�������Ⱥ����ѯ1000���˴Ρ����ڰ�ʱ����ʡ��ֳ�����ʡ�Ⱥ�������ʾ�Ϊ100%����һͶ�ߺ�����'},
                {name:'����',count:0,descript:'������Ů���Բμӹ�������������ģ��ִ�е���·�ߡ����롢���ߣ����ع��ҷ��ɡ����棬�����λ���ܷ���ȡ�����������ǰ������ǰ���������ģ����ͷ���á���ҵ���ϣ��������У�ϵͳѧϰ�������˻�������֪ʶ������ָ����������������Ϊ�˱�֤�������ص���Ŀ��أ���ʱ���м��������ź���Ŀ���赥λ��Ǣ�����Э���л����֣��л���Ժ���йص�λ����֤��������Ůɽ������Ŀ���ƿڵ�վ�ȶ����Ŀ˳����ͨ��������2009��μ�ȫ����һ����ȾԴ�ղ��ڼ䣬�Կ����ͣ�����100�����ҹ�Ӱ�,˳����ɹ������񣬱��ֳ����ر��ܳԿࡢ�ر������͡��ر���ս�����ر��ܷ��ס��ľ�������ȾԴ�ղ顢������Ŀ������̬����������ˮԴ������������Ŀ�������������ȸ�����У��侫տ��ҵ��ͻ����ҵ��������Ĺ�������Ҳ�õ���ҵĳ�ֿ϶�����α�����������ί��������Ϊ�Ƚ����ˡ�'},
                {name:'��ܷ�',count:0,descript:'��ܷ壬�У���ѧ�Ļ����������������Ľ�ί���˹ܣ����ڹ�����Ա�����ڴ��ڹ����ڼ䣬��������ҵ�����ڵİ������̣���ŵ�涨�����ڰ��ҵ����ѭ�����顢��Ч���淶����ϸ���������ķ���ԭ��Χ��������ͨ���󡢷���Ⱥ�ڵĹ���Ŀ�꣬���������������2016�꣬��ί�˹ܼ��ۺ�ִ����ӹ�������ɷ�������5500��������а����·�������֤��158������ҵ�ʸ�֤�°� 49������ҵ�ʸ�֤����3161�������䳵������2127������ʱ����ʺ������ʾ���100%��'},
                {name:'����',count:0,descript:'����Ů������������������ҵ���ڹ�����Ա�����ڹ�������������Ϊ��ҵ��Ⱥ�����룬����Ⱥ�ڶ���·����������ѧϰҵ��֪ʶ��ҵ���ܡ�����Ϊȫ���ش���Ŀ���񣬻�������������������λ�Ͳ����漰��ҵ�õػ�������ҵ������Э��������2016�깲�����ֵ���ռ������85������ľ�ɷ����11����ľ���������27����½��Ұ������ѱ����ֳ���23����½��Ұ�����ﾭӪ���28����½��Ұ�������������5�������˼���71����ľ�ļӹ����9����������ľ������Ӫ���2����'},
                {name:'����',count:0,descript:'����Ů����������������ʳҩ�ര�ڹ�����Ա����2014��4�µ����Ĵ��ڹ���������ʼ�ռ��������������������ķ���ԭ���μǡ����񡢹淶�����ࡢ��Ч���ķ�����ּ������ǻ�Ĺ�������͸߶ȵľ�ҵ�������Ⱥ�ڣ���ʵ����Ⱥ��������񴰿ڣ����š�Ⱥ��������С�¡���ԭ����ƽ���ĸ�λ���ͷų���ƽ����������2016�꣬��������������1672���������°��1102��������203�������96����ע��265��������6����'},
                {name:'����',count:0,descript:'���ǣ�Ů��2014��9�±�ƸΪ����ί���ڹ�����Ա�������ڼ䣬��ʼ���μǡ�����Ⱥ�ڡ�������ҵ��������㡱����ּ���ԡ�ΪȺ�ڰ���¡���Ⱥ�ںð��¡�ΪҪ�������ɼ�������ҵҵ������ͬ�»�����������ٸ��飬���ڶ���ʱ��ֻ����һ��ֵ�أ�����Ա���١�������ȴ���ܼ�������£�ֻ�п�Ч�ʡ�ʱ������֤����ͳ�ƣ�2016�꣬���ڽ���Ⱥ����ѯԼ3000�˴Σ��������������Ŀ1154���Σ����������֤7152�ţ�����ʼ�ռ�ֳ��ڡ������ɡ��������������ϸڣ���ҵ�񾫡�Ч�ʸ�Ϊ���ϣ�ȷ���˸������Բ����ɣ�ʵ�������ʲ��٣������ˡ����������㳬�ڡ�����δ���������Ⱥ���������¼���ʼ�ձ�����Ͷ�ߡ��Ⱥ���Ϊ��ȡ��Ƚ����ˡ������ڱ���Ϊ�����촰�ڡ�������ͬ־���չ�����������ֹ����ϡ��Ȱ�������ڵ������Կ����͵ľ����ò��Ϊ��90�������˱��ʡ�'}
            ]},
            { focus:0, vote:true, items : [
                {name:'',style:'mask btnVote',playType:-2},
                {name:'����',style:'mask btnReturn'}
            ]},
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
        var columns = 5; rows = 2;              //�������У������м���
        var pageCount = columns * rows;
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
            if(/(y+)/.test(fmt))
                fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
            for(var k in o)
                if(new RegExp("("+ k +")").test(fmt))
                    fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
            return fmt;
        };
        var voteSwitch = (new Date()).Format("yyyy-MM-dd hh:mm:ss") < "2017-07-13 00:00:00";
        function focused(index,initilized){
            if( focusable.length <= 1 ) return;
            var focus = focusable[blocked].focus, previous = 0;
            var item =  focusable[blocked].items[focus];
            if(typeof index == "number" && !initilized){
                //��:11,��:-11,��-1,��1
                //���������ͶƱ��,���������Ҽ�ʱ
                if( blocked == focusable.length - 1 ) return;
                else {
                     if( blocked == 0  && (
                         index == 11 && focus < columns || //���Ϲ���ʱ
                         index == -1 && focus % columns == 0 || //�������ʱ
                         index == 1 && focus % columns == columns - 1 || //���ҹ���ʱ
                         index == -11 && ( ( columns == 1 && focus + 1 >= focusable[blocked].items.length ) || ( columns > 1 && ( Math.floor( focus / columns ) == Math.floor( focusable[blocked].items.length / columns ) )) ) //���¹���ʱ   && focus + columns != focusable[blocked].items.length (���һ��δ����ʱ)
                     ) || blocked == 1 && (index == 11 || index == -11 || index == -1 && focus == 0 || index == 1 && focus + 1 >= focusable[blocked].items.length )) return;
                     //TODO:���������ҳ�����ذ�ť��ʱ����ͬʱ���ϣ�������ص���Ŀ��ʱ����Ҫ��д����ƶ�����
                    if( blocked == 0 ) {
                        if( index == 1 || index == -1 ) focus += index;
                        else if( index == 11 ) focus -= columns;
                        else if( index == -11 ) focus += columns;
                        if( focus >= focusable[blocked].items.length ) { focus = focusable[blocked].items.length - 1 ; }
                    } else if( blocked == 1 ) {
                        focus += index;
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

            for( var o in focusable.flowed ) flowedShow(focusable.flowed[o]);
        }
        var flowedShow = function(index){
            if( typeof index == 'undefined' ) return;
            var focus = focusable[index].focus;
            var items = focusable[index].items;
            //ÿҳ��ʾ����
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;

            document.body.style.backgroundImage = 'url("images/bg-2017-07-08-' +  ( Math.floor(focus  / pageCount) + 1) + '.jpg")';
            var html = '';
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='text text" + ( i % pageCount + 1 ) + "'>" + item.count + "</div>";
                if( blocked != index || i != focus ) continue;
                $("mask").className = "mask mask" + ( i % pageCount + 1 );
            }
            $("flowed").innerHTML = html;
        }
        var showUserItemInfo = function() {
            var desc = focusable[0].items[focusable[0].focus].descript;
            var html = '';
            if(voteSwitch) {
                $.vote.message = focusable[1].items[0].name = focusable[0].items[focusable[0].focus].name;
                html += '<div class="mask btnVoteNormal"></div><div class="mask btnReturnNormal"></div>';
            }
            html += '<div class="descript">' + desc + "</div>";
            $("after").innerHTML = html;
            $("after").style.visibility = 'visible';
            $("mask").className = focusable[1].items[focusable[1].focus].style;
        }
        var sortAndShow = function (index, results){
            for( var i = 0 ; i < results.length; i++ ) {
                var name = results[i].name;
                for( var j = 0; j < focusable[0].items.length ; j ++ ) {
                    if( name != focusable[0].items[j].name ) continue;
                    focusable[0].items[j].count = results[i].num;
                    break;
                }
            }
            var focus = focusable[0].focus;
            var items = focusable[0].items;
            var html = '';
            flowCursorIndex = Math.floor(focus / pageCount) * pageCount;
            var length = items.length - flowCursorIndex >= pageCount ? pageCount : items.length - flowCursorIndex;
            for(var i = flowCursorIndex; i < flowCursorIndex + length; i += 1) {
                var item = items[i];
                html += "<div class='text text" + ( i % pageCount + 1 ) + "'>" + (item.count == '' ? 0 : item.count) + "</div>";
            }
            $("flowed").innerHTML = html;
        }
        function queryVoteResult(){
            try {
                $.ajax('http://192.168.49.56:8989/VoteStatistics/getVoteInfo?classifyID=394',function(result){
                    sortAndShow(0,result);
                });
            } catch ( e ) {};
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
                //�����ʾ����ʾ��ȡ����ʾ�����ʾ��������ʾ�����
                //if($('votePop').style.visibility == 'hidden' || $.vote.tooltiped ) { $.vote.show(); return;}
                if( blocked == focusable.length - 1 && focusable[focusable.length - 1].focus == focusable[focusable.length - 1].items.length - 1 ) { goBack(); return; }
                else {
                    //���� $.vote.current.message, $vote.current.id ����Ϊ��ʱ�Ž���ͶƱ
                    if(typeof $.vote.current.message != "string" || typeof $.vote.current.id == "undefined" ) return;
                    var cardId = CA.card.serialNumber;
                    //�����ͳ��
                    //http://192.168.49.56:8080/voteNew/external/clickCount.ipanel?icid=8230003190017318&classifyID=100&content=44
                    //ר��ͶƱ����
                    var url = "http://192.168.49.56:8080/voteNew/external/addVote4.ipanel?icid=" + cardId + "&phone=13999999999&classifyID=" + $.vote.current.id + "&voteCount=15&content=" + encodeURIComponent($.vote.current.message);
                    $.ajax(url,function(result){
                        if(result.recode != '002' || result.result == false ){
                            $.vote.voted = result.result == false;
                            $.vote.tooltip($.vote.fail);
                        } else {
                            $.vote.voted = true;
                            $.vote.tooltip($.vote.success);
                            queryVoteResult();
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
            $.vote.fail = "����ͶƱ���࣡";
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
            //������¼����绰����������˳�򼰽���
            $.vote.focus = {}
            $.current = function (){
                return "/EPG/jsp/defaultHD/en/SaveCurrFocus.jsp?currFoucs=" + blocked + "," + focusable[blocked].focus + "&url=";
            };
            $.buildUserInterface = function(option){
                var html = "";
                if(typeof option.external.before == 'string') html += option.external.before;
                if(typeof option.flowed != 'undefined' ) {
                    html += "<div id='flowed' class='flowed'></div>";
                    focusable.flowed = [];
                    for(var i = 0; i< option.flowed.length; i++){ focusable[option.flowed[i]].flowed = true; focusable.flowed[i] = option.flowed[i];}
                }
                if(typeof option.external.after == 'string' ) html += option.external.after;
                html += "<div id='mask'></div>";
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
            if( !voteSwitch ) focusable[1].items = focusable[1].items.slice(1);
            $.buildUserInterface({flowed:[0],vote:[{blocked:1,item:undefined,id:394}],video:undefined,position:undefined,external:{after:'<div class="after" id="after" style="visibility: hidden"></div>',before:undefined}}); //
            focused(<%= focused %>, true);
            queryVoteResult();
        }
        function goBack(keyBack){
            if( blocked == 1 ) {
                blocked = 0;
                $("after").style.visibility = 'hidden';
                focused(focusable[0].focus, true);
                return;
            }
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
            if( blocked == 0 ) {
                blocked = 1; focusable[1].focus = 0;showUserItemInfo(); return;
            }
            if( blocked == 1 && (!voteSwitch && focusable[blocked].focus == 0 || voteSwitch && focusable[blocked].focus == 1  )) {
                blocked = 0;
                $("after").style.visibility = 'hidden';
                focused(focusable[0].focus, true);
                return;
            }
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
                    $.vote.voted = $.vote.moreVote = false;
                    $.vote.current = {};
                    $.vote.current.id = focusable[blocked].voteId;
                    $.vote.current.message = typeof item.name == 'undefined' ? item.vote : item.name;
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
<body leftmargin="0" topmargin="0" style="overflow:hidden; background:black url('images/bg-2017-07-08-1.jpg') no-repeat;" onUnload="exit();"></body>
</html>