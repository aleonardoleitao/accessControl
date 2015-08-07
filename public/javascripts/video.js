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

	// inicio uma requisição
	$.ajax({    	
	    url : urlTratamento,
	    dataType : "json",
		// função para de sucesso
	    success : function(data){

			//urlServer = "http://clappr.io/" + data.path + ".mp4?token=" + data.token;
			urlCompleta = urlServer + "/" + data.path + ".mp4?token=" + data.token + "&tk=" + token + "&perfil=" + perfil;
			comandos = '"' + urlServer + '","' + imagem + '","' + urlCompleta + '","' + idVideo + '","' + width + '","' + perfil + '"';
			$("#"+ idVideo).append("<img style='cursor:pointer; height: 362px; width: "+width+"px;' src='" + imagem + "' onClick='javascript:exibeVideo(" + comandos + ");'/>");

	    }
	});//termina o ajax
}

//480hx395w

function exibeVideo(urlServer, imagem, urlCompleta, idVideo, width, perfil) {
	var idVideo = "#" + idVideo;
	div = $(idVideo);
	div.html("");
	var urlServer = urlServer + "/javascripts/player/"
	var watermark_user = "https://www.swingreal.com/videolog/" + perfil +  "/watermark.png";
	var player = new Clappr.Player({
		poster: imagem,
		source: urlCompleta,
		parentId: idVideo,
		width: width,
		autoPlay: true,
		hideMediaControl: false,
		baseUrl: urlServer,
		hideMediaControl: true,
		watermark: watermark_user, position: 'bottom-right'
	});

}