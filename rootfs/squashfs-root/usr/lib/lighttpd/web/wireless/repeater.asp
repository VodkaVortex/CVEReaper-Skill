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
var responseJson;
var v_ApCliSsid,v_ApCliBssid,v_ApCliAuthMode,v_ApCliEncrypType,v_ApCliKeyStr,v_ApCliWPAPSK,v_ApCliStatus,str,v_ScanAp;
var opmode=0,wispInterface=0;

function saveChanges(){
	if (v_ApCliStatus=="MM_connection_success"){
		if(!confirm(JS_msg131))	
			return false;
	}
	
	if (!checkVaildVal.IsVaildSSID($("#ApCliSsid").val(), MM_ssid)) return false;
	
	var mac_tmp=combinMAC2($("#bssid1").val(),$("#bssid2").val(),$("#bssid3").val(),$("#bssid4").val(),$("#bssid5").val(),$("#bssid6").val());
	$("#ApCliBssid").val(mac_tmp);
	supplyValue("ApCliBssid", mac_tmp);
	if (!checkVaildVal.IsVaildMacAddr($("#ApCliBssid").val()))	return false;
	
	var apcli_auth_mode = $('#ApCliAuthMode')[0].selectedIndex;
	var apcli_keytype = $('#ApCliKeyType')[0].selectedIndex;
	
	if (apcli_auth_mode == 1){
		var wepkey = $("#ApCliKeyStr").val();
		if (apcli_keytype == 0){//hex
			if (wepkey.length == 10 || wepkey.length == 26){
				if (!checkVaildVal.IsVaildWiFiPass(wepkey, MM_wepkey, "hex")) return false;
			}
			else{
				alert(JS_msg34);
				return false;
			}
		}
		else{//ascii
			if (wepkey.length == 5 || wepkey.length == 13){
				if (!checkVaildVal.IsVaildWiFiPass(wepkey, MM_wepkey, "ascii")) return false;
			}
			else{
				alert(JS_msg35);
				return false;
			}
		}
	}
	else if (apcli_auth_mode >= 2) {
		var wpakey = $("#ApCliWPAPSK").val();
		if (apcli_keytype == 0){//hex
			if (wpakey.length != 64){
				alert(JS_msg25);
				return false;
			}
			if (!checkVaildVal.IsVaildWiFiPass(wpakey, MM_wpakey, "hex")) return false;
		}
		else{
			if (wpakey.length < 8 || wpakey.length > 63){
				alert(JS_msg24);
				return false;
			}		
			if (!checkVaildVal.IsVaildWiFiPass(wpakey, MM_wpakey, "ascii")) return false;
		}
	}
	
	return true;
}

function updateKeyFormat(){
	var apcli_auth_mode = $('#ApCliAuthMode')[0].selectedIndex;
	var apcli_keytype = $('#ApCliKeyType')[0].selectedIndex;
	
	if (apcli_auth_mode == 1){
		if (apcli_keytype == 0)
			$("#ApCliKeyStr").attr("maxlength",26);
		else
			$("#ApCliKeyStr").attr("maxlength",13);
	}else if (apcli_auth_mode >= 2){
		if (apcli_keytype == 0)
			$("#ApCliWPAPSK").attr("maxlength",64);
		else
			$("#ApCliWPAPSK").attr("maxlength",63);
	}
}

function updateEncrypType(){
	updateKeyFormat();
}

function clearStatus(){
	$("#div_apcli_status").hide();
}
function updateAuthMode(){
	CreateEncrypType();

	$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wpa_key, #div_apcli_wep_type").hide();
	setDisabled("#ApCliKeyStr, #ApCliWPAPSK", true);

	var apcli_auth_mode = $('#ApCliAuthMode').val();
	if (apcli_auth_mode == "NONE"){
		supplyValue("ApCliEncrypType","NONE");	
	}else if (apcli_auth_mode == "WEP"){
		$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wep_type").show();
		setDisabled("#ApCliKeyStr", false);
		
		if (v_ApCliAuthMode == "OPEN")
			supplyValue("ApCliEncrypType","OPEN");
		else
			supplyValue("ApCliEncrypType","SHARED");
		
		if (v_ApCliKeyStr.length == 10 || v_ApCliKeyStr.length == 26)
			supplyValue("ApCliKeyType","0");
		else
			supplyValue("ApCliKeyType","1");	
	}else{
		$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wpa_key").show();	
		setDisabled("#ApCliWPAPSK", false);

		if (v_ApCliEncrypType == "TKIP")
			supplyValue("ApCliEncrypType","TKIP");
		else if (v_ApCliEncrypType == "AES" || v_ApCliEncrypType == "TKIPAES")
			supplyValue("ApCliEncrypType","AES");
			
		if (v_ApCliWPAPSK.length == 64)
			supplyValue("ApCliKeyType","0");
		else
			supplyValue("ApCliKeyType","1");
	}
}

function CreateEncrypType(){
	var new_options,new_values;
	switch($("#ApCliAuthMode").val()){
		case "NONE":
			new_values  = ["NONE"];
			new_options = [MM_disable];
			break;
		case "WEP":
			new_values  = ["OPEN","SHARED"];
			new_options = [MM_open_system,MM_shared_key];
			break;
		default:
			new_values  = ["TKIP","AES"];
			new_options = ["TKIP","AES"];
			break;
	}	
	CreateOptions('ApCliEncrypType', new_options, new_values);
}

function showApcliStatus(ssid,val) {
	switch (val){
		case 0:
			$("#apcli_status").html(MM_connection_fail);	
			break;
		case 1:
			$("#apcli_status").html(MM_connection_success);	
			break;
		case 2:
			$("#apcli_status").html(MM_noconnection);	
			break;
		default:
			$("#apcli_status").html(MM_noconnection);	
			break;					
	}

	if (ssid==""){
		$("#apcli_status").html(MM_noconnection);	
	}
}
			
function initValue(){
	setJSONValue({
		'ApCliKeyStr'      : responseJson['ApCliKeyStr'],
		'ApCliWPAPSK'      : responseJson['ApCliWPAPSK'],
		'ApCliChannel'     : responseJson['ApCliChannel'],
		'ApCliBssid'       : responseJson['ApCliBssid'],
		'ApCliSsid'        : responseJson['ApCliSsid']
	});

	$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wpa_key").hide();
	setDisabled("#ApCliKeyStr, #ApCliWPAPSK", true);

	v_WiFiOff=responseJson['WiFiOff'];
	v_ApCliSsid=responseJson['ApCliSsid'];
	v_ApCliBssid=responseJson['ApCliBssid'];
	v_ApCliAuthMode=responseJson['ApCliAuthMode'];
	v_ApCliEncrypType=responseJson['ApCliEncrypType'];
	v_ApCliKeyStr=responseJson['ApCliKeyStr'];
	v_ApCliWPAPSK=responseJson['ApCliWPAPSK'];
	v_ApCliStatus=responseJson['ApCliStatus'];
	
	if (v_ApCliEncrypType == "NONE")
		supplyValue("ApCliAuthMode","NONE");
	else if (v_ApCliEncrypType == "WEP")
		supplyValue("ApCliAuthMode","WEP");
	else if (v_ApCliAuthMode == "WPAPSK")
		supplyValue("ApCliAuthMode","WPAPSK");
	else if (v_ApCliAuthMode == "WPA2PSK")
		supplyValue("ApCliAuthMode","WPA2PSK");

	if (v_ApCliSsid == ""){
		supplyValue("ApCliSsid", "Repeater RPT");	
	}
	
	if (v_ApCliBssid != "") {
		bssid_tmp=v_ApCliBssid.split(":");
		$("#bssid1").val(bssid_tmp[0]);
		$("#bssid2").val(bssid_tmp[1]);
		$("#bssid3").val(bssid_tmp[2]);
		$("#bssid4").val(bssid_tmp[3]);
		$("#bssid5").val(bssid_tmp[4]);
		$("#bssid6").val(bssid_tmp[5]);
	}
	else{
		$("#bssid1").val("00");
		$("#bssid2").val("00");
		$("#bssid3").val("00");
		$("#bssid4").val("00");
		$("#bssid5").val("00");
		$("#bssid6").val("00");
	}

	updateAuthMode();
	showApcliStatus(v_ApCliSsid,parseInt(v_ApCliStatus));

	if (opmode == 2 || opmode == 3)
	{
		$("#goback").show();
	}
	else
	{
		$("#goback").hide();
	}
	
	if (v_WiFiOff==1) {
		$(":input").attr('disabled',true);
	}
	
	if (v_ApCliSsid!="") {
		$("#div_apcli_status").show();
	}
}

function createApList(){
	var postVarList = {topicurl : "setting/getWiFiApcliScan"};
	postVarList["WiFiIdx"] = WiFiIdx;
	$(":input").attr('disabled',true);
	postVarList = JSON.stringify(postVarList);
	$.ajax({  
	   	type : "post",  
	    url : " /cgi-bin/cstecgi.cgi",  
	    data : postVarList,  
	    beforeSend:function(){
			$('#div_aplist_head').nextAll().remove();
			var _html = '<tr><td colspan=7 style="text-align:center;"><img width=60 src=\"/style/load.gif\" style="margin-top:100px;"/></td></tr>';
			$('#div_aplist').append(_html);
		},  
	    success : function(Data){
	    	responseJson = JSON.parse(Data);
			v_ScanAp=responseJson['ScanAp'];
			if (-1!= v_ScanAp.indexOf(";m1t7k|")){
				str=v_ScanAp;
				var i=0,j=0;
				var str1;		
				var p1="#m1t7k|";
				var p2=";m1t7k|";
				var strTmp="";
				var signal;
				str1 = str.substr(0,-7);
				var str_arr_temp1 =[];
				var str_arr_temp = str.split(p1);
				//Delete empty elements
				for(var k=0; k < str_arr_temp.length; k++)
				{
					if(0 == str_arr_temp[k].length) continue;
					str_arr_temp1.push(str_arr_temp[k]);
				}
				//sort
 				str_arr_temp1 = sort_diy(str_arr_temp1);
				str = str_arr_temp1.join(p1);
				var str_arr = [];
				//After sorting, from the array
				for(var i = 0; i<str_arr_temp1.length; i++ )
				{
					str_arr[i] = str_arr_temp1[i].split(p2);
				}

				for(var i = 0; i<str_arr.length; i++){
					//if(str_arr[i][1]=="unknown" && str_arr[i][2] ==v_ApCliBssid)continue;
					if(str_arr[i][1]=="unknown")continue;
					strTmp+="<tr align=\"center\">\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][0]+"</td>\n";
					if(str_arr[i][1]=="unknown")
						strTmp+="<td class=\"item_center2\">&nbsp;</td>\n";
					else
						strTmp+="<td class=\"item_center2\">"+str_arr[i][1].replace(eval("/ /gi"),'&nbsp;')+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][2]+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][3]+"</td>\n";					
					signal=(200+2*str_arr[i][4]);
					if (signal>=100) signal=100;
					strTmp+="<td class=\"item_center2\">"+signal+"%"+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][5]+"</td>\n";
 					strTmp+="<td><input type=radio name=selectap id=selectap value="+str_arr[i][2]+" onclick=\"select_SSID("+i+")\"></td>"; 
					strTmp+="</tr>";				
				}
				$('#div_aplist_head').nextAll().remove();
				$('#div_aplist').append(strTmp);			
			}
			$(":input").attr('disabled',false);
		}
	});
}

var WiFiIdx="0";
var responseJsonIdx;
var wifiFlag=0;
$(function(){
	var info = location.search.substr(1).split(":");
	opmode = info[0];
	if(opmode == 3){
		wispInterface = info[1];
	}

	var postVarBuilt = { "topicurl" : "setting/getWebWlanIdx"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : false,  
        success : function(Data){
			responseJsonIdx = JSON.parse(Data);
			wifiFlag=responseJsonIdx['webWlanIdx'];
		}
    }); 
	
	if(top.frames[0].wifiSelect == 1 || wifiFlag == 1)
		WiFiIdx = "1";
		
	var postVar = { topicurl : "setting/getWiFiRepeaterConfig"};
	postVar["WiFiIdx"] = WiFiIdx;
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);
			initValue();
		}
	});
	//setTimeout("createApList();",1);
});

function doSubmit(){
	if (saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/setWiFiRepeaterConfig"};
	postVar['ApCliSsid'] = $('#ApCliSsid').val();
	postVar['ApCliBssid'] = $('#ApCliBssid').val();
	postVar['ApCliChannel'] = $('#ApCliChannel').val();
	postVar['ApCliAuthMode'] = $('#ApCliAuthMode').val();
	postVar['ApCliEncrypType'] = $('#ApCliEncrypType').val();
	postVar['ApCliKeyType'] = $('#ApCliKeyType').val();
	postVar['ApCliKeyStr'] = $('#ApCliKeyStr').val();
	postVar['ApCliWPAPSK'] = $('#ApCliWPAPSK').val();
	postVar['OperationMode'] = opmode;
	postVar['wispInterface'] = wispInterface;
	postVar["WiFiIdx"] = WiFiIdx;
	uiPost4(postVar);
}

function select_SSID(index){	
	var f=document.wirelessRepeater;
	var i,tmpi,auth_str;
	var p1="#m1t7k|";
	var p2=";m1t7k|";
	i=$("table[id$='div_aplist']>tbody").children("tr").length-3;

	$("#ApCliAuthMode").attr('disabled',true);
	$("#bssid1,#bssid2,#bssid3,#bssid4,#bssid5,#bssid6").attr("disabled", true);
	$("#div_apcli_encryp_type,#div_apcli_key_format").find("select").attr("disabled", true);

	if(str.split(p1)[index].split(p2)[1]=="unknown")
		supplyValue("ApCliSsid", "");
	else
		supplyValue("ApCliSsid", str.split(p1)[index].split(p2)[1]);
	var selectap_mac = $('input[name="selectap"]:checked').val();
	bssid_tmp=selectap_mac.split(":");
	$("#bssid1").val(bssid_tmp[0]);
	$("#bssid2").val(bssid_tmp[1]);
	$("#bssid3").val(bssid_tmp[2]);
	$("#bssid4").val(bssid_tmp[3]);
	$("#bssid5").val(bssid_tmp[4]);
	$("#bssid6").val(bssid_tmp[5]);
	
	$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wpa_key").hide();
	$("#ApCliChannel").val(str.split(p1)[index].split(p2)[0]);
	
	auth_str=str.split(p1)[index].split(p2)[3];
	if (auth_str=="NONE") {
		f.ApCliEncrypType.options[0] = new Option(MM_disable,"NONE");
		supplyValue("ApCliAuthMode","NONE");
		supplyValue("ApCliEncrypType","NONE");
	}else if (auth_str=="WEP") {
		$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wep_type").show();
		$("#ApCliKeyStr").val("").attr("disabled", false);
		f.ApCliEncrypType.options[0] = new Option(MM_open_system,"OPEN");
		f.ApCliEncrypType.options[1] = new Option(MM_shared_key,"SHARED");
		supplyValue("ApCliAuthMode","WEP");
		supplyValue("ApCliEncrypType", "OPEN");
	}else if (auth_str.search("WPA") != -1) {
		$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wpa_key").show();
		$("#ApCliWPAPSK").val("").attr("disabled", false);
		f.ApCliEncrypType.options[0] = new Option("TKIP","TKIP");
		f.ApCliEncrypType.options[1] = new Option("AES","AES");
		
		if (auth_str.split("/")[0] =="WPA2PSK" || auth_str.split("/")[0] =="WPAPSKWPA2PSK"){
			supplyValue("ApCliAuthMode", "WPA2PSK");
		}else{
			supplyValue("ApCliAuthMode", "WPAPSK");
		}
					
		if (auth_str.split("/")[1]=="TKIP"){
			supplyValue("ApCliEncrypType","TKIP");
		}else if (auth_str.split("/")[1] == "AES" || auth_str.split("/")[1] == "TKIPAES"){ 
			supplyValue("ApCliEncrypType","AES");
		}
		supplyValue("ApCliKeyType","1");
	}

	clearStatus();
}

function doBack(){
	top['view'].location.href = '../adm/opmode.asp'
}

</script>
</head>
<body class="mainbody">
<span id="div_body_setting">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessRepeater" id="wirelessRepeater">
<input type="hidden" id="ApCliChannel" name="ApCliChannel">
<input type="hidden" id="ApCliChannelExt" name="ApCliChannelExt">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_repeater_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_repeater_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr> 
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><input type="text" id="ApCliSsid" name="ApCliSsid" size="32" maxlength="32"></td>
</tr>
<tr> 
<td class="item_left">BSSID</td>
<td><input type="hidden" id="ApCliBssid" name="ApCliBssid">
<input style="width:28px" maxlength="2" name="bssid1" id="bssid1" onFocus="this.select();" onKeyUp="HWKeyUp('bssid',1,event);" onKeyDown="return HWKeyDown('bssid', 1,event)">:
<input style="width:28px" maxlength="2" name="bssid2" id="bssid2" onFocus="this.select();" onKeyUp="HWKeyUp('bssid',2,event);" onKeyDown="return HWKeyDown('bssid', 2,event)">:
<input style="width:28px" maxlength="2" name="bssid3" id="bssid3" onFocus="this.select();" onKeyUp="HWKeyUp('bssid',3,event);" onKeyDown="return HWKeyDown('bssid', 3,event)">:
<input style="width:28px" maxlength="2" name="bssid4" id="bssid4" onFocus="this.select();" onKeyUp="HWKeyUp('bssid',4,event);" onKeyDown="return HWKeyDown('bssid', 4,event)">:
<input style="width:28px" maxlength="2" name="bssid5" id="bssid5" onFocus="this.select();" onKeyUp="HWKeyUp('bssid',5,event);" onKeyDown="return HWKeyDown('bssid', 5,event)">:
<input style="width:28px" maxlength="2" name="bssid6" id="bssid6" onFocus="this.select();" onKeyUp="HWKeyUp('bssid',6,event);" onKeyDown="return HWKeyDown('bssid', 6,event)"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><select name="ApCliAuthMode" id="ApCliAuthMode" onChange="updateAuthMode()"> 
<option value="NONE"><script>dw(MM_disable)</script></option>
<option value="WEP">WEP</option>
<option value="WPAPSK">WPA-PSK</option>
<option value="WPA2PSK">WPA2-PSK</option>
</select></td>
</tr>
<tr id="div_apcli_encryp_type" style="display:none"> 
<td class="item_left"><script>dw(MM_encryp_type)</script></td>
<td><select name="ApCliEncrypType" id="ApCliEncrypType" onChange="updateEncrypType()">
</select><span id="div_apcli_wep_type" style="display:none">&nbsp;&nbsp;<script>dw("("+JS_choose+")");</script></span></td>
</tr>
<tr id="div_apcli_key_format" style="display:none"> 
<td class="item_left"><script>dw(MM_key_format)</script></td>
<td><select name="ApCliKeyType" id="ApCliKeyType" onChange="updateKeyFormat()">
<option value="0">Hex</option>
<option value="1">ASCII</option>
</select>&nbsp;&nbsp;<script>dw("("+JS_choose+")");</script></td>
</tr>
<tr id="div_apcli_wep_key" style="display:none">
<td class="item_left"><script>dw(MM_key)</script></td>
<td><input type="text" id="ApCliKeyStr" name="ApCliKeyStr" maxlength="26"></td>
</tr>
<tr id="div_apcli_wpa_key" style="display:none"> 
<td class="item_left"><script>dw(MM_key)</script></td>
<td><input type="text" id="ApCliWPAPSK" name="ApCliWPAPSK" maxlength="64"></td>
</tr>
<tr id="div_apcli_status" style="display:none">
<td class="item_left"><script>dw(MM_connection_status)</script></td>
<td id="apcli_status">&nbsp;</td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button id=goback value="'+BT_back+'" onClick="doBack()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class=button value="'+BT_connect+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>

<table border=0 width="100%" id="div_aplist" name="div_aplist">
<tr>
<td colspan="6" class="content_title"><script>dw(MM_site_survey_table)</script></td>
<td align="right"><script>dw('<input type=button class=button value='+BT_scan+' name=refresh onClick="createApList();">')</script></td>
</tr>
<tr><td colspan="7"><hr size=1 noshade align=top class=bline></td></tr>
<tr id="div_aplist_head" align="center">
<td class="item_center"><b><script>dw(MM_channel)</script></b></td>
<td class="item_center"><b><script>dw(MM_ssid)</script></b></td>
<td class="item_center"><b>BSSID</b></td>
<td class="item_center"><b><script>dw(MM_security_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_signal)</script></b></td>
<td class="item_center"><b><script>dw(MM_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
</table>
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
