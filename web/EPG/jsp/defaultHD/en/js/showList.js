/*
 * showList对象的作用就是控制在页面列表数据信息上下滚动切换以及翻页；
 * @__listSize    列表显示的长度；
 * @__dataSize    所有数据的长度；
 * @__position    数据焦点的位置；
 * @__startplace  列表焦点Div开始位置的值；
 */
function showList(__listSize, __dataSize, __position, __startplace, __f){
	this.currWindow = typeof(__f)     =="undefined" ? iPanel.mainFrame : __f;//使用窗口
	this.listSize = typeof(__listSize)=="undefined" ? 0 : __listSize;//列表显示的长度
	this.dataSize = typeof(__dataSize)=="undefined" ? 0 : __dataSize;//所有数据的长度
	this.position = typeof(__position)=="undefined" ? 0 : __position;//数据焦点的位置  
	this.focusPos = 0;    //页面焦点的位置
	this.lastPosition = 0;
	this.lastFocusPos = 0;
	this.tempSize = 0;
	this.infinite = 0;
	
	this.fixedPos = Math.floor((this.listSize-1)/2);//页面固定焦点位置
	
	this.pageStyle  = 0;
	this.pageLoop   = null;
	this.showLoop   = null;
	this.focusLoop  = null;
	this.focusFixed = null;
	this.focusVary  = 1;
	this.focusStyle = 0;
	
	this.showType = 1;
	this.listSign = 0;
	this.listHigh = 30;
	this.listPage = 1;
	this.currPage = 1;
	
	this.focusDiv = -1;
	this.focusPlace = new Array();
	this.startPlace = typeof(__startplace)=="undefined" ? 0 : __startplace;//页面焦点初始top值
	
	this.haveData = function(){};
	this.notData = function(){};
	
	this.focusUp  = function(){this.changeList(-1);};
	this.focusDown= function(){this.changeList(1); };
	this.pageUp   = function(){this.changePage(-1);};
	this.pageDown = function(){this.changePage(1); };
	
	this.startShow = function(){
		this.initAttrib();
		this.setFocus();
		this.showList();
	}
	this.initAttrib = function(){	
		if(typeof(this.listSign)=="number") this.listSign = this.listSign==0 ? "top":"left";
		if(typeof(this.focusDiv)=="object") this.focusDiv.moveSign = this.listSign;
				
		if(this.focusFixed==null||(this.focusFixed&&this.showType==0)) this.focusFixed = false;
		if(this.showLoop  ==null) this.showLoop   = this.focusFixed ? true : false;
		if(this.pageLoop  ==null) this.pageLoop   = this.showLoop ? true : false;
		if(this.focusLoop ==null) this.focusLoop  = this.showLoop ? true : false;
		if(!this.focusFixed&&this.dataSize<this.listSize) this.showLoop = false;
		
		if(this.focusVary<1) this.focusVary = 1;
		if(this.focusPos>=this.listSize) this.focusPos = this.listSize-1;
		if(this.focusPos<0) this.focusPos = 0;
		if(this.position>=this.dataSize) this.position = this.dataSize-1;
		if(this.position<0) this.position = 0;
		this.lastPosition = this.infinite = this.position;
		
		this.initPlace();
		this.initFocus();
		this.lastFocusPos = this.focusPos;
	}
	this.initFocus = function(){
		this.tempSize = this.dataSize<this.listSize?this.dataSize:this.listSize;
		if(this.showType == 0){
			this.focusPos = this.position%this.listSize;
		}else if(!this.focusFixed&&!this.showLoop){
			var tempNum = this.position-this.focusPos;
			if(tempNum<0||tempNum>this.dataSize-this.tempSize) this.focusPos = this.position<this.tempSize ? this.position : this.tempSize-(this.dataSize-this.position);
		}
	}
	this.initPlace = function(){
		var tmph = this.listHigh;
		var tmpp = [this.startPlace];		
		for(var i=1; i<this.listSize; i++) tmpp[i] = typeof(tmph)=="object" ? (typeof(tmph[i-1])=="undefined" ? tmph[tmph.length-1]+tmpp[i-1] : tmph[i-1]+tmpp[i-1]) : tmph*i+tmpp[0];
		this.focusPlace = tmpp;
	}
	this.changeList = function(__num){
		if(this.dataSize==0) return;
		if((this.position+__num<0||this.position+__num>this.dataSize-1)&&!this.focusLoop) return;
		this.changePosition(__num);
		this.checkFocusPos(__num);
	}
	this.changePosition = function(__num){
		this.infinite += __num;
		this.lastPosition = this.position;	
		this.position = this.getPos(this.infinite, this.dataSize);
	}
	this.checkFocusPos = function(__num){
		if(this.showType==0){	
			var tempNum  = this.showLoop ? this.infinite : this.position;
			var tempPage = Math.ceil((tempNum+1)/this.listSize);
			this.changeFocus(this.getPos(tempNum, this.listSize)-this.focusPos);
			if(this.currPage!=tempPage){ this.currPage = tempPage;this.showList(); }		
		}else{
			if((this.lastPosition+__num<0||this.lastPosition+__num>this.dataSize-1)&&!this.showLoop&&!this.focusFixed){
				this.changeFocus(__num*(this.tempSize-1)*-1);
				this.showList();
				return;
			}
			
			var tempNumUp = __num*this.fixedPos;
			var tempNumDown = __num*(this.listSize-1-this.fixedPos);
			
			if(this.focusPos+__num<0||this.focusPos+__num>this.listSize-1||this.focusFixed){				
				this.showList();
			}else if(this.showType==2&&!this.showLoop&&Math.abs(__num)==1&&((this.focusPos+__num==0&&this.position!=0)||(this.focusPos+__num==this.listSize-1&&this.position!=this.dataSize-1))){
				this.showList();
			}else if(this.showType==3&&!this.showLoop&&Math.abs(__num)==1&&((this.focusPos+tempNumUp==0&&this.lastPosition+tempNumUp!=0)||(this.focusPos+tempNumDown==this.listSize-1&&this.lastPosition+tempNumDown!=this.dataSize-1))){
				this.showList();
			}else{
				this.changeFocus(__num);
			}
		}		
	}
	this.changeFocus = function(__num){
		this.lastFocusPos = this.focusPos;
		this.focusPos += __num;
		this.setFocus(__num);
	}
	this.setFocus = function(__num){
		if(typeof(this.focusDiv)=="number") return;
		var tempBool = this.focusStyle==0&&(Math.abs(this.focusPos-this.lastFocusPos)>this.focusVary||(Math.abs(this.position-this.lastPosition)>1&&!this.showLoop));
		if(typeof(this.focusDiv)=="string"){
			this.$(this.focusDiv).style[this.listSign] = this.focusPlace[this.focusPos];
		}else if(typeof(__num)=="undefined"||tempBool){
			this.focusDiv.tunePlace(this.focusPlace[this.focusPos]);
		}else if(__num!=0){
			this.focusDiv.moveStart(__num/Math.abs(__num), Math.abs(this.focusPlace[this.focusPos]-this.focusPlace[this.lastFocusPos]));
		}
	}	
	this.changePage = function(__num){	
		if(this.dataSize==0) return;
		var isBeginOrEnd = this.currPage+__num<1||this.currPage+__num>this.listPage;
		if(this.showLoop){
			if(isBeginOrEnd&&!this.pageLoop) return;
			var tempNum = this.listSize*__num;
			if(!this.focusFixed&&this.pageStyle!=0&&this.focusPos!=0){
				this.changePosition(this.focusPos*-1);
				this.checkFocusPos(this.focusPos*-1);
			}
			this.changePosition(tempNum);
			this.checkFocusPos(tempNum);
		}else{
			if(this.dataSize<=this.listSize) return;
			if(this.showType==0){
				if(isBeginOrEnd&&!this.pageLoop) return;
				var endPageNum = this.dataSize%this.listSize;
				var isEndPages = (this.getPos(this.currPage-1+__num, this.listPage)+1)*this.listSize>this.dataSize;
				var overNum = isEndPages && this.focusPos >= endPageNum ? this.focusPos+1-endPageNum : 0;		
				var tempNum = isBeginOrEnd && endPageNum != 0 ? endPageNum : this.listSize; 
				overNum = this.pageStyle==0 ? overNum : this.focusPos;
				tempNum = tempNum*__num-overNum;				
				this.changePosition(tempNum);
				this.checkFocusPos(tempNum);
			}else{
				var tempPos   = this.position-this.focusPos;
				var tempFirst = this.dataSize-this.tempSize;
				if(tempPos+__num<0||tempPos+__num>tempFirst){
					if(!this.pageLoop) return;
					tempPos = __num<0 ? tempFirst : 0;
				}else{
					tempPos += this.tempSize*__num;
					if(tempPos<0||tempPos>tempFirst) tempPos = __num<0 ? 0 : tempFirst;
				}		
				var tempNum = this.pageStyle==0||this.focusFixed ? this.focusPos : 0;
				if(!this.focusFixed&&this.pageStyle!=0&&this.focusPos!=0) this.changeFocus(this.focusPos*-1);
				this.changePosition(tempPos-this.position+tempNum); 
				this.showList();
			}
		}
	}
	this.showList = function(){
		var tempPos = this.position-this.focusPos;
		for(var i=tempPos; i<tempPos+this.listSize; i++){		
			var tempObj = { idPos:i-tempPos, dataPos:this.getPos(i, this.dataSize) };
			(i>=0&&i<this.dataSize)||(this.showLoop&&this.dataSize!=0) ? this.haveData(tempObj) : this.notData(tempObj);
		}
		this.currPage = Math.ceil((this.position+1)/this.listSize);
		this.listPage = Math.ceil(this.dataSize/this.listSize);
	}
	this.clearList = function(){
		for(var i=0; i<this.listSize; i++) this.notData( { idPos:i, dataPos:this.getPos(i, this.dataSize) } );
	}	
	this.getPos = function(__num, __size){
		return __size==0 ? 0 : (__num%__size+__size)%__size;
	}
	this.$ = function(__id){
		if(typeof(this.currWindow.keyActionCount)!="undefined") this.currWindow.keyActionCount++;
		return this.currWindow.document.getElementById(__id);
	}
}