<%@ page contentType="text/html; charset=GBK" language="java" %>
<%@ include file="datajspHD/iCatchNew_zhuantihui_data.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
<title>ר���</title>
<link href="iCatch_image/main.css" rel="stylesheet" type="text/css"/>
<script language="javascript" type="text/javascript">
<!--
iPanel.eventFrame.initPage(window);
var listData = [];	//�б�����
var listObj = null;
var listFocusPos = 0;
var bigImgData = {};	//��ͼ����
var buttonData = [
    {name: "��ҳ", focusImg: "iCatch_image/footbtn1_01.png", lostFocusImg: "iCatch_image/footbtn0_01.png"},
    {name: "����", focusImg: "iCatch_image/footbtn1_02.png", lostFocusImg: "iCatch_image/footbtn0_02.png"}
];
var focusArea = 0;	//0�������б��ϣ�1�����ڴ�ͼ�ϣ�2�����ڰ�ť��
var buttonFocusPos = 0;	//0��������ҳ�ϣ�1�����ڷ�����


var marqueeText = "�������� ���������ƿ� �������ʽ�Ŀ��Ӱ�Ӵ�Ƭ���������㲥������72Сʱ�Ŀɻؿ�   �����㲥";	//���������

function eventHandler(eventObj, type) {
    switch (eventObj.code) {
        case "KEY_UP":
            udMove(-1);
            break;
        case "KEY_DOWN":
            udMove(1);
            break;
        case "KEY_LEFT":
            lrMove(-1);
            break;
        case "KEY_RIGHT":
            lrMove(1);
            break;
        case "KEY_SELECT":
            doSelect();
            break;
        case "KEY_BACK":
            doBack();
            break;
        case "KEY_MENU":
            doMenu();
            break;
        default:
            return 1;
            break;
    }

    return 0;
}

function init() {

    //��ʼ������
    initDatas();

    initList();
    $(bigImgData.id).src = bigImgData.img;

    if (focusArea == 1) {
        $("bigimgfocus").style.visibility = "visible";
    }
    else if (focusArea == 2) {
        $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
    }

    showMarquee();
}

//��ʼ������
function initDatas() {
    focusArea = icatchFocusArea;
    listFocusPos = icatchListFocusPos;
    listData = listTypeArray;
    bigImgData = recommendArray[0];
}


function delayInit() {
    init();
}

//��ʾ�����
function showMarquee() {
    $("marquee").innerText = E.marqueeText;
}

//��ʼ���б�
function initList() {
    listObj = new E.showList(8, listData.length, listFocusPos, 170, window);
    listObj.listHigh = 44;
    listObj.focusDiv = "listfocus";
    listObj.showType = 1;
    listObj.haveData = setList;
    listObj.notData = clearList;
    listObj.startShow();
    setArrowStyle();
    setListStyle();
    if (focusArea == 0) {
        $(listObj.focusDiv).style.visibility = "visible";
    }
}

//�����б�����
function setList(list) {
    $("list" + list.idPos).innerText = iPanel.misc.interceptString(listData[list.dataPos].name, 20);
}

//����б�����
function clearList(list) {
    $("list" + list.idPos).innerText = "";
}

//�����б���ʽ
function setListStyle() {
    if (listObj.dataSize > 0) {
        var name = listData[listObj.position].name;
        var tempName = iPanel.misc.interceptString(name, 20);

        if (name != tempName) {
            $(listObj.focusDiv).innerHTML = "<marquee style=\"width:325px; height:42px;\">" + name + "</marquee>";
        }
        else {
            $(listObj.focusDiv).innerText = tempName;
        }
    }
}

//�����ƶ�����
function udMove(num) {
    switch (focusArea) {
        case 0:	//�������б���
            if (listObj.position == 0 && num < 0) {
            }
            else if (listObj.position == listObj.dataSize - 1 && num > 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
                focusArea = 2;
            }
            else {
                listObj.changeList(num);
                setListStyle();
                setArrowStyle();
            }
            break;
        case 1:	//�����ڴ�ͼ��
            if (num > 0) {
                $("bigimgfocus").style.visibility = "hidden";
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
                focusArea = 2;
            }
            break;
        case 2:	//�����ڰ�ť��
            if (num < 0) {
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocusImg;
                $(listObj.focusDiv).style.webkitTransitionDuration = "0ms";
                listObj.changeList(listObj.listSize - listObj.focusPos - 1);
                $(listObj.focusDiv).style.visibility = "visible";
                $(listObj.focusDiv).style.webkitTransitionDuration = "100ms";
                focusArea = 0;
                setListStyle();
            }
            break;
    }
}

//�����ƶ�����
function lrMove(num) {
    switch (focusArea) {
        case 0:	//�������б���
            if (num > 0) {
                $(listObj.focusDiv).style.visibility = "hidden";
                $("bigimgfocus").style.visibility = "visible";
                focusArea = 1;
            }
            break;
        case 1:	//�����ڴ�ͼ��
            if (num < 0) {
                $("bigimgfocus").style.visibility = "hidden";
                $(listObj.focusDiv).style.visibility = "visible";
                focusArea = 0;
            }
            break;
        case 2:	//�����ڰ�ť��
            if (buttonFocusPos == 0 && num > 0) {
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocusImg;
                buttonFocusPos = 1;
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
            }
            else if (buttonFocusPos == 1 && num < 0) {
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].lostFocusImg;
                buttonFocusPos = 0;
                $("button" + buttonFocusPos).src = buttonData[buttonFocusPos].focusImg;
            }
            break;
    }
}

function doSelect() {
    switch (focusArea) {
        case 0:	//�������б���
            if (listObj.dataSize > 0) {
                /*
                 * ����ר������������Ӻ��޸�URL
                 */
                var data = listData[listObj.position];
                var typeurl = focusURL();
                if (data.name == 'ֱ��Ů�Ӱ����������') {
                    window.location.href = typeurl + "20151019girlMarathon.jsp?typeId=10000100000000090000000000105600&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == 'Ʊѡ������Ӱ���TOP10') {
                    window.location.href = typeurl + "20151215Film.jsp?typeId=10000100000000090000000000105764&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == 'Ůҽ�������㲻��������ҽ����') {
                    window.location.href = typeurl + "http://192.168.35.153:8080/huoDong_MingFei.jsp?lcn=mingfei";
                    return;
                }
                if (data.name == '����Ӣ�ݳ���Ʊ�����') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=142";
                    return;
                }
                if (data.name == '����ݮ���ֽ���Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=20";
                    return;
                }
                if (data.name == '��30����콱������Ӿ�') {
                    window.location.href = typeurl + "highvod_happy_classify.jsp?typeId=10000100000000090000000000105805&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '630���æ') {
                    window.location.href = typeurl + "20151014help.jsp";
                    return;
                }
                if (data.name == '������ ���з') {
                    window.location.href = typeurl + "2015autumn.jsp?typeId=10000100000000090000000000105554&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '2015���������������') {
                    window.location.href = typeurl + "cqlama3_index.jsp?typeId=10000100000000090000000000105402&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '����������ɽ��') {
                    window.location.href = typeurl + "20150818_cqyz.jsp?typeId=10000100000000090000000000105402&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�װٺδ�ս����') {
                    window.location.href = typeurl + "20150814_girlspk.jsp?typeId=10000100000000090000000000105388&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�������� ��ȫ���ż�') {
                    window.location.href = typeurl + "2015_summerSafety.jsp?typeId=10000100000000090000000000105347&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�и߿�ʵ�ñ���') {
                    window.location.href = typeurl + "2015gaoKao.jsp?typeId=10000100000000090000000000105178&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '����������ɼ�') {
                    window.location.href = typeurl + "FatherAndMother.jsp?typeId=10000100000000090000000000105148&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '����VS�� ���������') {
                    window.location.href = typeurl + "StockOrEstate.jsp?typeId=10000100000000090000000000105126&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�������ŵľ���') {
                    window.location.href = typeurl + "2015superStar.jsp?typeId=10000100000000090000000000105035&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '��ǣŮ����') {
                    window.location.href = typeurl + "2015women.jsp?typeId=10000100000000090000000000105006&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == 'ʧ��') {
                    window.location.href = typeurl + "sg.jsp?typeId=10000100000000090000000000105003&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '����������ʱ��') {
                    window.location.href = typeurl + "2015spring.jsp?typeId=10000100000000090000000000104987&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '���������ޡ�����') {
                    window.location.href = typeurl + "goodwife.jsp?typeId=10000100000000090000000000104981&pageSize=50&startIndex=0";
                    return;
                }
				if (data.name == '2014�ꡰ���') {
                    window.location.href = typeurl + "listIndex.jsp?typeId=001000&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '��TVB���������߾͹��ˣ�') {
                    window.location.href = typeurl +  "tvb2.jsp?typeId=10000100000000090000000000104849&pageSize=50&startIndex=0";
                    return;
                }
				if (data.name == '�����⻤�ɹ���') {
                    window.location.href = typeurl + "winterIndex.jsp?typeId=10000100000000090000000000104745&pageSize=100&startIndex=0";
                    return;
                }
				if (data.name == '��Ѫ�ж� �ഺ����') {
                    window.location.href = typeurl + "boyDream.jsp?typeId=10000100000000090000000000104677&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�ҵ���Ůʱ��') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_wdsnsd.jsp?src=akzq";
                    return;
                }
                if (data.name == '��Ī��ε�ݳ�����Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_mww.jsp?src=akzq";
                    return;
                }
                if (data.name == '��������ݳ�����Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_tfz.jsp?src=25";
                    return;
                }
                if (data.name == '���������ݳ�����Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=17";
                    return;
                }
                if (data.name == '����ͯ�������ֻ���Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/entrance.jsp?gpid=126";
                    return;
                }
                if (data.name == '������ζ �´����') {
                    window.location.href = typeurl + "http://192.168.9.77/index.html?page=1";
                    return;
                }
                if (data.name == '�к��������ü��ܴ����') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/STemplate2.jsp?typeId=10000100000000090000000000105782";
                    return;
                }
                if (data.name == '�����ɶ��ʶ���˹��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/STemplate2.jsp?typeId=10000100000000090000000000105923&voteId=100";
                    return;
                }
                if (data.name == '��ս��������') {
                    window.location.href = typeurl + "http://192.168.35.153:8080/weiqi.jsp?lcn=weiqi";
                    return;
                }
                if (data.name == '�㱬���������ʱȫ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160322.jsp";
                    return;
                }
                if (data.name == '3.15���ж�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160315.jsp";
                    return;
                }
                if (data.name == '��������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160310.jsp";
                    return;
                }
                if (data.name == '��Ҫ������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160308.jsp";
                    return;
                }
                if (data.name == '2016ȫ������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160307.jsp";
                    return;
                }
                if (data.name == '��ѧ��һ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160303.jsp";
                    return;
                }
                if (data.name == 'TFBOYS���㿪ѧ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160222.jsp";
                    return;
                }
                if (data.name == '�����ں��ۺ�֢') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160221.jsp";
                    return;
                }
                if (data.name == '2016�����������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160207.jsp";
                    return;
                }
                if (data.name == 'ϲ��֮����ѵ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160206.jsp";
                    return;
                }
                if (data.name == 'С����������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160201.jsp";
                    return;
                }
                if (data.name == '�а� �м�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160202.jsp";
                    return;
                }
                if (data.name == 'Holdס2016�����ִ�֮���ؼ�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160202-1.jsp";
                    return;
                }
                if (data.name == 'Holdס2016�����ִ�֮���ֺ���') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160128.jsp";
                    return;
                }
                if (data.name == '���ٲ����֮����׷�¾�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160127.jsp";
                    return;
                }
                if (data.name == '2016����굵��Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160120.jsp";
                    return;
                }
                if (data.name == '��ĩ��������Ӯ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160115.jsp";
                    return;
                }
                if (data.name == '2016�㲥���ӱ������´�������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160114.jsp";
                    return;
                }
                if (data.name == '��Ӱ����ΰ��Ŀƻ�ϵ�У������ս') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160105.jsp";
                    return;
                }
                if (data.name == '�������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151230.jsp";
                    return;
                }
                if (data.name == 'ְ������������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151224.jsp";
                    return;
                }
                if (data.name == '2015�ж������������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151223.jsp";
                    return;
                }
                if (data.name == '���껪 �뻶��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151218.jsp";
                    return;
                }
                if (data.name == 'ʮ���¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151203.jsp";
                    return;
                }
                if (data.name == 'ʮ�����������ů��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151215.jsp";
                    return;
                }
                if (data.name == '���Ǿ�Ԯ���������淨��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151125.jsp";
                    return;
                }
                if (data.name == '�������˱ؿ���ʮ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151105.jsp";
                    return;
                }
                if (data.name == 'ʮһ�¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151103.jsp";
                    return;
                }
                if (data.name == '��A-lin�ݳ�����Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8085/iptv/hdzq_alin.jsp?src=24";
                    return;
                }
                if (data.name == 'ɽ�ӹ��� ������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151027.jsp";
                    return;
                }
                if (data.name == '����֮���Ӱ��ʲô') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151009.jsp";
                    return;
                }
                if (data.name == '�Ա���������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150930.jsp";
                    return;
                }
                if (data.name == '����������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150929.jsp";
                    return;
                }
                if (data.name == '�ۇ���Ϯ �������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150925.jsp";
                    return;
                }
                if (data.name == '��սʤ��70����') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150814.jsp";
                    return;
                }
                if (data.name == 'Ũ������ͺ���') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150918.jsp";
                    return;
                }
                if (data.name == '���ף����') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150916.jsp";
                    return;
                }
                if (data.name == '���������ݳ�����Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=16";
                    return;
                }
                if (data.name == '�������������ݳ�����Ʊ') {
                    window.location.href = typeurl + "http://192.168.48.217:8082/epghd/1.html?pid=12";
                    return;
                }
                if (data.name == "007����ϵ��֮���鵳") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20151112.jsp";
                    return;
                }
                if (data.name == "���¹�Ӱָ��") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150912.jsp";
                    return;
                }
                if (data.name == "ʦ����ʫ") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150910.jsp";
                    return;
                }
                if (data.name == "ӭ��ѧ��У԰��Ӱ������") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150902.jsp";
                    return;
                }
                if (data.name == "��ٶ���Ҳ���") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150825.jsp";
                    return;
                }
                if (data.name == "��Ϧ���ʥ��") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150819.jsp";
                    return;
                }
                if (data.name == "���������۷����") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150807.jsp";
                    return;
                }
                if (data.name == "�ഺ �ܶ�ɽ�ǹ���") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150730.jsp";
                    return;
                }
                if (data.name == "������� ��Ӱ��ɶӴ") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150717.jsp";
                    return;
                }
                if (data.name == "��������������") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150714.jsp";
                    return;
                }
                if (data.name == "����Ů�˷������") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150708.jsp";
                    return;
                }
                if (data.name == "TVB���Ǽ����") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150624.jsp";
                    return;
                }
                if (data.name == "���¹�Ӱָ��") {//  2013-04-11
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150602.jsp";
                    return;
                }
                if (data.name == '��ͯ��ȫ��Ϊ�ֲ�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150529.jsp";
                    return;
                }
                if (data.name == '�Ҽ��з�Ҫװ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150522.jsp";
                    return;
                }
                if (data.name == '��ս����¼') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150511.jsp";
                    return;
                }
                if (data.name == '5�¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150430.jsp";
                    return;
                }
                if (data.name == 'ֱ���Ჴ��ǿ�ҵ���') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150429.jsp";
                    return;
                }
                if (data.name == '�ҹ�����Ϯ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150422.jsp";
                    return;
                }
                if (data.name == '�ٶ��뼤���ǰ������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150413.jsp";
                    return;
                }
                if (data.name == '4�¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150408.jsp";
                    return;
                }
                if (data.name == '��ͥ�ر���ѧ���ȳ�ʶ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150330.jsp";
                    return;
                }
                if (data.name == '��ϷŮ������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150325.jsp";
                    return;
                }
                if (data.name == '��ҹ������ζ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150217.jsp";
                    return;
                }
                if (data.name == '���꿴��Ϸ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150215.jsp";
                    return;
                }
                if (data.name == '����������н�����') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150305.jsp";
                    return;
                }
                if (data.name == '���������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150219.jsp";
                    return;
                }
                if (data.name == '����������ϸ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150213.jsp";
                    return;
                }
                if (data.name == '��һ���ط�ֻ������֪��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150209.jsp";
                    return;
                }
                if (data.name == '���¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20160309.jsp";
                    return;
                }
                if (data.name == '���¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150129.jsp";
                    return;
                }
                if (data.name == 'С�����١�������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150127.jsp";
                    return;
                }
                if (data.name == '��������3�����֮ս') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150123.jsp";
                    return;
                }
                if (data.name == '�̵�2014�곬�����㲥�Ⱦ�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141225.jsp";
                    return;
                }
                if (data.name == '����ů���Ӻ���') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150112.jsp";
                    return;
                }
                if (data.name == '�������껶����Ϯ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/S20150107.jsp";
                    return;
                }
                if (data.name == '2014��Ӱ�㲥��ĩ�̵�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141229.jsp";
                    return;
                }
                if (data.name == '����ͷ��Ϸһ��֮ң') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141222.jsp";
                    return;
                }
                if (data.name == '����һ���ů��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141215.jsp";
                    return;
                }
                if (data.name == 'ʮһ�¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141104.jsp";
                    return;
                }
                if (data.name == '����Ƭ�ļ�ǿ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141201.jsp";
                    return;
                }
                if (data.name == '�������μ�') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141127.jsp";
                    return;
                }
                if (data.name == '��Ƭ��ӳ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141024.jsp";
                    return;
                }
                if (data.name == 'ϲ��������') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140929.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '���ʴ�Խ����') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141114.jsp";
                    return;
                }
                if (data.name == '�������Ӷ���ɽ�ǵڶ���') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20141113.jsp";
                    return;
                }
                if (data.name == "ƭ�������") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "cheat.jsp?typeId=10000100000000090000000000104664&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�Ի�����˷�ɽ��") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "chihuo.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��ս���쵵֮ʮ�¹�Ӱָ��") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "OctmovieSeason.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��������ڶ���") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "cqlama2_index.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "�����߼������������") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "qiuys.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�ҵ��ϰ�·') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140920.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '���̫�̲���ͣ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140905.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '���ô�н�ٻ�����һ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140828.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == '9�¹�Ӱָ��') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140901.jsp?typeId=" + data.typeId;
                    return;
                }
                if (data.name == "��Ӱ���бʼ�") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "oneFilm.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�������ٶ���Ϯ") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "wuyazai.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��ҵ����ѱ��ҳа���") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "ceo.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�ഺ���ϣ������ۡ�����') {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "ladybro.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == '�����ʦ����ͨ') {
                    window.location.href = typeurl + "/EPG/jsp/neirong/A20140805.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "8�¹�Ӱָ��") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "AugmovieSeason.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��ٿ�ɶ������������") {//Ѱ������У��Style 2014-07-28
                    window.location.href = typeurl + "lookWhat.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��ս������PK��С��") {//Ѱ������У��Style 2014-05-28
                    window.location.href = typeurl + "JuezhanPK.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���ִ�ʦ��Ц���˻ỳ��") {//Ѱ������У��Style 2014-05-28
                    window.location.href = typeurl + "fenshouDaShi.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�����ֻ���Щ�¶�") {//Ѱ������У��Style 2014-05-28
                    window.location.href = typeurl + "mobilePhone.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���ڿƻô���ս") {//���ڿƻô���ս 2014-05-28
                    window.location.href = typeurl + "summerMovie.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�߿�ʵ�ñ���") {//Ѱ������У��Style 2014-05-28
                    window.location.href = typeurl + "entrance.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "Ѱ������У��Style") {//Ѱ������У��Style 2014-05-28
                    window.location.href = typeurl + "beautyUniform.htm?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�������Ӽ��껪") {//�������Ӽ��껪 2014-05-28
                    window.location.href = typeurl + "childAct.htm?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�������Ӣ�۷���") {//�������Ӣ�۷��� 2013-08-21
                    window.location.href = typeurl + "hero.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "������רҵ����ʮ����") {//������רҵ����ʮ���� 2013-08-21
                    window.location.href = typeurl + "JohnnyTo.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "����ı����") {//����ı���� 2013-08-21
                    window.location.href = typeurl + "zhang.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "·�����ഺ����") {//��33����۵�Ӱ���� 2013-08-21
                    window.location.href = typeurl + "lgqc.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�Ի��Ǳ�׷����ʳ��") {//��33����۵�Ӱ���� 2013-08-21
                    window.location.href = typeurl + "meisiju.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�óԲ����� ���ⴺ��") {//��33����۵�Ӱ���� 2013-08-21
                    window.location.href = typeurl + "delicious.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���¹�Ӱָ��") {//��33����۵�Ӱ���� 2013-08-21
                    window.location.href = typeurl + "maytide.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��33����۵�Ӱ����") {//��33����۵�Ӱ���� 2013-08-21
                    window.location.href = typeurl + "hongKongFilmAward.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�������Ӷ���ɽ��") {//���¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "spicy.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "TICO����ܶ�Ա") {//���¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "toyStory.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�����ӳ�������սʿ") {//���¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "CaptainAmerica.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���¹�Ӱָ��") {//���¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "th_ganyin.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��ɭ˹̹ɭ����ս����") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "JasonStatham.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��һվ��ȥ�Ķ�") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "TheNextStation.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "Ц������") {//Ц������ 2013-08-21
                    window.location.href = typeurl + "xlzb.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�����ǻ۲²²µ�����") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "guess3.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���������һ���") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "PeachBlossom.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�η������׵�Ӱ��") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "liaofan.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "Ů�ˣ�������") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "lvwzm.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "��˹��Ů��������") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "OOQ.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "3�¹�Ӱָ��") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "MarchMovieSeason.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�Ѳ���־��") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "ncwzw.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "Ԫ���������˽�") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "yxqrj.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "ʱ�䶼ȥ�Ķ���") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "sjqne.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "2014�����������") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "cjlh.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�������������˲���") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "Shirley.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�佱����ս") {//�佱����ս 2013-08-21
                    window.location.href = typeurl + "bjjdz.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���ֲʺ絺") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "klchd.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���¹�Ӱָ��") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "eygy.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�����Ҿ翴ɶӴ") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "cjbj.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���ٲ����") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "hjbjb.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���ٶ�����ϰ��") {//���ٶ�����ϰ�� 2013-08-21
                    window.location.href = typeurl + "hjbxb.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "���Ǹ��ֵڶ���") {//���Ǹ��ֵڶ��� 2013-08-21
                    window.location.href = typeurl + "iamsinger.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "1�¹�Ӱָ��") {//1�¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "JanuaryMovieSeason01.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "ʢŮ����ս") {//1�¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "sndzz.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�����⻤�ɹ���") {//�����⻤�ɹ��� 2013-08-21
                    window.location.href = typeurl + "nywhgd.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "2013������Ӱ�̵�") {//2013������Ӱ�̵� 2013-08-21
                    window.location.href = typeurl + "2013repd1.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "2013���ɴ���ĵ��Ӿ�") {//2013������Ӱ�̵� 2013-08-21
                    window.location.href = typeurl + "2013hktv.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "ʥ�����ҹ") {//ʥ�����ҹ 2013-08-21
                    window.location.href = typeurl + "ChristmasNightHurricane.jsp?typeId=" + data.typeId + "&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "�й�ʽ����") {//�й�ʽ���� 2013-08-21
                    window.location.href = typeurl + "zgsyl.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "12�¹�Ӱָ��") {//12�¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "summerMovieSeason.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�漣�ι���") {//�漣�ι��� 2013-08-21
                    window.location.href = typeurl + "qj2.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "������ ����50") {// ������ ����50 2013-08-21
                    window.location.href = typeurl + "jmbt50.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�����ǻ۲²²µڶ���") {// �����ǻ۲²²µڶ��� 2013-08-21
                    window.location.href = typeurl + "lifeWisdom2.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�ְ�ȥ�Ķ�") {// �ְ�ȥ�Ķ� 2013-08-21
                    window.location.href = typeurl + "wheredad01.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "���ǽ���") {// ���ǽ��� 2013-08-21
                    window.location.href = typeurl + "wegetmarried.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "ȫ���Ըж�������TOP10") {// ȫ���Ըж�������TOP10 2013-08-21
                    window.location.href = typeurl + "glableSexTop10.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "��Ϸ�������Ļ����") {// ��Ϸ�������Ļ���� 2013-08-21
                    window.location.href = typeurl + "yxsq_bg.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "11�¹�Ӱָ��") {// 11�¹�Ӱָ�� 2013-08-21
                    window.location.href = typeurl + "viewingGuide11.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "��������") {// �������� 2013-09-17
                    window.location.href = typeurl + "mldjt.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�ƽ���������") {// ����ŷý���� 2013-09-17
                    window.location.href = typeurl + "aiKeJiao.jsp?typeId=10000100000000090000000000102364&pageSize=50&startIndex=0";
                    return;
                }
                if (data.name == "����ŷý����") {// ����ŷý���� 2013-09-17
                    window.location.href = typeurl + "yxo_index.jsp?pTypeId=10000100000000090000000000102120&pSize=9&typeId=10000100000000090000000000102130&size=3";
                    return;
                }
                if (data.name == "������Ҷ��") {// ������Ҷ�� 2013-10-28
                    window.location.href = typeurl + "yxlyd.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "լ��Ů�����Ȼ�") {// լ��Ů�����Ȼ� 2013-10-28
                    window.location.href = typeurl + "ns_zyh.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�漣�ι���") {// �漣�ι��� 2013-10-28
                    window.location.href = typeurl + "qjmgc.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "˭�������еĴ���Ӣ��") {// ˭�������еĴ���Ӣ�� 2013-10-28
                    window.location.href = typeurl + "dgg_index.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "���ɼ�¼Ƭչ����") {// ���ɼ�¼Ƭչ���� 2013-09-17
                    window.location.href = typeurl + "ypjlp.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�����＾") {// �����＾ 2013-09-17
                    window.location.href = typeurl + "yzqj01.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "ȫ�����ܻ�ӭ������ɫTOP10") {// ȫ�����ܻ�ӭ������ɫTOP10 2013-09-17
                    window.location.href = typeurl + "zhy_animal.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "Խ��Խ�´�����") {// Խ��Խ�´����� 2013-09-17
                    window.location.href = typeurl + "damx.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "����ŷý����") {// ����ŷý���� 2013-09-02
                    window.location.href = typeurl + "yxo_index.jsp?pTypeId=10000100000000090000000000102120&pSize=9&typeId=10000100000000090000000000102130&size=3";
                    return;
                }
                if (data.name == "��ѧ��") {// ��ѧ�� 2013-09-02
                    window.location.href = typeurl + "schoolOpens.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "˵�ø��ȳ��ú�") {// ˵�ø��ȳ��ú� 2013-09-02
                    window.location.href = typeurl + "superOrator.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "С�ְ����³ɳ���") {// С�ְ����³ɳ��� 2013-08-26
                    window.location.href = typeurl + "wenzhang_index.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�˲���ĸǴ���") {// �˲���ĸǴ��� 2013-08-21
                    window.location.href = typeurl + "index_acl01.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�����ǻ۲²²�") {// �����ǻ۲²²� 2013-08-14
                    window.location.href = typeurl + "live_guess.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "���ڵ�֮���¹�Ӱָ��") {// ���ڵ�֮���¹�Ӱָ�� 2013-08-7
                    window.location.href = typeurl + "movieGuide8.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "������ĩ������ʱ��") {// ������ĩ������ʱ�� 2013-08-1
                    window.location.href = typeurl + "hollywood_times.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "���ڱ�׷���") {// ���ڱ�׷��� 2013-07-25
                    window.location.href = typeurl + "shuqi_zqj.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�ϵ�ͼ����������") {// �ϵ�ͼ���������� 2013-07-24
                    window.location.href = typeurl + "oldmap.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "�ҵ��ഺӳ���") {// �ҵ��ഺӳ��� 2013-07-18
                    window.location.href = typeurl + "myYouth.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "����С��������ϵ����") {// ����С��������ϵ���� 2013-07-10
                    window.location.href = typeurl + "dxhaizi.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "����ȥ̨��") {// ����ȥ̨�� 2013-07-08
                    window.location.href = typeurl + "comewithmeitotaibei.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "���ڹ۾�ָ��") {// ���ڹ۾�ָ�� 2013-07-04
                    window.location.href = typeurl + "sq_gy.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }

                if (data.name == "�༭���Ĺ���") {// �༭���Ĺ��� 2013-05-14
                    window.location.href = typeurl + "storyEditorialDept.jsp?typeId=" + data.typeId + "&pageSize=8&startIndex=0";
                    return;
                }
                if (data.name == "���繷Ѫ����") {// ���繷Ѫ���� 2013-03-26
                    window.location.href = typeurl + "hjg_index.jsp?typeId=" + data.typeId + "&pageSize=8&startIndex=0";
                    return;
                }
                if (data.name == "������лƲ�") {// ������лƲ�  2013-03-29
                    window.location.href = typeurl + "cnhb.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "����ӰƬ����") {// ����ӰƬ���� 2013-04-08
                    window.location.href = typeurl + "jxypds.jsp?typeId=" + data.typeId + "&pageSize=10&startIndex=0";
                    return;
                }
                if (data.name == "�ٱ�������") {// �ٱ������� 2013-04-03
                    window.location.href = typeurl + "changeable_wzl.jsp?typeId=" + data.typeId + "&pageSize=14&startIndex=0";
                    return;
                }
                if (data.name == "�ռ�����ս") {// �ռ�����ս 2013-04-11
                    window.location.href = typeurl + "zjgwz.jsp?typeId=" + data.typeId + "&pageSize=30&startIndex=0";
                    return;
                }
                if (data.name == "����Ů��������") {// �ռ�����ս 2013-04-11
                    window.location.href = typeurl + "syns.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "��Ц����") {// �ռ�����ս 2013-04-11
                    window.location.href = typeurl + "laughandsports.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "��Щ���Ƶ�����") {// �ռ�����ս 2013-04-11
                    window.location.href = typeurl + "theabsurddays.jsp?typeId=" + data.typeId + "&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "2013�������������") {
                    window.location.href = typeurl + "lm_index.jsp?typeId=10000100000000090000000000101780&pageSize=20&startIndex=0";
                    return;
                }
                if (data.name == "TICO��������") {//  2013-04-11
                    window.location.href = typeurl + "tico_baby.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "TICO������������") {//  2013-04-11
                    window.location.href = typeurl + "TICO_finals.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "����΢�Ŷ��ĺ�ȫ���н�����") {//  2013-04-11
                    window.location.href = typeurl + "weixinSurvey.htm?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "ѧ������") {//  2013-04-11
                    window.location.href = typeurl + "xueBa.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "7�¹�Ӱָ��") {//  2013-04-11
                    window.location.href = typeurl + "julyMovie.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == "������ʳ��֮����ϵ�����") {//  2013-04-11
                    window.location.href = typeurl + "tongueOfChongqing.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == 'ʮ��㳡�������������') {//  2013-04-11
                    window.location.href = typeurl + "dance10.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '����ˮħ�����������') {//  2013-04-11
                    window.location.href = typeurl + "water.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '���ڲ����֮����') {//  2013-04-11
                    window.location.href = typeurl + "summerfamous.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if (data.name == '���õ�������������Ů��') {//  2013-04-11
                    window.location.href = typeurl + "nvshen.jsp?typeId=" + data.typeId + "&pageSize=100&startIndex=0";
                    return;
                }
                if ("����" == data.name) {
                    window.location.href = typeurl + "search.jsp?typeId=" + listTypeId;
                }
                //������Ŀ
                else if (1 == data.hasSubType) {
                    window.location.href = typeurl + "type_second.jsp?typeId=" + data.typeId;
                } else {
                    //������Ŀ�н�Ŀ ���� ��������ĿҲ�޽�Ŀ
                    iPanel.eventFrame.showType = 0;//��ʾ�Ǹ�ͼƬ
                    window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=" + data.typeId + "&pageLength=8";
                }
            }
            break;
        case 1:	//�����ڴ�ͼ��
            var data = bigImgData;
            var typeurl = focusURL();
            if (data.name == '�㱬���������ʱȫ��') {
                window.location.href = typeurl + "/EPG/jsp/neirong/S20160322.jsp";
            } else {
                iPanel.eventFrame.showType = 0;//��ʾ�Ǹ�ͼƬ
                window.location.href = typeurl + "iCatch_yulq_list.jsp?typeId=" + data.typeId + "&pageLength=8";
            }
            break;
        case 2:	//�����ڰ�ť��
            if (buttonFocusPos == 0) {
                doMenu();
            }
            else {
                doBack();
            }
            break;
    }
}

//����ҳ
function doMenu() {
    iPanel.mainFrame.location.href = E.portal_url;
}

function doBack() {
    window.location.href = "<%=turnPage.go(-1)%>";
}

function focusURL() {
    var baseurl = "SaveCurrFocus.jsp?currFoucs=" + focusArea + "," + listObj.position + "&url=";
    return baseurl;
}

//���ü�ͷ��ʽ
function setArrowStyle() {
    if (listObj.focusPos == 0 && listObj.position == 0) {
        $("arrup").src = "iCatch_image/arrow_up0.png";
    }
    else {
        $("arrup").src = "iCatch_image/arrow_up1.png";
    }

    if (listObj.position == listObj.dataSize - 1) {
        $("arrdown").src = "iCatch_image/arrow_down0.png";
    }
    else {
        $("arrdown").src = "iCatch_image/arrow_down1.png";
    }
}
//-->
</script>
</head>

<body background="iCatch_image/zth_bg.jpg" leftmargin="0" topmargin="0" onLoad="javascript:init();">

<!--Logo-->
<div style="position:absolute; left:141px; top:56px; width:158px; height:36px;"><img src="iCatch_image/logo_title5.png"
                                                                                     width="158" height="36"/></div>

<!--Arrow-->
<div style="position:absolute; left:246px; top:148px; width:21px; height:15px;"><img src="iCatch_image/arrow_up0.png"
                                                                                     width="21" height="15" id="arrup"/>
</div>
<div style="position:absolute; left:246px; top:529px; width:21px; height:15px;"><img src="iCatch_image/arrow_down0.png"
                                                                                     width="21" height="15"
                                                                                     id="arrdown"/></div>

<!--Left List-->
<div style="position:absolute; left:85px; top:170px; width:340px; height:44px; background:url(iCatch_image/btm4_1.png) center no-repeat;-webkit-transition-duration:100ms;font-size:24px; color:#fefefe;line-height:44px; text-align:center; z-index:2; visibility:hidden;"
     id="listfocus"></div>
<div style="position:absolute; left:85px; top:170px; width:340px; height:352px;">
    <table width="340" height="352" border="0" cellspacing="0" cellpadding="0" class="btm4_0">
        <tr>
            <td width="340" height="44" id="list0"></td>
        </tr>
        <tr>
            <td height="44" id="list1"></td>
        </tr>
        <tr>
            <td height="44" id="list2"></td>
        </tr>
        <tr>
            <td height="44" id="list3"></td>
        </tr>
        <tr>
            <td height="44" id="list4"></td>
        </tr>
        <tr>
            <td height="44" id="list5"></td>
        </tr>
        <tr>
            <td height="44" id="list6"></td>
        </tr>
        <tr>
            <td height="44" id="list7"></td>
        </tr>
    </table>
</div>

<!--Poster-->
<div id="bigimgfocus"
     style="position:absolute; left:443px; top:123px; width:763px; height:441px; background:url(iCatch_image/focus06.png) center no-repeat; z-index:1; visibility:hidden;"></div>
<div style="position:absolute; left:453px; top:133px; width:742px; height:420px;"><img src="iCatch_image/global_tm.gif"
                                                                                       width="742" height="420"
                                                                                       id="bigimg"/></div>
<div style="position:absolute; left:447px; top:449px; width:24px; height:40px; background:url(iCatch_image/cover.png) center no-repeat; visibility:visible;"
     id="cover"></div>
<!--Bottom-->
<div style="position:absolute; left:55px; top:625px; width:250px; height:45px;">
    <div style="position:absolute; top:1px; left:0px; width:58px; height:44px;"><img src="iCatch_image/footicon.png"
                                                                                     width="58" height="44"/></div>
    <div style="position:absolute; top:3px; left:60px; width:90px; height:42px;"><img src="iCatch_image/footbtn0_01.png"
                                                                                      width="90" height="42"
                                                                                      id="button0"/></div>
    <div style="position:absolute; top:3px; left:133px; width:90px; height:42px;"><img
            src="iCatch_image/footbtn0_02.png" width="90" height="42" id="button1"/></div>
</div>
<div style="position:absolute; left:400px; top:630px; width:806px; height:40px; font-size:18px; color:#fff; line-height:40px;">
    <marquee id="marquee">
    </marquee>
</div>
<div style="position: absolute; left: 1065px; top: 121px; width: 140px; height: 145px; background: url(iCatch_image/new.png) center no-repeat; z-index:10;"></div>
</body>
</html>