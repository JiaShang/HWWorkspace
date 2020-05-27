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

