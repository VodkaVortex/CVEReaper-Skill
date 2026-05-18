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
var rules_num,lanip,lanmsk,netip,qosEnable,ManualUpSpeed,ManualDwSpeed,ipStart,ipEnd;

function IpRangeCheck(s1,s2){
	var ip1=s1.split(".");
	var ip2=s2.split(".");
	for(var k=0;k<4;k++){
		var a=Number(ip1[3]);
		var b=Number(ip2[3]);
      	if(a>b) {alert(JS_msg100); return 0;}
	}
	return 1;
}
function saveChanges(){
	if ($("#enabled").val() == 1){	
		$("#manualUplinkSpeed").val($("#manualUplinkSpeed_tmp").val());
		$("#manualDownlinkSpeed").val($("#manualDownlinkSpeed_tmp").val());
		if (!checkVaildVal.IsVaildNumber($("#manualUplinkSpeed_tmp").val(), MM_total_uplink_speed)) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#manualUplinkSpeed_tmp").val(),MM_total_uplink_speed, 100, 12500)) return false;
		if (!checkVaildVal.IsVaildNumber($("#manualDownlinkSpeed_tmp").val(), MM_total_downlink_speed)) return false;
		if (!checkVaildVal.IsVaildNumberRange($("#manualDownlinkSpeed_tmp").val(),MM_total_downlink_speed, 100, 12500)) return false;
	}
	return true;
}
function enableAddButton(){
	setDisabled("#add,#scan",false);
}
function addClick(){
	if ( rules_num >= 10 ) {
		alert(JS_msg28);
		return false;
	}
	ipStart = netip+$("#ipstart").val();
	//ipEnd = netip+$("#ipend").val();
	setJSONValue({
		"ipStart" : ipStart,
		"ipEnd"   : ipEnd
	});
	if (!checkVaildVal.IsVaildIpAddr(ipStart, MM_start_ipaddr)) return false;
	if (!checkVaildVal.IsIpSubnet(ipStart, lanmsk, lanip)) {alert(JS_msg38);return false;}		
	if (ipStart == lanip) {alert(JS_msg39);return false;}	
	//if (ipEnd == lanip) {alert(JS_msg39);return false;}			
	//if(ipEnd==netip) {
		//supplyValue("ipEnd", ipStart);
	//}else {	
		//if (!checkVaildVal.IsVaildIpAddr(ipEnd, MM_end_ipaddr)) return false;
		//if (!checkVaildVal.IsIpSubnet(ipEnd, lanmsk, lanip)) {alert(JS_msg38);return false;}
		//if (!IpRangeCheck(ipStart, ipEnd))	return false;
		//if (ipStart == lanip || ipEnd == lanip){alert(JS_msg39);return false;}
	//}

	if (!checkVaildVal.IsVaildNumber($("#bandwidth").val(), MM_upload_bandwidth)) return false;
	if (!checkVaildVal.IsVaildNumberRange($("#bandwidth").val(),MM_upload_bandwidth, 100, 12500)) return false;
	if (!checkVaildVal.IsVaildNumber($("#bandwidth_downlink").val(), MM_download_bandwidth)) return false;
	if (!checkVaildVal.IsVaildNumberRange($("#bandwidth_downlink").val(),MM_download_bandwidth, 100, 12500)) return false;
	if(responseJson.length>2) {
		for(var i=2;i<responseJson.length;i++){
			//v = responseJson[i]['ip'].split("-");
			v = responseJson[i]['ip'];
			for (var j=0; j<v.length; j++){	
				var ips = Number(ipStart.split(".")[3]);
				//var ipe = Number(ipEnd.split(".")[3]);
				var v0 = Number(v.split(".")[3]);
				//var v1 = Number(v[1].split(".")[3]);
				//if (ips == v0 || ips == v1 || ipe == v0 || ipe == v1) {alert(JS_msg124);return false;}
				if (ips == v0) {alert(JS_msg124);return false;}				
				//if (ips < v0 && ipe > v0) {alert(JS_msg124);return false;}	
				//if (ips > v0 && ips < v1) {alert(JS_msg124);return false}		
			}
		}
	}

	var totaUpbandwidth = ManualUpSpeed;
	var totaDownbandwidth = ManualDwSpeed;
	var tmp_up_bd = Number($("#bandwidth").val());
	var tmp_down_bd = Number($("#bandwidth_downlink").val());
	if(rules_num==0){
		if($("#bandwidth").val() > Number(totaUpbandwidth)){alert(JS_msg113);$("#bandwidth").focus();return false;}
		if($("#bandwidth_downlink").val() > Number(totaDownbandwidth)){alert(JS_msg114);$("#bandwidth_downlink").focus();return false;}
	}else if(rules_num > 0){
		for(var i=1; i<=rules_num; i++){

			var rule_up = $("#td_upbandwidth"+i).html();
			var rule_down = $("#td_downbandwidth"+i).html();

			tmp_up_bd += Number(rule_up);
			tmp_down_bd += Number(rule_down);
			if(tmp_up_bd > Number(totaUpbandwidth)){alert(JS_msg113);$("#bandwidth").focus();return false;}
			if(tmp_down_bd > Number(totaDownbandwidth)){alert(JS_msg114);$("#bandwidth_downlink").focus();return false;}
		}
	}
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_comment,2)) return false;}	
	setDisabled("#add,#scan",true);
}
function disableAddFiled(){
	setDisabled("#ipstart,#ipend,#bandwidth,#bandwidth_downlink,#comment",true);
	setDisabled("#add,#scan",true);
}
function disableDelButton(){
	setDisabled("#deleteSelQos,#delreset",true);
}
function updateState(){
	if ($("#enabled").val()==0) {
		setDisabled("#manualUplinkSpeed_tmp,#manualDownlinkSpeed_tmp",true);
		disableAddFiled();
		disableDelButton();
	}
	else
	{
		setDisabled("#manualUplinkSpeed_tmp,#manualDownlinkSpeed_tmp",false);
	}
	//doSubmit();
}	
function initValue(){
	rules_num = responseJson.length-2;
	lanip = responseJson[1]['lanIp'];
	lanmsk = responseJson[1]['lanNetmask'];
	netip = lanip.replace(/\.\d{1,3}$/,".");
	qosEnable = responseJson[0]['enable'];
	ManualUpSpeed = responseJson[1]['manualUpSpeed'];
	ManualDwSpeed = responseJson[1]['manualDwSpeed'];
	
	$("#enabled").val(qosEnable);
	$("#manualUplinkSpeed").val(ManualUpSpeed);
	$("#manualUplinkSpeed_tmp").val(ManualUpSpeed);
	$("input[name=ManualDownlinkSpeed]").val(ManualDwSpeed)
	$("input[name=manualDownlinkSpeed_tmp]").val(ManualDwSpeed)
	
	var trNode,tdNode;
	var qosListTab=document.getElementById("div_qosFilterList");
	for(var i=2;i<responseJson.length;i++){
		trNode=qosListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=responseJson[i].idx;		
		trNode.insertCell(1).innerHTML=responseJson[i].ip;
		tdNode=trNode.insertCell(2);
		tdNode.innerHTML=responseJson[i].upBandwidth;
		tdNode.id="td_upbandwidth"+Number(i-1);
		tdNode=trNode.insertCell(3);
		tdNode.innerHTML=responseJson[i].dwBandwidth;
		tdNode=tdNode.id="td_downbandwidth"+Number(i-1);
		trNode.insertCell(4).innerHTML=responseJson[i].comment;
		trNode.insertCell(5).innerHTML='<input type=\"checkbox\" id=\"'+responseJson[i].delRuleName+'\" name=\"'+responseJson[i].delRuleName+'\" value=\"'+responseJson[i].delRuleName+'\" >';	
	}
	
	enableAddButton();
	if (qosEnable == 0) {
		setDisabled("#manualUplinkSpeed_tmp,#manualDownlinkSpeed_tmp",true);
		disableAddFiled();
		disableDelButton();
	}
	
	if (rules_num==0) 
		disableDelButton();
	
	if (lanip !="") decomIP2($(":input[name=ips]"),lanip,0);
}
function arpTblClick(url){
	openWindow(url,"_blank",700,400);
}
$(function(){	
	var postVar = { 'topicurl' : "setting/getIpQosRules"};
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
	setTimeout("initValue()",350);
});
function doSubmit(){	
	if (saveChanges()==false)
		return false;
	var postVar ={"topicurl":"setting/setIpQos"};
	postVar['enabled']=$("#enabled").val();
	postVar['manualUplinkSpeed'] = $("#manualUplinkSpeed_tmp").val();
	postVar['manualDownlinkSpeed'] = $("#manualDownlinkSpeed_tmp").val();
	uiPost(postVar);
}
function doSubmitRules(){	
	if (addClick()==false)
		return false;
	var postVar ={"topicurl":"setting/setIpQosRules"};
	postVar['ipStart'] = ipStart;
	//postVar['ipEnd'] = $("#ipEnd").val();
	postVar['bandwidth'] = $("#bandwidth").val();
	postVar['bandwidth_downlink'] = $("#bandwidth_downlink").val();
	postVar['comment'] = $("#comment").val();
	uiPost(postVar);
}
function doSubmitDelRules(){	
	var flg=0;
	var i,k=0;
    var postVar ={"topicurl":"setting/delIpQosRules"};
    for (i=0; i< rules_num; i++){
		var tmp = $("#delRule"+i).get(0);
		if (tmp.checked == true){
			postVar['delRule'+k]= i;
			k++;
			flg=1
		}
	}
	if(flg==0){
		alert(JS_msg36);
	 	event.returnValue = false;
	}
	postVar['delRuleNum']= k;
	if(flg==1){
		uiPost(postVar);
	}
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post id="formIpQos" name="formIpQos">
<input type="hidden" id="ipStart" name="ipStart">
<input type="hidden" id="ipEnd" name="ipEnd">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_qos_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_qos_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="enabled" name="enabled" onChange="updateState()">
<option value="0" ><script>dw(MM_disable)</script></option>
<option value="1" ><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_total_uplink_speed)</script></td>
<td><input type="hidden" id="manualUplinkSpeed" name="manualUplinkSpeed" value="">
<input type="text" id="manualUplinkSpeed_tmp" name="manualUplinkSpeed_tmp" size="6" maxlength="6"  value="" > (100-12500KBytes)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_total_downlink_speed)</script></td>
<td><input type="hidden" id="manualDownlinkSpeed" name="manualDownlinkSpeed" value="" >
<input type="text" id="manualDownlinkSpeed_tmp" name="manualDownlinkSpeed_tmp" size="6" maxlength="6"  value="" > (100-12500KBytes)</td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" name=add onClick="doSubmit();">')</script></td>
</tr>
</table>
</form>

<br />
<form id="formIpQosAdd" name="formIpQosAdd" method=post>
<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td></tr>
<tr id="div_addline"><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" id="ipstart" name="ipstart" maxlength="3" value=""><input type="hidden" style="width:33px" id="ipend" name="ipend" maxlength="3" value="" > 
<script>dw('<input id=scan name=scan type=button value="'+BT_scan+'" onClick=arpTblClick(\"arpinfo.asp#flag=4\")>')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_upload_bandwidth)</script></td>
<td><input type="text" id="bandwidth" name="bandwidth" size="6" maxlength="6"> (100-12500KBytes)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_download_bandwidth)</script></td>
<td><input type="text" id="bandwidth_downlink" name="bandwidth_downlink" size="6" maxlength="6"> (100-12500KBytes)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" id="comment" name="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" name=add id=add onClick="doSubmitRules();">')</script></td></tr>
</table>
</form>

<form method=post name="formIpQosDel">
<input type="hidden" value="/firewall/qos.asp" name="submit-url">
<table border=0 width="100%">
<tr><td colspan="6"><b><script>dw(MM_qos_table)</script>&nbsp;&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="6"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_upload_bandwidth)</script></b></td>
<td class="item_center"><b><script>dw(MM_download_bandwidth)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="div_qosFilterList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id="deleteSelQos" name="deleteSelQos" onClick="doSubmitDelRules();">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="delreset" name="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>