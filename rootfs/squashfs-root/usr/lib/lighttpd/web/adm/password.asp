<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var responseJson ,v_current_pwd,v_current_user,v_watchdogb,v_watchdogcap;
function saveChanges(){
	if (!checkVaildVal.IsVaildString($("#admuser").val(), MM_username,1)) return false;	
	if (!checkVaildVal.IsVaildString($("#oldadmpass").val(), MM_oldpassword,1)) return false;
	if ($("#oldadmpass").val() != v_current_pwd) {alert(JS_msg49);return false;}
	if (!checkVaildVal.IsVaildString($("#admpass").val(), MM_newpassword,1)) return false;	
	if ($("#admpass2").val() != $("#admpass").val()) {alert(JS_msg50);return false;}
	return true;
}
function clearCookie(name) {    
 	setCookie(name, "", -1);    
}    
function setCookie(name, value, seconds) {    
	seconds = seconds || 0;      
	var expires = "";    
	if (seconds != 0 ) {   
		var date = new Date();    
		date.setTime(date.getTime()+(seconds*1000));    
		expires = "; expires="+date.toGMTString();    
	}    
 	document.cookie = name+"="+escape(value)+expires+"; path=/";  
} 
function initValue(){	
	v_current_pwd=responseJson['Password'];
	v_current_user=responseJson['Login'];
	supplyValue("admuser",v_current_user);
}
$(function(){
	var postVar = { topicurl : "setting/getPasswordCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);
		}
    });	
	initValue();
});
function doSubmit(){
	if(saveChanges()==false) return false;
	var postVar ={"topicurl":"setting/setPasswordCfg"};
	postVar['admuser'] = $("#admuser").val();
	postVar['admpass'] = $("#admpass").val();
	postVar['admwatchdog'] = $('input[name="admwatchdog"]:checked').val();	
	uiPost2(postVar)
}
var lanip='',wtime=0;
function uiPost2(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJsonPost = JSON.parse(Data);
		lanip=responseJsonPost['lan_ip'];
		if(true==responseJsonPost['success']){
			clearCookie(document.cookie.split("=")[0]);
			parent.location.href='http://'+lanip+'/login.asp';
			return false;
		}
	});
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method="post" name="passwordCfg" id="passwordCfg">
<span style="display:none">
<input type="radio" name="admwatchdog" id="admwatchdog" value="1"><script>dw(MM_enable)</script>
<input type="radio" name="admwatchdog" id="admwatchdog" value="0"><script>dw(MM_disable)</script>
</span>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_admin_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_sdmin_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr id="div_username" style="display:none">
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type="text" name="admuser" id="admuser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_oldpassword)</script></td>
<td><input type="text" id="oldadmpass" name="oldadmpass" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type="text" id="admpass" name="admpass" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_cfpassword)</script></td>
<td><input type="text" name="admpass2" id="admpass2" maxlength="32"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>