<html>
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
var usb_state,rate,responseNginxCfg;
function initValue(){
	var f=document.form_nginx;
	usb_state=responseNginxCfg['UsbFlag'];
	rate=responseNginxCfg['nginx_rate'];
		
	if(responseNginxCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
		$("#div_no_usbdivice").show();
		$("#div_usbdivice").hide();
	} 
	else{
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice").show();
	}
	
	f.nginx_rate.value = rate;
}
function saveChanges(){
	if (!checkVaildVal.IsVaildNumberRange($('#nginx_rate').val(), MM_nginx_rate, 1, 50000)) return false;
	return true;
}
$(function(){
	var postVar = { topicurl : "setting/getNginxCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseNginxCfg = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){	
	if (saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/setNginxCfg"};
	postVar['nginx_rate']  = $('input[name="nginx_rate"]').val();
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

<div id="div_usbdivice">
<form method=post name=form_nginx >
<input type="hidden" name="submit-url" value="/usb/usb_ftp.asp">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_nginx_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_nginx_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_nginx_rate)</script></td>
<td><input type=text name=nginx_rate id=nginx_rate size=8 maxlength=5 value="512"> (KB/S)</td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
</div>
<script>showFooter()</script>
</body></html>