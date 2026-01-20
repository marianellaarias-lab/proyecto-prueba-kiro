# HU-165 - Captura de TID y MID para Auditoría

## User Story
**Como** Aseguradora  
**Quiero** que el sistema valide y almacene TID (Terminal ID) y MID (Merchant ID) en todas las transacciones  
**Para** auditar, aplicar reglas por cadena, mejorar trazabilidad y cumplir con regulaciones Federales

## Información General
- **Estado:** Resolved
- **Área:** ATMP
- **Iteración:** ATMP\Sprint 8
- **Épica:** F1.3 | API Validaciones

## Alcance
1. **Nuevos campos en la solicitud:**
   - tid - Terminal ID (máx 16 caracteres)
   - mid - Merchant ID (máx 25 caracteres)

2. **Impactos:**
   - Actualizar el APIG API POS en V2
   - Lógica almacenamiento en Transacciones (Punto 6 de los criterios)

## Criterios de Aceptación

### Escenario: Captura exitosa de TID y MID
**DADO** que soy una aseguradora procesando transacciones  
**CUANDO** envío una solicitud con tid="POS123456789" y mid="454912345678"  
**ENTONCES** el sistema debe:
- Validar que TID tenga máximo 16 caracteres
- Validar que MID tenga máximo 25 caracteres
- Almacenar ambos campos en DynamoDB
- Registrar en logs de auditoría
- Permitir consultas posteriores

### Escenario: Validación de versión API
**DADO** que el merchant está en V1 del API  
**CUANDO** no se envían los campos MID y TID  
**ENTONCES** se debe guardar en la transacción los datos que llegan de B24/Datalake

**DADO** que el merchant está en V2 del API  
**CUANDO** no se envían los campos requeridos  
**ENTONCES** se debe presentar Error 400

## Notas Técnicas
- Los cambios deben manejarse en una nueva versión del API para no impactar al proceso actual
- Debe tener header de versión del API
- Añadir columnas MID, TID para consultas por cadena
- Crear GSI1 con parent_company_code (PK) + mid (SK)

## Tags
POS, TID, MID, Validaciones, Auditoría

## Historias Derivadas
- [HU-165a: Validación de campos TID/MID](./HU-165a-validacion.md)
- [HU-165b: Almacenamiento en DynamoDB](./HU-165b-almacenamiento.md)
- [HU-165c: Logging y auditoría](./HU-165c-logging.md)
- [HU-165d: Consultas por cadena](./HU-165d-consultas.md)
- [HU-165e: Integración con reportes](./HU-165e-reportes.md)