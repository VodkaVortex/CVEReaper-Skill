<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" >
var responsePartList;
function SelectPath(val){
	parent.opener.self.$("#direct").val(val);
	self.close();
}
function showAllDir(){
	var dirTab = $("#showDirList").get(0);
	var trNode;
	for(var i=1;i<responsePartList.length;i++){
		trNode=dirTab.insertRow(-1);
		trNode.align="left";
		trNode.insertCell(0).innerHTML='<a href=\"#\" id=\"underline\" onclick=\"SelectPath(\''+responsePartList[i].dirName+'\');\">'+responsePartList[i].dirName+'</a>';
	}
}
$(function(){
	var postVar = { topicurl : "setting/ShowAllDir"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responsePartList = JSON.parse(Data);
		}
    });
	showAllDir();
});
</script>
</head>
<body>
<table width=600><tr><td>
<form name="arp_list">
<input type=hidden name=tableType value="1">
<table width=100% border=0 cellpadding=3 cellspacing=1> 
<tr><td class="title"><script>dw(MM_add_media_dir)</script></td></tr>
<tr><td><hr></td></tr>
</table>

<table width=100% border=0 cellpadding=3 cellspacing=3>
<tr class="title4" align=center>
<td><b><script>dw(MM_directory)</script></b></td>
</tr>
<tbody id="showDirList"></tbody>
</table>
</form>
</td></tr></table>
</body></html>
