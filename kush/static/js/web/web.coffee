$('.scroll-top').click ->
  $('body,html').animate({scrollTop:0}, 1000)


$('.scroll-down').click ->
  $('body,html').animate({scrollTop:$(window).scrollTop()+800}, 1000)


$('body').scrollspy({ target: '#navbar' })
