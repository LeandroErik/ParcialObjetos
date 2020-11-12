/*
 * Nombre: Quispe Choque, Nombre Erik Leandro
 * Legajo: 1722876
 * 
 * Puntos de Entrada:
 * 
 * Punto 1:
 * Punto 2: 
 * Punto 3: 
 * Punto 4: 
 * Punto 5a: 
 * Punto 5b: 
 * Punto 5c:  
 */
 
 class Mensaje{
 	const property emisor
 	var peso //en KB
 	var contenidos = []
 	
 	method peso() = 5 +self.pesoContenido() * 1.3
	method pesoContenido() = contenidos.sum({contenido => contenido.peso()})
	
	method enviarMensaje(chat){
		if(not chat.puedeRecibir(self) or not emisor.tieneEspacio()){
			self.error("No se pudo enviar mensaje")
		}
		chat.recibirMensaje(self)
	}

 }
 /*tipos de contenido*/
 class Texto{
 	const cantCacateres
 	method peso() = 1*cantCacateres
 }
 class Audio{
 	const duracion
 	method peso() = duracion *1.2
 }
 class Imagen{
 	var alto
 	var ancho  //FALTAAAAA DEFINIR ALTO Y ANCHOOOOOOO
 	var modo
 	
 	method peso() = modo.compresion(self.pixeles()) * 2 //tranformo en KB
	method pixeles() = alto * ancho
 }
 
 class GIF inherits Imagen{
 	var cantCuadros
 	
 	override method peso() = super() * cantCuadros
 }
 
 class Contacto{
 	var contacto
 	method peso() = 3
 }
 /*tipos de compresion*/
 object compresionOriginal{
 	method compresion(pixeles) = pixeles
 }
 object compresionVariable{
 	const procentajeAEnviar
 	
 	method compresion(pixeles) = pixeles * procentajeAEnviar
 }
 object compresionMaxima{
 	method compresion(pixeles) = 10000.min(pixeles)
 		
 }
 
 /*diseñanado chats*/
 
 object Mensajeria{
 	const chats = []
 }
 
 class Chat{
 	const participantes = []
 	const mensajes = []
 	
 	var restriccion
 	
 	method cuantoEspacioOcupa() = mensaje.sum({mensaje => mensaje.peso()})
 	
 	method puedeEnviar(mensaje) = self.contieneEmisor(mensaje) 
 	
	method contieneEmisor(mensaje) = participantes.contains(mensaje.emisor())
	
	method recibirMensaje(mensaje){
		mensajes.add(mensaje)
	}
 	
 }
 
 class ChatPremium inherits Chat {
 	
 	const property creador
 	method puedeEnviar(mensaje) = restriccion.cumple(mensaje,self)
 }
 
 object difusion{
 	method cumple(mensaje,creador) = creador.es(mensaje.emisor())
 }
 
 /*PERSONA*/
 
 class Persona{
 	var espacio = 100
 	
 	method tieneEspacio() = true
 }