# USER STORY 165F1.3 | API Validaciones | TID, Merchant ID

## Como Aseguradora
Quiero capturar TID (terminal), Merchant ID (MID) 
Para auditar, aplicar reglas por cadena, mejorar trazabilidad y cumplir con regulaciones Federales

## ALCANCE
Nuevos campos en la solicitud:
- tid - Terminal ID Máx 16
- mid - Merchant ID máx 25

Impactos:
- Actualizar el APIG API POS en V2
- Lógica almacenamiento en Transacciones (Punto 6 de los criterios) DB-MCS-Report-Transaccional-Items-Tbl

## Criterios de Aceptación

### A. Criterios de aceptación:
**Scenario: Captura de TID, MID**
Given una solicitud con tid="POS123456789", mid="4549123456789" 
When la API procesa la validación
Then los dos campos quedan disponibles en logs y registro de auditoría
And se pueden consultar 

Si el merchant está en V1 del API, se debe guardar en la transacción los datos MID y TID que llegan de B24/Datalake 

### B. Notas técnicas
- Añadir columnas Merchant ID (MID), Terminal ID (TID) para consultas por cadena
- Debe tener header de versión del API. Si no se envía la versión del API se infiere que es Versión 1 (se valida como está en PROD, no se envia MID, TID)
- Si, está en V2 los campos son requeridos si no se envian en la V2 del API se presenta Error 400
- Si envía datos demás se debe responder como está en PROD al momento con un Error 400
- Validaciones de longitud y formato: tid mid 

### C. Tags
POS; TID; MID

## Notas:
Los cambios deben manejarse en una nueva versión del API para no impactar al proceso actual.