var url = window.location.href;

var isP60 = typeof sysmisc != "undefined"?true:false;
var isP30 = iPanel.eventFrame.systemId == 1?true:false;
var isHD30 = typeof iPanel.eventFrame.systemId == 'undefined'?true:false;
var isHD30Adv =typeof navigator != "undefined" && typeof navigator.userAgent == 'string' && navigator.userAgent.indexOf('3.0 Advanced') > 0;
var isWG = iPanel.eventFrame.systemId == 2?true:false;


var isSearch = url.indexOf('searchIndex.jsp') > 0;
var isKorean = url.indexOf('searchIndex.jsp') > 0;
var isWestern = url.indexOf('searchIndex.jsp') > 0;

var cardId = typeof CA != "undefined" ? CA.card.serialNumber : (typeof sysmisc != "undefined" ? sysmisc.getChipId():"9950000002197670");


var huawei_epg_url = typeof iPanel!="undefined"&&iPanel.eventFrame?iPanel.eventFrame.pre_epg_url:
sysmisc.getEnv('epg_address','');  

var isEpgUrl = url.startWith("/EPG/jsp")  
var isEPGflag = url.indexOf('EPGflag') > 0; 


function checkIPANEL30(){
	var userAgent = navigator.userAgent.toLowerCase();
	var flag = false;	
	if(userAgent.indexOf("ipanel") != -1 && userAgent.indexOf("advanced") == -1){//ipanel3.0
		flag = true;
	}
	return flag;
}

/////////////////////////////////////
if( isP60) {
	p60_path_save();
	url = 'http://aoh5.cqccn.com/h5_vod/vod/detail.html?vod_id=' + id + "&typeId=" + typeId;
} else if (isHD30 || isP30 || isGW){
	var detailPage = 'vod/tv_detail.jsp';
	if (isKorean){ 
		detailPage = 'hjzq/hj_tvDetail.jsp';
	}else if (isWestern){ 
		detailPage = 'western/eu_tvDetail.jsp';
	}
	url = EPGUrl + "/EPG/jsp/defaultHD/en/hddb/" + detailPage+"?vodId="+id+"&typeId=" + typeId;
}

//////////////////////////////////////////////////////
function iDebug(_str){
	if(navigator.appName.indexOf("iPanel")>-1){
		iPanel.debug(_str);
	}else if(navigator.appName.indexOf("Netscape")>-1 || navigator.appName.indexOf("Google")>-1){
		console.log(_str);
	}else if(navigator.appName.indexOf("Opera")>-1){
		opera.postError(_str);
	}
}












////////////////////////////////////////////////////////
 































