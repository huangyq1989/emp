webpackJsonp([2],{"5zde":function(t,e,n){n("zQR9"),n("qyJz"),t.exports=n("FeBl").Array.from},Gu7T:function(t,e,n){"use strict";e.__esModule=!0;var s,a=n("c/Tr"),i=(s=a)&&s.__esModule?s:{default:s};e.default=function(t){if(Array.isArray(t)){for(var e=0,n=Array(t.length);e<t.length;e++)n[e]=t[e];return n}return(0,i.default)(t)}},N97s:function(t,e){},WSJo:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var s=n("Gu7T"),a=n.n(s),i=n("Xxa5"),r=n.n(i),o=n("exGp"),u=n.n(o),c=n("Dd8w"),l=n.n(c),d=n("NYxO"),f=["单选题","多选题","判断题"],v={name:"exam",data:function(){return{contentH:0,loading:!0,nodata:!1,types:f,total:0,questions:[]}},computed:l()({},Object(d.c)(["info"]),{wrapHeight:function(){return this.contentH},rightAnswer:function(){return function(t,e){return t.trueAnswer.indexOf(e+1)>-1||t.trueAnswer.indexOf((e+1).toString())>-1}}}),mounted:function(){var t=this;this.$nextTick(function(){t.contentH=document.documentElement.clientHeight,t.getData()})},methods:{getData:function(){var t=this;return u()(r.a.mark(function e(){var n,s;return r.a.wrap(function(e){for(;;)switch(e.prev=e.next){case 0:return n={studentId:t.info.id,examinationId:t.$route.query.examid},e.next=3,t.$Request.get("/examination/getTestPaperByWeChat.do",n);case 3:s=e.sent,t.loading=!1,s&&0===s.code?t.formatQuestion(s):t.nodata=!0;case 6:case"end":return e.stop()}},e,t)}))()},formatQuestion:function(t){var e=t.list||{},n=e.answer?JSON.parse(e.answer):[];n.forEach(function(t){1*t.subjectType!=1&&(t.answer=t.answer&&t.answer.length?t.answer[0]:"")});var s=[n.filter(function(t){return 0===t.subjectType}),n.filter(function(t){return 1===t.subjectType}),n.filter(function(t){return 2===t.subjectType})],i=[].concat(a()(s[0]),a()(s[1]),a()(s[2]));this.questions=i,this.total=this.questions.length,this.nodata=!this.questions.length,console.log(this.questions)}}},p={render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"exam-main",style:{minHeight:t.wrapHeight+"px"}},[n("div",{staticClass:"exam-content"},[t.nodata?n("div",{staticClass:"no-data"}):[n("div",{directives:[{name:"show",rawName:"v-show",value:!t.loading,expression:"!loading"}],staticClass:"eaxm-content-main"},[n("ul",[t._l(t.questions,function(e,s){return[n("li",{key:s,attrs:{id:"q"+s}},[n("div",{staticClass:"question-type"},[t._v(t._s(t.types[1*e.subjectType]))]),t._v(" "),n("div",{staticClass:"question-content"},[n("div",{staticClass:"question-title"},[t._v(t._s(s+1)+". "+t._s(e.title))]),t._v(" "),1*e.subjectType==0||1*e.subjectType==2?n("van-radio-group",{staticClass:"question-options",model:{value:e.answer,callback:function(n){t.$set(e,"answer",n)},expression:"item.answer"}},[t._l(e.op,function(s,a){return[n("van-radio",{attrs:{name:a+1,disabled:!0}},[t._v("\n\t\t\t\t\t\t\t\t\t\t\t"+t._s(s)+"\n\t\t\t\t\t\t\t\t\t\t\t"),t.rightAnswer(e,a)?[n("van-icon",{attrs:{name:"success"}})]:t._e()],2)]})],2):t._e(),t._v(" "),1*e.subjectType==1?n("van-checkbox-group",{staticClass:"question-options",model:{value:e.answer,callback:function(n){t.$set(e,"answer",n)},expression:"item.answer"}},[t._l(e.op,function(s,a){return[n("van-checkbox",{attrs:{shape:"square",name:a+1,disabled:!0}},[t._v("\n\t\t\t\t\t\t\t\t\t\t\t"+t._s(s)+"\n\t\t\t\t\t\t\t\t\t\t\t"),t.rightAnswer(e,a)?[n("van-icon",{attrs:{name:"success"}})]:t._e()],2)]})],2):t._e()],1),t._v(" "),n("div",{staticStyle:{color:"red"}},[t._v("答案解析："+t._s(e.answerAnalysis||"无"))])])]})],2)])]],2)])},staticRenderFns:[]};var h=n("VU/8")(v,p,!1,function(t){n("N97s")},"data-v-5edb85b7",null);e.default=h.exports},"c/Tr":function(t,e,n){t.exports={default:n("5zde"),__esModule:!0}},fBQ2:function(t,e,n){"use strict";var s=n("evD5"),a=n("X8DO");t.exports=function(t,e,n){e in t?s.f(t,e,a(0,n)):t[e]=n}},qyJz:function(t,e,n){"use strict";var s=n("+ZMJ"),a=n("kM2E"),i=n("sB3e"),r=n("msXi"),o=n("Mhyx"),u=n("QRG4"),c=n("fBQ2"),l=n("3fs2");a(a.S+a.F*!n("dY0y")(function(t){Array.from(t)}),"Array",{from:function(t){var e,n,a,d,f=i(t),v="function"==typeof this?this:Array,p=arguments.length,h=p>1?arguments[1]:void 0,m=void 0!==h,_=0,y=l(f);if(m&&(h=s(h,p>2?arguments[2]:void 0,2)),void 0==y||v==Array&&o(y))for(n=new v(e=u(f.length));e>_;_++)c(n,_,m?h(f[_],_):f[_]);else for(d=y.call(f),n=new v;!(a=d.next()).done;_++)c(n,_,m?r(d,h,[a.value,_],!0):a.value);return n.length=_,n}})}});
//# sourceMappingURL=2.1989e6346b4a245ffe62.js.map