webpackJsonp([12],{"2cmP":function(e,t){},"T+/8":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var o=n("Xxa5"),r=n.n(o),i=n("exGp"),a=n.n(i),s={name:"login",data:function(){return{phone:"",verifycode:"",codeText:"获取验证码",disabledCodeBtn:!0}},methods:{sendVerifycode:function(){var e=this;return a()(r.a.mark(function t(){var n,o;return r.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:if(!e.verifyPhone()){t.next=4;break}e.$toast(e.verifyPhone()),t.next=10;break;case 4:return e.countDown(60),n={phone:e.phone},t.next=8,e.$Request.get("/student/getVerificationCode.do",n);case 8:(o=t.sent)&&0===o.code&&e.$toast.success("发送成功");case 10:case"end":return t.stop()}},t,e)}))()},verifyPhone:function(){return this.phone?11!==this.phone.length&&"请输入11位手机号":"请输入手机号"},verifyCode:function(){return!this.verifycode&&"请输入验证码"},countDown:function(e){var t=this;if(0===e)return this.disabledCodeBtn=!0,void(this.codeText="获取验证码");this.disabledCodeBtn=!1,this.codeText="重新发送("+e+")",e--,setTimeout(function(){t.countDown(e)},1e3)},login:function(){var e=this;return a()(r.a.mark(function t(){var n,o,i,a;return r.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:if(console.log(e.verifyPhone(),e.verifyCode()),!e.verifyPhone()&&!e.verifyCode()){t.next=5;break}e.$toast(e.verifyPhone()||e.verifyCode()),t.next=11;break;case 5:return console.log(6666),n={phone:e.phone,verificationCode:e.verifycode},t.next=9,e.$Request.get("/student/queryStudentsByWeChat.do",n);case 9:(o=t.sent)&&0===o.code&&o.list&&(i=o.list,e.$Utils.setItem("flag","islogin",1),e.$Utils.setItem("info",i,1),(a=e.$route.query.returnUrl)?e.$router.replace({path:a}):e.$router.replace({path:"/index"}));case 11:case"end":return t.stop()}},t,e)}))()}}},c={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"login-page"},[n("van-cell-group",[n("van-field",{attrs:{type:"tel",maxlength:"11",center:"",clearable:"",name:"phone",placeholder:"请输入手机号码"},model:{value:e.phone,callback:function(t){e.phone=t},expression:"phone"}}),e._v(" "),n("van-field",{attrs:{type:"number",maxlength:"4",center:"",clearable:"",placeholder:"验证码"},model:{value:e.verifycode,callback:function(t){e.verifycode=t},expression:"verifycode"}},[n("van-button",{attrs:{slot:"button",size:"small",type:"primary",disabled:!e.disabledCodeBtn},on:{click:e.sendVerifycode},slot:"button"},[e._v(e._s(e.codeText))])],1)],1),e._v(" "),n("div",{staticClass:"page-footer"},[n("van-button",{attrs:{round:"",block:"",type:"primary"},on:{click:e.login}},[e._v("登录")])],1)],1)},staticRenderFns:[]};var l=n("VU/8")(s,c,!1,function(e){n("2cmP")},null,null);t.default=l.exports}});
//# sourceMappingURL=12.4ab5f240dd4425aa2cf1.js.map