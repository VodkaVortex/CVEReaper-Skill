<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/ajax.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var wifidog_enabled;
var setAuthServer;
var setAuthSerPath;
var setAuthServerDef;
var setAuthSerPathDef;
var lanIP;
var lanage='cn';
var mCODE;
var gwid;
var authServerPort;
var responseJson;

function updateState(){
	if (document.wifidog.wifidogEnabled.selectedIndex == 0) {
		$("#div_wifidog_status").hide();
		$("#div_wifidog_setting").hide();
	}
}

function saveChanges(){	
	if (document.wifidog.wifidogEnabled.selectedIndex == 1) {
		if (!checkVaildVal.isBlankCheck(document.wifidog.wifidogID.value, MM_wifidog_id)) return false;	
		if (!checkVaildVal.isBlankCheck(document.wifidog.wifidogServer.value, MM_wifidog_auth)) return false;	
	}
	return true;
}

function changeAuthAddr(th){
	if(/http/gi.test(th.value))
		document.getElementById("wifidogSerAddr").href=th.value+":"+document.wifidog.wifidogServerPort.value;
	else
		document.getElementById("wifidogSerAddr").href="http://"+th.value+":"+document.wifidog.wifidogServerPort.value;
}

function Load_Setting(){
	wifidog_enabled = responseJson['wifidog_enabled'];
	setAuthServer=responseJson['wifidogServer'];
	setAuthSerPath=responseJson['wifidogSerPath'];
	setAuthServerDef=responseJson['wifidogServerDef'];
	setAuthSerPathDef=responseJson['wifidogSerPathDef'];
	lanIP=responseJson['lanIp'];
	lanage=responseJson['LanguageType'];
	mCODE=responseJson['wifidogMCode'];
	gwid=responseJson['wifidog_gwid'];
	authServerPort=responseJson['wifidogServerPort'];
	
	if(wifidog_enabled == "1"){
		document.wifidog.wifidogEnabled.selectedIndex =1;
		$("#div_wifidog_status,#div_wifidog_setting").show();
	}else {
		document.wifidog.wifidogEnabled.selectedIndex =0;
		$("#div_wifidog_status,#div_wifidog_setting").hide();
	}
	
	if(setAuthServer!=""){
		if(/http/gi.test(setAuthServer))
			document.getElementById("wifidogSerAddr").href=setAuthServer+":"+authServerPort;
		else
			document.getElementById("wifidogSerAddr").href="http://"+setAuthServer+":"+authServerPort;
		document.wifidog.wifidogServer.value=setAuthServer;
	}else{
		document.getElementById("wifidogSerAddr").href="http://"+setAuthServerDef+":"+authServerPort;
		document.wifidog.wifidogServer.value=setAuthServerDef;
	}
	
	if(setAuthSerPath!="")
		document.wifidog.wifidogSerPath.value=setAuthSerPath;
	else
		document.wifidog.wifidogSerPath.value=setAuthSerPathDef;
	if(authServerPort!="")
		document.wifidog.wifidogServerPort.value=authServerPort;
	else
		document.wifidog.wifidogServerPort.value="80";

	document.getElementById("wifidogStatus").href="http://"+lanIP+":2060/wifidog/status?lan="+lanage;
	document.wifidog.wifidogCODE.value = mCODE;
	document.wifidog.wifidogID.value = gwid;
	document.getElementById("div_content_help").style.display = "";
}

$(function(){
	var postVar = { topicurl : "setting/getWifidogConfig"};
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
	Load_Setting();
});

function doSubmit(){
	if(arguments.length==0){
		if(saveChanges()==false)return false;
	}
	var postVar ={"topicurl":"setting/setWifidogCfg"};
	postVar['wifidogEnabled'] = $('#wifidogEnabled').val();
	postVar['wifidogID'] = $('#wifidogID').val();
	postVar['wifidogServer'] = $('#wifidogServer').val();
	postVar['wifidogSerPath'] = $('#wifidogSerPath').val();
	postVar['wifidogServerPort'] = $('#wifidogServerPort').val();
	uiPost(postVar);
}
</script>
</head>
<body  class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="wifidog" id="wifidog" >
<input type="hidden" name="submit-url" value="/internet/wifidog.asp">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_wifidog_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_wifidog)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select onChange="updateState();doSubmit(1);" id="wifidogEnabled" name="wifidogEnabled" >
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select><span id="div_wifidog_status" style="display:none">&nbsp;&nbsp;&nbsp;
<a target="_blank" href="http://totolink.wlanzone.cn" id="wifidogSerAddr" style="text-decoration:none;color:blue;"><b>[<script>dw(MM_wifidog_manage)</script>]</b></a>&nbsp;&nbsp;&nbsp;
<a target="_blank" href="http://192.168.0.1:2060/wifidog/status" id="wifidogStatus" style="text-decoration:none;color:blue;"><b>[<script>dw(MM_wifidog_status)</script>]</b></a></span></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<span id="div_wifidog_setting" style="display:none">
<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_wifidog_id)</script></td>
<td><input type="text" name="wifidogID" id="wifidogID" size="32" value=""></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_wifidog_code)</script></td>
<td><input type="text" name="wifidogCODE" size="32" maxlength="50" readOnly="true"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_wifidog_auth)</script></td>
<td><input type="text" name="wifidogServer" id="wifidogServer" size="32" value="" onChange="changeAuthAddr(this)"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_wifidog_authPort)</script></td>
<td><input type="text" name="wifidogServerPort" id="wifidogServerPort" size="32" value="" onChange="changeAuthAddr(this)"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_wifidog_path)</script></td>
<td><input type="text" name="wifidogSerPath" id="wifidogSerPath" size="32" value="" > <script>dw(MM_example)</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="return doSubmit()">')</script></td></tr>
</table>
</span>
</form>

<script>showFooter()</script>
</body></html>