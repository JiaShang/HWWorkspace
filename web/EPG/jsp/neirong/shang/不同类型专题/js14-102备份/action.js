
function search( retUrl ){
	if( iPanel.mediaType == 'P30' || iPanel.mediaType == 'GW' ){
		iPanel.IOControlWrite("startOtherApk","com.ipanel.chongqing_ipanelforhw,com.ipanel.join.cq.vod.searchpage.SearchPage");
		return;
	}
	var searchUrl = iPanel.mediaType == 'P60' ? 'http://aoh5.cqccn.com/h5_vod/allSearch/index.html' : '/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp';
	window.location.href = that.linkto(searchUrl, retUrl);
}

function selectAct() {
	if (that.focusable.length <= 0) return;
	var blocked = that.blocked;
	var focus = that.focusable[blocked].focus;
	var typeId = that.focusable[blocked].typeId;
	var item = that.focusable[blocked].items[focus];
	item.typeId = typeId;
	that.call('selectItem', item);
}

/*function doBack() {
	
}
*/



function goHome() {
	if (isP30 || isGW) {
		iPanel.eventFrame.exitToHomePage();
	} else if( isHD30 ) {
		window.location.href = iPanel.eventFrame.portal_url;
	} else if( isP60 ) {
		sysmisc.finish();
	} 
}

function goSearch(  ){
	if( isP30 || isGW ){
		iPanel.IOControlWrite("startOtherApk","com.ipanel.chongqing_ipanelforhw,com.ipanel.join.cq.vod.searchpage.SearchPage");
		return;
	}
	var searchUrl = isP60 ? 'http://aoh5.cqccn.com/h5_vod/allSearch/index.html' : '/EPG/jsp/defaultHD/en/userInfo/searchIndex.jsp';
	window.location.href = searchUrl, retUrl;
}

function doMenu() {		
	if(videoFlag){
		exit();	
	}
	if(isP60){
		var pathSave = sysmisc.path_back();
		if (pathSave && pathSave.indexOf("http") === 0) {
			window.location.href = pathSave;
		} else {
			sysmisc.finish();
		}
	}else if(iPanel.eventFrame.systemId == 1){
        iPanel.eventFrame.exitToHomePage();
    }else{
        iPanel.mainFrame.location.href = iPanel.eventFrame.portal_url;
    }
}

function startApk(){
	if (isP30){
		iPanel.IOControlWrite("startAPK", linkAndr);
	}else if(isP60){
		sysmisc.runCommand("am start -n " + item.linkP60Apk );	
	}else if(isWG){
		iPanelGatewayHelper.launchApk(包名,类名, 参数);
	}
}

function strStart(str,subStr){
	if (str == null || str == "" || str.length == 0 || subStr.length > str.length) return false;
        return this.substr(0, subStr.length) === str;
	
}
function strEnd(str,subStr){
	if (str == null || str == "" || str.length == 0 || subStr.length > str.length) return false;
        return str.substring(str.length - subStr.length) === subStr;
	
}

///////////////////////////////////////////////////////////
function iDebug(_str){
	if(navigator.appName.indexOf("iPanel")>-1){
		iPanel.debug(_str);
	}else if(navigator.appName.indexOf("Netscape")>-1 || navigator.appName.indexOf("Google")>-1){
		console.log(_str);
	}else if(navigator.appName.indexOf("Opera")>-1){
		opera.postError(_str);
	}
}


function initScroll(dataSize,listSize,listPage){
	if(scrollFlag && dataSize>listSize){
		$("scrollLower").style.visibility= "visible";
		$("scrollUpper").style.visibility= "visible";
		if(scrollWay!="undefined"&&scrollWay==1){
			var barLength=$("lists").offsetHeight-10;
			var barLeft=$("listName0").offsetLeft+$("listName0").offsetWidth+20;
			var scrollHeight=barLength/dataSize.toFixed(2);
		}else{
			var barLength=$("lists").offsetHeight-10;
			var barLeft=$("listName0").offsetLeft+$("listName0").offsetWidth+leftSpace*(row-1)+20;
			var scrollHeight=barLength/listPage.toFixed(2);
		}
		$("scrollLower").style.height=barLength+"px";
		$("scrollLower").style.left=barLeft+"px";
		$("scrollUpper").style.height=scrollHeight+"px";
	}else{
		$("scrollLower").style.visibility= "hidden";
		$("scrollUpper").style.visibility= "hidden";
	}
}
function scrollChange(dataSize,position,currPage,listPage){
	var lowerBarLength=$("scrollLower").offsetHeight;
	var upperBarLength=$("scrollUpper").offsetHeight;
	if(scrollWay!="undefined"&&scrollWay==1){
		var percent = Number( (position/dataSize).toFixed(2));
		$("scrollUpper").style.top=percent*lowerBarLength+"px";
	}else{
		var percent = Number(((currPage-1)/listPage).toFixed(2));
		$("scrollUpper").style.top=percent*lowerBarLength+"px";
	}
	
	
}
/////////////////////////////////////////////////////////////////////

function doFullPlay(pos){
	vodId=listData[pos].id;
	vodName=listData[pos].name;
	fullScreen(vodId,vodName);
}
function doSmallPlay(pos){
	vodId=listData[pos].id;
	vodName=listData[pos].name;
	var left=videoPos[0];
	var top=videoPos[1];
	var width=videoPos[2];
	var height=videoPos[3];
	smallScreen(vodId,vodName,left,top,width,height);
}



function sendVote(repeat,voteCount,contentNum){

	
}

	
		
		
		
		
		
		
		
		
		