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
<script language="javascript" src="wps_timer.js"></script>
<script language="javascript">
var responseJson;
var v_WiFiOff,v_WscEabled,v_PIN,v_AccessPolicy,v_WscMode,v_WscPinMode,v_WepOnFlag,up_WepOnFlag;
var v_wpsHwBtnMode,v_WscModeOption,v_RepeaterWPS;

function onPINModeClick(){
	if (document.WPSSetup.PINMode[1].checked)
		$("#div_wps_pin").show();
	else 
		$("#div_wps_pin").hide();
}
function onPINPBCRadioClick(){
	if (document.WPSSetup.PINPBCRadio[1].checked){
		$("#div_pin_config").show();
		onPINModeClick();
	}else
		$("#div_pin_config").hide();
}
function initValue(){
	if(v_RepeaterWPS=="1"){
		$("#div_nomal_wps").hide();
		$("#div_repeater_wps").show();
	}else{
		setJSONValue({
			"WscEabled"  : v_WscEabled,
			"div_WPSPin" : v_PIN
		});
	
		if(v_WscEabled==1){
			$("#div_wps_setting, #div_wps_info").show();
			updateWPS();
			
			if (v_WscMode==1)
				document.WPSSetup.PINPBCRadio[1].checked = true;
			else
				document.WPSSetup.PINPBCRadio[0].checked = true;
				
			if (v_WscPinMode==0)
				document.WPSSetup.PINMode[0].checked = true;
			else
				document.WPSSetup.PINMode[1].checked = true;
					
			onPINPBCRadioClick();
		}
		
		if ("0"==v_WscModeOption) {
			$(":input").attr('disabled',true);
		}
		if(v_AccessPolicy==1){
			$("#div_wps_setting, #div_wps_info").hide();
			$("#WscEabled").get(0).selectedIndex=0;
			$(":input").attr('disabled',true);
		}
		supplyValue("wpsHwBtnMode",v_wpsHwBtnMode);
	}
}
var responseJsonIdx;
var wifiFlag=0;
var WiFiIdx="0";
$(function(){
	var postVar0 = { topicurl : "setting/getWebWlanIdx"};
   	postVar0 = JSON.stringify(postVar0);
	$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar0))
    .done(function( Data0 ) {
		responseJsonIdx = JSON.parse(Data0);
		wifiFlag=responseJsonIdx['webWlanIdx'];
    })
	.fail(function(){
		resetForm();
	});
	
	if(top.frames[0].wifiSelect == 1 || wifiFlag == 1)
		WiFiIdx = "1";

	var postVar2 = { topicurl : "setting/getWiFiWpsEncry"};
	postVar2["WiFiIdx"] = WiFiIdx;
   	postVar2 = JSON.stringify(postVar2);
	$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar2))
    .done(function( Data2 ) {
		responseJsonIdx = JSON.parse(Data2);
		v_WepOnFlag=responseJsonIdx['WepOn'];
		if(v_WepOnFlag == "1")
		{
			if($("#WscEabled").get(0).selectedIndex == 1)
				
			return;
		}
		else
		{
			var postVar1 = { topicurl : "setting/getWiFiWpsSetupConfig"};
			postVar1["WiFiIdx"] = WiFiIdx;
			postVar1 = JSON.stringify(postVar1);
			$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar1))
		    .done(function( Data1 ) {
				responseJson = JSON.parse(Data1);
				v_WscEabled=responseJson['WscEabled'];
				v_PIN=responseJson['PIN'];
				v_WiFiOff=responseJson['WiFiOff'];
				v_WscMode=responseJson['WscMode'];
				v_WscPinMode=responseJson['WscPinMode'];
				v_wpsHwBtnMode=responseJson['wpsHwBtnMode'];
				v_AccessPolicy=responseJson['AccessPolicy0'];
				v_WscModeOption=responseJson['WscModeOption'];
				v_RepeaterWPS=responseJson['RepeaterWPS'];
				initValue();
			})
			.fail(function(){
				resetForm();
			});
		}
    })
	.fail(function(){
		resetForm();
	});
	
   return;
}); 
function updateWPS(){
	var postVar;
	postVar = { topicurl : "setting/getWiFiWpsConfig"};
	postVar['WiFiIdx'] = WiFiIdx;
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "POST",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
			WpsStatus = JSON.parse(Data);
			WPSUpdateHTML(WpsStatus);
		}
    });
}
function WPSUpdateHTML(WpsStatus){
	//var WscResult = WpsStatus['WscResult'];
	var WscStatus = WpsStatus['WscStatus'];

	if (WscStatus == "-1"){
		supplyValue("div_WPSStatus", MM_idle);
		StopTheClock();
	}
	else if (WscStatus == "0"){
		supplyValue("div_WPSStatus", MM_wps_success);
		StopTheClock();
	}
	else if (WscStatus == "1" || WscStatus ==  "3"){
		supplyValue("div_WPSStatus", MM_start_wps_process);
	}
	else if (WscStatus ==  "2"){
		supplyValue("div_WPSStatus", MM_wps_fail);
		StopTheClock();
	}
	else{
		supplyValue("div_WPSStatus", MM_start_wps_process);
	}
}
function ValidateChecksum(PIN){
    var accum = 0;
    var tmp_str = PIN.replace("-", "");
    var pincode = tmp_str.replace(" ", "");

	supplyValue("PIN", pincode);

    if (pincode.length == 4) return 1;
    if (pincode.length != 8) return 0;
    accum += 3 * (parseInt(pincode / 10000000) % 10);
    accum += 1 * (parseInt(pincode / 1000000) % 10);
    accum += 3 * (parseInt(pincode / 100000) % 10);
    accum += 1 * (parseInt(pincode / 10000) % 10);
    accum += 3 * (parseInt(pincode / 1000) % 10);
    accum += 1 * (parseInt(pincode / 100) % 10);
    accum += 3 * (parseInt(pincode / 10) % 10);
    accum += 1 * (parseInt(pincode / 1) % 10);
	return ((accum % 10) == 0);
}
function PINPBCFormCheck(){
	if (document.WPSSetup.PINPBCRadio[1].checked && document.WPSSetup.PINMode[1].checked){
		var pinVal = $("#PIN").val();	
		if (!checkVaildVal.IsVaildNumber(pinVal, "WPS PIN")) 
			return false;		
		
		if (!ValidateChecksum(pinVal)){
			alert(JS_msg32);
			return false;
		}
		return true;
	}
}
function do_count_downwps(){
	supplyValue('show_sec',wtime);
	if(wtime == 0) {top.location.reload();}
	if(wtime > 0) {wtime--;setTimeout('do_count_downwps()',1000);}
}
function doSubmit(){
	var postVar;
	up_WepOnFlag=1;
	postVar ={"topicurl":"setting/setWiFiWpsSetupConfig"}
	postVar['WiFiIdx'] = WiFiIdx;
	postVar['WscEabled'] = $('#WscEabled').val();
	if(v_WepOnFlag == "1")
		alert(JS_msg155);
	uiPost2(postVar);
}
function startWPS(){
	var postVar;
	postVar = {"topicurl":"setting/setWiFiWpsConfig"};
	postVar['WiFiIdx'] = WiFiIdx;
	if(v_RepeaterWPS=="1"){
		postVar['PINPBCRadio'] = "2";
		uiPost(postVar);
	}else{
		var PINPBCRadio = $(":radio[name=PINPBCRadio]:checked").val();
		var PINMode = $(":radio[name=PINMode]:checked").val();
		postVar['PINPBCRadio'] = PINPBCRadio;
		postVar['PINMode'] = PINMode;
		if ("1"==PINPBCRadio&&"1"==PINMode){
			if(!PINPBCFormCheck())return false;
			postVar['PIN'] = $('#PIN').val();
		}
		postVar = JSON.stringify(postVar);
		
		$.post(" /cgi-bin/cstecgi.cgi",postVar,
		function(Data){
			responseJson = JSON.parse(Data);
			InitializeTimer();
			updateWPS();
		});
	}
}
function changeBtnWpsMode(){
	var postVar ={"topicurl":"setting/setWpsBtnMode"};
	postVar['wpsHwBtnMode']=$("#wpsHwBtnMode").val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<span id="div_body_setting">
<script>showToper()</script>
<script>showContainer()</script>
<form method="post" name="WPSSetup">
<span id="div_nomal_wps">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_wps_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_wps_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="WscEabled" name="WscEabled" onChange="doSubmit()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table id="div_wps_setting" style="display:none" border=0 width="100%">
<tr id="div_wps_info" style="display:none">
<td class="item_left"><script>dw(MM_wps_status)</script></td>
<td><span id="div_WPSStatus"> </span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_pin_code)</script></td>
<td><b><span id="div_WPSPin"></span></b></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_pbcpin_mode)</script></td>
<td><input type="radio" name="PINPBCRadio" value="2" checked onClick="onPINPBCRadioClick()">PBC 
<input type="radio" name="PINPBCRadio" value="1" onClick="onPINPBCRadioClick()">PIN</td>
</tr>
<tr id="div_pin_config" style="display:none">
<td class="item_left">&nbsp;</td>
<td><input type="radio" name="PINMode" value="0" onClick="onPINModeClick()"> <script>dw(MM_pin_registrant)</script>&nbsp;&nbsp;<input type="radio" name="PINMode" value="1" onClick="onPINModeClick()"> <script>dw(MM_pin_accepting_registration_agency)</script> <span id="div_wps_pin" style="display:none"> <input type="text" name="PIN" id="PIN" size="8" maxlength="8"></span></td>
</tr>
<tr>
<td class="item_left">&nbsp;</td>
<td><script>dw('<input type="button" class=button value="'+BT_start+'" name="submitWPS" onClick="startWPS();">')</script></td>
</tr>
<tr style="display:none"><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr id="div_wps_mode" style="display:none">
<td class="item_left"><script>dw(MM_wps_hwBtnMode)</script></td>
<td><select name="wpsHwBtnMode" id="wpsHwBtnMode" onChange="changeBtnWpsMode();">
<option value="0">2.4G</option>
<option value="1">5G</option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
</span>

<span id="div_repeater_wps" style="display:none">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_wps_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_wps_setting_pbc)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_pbc_mode)</script></td>
<td><script>dw('<input type="button" class=button value="'+BT_start+'" name="submitWPS" onClick="startWPS();">')</script></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
</span>
</form>
<script>showFooter()</script>
</span>
<span id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</span>
</body></html>

