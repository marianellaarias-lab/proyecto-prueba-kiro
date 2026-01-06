# Casos de Prueba - HU-165b Almacenamiento en DynamoDB

## Información General
- **Historia:** HU-165b - Almacenamiento en DynamoDB
- **Componente:** Lambda Core (product-validation DWHP)
- **Tipo:** Integración, Base de Datos
- **Prioridad:** Alta

---

## TC-165b-001: Almacenamiento exitoso de nuevos campos

**Objetivo:** Verificar que TID, MID, parent_company_code se almacenen correctamente

**Precondiciones:**
- DynamoDB tabla configurada con nuevos campos
- Lambda Core desplegado
- Datos validados disponibles

**Datos de Prueba:**
```json
{
  "tid": "POS123456789",
  "mid": "MERCHANT001",
  "parent_company_code": "CHAIN001",
  "transaction_id": "TXN_001",
  "amount": 100.50,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Pasos:**
1. Procesar transacción con datos completos
2. Consultar registro en DynamoDB
3. Verificar presencia de todos los campos

**Resultado Esperado:**
- Registro creado exitosamente
- Campos tid, mid, parent_company_code presentes
- Datos incluidos en validated_data, sold_data, refund_data, response
- Estructura existente intacta

**Consulta de Verificación:**
```sql
SELECT * FROM transactions WHERE transaction_id = 'TXN_001'
```

---

## TC-165b-002: Creación y funcionalidad de GSI1

**Objetivo:** Verificar que GSI1 se cree correctamente para consultas por cadena

**Precondiciones:**
- GSI1 configurado: PK=parent_company_code, SK=mid
- Múltiples transacciones almacenadas

**Datos de Prueba:**
```json
[
  {
    "tid": "POS001", "mid": "MERCH001", "parent_company_code": "CHAIN001",
    "transaction_id": "TXN_001", "amount": 100.00
  },
  {
    "tid": "POS002", "mid": "MERCH002", "parent_company_code": "CHAIN001", 
    "transaction_id": "TXN_002", "amount": 200.00
  },
  {
    "tid": "POS003", "mid": "MERCH001", "parent_company_code": "CHAIN002",
    "transaction_id": "TXN_003", "amount": 150.00
  }
]
```

**Pasos:**
1. Insertar transacciones de prueba
2. Consultar GSI1 por parent_company_code = "CHAIN001"
3. Consultar GSI1 por parent_company_code + mid específico
4. Medir tiempo de respuesta

**Resultado Esperado:**
- Consulta por CHAIN001 retorna TXN_001 y TXN_002
- Consulta por CHAIN001 + MERCH001 retorna solo TXN_001
- Tiempo de respuesta < 100ms
- GSI1 funcional y eficiente

---

## TC-165b-003: Compatibilidad con transacciones V1

**Objetivo:** Verificar que transacciones sin TID/MID no fallen

**Precondiciones:**
- Sistema configurado para manejar campos opcionales

**Datos de Prueba V1:**
```json
{
  "transaction_id": "TXN_V1_001",
  "amount": 75.25,
  "timestamp": "2024-01-15T11:00:00Z",
  "existing_field": "value"
}
```

**Pasos:**
1. Procesar transacción V1 sin nuevos campos
2. Verificar almacenamiento exitoso
3. Consultar registro creado
4. Verificar que campos faltantes sean NULL/vacío

**Resultado Esperado:**
- Transacción procesada sin errores
- tid, mid, parent_company_code = NULL o vacío
- Funcionalidad existente preservada
- No impacto en rendimiento

---

## TC-165b-004: Integración con datos B24/Datalake

**Objetivo:** Verificar uso de datos B24/Datalake cuando no se proporcionan TID/MID

**Precondiciones:**
- Conexión a B24/Datalake configurada
- Datos de prueba disponibles en B24

**Datos de Prueba:**
```json
{
  "transaction_id": "TXN_B24_001",
  "merchant_reference": "REF_B24_001",
  "version": "v1"
}
```

**Datos Esperados de B24:**
```json
{
  "tid": "B24_TERMINAL_001",
  "mid": "B24_MERCHANT_001",
  "parent_company_code": "B24_CHAIN_001"
}
```

**Pasos:**
1. Procesar transacción V1 sin TID/MID
2. Verificar consulta a B24/Datalake
3. Confirmar almacenamiento de datos B24
4. Validar trazabilidad completa

**Resultado Esperado:**
- Datos B24 consultados automáticamente
- TID/MID de B24 almacenados en campos correspondientes
- Trazabilidad mantenida
- Logs indican origen de datos (B24)

---

## TC-165b-005: Integridad de objetos de respuesta

**Objetivo:** Verificar que nuevos campos aparezcan en todos los objetos requeridos

**Precondiciones:**
- Transacción procesada completamente

**Datos de Prueba:**
```json
{
  "tid": "POS999",
  "mid": "MERCH999", 
  "parent_company_code": "CHAIN999",
  "transaction_id": "TXN_INTEGRITY_001"
}
```

**Pasos:**
1. Procesar transacción completa
2. Verificar validated_data contiene TID/MID/parent_company_code
3. Verificar sold_data contiene los campos
4. Verificar refund_data contiene los campos
5. Verificar response contiene los campos

**Resultado Esperado:**
- Todos los objetos (validated_data, sold_data, refund_data, response) contienen los nuevos campos
- Valores consistentes en todos los objetos
- Estructura JSON válida

---

## TC-165b-006: Rendimiento de escritura con nuevos campos

**Objetivo:** Verificar que nuevos campos no impacten significativamente el rendimiento

**Precondiciones:**
- Ambiente de prueba con métricas habilitadas
- Baseline de rendimiento establecido

**Datos de Prueba:**
- 100 transacciones con nuevos campos
- 100 transacciones sin nuevos campos (control)

**Pasos:**
1. Procesar lote de transacciones con nuevos campos
2. Procesar lote de transacciones sin nuevos campos
3. Comparar tiempos de procesamiento
4. Analizar métricas de DynamoDB (WCU usage)

**Resultado Esperado:**
- Diferencia de rendimiento < 10%
- WCU usage incrementa proporcionalmente
- Sin timeouts o errores de capacidad
- Latencia promedio aceptable

---

## TC-165b-007: Manejo de errores de DynamoDB

**Objetivo:** Verificar manejo robusto de errores de base de datos

**Precondiciones:**
- Capacidad de simular errores DynamoDB

**Escenarios de Error:**
1. **Capacidad excedida (ProvisionedThroughputExceededException)**
2. **Tabla no disponible (ResourceNotFoundException)**
3. **Datos inválidos (ValidationException)**

**Pasos:**
1. Simular cada tipo de error
2. Verificar manejo de excepciones
3. Confirmar logs de error apropiados
4. Verificar reintentos automáticos

**Resultado Esperado:**
- Errores manejados gracefully
- Logs detallados para debugging
- Reintentos automáticos cuando apropiado
- Respuestas de error informativas

---

## TC-165b-008: Consultas GSI1 con filtros

**Objetivo:** Verificar funcionalidad de consultas complejas usando GSI1

**Precondiciones:**
- GSI1 poblado con datos de prueba variados

**Datos de Prueba:**
```json
[
  {"parent_company_code": "CHAIN001", "mid": "MERCH001", "tid": "POS001", "amount": 100, "date": "2024-01-15"},
  {"parent_company_code": "CHAIN001", "mid": "MERCH001", "tid": "POS002", "amount": 200, "date": "2024-01-16"},
  {"parent_company_code": "CHAIN001", "mid": "MERCH002", "tid": "POS003", "amount": 150, "date": "2024-01-15"}
]
```

**Pasos:**
1. Consultar por parent_company_code = "CHAIN001"
2. Consultar por parent_company_code + mid específico
3. Aplicar filtros adicionales (fecha, monto)
4. Verificar resultados y rendimiento

**Resultado Esperado:**
- Consultas retornan datos correctos
- Filtros aplicados apropiadamente
- Rendimiento dentro de SLA (< 200ms)
- Paginación funcional si aplica

---

## TC-165b-009: Migración de datos existentes

**Objetivo:** Verificar que datos existentes no se corrompan con nuevos campos

**Precondiciones:**
- Datos existentes en DynamoDB antes de deployment

**Pasos:**
1. Identificar registros existentes pre-deployment
2. Ejecutar deployment con nuevos campos
3. Consultar registros existentes
4. Verificar integridad de datos originales

**Resultado Esperado:**
- Datos existentes intactos
- Nuevos campos NULL/vacío en registros antiguos
- Sin pérdida de información
- Consultas existentes funcionan normalmente

---

## TC-165b-010: Backup y recuperación

**Objetivo:** Verificar que nuevos campos se incluyan en backups

**Precondiciones:**
- Sistema de backup configurado

**Pasos:**
1. Crear transacciones con nuevos campos
2. Ejecutar backup de DynamoDB
3. Simular restauración
4. Verificar integridad de nuevos campos

**Resultado Esperado:**
- Backup incluye nuevos campos
- Restauración exitosa con datos completos
- Nuevos campos preservados correctamente

---

## Casos de Prueba de Carga

### TC-165b-LOAD-001: Carga sostenida
**Objetivo:** Verificar comportamiento bajo carga normal
- 1000 transacciones/minuto por 10 minutos
- Monitorear WCU/RCU usage
- Verificar sin degradación

### TC-165b-LOAD-002: Picos de tráfico
**Objetivo:** Verificar manejo de picos
- 5000 transacciones en 1 minuto
- Verificar auto-scaling
- Confirmar sin pérdida de datos

---

## Configuración de Ambiente

**DynamoDB Setup:**
```
Table: transactions
- PK: transaction_id
- Attributes: tid, mid, parent_company_code, ...
- GSI1: PK=parent_company_code, SK=mid
- Provisioned: 100 RCU, 100 WCU (ajustar según carga)
```

**Monitoreo:**
- CloudWatch métricas habilitadas
- Logs detallados para debugging
- Alertas configuradas para errores