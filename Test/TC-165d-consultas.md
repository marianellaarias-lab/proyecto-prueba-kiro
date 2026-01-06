# Casos de Prueba - HU-165d Consultas por Cadena

## Información General
- **Historia:** HU-165d - Consultas por cadena
- **Componente:** API de Consultas + DynamoDB GSI1
- **Tipo:** Funcional, Rendimiento, API
- **Prioridad:** Media

---

## TC-165d-001: Consulta por cadena específica

**Objetivo:** Verificar consultas eficientes por parent_company_code

**Precondiciones:**
- GSI1 configurado y poblado
- API de consultas desplegada
- Datos de prueba variados

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_001", "tid": "POS001", "mid": "MERCH001", "parent_company_code": "CHAIN001", "amount": 100.00, "date": "2024-01-15"},
  {"transaction_id": "TXN_002", "tid": "POS002", "mid": "MERCH002", "parent_company_code": "CHAIN001", "amount": 200.00, "date": "2024-01-15"},
  {"transaction_id": "TXN_003", "tid": "POS003", "mid": "MERCH003", "parent_company_code": "CHAIN002", "amount": 150.00, "date": "2024-01-15"}
]
```

**Pasos:**
1. Ejecutar consulta: `GET /transactions/by-chain/CHAIN001`
2. Verificar resultados retornados
3. Confirmar ordenamiento por fecha/hora
4. Validar estructura de respuesta

**Resultado Esperado:**
- Retorna TXN_001 y TXN_002 únicamente
- Datos completos incluyendo TID, MID
- Ordenamiento cronológico correcto
- Tiempo de respuesta < 2 segundos
- Estructura JSON válida

**Respuesta Esperada:**
```json
{
  "chain_code": "CHAIN001",
  "total_transactions": 2,
  "transactions": [
    {
      "transaction_id": "TXN_001",
      "tid": "POS001", 
      "mid": "MERCH001",
      "amount": 100.00,
      "date": "2024-01-15T10:30:00Z"
    },
    {
      "transaction_id": "TXN_002",
      "tid": "POS002",
      "mid": "MERCH002", 
      "amount": 200.00,
      "date": "2024-01-15T11:00:00Z"
    }
  ]
}
```

---

## TC-165d-002: Consulta por cadena y MID específico

**Objetivo:** Verificar consultas usando GSI1 completo (parent_company_code + MID)

**Precondiciones:**
- GSI1 funcional con datos de prueba

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_010", "tid": "POS010", "mid": "MERCH_SPECIFIC", "parent_company_code": "CHAIN001", "amount": 300.00},
  {"transaction_id": "TXN_011", "tid": "POS011", "mid": "MERCH_SPECIFIC", "parent_company_code": "CHAIN001", "amount": 400.00},
  {"transaction_id": "TXN_012", "tid": "POS012", "mid": "MERCH_OTHER", "parent_company_code": "CHAIN001", "amount": 250.00}
]
```

**Pasos:**
1. Ejecutar consulta: `GET /transactions/by-chain/CHAIN001/merchant/MERCH_SPECIFIC`
2. Verificar que solo retorne transacciones del merchant específico
3. Medir tiempo de respuesta
4. Validar uso eficiente de GSI1

**Resultado Esperado:**
- Retorna solo TXN_010 y TXN_011
- Respuesta rápida usando índice GSI1 (< 500ms)
- Datos completos y precisos
- Sin scan de tabla completa

**Métricas de Rendimiento:**
- Query time < 500ms
- RCU consumption eficiente
- Sin ProvisionedThroughputExceededException

---

## TC-165d-003: Consulta con filtros avanzados

**Objetivo:** Verificar combinación de GSI1 con filtros adicionales

**Precondiciones:**
- API soporta filtros múltiples
- Datos de prueba con rangos variados

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_020", "tid": "POS020", "mid": "MERCH020", "parent_company_code": "CHAIN_FILTER", "amount": 100.00, "date": "2024-01-15", "status": "completed"},
  {"transaction_id": "TXN_021", "tid": "POS021", "mid": "MERCH021", "parent_company_code": "CHAIN_FILTER", "amount": 500.00, "date": "2024-01-16", "status": "completed"},
  {"transaction_id": "TXN_022", "tid": "POS022", "mid": "MERCH022", "parent_company_code": "CHAIN_FILTER", "amount": 200.00, "date": "2024-01-15", "status": "pending"}
]
```

**Pasos:**
1. Consultar con filtros múltiples:
   ```
   GET /transactions/search?parent_company_code=CHAIN_FILTER&date_from=2024-01-15&date_to=2024-01-15&amount_min=150&status=completed
   ```
2. Verificar aplicación correcta de filtros
3. Confirmar rendimiento aceptable
4. Validar lógica de filtrado

**Resultado Esperado:**
- Retorna solo transacciones que cumplan TODOS los filtros
- En este caso: ninguna transacción (TXN_020 amount < 150, TXN_022 status != completed)
- Respuesta vacía pero estructura válida
- Tiempo de respuesta < 2 segundos

---

## TC-165d-004: Paginación en consultas grandes

**Objetivo:** Verificar funcionalidad de paginación para grandes volúmenes

**Precondiciones:**
- 100+ transacciones para una cadena específica
- API soporta paginación

**Datos de Prueba:**
- 150 transacciones con parent_company_code = "CHAIN_LARGE"
- Variedad en TID, MID, fechas, montos

**Pasos:**
1. Consultar primera página: `GET /transactions/by-chain/CHAIN_LARGE?limit=50`
2. Consultar segunda página usando cursor/offset
3. Consultar tercera página
4. Verificar que no haya duplicados ni faltantes

**Resultado Esperado:**
- Primera página: 50 transacciones + cursor/token para siguiente
- Segunda página: 50 transacciones + cursor
- Tercera página: 50 transacciones + indicador de final
- Total: 150 transacciones únicas
- Sin duplicados entre páginas
- Ordenamiento consistente

**Estructura de Paginación:**
```json
{
  "chain_code": "CHAIN_LARGE",
  "page": 1,
  "limit": 50,
  "total_count": 150,
  "has_more": true,
  "next_cursor": "eyJ0aW1lc3RhbXAiOiIyMDI0LTAxLTE1VDEwOjMwOjAwWiJ9",
  "transactions": [...]
}
```

---

## TC-165d-005: Adaptación de filtros existentes

**Objetivo:** Verificar que filtros existentes funcionen con nuevos campos

**Precondiciones:**
- Sistema tiene filtros pre-existentes
- Nuevos campos integrados correctamente

**Escenarios de Prueba:**
1. **Filtros existentes sin nuevos campos**
2. **Filtros existentes + nuevos campos**
3. **Solo nuevos campos como filtros**

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_COMPAT_001", "amount": 100.00, "status": "completed", "tid": "POS_COMPAT_001", "mid": "MERCH_COMPAT_001", "parent_company_code": "CHAIN_COMPAT"},
  {"transaction_id": "TXN_COMPAT_002", "amount": 200.00, "status": "pending", "tid": "POS_COMPAT_002", "mid": "MERCH_COMPAT_002", "parent_company_code": "CHAIN_COMPAT"}
]
```

**Pasos:**
1. Filtro existente: `GET /transactions?status=completed`
2. Filtro combinado: `GET /transactions?status=completed&parent_company_code=CHAIN_COMPAT`
3. Solo nuevo filtro: `GET /transactions?tid=POS_COMPAT_001`
4. Verificar compatibilidad y resultados

**Resultado Esperado:**
- Filtros existentes funcionan sin cambios
- Combinaciones de filtros funcionan correctamente
- Nuevos filtros funcionan independientemente
- Sin regresiones en funcionalidad existente

---

## TC-165d-006: Manejo de consultas sin resultados

**Objetivo:** Verificar respuestas apropiadas para consultas vacías

**Precondiciones:**
- Datos de prueba que no coincidan con criterios

**Pasos:**
1. Consultar cadena inexistente: `GET /transactions/by-chain/NONEXISTENT_CHAIN`
2. Consultar con filtros que no coincidan
3. Consultar merchant inexistente en cadena válida
4. Verificar respuestas y códigos de estado

**Resultado Esperado:**
- Status Code: 200 (no 404)
- Respuesta estructurada con array vacío
- Mensaje informativo apropiado
- Tiempo de respuesta rápido

**Respuesta Esperada:**
```json
{
  "chain_code": "NONEXISTENT_CHAIN",
  "total_transactions": 0,
  "transactions": [],
  "message": "No transactions found for the specified criteria"
}
```

---

## TC-165d-007: Rendimiento bajo carga

**Objetivo:** Verificar rendimiento de consultas bajo carga sostenida

**Precondiciones:**
- Ambiente de prueba con datos representativos
- Herramientas de carga disponibles

**Escenario de Carga:**
- 100 consultas concurrentes por minuto
- Mix de tipos de consulta (por cadena, por merchant, con filtros)
- Duración: 10 minutos

**Métricas a Monitorear:**
- Tiempo de respuesta promedio
- Percentil 95 de latencia
- Throughput sostenido
- Errores de capacidad DynamoDB
- CPU/memoria de Lambda

**Resultado Esperado:**
- Tiempo promedio < 1 segundo
- P95 < 2 segundos
- Sin errores de capacidad
- Throughput sostenido sin degradación
- Recursos dentro de límites

---

## TC-165d-008: Consultas con datos históricos mixtos

**Objetivo:** Verificar manejo de datos con y sin nuevos campos

**Precondiciones:**
- Datos históricos sin TID/MID/parent_company_code
- Datos nuevos con todos los campos

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_OLD_001", "amount": 100.00, "date": "2024-01-01", "tid": null, "mid": null, "parent_company_code": null},
  {"transaction_id": "TXN_NEW_001", "amount": 200.00, "date": "2024-01-15", "tid": "POS_NEW_001", "mid": "MERCH_NEW_001", "parent_company_code": "CHAIN_NEW"}
]
```

**Pasos:**
1. Consultar por parent_company_code que incluya ambos tipos
2. Verificar manejo de valores NULL
3. Confirmar que datos históricos no se pierdan
4. Validar estructura de respuesta consistente

**Resultado Esperado:**
- Datos históricos incluidos con campos NULL/vacío
- Datos nuevos con todos los campos poblados
- Sin errores por campos faltantes
- Estructura de respuesta consistente
- Filtros manejan NULLs apropiadamente

---

## TC-165d-009: Validación de parámetros de entrada

**Objetivo:** Verificar validación robusta de parámetros de consulta

**Casos de Prueba:**
1. **parent_company_code inválido:** caracteres especiales, muy largo
2. **mid inválido:** formato incorrecto, longitud excesiva
3. **tid inválido:** caracteres no permitidos
4. **Fechas inválidas:** formato incorrecto, rangos imposibles
5. **Montos inválidos:** negativos, formato incorrecto
6. **Parámetros de paginación inválidos:** limit negativo, offset inválido

**Pasos:**
1. Enviar consultas con cada tipo de parámetro inválido
2. Verificar respuestas de error apropiadas
3. Confirmar que no se ejecuten consultas inválidas
4. Validar mensajes de error informativos

**Resultado Esperado:**
- Status Code: 400 para parámetros inválidos
- Mensajes de error específicos y útiles
- Sin consultas ejecutadas con parámetros inválidos
- Validación consistente en todos los endpoints

---

## TC-165d-010: Integración con cache

**Objetivo:** Verificar funcionamiento con sistema de cache si existe

**Precondiciones:**
- Sistema de cache configurado (Redis, ElastiCache, etc.)
- Políticas de cache definidas

**Pasos:**
1. Ejecutar consulta por primera vez (cache miss)
2. Ejecutar misma consulta inmediatamente (cache hit)
3. Modificar datos subyacentes
4. Verificar invalidación de cache
5. Confirmar datos actualizados en siguiente consulta

**Resultado Esperado:**
- Primera consulta: cache miss, datos desde DynamoDB
- Segunda consulta: cache hit, respuesta rápida
- Después de modificación: cache invalidado
- Consulta post-modificación: datos actualizados
- Tiempos de respuesta mejorados con cache

---

## Casos de Prueba de Seguridad

### TC-165d-SEC-001: Autorización de consultas
**Objetivo:** Verificar que solo usuarios autorizados puedan consultar datos específicos
- Probar con diferentes niveles de acceso
- Verificar filtrado por permisos de cadena/merchant

### TC-165d-SEC-002: Inyección de parámetros
**Objetivo:** Verificar protección contra inyección en parámetros de consulta
- Probar caracteres especiales en filtros
- Verificar sanitización de entrada

---

## Configuración de Ambiente

**DynamoDB GSI1:**
```
GSI1: parent_company_code-mid-index
- PK: parent_company_code
- SK: mid
- Projected Attributes: ALL
- Provisioned: 50 RCU, 25 WCU
```

**API Endpoints:**
```
GET /transactions/by-chain/{parent_company_code}
GET /transactions/by-chain/{parent_company_code}/merchant/{mid}
GET /transactions/search
```

**Herramientas de Prueba:**
- Postman/Newman para pruebas automatizadas
- JMeter para pruebas de carga
- CloudWatch para monitoreo de métricas