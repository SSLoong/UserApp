$(function(){
	if($.browser.msie&&$.browser.version<10){
		$("body").addClass("bg-gray").html('\
			<div class="pa" style="width:700px;height:300px;left:50%;top:50%;margin:-150px 0 0 -375px;">\
			<a class="pa bg-transparent" style="left:0px;top:150px;width:175px;height:150px;" href="http://rj.baidu.com/soft/detail/17458.html"></a>\
			<a class="pa bg-transparent" style="left:175px;top:150px;width:175px;height:150px;" href="http://rj.baidu.com/search/index/?kw=ie%252011"></a>\
			<a class="pa bg-transparent" style="left:350px;top:150px;width:175px;height:150px;" href="http://rj.baidu.com/soft/detail/14744.html"></a>\
			<a class="pa bg-transparent" style="left:525px;top:150px;width:175px;height:150px;" href="http://rj.baidu.com/soft/detail/11843.html"></a>\
			<img src="public/images/browser.png" wdith="700" height="300"></div>\
		');
	}
});