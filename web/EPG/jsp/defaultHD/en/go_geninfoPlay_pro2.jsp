<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="../../common4dtv/jsp/config.jsp" %>
<%@ page import="java.util.*"%>
<%!

public List getAllProdList(){
	StringBuffer strLists = new StringBuffer();
	
strLists.append("prodCode:100159#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:100160#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:100161#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:100189#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130000#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130001#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130002#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130003#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130004#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130005#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130006#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:130007#comboId:1279#comboName:\"������ѧȫ���\"#type:0;");
strLists.append("prodCode:100202#comboId:1348#comboName:\"��ͯ�������������ײ�\"#type:0;");
strLists.append("prodCode:100236#comboId:1295#comboName:\"��������ȫ�����ײ�\"#type:0;");
strLists.append("prodCode:100236#comboId:1294#comboName:\"��������ȫ�����ײ�\"#type:0;");
strLists.append("prodCode:100203#comboId:1312#comboName:\"�׶�Ӣ������ײ�\"#type:0;");
strLists.append("prodCode:100203#comboId:1313#comboName:\"�׶�Ӣ������ײ�\"#type:0;");
strLists.append("prodCode:100377#comboId:1428#comboName:\"Hifi����\"#type:0;");
strLists.append("prodCode:100377#comboId:1532#comboName:\"Hifi�����Ż��ײ�\"#type:0;");
strLists.append("prodCode:100278#comboId:1533#comboName:\"i12�����Ż��ײ�\"#type:0;");
strLists.append("prodCode:100278#comboId:1432#comboName:\"i12������\"#type:0;");
strLists.append("prodCode:100325#comboId:1433#comboName:\"i12����Ȧ\"#type:0;");
strLists.append("prodCode:100332#comboId:1434#comboName:\"i12�ǻ���\"#type:0;");
strLists.append("prodCode:100247#comboId:1361#comboName:\"TVBר��\"#type:0;");
strLists.append("prodCode:100311#comboId:1436#comboName:\"�����������\"#type:0;");
strLists.append("prodCode:100315#comboId:1437#comboName:\"������������\"#type:0;");
strLists.append("prodCode:100312#comboId:1438#comboName:\"�����������\"#type:0;");
strLists.append("prodCode:100316#comboId:1447#comboName:\"��������ʳӪ��\"#type:0;");
strLists.append("prodCode:100313#comboId:1439#comboName:\"���������շ�\"#type:0;");
strLists.append("prodCode:100321#comboId:1440#comboName:\"������DIY\"#type:0;");
strLists.append("prodCode:100319#comboId:1441#comboName:\"������������԰\"#type:0;");
strLists.append("prodCode:100320#comboId:1442#comboName:\"������ʱ�мҾ�\"#type:0;");
strLists.append("prodCode:100314#comboId:1443#comboName:\"�����������˶�\"#type:0;");
strLists.append("prodCode:100309#comboId:1444#comboName:\"�����������\"#type:0;");
strLists.append("prodCode:100308#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100309#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100310#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100311#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100312#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100313#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100314#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100315#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100316#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100317#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100318#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100319#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100320#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100321#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100322#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100323#comboId:1539#comboName:\"�������Ż��ײ�\"#type:0;");
strLists.append("prodCode:100308#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100309#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100310#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100311#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100312#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100313#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100314#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100315#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100316#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100317#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100318#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100319#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100320#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100321#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100322#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100323#comboId:1398#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100317#comboId:1445#comboName:\"��������������\"#type:0;");
strLists.append("prodCode:100323#comboId:1446#comboName:\"��������Ȥ����\"#type:0;");
strLists.append("prodCode:100310#comboId:1448#comboName:\"�������٤ʱ��\"#type:0;");
strLists.append("prodCode:100318#comboId:1449#comboName:\"�������в�����\"#type:0;");
strLists.append("prodCode:100322#comboId:1450#comboName:\"������ְҵ��ѵ\"#type:0;");
strLists.append("prodCode:100308#comboId:1451#comboName:\"�������л�̫��\"#type:0;");
strLists.append("prodCode:100174#comboId:1534#comboName:\"�ʺ��ݳ����Ż��ײ�\"#type:0;");
strLists.append("prodCode:100383#comboId:1504#comboName:\"�ʺ����ֳ����\"#type:0;");
strLists.append("prodCode:100378#comboId:1429#comboName:\"�����\"#type:0;");
strLists.append("prodCode:100264#comboId:1430#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100384#comboId:1514#comboName:\"��ʿ����Ϸ\"#type:0;");
strLists.append("prodCode:100306#comboId:1487#comboName:\"�¶�������ѧǰ������\"#type:0;");
strLists.append("prodCode:100305#comboId:1368#comboName:\"�¶�������ѧǰ��\"#type:0;");
strLists.append("prodCode:100364#comboId:1431#comboName:\"��Ƥ��Ϸ\"#type:0;");
strLists.append("prodCode:100173#comboId:1359#comboName:\"�ʺ�����+�ٿ�ѧԷ30���ػ�\"#type:0;");
strLists.append("prodCode:100176#comboId:1359#comboName:\"�ʺ�����+�ٿ�ѧԷ30���ػ�\"#type:0;");
strLists.append("prodCode:100420#comboId:1649#comboName:\"�汾����\"#type:0;");
strLists.append("prodCode:100421#comboId:1566#comboName:\"�������İ����ײ�\"#type:0;");
strLists.append("prodCode:100421#comboId:1567#comboName:\"�������İ����ײ�\"#type:0;");
strLists.append("prodCode:100421#comboId:1565#comboName:\"��������\"#type:0;");
strLists.append("prodCode:100346#comboId:1497#comboName:\"����ѧ�������������\"#type:0;");
strLists.append("prodCode:100346#comboId:1402#comboName:\"����ѧ����������\"#type:0;");
strLists.append("prodCode:100345#comboId:1501#comboName:\"����ѧ��ְҵ���Խ������\"#type:0;");
strLists.append("prodCode:100345#comboId:1405#comboName:\"����ѧ��ְҵ���Խ���\"#type:0;");
strLists.append("prodCode:100258#comboId:1536#comboName:\"������Ϸ�Ż��ײ�\"#type:0;");
strLists.append("prodCode:100258#comboId:1399#comboName:\"������Ϸ\"#type:0;");
strLists.append("prodCode:100365#comboId:1435#comboName:\"������԰\"#type:0;");
strLists.append("prodCode:100390#comboId:1522#comboName:\"ʥ����Ϸ\"#type:0;");
strLists.append("prodCode:100328#comboId:1453#comboName:\"���콡������\"#type:0;");
strLists.append("prodCode:100328#comboId:1452#comboName:\"���콡��\"#type:0;");
strLists.append("prodCode:100419#comboId:1648#comboName:\"ͯ����԰\"#type:0;");
strLists.append("prodCode:100349#comboId:1496#comboName:\"����ѧ��Сѧ�������\"#type:0;");
strLists.append("prodCode:100349#comboId:1401#comboName:\"����ѧ��Сѧ����\"#type:0;");
strLists.append("prodCode:100282#comboId:1494#comboName:\"�¶������ж��꼶����\"#type:0;");
strLists.append("prodCode:100281#comboId:1493#comboName:\"�¶������ж��꼶\"#type:0;");
strLists.append("prodCode:100280#comboId:1492#comboName:\"�¶�������ȫ�꼶����\"#type:0;");
strLists.append("prodCode:100282#comboId:1492#comboName:\"�¶�������ȫ�꼶����\"#type:0;");
strLists.append("prodCode:100284#comboId:1492#comboName:\"�¶�������ȫ�꼶����\"#type:0;");
strLists.append("prodCode:100279#comboId:1413#comboName:\"�¶�������ȫ�꼶\"#type:0;");
strLists.append("prodCode:100281#comboId:1413#comboName:\"�¶�������ȫ�꼶\"#type:0;");
strLists.append("prodCode:100283#comboId:1413#comboName:\"�¶�������ȫ�꼶\"#type:0;");
strLists.append("prodCode:100284#comboId:1491#comboName:\"�¶����������꼶����\"#type:0;");
strLists.append("prodCode:100283#comboId:1490#comboName:\"�¶����������꼶\"#type:0;");
strLists.append("prodCode:100280#comboId:1489#comboName:\"�¶�������һ�꼶����\"#type:0;");
strLists.append("prodCode:100279#comboId:1488#comboName:\"�¶�������һ�꼶\"#type:0;");
strLists.append("prodCode:100288#comboId:1486#comboName:\"�¶������ж��꼶����\"#type:0;");
strLists.append("prodCode:100287#comboId:1485#comboName:\"�¶������ж��꼶\"#type:0;");
strLists.append("prodCode:100286#comboId:1484#comboName:\"�¶�������ȫ�꼶����\"#type:0;");
strLists.append("prodCode:100288#comboId:1484#comboName:\"�¶�������ȫ�꼶����\"#type:0;");
strLists.append("prodCode:100290#comboId:1484#comboName:\"�¶�������ȫ�꼶����\"#type:0;");
strLists.append("prodCode:100285#comboId:1414#comboName:\"�¶�������ȫ�꼶\"#type:0;");
strLists.append("prodCode:100287#comboId:1414#comboName:\"�¶�������ȫ�꼶\"#type:0;");
strLists.append("prodCode:100289#comboId:1414#comboName:\"�¶�������ȫ�꼶\"#type:0;");
strLists.append("prodCode:100290#comboId:1483#comboName:\"�¶����������꼶����\"#type:0;");
strLists.append("prodCode:100289#comboId:1482#comboName:\"�¶����������꼶\"#type:0;");
strLists.append("prodCode:100286#comboId:1481#comboName:\"�¶�������һ�꼶����\"#type:0;");
strLists.append("prodCode:100285#comboId:1480#comboName:\"�¶�������һ�꼶\"#type:0;");
strLists.append("prodCode:100272#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100273#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100274#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100275#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100276#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100277#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100280#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100282#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100284#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100286#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100288#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100290#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100292#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100294#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100296#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100298#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100301#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100304#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100306#comboId:1531#comboName:\"�¶�����ѧ���\"#type:0;");
strLists.append("prodCode:100266#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100267#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100268#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100269#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100270#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100271#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100279#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100281#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100283#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100285#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100287#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100289#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100291#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100293#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100295#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100297#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100299#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100302#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100305#comboId:1530#comboName:\"�¶�����ѧ��\"#type:0;");
strLists.append("prodCode:100300#comboId:1479#comboName:\"�¶����и�ȫ�̾���199/����\"#type:0;");
strLists.append("prodCode:100301#comboId:1478#comboName:\"�¶����и�ȫ�̾���299/��\"#type:0;");
strLists.append("prodCode:100299#comboId:1367#comboName:\"�¶����и�����\"#type:0;");
strLists.append("prodCode:100273#comboId:1477#comboName:\"�¶���Сѧ���꼶����\"#type:0;");
strLists.append("prodCode:100267#comboId:1476#comboName:\"�¶���Сѧ���꼶\"#type:0;");
strLists.append("prodCode:100277#comboId:1475#comboName:\"�¶���Сѧ���꼶����\"#type:0;");
strLists.append("prodCode:100271#comboId:1474#comboName:\"�¶���Сѧ���꼶\"#type:0;");
strLists.append("prodCode:100272#comboId:1473#comboName:\"�¶���Сѧȫ�꼶����\"#type:0;");
strLists.append("prodCode:100273#comboId:1473#comboName:\"�¶���Сѧȫ�꼶����\"#type:0;");
strLists.append("prodCode:100274#comboId:1473#comboName:\"�¶���Сѧȫ�꼶����\"#type:0;");
strLists.append("prodCode:100275#comboId:1473#comboName:\"�¶���Сѧȫ�꼶����\"#type:0;");
strLists.append("prodCode:100276#comboId:1473#comboName:\"�¶���Сѧȫ�꼶����\"#type:0;");
strLists.append("prodCode:100277#comboId:1473#comboName:\"�¶���Сѧȫ�꼶����\"#type:0;");
strLists.append("prodCode:100266#comboId:1416#comboName:\"�¶���Сѧȫ�꼶\"#type:0;");
strLists.append("prodCode:100267#comboId:1416#comboName:\"�¶���Сѧȫ�꼶\"#type:0;");
strLists.append("prodCode:100268#comboId:1416#comboName:\"�¶���Сѧȫ�꼶\"#type:0;");
strLists.append("prodCode:100269#comboId:1416#comboName:\"�¶���Сѧȫ�꼶\"#type:0;");
strLists.append("prodCode:100270#comboId:1416#comboName:\"�¶���Сѧȫ�꼶\"#type:0;");
strLists.append("prodCode:100271#comboId:1416#comboName:\"�¶���Сѧȫ�꼶\"#type:0;");
strLists.append("prodCode:100274#comboId:1472#comboName:\"�¶���Сѧ���꼶����\"#type:0;");
strLists.append("prodCode:100268#comboId:1471#comboName:\"�¶���Сѧ���꼶\"#type:0;");
strLists.append("prodCode:100275#comboId:1470#comboName:\"�¶���Сѧ���꼶����\"#type:0;");
strLists.append("prodCode:100269#comboId:1469#comboName:\"�¶���Сѧ���꼶\"#type:0;");
strLists.append("prodCode:100276#comboId:1468#comboName:\"�¶���Сѧ���꼶����\"#type:0;");
strLists.append("prodCode:100270#comboId:1467#comboName:\"�¶���Сѧ���꼶\"#type:0;");
strLists.append("prodCode:100272#comboId:1466#comboName:\"�¶���Сѧһ�꼶����\"#type:0;");
strLists.append("prodCode:100266#comboId:1465#comboName:\"�¶���Сѧһ�꼶\"#type:0;");
strLists.append("prodCode:100294#comboId:1464#comboName:\"�¶����¸���������\"#type:0;");
strLists.append("prodCode:100293#comboId:1463#comboName:\"�¶����¸������\"#type:0;");
strLists.append("prodCode:100292#comboId:1462#comboName:\"�¶����¸���ȫ������\"#type:0;");
strLists.append("prodCode:100294#comboId:1462#comboName:\"�¶����¸���ȫ������\"#type:0;");
strLists.append("prodCode:100296#comboId:1462#comboName:\"�¶����¸���ȫ������\"#type:0;");
strLists.append("prodCode:100298#comboId:1462#comboName:\"�¶����¸���ȫ������\"#type:0;");
strLists.append("prodCode:100291#comboId:1415#comboName:\"�¶����¸���ȫ��\"#type:0;");
strLists.append("prodCode:100293#comboId:1415#comboName:\"�¶����¸���ȫ��\"#type:0;");
strLists.append("prodCode:100295#comboId:1415#comboName:\"�¶����¸���ȫ��\"#type:0;");
strLists.append("prodCode:100297#comboId:1415#comboName:\"�¶����¸���ȫ��\"#type:0;");
strLists.append("prodCode:100296#comboId:1461#comboName:\"�¶����¸����������\"#type:0;");
strLists.append("prodCode:100295#comboId:1460#comboName:\"�¶����¸�������\"#type:0;");
strLists.append("prodCode:100298#comboId:1459#comboName:\"�¶����¸����Ĳ����\"#type:0;");
strLists.append("prodCode:100297#comboId:1458#comboName:\"�¶����¸����Ĳ�\"#type:0;");
strLists.append("prodCode:100292#comboId:1457#comboName:\"�¸���һ�����\"#type:0;");
strLists.append("prodCode:100291#comboId:1456#comboName:\"�¶����¸���һ��\"#type:0;");
strLists.append("prodCode:100303#comboId:1455#comboName:\"�¶�����˼ȫ�̾�������\"#type:0;");
strLists.append("prodCode:100304#comboId:1454#comboName:\"�¶�����˼ȫ�̾�������\"#type:0;");
strLists.append("prodCode:100302#comboId:1417#comboName:\"�¶�����˼ȫ�̾���\"#type:0;");
strLists.append("prodCode:100399#comboId:1527#comboName:\"�Ҹ�������\"#type:0;");
strLists.append("prodCode:100262#comboId:1537#comboName:\"�ż���Ϸ�Ż��ײ�\"#type:0;");
strLists.append("prodCode:100262#comboId:1369#comboName:\"�ż���Ϸ\"#type:0;");
strLists.append("prodCode:100379#comboId:1510#comboName:\"����789�ҷ���ѵ����\"#type:0;");
strLists.append("prodCode:100379#comboId:1505#comboName:\"����789�ҷ���ѵ\"#type:0;");
strLists.append("prodCode:100380#comboId:1509#comboName:\"����789�������ϰ���\"#type:0;");
strLists.append("prodCode:100380#comboId:1506#comboName:\"����789��������\"#type:0;");
strLists.append("prodCode:100424#comboId:1659#comboName:\"����789\"#type:0;");
strLists.append("prodCode:100381#comboId:1507#comboName:\"����789�����ѧ\"#type:0;");
strLists.append("prodCode:100382#comboId:1508#comboName:\"����789��ɩ��ѵ\"#type:0;");
strLists.append("prodCode:100389#comboId:1538#comboName:\"ӳ�Ե羺�Ż��ײ�\"#type:0;");
strLists.append("prodCode:100389#comboId:1519#comboName:\"ӳ�Ե羺\"#type:0;");
strLists.append("prodCode:100348#comboId:1498#comboName:\"����ѧ���׽̽������\"#type:0;");
strLists.append("prodCode:100348#comboId:1403#comboName:\"����ѧ���׽̽���\"#type:0;");
strLists.append("prodCode:100172#comboId:1328#comboName:\"�ʺ翨��OK\"#type:0;");
strLists.append("prodCode:100173#comboId:1330#comboName:\"�ʺ�����MV\"#type:0;");
strLists.append("prodCode:100174#comboId:1331#comboName:\"�ʺ������ݳ���\"#type:0;");
strLists.append("prodCode:100175#comboId:1339#comboName:\"Ȥζ�����\"#type:0;");
strLists.append("prodCode:100176#comboId:1337#comboName:\"����������\"#type:0;");
strLists.append("prodCode:100177#comboId:1336#comboName:\"����-������\"#type:0;");
strLists.append("prodCode:100178#comboId:1332#comboName:\"����-������\"#type:0;");
strLists.append("prodCode:100179#comboId:1333#comboName:\"����-С����\"#type:0;");
strLists.append("prodCode:100180#comboId:1340#comboName:\"����-����·\"#type:0;");
strLists.append("prodCode:100181#comboId:1334#comboName:\"����-ѧǰ��\"#type:0;");
strLists.append("prodCode:100183#comboId:1335#comboName:\"����-������\"#type:0;");
strLists.append("prodCode:100196#comboId:1370#comboName:\"����Ϸ\"#type:0;");
strLists.append("prodCode:100347#comboId:1499#comboName:\"����ѧ����Ӥ�������\"#type:0;");
strLists.append("prodCode:100347#comboId:1404#comboName:\"����ѧ����Ӥ����\"#type:0;");
strLists.append("prodCode:100392#comboId:1540#comboName:\"������羺�Ż��ײ�\"#type:0;");
strLists.append("prodCode:100392#comboId:1520#comboName:\"������羺\"#type:0;");
strLists.append("prodCode:100350#comboId:1500#comboName:\"����ѧ����ѧ�������\"#type:0;");
strLists.append("prodCode:100350#comboId:1406#comboName:\"����ѧ����ѧ����\"#type:0;");

	strLists.append("prodCode:100473#comboId:1853#comboName:\"���㲥��ͨ��Ʒ\"#type:0;");	
	strLists.append("prodCode:100375#comboId:1495#comboName:\"���������\"#type:0;");
	strLists.append("prodCode:100185#comboId:1155#comboName:\"����ר��\"#type:0;");
	strLists.append("prodCode:100186#comboId:1160#comboName:\"ǿ��������\"#type:0;");
	strLists.append("prodCode:100417#comboId:1543#comboName:\"�ſ�ר��\"#type:0;");
	strLists.append("prodCode:100359#comboId:1395#comboName:\"���ר��\"#type:0;");
	strLists.append("prodCode:100359#comboId:1396#comboName:\"��˰����\"#type:0;");
	strLists.append("prodCode:100359#comboId:1397#comboName:\"��˰���\"#type:0;");
	strLists.append("prodCode:100360#comboId:1382#comboName:\"Ӣ����ר��\"#type:0;");
	strLists.append("prodCode:100360#comboId:1421#comboName:\"Ӣ����ר������\"#type:0;");
	strLists.append("prodCode:100326#comboId:1386#comboName:\"�Ӱ���ר��\"#type:0;");
	strLists.append("prodCode:100326#comboId:1521#comboName:\"�Ӱ���ר��ȫ���ײ�\"#type:0;");
	strLists.append("prodCode:100247#comboId:1361#comboName:\"TVBר��\"#type:0;");	
	strLists.append("prodCode:100247#comboId:1543#comboName:\"�ſ�ר��\"#type:0;");		
	strLists.append("prodCode:100247#comboId:1542#comboName:\"�ſ�ר��ȫ��\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1541#comboName:\"�Ѻ�ר��\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1545#comboName:\"�Ѻ�ר��(����)\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1546#comboName:\"�Ѻ�ר������\"#type:0;");			
	strLists.append("prodCode:100418#comboId:1547#comboName:\"�Ѻ�ר��ȫ�����\"#type:0;");		
	strLists.append("prodCode:100398#comboId:1529#comboName:\"â��TV\"#type:0;");
	strLists.append("prodCode:100250#comboId:1418#comboName:\"1T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100363#comboId:1418#comboName:\"1T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100361#comboId:1419#comboName:\"2T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100363#comboId:1419#comboName:\"2T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100362#comboId:1420#comboName:\"5T�ƿռ�\"#type:0;");
	strLists.append("prodCode:100363#comboId:1420#comboName:\"5T�ƿռ�\"#type:0;");
	
	strLists.append("prodCode:406015#comboId:1680#comboName:\"4Kר��\"#type:1#webUrl:192.168.15.19\"#pkgName:\"com.ipanel.chongqing_ipanelforhw-com.ipanel.join.cq.vod.detail.DetailActivity\";");
	strLists.append("prodCode:406010#comboId:1680#comboName:\"4Kר��\"#type:1#webUrl:192.168.15.19\"#pkgName:\"com.ipanel.chongqing_ipanelforhw-com.ipanel.join.cq.vod.detail.DetailActivity\";");
	
	strLists.append("prodCode:402001#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402002#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402003#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402004#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402005#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402006#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402007#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402008#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402009#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402010#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");	
	strLists.append("prodCode:402011#comboId:1683#comboName:\"ǿ��������\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");	
	
	strLists.append("prodCode:404000#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404001#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404002#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404003#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404006#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404008#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404009#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404005#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404016#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404018#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404020#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404099#comboId:1682#comboName:\"ɳ��Ժ��\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");

	
	strLists.append("prodCode:403000#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403001#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403002#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403003#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403004#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403005#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403006#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403007#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403008#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403009#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403010#comboId:1681#comboName:\"�й�����Ժ��\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	
	
	
	String[] array = (strLists.toString()).split(";");
	ArrayList<Map> tmpList = new ArrayList<Map>();
	for(int i = 0 ; i < array.length; i++){
		HashMap<String, String> tmpMap = new HashMap<String, String>();
		String[] tmparr = array[i].split("#");
		for(int j = 0; j < tmparr.length; j++){
			String[] curarr = tmparr[j].split(":");
			if(curarr[0].equals("webUrl"))curarr[1] = "\"http://"+curarr[1];
			tmpMap.put("\""+curarr[0]+"\"", curarr[1]);
		}
		tmpList.add(tmpMap);
	}
	return tmpList;
}

%>
<%
	System.out.println("go geninfoPlayin=");
	Map resultMp = new HashMap();
	resultMp = (Map) request.getAttribute("resultMp");
	String comeType = (String) request.getAttribute("comeType"); //�жϻؿ���Դ
	String mess = (String) resultMp.get("message");
	String FSNId = (String)resultMp.get("neVodId");
	//String price = (String)resultMp.get("price");
	//String spName = (String)resultMp.get("spName");
	//System.out.println("geninfo_nor FSNId =="+FSNId+",spName=="+spName);
	if(mess == null)
	{
		mess = "����ʧ��";
	}
		
	Object confirmMarkObj = resultMp.get("confirmMark");//����Ƿ��߹����ζ�������
	boolean confirmMark = (null != confirmMarkObj);
	
	Object o = resultMp.get("Anci_flag");
	String Anci_flag = null;
	if(null != o)
	{
		Anci_flag = o.toString();
	}
	

	
	// ���������Ȩҳ����ת·��
	String confirmUrl = "";
	
	//������صĴ���������Ҫ������,�������û���������
	if("Anci_flag".equals(Anci_flag))
	{
		//��Ŀ���
		String vodId = (String) resultMp.get("progId");
		//�������(���õ��Ӿ�)
		String supVodId = (String) resultMp.get("parentVodId");
		//��������
		String contentType = (String) resultMp.get("contentType");
		//ҵ������
		String businessType = (String) resultMp.get("businessType");
		//��Ʒ����
		Map prodObj = (Map)resultMp.get("prodObj");
		//��Ʒ���
		String prodcode = (String)prodObj.get("PROD_CODE");
		//������
		String serviceId = (String)prodObj.get("SERVICE_CODE");
		//������ʶ
		String continueType = ((Integer)prodObj.get("PROD_CONTINUEABLE")).toString();
		// ��С���ڲ���Ƭ��ʱ�贫��˲�������trickmode�Ĳ���
		String tkmode = (String)resultMp.get("tkmode");
		// ��С���ڲ���Ƭ��ʱ�贫��˲�������osd����ʾ
		String osd = (String)resultMp.get("osd");
		//��������
		String playType = (String)resultMp.get("playtype");
		//Ƶ�����
		String chanId = (String)resultMp.get("chanId");
		//��Ŀ���
		String typeId = (String)resultMp.get("typeId");
		//���ŵĿ�ʼʱ��
		String startTime = (String)resultMp.get("starttime");
		//ý��ID
		String mediaId = (String)resultMp.get("mediaId");
		//�ⲿID
		String neVodId = (String)resultMp.get("neVodId");
		//spName
		String spName = (String)resultMp.get("spName");
		//price
		String price = (String)resultMp.get("price");
	
		confirmUrl = request.getScheme() + "://" + request.getServerName()
                     + ":" + request.getServerPort() + request.getContextPath() + "/jsp/defaultHD/en/Confirm_pay.jsp?"
		                     + "prodcode@" + prodcode
		                     + "&serviceId@" + serviceId
		                     + "&continueType@" + continueType
		                     + "&contentType@" + contentType
		                     + "&vodId@" + vodId
		                     + "&businessType@" + businessType
		                     + "&supVodId@" + supVodId
		                     + "&tkmode@" + tkmode
		                     + "&osd@" + osd
		                     + "&playtype@" + playType
		                     + "&chanId@" + chanId
		                     + "&typeId@" + typeId
		                     + "&startTime@" + startTime
							 + "&mediaId@" + mediaId
							 + "&neVodId@" + neVodId
							 + "&spName@" + spName
							 + "&price@" + price
							 ;
		                
		       //System.out.println("geninfo_nor confirmUrl = " + confirmUrl);  
					
		   //System.out.println("confirmUrl = " + confirmUrl);         
	}
	 

	//�Ƿ���Բ��ű�ʶ
	int playFlag = 0;
	int anCiFlag = 0;
	String url = "";
	
	/* ��ͼ�����ҳ�淵����Ҫ�Ĳ��� */
	String tw_record_template = (String) resultMp.get("tw_record_template");
	String tw_record_flag = (String) resultMp.get("tw_record_flag");
	
	
	
	//ӰƬ�Ĳ��ŵ�ַ
	String playUrl = (String)resultMp.get("playUrl");
	String json ="";
	//Map prodObj = null;
	//String prodCode = "";
	
	
	 List allProdList = getAllProdList();
	 //System.out.println("allProdList="+allProdList);
	 //���²�Ʒ�б�
	 List monthList = (List)resultMp.get("MONTH_LIST");
	 //String prodList = "[";
	 ArrayList<Map> prodList = new ArrayList<Map>();
	 
	if(null != monthList && monthList.size() > 0)
	{
		System.out.println("geninfo monthList.size()="+monthList.size());
		for(int i=0;i<monthList.size();i++)
		{
			Map tmpObj = (Map)monthList.get(i);
			String prodName = (String)tmpObj.get("PROD_NAME");
			String prodCode = (String)tmpObj.get("PROD_CODE");
			String serCode = (String)tmpObj.get("SERVICE_CODE");
			/*String tmpStr = "{prodName:\""+prodName+"\""+",prodCode:\""+prodCode+"\"}";
			if(i<monthList.size()-1) tmpStr +=",";
			prodList+=tmpStr;
			*/
			System.out.println("ByMonth prodCode=="+prodCode+",,serCode="+serCode+",,prodName="+prodName);
			for(int j=0;j<allProdList.size();j++){
				Map tmpMap = (Map)allProdList.get(j);
				String tmpCode = (String)tmpMap.get("\"prodCode\"");
				if(prodCode.equals(tmpCode)){
					System.out.println("prodCode="+prodCode+",tmpCode="+tmpCode);
					String vodId = (String) resultMp.get("progId");
					String typeId = (String)resultMp.get("typeId");
					String playType = (String)resultMp.get("playtype");
					String parentVodId = (String) resultMp.get("parentVodId");
					tmpMap.put("\"vodId\"",vodId);
					tmpMap.put("\"typeId\"","\""+typeId+"\"");
					tmpMap.put("\"playType\"",playType);
					tmpMap.put("\"parentVodId\"",parentVodId);
					tmpMap.put("\"FSNId\"","\""+FSNId+"\"");
					/*if("100185".equals(prodCode)||"100359".equals(prodCode)||"100360".equals(prodCode)){
						tmpMap.put("type","1");
					}else{
						tmpMap.put("type","0");
					}*/
					prodList.add(tmpMap);
				}
			}
		}	
	}
 
	 
      //���ζ�����Ʒ�б�
    List timesList = (List)resultMp.get("TIMES_LIST");
	if(null != timesList && timesList.size() > 0)
	{
		System.out.println("timesList.size()="+timesList.size());
		for(int i=0;i<timesList.size();i++)
		{
			Map tmpObj = (Map)timesList.get(i);
			String prodCode = (String)tmpObj.get("PROD_CODE");
			
			System.out.println("timeList="+tmpObj);
			MetaData meta = new MetaData(request);
            // ��ȡVOD��������Ϣ
			String proId = (String)resultMp.get("progId");
			int intProgId = Integer.parseInt(proId);
            Map vodDetail = meta.getVodDetailInfo(intProgId);
			System.out.println("timesList vodDetail="+vodDetail);
            String price = (String)vodDetail.get("VODPRICE");
            price = getPrice(price) + "Ԫ";
			String spName = (String) vodDetail.get("SPNAME");
			spName = spName.trim();
			System.out.println("price="+price+",spName=="+spName);
			String code = (String) vodDetail.get("CODE");
			
			System.out.println("ByTimes prodCode=="+prodCode);
			for(int j=0;j<allProdList.size();j++){
				Map tmpMap = (Map)allProdList.get(j);
				String tmpCode = (String)tmpMap.get("\"prodCode\"");
				if(prodCode.equals(tmpCode)){
					System.out.println("prodCode="+prodCode+",tmpCode="+tmpCode);
					tmpMap.put("\"price\"","\""+price+"\"");
					/*if(prodCode.equals("401000")){
						tmpMap.put("buyUrl",confirmUrl);
					}*/
					tmpMap.put("\"FSNId\"","\""+code+"\"");
					tmpMap.put("\"spName\"","\""+spName+"\"");
					prodList.add(tmpMap);
				}
			}
		}	
	}
	System.out.println("prodList="+prodList);
	
	String vodId = (String) resultMp.get("progId");
	String typeId = (String)resultMp.get("typeId");
	//ӰƬ�ɲ���
	if (playUrl != null && !"".equals(playUrl))
	{
		playFlag = 1;
		String reportUrl = (String) resultMp.get("reportUrl");
		String splayFlag = Integer.toString(playFlag);
		String supVodId = (String) resultMp.get("parentVodId");
		json +="{\"retCode\":"+resultMp.get("retCode")+",\"playFlag\":\""+splayFlag+"\""+",\"anCiFlag\":\""+anCiFlag+"\""+",\"playUrl\":\""+playUrl+"\""+",\"reportUrl\":\""+reportUrl+"\",\"parentVodId\":\""+supVodId+"\"}";
   }else if("Anci_flag".equals(Anci_flag)){
   		anCiFlag = 1;
	    String splayFlag = Integer.toString(playFlag);
		json +="{\"retCode\":"+resultMp.get("retCode")+",\"playFlag\":\""+splayFlag+"\""+",\"anCiFlag\":\""+anCiFlag+"\""+",\"message\":\""+mess+"\""+",\"prodList\":"+prodList+",\"confirmUrl\":\""+confirmUrl+"\"}";
		json = json.replaceAll("=",":");
		json = json.replaceAll("@","=");
   }else{
	    String splayFlag = Integer.toString(playFlag);
		json +="{\"retCode\":"+resultMp.get("retCode")+",\"playFlag\":\""+splayFlag+"\""+",\"anCiFlag\":\""+anCiFlag+"\""+",\"message\":\""+mess+"\""+",\"prodList\":"+prodList+"}";
		json = json.replaceAll("=",":");
   }
   System.out.println("json="+json);
%>
<%=json %>

