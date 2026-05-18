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
var responseJson,responseMacJson;
var v_opmode,v_wan_mode,v_lanip,v_dns_mode;
var v_pppoeRelayb,v_pppoe_stype,v_pppoe_opmode,v_pppoeConnectStatus,v_pppoeSpecType_show;
var v_wanip,v_wanmask,v_wangateway,v_wanpridns,v_wansecdns,v_ipmode=1; 
var v_pptpb,v_pptpMode,v_pptp_ip,v_pptp_mask,v_pptp_gateway,v_pptp_server;
var v_l2tpb,v_l2tpMode,v_l2tp_ip,v_l2tp_mask,v_l2tp_gateway,v_l2tp_server;   
var v_cloneMac,v_defMac;
var pppConnectStatus=0;  
function cloneMacClick(){
	setDisabled("#cloneMacBtn",true);
	setDisabled("#factoryMacBtn",false);
	var postVar = {topicurl : "setting/getStationMacByIp"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseMacJson = JSON.parse(Data);							
		}
    });	
	
	var macArr = responseMacJson['stationMac'];
	supplyValue("macCloneMac",macArr);
	var mac=macArr.split(":");
	$("#mac1").val(mac[0]);$("#mac2").val(mac[1]);$("#mac3").val(mac[2]);$("#mac4").val(mac[3]);$("#mac5").val(mac[4]);$("#mac6").val(mac[5]);
}
function factoryMacClick(){
	setDisabled("#factoryMacBtn",true);
	setDisabled("#cloneMacBtn",false);
	var macArr = responseJson['defaultMac'];
	supplyValue("macCloneMac",macArr);
	var mac=macArr.split(":");
	$("#mac1").val(mac[0]);$("#mac2").val(mac[1]);$("#mac3").val(mac[2]);$("#mac4").val(mac[3]);$("#mac5").val(mac[4]);$("#mac6").val(mac[5]);
}
function setValAttr(objectID){
	$("#"+objectID).val("");
	$("#"+objectID).focus();	
}
function saveChanges(){	
	setJSONValue({
		'priDns'		:	combinIP($(":input[name=wanpridns]")),
		'secDns'		:	combinIP($(":input[name=wansecdns]")),			
		'staticIp'		:	combinIP($(":input[name=ip]")),
		'staticNetmask'	:	combinIP($(":input[name=mask]")),
		'staticGateway'	:	combinIP($(":input[name=gateway]")),	
				
		'l2tpIp'		:	combinIP($(":input[name=l2tp_ip]")),
		'l2tpNetmask'	:	combinIP($(":input[name=l2tp_mask]")),
		'l2tpGateway'	:	combinIP($(":input[name=l2tp_gateway]")),
		'l2tpServer'	:	combinIP($(":input[name=l2tp_server]")),			
		'pptpIp'		:	combinIP($(":input[name=pptp_ip]")),
		'pptpNetmask'	:	combinIP($(":input[name=pptp_mask]")),
		'pptpGateway'	:	combinIP($(":input[name=pptp_gateway]")),
		'pptpServer'	:	combinIP($(":input[name=pptp_server]")),
	
		'macCloneMac'	:	combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val())
	});

	if ($("#connectionType").val() == "static"){
		if (!checkVaildVal.IsVaildIpAddr($("#staticIp").val(),MM_ipaddr)) return false;
		if (!checkVaildVal.IsSameIp($("#staticIp").val(), v_lanip)){alert(JS_msg44);return false}
		if (!checkVaildVal.IsVaildMaskAddr($("#staticNetmask").val(), MM_netmask)) return false;
		if (!checkVaildVal.IsVaildIpAddr($("#staticGateway").val(),MM_default_gateway)) return false;   
		if (!checkVaildVal.IsIpSubnet($("#staticGateway").val(), $("#staticNetmask").val(), $("#staticIp").val())) {alert(JS_msg45);return false;}		
		if ($("#staticGateway").val() == $("#staticIp").val()){alert(JS_msg46);return false;}
		if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_pridns)) return false;  
		if ($("#secDns").val() != ""){	if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_secdns)) return false;}
		if (!checkVaildVal.IsVaildNumber($("#staticMtu").val(), "MTU")){setValAttr("staticMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#staticMtu").val(),"MTU", 1400, 1500)){setValAttr("staticMtu");return false;}
	}else if ($("#connectionType").val() == "dhcp"){ 
		if ($("#hostname").val() != ""){if (!checkVaildVal.IsVaildString($("#hostname").val(), MM_hostname,1)) return false;}
		if (!checkVaildVal.IsVaildNumber($("#dhcpMtu").val(), "MTU")){setValAttr("dhcpMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#dhcpMtu").val(),"MTU", 1400, 1500)) {setValAttr("dhcpMtu");return false;}
		if ($("input[name=dnsMode]:eq(1)").get(0).checked == true){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_pridns)) return false;  
			if ($("#secDns").val() != ""){if (!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_secdns)) return false;}
		}
	}else if ($("#connectionType").val() == "pppoe") { 
		if (!checkVaildVal.IsVaildString($("#pppoeUser").val(),MM_username,1)){return false;}
		if (!checkVaildVal.IsVaildString($("#pppoePass3").val(), MM_password,1)){return false;}	
		supplyValue("pppoePass",$("#pppoePass3").val());
		if (!checkVaildVal.IsVaildNumber($("#pppoeMtu").val(), "MTU")){setValAttr("pppoeMtu");return false;}	
		if (!checkVaildVal.IsVaildNumberRange($("#pppoeMtu").val(), "MTU",1400, 1492)){setValAttr("pppoeMtu");return false;}
		if ($("input[name=dnsMode]:eq(1)").get(0).checked == true){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_pridns)) return false;  
			if ($("#secDns").val() != ""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_secdns)) return false;}   
		}
	}else if ($("#connectionType").val() == "l2tp"){ 
		if (!checkVaildVal.IsVaildString($("#l2tpUser").val(), MM_username,1)){setValAttr("l2tpUser");return false;}
		if (!checkVaildVal.IsVaildString($("#l2tpPass3").val(), MM_password,1)){setValAttr("l2tpPass3");return false;}		
		supplyValue("l2tpPass",$("#l2tpPass3").val());
		if ($("input[name=l2tpMode]:eq(0)").get(0).checked == true){
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpIp").val(),MM_ipaddr))return false;
			if (!checkVaildVal.IsVaildMaskAddr($("#l2tpNetmask").val(), "L2TP "+MM_netmask))return false;
			if (!checkVaildVal.IsVaildIpAddr($("#l2tpGateway").val(),MM_default_gateway))return false;
		}		
		if (!checkVaildVal.IsVaildIpAddr($("#l2tpServer").val(),"L2TP" + MM_server_ipaddr))return false;
		if (!checkVaildVal.IsVaildNumber($("#l2tpMtu").val(), "MTU")){setValAttr("l2tpMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#l2tpMtu").val(), "MTU",546, 1492)){setValAttr("l2tpMtu");return false;}
		if ($("input[name=dnsMode]:eq(1)").get(0).checked == true){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_pridns))return false;  
			if ($("#secDns").val() != ""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_secdns))return false;}  
		}
	}else if ($("#connectionType").val() == "pptp") { 
		if (!checkVaildVal.IsVaildString($("#pptpUser").val(), MM_username,1)){setValAttr("pptpUser");return false;}		
		if (!checkVaildVal.IsVaildString($("#pptpPass3").val(), MM_password,1)){setValAttr("pptpPass3");return false;}
		supplyValue("pptpPass",$("#pptpPass3").val());
		if ($("input[name=pptpMode]:eq(0)").get(0).checked == true){
			if(!checkVaildVal.IsVaildIpAddr($("#pptpIp").val(),MM_ipaddr))return false;
			if (!checkVaildVal.IsVaildMaskAddr($("#pptpNetmask").val(), "PPTP "+MM_netmask))return false;
			if(!checkVaildVal.IsVaildIpAddr($("#pptpGateway").val(),MM_default_gateway))return false;
		}		
		if (!checkVaildVal.IsVaildIpAddr($("#pptpServer").val(), "PPTP "+MM_server_ipaddr))return false;
		if (!checkVaildVal.IsVaildNumber($("#pptpMtu").val(), "MTU")){setValAttr("pptpMtu");return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#pptpMtu").val(),"MTU", 546, 1492)){setValAttr("pptpMtu");return false;}
		if ($("input[name=dnsMode]:eq(1)").get(0).checked == true){
			if (!checkVaildVal.IsVaildIpAddr($("#priDns").val(),MM_pridns))return false;  
			if ($("#secDns").val() != ""){if(!checkVaildVal.IsVaildIpAddr($("#secDns").val(),MM_secdns))return false;}   
		}
	}
	if ($("#macCloneMac").val() != ""){if (!checkVaildVal.IsVaildMacAddr($("#macCloneMac").val(), MM_macaddr))return false;} 
	return true;
}
function l2tpModeSwitch(fg){
	if(fg)
	{	
		if (v_ipmode==0){
			
			$("#l2tpMode0").prop('checked',true);
			$("#div_l2tpIp,#div_l2tpNetmask,#div_l2tpGateway").show();
			$('#ipmode').val("static");
			$("#dnsMode1").prop('checked',true);
			$("#div_dns_mode").hide();
		}else{ 
			
			$("#l2tpMode1").prop('checked',true);
			$("#div_l2tpIp,#div_l2tpNetmask,#div_l2tpGateway").hide();
			$('#ipmode').val("dynamic");
			$("#dnsMode0").prop('checked',true);
			$("#div_dns_mode").show();
		}
	}
	else
	{
		if ($("input[name=l2tpMode]:eq(0)").get(0).checked == true){ 
			$("#div_l2tpIp,#div_l2tpNetmask,#div_l2tpGateway").show();
			$('#ipmode').val("static");
			$("#dnsMode1").prop('checked',true);
			$("#div_dns_mode").hide();
		}else{ 
			$("#div_l2tpIp,#div_l2tpNetmask,#div_l2tpGateway").hide();
			$('#ipmode').val("dynamic");
			$("#dnsMode0").prop('checked',true);
			$("#div_dns_mode").show();
		}
	}
	dnsModeSwitch();
}
function pptpModeSwitch(fg){
	if(fg)
	{	
		if (v_ipmode==0){
			$("#pptpMode0").prop('checked',true);
			$("#div_pptpIp,#div_pptpNetmask,#div_pptpGateway").show();
			$('#ipmode').val("static");
			$("#dnsMode1").prop('checked',true);
			$("#div_dns_mode").hide();	
		}else{ 		
			$("#pptpMode1").prop('checked',true);
			$("#div_pptpIp,#div_pptpNetmask,#div_pptpGateway").hide();
			$('#ipmode').val("dynamic");
			$("#dnsMode0").prop('checked',true);
			$("#div_dns_mode").show();
		}
	}
	else
	{
		if ($("input[name=pptpMode]:eq(0)").get(0).checked == true){ 
			$("#div_pptpIp,#div_pptpNetmask,#div_pptpGateway").show();
			$('#ipmode').val("static");
			$("#dnsMode1").prop('checked',true);
			$("#div_dns_mode").hide();
		}else{
			$("#div_pptpIp,#div_pptpNetmask,#div_pptpGateway").hide();
			$('#ipmode').val("dynamic");
			$("#dnsMode0").prop('checked',true);
			$("#div_dns_mode").show();
		}
	}
}
function setPPPConnected(){
   	pppConnectStatus = 1;
}
function pppoeOPModeSwitch(){
	$("#div_pppoe_manual").hide();
	if ($("#pppoeOPMode").get(0).selectedIndex == 1) {
		$("#div_pppoe_manual").show();
		if (pppConnectStatus == 0) {
			setDisabled("#pppConnect",false);
			setDisabled("#pppDisconnect",true);
		}else {
			setDisabled("#pppConnect",true);
			setDisabled("#pppDisconnect",false);
		}
	}	
}
function dnsModeSwitch(){
	if ($("input[name=dnsMode]:checked").val() == 0){	
		setDisabled(":input[name=wanpridns]",false);
		setDisabled(":input[name=wansecdns]",false);
	}else {		
		setDisabled(":input[name=wanpridns]",true);
		setDisabled(":input[name=wansecdns]",true);
	}
}
function changePasswordType(val){
	if (val==1) {
		$("#div_pppoe_pass2").hide();//p
		$("#div_pppoe_pass3").show();//t
		$("#pppoePass3").val("");
		$("#pppoePass3").focus();
	}else if (val==2) {
		$("#div_l2tp_pass2").hide();//p
		$("#div_l2tp_pass3").show();//t
		$("#l2tpPass3").val("");
		$("#l2tpPass3").focus();
	}else if (val==3) {
		$("#div_pptp_pass2").hide();//p
		$("#div_pptp_pass3").show();//t
		$("#pptpPass3").val("");
		$("#pptpPass3").focus();
	}
}
function connectionTypeSwitch(){	
	$("#div_static,#div_dhcp,#div_pppoe,#div_l2tp,#div_pptp,#div_dns,#div_dns_mode").hide();
	if ($("#connectionType").val() == "static") {			
		$("#div_static,#div_dns").show();
		supplyValue("dnsMode",0);
	}else if ($("#connectionType").val() == "dhcp") {			
		$("#div_dhcp,#div_dns,#div_dns_mode").show();
		supplyValue("dnsMode",1);
	}else if ($("#connectionType").val() == "pppoe") { 
		$("#div_pppoe,#div_dns,#div_dns_mode").show();
		supplyValue("dnsMode",1);
		pppoeOPModeSwitch();
	}else if ($("#connectionType").val() == "l2tp") {
		l2tpModeSwitch();
		$("#div_l2tp,#div_dns,#div_dns_mode").show();
		supplyValue("dnsMode",1);
	}else if ($("#connectionType").val() == "pptp") {
		pptpModeSwitch();
		$("#div_pptp,#div_dns,#div_dns_mode").show();
		supplyValue("dnsMode",1);
	}
	if(v_opmode == "3") $("#div_macclone").hide();
	dnsModeSwitch($("input[name=dnsMode]:checked").val());
}
function createWanOptions(flag){
	var new_options,new_values;
	switch(flag){
		case 0:
			new_options = [MM_staticip,"DHCP","PPPoE"];
			new_values  = ['static','dhcp','pppoe'];
			break;
		case 1:
			new_options = [MM_staticip,"DHCP","PPPoE","L2TP","PPTP"];
			new_values  = ['static','dhcp','pppoe','l2tp','pptp'];
			break;
		case 2:
			new_options = [MM_staticip,"DHCP","PPPoE","L2TP"];
			new_values  = ['static','dhcp','pppoe','l2tp'];
			break;
		case 3:
			new_options = [MM_staticip,"DHCP","PPPoE","PPTP"];
			new_values  = ['static','dhcp','pppoe','pptp'];
			break;
		default:
			new_options = [MM_staticip,"DHCP","PPPoE"];
			new_values  = ['static','dhcp','pppoe'];
			break;
	}
	CreateOptions('connectionType',new_options,new_values);
}

function wanConnStatusUpdate()
{
	var tb_tmp="", wan_proto="DHCP";
	if (v_wan_mode == "static") {
		wan_proto=MM_staticip;
	}else if (v_wan_mode == "pppoe") {
		wan_proto="PPPOE";	
	}else if (v_wan_mode == "l2tp") {		
		wan_proto="L2TP";
	}else if (v_wan_mode == "pptp") {
		wan_proto="PPTP";
	}else{
		wan_proto="DHCP";
	}
	var wanConnectStatus = v_pppoeConnectStatus == 'MM_connected' ? MM_connected : MM_disconnected;
	tb_tmp += '<tr><td class="item_left">'+MM_connection_status+'</td>';
	tb_tmp += '<td><font color="red">'+wan_proto+'  '+wanConnectStatus+'</font></td></tr>';

	//console.log(tb_tmp);
	$("#div_connection_status").html(tb_tmp);
}

function initValue(){	
	v_opmode       	=  responseJson['OperationMode'];
	v_wan_mode      =  responseJson['wanConnectionMode'];		  
	v_l2tpb         =  responseJson['l2tpBt'];
	v_pptpb       	=  responseJson['pptpBt'];
	v_pppoeRelayb  	=  responseJson['pppoeRelayBt'];
	v_pppoeConnectStatus  =  responseJson['pppoeConnectStatus'];
	v_pppoe_stype   =  responseJson['wan_pppoe_spectype'];	
	v_pppoe_opmode  =  responseJson['wan_pppoe_opmode'];
	v_pppoeSpecType_show  =  responseJson['pppoeSpecType_show'];
	
	if(v_pppoeSpecType_show == 0 ){
		document.getElementById("pppoeSpecType").style.display="none";
		document.getElementById("div_pppoe_spectype_hint").style.display="none";
	}		
	if(v_l2tpb==1 &&  v_pptpb==1){
		v_l2tpMode      =  responseJson['wan_l2tp_mode'];
		v_l2tp_ip       =  responseJson['wan_l2tp_ip'];
		v_l2tp_mask     =  responseJson['wan_l2tp_netmask'];
		v_l2tp_gateway  =  responseJson['wan_l2tp_gateway'];
		v_l2tp_server   =  responseJson['wan_l2tp_server'];
		v_pptpMode      =  responseJson['wan_pptp_mode'];
		v_pptp_ip       =  responseJson['wan_pptp_ip'];
		v_pptp_mask     =  responseJson['wan_pptp_netmask'];
		v_pptp_gateway  =  responseJson['wan_pptp_gateway'];
		v_pptp_server   =  responseJson['wan_pptp_server'];
	}
	v_wanip       	=  responseJson['wan_ipaddr'];
	v_wanmask       =  responseJson['wan_netmask'];
	v_wangateway    =  responseJson['wan_gateway'];
	v_wanpridns     =  responseJson['DNS1'];
	v_wansecdns     =  responseJson['DNS2'];
	v_dns_mode      =  responseJson['wan_dns_mode'];
	v_lanip       	=  responseJson['lanIp'];
	v_cloneMac      =  responseJson['cloneMac'];
	v_ipmode        =  responseJson['IpMode'];
	//v_defMac      	=   responseJson['defaultMac'];
	
	setJSONValue({ 
		'hostname'		:	responseJson['wan_dhcp_hn'],
		'dhcpMtu'		:	responseJson['wan_dhcp_mtu'],
		
		'staticIp'	    :   responseJson['wan_ipaddr'],
		'staticNetmask'	:   responseJson['wan_netmask'],
		'staticGateway'	:   responseJson['wan_gateway'],
		'staticMtu'     :   responseJson['wan_static_mtu'],
		
		'pppoeUser'     :   responseJson['wan_pppoe_user'],
		'pppoePass2'	:   responseJson['wan_pppoe_pass'],
		'pppoePass3'	:   responseJson['wan_pppoe_pass'],
		'pppoeSpecType'	:   responseJson['wan_pppoe_spectype'],
		'pppoeOPMode'	:   responseJson['wan_pppoe_opmode'],
		'pppoeMtu'	    :   responseJson['wan_pppoe_mtu'],
		'lcpEcho'	    :   responseJson['lcpEchoEnable'],
		
		'l2tpUser'      :   responseJson['wan_l2tp_user'],
		'l2tpPass2'	    :   responseJson['wan_l2tp_pass'],
		'l2tpPass3'	    :   responseJson['wan_l2tp_pass'],
		'l2tpMtu'	    :   responseJson['wan_l2tp_mtu'],
		'l2tpNetmask'   :   responseJson['wan_l2tp_netmask'],
		'l2tpIp'	    :   responseJson['wan_l2tp_ip'],
		'l2tpGateway'	:   responseJson['wan_l2tp_gateway'],
		'l2tpServer'    :   responseJson['wan_l2tp_server'],
			 
		'pptpUser'      :   responseJson['wan_pptp_user'],
		'pptpPass2'	    :   responseJson['wan_pptp_pass'],
		'pptpPass3'	    :   responseJson['wan_pptp_pass'],
		'pptpMtu'	    :   responseJson['wan_pptp_mtu'],
		'pptpNetmask'   :   responseJson['wan_pptp_netmask'],
		'pptpIp'	    :   responseJson['wan_pptp_ip'],
		'pptpGateway'	:   responseJson['wan_pptp_gateway'],
		'pptpServer'    :   responseJson['wan_pptp_server'],
	
		'priDns'        :   responseJson['DNS1'],
		'secDns'        :   responseJson['DNS2'],

		'specialWayEnabled'        :   responseJson['specialWayEnabled']
	}); 
	wanConnStatusUpdate();
	$("#div_connection_type").show();

	if ( responseJson['mppe'] == "1" )
		$("#mppe").prop('checked',true);

	if ( responseJson['mppc'] == "1" )
		$("#mppc").prop('checked',true);

	if (v_pppoeConnectStatus == "MM_connected")	setPPPConnected();

	if (v_opmode==3) $("#div_macclone").hide();

	if (v_l2tpb==1 && v_pptpb==1 && v_opmode !=3 ) 
		createWanOptions(1);
	else if (v_l2tpb==1 && v_pptpb==0) 
		createWanOptions(2); 
	else if (v_l2tpb==0 && v_pptpb==1)
		createWanOptions(3); 
	else if ((v_l2tpb==0 && v_pptpb==0) || v_opmode ==3 )
		createWanOptions(0);
	
	$("#div_connectionType").show();
	$("#div_static,#div_dhcp,#div_pppoe,#div_l2tp,#div_pptp,#div_dns,#div_dns_mode").hide();
	
	if (v_wan_mode == "static") {
		supplyValue("connectionType","static");
		$("#div_static,#div_dns").show();
		$("#div_dns_mode").hide();
	}else if (v_wan_mode == "pppoe") {
		supplyValue("connectionType","pppoe");
		//$("#pppoeSpecType").get(0).selectedIndex = v_pppoe_stype;
		$("#div_pppoe,#div_dns,#div_dns_mode").show();
		pppoeOPModeSwitch();
	}else if (v_wan_mode == "l2tp") {
		supplyValue("connectionType","l2tp");
		supplyValue("l2tpMode",v_l2tpMode);
		l2tpModeSwitch(1);
		$("#div_l2tp,#div_dns").show();
	}else if (v_wan_mode == "pptp") {
		supplyValue("connectionType","pptp");
		supplyValue("ipmode",v_pppoe_opmode);
		pptpModeSwitch(1);
		$("#div_pptp,#div_dns").show();
	}else{
		supplyValue("connectionType","dhcp");
		$("#div_dhcp,#div_dns,#div_dns_mode").show();
	}
	
	supplyValue("dnsMode",v_dns_mode);
	dnsModeSwitch();
	
	if (v_wanip !="") decomIP($(":input[name=ip]"),v_wanip,1);
	if (v_wanmask !="") decomIP($(":input[name=mask]"),v_wanmask,1);
	if (v_wangateway !="") decomIP($(":input[name=gateway]"),v_wangateway,1);
	if (v_l2tp_ip !="") decomIP($(":input[name=l2tp_ip]"),v_l2tp_ip,1);	
	if (v_l2tp_mask !="") decomIP($(":input[name=l2tp_mask]"),v_l2tp_mask,1);
	if (v_l2tp_gateway !="") decomIP($(":input[name=l2tp_gateway]"),v_l2tp_gateway,1);
	if (v_l2tp_server !="") decomIP($(":input[name=l2tp_server]"),v_l2tp_server,1);
	if (v_pptp_ip !="") decomIP($(":input[name=pptp_ip]"),v_pptp_ip,1);
	if (v_pptp_mask !="") decomIP($(":input[name=pptp_mask]"),v_pptp_mask,1);
	if (v_pptp_gateway !="") decomIP($(":input[name=pptp_gateway]"),v_pptp_gateway,1);
	if (v_pptp_server !="") decomIP($(":input[name=pptp_server]"),v_pptp_server,1);
	if (v_wanpridns !="") decomIP($(":input[name=wanpridns]"),v_wanpridns,1);
	if (v_wansecdns !="") decomIP($(":input[name=wansecdns]"),v_wansecdns,1);

	$("#div_pppoe_pass2,#div_pptp_pass2,#div_l2tp_pass2").show();//p
	$("#div_pppoe_pass3,#div_pptp_pass3,#div_l2tp_pass3").hide();//t
	
	if (v_pppoeRelayb==1){
		$("#div_pppoe_spectype").show();
	}else{
		$("#div_pppoe_spectype").hide();
	}
	
	if (v_opmode==3) {
		$("#div_macclone").hide();
	}else {
		$("#div_macclone").show();
	}
	
	if (v_cloneMac != "") {
		var cloneMac_tmp=v_cloneMac.split(":");
		$("#mac1").val(cloneMac_tmp[0]);
		$("#mac2").val(cloneMac_tmp[1]);
		$("#mac3").val(cloneMac_tmp[2]);
		$("#mac4").val(cloneMac_tmp[3]);
		$("#mac5").val(cloneMac_tmp[4]);
		$("#mac6").val(cloneMac_tmp[5]);
		supplyValue("macCloneMac",v_cloneMac);
		setDisabled("#factoryMacBtn",false);
	  	//setDisabled("#cloneMacBtn",true);
	}else{
		setDisabled("#factoryMacBtn",true);
		//setDisabled("#cloneMacBtn",false);
	}
}
$(function(){
	var postVar = { topicurl : "setting/getWanConfig"};
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


function win78reload(){
	var userAgent = navigator.userAgent;
	if(userAgent.indexOf("Windows NT 6.1") > -1 || userAgent.indexOf("Windows 7") > -1 || userAgent.indexOf("Windows 8") > -1){
		wtime = 46;
	}else{
		wtime = 46;
	}
	
	do_count_down();
}

function waitpage(){
	$("#div_body_setting").hide();
	$("#div_wait").show();
}
function uiPost3(postVar){
	postVar = JSON.stringify(postVar);
	//console.log(postVar);
	$(":input").attr('disabled',true);
	setTimeout('waitpage()',1500);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){

	});
	win78reload();
}
function doSubmit(){
	if(saveChanges()==false)
		return false;
		
	var postVar ={"topicurl":"setting/setWanConfig"};
	postVar['connectionType']= $('#connectionType').val();
	if($('#connectionType').val()=="static"){
		postVar['staticIp']=$('#staticIp').val();
		postVar['staticNetmask']=$('#staticNetmask').val();
		postVar['staticGateway']=$('#staticGateway').val();
		postVar['staticMtu']=$('#staticMtu').val();
	}else if($('#connectionType').val()=="dhcp"){
		postVar['hostname']=$('#hostname').val();
		postVar['dhcpMtu']=$("#dhcpMtu").val();
	}else if($('#connectionType').val()=="pppoe"){
		postVar['pppoeUser']=$('#pppoeUser').val();
		postVar['pppoePass']=$('#pppoePass3').val();
		postVar['pppoeSpecType']=$("#pppoeSpecType").val();
		postVar['pppoeOPMode']=$("#pppoeOPMode").val();
		postVar['pppoeMtu']=$('#pppoeMtu').val();
		postVar['specialWayEnabled']=$("#specialWayEnabled").val();
		postVar['lcpEchoEnable']=$('#lcpEcho').is(':checked')?"1":"0";
	}else if($('#connectionType').val()=="l2tp"){
		postVar['l2tpServer']=$('#l2tpServer').val();
		postVar['l2tpUser']=$("#l2tpUser").val();
		postVar['l2tpPass']=$('#l2tpPass3').val();
		postVar['l2tpMode']=$('#ipmode').val();
		postVar['l2tpIp']=$("#l2tpIp").val();
		postVar['l2tpNetmask']=$('#l2tpNetmask').val();
		postVar['l2tpGateway']=$('#l2tpGateway').val();
		postVar['l2tpMtu']=$("#l2tpMtu").val();
	}else if($('#connectionType').val()=="pptp"){
		postVar['pptpServer']=$('#pptpServer').val();
		postVar['pptpUser']=$("#pptpUser").val();
		postVar['pptpPass']=$('#pptpPass3').val();
		postVar['pptpMode']=$('#ipmode').val();
		postVar['pptpIp']=$("#pptpIp").val();
		postVar['pptpNetmask']=$('#pptpNetmask').val();
		postVar['pptpGateway']=$('#pptpGateway').val();
		postVar['pptpMtu']=$("#pptpMtu").val();
	//	postVar['mppe']=$("#mppe").val();
	//	postVar['mppc']=$("#mppc").val();

		if( $("#mppe").prop('checked') ){
			postVar['mppe']="1";
		}else{
			postVar['mppe']="0";
		}
		if( $("#mppc").prop('checked') ){
			postVar['mppc']="1";
		}else{
			postVar['mppc']="0";
		}

	}
	if($('input[name="dnsMode"]:checked').val()=="0"){
		postVar['dnsMode']="0";
		postVar['priDns']=$('#priDns').val();
		postVar['secDns']=$('#secDns').val();
	}else{
		postVar['dnsMode']="1";
	}
	if ($('#macCloneMac').val() != ""){
		postVar['macCloneMac']=$('#macCloneMac').val();
	}
	uiPost3(postVar);
}
function pppConnectClick(connect){
	if(saveChanges()==false)
		return false;
		
	if (pppConnectStatus == connect) {
		var postVar ={"topicurl":"setting/setWanConfig"};
		postVar['connectionType']= $('#connectionType').val();
		postVar['pppoeUser']=$('#pppoeUser').val();
		postVar['pppoePass']=$('#pppoePass3').val();
		postVar['pppoeSpecType']=$("#pppoeSpecType").val();		
		postVar['pppoeOPMode']=$('#pppoeOPMode').val();
		postVar['pppoeMtu']=$('#pppoeMtu').val();
		postVar['lcpEchoEnable']=$('#lcpEcho').is(':checked')?"1":"0";
		if ($('#macCloneMac').val() != ""){
			postVar['macCloneMac'] = $('#macCloneMac').val();
		}
		
		if(Number(connect)==0)
			postVar['pppConnect']="1";
		if(Number(connect)==1)	
			postVar['pppDisconnect']="1";
		
		if($('input[name="dnsMode"]:checked').val()=="0"){
			postVar['dnsMode']="0";
			postVar['priDns']=$('#priDns').val();
			postVar['secDns']=$('#secDns').val();
		}else{
			postVar['dnsMode']="1";
		}	
		uiPost(postVar);
	}
	else {
		return false;
	}
}
</script>
</head>
<body class="mainbody">

<input type="hidden" id="ipmode" name="ipmode">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="wanCfg" id="wanCfg">
<span id="div_body_setting">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_wan_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_wan_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tbody id="div_connection_status"></tbody>
<tr id="div_connection_type" style="display:none">
<td class="item_left"><script>dw(MM_connection_type)</script></td>
<td><select id="connectionType" name="connectionType" onChange="connectionTypeSwitch()">
</select></td>
</tr>
</table>

<table id="div_static" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="hidden" id="staticIp" name="staticIp">
<div id="staticIpLen">
<input type="text" style="width:33px" size="3" maxlength="3" id="ip1" name="ip" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="ip2" name="ip" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="ip3" name="ip" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="ip4" name="ip" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);" onblur="autoChangeMask('ip','mask');"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><input type="hidden" id="staticNetmask" name="staticNetmask">
<div id="staticMaskLen">
<input type="text" style="width:33px" size="3" maxlength="3" id="mask1" name="mask" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="mask2" name="mask" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="mask3" name="mask" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="mask4" name="mask" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_default_gateway)</script></td>
<td><input type="hidden" id="staticGateway" name="staticGateway">
<div id="staticGwLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="gateway" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" id="staticMtu" name="staticMtu" size="4" maxlength=4>&nbsp;(1400~1500)</td>
</tr>
</table>

<table id="div_dhcp" style="display:none" border=0 width="100%">
<tr style="display:none">
<td class="item_left"><script>dw(MM_hostname)</script></td>
<td><input type=text id="hostname" name="hostname" maxlength=32> (<script>dw(MM_optional)</script>)</td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" id="dhcpMtu" name="dhcpMtu" size="4" maxlength=4>&nbsp;(1400~1500)</td>
</tr>
</table>

<table id="div_pppoe" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type="text"  id="pppoeUser" name="pppoeUser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type="hidden" id="pppoePass" name="pppoePass">
<span id="div_pppoe_pass2"><input type=password id="pppoePass2" name="pppoePass2" maxlength="32" onFocus="changePasswordType(1)"></span>
<span id="div_pppoe_pass3" style="display:none"><input type=text id="pppoePass3" name="pppoePass3" maxlength="32"></span></td>
</tr>
<tr id="div_pppoe_spectype" style="display:none">
<td class="item_left" id="div_pppoe_spectype_hint"><script>dw(MM_spectype)</script></td>
<td><select id="pppoeSpecType" name="pppoeSpecType">
<option value="0"><script>dw(MM_none)</script></option>
<option value="1"><script>dw(MM_spectype)</script> 1</option>
<option value="2"><script>dw(MM_spectype)</script> 2</option>
<option value="3"><script>dw(MM_spectype)</script> 3</option>
</select></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_connection_mode)</script></td>
<td><select id="pppoeOPMode" name="pppoeOPMode" onChange="pppoeOPModeSwitch()">
<option value="KeepAlive"><script>dw(MM_keep_alive)</script></option>
<option value="Manual"><script>dw(MM_manual)</script></option>
</select>&nbsp;&nbsp;
<span id="div_pppoe_manual" style="display:none">
<script>dw('<input type="button" class="button4" id="pppConnect" name="pppConnect" value="'+BT_connect+'" onClick="pppConnectClick(0)">')</script>&nbsp;&nbsp;
<script>dw('<input type="button" class="button4" id="pppDisconnect" name="pppDisconnect" value="'+BT_disconnect+'" onClick="pppConnectClick(1)">')</script>
</span></td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" id="pppoeMtu" name="pppoeMtu" size="4" maxlength=4>&nbsp;(1400-1492)</td>
</tr>

<tr>
<td class="item_left"><script>dw(MM_lcp_echo_enabled)</script></td>
<td><input type="checkbox" id="lcpEcho"></td>
</tr>

</table>

<table id="div_l2tp" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_address_mode)</script></td>
<td><input type="radio" id="l2tpMode0" name="l2tpMode" value="0" onClick="l2tpModeSwitch()"><script>dw(MM_static)</script>
<input type="radio" id="l2tpMode" name="l2tpMode" value="1" onClick="l2tpModeSwitch()" checked><script>dw(MM_dynamic)</script></td>
</tr>
<tr id="div_l2tpIp" style="display:none">
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="hidden" id="l2tpIp" name="l2tpIp">
<div id="l2tpIpLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_ip" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr id="div_l2tpNetmask" style="display:none">
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><input type="hidden" id="l2tpNetmask" name="l2tpNetmask">
<div id="l2tpNetmaskLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_mask" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr id="div_l2tpGateway" style="display:none">
<td class="item_left"><script>dw(MM_default_gateway)</script></td>
<td><input type="hidden" id="l2tpGateway" name="l2tpGateway">
<div id="l2tpGatewayLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_gateway" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_gateway" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_gateway" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_gateway" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_server_ipaddr)</script></td>
<td><input type="hidden" id="l2tpServer" name="l2tpServer">
<div id="l2tpServerLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="l2tp_server" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type="text"id="l2tpUser" name="l2tpUser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type="hidden" id="l2tpPass" name="l2tpPass">
<span id="div_l2tp_pass2"><input type=password id="l2tpPass2" name="l2tpPass2" maxlength="32" onFocus="changePasswordType(2)"></span>
<span id="div_l2tp_pass3" style="display:none"><input type=text id="l2tpPass3" name="l2tpPass3" maxlength="32"></span></td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text" id="l2tpMtu" name="l2tpMtu" size="4" maxlength=4>&nbsp;(546-1492)</td>
</tr>
</table>

<table id="div_pptp" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_address_mode)</script></td>
<td><input type="radio" id="pptpMode0" name="pptpMode" value="0" onClick="pptpModeSwitch()"><script>dw(MM_static)</script>
<input type="radio" id="pptpMode1" name="pptpMode" value="1" onClick="pptpModeSwitch()" checked><script>dw(MM_dynamic)</script></td>
</tr>
<tr id="div_pptpIp" style="display:none">
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="hidden" id="pptpIp" name="pptpIp">
<div id="pptpIpLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_ip" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr id="div_pptpNetmask" style="display:none">
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><input type="hidden" id="pptpNetmask" name="pptpNetmask">
<div id="pptpNetmaskLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_mask" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr id="div_pptpGateway" style="display:none">
<td class="item_left"><script>dw(MM_default_gateway)</script></td>
<td><input type="hidden" id="pptpGateway" name="pptpGateway">
<div id="pptpGatewayLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_gateway" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_gateway" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_gateway" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_gateway" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_server_ipaddr)</script></td>
<td><input type="hidden" id="pptpServer" name="pptpServer">
<div id="pptpServerLen">
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" name="pptp_server" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type="text" id="pptpUser" name="pptpUser" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type="hidden" id="pptpPass" name="pptpPass">
<span id="div_pptp_pass2"><input type=password id="pptpPass2" name="pptpPass2" maxlength="32" onFocus="changePasswordType(3)"></span>
<span id="div_pptp_pass3" style="display:none"><input type=text id="pptpPass3" name="pptpPass3" maxlength="32"></span></td>
</tr>
<tr>
<td class="item_left">MTU</td>
<td><input type="text"  id="pptpMtu" name="pptpMtu" size="4" maxlength=4>&nbsp;(546-1492)</td>
</tr>
<tr>
<td class="item_left">MPPE Encryption</td>
  <td>
  <input type="checkbox" id="mppe" name="mppe" value="0">
  </td>
</tr>
<td class="item_left">MPPC Compression</td>
  <td>
  <input type="checkbox" id="mppc" name="mppc" value="0">
  </td>
</tr>

</table>

<table id="div_pppoe" style="display:none" border=0 width="100%">
<tr>
<td class="item_left" ><script>dw(MM_SpecialWay)</script></td>
<td><select class="select" id="specialWayEnabled" name="specialWayEnabled">
<option value="0"><script>dw(MM_off)</script></option>
<option value="1"><script>dw(MM_on)</script></option>
</select></td>
</tr>
</table>


<table id="div_dns_mode" style="display:none" border=0 width="100%">
<tr><td colspan="2"><input type="radio" id="dnsMode0" name="dnsMode" value="1" onClick="dnsModeSwitch(0)"><script>dw(MM_dns_auto)</script></td></tr>
<tr><td colspan="2"><input type="radio" id="dnsMode1" name="dnsMode" value="0" onClick="dnsModeSwitch(1)"><script>dw(MM_dns_manual)</script></td></tr>
</table>

<table id="div_dns" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_pridns)</script></td>
<td><input type="hidden" id="priDns" name="priDns">
<div id="priDnsLen">
<input type="text" style="width:33px" size="3" maxlength="3" id="wanpridns" name="wanpridns" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="wanpridns" name="wanpridns" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="wanpridns" name="wanpridns" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="wanpridns" name="wanpridns" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>
</div>
</tr>
<tr>
<td class="item_left"><script>dw(MM_secdns)</script></td>
<td><input type="hidden" id="secDns" name="secDns">
<div id="secDnsLen">
<input type="text" style="width:33px" size="3" maxlength="3" id="wansecdns" name="wansecdns" onKeyDown="return ipVali(event,this.name,0);" onkeyup="ipValiOnKeyUp(event,this.name,0);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="wansecdns" name="wansecdns" onKeyDown="return ipVali(event,this.name,1);" onkeyup="ipValiOnKeyUp(event,this.name,1);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="wansecdns" name="wansecdns" onKeyDown="return ipVali(event,this.name,2);" onkeyup="ipValiOnKeyUp(event,this.name,2);">. 
<input type="text" style="width:33px" size="3" maxlength="3" id="wansecdns" name="wansecdns" onKeyDown="return ipVali(event,this.name,3);" onkeyup="ipValiOnKeyUp(event,this.name,3);"></td>	
</div>
</tr>
</table>

<table id="div_macclone" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_macaddr_clone)</script></td>
<td><input type="hidden" id="macCloneEnbl" name="macCloneEnbl">
<input type="hidden" name="macCloneMac" id="macCloneMac">
<input type="text" style="width:28px" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)">
<script>dw('<input type="button" class=button4 id=cloneMacBtn name=cloneMacBtn value="'+BT_clone_mac+'" onClick="cloneMacClick()">&nbsp;&nbsp;\
<input type="button" class=button4 id=factoryMacBtn name=factoryMacBtn value="'+BT_factory_mac+'" onClick="factoryMacClick()">')</script></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</span>
</form>

<script>showFooter()</script>

<span id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</span>

</body></html>
