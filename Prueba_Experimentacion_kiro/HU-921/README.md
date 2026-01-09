# HU-921 - Sistema de Selección de Cliente y Contexto Global

## Descripción
Esta historia de usuario implementa un sistema complejo de selección de clientes que permite a los Solution Owner cambiar dinámicamente el contexto de toda la aplicación, eliminando hardcodeo y habilitando comportamientos específicos por cliente/programa.

## ⚠️ IMPORTANTE: Complejidad Identificada
Tras análisis técnico del TL y diagrama de flujo, se identificó que la HU original era **deficiente** y no reflejaba la **complejidad real** del sistema requerido.

## Archivos Incluidos

### 📄 HU-921-original.md
Historia de usuario tal como fue proporcionada originalmente, sin modificaciones.

### 📄 HU-921-refinada.md *(OBSOLETO)*
Primer refinamiento basado solo en la HU original (antes del análisis técnico).

### 📄 HU-921-refinada-v2.md *(ACTUAL)*
**Refinamiento actualizado** post-análisis técnico que incluye:
- Estructura expandida (Como/Quiero/Para)
- **7 Reglas de Negocio** extraídas del análisis técnico
- **10 Escenarios Gherkin** que reflejan la complejidad real
- **12 Preguntas críticas** para el Product Owner
- Análisis del diagrama de flujo
- Recomendación de división en múltiples HUs

### 📄 TC-HU921-Tenant-Management.feature *(OBSOLETO)*
Casos de prueba del primer refinamiento (antes del análisis técnico).

### 📄 TC-HU921-Tenant-Management-v2.feature *(ACTUAL)*
**Casos de prueba actualizados** que cubren la complejidad real:

#### Cobertura de Pruebas v2:
- **Acceso y Listado** (3 escenarios)
  - Visualización inicial de todos los clientes
  - Control de acceso por rol
  - Registro dinámico de nuevos clientes

- **Selección y Contexto Global** (3 escenarios)
  - Selección inicial y carga de contexto
  - Cambio entre clientes con diferentes configuraciones
  - Manejo de clientes sin programas

- **Programas Dinámicos** (3 escenarios)
  - Carga de programas específicos por cliente
  - Diferencias entre clientes
  - Validación de configuraciones no hardcodeadas

- **Comportamientos Específicos** (3 escenarios)
  - Te Paga con categorías habilitadas
  - OTC sin categorías
  - Consistencia entre clientes para mismo programa

- **Persistencia y Sesión** (3 escenarios)
  - Persistencia durante navegación
  - Persistencia durante sesión completa
  - Limpieza al cerrar sesión

- **Validación y Errores** (3 escenarios)
  - Cliente eliminado durante sesión
  - Programas modificados durante sesión
  - Validación de permisos por cliente

- **Rendimiento** (2 escenarios)
  - Múltiples clientes (50+)
  - Carga eficiente de contexto

- **Integración** (2 escenarios)
  - Consistencia entre secciones
  - Actualización automática de configuraciones

- **Filtrado y Búsqueda** (2 escenarios)
  - Búsqueda en lista extensa
  - Filtrado por tipo de programa

### 📄 Analisis-Tecnico-TL.md *(NUEVO)*
**Documento crítico** que contiene:
- Explicación completa del Team Lead
- Análisis del diagrama de flujo proporcionado
- Identificación de la problemática del hardcodeo
- Impacto técnico real (refactoring arquitectónico)
- Riesgos y recomendaciones
- Justificación para división de la HU

## Hallazgos Críticos del Análisis

### Complejidad Real Identificada:
1. **No es solo un dashboard**: Es una transformación arquitectónica completa
2. **Hardcodeo masivo**: Programas hardcodeados en todo el código base
3. **Contexto global**: Toda la aplicación debe adaptarse al cliente seleccionado
4. **Comportamientos dinámicos**: Te Paga con categorías, OTC sin categorías
5. **Configuración por cliente**: Cada cliente tiene programas y configuraciones únicas

### Problemática del Hardcodeo Actual:
```javascript
// ACTUAL (PROBLEMÁTICO):
if (programa === "Te Paga") { mostrarCategorias = true; }

// REQUERIDO (DINÁMICO):
if (clienteConfig.programas["Te Paga"].categorias) { mostrarCategorias = true; }
```

## Reglas de Negocio Actualizadas

1. **RN1 - Control de Acceso Global**: Solo Solution Owner puede seleccionar clientes
2. **RN2 - Listado Completo**: Mostrar TODOS los clientes (MCS, DEMO, nuevos)
3. **RN3 - Contexto Global**: Selección afecta TODA la aplicación
4. **RN4 - Programas Dinámicos**: Eliminar hardcodeo, configuración por cliente
5. **RN5 - Comportamientos Específicos**: Te Paga con categorías, OTC sin categorías
6. **RN6 - Persistencia de Selección**: Mantener durante toda la sesión
7. **RN7 - Configuración No Hardcodeada**: Todo debe ser dinámico y configurable

## Impacto Técnico Real

### Áreas Afectadas:
- **Frontend**: Todas las secciones/componentes
- **Backend**: APIs de configuración, validaciones
- **Base de Datos**: Nuevas tablas de configuración cliente/programa
- **Arquitectura**: Estado global, contexto compartido

### Estimación Revisada:
- **Original**: 2-3 sprints (basado en HU inicial)
- **Real**: 6-8 sprints (basado en análisis técnico)
- **Recomendado**: División en 4 HUs de 2 sprints cada una

## Recomendación de División

### HU-921A: Selector de Cliente y Contexto Global
- Implementar lista y selección de clientes
- Estado global de cliente activo
- Persistencia de selección

### HU-921B: Programas Dinámicos por Cliente
- Configuración de programas por cliente
- Eliminación de hardcodeo de programas
- API de configuraciones dinámicas

### HU-921C: Comportamientos Específicos por Programa
- Te Paga con categorías vs OTC sin categorías
- Validaciones dinámicas por programa
- Lógica condicional adaptativa

### HU-921D: Migración de Hardcodeo (Técnica)
- Refactoring de código existente
- Migración de configuraciones a BD
- Testing de configuraciones dinámicas

## Preguntas Críticas Identificadas

### Para Product Owner:
1. **Priorización**: ¿Selector de clientes o eliminación de hardcodeo primero?
2. **UX/UI**: ¿Cuándo estarán los mockups del selector?
3. **Alcance**: ¿Incluir migración completa del hardcodeo?
4. **Configuración**: ¿Cómo se configuran nuevos clientes?

### Para Desarrollo:
1. **Arquitectura**: ¿Patrón para estado global? (Redux, Context)
2. **Performance**: ¿Estrategia de carga de configuraciones?
3. **Migración**: ¿Gradual o big bang?
4. **Testing**: ¿Cómo testear configuraciones dinámicas?

## Casos de Prueba Destacados v2

### Casos Críticos Nuevos:
1. **Contexto Global**: Cambio de cliente afecta toda la app
2. **Configuraciones Dinámicas**: Sin hardcodeo, todo desde BD
3. **Comportamientos por Programa**: Te Paga ≠ OTC ≠ Flexi
4. **Persistencia de Sesión**: Mantener selección durante navegación

### Casos Edge Identificados:
1. **Cliente sin programas**: Manejo de configuración vacía
2. **Cliente eliminado**: Durante sesión activa
3. **Programas modificados**: Cambios externos durante uso
4. **Configuraciones inconsistentes**: Validación de integridad

## Métricas de Cobertura v2

- **Total de escenarios**: 24 (vs 21 original)
- **Escenarios de contexto global**: 6 (nuevos)
- **Escenarios de configuración dinámica**: 4 (nuevos)
- **Escenarios de comportamientos específicos**: 3 (expandidos)
- **Cobertura de clientes**: 4 tipos diferentes
- **Cobertura de programas**: 3 programas con comportamientos únicos

## Conclusión

La HU-921 **NO es una simple vista de dashboard**. Es una **transformación arquitectónica** que requiere:
- Refactoring masivo del código existente
- Implementación de contexto global
- Sistema de configuraciones dinámicas
- Eliminación completa del hardcodeo

**Recomendación**: Dividir en múltiples HUs y definir UX/UI antes de comenzar desarrollo.