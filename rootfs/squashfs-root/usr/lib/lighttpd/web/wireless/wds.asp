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
var rules_num=0;
var responseJson,v_WiFiOff,v_WdsEnable,v_WdsList,v_WdsCommentList;
var v_ApCliSsid,v_ApCliBssid,v_ApCliAuthMode,v_ApCliEncrypType,v_ApCliKeyStr,v_ApCliWPAPSK,v_ApCliStatus;

function showButton(show){
	if (show==1){
		setDisabled("#add, #scan", false);
	}else if (show==2){
		setDisabled("#add, #scan", true);
	}else if (show==3){
		setDisabled("#mac1, #mac2, #mac3, #mac4, #mac5, #mac6, #comment", true);
		setDisabled("#ApCliAuthMode, #ApCliEncrypType, #ApCliKeyType, #ApCliKeyStr, #ApCliWPAPSK", true);
		setDisabled("#add, #scan", true);
	}else if (show==4){
		setDisabled("#del_sel, #del_reset", true);
	}else if (show==5){
		setDisabled("#del_sel, #del_reset", false);
	}
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

function updateAuthMode(){
	CreateEncrypType();

	$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wpa_key, #div_apcli_wep_type").hide();
	setDisabled("#ApCliKeyStr, #ApCliWPAPSK", true);

	var apcli_auth_mode = $('#ApCliAuthMode').val();
	if (apcli_auth_mode=="NONE"){
		supplyValue("ApCliEncrypType","NONE");	
	}else if (apcli_auth_mode=="WEP"){
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
		'WdsEnable'		   : 	responseJson['WdsEnable'],		
		'ApCliSsid'        : 	responseJson['ApCliSsid'],
		'ApCliBssid'       : 	responseJson['ApCliBssid'],
		'ApCliChannel'     : 	responseJson['ApCliChannel'],
		'ApCliKeyStr'      : 	responseJson['ApCliKeyStr'],
		'ApCliWPAPSK'      : 	responseJson['ApCliWPAPSK'],
		'WdsList'		   :	responseJson['WdsList'],
		'comment'		   :	responseJson['WdsCommentList'],
		'WiFiIdx'          :   	WiFiIdx
	});
	
	$("#div_apcli_encryp_type, #div_apcli_key_format, #div_apcli_wep_key, #div_apcli_wpa_key, #div_apcli_wep_type").hide();
	setDisabled("#ApCliKeyStr, #ApCliWPAPSK", true);
	
	v_WiFiOff=responseJson['WiFiOff'];
	v_WdsEnable=responseJson['WdsEnable'];	
	v_WdsList=responseJson['WdsList'];	
	v_WdsCommentList = responseJson['WdsCommentList'];
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

	if (v_ApCliBssid != "" && v_WdsList!="00:00:00:00:00:00") {
		bssid_tmp=v_ApCliBssid.split(":");
		$("#mac1").val(bssid_tmp[0]);
		$("#mac2").val(bssid_tmp[1]);
		$("#mac3").val(bssid_tmp[2]);
		$("#mac4").val(bssid_tmp[3]);
		$("#mac5").val(bssid_tmp[4]);
		$("#mac6").val(bssid_tmp[5]);
	}

	updateAuthMode();
	showApcliStatus(v_ApCliSsid,parseInt(v_ApCliStatus));
	
	if (v_WdsEnable==0) {
		showButton(3);
		showButton(4);
		$("#div_wds_setting").hide();
	}else{
		$("#div_wds_setting").show();
	}
	
	if (v_WiFiOff==1) {
		$(":input").attr('disabled',true);
	}

	if (v_ApCliBssid!="") {
		$("#div_apcli_status").show();
	}
	
	if (v_WdsList!="" && v_WdsList!="00:00:00:00:00:00"){	
		var wdsdata = new Array();
		var commentdata = new Array();
		wdsdata = v_WdsList.split(" ");
		commentdata=v_WdsCommentList.replace(/\$/g,"").split(" ");
		rules_num = wdsdata.length;
		var strTmp="";
		for (i=0; i<wdsdata.length; i++){
			strTmp="<tr align=\"center\">\n";
			strTmp+="<td class=item_center2>"+(i+1)+"</td>\n";
			strTmp+="<td class=item_center2>"+wdsdata[i]+"</td>\n";
			strTmp+="<td class=item_center2>"+commentdata[i]+"</td>\n";
			strTmp+="<td class=item_center2><input type=checkbox id=DR"+i+" name=DR"+i+"></td>\n";
			strTmp+="</tr>\n";
			$("#div_wdslist").append(strTmp);
		}
	}
	
	if (rules_num == 0) {
		showButton(4);
	}
}

var WiFiIdx="0";
var responseJsonIdx;
var wifiFlag=0;
$(function(){
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
		
	var postVar = { topicurl : "setting/getWiFiWdsAddConfig"};
	postVar["WiFiIdx"] = WiFiIdx;
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

function updateState(){
	var postVar ={"topicurl":"setting/setWiFiWdsAddConfig"};
	postVar['WdsEnable'] = $('#WdsEnable').val();
	postVar['addEffect'] = "1";
	postVar["WiFiIdx"] = WiFiIdx;
	if(v_WdsEnable == 1 && ($('#ApCliBssid').val() != "00:00:00:00:00:00"))
		uiPost4(postVar);
	else
		uiPost2(postVar);
}

function deleteClick(){
	var flg=0;
	var postVar = {"topicurl":"setting/setWiFiWdsDeleteConfig"};
	for (i=0; i< rules_num; i++) {
		var tmp = eval("document.wirelessWdsDel.DR"+i);
		if (tmp.checked == true) {
			var DR = i;	
			postVar['DR'+i] = DR;
			flg=1;
		}
	}
	
	if(flg==0){
		alert(JS_msg36);
		return false;
	}
	postVar["WiFiIdx"] = WiFiIdx;
	uiPost2(postVar);
}

function delClick(){
	if($('#ApCliBssid').val() == "00:00:00:00:00:00")
	{	
		alert(JS_msg70_1);
		return false;
	}
	var postVar = {"topicurl":"setting/setWiFiWdsAddConfig"};
	postVar['ApCliSsid'] = "TOTOLINK WDS";
	postVar['ApCliBssid'] = "00:00:00:00:00:00";
	postVar['ApCliAuthMode'] = "NONE";	
	postVar['WdsList'] = "";
	postVar['comment'] = "";
	postVar['addEffect'] = "0";
	postVar["WiFiIdx"] = WiFiIdx;
	uiPost2(postVar);
}

function saveChanges(){
	//if (rules_num > 0){
	//	alert(JS_msg30);
	//	return false;
	//}		
	
	var mac_tmp=combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val());
	$("#ApCliBssid").val(mac_tmp);
	if($("#WdsEnable")!=0){
		if(!checkVaildVal.IsVaildMacAddr($("#ApCliBssid").val()))
			return false;
	}		

    /*	
	var p = v_WdsList.split(" ");
	for (var i=0; i<p.length; i++){
		if ($("#ApCliBssid").val()==p[i]){
			alert(JS_msg29);
			return false;
		}
	}
	*/
	
	var macVal=$("#ApCliBssid").val();
	//if (rules_num==0)
		$("#WdsList").val(macVal);
	//else if (rules_num==1)	
		//$("#WdsList").val(p[0]+" "+macVal);
	//else if (rules_num==2)
		//$("#WdsList").val(p[0]+" "+p[1]+" "+macVal);
	//else if (rules_num==3)
		//$("#WdsList").val(p[0]+" "+p[1]+" "+p[2]+" "+macVal);
	
	//if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_comment,2)) return false;}	
	
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

function doSubmit(){
	if (saveChanges()==false)
		return false;
	
	var postVar ={"topicurl":"setting/setWiFiWdsAddConfig"};
	postVar['ApCliSsid'] = $('#ApCliSsid').val();
	postVar['ApCliBssid'] = $('#ApCliBssid').val();
	postVar['ApCliChannel'] = $('#ApCliChannel').val();
	postVar['ApCliAuthMode'] = $('#ApCliAuthMode').val();
	postVar['ApCliEncrypType'] = $('#ApCliEncrypType').val();
	postVar['ApCliKeyType'] = $('#ApCliKeyType').val();
	postVar['ApCliKeyStr'] = $('#ApCliKeyStr').val();
	postVar['ApCliWPAPSK'] = $('#ApCliWPAPSK').val();	
	postVar['WdsEnable'] = $('#WdsEnable').val();
	postVar['WdsList'] = $("#WdsList").val();
	postVar['comment'] = $("#comment").val();
	postVar['addEffect'] = "0";
	postVar["WiFiIdx"] = WiFiIdx;
	uiPost4(postVar);	
}

function open_site_survey(){
	openWindow("site_survey.asp","_blank",700,400);
}
</script>
</head>
<body class="mainbody">
<span id="div_body_setting">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessWdsAdd" id="wirelessWdsAdd">
<input type="hidden" id="WdsList" name="WdsList">
<input type="hidden" id="addEffect" name="addEffect" value="1">
<input type="hidden" id="WiFiIdx" name="WiFiIdx" value="0">
<input type="hidden" id="ApCliSsid" name="ApCliSsid">
<input type="hidden" id="ApCliChannel" name="ApCliChannel">
<input type="hidden" id="ApCliChannelExt" name="ApCliChannelExt">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_wds_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_wds_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="WdsEnable" id="WdsEnable" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div id="div_wds_setting" style="display:none">
<table border=0 width="100%"> 
<tr style="display:none"><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td></tr>
<tr> 
<td class="item_left"><script>dw(MM_macaddr)</script></td>
<td><input type="hidden" id="ApCliBssid" name="ApCliBssid">
<input type="text" style="width:28px" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac',1,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac',2,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac',3,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac',4,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac',5,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac',6,event)">
<script>dw('<input type=button name=scan id=scan value='+BT_scan+' onClick="open_site_survey()">')</script></td>
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
<tr style="display:none">
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" id="comment" name="comment" maxlength="20"></td>
</tr>
<tr id="div_apcli_status" style="display:none">
<td class="item_left"><script>dw(MM_connection_status)</script></td>
<td id="apcli_status">&nbsp;</td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id=del onClick="delClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type=button class=button value="'+BT_apply+'" id=add onClick="doSubmit()">')</script></td></tr>
</table>
</form>
</div>

<span style="display:none">
<form name="wirelessWdsDel" id="wirelessWdsDel">
<table border=0 width="100%" id="div_wdslist"> 
<tr><td colspan="4"><b><script>dw(MM_wds_table);dw(JS_msg70)</script></b></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center" >
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script>(BSSID)</b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" name=del_sel id=del_sel onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="del_reset" onClick="resetForm()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</span>
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
