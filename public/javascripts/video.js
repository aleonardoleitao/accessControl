function MontaVideo(url, path, id, img, wth, tk, pf) {

	var urlServer = url;
	var urlCompleta = "";
	var path = path.replace(".mp4","");
	var pathVideo = encodeURIComponent(path);
	var idVideo = id;
	var imagem = img;
	var width = wth;
	var token = tk;
	var perfil = pf;

	// Url com tratamento de encode
	var urlTratamento = urlServer + "/videos/" + pathVideo + ".json";

	//Carregamento da div
	$("#"+ idVideo).addClass("player-video");
	$("#"+ idVideo).append("<div class='thumb-video'><img class='placeholder' src='" + imagem + "'/></div>");
	$("#"+ idVideo).append("<div class='play-video' id='link" + idVideo + "'><img width='150px' height='150px' src='" + urlServer + "/static/images/video-play-button.png' onClick='javascript::' /></div>");


	// inicio uma requisição
	$.ajax({    	
	    url : urlTratamento,
	    dataType : "json",
		// função para de sucesso
	    success : function(data){

			//urlServer = "http://clappr.io/" + data.path + ".mp4?token=" + data.token;
			urlCompleta = urlServer + "/" + data.path + ".mp4?token=" + data.token + "&tk=" + token + "&perfil=" + perfil;
			comandos = '"' + urlServer + '","' + imagem + '","' + urlCompleta + '","' + idVideo + '","' + width + '","' + perfil + '"';
			//$("#"+ idVideo).append("<img style='cursor:pointer; height: 360px; width: "+width+"px;' src='" + imagem + "' onClick='javascript:exibeVideo(" + comandos + ");'/>");
			$("#link" + idVideo).html("<img width='150px' height='150px' src='" + urlServer + "/static/images/video-play-button.png' onClick='javascript:exibeVideo(" + comandos + ");'/>");
	    }
	});//termina o ajax
}

function MontaVideoHtml5(url, path, id, img, wth, tk, pf) {

	var urlServer = url;
	var urlCompleta = "";
	var path = path.replace(".mp4","");
	var pathVideo = encodeURIComponent(path);
	var idVideo = id;
	var imagem = img;
	var width = wth;
	var token = tk;
	var perfil = pf;

	// Url com tratamento de encode
	var urlTratamento = urlServer + "/videos/" + pathVideo + ".json";

	//Carregamento da div
	$("#"+ idVideo).addClass("player-video");
	$("#"+ idVideo).append("<div class='thumb-video'><img class='placeholder' src='" + imagem + "'/></div>");
	$("#"+ idVideo).append("<div class='play-video' id='link" + idVideo + "'><img width='150px' height='150px' src='" + urlServer + "/static/images/video-play-button.png' onClick='javascript::' /></div>");


	// inicio uma requisição
	$.ajax({    	
	    url : urlTratamento,
	    dataType : "json",
		// função para de sucesso
	    success : function(data){

			//urlServer = "http://clappr.io/" + data.path + ".mp4?token=" + data.token;
			urlCompleta = urlServer + "/" + data.path + ".mp4?token=" + data.token + "&tk=" + token + "&perfil=" + perfil;
			comandos = '"' + urlServer + '","' + imagem + '","' + urlCompleta + '","' + idVideo + '","' + width + '","' + perfil + '"';
			//$("#"+ idVideo).append("<img style='cursor:pointer; height: 360px; width: "+width+"px;' src='" + imagem + "' onClick='javascript:exibeVideo(" + comandos + ");'/>");
			$("#link" + idVideo).html("<img width='150px' height='150px' src='" + urlServer + "/static/images/video-play-button.png' onClick='javascript:exibeVideoHtml5(" + comandos + ");'/>");
	    }
	});//termina o ajax
}

//480hx395w
function exibeVideo(urlServer, imagem, urlCompleta, idVideo, width, perfil) {
	var idVideo = "#" + idVideo;
	div = $(idVideo);
	div.html("");
	var urlServer = urlServer + "/javascripts/player/"
	var watermark_user = "https://m.swingreal.com/videolog/" + perfil +  "/watermark.png";

	var valueWidth = $(document).width();
	if valueWidth > 480 {
		valueWidth = 480;
	}
	var valueHeight = Math.round((valueWidth/4)*3);
	
	var player = new Clappr.Player({
		poster: imagem,
		source: urlCompleta,
		parentId: idVideo,
		width: valueWidth,
		height: valueHeight,
		autoPlay: true,
		hideMediaControl: false,
		baseUrl: urlServer,
		watermark: watermark_user, position: 'bottom-right'
	});
}

//480hx395w
function exibeVideoHtml5(urlServer, imagem, urlCompleta, idVideo, width, perfil) {
	var idVideo = "#" + idVideo;
	div = $(idVideo);
	div.html("");
	//var urlServer = urlServer + "/javascripts/player/"
	var watermark_user = "https://m.swingreal.com/videolog/" + perfil +  "/watermark.png";

	var videlem = document.createElement("video");
	/// ... some setup like poster image, size, position etc. goes here...
	/// now, add sources:
	videlem.autoplay	= true;
	videlem.controls	= true;
	videlem.preload		= "auto";
	//videlem.data-setup	= '{"controls":true}';
	videlem.poster		= watermark_user;

	var sourceMP4 = document.createElement("source"); 
	sourceMP4.type = "video/mp4";
	sourceMP4.src = urlCompleta;
	
	videlem.appendChild(sourceMP4);

	div.html(videlem);
}