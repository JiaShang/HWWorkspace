

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
	
	this.postData = null;	
	
	this.childnodes = null;
	
}

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

AJAX_OBJ.prototype.getInstance = function(){
	for (var i = 0; i < objPool.length; i ++){
		if (objPool[i].readyState == 0 || objPool[i].readyState == 4){
			return objPool[i];
		}
	}
	objPool[objPool.length] = this.createXMLHttpRequest();
	return objPool[objPool.length - 1];
}

AJAX_OBJ.prototype.requestData = function(requestMethod,sendData){
	this.xmlHttp = this.getInstance();
	var request_url = this.url + this.urlParameters;
	var self = this;
	if (request_url.indexOf("?") > -1){
		request_url = request_url + "&randnum=" + Math.random();
	}
	else{
		request_url = request_url + "?randnum=" + Math.random();
	}

	this.xmlHttp.onreadystatechange = function(){
		self.stateChanged(requestMethod);
	};
	requestMethod = requestMethod || "GET";
	if(typeof(sendData) != "undefined") this.postData = sendData;
	
	this.xmlHttp.open(requestMethod, request_url, true);
	this.xmlHttp.send(this.postData);
	if(this.timer > 0){
		self.timeHandler = setTimeout(function(){
			self.checkAjaxTimeout();
		},self.timer);
	}
}

AJAX_OBJ.prototype.stateChanged = function(requestMethod){
	if(this.xmlHttp.readyState == 4){
		if(this.timer>0){
			clearTimeout(this.timeHandler);
		}
		if(this.xmlHttp.status == 200 || this.xmlHttp.status == 304 ){
			this.callback(this.xmlHttp);
		}
		else{
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

AJAX_OBJ.prototype.checkAjaxTimeout = function(){	
	if(this.xmlHttp.readyState != 4){
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
		if(typeof _sendData=='undefined'){
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
		}else{
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
		if(typeof _sendData=='undefined'){
			var ajaxObj = new AJAX_OBJ(_url,function(_xmlHttp){
				iDebug("[config.js] transAjax-success-get-_xmlHttp.responseText===" + _xmlHttp.responseText);
				if (!_xmlHttp.responseText) return;
				
				var res = eval("("+_xmlHttp.responseText+")");
				_callBak&&_callBak(res,0);
			},function(_xmlHttp){
				_callBak&&_callBak(_xmlHttp,1);
				iDebug("[config.js  transAjax] fail !");
			});
			ajaxObj.requestData();
		}else{
			var ajaxObj = new AJAX_OBJ(_url,function(_xmlHttp){
				iDebug("[config.js] transAjax-success-post-_xmlHttp.responseText===" + _xmlHttp.responseText);
				if (!_xmlHttp.responseText) return;
				
				var res = eval("("+_xmlHttp.responseText+")");
				_callBak&&_callBak(res,0);
			},function(_xmlHttp){
				_callBak&&_callBak(_xmlHttp,1);
				iDebug("[config.js  transAjax] fail !");
			});
			ajaxObj.urlParameters = _sendData;
			ajaxObj.requestData("POST");	
		}
	}
}