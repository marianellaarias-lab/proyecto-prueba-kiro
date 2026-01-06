# Casos de Prueba - HU-165c Logging y Auditoría

## Información General
- **Historia:** HU-165c - Logging y auditoría
- **Componente:** Lambda Core + Sistema de Logging
- **Tipo:** Funcional, Auditoría, Compliance
- **Prioridad:** Media

---

## TC-165c-001: Logging en procesamiento principal

**Objetivo:** Verificar que TID, MID, parent_company_code se registren en todos los puntos relevantes

**Precondiciones:**
- Sistema de logging configurado
- Nivel de log apropiado (INFO/DEBUG)
- Lambda Core desplegado

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_LOG_001",
  "tid": "POS_LOG_001",
  "mid": "MERCH_LOG_001", 
  "parent_company_code": "CHAIN_LOG_001",
  "amount": 250.75
}
```

**Pasos:**
1. Procesar transacción con datos completos
2. Revisar logs en CloudWatch/sistema de logging
3. Verificar presencia de TID/MID/parent_company_code en logs
4. Confirmar timestamps y contexto

**Resultado Esperado:**
- Logs contienen TID, MID, parent_company_code en puntos clave:
  - Inicio de procesamiento
  - Validación exitosa
  - Almacenamiento en DynamoDB
  - Finalización de transacción
- Timestamps precisos y consistentes
- Contexto de transacción mantenido

**Verificación de Logs:**
```
[2024-01-15T10:30:00.123Z] INFO Processing transaction TXN_LOG_001 - TID: POS_LOG_001, MID: MERCH_LOG_001, Chain: CHAIN_LOG_001
[2024-01-15T10:30:00.456Z] INFO Validation successful - TID: POS_LOG_001, MID: MERCH_LOG_001
[2024-01-15T10:30:00.789Z] INFO Stored in DynamoDB - TID: POS_LOG_001, MID: MERCH_LOG_001, Chain: CHAIN_LOG_001
```

---

## TC-165c-002: Logging con utils_logger

**Objetivo:** Verificar que utils_logger incluya nuevos campos como estándar

**Precondiciones:**
- utils_logger configurado con nuevos campos
- Múltiples puntos de logging en el código

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_UTILS_001",
  "tid": "POS_UTILS_001",
  "mid": "MERCH_UTILS_001",
  "parent_company_code": "CHAIN_UTILS_001"
}
```

**Pasos:**
1. Ejecutar flujo que use utils_logger en múltiples puntos
2. Verificar formato consistente en todos los logs
3. Confirmar que nuevos campos aparezcan automáticamente
4. Validar estructura JSON si aplica

**Resultado Esperado:**
- Formato consistente en todos los logs generados por utils_logger
- TID, MID, parent_company_code incluidos automáticamente
- Estructura JSON válida y parseable
- Sin duplicación o campos faltantes

**Formato Esperado:**
```json
{
  "timestamp": "2024-01-15T10:30:00.123Z",
  "level": "INFO",
  "message": "Processing validation",
  "transaction_id": "TXN_UTILS_001",
  "tid": "POS_UTILS_001",
  "mid": "MERCH_UTILS_001", 
  "parent_company_code": "CHAIN_UTILS_001",
  "component": "validation-service"
}
```

---

## TC-165c-003: Auditoría de cambios de transacción

**Objetivo:** Verificar logging completo cuando se modifica una transacción

**Precondiciones:**
- Transacción existente en sistema
- Capacidad de modificar transacciones

**Datos de Prueba Inicial:**
```json
{
  "transaction_id": "TXN_AUDIT_001",
  "tid": "POS_ORIGINAL",
  "mid": "MERCH_ORIGINAL",
  "parent_company_code": "CHAIN_ORIGINAL",
  "status": "pending"
}
```

**Datos de Modificación:**
```json
{
  "transaction_id": "TXN_AUDIT_001", 
  "tid": "POS_UPDATED",
  "mid": "MERCH_UPDATED",
  "parent_company_code": "CHAIN_UPDATED",
  "status": "completed"
}
```

**Pasos:**
1. Crear transacción inicial
2. Modificar transacción con nuevos valores
3. Revisar logs de auditoría
4. Verificar trazabilidad completa

**Resultado Esperado:**
- Log de estado anterior completo
- Log de estado nuevo completo
- Identificación clara del cambio
- Usuario/sistema que realizó cambio registrado
- Timestamp preciso del cambio
- Razón del cambio si está disponible

**Logs de Auditoría Esperados:**
```
[2024-01-15T10:30:00Z] AUDIT Transaction TXN_AUDIT_001 modified by system_user
  BEFORE: {"tid":"POS_ORIGINAL","mid":"MERCH_ORIGINAL","parent_company_code":"CHAIN_ORIGINAL","status":"pending"}
  AFTER:  {"tid":"POS_UPDATED","mid":"MERCH_UPDATED","parent_company_code":"CHAIN_UPDATED","status":"completed"}
```

---

## TC-165c-004: Logs estructurados para análisis

**Objetivo:** Verificar que logs sean estructurados y searchables

**Precondiciones:**
- Sistema de logging configurado para JSON estructurado
- Herramientas de búsqueda disponibles (CloudWatch Insights, ELK, etc.)

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_SEARCH_001",
  "tid": "POS_SEARCH_001", 
  "mid": "MERCH_SEARCH_001",
  "parent_company_code": "CHAIN_SEARCH_001"
}
```

**Pasos:**
1. Procesar transacción
2. Buscar logs por TID específico
3. Buscar logs por MID específico  
4. Buscar logs por parent_company_code
5. Realizar búsquedas combinadas

**Resultado Esperado:**
- Búsqueda por TID retorna todos los logs relacionados
- Búsqueda por MID retorna logs apropiados
- Búsqueda por parent_company_code funciona correctamente
- Búsquedas combinadas (TID + MID) funcionan
- Resultados ordenados cronológicamente
- Formato JSON válido y parseable

**Consultas de Prueba:**
```
fields @timestamp, @message | filter tid = "POS_SEARCH_001"
fields @timestamp, @message | filter mid = "MERCH_SEARCH_001" 
fields @timestamp, @message | filter parent_company_code = "CHAIN_SEARCH_001"
```

---

## TC-165c-005: Logging de errores con contexto

**Objetivo:** Verificar que errores incluyan contexto completo con nuevos campos

**Precondiciones:**
- Capacidad de simular errores
- Sistema de logging de errores configurado

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_ERROR_001",
  "tid": "POS_ERROR_001",
  "mid": "MERCH_ERROR_001",
  "parent_company_code": "CHAIN_ERROR_001",
  "invalid_field": "cause_error"
}
```

**Pasos:**
1. Procesar transacción que cause error (validación, DynamoDB, etc.)
2. Revisar logs de error generados
3. Verificar contexto completo en logs de error
4. Confirmar stack trace si aplica

**Resultado Esperado:**
- Logs de error incluyen TID, MID, parent_company_code
- Contexto completo de la transacción preservado
- Stack trace detallado cuando apropiado
- Nivel de log apropiado (ERROR)
- Información suficiente para debugging

**Log de Error Esperado:**
```json
{
  "timestamp": "2024-01-15T10:30:00.123Z",
  "level": "ERROR", 
  "message": "Validation failed for transaction",
  "transaction_id": "TXN_ERROR_001",
  "tid": "POS_ERROR_001",
  "mid": "MERCH_ERROR_001",
  "parent_company_code": "CHAIN_ERROR_001",
  "error": "Invalid field format",
  "stack_trace": "..."
}
```

---

## TC-165c-006: Compliance con regulaciones

**Objetivo:** Verificar que logging cumpla con requerimientos regulatorios

**Precondiciones:**
- Conocimiento de regulaciones aplicables
- Sistema configurado para compliance

**Aspectos a Verificar:**
1. **Inmutabilidad:** Logs no pueden modificarse después de escritura
2. **Integridad:** Logs completos sin gaps
3. **Retención:** Logs preservados según política (ej: 7 años)
4. **Acceso:** Logs accesibles para auditorías
5. **Encriptación:** Logs encriptados en tránsito y reposo

**Pasos:**
1. Generar transacciones de prueba
2. Verificar inmutabilidad de logs
3. Confirmar políticas de retención
4. Validar encriptación
5. Probar acceso controlado

**Resultado Esperado:**
- Logs inmutables una vez escritos
- Retención automática según política
- Encriptación end-to-end
- Acceso controlado y auditado
- Cumplimiento con regulaciones federales

---

## TC-165c-007: Rendimiento de logging

**Objetivo:** Verificar que logging adicional no impacte significativamente el rendimiento

**Precondiciones:**
- Baseline de rendimiento establecido
- Métricas de rendimiento habilitadas

**Datos de Prueba:**
- 1000 transacciones con logging completo
- 1000 transacciones con logging mínimo (control)

**Pasos:**
1. Procesar lote con logging completo de nuevos campos
2. Procesar lote control con logging mínimo
3. Comparar tiempos de procesamiento
4. Analizar overhead de logging

**Resultado Esperado:**
- Overhead de logging < 5% del tiempo total
- Sin impacto en latencia de usuario
- Throughput mantenido dentro de SLA
- Recursos de logging escalables

---

## TC-165c-008: Correlación de logs distribuidos

**Objetivo:** Verificar que logs mantengan correlación a través de componentes

**Precondiciones:**
- Múltiples componentes (Gateway, Core, DynamoDB)
- Correlation ID implementado

**Datos de Prueba:**
```json
{
  "correlation_id": "CORR_001",
  "transaction_id": "TXN_CORR_001",
  "tid": "POS_CORR_001",
  "mid": "MERCH_CORR_001",
  "parent_company_code": "CHAIN_CORR_001"
}
```

**Pasos:**
1. Procesar transacción que pase por múltiples componentes
2. Buscar logs por correlation_id
3. Verificar presencia de TID/MID/parent_company_code en todos los componentes
4. Confirmar orden cronológico correcto

**Resultado Esperado:**
- Logs de todos los componentes correlacionados
- TID/MID/parent_company_code consistentes en todos los logs
- Flujo completo trazeable
- Timestamps coherentes entre componentes

---

## TC-165c-009: Logging de métricas y eventos

**Objetivo:** Verificar que nuevos campos se incluyan en eventos de métricas

**Precondiciones:**
- Sistema de métricas configurado (CloudWatch/Kinesis)
- Eventos de negocio definidos

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_METRICS_001",
  "tid": "POS_METRICS_001",
  "mid": "MERCH_METRICS_001", 
  "parent_company_code": "CHAIN_METRICS_001",
  "amount": 500.00,
  "event_type": "transaction_completed"
}
```

**Pasos:**
1. Procesar transacción que genere eventos de métricas
2. Verificar eventos en sistema de métricas
3. Confirmar inclusión de nuevos campos
4. Validar estructura de eventos

**Resultado Esperado:**
- Eventos incluyen TID, MID, parent_company_code
- Métricas agregables por nuevos campos
- Eventos enviados a CloudWatch/Kinesis correctamente
- Estructura consistente con estándares

---

## TC-165c-010: Logging de transacciones V1 vs V2

**Objetivo:** Verificar diferenciación clara entre transacciones V1 y V2 en logs

**Precondiciones:**
- Soporte para ambas versiones API

**Datos de Prueba V1:**
```json
{
  "transaction_id": "TXN_V1_LOG_001",
  "amount": 100.00
}
```

**Datos de Prueba V2:**
```json
{
  "transaction_id": "TXN_V2_LOG_001", 
  "tid": "POS_V2_001",
  "mid": "MERCH_V2_001",
  "parent_company_code": "CHAIN_V2_001",
  "amount": 100.00
}
```

**Pasos:**
1. Procesar transacción V1
2. Procesar transacción V2
3. Comparar logs generados
4. Verificar diferenciación clara

**Resultado Esperado:**
- Logs V1 indican ausencia de nuevos campos claramente
- Logs V2 incluyen todos los nuevos campos
- Versión API claramente identificada en logs
- Comportamiento diferenciado documentado

---

## Configuración de Ambiente de Prueba

**CloudWatch Setup:**
- Log Groups configurados
- Retention policy apropiada
- Structured logging habilitado

**Métricas y Alertas:**
- Alertas por errores de logging
- Métricas de volumen de logs
- Dashboards para monitoreo

**Herramientas de Análisis:**
- CloudWatch Insights configurado
- Queries predefinidas para TID/MID/parent_company_code
- Acceso controlado para equipos de auditoría