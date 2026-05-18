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
var responseJsonLan, responseJson;
var rules_num, v_lanip, v_lanmsk, v_enabled;
var arr_ip, arr_mac, arr_cmnt;
window.onerror=function(){return true;} 
function disableAddFiled(){	
	$("#mac1, #mac2, #mac3, #mac4, #mac5, #mac6, #comment").attr("disabled",true);
	$("#ip").attr("disabled",true);
	$("#add, #scan").attr("disabled",true);
}
function disableDelButton(){	
	$("#del_sel, #delreset").attr("disabled",true);
}
function initValue(){
	v_lanip=responseJsonLan['lanIp'];
	v_lanmsk=responseJsonLan['lanNetmask'];
	v_enabled=responseJson['enable'];		
	rules_num=responseJson['RuleNum'];
	
	if (v_enabled==0) {
		disableAddFiled();
		disableDelButton();
	}
	if(v_enabled==1)
		$("#enabled")[0].selectedIndex=1;
	else 
		$("#enabled")[0].selectedIndex=0;	
	
	if (rules_num == 0)
		disableDelButton();
	else{
		arr_ip = responseJson['IpRules'].split(";");
		arr_mac = responseJson['MacRules'].split(";");
		arr_cmnt = responseJson['Comments'].split(";");
	}
	if (v_lanip !="") 
		decomIP2($(":input[name=ips]"),v_lanip,0);
	
	var dhcpListTab=$("#div_staticDhcpList").get(0);
	var trNode;

	for(var i=1; i<parseInt(rules_num)+1; i++){
		trNode=dhcpListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML = i;
		trNode.insertCell(1).innerHTML = arr_ip[i-1];
		trNode.insertCell(2).innerHTML = arr_mac[i-1];
		trNode.insertCell(3).innerHTML = arr_cmnt[i-1];
		trNode.insertCell(4).innerHTML = '<input type=\"checkbox\" id=id_'+(i-1)+' name=name_'+(i-1)+' value=value_'+(i-1)+'>';		
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
	
	var postVar = { topicurl : "setting/getStaticDhcpConfig"};
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
	if ($("#enabled").val()=="0") {
		disableAddFiled();
		disableDelButton();
	}

	var postVar ={"topicurl":"setting/setStaticDhcpConfig"};
	postVar['enabled']= $("#enabled").val();
	postVar['addEffect']= "1";
	uiPost(postVar);
}
function deleteClick(){
	var postVar="", delIndex = "";
	var delNum = 0;
	
	postVar ={"topicurl":"setting/delStaticDhcpConfig"};
	for (i=0; i< rules_num; i++) {
		var tmpNode=$("#id_"+i).get(0);
		if (tmpNode.checked == true){
			delIndex += (i+";");
			delNum++;
		}
  	}
	if(delNum == 0){
		alert(JS_msg36);
		return false;
	}
	delIndex = delIndex.substring(0, delIndex.length-1);
	postVar['delIndex'] = delIndex;
	postVar['delNum'] = delNum;
	uiPost(postVar);
}
function saveChanges(){
	if (rules_num >= 10){
		alert(JS_msg28);
		return false;
	}
	
	var netip=v_lanip.replace(/\.\d{1,3}$/,".");
	$("#ip_address").val(netip+$("#ip").val());	
	if (!checkVaildVal.IsVaildIpAddr($("#ip_address").val(), MM_ipaddr)) return false;
	if (!checkVaildVal.IsSameIp($("#ip_address").val(), v_lanmsk, v_lanip)) {alert(JS_msg38);return false;}
	if ($("#ip_address").val()== v_lanip) {alert(JS_msg39);return false;}
	
	var mac_tmp=combinMAC2($("#mac1").val(),$("#mac2").val(),$("#mac3").val(),$("#mac4").val(),$("#mac5").val(),$("#mac6").val());
	$("#mac_address").val(mac_tmp);
	if (!checkVaildVal.IsVaildMacAddr($("#mac_address").val()))
		return false;
	
	for (var i=0; i<rules_num; i++){
		if (($("#mac_address").val()==arr_mac[i]) || 
			($("#mac_address").val().toLowerCase()==arr_mac[i].toLowerCase()) || 
			($("#ip_address").val()==arr_ip[i])) {
			alert(JS_msg29);
			return false;
		}
	}
	if ($("#comment").val()!=""){if (!checkVaildVal.IsVaildString($("#comment").val(), MM_comment,2)) return false;}	
	return true;
}
function doSubmit(){
	if (saveChanges()==false)
		return false;
	
	var postVar ={"topicurl":"setting/setStaticDhcpConfig"};
	postVar['enabled']= $("#enabled").val();
	postVar['addIp']=$("#ip_address").val();
	postVar['addMac']=$("#mac_address").val();
	postVar['addCmnt']=$("#comment").val();
	postVar['addEffect']="0";
	
	uiPost(postVar);
}
function resultFun(data){
	if(data=="" || data==null)
		win78reload();
	else
		window.location.href='/internet/static_dhcp.asp';
}
function errorFun(readyState,status){win78reload();}
function win78reload(){setTimeout(function(){Ajax.getInstance('/login.asp','',0,resultFun,errorFun);Ajax.get();},"5000");}
function arpTblClick(url){	
	openWindow(url,"_blank",700,400);
}
</script>
</head>

<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form name="formStaticDhcpAdd"  id="formStaticDhcpAdd">
<input type="hidden" id="addEffect"name="addEffect" value="1">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_static_dhcp_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_static_dhcp_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="enabled" name="enabled" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br />
<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td>
<tr id="div_addline"><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="hidden" id="ip_address" name="ip_address">
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" maxlength="3" id="ip" name="ip"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_macaddr)</script></td>
<td><input type="hidden" id="mac_address" name="mac_address">
<input type="text" style="width:28px" maxlength="2" name="mac1" id="mac1" onFocus="this.select();" onKeyUp="HWKeyUp('mac',1,event);" onKeyDown="return HWKeyDown('mac', 1,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac2" id="mac2" onFocus="this.select();" onKeyUp="HWKeyUp('mac',2,event);" onKeyDown="return HWKeyDown('mac', 2,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac3" id="mac3" onFocus="this.select();" onKeyUp="HWKeyUp('mac',3,event);" onKeyDown="return HWKeyDown('mac', 3,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac4" id="mac4" onFocus="this.select();" onKeyUp="HWKeyUp('mac',4,event);" onKeyDown="return HWKeyDown('mac', 4,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac5" id="mac5" onFocus="this.select();" onKeyUp="HWKeyUp('mac',5,event);" onKeyDown="return HWKeyDown('mac', 5,event)">:
<input type="text" style="width:28px" maxlength="2" name="mac6" id="mac6" onFocus="this.select();" onKeyUp="HWKeyUp('mac',6,event);" onKeyDown="return HWKeyDown('mac', 6,event)">
<script>dw('<input id="scan" name=scan type=button value="'+BT_scan+'" onClick=arpTblClick(\"../firewall/arpinfo.asp#flag=5\")>')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" id="comment" name="comment" maxlength="20"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" id="add" onClick="doSubmit()">')</script></td></tr>
</table>
</form>

<form name="formStaticDhcpDel" id="formStaticDhcpDel">
<table border=0 width="100%">
<tr><td colspan="5"><b><script>dw(MM_static_dhcp_table);dw(JS_msg59);</script></b></td></tr>
<tr><td colspan="5"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="div_staticDhcpList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" id="del_sel" onClick="deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" id="delreset" onClick="resetForm()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
<iframe id="win78iframe" class="hidden" name="win78target"></iframe>
</body></html>
