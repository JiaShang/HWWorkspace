<%@ page import="java.net.URLEncoder"%>
<%@ page pageEncoding="GBK"%>
<%@ page import="com.huawei.iptvmw.epg.bean.MetaData" %>
<%@ include file="../../common4dtv/jsp/config.jsp" %>
<%@ page import="java.util.*"%>
<%!

public List getAllProdList(){
	StringBuffer strLists = new StringBuffer();
	
strLists.append("prodCode:100159#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:100160#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:100161#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:100189#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130000#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130001#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130002#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130003#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130004#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130005#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130006#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:130007#comboId:1279#comboName:\"育才中学全年包\"#type:0;");
strLists.append("prodCode:100202#comboId:1348#comboName:\"儿童素质培养半年套餐\"#type:0;");
strLists.append("prodCode:100236#comboId:1295#comboName:\"经典儿歌大全包年套餐\"#type:0;");
strLists.append("prodCode:100236#comboId:1294#comboName:\"经典儿歌大全半年套餐\"#type:0;");
strLists.append("prodCode:100203#comboId:1312#comboName:\"幼儿英语半年套餐\"#type:0;");
strLists.append("prodCode:100203#comboId:1313#comboName:\"幼儿英语包年套餐\"#type:0;");
strLists.append("prodCode:100377#comboId:1428#comboName:\"Hifi音乐\"#type:0;");
strLists.append("prodCode:100377#comboId:1532#comboName:\"Hifi音乐优惠套餐\"#type:0;");
strLists.append("prodCode:100278#comboId:1533#comboName:\"i12动画优惠套餐\"#type:0;");
strLists.append("prodCode:100278#comboId:1432#comboName:\"i12动画城\"#type:0;");
strLists.append("prodCode:100325#comboId:1433#comboName:\"i12漫迷圈\"#type:0;");
strLists.append("prodCode:100332#comboId:1434#comboName:\"i12智慧屋\"#type:0;");
strLists.append("prodCode:100247#comboId:1361#comboName:\"TVB专区\"#type:0;");
strLists.append("prodCode:100311#comboId:1436#comboName:\"优生活保健养生\"#type:0;");
strLists.append("prodCode:100315#comboId:1437#comboName:\"优生活风尚舞汇\"#type:0;");
strLists.append("prodCode:100312#comboId:1438#comboName:\"优生活健身塑形\"#type:0;");
strLists.append("prodCode:100316#comboId:1447#comboName:\"优生活美食营养\"#type:0;");
strLists.append("prodCode:100313#comboId:1439#comboName:\"优生活美颜坊\"#type:0;");
strLists.append("prodCode:100321#comboId:1440#comboName:\"优生活DIY\"#type:0;");
strLists.append("prodCode:100319#comboId:1441#comboName:\"优生活青少乐园\"#type:0;");
strLists.append("prodCode:100320#comboId:1442#comboName:\"优生活时尚家居\"#type:0;");
strLists.append("prodCode:100314#comboId:1443#comboName:\"优生活体育运动\"#type:0;");
strLists.append("prodCode:100309#comboId:1444#comboName:\"优生活武道馆\"#type:0;");
strLists.append("prodCode:100308#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100309#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100310#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100311#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100312#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100313#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100314#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100315#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100316#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100317#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100318#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100319#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100320#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100321#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100322#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100323#comboId:1539#comboName:\"优生活优惠套餐\"#type:0;");
strLists.append("prodCode:100308#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100309#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100310#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100311#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100312#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100313#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100314#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100315#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100316#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100317#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100318#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100319#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100320#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100321#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100322#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100323#comboId:1398#comboName:\"优生活尽享包\"#type:0;");
strLists.append("prodCode:100317#comboId:1445#comboName:\"优生活艺术课堂\"#type:0;");
strLists.append("prodCode:100323#comboId:1446#comboName:\"优生活逸趣休闲\"#type:0;");
strLists.append("prodCode:100310#comboId:1448#comboName:\"优生活瑜伽时间\"#type:0;");
strLists.append("prodCode:100318#comboId:1449#comboName:\"优生活孕产育儿\"#type:0;");
strLists.append("prodCode:100322#comboId:1450#comboName:\"优生活职业培训\"#type:0;");
strLists.append("prodCode:100308#comboId:1451#comboName:\"优生活中华太极\"#type:0;");
strLists.append("prodCode:100174#comboId:1534#comboName:\"彩虹演唱会优惠套餐\"#type:0;");
strLists.append("prodCode:100383#comboId:1504#comboName:\"彩虹音乐唱享包\"#type:0;");
strLists.append("prodCode:100378#comboId:1429#comboName:\"畅玩吧\"#type:0;");
strLists.append("prodCode:100264#comboId:1430#comboName:\"橙视屏动\"#type:0;");
strLists.append("prodCode:100384#comboId:1514#comboName:\"迪士尼游戏\"#type:0;");
strLists.append("prodCode:100306#comboId:1487#comboName:\"新东方多纳学前包包年\"#type:0;");
strLists.append("prodCode:100305#comboId:1368#comboName:\"新东方多纳学前包\"#type:0;");
strLists.append("prodCode:100364#comboId:1431#comboName:\"嗨皮游戏\"#type:0;");
strLists.append("prodCode:100173#comboId:1359#comboName:\"彩虹音乐+百科学苑30天特惠\"#type:0;");
strLists.append("prodCode:100176#comboId:1359#comboName:\"彩虹音乐+百科学苑30天特惠\"#type:0;");
strLists.append("prodCode:100420#comboId:1649#comboName:\"绘本星球\"#type:0;");
strLists.append("prodCode:100421#comboId:1566#comboName:\"育儿中心半年套餐\"#type:0;");
strLists.append("prodCode:100421#comboId:1567#comboName:\"育儿中心包年套餐\"#type:0;");
strLists.append("prodCode:100421#comboId:1565#comboName:\"育儿中心\"#type:0;");
strLists.append("prodCode:100346#comboId:1497#comboName:\"开心学堂艺术生活年包\"#type:0;");
strLists.append("prodCode:100346#comboId:1402#comboName:\"开心学堂艺术生活\"#type:0;");
strLists.append("prodCode:100345#comboId:1501#comboName:\"开心学堂职业考试教育年包\"#type:0;");
strLists.append("prodCode:100345#comboId:1405#comboName:\"开心学堂职业考试教育\"#type:0;");
strLists.append("prodCode:100258#comboId:1536#comboName:\"梦想游戏优惠套餐\"#type:0;");
strLists.append("prodCode:100258#comboId:1399#comboName:\"梦想游戏\"#type:0;");
strLists.append("prodCode:100365#comboId:1435#comboName:\"泡泡乐园\"#type:0;");
strLists.append("prodCode:100390#comboId:1522#comboName:\"圣剑游戏\"#type:0;");
strLists.append("prodCode:100328#comboId:1453#comboName:\"天天健康包年\"#type:0;");
strLists.append("prodCode:100328#comboId:1452#comboName:\"天天健康\"#type:0;");
strLists.append("prodCode:100419#comboId:1648#comboName:\"童书乐园\"#type:0;");
strLists.append("prodCode:100349#comboId:1496#comboName:\"开心学堂小学教育年包\"#type:0;");
strLists.append("prodCode:100349#comboId:1401#comboName:\"开心学堂小学教育\"#type:0;");
strLists.append("prodCode:100282#comboId:1494#comboName:\"新东方初中二年级包年\"#type:0;");
strLists.append("prodCode:100281#comboId:1493#comboName:\"新东方初中二年级\"#type:0;");
strLists.append("prodCode:100280#comboId:1492#comboName:\"新东方初中全年级包年\"#type:0;");
strLists.append("prodCode:100282#comboId:1492#comboName:\"新东方初中全年级包年\"#type:0;");
strLists.append("prodCode:100284#comboId:1492#comboName:\"新东方初中全年级包年\"#type:0;");
strLists.append("prodCode:100279#comboId:1413#comboName:\"新东方初中全年级\"#type:0;");
strLists.append("prodCode:100281#comboId:1413#comboName:\"新东方初中全年级\"#type:0;");
strLists.append("prodCode:100283#comboId:1413#comboName:\"新东方初中全年级\"#type:0;");
strLists.append("prodCode:100284#comboId:1491#comboName:\"新东方初中三年级包年\"#type:0;");
strLists.append("prodCode:100283#comboId:1490#comboName:\"新东方初中三年级\"#type:0;");
strLists.append("prodCode:100280#comboId:1489#comboName:\"新东方初中一年级包年\"#type:0;");
strLists.append("prodCode:100279#comboId:1488#comboName:\"新东方初中一年级\"#type:0;");
strLists.append("prodCode:100288#comboId:1486#comboName:\"新东方高中二年级包年\"#type:0;");
strLists.append("prodCode:100287#comboId:1485#comboName:\"新东方高中二年级\"#type:0;");
strLists.append("prodCode:100286#comboId:1484#comboName:\"新东方高中全年级包年\"#type:0;");
strLists.append("prodCode:100288#comboId:1484#comboName:\"新东方高中全年级包年\"#type:0;");
strLists.append("prodCode:100290#comboId:1484#comboName:\"新东方高中全年级包年\"#type:0;");
strLists.append("prodCode:100285#comboId:1414#comboName:\"新东方高中全年级\"#type:0;");
strLists.append("prodCode:100287#comboId:1414#comboName:\"新东方高中全年级\"#type:0;");
strLists.append("prodCode:100289#comboId:1414#comboName:\"新东方高中全年级\"#type:0;");
strLists.append("prodCode:100290#comboId:1483#comboName:\"新东方高中三年级包年\"#type:0;");
strLists.append("prodCode:100289#comboId:1482#comboName:\"新东方高中三年级\"#type:0;");
strLists.append("prodCode:100286#comboId:1481#comboName:\"新东方高中一年级包年\"#type:0;");
strLists.append("prodCode:100285#comboId:1480#comboName:\"新东方高中一年级\"#type:0;");
strLists.append("prodCode:100272#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100273#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100274#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100275#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100276#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100277#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100280#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100282#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100284#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100286#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100288#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100290#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100292#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100294#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100296#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100298#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100301#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100304#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100306#comboId:1531#comboName:\"新东方畅学年包\"#type:0;");
strLists.append("prodCode:100266#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100267#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100268#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100269#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100270#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100271#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100279#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100281#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100283#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100285#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100287#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100289#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100291#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100293#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100295#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100297#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100299#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100302#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100305#comboId:1530#comboName:\"新东方畅学包\"#type:0;");
strLists.append("prodCode:100300#comboId:1479#comboName:\"新东方托福全程精讲199/半年\"#type:0;");
strLists.append("prodCode:100301#comboId:1478#comboName:\"新东方托福全程精讲299/年\"#type:0;");
strLists.append("prodCode:100299#comboId:1367#comboName:\"新东方托福精讲\"#type:0;");
strLists.append("prodCode:100273#comboId:1477#comboName:\"新东方小学二年级包年\"#type:0;");
strLists.append("prodCode:100267#comboId:1476#comboName:\"新东方小学二年级\"#type:0;");
strLists.append("prodCode:100277#comboId:1475#comboName:\"新东方小学六年级包年\"#type:0;");
strLists.append("prodCode:100271#comboId:1474#comboName:\"新东方小学六年级\"#type:0;");
strLists.append("prodCode:100272#comboId:1473#comboName:\"新东方小学全年级包年\"#type:0;");
strLists.append("prodCode:100273#comboId:1473#comboName:\"新东方小学全年级包年\"#type:0;");
strLists.append("prodCode:100274#comboId:1473#comboName:\"新东方小学全年级包年\"#type:0;");
strLists.append("prodCode:100275#comboId:1473#comboName:\"新东方小学全年级包年\"#type:0;");
strLists.append("prodCode:100276#comboId:1473#comboName:\"新东方小学全年级包年\"#type:0;");
strLists.append("prodCode:100277#comboId:1473#comboName:\"新东方小学全年级包年\"#type:0;");
strLists.append("prodCode:100266#comboId:1416#comboName:\"新东方小学全年级\"#type:0;");
strLists.append("prodCode:100267#comboId:1416#comboName:\"新东方小学全年级\"#type:0;");
strLists.append("prodCode:100268#comboId:1416#comboName:\"新东方小学全年级\"#type:0;");
strLists.append("prodCode:100269#comboId:1416#comboName:\"新东方小学全年级\"#type:0;");
strLists.append("prodCode:100270#comboId:1416#comboName:\"新东方小学全年级\"#type:0;");
strLists.append("prodCode:100271#comboId:1416#comboName:\"新东方小学全年级\"#type:0;");
strLists.append("prodCode:100274#comboId:1472#comboName:\"新东方小学三年级包年\"#type:0;");
strLists.append("prodCode:100268#comboId:1471#comboName:\"新东方小学三年级\"#type:0;");
strLists.append("prodCode:100275#comboId:1470#comboName:\"新东方小学四年级包年\"#type:0;");
strLists.append("prodCode:100269#comboId:1469#comboName:\"新东方小学四年级\"#type:0;");
strLists.append("prodCode:100276#comboId:1468#comboName:\"新东方小学五年级包年\"#type:0;");
strLists.append("prodCode:100270#comboId:1467#comboName:\"新东方小学五年级\"#type:0;");
strLists.append("prodCode:100272#comboId:1466#comboName:\"新东方小学一年级包年\"#type:0;");
strLists.append("prodCode:100266#comboId:1465#comboName:\"新东方小学一年级\"#type:0;");
strLists.append("prodCode:100294#comboId:1464#comboName:\"新东方新概念二册包年\"#type:0;");
strLists.append("prodCode:100293#comboId:1463#comboName:\"新东方新概念二册\"#type:0;");
strLists.append("prodCode:100292#comboId:1462#comboName:\"新东方新概念全集包年\"#type:0;");
strLists.append("prodCode:100294#comboId:1462#comboName:\"新东方新概念全集包年\"#type:0;");
strLists.append("prodCode:100296#comboId:1462#comboName:\"新东方新概念全集包年\"#type:0;");
strLists.append("prodCode:100298#comboId:1462#comboName:\"新东方新概念全集包年\"#type:0;");
strLists.append("prodCode:100291#comboId:1415#comboName:\"新东方新概念全集\"#type:0;");
strLists.append("prodCode:100293#comboId:1415#comboName:\"新东方新概念全集\"#type:0;");
strLists.append("prodCode:100295#comboId:1415#comboName:\"新东方新概念全集\"#type:0;");
strLists.append("prodCode:100297#comboId:1415#comboName:\"新东方新概念全集\"#type:0;");
strLists.append("prodCode:100296#comboId:1461#comboName:\"新东方新概念三册包年\"#type:0;");
strLists.append("prodCode:100295#comboId:1460#comboName:\"新东方新概念三册\"#type:0;");
strLists.append("prodCode:100298#comboId:1459#comboName:\"新东方新概念四册包年\"#type:0;");
strLists.append("prodCode:100297#comboId:1458#comboName:\"新东方新概念四册\"#type:0;");
strLists.append("prodCode:100292#comboId:1457#comboName:\"新概念一册包年\"#type:0;");
strLists.append("prodCode:100291#comboId:1456#comboName:\"新东方新概念一册\"#type:0;");
strLists.append("prodCode:100303#comboId:1455#comboName:\"新东方雅思全程精讲半年\"#type:0;");
strLists.append("prodCode:100304#comboId:1454#comboName:\"新东方雅思全程精讲包年\"#type:0;");
strLists.append("prodCode:100302#comboId:1417#comboName:\"新东方雅思全程精讲\"#type:0;");
strLists.append("prodCode:100399#comboId:1527#comboName:\"幸福健身团\"#type:0;");
strLists.append("prodCode:100262#comboId:1537#comboName:\"炫佳游戏优惠套餐\"#type:0;");
strLists.append("prodCode:100262#comboId:1369#comboName:\"炫佳游戏\"#type:0;");
strLists.append("prodCode:100379#comboId:1510#comboName:\"养老789家服培训包年\"#type:0;");
strLists.append("prodCode:100379#comboId:1505#comboName:\"养老789家服培训\"#type:0;");
strLists.append("prodCode:100380#comboId:1509#comboName:\"养老789健康养老包年\"#type:0;");
strLists.append("prodCode:100380#comboId:1506#comboName:\"养老789健康养生\"#type:0;");
strLists.append("prodCode:100424#comboId:1659#comboName:\"养老789\"#type:0;");
strLists.append("prodCode:100381#comboId:1507#comboName:\"养老789老年大学\"#type:0;");
strLists.append("prodCode:100382#comboId:1508#comboName:\"养老789月嫂培训\"#type:0;");
strLists.append("prodCode:100389#comboId:1538#comboName:\"映霸电竞优惠套餐\"#type:0;");
strLists.append("prodCode:100389#comboId:1519#comboName:\"映霸电竞\"#type:0;");
strLists.append("prodCode:100348#comboId:1498#comboName:\"开心学堂幼教教育年包\"#type:0;");
strLists.append("prodCode:100348#comboId:1403#comboName:\"开心学堂幼教教育\"#type:0;");
strLists.append("prodCode:100172#comboId:1328#comboName:\"彩虹卡拉OK\"#type:0;");
strLists.append("prodCode:100173#comboId:1330#comboName:\"彩虹音乐MV\"#type:0;");
strLists.append("prodCode:100174#comboId:1331#comboName:\"彩虹音乐演唱会\"#type:0;");
strLists.append("prodCode:100175#comboId:1339#comboName:\"趣味生活包\"#type:0;");
strLists.append("prodCode:100176#comboId:1337#comboName:\"养生健康包\"#type:0;");
strLists.append("prodCode:100177#comboId:1336#comboName:\"屏动-健康汇\"#type:0;");
strLists.append("prodCode:100178#comboId:1332#comboName:\"屏动-愉悦心\"#type:0;");
strLists.append("prodCode:100179#comboId:1333#comboName:\"屏动-小帮手\"#type:0;");
strLists.append("prodCode:100180#comboId:1340#comboName:\"屏动-万里路\"#type:0;");
strLists.append("prodCode:100181#comboId:1334#comboName:\"屏动-学前班\"#type:0;");
strLists.append("prodCode:100183#comboId:1335#comboName:\"屏动-讲故事\"#type:0;");
strLists.append("prodCode:100196#comboId:1370#comboName:\"云游戏\"#type:0;");
strLists.append("prodCode:100347#comboId:1499#comboName:\"开心学堂孕婴教育年包\"#type:0;");
strLists.append("prodCode:100347#comboId:1404#comboName:\"开心学堂孕婴教育\"#type:0;");
strLists.append("prodCode:100392#comboId:1540#comboName:\"掌世界电竞优惠套餐\"#type:0;");
strLists.append("prodCode:100392#comboId:1520#comboName:\"掌世界电竞\"#type:0;");
strLists.append("prodCode:100350#comboId:1500#comboName:\"开心学堂中学教育年包\"#type:0;");
strLists.append("prodCode:100350#comboId:1406#comboName:\"开心学堂中学教育\"#type:0;");

	strLists.append("prodCode:100473#comboId:1853#comboName:\"来点播开通产品\"#type:0;");	
	strLists.append("prodCode:100375#comboId:1495#comboName:\"来点智享版\"#type:0;");
	strLists.append("prodCode:100185#comboId:1155#comboName:\"韩剧专区\"#type:0;");
	strLists.append("prodCode:100186#comboId:1160#comboName:\"强档好莱坞\"#type:0;");
	strLists.append("prodCode:100417#comboId:1543#comboName:\"优酷专区\"#type:0;");
	strLists.append("prodCode:100359#comboId:1395#comboName:\"凤凰专区\"#type:0;");
	strLists.append("prodCode:100359#comboId:1396#comboName:\"凤凰半年包\"#type:0;");
	strLists.append("prodCode:100359#comboId:1397#comboName:\"凤凰包年\"#type:0;");
	strLists.append("prodCode:100360#comboId:1382#comboName:\"英美剧专区\"#type:0;");
	strLists.append("prodCode:100360#comboId:1421#comboName:\"英美剧专区包年\"#type:0;");
	strLists.append("prodCode:100326#comboId:1386#comboName:\"坝坝舞专区\"#type:0;");
	strLists.append("prodCode:100326#comboId:1521#comboName:\"坝坝舞专区全年套餐\"#type:0;");
	strLists.append("prodCode:100247#comboId:1361#comboName:\"TVB专区\"#type:0;");	
	strLists.append("prodCode:100247#comboId:1543#comboName:\"优酷专区\"#type:0;");		
	strLists.append("prodCode:100247#comboId:1542#comboName:\"优酷专区全年\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1541#comboName:\"搜狐专区\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1545#comboName:\"搜狐专区(季度)\"#type:0;");		
	strLists.append("prodCode:100418#comboId:1546#comboName:\"搜狐专区半年\"#type:0;");			
	strLists.append("prodCode:100418#comboId:1547#comboName:\"搜狐专区全年促销\"#type:0;");		
	strLists.append("prodCode:100398#comboId:1529#comboName:\"芒果TV\"#type:0;");
	strLists.append("prodCode:100250#comboId:1418#comboName:\"1T云空间\"#type:0;");
	strLists.append("prodCode:100363#comboId:1418#comboName:\"1T云空间\"#type:0;");
	strLists.append("prodCode:100361#comboId:1419#comboName:\"2T云空间\"#type:0;");
	strLists.append("prodCode:100363#comboId:1419#comboName:\"2T云空间\"#type:0;");
	strLists.append("prodCode:100362#comboId:1420#comboName:\"5T云空间\"#type:0;");
	strLists.append("prodCode:100363#comboId:1420#comboName:\"5T云空间\"#type:0;");
	
	strLists.append("prodCode:406015#comboId:1680#comboName:\"4K专区\"#type:1#webUrl:192.168.15.19\"#pkgName:\"com.ipanel.chongqing_ipanelforhw-com.ipanel.join.cq.vod.detail.DetailActivity\";");
	strLists.append("prodCode:406010#comboId:1680#comboName:\"4K专区\"#type:1#webUrl:192.168.15.19\"#pkgName:\"com.ipanel.chongqing_ipanelforhw-com.ipanel.join.cq.vod.detail.DetailActivity\";");
	
	strLists.append("prodCode:402001#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402002#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402003#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402004#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402005#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402006#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402007#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402008#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402009#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");
	strLists.append("prodCode:402010#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");	
	strLists.append("prodCode:402011#comboId:1683#comboName:\"强档好莱坞\"#type:2#webUrl:192.168.42.49/epg/hollywood/biz_00374562.do\"#pkgName:\"sitv.s003.dianbo.com.chongqinghollywood-sitv.s003.dianbo.com.chongqinghollywood.activity.MainDetailActivity\";");	
	
	strLists.append("prodCode:404000#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404001#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404002#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404003#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404006#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404008#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404009#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404005#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404016#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404018#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404020#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");
	strLists.append("prodCode:404099#comboId:1682#comboName:\"沙发院线\"#type:2#webUrl:192.168.15.19\"#pkgName:\"com.zhhs.galaxyott-com.zhhs.galaxyott.activity.mainActivity.MainActivity\";");

	
	strLists.append("prodCode:403000#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403001#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403002#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403003#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403004#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403005#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403006#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403007#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403008#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403009#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	strLists.append("prodCode:403010#comboId:1681#comboName:\"中国电视院线\"#type:2#webUrl:192.168.5.229/dyyx/search_content.htm\"#pkgName:\"com.pd.dsyx_cq_new-com.pd.dsyx_cq_new.MainActivity\";");
	
	
	
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
	String comeType = (String) request.getAttribute("comeType"); //判断回看来源
	String mess = (String) resultMp.get("message");
	String FSNId = (String)resultMp.get("neVodId");
	//String price = (String)resultMp.get("price");
	//String spName = (String)resultMp.get("spName");
	//System.out.println("geninfo_nor FSNId =="+FSNId+",spName=="+spName);
	if(mess == null)
	{
		mess = "操作失败";
	}
		
	Object confirmMarkObj = resultMp.get("confirmMark");//标记是否走过按次订购流程
	boolean confirmMark = (null != confirmMarkObj);
	
	Object o = resultMp.get("Anci_flag");
	String Anci_flag = null;
	if(null != o)
	{
		Anci_flag = o.toString();
	}
	

	
	// 处理二次授权页面跳转路径
	String confirmUrl = "";
	
	//如果返回的错误码是需要订购的,则会进入用户订购流程
	if("Anci_flag".equals(Anci_flag))
	{
		//节目编号
		String vodId = (String) resultMp.get("progId");
		//父集编号(适用电视剧)
		String supVodId = (String) resultMp.get("parentVodId");
		//内容类型
		String contentType = (String) resultMp.get("contentType");
		//业务类型
		String businessType = (String) resultMp.get("businessType");
		//产品对象
		Map prodObj = (Map)resultMp.get("prodObj");
		//产品编号
		String prodcode = (String)prodObj.get("PROD_CODE");
		//服务编号
		String serviceId = (String)prodObj.get("SERVICE_CODE");
		//续订标识
		String continueType = ((Integer)prodObj.get("PROD_CONTINUEABLE")).toString();
		// 在小窗口播放片花时需传入此参数控制trickmode的操作
		String tkmode = (String)resultMp.get("tkmode");
		// 在小窗口播放片花时需传入此参数控制osd的显示
		String osd = (String)resultMp.get("osd");
		//播放类型
		String playType = (String)resultMp.get("playtype");
		//频道编号
		String chanId = (String)resultMp.get("chanId");
		//栏目编号
		String typeId = (String)resultMp.get("typeId");
		//播放的开始时间
		String startTime = (String)resultMp.get("starttime");
		//媒体ID
		String mediaId = (String)resultMp.get("mediaId");
		//外部ID
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
	 

	//是否可以播放标识
	int playFlag = 0;
	int anCiFlag = 0;
	String url = "";
	
	/* 与图文相关页面返回需要的参数 */
	String tw_record_template = (String) resultMp.get("tw_record_template");
	String tw_record_flag = (String) resultMp.get("tw_record_flag");
	
	
	
	//影片的播放地址
	String playUrl = (String)resultMp.get("playUrl");
	String json ="";
	//Map prodObj = null;
	//String prodCode = "";
	
	
	 List allProdList = getAllProdList();
	 //System.out.println("allProdList="+allProdList);
	 //包月产品列表
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
 
	 
      //按次订购产品列表
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
            // 获取VOD的详情信息
			String proId = (String)resultMp.get("progId");
			int intProgId = Integer.parseInt(proId);
            Map vodDetail = meta.getVodDetailInfo(intProgId);
			System.out.println("timesList vodDetail="+vodDetail);
            String price = (String)vodDetail.get("VODPRICE");
            price = getPrice(price) + "元";
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
	//影片可播放
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

