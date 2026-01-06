# Casos de Prueba - Proyecto Validaciones API TID/MID

Este directorio contiene los casos de prueba detallados para todas las historias de usuario del proyecto de validaciones API, específicamente para la implementación de campos TID (Terminal ID), MID (Merchant ID) y parent_company_code.

## Estructura de Casos de Prueba

### Casos de Prueba por Historia de Usuario

1. **[TC-165a-validacion.md](./TC-165a-validacion.md)** - Validación de campos TID/MID
   - 10 casos de prueba funcionales
   - Casos de regresión para V1
   - Validaciones de formato, longitud y tipos

2. **[TC-165b-almacenamiento.md](./TC-165b-almacenamiento.md)** - Almacenamiento en DynamoDB
   - 10 casos de prueba de integración
   - Casos de carga y rendimiento
   - Pruebas de GSI1 y consultas

3. **[TC-165c-logging.md](./TC-165c-logging.md)** - Logging y auditoría
   - 10 casos de prueba de observabilidad
   - Compliance y regulaciones
   - Correlación de logs distribuidos

4. **[TC-165d-consultas.md](./TC-165d-consultas.md)** - Consultas por cadena
   - 10 casos de prueba de API
   - Pruebas de rendimiento y carga
   - Casos de seguridad

5. **[TC-165e-reportes.md](./TC-165e-reportes.md)** - Integración con reportes
   - 10 casos de prueba de BI/ETL
   - Integridad de pipeline
   - Compatibilidad con herramientas existentes

## Resumen de Cobertura

### Total de Casos de Prueba: 50+
- **Funcionales:** 25 casos
- **Integración:** 15 casos  
- **Rendimiento:** 8 casos
- **Seguridad:** 2 casos
- **Regresión:** 5+ casos

### Tipos de Prueba Cubiertos

#### ✅ Pruebas Funcionales
- Validación de entrada y formato
- Lógica de negocio
- Flujos de datos end-to-end
- Manejo de errores

#### ✅ Pruebas de Integración
- Integración entre componentes (Lambda Gateway ↔ Core)
- Integración con DynamoDB
- Integración con sistemas externos (B24/Datalake)
- Pipeline de datos completo

#### ✅ Pruebas de Rendimiento
- Carga sostenida
- Picos de tráfico
- Latencia de consultas
- Throughput de reportes

#### ✅ Pruebas de Seguridad
- Autorización de consultas
- Validación de entrada (inyección)
- Acceso controlado a datos

#### ✅ Pruebas de Compliance
- Auditoría completa
- Retención de logs
- Trazabilidad de transacciones
- Regulaciones federales

## Orden de Ejecución Recomendado

### Fase 1: Validación Básica
1. **TC-165a** - Validación de campos (crítico)
2. **TC-165b** - Almacenamiento básico

### Fase 2: Funcionalidad Completa  
3. **TC-165c** - Logging y auditoría
4. **TC-165d** - Consultas por cadena

### Fase 3: Integración Final
5. **TC-165e** - Reportes y BI

### Fase 4: Pruebas de Carga y Regresión
6. Casos de rendimiento de todas las historias
7. Suite completa de regresión

## Ambientes de Prueba

### Ambiente de Desarrollo
- **Propósito:** Pruebas unitarias y de integración básica
- **Datos:** Dataset pequeño y controlado
- **Configuración:** Logs en DEBUG, métricas detalladas

### Ambiente de Testing
- **Propósito:** Pruebas funcionales completas
- **Datos:** Dataset representativo
- **Configuración:** Configuración similar a producción

### Ambiente de Performance
- **Propósito:** Pruebas de carga y rendimiento
- **Datos:** Dataset grande (100K+ transacciones)
- **Configuración:** Métricas de rendimiento habilitadas

## Datos de Prueba

### Datasets Estándar
```json
// Dataset básico
{
  "transaction_id": "TXN_TEST_001",
  "tid": "POS_TEST_001", 
  "mid": "MERCH_TEST_001",
  "parent_company_code": "CHAIN_TEST_001",
  "amount": 100.00,
  "timestamp": "2024-01-15T10:30:00Z"
}

// Dataset histórico (sin nuevos campos)
{
  "transaction_id": "TXN_HIST_001",
  "amount": 100.00,
  "timestamp": "2024-01-01T10:30:00Z",
  "tid": null,
  "mid": null, 
  "parent_company_code": null
}
```

### Casos Límite
- **TID:** 1 carácter, 16 caracteres, 17 caracteres (inválido)
- **MID:** 1 carácter, 25 caracteres, 26 caracteres (inválido)
- **parent_company_code:** Varios formatos y longitudes
- **Caracteres especiales:** Guiones, underscores, símbolos

## Herramientas de Prueba

### Automatización
- **Postman/Newman:** Pruebas de API automatizadas
- **JMeter:** Pruebas de carga y rendimiento
- **Jest/Mocha:** Pruebas unitarias de Lambda
- **Selenium:** Pruebas de UI de reportes

### Monitoreo
- **CloudWatch:** Métricas y logs
- **X-Ray:** Trazabilidad distribuida
- **DynamoDB Insights:** Métricas de base de datos

### Validación de Datos
- **AWS Glue DataBrew:** Calidad de datos
- **Custom scripts:** Validación de integridad

## Criterios de Aceptación

### Criterios de Éxito
- ✅ 100% de casos funcionales pasan
- ✅ 95%+ de casos de rendimiento dentro de SLA
- ✅ 0 regresiones en funcionalidad existente
- ✅ Compliance verificado con regulaciones

### SLAs de Rendimiento
- **Validación:** < 200ms por transacción
- **Almacenamiento:** < 500ms por transacción
- **Consultas:** < 2 segundos para consultas complejas
- **Reportes:** Generación nocturna completada en < 4 horas

## Reportes de Prueba

### Métricas Clave
- **Cobertura de código:** > 80%
- **Cobertura funcional:** 100% de criterios de aceptación
- **Tasa de éxito:** > 95% en primera ejecución
- **Tiempo de ejecución:** Suite completa < 2 horas

### Documentación de Resultados
- Reporte ejecutivo de resultados
- Detalles de fallos y resoluciones
- Métricas de rendimiento
- Recomendaciones para producción

## Contacto y Soporte

**Equipo de QA:** qa-team@company.com  
**Product Owner:** po-atmp@company.com  
**DevOps:** devops-team@company.com

Para preguntas sobre casos de prueba específicos o ejecución de suites, contactar al equipo correspondiente.