<%@ page pageEncoding="GBK" %>
<div id="tip_note" style="position:absolute; left:363px; top:244px; width:554px; height:330px; background:url(iCatch_image/showtip/tck_bg.png) no-repeat;-webkit-transition-duration:1ms; visibility:hidden; z-index:100;">
<table width="476" border="0" align="center" cellpadding="0" cellspacing="0" style="font-size:34px; color:#000000;">
  <tr>
    <td height="25" colspan="2"></td>
  </tr>
  <tr>
    <td width="112" height="200"><img src="iCatch_image/showtip/tck_icon.png" width="105" height="125" /></td>
    <td width="364" id="tip_info">&nbsp;</td>
  </tr>
  <tr id="note1" style="display:none">
    <td height="80" colspan="2" align="center"><img id="sure" src="iCatch_image/showtip/tck_define0.png" width="145" height="50" style="padding-right:10px;"><img id="cancel" src="iCatch_image/showtip/tck_cancel1.png" width="145" height="50" style="padding-left:10px;"></td>
  </tr>
  <tr id="note2" style="display:none">
    <td height="80" colspan="2" align="center"><img src="iCatch_image/showtip/tck_define1.png" width="145" height="50"></td>
  </tr>
</table>
</div>
	<script language="javascript">

	/**提示页面所要的图片 */
	var img_ok = "iCatch_image/showtip/tck_define0.png";
	var img_ok_focus = "iCatch_image/showtip/tck_define1.png";
	var img_cancel = "iCatch_image/showtip/tck_cancel0.png";
	var img_cancel_focus = "iCatch_image/showtip/tck_cancel1.png";
	
	
	/* 提示层显示的标志：0:没有提示层（默认）；1:一个按钮提示层；2:两个按钮的提示层; */
	var show_tip = 0;
	
	/* 提示层显示焦点的位置 */
	var tip_focus = 0;
	
	/* 按次授权路径 */
	var confirmUrl = null;
	
	/**0：取消，1：确定 */
	var action_flag = 0;
	
	/**值等于1时按次订购 */
	var anCiFlag = 0;
	
	/**响应事件标识，0：操作页面、1：提示页面  */
	var key_flag = 0;
		
	
	/* 显示提示框：参数mes为提示信息字符串；buttonNum为显示的按钮数； 1("确定")2("确定"，"取消")*/
	function showTipWindow(mes,buttonNum){
		iPanel.debug("cdq showTipWindow iPanel.mainFrame.location.href = " + iPanel.mainFrame.location.href);
		key_flag = 1;	// 父窗口不响应键值
		show_tip = buttonNum;
		if(buttonNum == 1){//提示一个按钮
			showOneButton(mes);
		}
		else if(buttonNum == 2){//提示两个按钮
			showTwoButton(mes);
		}
	}
	
	/**提示一个按钮 */
	function showOneButton(msg){
		$("sure").src = img_ok_focus;
		note1.style.display = "none";
		note2.style.display = "block";
		$("tip_note").style.visibility = "visible";
		tip_info.innerText = msg;
	}
	
	/**提示两个按钮 */
	function showTwoButton(msg){
		tip_info.innerText = msg;
		$("sure").src = img_ok;
		$("cancel").src = img_cancel_focus;
		note1.style.display = "block";
		note2.style.display = "none";
		$("tip_note").style.visibility = "visible";
	}
	
	/**关闭提示框  */
	function closeTipWindow(){
		key_flag = 0;
		action_flag = 0;
		tip_info.innerText = "&nbsp;";
		$("tip_note").style.visibility = "hidden";
	}
	
	/**按键响应（KEY_OK、KEY_LEFT、KEY_RIGHT、KEY_EXIT），其它键值不响应  */
	function tipkeypress(keycode){
		//单个按钮提示，值响应（KEY_OK、KEY_EXIT）；
		if(show_tip == 1){
			if("KEY_SELECT" == keycode){//单个按钮提示，只要关闭即可，无其他操作 
				closeTipWindow();
				return 0;
			}
		}
		
		//两个按钮提示，值响应（KEY_OK、KEY_LEFT、KEY_RIGHT、KEY_EXIT）；
		if(show_tip == 2){
			if("KEY_SELECT" == keycode){//KEY_OK响应 
				if(anCiFlag == 1){//按次订购 
					if(action_flag == 1){
						anCi();//按次订购 
					}
					else{
						closeTipWindow();//关闭提示 
					}
				}
				else{
					//书签提示 操作
					if(action_flag == 1){
						tip_fromBookmarkPlay();//从书签播放 
					}
					else{
						tip_fromBeginPlay();//从开始处播放 
					}
					closeTipWindow();
				}
				return 0;
			}
			if("KEY_LEFT" == keycode){
				if(action_flag == 0){//在取消按钮才响应 
					action_flag = 1;
				   $("sure").src = img_ok_focus;
				   $("cancel").src = img_cancel;
				}
				return 0;
			}
			
			if("KEY_RIGHT" == keycode){
				if(action_flag == 1){//在确定按钮才响应  
					action_flag = 0;
				   $("sure").src = img_ok;
				   $("cancel").src = img_cancel_focus;
				}
				return 0;
			}
			
			if("KEY_EXIT" == keycode){//退出 
				return 1;
			}
		}
		return 0;
	}
	
	
	/* 按次购买 */  
	function anCi(){
		closeTipWindow();
		anCiFlag = 0;
		$("data_ifm").src = confirmUrl;
	}
	
	/* 书签的获取：判断某个VOD是否含有书签，如果没有返回null，如果有返回书签播放的开始时间 */
	function domark(vodid){
	    var bookMark = iPanel.ioctlRead("bookmark");
		var overIdArray = new Array();
		var temp = new Array();
		if(bookMark != null){
			overIdArray = bookMark.split(";");
			var aa = 1;
			for(var i = 0; i < overIdArray.length; i++){
				temp = overIdArray[i].split(",");
				if(temp[1]==vodid){
					/* 将断点时间取出，其他字段不要 */
					return temp[4];
				}
				else if(temp[1] == "undefined" || temp[1] == undefined){
					return null;
				}
			}
		}
		else{
		   return null;
		}
	}
	
	/* 获取授权路径 */ 
	function getAuthUrl(vodId){
		/* 获取书签的时间 */
		var bmStartTime = domark(vodId);
		
		/* 根据书签时间拼接授权路径*/
		if (bmStartTime != null){
			showTipWindow("该节目有书签，是否从书签处播放", 2);
		}
	    else{
	    	//直接授权播放 
	        tip_fromBeginPlay();
	    }
	}
	
</script>