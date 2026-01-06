# HU-165c - Logging y Auditoría

## User Story
**Como** auditor del sistema  
**Quiero** que se registren TID, MID y parent_company_code en todos los logs  
**Para** tener trazabilidad completa de las transacciones y cumplir con regulaciones

## Información General
- **Historia Padre:** HU-165
- **Componente:** Lambda Core + Logging Infrastructure
- **Prioridad:** Media
- **Estimación:** 3 puntos

## Criterios de Aceptación

### Escenario: Logging en procesamiento principal
**DADO** que proceso una transacción con TID, MID y parent_company_code  
**CUANDO** se ejecuta el flujo de validación  
**ENTONCES** debo registrar en logs:
- TID en todos los puntos de logging relevantes
- MID en todos los puntos de logging relevantes  
- parent_company_code para identificación de cadena
- Timestamp y contexto de la transacción

### Escenario: Logging en utils_logger
**DADO** que utilizo las utilidades de logging  
**CUANDO** registro eventos de la transacción  
**ENTONCES** debo:
- Incluir TID, MID, parent_company_code como campos estándar
- Mantener formato consistente en todos los logs
- Asegurar que no se pierda información en el flujo

### Escenario: Auditoría de cambios
**DADO** que se modifica una transacción  
**CUANDO** se registra el cambio  
**ENTONCES** debo:
- Logear estado anterior y nuevo
- Incluir identificadores TID/MID para trazabilidad
- Registrar usuario/sistema que realizó el cambio
- Mantener integridad del audit trail

### Escenario: Logs estructurados para análisis
**DADO** que genero logs de transacciones  
**CUANDO** se almacenan en el sistema de logging  
**ENTONCES** debo:
- Usar formato JSON estructurado
- Incluir campos searchables (TID, MID, parent_company_code)
- Facilitar consultas y análisis posteriores
- Cumplir con estándares de logging corporativos

## Definición de Terminado
- [ ] TID, MID, parent_company_code incluidos en logger principal
- [ ] utils_logger actualizado con nuevos campos
- [ ] Logs estructurados y searchables
- [ ] Documentación de formato de logs actualizada
- [ ] Pruebas de logging en todos los flujos críticos
- [ ] Verificación de compliance con regulaciones

## Notas Técnicas
- **Formato:** JSON estructurado
- **Campos obligatorios:** timestamp, level, message, tid, mid, parent_company_code
- **Herramientas:** CloudWatch/Kinesis para análisis
- **Retención:** Según políticas de compliance (típicamente 7 años)
- **Sensibilidad:** Considerar enmascaramiento de datos sensibles

## Consideraciones de Compliance
- Regulaciones Federales requieren trazabilidad completa
- Logs deben ser inmutables una vez escritos
- Acceso controlado para auditorías
- Backup y archivado según políticas corporativas

## Dependencias
- HU-165a (validaciones) debe estar completada
- HU-165b (almacenamiento) debe estar en progreso
- Coordinación con equipo de compliance/auditoría