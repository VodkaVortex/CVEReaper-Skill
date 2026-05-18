<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript">
var responseUserCfg,responseUserList,usb_state,user0,guest,rules_num, usb_ftp,usb_smb;
function initValue(){
	usb_state=responseUserCfg['UsbFlag'];
	user0=responseUserCfg['Login'];
	guest=responseUserCfg['FtpAnonymous'];
	rules_num=responseUserCfg['userNums'];
	usb_ftp=responseUserCfg['ftpBuild'];
	usb_smb=responseUserCfg['smbBuild'];
	showUserList();
	showUser();
	
	if(responseUserCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
		$("#div_no_usbdivice").show();
		$("#div_usbdivice").hide();
	}else{
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice").show();
	}
}
function showUserList(){
	var userListTab=$("#showUserList").get(0);
	var trNode;
	//admin
	trNode=userListTab.insertRow(-1);
	trNode.align="center";
	trNode.insertCell(0).innerHTML="--";
	trNode.insertCell(1).innerHTML=user0;
	trNode.insertCell(2).innerHTML=MM_yes;
	trNode.insertCell(3).innerHTML=MM_yes;	
	trNode.insertCell(4).innerHTML="--";	
	//anonymous
	trNode=userListTab.insertRow(-1);
	trNode.align="center";
	trNode.insertCell(0).innerHTML="--";
	trNode.insertCell(1).innerHTML="anonymous";
	trNode.insertCell(2).innerHTML=(guest==1?MM_yes:MM_no);;
	trNode.insertCell(3).innerHTML=MM_no;	
	trNode.insertCell(4).innerHTML="--";
	//addUser
	for(var i=1;i<responseUserList.length;i++){
		trNode=userListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=responseUserList[i].idx+'<input type=\"checkbox\" id=\"'+responseUserList[i].delRuleName+'\" name=\"'+responseUserList[i].delRuleName+'\" value=\"'+responseUserList[i].delRuleName+'\" >';
		trNode.insertCell(1).innerHTML=responseUserList[i].userName.replace(eval("/&/gi"),'&amp;');
		trNode.insertCell(2).innerHTML=(responseUserList[i].ftpEnable==1?MM_yes:MM_no);
		trNode.insertCell(3).innerHTML=(responseUserList[i].smbEnable==1?MM_yes:MM_no);	
		trNode.insertCell(4).innerHTML=(responseUserList[i].creatDir==1?MM_yes:MM_no);	
	}
}
function deleteClick(){
   	for(i=0; i< rules_num; i++){
		var tmp;
		tmp	= eval("document.storage_user_adm.delRule"+i);
		if(tmp.checked == true)	return true;
	}
	alert(JS_msg128);
	return false;
}
function open_useradd_window(){
	if(rules_num == 10){
		alert(JS_msg112);
		return false;
	}
	window.open("usb_basic_userAdd.asp","Storage_User_Add","toolbar=no, location=no, scrollbars=yes, resizable=no, width=640, height=440");
}
function showUser(){
	var userTab = $("#showUserTab").get(0);
	for(var i=0;i<userTab.rows.length;i++){
		if(userTab.rows[i].cells.length>0){
			if(1 == usb_ftp)
				userTab.rows[i].cells[2].style.display="";
			else
				userTab.rows[i].cells[2].style.display="none";
			
			if(1 == usb_smb)
				userTab.rows[i].cells[3].style.display="";
			else
				userTab.rows[i].cells[3].style.display="none";	
		}
	}
}
$(function(){
	var postVar = { topicurl : "setting/getUserCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseUserCfg = JSON.parse(Data);
		}
    });
	
	var postVar = { topicurl : "setting/getUserList"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseUserList = JSON.parse(Data);
		}
    });
	initValue();	
});
function doDelete(){	
	var flg=0;
	var postVar ={"topicurl":"setting/storageDelUser"};
    for (i=0; i< rules_num; i++){
		var tmp = $("#delRule"+i).get(0);
		if (tmp.checked == true){
			postVar['delRule'+i]= i;
			flg=1;
		}
	}
	
	if(flg==0){
		alert(JS_msg128);
	 	event.returnValue = false;
	}
	
	if(flg==1){
		uiPost(postVar);
	}
}
</script>
</head>

<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<div id="div_no_usbdivice" style="display:none">
<table border=0 width="100%">
<tr><td><img src="../graphics/warning.gif" align="absmiddle">&nbsp;&nbsp;<span id="usbdevice_check">&nbsp;</span>&nbsp;&nbsp;
<script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>

<div id="div_usbdivice">
<form method=post name=storage_user_adm action="/goform/StorageDelUser">
<input type="hidden" name="submit-url" value="/usb/usb_basic_user.asp">
<input type=hidden name=hiddenButton value="">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_user_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_user_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table id="showUserTab" border=0 width="100%">
<tr align="center">
<td class="item_center">&nbsp;</td>
<td class="item_center"><b><script>dw(MM_username)</script></b></td>
<td class="item_center"><b><script>dw(MM_usb_userftp)</script></b></td>
<td class="item_center"><b><script>dw(MM_usb_usersmb)</script></b></td>
<td class="item_center"><b><script>dw(MM_auto_dir)</script></b></td>
</tr>
<tbody id="showUserList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class="button" name="add" value="'+BT_add+'" onClick="open_useradd_window()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class="button" name="del" value="'+BT_delete+'" return onClick="doDelete()"')</script></td></tr>
</table>
</form>
</div>
<script>showFooter()</script>
</body></html>