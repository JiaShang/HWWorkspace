var isP60 = typeof sysmisc != 'undefined';
var HD30 = typeof iPanel != 'undefined' && typeof iPanel.eventFrame.systemId == 'undefined';
var isGW = typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 2;
var isP30 = typeof iPanel != 'undefined' && iPanel.eventFrame.systemId == 1;

// focusUp();      //焦点向上移动；
// focusDown(); //焦点向下移动；
// pageUp();      //列表向前鄱页；
// pageDown(); //列表向后翻页；
// clearList();     //清除列表信息
// changeList(__num); //焦点移动

// var scrollFlag = 1; //0：不显示滚动条，显示滚动条
// var scrollWay = 2;  //1：按数据个数滑动，按数据页数滑动
// var scrollData = 2; //1：按数据个数显示，按数据页数显示

initListData()末尾：
initScroll(listBox.dataSize,1,listBox.listPage);

move()末尾：
scrollChange(listBox.dataSize,listBox.position,listBox.currPage,listBox.listPage);

<div id="scrollLower" style="position: absolute; left: 1200px; top: 175px; width: 5px; background-color: #959ea5; visibility: hidden; height: 448px;">
	<div id="scrollUpper" style="position: absolute; top: 0px; height: 100px;width: 25px;left: -12px; background-color: #fbba54;z-index: 1;color: #fffbfb;font-size: 22px;"></div>
</div>
//##################截取名称#######################
初始化数据init中：
for( var j = 0; j < cursor.focusable[i].items.length; j ++){
	var name = cursor.focusable[i].items[j].name;
	var star = name.indexOf("：");  //不存在返回-1
	star++;
	var end = name.indexOf("（") <=0 ? name.length : name.indexOf("（");
	cursor.focusable[i].items[j].name = name.substring(star,end);  //substring取前不取后
}



function initScroll(dataSize,pageCount,listPage){  //总数据长度，每页数据个数，总数据页数
	if(scrollFlag && dataSize>pageCount){
		$("scrollLower").style.visibility= "visible";
		$("scrollUpper").style.visibility= "visible";
		if (scrollData == 1){
			if(dataSize >= 10){
				$("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />"+dataSize;
			}else{
				$("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />&nbsp;"+dataSize;
			}
		}else if (scrollData == 2){
			if(listPage >= 10){
				$("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />"+listPage;
			}else{
				$("scrollUpper").innerHTML = "&nbsp;1<br />&nbsp;/<br />&nbsp;"+listPage;
			}
		}
		// if(scrollWay=="undefined" || scrollWay==1){
		// 	var barLength=$("lists").offsetHeight-10;
		// 	var barLeft=$("listName0").offsetLeft+$("listName0").offsetWidth+20;
		// 	var scrollHeight=barLength/dataSize.toFixed(2);
		// }else{
		// 	var barLength=$("lists").offsetHeight-10;
		// 	var barLeft=$("listName0").offsetLeft+$("listName0").offsetWidth+leftSpace*(row-1)+20;
		// 	var scrollHeight=barLength/listPage.toFixed(2);
		// }
		// $("scrollLower").style.height=barLength+"px";
		// $("scrollLower").style.left=barLeft+"px";
		// $("scrollUpper").style.height=scrollHeight+"px";
	}else{
		$("scrollLower").style.visibility= "hidden";
		$("scrollUpper").style.visibility= "hidden";
	}
}
function scrollChange(dataSize,position,currPage,listPage){  //总数据长度，数据焦点，当前页数，数据总页数
	var lowerBarLength=$("scrollLower").offsetHeight;
	var upperBarLength=$("scrollUpper").offsetHeight;
	if(scrollWay=="undefined" || scrollWay==1){
		var percent = Number( (position/(dataSize-1)).toFixed(2));
		$("scrollUpper").style.top=percent*(lowerBarLength-upperBarLength)+"px";
	}else{
		var percent = Number(((currPage-1)/(listPage-1)).toFixed(2));
		$("scrollUpper").style.top=percent*(lowerBarLength-upperBarLength)+"px";
	}
	if (scrollData == 1){
		if(listBox.dataSize >= 10){
			if(listBox.position+1 >= 10){
				$("scrollUpper").innerHTML = (position+1)+"<br />&nbsp;/<br />"+dataSize;
			}else{
				$("scrollUpper").innerHTML = "&nbsp;"+(position+1)+"<br />&nbsp;/<br />"+dataSize;
			}
		}else {
			$("scrollUpper").innerHTML = "&nbsp;"+(position+1)+"<br />&nbsp;/<br />&nbsp;"+dataSize;
		}
	}else if (scrollData == 2){
		if(listBox.listPage >= 10){
			if(listBox.currPage+1 >= 10){
				$("scrollUpper").innerHTML = currPage+"<br />&nbsp;/<br />"+listPage;
			}else{
				$("scrollUpper").innerHTML = "&nbsp;"+currPage+"<br />&nbsp;/<br />"+listPage;
			}
		}else {
			$("scrollUpper").innerHTML = "&nbsp;"+currPage+"<br />&nbsp;/<br />&nbsp;"+listPage;
		}
	}
}


// #####################################################

//统计页面访问量
var cardId = (typeof CA!="undefined" && typeof CA.card!="undefined" && typeof CA.card.serialNumber!="undefined")?CA.card.serialNumber:"1234567890";  //获取CA卡号
function visitNum(id){
	var url="http://192.168.18.249:8080/voteNew/external/clickCount.ipanel?icid="+cardId+"&classifyID="+id+"&content=1";
	ajax(url, function(rst){
			if( rst != "" && rst != 'undefined'&& rst.result ) {
				//tooltip( decodeURIComponent('统计成功') );  //统计成功
				return;
			}else{
				tooltip( decodeURIComponent('统计失败') );  //统计失败
			}
		},
		{
			fail:function( meg )
			{
				tooltip( decodeURIComponent("fail") );
				return;
			}
		}
	);
}

//获取投票结果
function getVoteResult(id){
	var url="http://192.168.18.249:8989/VoteStatistics/getVoteInfo?classifyID="+cursor.voteId;
	ajax(url, function(rst){
		if( rst != "" && rst != 'undefined') {
			//tooltip( decodeURIComponent('获取投票结果成功') );  //成功
			for (var i = 0;i < cursor.focusable[0].items.length ;i++) {
				for (var j = 0;j < rst.length ;j++){
					if(cursor.focusable[0].items[i].name == rst[j].name){
						cursor.focusable[0].items[i].voteResult = rst[j].num;
						break;
					}
				}
			}
			return true;
		}else{
			// tooltip( decodeURIComponent('获取投票结果失败') );  //失败
			return false;
		}
		},
		{
			fail:function( meg )
			{
				// tooltip( decodeURIComponent("fail") );
				return false;
			}
		}
	);
}
////寻找专题  栏目名称与专题名称相同，或者栏目下连续剧与专题名称相同
cursor.initialize({
    data: [<%
        String html = "";
for ( int i = 0; i < infos.size(); i++) {
    ColumnInfo info = infos.get(i);
    inner.special = true;
    //Result result = inner.getVodList( info.getTypeId(), info.getStation(),info.getLength() );
    Result result = inner.getTypeList( info.getTypeId(), info.getStation(),info.getLength() );
    html += inner.resultToString(result);
    if( i + 1 < infos.size() ) html += ",\n";
}
out.write(html);
%>],

lazyShow    :   function(){
	var blocked = cursor.listBlocked;
	var focus = cursor.focusable[blocked].focus;
	if( focusArea == 1 ) {
		// var text = cursor.focusable[blocked].items[focus].name;
		var id = String(listBox.focusPos);
		var text = $('listName' + id).innerText;
		if ( text.indexOf("...") != -1 ) {
			$('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + cursor.focusable[blocked].items[focus].name + '</marquee>';
		}
		// cursor.calcStringPixels(text, 24, function(width){
		//     if( width <= 440 ) return;
		//     $('listName' + id).innerHTML = '<marquee class="marquee" scrollamount="8">' + text + '</marquee>';
		// });
	};
}