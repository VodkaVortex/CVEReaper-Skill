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
var responseJson,responseJsonIdx;
var WiFiIdx="0";
var wifiFlag=0;
function wifiStainfo(){
	var postVarBuilt = { "topicurl" : "setting/getWebWlanIdx"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : false,  
        success : function(Data){
			responseJsonIdx = JSON.parse(Data);
			wifiFlag=responseJsonIdx['webWlanIdx'];
		}
    }); 
	
	if(top.frames[0].wifiSelect == 1 || wifiFlag == 1)
		WiFiIdx = "1";
		
	var postVarList = { "topicurl" : "setting/getWiFiStaInfo"};
	postVarList["WiFiIdx"] = WiFiIdx;
    postVarList = JSON.stringify(postVarList);
	$.ajax({  
       	type : "post",  
        	url : " /cgi-bin/cstecgi.cgi",  
        	data : postVarList,  
        	async : false,  
        	success : function(Data){
			if (Data!="{}"){
				Data=Data.substring(0,Data.length-1);
				var stadataRE=Data.replace(/#/g,";");
				var stadata=stadataRE.split(";");
				var strTmp="",i,k;
				for(i=0,k=0;i<stadata.length/7;i++,k=k+7){
					strTmp="<tr>\n";
					strTmp+="<td class=\"item_center2\" align=\"center\" style=\"display:none\">"+stadata[k]+"</td>\n";
					strTmp+="<td class=\"item_center2\" align=\"center\">"+stadata[k+1]+"</td>\n";
					strTmp+="<td class=\"item_center2\" align=\"center\">"+stadata[k+2]+"</td>\n";
					strTmp+="<td class=\"item_center2\" align=\"center\">"+stadata[k+3]+"</td>\n";
					strTmp+="<td class=\"item_center2\" ><table><tr>";
					if (stadata[k+5]>=100)
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div class=rssi4></div></td><td><div class=rssi5></div></td><td>"+stadata[k+5]+"%</td>";
					else if(stadata[k+5]>=80)
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div class=rssi4></div></td><td><div style=\"width:"+stadata[k+4]+"px;height:20px;background-color:#0047af;\"></div></td><td>"+stadata[k+5]+"%</td>";
					else if(stadata[k+5]>=60)
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div class=rssi3></div></td><td><div style=\"width:"+stadata[k+4]+"px;height:20px;background-color:#005fbc;\"></div></td><td>"+stadata[k+5]+"%</td>";
					else if(stadata[k+5]>=40)
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div class=rssi2></div></td><td><div style=\"width:"+stadata[k+4]+"px; height:20px;background-color:#0083d2;\"></div></td><td>"+stadata[k+5]+"%</td>";
					else if(stadata[k+5]>=20)
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div class=rssi1></div></td><td><div style=\"width:"+stadata[k+4]+"px;height:20px;background-color:#00a5e6;\"></div></td><td>"+stadata[k+5]+"%</td>";
					else
						strTmp+="<td><div style=width:50px;></div></td><td align=\"left\"><div style=\"width:"+stadata[k+4]+"px;height:20px;background-color:#00c8fb;\"></div></td><td>"+stadata[k+5]+"%</td>";
	
					strTmp+="</tr></table></td>\n";	
					strTmp+="<td class=\"item_center2\" align=\"center\">"+stadata[k+6]+"</td>\n";
					strTmp+="</tr>";
					$("#div_stalist").after(strTmp);
				}
			}			
		}
    });
}
</script>
</head>
<body class="mainbody" onload="wifiStainfo();">
<script>showToper()</script>
<script>showContainer()</script>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_stationList)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<br>
<table border=0 width="100%">
<tr align="center" id="div_stalist">
<td class="item_center" style="display:none"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_band_width)</script></b></td>
<td class="item_center"><b><script>dw(MM_signal)</script></b></td>
<td class="item_center"><b><script>dw(MM_connected_time)</script></b></td>
</tr>
</table>
<br>
<script>showFooter()</script>
</body></html>