<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<title></title>
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
var osplatfrom="",v_upnpEnabled,v_getUpnpTable,responseJson;
function resultFun(data){
	if(data=="" || data==null)
		win78reload();
	else
		window.location.href='/adm/upnp.asp';
}
function errorFun(readyState,status){
	win78reload();
}
function win78reload(){
	setTimeout(function(){Ajax.getInstance('/login.asp','',0,resultFun,errorFun);Ajax.get();},"5000");
}
function doSubmit(){
	var postVar ={"topicurl":"setting/setMiniUPnPConfig"};
	postVar['upnpEnbl']  = $('#upnpEnbl').val();
	uiPost(postVar);
}
function initValue(){
	var f=document.upnpCfg;
	v_upnpEnabled=responseJson['upnpEnabled'];
	v_getUpnpTable=responseJson['getUpnpTable'];
	if (v_upnpEnabled == 1) {
		$("#upnpEnbl")[0].selectedIndex = 1;
		$("#div_upnplist").show();
	}
	else {
		$("#upnpEnbl")[0].selectedIndex = 0;
		$("#div_upnplist").hide();
	}
	$("#div_showUpnpList")
	var trNode;
	var igmpListTab=$("#div_showUpnpList").get(0);
	if(v_getUpnpTable!="none"){
		v_getUpnpTable=v_getUpnpTable.substring(0,v_getUpnpTable.length-1)
		v_getUpnpTable=v_getUpnpTable.replace("#",":");
		v_getUpnpTable=v_getUpnpTable.split(":");
		for(var i=0,k=0;i<v_getUpnpTable.length/6;i++,k=k+6){
			trNode=igmpListTab.insertRow(-1);
			trNode.align="center";
			trNode.insertCell(0).innerHTML=i+1;		
			trNode.insertCell(1).innerHTML=v_getUpnpTable[k];
			trNode.insertCell(2).innerHTML=v_getUpnpTable[k+1];
			trNode.insertCell(3).innerHTML=v_getUpnpTable[k+2];
			trNode.insertCell(4).innerHTML=v_getUpnpTable[k+3];
			trNode.insertCell(5).innerHTML=v_getUpnpTable[k+4];
			trNode.insertCell(6).innerHTML=v_getUpnpTable[k+5];
		}
	}
}
$(function(){
	var postVar = { topicurl : "setting/getMiniUPnPConfig"};
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
</script>
</head>

<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="upnpCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_upnp_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_upnp_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="upnpEnbl" name="upnpEnbl" onChange="doSubmit()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br />
<div id="div_upnplist" style="display:none">
<table border=0 width="100%">
<tr><td colspan="7"><b><script>dw(MM_upnp_table)</script></b></td></tr>
<tr><td colspan="7"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_protocol)</script></b></td>
<td class="item_center"><b><script>dw(MM_external_port)</script></b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_internal_port)</script></b></td>
<td class="item_center"><b><script>dw(MM_status)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
</tr>
<tbody id="div_showUpnpList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>
</form>
<script>showFooter()</script>
<iframe id="win78iframe" class="hidden" name="win78target"></iframe>
</body></html>