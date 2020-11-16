var isTest = 0;	// 0：接口数据,1:本地假数据
var DEBUG = 1;	// 0：公网地址,1：机顶盒测试网地址，2：正式环境
var mainLabel = -1;	//列表栏目id
var HOST = ["http://125.62.26.203:90","http://192.168.19.103:90","http://tvapi.smartcommunity.cqccn.com:90"][DEBUG];

var isP60 = typeof sysmisc != "undefined"?true:false;//是否是P60盒子
iDebug("[playCase config.js] isP60="+isP60);
var cardId = typeof CA != "undefined" ? CA.card.serialNumber : (typeof sysmisc != "undefined" ? sysmisc.getChipId():"8230004478516914");
iDebug("playCase config.js cardId="+cardId);
var huawei_epg_url = typeof iPanel!="undefined"&&iPanel.eventFrame?iPanel.eventFrame.pre_epg_url:"http://192.168.251:8981";
var areaCode = getGlobalVar("GW_areaCode")||"";
var streetCode = getGlobalVar("GW_areaCode")||"";
var comCode = getGlobalVar("GW_comCode")||"";
var vilCode = getGlobalVar("GW_vilCode")||"";

// 获取地址信息
var addressUrl = [HOST+"/aic/tv/home/address/v3?boxCard="+cardId,"data/addressInfo.js"][isTest];
// 三级栏目和列表接口boxCard-智能卡卡号,areaCode-区县编码,streetCode-街道编码,comCode-社区编码,vilCode-小区编码,columnId-二级栏目id
var getListUrl = [HOST + "/aic/tv/home/third/v3?boxCard="+cardId+"&areaCode={1}&streetCode={2}&comCode={3}&vilCode={4}&columnId={5}","data/list.js"][isTest];
// 华为鉴权播放地址，typeId:栏目id,progId:影片id,playType:播放类型（1为电影;11为剧集）,idType:影片ID类型,如是外部ID需要把值设成FSN
var getPlayUrl = [huawei_epg_url + "/defaultHD/en/go_authorization.jsp?typeId={1}&progId={2}&playType=1&contentType=0&business=1","data/authorization.js"][isTest];

// 获取地址信息
function getAddressInfo(_callBak) {
	if(isTest){//本地数据
		var url = addressUrl + "?"+new Date().getTime();
	}else{
		var url = addressUrl;
	}
	iDebug("[playCase config.js] getAddressInfo url="+url);
	if(isP60){//P60盒子
		if(epgAddress != ''){
			var cookie = '[{"key": "cookie", "value":"JSESSIONID=' + sysmisc.getEnv('sessionid', '') + '"}]';
	        iDebug("[playCase config.js] getAddressInfo-success-cookie===" + cookie);
    		bridge.ajax('get', url, 'text/xml', cookie, '', function(resp) {
	            iDebug("[playCase config.js] getAddressInfo-success-resp===" + resp);
	            addressResult(resp);
				_callBak&&_callBak();
	        }, function(resp) {
				_callBak&&_callBak();
	            iDebug("[playCase config.js]--getAddressInfo--isP60--fail");
	        });
		}
	}else{
		var ajaxObj = new ajaxClass(url,function(_xmlHttp){
			addressResult(_xmlHttp.responseText);
			_callBak&&_callBak();
		},function(_xmlHttp){
			_callBak&&_callBak();
			iDebug("[playCase config.js] getAddressInfo fail !");
		});
		ajaxObj.requestData();
	}
}

function addressResult(jsonStr) {
	var jsonData = eval('('+jsonStr+')');
	if(jsonData && jsonData.code == 0){
		var userData = jsonData.data;
		areaCode = userData.areaCode || "";
		streetCode = userData.streetCode || "";
		comCode = userData.comCode || "";
		vilCode = userData.vilCode || "";
		iDebug("[playCase config.js] areaCode="+areaCode+" streetCode="+streetCode+" comCode="+comCode+" vilCode="+vilCode);
		setGlobalVar("GW_areaCode",areaCode);
		setGlobalVar("GW_streetCode",streetCode);
		setGlobalVar("GW_comCode",comCode);
		setGlobalVar("GW_vilCode",vilCode);
	}
}