function MontaVideo(url, path, id, img, wth, tk, pf) {

	urlServer = url;
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
				urlServer = urlServer + "/" + data.path + ".mp4?token=" + data.token;
				comandos = '"' + imagem + '","' + urlServer + '","' + idVideo + '","' + width + '"';
				div.append("<img style='cursor:pointer; height: 360px; width: "+width+"px;' src='" + imagem + "' onClick='javascript:exibeVideo(" + comandos + ");'/>");

	        }
	    });//termina o ajax
	});
}


function exibeVideo(imagem, urlServer, idVideo, width) {
	idVideo = "#" + idVideo;
	div = $(idVideo);
	div.html("");

	var player = new Clappr.Player({
		poster: imagem,
		source: urlServer,
		parentId: idVideo,
		width: width
	});

}