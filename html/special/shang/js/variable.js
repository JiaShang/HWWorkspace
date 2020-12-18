var url = window.location.href;
var localIp = "";
var listBox = null;
var listData = [];      //自定义listName
var titleBox = null;
var titleData = [];     //自定义titleName
var focusPicData = [];  //自定义焦点Focus
var titlePicData = [];  //自定义titleFocus
var listPosters = [];   //自定义listImg
var titlePosters = [];  //自定义titleImg

var focusArea = 0;
var picPrefix = ["20201113",0];
var bgImg = "images/J"+picPrefix+"Bg.png";
var act = 0;  //有无子栏目
var picFlag = [1,"7"]; //0：自定义 1:绑在一级栏目下 2:绑在子栏目的一条视频下 3：绑在子栏目的多条视频下
var palyFlag = 0;
var testFlag = 0;
//focusPic-left  focusPic-top  left间隔个数  top间隔个数
//  0                  1            2          3
var listGap = [0,0,0,0,0,0];
//titlePic-left    titlePic-top   left间隔个数  top间隔个数
//  0                  1               2           3
var titleGap = [0,0,0,0,0,0];
var defFocus = [0,0]; //默认blocked 默认焦点

var ColumnImg = [];
var imgData = [];
var posters = [];
var bgImgs = [];
var otherPics = [];
var addTagFlag = 0;  //1：打标签   0：常规   -1：放大   -2：直接return

//0:左右移动 1:上下
var direct = "0";
var VODflag = 0;  //1: 网络播放   2: 频道直播

var startTime = ['2020-08-07','20','00'];
var endTime = ['2020-08-09','20','00'];
var tipFlag = -1;
var picPos = 0;
var record = [457,0];  // voteId ；是否记录
var vote = [0,457,10,10,0];   //是否投票，voteId,allCount,singleCount,是否记录电话


////left top wdith height 字体大小 文字行高    字体颜色   居中显示  是否显示
//   0    1    2     3      4      5           6       7       8
var page = [600,650,60,60,48,60,"8b0000","center",0];   //页数显示

//left top wdith height 上层left 上层top 背景色 焦点色 是否显示 显示类型 是否显示具体数据
//  0    1    2     3      4       5      6    7      8       9        10
var sc = [1220,150,3,490,-2,6,"584d42","d0a96f",0,2,0];
var scrollFlag = sc[8];
var scrollWay = sc[9];
var scrollData = sc[10];

//left top wdith height  是否轮播:99轮播  其他数字播指定位置视频 ；是否播放
// 0   1    2     3            4                               5
var video = [546,361,83,162,99,0];  //是否轮播:99轮播  其他数字播指定位置视频 ；是否播放

////left top wdith height 列数 行数 left间距 top间距 字体大小 一行显示多少个字 焦点背景色 非焦点色 焦点色 方向 是否显示
//   0    1    2     3      4   5    6       7      8         9          10        11    12    13   14
var list = ["110","280","500","500","6","2","50","50","24","15","","ffffff","ffffff",0,0];
var maxListLen = Number(list[9]);

////left top wdith height 行间距 列间距 是否显示 异形listImg时的字段   放大listImg时的字段
//   0    1    2     3      4      5    6           7                   8
var listImg = [80,570,204,43,225,225,0,"3",'7'];
var listName = [80,570,204,43,225,225,0,'center'];
var titleImg = [65,37,360,215,380,275,0,"4",'7'];
var titleName = [85,37,346,115,345,127,0,'left'];

////left top wdith height 行数 列数 left间距 top间距 字体大小 一行显示多少个字 背景色 非焦点色 焦点色 方向 是否显示
//   0    1    2     3      4   5    6       7       8         9          10     11    12    13   14
var title = ["100","200","300","200","6","2","50","50","24","6","","c60003","FAF246","1","0"];
var maxTitleLen = Number(title[9]);

// left top wdith height left间距 top间距  pic   移动方向  是否显示  异形焦点样式是字段名称
//  0    1    2     3       4      5      6       7       8           9
var titlePic = [48,138,388,243,380,276,"20191120ListFocus",1,0,"4"];//方向 ；0不显示  1显示

// left top wdith height left间距 top间距   pic 移动方向 是否显示  异形焦点样式是字段名称
//  0    1    2     3       4      5       6       7     8          9
//&focusPic=747,106,430,515,57,72,20201105List,1,1
var focusPic = [320,370,1280,720,225,129,"20201125_8Focus",0,0,"3"];  //方向 ；0不显示  1显示焦点框  2替换焦点图（blocked）  3异形焦点  4自定义;异形焦点时的字段

// 是否截取 startStr endStr
//    0      1        2
var cutName = ["0",":","("];
var cutFlag = Number(cutName[0]) ; //等于1时，截取
var startStr = cutName[1];
var endStr = cutName[2];

var isP60 = typeof sysmisc != "undefined"?true:false;//是否是P60盒子
var isP30 = iPanel.eventFrame.systemId == 1?true:false;
var isHD30 = typeof iPanel.eventFrame.systemId == 'undefined'?true:false;
var isHD30Adv =typeof navigator != "undefined" && typeof navigator.userAgent == 'string' && navigator.userAgent.indexOf('3.0 Advanced') > 0;
var isWG = iPanel.eventFrame.systemId == 2?true:false;


var isSearch = url.indexOf('searchIndex.jsp') > 0;
var isKorean = url.indexOf('searchIndex.jsp') > 0;
var isWestern = url.indexOf('searchIndex.jsp') > 0;

var cardId = typeof CA != "undefined" ? CA.card.serialNumber : (typeof sysmisc != "undefined" ? sysmisc.getChipId():"9950000002197670");


var huawei_epg_url = typeof iPanel!="undefined"&&iPanel.eventFrame?iPanel.eventFrame.pre_epg_url:
sysmisc.getEnv('epg_address','');   //"http://192.168.14.102:8082"

var isEpgUrl = url.startWith("/EPG/jsp")  //页面是否在EPG上
var isEPGflag = url.indexOf('EPGflag') > 0;  //是否返回首页


function checkIPANEL30(){
	var userAgent = navigator.userAgent.toLowerCase();
	var flag = false;	
	if(userAgent.indexOf("ipanel") != -1 && userAgent.indexOf("advanced") == -1){//ipanel3.0
		flag = true;
	}
	return flag;
}

///////////////影片详情页面//////////////////////
if( isP60) {
	// p60_path_save();
	// url = 'http://aoh5.cqccn.com/h5_vod/vod/detail.html?vod_id=' + id + "&typeId=" + typeId;
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
var debugMode= 0; //1 调试，0 正式
































