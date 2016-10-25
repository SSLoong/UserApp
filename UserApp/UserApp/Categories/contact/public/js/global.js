$(function(){
$(".page").last().css("visibility","visible");
JH.title.unshift($("title").text());
$("body").on("click","a",function(e){
	e.preventDefault();
	var eff = "slideInRight";
	if($(this).attr("href") != "" && $(this).attr("href") != "#" && window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ] != $(this).attr("href")){
		if($(this).attr("data-page") == "page"){
			JH.load.page($(this).attr("href"));
		}else if($(this).attr("data-page") == "new"){
			if($(this).attr("data-eff")!="undefined"){
				 eff = $(this).attr("data-eff");
			}
			JH.load.new($(this).attr("href"),eff);
		}else{
			window.location.href = $(this).attr("href");
		}
	}
});
window.onpopstate = function(event){
	var pageurl = window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ];
	JH.back = true;
	if(JH.pageurl!=pageurl&&$(".page").length==1){
		JH.load.page(pageurl);
	}else if($(".page").length>1){
		JH.load.newclose({state:event.state,suc:function(){
			if(JH.pageurl!=pageurl&&$(".page").length==1){
				JH.load.page(pageurl);
			}
			JH.closesuc();
		}});
	}
};
});