/*
*	��װ���صĹ淶,���Žӿ�
*/

function PlayObj(){
	this.browserType = "";
	this.mpObj = null;
	this.mediaId = 0;
	this.pauseFlag = 0;
	this.mediaUrl = "";
}
/*
* ��ʼ�����ڴ���������
*/
PlayObj.prototype.init = function(){
	this.browserType = this.getBrowserType();//��ȡ���������
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
		case "gd_suma"://�㶫����
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
	}else if(typeof rocmeSTB != "undefined"){//���ɹ�����
		return "nmg_suma";
	}else if(typeof Network != "undefined" && /mozilla/.test(ua)){//�㶫ʡ���淶���õ��������
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
* ��mediaPlayer �󶨲�����Ч
*/
PlayObj.prototype.bindID = function(id){
	switch(this.browserType){
		case "advance":
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:bindID--tmpId="+tmpId);
			var flag = this.mpObj.bindPlayerInstance(tmpId);
			this.debug("-fun:bindID--flag="+flag);
			break;
		case "coship"://0��ʾ�󶨳ɹ���-1��ʾ��ʧ��
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:bindID coship--tmpId="+tmpId);
			var flag = this.mpObj.bindNativePlayerInstance(tmpId);
			this.debug("-fun:bindID coship--flag="+flag);
			break;
		case "gd_suma"://�㶫����
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
* ����󶨣����ͷ���Դ���൱��close�Ĳ���
*/
PlayObj.prototype.unbindID = function(id){
	switch(this.browserType){
		case "advance":
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:unbindID--tmpId="+tmpId);
			var flag = this.mpObj.unbindPlayerInstance(tmpId);
			this.debug("-fun:unbindID--flag="+flag);
			break;
		case "coship"://0��ʾ�ͷųɹ���-1��ʾ�ͷ�ʧ��
			var tmpId = typeof id == "undefined"?this.mediaId:id;
			this.debug("-fun:unbindID coship--tmpId="+tmpId);
			var flag = this.mpObj.releaseMediaPlayer(tmpId);
			this.debug("-fun:unbindID coship--flag="+flag);
			break;
		case "gd_suma"://�㶫����
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
* ���ݲ������ò���ģʽ��
* 0����setVideoDisplayArea()�������趨��height��width��left��top������ָ����λ�úʹ�С����ʾ��
* 1��ȫ����ʾ����ȫ���߶ȺͿ����ʾ(Ĭ��ֵ)��
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
* ������Ƶ��λ��
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
		case "nmg_suma"://���ɹ�����
			this.debug("====rocmeSTB====setPosition");
			rocmeSTB.player.setVideoWindow(x,y,w,h);
			break;
		case "gd_suma"://�㶫����
			model = typeof model=="undefined"?0:model;
			this.mpObj.position = model+","+x+","+y+","+w+","+h;//��ȫ����ȫ������Ϊ��1,0,0,0,0
			this.mpObj.refresh();
			break;
		case "iPanel":
			media.video.setPosition(x,y,w,h);//x,y,w,h
			break;
		case "android":
			this.debug("====android====setPosition");
			DRMPlayer.setDisplay('{"x":'+x+', "y":'+y+', "w":'+w+', "h":'+h+'}');//����
			break;
		case "Inspur":
			this.debug("====Inspur====setPosition");
			iSTB.player.set_video_window(x,y,w,h);
			break;
		case "coship":
			this.mpObj.setMatchMethod(2);//������Ƶ�������Ӧ��ʽ
			this.mpObj.setVideoDisplayArea(x,y,w,h);
			this.mpObj.setCurrentAudioChannel("Stereo"); //��������������
			this.mpObj.refreshVideoDisplay();//������Ƶ����ʾ����setVideoDisplayMode��setVideoDisplayAreaһ��ʹ��
			break;
		case "P60":
			//����һ������������ָ��������λ�ü���С�����ز�����id
			//���������Ͻǵ�x���꣬��ֵΪ�����������Ļ��ȵİٷֱȣ���ȷ��С�����3λ
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
* ���ò���·��,�첽���������ô�����ý���URL��ַ�����ô˲������м���Զ�������õ�mediaURL�ĺϷ��ԡ�
* ��URL�Ϸ�������ҳ�淢��MSG_MEDIA_URL_VALID��Ϣ��	value: 13001
* ��URL���Ϸ�������ҳ�淢��MSG_MEDIA_URL_INVALID��Ϣ��value: 13002
* ҳ��ֻ�н��յ�MSG_MEDIA_URL_VALID��Ϣ�󣬲ſ��Ե���play()�������в��š�
*/
PlayObj.prototype.setSource = function(url,s_flag,time){
	switch(this.browserType){
		case "advance":
			this.mediaUrl = url;
			this.debug("-fun:setSource---url="+url);
			var flag = this.mpObj.setMediaSource(url);
			this.debug("-fun:setSource---flag="+flag);
			break;
		case "nmg_suma"://���ɹ�����
			var flag = rocmeSTB.player.play(url);// 0��ʾ�ɹ�������Ϊ������
			this.debug("rocmeSTB:setSource---flag="+flag);
			break;
		case "gd_suma"://�㶫����
			this.mpObj.source = url;
			break;
		case "iPanel":
			DVB.stopAV();
			media.AV.open(url, s_flag);
			break;
		case "android":
			//����ǰ��������ӿ�, ��һ��������೤ʱ������ݲſ�ʼ����, �ڶ�������������ݲ���, �ٴλ�����Ҫ����೤ʱ�������. ��λ���Ǻ���
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
			// 0 ? ��ʾ����TrickMode������1 ? ��ʾ������TrickMode���� (Ĭ��ֵ)��
			var flag1 = this.mpObj.setAllowTrickmodeFlag(0);//��ʾ�ò�����ʵ���������������Ƿ������κ� TrickMode�������������/����/��ͣ��
			var flag2 = this.mpObj.setSingleMedia(url);
			this.debug("coship:setSource---flag1="+flag1+" | flag2="+flag2);
			break;
		case "P60":
			sysmisc.bringToForeground("web");//������Ҫ��ʾ����ǰ��ͼ��,videoΪ��Ƶ�㣬����Ϊweb��
			time = time?time:0;
			mixplayer.playUrl(this.mediaId, url, time);
			break;
		default:break;
	}
};

/*
* ipanel��������ò���·��,�첽��������ý����ʼ�㿪ʼ���ţ��Ե��ӹ㲥��ʵʱ��ʽ��ʼ���š�
* �����ųɹ�������ҳ�淢��MSG_MEDIA_PLAY_SUCCESS��Ϣ��value: 13003
* ������ʧ�ܣ�����ҳ�淢��MSG_MEDIA_PLAY_FAILED��Ϣ��value: 13004
*/
PlayObj.prototype.play = function(flag){//����0��ʾ�ں�̨���ţ���������1��ʾǰ̨����
	switch(this.browserType){
		case "advance":
			this.debug("advance--play---flag:"+flag);
			this.debug("advance--play--instance_id::"+this.mpObj.getPlayerInstanceID());
			if(typeof flag == "undefined") this.mpObj.play();
			else this.mpObj.play(flag);
			break;
		case "gd_suma"://�㶫����
			this.mpObj.play();
			break;
		case "iPanel":
			media.AV.play();
			this.debug("iPanel--play---flag");
			break;
		case "Inspur":break;
		case "coship"://�ɹ�����0�����򷵻�����
			var flag = this.mpObj.playFromStart();//��ý����ʼ�㿪ʼ����
			this.debug("coship:play---in play--flag="+flag);
			break;
		case "android":break;
	}
};

/*
* ��ͣ������Ƶ��Ĭ�ϱ������һ֡
* flag:0,	����
* flag:1,	�������һ֡ 
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
			var flag = mixplayer.pause(this.mediaId);//0:�ɹ�,-1:ʧ��
			this.debug("-fun:pause--P60--flag="+flag);
			break;
		default:break;
	}
};

/*
*��ͣ�󣬻�ԭ������״̬
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
			var flag = mixplayer.resume(this.mediaId);//0:�ɹ�,-1:ʧ��
			this.debug("-fun:resume--P60--flag="+flag);
			break;
		default:break;
	}
};

/*
* ֹͣ������Ƶ,Ĭ�ϱ������һ֡
* flag:0,	����
* flag:1,	�������һ֡ 
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
			this.mpObj.stop();//ֹͣ���ڲ��ŵ�ý�壬���ͷŻ����б��ز������������Դ
			break;
		case "P60":
			var state = mixplayer.stop(this.mediaId);//0:�ɹ�,-1:ʧ��
			this.debug("-fun:stop--P60--state="+state);
			break;
		default:break;
	}
};


/*
*�ͷ���Դ����ͬ��unBindID
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
			var state = mixplayer.destroy(this.mediaId);//0:�ɹ�,-1:ʧ��
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
			return this.mpObj.getMediaDuration();//��ȡ��ǰ���ŵ�ý�����ʱ������λ����
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
			return currTime;//���ص�ǰʵʱ�����ŵ�λ�ã��뿪ʼ���ʱ����룩��λ����
			break;
		case "android":
			this.debug("-fun:elapsed---DRMPlayer.getPosition()="+DRMPlayer.getPosition(),2);
			return Math.ceil(DRMPlayer.getPosition()/1000);
			break;
		case "Inspur":
			return iSTB.player.get_position();
			break;
		case "coship":
			return this.mpObj.getCurrentPlayTime();//��ȡý�岥�ŵ��ĵ�ǰʱ��㣬��λ����
			break;
		case "P60":
			var currTime = mixplayer.getCurrent(this.mediaId);//��λ��
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
			var flag = media.AV.seek(time);//1����ʾ�ɹ�;0����ʾʧ��;
			this.debug("-fun:seek-iPanel--flag="+flag);
			break;
		case "android":
			this.debug("-fun:seek---type="+type+",time="+time,2);
			DRMPlayer.seekTo(time*1000);//����
			break;
		case "Inspur":
			iSTB.player.seek(time);
			break;
		case "coship":
			var flag = this.mpObj.playByTime(type,time);//1��Normal Play Time��2��Absolute Time
			this.debug("-fun:seek--coship flag="+flag+" | time="+time);
			break;
		case "P60":
			this.debug("-fun:seek--P60--time="+time);
			var flag = mixplayer.seekTo(this.mediaId,time);//0:�ɹ�,-1:ʧ��
			this.debug("-fun:seek--P60--flag="+flag);
			break;
		default:
			break;
	}
};

// ��������
PlayObj.prototype.setVolume = function(num){
	this.debug("-fun:setVolume--this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			media.sound.value = num;
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.setVolume(num);//num:0~31����ʾ�������ɹ�����0�����򷵻�������
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

// ��ȡ����
PlayObj.prototype.getVolume = function(){
	this.debug("-fun:getVolume---this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			return media.sound.getVolume();//��ƽ̨��ȡ������ֵ0~100
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.getVolume();//����ֵ:��ǰϵͳ������0~31��
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
 * ���þ���
 * @param {[type]} num��0������1���� [description]
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
			var flag = this.mpObj.setMuteFlag(num);//0 ? ��ʾ����Ϊ���� (Ĭ��ֵ)��1 ? ��ʾ����Ϊ�������ɹ�����0
			this.debug("-fun:setMute-coship--flag="+flag);
			break;
		case "gd_suma":
			if(num == 1){
				this.mpObj.audioMute();//����ǰ����ʵ������Ϊ����
			}else{
				this.mpObj.audioUnmute();//����ǰ����ʵ���������״̬
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
				mixplayer.voiceUp();//��������
			}
			break;
		default:
			break;
	}
};

// ��ȡ����״̬
PlayObj.prototype.getMuteFlag = function(){
	this.debug("-fun:getMuteFlag---this.browserType="+this.browserType);
	switch(this.browserType){
		case "iPanel":
			return media.sound.isMute;//0,��ʾδ������1,��ʾ����
			break;
		case "android":break;
		case "advance":
		case "coship":
			var flag = this.mpObj.getMuteFlag();//����ֵ:0��ʾ���� (Ĭ��ֵ)��1��ʾ������
			this.debug("-fun:getMuteFlag-coship--flag="+flag);
			return flag;
			break;
		case "gd_suma":
			return this.mpObj.getMute();//��ֵ�ͣ�1Ϊ������0Ϊ�Ǿ���		
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
