/*
 * Nombre: Quispe Choque, Nombre Erik Leandro
 * Legajo: 1722876
 * 
 * Puntos de Entrada:
 * 
 * Punto 1:var chat =new Chat(participantes = [erik,jorge],mensajes = [mensaje]) y lo usamos con chat.cuantoEspacioOcupa()
 * Punto 2: var mensaje = new Mensaje(emisor = pepita,contenidos = [unTexto,unaFoto]))
 * Punto 3:  var usuario = new Persona()  ; persona.buscarTexto(unTexto)
 * Punto 4: usuario.mensajesMasPesadosdeCadaChat()
 * Punto 5a: usuario.tieneNotificaciones()
 * Punto 5b: usuario.leer(chat)
 * Punto 5c:  usuario.notificacionesSinLeer()
 */
 
 class Mensaje{
 	const property emisor
 
 	var contenidos = []
 	
 	method peso() = 5 + self.pesoContenido() * 1.3
 	
 	/*interprete que podria haber vario contenidos en un mensaje
 	 * otra solucion seria method pesoContenido()=contenido.peso()
 	 * */
 	
	method pesoContenido() = contenidos.sum({contenido => contenido.peso()})
	
	method enviarseA(chat){
		self.validacion(chat)
		chat.recibirMensaje(self)
	}
	
	method validacion(chat){
		if(not chat.puedeRecibir(self)){
			self.error("No se pudo enviar mensaje")
		}
	}
	method noSupera(valor) = self.peso() < valor
	
	method contiene(texto) = emisor.tieneEnsuNombre(texto) or self.contenidosConTexto(texto) 
	
	method contenidosConTexto(texto) = contenidos.any({contenido => contenido.tiene(texto)})
 }
 
 /*------------------TIPOS CONTENIDOS----------------*/
 /*Opte por usar la <Interfaz> contenido mas que todo porque no queria esta overrideando pro cada peso que tenia,ademas se podria haber usado herencia por el tema del metodo contiene(),pero no lo vi necesario*/
 class Texto{
 	const palabras
 	
 	method cantCaracteres() = palabras.size()
 	
 	method peso() = 1* self.cantCaracteres()
 	
 	method contiene(texto) = palabras.contains(texto)
 }
 
 class Audio{
 	const duracion
 	
 	method peso() = duracion *1.2
 	
 	method contiene(texto) = false
 }
 
 class Imagen{
 	var alto
 	var ancho  
 	var modo //modos de compresion
 	
 	method peso() = modo.compresion(self.pixeles()) * 2 //tranformo en KB
 	
	method pixeles() = alto * ancho
	
	method contiene(texto) = false
 }
 /*hice que gif herede de imagen porque en el texto decia que eran como cualquier imagen ,pero se le agrega cant de cuadros */
 class GIF inherits Imagen{
 	var cantCuadros
 	
 	override method peso() = super() * cantCuadros
 }
 
 class Contacto{
 	var contacto //es una persona
 	
 	method peso() = 3
 	
 	method contiene(texto) = contacto.tieneEnsuNombre(texto)
 	
 }
 /*------------TIPOS COMPRESION----------*/
 
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
 
 /*TIPOS DE CHATS*/
 
 /*ACA plantee que los chatsPremium heredan de los Chat (comunes) , opte por esta opcion mas qu todo porque decia el chat el chat premium tenia unos comportamientos extra que el comun no tenia*/

 class Chat{
 	const participantes = []
 	const mensajes = []
 	
 	
 	method cuantoEspacioOcupa() = mensajes.sum({mensaje => mensaje.peso()})
 	
 	method puedeRecibir(mensaje) = self.contieneEmisor(mensaje) and self.todosTieneEspacio(mensaje)
 	
 	method todosTieneEspacio(mensaje) = participantes.all({participante =>participante.tieneEspacio(mensaje.peso())})
 	
	method contieneEmisor(mensaje) = participantes.contains(mensaje.emisor())
	
	method recibirMensaje(mensaje){
		
		self.enviarNotificacion(mensaje)
		self.restarEspacio(mensaje)
		
		mensajes.add(mensaje)
	}
	
	method enviarNotificacion(mensaje) =participantes.forEach({participante => participante.recibirNotificacion(mensaje)})
	method restarEspacio(mensaje) = participantes.forEach({participante => participante.restarEspacio(mensaje.peso())})
	
	method cantMensajes() = mensajes.size()
	
	method superaMensajes(valor) = self.cantMensajes() > valor
	
	method contienenAlgunMensajeCon(texto) = mensajes.any({mensaje => mensaje.contiene(texto)})
	
	method mensajeMasPesado() =mensajes.max({mensaje => mensaje.peso()})
	
	method contiene(mensaje) = mensajes.contains(mensaje)
	
	
 }
 
 class ChatPremium inherits Chat{
 	var restriccion
 	var creador
 	
 	override method puedeRecibir(mensaje) = super(mensaje) and restriccion.permiteEnviar(mensaje,self)
 	
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
 	var espacio 
 	const chats = []
 	
 	const notificaciones = []
 	
 	method tieneEspacio(peso) = espacio - peso > 0
 	
 	method restarEspacio(peso){
 		espacio -=peso
 	}
 	
 	method es(nombrePersona) = nombre.equals(nombrePersona)
 	
 	method buscarTexto(texto) = chats.contienenAlgunMensajeCon(texto)
 	
 	method tieneEnsuNombre(texto) = nombre.contains(texto)
 	
 	method mensajesMasPesadosdeCadaChat() =chats.map({chat =>chat.mensmensajeMasPesado()})
 	
 	method leer(chat){
 		self.notificacionesDel(chat).forEach({notificacion => notificacion.leer()})
 	}
 	method notificacionesDel(chat) = notificaciones.filter({notif => notif.perteneceA(chat)})
 	
 	method notificacionesSinLeer() = notificaciones.filter({notificacion => not notificacion.estaLeida()})
 	
 	method recibirNotificacion(mensajeRecibido){
 		notificaciones.add(new Notificacion(mensaje = mensajeRecibido,estaLeida = false))
 	}
 	
 	method tieneNotificaciones() =  not self.notificacionesSinLeer().isEmpty()
 }
 
// Notificaciones

class Notificacion{
	var mensaje
	var estaLeida = false
	
	method estaLeida() = estaLeida
	
	method leer(){
			estaLeida = true
	}
	method perteneceA(chat) = chat.contiene(mensaje)
}
/*lo pense de otra manera si es que hay mas estados,pero como solo son 2 opte por los flags
 * esto iria en la clase notificacion -----> method estaLeida() = estado.leido() 
 object leida{
	method leido() = true
}
object sinLeer{
	method leido() = false
}
 */