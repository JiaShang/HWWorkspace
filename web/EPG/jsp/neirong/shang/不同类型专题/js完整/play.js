

function exit(){
	if(isP60){
		mixplayer.stop(playerId);
		mixplayer.destroy(playerId);
		//dvbplayer.stop(playerId);
		//dvbplayer.destroy(playerId);
	}else{
		//DVB.stopAV(0);
		media.AV.close();
	}
}


//////////////////////////////播放函数////////////////////////////////

function fullScreen(__id,__name) {
	if(isP60){
		getRTSP(__name, __id, 1);        ////播电影类型影片
	}else{
		var reUrl = window.location.href;
		reUrl = encodeURIComponent(reUrl);
		$("data_ifm").src = iPanel.eventFrame.pre_epg_url + "/defaultHD/en/hidden_detail.jsp?typeId=-1&playType=1"
            + "&vodId=" + __id + "&baseFlag=0&idType=FSN&appBackUrl="+reUrl;
	}
}

function smallScreen(__id,__name,__left,__top,__width,__height){
	//alert("isP60="+isP60+",,,__id="+__id);
	if(isP60){
		__left=(__left/1280).toFixed(3);
		__top=(__top/720).toFixed(3);
		__width=(__width/1280).toFixed(3);
		__height=(__height/720).toFixed(3);
		alert("__left="+__left+"__top="+__top+"__width="+__width+"__height="+__height);
		mediaPlayer = mixplayer.create(__left,__top,__width,__height);
		alert("__id"+__id+"__name"+__name);
		rtspurl = getNewRTSP(__name, __id, 1, 0, 0);          //播电影类型影片              
		//alert(rtspurl);
	}else{
		media.video.setPosition(__left,__top,__width,__height);
		 play_ajax(__id);
	}
	
}

//////////////////////////////3.0////////////////////////////////
function play_ajax(freeVodId){
	getMovieRtspUrl = iPanel.eventFrame.pre_epg_url+"/defaultHD/en/go_authorization.jsp?typeId=-1&playType=1&progId="+freeVodId+"&contentType=0&business=1&idType=FSN";       //idType=FSN 三方id ; baseFlag=0不需要鉴权
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function (){
		if(XHR.readyState == 4){
			if(XHR.status == 200){
				var json = eval("(" + XHR.responseText + ")");
				rtsp =json.playUrl.split("^")[4];
				play();
			}
			else{           //AJAX没有获取到数据
				XHR.abort();
			}
		}
	}
	XHR.open("GET", getMovieRtspUrl, true);
	XHR.send(null);
}
function play(){
	media.AV.open(rtsp,"VOD");
}





////////////////////////////P60////////////////////////////////////////////

function getNewRTSP(name, vod_id, flag, index, time, _parentVodId) {
   iDebug(">>>p60box getNewRTSP-epg_address===" + sysmisc.getEnv('epg_address', ''));
    if (sysmisc.getEnv('epg_address', '') != '') {
        var url = urlJoin(sysmisc.getEnv('epg_address', '') + '/EPG/jsp/defaultHD/en/go_authorization.jsp', joinStr(getObject(vod_id, flag, _parentVodId)));
        iDebug(">>>p60box getNewRTSP-url===" + url);
        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
        bridge.ajax('post', url, 'text/xml', cookie, '', function(resp) {
            iDebug(">>>p60box getNewRTSP-success-resp===" + resp);
            var jsonStr = resp.trim().replace(/[\r\n]/g, "");
            iDebug(">>>p60box getNewRTSP-success-jsonstr===" + jsonStr);
            var json = eval("(" + jsonStr + ")");
            if (json.playUrl) {
            	iDebug(">>>p60box getNewRTSP-success-json.playUrl===" + json.playUrl);
                var rtsp = json.playUrl;
                var _playUrl = rtsp.split("^")[4];
				iDebug(">>>p60box getNewRTSP-success-_playUrl===" + _playUrl);
				
				//if(mediaPlayer)mixplayer.stop(mediaPlayer);
				iDebug(">>>p60box getNewRTSP-success-222222==");
                playVideo(_playUrl);
                return rtsp;
            }
        }, function(resp) {
            iDebug(">>>p60box getNewRTSP-fail");
        })
    }
}

// 播放视频
function playVideo(_url) {
	iDebug(">>>p60box playVideo _url="+_url+" seekTime="+seekTime);
    sysmisc.bringToForeground("web");//设置需要显示在最前的图层,video为视频层，其它为web层
	mixplayer.playUrl(mediaPlayer, _url, seekTime+"");

}





//////////////////////////////////////////////////
function iDebug(__str){
	return;             //屏蔽打印
	$("msgNote").innerHTML += __str+ "<br>";
}












