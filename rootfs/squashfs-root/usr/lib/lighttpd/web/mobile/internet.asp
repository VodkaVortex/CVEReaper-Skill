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
    <style>
    .none_p_m{padding-right: 0 !important; padding-left: 0 !important; }
    .container{padding-right: 30px;padding-left: 30px;}
    </style>
</head>
<body>
	<div class="container-fluid">
		<div class="row cs-header">
			<h4><i class="glyphicon glyphicon-asterisk"></i><script>dw(MB_wan_setting)</script></h4>
		</div>
        
		<div class="row" id="cs_tab">
			<div data-cs-index="pppoe" class="col-xs-4 cs-p-0 active">
            	<div class="btn btn-block"><script>dw(MB_pppoe)</script></div>
            </div>			
			<div data-cs-index="dhcp" class="col-xs-4 cs-p-0">
            	<div class="btn btn-block"><script>dw(MB_dhcp)</script></div>
            </div>
			<div data-cs-index="static" class="col-xs-4 cs-p-0">
            	<div class="btn btn-block"><script>dw(MB_static)</script></div>
            </div>
		</div>
        
		<div id="cs_internet">
            <!-- PPPoE -->
            <div id="tab_pppoe" style="display: none;">
                <div class="cs-h-10"></div>
                <div class="container">
                    <p><script>dw(MB_isp_info)</script></p>
                    <p id="ppp_err_msg" style="display: none; color:#FFFF00" align="center"></p>
                </div>
                <div class="cs-h-20"></div>
                <div class="container">
                    <form class="">
                    <div class="form-group">
                        <label for="pppoe_user"><script>dw(MB_pppoe_user)</script></label>
                        <input type="text" class="form-control" id="pppoe_user" maxlength="32">
                    </div>
                    <div class="form-group has-feedback">
                        <label for="pppoe_pass"><script>dw(MB_pppoe_pass)</script></label>
                        <span id="switch_eye" class="pos-right"><i class="glyphicon glyphicon-eye-open"></i></span>
                        <input type="password" class="form-control" id="pppoe_pass" maxlength="32">
                    </div>
                    <div class="cs-h-50"></div>
                    <div class="row">
                        <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-default" onClick="doBack()"><script>dw(BT_back)</script></button></div>
                        <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-cs-black" onClick="doPost(3)"><script>dw(BT_next)</script></button></div>
                    </div>
                    </form>
                </div>
            </div>
            <!-- /. PPPoE -->
            
            <!-- Dynamic IP -->
            <div id="tab_dhcp" style="display: none;">
                <div class="cs-h-10"></div>
                <div class="container">
                	<p><script>dw(MB_wan_status)</script></p>
                   <p id="wanip_err_cn" style="display: none; color:#FFFF00" align="center"><script>dw(MB_dhcp_info)</script><spand id="change_lanip"></spand></p>
                    <p id="wanip_err_en" style="display: none; color:#FFFF00" align="center"><script>dw(MB_dhcp_info)</script><spand id="change_lanip"></spand>&nbsp;automaticalty.</p>  
                </div>
                <div class="cs-h-20"></div>
                <div class="container cs-font-blue cs-input">
                    <form class="">
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_ip)</script></span>
                        <div class="col-xs-6 none_p_m" id="myip"></div>
                    </label>
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_mask)</script></span>
                        <div class="col-xs-6 none_p_m" id="mymask"></div>
                    </label>
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_gw)</script></span>
                        <div class="col-xs-6 none_p_m" id="mygw"></div>
                    </label>
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_ddns)</script></span>
                        <div class="col-xs-6 none_p_m" id="mydns"></div>
                    </label>
                    </form>
                    <div class="cs-h-50"></div>
                    <div class="row">
                        <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-default" onClick="doBack()"><script>dw(BT_back)</script></button></div>
                        <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-cs-black" onClick="doPost(1)"><script>dw(BT_next)</script></button></div>
                    </div>
                </div>
            </div>
            <!-- /. Dynamic IP -->
            
            <!-- Static IP -->
            <div id="tab_static" style="display: none;">
                <div class="cs-h-10"></div>
                <div class="container">
                    <p><script>dw(MB_static_info)</script></p>
                    <p id="err_msg" style="display: none; color:#FFFF00" align="center"></p>
                </div>
                <div class="cs-h-20"></div>
                <div class="container cs-font-blue cs-input">
                    <form class="">
                    <input type="hidden" id="lanip">
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_ip)</script></span>
                        <input type="text" class="col-xs-6 none_p_m" id="wanip" maxlength="15" onBlur="setMask()">
                    </label>
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_mask)</script></span>
                        <input type="text" class="col-xs-6 none_p_m" id="wanmask" maxlength="15">
                    </label>
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_gw)</script></span>
                        <input type="text" class="col-xs-6 none_p_m" id="wangw" maxlength="15">
                    </label>
                    <label>
                    	<span class="col-xs-6 none_p_m"><script>dw(MB_ddns)</script></span>
                        <input type="text" class="col-xs-6 none_p_m" id="wandns" maxlength="15">
                    </label>
                    </form>
                    <div class="cs-h-50"></div>
                    <div class="row">
                        <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-default" onClick="doBack()"><script>dw(BT_back)</script></button></div>
                        <div class="col-xs-6"><button type="button" class="btn btn-lg btn-block btn-cs-black" onClick="doPost(0)"><script>dw(BT_next)</script></button></div>
                    </div>
                </div>
            </div>
            <!-- /. Static IP -->
            <div class="cs-h-10"></div>
		</div>
	</div>
    <script language="javascript" src="js/bootstrap.min.js"></script>
    <script language="javascript" src="js/router.js"></script>
	<script>
		function setMask() {
			var mask="",ip=$('#wanip').val().split(".")[0];
			if ((ip>=0&&ip<127)&&($('#wanip').val()!=0)) {
				mask="255.0.0.0";//A type
			} else if (ip>127&&ip<192) {
				mask="255.255.0.0";//B type
			} else if (ip>=192&&ip<224) {
				mask="255.255.255.0";//C type
			} 
			$('#wanmask').val(mask);
		}

		function doBack() {
            gotoUrl('home.asp');
		}

		function doPost(type) {
            var data="";
			if (type==0) {
				if (!IsValidIP($('#wanip'),MB_ip)) return false;
                if (!SameIp($('#wanip').val(),$('#lanip').val())) {$('#err_msg').html(JS_msg44);$('#err_msg').css('display','block');return false;}
				if (!IsValidMask($('#wanmask'),MB_mask)) return false;
				if (!IsValidIP($('#wangw'),MB_gw)) return false;
                if (!IsIpSubnet($('#wangw').val(),$('#wanmask').val(),$('#wanip').val())) {$('#err_msg').html(JS_msg44);$('#err_msg').css('display','block');return false;}
                if (!IsSameIP($('#wangw'),$('#wanip'),MB_gw)) return false;
				if (!IsValidIP($('#wandns'),MB_ddns)) return false;
				if (!IsSameIP($('#wandns'),$('#wanip'),MB_ddns)) return false;
                data="wantype="+type+"&wanip="+$('#wanip').val()+"&wanmask="+$('#wanmask').val()+"&wangw="+$('#wangw').val()+"&wandns="+$('#wandns').val();
			} else if (type==3) {
				if (!IsValidStr($('#pppoe_user'),MB_pppoe_user,0)) return false;
				if (!IsValidStr($('#pppoe_pass'),MB_pppoe_pass,0)) return false;
                data="wantype="+type+"&pppoe_user="+$('#pppoe_user').val()+"&pppoe_pass="+$('#pppoe_pass').val();
			} else {
                data="wantype="+type;
            }
            gotoUrl("wifi.asp#"+data);
		}	

        $(function() {
            getWizardCfg(1);
            var url_href = location.href.substring(location.href.indexOf('=')+1);//url_href 1 DHCP 2 PPPoE 3 Static ip 4 DHCP modify WAN ip
			if(1 == url_href){//DHCP
				$("#tab_static,#tab_pppoe").hide();
				$("#tab_dhcp").show();
                $($('#cs_tab').find('.btn')[1]).parent().addClass('active').siblings().removeClass('active');
                getDial("DHCP");    
            }else if(2 == url_href){//PPPoE
                $("#tab_dhcp,#tab_static").hide();
                $($('#cs_tab').find('.btn')[0]).parent().addClass('active').siblings().removeClass('active');
                $("#tab_pppoe").show();
            }else if(3 == url_href){//static IP
                $($('#cs_tab').find('.btn')[2]).parent().addClass('active').siblings().removeClass('active');
                $("#tab_dhcp,#tab_pppoe").hide();
                $("#tab_static").show();
            }else if(4 == url_href){//modify WAN IP
                getDial("DHCP");
                $("#tab_static,#tab_pppoe").hide();
                $("#tab_dhcp").show();
                $($('#cs_tab').find('.btn')[1]).parent().addClass('active').siblings().removeClass('active');
                $("#tab_static,#tab_pppoe").hide();
                $("#change_lanip").html(getCookie("change_lanip"));
                if(getCookie("languageType")=="EN"){
                     $("#tab_dhcp,#wanip_err_en").show();
                }else{
                    $("#tab_dhcp,#wanip_err_cn").show();
                }
			}else{//Skip WAN detect
                $("#tab_static,#tab_pppoe").hide();
                $("#tab_dhcp").show();
                $($('#cs_tab').find('.btn')[1]).parent().addClass('active').siblings().removeClass('active');
                getDial("DHCP"); 
            }

			$('#cs_tab').on('click', function(event) {
				event.preventDefault();
				var current = event.target;
				if ($(current).parent().hasClass('active')) {
					return false;
				}
				var type = $(current).parent().data('cs-index');
				$(current).parent().addClass('active').siblings().removeClass('active');
				$('#tab_'+type).css('display','block').siblings().css('display','none');
			});	

			$('#switch_eye').on('click', function(event) {
				var $i_element = $(this).find('i');
				if ($i_element.hasClass('glyphicon-eye-open')) {
					$i_element.removeClass('glyphicon-eye-open').addClass('glyphicon-eye-close');
					$('#pppoe_pass').attr('type','text');
				} else {					
					$i_element.removeClass('glyphicon-eye-close').addClass('glyphicon-eye-open');
					$('#pppoe_pass').attr('type','password');
				}
			});
		});
	</script>

</body>
</html>
