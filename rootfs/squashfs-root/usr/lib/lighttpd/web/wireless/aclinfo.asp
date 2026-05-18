<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var f=window.opener.document.wirelessAclAdd;
function selectArpTbl(ip, mac){	
	if(window.opener.closed){
		alert(JS_msg68);
		window.close();
		return false;
	}
	
	var macVal=mac.split(":");	
	f.mac1.value = macVal[0];
	f.mac2.value = macVal[1];
	f.mac3.value = macVal[2];
	f.mac4.value = macVal[3];
	f.mac5.value = macVal[4];
	f.mac6.value = macVal[5];
	window.close();
}

$(function(){
	var postVarList = { topicurl : "setting/getWiFiIpMacTable"};
	postVarList['WiFiIdx']=f.WiFiIdx.value;
   	postVarList = JSON.stringify(postVarList);
	$.ajax({  
       	type : "post",  
		url : " /cgi-bin/cstecgi.cgi",  
		data : postVarList,  
		async : false,  
		success : function(Data){
			responseJson = JSON.parse(Data);
			if(responseJson.length > 0){
				var aclListTab=$("#div_acllist").get(0);
				var trNode;
				for(var i=0;i<responseJson.length;i++){
					trNode=aclListTab.insertRow(-1);
					trNode.align="center";
					trNode.insertCell(0).innerHTML=responseJson[i].mac;
					trNode.insertCell(1).innerHTML="<input type=radio id=DR name=DR onclick=selectArpTbl('"+responseJson[i].ip+"','"+responseJson[i].mac+"')>";
				}
			}
		}
	});
});
</script>
</head>
<body class="mainbody">
<table width=600><tr><td>
<form name="formIpMacTbl" id="formIpMacTbl">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_ipmac_list)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_ipmac_list)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%" id="div_acllist">
<tr align="center">
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()"> &nbsp; &nbsp;\
<input type=button class=button value="'+BT_close+'" onClick="window.close();">')</script></td></tr>
</table>
</form>
</td></tr></table>
</body></html>