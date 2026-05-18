<html>
<head>
<title></title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<link href="style/style.css" rel="stylesheet" type="text/css">
<link href="style/line.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="favicon.ico">
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript" src="js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var v_login_flag,v_wanConnectStatus,v_lanip;
var v_LanguageType,v_MultiLangSupport,v_HelpBuild,v_fmVersion,v_ProductModel,v_Title;

if(top!=self)top.location.href = self.location.href;
window.onerror=function(){return true;};

function saveChanges(){
	if($("#username").val() == ""){
		alert(MM_username+JS_msg1);
		$("#username").focus();
		return false;
	}	
	if($("#password").val() == ""){
		alert(MM_password+JS_msg1);
		$("#password").focus();
		return false;
	}	
	$("#Login").submit();
	return true;
}

function clearLoginErrMsg(){	
	$("#div_login_err_msg").html("");
}

function initValue(){
	$("#username").focus();
	v_login_flag=responseJson['login_flag'];
	v_lanip=responseJson['lanIp'];
	v_wanConnectStatus=responseJson['wanConnectStatus'];
	
	v_LanguageType=responseJson['LanguageType'];
	v_MultiLangSupport=responseJson['MultiLangBuilt'];
	v_HelpBuild=responseJson['HelpBuilt'];		
	v_fmVersion=responseJson['fmVersion'];
	v_ProductModel=responseJson['ProductModel'];

	v_Title=responseJson['Title'];	
	if(v_Title!="") top.document.title=v_Title;
	
	if (Number(v_login_flag) == 1) $("#div_login_err_msg").html(JS_msg51);
	else if (Number(v_login_flag) == 2) $("#div_login_err_msg").html(JS_msg52);
	else if (Number(v_login_flag) == 3) $("#div_login_err_msg").html(JS_msg53);
	else if (Number(v_login_flag) == 4) $("#div_login_err_msg").html(JS_msg54);
	else $("#div_login_err_msg").html("");
	
	var tmp;
	if(v_ProductModel==""){
		tmp = MM_firmware+"  "+v_fmVersion;
	}else{
		tmp = v_ProductModel+"    ("+MM_firmware+"  "+v_fmVersion+")";
	}
	$("#ProductModel").html(tmp);	
	$("#HelpUrl").attr("href", 'http://'+responseJson['HelpUrl']);	
	
	setJSONValue({
		'msg_login_1' : MSG_login_1,
		'msg_login_2' : MSG_login_2
	});
	
	if (v_MultiLangSupport.split(";").length > 1) $("#div_multi_language").show();
	
	
	if (v_HelpBuild == "1") $("#div_help").show();


	$("#div_loginIp").html(window.location.hostname);
}

$(function(){
	responseJson = _globalCfg_;
	initValue();
	showLanguageOption();
})
</script>
</head>
<body style="overflow-x:hidden">
<form method=post id="Login" name="Login" action="/cgi-bin/cstecgi.cgi?action=login">
<table height="96" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="top_left">&nbsp;</td>
<td class="top_center">&nbsp;</td>
<td class="top_right" align="right">&nbsp;</td>
</tr>
</table>

<table height="44" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td class="first_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left" id="ProductModel"></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none;position: relative;">
	<select id="languageOption"></select>
	&nbsp;&nbsp;</span>
<span id="div_help" style="display:none"><a id="HelpUrl" href="http://www.totolink.cn" target="_blank" style="position: relative;"><img id="help" src="../style/help_custom.gif" border="0" align="absmiddle"><span style="position: absolute;right: 12px;bottom:-2px;color: #fff;font-weight: bold;"><script>dw(MM_help)</script></span></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>

<table id="div_main" height="781" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td valign="top" class="first_table"><div align="center">
<table border=0 width="370" align="center">
<tr><td height="80"></td></tr>
<tr><td class="login_title"><script>dw(MM_login)</script></td></tr>
<tr><td class="login_help"><span id="msg_login_1"></span>&nbsp;<span id="div_loginIp"></span>&nbsp;<span id="msg_login_2"></span></td></tr>
<tr><td height="10"></td></tr>
</table>

<table width="370" height="227" border="0" cellpadding="0" cellspacing="0">
<tr>
<td colspan="3" background="style/login.gif" width="370" height="227"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td colspan="2" height="30"></td></tr>
<tr>
<td class="login_label"><script>dw(MM_username)</script></td>
<td><input type="text" name="username" id="username" maxlength="32" class="login_input" onKeyDown="clearLoginErrMsg()"></td>
</tr>
<tr><td colspan="2" height="20"></td></tr>
<tr>
<td class="login_label"><script>dw(MM_password)</script></td>
<td><input type="password" name="password" id="password" maxlength="32" class="login_input"  onkeydown="if(event.keyCode==13)saveChanges();" onFocus="clearLoginErrMsg()"></td>
</tr>
<tr><td colspan="2" height="60" align="center"><span id="div_login_err_msg"></span></td></tr>
<tr>
<td colspan="2" align="center" id="submitBtn">
	<button type="button" onClick="return saveChanges()" style="cursor:pointer;padding:0;margin:0;border:0;background: #00A0CB;color: #fff;height: 40px;min-width: 130px;font-weight: bold;font-size: 18px;padding:5px 20px;">
	<script>dw(BT_login)</script>
	</button>
</td>
</tr>
</table></td>
</tr>
</table>
</div></td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center1">
<script>
	var curDate = new Date();
	dw(MM_Copyright_Left)+document.write(curDate.getFullYear())+dw(MM_Copyright_Right);
</script>
</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</form>

</body>
</html>
