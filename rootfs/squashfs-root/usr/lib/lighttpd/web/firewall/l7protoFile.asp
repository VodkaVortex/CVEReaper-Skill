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
var flag=eval(location.href.split("#")[1]);
var responseJson;
function selectL7Tbl(num, fileName)
{
	window.opener.document.l7FilterAdd.l7protoFile.value = fileName;
	window.close();
}

function initValue(){
	var trNode,tdNode;
	var l7ListTab=$("#div_l7List").get(0);
	for(var i=1;i<responseJson.length;i++){
		trNode=l7ListTab.insertRow(-1);
		trNode.align="center";
		tdNode=trNode.insertCell(0);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJson[i].idx;	
		tdNode=trNode.insertCell(1);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJson[i].protoFile;	
		tdNode=trNode.insertCell(2);
		tdNode.className="item_center2";	
		tdNode.innerHTML='<input type=\"radio\" name=\"selected'+responseJson[i].idx+'\" onClick=\"selectL7Tbl('+responseJson[i].idx+', \''+responseJson[i].protoFile+'\')\">';
	}
}

$(function(){
	var postVar = { topicurl : "setting/getL7protoFile"};
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
<table width=600><tr><td>
<form method=post name="formIpMacTbl">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_l7_fileList)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_ipmac_list)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr align="center">
<td class="item_center"><b><script>dw("NO.")</script></b></td>
<td class="item_center"><b><script>dw(MM_l7_file)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="div_l7List"></tbody>
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