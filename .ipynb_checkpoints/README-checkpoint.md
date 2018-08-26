# Modelo de Análisis de sentimientos con Emojis

#### Se realizará el modelo con emojis en lugar de etiquetas debido a que se considera más *amigabe* para el usuario/cliente.

Uno de los problemas principales sería el encontrar un modelo que ya esté entranado en español para obtener los pesos. Creo que en este caso no podremos escaparnos de hacer el *label* a mano. Sin embargo, es un beneficio derivado del hecho de que no existen muchas compañías que hacen este tipo de análisis en Méx (*no sé si en España o latinoamérica si lo hagan.*) lo cual nos podría generar una ventaja comparativa. 


## Train y Test sets
Los índices serían los siguientes:

- "0": ":smile:",
- "1": ":disappointed:",
- "2": ":rage:",
- "3": ":yum:",
- "4": ":heart:",
- "5": ":thumbsup:",
- "6": ":thumbsdown:",
- "7": ":clap:",
- "8": ":telephone:",
- "9": ":moneybag:",
- "10": ":smoking:",
- "11": ":soccer:",
- "12": ":bikini:",
- "13": ":x:",
- "14": ":raised_hands:",
- "15": ":ok_hand:"

Algunos ejemplos que escribí:


* estaba equivocado, 13
* chistoso, 0
* me gusta cuando la gente sonríe, 0
* estoy impresionado por tu trabajo en este proyecto, 7
* vamos a comer juntos, 3
* que momento tan divertido, 0
* estuvo aburrido, 1
* que evento tan aburrido, 1
* te extraño, 4
* sigo enamorado, 4
* estoy feliz con mi novia, 4
* estoy muy frustrado, 2
* que buena broma, 0
* el portero apesta, 11
* el cruz azul juega muy mal, 11
* quiero ir de vacaciones, 12
* extraño ir a la playa, 12
* me gusta cancún, 12
* estuve en manzanillo, 12
* muy buen postre, 15


## TODO

Revisar la siguiente liga para posibles personas que quieran entrar:
[UNAM - Posible clase de lingüística o programación](http://www.corpus.unam.mx/cursopln/plnPython/clase10.pdf)
