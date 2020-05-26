function $(_id){
	return document.getElementById(_id);
}
function getUrlParams(_key, _url) {
	//alert(window.location.href);
/*
 * ��ȡ��׼URL�Ĳ���
 * @_key���ַ�������֧����������������ͬ��key��
 * @_url���ַ�������window��.location.href��ʹ��ʱ������window����
 * ע�⣺
 * 	1���粻����ָ���������ؿ��ַ���������ֱ����ʾ��ʹ��ʱע���ж�
 * 	2���Ǳ�׼URL����
 */
	if (typeof(_url) == "object") {
		url = _url.location.href;
	} else {
		_url = (typeof(_url) == "undefined" || _url == null || _url == "") ? window.location.href : _url;
	}
	if (_url.indexOf("?") == -1) {
		return "";
	}
	var params = [];
	_url = _url.split("?")[1].split("&");
	for (var i = 0, len = _url.length; i < len; i++) {
		params = _url[i].split("=");
		if (params[0] == _key) {
			return params[1];
		}
	}
	return "";
}


/*
**���ݴ�����ַ����ͳ��ȶԱ�
*��str���ȳ���lenʱ��ֱ�ӷ���len���ȵ�str
*��str����û����lenʱ��typeΪ1�Ļ�ֱ�ӷ���str�����򷵻�""
*/
function getDisplayString(str,len,type){
    var totalLength=0;
    var toMarqueeFlag = false;
    var position=0;
    for(var i=0;i<str.length;i++){
        var intCode=str.charCodeAt(i);
        if((intCode >= 0x0001 && intCode <= 0x007e) || (0xff60<=intCode && intCode<=0xff9f)){
            totalLength+=1;//�����ĵ����ַ����ȼ�1
        }else{
            totalLength+=2;//�����ַ��������2
        }
        if(totalLength > len){
            position = i;
            toMarqueeFlag = true;
            break;
        }
    }
    if(toMarqueeFlag)
        return str.substring(0,position);
    if(type == 1) return str;
	return "";
}
//�Ը����ַ������б���ת����ת���ɵ�ǰҳ�����
//iPanel.getDisplayString();
function getStrChineseLength(str){
	str = str.replace(/[ ]*$/g,"");
	var w = 0;
	for (var i=0; i<str.length; i++) {
		 var c = str.charCodeAt(i);
		 //���ֽڼ�1
		 if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
		   w++;
		 }else {
		   w+=2;
		 }
    } 	
	var length = w % 2 == 0 ? (w/2) : (parseInt(w/2)+1) ;
	return length;
}

//jsonת�����ַ�����ʽ
var jsonToString =  function(json) {
	function switchObjectType(obj) {
		var s = "";
		switch (typeof(obj)) {
			case "string":
				s += "\"" + obj + "\"";
				break;
			case "numeric":
			case "boolean":
				s += obj;
				break;
			case "object":
				if (obj.constructor === Array) {
					var len = obj.length;
					s += "[";
					for (var i = 0; i < len; i ++) {
						if (i > 0) {
							s += ",";
						}
						s += switchObjectType(obj[i]);
					}
					s += "]";
				}
				else if (obj.constructor === Function) {
					s += obj;
				}
				else {
					s += jsonToString(obj);
				}
				break;
			case "function":
				s += obj;
				break;
			default:
				s += obj;
				break;
			}
			
			return s;
	}
	
	var str = "";
	var first = true;
	var json_type = "object";
	
	if(json != null && typeof(json) == "object") {
		if (json.constructor === Array) {
			json_type = "array";
		}
		
		str += (json_type == "object") ? "{" : "[";
		
		for (var property in json) {
			if (!first) {
				str += ",";
			}
			else {
				first = false;
			}
			
			if (json_type == "object") {
				str += "\"" + property + "\":";
			}
			
			if (json[property] != null) {
				str += switchObjectType(json[property]);
			}
			else {
				str += "null";
			}
		}
		str += (json_type == "object") ? "}" : "]";
	}
	
	return str;
};



var util = {
	/**
	 * util.date��������������Date�йصĹ���
	 */
	date: {
		/**
		 * util.date.format����������������ڶ���d��ʽ��Ϊformatterָ���ĸ�ʽ
		 * @param {object} d ����Ҫ���и�ʽ����date����
		 * @param {string} formatter ������Ҫ�ĸ�ʽ���硰yyyy-MM-dd hh:mm:ss��
		 * @return {string} ��ʽ����������ַ������硰2008-09-01 14:00:00��
		 */
		format: function(d, formatter) {
		    if(!formatter || formatter == "")
		    {
		        formatter = "yyyy-MM-dd";
		    }

			var weekdays = {
				chi: ["������", "����һ", "���ڶ�", "������", "������", "������", "������"],
				eng: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
			};
		    var year = d.getYear().toString();
		    var month = (d.getMonth() + 1).toString();
		    var date = d.getDate().toString();
		    var day = d.getDay();
			var hour = d.getHours().toString();
			var minute = d.getMinutes().toString();
			var second = d.getSeconds().toString();

		    var yearMarker = formatter.replace(/[^y|Y]/g,'');
		    if(yearMarker.length == 2) {
		        year = year.substring(2,4);
		    }

		    var monthMarker = formatter.replace(/[^M]/g,'');
		    if(monthMarker.length > 1) {
		        if(month.length == 1) {
		            month = "0" + month;
		        }
		    }

		    var dateMarker = formatter.replace(/[^d]/g,'');
		    if(dateMarker.length > 1) {
		        if(date.length == 1) {
		            date = "0" + date;
		        }
		    }

			var hourMarker = formatter.replace(/[^h]/g, '');
		    if(hourMarker.length > 1) {
				if(hour.length == 1) {
					hour = "0" + hour;
				}
		    }

			var minuteMarker = formatter.replace(/[^m]/g, '');
		    if(minuteMarker.length > 1) {
				if(minute.length == 1) {
					minute = "0" + minute;
				}
		    }

			var secondMarker = formatter.replace(/[^s]/g, '');
		    if(secondMarker.length > 1) {
				if(second.length == 1) {
					second = "0" + second;
				}
		    }

		    var dayMarker = formatter.replace(/[^w]/g, '');
		  //  var lang = user.UILanguage;
		  var lang = 1;
		    var result = formatter.replace(yearMarker,year).replace(monthMarker,month).replace(dateMarker,date).replace(hourMarker,hour).replace(minuteMarker,minute).replace(secondMarker,second);
			
		    return result;
		},

        getDate: function(offset) {
            var d = new Date();
            var year = d.getYear();
            var month = d.getMonth();
            var date = d.getDate();
            var hour = d.getHours();
            var minute = d.getMinutes();
            var second = d.getSeconds();
            var dd = new Date(year, month, (date+offset), hour, minute, second);
            return dd;
        }
	},
	str: {
		addZero: function(__str, __num){
			__str = __str.toString();
			for(var i = __str.length; i < __num; i++){
				__str = "0"+__str;
			}
			return __str;
		},

		getDuration: function(__t1, __t2){
			var t1 = __t1.split(":");
			var t2 = __t2.split(":");
			var duration = 0;
			duration = (Math.floor(t2[0])*60+Math.floor(t2[1])) - (Math.floor(t1[0])*60+Math.floor(t1[1]));
			if(t1[0] > t2[0]) duration = duration + 1440;
			return duration;
		},
		secondToStringTime: function(__sec){
			var hour = Math.floor(__sec/3600);
			var minute = Math.floor((__sec - hour*3600)/60);
			var second = __sec - hour*3600 - minute*60;
			hour = hour>9?hour:"0"+hour;
			minute = minute>9?minute:"0"+minute;
			second = second>9?second:"0"+second;
			return hour+":"+minute+":"+second;
		},
		getDateTime : function (year,month,date,hour,minute,second) {
            var d = new Date(year, month-1, date, hour, minute, second);
            return d.getTime();
 		},
		getCurrTime:function(){
			 var d = new Date();
			 return d.getTime();
		}
	}
};




//������
function ScrollBar(id, barId, f) {
	this.obj = null;
	this.barObj = null;
	if (typeof(f) == "object"){
		this.obj = f.document.getElementById(id);
		if(typeof(barId) != "undefined"){
			this.barObj = f.document.getElementById(barId);
		}
	} else {
		this.obj = document.getElementById(id);
		if(typeof(barId) != "undefined"){
			this.barObj = document.getElementById(barId);
		}
	}
}

ScrollBar.prototype.init = function(totalNum, pageSize, maxBarLength, startPos, type) {
	this.startPos = startPos;
	var percent = 1;
	if (totalNum > pageSize) {
		percent = pageSize / totalNum;
	}
	var barLength = percent * maxBarLength;
	if(typeof(type) != "undefined"){
		if(this.barObj != null){
			this.barObj.style.height = Math.round(barLength) + "px";
		}
		else{
			this.obj.style.height = Math.round(barLength) + "px";
		}
		this.endPos = this.startPos + (maxBarLength - barLength);//2008-10-16
	}
	else{
		this.endPos = this.startPos + maxBarLength;
	}
	if(totalNum > 1){
		this.footStep = (this.endPos - this.startPos) / (totalNum - 1);
	}
	else{
		this.footStep = 0;
	}
};

ScrollBar.prototype.scroll = function(currPos) {
	var tempPos = this.startPos + this.footStep * currPos;
	this.obj.style.top = Math.round(tempPos) + "px";
};



/*
��ȡ�����е� ��Ʒ���ƵĴ���
������Ҫ���ֻ�Ʒ�Ƿ����ۣ�������ҳ�洦�����������
*/
function getProName(_arr){
	var str = "";
	for(var i = 0; i < _arr.length; i++){
		var tempName  = _arr[i].prodName;
		if(getStrChineseLength(tempName)>18){
			tempName= tempName.substr(0,18)+"...";
		}
		str += (tempName+"<br/>");	
	}	
	//iPanel.debug("getProName str ======" + str);
	return str;
}


/**
 *
 * @author yx
 * @type {{init: tgo.init, $focus: Array, getFocusIndex: tgo.getFocusIndex, searchFocus: tgo.searchFocus, focusMove: tgo.focusMove, $keyEvent: {up: tgo.$keyEvent.up, down: tgo.$keyEvent.down, left: tgo.$keyEvent.left, right: tgo.$keyEvent.right, ok: tgo.$keyEvent.ok, back: tgo.$keyEvent.back, beforeKeyEventEnter: tgo.$keyEvent.beforeKeyEventEnter, keyLock: boolean}, keyEventInit: tgo.keyEventInit}}
 */

/**
 *
 * @param {function} callback
 */
Array.prototype.each = function (callback) {
    for(var i = 0; i < this.length; i++){
        var breaks = callback(this[i],i);
        if(breaks === false){
        	break;
		}
    }
};
if(!window.JSON){
    window.JSON = {
        parse : function (str) {
			if(typeof str === 'string'){
				eval('var obj = ' + str);
				return obj;
			}
        },
		stringify : function (json) {
        	var str = '';
        	switch (typeof json){
				case 'object':
                    for(var key in json){
                        if(typeof json[key] === 'function'){
                        	continue;
						}
                        if(!(json instanceof Array)){
                            str += '"' + key + '"' + ':';
                        }
                        str += this.stringify(json[key]) + ','
                    }
                    str = str.substring(0,str.length - 1);
                    if(json instanceof Array){
                        str = '[' + str + ']'
                    }else{
                        str = '{' + str + '}'
                    }
					break;
				case 'string':
					str = '"' + json + '"';
					break;
				case 'function':
					break;
				default:
					str = json;
					break;
			}
			return str;
        }
    }
}

var tgo = {
    /**
	 *	初始化所有焦点、按键
     */
        init: function (options) {
            // if(typeof Object.defineProperty !== 'undefined'){
             //    Object.defineProperty(tgo.$keyEvent,'ok',{
             //        set : function (val) {
             //            document.onclick = val;
             //            this.value = val;
             //        },
             //        get : function () {
             //            return this.value
             //        }
             //    });
			// }
        	this.keyEventInit();
        	if(options && options.focusElement){
        		tgo.focusElement = options.focusElement;
			}
			if(options && options.allFocus){
                this.allFocus = options.allFocus;
                if(typeof options.focusElement != 'undefined'){
                	for(var i = 0; i < this.allFocus.length; i++){
                		var obj = this.allFocus[i];
                        options.focusElement(obj)
					}
                }
            }else{
                this.allFocus = tgo.searchFocus();
			}
            this.currentFocus = this.allFocus[0];
        },
        $focus: [],
		getFocusIndex:function (ele) {
			for ( var i = 0; i < this.allFocus.length; i++){
				if(this.allFocus[i] === ele){
					return i;
				}
			}
        },
        searchFocus: function () {
            try {
                var arr = [];
                var ele = document.getElementsByTagName("body")[0];
                forFocus(arr, ele);
                return arr;
                function forFocus(arr, ele) {
                    if (ele.children) {
                        for (var i = 0; i < ele.children.length; i++) {
                            if (ele.children[i] && ele.children[i].className) {
                                if (ele.children[i].className.indexOf("focus") > -1) {
                                    var isRepeat = false;
                                    for(var j = 0; j < arr.length; j++){
                                    	if(arr[j] === ele.children[i]){
                                    		isRepeat = true;
                                    		break;
										}
									}
									if(!isRepeat){
                                        arr.push(ele.children[i]);
                                        if(tgo.focusElement){
                                            tgo.focusElement(ele.children[i])
										}
                                    }
                                }
                            }
                            if (ele.children[i] && ele.children[i].children) {
                                if (ele.children[i].children.length > 0) {
                                    forFocus(arr, ele.children[i]);
                                }
                            }
                        }
                    }
                }
            } catch (e) {
                alert(e.name + " ," + e.message);
            }
        },
        focusMove: function (options) {
            try {
                /**
                 *  如果含有自定义焦点
                 */
                for (var i = 0; i < this.$focus.length; i++) {
					var res = false;
					if(typeof this.$focus[i].element === 'object'){
                        if(this.$focus[i].element instanceof TGOFOCUS || this.$focus[i].element instanceof Array){
							Array.prototype.each.call(this.$focus[i].element,function (obj) {
								if(obj === tgo.currentFocus){
									res = true;
									return false;
								}
							});
						}else{
							(this.$focus[i].element === this.currentFocus) && (res = true);
						}
					}
                    if (res) {
                        var dire;
                        if (options.direction == 'add') {
                            if (options.axis == 'x') {
                            	dire = this.$focus[i].direction.right;
                            	if(typeof this.$focus[i].direction.right === 'function'){
                                    dire = this.$focus[i].direction.right();
								}
                            } else if (options.axis == 'y') {
                                dire = this.$focus[i].direction.bottom;
                                if(typeof this.$focus[i].direction.bottom === 'function'){
                                    dire = this.$focus[i].direction.bottom();
                                }
                            }
                        } else if (options.direction == 'reduce') {
                            if (options.axis == 'x') {
                                dire = this.$focus[i].direction.left;
                                if(typeof this.$focus[i].direction.left === 'function'){
                                    dire = this.$focus[i].direction.left();
                                }
                            } else if (options.axis == 'y') {
                                dire = this.$focus[i].direction.top;
                                if(typeof this.$focus[i].direction.top === 'function'){
                                    dire = this.$focus[i].direction.top();
                                }
                            }
                        }
                        if(dire === false){
                            return tgo.currentFocus;
                        }
                        if(dire) {
                            if(dire instanceof TGOFOCUS || dire instanceof Array){
                            	return dire[0]
							}else{
                                return dire
							}
                        }
                        break;
                    }
                }
                var children = tgo.allFocus;
                var x1 = getOffsetLeftByBody(tgo.currentFocus);
                var x2 = getOffsetLeftByBody(tgo.currentFocus) + getOffsetWidthByBody(tgo.currentFocus);
                var y1 = getOffsetTopByBody(tgo.currentFocus);
                var y2 = getOffsetTopByBody(tgo.currentFocus) + getOffsetHeightByBody(tgo.currentFocus);
                var tempArr = [];
                for (var i = 0; i < children.length; i++) {
                        switch (options.axis) {
                            case 'x':
                                if (options.direction == 'add') {
                                    if (getOffsetLeftByBody(children[i]) >= x2) {
                                        tempArr.push(children[i]);
                                    }
                                } else if (options.direction == 'reduce') {
                                    if (getOffsetLeftByBody(children[i]) + getOffsetWidthByBody(children[i]) <= x1) {
                                        tempArr.push(children[i]);
                                    }
                                }
                                break;
                            case 'y':
                                if (options.direction == 'add') {
                                    if (getOffsetTopByBody(children[i]) >= y2) {
                                        tempArr.push(children[i]);
                                    }
                                } else if (options.direction == 'reduce') {
                                    if (getOffsetTopByBody(children[i]) + getOffsetHeightByBody(children[i]) <= y1) {
                                        tempArr.push(children[i]);
                                    }
                                }
                                break;
                        }
                }
                var min = {
                    jl: 0,
                    element: tgo.currentFocus
                };
                for (var j = 0; j < tempArr.length; j++) {
                    var tempX1 = getOffsetLeftByBody(tempArr[j]);
                    var tempX2 = getOffsetLeftByBody(tempArr[j]) + getOffsetWidthByBody(tempArr[j]);
                    var tempY1 = getOffsetTopByBody(tempArr[j]);
                    var tempY2 = getOffsetTopByBody(tempArr[j]) + getOffsetHeightByBody(tempArr[j]);
                    var jl = -1;
                    switch (options.axis) {
                        case 'x':
                            if (options.direction == 'add') {
                                if (y2 < tempY1) {
                                    jl = (tempX1 - x2) * (tempX1 - x2) + (tempY1 - y2) * (tempY1 - y2);
                                } else if (y1 > tempY2) {
                                    jl = (tempX1 - x2) * (tempX1 - x2) + (tempY2 - y1) * (tempY2 - y1);
                                } else {
                                    jl = (tempX1 - x2) * (tempX1 - x2);
                                }
                            } else if (options.direction == 'reduce') {
                                if (y2 < tempY1) {
                                    jl = (x1 - tempX2) * (x1 - tempX2) + (y1 - tempY2) * (y1 - tempY2);
                                } else if (y1 > tempY2) {
                                    jl = (x1 - tempX2) * (x1 - tempX2) + (y2 - tempY1) * (y2 - tempY1);
                                } else {
                                    jl = (x1 - tempX2) * (x1 - tempX2);
                                }
                            }
                            break;
                        case 'y':
                            if (options.direction == 'add') {
                                if (x1 > tempX2) {
                                    jl = (y2 - tempY1) * (y2 - tempY1) + (x1 - tempX2) * (x1 - tempX2);
                                } else if (x2 < tempX1) {
                                    jl = (y2 - tempY1) * (y2 - tempY1) + (x2 - tempX1) * (x2 - tempX1);
                                } else {
                                    jl = (y2 - tempY1) * (y2 - tempY1);
                                }
                            } else if (options.direction == 'reduce') {
                                if (x1 > tempX2) {
                                    jl = (tempY2 - y1) * (tempY2 - y1) + (tempX1 - x2) * (tempX1 - x2);
                                } else if (x2 < tempX1) {
                                    jl = (tempY2 - y1) * (tempY2 - y1) + (tempX2 - x1) * (tempX2 - x1);
                                } else {
                                    jl = (tempY2 - y1) * (tempY2 - y1);
                                }
                            }
                            break;
                    }

                    if (j == 0) {
                        min.jl = jl;
                        min.element = tempArr[j];
                    } else if (min.jl > jl) {
                        min.jl = jl;
                        min.element = tempArr[j];
                    }
                }
                return (min.element);
            } catch (e) {
                alert(e.name + " ," + e.message);
            }
            return null;
        },
        $keyEvent: {
            up: function () {
            	$.preventDefault()
                var nextFocus = tgo.focusMove({
                    axis : 'y',
                    direction : 'reduce'
                });
                if(tgo.currentFocus != nextFocus && nextFocus.style.display != "none" && nextFocus.style.visibility != "hidden"){
                    tgo.querySelector(nextFocus).focus();
				}
            },
            down: function () {
                var nextFocus = tgo.focusMove({
                    axis : 'y',
                    direction : 'add'
                });
                if(tgo.currentFocus != nextFocus && nextFocus.style.display != "none"  && nextFocus.style.visibility != "hidden"){
                    tgo.querySelector(nextFocus).focus();
                }
            },
            left: function () {
                var nextFocus = tgo.focusMove({
                    axis : 'x',
                    direction : 'reduce'
                });
                if(tgo.currentFocus != nextFocus && nextFocus.style.display != "none" && nextFocus.style.visibility != "hidden"){
                    tgo.querySelector(nextFocus).focus();
                }
            },
            right: function () {
                var nextFocus = tgo.focusMove({
                    axis : 'x',
                    direction : 'add'
                });
                if(tgo.currentFocus != nextFocus && nextFocus.style.display != "none" && nextFocus.style.visibility != "hidden"){
                    tgo.querySelector(nextFocus).focus();
                }
            },
			ok : function(){

			},
			back :function(){

			},
			beforeKeyEventEnter : function (keyCode) {

            },
			keyLock : false
        },
        keyEventInit: function () {
			document.onkeydown = function (event) {
                if( tgo.$keyEvent.keyLock ){
					return;
				}
                tgo.$keyEvent.beforeKeyEventEnter(event.which);
                switch (event.which){
                    case 1: //up
                    case 38:
                    case 28:
                    case 269:
                    	tgo.$keyEvent.up();
                        event.preventDefault();
                        return false;
                        break;
                    case 2: //down
                    case 40:
                    case 31:
                    case 270:
                        tgo.$keyEvent.down();
                        event.preventDefault();
                        return false;
                        break;
                    case 3: //left
                    case 37:
                    case 29:
                    case 271:
                        tgo.$keyEvent.left();
                        event.preventDefault();
                        return false;
                        break;
                    case 4: //right
                    case 39:
                    case 30:
                    case 272:
                        tgo.$keyEvent.right();
                        event.preventDefault();
                        return false;
                        break;
                    case 8:   //返回
                    case 45:
                    case 46:
                    case 283:
                    case 340:
                        tgo.$keyEvent.back();
                        event.preventDefault();
                        return false;
                        break;
                    case 13://确定
						tgo.querySelector(tgo.currentFocus).ok();
						tgo.$keyEvent.ok();
                        event.preventDefault();
                        return false;
                }
            }
        }
    };

function getOffsetTopByBody (el) {
    var offsetTop = 0;
    var i=0;
    if(typeof el.style.marginTop != 'undefined' && !Function.prototype.bind){
        offsetTop += parseInt(el.style.marginTop);
    }
    while (el.tagName != 'BODY') {
        offsetTop += (el.offsetTop===undefined ? 0 : parseInt(el.offsetTop));
        el = el.offsetParent;
        i++;
    }
    return offsetTop;
}

function getOffsetLeftByBody (el) {
    var offsetLeft = 0;
    if(typeof el.style.marginLeft != 'undefined' && !Function.prototype.bind){
        offsetLeft += parseInt(el.style.marginLeft);
    }
    while (el.tagName != 'BODY') {
        offsetLeft += (el.offsetLeft===undefined ? 0 : parseInt(el.offsetLeft));
        el = el.offsetParent;
    }
    return offsetLeft;
}

function getOffsetWidthByBody(el) {
    var offsetWidth = el.offsetWidth;
    if(!Function.prototype.bind){
        if(el.style.marginLeft){
            offsetWidth -= parseInt(el.style.marginLeft);
        }
        if(el.style.marginRight){
            offsetWidth -= parseInt(el.style.marginRight);
        }
    }
    return offsetWidth;
}

function getOffsetHeightByBody(el) {
    var offsetHeight = el.offsetHeight;
    if(!Function.prototype.bind) {
        if(el.style.marginTop){
            offsetHeight -= parseInt(el.style.marginTop);
        }
        if(el.style.marginBottom){
            offsetHeight -= parseInt(el.style.marginBottom);
        }
    }
    return offsetHeight;
}

/**
 *
 * @param selector
 * @returns {TGOFOCUS}
 */
tgo.querySelector = function (selector) {
	if(!selector){
		throw new Error();
	}
	var ele = [];
	if(typeof selector === 'string'){
		var selectorArr = selector.split(',');
		for(var i = 0; i < selectorArr.length; i++){
			var obj = selectorArr[i];
            if(obj.indexOf('#') == 0){
                ele.push(document.getElementById(obj.substring(1)));
            }else if(obj.indexOf('.') == 0){
                ele = ele.concat(findClass(obj.substring(1)))
            }else{
                ele = document.getElementsByTagName(obj);
            }
		}
	}else{
		if(selector instanceof TGOFOCUS){
			Array.prototype.each.call(selector,function (obj) {
				ele.push(obj);
            })
		}else{
            ele = selector
		}
	}
	var news = new TGOFOCUS(ele,selector);
	return news;
};
tgo.querySelector.preventDefault = function () {
};
/**
 *  元素的所有事件绑定
 */
tgo.$event = [];
/**
 *  元素的所有事件委托
 *  {
 *    element {DOM} //委托dom
 *    children {Array}  [{selector,eventtype,callback}]  //委托的子集
 *  }
 */
tgo.$entrust = [];
    /**
	 *
     */
function TGOFOCUS(ele,selector){
	if(typeof ele != 'undefined' && (ele instanceof Array || ele.toString().indexOf("HTMLCollection") > -1)){
		for(var i = 0; i < ele.length; i++){
			this[i] = ele[i];
		}
        this.length = ele.length;
	}else if(!!ele){
        this[0] = ele;
        this.length = 1;
	}else{
        this.length = 0;
	}
	if(typeof selector === "string"){
		this.selector = selector;
    }
}

TGOFOCUS.prototype = {
	text : function (val) {
		if(val != undefined){
			for(var i = 0; i < this.length; i++){
                this[i].innerText = val;
			}
		}else{
			var arr = [];
            for(var i = 0; i < this.length; i++){
				arr.push(this[i].innerText);
            }
            return arr.join('');
		}
        return this;
    },
	html : function (val) {
        if(val != undefined){
            for(var i = 0; i < this.length; i++){
                this[i].innerHTML = val;
            }
        }else{
            var arr = [];
            for(var i = 0; i < this.length; i++){
                arr.push(this[i].innerHTML);
            }
            return arr.join('');
        }
        return this;
    },
	eq : function (index) {
		if(this[index]){
            var selector = this[index];
            return new TGOFOCUS(selector,selector);
        }else{
            return new TGOFOCUS();
		}
    },
	ok : function (callback) {
		if(typeof callback === "function"){
			for(var i = 0; i < this.length; i++){
				var find = false;
				var _this = this;
				(function (obj) {
                    obj.onclick = function () {
                        tgo.querySelector(obj).ok();
                    };
                })(_this[i]);
				tgo.$event.each(function (obj) {
					if(obj.element === _this[i]){
						find = true;
						obj.ok = callback;
					}
                });
				if(!find){
                    tgo.$event.push({
                        element : this[i],
                        ok : callback
                    });
				}
			}
		}else{
			for(var i = 0; i < tgo.$event.length; i++){
                for(var j = 0; j < this.length; j++){
                	if(this[j] === tgo.$event[i].element){
                		if(typeof tgo.$event[i].ok === 'function'){
                            tgo.$event[i].ok.call(tgo.$event[i].element);
						}
					}
				}
			}
            for(var i = 0; i < tgo.$entrust.length; i ++){
                for(var j = 0; j < this.length; j++){
                    if(tgo.querySelector(this[j]).parents(tgo.$entrust[i].element).length > 0){
                        for(var k = 0; k < tgo.$entrust[i].list.length; k++){
                        	if(tgo.$entrust[i].list[k].childrenSelector.indexOf('.') > -1){
                                var arr = this[j].className.split(" ");
                                for(var l = 0; l < arr.length; l++){
                                    if(tgo.$entrust[i].list[k].childrenSelector.substring(1) === arr[l]){
                                        if(typeof tgo.$entrust[i].list[k].ok === 'function'){
                                            tgo.$entrust[i].list[k].ok.call(this[j]);
                                        }
                                    }
                                }
							}else if(tgo.$entrust[i].list[k].childrenSelector.indexOf('#') > -1){
								if(tgo.$entrust[i].list[k].childrenSelector.substring(1) === this[j].id){
									if(typeof tgo.$entrust[i].list[k].ok === 'function'){
										tgo.$entrust[i].list[k].ok.call(this[j]);
									}
								}
							}else{
                                if(tgo.$entrust[i].list[k].childrenSelector.toLowerCase() === this[j].tagName.toLowerCase()){
                                    if(typeof tgo.$entrust[i].list[k].ok === 'function'){
                                        tgo.$entrust[i].list[k].ok.call(this[j]);
                                    }
                                }
							}

                        }
                    }
                }
            }
		}
        return this;
    },
	css : function (key,val) {
        /**
         * key的转化
         */
        var reverseName = function(str){
            var arr = str.split('');
            var index = -1;
            for(var i = 0; i < arr.length; i++){
                if(index != -1){
                    index = -1;
                    arr[i] = arr[i].toUpperCase();
                }
                if(arr[i] === '-'){
                    if(i != 0){
                        index = i + 1;
                    }
                    arr[i] = '';
                }
            }
            return arr.join('');
        };
		if(val == undefined && typeof key === "string"){
			if(typeof getComputedStyle != "undefined"){
                return getComputedStyle(this[0])[key];
			}else if(typeof this[0].currentStyle != "undefined"){
                return this[0].currentStyle[key];
			}else{
                return this[0].style[key];
			}
		}else if(val == undefined && typeof key === "object"){
			for(var styleName in key){
                for(var i = 0; i < this.length; i++){
                    this[i].style[reverseName(styleName)] = key[styleName];
                }
			}
		}else{
            for(var i = 0; i < this.length; i++){
            	this[i].style[key] = val;
			}
		}
		return this;
    },
	children : function (selector) {
		if(typeof selector === "undefined"){
			var arr = [];
			for(var i = 0; i < this.length; i++){
				for(var j = 0; j < this[i].children.length; j++){
					arr.push(this[i].children[j]);
				}
			}
			return new TGOFOCUS(arr);
		}else if(typeof selector === "string"){
			if(selector.indexOf("#") == 0){//id选择
				var id = selector.substring(1);
				var arr = [];
                for(var i = 0; i < this.length; i++){
                    for(var j = 0; j < this[i].children.length; j++){
                    	if(this[i].children[j].id === id){
                    		arr.push(this[i].children[j]);
                    		break;
						}
                    }
                }
                return new TGOFOCUS(arr);
			}else if(selector.indexOf(".") == 0){
				var className = selector.substring(1);
                var arr = [];
                for(var i = 0; i < this.length; i++){
                    for(var j = 0; j < this[i].children.length; j++){
                    	var classArr = this[i].children[j].className.split(" ");
                    	for (var k = 0; k < classArr.length; k++){
                    		if(classArr[k] === className){
								arr.push(this[i].children[j]);
                    			break;
							}
						}
                    }
                }
                return new TGOFOCUS(arr);
            }else{
                var tagName = selector;
                var arr = [];
                for(var i = 0; i < this.length; i++){
                    for(var j = 0; j < this[i].children.length; j++){
                            if(tagName === this[i].children[j].tagName.toLowerCase()){
                                arr.push(this[i].children[j]);
                                break;
                            }
                    }
                }
                return new TGOFOCUS(arr);
			}
		}
    },
	parent : function () {
		var arr = [];
		for(var i = 0; i < this.length; i++){
			var state = false;
			for(var j = 0; j < arr.length; j++){
				if(arr[j] === this[i].parentNode){
					state = true;
					break;
				}
			}
			if(!state){
				arr.push(this[i].parentNode);
			}
		}
		return new TGOFOCUS(arr);
    },
	index : function () {
		var index = -1;
		for(var i = 0; i < this[0].parentNode.children.length; i++){
			if(this[0].parentNode.children[i] === this[0]){
				index = i;
				break;
			}
		}
        return index;
    },
	append : function (val) {
		if(typeof val === 'string'){
			for(var i = 0; i < this.length; i++){
                var div = document.createElement('div');
                div.innerHTML = val;
				var obj = this[i];
				for(var j = 0; j < div.children.length; j++){
                    obj.appendChild(div.children[j]);
                    j--;
				}
			}
		}
		return this;
    },
	prepend : function (val) {
        if(typeof val === 'string'){
            for(var i = 0; i < this.length; i++){
                var div = document.createElement('div');
                div.innerHTML = val;
                var obj = this[i];
                for(var j = div.children.length - 1; j >= 0; j--){
                    obj.insertBefore(div.children[j],obj.children[0] ? obj.children[0] : null);
                }
            }
        }
        return this;
    },
	focus : function (callback) {
        if(typeof callback === "function"){
            for(var i = 0; i < this.length; i++){
                var find = false;
                var _this = this;
                (function (obj) {
                    obj.onmouseover = function () {
                        tgo.querySelector(obj).focus();
                    };
                })(_this[i]);
                tgo.$event.each(function (obj) {
                    if(obj.element === _this[i]){
                        find = true;
                        obj.focus = callback;
                    }
                });
                if(!find){
                    tgo.$event.push({
                        element : this[i],
                        focus : callback
                    });
                }
            }
        }else{
            for(var i = 0; i < tgo.$event.length; i++){
                for(var j = 0; j < this.length; j++){
                    if(this[j] === tgo.$event[i].element && typeof tgo.$event[i].focus === 'function'){
						tgo.querySelector(tgo.currentFocus).blur();
						tgo.$event[i].focus.call(tgo.$event[i].element);
						tgo.currentFocus = tgo.$event[i].element;
                    }
                }
            }
            for(var i = 0; i < tgo.$entrust.length; i ++){
                for(var j = 0; j < this.length; j++){
                    if(tgo.querySelector(this[j]).parents(tgo.$entrust[i].element).length > 0){
                        for(var k = 0; k < tgo.$entrust[i].list.length; k++){
                            if(tgo.$entrust[i].list[k].childrenSelector.indexOf('.') > -1){
                                var arr = this[j].className.split(" ");
                                for(var l = 0; l < arr.length; l++){
                                    if(tgo.$entrust[i].list[k].childrenSelector.substring(1) === arr[l]){
                                        if(typeof tgo.$entrust[i].list[k].focus === 'function'){
                                            tgo.querySelector(tgo.currentFocus).blur();
                                            tgo.$entrust[i].list[k].focus.call(this[j]);
                                            tgo.currentFocus = this[j];
                                        }
                                    }
                                }
                            }else if(tgo.$entrust[i].list[k].childrenSelector.indexOf('#') > -1){
                                if(tgo.$entrust[i].list[k].childrenSelector.substring(1) === this[j].id){
                                    if(typeof tgo.$entrust[i].list[k].focus === 'function'){
                                        tgo.querySelector(tgo.currentFocus).blur();
                                        tgo.$entrust[i].list[k].focus.call(this[j]);
                                        tgo.currentFocus = this[j];
                                    }
                                }
                            }else{
                                if(tgo.$entrust[i].list[k].childrenSelector.toLowerCase() === this[j].tagName.toLowerCase()){
                                    if(typeof tgo.$entrust[i].list[k].focus === 'function'){
                                        tgo.querySelector(tgo.currentFocus).blur();
                                        tgo.$entrust[i].list[k].focus.call(this[j]);
                                        tgo.currentFocus = this[j];
                                    }
                                }
                            }

                        }
                    }
                }
            }
        }

        return this;
    },
    blur : function (callback) {
        if(typeof callback === "function"){
            for(var i = 0; i < this.length; i++){
                var find = false;
                var _this = this;
                (function (obj) {
                    obj.onmouseout = function () {
                        tgo.querySelector(obj).blur();
                    };
                })(_this[i]);
                tgo.$event.each(function (obj) {
                    if(obj.element === _this[i]){
                        find = true;
                        obj.blur = callback;
                    }
                });
                if(!find){
                    tgo.$event.push({
                        element : this[i],
                        blur : callback
                    });
                }
            }
        }else{
            for(var i = 0; i < tgo.$event.length; i++){
                for(var j = 0; j < this.length; j++){
                    if(this[j] === tgo.$event[i].element){
                    	if(typeof tgo.$event[i].blur === 'function'){
                            tgo.$event[i].blur.call(tgo.$event[i].element);
						}
                    }
                }
            }
            for(var i = 0; i < tgo.$entrust.length; i ++){
                for(var j = 0; j < this.length; j++){
                    if(tgo.querySelector(this[j]).parents(tgo.$entrust[i].element).length > 0){
                        for(var k = 0; k < tgo.$entrust[i].list.length; k++){
                            if(tgo.$entrust[i].list[k].childrenSelector.indexOf('.') > -1){
                                var arr = this[j].className.split(" ");
                                for(var l = 0; l < arr.length; l++){
                                    if(tgo.$entrust[i].list[k].childrenSelector.substring(1) === arr[l]){
                                        if(typeof tgo.$entrust[i].list[k].blur === 'function'){
                                            tgo.$entrust[i].list[k].blur.call(this[j]);
                                        }
                                    }
                                }
                            }else if(tgo.$entrust[i].list[k].childrenSelector.indexOf('#') > -1){
                                if(tgo.$entrust[i].list[k].childrenSelector.substring(1) === this[j].id){
                                    if(typeof tgo.$entrust[i].list[k].blur === 'function'){
                                        tgo.$entrust[i].list[k].blur.call(this[j]);
                                    }
                                }
                            }else{
                                if(tgo.$entrust[i].list[k].childrenSelector.toLowerCase() === this[j].tagName.toLowerCase()){
                                    if(typeof tgo.$entrust[i].list[k].blur === 'function'){
                                        tgo.$entrust[i].list[k].blur.call(this[j]);
                                    }
                                }
                            }

                        }
                    }
                }
            }
        }
        return this;
    },
	parents : function (selector) {
		var parent = this[0].parentNode;
		var type = (function(){
			if(typeof selector === 'string'){
                if(selector.indexOf('.') > -1){//类
                    return '0'
                }else if(selector.indexOf('#') > -1){
                    return '1'
                }else{
                    return '2'
                }
			}else{
				return '4'
			}

		})();
		while(parent.tagName != 'BODY'){
			switch (type){
				case '0': //类
					if(parent.className){
						var arr = parent.className.split(" ");
						for(var i = 0; i < arr.length; i++){
							if(arr[i] === selector.substring(1)){
								return tgo.querySelector(parent);
							}
						}
					}
					break;
                case '1': //id
					if(parent.id === selector.substring(1).replace(/ /g,"")){
                        return tgo.querySelector(parent);
                    }
                    break;
                case '2': //tag
					if(parent.tagName.toLowerCase() === selector.toLowerCase()){
                        return tgo.querySelector(parent);
					}
                    break;
				case '4':
					if(parent === selector){
                        return tgo.querySelector(parent);
					}
					break;
			}
			parent = parent.parentNode;
		}
        return tgo.querySelector([]);
    },
    delegate : function (selector,eventType,callback) {
        for(var i = 0; i < this.length; i++){
            var find = false;
            var _this = this;
            tgo.$entrust.each(function (obj) {
                if(obj.element === _this[i]){
                    find = true;
                    if(!obj.list){
                        obj.list = []
                    };
                    var entrust = {
                        childrenSelector : selector
                    };
                    entrust[eventType] = callback;
                    obj.list.push(entrust);
                }
            });
            if(!find){
				var obj = {
                    element : this[i],
                    list :[]
                };
                var entrust = {
                    childrenSelector : selector
                };
                entrust[eventType] = callback;
                obj.list.push(entrust);
                tgo.$entrust.push(obj);
            }
        }
        return this;
    },
	find : function (selector) {
		var arr = [];
		if(typeof selector === 'string'){
            if(selector.indexOf('.') == 0){
            	Array.prototype.each.call(this,function (obj) {
                    arr = arr.concat(findClass(selector.substring(1),obj))
                });
			}else{
                Array.prototype.each.call(this,function (obj) {
                    arr = arr.concat(findClass(selector.substring(1),obj))
                });
			}
		}
        return new TGOFOCUS(arr)
    }	
};

function findClass(className,parent){
    var arr=[];
    var bodys=document.getElementsByTagName("body")[0];
    if(parent){
        bodys = parent;
	}
    fors(bodys);
    return arr;
    function fors(nodes){
        for(var i=0;i<nodes.children.length;i++){
            var child=nodes.children[i];
            if(typeof child.className != "undefined"){
                var classArr = child.className.split(" ");
                for (var k = 0; k < classArr.length; k++){
                    if(classArr[k] === className ){
                        arr.push(child);
                        break;
                    }
                }
			}
            if(child.children.length>0){
                fors(child);
            }
        }
    }
}

tgo.Router = function (options) {
    if(typeof options === 'object' && options.routes instanceof Array){
        this.routes = options.routes;
    }
    if(typeof options === 'object' && options.parentFile){
        this.parentFile = options.parentFile;
    }
    /**
	 * 获取url的参数
     */
    this.query = {};
    var href = window.location.href;
	if(href.split('?')[1]){
		var params = href.split('?')[1];
		var arr = params.split('&');
		for(var i = 0; i < arr.length; i++){
			var objArr = arr[i].split('=');
			if(objArr[0]){
                this.query[objArr[0]] = objArr[1] || "";
			}
		}
	}
};

tgo.Router.prototype.push = function (route) {
    var url = '';
    switch (typeof route){
		case 'object':
            if(route.name){
                for(var key in this.routes){
                    if(this.routes[key].name === route.name){
                        url = '/' + this.parentFile + this.routes[key].path;
                        var query = (function(href){
                            var query = {};
                            if(href.split('?')[1]){
                                var params = href.split('?')[1];
                                var arr = params.split('&');
                                for(var i = 0; i < arr.length; i++){
                                    var objArr = arr[i].split('=');
                                    if(objArr[0]){
                                        query[objArr[0]] = objArr[1] || "";
                                    }
                                }
                            }
                            return query;
						})(url);
                        for(var param in query){
                            !route.query[param] && (route.query[param] = query[param]) ;
                        }
                        if(typeof route.query === "object"){
                            url += '?';
                            var i = 0;
                            for(var k in route.query){
                                if(i != 0){
                                    url += '&' + k + '=' + route.query[k];
                                }else{
                                    url += k + '=' + route.query[k];
                                }
                                i++;
                            }
                        }
                    }
                }
            }else if(route.path){
                if(route.path.indexOf('/') == 0){ //绝对路径处理
                    url = '/' + this.parentFile +  route.path;
                }else{ //相对路径
                    url = route.path;
                }
                var query = (function(href){
                    var query = {};
                    if(href.split('?')[1]){
                        var params = href.split('?')[1];
                        var arr = params.split('&');
                        for(var i = 0; i < arr.length; i++){
                            var objArr = arr[i].split('=');
                            if(objArr[0]){
                                query[objArr[0]] = objArr[1] || "";
                            }
                        }
                    }
                    return query;
                })(url);
                for(var param in query){
                    !route.query[param] && (route.query[param] = query[param]) ;
                }
                if(typeof route.query === "object"){
                	url = url.split('?')[0];
                    if(url.indexOf('?') == -1){
                        url += '?';
                    }else{
                        url += '&';
                    }
                    var i = 0;
                    for(var k in route.query){
                        if(i != 0){
                            url += '&' + k + '=' + route.query[k];
                        }else{
                            url += k + '=' + route.query[k];
                        }
                        i++;
                    }
                }
            }
			break;
		case 'string':
            if(route.indexOf('/') == 0){ //绝对路径处理
                url = '/' + this.parentFile +  route;
            }else{ //相对路径
                url = route;
            }
            break;
    }
    if(url){
        window.location.href = url;
	}else{
		throw new Error('请指定path或者name');
	}
};

tgo.Router.prototype.replace = function (route) {
    var url = '';
    switch (typeof route){
        case 'object':
            if(route.name){
                for(var key in this.routes){
                    if(this.routes[key].name === route.name){
                        url = '/' + this.parentFile + this.routes[key].path;
                        var query = (function(href){
                            var query = {};
                            if(href.split('?')[1]){
                                var params = href.split('?')[1];
                                var arr = params.split('&');
                                for(var i = 0; i < arr.length; i++){
                                    var objArr = arr[i].split('=');
                                    if(objArr[0]){
                                        query[objArr[0]] = objArr[1] || "";
                                    }
                                }
                            }
                            return query;
                        })(url);
                        for(var param in query){
                            !route.query[param] && (route.query[param] = query[param]) ;
                        }
                        if(typeof route.query === "object"){
                            url += '?';
                            var i = 0;
                            for(var k in route.query){
                                if(i != 0){
                                    url += '&' + k + '=' + route.query[k];
                                }else{
                                    url += k + '=' + route.query[k];
                                }
                                i++;
                            }
                        }
                    }
                }
            }else if(route.path){
                if(route.path.indexOf('/') == 0){ //绝对路径处理
                    url = '/' + this.parentFile +  route.path;
                }else{ //相对路径
                    url = route.path;
                }
                var query = (function(href){
                    var query = {};
                    if(href.split('?')[1]){
                        var params = href.split('?')[1];
                        var arr = params.split('&');
                        for(var i = 0; i < arr.length; i++){
                            var objArr = arr[i].split('=');
                            if(objArr[0]){
                                query[objArr[0]] = objArr[1] || "";
                            }
                        }
                    }
                    return query;
                })(url);
                for(var param in query){
                    !route.query[param] && (route.query[param] = query[param]) ;
                }
                if(typeof route.query === "object"){
                    url = url.split('?')[0];
                    if(url.indexOf('?') == -1){
                        url += '?';
                    }else{
                        url += '&';
                    }
                    var i = 0;
                    for(var k in route.query){
                        if(i != 0){
                            url += '&' + k + '=' + route.query[k];
                        }else{
                            url += k + '=' + route.query[k];
                        }
                        i++;
                    }
                }
            }
            break;
        case 'string':
            if(route.indexOf('/') == 0){ //绝对路径处理
                url = '/' + this.parentFile +  route;
            }else{ //相对路径
                url = route;
            }
            break;
    }
    if(url){
        window.location.replace(url);
    }else{
        throw new Error('请指定path或者name');
    }
};

var Promise = function (mainThread) {
	if(typeof mainThread === 'function'){
        this.mainThread = mainThread;
    }
};

Promise.prototype.then = function (resolve,reject) {
	if(typeof resolve === 'function'){
		try{
            this.mainThread(resolve,reject)
		}catch (e){
			console.log(e);
		}
	}
	return this;
};

if( typeof sysmisc != 'undefined') {
    Base64 = {
        _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
        encode: function (input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;
            input = Base64._utf8_encode(input);
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }
                output = output +
                    this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
                    this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
            }
            return output;
        },
        // public method for decoding
        decode: function (input) {
            var output = "";
            var chr1, chr2, chr3;
            var enc1, enc2, enc3, enc4;
            var i = 0;
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
            while (i < input.length) {
                enc1 = this._keyStr.indexOf(input.charAt(i++));
                enc2 = this._keyStr.indexOf(input.charAt(i++));
                enc3 = this._keyStr.indexOf(input.charAt(i++));
                enc4 = this._keyStr.indexOf(input.charAt(i++));
                chr1 = (enc1 << 2) | (enc2 >> 4);
                chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                chr3 = ((enc3 & 3) << 6) | enc4;
                output = output + String.fromCharCode(chr1);
                if (enc3 != 64)output = output + String.fromCharCode(chr2);
                if (enc4 != 64)output = output + String.fromCharCode(chr3);
            }
            output = Base64._utf8_decode(output);
            return output;
        },
        _utf8_encode: function (string) {
            string = string.replace(/\r\n/g, "\n");
            var utftext = "";
            for (var n = 0; n < string.length; n++) {
                var c = string.charCodeAt(n);
                if (c < 128) {
                    utftext += String.fromCharCode(c);
                } else if ((c > 127) && (c < 2048)) {
                    utftext += String.fromCharCode((c >> 6) | 192);
                    utftext += String.fromCharCode((c & 63) | 128);
                } else {
                    utftext += String.fromCharCode((c >> 12) | 224);
                    utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                    utftext += String.fromCharCode((c & 63) | 128);
                }
            }
            return utftext;
        },
        _utf8_decode: function (utftext) {
            var string = "";
            var i = 0;
            var c = 0, c1 = 0, c2 = 0;
            while (i < utftext.length) {
                c = utftext.charCodeAt(i);
                if (c < 128) {
                    string += String.fromCharCode(c);
                    i++;
                } else if ((c > 191) && (c < 224)) {
                    c2 = utftext.charCodeAt(i + 1);
                    string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                    i += 2;
                } else {
                    c2 = utftext.charCodeAt(i + 1);
                    c3 = utftext.charCodeAt(i + 2);
                    string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                    i += 3;
                }
            }
            return string;
        }
    };
    window.Base64 = Base64;
}
