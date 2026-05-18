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
var responseJson,v_opmode,v_lanautodhcpc,v_lanip,v_lanmsk,v_langw,v_dhcpEnabled,v_dhcpLease,v_dhcpStart,v_dhcpEnd,dhcpsart,dhcpend;
function zip(a, b, c, d){
   	var  re = 0;
   	re=(Number(a)*16777216)+(Number(b)<<16)+(Number(c)<<8)+(Number(d));
    return re;
}
function unzip(zipc, flag){
	var var1=Math.floor(Number(zipc/16777216));
	var remainder1=Number(zipc%16777216);
	var var2=Math.floor(remainder1/65536);
	var remainder2=Math.floor(remainder1%65536);
	var var3=Math.floor(remainder2/256);
	var var4=Math.floor(remainder2%256);
	
	if(flag==1){
		dhcpsart = var1+'.'+ var2 +'.'+ var3 +'.'+ var4;
	}else if(flag==2){
		dhcpend = var1+'.'+ var2 +'.'+ var3 +'.'+ var4;	
	}
}
function firstIP( IP,mask){
	$("#lanIp").val(combinIP($(":input[name=ip]")));
	$("#lanNetmask").val(combinIP($(":input[name=mask]")));
	var iparry = $("#lanIp").val().split('.');
	var ipadd4 = iparry[3];
	
	var ip1=Math.floor(IP/4);
	var ip2=Number(IP%4);

	var mask1=Math.floor(mask/4);
	var mask2=Number(mask%4);

	var network=Number(ip1&mask1)*4+Number(ip2&mask2);//3221225472
	var firstIPAdd=0;
	var netIP=(IP&(~mask))+1;
	if (netIP<256&&netIP>128) {
		netIP=1;
		firstIPAdd = network+netIP;//1+1;
	}else{
		if(Number(ipadd4) > 128) netIP=1;
		firstIPAdd =network+netIP;
	}
	unzip(firstIPAdd,1);
}   
function lastIP(IP,mask){
    var ip1=Math.floor(IP/4);
	var ip2=Number(IP%4);
	var mask1=Math.floor(mask/4);
	var mask2=Number(mask%4);
	var network=Number(ip1&mask1)*4+Number(ip2&mask2);
	var network1=Math.floor(network/2);
	var network2=Number(network%2);
	var lastIPAdd=Number(network2|((~mask)%2))+Number(network1|((~mask)/2))*2-1;	
	var netIP=(IP&(~mask))+1;
	if (netIP==129) lastIPAdd = network+netIP-2;
	if (netIP>129&&mask==4294967040) lastIPAdd = network+netIP-2;//4294967040==[255.255.255.0]
	if (lastIPAdd==IP) lastIPAdd--;
	unzip(lastIPAdd,2);       
}
function checkPool(poolstart,poolend){
	var ip1=$("#ip1").val();
	var ip2=$("#ip2").val();
	var ip3=$("#ip3").val();
	var ip4=$("#ip4").val();
	var mask1=$("#mask1").val();
	var mask2=$("#mask2").val();
	var mask3=$("#mask3").val();
	var mask4=$("#mask4").val();
	
	firstIP(zip(ip1,ip2,ip3,ip4),zip(mask1,mask2,mask3,mask4));
	lastIP(zip(ip1,ip2,ip3,ip4),zip(mask1,mask2,mask3,mask4));

	var rightPools=zip(dhcpsart.split(".")[0], dhcpsart.split(".")[1], dhcpsart.split(".")[2], dhcpsart.split(".")[3]);
	var rightPoole=zip(dhcpend.split(".")[0], dhcpend.split(".")[1], dhcpend.split(".")[2], dhcpend.split(".")[3]);
	var currPoolStart=zip(poolstart.split(".")[0], poolstart.split(".")[1], poolstart.split(".")[2], poolstart.split(".")[3]);
	var currPoolEnd=zip(poolend.split(".")[0], poolend.split(".")[1], poolend.split(".")[2], poolend.split(".")[3]);
	
	if(currPoolStart<rightPools || currPoolEnd>rightPoole){
		alert(JS_msg125+dhcpsart+"-"+dhcpend);
		return false;
	}
	return true;
}
function checkpPrivateNetwork(ip){
	var aNetSegs=zip("0","0","0","0");
	var aNetSege=zip("127","255","255","255");
	var bNetSegs=zip("128","0","0","0");
	var bNetSege=zip("191","255","255","255");
	var cNetSegs=zip("192","0","0","0");
	var cNetSege=zip("233","255","255","255");
	
	var aPrivateNets=zip("10","0","0","0");
	var aPrivateNete=zip("10","255","255","255");
	var bPrivateNets=zip("172","16","0","0");
	var bPrivateNete=zip("172","31","255","255");
	var cPrivateNets=zip("192","168","0","0");
	var cPrivateNete=zip("192","168","255","255");
	var currIP=zip(ip.split(".")[0],ip.split(".")[1],ip.split(".")[2],ip.split(".")[3]);
	if(aNetSegs<currIP && currIP<aNetSege){ 
		if(aPrivateNete<currIP || currIP<aPrivateNets){
			alert(JS_msg43+"10.0.0.0-10.255.255.255");
			return false;
		}else{
			return true;
		}
	}else if(bNetSegs<currIP && currIP<bNetSege){
		if(bPrivateNete<currIP || currIP<bPrivateNets){
			alert(JS_msg43+"172.16.0.0-172.31.255.255");
			return false;
		}else{
			return true;
		}
	}else if(cNetSegs<currIP && currIP<cNetSege){
		if(cPrivateNete<currIP || currIP<cPrivateNets){
			alert(JS_msg43+"192.168.0.0-192.168.255.255");
			return false;
		}else{
			return true;
		}
	}else{
		return false;
	}
} 
function saveChanges(){	
	setJSONValue({
		'lanIp'		:	combinIP($(":input[name=ip]")),
		'lanNetmask':	combinIP($(":input[name=mask]")),
		'dhcpStart'	:	combinIP($(":input[name=sip]")),
		'dhcpEnd'	:	combinIP($(":input[name=eip]"))
	});
	
	if (!checkpPrivateNetwork($("#lanIp").val())) return false;	
	if ($("#lanDhcpType").get(0).selectedIndex == 1) {
		if (!checkVaildVal.IsVaildIpAddr($("#dhcpStart").val(), "DHCP "+MM_start_ipaddr))return false;				
		if (!checkVaildVal.IsVaildIpAddr($("#dhcpEnd").val(), "DHCP "+MM_end_ipaddr))return false;			
		if (!checkVaildVal.IsIpRange($("#dhcpStart").val(), $("#dhcpEnd").val())) return false;
		if (($("#dhcpStart").val() ==$("#lanIp").val()) || ($("#dhcpEnd").val() == $("#lanIp").val())) {alert(JS_msg39);return false;}		
		if (!checkPool($("#dhcpStart").val(),$("#dhcpEnd").val())) return false;
		if (!checkVaildVal.IsIpSubnet($("#lanIp").val(), $("#lanNetmask").val(),$("#dhcpStart").val())){alert(JS_msg55);return false;}
		if (!checkVaildVal.IsIpSubnet($("#lanIp").val(), $("#lanNetmask").val(),$("#dhcpEnd").val())){alert(JS_msg56);return false;}
		if (!checkVaildVal.IsVaildNumberRange($("#dhcpLease").val(),MM_lease_time, 60, 86400)) return false;
	}
	return true;
}
function dhcpTypeSwitch(){
	if ($("#lanDhcpType").get(0).selectedIndex == 1)
		$("#div_dhcp_setting").show();
  	else
   	  	$("#div_dhcp_setting").hide();
}
function initValue(){
	v_opmode=responseJson['OperationMode'];	
	v_lanip=responseJson['lanIp'];
	v_lanmsk=responseJson['lanNetmask'];
	v_dhcpEnabled=responseJson['dhcpEnabled'];
	v_dhcpLease=responseJson['dhcpLease'];
	v_dhcpStart=responseJson['dhcpStart'];
	v_dhcpEnd=responseJson['dhcpEnd'];

	setJSONValue({
		'lanIp'			:	responseJson['lanIp'],
		'lanNetmask'	:	responseJson['lanNetmask'],
		'dhcpStart'		:	responseJson['dhcpStart'],
		'dhcpEnd'		:	responseJson['dhcpEnd']		
	});

	if (v_lanip !="") 	 decomIP($(":input[name=ip]"),v_lanip,1);
	if (v_lanmsk !="") 	 decomIP($(":input[name=mask]"),v_lanmsk,1);
	if (v_dhcpStart !="")  decomIP($(":input[name=sip]"),v_dhcpStart,1);
	if (v_dhcpEnd !="")    decomIP($(":input[name=eip]"),v_dhcpEnd,1);

	$("#lanDhcpType").get(0).selectedIndex=v_dhcpEnabled;
	supplyValue("dhcpLease",v_dhcpLease);	
	dhcpTypeSwitch();
    
	if (v_opmode!=1 && v_opmode!=3) 
		$("#div_dhcp_server").hide();	
}
$(function(){
	var postVar = { topicurl : "setting/getLanConfig"};
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
	
	var postVar ={"topicurl":"setting/setLanConfig"};
	postVar['dhcpStart']=$('#dhcpStart').val();
	postVar['dhcpEnd']=$('#dhcpEnd').val();
	postVar['lanDhcpType']=$('#lanDhcpType').val();
	postVar['dhcpLease']=$("#dhcpLease").val();
	uiPost3(postVar);
}
function do_count_down_lan(){
	supplyValue('show_sec',wtime);
	if(wtime == 0) {parent.location.href='http://'+lanip; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down_lan()',1000);}
}
function win78reload(){
	lanip = $('#lanIp').val();
	var userAgent = navigator.userAgent;
	if(userAgent.indexOf("Windows NT 6.1") > -1 || userAgent.indexOf("Windows 7") > -1 || userAgent.indexOf("Windows 8") > -1){
		wtime = 51;//81;		
	}else{
		wtime = 41;//61;
	}
	if ($('#lanIp').val()==v_lanip)
		do_count_down();
	else
		do_count_down_lan();
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
<tr><td class="content_title"><script>dw(MM_dhcp_server_settings)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr style="display:none">
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="hidden" id="lanIp" name="lanIp">
<input type="text" style="width:33px" maxlength="3" id="ip1" name="ip">. 
<input type="text" style="width:33px" maxlength="3" id="ip2" name="ip">. 
<input type="text" style="width:33px" maxlength="3" id="ip3" name="ip">. 
<input type="text" style="width:33px" maxlength="3" id="ip4" name="ip"></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_netmask)</script></td>
<td><input type="hidden" id="lanNetmask" name="lanNetmask">
<input type="text" style="width:33px" maxlength="3" id="mask1" name="mask">. 
<input type="text" style="width:33px" maxlength="3" id="mask2" name="mask">. 
<input type="text" style="width:33px" maxlength="3" id="mask3" name="mask">. 
<input type="text" style="width:33px" maxlength="3" id="mask4" name="mask"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_dhcp_server)</script></td>
<td><select id="lanDhcpType" name="lanDhcpType" onChange="dhcpTypeSwitch()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
</table>

<table id="div_dhcp_setting" style="display:none" border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_start_ipaddr)</script></td>
<td><input type="hidden" id="dhcpStart" name="dhcpStart">
<input type="text" style="width:33px" maxlength="3" id="sip1" name="sip" onKeyDown="return ipVali(event,this.name,0);">. 
<input type="text" style="width:33px" maxlength="3" id="sip2" name="sip" onKeyDown="return ipVali(event,this.name,1);">. 
<input type="text" style="width:33px" maxlength="3" id="sip3" name="sip" onKeyDown="return ipVali(event,this.name,2);">. 
<input type="text" style="width:33px" maxlength="3" id="sip4" name="sip" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_end_ipaddr)</script></td>
<td><input type="hidden" id="dhcpEnd" name="dhcpEnd">
<input type="text" style="width:33px" maxlength="3" id="eip1" name="eip" onKeyDown="return ipVali(event,this.name,0);">. 
<input type="text" style="width:33px" maxlength="3" id="eip2" name="eip" onKeyDown="return ipVali(event,this.name,1);">. 
<input type="text" style="width:33px" maxlength="3" id="eip3" name="eip" onKeyDown="return ipVali(event,this.name,2);">. 
<input type="text" style="width:33px" maxlength="3" id="eip4" name="eip" onKeyDown="return ipVali(event,this.name,3);"></td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_lease_time)</script></td>
<td><select id="dhcpLease" name="dhcpLease">
<option value="86400">1 <script>dw(MM_day)</script></option>
<option value="7200">2 <script>dw(MM_hours)</script></option>
<option value="3600">1 <script>dw(MM_hour)</script></option>
<option value="900">15 <script>dw(MM_minutes)</script></option>
<option value="300">5 <script>dw(MM_minutes)</script></option>
</select></td>
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
