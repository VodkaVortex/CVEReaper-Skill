'use strict';

function sendSMS(thisTelphone) {
  var product = {
    name: '无线WIFI',
    url: 'www.TOTOLINK.net',
    company: '吉翁'
  };
  $.post('http://192.168.10.138:9000/api/sms', {
      telphone: thisTelphone,
      product: product
    },
    function(data, status) {
      if (data == true) {
        alert('发送成功');
      } else {
        alert(data.desc || '发送失败');
      }
    }
  );
}

function verifyPassword(thisTelphone,thisPassword) {
  $.get('http://192.168.10.138:9000/api/sms', {
    telphone: thisTelphone,
    password: thisPassword
  }, function(data, status) {
    if (data == true) {
      alert('密码正确');
    } else {
      alert(data.desc || '登录失败');
    }
  });
}
