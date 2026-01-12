# Estructura para Azure DevOps - Gestión de Bugs

## 🏗️ Configuración de Work Items

### Campos Estándar de Bug en Azure DevOps

#### **Campos Básicos**:
```
Title: [Título descriptivo del bug]
State: New → Active → Resolved → Closed
Reason: New/Approved/Fixed/Duplicate/Won't Fix/etc.
Assigned To: [Desarrollador responsable]
Area Path: [Área del producto]
Iteration Path: [Sprint/Iteración]
```

#### **Campos de Clasificación**:
```
Priority: 1 (Highest) → 4 (Lowest)
Severity: 1-Critical → 4-Low
Bug Type: Code Defect/Design Issue/Documentation/etc.
Found In Build: [Versión donde se encontró]
Integrated In Build: [Versión donde se resolvió]
```

#### **Campos Personalizados Recomendados**:
```
Environment: Development/Testing/Staging/Production
Browser: Chrome/Firefox/Safari/Edge/Mobile
Device Type: Desktop/Tablet/Mobile
Test Case ID: [ID del caso de prueba relacionado]
Customer Impact: High/Medium/Low/None
Workaround Available: Yes/No
```

## 📋 Template Completo para Azure DevOps

### **Título del Bug**:
```
[COMPONENTE] - [Descripción específica del problema]

Ejemplos:
- CATEGORÍAS - Inconsistencia entre lista y detalle en MCC
- LOGIN - Error 500 al autenticar con usuario específico
- REPORTES - Timeout al generar reporte con más de 1000 registros
```

### **Descripción (Description)**:
```markdown
## Resumen
[Descripción concisa del problema en 1-2 líneas]

## Impacto en el Usuario
[Cómo afecta la experiencia del usuario final]

## Funcionalidad Afectada
[Qué características específicas no funcionan correctamente]

## Ambiente y Configuración
- **Ambiente**: [Development/Testing/Staging/Production]
- **Browser**: [Chrome 120.0, Firefox 119.0, etc.]
- **Dispositivo**: [Desktop 1920x1080, Mobile iPhone 14, etc.]
- **Usuario de Prueba**: [ID del usuario utilizado]
- **Fecha/Hora**: [Cuándo se detectó]

## Datos de Contexto
[Información específica del contexto donde ocurre el bug]
```

### **Pasos para Reproducir (Repro Steps)**:
```markdown
## Pre-condiciones
- [Condición 1: Estado inicial requerido]
- [Condición 2: Datos específicos necesarios]
- [Condición 3: Configuración del ambiente]

## Pasos Detallados
1. **Navegar a**: [URL específica o pantalla]
2. **Ingresar datos**: [Valores exactos utilizados]
3. **Hacer clic en**: [Botón/elemento específico]
4. **Observar**: [Qué verificar en cada paso]
5. **Resultado**: [Qué ocurre al final]

## Datos de Prueba Específicos
- **ID de Registro**: [Valor específico]
- **Categoría**: [Valor utilizado]
- **Fechas**: [Rangos específicos]
- **Filtros**: [Configuración exacta]
```

### **Resultado Actual vs Esperado**:
```markdown
## Resultado Actual
[Descripción detallada de qué está ocurriendo]

## Resultado Esperado
[Descripción detallada de qué debería ocurrir]

## Diferencia Específica
[Exactamente qué está mal y cómo debería ser]
```

### **Evidencias (Attachments)**:
```markdown
## Screenshots
- [Adjuntar capturas de pantalla numeradas]
- Screenshot_01_Lista_Categorias.png
- Screenshot_02_Detalle_Categoria.png
- Screenshot_03_Inconsistencia_Resaltada.png

## Logs
- [Adjuntar logs relevantes]
- Browser_Console_Log.txt
- Server_Error_Log.txt
- Network_Traffic_Log.har

## Videos (si aplica)
- [Grabación de la reproducción del bug]
- Bug_Reproduction_Video.mp4

## Datos de Ejemplo
- [Datasets o queries que muestran el problema]
- Inconsistent_Data_Query.sql
- Sample_Data_Export.csv
```

## 🔧 Configuración de Estados y Workflow

### **Estados Recomendados**:
```
New → Active → Resolved → Closed
     ↓         ↓         ↓
   Rejected  Reopened  Verified
```

### **Transiciones y Responsabilidades**:

#### **New → Active**:
- **Quién**: QA Lead o Scrum Master
- **Cuándo**: Después de validar que el bug es legítimo
- **Criterios**: Bug reproducible y bien documentado

#### **Active → Resolved**:
- **Quién**: Desarrollador asignado
- **Cuándo**: Después de implementar el fix
- **Criterios**: Código corregido y desplegado en ambiente de testing

#### **Resolved → Closed**:
- **Quién**: QA que reportó el bug
- **Cuándo**: Después de verificar que el fix funciona
- **Criterios**: Retesting completado exitosamente

#### **Resolved → Reopened**:
- **Quién**: QA durante retesting
- **Cuándo**: Si el bug persiste o aparecen nuevos problemas
- **Criterios**: Evidencia de que el fix no resolvió el problema

## 📊 Queries y Reportes Útiles

### **Query 1: Bugs por Severidad y Estado**:
```sql
SELECT 
    [System.Title],
    [Microsoft.VSTS.Common.Severity],
    [System.State],
    [System.AssignedTo],
    [System.CreatedDate]
FROM WorkItems 
WHERE [System.WorkItemType] = 'Bug'
    AND [System.State] <> 'Closed'
ORDER BY [Microsoft.VSTS.Common.Severity], [System.CreatedDate]
```

### **Query 2: Bugs por Componente**:
```sql
SELECT 
    [System.AreaPath],
    COUNT(*) as BugCount,
    [System.State]
FROM WorkItems 
WHERE [System.WorkItemType] = 'Bug'
    AND [System.CreatedDate] >= @StartDate
GROUP BY [System.AreaPath], [System.State]
ORDER BY BugCount DESC
```

### **Query 3: Tiempo de Resolución**:
```sql
SELECT 
    [System.Id],
    [System.Title],
    [System.CreatedDate],
    [Microsoft.VSTS.Common.ResolvedDate],
    DATEDIFF(day, [System.CreatedDate], [Microsoft.VSTS.Common.ResolvedDate]) as DaysToResolve
FROM WorkItems 
WHERE [System.WorkItemType] = 'Bug'
    AND [System.State] = 'Resolved'
ORDER BY DaysToResolve DESC
```

## 🏷️ Sistema de Etiquetas (Tags)

### **Etiquetas por Tipo**:
- `data-issue` - Problemas de datos
- `ui-bug` - Problemas de interfaz
- `performance` - Problemas de rendimiento
- `integration` - Problemas de integración
- `security` - Problemas de seguridad

### **Etiquetas por Impacto**:
- `customer-facing` - Visible para clientes
- `internal-only` - Solo afecta usuarios internos
- `regression` - Funcionalidad que antes funcionaba
- `enhancement` - Mejora más que bug

### **Etiquetas por Urgencia**:
- `hotfix-required` - Necesita fix inmediato
- `production-blocker` - Bloquea despliegue a producción
- `sprint-blocker` - Bloquea otros trabajos del sprint

## 📈 Dashboard y Métricas

### **Widgets Recomendados para Dashboard**:

#### **1. Bug Trend Chart**:
- Muestra tendencia de bugs creados vs resueltos
- Período: Últimos 3 meses
- Agrupado por semana

#### **2. Bug Distribution by Severity**:
- Gráfico de pie mostrando distribución por severidad
- Solo bugs activos (New, Active, Resolved)

#### **3. Bug Age Chart**:
- Tiempo que llevan abiertos los bugs
- Agrupado por severidad
- Alerta para bugs > 30 días

#### **4. Resolution Rate**:
- Porcentaje de bugs resueltos vs total
- Comparación mes actual vs anterior

### **KPIs Clave**:
```
- Bug Discovery Rate: Bugs encontrados por sprint
- Bug Resolution Rate: Bugs resueltos por sprint  
- Average Resolution Time: Tiempo promedio de resolución
- Reopened Bug Rate: % de bugs que se reabren
- Escaped Defects: Bugs encontrados en producción
- Bug Density: Bugs por feature/componente
```

## 🔗 Integración con Herramientas

### **Integración con Testing Tools**:
- **Test Plans**: Vincular bugs con casos de prueba
- **Automated Tests**: Referenciar tests que fallan
- **Test Results**: Adjuntar resultados de ejecución

### **Integración con Development**:
- **Pull Requests**: Vincular PRs que resuelven bugs
- **Commits**: Referenciar commits específicos
- **Build Results**: Mostrar en qué build se resolvió

### **Integración con Monitoring**:
- **Application Insights**: Links a logs y métricas
- **Error Tracking**: Conexión con Sentry, Bugsnag
- **Performance Monitoring**: Links a New Relic, Datadog

## 🎯 Best Practices para Azure DevOps

### **Nomenclatura Consistente**:
- Usar prefijos estándar en títulos
- Mantener convenciones de naming
- Usar etiquetas de forma consistente

### **Documentación Rica**:
- Usar markdown para formateo
- Incluir links a documentación relacionada
- Mantener historial de cambios

### **Trazabilidad Completa**:
- Vincular con requirements originales
- Conectar con casos de prueba
- Referenciar documentación técnica

### **Automatización**:
- Reglas automáticas para asignación
- Notificaciones configuradas
- Templates predefinidos para tipos comunes

## 📋 Checklist de Calidad para Bugs

### **Antes de Crear el Bug**:
- [ ] Bug es reproducible consistentemente
- [ ] Información de ambiente está completa
- [ ] Screenshots/evidencias están adjuntas
- [ ] Pasos de reproducción son claros
- [ ] Severidad y prioridad están correctas

### **Antes de Asignar**:
- [ ] Área y componente están identificados
- [ ] Desarrollador apropiado está asignado
- [ ] Estimación de esfuerzo está incluida
- [ ] Dependencias están identificadas

### **Antes de Resolver**:
- [ ] Fix está implementado y probado
- [ ] Código está revisado
- [ ] Documentación está actualizada
- [ ] Plan de retesting está definido

### **Antes de Cerrar**:
- [ ] Retesting completado exitosamente
- [ ] No hay regresiones introducidas
- [ ] Documentación de usuario actualizada
- [ ] Lecciones aprendidas documentadas