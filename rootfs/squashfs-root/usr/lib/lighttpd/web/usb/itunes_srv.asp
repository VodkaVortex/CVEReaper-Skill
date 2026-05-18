<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript">
var responseItunesCfg,itunes_enable,itunes_dir,itunes_srvname,itunes_password,itunes_wan,usb_state,wan_ip,lan_ip,wanstatus,remoteport;
function initValue(){	
	itunes_enable=responseItunesCfg['iTunesEnable'];
	itunes_dir=responseItunesCfg['iTunesDir'];
	itunes_srvname=responseItunesCfg['iTunesSrvName'];
	itunes_password=responseItunesCfg['iTunesPasswd'];
	itunes_wan=responseItunesCfg['iTunesWan'];
	usb_state=responseItunesCfg['UsbFlag'];
	wan_ip=responseItunesCfg['wanIP'];
	lan_ip=responseItunesCfg['lanIp'];
	wanstatus=responseItunesCfg['wanConnectStatus'];
	remoteport=responseItunesCfg['RemoteManagementPort'];
	
	if(responseItunesCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
		document.getElementById("div_no_usbdivice").style.display = "";
		document.getElementById("div_usbdivice").style.display = "none";
	}else{
		document.getElementById("div_no_usbdivice").style.display = "none";
		document.getElementById("div_usbdivice").style.display = "";
	}
	
	document.itunessrv.dir_path.disabled = true;
	document.itunessrv.srv_name.disabled = true;
	document.itunessrv.srv_password.disabled = true;
	document.itunessrv.fromwan.disabled = true;
	document.itunessrv.dir_Pro.disabled = true;
	document.itunessrv.dir_path.value = itunes_dir;
	document.itunessrv.srv_name.value = itunes_srvname;
	document.itunessrv.srv_password.value = itunes_password;
	
	if(itunes_wan == "1")
		document.itunessrv.fromwan.checked = true;
	
	if (itunes_enable == "1"){
		document.itunessrv.enabled[0].checked = true;
		document.itunessrv.dir_path.disabled = false;	
		document.itunessrv.srv_name.disabled = false;
		document.itunessrv.srv_password.disabled = false;
		document.itunessrv.dir_Pro.disabled = false;
		document.itunessrv.fromwan.disabled = false;
	}else
		document.itunessrv.enabled[1].checked = true;
}
function CheckValue(){	
	var re=/^[A-Za-z0-9]*$/;   
	if (document.itunessrv.enabled[0].checked == true){
		var reg = /^\w+$/;

		if (document.itunessrv.srv_name.value == ""){
			alert(JS_msg117);
			document.itunessrv.srv_name.focus();
			document.itunessrv.srv_name.select();
			return false;
		}else if (document.itunessrv.srv_name.value.indexOf(" ") >= 0){
			alert(JS_msg118);
			document.itunessrv.srv_name.focus();
			document.itunessrv.srv_name.select();
			return false;
		}else if(!reg.test(document.itunessrv.srv_name.value)){
			alert(JS_msg116);
			document.itunessrv.srv_name.focus();
			return false;
		}
		
		if (document.itunessrv.srv_password.value == ""){
			alert(MM_password+JS_msg1);
			document.itunessrv.srv_password.focus();
			document.itunessrv.srv_password.select();
			return false;
		}
		else if (document.itunessrv.srv_password.value.indexOf(" ") >= 0){
			alert(JS_msg118);
			document.itunessrv.srv_password.focus();
			document.itunessrv.srv_password.select();
			return false;
		}else if(re.test(document.itunessrv.srv_password.value)==false){
			alert(JS_msg119);
			document.itunessrv.srv_password.focus();
			document.itunessrv.srv_password.select();
			return false;	
		}
		
		if (document.itunessrv.dir_path.value == ""){
			alert(MM_dir_path+JS_msg118);
			document.itunessrv.dir_path.focus();
			document.itunessrv.dir_path.select();
			return false;
		}
	}
	return true;
}
function enable_switch(){
	if (document.itunessrv.enabled[1].checked == true){
		document.itunessrv.dir_path.disabled = true;
		document.itunessrv.srv_name.disabled = true;
		document.itunessrv.srv_password.disabled = true;
		document.itunessrv.dir_Pro.disabled = true;
		document.itunessrv.fromwan.disabled = true;
	}else{
		document.itunessrv.dir_path.disabled = false;
		document.itunessrv.srv_name.disabled = false;
		document.itunessrv.srv_password.disabled = false;
		document.itunessrv.dir_Pro.disabled = false;
		document.itunessrv.fromwan.disabled = false;
	}
}
function submit_apply(){
	if (!CheckValue())
		return false;
	return true;
}
function resetForm(){
	location=location; 
}
function open_diradd_window(n){
	var locationip = location.href.split('/')[2];
	if( locationip == lan_ip ){
		window.open("itunes_add_dir.asp","ietunes_path","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480")
	}else{
		if(wanstatus=='MM_disconnected'){
			alert(JS_msg120);
			return false;
		}
		window.open("http://"+wan_ip+":"+remoteport+"/usb/itunes_add_dir.asp","itunes_add","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480");
	}
}
$(function(){
	var postVar = { topicurl : "setting/getItunesCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseItunesCfg = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){	
	if (CheckValue()==false)
		return false;
		
	var postVar ={"topicurl":"setting/Itunes_Init"};
	postVar['enabled']  = $(':radio[name="enabled"]:checked').val();
	postVar['dir_path']  = $('input[name="dir_path"]').val();
	postVar['srv_name']  = $('input[name="srv_name"]').val();
	postVar['srv_password']  = $('input[name="srv_password"]').val();
	postVar['fromwan']  = $('input[name="fromwan"]').get(0).checked?"on":"";
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

<form method=post name=itunessrv action="/goform/Itunes_Init">
<div id="div_usbdivice">
<input type="hidden" name="submit-url" value="/usb/itunes_srv.asp">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_itunes_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_itunes_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr> 
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><input class=radio type=radio name=enabled value="1" onClick="enable_switch()"><script>dw(MM_enable)</script> &nbsp;
<input class=radio type=radio name=enabled value="0" onClick="enable_switch()" checked><script>dw(MM_disable)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_itunes_server)</script></td>
<td><input type=text name=srv_name maxlength=15></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type=text name=srv_password maxlength=15></td>
</tr>
<tr> 	
<td class="item_left"><script>dw(MM_allow_wan_set)</script></td> 
<td><input type="checkbox" name="fromwan" ></td> 
</tr> 
<tr>
<td class="item_left"><script>dw(MM_dir_path)</script></td>
<td><input type=text name=dir_path maxlength=128 size="32"> 
<script>dw('<input type="button" class="button" name="dir_Pro" value="'+BT_search+'" onClick="open_diradd_window()">')</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="return doSubmit()">')</script></td></tr>
</table>
</div>
</form>
<script>showFooter()</script>
</body></html>