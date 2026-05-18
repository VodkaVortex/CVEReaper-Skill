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
var f=window.opener.document.wirelessWdsAdd;
var str,v_ScanAp;;

function show_div(id,show){
	if (show){
		window.opener.document.getElementById(id).style.display = "";
	}	
	else{
		window.opener.document.getElementById(id).style.display = "none";
	}
}

function CreateEncrypType(_val){
	var new_options,new_values;

	switch(_val){
		case "NONE":
			new_values  = ["NONE"];
			new_options = [MM_disable];
			break;
		case "WEP":
			new_values  = ["OPEN","SHARED"];
			new_options = [MM_open_system,MM_shared_key];
			break;
		default:
			new_values  = ["TKIP","AES"];
			new_options = ["TKIP","AES"];
			break;
	}	
	CreateOptions(new_options, new_values);
}

function CreateOptions(optionValue,valueArray)
{
	var valueOptions;

	$('#ApCliEncrypType',window.opener.document).empty();
	if(valueArray == undefined){
		valueOptions = optionValue;
	}
	else {
		valueOptions = valueArray;
	}
	 
	for(var i = 0; i < optionValue.length; i++){
		var tmp="<option value='"+optionValue[i]+"'>"+valueOptions[i]+"</option>";
		$("#ApCliEncrypType",window.opener.document).append(tmp);
	}
}

function select_SSID(index){	
	if(window.opener.closed){
		alert(JS_msg68);
		window.close();
		return false;
	}
	
	var auth_str;
	var p1="#m1t7k|";
	var p2=";m1t7k|";

	f.ApCliSsid.value=str.split(p1)[index].split(p2)[1];
	var selectap_mac = $('input[name="selectap"]:checked').val();
	bssid_tmp=selectap_mac.split(":");
	f.mac1.value=bssid_tmp[0];
	f.mac2.value=bssid_tmp[1];
	f.mac3.value=bssid_tmp[2];
	f.mac4.value=bssid_tmp[3];
	f.mac5.value=bssid_tmp[4];
	f.mac6.value=bssid_tmp[5];
	
	show_div("div_apcli_encryp_type",false);
	show_div("div_apcli_key_format",false);
	show_div("div_apcli_wep_key",false);
	show_div("div_apcli_wpa_key",false);

	f.ApCliChannel.value=str.split(p1)[index].split(p2)[0];

	auth_str=str.split(p1)[index].split(p2)[3];
	if (auth_str=="NONE") {
		CreateEncrypType(auth_str);
		f.ApCliAuthMode.value="NONE";
		f.ApCliEncrypType.value="NONE";
	}else if (auth_str=="WEP") {
		show_div("div_apcli_encryp_type",true);
		show_div("div_apcli_key_format",true);
		show_div("div_apcli_wep_key",true);
		f.ApCliKeyStr.disabled=false;
		f.ApCliAuthMode.value="WEP";
		CreateEncrypType(auth_str);
		f.ApCliEncrypType.value=auth_str;
		f.ApCliKeyStr.value="";
	}else if (auth_str.search("WPA") != -1) {
		show_div("div_apcli_encryp_type",true);
		show_div("div_apcli_key_format",true);
		show_div("div_apcli_wpa_key",true);	
		f.ApCliWPAPSK.disabled=false;
		if (auth_str.split("/")[0] =="WPA2PSK" || auth_str.split("/")[0] =="WPAPSKWPA2PSK"){
			f.ApCliAuthMode.value="WPA2PSK";
		}else{
			f.ApCliAuthMode.value="WPAPSK";
		}
		CreateEncrypType(auth_str);
		if (auth_str.split("/")[1]=="TKIP"){
			f.ApCliEncrypType.value="TKIP";
		}else if (auth_str.split("/")[1] == "AES" || auth_str.split("/")[1] == "TKIPAES"){ 
			f.ApCliEncrypType.value="AES";
		}
		f.ApCliKeyType.value="1";
		f.ApCliWPAPSK.value="";
	}

	window.close(); 
}

$(function(){
	var postVarList = { topicurl : "setting/getWiFiApcliScan"};
	postVarList['WiFiIdx'] = f.WiFiIdx.value;
	postVarList['WdsScan'] = "1";
    postVarList = JSON.stringify(postVarList);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarList,  
        beforeSend:function(){
			$('#div_aplist_head').nextAll().remove();
			var _html = '<tr><td colspan=7 style="text-align:center;"><img width=60 src=\"/style/load.gif\" style="margin-top:50px;margin-bottom:50px;"/></td></tr>';
			$('#div_aplist').append(_html);
		},
        success : function(Data){
        	responseJson = JSON.parse(Data);
			v_ScanAp=responseJson['ScanAp'];
			if (-1!= v_ScanAp.indexOf(";m1t7k|")){
				str=v_ScanAp;
				var i=0,j=0;
				var str1;		
				var p1="#m1t7k|";
				var p2=";m1t7k|";
				var strTmp="";
				var signal;

				str1 = str.substr(0,-7);
				var str_arr_temp1 =[];
				var str_arr_temp = str.split(p1);
				//Delete empty elements
				for(var k=0; k < str_arr_temp.length; k++)
				{
					if(0 == str_arr_temp[k].length) continue;
					str_arr_temp1.push(str_arr_temp[k]);
				}
				//sort
 				str_arr_temp1 = sort_diy(str_arr_temp1);
				str = str_arr_temp1.join(p1);
				var str_arr = [];
				//After sorting, from the array
				for(var i = 0; i<str_arr_temp1.length; i++ )
				{
					str_arr[i] = str_arr_temp1[i].split(p2);
				}
				for(var i = 0; i<str_arr.length; i++){
					if(str_arr[i][1]=="unknown")continue;
					strTmp+="<tr align=\"center\">\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][0]+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][1].replace(eval("/ /gi"),'&nbsp;')+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][2]+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][3]+"</td>\n";					
					signal=(200+2*str_arr[i][4]);
					if (signal>=100) signal=100;
					strTmp+="<td class=\"item_center2\">"+signal+"%"+"</td>\n";
					strTmp+="<td class=\"item_center2\">"+str_arr[i][5]+"</td>\n";
 					strTmp+="<td><input type=radio name=selectap id=selectap value="+str_arr[i][2]+" onclick=\"select_SSID("+i+")\"></td>"; 
					strTmp+="</tr>";				
				}
				$('#div_aplist_head').nextAll().remove();
				$('#div_aplist').append(strTmp);			
			}
			$(":input").attr('disabled',false);
		}
	});
});
</script>
</head>
<body class="mainbody">
<table width="650"><tr><td>
<form name="site_survey" id="site_survey">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_site_survey_table)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_sitesurvey)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>
<table border=0 width="100%" id="div_aplist" name="div_aplist">
<tr id="div_aplist_head" align="center">
<td class="item_center"><b><script>dw(MM_channel)</script></b></td>
<td class="item_center"><b><script>dw(MM_ssid)</script></b></td>
<td class="item_center"><b>BSSID</b></td>
<td class="item_center"><b><script>dw(MM_security_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_signal)</script></b></td>
<td class="item_center"><b><script>dw(MM_mode)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button value='+BT_scan+' id=refresh name=refresh onClick="window.location.reload()">')</script></td></tr>
</table>
</form> 
</td></tr></table>
</body></html>