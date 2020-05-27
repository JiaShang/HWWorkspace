<html>
<meta name="page-view-size" content="1280*720">
<head>
    <title></title>
    <style></style>
    <script type="text/javascript" language="javascript">

        try{ iPanel.eventFrame.initPage(window); E.is_HD_vod = true;} catch (e) {};

        function init(){
            media.video.setPosition(58,429,383,216);
            play_ajax();
        }

        function play_ajax(freeVodId){
            var freeVodId="3000001420141119006400-30000001";
            var getMovieRtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?playType=1&progId="+freeVodId+"&contentType=0&business=1&baseFlag=0&idType=FSN";
            var XHR = new XMLHttpRequest();
            XHR.onreadystatechange = function (){
                if(XHR.readyState == 4){
                    if(XHR.status == 200){
                        alert(XHR.responseText);
                        var json = eval("(" + XHR.responseText + ")");
                        rtsp =json.playUrl.split("^")[4];
                        play();
                    }
                    else{
                        XHR.abort();
                    }
                }
            }
            XHR.open("GET", getMovieRtspUrl, true);
            XHR.send(null);
        }


        function eventHandler(eventObj, __type){
            switch(eventObj.code){
                case "KEY_BACK":
                    window.location.href = EPGflag ? iPanel.eventFrame.portalUrl : backUrl;
                    break;
                case "KEY_EXIT":
                case "KEY_MENU":
                    location.href = iPanel.eventFrame.portalUrl;
                    return 0;
                    break;
                case "VOD_PREPAREPLAY_SUCCESS":
                    media.AV.play();
                    break;
                case "EIS_VOD_PROGRAM_END":
                    play_ajax();
                    break;
            }
            return eventObj.args.type;
        }

        function play(){
            media.AV.open(rtsp,"VOD");
        }

        window.onload = function(){
            setTimeout("init()",100);
        }

        function exit() {
            DVB.stopAV(0);
            media.AV.close();
        }
    </script>
</head>
<body onUnload="exit();">
<!--div style="left:58px;top:429px;width:383px;height:216px;background-color:white; position:absolute;"></div-->
</body>