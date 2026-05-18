<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/ajax.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript">
var usb_state;
var ftpenabled,anonymous,ftpname,port,maxsessions,adddir,rename,remove,readfile,writefile,download,upload;
var all_str,rules_num;
var portStatus=1;
var responseFtpCfg,responseFtpUserList;
function initValue(){
	var f=document.storage_ftp;
	ftpname=responseFtpCfg['FtpName'];
	port=responseFtpCfg['FtpPort'];
	maxsessions=responseFtpCfg['FtpMaxSessions'];
	usb_state=responseFtpCfg['UsbFlag'];
	ftpenabled=responseFtpCfg['FtpEnabled'];
	anonymous=responseFtpCfg['FtpAnonymous'];
	adddir=responseFtpCfg['FtpAddDir'];
	rename=responseFtpCfg['FtpRename'];
	remove=responseFtpCfg['FtpRemove'];
	readfile=responseFtpCfg['FtpRead'];
	writefile=responseFtpCfg['FtpWrite'];
	download=responseFtpCfg['FtpDownload'];
	upload=responseFtpCfg['FtpUpload'];
	all_str=responseFtpCfg['AdmUsers'];
	
	showFtpUserList();
	
	if(responseFtpCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
		$("#div_no_usbdivice").get(0).style.display = "";
		$("#div_usbdivice").get(0).style.display = "none";
	}else{
		$("#div_no_usbdivice").get(0).style.display = "none";
		$("#div_usbdivice").get(0).style.display = "";
	}
	
	f.ftp_anonymous[0].disabled = true;
	f.ftp_anonymous[1].disabled = true;
	f.ftp_name.disabled = true;
	f.ftp_port.disabled = true;
	f.ftp_max_sessions.disabled = true;
	f.ftp_adddir[0].disabled = true;
	f.ftp_adddir[1].disabled = true;
	f.ftp_rename[0].disabled = true;
	f.ftp_rename[1].disabled = true;
	f.ftp_remove[0].disabled = true;
	f.ftp_remove[1].disabled = true;
	f.ftp_read[0].disabled = true;
	f.ftp_read[1].disabled = true;
	f.ftp_write[0].disabled = true;
	f.ftp_write[1].disabled = true;
	f.ftp_download[0].disabled = true;
	f.ftp_download[1].disabled = true;
	f.ftp_upload[0].disabled = true;
	f.ftp_upload[1].disabled = true;
	document.del_ftp.add.disabled = true;
	document.del_ftp.del.disabled = true;

	if (ftpenabled == "1"){
		f.ftp_enabled[0].checked = true;
		f.ftp_anonymous[0].disabled = false;
		f.ftp_anonymous[1].disabled = false;
		//$("ftpinfo").style.display = "";
		if (anonymous == 1)
			f.ftp_anonymous[0].checked = true;
		else
			f.ftp_anonymous[1].checked = true;
		
		f.ftp_name.disabled = false;
		f.ftp_name.value = ftpname;

		f.ftp_port.disabled = false;
		f.ftp_port.value = port;

		f.ftp_max_sessions.disabled = false;
		f.ftp_max_sessions.value = maxsessions;

		f.ftp_adddir[0].disabled = false;
		f.ftp_adddir[1].disabled = false;
		if (adddir == 1)
			f.ftp_adddir[0].checked = true;
		else
			f.ftp_adddir[1].checked = true;

		f.ftp_rename[0].disabled = false;
		f.ftp_rename[1].disabled = false;
		if (rename == 1)
			f.ftp_rename[0].checked = true;
		else
			f.ftp_rename[1].checked = true;
		
		f.ftp_remove[0].disabled = false;
		f.ftp_remove[1].disabled = false;
		if (remove == 1)
			f.ftp_remove[0].checked = true;
		else
			f.ftp_remove[1].checked = true;

		f.ftp_read[0].disabled = false;
		f.ftp_read[1].disabled = false;
		if (readfile == 1)
			f.ftp_read[0].checked = true;
		else
			f.ftp_read[1].checked = true;

		f.ftp_write[0].disabled = false;
		f.ftp_write[1].disabled = false;
		if (writefile == 1)
			f.ftp_write[0].checked = true;
		else
			f.ftp_write[1].checked = true;

		f.ftp_download[0].disabled = false;
		f.ftp_download[1].disabled = false;
		if (download == 1)
			f.ftp_download[0].checked = true;
		else
			f.ftp_download[1].checked = true;

		f.ftp_upload[0].disabled = false;
		f.ftp_upload[1].disabled = false;
		if (upload == 1)
			f.ftp_upload[0].checked = true;
		else
			f.ftp_upload[1].checked = true;

		document.del_ftp.add.disabled = false;
		document.del_ftp.del.disabled = false;
	}else{
		f.ftp_enabled[1].checked = true;
	}
}
function saveChanges(){
	var f=document.storage_ftp;
	if (f.ftp_enabled[0].checked == true){
		if (!checkVaildVal.IsVaildString(f.ftp_name.value, MM_ftp_name,1)) return false;		
		if (!checkVaildVal.IsVaildPort(f.ftp_port.value,MM_ftp_port)) return false;	
		if (!checkVaildVal.IsVaildNumberRange(f.ftp_max_sessions.value,MM_ftp_max_sessions, 1, 10)){
			return false;
		}
		if (f.ftp_port.value == ""){
			alert(MM_port+JS_msg18);
			f.ftp_port.focus();
			return false;
		}
		if(!portStatus){
			alert(MM_ftp_setting+JS_msg115);
			return false;
		}	
	}	
	return true;
}
function ftp_enable_switch(){
	var f=document.storage_ftp;
	if (f.ftp_enabled[1].checked == true){
		f.ftp_anonymous[0].disabled = true;
		f.ftp_anonymous[1].disabled = true;
		f.ftp_name.disabled = true;
		f.ftp_port.disabled = true;
		f.ftp_max_sessions.disabled = true;
		f.ftp_adddir[0].disabled = true;
		f.ftp_adddir[1].disabled = true;
		f.ftp_rename[0].disabled = true;
		f.ftp_rename[1].disabled = true;
		f.ftp_remove[0].disabled = true;
		f.ftp_remove[1].disabled = true;
		f.ftp_read[0].disabled = true;
		f.ftp_read[1].disabled = true;
		f.ftp_write[0].disabled = true;
		f.ftp_write[1].disabled = true;
		f.ftp_download[0].disabled = true;
		f.ftp_download[1].disabled = true;
		f.ftp_upload[0].disabled = true;
		f.ftp_upload[1].disabled = true;
		document.del_ftp.add.disabled = true;
		document.del_ftp.del.disabled = true;
	}else{
		f.ftp_anonymous[0].disabled = false;
		f.ftp_anonymous[1].disabled = false;
		f.ftp_name.disabled = false;
		f.ftp_port.disabled = false;
		f.ftp_max_sessions.disabled = false;
		f.ftp_adddir[0].disabled = false;
		f.ftp_adddir[1].disabled = false;
		f.ftp_rename[0].disabled = false;
		f.ftp_rename[1].disabled = false;
		f.ftp_remove[0].disabled = false;
		f.ftp_remove[1].disabled = false;
		f.ftp_read[0].disabled = false;
		f.ftp_read[1].disabled = false;
		f.ftp_write[0].disabled = false;
		f.ftp_write[1].disabled = false;
		f.ftp_download[0].disabled = false;
		f.ftp_download[1].disabled = false;
		f.ftp_upload[0].disabled = false;
		f.ftp_upload[1].disabled = false;
		document.del_ftp.add.disabled = false;
		document.del_ftp.del.disabled = false;
	}
}
function deleteClick(){
   	for(i=0; i< rules_num; i++){
		var tmp = eval("document.del_ftp.delRule"+i);
		if(tmp.checked == true)	return true;
	}
	alert(JS_msg108);
	return false;
}
function doDelete(){	
	var flg=0;
	var postVar ={"topicurl":"setting/delFtpUser"};
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
function open_diradd_window(){
	var cnt = 0;
	var p = all_str.split(";");
	for(i=0; i<p.length;i++){
		var q=p[i].split(",");
		if(q[2] == 1) cnt++;
	}
	if(rules_num == 10){
		alert(JS_msg112);
		return false;
	}	
	if(cnt == 0 && anonymous == 0){
		alert(JS_msg107);
		return false;
	}	
	window.open("usb_ftpAdd.asp","Ftp_Dir_Add","toolbar=no, location=no, scrollbars=yes, resizable=no, width=640, height=440");
}
function resultFun(data){
	if(data==1){
		portStatus=0;
	}else{
		portStatus=1;
	}
}
function checkPort(){
	var postVar ={"topicurl":"setting/checkPort"};
	postVar['port']  = $('input[name="ftp_port"]').val();
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			var responseFtpCfg = JSON.parse(Data);
			resultFun(responseFtpCfg['portStatus']);
		}
    });
}
function checkPort2(){
	if(document.storage_ftp.ftp_port.value !=port)
	checkPort();
}
function showFtpUserList(){
	var dirTab = $("#showFtpUserList").get(0);
	var trNode;
	rules_num=0;
	for(var i=1;i<responseFtpUserList.length;i++){
		trNode=dirTab.insertRow(-1);
		trNode.align="center";
		if(responseFtpUserList[i].delRuleName!=0){	
			trNode.insertCell(0).innerHTML=(rules_num+1)+'<input type=\"checkbox\" id=\"'+responseFtpUserList[i].delRuleName+'\" name=\"'+responseFtpUserList[i].delRuleName+'\" value=\"'+responseFtpUserList[i].delRuleName+'\" >';
			rules_num++;
		}else{
			trNode.insertCell(0).innerHTML="--";
		}
		trNode.insertCell(1).innerHTML=responseFtpUserList[i].userName.replace(eval("/&/gi"),'&amp;');
		trNode.insertCell(2).innerHTML=responseFtpUserList[i].path.replace(eval("/&/gi"),'&amp;');
	}
}
$(function(){
	var postVar = { topicurl : "setting/getFtpCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseFtpCfg = JSON.parse(Data);
		}
    });
	
	var postVar = { topicurl : "setting/getFtpUserCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseFtpUserList = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){	
	if (saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/ftpServerInit"};
	postVar['ftp_enabled']  = $(':radio[name="ftp_enabled"]:checked').val();
	postVar['ftp_name']  = $('input[name="ftp_name"]').val();
	postVar['ftp_anonymous']  = $(':radio[name="ftp_anonymous"]:checked').val();
	postVar['ftp_anonymous_dir']  = "/media";
	postVar['ftp_port']  = $('input[name="ftp_port"]').val();
	postVar['ftp_max_sessions']  = $('input[name="ftp_max_sessions"]').val();
	postVar['ftp_adddir']  = $(':radio[name="ftp_adddir"]:checked').val();
	postVar['ftp_rename']  = $(':radio[name="ftp_rename"]:checked').val();
	postVar['ftp_remove']  = $(':radio[name="ftp_remove"]:checked').val();
	postVar['ftp_read']  = $(':radio[name="ftp_read"]:checked').val();
	postVar['ftp_write']  = $(':radio[name="ftp_write"]:checked').val();
	postVar['ftp_download']  = $(':radio[name="ftp_download"]:checked').val();
	postVar['ftp_upload']  = $(':radio[name="ftp_upload"]:checked').val();
	uiPost(postVar);
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

<div id="div_usbdivice" width=700><tr><td>
<form method=post name=storage_ftp action="/goform/Ftp_Init">
<input type="hidden" name="submit-url" value="/usb/usb_ftp.asp">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_ftp_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_ftp_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><input type=radio name=ftp_enabled value="1" onClick="ftp_enable_switch();checkPort2();"><script>dw(MM_enable)</script>
<input type=radio name=ftp_enabled value="0" onClick="ftp_enable_switch();checkPort2();" checked><script>dw(MM_disable)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ftp_name)</script></td>
<td><input type=text name=ftp_name maxlength=16 value="FTPServer"></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_ftp_anonymous_login)</script></td>
<td><input type=radio name=ftp_anonymous value="1"><script>dw(MM_enable)</script>
<input type=radio name=ftp_anonymous value="0" checked><script>dw(MM_disable)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ftp_port)</script></td>
<td><input type=text name=ftp_port size=5 maxlength=5 value="21" onChange="checkPort();"> (1-65535)</td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_max_sessions)</script></td>
<td><input type=text name=ftp_max_sessions size=2 maxlength=2 value="10"> (1-10)</td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_create_dir)</script></td>
<td><input type=radio name=ftp_adddir value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_adddir value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_rename_file_dir)</script></td>
<td><input type=radio name=ftp_rename value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_rename value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_remove_file_dir)</script></td>
<td><input type=radio name=ftp_remove value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_remove value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_readfile)</script></td>
<td><input type=radio name=ftp_read value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_read value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_writefile)</script></td>
<td><input type=radio name=ftp_write value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_write value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_download_capability)</script></td>
<td><input type=radio name=ftp_download value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_download value="0"><script>dw(MM_disable)</script></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ftp_upload_capability)</script></td>
<td><input type=radio name=ftp_upload value="1" checked><script>dw(MM_enable)</script>
<input type=radio name=ftp_upload value="0"><script>dw(MM_disable)</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="setTimeout(doSubmit,250)">')</script></td></tr>
</table>
</form>

<form method=post name=del_ftp action="/goform/Ftp_Del">
<input type="hidden" name="submit-url" value="/usb/usb_ftp.asp">
<table border=0 width="100%"> 
<tr><td colspan="3"><b><script>dw(MM_sharing_dir_list)</script></b></td></tr>
<tr><td colspan="3"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center">&nbsp;</td>
<td class="item_center"><b><script>dw(MM_allows_users)</script></b></td>
<td class="item_center"><b><script>dw(MM_dir_name)</script></b></td>    
</tr>
<tbody id="showFtpUserList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class="button" name="add" value="'+BT_add+'" onClick="open_diradd_window()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button"  onClick="return doDelete()" name="del" value="'+BT_delete+'">')</script></td></tr>
</table>
</form>
</div>
<form method=post id="portcheckfrm" action="/goform/checkPort" style="display:none;">
<input type=text name="enabled" value="">
<input type=text name="port" value="">
</form>
<script>showFooter()</script>
</body></html>