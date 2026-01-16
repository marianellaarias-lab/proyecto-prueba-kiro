# Estructura de Historia de Usuario Completa - Modelo para Product Owner

## 📋 Contexto y Propósito

Este documento define la estructura óptima para presentar Historias de Usuario que permitan un análisis completo y eviten problemas comunes como:
- Refinamientos con poco contexto
- Estimaciones incorrectas por complejidad oculta
- Desarrollo "a ciegas" sin entender el sistema
- Casos de prueba incompletos

**Basado en**: Experiencias reales de refinamiento (HU-165, HU-921) y propuestas de mejora del área QA.

---

## 🏗️ Estructura Completa de HU

### **SECCIÓN 1: INFORMACIÓN BÁSICA**

```markdown
# HU-[NÚMERO] - [Título Descriptivo]

## Información General
- **ID**: HU-[NÚMERO]
- **Epic/Feature**: [Nombre del Epic al que pertenece]
- **Prioridad**: [Alta/Media/Baja]
- **Estimación Inicial**: [Story Points o Horas]
- **Sprint Objetivo**: [Sprint X]
- **Responsable PO**: [Nombre del Product Owner]
```

### **SECCIÓN 2: HISTORIA DE USUARIO ESTRUCTURADA**

```markdown
## Historia de Usuario
**Como** [tipo de usuario específico]  
**Quiero** [funcionalidad específica y clara]  
**Para** [beneficio de negocio concreto y medible]

```

### **SECCIÓN 3: CONTEXTO DEL SISTEMA** ⭐ *CRÍTICO*

```markdown
## Contexto del Sistema Actual

### Arquitectura Relevante
**Componentes Involucrados**: [Sistemas, módulos, servicios afectados]
**Integraciones Existentes**: [APIs, servicios externos, bases de datos]
**Flujos de Datos**: [Cómo se mueve la información actualmente]

### Impacto del Cambio
**Áreas de Código Afectadas**: [Frontend, Backend, Base de Datos]
**Sistemas Externos Impactados**: [Integraciones que cambiarán]
**Usuarios Afectados**: [Tipos de usuarios que verán cambios]
**Dependencias Técnicas**: [Qué otros sistemas/equipos se necesitan]
```

### **SECCIÓN 4: DEFINICIÓN FUNCIONAL DETALLADA**

```markdown
## Definición Funcional

### Campos y Conceptos Clave
[Definir todos los campos, entidades y conceptos nuevos o modificados]

### Flujos Principales
1. **Flujo Exitoso Principal**: [Paso a paso del caso ideal]
2. **Flujos Alternativos**: [Variaciones del flujo principal]
3. **Puntos de Decisión**: [Dónde el sistema debe tomar decisiones]

### Reglas de Negocio
**RN1**: [Regla específica y verificable]
**RN2**: [Regla específica y verificable]
**RN3**: [Regla específica y verificable]
[Continuar numerando todas las reglas]

### Validaciones y Restricciones
- **Campos Obligatorios**: [Lista específica]
- **Formatos Requeridos**: [Validaciones de formato]
- **Rangos Permitidos**: [Valores mínimos/máximos]
```

### **SECCIÓN 5: CRITERIOS DE ACEPTACIÓN EXPANDIDOS**

```markdown
## Criterios de Aceptación

### Funcionales
- [ ] **CA1**: [Criterio específico y testeable]
- [ ] **CA2**: [Criterio específico y testeable]
- [ ] **CA3**: [Criterio específico y testeable]

### No Funcionales
- [ ] **Performance**: [Tiempos de respuesta específicos]
- [ ] **Seguridad**: [Requisitos de seguridad]
- [ ] **Usabilidad**: [Criterios de experiencia de usuario]
- [ ] **Compatibilidad**: [Browsers, dispositivos soportados]

### Técnicos
- [ ] **Logging**: [Qué eventos deben loggearse]
- [ ] **Monitoreo**: [Métricas a trackear]
- [ ] **Documentación**: [Documentación técnica requerida]
- [ ] **Testing**: [Cobertura mínima de pruebas]
```

### **SECCIÓN 6: ESCENARIOS GHERKIN** ⭐ *CRÍTICO PARA QA* //hacer merge con sección 5

```markdown
## Escenarios de Prueba (Gherkin)

### Escenario 1: [Nombre del escenario principal]
```gherkin
Given [contexto inicial específico]
And [condición adicional]
When [acción del usuario]
Then [resultado esperado específico]
And [resultado adicional]
```

### Escenario 2: [Escenario alternativo]
```gherkin
Given [contexto diferente]
When [acción alternativa]
Then [resultado alternativo]
```

### Escenario 3: [Escenario de error]
```gherkin
Given [contexto de error]
When [acción que causa error]
Then [manejo de error esperado]
And [mensaje específico mostrado]
```

[Incluir todos los escenarios principales, alternativos y de error]
```

### **SECCIÓN 7: CASOS EDGE Y EXCEPCIONES**

```markdown
## Casos Edge y Manejo de Excepciones

### Casos Límite Identificados
1. **[Caso Edge 1]**: [Descripción y comportamiento esperado]
2. **[Caso Edge 2]**: [Descripción y comportamiento esperado]
3. **[Caso Edge 3]**: [Descripción y comportamiento esperado]

### Manejo de Errores
- **Error de Validación**: [Qué hacer cuando los datos son inválidos]
- **Error de Sistema**: [Qué hacer cuando hay fallas técnicas]
- **Error de Integración**: [Qué hacer cuando fallan servicios externos]
- **Timeout/Performance**: [Qué hacer cuando hay problemas de rendimiento]

### Estados Inconsistentes
- **Recuperación de Errores**: [Cómo el sistema se recupera]
- **Rollback**: [Cuándo y cómo hacer rollback]
- **Notificaciones**: [A quién notificar en caso de problemas]
```

### **SECCIÓN 8: RIESGOS Y DEPENDENCIAS** //esto para el desa

```markdown
## Riesgos y Dependencias

### Riesgos Técnicos Identificados
- **[Riesgo 1]**: [Descripción, probabilidad, impacto, mitigación]
- **[Riesgo 2]**: [Descripción, probabilidad, impacto, mitigación]

### Dependencias Externas
- **Equipos**: [Qué otros equipos necesitamos]
- **Sistemas**: [Qué sistemas externos deben estar disponibles]
- **Datos**: [Qué datos necesitamos que estén disponibles]
- **Infraestructura**: [Qué recursos de infraestructura se requieren]

### Supuestos y Restricciones
- **Supuestos**: [Qué estamos asumiendo que es verdad]
- **Restricciones Técnicas**: [Limitaciones técnicas conocidas]
- **Restricciones de Tiempo**: [Deadlines críticos]
- **Restricciones de Recursos**: [Limitaciones de personal/presupuesto]
```

---

## 🎯 Guía de Uso para Product Owner

### **ANTES de Escribir la HU:**

#### 1. **Sesión de Contexto del Sistema** (Recomendado) //Revisar
- Reunirse con Tech Lead para entender el sistema actual
- Identificar componentes afectados
- Evaluar complejidad técnica real
- Documentar dependencias y riesgos

#### 2. **Validación con Stakeholders**
- Confirmar el problema de negocio
- Validar el valor esperado
- Identificar todos los usuarios afectados
- Confirmar prioridad y urgencia

### **AL Escribir la HU:**

#### ✅ **Hacer:**
- Usar la estructura completa para HUs complejas
- Ser específico en criterios de aceptación
- Definir claramente las reglas de negocio

#### ❌ **Evitar:**
- Asumir que el equipo conoce el contexto
- Dejar criterios de aceptación ambiguos
- Omitir información sobre el sistema actual
- Mezclar múltiples funcionalidades en una HU

### **DESPUÉS de Escribir la HU:**

#### 1. **Revisión Interna**
- Validar completitud usando el checklist
- Confirmar que todos los campos están llenos
- Verificar que los criterios son testeables

#### 2. **Refinamiento Técnico**
- Presentar el contexto completo al equipo
- Explicar el impacto técnico esperado
- Aclarar dudas sobre el sistema actual
- Validar estimaciones con el contexto proporcionado
- Ajustar la HU según feedback técnico

---

## 📊 Plantilla Simplificada para HUs Simples

Para HUs claramente simples (cambios menores de UI, ajustes de texto, etc.), se puede usar una versión simplificada:

```markdown
# HU-[NÚMERO] - [Título]

## Historia de Usuario
**Como** [usuario]  
**Quiero** [funcionalidad]  
**Para** [beneficio]

## Contexto
**Cambio Requerido**: [Descripción específica del cambio]
**Impacto**: [Áreas afectadas]

## Criterios de Aceptación
- [ ] [Criterio 1]
- [ ] [Criterio 2]

## Escenarios de Prueba
### Escenario Principal
```gherkin
Given [contexto]
When [acción]
Then [resultado]
```

## Definition of Ready
- [ ] Mockups disponibles (si aplica)
- [ ] Criterios validados
- [ ] Impacto técnico evaluado
```

---

## 🚨 Señales de Alerta - Cuándo Usar la Estructura Completa

### **Usar SIEMPRE la estructura completa cuando:**
- La HU afecta múltiples sistemas o componentes
- Requiere cambios en base de datos
- Involucra integraciones con sistemas externos
- Tiene impacto en performance o seguridad
- El equipo técnico indica complejidad oculta
- Es una funcionalidad completamente nueva
- Afecta flujos críticos de negocio

### **Señales de que una HU necesita más análisis:**
- El Tech Lead dice "esto es más complejo de lo que parece"
- Hay feedback sobre hardcodeo o refactoring necesario
- La estimación inicial varía mucho entre desarrolladores
- QA identifica muchos casos edge no documentados
- Hay dependencias con otros equipos o sistemas

---

## 📈 Beneficios de Usar Esta Estructura

### **Para el Equipo de Desarrollo:**
- Contexto completo antes de estimar
- Menos sorpresas durante implementación
- Mejor calidad de código por entendimiento profundo
- Estimaciones más precisas

### **Para QA:**
- Casos de prueba más completos desde el inicio
- Mejor cobertura de testing
- Identificación temprana de casos edge
- Menos bugs en producción

### **Para Product Owner:**
- Estimaciones más confiables
- Menos cambios de alcance durante desarrollo
- Mejor comunicación con stakeholders
- Entregas más predecibles

### **Para el Proyecto:**
- Reducción de retrabajos
- Mejor calidad del producto final
- Mayor satisfacción del cliente
- ROI mejorado del desarrollo

---

## 🔄 Proceso de Mejora Continua

### **Después de cada HU completada:**
1. **Retrospectiva**: ¿Qué información faltó?
2. **Actualización**: Mejorar la plantilla según aprendizajes
3. **Capacitación**: Compartir lecciones aprendidas con el equipo
4. **Métricas**: Medir mejora en precisión de estimaciones

### **Métricas de Éxito:**
- **Precisión de Estimaciones**: Desviación real vs estimado
- **Cambios de Alcance**: Reducción en cambios durante sprint
- **Bugs en Producción**: Reducción por mejor análisis inicial
- **Satisfacción del Equipo**: Feedback sobre calidad de información