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
var v_WiFiOff,v_Channel,v_WirelessMode,v_BssidNum,v_AuthMode,v_EncrypType,v_SSIDS, v_AutoChannel_no;
var v_ApCliEnable,v_ApCliAuthMode,v_ApCliEncrypType,v_ApCliSsid,v_ApCliBssid,v_ApCliStatus;
var rules_num=0;

function showWiFiBand(phy_mode){
	if (phy_mode==0)
		return "2.4GHz (B+G)";
	else if (phy_mode==1)	 
		return "2.4GHz (B)";
	else if (phy_mode==4)
		return "2.4GHz (G)";
	else if (phy_mode==9)
		return "2.4GHz (B+G+N)";
	else if (phy_mode==2) 
		return "802.11A";
	else if (phy_mode==8) 
		return "802.11A/N";
	else if (phy_mode==14) 
		return "802.11A/N/AC";
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

function showApcliAuthMode(auth_mode,encryp_type){
	if (encryp_type=="NONE")
		supplyValue("div_apcli_authmode", MM_disable);
	else if (encryp_type=="WEP"){ 
		if (auth_mode=="OPEN")
			supplyValue("div_apcli_authmode", "WEP"+MM_open_system);
		else
			supplyValue("div_apcli_authmode", "WEP"+MM_shared_key);
	}
	else if (auth_mode=="WPAPSK") 
		supplyValue("div_apcli_authmode", "WPA-PSK");
	else if (auth_mode=="WPA2PSK")  
		supplyValue("div_apcli_authmode", "WPA2-PSK");
	else
		supplyValue("div_apcli_authmode", MM_disable);
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

function showMultiAp()
{
	var tb_tmp="",j=0,tmp,tmp_ap;
	
	for(var i=1;i<v_SSIDS.length;i++){
		tmp_ap=v_SSIDS[i];
		
		tb_tmp+='<br><table border=0 class="list"><tr><td class=item_head2>';
		tb_tmp += MM_multipleap_info+i+'</td></tr><tr><td><table class="list1">';
		if (tmp_ap['SSIDOff']==0){
			tmp=MM_enabled;
		}else{
			tmp=MM_disabled;
		}
		tb_tmp += '<tr><td class="item_left">' + MM_wireless_status + '</td><td>' + tmp + '</td></tr>';
		
		tmp = tmp_ap['SSID'].replace(eval("/&/gi"),'&amp;');
		tmp = tmp.replace(eval("/ /gi"),'&nbsp;');
		
		tb_tmp += '<tr><td class="item_left">' + MM_ssid + '</td><td>'+tmp+'</td></tr>';
		
		tb_tmp += '<tr><td class="item_left">' + MM_band + '</td><td>'+v_WirelessMode+'</td></tr>';
		
		tb_tmp += '<tr><td class="item_left">' + MM_security_mode + '</td><td>'+showWiFiAuthMode(tmp_ap['AuthMode'],tmp_ap['EncrypType'])+'</td></tr>';
		
		tb_tmp += '<tr><td class="item_left">BSSID</td><td>'+tmp_ap['wlanMAC']+'</td></tr>';
		
		tb_tmp += '<tr><td class="item_left">'+MM_associated_clients+'</td><td>'+tmp_ap['sta_associated_num']+'</td></tr>';
		tb_tmp += '</table></td></tr></table>'
	}
	
	$("#div_mssid").html(tb_tmp);
}

function initValue(){
	v_Channel = responseJson['Channel'];
	v_AutoChannel_no = responseJson['AutoChannelNo'];
	v_WirelessMode = showWiFiBand(responseJson['WirelessMode']);
	v_BssidNum = responseJson['BssidNum'];
	
	v_ApCliEnable = responseJson['ApCliEnable'];
	v_ApCliAuthMode = responseJson['ApCliAuthMode'];
	v_ApCliEncrypType = responseJson['ApCliEncrypType'];
	v_ApCliSsid = responseJson['ApCliSsid'];
	v_ApCliBssid = responseJson['ApCliBssid'];
	v_ApCliStatus = responseJson['ApCliStatus'];
	v_SSIDS = responseJson['SSIDS'];
	
	var ssid0 = v_SSIDS[0];
	v_WiFiOff = ssid0['SSIDOff'];
	v_SSID = ssid0['SSID'];
	v_AuthMode = ssid0['AuthMode'];
	v_EncrypType = ssid0['EncrypType'];
	
	var ssid,apcli_ssid;
	if (v_SSID!=""){
		ssid = v_SSID.replace(eval("/&/gi"),'&amp;');
		ssid = ssid.replace(eval("/ /gi"),'&nbsp;');
		supplyValue("div_ssid", ssid);
	}else{
		supplyValue("div_ssid", "");
	}
	
	setJSONValue({
		'div_wifimac'				:	ssid0['wlanMAC'],
		'div_associated_sta1'    :   ssid0['sta_associated_num'],
		'div_stationList'       	:   MM_stationList,
		'div_associated_clients'	:   MM_associated_clients
	});
	
	var totalStaNum=0;
	for(var i=0;i<v_SSIDS.length;i++){
		totalStaNum+=parseInt(v_SSIDS[i]['sta_associated_num']);
	}
	supplyValue('div_sta_associated_num', totalStaNum);
	
	if (v_ApCliSsid!=""){
		apcli_ssid = v_ApCliSsid.replace(eval("/&/gi"),'&amp;');
		apcli_ssid = apcli_ssid.replace(eval("/ /gi"),'&nbsp;');
		supplyValue("div_apcli_ssid", apcli_ssid);
	}else{
		supplyValue("div_apcli_ssid", "Repeater RPT");
	}

	if (v_ApCliBssid==""){
		supplyValue("div_apcli_bssid", "00:00:00:00:00:00");
	}else{
		supplyValue("div_apcli_bssid", v_ApCliBssid);
	}

	if (v_Channel==0){
		supplyValue("div_channel", MM_auto_select+'('+v_AutoChannel_no+')');
	}else{
		supplyValue("div_channel", v_Channel);
	}
	
	$("#div_band0").html(v_WirelessMode);
	$("#div_authmode0").html(showWiFiAuthMode(v_AuthMode,v_EncrypType));
	showApcliAuthMode(v_ApCliAuthMode,v_ApCliEncrypType);
	
	if (v_WiFiOff==0&&v_ApCliEnable==1){
		$("#div_repeater").show();
		showApcliStatus(v_ApCliSsid,parseInt(v_ApCliStatus));				
	}
	
	if (v_WiFiOff==0){
		supplyValue("div_status", MM_enabled);
		if(v_SSIDS.length > 1){
			showMultiAp();
		}
	}
	else{
		supplyValue("div_status", MM_disabled);
	}
	
	$("#div_staList").show();
}

var WiFiIdx="0";
var responseJsonIdx;
var wifiFlag=0;
function wifiStainfo(){
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
		
	var postVar = { "topicurl" : "setting/getWiFiApInfo"};
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

	var postVarList = { "topicurl" : "setting/getWiFiStaInfo"};
	postVarList["WiFiIdx"] = WiFiIdx;
    postVarList = JSON.stringify(postVarList);
	$.ajax({  
       	type : "post",  
        	url : " /cgi-bin/cstecgi.cgi",  
        	data : postVarList,  
        	async : false,  
        	success : function(Data){
			if (Data!="[]"){
				var rJson = JSON.parse(Data);
				rules_num = rJson.length;
				var tmpJson;
				var strTmp="";
				var strRssi=100;
				for(var i=0;i<rules_num;i++){
					tmpJson=rJson[i];		
					strTmp="<tr align=\"center\">\n";
					strTmp+="<td>"+tmpJson['MAC']+"</td>\n";//mac
					strTmp+="<td>"+tmpJson['MODE']+"</td>\n";//mode
					strTmp+="<td>"+tmpJson['BW']+"</td>\n";//bw
					strTmp+="<td align=left><table><tr>";
					var rssi = parseInt(tmpJson['RSSI']*2.5);//(95+(rssi-95))*100/40
					
					if (rssi>=100){
						strRssi = 100;
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div class=rssi4></div></td><td><div class=rssi5></div></td><td>"+strRssi+"%</td>";
					}else if(rssi>=80){
						strRssi = rssi-80;
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div class=rssi4></div></td><td><div style=\"width:"+strRssi+"px;height:20px;background-color:#0047af;\"></div></td><td>"+rssi+"%</td>";
					}else if(rssi>=60){
						strRssi = rssi-60;
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div style=\"width:"+strRssi+"px;height:20px;background-color:#005fbc;\"></div></td><td>"+rssi+"%</td>";
					}else if(rssi>=40){
						strRssi = rssi-40;
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div style=\"width:"+strRssi+"px; height:20px;background-color:#0083d2;\"></div></td><td>"+rssi+"%</td>";
					}else if(rssi>=20){
						strRssi = rssi-20;
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div style=\"width:"+strRssi+"px;height:20px;background-color:#00a5e6;\"></div></td><td>"+rssi+"%</td>";
					}else{
						strRssi = rssi;
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div style=\"width:"+strRssi+"px;height:20px;background-color:#00c8fb;\"></div></td><td>"+rssi+"%</td>";
					}
					
					strTmp+="</tr></table></td>\n";	
					strTmp+="<td>"+tmpJson['TIME']+"</td>\n";
					strTmp+="</tr>";
					$("#div_stalist").after(strTmp);
				}
			}			
		}
    });
	initValue();
}
</script>
</head>
<body class="mainbody" onload="wifiStainfo();">
<script>showToper()</script>
<script>showContainer()</script>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_wireless_status)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_wireless_status)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_wireless_info)</script></td></tr>
<tr><td><table class="list1">
<tr>
<td class="item_left"><script>dw(MM_wireless_status)</script></td>
<td><span id="div_status"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ssid)</script></td>
<td><span id="div_ssid"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_band)</script></td>
<td><span id="div_band0"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_channel)</script></td>
<td><span id="div_channel"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_security_mode)</script></td>
<td><span id="div_authmode0"></span></td>
</tr>
<tr>
<td class="item_left">BSSID</td>
<td><span id="div_wifimac"></span></td>
</tr>
<tr><td class="item_left"><script>dw(MM_associated_clients)</script></td>
<td><span id="div_associated_sta1"></span></td>
</tr>
</table></td></tr>
</table>

<span id="div_mssid">&nbsp;</span>

<span id="div_repeater" style="display:none"><br>
<table border=0 class="list">
<tr><td class=item_head2><script>dw(MM_repeater_connection_status)</script></td></tr>
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
<td><span id="apcli_status"></span></td>
</tr>
</table></td></tr>
</table>
</span>

<br>
<table id="div_staList" border=0 width="100%" style="display:none">
<tr><td colspan="6" class="item_head">
<span id="div_stationList"></span>
<span>(</span>
<span id="div_associated_clients"></span>
<span>:</span>
<span id="div_sta_associated_num"></span>
<span>)</span>
</td></tr>
<tr><td colspan="6"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center" id="div_stalist">
<td class="item_center" style="display:none"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_band_width)</script></b></td>
<td class="item_center"><b><script>dw(MM_signal)</script></b></td>
<td class="item_center"><b><script>dw(MM_connected_time)</script></b></td>
</tr>
</table>
<br>
<script>showFooter()</script>
</body></html>