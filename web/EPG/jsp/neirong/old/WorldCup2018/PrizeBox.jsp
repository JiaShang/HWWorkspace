<%@ include file="../player/include.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title>我的奖品</title>
    <script language="javascript" type="text/javascript" src="../player/common.js"></script>
    <style>
        .prizeBox {width:1160px;height:330px;position:absolute;left:94px;top:170px;overflow: hidden;}
        .itemContainer{width:288px;height:164px;overflow:hidden;float:left;}
        .item,.item img{width:245px;height:130px;}
    </style>
</head>
<body leftmargin="0" topmargin="0" style='overflow:hidden; background:transparent url("images/PrizeBoxBg.jpg") no-repeat;' onUnload="exit();">
<div id="prizeBox" class="prizeBox"></div>
</body>
<script language="javascript" type="text/javascript">
    <!--
    cursor.initialize({
        init:function(){
            cursor.backUrl='<%= backUrl %>';
            cursor.call("visitedRecord");
            cursor.call("queryCardNoAndPhone");
        },
        queryCardNoAndPhone : function(){
            cursor.phoneNumber = iPanel.getGlobalVar("__WorldCupBindingPhone__");
            if( cursor.call("phoneValidate") ){
                var url = "http://192.168.89.23/worldCup/phone.do?cardNo=" + CA.card.serialNumber;
                //返回结果格式：{"cardNo":null,"phone":null}";
                ajax( url, function( result ){
                    if( result.phone != null )
                    {
                        iPanel.setGlobalVar("__WorldCupBindingPhone__",cursor.phoneNumber = result.phone);
                    }
                    cursor.call("QueryPrize");
                });
            } else {
                cursor.call("QueryPrize");
            }
        },
        QueryPrize : function(){
            var url = "http://192.168.89.23/worldCup/prizeBox.do?cardNo=" + CA.card.serialNumber;
            if(typeof cursor.phoneNumber !== "undefined") url += '&phone=' + cursor.phoneNumber;
            ajax(url, function(result){
                if(typeof result.data === 'undefined' || result.data.length == 0 ) return;
                var html = "";
                for(var i = 0; i <= result.data.length && i < 8; i ++){
                    var item = result.data[i];
                    if( ! item.trophyId ) continue;
                    html += '<div class="itemContainer"><div class="item"><img src="images/prize' + item.trophyId + '.png"/></div></div>';
                }
                /*var html = '';
                for( var i = 1; i <=13; i +=2 ){
                    html += '<div class="itemContainer"><div class="item"><img src="images/prize' + i + '.png"/></div></div>';
                }*/
                $("prizeBox").innerHTML = html;
            })
        },
        visitedRecord : function(){
            var record = function(){
                try {
                    cursor.call("sendVote",{
                        id:419,limit:9999,limitPer:9999,target:'全民拼手气',repeat:true
                    });
                    var url = "http://192.168.89.23/serve/vistor/count.do?id=1&choice=" +
                        encodeURIComponent("我的奖品") + "&cardNo=" + CA.card.serialNumber;
                    ajax(url);
                }catch (e) { }
            };
            setTimeout(function(){ record(); },30);
        },
        select:function(){
            cursor.call("goBackAct");
        }
    });
    -->
</script>
</html>