/*
*	封装播控的规范,播放接口
*/

function PlayObj(){
	this.browserType = "";
	this.mpObj = null;
	this.mediaId = 0;
	this.pauseFlag = 0;
	this.mediaUrl = "";
}
/*
* 初始化用于创建播放器
*/
PlayObj.prototype.init = function(){
	this.browserType = this.getBrowserType();//获取浏览器类型
	this.debug("-fun:init this.browserType="+this.browserType);
	switch(this.browserType){
		case "advance":
			this.mpObj = new MediaPlayer();
			this.mediaId = this.mpObj.getPlayerInstanceID();
			this.debug("-fun:init--this.mediaId="+this.mediaId);
			VOD.changeServer("huawei_v2", "ip");
		break;
		case "iPanel":
			VOD.server.mode = "IP";
			VOD.changeServer("huawei_v2", "ip");
		break;
		case "coship":
			this.mpObj = new MediaPlayer();
			this.mediaId = this.mpObj.getNativePlayerInstanceId();
			this.debug("-fun:init coship--this.mediaId="+this.mediaId);
			break;
		case "gd_suma"://广东数码
			if(typeof MediaPlayer!='undefined'){
				this.mpObj = new MediaPlayer();
				this.mediaId = this.mpObj.createPlayerInstance("Video",2);
				this.debug("-fun:init suma--this.mediaId="+this.mediaId);
			}
			break;
		case "P60":
			this.mediaId = mixplayer.create(0, 0, 1, 1);
			this.debug("-fun:init P60--this.mediaId="+this.mediaId);
			break;
		case "android":break;
		case "Inspur":break;
		default:break;
	}	
};

PlayObj.prototype.getBrowserType = function(){
	var ua = navigator.userAgent.toLowerCase();
	this.debug("mediaPlayer.js--getBrowserType--ua="+ua);
	this.debug("mediaPlayer.js--getBrowserType--navigator.appName="+navigator.appName+" typeof MediaPlayer="+typeof MediaPlayer+"  typeof sysmisc="+typeof sysmisc);
	if(typeof sysmisc !== "undefined"){
		return "P60";
	}else if((typeof MediaPlayer != "undefined"&&/chrome/.test(ua))){
		return "advance";
	}else if(/ipanel/.test(ua)){
		if(/advance/.test(ua))return "advance";//advance
		return "iPanel";//3.0
	}else if(typeof iPanel!="undefined"&&navigator.appName == "Netscape"){
		return "iPanel";
	}else if(typeof rocmeSTB != "undefined"){//内蒙古数码
		return "nmg_suma";
	}else if(typeof Network != "undefined" && /mozilla/.test(ua)){//广东省网规范，用的数码盒子
		return "gd_suma";
	}
	return /enrich/.test(ua) ? 'EVM'
		: /coship/.test(ua) ? 'coship'
		: /wobox/.test(ua) ? 'Inspur'
		: window.ActiveXObject ? 'IE'
		: document.getBoxObjectFor || /firefox/.test(ua) ? 'FireFox'
		: window.openDatabase && !/chrome/.test(ua) ? 'Safari'
		: /opr/.test(ua) ? 'Opera'
		:/android/.test(ua)?'android'
		: window.MessageEvent && !document.getBoxObjectFor ? 'Chrome'
		: '';
}

/*
* 与mediaPlayer 绑定才能有效
*/
PlayObj.prototype.bindID = function(id){
	switch(this.browserType){
		case "advance":
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:bindID--tmpId="+tmpId);
			var flag = this.mpObj.bindPlayerInstance(tmpId);
			this.debug("-fun:bindID--flag="+flag);
			break;
		case "coship"://0表示绑定成功，-1表示绑定失败
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:bindID coship--tmpId="+tmpId);
			var flag = this.mpObj.bindNativePlayerInstance(tmpId);
			this.debug("-fun:bindID coship--flag="+flag);
			break;
		case "gd_suma"://广东数码
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun: suma bindID--tmpId="+tmpId);
			var flag = this.mpObj.bindPlayerInstance(parseInt(tmpId));
			this.debug("-fun: suma bindID--flag="+flag);
			break;
		case "iPanel":break;
		case "android":break;
		case "Inspur":break;	
	}
};

/*
* 解除绑定，会释放资源，相当于close的操作
*/
PlayObj.prototype.unbindID = function(id){
	switch(this.browserType){
		case "advance":
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:unbindID--tmpId="+tmpId);
			var flag = this.mpObj.unbindPlayerInstance(tmpId);
			this.debug("-fun:unbindID--flag="+flag);
			break;
		case "coship"://0表示释放成功，-1表示释放失败
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:unbindID coship--tmpId="+tmpId);
			var flag = this.mpObj.releaseMediaPlayer(tmpId);
			this.debug("-fun:unbindID coship--flag="+flag);
			break;
		case "gd_suma"://广东数码
			var flag = this.mpObj.releasePlayerInstance();
			this.debug("-fun:unbindID gd_suma--flag="+flag);
			this.mpObj = null;
			break;
		case "iPanel":break;
		case "android":break;
		case "Inspur":break;
		default:break;
	}
};

/*
* 依据参数设置播放模式，
* 0：按setVideoDisplayArea()方法中设定的height、width、left和top属性所指定的位置和大小来显示；
* 1：全屏显示，按全屏高度和宽度显示(默认值)；
* else
*/
PlayObj.prototype.setMode = function(mode){
	switch(this.browserType){
		case "advance":
			this.mode = mode;
			this.mpObj.setVideoDisplayMode(mode);
			this.mpObj.refresh();
			break;
		case "coship":
			this.mode = mode;
			this.mpObj.setVideoDisplayMode(mode);
			break;
		case "gd_suma":
			break;
		case "iPanel":
			if(mode == 1){
				media.video.fullScreen(mode);
			}
			break;
		case "android":break;
		case "Inspur":break;
		default:break;
	}
};

/*
* 设置视频的位置
*/
PlayObj.prototype.setPosition = function(x,y,w,h,model){
	switch(this.browserType){
		case "advance":
			videoRectangle = new Rectangle();
			videoRectangle.left= x;
			videoRectangle.top = y;
			videoRectangle.width = w;
			videoRectangle.height = h;
			this.mpObj.setVideoDisplayArea(videoRectangle);
			this.debug("====refresh====");
			this.mpObj.refresh();
			break;
		case "nmg_suma"://内蒙古数码
			this.debug("====rocmeSTB====setPosition");
			rocmeSTB.player.setVideoWindow(x,y,w,h);
			break;
		case "gd_suma"://广东数码
			model = typeof model=="undefined"?0:model;
			this.mpObj.position = model+","+x+","+y+","+w+","+h;//非全屏，全屏设置为：1,0,0,0,0
			this.mpObj.refresh();
			break;
		case "iPanel":
			media.video.setPosition(x,y,w,h);//x,y,w,h
			break;
		case "android":
			this.debug("====android====setPosition");
			DRMPlayer.setDisplay('{"x":'+x+', "y":'+y+', "w":'+w+', "h":'+h+'}');//像素
			break;
		case "Inspur":
			this.debug("====Inspur====setPosition");
			iSTB.player.set_video_window(x,y,w,h);
			break;
		case "coship":
			this.mpObj.setMatchMethod(2);//设置视频输出自适应方式
			this.mpObj.setVideoDisplayArea(x,y,w,h);
			this.mpObj.setCurrentAudioChannel("Stereo"); //设置声道立体声
			this.mpObj.refreshVideoDisplay();//调整视频的显示，与setVideoDisplayMode或setVideoDisplayArea一起使用
			break;
		case "P60":
			//创建一个播放器，并指定播放器位置及大小，返回播放器id
			//播放器左上角的x坐标，该值为坐标相对于屏幕宽度的百分比，精确度小数点后3位
			x = (x/1280).toFixed(3);
			y = (y/720).toFixed(3);
			w = (w/1280).toFixed(3);
			h = (h/720).toFixed(3);
			this.debug("-fun:setPosition P60--x="+x+"  y="+y+"  w="+w+"  h="+h);
			var flag = mixplayer.resize(this.mediaId,x, y, w, h);
			this.debug("-fun:setPosition P60--flag="+flag);
			break;
		default:break;
	}
};

/*
* 设置播放路径,异步方法，设置待播放媒体的URL地址。设置此参数后，中间件自动检测设置的mediaURL的合法性。
* 若URL合法，则向页面发送MSG_MEDIA_URL_VALID消息；	value: 13001
* 若URL不合法，则向页面发送MSG_MEDIA_URL_INVALID消息。value: 13002
* 页面只有接收到MSG_MEDIA_URL_VALID消息后，才可以调用play()方法进行播放。
*/
PlayObj.prototype.setSource = function(url,s_flag,time){
	switch(this.browserType){
		case "advance":
			this.mediaUrl = url;
			this.debug("-fun:setSource---url="+url);
			var flag = this.mpObj.setMediaSource(url);
			this.debug("-fun:setSource---flag="+flag);
			break;
		case "nmg_suma"://内蒙古数码
			var flag = rocmeSTB.player.play(url);// 0表示成功，其他为错误码
			this.debug("rocmeSTB:setSource---flag="+flag);
			break;
		case "gd_suma"://广东数码
			this.mpObj.source = url;
			break;
		case "iPanel":
			DVB.stopAV();
			media.AV.open(url, s_flag);
			break;
		case "android":
			//播放前调用这个接口, 第一个代表缓冲多长时间的数据才开始播放, 第二个代表如果数据不足, 再次缓冲需要缓冲多长时间的数据. 单位都是毫秒
			DRMPlayer.setPlayerBuffer(1500,1500);
			var mediaUrl = '{"url":"'+url+'","type":"hls","protected":false, "skeEnabled":false, "accountId":"","crmId":"","sessionId":"","ticket":"","cookie":"","isStartOver":false,"laUrl":""}';
			DRMPlayer.open(mediaUrl);
			break;
		case "Inspur":
			this.debug("Inspur:setSource---url="+url);
			iSTB.player.play(url);
			break;
		case "coship":
			this.mpObj.clearIframe();
			// 0 ? 表示允许TrickMode操作。1 ? 表示不允许TrickMode操作 (默认值)。
			var flag1 = this.mpObj.setAllowTrickmodeFlag(0);//表示该播放器实例在生命周期内是否都允许任何 TrickMode操作（包括快进/快退/暂停）
			var flag2 = this.mpObj.setSingleMedia(url);
			this.debug("coship:setSource---flag1="+flag1+" | flag2="+flag2);
			break;
		case "P60":
			sysmisc.bringToForeground("web");//设置需要显示在最前的图层,video为视频层，其它为web层
			time = time?time:0;
			mixplayer.playUrl(this.mediaId, url, time);
			break;
		default:break;
	}
};

/*
* ipanel浏览器设置播放路径,异步方法，从媒体起始点开始播放，对电视广播以实时方式开始播放。
* 若播放成功，则向页面发送MSG_MEDIA_PLAY_SUCCESS消息；value: 13003
* 若播放失败，则向页面发送MSG_MEDIA_PLAY_FAILED消息。value: 13004
*/
PlayObj.prototype.play = function(flag){//参数0表示在后台播放，不传或者1表示前台播放
	switch(this.browserType){
		case "advance":
			this.debug("advance--play---flag:"+flag);
			this.debug("advance--play--instance_id::"+this.mpObj.getPlayerInstanceID());
			if(typeof flag == "undefined") this.mpObj.play();
			else this.mpObj.play(flag);
			break;
		case "gd_suma"://广东数码
			this.mpObj.play();
			break;
		case "iPanel":
			media.AV.play();
			this.debug("iPanel--play---flag");
			break;
		case "Inspur":break;
		case "coship"://成功返回0，否则返回其它
			var flag = this.mpObj.playFromStart();//从媒体起始点开始播放
			this.debug("coship:play---in play--flag="+flag);
			break;
		case "android":break;
	}
};

/*
* 暂停播放视频，默认保持最后一帧
* flag:0,	黑屏
* flag:1,	保持最后一帧 
*/
PlayObj.prototype.pause = function(flag){
	switch(this.browserType){
		case "advance":
			var flag = typeof flag == "undefined"?1:flag;
			this.debug("-fun:pause----flag="+flag);
			this.mpObj.enableTrickMode(1);
			this.mpObj.setPauseMode(flag);
			this.mpObj.pause();
			break;
		case "nmg_suma":
			rocmeSTB.player.pause();
			break;
		case "gd_suma":
			var flag = typeof flag == "undefined"?1:flag;
			this.debug("-fun:gd_suma pause----flag="+flag);
			var result = this.mpObj.pause(flag);
			this.debug("-fun:gd_suma pause--gd_suma--result="+result);
			break;
			break;
		case "iPanel":
			this.debug("iPanel-fun:iPanel pause----");
			media.AV.pause();
			break;
		case "android":
			DRMPlayer.pause();
			break;
		case "Inspur":
			iSTB.player.pause();
			break;
		case "coship":
			this.debug("-fun:pause--coship--flag="+flag);
			this.mpObj.setStopMode(flag);
			this.mpObj.pause();
			break;
		case "P60":
			var flag = mixplayer.pause(this.mediaId);//0:成功,-1:失败
			this.debug("-fun:pause--P60--flag="+flag);
			break;
		default:break;
	}
};

/*
*暂停后，还原到播放状态
*/
PlayObj.prototype.resume = function(){
	this.debug("-fun:resume---this.browserType="+this.browserType);
	switch(this.browserType){
		case "advance":
			this.mpObj.resume();
			break;
		case "nmg_suma":
			rocmeSTB.player.resume();
			break;
		case "gd_suma":
			this.mpObj.point = this.mpObj.currentPoint;
			this.mpObj.play();
			this.mpObj.refresh();
			break;
		case "iPanel":
			this.debug("-fun:iPanel resume----");
			media.AV.play();
			break;
		case "android":
			DRMPlayer.resume();
			break;
		case "Inspur":
			iSTB.player.resume();
			break;
		case "coship":
			this.mpObj.resume();
			break;
		case "P60":
			var flag = mixplayer.resume(this.mediaId);//0:成功,-1:失败
			this.debug("-fun:resume--P60--flag="+flag);
			break;
		default:break;
	}
};

/*
* 停止播放视频,默认保持最后一帧
* flag:0,	黑屏
* flag:1,	保持最后一帧 
*/
PlayObj.prototype.stop = function(flag){
	switch(this.browserType){
		case "advance":
			flag = typeof flag == "undefined"?1:flag;
			this.debug("-fun:stop----flag="+flag);
			this.debug("-fun:stop--this.mediaId="+this.mediaId);
			this.mpObj.setPauseMode(flag);
			this.mpObj.stop();
			DVB.clearVideoLevel();
			break;
		case "nmg_suma":
			rocmeSTB.player.stop();
			break;
		case "gd_suma":
			break;
		case "iPanel":
			flag = typeof flag == "undefined"?1:flag;
			this.debug("-fun:stop--iPanel--flag="+flag);
			// DVB.keepAVLastFrame = flag;
			DVB.stopAV(flag);
			// var num = media.AV.stop(flag);
			// this.debug("-fun:stop--iPanel--num="+num);
			break;
		case "android":
			DRMPlayer.close();
			break;
		case "Inspur":
			iSTB.player.stop();
			break;
		case "coship":
			flag = typeof flag == "undefined"?1:flag;
			this.debug("-fun:stop--coship--flag="+flag);
			this.mpObj.setStopMode(flag);
			this.mpObj.stop();//停止正在播放的媒体，并释放机顶盒本地播放器的相关资源
			break;
		case "P60":
			var state = mixplayer.stop(this.mediaId);//0:成功,-1:失败
			this.debug("-fun:stop--P60--state="+state);
			break;
		default:break;
	}
};


/*
*释放资源，等同于unBindID
*/
PlayObj.prototype.close = function(){
	switch(this.browserType){
		case "advance":
			// VOD.changeServer("huawei_v2","dvb");
			this.unbindID();
			break;
		case "iPanel":
			this.debug("-fun:close--iPanel--");
			media.AV.close();
			// VOD.changeServer("huawei_v2","dvb");
			break;
		case "gd_suma":
			this.unbindID();
			break;
		case "coship":
			this.unbindID();
			break;
		case "P60":
			var state = mixplayer.destroy(this.mediaId);//0:成功,-1:失败
			this.debug("-fun:close--P60--state="+state);
			break;
		case "android":break;
		case "Inspur":break;
		default:break;
	}
};

PlayObj.prototype.duration = function(){
	this.debug("-fun:duration---this.mediaId="+this.mediaId);
	switch(this.browserType){
		case "advance":
			var duration = this.mpObj.getMediaDuration();
			this.debug("advance-fun:duration---advance duration="+duration);
			return duration;
			break;
		case "nmg_suma":
			return rocmeSTB.player.getDuration();
			break;
		case "gd_suma":
			var duration = this.mpObj.getMediaDuration();
			this.debug("gd_suma-fun:duration---gd_suma duration="+duration);
			var arr = duration.split(":");
			duration = parseInt(arr[0],10)*3600+parseInt(arr[1],10)*60+parseInt(arr[2],10);
			this.debug("gd_suma-fun:duration---gd_suma duration222="+duration);
			return duration;
			break;
		case "iPanel":
			var duration = media.AV.duration;
			this.debug("iPanel-fun:duration---gd_suma duration="+duration);
			return duration;
			break;
		case "android":
			this.debug("-fun:duration---DRMPlayer.getDuration()="+DRMPlayer.getDuration(),2);
			return DRMPlayer.getDuration()/1000;
			break;
		case "Inspur":
			return iSTB.player.get_duration();
			break;
		case "coship":
			return this.mpObj.getMediaDuration();//获取当前播放的媒体的总时长，单位：秒
			break;
		case "P60":
			var duration = mixplayer.getDuration(this.mediaId);
			this.debug("-fun:duration--P60--duration="+duration);
			return duration;
			break;
		default:
			return 0;
			break;
	}
};

PlayObj.prototype.elapsed = function(){
	// this.debug("-fun:elapsed---this.mediaId="+this.mediaId);
	switch(this.browserType){
		case "advance":
			var currTime = this.mpObj.getCurrentPlayTime();
			this.debug("-fun:elapsed--getCurrentPlayTime="+currTime);
			return currTime;
			break;
		case "nmg_suma":
			this.debug("-fun:rocmeSTB--elapsed="+rocmeSTB.player.getPosition());
			return rocmeSTB.player.getPosition();
			break;
		case "gd_suma":
			var currTime = this.mpObj.currentPoint;
			this.debug("-fun:elapsed---gd_suma currTime="+currTime);
			return currTime;
			break;
		case "iPanel":
			var currTime = media.AV.elapsed;
			this.debug("-fun:elapsed---iPanel currTime="+currTime);
			return currTime;//返回当前实时流播放的位置（离开始点的时间距离）单位：秒
			break;
		case "android":
			this.debug("-fun:elapsed---DRMPlayer.getPosition()="+DRMPlayer.getPosition(),2);
			return Math.ceil(DRMPlayer.getPosition()/1000);
			break;
		case "Inspur":
			return iSTB.player.get_position();
			break;
		case "coship":
			return this.mpObj.getCurrentPlayTime();//获取媒体播放到的当前时间点，单位：秒
			break;
		case "P60":
			var currTime = mixplayer.getCurrent(this.mediaId);//单位秒
			this.debug("-fun:elapsed--P60--currTime="+currTime);
			return currTime;
			break;
		default: 
			return 0;
			break;
	}
};

PlayObj.prototype.seek = function(type, time){
	this.debug("-fun:seek---this.mediaId="+this.mediaId);
	switch(this.browserType){
		case "advance":
			this.mpObj.enableTrickMode(1);
			this.mpObj.seek(type, time);	
			break;
		case "nmg_suma":
			rocmeSTB.player.seek(time);
			break;
		case "gd_suma":
			this.mpObj.point = time;
			this.mpObj.refresh();
			break;
		case "iPanel":
			var hour = Math.floor(time/3600);
			var minute = Math.floor((time-hour*3600)/60);
			var second = time-hour*3600-minute*60;
			hour = hour>9?hour:"0"+hour;
			minute = minute>9?minute:"0"+minute;
			second = second>9?second:"0"+second;
			time = hour+":"+minute+":"+second;
			this.debug("-fun:seek-iPanel--time="+time);
			var flag = media.AV.seek(time);//1：表示成功;0：表示失败;
			this.debug("-fun:seek-iPanel--flag="+flag);
			break;
		case "android":
			this.debug("-fun:seek---type="+type+",time="+time,2);
			DRMPlayer.seekTo(time*1000);//毫秒
			break;
		case "Inspur":
			iSTB.player.seek(time);
			break;
		case "coship":
			var flag = this.mpObj.playByTime(type,time);//1：Normal Play Time；2：Absolute Time
			this.debug("-fun:seek--coship flag="+flag+" | time="+time);
			break;
		case "P60":
			this.debug("-fun:seek--P60--time="+time);
			var flag = mixplayer.seekTo(this.mediaId,time);//0:成功,-1:失败
			this.debug("-fun:seek--P60--flag="+flag);
			break;
		default:
			break;
	}
};

// 设置音量
PlayObj.prototype.setVolume = function(num){
	this.debug("-fun:setVolume--this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			media.sound.value = num;
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.setVolume(num);//num:0~31，表示音量。成功返回0，否则返回其它。
			this.debug("-fun:setVolume--flag="+flag);
			break;
		case "Inspur":
			iSTB.player.set_volume(num);
			break;
		case "gd_suma":
			DataAccess.setInfo("MediaSetting","OutputVolumn",num+"");//0-32
			break;
		case "P60":
			if(num > 0){
				mixplayer.voiceUp();
			}else{
				mixplayer.voiceDown();
			}
			break;
		default:
			break;
	}
};

// 获取音量
PlayObj.prototype.getVolume = function(){
	this.debug("-fun:getVolume---this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			return media.sound.getVolume();//从平台获取的音量值0~100
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.getVolume();//返回值:当前系统音量，0~31。
			this.debug("-fun:getVolume---flag="+flag);
			return flag;
			break;
		case "gd_suma":
			return parseInt(DataAccess.getInfo('MediaSetting', 'OutputVolumn'), 10);
			break;
		case "Inspur":
			return iSTB.player.get_volume();
			break;
		case "P60":
			return parseInt(mixplayer.getCurrentVoice(),10);
			break;
		default:
			return 0;
			break;
	}
};

/**
 * 设置静音
 * @param {[type]} num：0有声，1无声 [description]
 */
PlayObj.prototype.setMute = function(num){
	this.debug("-fun:setMute---this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			if(num == 1){
				media.sound.mute();
			}else{
				media.sound.resume();
			}
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.setMuteFlag(num);//0 ? 表示设置为有声 (默认值)。1 ? 表示设置为静音。成功返回0
			this.debug("-fun:setMute-coship--flag="+flag);
			break;
		case "gd_suma":
			if(num == 1){
				this.mpObj.audioMute();//将当前播放实例设置为静音
			}else{
				this.mpObj.audioUnmute();//将当前播放实例解除静音状态
			}
			break;
		case "Inspur":
			if(num == 0){
				iSTB.player.unmute();
			}else{
				iSTB.player.mute();
			}
			break;
		case "P60":
			if(num){
				mixplayer.mute();
			}else{
				mixplayer.voiceUp();//调大音量
			}
			break;
		default:
			break;
	}
};

// 获取静音状态
PlayObj.prototype.getMuteFlag = function(){
	this.debug("-fun:getMuteFlag---this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			return media.sound.isMute;//0,表示未静音；1,表示静音
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.getMuteFlag();//返回值:0表示有声 (默认值)。1表示静音。
			this.debug("-fun:getMuteFlag-coship--flag="+flag);
			return flag;
			break;
		case "gd_suma":
			return this.mpObj.getMute();//数值型，1为静音，0为非静音		
			break;
		default:
			return 0;
			break;
	}
};

PlayObj.prototype.startTime = function(){
	this.debug("-fun:startTime---");
	switch(this.browserType){
		case "advance":
			return this.mpObj.getTSTVStartTime();
			break;
		case "iPanel":break;
		case "android":break;
		default:break;
	}
};

PlayObj.prototype.endTime = function(){
	this.debug("-fun:endTime---");
	switch(this.browserType){
		case "advance":
			return this.mpObj.getTSTVEndTime();	
			break;
		case "iPanel":break;
		case "android":break;
		default:break;
	}
};

PlayObj.prototype.presentTime = function(){
	this.debug("-fun:presentTime---");
	switch(this.browserType){
		case "advance":
			return this.mpObj.getTSTVPresentTime();
			break;
		case "iPanel":break;
		case "android":break;
		default:break;
	}
};

PlayObj.prototype.debug = function(str){
	if(configFlag == true && $("logDebug")){
		$("logTxt").innerHTML += "<p>"+str+"</p>";	
		$("logDebug").style.visibility = "visible";
	}else{
		switch(this.browserType){
			case "advance":
			case "iPanel":
				iPanel.debug(str);
				break;
			case "nmg_suma":
				rocmeSTB.event.debug(str);
				break;
			case "android":
				DRMPlayer.log(str);
				break;
			case "gd_suma":
			case "Chrome":
				console.log(str);
				break;
			case "coship":
				Utility.println("JSPrint", "0x3FFFFFFF", str)
				break;
			case "Inspur":break;
			default:
				console.log(str);
				break;
		}
	}
};

PlayObj.prototype.getPlaybackMode = function(){
	this.debug("-fun:getPlaybackMode---");
	switch(this.browserType){
		case "advance":
			return this.mpObj.getPlaybackMode();	
		break;
		case "iPanel":break;
		case "android":break;
		default:break;
	}
};

PlayObj.prototype.setPace = function(speed){
	this.debug("-fun:getPlaybackMode---speed="+speed);
	switch(this.browserType){
		case "iPanel":
			media.AV.forward(speed);
			break;
		case "advance":
			var flag = this.mpObj.setPace(speed);
			this.debug("-fun:advance setPace flag="+flag);
			break;
		case "android":break;
		case "coship"://speed:2~32
			if(speed > 0){
				var flag = this.mpObj.fastForward(speed);
			}else{
				var flag = this.mpObj.fastRewind(speed);
			}
			this.debug("-fun:coship setPace flag="+flag);
			break;
		case "gd_suma":
			this.mpObj.Pace = speed;
			this.mpObj.refresh();
			break;
		default:break;
	}
};
