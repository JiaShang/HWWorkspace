/*
 * @url: request url
 * @callback: callback function
 * @errorhandle: error handle function
 * @timer: request interval
 * @retrial: error request times(value=-1:infinity)
 */

var objPool = [];

function AJAX_OBJ(url, callback, errorhandle, timer, retrial){
	this.xmlHttp = null;
	this.num = 0;
	this.url = url;
	this.urlParameters = "";
	this.callback = callback;
	this.errorhandle = errorhandle;

	this.timer = timer || 5000;
	this.timeout = -1;
	this.retrial = retrial || 1;
	this.requestInterval = 1000;
	
	this.postData = null;	//要发送的POST数据
	
	this.childnodes = null;
	
}
/*创建 XMLHttpRequest 对象，IE 浏览器使用 ActiveXObject，而其他的浏览器使用名为 XMLHttpRequest 的 JavaScript 内建对象。*/
AJAX_OBJ.prototype.createXMLHttpRequest = function(){
	var xmlh = null;
	if(window.ActiveXObject){
		xmlh = new ActiveXObject("Microsoft.XMLHttp");
	}
	else if(window.XMLHttpRequest){
		xmlh = new XMLHttpRequest();
	}
	return xmlh;
}
/*获取一个XMLHttpRequest 对象*/
AJAX_OBJ.prototype.getInstance = function(){
	for (var i = 0; i < objPool.length; i ++){
		if (objPool[i].readyState == 0 || objPool[i].readyState == 4){// 返回已有的readyState属性值为0或者4的XMLHttpRequest对象，readyState=0，请求未初始化（在调用 open() 之前）；readyState=4，请求已完成（可以访问服务器响应并使用它）
			return objPool[i];
		}
	}
	objPool[objPool.length] = this.createXMLHttpRequest();//如果已有的XMLHttpRequest对象都属于非空闲状态，则创建返回一个新的XMLHttpRequest对象
	return objPool[objPool.length - 1];
}
/*请求数据*/
AJAX_OBJ.prototype.requestData = function(requestMethod,sendData){
	this.xmlHttp = this.getInstance();//获取一个XMLHttpRequest 对象
	var request_url = this.url + this.urlParameters;//服务器端脚本的 URL
	var self = this;
	if (request_url.indexOf("?") > -1){
		request_url = request_url + "&randnum=" + Math.random();//如果XMLHttpRequest提交的URL与历史一样则使用缓存，地址后面加上随机数可以避免使用缓存，取到最新的数据
	}
	else{
		request_url = request_url + "?randnum=" + Math.random();
	}

	this.xmlHttp.onreadystatechange = function(){//每当 readyState 改变时，onreadystatechange 函数就会被执行。
		self.stateChanged(requestMethod);
	};
	requestMethod = requestMethod || "GET";
	if(typeof(sendData) != "undefined") this.postData = sendData;
	//this.xmlHttp.setRequestHeader ("Content-Type","text/plain;charset=UTF-8");
	this.xmlHttp.open(requestMethod, request_url, true);//向服务器发送一个请求
	this.xmlHttp.send(this.postData);
	if(this.timer > 0){
		self.timeHandler = setTimeout(function(){
			self.checkAjaxTimeout();
		},self.timer);
	}
}
/*每当 readyState 改变时,执行此方法*/
AJAX_OBJ.prototype.stateChanged = function(requestMethod){
	if(this.xmlHttp.readyState == 4){//请求已完成
		if(this.timer>0){
			clearTimeout(this.timeHandler);//如果响应了就取消超时定时器
		}
		if(this.xmlHttp.status == 200 || this.xmlHttp.status == 304 ){//请求成功时，调用回到函数callback,将请求到的对象作为函数参数
			this.callback(this.xmlHttp);
		}
		else{//error handling 请求失败时，再次请求
			this.num++;
			var self = this;
			if(this.retrial != -1 && this.num < this.retrial){
				clearTimeout(this.timeout);
				this.timeout = setTimeout(function(){self.requestData(requestMethod);}, this.requestInterval);
			}
			else if(this.retrial == -1){//
				clearTimeout(this.timeout);
				this.timeout = setTimeout(function(){self.requestData(requestMethod);}, this.requestInterval);
			}else{
				this.errorhandle(this.xmlHttp.status);	
			}
		}
	}
}
//判断是否超时
AJAX_OBJ.prototype.checkAjaxTimeout = function(){	
	if(this.xmlHttp.readyState != 4){//请求已完成
		this.xmlHttp.abort();
		this.num++;
		var self = this;
		if(this.retrial != -1 && this.num < this.retrial){
			clearTimeout(this.timeout);
			this.timeout = setTimeout(function(){self.requestData();}, this.requestInterval);
		}else if(this.retrial == -1){//
			clearTimeout(this.timeout);
			this.timeout = setTimeout(function(){self.requestData();}, this.requestInterval);
		}else{
			this.errorhandle(this.xmlHttp.status);	
		}
	}
}	
/*向请求地址增加参数*/
AJAX_OBJ.prototype.addParameter = function(params){
	if(params.length > 0){
		this.urlParameters = "";
		for(var i = 0; i < params.length; i++){
			var curr_param = params[i];
			if(i == 0) this.urlParameters += "?" + curr_param.name + "=" + curr_param.value;
			else this.urlParameters += "&" + curr_param.name + "=" + curr_param.value;
		}
	}
}
/*获取返回来的xml数据的某个节点*/
AJAX_OBJ.prototype.getNodes = function(param, index){
	if(typeof(this.xmlHttp.responseXML) != "undefined"){
		if(typeof(param) != "undefined" && typeof(index) != "undefined"){
			this.childnodes = this.xmlHttp.responseXML.getElementsByTagName(param)[index].childNodes;
			return this.childnodes;
		}
		else if(typeof(param) != "undefined"){
			this.childnodes = this.xmlHttp.responseXML.getElementsByTagName(param);
			return this.childnodes;
		}
		else{
			return null;
		}
	}
	else{
		return null;
	}
}

function transAjax(_url,_callBak,_sendData) {
	iDebug("[config.js] transAjax url="+_url);
	iDebug("[config.js] transAjax isP60="+isP60+"---typeof _sendData:"+(typeof _sendData));
	if(isP60){//P60盒子
		if(typeof _sendData=='undefined'){//get请求
			var cookie = '[{"key": "cookie", "value":"JSESSIONID=' + sysmisc.getEnv('sessionid', '') + '"}]';
			iDebug("[config.js] transAjax--get-cookie===" + cookie);
			bridge.ajax('get', _url, 'text/xml', cookie, '', function(resp) {
				iDebug("[config.js] transAjax-success-resp===" + resp);
				var data = eval('('+resp+')');
				_callBak&&_callBak(data,0);
			}, function(resp) {
				var data = eval('('+resp+')');
				_callBak&&_callBak(data,1);
				iDebug("[config.js]--transAjax--isP60--getfail");
			});
		}else{//post请求
			var cookie = '[{"key": "cookie", "value":"JSESSIONID=' + sysmisc.getEnv('sessionid', '') + '"}]';
			iDebug("[config.js] transAjax--post--cookie===" + cookie);
			iDebug("[config.js] transAjax _sendData="+_sendData);
			bridge.ajax('post', _url, 'text/xml', cookie, _sendData, function(resp) {
				iDebug("[config.js] transAjax-success-resp===" + resp);
				var data = eval('('+resp+')');
				_callBak&&_callBak(data,0);
			}, function(resp) {
				var data = eval('('+resp+')');
				_callBak&&_callBak(data,1);
				iDebug("[config.js]--transAjax--isP60--postfail");
			});	
		}
	}else{
		if(typeof _sendData=='undefined'){//get请求
			var ajaxObj = new AJAX_OBJ(_url,function(_xmlHttp){
				iDebug("[config.js] transAjax-success-get-_xmlHttp.responseText===" + _xmlHttp.responseText);
				if (!_xmlHttp.responseText) return;
				//先判断是否是鉴权失败！
				var res = eval("("+_xmlHttp.responseText+")");
				_callBak&&_callBak(res,0);
			},function(_xmlHttp){
				_callBak&&_callBak(_xmlHttp,1);
				iDebug("[config.js  transAjax] fail !");
			});
			ajaxObj.requestData();
		}else{//post请求
			var ajaxObj = new AJAX_OBJ(_url,function(_xmlHttp){
				iDebug("[config.js] transAjax-success-post-_xmlHttp.responseText===" + _xmlHttp.responseText);
				if (!_xmlHttp.responseText) return;
				//先判断是否是鉴权失败！
				var res = eval("("+_xmlHttp.responseText+")");
				_callBak&&_callBak(res,0);
			},function(_xmlHttp){
				_callBak&&_callBak(_xmlHttp,1);
				iDebug("[config.js  transAjax] fail !");
			});
			ajaxObj.urlParameters = _sendData;//post参数单独设置
			ajaxObj.requestData("POST");	
		}
	}
}