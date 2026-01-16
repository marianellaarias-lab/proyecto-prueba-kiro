# Metodología de Análisis de Bugs

## 🔍 Proceso Completo de Análisis

### Fase 1: Detección y Captura Inicial
#### Información Básica Requerida:
- **ID del Bug**: Identificador único en Azure DevOps
- **Título Descriptivo**: Resumen claro del problema
- **Severidad**: Crítica/Alta/Media/Baja
- **Prioridad**: 1-4 (1 = más alta)
- **Área/Componente**: Módulo específico afectado
- **Ambiente**: Desarrollo/Testing/Staging/Producción

#### Captura de Evidencias:
- **Screenshots**: Pantallas que muestran el problema
- **Logs**: Registros de sistema relevantes
- **Datos de Prueba**: Información específica usada
- **Configuración**: Setup del ambiente de testing

### Fase 2: Reproducción y Análisis
#### Pasos de Reproducción:
1. **Pre-condiciones**: Estado inicial requerido
2. **Pasos Detallados**: Secuencia exacta de acciones
3. **Datos Específicos**: Valores exactos utilizados
4. **Resultado Actual**: Qué está ocurriendo
5. **Resultado Esperado**: Qué debería ocurrir

#### Análisis de Impacto:
- **Usuarios Afectados**: Quiénes experimentan el problema
- **Funcionalidad Impactada**: Qué características no funcionan
- **Workarounds**: Soluciones temporales disponibles
- **Frecuencia**: Qué tan seguido ocurre

### Fase 3: Categorización y Priorización
#### Criterios de Severidad:
- **Crítica**: Sistema no funciona, bloquea funcionalidad principal
- **Alta**: Funcionalidad importante no funciona, sin workaround
- **Media**: Funcionalidad menor afectada, workaround disponible
- **Baja**: Cosmético, no afecta funcionalidad

#### Criterios de Prioridad:
- **P1**: Resolver inmediatamente (< 24h)
- **P2**: Resolver en sprint actual (< 1 semana)
- **P3**: Resolver en próximo sprint (< 2 semanas)
- **P4**: Backlog, resolver cuando sea posible

## 🎯 Análisis Específico por Tipo de Bug

### Bugs de Datos (Como el Caso 1103)
#### Información Adicional Requerida:
- **Fuente de Datos**: De dónde vienen los datos inconsistentes
- **Momento de Inconsistencia**: Cuándo se genera la discrepancia
- **Alcance**: Cuántos registros están afectados
- **Patrón**: Si hay un patrón en los datos afectados

#### Análisis Técnico:
- **Base de Datos**: Estado actual de los datos
- **APIs Involucradas**: Servicios que manejan los datos
- **Transformaciones**: Procesos que modifican los datos
- **Sincronización**: Puntos donde los datos se sincronizan

### Bugs de UI/UX
#### Información Específica:
- **Browser/Dispositivo**: Dónde se reproduce
- **Resolución**: Tamaño de pantalla afectado
- **Interacción**: Secuencia específica de clicks/acciones
- **Estado de la Aplicación**: Contexto cuando ocurre

### Bugs de Integración
#### Análisis Requerido:
- **Sistemas Involucrados**: Qué servicios están conectados
- **Protocolo**: HTTP, WebSocket, etc.
- **Autenticación**: Tokens, permisos involucrados
- **Timeouts**: Si hay problemas de tiempo de respuesta

### Bugs de Performance
#### Métricas Necesarias:
- **Tiempo de Respuesta**: Actual vs esperado
- **Recursos**: CPU, memoria, red utilizados
- **Volumen de Datos**: Cantidad de información procesada
- **Concurrencia**: Número de usuarios simultáneos

## 📊 Template de Análisis Completo

### Información del Bug
```markdown
**ID**: BUG-[NÚMERO]
**Título**: [Descripción clara y específica]
**Reportado por**: [Nombre del QA/Usuario]
**Fecha**: [Fecha de detección]
**Ambiente**: [Dónde se encontró]

**Severidad**: [Crítica/Alta/Media/Baja]
**Prioridad**: [1-4]
**Área**: [Módulo/Componente]
**Tipo**: [Funcional/UI/Datos/Performance/Integración]
```

### Descripción del Problema
```markdown
**Resumen**: [Descripción concisa del problema]

**Impacto en el Usuario**: [Cómo afecta la experiencia]

**Funcionalidad Afectada**: [Qué características no funcionan]

**Frecuencia**: [Siempre/A veces/Rara vez]
```

### Reproducción
```markdown
**Pre-condiciones**:
- [Condición 1]
- [Condición 2]

**Pasos para Reproducir**:
1. [Paso 1]
2. [Paso 2]
3. [Paso N]

**Datos de Prueba**:
- [Dato específico 1]
- [Dato específico 2]

**Resultado Actual**: [Qué pasa]
**Resultado Esperado**: [Qué debería pasar]
```

### Análisis Técnico
```markdown
**Componentes Involucrados**:
- [Componente 1]
- [Componente 2]

**Posible Causa Raíz**: [Hipótesis inicial]

**Logs Relevantes**: [Extractos de logs]

**Consultas de BD**: [Si aplica, queries para verificar datos]
```

### Evidencias
```markdown
**Screenshots**: [Links a imágenes]
**Videos**: [Si aplica, grabaciones]
**Logs**: [Archivos de log adjuntos]
**Datos de Ejemplo**: [Datasets que reproducen el problema]
```

## 🔄 Flujo de Análisis

### Flujo Estándar:
```
1. Detección → 2. Captura Inicial → 3. Reproducción → 4. Análisis → 5. Categorización → 6. Asignación
```

### Flujo para Bugs Complejos:
```
1. Detección → 2. Análisis Preliminar → 3. Investigación Profunda → 4. Reproducción Controlada → 5. Análisis de Impacto → 6. Priorización → 7. Asignación Especializada
```

## 📈 Métricas de Calidad del Análisis

### Indicadores de Buen Análisis:
- **Reproducibilidad**: 100% de los pasos funcionan
- **Completitud**: Toda la información necesaria está presente
- **Claridad**: Cualquier desarrollador puede entender el problema
- **Precisión**: La causa raíz identificada es correcta

### KPIs de Proceso:
- **Tiempo de Análisis**: Tiempo promedio para analizar un bug
- **Tasa de Resolución**: % de bugs resueltos en primer intento
- **Calidad de Información**: Score de completitud de reportes
- **Satisfacción de Desarrollo**: Feedback sobre calidad de reportes

## 🛠️ Herramientas de Apoyo

### Para Captura de Evidencias:
- **Screenshots**: Snagit, Lightshot, herramientas nativas
- **Videos**: OBS, Loom para grabaciones de pantalla
- **Logs**: Herramientas de log aggregation (ELK, Splunk)
- **Network**: Fiddler, Chrome DevTools para tráfico de red

### Para Análisis de Datos:
- **Base de Datos**: SQL Server Management Studio, pgAdmin
- **APIs**: Postman, Insomnia para testing de endpoints
- **Performance**: Chrome DevTools, New Relic
- **Monitoreo**: Application Insights, Datadog

## 🎯 Casos Especiales

### Bugs Intermitentes:
- **Patrón de Ocurrencia**: Cuándo y bajo qué condiciones
- **Logs Extendidos**: Captura durante períodos largos
- **Monitoreo**: Métricas continuas para identificar triggers
- **Reproducción**: Múltiples intentos con variaciones

### Bugs de Datos Masivos:
- **Muestra Representativa**: Subset de datos para análisis
- **Scripts de Validación**: Queries para verificar integridad
- **Impacto Cuantificado**: Número exacto de registros afectados
- **Plan de Corrección**: Estrategia para fix masivo

### Bugs de Seguridad:
- **Confidencialidad**: Manejo seguro de información sensible
- **Escalación**: Proceso acelerado de reporte
- **Documentación Restringida**: Acceso limitado a detalles
- **Validación**: Testing especializado post-fix