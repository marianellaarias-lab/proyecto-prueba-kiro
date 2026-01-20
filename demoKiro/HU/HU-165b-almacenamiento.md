# HU-165b - Almacenamiento en DynamoDB

## User Story
**Como** desarrollador del Lambda Core  
**Quiero** almacenar los campos TID, MID y parent_company_code en DynamoDB  
**Para** permitir consultas eficientes por cadena y mantener trazabilidad

## Información General
- **Historia Padre:** HU-165
- **Componente:** Lambda Core (product-validation DWHP)
- **Prioridad:** Alta
- **Estimación:** 5 puntos

## Criterios de Aceptación

### Escenario: Almacenamiento exitoso de nuevos campos
**DADO** que recibo datos validados con TID, MID y parent_company_code  
**CUANDO** proceso la transacción  
**ENTONCES** debo:
- Incorporar los campos al payload almacenado en DynamoDB
- Incluirlos en validated_data, sold_data, refund_data y response
- Mantener la estructura existente intacta

### Escenario: Creación de GSI1 para consultas
**DADO** que almaceno una transacción con parent_company_code y MID  
**CUANDO** se crea el registro en DynamoDB  
**ENTONCES** debo:
- Crear GSI1 con parent_company_code como PK
- Usar MID como SK en GSI1
- Permitir consultas eficientes por cadena de comercios

### Escenario: Compatibilidad con datos existentes
**DADO** que proceso transacciones de V1 sin TID/MID  
**CUANDO** almaceno en DynamoDB  
**ENTONCES** debo:
- Mantener la estructura existente
- No fallar por campos faltantes
- Preservar funcionalidad actual

### Escenario: Datos de B24/Datalake en V1
**DADO** que el merchant está en V1  
**CUANDO** no se proporcionan TID/MID en la solicitud  
**ENTONCES** debo:
- Usar los datos que llegan de B24/Datalake
- Almacenar en los mismos campos TID/MID
- Mantener trazabilidad completa

## Definición de Terminado
- [ ] Campos TID, MID, parent_company_code añadidos a tabla DynamoDB
- [ ] GSI1 creado y funcional (parent_company_code + MID)
- [ ] Datos incluidos en todos los objetos de respuesta
- [ ] Migración de datos existentes (si aplica)
- [ ] Pruebas de rendimiento en consultas GSI1
- [ ] Documentación de esquema actualizada

## Notas Técnicas
- **Tabla:** Transacciones principales
- **Nuevas columnas:** tid (String), mid (String), parent_company_code (String)
- **GSI1:** PK=parent_company_code, SK=mid
- **Objetos afectados:** validated_data, sold_data, refund_data, response
- **Considerar:** Índices adicionales si se requieren consultas por TID individual

## Dependencias
- HU-165a debe estar completada (validaciones)
- Coordinación con equipo de infraestructura para cambios en DynamoDB