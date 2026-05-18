<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../style/normal_ws.css" rel="stylesheet" type="text/css">
<link href="../style/line.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/common.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script>
var protalVersion='protal_1.0';
var adsPage='/portal/index_noauth.html,30';  
var language="cn";
var lanIP="192.168.0.1";
var productModel="C750R"
var stayTime=adsPage.split(",")[1];
if(top!=self)top.location.href = self.location.href;

function saveChanges(flag,th)
{
	if(flag==0){
		document.auth.loginflag.value="logout";
	}
	else{

		if(document.auth.auth_user.value == "") {
			alert(JS_username_empty);
			document.auth.auth_user.focus();
			return false;
		}
		
		if(document.auth.auth_pass.value == "") {
			alert(JS_password_empty);
			document.auth.auth_pass.focus();
			return false;
		}
		document.auth.loginflag.value="login";
	}
	
	if(arguments.length==2){
	document.getElementById("protalPageDiv").style.display = "";
if(!/protal_1.0/.test(protalVersion)){
		document.getElementById("userAuthDiv").style.display = "";
		document.getElementById("userAuthDiv").style.left = "35%";
		document.getElementById("topic").style.display = "none";
		document.getElementById("pics_top").style.display = "none";
		document.getElementById("pics_bottom").style.display = "none"; 
			return false;
	  }else{
		document.auth.submit();
	  }
	}
	return true;
}
function iframeAutoFit(){
	var iframeObj = document.getElementById("showAdsPage");
	iframeObj.height=(iframeObj.Document?iframeObj.Document.body.scrollHeight:iframeObj.contentDocument.body.offsetHeight)+20+"px";
}
function Load_Setting()
{	
	var adsParam=adsPage.split(",")[0];
	if(/http:/ig.test(adsParam)|| /portal/ig.test(adsParam)){
		document.getElementById("showAdsPage").src=adsParam;
	}else{
		document.getElementById("showAdsPage").src="/"+adsParam+"/index.html";
	}
	var s = location.href.split("&");
	document.auth.gw_address.value = s[0].split("=")[1];
	document.auth.gw_port.value = s[1].split("=")[1];
	document.auth.gw_id.value = s[2].split("=")[1];
	document.auth.ip.value = s[3].split("=")[1];
	document.auth.mac.value = s[4].split("=")[1];
	document.auth.key.value = s[5].split("=")[1];
	document.auth.wwver.value = s[6].split("=")[1];
	document.auth.onlineuser.value = s[7].split("=")[1];
	document.auth.url.value = s[8].split("=")[1];
	document.auth.token.value = (new Date).valueOf();//Math.round(Math.random()*100000);
	document.getElementById("lanIP").innerHTML=lanIP;
	document.getElementById("ProductModel").innerHTML=productModel;
	//document.auth.action = "http://"+s[0].split("=")[1]+":"+s[1].split("=")[1]+"/wifidog/auth";

	//document.getElementById("div_main").style.height = document.body.offsetHeight-96-44-41+"px";
	//document.getElementById("div_main").style.height = document.body.clientHeight-96-44-41+"px";//for firefox	
	
	//if(!/protal_1.0/.test(protalVersion)){
	if(1){
		document.getElementById("protalPageDiv").style.display="";
		document.getElementById("userAuthDiv").style.display="none";
		document.getElementById("auth_user").value="admin";
		document.getElementById("auth_pass").value="admin";
		document.getElementById("gointernetId").disabled = true;
		//showStayTime();
		//setTimeout(function(){$("gointernetId").disabled = false;},(adsPage.split(",")[1]-0)*1000);
	}else{
		document.getElementById("protalPageDiv").style.display="none";
		document.getElementById("userAuthDiv").style.display="";
		document.getElementById("topic").style.display = "";
		document.getElementById("pics_top").style.display = "";
		document.getElementById("pics_bottom").style.display = ""; 
	}
}
var counters=stayTime;
var timer="";
function showStayTime(){
	document.getElementById("stayTimeID").style.display="";
	document.getElementById("showStayTime").innerHTML=--counters;
	if(counters == 0){
		timer=0;
		clearTimeout(timer);
		document.getElementById("gointernetId").disabled = false;
		document.getElementById("showStayTime").innerHTML=0;
		document.getElementById("stayTimeID").style.display="none";
		return;
	}
	timer=setTimeout(function(){showStayTime();},1000);
}

function open_auth_user()
{
	window.open("/auth/auth_user_add.asp","AddAuthUser",'width=620,height=400,left=50%,top=50%,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no');
}
window.onresize=iframeAutoFit;
</script>
</head>
<body onLoad="Load_Setting()">
<div id="protalPageDiv">
<div style="width: 100px; height: 30px;position: absolute;right: 20%;top: 5%;display:none;">
	<a href="#" id="gointernetId" onClick="return saveChanges(1,this)" style="cursor:pointer;height:30px;font-size: 15px;;line-height:30px;font-weight: bold;text-decoration:none;color: #000;">
		<img src="/style/icon_Network.png" /><script>dw(BT_gointernet)</script>
	</a>
</div>
<div id="stayTimeID" style="display:none;"><span id="showStayTime" style="width:50px;height:30px;margin-top:3px;"></span></div><!--<script>dw(MM_seconds)</script>-->
<iframe src="" id="showAdsPage" onload="iframeAutoFit();" style="width:99%;"></iframe>
</div>
<div id="userAuthDiv" style="position:absolute;top:200px;" align="center">
<form method='POST' action='/cgi-bin/cstecgi.cgi?CSAuth=login' name="auth" id="auth">
<input type='hidden' name='token' value="" />
<input type='hidden' name='gw_address' value="" />
<input type='hidden' name='gw_port' value="" />
<input type='hidden' name='gw_id' value="" />
<input type='hidden' name='ip' value="" />
<input type='hidden' name='mac' value="" />
<input type='hidden' name='key' value="" />
<input type='hidden' name='wwver' value="" />
<input type='hidden' name='onlineuser' value="" />
<input type='hidden' name='url' value="" />
<input type='hidden' name='loginflag' value="" />

<span id="pics_top">
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
<td class="title_down_left" id="ProductModel"></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right">&nbsp;</td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>
</span>

<!--<table id="div_main" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td valign="top" class="first_table">-->
<div align="center">
<table border=0 width="370" align="center" id="topic">
<tr><td height="80"></td></tr>
<tr><td class="login_title"><script>dw(MM_authserver_setting)</script></td></tr>
<tr><td class="login_help"><span style="display:none" id="lanIP"></span></td></tr>
<tr><td height="10"></td></tr>
</table>

<table width="370" height="227" border="0" cellpadding="0" cellspacing="0">
<tr>
<td colspan="3" background="../style/login.gif" width="370" height="227"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td colspan="2" height="30"></td></tr>
<tr>
<td class="login_label"><script>dw(MM_username)</script></td>
<td><input type="text" name="auth_user" id="auth_user" maxlength="30" class="login_input"></td>
</tr>
<tr><td colspan="2" height="20"></td></tr>
<tr>
<td class="login_label"><script>dw(MM_password)</script></td>
<td><input type="password" name="auth_pass" id="auth_pass" maxlength="30" class="login_input"></td>
</tr>
<tr><td colspan="2" height="60" align="center">&nbsp;</td></tr>
<tr>
<td colspan="2" align="center">
<script>
if (language=="cn")
{
	document.write('<input type="image" src="../style/login_button_CN.gif" border="0" onClick="return saveChanges(1)" style="cursor:pointer">');
	document.write('&nbsp;&nbsp;<input type="image" src="../style/logout_button_CN.gif" border="0" onClick="return saveChanges(0)" style="cursor:pointer">');
}
else 
{
	document.write('<input type="image" src="../style/login_button.gif" border="0" onClick="return saveChanges(1)" style="cursor:pointer">');
	document.write('&nbsp;&nbsp;<input type="image" src="../style/logout_button.gif" border="0" onClick="return saveChanges(0)" style="cursor:pointer">');
}
</script>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:open_auth_user()"><script>dw(MM_register)</script></a></td>
</tr>
</table></td>
</tr>
</table>
</div><!--</td>
<td width="6"></td>
</tr>
</table>-->
<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0" id="pics_bottom">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
<script>document.auth.auth_user.focus();</script>
</form>
</div>
</body>
</html>
