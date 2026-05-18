<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/common.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script>
var authNum;
var protalURL;
var authType;
var responseJson,authPassTimev, idleOffTimev,authSuccToURLv;

function addAuthParame(){
	var passtime=document.getElementById("authPassTime").value;
	if(!isEmpty(passtime)){
		alert(MM_hotspot_passTime+JS_115);
		return false;
	}	
	if(!isNumberMsg(passtime,MM_hotspot_passTime))
		return false;
	var idleOfftime=document.getElementById("idleOffTime").value;
	if(!isEmpty(idleOfftime)){
		alert(MM_hotspot_idleOffTime+JS_115);
		return false;
	}	
	if(!isNumberMsg(idleOfftime,MM_hotspot_idleOffTime))
		return false;
	if(protalURL==1){	
		var succURL=document.getElementById("authSuccToUrl").value;
		if(!isEmpty(succURL)){
			alert(MM_succ_url+JS_115);
			return false;
		}	
	}
	return true;
}
function Load_Setting(){
	//authNum=responseJson['authNum'];
	protalURL=responseJson['portalUrl'];
	authType=responseJson['userAuthType'];
	authPassTimev=responseJson['authPassTime'];
	idleOffTimev=responseJson['idleOffTime'];
	authSuccToURLv=responseJson['authSuccToURL'];
		
	document.getElementById("gowhere").value = protalURL;
	document.getElementById("userAuthType").value = authType;
	document.getElementById("authPassTime").value = authPassTimev;
	document.getElementById("idleOffTime").value = idleOffTimev;
	$("#authSuccToUrl").val(authSuccToURLv);
	changeURL();
	var succToURL=$("#authSuccToUrl").val();
	if(/wifimedia\//ig.test(succToURL)){
		document.getElementById("mediaPage").checked=true;
	}
	chooseMedia();
}
function changeURL(){
	if(document.getElementById("gowhere").value==1){
		document.getElementById("showManualUrl").style.visibility="";
		document.getElementById("showManualUrl").style.display="";
	}else{
		document.getElementById("showManualUrl").style.visibility="hidden";
		document.getElementById("showManualUrl").style.display="none";
	}
}
function addADSUrlFun(){
	var ads_url=document.getElementById("ads_url").value;
	if(!isEmpty(ads_url)){
		alert(MM_ads_domain+JS_115);
		return false;
	}
	document.getElementById("adsAction").value="add";
	return true;
}
function deleteAdsURLFun(){
	document.getElementById("adsAction").value="del";
	return true;
}
function chooseMedia(){
	if(document.getElementById("mediaPage").checked){
		document.getElementById("authSuccToUrl").value="wifimedia/index.html";
		document.getElementById("urlID").style.display="none";
	}else{
		document.getElementById("urlID").style.display="";
	}
}

$(function(){
	var postVarAds = { topicurl : "setting/getAuthParame"};
    postVarAds = JSON.stringify(postVarAds);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAds,  
        async : true,  
        success : function(Data){
			responseJson = JSON.parse(Data);
			Load_Setting();			
		}
    });	
});
function doSubmit(){
	if(addAuthParame()==false)
		return false;
	var postVar ={"topicurl":"setting/formSetAuthParame"};
	postVar['authPassTime']= $("#authPassTime").val();
	postVar['idleOffTime']=$("#idleOffTime").val();
	postVar['gowhere']=$("#gowhere").val();
	postVar['userAuthType']=$("#userAuthType").val();
	postVar['authSuccToUrl']=$("#authSuccToUrl").val();
	
	uiPost(postVar);
}
</script>
</head>

<body class="mainbody">
<table width="600"><tr><td>
<form action="" method=POST name="formCsAuth">
<input type="hidden" value="/auth/authRule.asp" name="submit-url">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_auth_rule)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_auth_rule)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr id="">
<td class="item_left"><script>dw(MM_hotspot_passTime)</script></td>
<td align="left" colspan="2">
<input type="text" name="authPassTime" id="authPassTime" size="32" maxlength="16" value="">&nbsp;&nbsp;&nbsp;&nbsp;<script>dw(MM_seconds)</script></td>
</tr>
<tr id="">
<td class="item_left"><script>dw(MM_hotspot_idleOffTime)</script></td>
<td align="left" colspan="2">
<input type="text" name="idleOffTime" id="idleOffTime" size="32" maxlength="16" value="">&nbsp;&nbsp;&nbsp;&nbsp;<script>dw(MM_seconds)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_go_where)</script></td>
<td><select name="gowhere" id="gowhere" style="width: 230px;" onchange="changeURL();">
<option value="0"><script>dw(MM_auto)</script></option>
<option value="1"><script>dw(MM_manual)</script> </option>
</select></td>
</tr>
<tr id="showManualUrl">
<td class="item_left"><script>dw(MM_succ_url)</script></td>
<td><script>dw(MM_video)</script>：
<input type="checkbox" name="mediaPage" id="mediaPage" onClick="chooseMedia(this);" value="1" ><span id="urlID"><script>dw(MM_ads_domain)</script>：
<input type="text" name="authSuccToUrl" id="authSuccToUrl" size="16" maxlength="32" value=""></span>
</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_auth_type)</script></td>
<td><select name="userAuthType" id="userAuthType" style="width: 230px;">
<option value="0"><script>dw(MM_none)</script></option>
<option value="1"><script>dw(MM_user_auth)</script> </option>
<option value="2"><script>dw(MM_user_phone)</script></option>
<option value="3"><script>dw(MM_user_weixin)</script> </option>
<option value="4"><script>dw(MM_user_email)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="button" class="button" value="'+BT_apply+'" name="addCsAuth" onClick="return doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" onClick="resetForm()">')</script></td>
</tr>
</table>
</form>
</td></tr></table>
</body>
</html>