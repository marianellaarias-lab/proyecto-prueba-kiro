# HU-165a - Validación de Campos TID/MID

## User Story
**Como** desarrollador del API Gateway  
**Quiero** implementar validaciones de formato y longitud para TID y MID  
**Para** asegurar la integridad de los datos antes del procesamiento

## Información General
- **Historia Padre:** HU-165
- **Componente:** Lambda Gateway (APIG-DEV-MCS-PRODUCT-VALID-Lmda)
- **Prioridad:** Alta
- **Estimación:** 3 puntos

## Criterios de Aceptación

### Escenario: Validación exitosa de TID
**DADO** que recibo una solicitud con TID  
**CUANDO** el TID tiene entre 1 y 16 caracteres alfanuméricos  
**ENTONCES** la validación debe pasar y continuar el flujo

### Escenario: TID inválido por longitud
**DADO** que recibo una solicitud con TID  
**CUANDO** el TID tiene más de 16 caracteres  
**ENTONCES** debo retornar Error 400 con mensaje "TID excede longitud máxima (16 caracteres)"

### Escenario: Validación exitosa de MID
**DADO** que recibo una solicitud con MID  
**CUANDO** el MID tiene entre 1 y 25 caracteres alfanuméricos  
**ENTONCES** la validación debe pasar y continuar el flujo

### Escenario: MID inválido por longitud
**DADO** que recibo una solicitud con MID  
**CUANDO** el MID tiene más de 25 caracteres  
**ENTONCES** debo retornar Error 400 con mensaje "MID excede longitud máxima (25 caracteres)"

### Escenario: Campos requeridos en V2
**DADO** que la solicitud incluye header de versión "v2"  
**CUANDO** no se envían TID o MID  
**ENTONCES** debo retornar Error 400 con mensaje "TID y MID son requeridos en API v2"

### Escenario: Campos opcionales en V1
**DADO** que la solicitud no incluye header de versión (inferir V1)  
**CUANDO** no se envían TID o MID  
**ENTONCES** la validación debe pasar (campos opcionales en V1)

## Definición de Terminado
- [ ] Validaciones implementadas en Lambda Gateway
- [ ] Mensajes de error claros y específicos
- [ ] Pruebas unitarias para todos los escenarios
- [ ] Documentación de API actualizada
- [ ] Validación de regresión en V1 (sin romper funcionalidad existente)

## Notas Técnicas
- Implementar en modelos PosRequest y GenericPosRequest
- Añadir validaciones de formato y longitud
- Considerar caracteres especiales permitidos
- Mantener compatibilidad con V1 existente