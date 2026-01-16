# Casos de Prueba - HU-165e Integración con Reportes

## Información General
- **Historia:** HU-165e - Integración con reportes
- **Componente:** AWS Glue + Sistema de Reportes
- **Tipo:** Integración, ETL, BI
- **Prioridad:** Baja

---

## TC-165e-001: Campos disponibles en Glue Reports

**Objetivo:** Verificar que TID, MID, parent_company_code lleguen correctamente a reportes Glue

**Precondiciones:**
- Pipeline de AWS Glue configurado
- Jobs de ETL desplegados
- Transacciones procesadas con nuevos campos

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_GLUE_001", "tid": "POS_GLUE_001", "mid": "MERCH_GLUE_001", "parent_company_code": "CHAIN_GLUE_001", "amount": 150.00, "date": "2024-01-15"},
  {"transaction_id": "TXN_GLUE_002", "tid": "POS_GLUE_002", "mid": "MERCH_GLUE_002", "parent_company_code": "CHAIN_GLUE_002", "amount": 250.00, "date": "2024-01-15"}
]
```

**Pasos:**
1. Procesar transacciones con nuevos campos
2. Ejecutar job de Glue para generar reportes
3. Verificar presencia de campos en dataset resultante
4. Validar integridad de datos en pipeline

**Resultado Esperado:**
- Campos tid, mid, parent_company_code presentes en reporte Glue
- Valores correctos y sin corrupción
- Relaciones entre campos preservadas
- Job de Glue ejecuta sin errores
- Dataset resultante estructuralmente válido

**Verificación en Glue:**
```sql
SELECT transaction_id, tid, mid, parent_company_code, amount, date
FROM glue_transactions_table 
WHERE transaction_id IN ('TXN_GLUE_001', 'TXN_GLUE_002')
```

---

## TC-165e-002: Reportes de validación con nuevos campos

**Objetivo:** Verificar que reportes de validación incluyan métricas de nuevos campos

**Precondiciones:**
- Reporte de validación existente
- Transacciones procesadas con variedad de TID/MID

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_VAL_001", "tid": "POS_VAL_001", "mid": "MERCH_VAL_001", "parent_company_code": "CHAIN_VAL", "validation_status": "success"},
  {"transaction_id": "TXN_VAL_002", "tid": "POS_VAL_002", "mid": "MERCH_VAL_001", "parent_company_code": "CHAIN_VAL", "validation_status": "success"},
  {"transaction_id": "TXN_VAL_003", "tid": "POS_VAL_003", "mid": "MERCH_VAL_002", "parent_company_code": "CHAIN_VAL", "validation_status": "failed"}
]
```

**Pasos:**
1. Procesar transacciones con diferentes estados de validación
2. Generar reporte de validación
3. Verificar breakdown por TID, MID, parent_company_code
4. Confirmar métricas agregadas correctas

**Resultado Esperado:**
- Reporte incluye columnas TID, MID, parent_company_code
- Métricas agregadas por merchant (MID):
  - MERCH_VAL_001: 2 transacciones, 100% éxito
  - MERCH_VAL_002: 1 transacción, 0% éxito
- Métricas por cadena (parent_company_code):
  - CHAIN_VAL: 3 transacciones, 66.7% éxito
- Métricas por terminal (TID) disponibles

**Estructura de Reporte Esperada:**
```
Validation Report - 2024-01-15
================================
By Chain:
CHAIN_VAL: 3 transactions, 2 successful (66.7%)

By Merchant:
MERCH_VAL_001: 2 transactions, 2 successful (100%)
MERCH_VAL_002: 1 transaction, 0 successful (0%)

By Terminal:
POS_VAL_001: 1 transaction, 1 successful (100%)
POS_VAL_002: 1 transaction, 1 successful (100%)
POS_VAL_003: 1 transaction, 0 successful (0%)
```

---

## TC-165e-003: Manejo de datos históricos en reportes

**Objetivo:** Verificar que reportes manejen correctamente registros sin nuevos campos

**Precondiciones:**
- Datos históricos sin TID/MID/parent_company_code
- Datos nuevos con todos los campos
- Reporte configurado para manejar valores NULL

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_HIST_001", "amount": 100.00, "date": "2024-01-01", "tid": null, "mid": null, "parent_company_code": null},
  {"transaction_id": "TXN_HIST_002", "amount": 200.00, "date": "2024-01-10", "tid": null, "mid": null, "parent_company_code": null},
  {"transaction_id": "TXN_NEW_001", "amount": 300.00, "date": "2024-01-15", "tid": "POS_NEW_001", "mid": "MERCH_NEW_001", "parent_company_code": "CHAIN_NEW"}
]
```

**Pasos:**
1. Generar reporte que incluya período histórico y actual
2. Verificar manejo de valores NULL/vacío
3. Confirmar que agregaciones funcionen correctamente
4. Validar que datos históricos no se pierdan

**Resultado Esperado:**
- Registros históricos aparecen con campos NULL/vacío
- Agregaciones manejan NULLs apropiadamente
- Conteos totales incluyen todos los registros
- Métricas por nuevos campos excluyen NULLs correctamente
- Sin errores en procesamiento de datos mixtos

**Reporte Esperado:**
```
Transaction Summary Report
==========================
Total Transactions: 3
- With TID/MID data: 1 (33.3%)
- Historical (no TID/MID): 2 (66.7%)

By Chain (where available):
CHAIN_NEW: 1 transaction, $300.00

By Merchant (where available):
MERCH_NEW_001: 1 transaction, $300.00

Historical Transactions: 2 transactions, $300.00 total
```

---

## TC-165e-004: Nuevas dimensiones de análisis

**Objetivo:** Verificar que usuarios puedan crear análisis usando nuevos campos

**Precondiciones:**
- Herramienta de BI configurada (Tableau, PowerBI, etc.)
- Conexión a dataset con nuevos campos
- Usuarios con acceso a herramientas

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_BI_001", "tid": "POS_STORE_A", "mid": "MERCH_FOOD", "parent_company_code": "RESTAURANT_CHAIN", "amount": 45.50, "category": "food"},
  {"transaction_id": "TXN_BI_002", "tid": "POS_STORE_B", "mid": "MERCH_FOOD", "parent_company_code": "RESTAURANT_CHAIN", "amount": 32.75, "category": "food"},
  {"transaction_id": "TXN_BI_003", "tid": "POS_STORE_A", "mid": "MERCH_RETAIL", "parent_company_code": "RETAIL_CHAIN", "amount": 125.00, "category": "retail"}
]
```

**Pasos:**
1. Crear análisis agrupado por TID (análisis por terminal)
2. Crear análisis agrupado por MID (análisis por merchant)
3. Crear análisis agrupado por parent_company_code (análisis por cadena)
4. Crear análisis cruzado (TID + MID + cadena)
5. Verificar funcionalidad de drill-down

**Resultado Esperado:**
- **Análisis por Terminal (TID):**
  - POS_STORE_A: 2 transacciones, $170.50
  - POS_STORE_B: 1 transacción, $32.75

- **Análisis por Merchant (MID):**
  - MERCH_FOOD: 2 transacciones, $78.25
  - MERCH_RETAIL: 1 transacción, $125.00

- **Análisis por Cadena:**
  - RESTAURANT_CHAIN: 2 transacciones, $78.25
  - RETAIL_CHAIN: 1 transacción, $125.00

- **Análisis Cruzado:** Funcional con drill-down entre dimensiones

---

## TC-165e-005: Integridad del pipeline de datos

**Objetivo:** Verificar integridad end-to-end desde transacción hasta reporte

**Precondiciones:**
- Pipeline completo configurado
- Monitoreo de integridad habilitado

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_E2E_001",
  "tid": "POS_E2E_001", 
  "mid": "MERCH_E2E_001",
  "parent_company_code": "CHAIN_E2E_001",
  "amount": 999.99,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Pasos:**
1. Procesar transacción en sistema origen
2. Verificar almacenamiento en DynamoDB
3. Confirmar procesamiento en Glue ETL
4. Validar aparición en reportes finales
5. Verificar consistencia de datos en cada etapa

**Resultado Esperado:**
- Datos consistentes en todas las etapas del pipeline
- Sin pérdida de información en transformaciones
- Timestamps preservados correctamente
- Relaciones entre campos mantenidas
- Latencia total del pipeline dentro de SLA

**Puntos de Verificación:**
1. **DynamoDB:** Datos almacenados correctamente
2. **Glue Job:** Transformación exitosa
3. **Data Lake:** Datos disponibles para consulta
4. **Reportes:** Datos visibles en dashboards
5. **Métricas:** Contadores de integridad correctos

---

## TC-165e-006: Reportes transaccionales con nuevas columnas

**Objetivo:** Verificar que reportes transaccionales muestren nuevos campos

**Precondiciones:**
- Reporte transaccional existente
- Template actualizado con nuevos campos

**Datos de Prueba:**
```json
[
  {"transaction_id": "TXN_RPT_001", "tid": "POS_RPT_001", "mid": "MERCH_RPT_001", "parent_company_code": "CHAIN_RPT_001", "amount": 100.00, "status": "completed"},
  {"transaction_id": "TXN_RPT_002", "tid": "POS_RPT_002", "mid": "MERCH_RPT_002", "parent_company_code": "CHAIN_RPT_002", "amount": 200.00, "status": "pending"}
]
```

**Pasos:**
1. Generar reporte transaccional estándar
2. Verificar presencia de nuevas columnas
3. Confirmar formato y ordenamiento
4. Validar exportación (CSV, Excel, PDF)

**Resultado Esperado:**
- Reporte incluye columnas: TID, MID, Parent Company Code
- Datos correctos en cada fila
- Formato consistente con estándares existentes
- Exportación funcional en todos los formatos
- Headers de columna descriptivos

**Estructura de Reporte:**
```
Transaction Report - 2024-01-15
================================
Transaction ID | TID         | MID           | Parent Company | Amount | Status
TXN_RPT_001   | POS_RPT_001 | MERCH_RPT_001 | CHAIN_RPT_001  | $100.00| Completed
TXN_RPT_002   | POS_RPT_002 | MERCH_RPT_002 | CHAIN_RPT_002  | $200.00| Pending
```

---

## TC-165e-007: Métricas agregadas por nuevos campos

**Objetivo:** Verificar cálculo correcto de métricas usando nuevos campos

**Precondiciones:**
- Sistema de métricas configurado
- Datos suficientes para agregaciones significativas

**Datos de Prueba:**
```json
[
  {"tid": "POS_001", "mid": "MERCH_A", "parent_company_code": "CHAIN_X", "amount": 100.00, "date": "2024-01-15"},
  {"tid": "POS_001", "mid": "MERCH_A", "parent_company_code": "CHAIN_X", "amount": 150.00, "date": "2024-01-15"},
  {"tid": "POS_002", "mid": "MERCH_A", "parent_company_code": "CHAIN_X", "amount": 200.00, "date": "2024-01-15"},
  {"tid": "POS_003", "mid": "MERCH_B", "parent_company_code": "CHAIN_X", "amount": 75.00, "date": "2024-01-15"}
]
```

**Pasos:**
1. Generar métricas por terminal (TID)
2. Generar métricas por merchant (MID)
3. Generar métricas por cadena (parent_company_code)
4. Verificar cálculos de suma, promedio, conteo
5. Validar métricas de concentración/distribución

**Resultado Esperado:**
- **Por Terminal:**
  - POS_001: 2 transacciones, $250.00 total, $125.00 promedio
  - POS_002: 1 transacción, $200.00 total, $200.00 promedio
  - POS_003: 1 transacción, $75.00 total, $75.00 promedio

- **Por Merchant:**
  - MERCH_A: 3 transacciones, $450.00 total, $150.00 promedio
  - MERCH_B: 1 transacción, $75.00 total, $75.00 promedio

- **Por Cadena:**
  - CHAIN_X: 4 transacciones, $525.00 total, $131.25 promedio

- **Concentración:** 75% del volumen en MERCH_A

---

## TC-165e-008: Rendimiento de reportes con nuevos campos

**Objetivo:** Verificar que nuevos campos no impacten significativamente el rendimiento de reportes

**Precondiciones:**
- Baseline de rendimiento establecido
- Dataset representativo (10K+ transacciones)

**Datos de Prueba:**
- 10,000 transacciones con nuevos campos
- 10,000 transacciones sin nuevos campos (control)

**Pasos:**
1. Generar reporte con dataset que incluya nuevos campos
2. Generar reporte control sin nuevos campos
3. Comparar tiempos de procesamiento
4. Analizar uso de recursos (CPU, memoria, I/O)

**Resultado Esperado:**
- Incremento en tiempo de procesamiento < 15%
- Uso de memoria incrementa proporcionalmente
- Sin timeouts o errores de recursos
- Calidad de reportes mantenida
- SLA de generación de reportes cumplido

**Métricas de Rendimiento:**
- Tiempo de ETL: baseline + 10-15%
- Memoria utilizada: baseline + 5-10%
- Tiempo de consulta: baseline + 5%
- Tamaño de reporte: incremento esperado por nuevas columnas

---

## TC-165e-009: Compatibilidad con herramientas BI existentes

**Objetivo:** Verificar que herramientas BI existentes funcionen con nuevos campos

**Precondiciones:**
- Herramientas BI conectadas al dataset
- Dashboards existentes configurados

**Pasos:**
1. Actualizar conexiones de datos en herramientas BI
2. Verificar que dashboards existentes no se rompan
3. Añadir nuevos campos a dashboards existentes
4. Crear nuevos dashboards usando nuevos campos
5. Probar funcionalidad de filtros y drill-down

**Resultado Esperado:**
- Dashboards existentes funcionan sin cambios
- Nuevos campos disponibles para selección
- Filtros por TID/MID/parent_company_code funcionales
- Visualizaciones se actualizan correctamente
- Sin errores de conexión o consulta

---

## TC-165e-010: Documentación y capacitación de usuarios

**Objetivo:** Verificar que usuarios tengan documentación adecuada sobre nuevos campos

**Precondiciones:**
- Documentación actualizada
- Usuarios identificados para capacitación

**Pasos:**
1. Revisar documentación de campos actualizada
2. Verificar ejemplos de uso en documentación
3. Probar guías paso a paso
4. Validar glosario de términos
5. Confirmar disponibilidad de soporte

**Resultado Esperado:**
- Documentación clara sobre TID, MID, parent_company_code
- Ejemplos prácticos de análisis
- Guías para crear reportes personalizados
- Glosario actualizado con nuevos términos
- Canal de soporte disponible para preguntas

**Elementos de Documentación:**
- **Definiciones:** Qué es TID, MID, parent_company_code
- **Casos de uso:** Cuándo usar cada campo para análisis
- **Ejemplos:** Queries y reportes de ejemplo
- **Limitaciones:** Datos históricos, disponibilidad
- **FAQ:** Preguntas frecuentes sobre nuevos campos

---

## Casos de Prueba de Regresión

### TC-165e-REG-001: Reportes existentes intactos
**Objetivo:** Asegurar que reportes existentes no se vean afectados
- Ejecutar suite de reportes pre-existentes
- Verificar que resultados sean idénticos
- Confirmar que no hay regresiones

### TC-165e-REG-002: Performance de reportes históricos
**Objetivo:** Verificar que reportes de períodos históricos mantengan rendimiento
- Generar reportes de períodos anteriores a implementación
- Comparar con baseline histórico
- Confirmar rendimiento aceptable

---

## Configuración de Ambiente

**AWS Glue Jobs:**
```
Job: transaction-etl-job
- Input: DynamoDB transactions table
- Output: S3 data lake / Redshift
- Schedule: Daily at 2 AM
- Include fields: tid, mid, parent_company_code
```

**Data Lake Schema:**
```sql
CREATE TABLE transactions (
  transaction_id STRING,
  tid STRING,
  mid STRING, 
  parent_company_code STRING,
  amount DECIMAL(10,2),
  transaction_date DATE,
  status STRING
)
```

**Herramientas de Monitoreo:**
- CloudWatch para métricas de Glue jobs
- Data quality checks automatizados
- Alertas por fallos en pipeline