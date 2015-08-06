function MontaVideo(url, path, id, img, wth, tk, pf) {

	urlServer = url;
	urlCompleta = "";
	pathVideo = encodeURIComponent(path);
	idVideo = id;
	imagem = img;
	width = wth;
	token = tk;
	perfil = pf;

	// Url com tratamento de encode
	urlTratamento = urlServer + "/videos/" + pathVideo + ".json";

	//Criar imagem de loading
	//div = $("#" + idVideo);
	//div.append("<img src='" + imagem + "'/>");

	div = $("#"+ idVideo);

	$( document ).ready(function() {
		// inicio uma requisição
	    $.ajax({    	
	        url : urlTratamento,
	        dataType : "json",
	    	// função para de sucesso
	        success : function(data){

				//urlServer = "http://clappr.io/" + data.path + ".mp4?token=" + data.token;
				urlCompleta = urlServer + "/" + data.path + ".mp4?token=" + data.token;
				comandos = '"' + urlServer + '","' + imagem + '","' + urlCompleta + '","' + idVideo + '","' + width + '"';
				div.append("<img style='cursor:pointer; height: 395px; width: "+width+"px;' src='" + imagem + "' onClick='javascript:exibeVideo(" + comandos + ");'/>");

	        }
	    });//termina o ajax
	});
}

//480hx395w

function exibeVideo(urlServer, imagem, urlCompleta, idVideo, width) {
	idVideo = "#" + idVideo;
	div = $(idVideo);
	div.html("");

	var player = new Clappr.Player({
		poster: imagem,
		source: urlCompleta,
		parentId: idVideo,
		width: width,
		autoPlay: true,
		hideMediaControl: false,
		baseUrl: urlServer
	});

}