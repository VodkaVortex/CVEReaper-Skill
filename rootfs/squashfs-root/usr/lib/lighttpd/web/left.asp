<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/menu.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/forbidView.js"></script>
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript" src="js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var opmode,opmode_support;
var dhcpen,igmpb,ethspeedb;
var wifiDualband,wifiOff5g,wifiOff24g,apcli_enable,apclii_enable,mssidb,wdsb,wscb,wifischedule;
var connlimit,authType,vpnb,fwLayer7Bt,fwMenuShow,qosv4b;
var usb_basic,usb_sdcardBt,usb_ftp,usb_smb,usb_printer,usb_itunes,usb_dlna,usb_bt,usb_http,usb_nginx;
var wifidogb,csauth,hardac,csteWebAuth,cloud_ac,portalV2,brportal;
var reboot_schedule,upnpEn,syslogdEn,domainEn;
var counts=0,supporIptv=0;//ddns use it

function initValue(){
	opmode = responseJson['OperationMode'];
	opmode_support=responseJson['OpModeSupport'].split(";");
	
	dhcpen = responseJson['dhcpEnabled'];
	igmpb = responseJson['igmpProxyBt'];
	ethspeedb = responseJson['ethSpeedBt'];
	
	wifiDualband = responseJson['wifiDualband'];
	wifiOff5g = responseJson['WiFiOff_5g'];
	wifiOff24g = responseJson['WiFiOff_2g'];
	apcli_enable = responseJson['ApCliEnable'];
	apclii_enable = responseJson['ApCliiEnable'];
	mssidb = responseJson['mbssBt'];
	wdsb = responseJson['wdsBt'];
	wscb = responseJson['wscBt'];
	wifischedule = responseJson['wifiScheduleBt'];
	
	connlimit = responseJson['connLimit'];
	authType = responseJson['userAuthType'];
	vpnb = responseJson['vpnBt'];
	fwLayer7Bt = responseJson['fwLayer7Bt'];
	fwMenuShow = responseJson['fwMenuShowBt'];
	
	usb_basic = responseJson['usbBasicBt'];
	usb_ftp = responseJson['usbFtpBt'];
	usb_smb = responseJson['usbSmbBt'];
	usb_printer = responseJson['usbPrintBt'];
	usb_itunes = responseJson['usbItunesBt'];
	usb_dlna = responseJson['usbDlnaBt'];
	usb_bt = responseJson['usbBtBt'];
	usb_http = responseJson['usbHttpBt'];
	usb_nginx = responseJson['usbNginxBt'];
	
	wifidogb = responseJson['wifiDogBt'];
	csauth = responseJson['protalBt'];
	portalV2 = responseJson['portalV2'];
	brportal = responseJson['brportal'];
	csteWebAuth = responseJson['csteWebAuth'];
	hardac = responseJson['hardAc'];
	
	reboot_schedule = responseJson['rebootschBt'];
	upnpEn = responseJson['miniupnpdBt'];
	syslogdEn = responseJson['syslogdBt'];
	domainEn = responseJson['domainEn'];
	cloud_ac = responseJson['cloudac'];
	qosv4b = responseJson['qosv4Bt'];
	supporIptv = responseJson['supporIptv'];
}

function initMenu(){
	//  nodeID, parent nodeID,  Name,  URL
	initValue();

	a = new Menu('a');
	a.add(1, 0, MM_system_status,  "adm/status.asp", NoSubMenu, icon_System_Status);	
	if (opmode_support.length > 1)
		a.add(2, 0, MM_opmode,         "adm/opmode.asp", NoSubMenu, icon_Opmode);
	if (cloud_ac == 1)
		a.add(32, 0, MM_cloudac_bind,  "adm/cloudacbind.asp", NoSubMenu, icon_Network);
	
	/****************network start**********************/
	if (opmode == 1 || opmode == 3 || opmode == 4)	//gateway and wisp
	{
		a.add(3,     0, MM_network,        	"internet/wan.asp",	WithSubMenu, icon_Network);
		a.add(301,   3, MM_wan_setting,     "internet/wan.asp");
		a.add(302,   3, MM_lan_setting,     "internet/lan.asp");
		if (dhcpen == 1)
			a.add(303,  	3, MM_static_dhcp_setting,  "internet/static_dhcp.asp");
		if (vpnb == 1)
			a.add(304,  	3, MM_vpn_setting,        	"internet/vpn.asp");
		if (igmpb == 1)
			a.add(305,  	3, MM_igmpproxy_setting,    "internet/igmpproxy.asp");
		if (opmode == 1 && ethspeedb == 1)
			a.add(306,  	3, MM_ethspeed_setting,     "internet/ethspeed.asp");
	}
	else
	{
		a.add(3,     0, MM_network,        	"internet/lan.asp",	WithSubMenu, icon_Network);
		a.add(301,   3, MM_lan_setting,     "internet/lan.asp");
			
	}
	if (opmode==1 && supporIptv == 1)	
		a.add(307,   3, MM_IptvSetup,  			"internet/iptv.asp");
	
	/****************network end**********************/
	/**************cloud auth portal start***************/
	if (portalV2 == 1 && (opmode == 4 || brportal == 1))
	{
		a.add(8,     0, MM_cloud_portal,    "auth/portal.asp",	NoSubMenu, icon_Management);
	}
	/**************cloud auth portal end***************/
	
	/****************5G wireless start**************/
	if (wifiDualband == 1)
	{
		if (wifiOff5g == 1)
		{
			a.add(10,     0,  MM_wireless5g,  "wireless/basic.asp",	WithSubMenu, icon_Wireless);
			a.add(1001,   10, MM_basic_setting,        	 "wireless/basic.asp");
		}
		else
		{
			a.add(10,     0,  MM_wireless5g,  "wireless/stainfo.asp", WithSubMenu, icon_Wireless);
			a.add(1001,   10, MM_wireless_status,        "wireless/stainfo.asp");
			a.add(1002,   10, MM_basic_setting,        	 "wireless/basic.asp");
//			if (apclii_enable == 1)
//				a.add(1003,   10, MM_repeater_setting,    "wireless/repeater.asp");
			if (mssidb == 1)
				a.add(1004,   10, MM_multipleap_setting,   "wireless/multipleap.asp");
			a.add(1005,   10, MM_acl_setting,        	    "wireless/acl.asp");
			if (wdsb == 1 && opmode != 2)
				a.add(1006,   10, MM_wds_setting,        	"wireless/wds.asp");
			if (wscb == 1)
				a.add(1007,   10, MM_wps_setting,         "wps/wps.asp");
			a.add(1008,   10, MM_advanced_setting,        "wireless/advanced.asp");
		}
	}
	/****************5G wireless end***************/

	/****************2.4G wireless start**************/
	if (wifiOff24g == 1)
	{	
		if (wifiDualband == 1)
			a.add(4,     0, MM_wireless24g,  "wireless/basic.asp", WithSubMenu, icon_Wireless);
		else
			a.add(4,     0, MM_wireless,  "wireless/basic.asp", WithSubMenu, icon_Wireless);
		a.add(401,   4, MM_basic_setting,        	"wireless/basic.asp");
		if (wifiDualband != 1)
			a.add(409,  4,  MM_wlsch_setting,  "wireless/schedulewifi.asp");
	}
	else
	{	
		if (wifiDualband == 1)
			a.add(4,     0, MM_wireless24g,  "wireless/stainfo.asp", WithSubMenu, icon_Wireless);
		
		else
			a.add(4,     0, MM_wireless,  "wireless/stainfo.asp", WithSubMenu, icon_Wireless);
		a.add(401,   4, MM_wireless_status,        	"wireless/stainfo.asp");
		a.add(402,   4, MM_basic_setting,        	"wireless/basic.asp");
//		if (apcli_enable == 1)
//			a.add(403,   4, MM_repeater_setting,    "wireless/repeater.asp");
		if (mssidb == 1)
			a.add(404,   4, MM_multipleap_setting,   "wireless/multipleap.asp");
		a.add(405,   4, MM_acl_setting,        	    "wireless/acl.asp");
		if (wdsb == 1 && (opmode == 1 || opmode == 0))
			a.add(406,   4, MM_wds_setting,        	"wireless/wds.asp");
		if (wscb == 1)
			a.add(407,   4, MM_wps_setting,         "wps/wps.asp");
		a.add(408,   4, MM_advanced_setting,        "wireless/advanced.asp");
		if (wifiDualband != 1)
			a.add(409,  4,  MM_wlsch_setting,  "wireless/schedulewifi.asp");		
		
	}
	/****************2.4G wireless end***************/

	/****************qos start   ********************/
	if (qosv4b == 1 && (opmode == 1 || opmode == 3 || opmode == 4))
	{
		a.add(5,    0, "QoS",        	  "firewall/qos.asp", WithSubMenu, icon_QoS);
		a.add(501,  5, MM_qos_setting,    "firewall/qos.asp");
		if (connlimit == 1)
			a.add(502,  5, MM_conn_limit, "firewall/connlimit.asp");
	}
	/****************qos end     ********************/

	/****************firewall start******************/
	if (opmode == 1 || opmode == 3 || opmode == 4)
	{
		if (fwLayer7Bt==1)
		{
			a.add(6,    0, MM_smart_filtering,   "firewall/smart_filtering.asp", WithSubMenu, icon_Firewall);
		}
		else
		{
			a.add(6,    0, MM_firewall,      	"firewall/firewall_type.asp", WithSubMenu, icon_Firewall);
			a.add(601,  6, MM_firewall_type,    "firewall/firewall_type.asp");
			if (fwMenuShow.indexOf("ipport")>=0)
				a.add(602,  6, MM_port_filtering,   "firewall/ipport_filtering.asp");
			if (fwMenuShow.indexOf("mac")>=0)
				a.add(603,  6, MM_mac_filtering,    "firewall/mac_filtering.asp");
			if (fwMenuShow.indexOf("url")>=0)
				a.add(604,  6, MM_url_filtering,    "firewall/url_filtering.asp");
			if (fwMenuShow.indexOf("portforward")>=0)
				a.add(605,  6, MM_port_forwarding,  "firewall/port_forward.asp");
			if (fwMenuShow.indexOf("vpnpass")>=0)
				a.add(606,  6, MM_vpnpass_setting,  "firewall/vpnpass.asp");
			if (fwMenuShow.indexOf("dmz")>=0)
				a.add(607,  6, MM_dmz_setting,      "firewall/dmz.asp");
			if (fwMenuShow.indexOf("dos")>=0)
				a.add(608,  6, MM_dos_setting,      "firewall/dos.asp");
			if (fwMenuShow.indexOf("fwSchedule")>=0)
				a.add(609,  6, MM_rule_schedule_setting,  "firewall/fwSchedule.asp");
		}
	}
	/****************firewall end********************/

	/****************usb start   ********************/
	if (usb_basic == 1 && (opmode == 1 || opmode == 3))
	{
		if (usb_sdcardBt == 1)
			a.add(7,   0, MM_sdcard,      	"usb/usb_basic_user.asp", WithSubMenu, icon_USB_Storage);
		else
			a.add(7,   0, MM_usb_device,    "usb/usb_basic_user.asp", WithSubMenu, icon_USB_Storage);
		a.add(701,  7, MM_user_setting,   "usb/usb_basic_user.asp");
		a.add(702,  7, MM_disk_setting,   "usb/usb_basic_disk.asp");
		if (usb_ftp == 1)
			a.add(703,  7, MM_ftp_setting,        "usb/usb_ftp.asp");
		if (usb_smb == 1)
			a.add(704,  7, MM_samba_setting,      "usb/usb_smb.asp");
		if (usb_printer == 1)
			a.add(705,  7, MM_printer_setting,    "usb/p910printer_srv.asp");
		if (usb_bt == 1)
			a.add(706,  7, MM_torrent_setting,    "usb/torrent.asp");
		if (usb_dlna == 1)
			a.add(707,  7, MM_minidlna_setting,   "usb/minidlna.asp");
		if (usb_itunes == 1)
			a.add(708,  7, MM_itunes_setting,      "usb/itunes_srv.asp");
		if (usb_http == 1)
			a.add(709,  7, MM_httpfiles_server,    "usb/http_files.asp");
		if (usb_nginx == 1)
			a.add(710,  7, MM_nginx_setting,    "usb/usb_nginx.asp");
	}
	/****************usb  end   ********************/

	/****************auth start ********************/
	if (csteWebAuth ==1)
	{
		a.add(12,   0, MM_protal_setting,        	"auth/authStatus.asp", WithSubMenu, icon_Management);
		a.add(1201,   12, MM_auth_status,        	"auth/authStatus.asp");
		if (authType==1)
		{
			a.add(1202,  12, MM_authserver_setting,        		"auth/authserver.asp");
			a.add(1203,  12, MM_hotspot_setting,        		"auth/hotspotserver.asp");
		}
		a.add(1204,  12, MM_auth_rule,        		"auth/authRule.asp");
		a.add(1205,  12, MM_url_schedule,        		"auth/urlSchedule.asp");
		a.add(1206,  12, MM_auth_content,        		"auth/authContent.asp");
		a.add(1207,  12, MM_auth_template,        		"auth/authTemplate.asp");
		
		a.add(8,   0, MM_auth_gateway,        	"internet/wifidog.asp", WithSubMenu, icon_Management);
		a.add(801,   8, MM_auth_manage,        	"internet/wifidog.asp");
		a.add(802,   8, MM_wifidog_status,        	"auth/wifidog_status.asp");
	}
	/****************auth end  ********************/
	
	/****************management start *************/
	if (1)
	{
		a.add(9,    0, MM_management,      "adm/password.asp", WithSubMenu, icon_Management);
		a.add(901,  9, MM_admin_setting,   "adm/password.asp");
		a.add(902,  9, MM_ntp_setting,     "adm/ntp.asp");
		if (opmode == 1 || opmode == 3 || opmode == 4)
		{				
			a.add(903,  9, MM_ddns_setting,        	     "adm/ddns.asp");
			a.add(904,  9, MM_remote_management_setting, "adm/remote.asp");
		}
		if (upnpEn == 1 && (opmode == 1 || opmode == 3))
			a.add(905,  9, MM_upnp_setting,    "adm/upnp.asp");
		a.add(906,  9, MM_upgrade_firmware,    "adm/upload_firmware.asp");
		a.add(908,  9, MM_saveconf,        	   "adm/settings.asp");
		if (syslogdEn == 1)
			a.add(909,  9, MM_syslog,        	   "adm/syslog.asp");
		if (reboot_schedule == 1){
			if(hardac==1){
				a.add(910,  9, MM_rebootsch_setting, "adm/ap_schedule_reboot.asp");
			}else{
				a.add(910,  9, MM_rebootsch_setting, "adm/schedule.asp");
			}
		}
		if (wifischedule == 1 && wifiDualband == 1)
			a.add(911,  9,  MM_wlsch_setting,  "wireless/schedulewifi.asp");
		//if (wifidogb == 1 && opmode!= 0 && csteWebAuth !=1)
		//	a.add(912,  9, MM_wifidog_setting,  "internet/wifidog.asp",	"view");
		a.add(913,  9, MM_logout,      			"#");
	}
	
	$("#div_Menu").html(a.toString());
}

$(function(){
	var postVarBuilt = { topicurl : "setting/getGlobalFeatureBuilt"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);					
		}
    }); 
	initMenu();
});
</script>
</head>
<body style="overflow-x:hidden">
<div id="div_Menu"></div>
<form action="/cgi-bin/cstecgi.cgi" method=POST name="langCfg" target="_top">
<input type="hidden" name="langType">
</form>
</body>
</html>
