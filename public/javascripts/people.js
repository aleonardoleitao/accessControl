$(document).ready(function (){
	//troca de estado no filtro
	$('.widget-filtro .outro-link').click(function(){
		console.log("outro clicado");
		$('.widget-filtro .estado').hide();
		$('.widget-filtro .formulario').show();
	});
	//salva o novo estado no  filtro
	$('.widget-filtro .bt-salvar').click(function(){
		console.log("outro clicado");
		$('.widget-filtro .formulario').hide();
		$('.widget-filtro .estado').show();
		$('.widget-alerta').slideDown();
	});
	//esconde filtro
	$('.widget-filtro .todos').click(function(){
		$(this).addClass('ativo');
		$('.widget-filtro .online').removeClass('ativo');
	});
	//mostra filtro
	$('.widget-filtro .online').click(function(){
		$(this).addClass('ativo');
		$('.widget-filtro .todos').removeClass('ativo');
	});

	//alerta
	$('.widget-alerta .aplicar,.widget-alerta .cancelar').click(function(){
		$('.widget-alerta').slideToggle();
	});
	//alerta
	$('.form-people-filter input, .form-people-filter select, #filter_location').change(function(){
		$('.widget-alerta').slideDown();
	});
});
