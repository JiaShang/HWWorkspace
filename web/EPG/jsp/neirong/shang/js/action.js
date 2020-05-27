
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
	//如果是来点盒子，或者家庭网关，使用此方法退出到首页
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
	if(isP60){
		var pathSave = sysmisc.path_back();
		if (pathSave && pathSave.indexOf("http") === 0) {
			window.location.href = pathSave;
		} else {
			sysmisc.finish();//关闭浏览器
		}
	}else if(iPanel.eventFrame.systemId == 1){
        iPanel.eventFrame.exitToHomePage();
    }else{
        //原代码返回首页
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

////////////////////////////投票///////////////////////////////

		
		
		
		
		
		
		
		
		
		