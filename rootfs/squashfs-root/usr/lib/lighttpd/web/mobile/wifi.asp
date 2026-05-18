<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
    <!-- HTTP 1.1 -->  
    <meta http-equiv="pragma" content="no-cache">  
    <!-- HTTP 1.0 -->  
    <meta http-equiv="cache-control" content="no-cache">  
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>TOTOLINK</title>
    <link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/csstyle.css">
    <script language="javascript" src="js/jquery-1.11.1.min.js"></script>
    <script language="javascript" src="js/mobile.js"></script>
</head>
<body>
    <input type="hidden" id="wantype">
    <input type="hidden" id="pppoe_user">
    <input type="hidden" id="pppoe_pass">
    <input type="hidden" id="wanip">
    <input type="hidden" id="wanmask">
    <input type="hidden" id="wangw">
    <input type="hidden" id="wandns">
	<div class="container-fluid" id="cs_body_wifi">
		<div class="row cs-header">
			<h4><i class="glyphicon glyphicon-asterisk"></i><script>dw(MB_wifi_setting)</script></h4>
		</div>
        
		<div id="cs_wifi">
            <div class="cs-h-10"></div>
            <div class="container">
                <form class="">
                <div class="form-group">
                    <label class="cs-font-normal" for="wifissid"><script>dw(MB_wifi_ssid)</script></label>
                    <input type="text" class="form-control" id="wifissid" maxlength="32">
                </div>
                <div class="form-group has-feedback">
                    <label class="cs-font-normal" for="wifikey"><script>dw(MB_wifi_pass)</script></label>
                    <span id="switch_eye" class="pos-right"><i class="glyphicon glyphicon-eye-open"></i></span>
                    <input type="password" class="form-control" id="wifikey" maxlength="63">
                </div>
                <div class="form-group">
                    <label class="cs-font-normal"><script>dw(MB_pwd_length)</script></label>
                </div>
                <div class="form-group" id="div_err">
                    <label class="cs-err" id="err_msg"></label>
                </div>
                <div class="cs-h-20"></div>
                <div class="row">
                    <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-default" onClick="doBack()"><script>dw(MM_back)</script></button></div>
                    <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-cs-black" onClick="doPost()"><script>dw(MB_done)</script></button></div>
                </div>
                </form>
            </div>
		</div>
	</div>
    <div class="container-fluid" id="cs_result" style="display: none;">
        <div id="cs_connect">
            <div class="cs-h-200"></div>
            <div class="container col-xs-10 col-xs-offset-1">
                <div align="center">
                    <img src="img/connecting.png" class="img-responsive cs-img-6">
                    <div class="cs-h-10"></div>
                    <div class="result_bar">
                        <div id="result_bar" ></div>
                    </div>
                    <div class="cs-h-10"></div>
                    <h5><script>dw(MB_apply)</script></h5>
                </div>
            </div>
        </div>

        <!-- Successful -->
        <div id="cs_success" style="display:none">
            <div class="container" align="center">
                <div class="cs-h-30"></div>
                <img src="img/connect_on.png" class="img-responsive cs-img">
            </div>
            <div class="cs-h-30"></div>
            <div class="container">
                <div align="center">
                    <h4><script>dw(MB_success)</script></h4>
                </div>
                <div class="cs-h-10"></div>
                <div align="center">
                    <span><script>dw(MB_changed)</script></span>
                </div>
            </div>
            <div class="cs-h-30"></div>
            <div class="container">
                <div class="h4" style="border-bottom: 1px solid #fff; padding-bottom: 5px; "><script>dw(MM_wireless_info)</script></div>
                <div class="row">
                    <div class="col-xs-6"><script>dw(MB_wifi_ssid)</script></div>
                    <div class="col-xs-6" id="wifi_ssid"></div>
                </div>
                <div class="row">
                    <div class="col-xs-6"><script>dw(MB_wifi_pass)</script></div>
                    <div class="col-xs-6" id="wifi_pass"></div>
                </div>
            </div>
            <div class="cs-h-30"></div>
            <div>
                <button type="button" class="btn btn-block btn-cs-black" style="margin-left: 25%;width: 50%;" id="cs_ok_btn" align="center"><script>dw(BT_ok)</script></button>
            </div>
            <div class="cs-h-20"></div>
        </div>
        <!-- /. Successful -->

        <!-- Failed -->
        <div id="cs_fail" style="display:none">
        <div class="container col-xs-10 col-xs-offset-1">
            <div class="container" align="center">
                <div class="cs-h-30"></div>
                <img src="img/connect_off.png" class="img-responsive cs-img">
            </div>
            <div class="cs-h-30"></div>
            <div class="container">
                <div align="center">
                    <h5><script>dw(MB_fail)</script></h5>
                    <h5><script>dw(MB_configure)</script></h5>
                </div>   
            </div>        
            <div class="cs-h-30"></div>
            <div class="row">
                <div class="col-xs-8 col-xs-offset-2">
                    <button type="button" class="btn btn-lg btn-block btn-cs-black" id="cs_again_btn"><script>dw(BT_try_again)</script></button>
                </div>
            </div>
            <div class="cs-h-20"></div>
        </div>
        </div>
        <!-- /. Failed -->
    </div>
    <script language="javascript" src="js/bootstrap.min.js"></script>
    <script language="javascript" src="js/router.js"></script>
	<script>
		function doBack() {
			// gotoUrl('internet.asp');
			history.go(-1);
		}

		function doPost() {
			if (!IsValidStr($('#wifissid'),MB_wifi_ssid,1)) return false;
			if (!IsValidStr($('#wifikey'),MB_wifi_pass,2)) return false;
            $('#cs_wifi').hide();
            $('#cs_connect').show();

            var postVar={"topicurl" : "setting/setEasyWizard"};
            postVar['wanConnectionMode'] = $('#wantype').val();
            postVar['wan_pppoe_user'] = $('#pppoe_user').val();
            postVar['wan_pppoe_pass'] = $('#pppoe_pass').val();    
            postVar['wan_ipaddr'] = $('#wanip').val();
            postVar['wan_netmask'] = $('#wanmask').val();
            postVar['wan_gateway'] = $('#wangw').val();
            postVar['wan_primary_dns'] = $('#wandns').val();
            postVar['SSID']=$('#wifissid').val();
            postVar['WPAPSK']=$('#wifikey').val();
            postVar['AuthMode']="WPA2PSK";
            postVar['EncrypType']="AES";
            postVar = JSON.stringify(postVar);
            $.ajax({  
                type : "post",  
                url : " /cgi-bin/cstecgi.cgi",  
                data : postVar,  
                async : false,  
                success : function(Data){
                }
            });

            $("#cs_body_wifi").hide();
            $("#cs_result").show();
            var flag = 0;
            var flag_obj = setInterval(function(){
                if (flag < 16) {
                    flag++;
                    $('#result_bar').css('width',6.25*flag+'%');
                }else{
                    clearInterval(flag_obj);
                    $('#cs_success').show();
                    $('#cs_connect,#cs_fail').hide();
                }
            },1000);

            $("#wifi_ssid").html($('#wifissid').val());
            $("#wifi_pass").html($('#wifikey').val());
		}

		$(function() {
			getWizardCfg(2);
            var url_href = location.hash.substr(1);
            var url_href = url_href.split('&');
            for (var i = 0; i < url_href.length; i++) {
                url_href[i] = url_href[i].split('=');
            };
            if(0 == url_href[0][1]){//Static
                $("#wantype").val("static");
                $("#wanip").val(url_href[1][1]);
                $("#wanmask").val(url_href[2][1]);
                $("#wangw").val(url_href[3][1]);
                $("#wandns").val(url_href[4][1]);
            }else if(3 == url_href[0][1]){
                $("#wantype").val("pppoe");
                $("#pppoe_user").val(url_href[1][1]);
                $("#pppoe_pass").val(url_href[2][1]);
            }else{//DHCP
                $("#wantype").val("dhcp");
            }
			$('#switch_eye').on('click', function(event) {
				var $i_element = $(this).find('i');
				if ($i_element.hasClass('glyphicon-eye-open')) {
					$i_element.removeClass('glyphicon-eye-open').addClass('glyphicon-eye-close');
					$('#wifikey').attr('type','text');
				} else {
					$i_element.removeClass('glyphicon-eye-close').addClass('glyphicon-eye-open');
					$('#wifikey').attr('type','password');
				}
			});	

            $('#cs_ok_btn').on('click', function(event) {
                if (navigator.userAgent.indexOf("Firefox") != -1 || navigator.userAgent.indexOf("Chrome") !=-1) {
                   location.href="about:blank";
                   close();
                } else {
                   opener = null;
                   open("", "_self");
                   close();
                }
            });		
		});
	</script>
</body>
</html>