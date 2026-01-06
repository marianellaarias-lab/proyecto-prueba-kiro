# Historias de Usuario - Proyecto Validaciones API

Este directorio contiene las historias de usuario para el proyecto de validaciones de API, específicamente para la captura y procesamiento de TID (Terminal ID) y MID (Merchant ID).

## Estructura de Historias

### Historia Principal
- **[HU-165-principal.md](./HU-165-principal.md)** - Historia principal de captura TID/MID para auditoría

### Historias Derivadas
1. **[HU-165a-validacion.md](./HU-165a-validacion.md)** - Validación de campos TID/MID
2. **[HU-165b-almacenamiento.md](./HU-165b-almacenamiento.md)** - Almacenamiento en DynamoDB
3. **[HU-165c-logging.md](./HU-165c-logging.md)** - Logging y auditoría
4. **[HU-165d-consultas.md](./HU-165d-consultas.md)** - Consultas por cadena
5. **[HU-165e-reportes.md](./HU-165e-reportes.md)** - Integración con reportes

## Orden de Implementación Sugerido

1. **Fase 1 - Fundación**
   - HU-165a (Validación) - Crítico para funcionalidad básica
   - HU-165b (Almacenamiento) - Base para todas las demás funcionalidades

2. **Fase 2 - Observabilidad**
   - HU-165c (Logging) - Importante para auditoría y debugging

3. **Fase 3 - Funcionalidades Avanzadas**
   - HU-165d (Consultas) - Habilita análisis por cadena
   - HU-165e (Reportes) - Completa la integración con BI

## Componentes Afectados

- **Lambda Gateway** (APIG-DEV-MCS-PRODUCT-VALID-Lmda)
- **Lambda Core** (product-validation DWHP)
- **DynamoDB** (Tablas de transacciones)
- **AWS Glue** (Pipeline de reportes)
- **Sistema de Logging** (CloudWatch/Kinesis)

## Criterios INVEST

Todas las historias han sido diseñadas siguiendo los criterios INVEST:
- **I**ndependientes: Cada historia puede desarrollarse por separado
- **N**egociables: Los detalles pueden ajustarse según necesidades
- **V**aliosas: Cada una aporta valor específico al negocio
- **E**stimables: Tienen estimaciones de esfuerzo claras
- **S**mall: Son lo suficientemente pequeñas para un sprint
- **T**esteable: Tienen criterios de aceptación verificables

## Notas de Compliance

Este proyecto debe cumplir con regulaciones federales que requieren:
- Trazabilidad completa de transacciones
- Auditoría de cambios
- Retención de logs por períodos específicos
- Acceso controlado a datos sensibles

## Contacto

Para preguntas sobre estas historias de usuario, contactar al Product Owner o Scrum Master del equipo ATMP.