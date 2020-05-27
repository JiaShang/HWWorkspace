

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




function fullScreen(__id,__name) {
	if(isP60){
		getRTSP(__name, __id, 1);        
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
		//alert("__left="+__left+"__top="+__top+"__width="+__width+"__height="+__height+"__id"+__id+"__name"+__name);
		mediaPlayer = mixplayer.create(__left,__top,__width,__height);
		//alert("mediaPlayer"+mediaPlayer);
		__id = String(__id);
		//alert("rtspUrl="+rtspUrl);
		rtspUrl = getNewRTSP(__name, __id, 1, 0, 0); 
		//getNewRTSP(__name, __id, 1, 0, 0);                   
		//alert("smallScreen rtspUrl="+rtspUrl);
	}else{
		media.video.setPosition(__left,__top,__width,__height);
		 play_ajax(__id);
	}
	
}

//////////////////////////////////////////////////////////////
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
			else{           
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


////////////////////////////////////////////////////////////////////////

function getNewRTSP(name, vod_id, flag, index, time, _parentVodId) {
	 playVideo("1");
   //alert(">>>p60box getNewRTSP-epg_address===" + sysmisc.getEnv('epg_address', ''));
    if (sysmisc.getEnv('epg_address', '') != '') {
        var url = urlJoin(sysmisc.getEnv('epg_address', '') + '/EPG/jsp/defaultHD/en/go_authorization.jsp', joinStr(getObject(vod_id, flag, _parentVodId)));
       // alert(">>>p60box getNewRTSP-url===" + url);
        var cookie = '[{"key": "cookie", "value":"' + "JSESSIONID=" + sysmisc.getEnv('sessionid', '') + '"}]';
        bridge.ajax('post', url, 'text/xml', cookie, '', function(resp) {
          //  alert(">>>p60box getNewRTSP-success-resp===" + resp);
            var jsonStr = resp.trim().replace(/[\r\n]/g, "");
          //  alert(">>>p60box getNewRTSP-success-jsonstr===" + jsonStr);
            var json = eval("(" + jsonStr + ")");
            if (json.playUrl) {
            //	alert(">>>p60box getNewRTSP-success-json.playUrl===" + json.playUrl);
                var rtsp = json.playUrl;
                var _playUrl = rtsp.split("^")[4];
			//	alert(">>>p60box getNewRTSP-success-_playUrl===" + _playUrl);
				
				//if(mediaPlayer)mixplayer.stop(mediaPlayer);
                playVideo(_playUrl);
			//	alert("rtsp="+rtsp);
                return _playUrl;
            }
        }, function(resp) {
            iDebug(">>>p60box getNewRTSP-fail");
        })
    }
}


function playVideo(_url) {
	//alert(">>>p60box playVideo _url="+_url+" seekTime="+seekTime);
    sysmisc.bringToForeground("video");
	mixplayer.playUrl(mediaPlayer, _url, seekTime+"");

}





//////////////////////////////////////////////////
function iDebug(__str){
	return;            
	$("msgNote").innerHTML += __str+ "<br>";
}












