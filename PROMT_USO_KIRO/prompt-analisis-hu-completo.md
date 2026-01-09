# Prompt para Análisis Completo de Historia de Usuario

## Contexto de Uso
Utiliza este prompt cuando tengas una Historia de Usuario que requiera análisis técnico profundo, especialmente cuando sospechas que la HU inicial puede ser deficiente o no refleje la complejidad real del sistema.

---

## PROMPT COMPLETO

```
Necesito que hagas un análisis completo de refinamiento de Historia de Usuario siguiendo este proceso:

## CONTEXTO INICIAL:
Soy [ROL: ej. Product Owner/Scrum Master/Tech Lead] y tengo una HU que [SITUACIÓN: ej. parece simple pero sospecho que es más compleja / ha recibido feedback técnico / tiene información adicional del equipo].

## INFORMACIÓN DISPONIBLE:
1. **Historia de Usuario Original**: [PEGAR HU AQUÍ]

2. **Feedback Técnico** (si aplica):
   - Team Lead dice: "[PEGAR EXPLICACIÓN DEL TL]"
   - Desarrollador comenta: "[PEGAR COMENTARIOS DE DEV]"
   - Arquitecto menciona: "[PEGAR OBSERVACIONES DE ARQUITECTURA]"

3. **Diagramas/Documentación Adicional** (si aplica):
   [ADJUNTAR IMÁGENES O DESCRIBIR DIAGRAMAS]

4. **Contexto del Sistema**:
   - Tecnologías: [ej. React, Node.js, PostgreSQL]
   - Arquitectura actual: [ej. microservicios, monolito, etc.]
   - Problemas conocidos: [ej. hardcodeo, performance, etc.]

## PROCESO REQUERIDO:

### FASE 1: ANÁLISIS DE COMPLEJIDAD
1. **Evalúa si la HU original refleja la complejidad real**
2. **Identifica gaps entre lo descrito y lo requerido técnicamente**
3. **Analiza el impacto arquitectónico real**
4. **Detecta hardcodeo, deuda técnica o refactoring necesario**

### FASE 2: REFINAMIENTO EXPANDIDO
Genera una HU refinada que incluya:
- Historia estructurada (Como/Quiero/Para) que refleje la complejidad real
- Definición expandida de campos y conceptos
- **Reglas de Negocio** extraídas del análisis técnico (no solo de la HU original)
- **Escenarios Gherkin** que cubran la complejidad identificada
- **Preguntas críticas** para el PO basadas en gaps identificados

### FASE 3: CASOS DE PRUEBA COMPLETOS
Genera casos de prueba que cubran:
- **Casos técnicos**: Configuraciones, migraciones, refactoring
- **Casos de integración**: Impacto en otros sistemas/componentes
- **Casos de rendimiento**: Si hay cambios arquitectónicos
- **Casos de regresión**: Si hay refactoring de código existente
- **Casos edge**: Situaciones complejas identificadas en el análisis

### FASE 4: ANÁLISIS DE IMPACTO TÉCNICO
Documenta:
- **Áreas de código afectadas**
- **Cambios arquitectónicos necesarios**
- **Riesgos técnicos identificados**
- **Estimación de esfuerzo real vs percibido**
- **Recomendaciones de división de HU si es necesario**

### FASE 5: ENTREGABLES
Genera estos archivos:
1. `HU-[NÚMERO]-original.md` - HU sin modificaciones
2. `HU-[NÚMERO]-refinada-v2.md` - HU refinada post-análisis técnico
3. `TC-HU[NÚMERO]-[NOMBRE]-v2.feature` - Casos de prueba expandidos
4. `Analisis-Tecnico-[FUENTE].md` - Documento de análisis completo
5. `README.md` - Resumen ejecutivo con hallazgos y recomendaciones

## PRINCIPIOS A SEGUIR:
- **NO asumas nada** que no esté explícito en la información proporcionada
- **SÍ infiere** complejidad técnica basándote en el feedback del equipo
- **Prioriza completitud** sobre simplicidad si el análisis revela complejidad
- **Identifica proactivamente** riesgos y dependencias técnicas
- **Recomienda división** si la HU es demasiado compleja para un sprint

## FORMATO DE RESPUESTA:
1. Resumen ejecutivo de hallazgos
2. Comparación: complejidad percibida vs real
3. Archivos generados con explicación de cada uno
4. Recomendaciones críticas para el equipo
5. Próximos pasos sugeridos

¿Puedes proceder con este análisis?
```

---

## VARIANTES DEL PROMPT

### Para HU con Feedback Técnico Específico:
```
Tengo una HU que inicialmente parecía [DESCRIPCIÓN INICIAL] pero el equipo técnico ha identificado que en realidad requiere [COMPLEJIDAD REAL]. 

El Team Lead explica: "[FEEDBACK DEL TL]"
El diagrama de flujo muestra: [DESCRIPCIÓN O IMAGEN]

Necesito un refinamiento completo que refleje esta complejidad real y genere casos de prueba apropiados.
```

### Para HU con Sospecha de Complejidad Oculta:
```
Tengo esta HU que parece simple en superficie, pero sospecho que hay complejidad oculta porque [RAZONES: ej. afecta múltiples sistemas, requiere cambios arquitectónicos, etc.].

Por favor analiza la complejidad real y genera un refinamiento completo con casos de prueba que cubran todos los aspectos técnicos.
```

### Para HU que Requiere División:
```
Esta HU parece demasiado grande para un sprint. Necesito:
1. Análisis de complejidad real
2. Propuesta de división en múltiples HUs
3. Casos de prueba para cada HU dividida
4. Dependencias entre las HUs resultantes
```

---

## TIPS PARA MEJORES RESULTADOS

### Información a Proporcionar:
- **HU original completa** (no resumida)
- **Todo el feedback técnico** disponible (TL, devs, arquitectos)
- **Diagramas o documentación** adicional
- **Contexto del sistema** actual
- **Restricciones conocidas** (tiempo, recursos, tecnología)

### Qué Esperar:
- **Análisis honesto** de complejidad (puede ser mayor a lo esperado)
- **Refinamiento técnicamente sólido** 
- **Casos de prueba exhaustivos** (más de los usuales)
- **Recomendaciones prácticas** para el equipo
- **Identificación de riesgos** y dependencias

### Cuándo Usar Este Prompt:
- ✅ HU que parece simple pero afecta múltiples sistemas
- ✅ Feedback técnico indica mayor complejidad
- ✅ HU que requiere refactoring o migración
- ✅ Sospecha de que la estimación inicial es incorrecta
- ✅ HU con impacto arquitectónico significativo

### Cuándo NO Usar:
- ❌ HU claramente simple y bien definida
- ❌ Cambios menores de UI sin lógica compleja
- ❌ Bug fixes específicos y acotados
- ❌ Cuando no hay información técnica adicional disponible

---

## EJEMPLO DE USO

```
Necesito análisis completo de esta HU:

**HU Original**: Como usuario quiero ver un dashboard con métricas...

**Feedback del TL**: "Esto no es solo un dashboard, requiere cambiar toda la arquitectura de métricas porque actualmente están hardcodeadas..."

**Diagrama adjunto**: [imagen del flujo complejo]

**Contexto**: Sistema legacy con mucho hardcodeo, múltiples microservicios afectados.

Por favor procede con el análisis completo siguiendo el proceso definido.
```

---

## BENEFICIOS DE USAR ESTE PROMPT

1. **Evita subestimaciones** de esfuerzo
2. **Identifica complejidad oculta** tempranamente  
3. **Genera documentación completa** para el equipo
4. **Proporciona casos de prueba exhaustivos**
5. **Facilita toma de decisiones** sobre división de HUs
6. **Mejora la planificación** del sprint/release