(function($) {
	$.fn.limit=function(num){//截取文字
		$(this).each(function(i,d){
			var objString = $(this).text();
			var objLength = $(this).text().length;
			if(objLength > num){
				if(!$(this).attr("title")){
					$(this).attr("title",objString);
				}
				objString = $(this).text(objString.substring(0,JH.StringUtilities.limitLength(objString,num))+"…");
			}
		});
	};
	$.loading = function(){
		$("body").prepend('<div class="loading">\
			<div></div>\
			<div></div>\
			<div></div>\
			<div></div>\
			<div></div>\
		</div>');
		$(".loading").css({marginLeft:-$(".loading").outerWidth()/2,marginTop:-$(".loading").outerHeight()/2});
	};
	$.loading.close = function(title) {
		$(".loading").fadeOut(500,"easeOutQuad",function(){
			$(".loading").remove();
		});
	};
	$.getquery = function(url){
		var url = url;
		var u = url.split("?");
		if(typeof(u[1]) == "string"){
			u = u[1].split("&");
			var get = {};
			for(var i in u){
				var j = u[i].split("=");
				get[j[0]] = j[1];
			}
			return get;
		} else {
			return {};
		}
	};
	$.alert = function(title,type) {
		if(type == undefined){
			var time = 1500;
			$(".alert").remove();
			$.doTimeout("doAlert");
			$.doTimeout("doAlert",500,function(){
				time-=500;
				if(time == 0){
					$(".alert").remove();
					return false;
				}
				return true;
			});
			$("body").prepend('<div class="alert">'+title+'</div>');
		}else{
			$(".alert-confirm").remove();
			$("body").prepend('<div class="alert-confirm"><div class="alert alert-0'+type+'"><div class="title">'+title+'</div><div class="ctrl"><div class="btn-yes">确定</div></div></div></div>');
			$(".alert .btn-yes").on("tap",function(){
				$(".alert-confirm").remove();
			});
		}
		$(".alert").css({marginLeft:-$(".alert").outerWidth()/2,marginTop:-$(".alert").outerHeight()/2});
	};
	$.confirm = function(d) {
		if(d.btn == undefined){
			d.btn = {yes:"是",no:"否"};
		}
		$(".confirm-wrapper").remove();
		$("body").prepend('\
			<div class="confirm-wrapper">\
				<div class="confirm">\
					<div class="title">'+d.title+'</div>\
					<div class="ctrl"><div class="btn-no">'+d.btn.no+'</div><div class="btn-yes">'+d.btn.yes+'</div></div>\
				</div>\
		</div>');
		$(".confirm").css({marginLeft:-$(".confirm").outerWidth()/2,marginTop:-$(".confirm").outerHeight()/2});
		$(".confirm .btn-no,.confirm .btn-yes").on("tap",function(){
			$(".confirm-wrapper").remove();
		});
		$(".confirm .btn-yes").on("tap",function(){
			if(d.fuc == undefined){
				d.suc.apply();
			}else{
				d.suc.apply(this,[d.fuc,d.data]);
			}
		});
	};
	$.debug = function(title) {
		if(JH.debug){
			
			if($("body").find(".debug").length<=0){
				$("body").prepend('<div class="debug"><p>'+title+'</p></div>');
				$(".debug").on("click",function(){
					$(".debug").remove();
					JH.debugNum = 0;
				});
			}else{
				$(".debug").append("<p>"+title+"</p>");
			}
			JH.debugNum++;
			if(JH.debugNum == 11){
				$(".debug p:first-child").remove();
				JH.debugNum--;
			}
		}
	};
	$.fn.findparent=function(id){
		var dom;
		if($(this).parentsUntil(id).get(0) != undefined){
			dom = $(this).parentsUntil(id).parent();
		}else{
			dom = $(this).parent();
		}
		return dom;
	};
	$.fn.choosebox = function(check) {
		var that = $(this).find(".choosebox");
		$(this).find(".choosebox").on("tap",function(){
			if(check){
				if($(this).hasClass("active")){
					$(this).removeClass("active");
				}else{
					$(this).addClass("active");
				}
			}else{
				that.removeClass("active");
				$(this).addClass("active");
			}
		});
	};
	//tabs菜单
	$.fn.tabs = function(active) {
		if(active == undefined){
			active = 1;
		}
		var that = $(this);
		that.each(function(i,d){
			that.find(".tabs-menu>a").eq(active-1).addClass("active");
			that.find(".tabs-con").eq(active-1).addClass("active vv").css({"z-index":3});
			if(that.find(".tabs-menu>a").eq(active-1).attr("href") != "#"){
				JH.load.page(that.find(".tabs-menu>a").eq(active-1).attr("href"),that.find(".tabs-con.active"));
			}
			that.find(".tabs-menu>a").each(function(j,e){
				$(this).on("click",function(e){
					e.preventDefault();
					if(!$(this).hasClass("active") && !JH.post){
						that.find(".tabs-menu>a").removeClass("active");
						$(this).addClass("active");
						$(that).find(".tabs-con.active").css("z-index",2).siblings().css("z-index",1);
						that.find(".tabs-con").removeClass("active vv");
						that.find(".tabs-con").eq($(this).index()).addClass("active");
						that.find(".tabs-con.active").css("z-index",3);
						if($(this).attr("href")!="#"&&that.find(".tabs-con.active").is(":empty")){
							JH.load.page($(this).attr("href"),that.find(".tabs-con.active"));
						}else{
							that.find(".tabs-con").removeClass("animated fadeIn");
							$.doTimeout(1,function(){
								that.find(".tabs-con.active").addClass("animated fadeIn");
							});
						}
					}
				});
			});
		});
	};
})(jQuery);
var JH = {
	debugNum:0,debug:true,
	title:[],
	scrollbar:false,shrinkScrollbar:"scale",mousewheel:false,pagescroll:null,newscroll:null,
	post:false,back:false,
	page:1,pageurl:window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ],closesuc:$.noop,
	point:{lat:"",lng:""},
	reg:{
		tel:/^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\d{8}$/,
		vcode:/^\d{4}$/,
		policy:{gift:/满[\s\S]*?赠/,full:/满[\s\S]*?减/},
		policy_clear:{gift:/赠/,minus:/立减/},
		match:{minus:/立减([\s\S]*?)元/}
	},
	data:{
		
	}
};
JH.NumberFormat = {
	format:function(num,pattern){//格式化数字显示方式  JH.NumberFormat.format(12345.999,'#,##0.00')|(12345.999,'#,##0.##')|(123,'000000')
		var strarr = num?num.toString().split('.'):['0'];
		var fmtarr = pattern?pattern.split('.'):[''];
		var retstr='';	
		// 整数部分
		var str = strarr[0];
		var fmt = fmtarr[0];
		var i = str.length-1;  
		var comma = false;
		//console.log(fmt.substr(0,1));
		for(var f=fmt.length-1;f>=0;f--){
			switch(fmt.substr(f,1)){
				case '#':
					if(i>=0 ) retstr = str.substr(i--,1) + retstr;
					break;
				case '0':
					if(i>=0) retstr = str.substr(i--,1) + retstr;
					else retstr = '0' + retstr;
					break;
				case ',':
					comma = true;
					retstr=','+retstr;
					break;
			}
		}
		if(i>=0){
			if(comma){
				var l = str.length;
				for(;i>=0;i--){
					retstr = str.substr(i,1) + retstr;
					if(i>0 && ((l-i)%3)==0) retstr = ',' + retstr;
				}
			}
			else retstr = str.substr(0,i+1) + retstr;
		}	
		retstr = retstr+'.';
		//小数部分
		str=strarr.length>1?strarr[1]:'';
		fmt=fmtarr.length>1?fmtarr[1]:'';
		i=0;
		for(var f=0;f<fmt.length;f++){
			switch(fmt.substr(f,1)){
				case '#':
					if(i<str.length) retstr+=str.substr(i++,1);
					break;
				case '0':
					if(i<str.length) retstr+= str.substr(i++,1);
					else retstr+='0';
					break;
			}
		}
		return retstr.replace(/^,+/,'').replace(/\.$/,'');
	}
}
JH.NumberUtilities = {
	_aUniqueIDs:[],
	getUnique:function(){//返回当前纪元日毫秒数,产生独一无二数字
		if(this._aUniqueIDs == null) {
			this._aUniqueIDs = new Array();
		}
		var dCurrent = new Date();
		var nID = dCurrent.getTime();
		while(!this.isUnique(nID)){
			nID += this.random(dCurrent.getTime(), 2 * dCurrent.getTime());
		}	
		this._aUniqueIDs.push(nID);
		return nID;
    },
	isUnique:function(nNumber){
		for(var i = 0; i < this._aUniqueIDs.length; i++) {
			if(this._aUniqueIDs[i] == nNumber) {
				return false;
			}
		}
		return true;
	},
	random:function(nMinimum, nMaximum, nRoundToInterval) {//生成随机数
		nMaximum?nMaximum:nMaximum = 0;
		nRoundToInterval?nRoundToInterval:nRoundToInterval = 1;
		if(nMinimum > nMaximum) {
			var nTemp = nMinimum;
			nMinimum = nMaximum;
			nMaximum = nTemp;
		}
		var nDeltaRange = (nMaximum - nMinimum) + (1 * nRoundToInterval);
		var nRandomNumber = Math.random() * nDeltaRange;
		nRandomNumber += nMinimum;
		return Math.floor(nRandomNumber, nRoundToInterval);
	}
}
JH.StringUtilities = {
	isWhitespace:function( ch ) {
		return ch == '\r' || 
				ch == '\n' ||
				ch == '\f' || 
				ch == '\t' ||
				ch == ' '; 
	},
	trim:function( original ) {//剪去开始结尾处空白
		var characters = original.split( "" );
		for ( var i = 0; i < characters.length; i++ ) {
			if ( this.isWhitespace( characters[i] ) ) {
				characters.splice( i, 1 );
				i--;
			} else {
				break;
			}
		}
		for ( i = characters.length - 1; i >= 0; i-- ) {
			if ( this.isWhitespace( characters[i] ) ) {
				characters.splice( i, 1 );
			} else {
				break;
			}
		}
		return characters.join("");
	},
	limitLength:function(str,num){
		var l = 0;
		var a = str.split("");
		for (var i=0;i<num;i++) {
			if (a[i].charCodeAt(0)<299) {
				l+=1.5;
			} else {
				l++;
			}
		}
		return l;
	}
};
JH.ArrayUtilities = {
	randomize:function(aArray){//数组元素随机化
		var aCopy = aArray.concat();
		var aRandomized = new Array();
		var oElement;
		var nRandom;
		for(var i = 0; i < aCopy.length; i++) {
			nRandom = JH.NumberUtilities.random(0, aCopy.length - 1);
			aRandomized.push(aCopy[nRandom]);
			aCopy.splice(nRandom, 1);
			i--;
		}
		return aRandomized;
	},
	toString:function(oArray, nLevel) {//快速输出数组内容
		nLevel?nLevel:nLevel = 0;
		var sIndent = "";
		for(var i = 0; i < nLevel; i++) {
			sIndent += "\t";
		}
		var sOutput = "";
		for(var sItem in oArray) {
			if(typeof oArray[sItem] == "object") {
				sOutput = sIndent + "** " + sItem + " **\n" + toString(oArray[sItem], nLevel + 1) + sOutput;
			}
			else {
				sOutput += sIndent + sItem + ":" + oArray[sItem] + "\n";
			}
		}
		return sOutput;
	}
}
JH.getAppBusiness = function(){
	//微信浏览器
	if(/MicroMessenger/i.test(navigator.userAgent)){
		if(/android/i.test(navigator.userAgent)){
			//安卓地址
			window.location.href="http://a.app.qq.com/o/simple.jsp?pkgname=cn.vjsp.shanjiuke.md";
		}else{
			//苹果地址
			window.location.href="http://a.app.qq.com/o/simple.jsp?pkgname=cn.vjsp.shanjiuke.md";
		}
	}else{//默认浏览器
		if(/android/i.test(navigator.userAgent)){
			//安卓地址
			window.location.href="http://a.app.qq.com/o/simple.jsp?pkgname=cn.vjsp.shanjiuke.md";
		}
		if(/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
			//苹果地址
			window.location.href="http://a.app.qq.com/o/simple.jsp?pkgname=cn.vjsp.shanjiuke.md";
		}
	}
}
JH.getAppClient = function(){
	//微信浏览器
	if(/MicroMessenger/i.test(navigator.userAgent)){
		if(/android/i.test(navigator.userAgent)){
			//安卓地址
			window.location.href="http://app.qq.com/#id=detail&appid=1104014809";
		}else{
			//苹果地址
			window.location.href="http://fusion.qq.com/cgi-bin/qzapps/unified_jump?appid=11604152&from=wx&isTimeline=false&actionFlag=0¶ms=pname%3Dcn.vjsp.api.core%26versioncode%3D10%26channelid%3D%26actionflag%3D0";
		}
	}else{//默认浏览器
		if(/android/i.test(navigator.userAgent)){
			//安卓地址
			window.location.href="http://app.qq.com/#id=detail&appid=1104014809";
		}
		if(/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
			//苹果地址
			window.location.href="http://itunes.apple.com/app/id937064342";
		}
	}
}
JH.float = {
	div:function(arg1,arg2){ 
		var t1=0,t2=0,r1,r2; 
		try{t1=arg1.toString().split(".")[1].length}catch(e){} 
		try{t2=arg2.toString().split(".")[1].length}catch(e){} 
		with(Math){ 
			r1=Number(arg1.toString().replace(".","")) 
			r2=Number(arg2.toString().replace(".","")) 
			return (r1/r2)*pow(10,t2-t1);
		}
	},
	mul:function(arg1,arg2){ 
		var m=0,s1=arg1.toString(),s2=arg2.toString(); 
		try{m+=s1.split(".")[1].length}catch(e){} 
		try{m+=s2.split(".")[1].length}catch(e){} 
		return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);
	},
	add:function(arg1,arg2){ 
		var r1,r2,m; 
		try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0} 
		try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0} 
		m = Math.pow(10,Math.max(r1,r2));
		return (arg1*m+arg2*m)/m;
	},
	minus:function(arg1,arg2){ 
		var r1,r2,m,n;
		try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
		try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
		m=Math.pow(10,Math.max(r1,r2));
		//动态控制精度长度
		n=(r1>=r2)?r1:r2;
		return ((arg1*m-arg2*m)/m).toFixed(n);
	} 
}
JH.load = {
	page:function(url){
		if(!JH.post){
			JH.post = true;
			$.loading();
			$.ajax({
				type:"get",
				url: url,
				dataType:"html",
				cache:false,
				success: function(d){
					$.loading.close();
					JH.pagescroll.destroy();
					$(".page").last().html(d.match(/<!--page=begin-->([\s\S]*?)<!--page=end-->/)[0]);
					if(!JH.back){
						history.pushState(null,"",url);
						$("title").text(d.match(/<title>([\s\S]*?)<\/title>/)[1]);
						JH.title.unshift($("title").text());
					}else{
						JH.title.shift();
						$("title").text(d.match(/<title>([\s\S]*?)<\/title>/)[1]);
					}
					JH.pageurl = url;
					JH.back = false;
					JH.post = false;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			})
		}
	},
	new:function(url,eff){
		if(!JH.post){
			JH.post = true;
			$.loading();
			$.ajax({
				type:"get",
				url: url,
				dataType:"html",
				cache:false,
				success: function(d){
					$.loading.close();
					if(eff == undefined){
						eff = "slideInRight";
					}
					$("body").append('<div class="page animated '+eff+'"></div>');
					$(".page").last().html(d.match(/<!--new=begin-->([\s\S]*?)<!--new=end-->/)[0]);
					$(".page").last().one("webkitAnimationEnd mozAnimationEnd animationend", function(){
						JH.post = false;
					});
					history.pushState("new","",url);
					$("title").text(d.match(/<title>([\s\S]*?)<\/title>/)[1]);
					JH.title.unshift($("title").text());
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			})
		}
	},
	closeall:function(){
		window.history.go(-($(".page").length-1));
	},
	newclose:function(d){
		JH.post = true;
		if(d == undefined){
			d = {};
		}
		if(d.eff == undefined){
			d.eff = "slideOutRight";
		}
		if(d.state == null||d.state == undefined){
			$(".page").not(":first").removeClass("slideInLeft slideInRight slideInUp slideInDown fadeIn");
			$(".page").not(":first").addClass(d.eff);
			$(".page").last().one("webkitAnimationEnd mozAnimationEnd animationend", function(){
				$.each($(".page").not(":first"),function(i,d){
					JH.title.shift();
					d.remove();
				});
				$("title").text(JH.title[0]);
				JH.post = false;
				JH.back = false;
				if(d.suc != undefined){
					d.suc();
				}
			});
		}else if(d.state == "new"){
			$("title").text(JH.title[0]);
			$(".page").last().removeClass("slideInLeft slideInRight slideInUp slideInDown fadeIn");
			$(".page").last().addClass(d.eff);
			$(".page").last().one("webkitAnimationEnd mozAnimationEnd animationend", function(){
				JH.title.shift();
				$("title").text(JH.title[0]);
				$(".page").last().remove();
				JH.post = false;
				JH.back = false;
				if(d.suc != undefined){
					d.suc();
				}
			});
		}
	},
	refresh:function(myscroll){
		if(!JH.post){
			JH.post = true;
			$.loading();
			$.ajax({
				type:"get",
				url:window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ],
				dataType:"html",
				cache:false,
				success: function(d){
					$.loading.close();
					if($(".page").length>1){
						myscroll.destroy();
					}else{
						JH.pagescroll.destroy();
					}
					if($(".page").length>1){
						$(".page").last().html(d.match(/<!--new=begin-->([\s\S]*?)<!--new=end-->/)[0]);
					}else{
						$(".page").last().html(d.match(/<!--page=begin-->([\s\S]*?)<!--page=end-->/)[0]);
					}
					JH.post = false;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			})
		}
	},
	more:function(myscroll){
		if(!JH.post&&$(".page").last().find(".lastpage").length<1){
			JH.post = true;
			$.loading();
			JH.page++;
			$.ajax({
				type:"get",
				url:window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ],
				data:{page:JH.page},
				dataType:"html",
				cache:false,
				success: function(d){
					$.loading.close();
					if($.trim(d.match(/<!--more=begin-->([\s\S]*?)<!--more=end-->/)[1])==""){
						$(".page").last().find("#more").after('<div class="lastpage">没有更多了…</div>');
					}else{
						if(JH.page == 1){
							$(".page").last().find("#more").html(d.match(/<!--more=begin-->([\s\S]*?)<!--more=end-->/)[1]);
						}else{
							$(".page").last().find("#more").append(d.match(/<!--more=begin-->([\s\S]*?)<!--more=end-->/)[1]);
						}
					}
					if($(".page").length>1){
						myscroll.refresh();
					}else{
						JH.pagescroll.refresh();
					}
					JH.post = false;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			})
		}
	},
	json:function(url,suc,data){
		if(!JH.post){
			if(data == undefined){
				data = {};
			}
			$.loading();
			JH.post = true;
			$.ajax({
				type:"post",
				url: url,
				data:data,
				dataType:"json",
				cache:false,
				success: function(d){
					$.loading.close();
					JH.post = false;
					suc(d);
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			});
		}
	},
	jsonp:function(url,suc,data){
		if(!JH.post){
			if(data == undefined){
				data = {};
			}
			$.loading();
			JH.post = true;
			$.ajax({
				type: "post",
				url: url,
				data:data,
				dataType:"jsonp",
				jsonp: "callback",
				jsonpCallback:"suc",
				cache:false,
				success: function(d){
					$.loading.close();
					suc(d);
					JH.post = false;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			})
		}
	},
	ajax:function(url,suc,data){
		if(!JH.post){
			if(data == undefined){
				data = {};
			}
			$.loading();
			JH.post = true;
			$.ajax({
				type:"post",
				url: url,
				data:data,
				dataType:"html",
				cache:false,
				success: function(d){
					$.loading.close();
					suc(d);
					JH.post = false;
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					$.loading.close();
					$.alert("服务器可能喝多了，麻烦您再提交一次！");
					JH.post = false;
				}
			})
		}
	}
}
JH.limit=function(str,num){//截取文字
	var objString = str;
	var objLength = str.length;
	if(objLength > num){
		objString = objString.substring(0,JH.StringUtilities.limitLength(objString,num))+"…";
	}
	return objString;
}
JH.transDate = function(options){
	var date=new Date(); 
	date.setFullYear(options.substring(0,4)); 
	date.setMonth(options.substring(5,7)-1); 
	date.setDate(options.substring(8,10)); 
	date.setHours(options.substring(11,13)); 
	date.setMinutes(options.substring(14,16)); 
	date.setSeconds(options.substring(17,19)); 
	return Date.parse(date); 
}
JH.toDate = function(options){
	var date = new Date(options);
	Y = date.getFullYear() + '-';
	M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
	D = date.getDate() + ' ';
	h = date.getHours() + ':';
	m = date.getMinutes() + ':';
	s = date.getSeconds(); 
	return Y+M+D+h+m+s;
}
JH.geolocation = {
	watchID:"",
	get:function(suc,err){
		suc({coords:{longitude:"121.4455333",latitude:"31.235"}});//调试模式
		/*if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(suc, err,{
				// 指示浏览器获取高精度的位置，默认为false
				enableHighAccuracy: true,
				// 指定获取地理位置的超时时间，默认不限时，单位为毫秒
				timeout: 5000,
				// 最长有效期，在重复获取地理位置时，此参数指定多久再次获取位置。
				maximumAge: 3000
			});
		}else{
			$.alert("您的浏览器不支持定位服务！");
		}*/
	},
	watch:function(suc){
		if (navigator.geolocation) {
			JH.watchID = navigator.geolocation.watchPosition(suc, JH.geolocation.locationError,{
				enableHighAccuracy: true,
				timeout: 5000,
				maximumAge: 3000
			});
		}else{
			$.alert("您的浏览器不支持定位服务！");
		}
	},
	clearWatch:function(){
		navigator.geolocation.clearWatch(JH.watchID);
	},
	locationError: function(error){
		switch(error.code) {
			case error.TIMEOUT:
				$.alert("获取超时了，请重试！");
				break;
			case error.POSITION_UNAVAILABLE:
				$.alert("未获取到您的位置信息！");
				break;
			case error.PERMISSION_DENIED:
				$.alert("请允许浏览器获取您的位置<br>以便我们为您提供更好的服务！");
				break;
			case error.UNKNOWN_ERROR:
				$.alert('未知错误！');
				break;
		}
	},
	getAddress:function(point,suc){
		var point = new BMap.Point(point.lng,point.lat);
		var geoc = new BMap.Geocoder();  
  		geoc.getLocation(point, function(rs){
			var addComp = rs.addressComponents;
			suc(addComp);
			//province:省，city:市，district:区,street:街,streetNumber门牌号
		});
	},
	getNearAddress:function(point,suc){
		var url="http://api.map.baidu.com/geocoder/v2/?ak=A890717631fea0ad7d91f0089770d0bb&location="+point.lat+","+point.lng+"&output=json&pois=1";
		JH.load.jsonp(url,suc);
	}
}
JH.wx = {
	wz:function(suc){
		wx.getLocation({
			type: 'wgs84', //默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
			success: function (res) {
				var point = {};
				point.lat = res.latitude; // 纬度，浮点数，范围为90 ~ -90
				point.lng = res.longitude; // 经度，浮点数，范围为180 ~ -180。
				//point.lat = "31.235";//调试模式
				//point.lng = "121.4455333";//调试模式
				suc(point);
			}
		});
	},
	share:function(url,suc){
		var title = "领闪酒客优惠券，天天优惠享不停！"; // 分享标题
		var desc = "闪酒客优惠券可在下单支付时使用"; // 分享描述
		var link = url; // 分享链接
		var imgUrl = "http://www.13b.net/baimap/share-c-ico.png"; // 分享图标
		wx.onMenuShareAppMessage({
			title: title,
			desc: desc,
			link: link,
			imgUrl: imgUrl,
			type: "", // 分享类型,music、video或link，不填默认为link
			dataUrl: "", // 如果type是music或video，则要提供数据链接，默认为空
			success: function () { 
				suc();
			},
			cancel: function () {
				
			}
		});
		wx.onMenuShareTimeline({
			title: title, // 分享标题
			link: link, // 分享链接
			imgUrl: imgUrl, // 分享图标
			success: function () { 
				suc();
			},
			cancel: function () { 
				
			}
		});
	},
	pay:function(url,suc,cancel,data){
		JH.load.json(url,function(d){
			if(d.code="0000"){
				wx.chooseWXPay({
					timestamp: d.data.timestamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
					nonceStr: d.data.nonceStr, // 支付签名随机串，不长于 32 位
					package: d.data.package, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***
					signType: d.data.signType, // 签名方式
					paySign: d.data.paySign, // 支付签名
					success: function () {
						suc(d);
					},
					cancel: function () { 
						cancel(d);
					},
					fail: function () {
						cancel(d);
					}
				});
			}else{
				$.alert(d.msg);
			}
		},data);		
	}
}