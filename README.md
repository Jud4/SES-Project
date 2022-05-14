# Orden de deployment
/VPC

/parent_mod
## Variables
En /parent_mod hay 3 variables que setear 
- **sender_mail**: El email que usaremos para enviar
- **origin_domain**: El dominio del _sender_mail_ (gmail.com,yahoo.com, etc.)
- **Secondmail**: La dirección del email receptor
# Comprobación del resultado
Para ver que efectivamente tenemos conectada la instancia con SES ejecutamos el comando
```bash
openssl s_client -crlf -quiet -starttls smtp -connect email-smtp.us-west-2.amazonaws.com:587
```
Con esto nos conectamos al servicio de SES
El resultado debería verse algo como esto:

```bash
depth=2 C = US, O = Amazon, CN = Amazon Root CA 1
verify return:1
depth=1 C = US, O = Amazon, OU = Server CA 1B, CN = Amazon
verify return:1
depth=0 CN = email-smtp.us-west-2.amazonaws.com
verify return:1
250 Ok
```
# Aplicación Sendmail
Si bien ya la instancia podría enviar mensajes como se puede ver en este [post](https://docs.aws.amazon.com/ses/latest/dg/send-email-smtp-client-command-line.html),
se buscó una alternativa que permitiese hacer el proceso un poco más sencillo.

Para eso se instaló Sendmail, sin embargo, esta no funciona correctamente y es incapaz de hacer que los cliente de email vean los correos que les envía.

Sin embargo, para mandar un correo esta sería la forma:

```bash
/usr/sbin/sendmail -vf judavillalta@gmail.com judavillalta@yahoo.com 
```

Luego de este comando escribir, linea por línea, lo siguiente
```bash
From: judavillalta@gmail.com 
To: judavillalta@yahoo.com 
Subject: Amazon SES email

Hello from my VPC.
```
Si funcionase bien debería mandar el correo correctamente.
