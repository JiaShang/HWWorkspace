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

	/**��ʾҳ����Ҫ��ͼƬ */
	var img_ok = "iCatch_image/showtip/tck_define0.png";
	var img_ok_focus = "iCatch_image/showtip/tck_define1.png";
	var img_cancel = "iCatch_image/showtip/tck_cancel0.png";
	var img_cancel_focus = "iCatch_image/showtip/tck_cancel1.png";
	
	
	/* ��ʾ����ʾ�ı�־��0:û����ʾ�㣨Ĭ�ϣ���1:һ����ť��ʾ�㣻2:������ť����ʾ��; */
	var show_tip = 0;
	
	/* ��ʾ����ʾ�����λ�� */
	var tip_focus = 0;
	
	/* ������Ȩ·�� */
	var confirmUrl = null;
	
	/**0��ȡ����1��ȷ�� */
	var action_flag = 0;
	
	/**ֵ����1ʱ���ζ��� */
	var anCiFlag = 0;
	
	/**��Ӧ�¼���ʶ��0������ҳ�桢1����ʾҳ��  */
	var key_flag = 0;
		
	
	/* ��ʾ��ʾ�򣺲���mesΪ��ʾ��Ϣ�ַ�����buttonNumΪ��ʾ�İ�ť���� 1("ȷ��")2("ȷ��"��"ȡ��")*/
	function showTipWindow(mes,buttonNum){
		iPanel.debug("cdq showTipWindow iPanel.mainFrame.location.href = " + iPanel.mainFrame.location.href);
		key_flag = 1;	// �����ڲ���Ӧ��ֵ
		show_tip = buttonNum;
		if(buttonNum == 1){//��ʾһ����ť
			showOneButton(mes);
		}
		else if(buttonNum == 2){//��ʾ������ť
			showTwoButton(mes);
		}
	}
	
	/**��ʾһ����ť */
	function showOneButton(msg){
		$("sure").src = img_ok_focus;
		note1.style.display = "none";
		note2.style.display = "block";
		$("tip_note").style.visibility = "visible";
		tip_info.innerText = msg;
	}
	
	/**��ʾ������ť */
	function showTwoButton(msg){
		tip_info.innerText = msg;
		$("sure").src = img_ok;
		$("cancel").src = img_cancel_focus;
		note1.style.display = "block";
		note2.style.display = "none";
		$("tip_note").style.visibility = "visible";
	}
	
	/**�ر���ʾ��  */
	function closeTipWindow(){
		key_flag = 0;
		action_flag = 0;
		tip_info.innerText = "&nbsp;";
		$("tip_note").style.visibility = "hidden";
	}
	
	/**������Ӧ��KEY_OK��KEY_LEFT��KEY_RIGHT��KEY_EXIT����������ֵ����Ӧ  */
	function tipkeypress(keycode){
		//������ť��ʾ��ֵ��Ӧ��KEY_OK��KEY_EXIT����
		if(show_tip == 1){
			if("KEY_SELECT" == keycode){//������ť��ʾ��ֻҪ�رռ��ɣ����������� 
				closeTipWindow();
				return 0;
			}
		}
		
		//������ť��ʾ��ֵ��Ӧ��KEY_OK��KEY_LEFT��KEY_RIGHT��KEY_EXIT����
		if(show_tip == 2){
			if("KEY_SELECT" == keycode){//KEY_OK��Ӧ 
				if(anCiFlag == 1){//���ζ��� 
					if(action_flag == 1){
						anCi();//���ζ��� 
					}
					else{
						closeTipWindow();//�ر���ʾ 
					}
				}
				else{
					//��ǩ��ʾ ����
					if(action_flag == 1){
						tip_fromBookmarkPlay();//����ǩ���� 
					}
					else{
						tip_fromBeginPlay();//�ӿ�ʼ������ 
					}
					closeTipWindow();
				}
				return 0;
			}
			if("KEY_LEFT" == keycode){
				if(action_flag == 0){//��ȡ����ť����Ӧ 
					action_flag = 1;
				   $("sure").src = img_ok_focus;
				   $("cancel").src = img_cancel;
				}
				return 0;
			}
			
			if("KEY_RIGHT" == keycode){
				if(action_flag == 1){//��ȷ����ť����Ӧ  
					action_flag = 0;
				   $("sure").src = img_ok;
				   $("cancel").src = img_cancel_focus;
				}
				return 0;
			}
			
			if("KEY_EXIT" == keycode){//�˳� 
				return 1;
			}
		}
		return 0;
	}
	
	
	/* ���ι��� */  
	function anCi(){
		closeTipWindow();
		anCiFlag = 0;
		$("data_ifm").src = confirmUrl;
	}
	
	/* ��ǩ�Ļ�ȡ���ж�ĳ��VOD�Ƿ�����ǩ�����û�з���null������з�����ǩ���ŵĿ�ʼʱ�� */
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
					/* ���ϵ�ʱ��ȡ���������ֶβ�Ҫ */
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
	
	/* ��ȡ��Ȩ·�� */ 
	function getAuthUrl(vodId){
		/* ��ȡ��ǩ��ʱ�� */
		var bmStartTime = domark(vodId);
		
		/* ������ǩʱ��ƴ����Ȩ·��*/
		if (bmStartTime != null){
			showTipWindow("�ý�Ŀ����ǩ���Ƿ����ǩ������", 2);
		}
	    else{
	    	//ֱ����Ȩ���� 
	        tip_fromBeginPlay();
	    }
	}
	
</script>