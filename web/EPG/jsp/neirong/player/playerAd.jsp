<%@ include file="include.jsp" %>
<%@ page language="java" pageEncoding="GBK"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="page-view-size" content="1280*720"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <script language="javasctipt" type="text/javascript" src="common.js"></script>
</head>
<body leftmargin="0" topmargin="0" style="overflow:hidden;" onUnload="exit();">
<script type="text/javascript" language="JavaScript">
    (function(win){
        var lazied = function(){
            if( typeof win.cursor == 'undefined') { setTimeout(function () { lazied(); }, 50 ); return; }
            //不保存当前播放地址
            var itemPlay = { noSave : true };
            var backUrl  = '<%= backUrl %>';
            cursor.initialize({
                init: function(){
                    var typeId = itemPlay.typeId = query("typeId");
                    var vodId = itemPlay.id = query("progId");

                    if( typeId.isEmpty() || vodId.isEmpty() ) { tooltip("typeId 参数错误!");setTimeout(function(){cursor.call("goBackAct");},1000);return; }

                    var parentId = itemPlay.parentId =  query("parentVodId");

                    //var urlPATH = "http://192.168.204.42/communication/";
                    //本地址仅测试使用
                    var urlPATH = "http://192.168.204.13:8080/communication/";
                    var startAdCode = "Pre-ad";    //广告位 前贴片（视频）
                    var endAdCode = "Post-ad";     //后贴片（视频）
                    var pauseAdCode = "Pause-ad";  //暂停广告（图片）
                    var volumeAdCode = "Vol-ad";   //音量广告(图片)

                    var stbId = iPanel.serialNumber;//机顶盒ID
                    var cardId = iPanel.cardId;     //机顶盒卡号

                    var ipAddress = iPanel.IpAddress;//获取机顶盒ip
                    var smValue = iPanel.MAC;        //sm值
                    var logFlag = true;              //是否需要记录点播详单及广告计数  true: 需要  false: 不需要
                    var advId = undefined;

                    //assetName 正片的名字
                    var url = urlPATH + "adveristing?adLocationCode=" + startAdCode + "&oldAdList=&areaCode=&stbId=" + stbId + "&ip=" + ipAddress + "&assetName=&path=&serviceId=&logInfo=" + logFlag + "&columnId=" + typeId + "&cardNo=" + cardId;
                    var showStr = decodeURIComponent('%3D%3D%3E%E5%8A%A0%E8%BD%BD%E5%B9%BF%E5%91%8A%E8%BF%94%E5%9B%9E%E7%BB%93%E6%9E%9C%3A%20');
                    var errorStr = decodeURIComponent('%E6%9C%8D%E5%8A%A1%E5%99%A8%E8%BF%94%E5%9B%9E%E6%95%B0%E6%8D%AE%E9%94%99%E8%AF%AF!');
                    ajax( url , function(rst){  /*&spec=1*/
                        try {
                            tooltip("Result: " + rst);
                            debug(showStr,  rst);
                            var arr = rst.split(",");
                            if(typeof(arr[1]) != "undefined"){
                                advId = arr[1].replace(/( |　)/gi,'');
                                player.play({ position:{left:0,top:0,width:1280,height:720}, vodId: advId });
                            } else {
                                cursor.call("nextVideo");
                            }
                        } catch (e) {
                            win.debug(errorStr); cursor.call("nextVideo");return;
                        }
                    }, {fail : function(rst) { win.debug(errorStr); cursor.call("nextVideo");} , eval : false });
                },
                goHome: function(){},
                select: function(){},
                goBack: function(){},
                nextVideo : function(){
                    if( ! cursor.invokePlay(itemPlay, itemPlay.typeId, undefined, backUrl ) ) {
                        tooltip(decodeURIComponent('%E6%92%AD%E6%94%BE%E5%BD%B1%E7%89%87%E6%97%B6%E5%87%BA%E7%8E%B0%E6%9C%AA%E7%9F%A5%E9%94%99%E8%AF%AF%EF%BC%8C%E8%AF%B7%E9%87%8D%E5%90%AF%E6%9C%BA%E9%A1%B6%E7%9B%92%E5%90%8E%E5%86%8D%E8%AF%95%EF%BC%8C5%E7%A7%92%E5%90%8E%E8%87%AA%E5%8A%A8%E8%BF%94%E5%9B%9E%EF%BC%81'));
                        setTimeout(function(){
                            cursor.call('goBackAct');
                        }, 5000);
                    }
                }
            });
        };
        lazied();
    })(window);
</script>
</body>
</html>
<%
    /*不保存当前播放的历史记录*/
    inner.turnPage.removeLast();
%>