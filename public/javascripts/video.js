function MontaVideo(url, path, id, img, wth) {

	pathVideo = encodeURIComponent(path);
	idVideo = id;
	imagem = img;
	urlServer = url;
	width = wth;

	// Url com tratamento de encode
	urlTratamento = urlServer + "/videos/" + pathVideo + ".json";

	//Criar imagem de loading
	//div = $("#" + idVideo);
	//div.append("<img src='" + imagem + "'/>");

	$( document ).ready(function() {
		// inicio uma requisição
	    $.ajax({    	
	        url : urlTratamento,
	        dataType : "json",
	    	// função para de sucesso
	        success : function(data){

				//urlServer = "http://clappr.io/" + data.path + ".mp4?token=" + data.token;
				urlServer = urlServer + "/" + data.path + ".mp4?token=" + data.token;
				idVideo = "#video-" + idVideo

				div = $(idVideo);
				comandos = '"' + imagem + '","' + urlServer + '","' + idVideo + '","' + width + '"';
				div.append("<img src='" + imagem + "' onClick='javascript:exibeVideo(" + comandos + ");'/>");

	        }
	    });//termina o ajax
	});
}


function exibeVideo(imagem, urlServer, idVideo, width) {

	var player = new Clappr.Player({
		poster: imagem,
		source: urlServer,
		parentId: idVideo,
		width: width
	});

}