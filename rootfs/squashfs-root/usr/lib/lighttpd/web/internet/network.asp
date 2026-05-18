<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/ajax.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var v_netmode,v_lanip,v_lanmsk;

function saveChanges(){	
	setJSONValue({
		'lanIp'		:	combinIP($(":input[name=ip]")),
		'lanNetmask':	combinIP($(":input[name=mask]")),			
	});
	
	if ($("#netmode").get(0).selectedIndex == 1){
		if (!checkVaildVal.IsVaildIpAddr($("#lanIp").val(),MM_ipaddr)) return false;
		if (!checkVaildVal.IsVaildMaskAddr($("#lanNetmask").val(), MM_netmask)) return false;
		$("#lanMaskLen").val(getMaskLength($("#lanNetmask").val()));
	}
	return true;
}

function initValue(){
	v_lanip=responseJson['lanIp'];
	v_lanmsk=responseJson['lanNetmask'];

	setJSONValue({
		'lanIp'			:	responseJson['lanIp'],
		'lanNetmask'	:	responseJson['lanNetmask'],
	});

	if (v_lanip !="") 	 decomIP($(":input[name=ip]"),v_lanip,1);
	if (v_lanmsk !="") 	 decomIP($(":input[name=mask]"),v_lanmsk,1);

	$("#netmode").get(0).selectedIndex=v_netmode;
}

function updateState(){
	if ($("#netmode").get(0).selectedIndex == 1){
		$("#div_lanip, #div_lanmask").show();	
	}
	else{
		$("#div_lanip, #div_lanmask").hide();	
	}
}

$(function(){
	var postVar = { topicurl : "setting/getNetworkConfig"};
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

function doSubmit(){
	if(saveChanges()==false) 
		return false;
	
	var postVar ={"topicurl":"setting/setNetworkConfig"};
	postVar['netMode']=$('#netmode').val();
	postVar['lanIp']=$('#lanIp').val();
	postVar['lanNetmask']=$('#lanNetmask').val();
	postVar['lanMaskLen']=$("#lanMaskLen").val();
	
	if ($('#lanIp').val()==v_lanip)
		$("#show_msg").html(JS_msg75);
	else
		$("#show_msg").html(JS_msg77);
	uiPost3(postVar);
}

function win78reload(){
	lanip = $('#lanIp').val();
	var userAgent = navigator.userAgent;
	if(userAgent.indexOf("Windows NT 6.1") > -1 || userAgent.indexOf("Windows 7") > -1 || userAgent.indexOf("Windows 8") > -1){
		wtime = 81;		
	}else{
		wtime = 61;
	}
	do_count_down();
}

function uiPost3(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	setTimeout('waitpage()',1000);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		
	});
	win78reload();
}
</script>
</head>
<body class="mainbody">
<span id="div_body_setting">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="lanCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_localip_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_localip_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_mode)</script></td>
<td><select id="netmode" name="netmode" onChange="updateState()">
<option value="0"><script>dw(MM_dynamic)</script></option>
<option value="1"><script>dw(MM_static)</script></option>
</select></td>
</tr>
<tr id="div_lanip" style="display:none">
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="hidden" id="lanIp" name="lanIp">
<input type="text" style="width:33px" maxlength="3" id="ip1" name="ip" onKeyDown="return ipVali(event,this.name,0);"  onChange="autoChangePool();">. 
<input type="text" style="width:33px" maxlength="3" id="ip2" name="ip" onKeyDown="return ipVali(event,this.name,1);"  onChange="autoChangePool();">. 
<input type="text" style="width:33px" maxlength="3" id="ip3" name="ip" onKeyDown="return ipVali(event,this.name,2);"  onChange="autoChangePool();">. 
<input type="text" style="width:33px" maxlength="3" id="ip4" name="ip" onKeyDown="return ipVali(event,this.name,3);"  onChange="autoChangePool();"></td>
</tr>
<tr id="div_lanmask" style="display:none">
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><input type="hidden" id="lanNetmask" name="lanNetmask">
<input type="hidden" id="lanMaskLen" name="lanMaskLen">
<input type="text" style="width:33px" maxlength="3" id="mask1" name="mask" onKeyDown="return ipVali(event,this.name,0);" onChange="autoChangePool();">. 
<input type="text" style="width:33px" maxlength="3" id="mask2" name="mask" onKeyDown="return ipVali(event,this.name,1);" onChange="autoChangePool();">. 
<input type="text" style="width:33px" maxlength="3" id="mask3" name="mask" onKeyDown="return ipVali(event,this.name,2);" onChange="autoChangePool();">. 
<input type="text" style="width:33px" maxlength="3" id="mask4" name="mask" onKeyDown="return ipVali(event,this.name,3);" onChange="autoChangePool();"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td>
</tr>
</table>
</form>
<script>showFooter()</script>
</span>

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
