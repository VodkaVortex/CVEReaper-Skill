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
var rJson,iptvEn,proxyEn,snoopEn,tag;
var iptvVer,hardModel;
var mode_values,mode_options;
function setbackgroundValue(){
	setJSONValue({
		"mode"				: 	rJson['serviceType'],
		"InternetVid"		:	rJson['internetVid'],
		"InternetPri"		:	rJson['internetPri'],
		"IpPhoneVid"		:	rJson['ipPhoneVid'],
		"IpPhonePri"		:	rJson['ipPhonePri'],
		"IptvVid"			:	rJson['iptvVid'],
		"IptvPri"			:	rJson['iptvPri'],
		"lan1"				:	rJson['lan1'],
		"lan2"				:	rJson['lan2'],
		"lan3"				:	rJson['lan3'],
		"lan4"				:	rJson['lan4'],
		"wlan0"				:	rJson['wlan0'],
		"wlan0_va0"			:	rJson['wlan0_va0'],
		"wlan0_va1"			:	rJson['wlan0_va1'],
		"wlan1"				:	rJson['wlan1'],
		"wlan1_va0"			:	rJson['wlan1_va0'],
		"wlan1_va1"			:	rJson['wlan1_va1']

	});
	
	
	if(rJson['tagFlag']==1){
		tag = document.getElementById('tagflag');
		tag.checked=true;
	}else{
		tag = document.getElementById('tagflag');
		tag.checked=false;
	}
}
function initValue()
{
	setJSONValue({
		"IgmpVer"			:	rJson['igmpVer'],
		"InternetVid"		:	rJson['internetVid'],
		"InternetPri"		:	rJson['internetPri'],
		"IpPhoneVid"		:	rJson['ipPhoneVid'],
		"IpPhonePri"		:	rJson['ipPhonePri'],
		"IptvVid"			:	rJson['iptvVid'],
		"IptvPri"			:	rJson['iptvPri'],
		"tagflag"			:	rJson['tagFlag'],
		"lan1"				:	rJson['lan1'],
		"lan2"				:	rJson['lan2'],
		"lan3"				:	rJson['lan3'],
		"lan4"				:	rJson['lan4'],
		"wlan0"				:	rJson['wlan0'],
		"wlan0_va0"			:	rJson['wlan0_va0'],
		"wlan0_va1"			:	rJson['wlan0_va1'],
		"wlan1"				:	rJson['wlan1'],
		"wlan1_va0"			:	rJson['wlan1_va0'],
		"wlan1_va1"			:	rJson['wlan1_va1']
	});
	
	iptvVer = rJson['iptvVer'];//0:all,1:Singapore,2:Malaysia,3:Vietnam,4:Russia,5:Taiwan region
	
	if(iptvVer == 0){//0:all
		mode_values =["1","2","3","4","5","0"];
		mode_options=["Singapore-Singtel","Malaysia-Unifi","Malaysia-Maxis","VTV","Taiwan","User Define"];
	}else if(iptvVer == 1){//1:Singapore
		mode_values =["1","0"];
		mode_options=["Singapore-Singtel","User Define"];
	}else if(iptvVer == 2){//2:Malaysia
		mode_values =["2","3","0"];
		mode_options=["Malaysia-Unifi","Malaysia-Maxis","User Define"];
	}else if(iptvVer == 3){//3:Vietnam
		mode_values =["4","0"];
		mode_options=["VTV","User Define"];
	}else if(iptvVer == 4){//4:Russia
		mode_values =["0"];
		mode_options=["User Define"];
		$("#mode").attr("disabled",true).removeClass("select").addClass("select-dis");
	}else if(iptvVer == 5){//5:Taiwan region
		mode_values =["5"];
		mode_options=["Taiwan"];
		$("#mode").attr("disabled",true).removeClass("select").addClass("select-dis");
	}else{
		mode_values =["1","2","3","4","5","0"];
		mode_options=["Singapore-Singtel","Malaysia-Unifi","Malaysia-Maxis","VTV","Taiwan","User Define"];
	}
	
	CreateOptions("mode",mode_options,mode_values);
	
	setJSONValue({
			"mode"				: 	rJson['serviceType']
	});
	
	if(1 == rJson['igmpProxyEn']){
		proxyEn = document.getElementById('IgmpProxyEn');
		proxyEn.checked=true;
	}else{
		proxyEn = document.getElementById('IgmpProxyEn');
		proxyEn.checked=false;
	}
	if(1 == rJson['iptvEnable']){
		iptvEn = document.getElementById('iptvEnable');
		iptvEn.checked=true;
		$("#vlan_div,#lan_div,#mode_div").show();
	}else{
		iptvEn = document.getElementById('iptvEnable');
		iptvEn.checked=false;
		$("#vlan_div,#lan_div,#mode_div").hide();
	}
	if(1 == rJson['igmpSnoopEn']){
		snoopEn = document.getElementById('IgmpSnoopEn');
		snoopEn.checked=true;
	}else{
		snoopEn = document.getElementById('IgmpSnoopEn');
		snoopEn.checked=false;
	}
	if(1 == rJson['tagFlag']){
		tag = document.getElementById('tagflag');
		tag.checked=true;
	}else{
		tag = document.getElementById('tagflag');
		tag.checked=false;
	}
	if($("#mode").val()==0){
		$("#InternetVid,#InternetPri,#tagflag,#IpPhoneVid,#IpPhonePri,#IptvVid").attr("disabled",false);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",false).removeClass("select-dis").addClass("select");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").attr("disabled",false).removeClass("select-dis").addClass("select");
	}else{
		$("#InternetVid,#tagflag,#IpPhoneVid,#IptvVid,#IptvPri").attr("disabled",true);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",true).removeClass("select").addClass("select-dis");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").attr("disabled",true).removeClass("select").addClass("select-dis");
	}
	
	updateMode();
}

$(function()
{
	var postVar={topicurl:"setting/getIptvConfig"};
	 postVar=JSON.stringify(postVar);
	$.ajax({  
       	type : "post", 
       	url : " /cgi-bin/cstecgi.cgi", 
       	data : postVar, 
       	async : false, 
       	success : function(Data){
			rJson=JSON.parse(Data);
		}
	});
	initValue();
	try{ 
	   parent.frames["title"].initValue();
    }catch(e){}
});

function iptvSwitch()
{
	if($("#iptvEnable").is(":checked")){
		$("#vlan_div,#lan_div,#mode_div").show();
		updateMode();
	}else{
		$("#vlan_div,#lan_div,#mode_div").hide();
	}
}
function updateMode()
{
	tag = document.getElementById('tagflag');
	if($("#mode").val()==3){//Malaysia-Maxis
		$("#InternetVid").val("621");
		$("#InternetPri").val("0");
		$("#IptvVid").val("823");
		$("#IptvPri").val("0");
		$("#IpPhoneVid").val("822");
		$("#IpPhonePri").val("0");
		$("#lan1").val("1");
		$("#lan2,#lan3").val("3");
		$("#lan4").val("2");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").val("3");
		$("#internet_vid,#ipPhone_vid,#iptv_vid").show();
		tag.checked=true;
	}else if($("#mode").val()==2){//Malaysia-Unifi
		$("#InternetVid").val("500");
		$("#InternetPri").val("0");
		$("#IptvVid").val("600");
		$("#IptvPri").val("0");
		$("#lan1").val("1");
		$("#lan2,#lan3,#lan4").val("3");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").val("3");
		$("#internet_vid,#iptv_vid").show();
		$("#ipPhone_vid").hide();
		tag.checked=true;
	}else if($("#mode").val()==1){//Singapore-Singtel
		$("#InternetVid").val("10");
		$("#InternetPri").val("0");
		$("#IptvVid").val("20");
		$("#IptvPri").val("4");
		$("#IpPhoneVid").val("30");
		$("#IpPhonePri").val("0");
		$("#lan1").val("1");
		$("#lan2,#lan3,#lan4").val("3");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").val("3");
		$("#internet_vid,#iptv_vid").show();
		$("#ipPhone_vid").hide();
		tag.checked=true;
	}else if($("#mode").val()==4){//VTV
		$("#InternetVid").val("35");
		$("#InternetPri").val("0");
		$("#IptvVid").val("36");
		$("#IptvPri").val("4");
		$("#IpPhoneVid").val("37");
		$("#IpPhonePri").val("5");
		$("#lan1").val("1");
		$("#lan3").val("2");
		$("#lan2,#lan4").val("3");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").val("3");
		$("#internet_vid,#ipPhone_vid,#iptv_vid").show();
		tag.checked=true;
	}else if($("#mode").val()==5){//Taiwan region
		$("#InternetVid").val("10");
		$("#InternetPri").val("0");
		$("#IptvVid").val("2");
		$("#IptvPri").val("0");
		$("#IpPhoneVid").val("2");
		$("#IpPhonePri").val("0");
		$("#lan1").val("1");
		$("#lan2,#lan3,#lan4").val("3");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").val("3");
		tag.checked=false;
		$("#internet_vid,#ipPhone_vid,#iptv_vid").hide();
	}else{//user define
		$("#InternetVid").val("10");
		$("#InternetPri").val("0");
		$("#IptvVid").val("30");
		$("#IptvPri").val("0");
		$("#IpPhoneVid").val("20");
		$("#IpPhonePri").val("0");
		$("#lan1,#lan2,#lan3,#lan4").val("3");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").val("3");
		tag.checked=true;
		if(rJson['serviceType']=="0")setbackgroundValue();
		$("#internet_vid,#ipPhone_vid,#iptv_vid").show();
	}
	if($("#mode").val()==0){
		$("#InternetPri,#tagflag,#IpPhoneVid,#IpPhonePri,#IptvVid,#InternetVid").attr("disabled",false);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",false).removeClass("select-dis").addClass("select");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").attr("disabled",false).removeClass("select-dis").addClass("select");
	}else{
		$("#InternetVid,#tagflag,#IpPhoneVid,#IptvVid,#IptvPri").attr("disabled",true);
		$("#InternetPri,#IpPhonePri,#IptvPri,#lan1,#lan2,#lan3,#lan4").attr("disabled",true).removeClass("select").addClass("select-dis");
		$("#wlan0,#wlan0_va0,#wlan0_va1,#wlan1,#wlan1_va0,#wlan1_va1").attr("disabled",true).removeClass("select").addClass("select-dis");
	}
}

function saveChanges(){
	if($("#mode").val()==0){//User
		if(!checkVaildVal.IsVaildNumberRange($('#IptvVid').val(), "IPTV "+MM_VlanVID, 1, 4094)) return false;
		if(!checkVaildVal.IsVaildNumberRange($('#IpPhoneVid').val(), "IP-Phone "+MM_VlanVID, 1, 4094)) return false;
		if(!checkVaildVal.IsVaildNumberRange($('#InternetVid').val(), "Internet "+MM_VlanVID, 1, 4094)) return false;

		if($("#tagflag").is(":checked")){
			if($('#IptvVid').val()==$('#IpPhoneVid').val()||$('#IpPhoneVid').val()==$('#InternetVid').val()||$('#IptvVid').val()==$('#InternetVid').val()){
				alert(JS_msg157);
				return false;
			}
		}else{
			var typemask = 0;
			typemask |= 1 << $("#lan1").val();
			typemask |= 1 << $("#lan2").val();
			typemask |= 1 << $("#lan3").val();
			typemask |= 1 << $("#lan4").val();

			typemask |= 1 << $("#wlan0").val();
			typemask |= 1 << $("#wlan0_va0").val();
			typemask |= 1 << $("#wlan0_va1").val();
			typemask |= 1 << $("#wlan1").val();
			typemask |= 1 << $("#wlan1_va0").val();
			typemask |= 1 << $("#wlan1_va1").val();
			
			
			if(((typemask&0x2)==0x2)&&((typemask&0x4)==0x4)){
				if($('#IptvVid').val()!=$('#IpPhoneVid').val() || $("#IptvPri").val()!=$("#IpPhonePri").val()){
					alert(JS_msg156);
					return false;
				}
			}
		}
	}
	return true;
}

function doSubmit()
{
	if(saveChanges()==false) return false;
	var postVar = {"topicurl" : "setting/setIptvConfig"};
	postVar['igmpVer'] = $("#IgmpVer").val();
	postVar['serviceType'] = $("#mode").val();
	postVar['iptvVid'] = $("#IptvVid").val();
	postVar['iptvPri'] = $("#IptvPri").val();
	postVar['ipPhoneVid'] = $("#IpPhoneVid").val();
	postVar['ipPhonePri'] = $("#IpPhonePri").val();
	postVar['internetVid'] = $("#InternetVid").val();
	postVar['internetPri'] = $("#InternetPri").val();
	postVar['lan1']=$("#lan1").val();
	postVar['lan2']=$("#lan2").val();
	postVar['lan3']=$("#lan3").val();
	postVar['lan4']=$("#lan4").val();
	
	postVar['wlan0']=$("#wlan0").val();
	postVar['wlan0_va0']=$("#wlan0_va0").val();
	postVar['wlan0_va1']=$("#wlan0_va1").val();
	postVar['wlan1']=$("#wlan1").val();
	postVar['wlan1_va0']=$("#wlan1_va0").val();
	postVar['wlan1_va1']=$("#wlan1_va1").val();
	
	if($("#IgmpProxyEn").is(":checked"))
		postVar['igmpProxyEn'] = "1"
	else
		postVar['igmpProxyEn'] = "0"

	if($("#IgmpSnoopEn").is(":checked"))
		postVar['igmpSnoopEn'] ="1"
	else
		postVar['igmpSnoopEn'] ="0"

	if($("#iptvEnable").is(":checked"))
		postVar['iptvEnable'] = "1"
	else 
		postVar['iptvEnable'] = "0"
		
	if ($("#tagflag").is(":checked"))
		postVar['tagFlag']="1";
	else
		postVar['tagFlag']="0";
		
	postVar['addEffect'] = "0";
	uiPost2(postVar); 
}
</script>
</head>
<body class="mainbody">
<div id="div_body_setting">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_IptvSetup)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_IptvSetup)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%" style="padding-top: 10px;">
<tr>
<td class="item_left"><script>dw(MM_IgmpProxy)</script></b></td>
<td><input type="Checkbox" id="IgmpProxyEn" checked="checked"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_enable)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_IgmpSnooping)</script></td>
<td><input type="Checkbox" id="IgmpSnoopEn" checked="checked"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_enable)</script></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_IgmpVer)</script></td>
<td><select class="select3" id="IgmpVer" >
<option value="0">V2</option>
<option value="1">V3</option>
</select></td>
</tr>
</table>

</br>
<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_IPTV)</script></td>
<td><input type="Checkbox" id="iptvEnable" checked="checked" onClick="iptvSwitch()"><span>&nbsp;&nbsp;&nbsp;<script>dw(MM_enable)</script></span></td>
</tr>
<tr id="mode_div">
<td class="item_left"><script>dw(MM_mode)</script></td>
<td><select class="select" id="mode" onChange="updateMode()" style=""></select></td>
</tr>
</table>
</br>
<table border=0 width="100%" id="vlan_div">
<tr id="internet_vid">
<td class="item_left"><script>dw(MM_InternetVID)</script></td>
<td><input type="text" class="text4" id="InternetVid" maxlength="4" value=""></td>
<td class="item_center2"><script>dw(MM_InternetPri)</script></td>
<td><select id="InternetPri" class="select3">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
</select></td>
<td><input type="Checkbox" id="tagflag" checked="checked">&nbsp;802.1Q Tag</td>
</tr>
<tr id="ipPhone_vid" style="display: none">
<td class="item_left"><script>dw(MM_PhoneVID)</script></td>
<td><input type="text" class="text4" id="IpPhoneVid" maxlength="4" value="">
<td class="item_center2"><script>dw(MM_PhonePri)</script></td>
<td><select id="IpPhonePri" class="select3">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
</select></td>
</tr>
<tr id="iptv_vid">
<td class="item_left"><script>dw(MM_IptvVID)</script></td>
<td><input type="text" class="text4" id="IptvVid" maxlength="4" value="">
<td id="item_center2"><script>dw(MM_IptvPri)</script></td>
<td><select id="IptvPri" class="select3">
<option value="0">0</option>
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
</select></td>
</tr>
</table>
</br>

<table border=0 width="100%" id="lan_div">
<tr>
<td class="item_left">LAN1</td>
<td><select class="select" id="lan1">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr>
<td class="item_left">LAN2</td>
<td><select class="select" id="lan2">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="lan3_div">
<td class="item_left">LAN3</td>
<td><select class="select" id="lan3">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="lan4_div">
<td class="item_left">LAN4</td>
<td><select class="select" id="lan4">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="wlan0_div" style="display: none">
<td class="item_left">WLAN0</td>
<td><select class="select" id="wlan0">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="wlan0_va0_div" style="display: none">
<td class="item_left">WLAN0-VA0</td>
<td><select class="select" id="wlan0_va0">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="wlan0_va1_div" style="display: none">
<td class="item_left">WLAN0-VA1</td>
<td><select class="select" id="wlan0_va1">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="wlan1_div" style="display: none">
<td class="item_left">WLAN1</td>
<td><select class="select" id="wlan1">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="wlan1_va0_div" style="display: none">
<td class="item_left">WLAN1-VA0</td>
<td><select class="select" id="wlan1_va0">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
<tr id="wlan1_va1_div" style="display: none">
<td class="item_left">WLAN1-VA1</td>
<td><select class="select" id="wlan1_va1">
<option value="1">IPTV</option>
<option value="2">IP-Phone</option>
<option value="3">Internet</option>
</select></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</td></tr></table>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</div>
</body></html>
