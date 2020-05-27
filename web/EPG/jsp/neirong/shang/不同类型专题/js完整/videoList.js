function VideoList() {
	var listData = [];
	this.listBox = null;
	var listFocusPos = 0;	//当前焦点位置
	var maxListLen = 6;		//可见列表数
	var maxListWord = 30;	//可见列表字数
	var total = 0;			//列表总长
	var playingPos = [0,0];	//正在播放的视频在列表中下标、焦点位置
	var changeTimer = -1;
	this.listPos = 0;		//当前焦点在列表中下标
	this.videoID = 0;		//正在播放的视频id

	this.init = function(_data) {
		listData = _data;
		total = listData.length;
		iDebug("videoList.js init total="+total);
	}

	this.show = function(_pos) {
		iDebug("videoList.js show _pos="+_pos);
		if(typeof _pos != "undefined"){
			playingPos[0] = this.listPos = _pos;
			this.initList();
		}
		$("listDiv").style.visibility = "visible";
	}

	this.hide = function() {
		$("listDiv").style.visibility = "hidden";
		$("listFocus").style.visibility = "hidden";
		if(playingPos[1] > -1&&playingPos[1] < maxListLen){
			$("listBg" + playingPos[1]).style.visibility = "hidden";
		}
	}

	this.changeUD = function(_num) {
		this.changeList(_num,false);
	}

	// _flag：true表示自动切换
	this.changeList = function(_num, _flag) {
		var position = !_flag?this.listBox.position:playingPos[0];
		var focusPos = this.listBox.focusPos;
		if(position+_num < 0)return;
		if(position+_num > total-1&&_flag){//最后一条向下自动播放循环到第一个
			playingPos[0] = 0;
			iDebug("[videoList.js]changeList last playingPos[1]=== "+playingPos[1]);
			if((playingPos[1]+_num<0||playingPos[1]+_num>maxListLen-1)){
				this.loseFocus();
				playingPos[1] = 0;
				this.listPos = this.listBox.focusPos;
				listFocusPos = this.listBox.focusPos;
				this.initList();
			}
			this.changeVideo(playingPos[0]);
			return;
		}
		// 手动切换列表时，正在播放焦点位置发生变化
		if(!_flag&&(focusPos+_num<0||focusPos+_num>maxListLen-1)){
			playingPos[1] -= _num;
			iDebug("[videoList.js]manual playingPos[1]==="+playingPos[1])
		}
		clearTimeout(changeTimer);
		var self = this;
		changeTimer = setTimeout(function(){
			if(!_flag){//手动切换
				self.loseFocus();
				self.listBox.changeList(_num);
				self.onFocus();
			}else{//自动切换
				playingPos[0] += _num;
				iDebug("[videoList.js]changeList playingPos[0]==="+playingPos[0]+"     playingPos[1]=== "+playingPos[1]);
				// 第一个位置向上或最后一个位置向下
				if(playingPos[1]+_num<0||playingPos[1]+_num>maxListLen-1){
					var pos = playingPos[1];
					playingPos[1] = pos>maxListLen-1?maxListLen-1:pos<0?0:pos;
					self.listPos = pos<0?(self.listBox.position-Math.abs(pos-playingPos[1])+1):pos>maxListLen-1?(self.listBox.position+Math.abs(pos-playingPos[1])+1):self.listBox.position+_num;
					listFocusPos = focusPos;
					iDebug("[videoList.js]changeList self.listPos==="+self.listPos+" listFocusPos="+listFocusPos);
					self.initList();
				}
				self.changeVideo(playingPos[0]);
			}
		},100);
	}

	this.doSelect = function() {
		//避免同一个视频按多次播放多次
		if(total == 0||playingPos[0]==this.listBox.position){
			iDebug("videoList.js doSelect same !");
			return;
		}
		this.changeVideo();
		this.onFocus();
	}

	this.initList = function() {
		iDebug("[videoList.js] this.initList this.listPos="+this.listPos+"  this.videoID="+this.videoID);
		var self = this;
		this.listBox = new showList(maxListLen,total,this.listPos,40,window);
		this.listBox.focusDiv = "listFocus";
        this.listBox.listHigh = 96;
        this.listBox.focusPos = listFocusPos;
        // this.listBox.focusLoop = true;
        // this.listBox.pageLoop = true;
        this.listBox.haveData = function(_list){
        	maxListWord = _list.dataPos<9?30:_list.dataPos<99?29:_list.dataPos<999?28:27;
            $("listName"+_list.idPos).innerHTML = (_list.dataPos+1)+"."+getStrChineseLen(listData[_list.dataPos].name,maxListWord)+'<span id="listImg'+_list.idPos+'" style="display:inline-block; width:30px; background:url() no-repeat right center;">&nbsp;</span>';
            // 设置正在播放的样式
            if(_list.dataPos == playingPos[0]){
				$("listBg" + _list.idPos).style.visibility = "visible";
				$("listImg" + _list.idPos).style.backgroundImage = "url(images/biao02.gif)";
				playingPos[0] = _list.dataPos;
				playingPos[1] = _list.idPos;
				self.videoID = listData[_list.dataPos].id;
				iDebug("[videoList.js] this.initList self.videoID="+self.videoID);
            }else{
				// iDebug("[videoList.js] this.initList _list.idPos="+_list.idPos);
				$("listBg" + _list.idPos).style.visibility = "hidden";
            }
        };
        this.listBox.notData = function(_list){
            $("listName"+_list.idPos).innerHTML = "";
			$("listBg" + _list.idPos).style.visibility = "hidden";
        };
        this.listBox.startShow();
		this.onFocus();
	}

	// _pos：播放索引，自动播放传，手动切换不传
	this.changeVideo = function(_pos) {
		iDebug("[videoList.js] changeVideo typeof _pos="+typeof _pos);
		if(typeof _pos == "undefined"){//手动切换
			playingPos[0] = this.listBox.position;
			playingPos[1] = this.listBox.focusPos;
			_pos = this.listBox.position;
		}
		iDebug("[videoList.js] changeVideo----playingPos[0]="+playingPos[0]+" | playingPos[1]="+playingPos[1]);
		this.videoID = listData[_pos].id;
		this.listPos = playingPos[0];
		iDebug("[videoList.js] changeVideo this.videoID="+this.videoID);
		this.clearPlayFocus();
	}

	this.onFocus = function() {
		$("listFocus").style.visibility = "visible";
		$("listBg" + this.listBox.focusPos).style.visibility = "hidden";
		if(playingPos[0] == this.listBox.position){
			playingPos[1] = this.listBox.focusPos;
			$("listImg" + this.listBox.focusPos).style.backgroundImage = "url(images/biao02_1.gif)";
		}
	}

	this.loseFocus = function() {
		$("listFocus").style.visibility = "hidden";
		if(playingPos[0] == this.listBox.position){
			$("listBg" + this.listBox.focusPos).style.visibility = "visible";
			$("listImg" + this.listBox.focusPos).style.backgroundImage = "url(images/biao02.gif)";
			playingPos[1] = this.listBox.focusPos;
		}				
	}

	// 清除新闻列表播放样式
	this.clearPlayFocus = function() {
		for(var i=0;i<maxListLen;i++){
			if((i+this.listBox.position-this.listBox.focusPos) == playingPos[0]){
				$("listBg" + i).style.visibility = "visible";
				$("listImg" + i).style.backgroundImage = "url(images/biao02.gif)";
				playingPos[1] = i;
			}else{
				$("listBg" + i).style.visibility = "hidden";
				if($("listImg" + i)){
					$("listImg" + i).style.backgroundImage = "";
				}
			}
		}
	}
}