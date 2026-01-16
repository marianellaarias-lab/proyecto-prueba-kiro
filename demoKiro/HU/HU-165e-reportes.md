# HU-165e - Integración con Reportes

## User Story
**Como** usuario del sistema de reportes  
**Quiero** que los campos TID, MID y parent_company_code estén disponibles en reportes transaccionales  
**Para** generar análisis detallados por terminal, merchant y cadena

## Información General
- **Historia Padre:** HU-165
- **Componente:** AWS Glue + Reportes Transaccionales
- **Prioridad:** Baja
- **Estimación:** 3 puntos

## Criterios de Aceptación

### Escenario: Campos disponibles en Glue Reports
**DADO** que se procesan transacciones con TID, MID, parent_company_code  
**CUANDO** se ejecutan los jobs de AWS Glue  
**ENTONCES** debo:
- Garantizar que los tres campos viajen al Glue report correspondiente
- Mantener integridad de datos en el pipeline
- Preservar relaciones entre campos

### Escenario: Reportes de validación
**DADO** que genero reportes de transacciones procesadas  
**CUANDO** incluyo los nuevos campos  
**ENTONCES** debo mostrar:
- TID asociado a cada transacción
- MID del merchant procesador
- parent_company_code para agrupación por cadena
- Métricas agregadas por estos campos

### Escenario: Reportes transaccionales históricos
**DADO** que consulto reportes históricos  
**CUANDO** los datos incluyen períodos antes y después de la implementación  
**ENTONCES** debo:
- Manejar correctamente registros sin TID/MID (períodos anteriores)
- Mostrar campos como NULL/vacío cuando no estén disponibles
- Mantener consistencia en agregaciones

### Escenario: Nuevas dimensiones de análisis
**DADO** que los campos están disponibles en reportes  
**CUANDO** los usuarios crean análisis personalizados  
**ENTONCES** deben poder:
- Agrupar transacciones por TID (análisis por terminal)
- Agrupar por MID (análisis por merchant)
- Agrupar por parent_company_code (análisis por cadena)
- Combinar dimensiones para análisis cruzados

## Definición de Terminado
- [ ] Pipeline de Glue actualizado para incluir TID, MID, parent_company_code
- [ ] Reportes transaccionales muestran nuevos campos
- [ ] Reportes de validación incluyen nuevas métricas
- [ ] Documentación de campos actualizada para usuarios finales
- [ ] Pruebas de integridad de datos en pipeline completo
- [ ] Capacitación a usuarios sobre nuevas dimensiones disponibles

## Especificaciones Técnicas

### Campos en Reportes
```
- transaction_id (existente)
- tid (nuevo) - Terminal ID
- mid (nuevo) - Merchant ID  
- parent_company_code (nuevo) - Código de cadena
- transaction_date (existente)
- amount (existente)
- status (existente)
```

### Nuevas Métricas Sugeridas
- Transacciones por terminal (TID)
- Volumen por merchant (MID)
- Distribución por cadena (parent_company_code)
- Análisis de concentración por terminal/merchant
- Patrones de uso por cadena

### Consideraciones de Datos Históricos
- Registros anteriores tendrán TID/MID = NULL
- Implementar lógica para manejar valores faltantes
- Considerar backfill si hay datos históricos disponibles en B24/Datalake
- Documentar limitaciones de datos históricos

## Reportes Afectados
1. **Reporte de Validaciones:** Incluir breakdown por TID/MID
2. **Reporte Transaccional:** Nuevas columnas y agrupaciones
3. **Reporte de Activity:** Métricas por terminal y cadena
4. **Reportes de Auditoría:** Trazabilidad completa con nuevos campos

## Dependencias
- HU-165b (almacenamiento) debe estar completada
- HU-165c (logging) debe estar completada
- Pipeline de datos debe estar estable
- Coordinación con equipo de BI/Analytics