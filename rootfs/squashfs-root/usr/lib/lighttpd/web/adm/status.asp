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
var v_ProductName,v_HardwareVersion,v_OpMode,v_PortLinkStatus,v_WanMode,v_wanPppoeMode,v_wanConnectStatus;
var v_WiFiDualband,v_HardAc,v_JSON2G,v_JSON5G;
var v_WiFiOff,v_ApcliEnable,v_WirelessMode,v_AutoChannel_no;
var v_rai_WiFiOff,v_rai_ApcliEnable,v_rai_WirelessMode;
var v_customerUrl;

function wanConnectSubmit(value){
	var postVar = {"topicurl":"setting/setManualConnect"};
	postVar["connectType"]=value;
	uiPost(postVar);
}

function showManualConnect(){
	if (v_OpMode == 1 || v_OpMode == 3){
		if (v_WanMode == "pppoe" && v_wanPppoeMode == "Manual") 
			$("#pppoeConnect,#pppoeDisconnect").show();
		else
			$("#pppoeConnect,#pppoeDisconnect").hide();
	}
}

function setPortStatusInfo(){
	if (responseJson["portlinkBt"] == 1){
		v_PortLinkStatus = responseJson['PortLinkStatus'];
		//  wan ports status
		if (v_OpMode == 0 || v_OpMode == 2 || v_OpMode == 3){
			var lanstr="LAN";
			if(v_hardAc=1){
				lanstr="LAN5";
			}
			if(v_PortLinkStatus.split(",")[0]==1){	
				$("#wan_port_img").attr("src", "../style/port_LAN_ON.gif");
				$("#wan_port_label").html(lanstr).addClass("port_link");
			}else {
				$("#wan_port_label").html(lanstr);
			}
		}else {
			if(v_PortLinkStatus.split(",")[0]==1){	
				$("#wan_port_img").attr("src", "../style/port_WAN_ON.gif");
				$("#wan_port_label").addClass("port_link");
			}
		}

		if (v_PortLinkStatus.split(",")[4]=="1"){
			 $("#lan1_port_img").attr("src", "../style/port_LAN_ON.gif");
			 $("#lan1_port_label").addClass("port_link");
		}
		if (v_PortLinkStatus.split(",")[3]=="1"){
			 $("#lan2_port_img").attr("src", "../style/port_LAN_ON.gif");
			 $("#lan2_port_label").addClass("port_link");
		}
		if (v_PortLinkStatus.split(",")[2]=="1"){
			 $("#lan3_port_img").attr("src", "../style/port_LAN_ON.gif");
			 $("#lan3_port_label").addClass("port_link");
		}
		if (v_PortLinkStatus.split(",")[1]=="1"){
			$("#lan4_port_img").attr("src", "../style/port_LAN_ON.gif");
			$("#lan4_port_label").addClass("port_link");
		}
		
		$("#div_port_status").show();
	}
}

function setSysInfo(){
	var time=responseJson['sysTime'].split(';');
	var tmp=time[0];
	if (time[0]>1)
		tmp+=MM_days+", ";
	else
		tmp+=MM_day+", ";
		
	tmp+=time[1];
	if (time[1]>1)
		tmp+=MM_hours+", ";
	else
		tmp+=MM_hour+", ";
	
	tmp+=time[2];
	if (time[2]>1)
		tmp+=MM_mins+", ";
	else
		tmp+=MM_min+", ";
		
	tmp+=time[3];
	if (time[3]>1)
		tmp+=MM_secs;
	else
		tmp+=MM_sec;
	
	$("#div_CustomerUrl").html(v_customerUrl).attr("href", "http://"+v_customerUrl);
		
	if (v_OpMode==0)
		supplyValue("div_workmode", MM_bridge_mode);
	else if (v_OpMode==1)
		supplyValue("div_workmode", MM_gateway_mode); 
	else if (v_OpMode==2)
		supplyValue("div_workmode", MM_repeater_mode); 
	else if (v_OpMode==3)
		supplyValue("div_workmode", MM_wisp_mode); 
	else if (v_OpMode==4)
		supplyValue("div_workmode", MM_marketing_mode);
		
	setJSONValue({
		"div_systime"       : tmp,
		"div_fwversion"     : responseJson['fmVersion'],
		"div_builttime"     : checkDate(responseJson['SysBuiltTime'])
	});
}

function setLanInfo(){
	setJSONValue({
		"div_lanip"      : responseJson['lanIp'],
		"div_lanmask"    : responseJson['lanMask'],
		"div_lanmac"     : responseJson['lanMac']
	});
	
	if (responseJson['dhcpEn'] == 1)
		supplyValue("div_dhcpenable", MM_enabled); 
	else
		supplyValue("div_dhcpenable", MM_disabled); 
	
	if (v_HardAc == 1 || v_OpMode == 0 || v_OpMode == 2)
		$("#div_lan_dhcpsrv").hide();	
	else
		$("#div_lan_dhcpsrv").show();	
}

function setWanInfo(){
	if (v_OpMode != 0 && v_OpMode != 2){
		$("#div_wan, #div_wan_statistics").show();
	}

	if (v_OpMode == 1){
		var time=responseJson['wanConnectTime'].split(';');
		var tmp=time[0];
		if (time[0]>1)
			tmp+=MM_days+", ";
		else
			tmp+=MM_day+", ";
			
		tmp+=time[1];
		if (time[1]>1)
			tmp+=MM_hours+", ";
		else
			tmp+=MM_hour+", ";
		
		tmp+=time[2];
		if (time[2]>1)
			tmp+=MM_mins+", ";
		else
			tmp+=MM_min+", ";
			
		tmp+=time[3];
		if (time[3]>1)
			tmp+=MM_secs;
		else
			tmp+=MM_sec;
		supplyValue("div_wanconnecttime", tmp);
		$("#div_wan_connect_time").show();
	}	
	
	v_WanMode=responseJson['wanMode'];
	v_wanPppoeMode=responseJson['wanPppoeMode'];
	v_wanConnectStatus=responseJson['wanConnectStatus'];
	showManualConnect();
	
	if (v_WanMode == "static")     supplyValue("div_wanmode", MM_staticip);
	else if (v_WanMode == "dhcp")  supplyValue("div_wanmode", "DHCP");
	else if (v_WanMode == "pppoe") supplyValue("div_wanmode", "PPPoE");
	else if (v_WanMode == "pptp")  supplyValue("div_wanmode", "PPTP");
	else if (v_WanMode == "l2tp")  supplyValue("div_wanmode", "L2TP");

	setJSONValue({
		"div_wanmac"          : responseJson['wanMac']
	});
	
	if (v_WanMode == "static"){
		setJSONValue({
			"wan_ip"         : responseJson['wan_ipaddr'],
			"wan_netmask"    : responseJson['wan_netmask'],
			"wan_gateway"    : responseJson['wan_gateway'],
			"wan_dns1"       : responseJson['wanDNS1'],
			"wan_dns2"       : responseJson['wanDNS2']
		});
	}else{
		if (v_wanConnectStatus != "MM_connected"){
			setJSONValue({
				"wan_ip"         : "0.0.0.0",
				"wan_netmask"    : "0.0.0.0",
				"wan_gateway"    : "0.0.0.0",
				"wan_dns1"       : "0.0.0.0",
				"wan_dns2"       : "0.0.0.0"
			});
		}else {
			setJSONValue({
				"wan_ip"         : responseJson['wanIp'],
				"wan_netmask"    : responseJson['wanMask'],
				"wan_gateway"    : responseJson['wanGW'],
				"wan_dns1"       : responseJson['wanDNS1'],
				"wan_dns2"       : responseJson['wanDNS2']
			});
		}
	}
	
	if (v_OpMode == 1 || v_OpMode == 3){
		if (v_WanMode == "pppoe" && v_wanPppoeMode == "Manual") {
			$("#div_pppoe_manaul").show();
			if (v_wanConnectStatus == "MM_disconnected") {
				setDisabled("#pppoeConnect", false);
				setDisabled("#pppoeDisconnect", true);
			}else {
				setDisabled("#pppoeConnect", true);
				setDisabled("#pppoeDisconnect", false);		
			}
		}
		if (responseJson['wanDNS2'] != "") $("#div_dns2").show();
	}
	
	if (v_wanConnectStatus=="MM_disconnected_info1"){
		$("#div_wanstatus").html(MM_disconnected_info1);
	}else if (v_wanConnectStatus=="MM_disconnected_info2"){
		$("#div_wanstatus").html(MM_disconnected_info2);
	}else if (v_wanConnectStatus=="MM_disconnected_info3"){
		$("#div_wanstatus").html(MM_disconnected_info3);
	}else if (v_wanConnectStatus=="MM_disconnected_info4"){
		$("#div_wanstatus").html(MM_disconnected_info4);
	}else if (v_wanConnectStatus=="MM_connected"){
		$("#div_wanstatus").html(MM_connected);
	}else if (v_wanConnectStatus=="MM_disconnected"){
		$("#div_wanstatus").html(MM_disconnected);
	}else if (v_wanConnectStatus=="MM_unknown"){
		$("#div_wanstatus").html(MM_unknown);
	}
}

function setWirelessMode(mode){
	switch(mode){
		case '0':
			return "2.4GHz (B+G)";
			break;
		case '1':
			return "2.4GHz (B)";
			break;
		case '4':
			return "2.4GHz (G)";
			break;
		case '6':
			return "2.4GHz (N)";
			break;
		case '9':
			return "2.4GHz (B+G+N)";
			break;
		case '2':
			return "802.11A";
			break;
		case '8':
			return "802.11A/N";
			break;
		case '14':
			return "802.11A/N/AC";
			break;
		default:
			return "2.4GHz (B+G+N)";
			break;
	}
}

function showWiFiAuthMode(auth_mode,encryp_type){
	if (auth_mode=="NONE")
		return MM_disable;
	else if (encryp_type=="WEP"){ 	
		if (auth_mode=="OPEN") 
			return ("WEP-"+MM_open_system);
		else
			return ("WEP-"+MM_shared_key);
	}
	else if (auth_mode=="WPAPSK") 
		return "WPA-PSK";
	else if (auth_mode=="WPA2PSK")  
		return "WPA2-PSK";
	else if (auth_mode=="WPAPSKWPA2PSK")	 
		return "WPA/WPA2-PSK";
	else 
		return MM_disable;

}

function setWlanInfo(){
	v_JSON2G=responseJson['APS2G'];
	v_WiFiOff = v_JSON2G['WiFiOff'];
	v_AutoChannel_no = v_JSON2G['AutoChannelNo'];
	v_WirelessMode = v_JSON2G['WirelessMode'];

	if (v_WiFiDualband==0){
		$("#show_wlan_txrx").html(MM_wlan);
		$("#show_wlan_lable").html(MM_wireless_info);
		$("#show_repeater_lable").html(MM_repeater_connection_status);
	}else {
		$("#show_wlan_txrx").html(MM_wlan_24g);
		$("#show_wlan_lable").html(MM_wireless_info_24g);
		$("#show_multipleap_lable1").html(MM_multipleap_info_24g);
		$("#show_multipleap_lable2").html(MM_multipleap_info_24g);
		$("#show_repeater_lable").html(MM_repeater_connection_status_24g);
	}
	
	if (v_WiFiOff==0){
		supplyValue("div_wifioff",MM_enabled);
	}else{
		supplyValue("div_wifioff",MM_disabled);
	}
	if (v_WiFiOff==1) return;

	$("#div_wifimode").html(setWirelessMode(v_WirelessMode));
	
	var ssid=v_JSON2G['SSIDS'][0]['SSID'].replace(eval("/&/gi"),'&amp;');
	supplyValue("div_ssid", ssid.replace(eval("/ /gi"),'&nbsp;'));
	
	if (v_JSON2G['Channel']==0){
		supplyValue("div_channel",MM_auto_select+'('+v_AutoChannel_no+')');
	}else{
		supplyValue("div_channel",v_JSON2G['Channel']);
	}

	$("#div_authmode").html(showWiFiAuthMode(v_JSON2G['SSIDS'][0]['AuthMode'],v_JSON2G['SSIDS'][0]['EncrypType']));
	supplyValue("div_wifimac",v_JSON2G['SSIDS'][0]['wlanMAC']);
	supplyValue("div_sta_associated_num",v_JSON2G['SSIDS'][0]['sta_associated_num']);
	
	$("#div_wireless, #div_wlan_statistics").show();
}

function setWlanInfo_5g(){
	if (v_WiFiDualband==0) return;	
	
	v_JSON5G=responseJson['APS5G'];
	v_rai_WiFiOff = v_JSON5G['WiFiOff'];
	
	if (v_rai_WiFiOff==1) return;
	
	v_rai_WirelessMode = v_JSON5G['WirelessMode'];
	var ssid1=v_JSON5G['SSIDS'][0];

	if (v_rai_WiFiOff==0){
		supplyValue("div_wifioff5g",MM_enabled);
	}else{
		supplyValue("div_wifioff5g",MM_disabled);
	}

	$("#div_wifimode5g").html(setWirelessMode(v_rai_WirelessMode));
	
	var rai_ssid=ssid1['SSID'].replace(eval("/&/gi"),'&amp;');
	supplyValue("div_ssid5g", rai_ssid.replace(eval("/ /gi"),'&nbsp;'));
	
	if (v_JSON5G['Channel']==0){
		supplyValue("div_channel5g",MM_auto_select);
	}else{
		supplyValue("div_channel5g",v_JSON5G['Channel']);
	}

	$("#div_authmode5g").html(showWiFiAuthMode(ssid1['AuthMode'],ssid1['EncrypType']));
	supplyValue("div_wifimac5g",ssid1['wlanMAC']);
	supplyValue("div_sta_associated_num5g",ssid1['sta_associated_num']);
	
	$("#div_wireless5g, #div_wlan_statistics5g").show();
}

function showApcliStatus(id,ssid,val) {
	switch (val){
		case 0:
			$(id).html(MM_connection_fail);	
			break;
		case 1:
			$(id).html(MM_connection_success);	
			break;
		case 2:
			$(id).html(MM_noconnection);	
			break;
		default:
			$(id).html(MM_noconnection);	
			break;					
	}

	if (ssid==""){
		$(id).html(MM_noconnection);	
	}
}

function setReapeaterInfo(){	
	if (v_WiFiOff==1) return;
		
	v_ApcliEnable=v_JSON2G['ApCliEnable'];
	if (v_WiFiOff==0&&v_ApcliEnable==1){
		var apclissid=v_JSON2G['ApCliSsid'].replace(eval("/&/gi"),'&amp;');
		if (v_JSON2G['ApCliSsid']!=""){
			apclissid = v_JSON2G['ApCliSsid'].replace(eval("/&/gi"),'&amp;');
			supplyValue("div_apcli_ssid", apclissid.replace(eval("/ /gi"),'&nbsp;'));
		}else{
			supplyValue("div_apcli_ssid", "Repeater RPT");
		}
		
		if (v_JSON2G['ApCliBssid']==""){
			supplyValue("div_apcli_bssid","00:00:00:00:00:00");
		}else{
			supplyValue("div_apcli_bssid",v_JSON2G['ApCliBssid']);
		}
	
		$("#div_apcli_authmode").html(showWiFiAuthMode(v_JSON2G['ApCliAuthMode'],v_JSON2G['ApCliEncrypType']));

		$("#div_repeater").show();
		showApcliStatus("#div_apcli_status",v_JSON2G['ApCliSsid'],parseInt(v_JSON2G['ApCliStatus']));
	}
}

function setReapeaterInfo_5g(){	
	if (v_rai_WiFiOff==1) return;

	v_rai_ApcliEnable=v_JSON5G['ApCliEnable'];
	if (v_rai_WiFiOff==0&&v_rai_ApcliEnable==1){
		var rai_apclissid=v_JSON5G['ApCliSsid'].replace(eval("/&/gi"),'&amp;');
		if (v_JSON5G['ApCliSsid']!=""){
			apclissid = v_JSON5G['ApCliSsid'].replace(eval("/&/gi"),'&amp;');
			supplyValue("div_apcli_ssid5g", apclissid.replace(eval("/ /gi"),'&nbsp;'));
		}else{
			supplyValue("div_apcli_ssid5g", "Repeater RPT");
		}
		
		if (v_JSON5G['ApCliBssid']==""){
			supplyValue("div_apcli_bssid5g","00:00:00:00:00:00");
		}else{
			supplyValue("div_apcli_bssid5g",v_JSON5G['ApCliBssid']);
		}

		$("#div_apcli_authmode5g").html(showWiFiAuthMode(v_JSON5G['ApCliAuthMode'],v_JSON5G['ApCliEncrypType']));

		$("#div_repeater5g").show();
		showApcliStatus("#div_apcli_status5g",v_JSON5G['ApCliSsid'],parseInt(v_JSON5G['ApCliStatus']));
	}
}

function setUsbInfo(){
	if(usb_state==1) $("#div_diskinfo").show();
}

function setStatisticsInfo(){
	setJSONValue({
		"div_wanrx"     : responseJson['wanRx'],
		"div_wantx"     : responseJson['wanTx'],
		"div_lanrx"     : responseJson['lanRx'],
		"div_lantx"     : responseJson['lanTx'],
		"div_wlanrx"    : responseJson['wlanRx'],
		"div_wlantx"    : responseJson['wlanTx'],
		"div_wlanrx5g"  : responseJson['wlanRx5g'],
		"div_wlantx5g"  : responseJson['wlanTx5g']
	});
}

function showApcliAuthMode(auth_mode,encryp_type){
	if (encryp_type=="NONE")
		supplyValue("div_apcli_mode", MM_disable);
	else if (auth_mode=="OPEN" || auth_mode=="SHARED"){ 
		if (auth_mode=="OPEN")
			supplyValue("div_apcli_mode", "WEP"+MM_open_system);
		else
			supplyValue("div_apcli_mode", "WEP"+MM_shared_key);
	}
	else if (auth_mode=="WPAPSK")
		supplyValue("div_apcli_mode", "WPA-PSK");
	else if (auth_mode=="WPA2PSK")
		supplyValue("div_apcli_mode", "WPA2-PSK");
	else
		supplyValue("div_apcli_mode", MM_disable);
}

function setApNameInfo()
{
	setJSONValue({
		'ID_APNAME' : responseJson['ApName'],
		'BT_APNAME' : BT_modify
	});

	if(v_HardAc==1){
		$("#TR_APNAME").show();
	}
}

function initValue(){
    v_customerUrl = responseJson['customerUrl'];	
	v_OpMode = responseJson['OperationMode'];	
	v_ProductName = responseJson['productName'];
	v_HardwareVersion = responseJson['hardwareVersion'];
	v_WiFiDualband = responseJson['wifiDualband'];
	v_HardAc = responseJson['hardAc'];

	setWlanInfo();
	setReapeaterInfo();
	if(v_WiFiDualband==1){
		setWlanInfo_5g();
		setReapeaterInfo_5g();
	}
	
	setPortStatusInfo();
	setSysInfo();
	setLanInfo();
	setWanInfo();
	setStatisticsInfo();
	setApNameInfo();

	try{ 
		parent.frames["title"].initValue();
	}catch(e){}
}

$(function(){
	var postVar = { topicurl : "setting/getSysStatusUICfg"};
	postVar = JSON.stringify(postVar);
	$.when( $.post( " /cgi-bin/cstecgi.cgi", postVar))
	.done(function( Data) {
		responseJson = JSON.parse(Data);
		initValue();
	})
	.fail(function(){
		resetForm();
	});
});
function setApName()
{
	var postVar ={"topicurl":"setting/setApName"};
	postVar['APName'] = $('#ID_APNAME').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_system_status)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_system_status)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div id="div_port_status" style="display:none">
<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td><img id="wan_port_img" src='../style/port_Default.gif'></td>
<td width=10></td>
<td><img id="lan4_port_img" src='../style/port_Default.gif'></td>
<td><img id="lan3_port_img" src='../style/port_Default.gif'></td>
<td><img id="lan2_port_img" src='../style/port_Default.gif'></td>
<td><img id="lan1_port_img" src='../style/port_Default.gif'></td>
</tr>
<tr align=center>
<td><span id="wan_port_label" class="port_default">WAN</span></td>
<td></td>
<td><span id="lan4_port_label" class="port_default">LAN4</span></td>
<td><span id="lan3_port_label" class="port_default">LAN3</span></td>
<td><span id="lan2_port_label" class="port_default">LAN2</span></td>
<td><span id="lan1_port_label" class="port_default">LAN1</span></td>
</tr>
</table><br>
</div>

<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_system_info)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_system_uptime)</script></td>
<td><span id="div_systime"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_customer_urlTitle)</script></td>
<td><a id="div_CustomerUrl" href="" target="_blank"></a></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_firmware_version)</script></td>
<td><span id="div_fwversion"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_build_time)</script></td>
<td><span id="div_builttime"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_work_mode)</script></td>
<td><span id="div_workmode"></span></td>
</tr>
</table></td></tr>
</table>

<div id="div_wan" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_wan_info)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_connection_status)</script></td>
<td>
<font color="#ff0000"><span id="div_wanmode"></span>&nbsp;&nbsp;&nbsp;<span id="div_wanstatus"></span></font>
<div id="div_pppoe_manaul" style="display:none"><script>dw('<input type=button id=pppoeConnect value="'+BT_connect+'" onClick=wanConnectSubmit("3")>&nbsp;&nbsp;\
<input type=button id=pppoeDisconnect value="'+BT_disconnect+'" onClick=wanConnectSubmit("4")>')</script></div></td>
</tr>
<tr id="div_wan_connect_time" style="display:none">
<td class="item_left"><script>dw(MM_connection_time)</script></td>
<td><span id="div_wanconnecttime"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><span id="wan_ip"> </span> </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><span id="wan_netmask"> </span> </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_default_gateway)</script></td>
<td><span id="wan_gateway"> </span> </td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_dns_server)</script></td>
<td><span id="wan_dns1"> </span> <span id="div_dns2" style="display:none">/ <span id="wan_dns2"> </span></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_macaddr)</script></td>
<td><span id="div_wanmac"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<div id="div_wireless5g" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2>5G <script>dw(MM_wireless_info)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_wireless_status)</script></td>
<td><span id="div_wifioff5g"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><span id="div_ssid5g"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_band)</script></td>
<td><span id="div_wifimode5g"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_channel)</script></td>
<td><span id="div_channel5g"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><span id="div_authmode5g"></span></td>
</tr>
<tr>
<td class="item_left">BSSID</td>
<td><span id="div_wifimac5g"></span></td>
</tr>
<tr style="">
<td class=item_left><script>dw(MM_associated_clients)</script></td>
<td><span id="div_sta_associated_num5g"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<div id="div_wireless" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><span id="show_wlan_lable"></span></td></tr>
<tr><td><table class="list1">
<tr id="TR_APNAME" style="display:none">
<td class="item_left"><script>dw(MM_apname)</script></td>
<td>
	<input type=text id="ID_APNAME" name="ID_APNAME" />&nbsp;&nbsp;
	<input type=button id="BT_APNAME" name="BT_APNAME" value="Modify" onClick="setApName();" />
</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_wireless_status)</script></td>
<td><span id="div_wifioff"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><span id="div_ssid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_band)</script></td>
<td><span id="div_wifimode"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_channel)</script></td>
<td><span id="div_channel"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><span id="div_authmode"></span></td>
</tr>
<tr>
<td class="item_left">BSSID</td>
<td><span id="div_wifimac"></span></td>
</tr>
<tr style="">
<td class=item_left><script>dw(MM_associated_clients)</script></td>
<td><span id="div_sta_associated_num"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<div id="div_repeater5g" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2>5G <script>dw(MM_repeater_connection_status)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><span id="div_apcli_ssid5g"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><span id="div_apcli_authmode5g"></span></td>
</tr>
<tr>
<td class="item_left">BSSID</td>
<td><span id="div_apcli_bssid5g"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_status)</script></td>
<td><span id="div_apcli_status5g"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<div id="div_repeater" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><span id="show_repeater_lable"></span></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><span id="div_apcli_ssid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><span id="div_apcli_authmode"></span></td>
</tr>
<tr>
<td class="item_left">BSSID</td>
<td><span id="div_apcli_bssid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_status)</script></td>
<td><span id="div_apcli_status"></span></td>
</tr>
</table></td></tr>
</table>
</div>

<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_lan_info)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><span id="div_lanip"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><span id="div_lanmask"></span></td>
</tr>
<tr id="div_lan_dhcpsrv">
<td class="item_left"><script>dw(MM_dhcp_server)</script></td>
<td><span id="div_dhcpenable"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_macaddr)</script></td>
<td><span id="div_lanmac"></span></td>
</tr>
</table></td></tr>
</table>

<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_statistics)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left">&nbsp;</td>
<td><b><script>dw(MM_rx_packets)</script></b></td>
<td><b><script>dw(MM_tx_packets)</script></b></td>
</tr>
<tr id="div_wan_statistics" style="display:none">
<td class="item_left"><b>WAN</b></td>
<td><span id="div_wanrx"></span></td>
<td><span id="div_wantx"></span></td>
</tr>
<tr>
<td class="item_left"><b>LAN</b></td>
<td><span id="div_lanrx"></span></td>
<td><span id="div_lantx"></span></td>
</tr>
<tr id="div_wlan_statistics" style="display:none">
<td class="item_left"><b><span id="show_wlan_txrx"></span></b></td>
<td><span id="div_wlanrx"></span></td>
<td><span id="div_wlantx"></span></td>
</tr>
<tr id="div_wlan_statistics5g" style="display:none">
<td class="item_left"><b><script>dw(MM_wlan)</script>(5G)</b></td>
<td><span id="div_wlanrx5g"></span></td>
<td><span id="div_wlantx5g"></span></td>
</tr>
</table></td></tr>
</table>

<div id="div_diskinfo" style="display:none">
<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_usbinfo)</script></td></tr>
<tr><td><table id="div_diskinfotb" class="list1">
<tr>
<td class="item_left">&nbsp;</td>
<td><b><script>dw(MM_partition_name)</script></b></td>
<td><b><script>dw(MM_total_size)</script></b></td>
<td><b><script>dw(MM_used_size)</script></b></td>
<td><b><script>dw(MM_free_size)</script></b></td>
<td><b><script>dw(MM_usage_percentage)</script></b></td>
</tr>
</table></td></tr>
</table>
</div>
<script>showFooter()</script>
</body></html>
