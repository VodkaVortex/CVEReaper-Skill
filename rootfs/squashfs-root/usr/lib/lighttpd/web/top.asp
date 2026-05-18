<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<link href="style/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript">
var wifiSelect=0;
var responseJson;
$(function(){
	var postVarBuilt = { "topicurl" : "setting/getWebWlanIdx"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : true,  
        success : function(Data){
			if(Data.indexOf("web_timeout!")<0){
				responseJson = JSON.parse(Data);
				wifiSelect=responseJson['webWlanIdx'];
				top.frames['view'].location.reload(true);
			}
		}
    }); 
})
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="top_left">&nbsp;</td>
<td class="top_center">&nbsp;</td>
<td class="top_right" align="right">&nbsp;</td>
</tr>
</table>
</body>
</html>
