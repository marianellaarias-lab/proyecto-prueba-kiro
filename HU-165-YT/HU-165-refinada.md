# USER STORY 165F1.3 - API Validaciones TID y Merchant ID (REFINADA)

## Historia de Usuario
**Como** Aseguradora  
**Quiero** capturar TID (Terminal ID) y Merchant ID (MID) en las solicitudes del API  
**Para** auditar, aplicar reglas por cadena, mejorar trazabilidad y cumplir con regulaciones Federales  

## Definición de Campos
- **TID (Terminal ID)**: Máximo 16 caracteres
- **MID (Merchant ID)**: Máximo 25 caracteres

## Reglas de Negocio

### RN001 - Versionado del API
- Si no se envía la versión del API se infiere que es Versión 1
- En Versión 1: se valida como está en PROD, no se envía MID, TID
- En Versión 2: los campos TID y MID son requeridos

### RN002 - Manejo de Errores
- Si no se envían MID y TID en la V2 del API se presenta Error 400
- Si envía datos demás se debe responder como está en PROD al momento con un Error 400

### RN003 - Validaciones de Campos
- Validaciones de longitud y formato para TID y MID

### RN004 - Almacenamiento en V1
- Si el merchant está en V1 del API, se debe guardar en la transacción los datos MID y TID que llegan de B24/Datalake

### RN005 - Compatibilidad
- Los cambios deben manejarse en una nueva versión del API para no impactar al proceso actual

### RN006 - Almacenamiento y Consultas
- Añadir columnas Merchant ID (MID), Terminal ID (TID) para consultas por cadena
- Debe tener header de versión del API

## Escenarios de Aceptación

### Escenario 1: Captura exitosa de TID y MID en API V2
```gherkin
Given el API está configurado en versión V2
And el header de versión está presente en la solicitud
When se envía una solicitud con tid="POS123456789" and mid="4549123456789"
Then la API procesa la validación exitosamente
And los campos TID y MID quedan disponibles en logs
And los campos TID y MID quedan disponibles en registro de auditoría
And los datos se almacenan en DB-MCS-Report-Transaccional-Items-Tbl
And se pueden consultar
```

### Escenario 2: Procesamiento en API V1 con datos de B24/Datalake
```gherkin
Given el merchant está usando API V1
And no se envía header de versión en la solicitud
When la API recibe la solicitud
Then se infiere que es versión 1
And se guardan en la transacción los datos MID y TID que llegan de B24/Datalake
And la validación se procesa como está en PROD actualmente
```

### Escenario 3: Error por campos faltantes en API V2
```gherkin
Given el API está configurado en versión V2
And el header de versión está presente en la solicitud
When se envía una solicitud sin el campo TID
Then la API responde con Error 400
And el mensaje indica que los campos son requeridos en V2
```

### Escenario 4: Error por campos faltantes en API V2 - MID
```gherkin
Given el API está configurado en versión V2
And el header de versión está presente en la solicitud
When se envía una solicitud sin el campo MID
Then la API responde con Error 400
And el mensaje indica que los campos son requeridos en V2
```

### Escenario 5: Error por longitud excedida en TID
```gherkin
Given el API está configurado en versión V2
And el header de versión está presente en la solicitud
When se envía una solicitud con tid que excede 16 caracteres
Then la API responde con Error 400
And el mensaje indica error de validación de longitud para TID
```

### Escenario 6: Error por longitud excedida en MID
```gherkin
Given el API está configurado en versión V2
And el header de versión está presente en la solicitud
When se envía una solicitud con mid que excede 25 caracteres
Then la API responde con Error 400
And el mensaje indica error de validación de longitud para MID
```

### Escenario 7: Error por datos adicionales no permitidos
```gherkin
Given el API está configurado en cualquier versión
When se envía una solicitud con campos adicionales no permitidos
Then la API responde con Error 400
And se mantiene el comportamiento actual de PROD
```

### Escenario 8: Consulta exitosa de datos almacenados
```gherkin
Given existen transacciones almacenadas con MID y TID
When se realiza una consulta de los datos
Then se pueden consultar los campos TID y MID almacenados
```

## Impactos Técnicos
- Actualización del APIG API POS a versión V2
- Modificación de lógica de almacenamiento en Transacciones
- Adición de columnas en DB-MCS-Report-Transaccional-Items-Tbl

## Tags
POS, TID, MID, API_V2, Validaciones

---

## PREGUNTAS PARA EL PRODUCT OWNER

### Validaciones y Formato
1. **¿Qué formato específico deben tener los campos TID y MID?** (alfanumérico, solo números, caracteres especiales permitidos)
2. **¿Cuál es el comportamiento esperado si TID o MID están vacíos pero se envían en la solicitud?**
3. **¿Se requiere alguna validación de formato específica más allá de la longitud?**

### Versionado del API
4. **¿Cómo se especifica exactamente el header de versión del API?** (nombre del header, valores permitidos)
5. **¿Qué sucede si se envía un header de versión inválido o no reconocido?**

### Comportamiento en V1
6. **¿Cómo se obtienen exactamente los datos MID y TID desde B24/Datalake en V1?**
7. **¿Qué sucede si B24/Datalake no proporciona estos datos en V1?**

### Almacenamiento y Consultas
8. **¿Cuáles son los nombres exactos de las nuevas columnas en DB-MCS-Report-Transaccional-Items-Tbl?**
9. **¿Cómo funcionan exactamente las "consultas por cadena" mencionadas en las notas técnicas?**
10. **¿Qué tipo de consultas específicas se pueden realizar con los campos TID y MID?**
11. **¿Se requieren índices específicos en las nuevas columnas para optimizar consultas?**

### Mensajes de Error
12. **¿Cuáles son los mensajes de error específicos que se deben retornar para cada tipo de validación?**
13. **¿Se requiere algún código de error específico además del HTTP 400?**

### Compatibilidad
14. **¿Existe algún plan de migración para merchants que usen V1 hacia V2?**
15. **¿Cuándo se planea deprecar la versión V1 del API?**