/*
 * Nombre: Quispe Choque, Nombre Erik Leandro
 * Legajo: 1722876
 * 
 * Puntos de Entrada:
 * 
 * Punto 1:var chat = new Chat()    	y lo usamos con chat.cuantoEspacioOcupa()
 * Punto 2: var mensaje = new Mensaje(emisor = pepita,)
 * Punto 3: 
 * Punto 4: 
 * Punto 5a: 
 * Punto 5b: 
 * Punto 5c:  
 */
 
 class Mensaje{
 	const property emisor
 
 	
 	method peso() = 5 +self.pesoContenido() * 1.3
	method pesoContenido() = contenidos.sum({contenido => contenido.peso()})
	
	method enviarseA(chat){
		if(not chat.puedeRecibir(self) or not emisor.tieneEspacio()){
			self.error("No se pudo enviar mensaje")
		}
		chat.recibirMensaje(self)
	}
	method noSupera(valor) = self.peso() < valor
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
 	var procentajeAEnviar
 	
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
 	
 	method cuantoEspacioOcupa() = mensaje.sum({mensaje => mensaje.peso()})
 	
 	method puedeEnviar(mensaje) = self.contieneEmisor(mensaje) 
 	
	method contieneEmisor(mensaje) = participantes.contains(mensaje.emisor())
	
	method recibirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	
	method cantMensajes() = mensajes.size()
	
	method superaMensajes(valor) = self.cantMensajes() > valor
	
 }
 
 class ChatPremium inherits Chat{
 	var restriccion
 	var creador
 	
 	override method puedeEnviar(mensaje) = super(mensaje) and restriccion.permiteEnviar(mensaje,self)
 	
 	method agregarMiembro(participante){
 		participantes.add(participante)
 	}
 	method eleiminarMiembro(participante){
 		participante.remove(participante)
 	}
 	method esCreador(alguien) = creador.es(alguien.nombre())
 }
 
 object difusion {
 	

 	 method permiteEnviar(mensaje,chat) = chat.esCreador(mensaje.emisor())
 }
 object restringido{
 	var limitesMensajes
 	 method permiteEnviar(mensaje,chat) = chat.superaMensajes(limitesMensajes) 
 }
 object ahorro {
 	var pesoMaximo
 	 method permiteEnviar(mensaje,chat) =  mensaje.noSupera(pesoMaximo)
 }
 

 
 /*PERSONA*/
 
 class Persona{
 	const nombre
 	var espacio = 100
 	
 	method tieneEspacio() = true
 	
 	method es(nombrePersona) = nombre.equals(nombrePersona)
 }