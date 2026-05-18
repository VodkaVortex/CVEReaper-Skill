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
var responseJson,responseJsonLan;
var rules_num,v_lanip,v_lanmsk;

function enableAddButton(){
	setDisabled("#add,#scan",false);
}
function disableAddFiled(){
	setDisabled("#wanfromPort,#wantoPort,#ip,#fromPort,#toPort,#protocol,#comment",true);
	setDisabled("#add,#scan",true);
}
function disableDelButton(){
	setDisabled("#deleteSelFwd,#delresest",true);
}
function saveChanges(){
	if (rules_num >= 10) {
		alert(JS_msg28);
		return false;
	}
	var netip=v_lanip.replace(/\.\d{1,3}$/,".");	
	$("#ip_address").val(netip+$("#ip").val());
	if (!checkVaildVal.IsVaildIpAddr($("#ip_address").val(), MM_ipaddr)) return false;	
	if (!checkVaildVal.IsIpSubnet($("#ip_address").val(), v_lanmsk, v_lanip)) {alert(JS_msg38);return false;}
	if ($("#ip_address").val() == v_lanip) {alert(JS_msg39);return false;}
	if (!checkVaildVal.IsVaildPort($("#wanfromPort").val(),MM_external_port)) return false;	
	if (!checkVaildVal.IsVaildPort($("#fromPort").val(),MM_internal_port)) return false;	
	var inPort = Number($("#fromPort").val());
	var outPort = Number($("#wanfromPort").val());
	var temp1,temp2;
	for (var i=1; i<responseJson.length; i++){	
		temp1=Number(responseJson[i].inPort);
		temp2=Number(responseJson[i].outPort);
		if (inPort ==  temp1) {alert(JS_msg115);return false;}
		if (outPort == temp2) {alert(JS_msg115);return false;}
	}
	
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_comment,2)) return false;}		
	return true;
}
function initValue(){	
	v_lanip=responseJsonLan['lanIp'];
	v_lanmsk=responseJsonLan['lanNetmask'];
	rules_num=responseJson.length-1;
	supplyValue("enabled",responseJson[0].enable);
	enableAddButton();
	if (responseJson[0].enable==0) {
		disableAddFiled();
		disableDelButton();
	}
	if (rules_num == 0) disableDelButton();
	if (v_lanip !="") decomIP2(document.formPortFwdAdd.ips,v_lanip,0);
	
	var trNode;
	var ipportListTab=$("#div_portForwardList").get(0);
	for(var i=1;i<responseJson.length;i++){
		trNode=ipportListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=responseJson[i].idx;		
		trNode.insertCell(1).innerHTML=responseJson[i].ip;
		trNode.insertCell(2).innerHTML=responseJson[i].proto;
		trNode.insertCell(3).innerHTML=responseJson[i].inPort;
		trNode.insertCell(4).innerHTML=responseJson[i].outPort;
		trNode.insertCell(5).innerHTML=responseJson[i].comment;
		trNode.insertCell(6).innerHTML='<input type=\"checkbox\" id=\"'+responseJson[i].delRuleName+'\"  value=\"'+responseJson[i].delRuleName+'\" >';
	}
}
$(function(){	
	var postVarLan = { topicurl : "setting/getLanConfig"};
    postVarLan = JSON.stringify(postVarLan);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarLan,  
        async : false,  
        success : function(Data){
			responseJsonLan = JSON.parse(Data);							
		}
    });	
	
	var postVar = { topicurl : "setting/getPortForwardRules"};
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
	if (saveChanges()==false)
		return false; 
		
	var postVar ={"topicurl":"setting/setPortForwardRules"};
	postVar['enabled']		=	$("#enabled").val();
	postVar['addEffect'] 	= 	"0";
	postVar['wanfromPort'] 	= 	$("#wanfromPort").val();
	postVar['wantoPort'] 	= 	$("wantoPort").val();
	postVar['ip_address']	= 	$("#ip_address").val();
	postVar['fromPort']		= 	$("#fromPort").val();
	postVar['toPort'] 		= 	$("#toPort").val();
	postVar['protocol'] 	= 	$("#protocol").val();
	postVar['comment'] 		= 	$("#comment").val();
	postVar['week_all']   = "ON";
	postVar['time_all']   = "ON";
	uiPost(postVar);
}
function updateState(){
	if ($("#enabled").get(0).selectedIndex==0) {
		disableAddFiled();
		disableDelButton();
	}
	var postVar ={"topicurl":"setting/setPortForwardRules"};
	postVar['enabled']=$("#enabled").val();
	postVar['addEffect'] = "1";
	uiPost(postVar);
}
function deleteClick(){	
   	var flg=0;
   	var postVar ={"topicurl":"setting/delPortForwardRules"};
    for (i=0; i< rules_num; i++)	{
		var tmp = $("#delRule"+i).get(0);
		if (tmp.checked == true){
			postVar['delRule'+i]= i;
			flg=1;
		}
	}
	
	if(flg==0){
		alert(JS_msg36);
	 	event.returnValue = false;
	}
	if(flg==1){
		uiPost(postVar);
	}
}
function arpTblClick(url){
	openWindow(url,"_blank",700,400);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="formPortFwdAdd">
<input type="hidden" id="ip_address" name="ip_address">
<input type="hidden" id="addEffect" name="addEffect" value="1">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_port_forwarding)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_port_forwarding)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select	id="enabled" name="enabled" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br />
<table border=0 width="100%"> 
<tr><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td></tr>
<tr id="div_addline"><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td class="item_left"><script>dw(MM_protocol)</script></td>
<td><select id="protocol" name="protocol">
<option selected value="TCP&UDP">TCP+UDP</option>
<option value="TCP">TCP</option>
<option value="UDP">UDP</option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" maxlength="3" id="ip" name="ip">
<script>dw('<input id=scan name=scan type=button value="'+BT_scan+'" onClick=arpTblClick(\"arpinfo.asp#flag=3\")>')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_internal_port)</script></td>
<td><input type="text" maxlength="5" size="5" id="fromPort" name="fromPort"><span style="display:none">  - <input type="text" maxlength="5" size="5" id="toPort" name="toPort"></span> (1-65535)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_external_port)</script></td>
<td><input type="text" maxlength="5" size="5" id="wanfromPort" name="wanfromPort"><span style="display:none">  - <input type="text" maxlength="5" size="5" id="wantoPort" name="wantoPort"></span> (1-65535)</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" id="comment" name="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" id=add name=add onClick="doSubmit()">')</script></td></tr>
</table>
</form>

<form method=post name="formPortFwdDel" >
<table border=0 width="100%"> 
<tr><td colspan="7"><b><script>dw(MM_port_forwarding_table)</script>&nbsp;&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="7"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_protocol)</script></b></td>
<td class="item_center"><b><script>dw(MM_internal_port)</script></b></td>
<td class="item_center"><b><script>dw(MM_external_port)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="div_portForwardList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id="deleteSelFwd" name="deleteSelFwd" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="delresest" name="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>
