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
	setDisabled("#add,scan",false);
}
var proto={TCP:"1",UDP:"2",ICMP:"4",ALL:"3"};
function saveChanges(){	
	if (rules_num >= 10) {
		alert(JS_msg28);
		return false;
	}	
	var netip=v_lanip.replace(/\.\d{1,3}$/,".");
	$("#sip_address").val( netip+$("#sip").val());
	if (!checkVaildVal.IsVaildIpAddr($("#sip_address").val(), MM_ipaddr)) 	return false;
	if (!checkVaildVal.IsIpSubnet($("#sip_address").val(), v_lanmsk, v_lanip)) {alert(JS_msg38);return false;}
	if ($("#sip_address").val() == v_lanip) {alert(JS_msg39);	return false;}
	if ($("#protocol").get(0).selectedIndex == 0 || $("#protocol").get(0).selectedIndex == 1 || $("#protocol").get(0).selectedIndex == 2) {
		if (!checkVaildVal.IsVaildPort($("#dFromPort").val(),MM_start_port)) 	return false;
		if ($("#dToPort").val() != "") {
			if (!checkVaildVal.IsVaildPort($("#dToPort").val(),MM_end_port)) return false;
			if (!checkVaildVal.IsPortRange($("#dFromPort").val(), $("#dToPort").val())) return false;
		}
	}	
	var pf = Number($("#dFromPort").val());
	var pt = Number($("#dToPort").val());
	var temp;
	for (var i=1; i<responseJson.length; i++){		
		temp  = responseJson[i].portRange.split("-");
		if($("#sip_address").val() == responseJson[i].ip){
			if ($("#dToPort").val() != ""){
				if(pf==Number(temp[0])||pt==Number(temp[1])||pt==Number(temp[0])||pf==Number(temp[1])){alert(JS_msg115);return false;}
				if (pf < Number(temp[0]) && pt > Number(temp[0])) {alert(JS_msg115);return false;}
				if (pf > Number(temp[0]) && pf < Number(temp[1])){alert(JS_msg115);return false;}
				
			}else{
				if (pf == Number(temp[0]) || pf == Number(temp[1])) {alert(JS_msg115);return false;}				
				if (pf >Number(temp[0]) && pf < Number(temp[1])) {alert(JS_msg115);return false;}
			}	 
		}	
   	}
	
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_comment,2)) return false;}
	return true;
}
function disableAddFiled(){
	setDisabled("#sip,#protocol,#comment,#dFromPort,#dToPort",true);
	setDisabled("#add,#scan",true);
}
function disableDelButton(){
	setDisabled("#deleteSelFilter,#delreset",true);
}
function initValue(){	
	v_lanip=responseJsonLan['lanIp'];
	v_lanmsk=responseJsonLan['lanNetmask'];
	rules_num=responseJson.length-1;
	supplyValue("enabled",responseJson[0].enable);
	if (responseJson[0].enable==0) {
		disableAddFiled();
		disableDelButton();
	}
	if ( rules_num == 0 )
		disableDelButton();
	
	var trNode;
	var ipportListTab=$("#div_ipportList").get(0);
	for(var i=1;i<responseJson.length;i++){
		trNode=ipportListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=responseJson[i].idx;		
		trNode.insertCell(1).innerHTML=responseJson[i].ip;
		trNode.insertCell(2).innerHTML=responseJson[i].proto;
		trNode.insertCell(3).innerHTML=responseJson[i].portRange;
		trNode.insertCell(4).innerHTML=responseJson[i].comment;
		trNode.insertCell(5).innerHTML='<input type=\"checkbox\" id=\"'+responseJson[i].delRuleName+'\" name=\"'+responseJson[i].delRuleName+'\" value=\"'+responseJson[i].delRuleName+'\" >';	
	}
	if (v_lanip !="") decomIP2($("input[name=ips]"),v_lanip,0);
}
function arpTblClick(url){
	openWindow(url,"_blank",700,400);
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
	
	var postVar = { topicurl : "setting/getIpPortFilterRules"};
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
function updateState(){
	if ($("#enabled").get(0).selectedIndex==0) {
		disableAddFiled();
		disableDelButton();
	}
	var postVar ={"topicurl":"setting/setIpPortFilterRules"};
	postVar['enabled']=$("#enabled").val();
	postVar['addEffect'] = "1";
	uiPost(postVar);
}
function deleteClick(){	
	var flg=0;
	var postVar ={"topicurl":"setting/delIpPortFilterRules"};
    for (i=0; i< rules_num; i++){
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
function doSubmit(){	
	if (saveChanges()==false)
		return false;
		 
	var postVar ={"topicurl":"setting/setIpPortFilterRules"};
	postVar['enabled']	  =	$("#enabled").val();
	postVar['addEffect']  = "0";
	postVar['mac_address']= $("#mac_address").val();
	postVar['sip_address']= $("#sip_address").val();
	postVar['sip_address2'] = $("#sip_address").val();
	postVar['sFromPort']  = $("sFromPort").val();
	postVar['sToPort'] 	  = $("#sToPort").val();
	postVar['dip_address'] = $("#dip_address").val();
	postVar['dip_address2'] = $("#dip_address").val();
	postVar['dFromPort']  = $("#dFromPort").val();
	postVar['dToPort'] 	  = $("#dToPort").val();
	postVar['protocol']   = $("#protocol").val();
	postVar['action']     = $("#action").val();
	postVar['comment']    = $("#comment").val();
	postVar['week_all']   = "ON";
	postVar['time_all']   = "ON";
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="formFilterAdd" id="formFilterAdd" >
<input type="hidden" id="sip_address" name="sip_address">
<input type="hidden" id="mac_address" name="mac_address">
<input type="hidden" id="dip_address" name="dip_address">
<input type="hidden" id="sFromPort" name="sFromPort">
<input type="hidden" id="sToPort" name="sToPort">
<input type="hidden" id="addEffect" name="addEffect" value="1">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_port_filtering)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_port_filtering)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="enabled" id="enabled" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr style="display:none">
<td class="item_left">Default Policy</td>
<td><select id="defaultFirewallPolicy" name="defaultFirewallPolicy">
<option value=0 selected>Accept</option>
<option value=1>Drop</option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br />
<table border=0 width="100%"> 
<tr><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td></tr>
<tr id="div_addline"><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="text" style="width:33px" id="ips" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" id="ips" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" id="ips" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" id="sip" name="sip" maxlength="3"> 
<script>dw('<input id=scan name=scan type=button value="'+BT_scan+'" onClick=arpTblClick(\"arpinfo.asp#flag=2\")>')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_protocol)</script></td>
<td><select name="protocol" id="protocol">
<option value="TCP+UDP">TCP+UDP</option>
<option value="TCP">TCP</option>
<option value="UDP">UDP</option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_port_range)</script></td>
<td><input type="text" size="5" id="dFromPort" name="dFromPort" maxlength="5"> - <input type="text" size="5" id="dToPort" name="dToPort" maxlength="5"> (1-65535)</td>
</tr>
<tr style="display:none">
<td class="item_left">Action</td>
<td><select name="action" id="action">
<option value="Drop" selected>Drop</option>
<option value="Accept">Accept</option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" name="comment" id="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" id=add name=add onClick="doSubmit()">')</script></td></tr>
</table>
</form>

<form method=post id="formFilterDel" name="formFilterDel" >
<table border=0 width="100%"> 
<tr><td colspan="6"><b><script>dw(MM_port_filtering_table)</script>&nbsp;&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="6"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_protocol)</script></b></td>
<td class="item_center"><b><script>dw(MM_port_range)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="div_ipportList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id="deleteSelFilter" name="deleteSelFilter" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="delreset" name="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>
