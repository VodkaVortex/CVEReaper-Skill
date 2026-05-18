<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/ajax.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript">
var lan_ip,wan_ip,bt_enable,bt_port,bt_username,bt_password,bt_auth_enable,bt_max_download,fromwan_h,usb_state;
var portStatus=1;
var responseTorrentCfg,responsePartList;	
function formCheck(){
	if($("#bt_enable").val() == 1){	
		if($("#bt_port").val() == ""){
			alert(MM_port+JS_msg18);
			return false;
		}
		else if (!checkVaildVal.IsVaildPort($("#bt_port").val(),MM_port)){
			return false;	
		}
		else if(!portStatus){
			alert(JS_msg115);
			return false;
		}	
			
		if($("#bt_auth_enable").val() == 1) {
 	    	if (!checkVaildVal.isBlankCheck($("#bt_username").val(), MM_username)) 
				return false;
			if(/[^a-zA-Z0-9]/gi.test($("#bt_username").val())){
				alert(MM_username+JS_msg74);
				return false;
			}
			if (!checkVaildVal.isBlankCheck($("#bt_password").val(), MM_password)) 
				return false;
			if(/[^a-zA-Z0-9]/gi.test($("#bt_password").val())){
				alert(MM_password+JS_msg74);
				return false;
			}
		}
	}
	return true;
}  
function initValue(){	
	bt_enable=responseTorrentCfg['TorrentEnabled'];
	lan_ip=responseTorrentCfg['lanIp'];
	wan_ip=responseTorrentCfg['wanIP'];
	bt_port=responseTorrentCfg['TorrentPort'];
	bt_username=responseTorrentCfg['TorrentUser'];
	bt_password=responseTorrentCfg['TorrentPsword'];
	bt_auth_enable=responseTorrentCfg['TorrentAuth'];
	bt_max_download=responseTorrentCfg['TorrentMaxDwLoad'];
	fromwan_h=responseTorrentCfg['TorrentWan'];
	usb_state=responseTorrentCfg['UsbFlag'];
	showPartList();
	
	if(responseTorrentCfg['usb_sdcardBt']==1)
		supplyValue("usbdevice_check", MSG_sdcard_check);
	else
		supplyValue("usbdevice_check", MSG_usb_check);
	
	if (usb_state == 0){
		$("#div_no_usbdivice").show();
		$("#div_usbdivice").hide();
	}else{
		$("#div_no_usbdivice").hide();
		$("#div_usbdivice").show();
		
		setJSONValue({
			'bt_enable'      : bt_enable,
			'bt_auth_enable' : bt_auth_enable,
			'bt_port'        : bt_port,
			'bt_max_download': bt_max_download,
			'fromwan_h'      : fromwan_h,
			'fromwan'        : fromwan_h,
			'disk_part'      : responseTorrentCfg['TorrentDir']
		});
		
		selectChange();
		selectChange_auth();
	}
}
function selectChange(){
	if($("#bt_enable").val() == 0){
		setDisabled("#bt_port, #bt_auth_enable, #bt_username, #bt_password, #bt_max_download, #fromwan, #set_torrent", true);
	}else if($("#bt_enable").val() == 1){
		setDisabled("#bt_port, #bt_auth_enable, #bt_username, #bt_password, #bt_max_download, #fromwan, #set_torrent", false);
	}
} 
function selectChange_auth(){
	setJSONValue({
		'bt_username' : bt_username,
		'bt_password' :bt_password
	});
	
	if($("#bt_auth_enable").val() == 0){
		$("#btusername, #btpassword").hide();
	}else if($("#bt_auth_enable").val() == 1){
		$("#btusername, #btpassword").show();
	}
}
function open_transmission_window(){
	if(window.location.hostname == lan_ip)
		window.open("http://"+lan_ip+":"+$("#bt_port").val(),"download_List","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480");
	else
		window.open("http://"+wan_ip+":"+$("#bt_port").val(),"download_List","toolbar=no, location=yes, scrollbars=yes, resizable=no, width=640, height=480");
} 
function fromwan_enable(){ 
	if($("#fromwan").is(':checked'))
		supplyValue("fromwan_h","1"); 
	else 
		supplyValue("fromwan_h","0"); 
} 
function resultFun(data){
	if(data==1){
		portStatus=0;
	}else{
		portStatus=1;
	}
}
function checkPort(){
	var postVar ={"topicurl":"setting/checkPort"};
	postVar['port']  = $('input[name="bt_port"]').val();
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			var responseFtpCfg = JSON.parse(Data);
			resultFun(responseFtpCfg['portStatus']);
		}
    });
}
function checkPort2(){
	if($("#bt_port").val() !=bt_port)
	checkPort();
}
function showPartList(){
	var partTab = $("#showPartList").get(0);
	var trNode;
	part_count=responsePartList.length-1;
	for(var i=1;i<responsePartList.length;i++){
		trNode=partTab.insertRow(-1);
		trNode.align="left";
		trNode.insertCell(0).innerHTML='<input type="radio" name="disk_part" value="'+responsePartList[i].path+'">';
		trNode.insertCell(1).innerHTML=responsePartList[i].path;
	}
}
$(function(){
	var postVar = { topicurl : "setting/getTorrentCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseTorrentCfg = JSON.parse(Data);
		}
    });
	var postVar = { topicurl : "setting/getPartitionList"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responsePartList = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){	
	if (formCheck()==false)
		return false;
		
	var postVar ={"topicurl":"setting/setTorrentSrv"};
	postVar['bt_enable']  = $('select[name="bt_enable"]').val();
	postVar['bt_port']  = $('input[name="bt_port"]').val();
	postVar['bt_auth_enable']  = $('select[name="bt_auth_enable"]').val();
	postVar['bt_max_download']  = $('select[name="bt_max_download"]').val();
	postVar['fromwan_h']  = $('input[name="fromwan_h"]').val();
	postVar['disk_part']  = $(':radio[name="disk_part"]:checked').val();
	postVar['bt_username']  = $('input[name="bt_username"]').val();
	postVar['bt_password']  = $('input[name="bt_password"]').val();
	uiPost(postVar);
}
</script>
</head>

<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<div id="div_no_usbdivice" style="display:none">
<table border=0 width="100%">
<tr><td><img src="../graphics/warning.gif" align="absmiddle">&nbsp;&nbsp;<span id="usbdevice_check">&nbsp;</span>&nbsp;&nbsp;
<script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>

<div id="div_usbdivice">
<form method=post name="storage_dwld" action="/goform/torrentsrv">
<input type="hidden" name="submit-url" value="/usb/torrent.asp">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_torrent_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_torrent_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select onChange="selectChange();checkPort2();" id="bt_enable" name="bt_enable" size="1">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr> 
<tr id="btport">
<td class="item_left"><script>dw(MM_port)</script></td>
<td><input type=text id="bt_port" name="bt_port" maxlength=5 value="" size="5" onChange="checkPort();"></td>
</tr>
<tr id="btauth">
<td class="item_left"><script>dw(MM_auth_torrent)</script></td>
<td><select onChange="selectChange_auth()" id="bt_auth_enable" name="bt_auth_enable" size="1">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="btusername">
<td class="item_left"><script>dw(MM_username)</script></td>
<td><input type=text id="bt_username" name="bt_username" maxlength=16></td>
</tr>
<tr id="btpassword">
<td class="item_left"><script>dw(MM_password)</script></td>
<td><input type=password id="bt_password" name="bt_password" maxlength=16></td>
</tr>
<tr id="btmaxdownload">	
<td class="item_left"><script>dw(MM_maximum_download_number)</script></td>
<td><select id="bt_max_download" name="bt_max_download" size="1">
<option value=1>1</option>
<option value=2>2</option>
<option value=3>3</option>
</select></td>
</tr>
<tr> 	
<td class="item_left"><script>dw(MM_allow_wan_set)</script></td> 
<td><input type="checkbox" id="fromwan" name="fromwan" onClick="fromwan_enable();"> <input type="hidden" id="fromwan_h" name="fromwan_h" value=0></td> 
</tr> 
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_partition_list)</script></td>
<td><table id="showPartList" style="border:0;"></table></td>
<tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="setTimeout(doSubmit,250)"> &nbsp; &nbsp;\
<input type=button class=button3 name="set_torrent" value="'+BT_set_torrent+'" onClick="open_transmission_window();">')</script></td></tr>
</table>
</form>
</div>
<form method=post id="portcheckfrm" action="/goform/checkPort" style="display:none;">
<input type=text id="enabled" name="enabled" value="">
<input type=text id="port" name="port" value="">
</form>
<script>showFooter()</script>
</body></html>