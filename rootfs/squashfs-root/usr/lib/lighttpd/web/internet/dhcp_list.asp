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
<script>
var responseJson;
$(function(){
	var postVar = { topicurl : "setting/getDhcpCliList"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);
			var dhcpListTab=$("#div_dhcpList").get(0);
			var trNode;
			var expires;
			for(var i=0;i<responseJson.length;i++){
				trNode=dhcpListTab.insertRow(-1);
				trNode.align="center";
				expires=responseJson[i].expires;
				expires=expires.replace("days",MM_days);
				expires=expires.replace("MM_always",MM_always);
				if(expires=="")
				  continue;
				trNode.insertCell(0).innerHTML=responseJson[i].ip;
				trNode.insertCell(1).innerHTML=responseJson[i].mac;
				trNode.insertCell(2).innerHTML=expires;
			}							
		}
    });
});
</script>
</head>
<body class="mainbody">
<table width="650"><tr><td>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_dhcp_list)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_dhcp_list)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr align="center">
<!--<td class="item_center"><b><script>dw(MM_hostname)</script></b></td>-->
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_expired_time)</script> (s)</b></td>
<!--<td class="item_center"><b><script>dw(MM_type)</script></b></td>-->
</tr>
<tbody id="div_dhcpList"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</td></tr></table>
</body></html>