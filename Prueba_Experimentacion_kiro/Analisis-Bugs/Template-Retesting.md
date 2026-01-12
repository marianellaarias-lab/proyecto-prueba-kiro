# Template - Escenarios de Retesting

## 📋 Información del Retesting

**Bug ID**: BUG-[NÚMERO]  
**Título**: [Título del bug original]  
**Fecha de Retesting**: [YYYY-MM-DD]  
**QA Responsable**: [Nombre del tester]  
**Build Probado**: [Versión con el fix]  
**Ambiente**: [Ambiente donde se ejecuta el retesting]  

## 📝 Resumen del Fix

**Desarrollador**: [Nombre del desarrollador que implementó el fix]  
**Descripción del Fix**: [Qué se cambió para resolver el bug]  
**Componentes Modificados**: [Archivos, APIs, queries, etc. que se modificaron]  
**Fecha de Implementación**: [Cuándo se implementó el fix]  
**Pull Request**: [Link al PR si está disponible]  

## 🎯 Escenario 1: Verificación del Caso Original

### Objetivo
Verificar que el bug original ya no ocurre siguiendo exactamente los mismos pasos del reporte inicial.

### Pre-condiciones
- [Mismas pre-condiciones del reporte original]
- Build [versión] desplegado en [ambiente]
- Datos de prueba preparados: [especificar datos exactos]
- [Otras condiciones específicas]

### Pasos de Ejecución
1. [Paso 1 - exactamente como en el reporte original]
2. [Paso 2 - exactamente como en el reporte original]
3. [Paso 3 - exactamente como en el reporte original]
4. [Continuar con todos los pasos originales]

### Resultado Esperado
[El comportamiento correcto que debería ocurrir ahora que el bug está resuelto]

### Resultado Actual
[Documentar qué ocurrió realmente durante la ejecución]

### Estado
- [ ] ✅ PASS - El bug está completamente resuelto
- [ ] ❌ FAIL - El bug persiste
- [ ] ⚠️ PARTIAL - Parcialmente resuelto, hay mejoras pero persisten issues

### Evidencias
- [ ] Screenshot_Retesting_01.png
- [ ] Screenshot_Retesting_02.png
- [ ] Video_Retesting.mp4 (si es necesario)
- [ ] Logs_Retesting.txt (si son relevantes)

### Notas
[Cualquier observación adicional durante la ejecución]

---

## 🔄 Escenario 2: Variaciones del Caso Original

### Objetivo
Verificar que el fix funciona en diferentes variaciones del escenario original.

### Variación 2.1: [Descripción de la primera variación]
**Diferencia**: [Qué cambia respecto al caso original]
**Justificación**: [Por qué es importante probar esta variación]

**Pasos**:
1. [Pasos modificados según la variación]
2. [...]

**Resultado Esperado**: [Qué debería ocurrir]
**Resultado Actual**: [Qué ocurrió]
**Estado**: [PASS/FAIL/PARTIAL]

### Variación 2.2: [Descripción de la segunda variación]
**Diferencia**: [Qué cambia]
**Justificación**: [Por qué es importante]

**Pasos**: [...]
**Resultado Esperado**: [...]
**Resultado Actual**: [...]
**Estado**: [PASS/FAIL/PARTIAL]

### Variación 2.3: Casos Edge
**Escenario**: [Caso límite relacionado con el bug]
**Justificación**: [Por qué es importante probar este edge case]

**Pasos**: [...]
**Resultado Esperado**: [...]
**Resultado Actual**: [...]
**Estado**: [PASS/FAIL/PARTIAL]

---

## 🧪 Escenario 3: Testing de Regresión

### Objetivo
Confirmar que el fix no introdujo nuevos problemas en funcionalidades relacionadas.

### Área 3.1: [Funcionalidad Relacionada 1]
**Descripción**: [Qué funcionalidad se está probando]
**Relación con el Fix**: [Por qué podría verse afectada por el fix]

**Casos de Prueba**:
- **Caso 1**: [Descripción] → [Resultado]
- **Caso 2**: [Descripción] → [Resultado]
- **Caso 3**: [Descripción] → [Resultado]

**Estado General**: [PASS/FAIL/PARTIAL]

### Área 3.2: [Funcionalidad Relacionada 2]
**Descripción**: [...]
**Relación con el Fix**: [...]

**Casos de Prueba**: [...]
**Estado General**: [PASS/FAIL/PARTIAL]

### Área 3.3: Performance y Usabilidad
**Tiempo de Respuesta**: 
- Antes del fix: [tiempo]
- Después del fix: [tiempo]
- Cambio: [mejora/degradación/sin cambio]

**Usabilidad**: [Cambios en la experiencia de usuario]
**Estabilidad**: [Resultado de múltiples ejecuciones]

---

## 🔍 Escenario 4: Verificación Técnica (Opcional)

### Objetivo
Verificar aspectos técnicos específicos del fix cuando sea relevante.

### Verificación 4.1: Base de Datos (si aplica)
**Query de Verificación**:
```sql
-- Query para verificar que los datos están correctos
SELECT [campos] FROM [tabla] WHERE [condición]
```

**Resultado Esperado**: [Qué datos deberían aparecer]
**Resultado Actual**: [Qué datos aparecieron]
**Estado**: [PASS/FAIL]

### Verificación 4.2: APIs (si aplica)
**Endpoint Probado**: [URL del API]
**Request**: [Datos enviados]
**Response Esperada**: [Respuesta correcta]
**Response Actual**: [Respuesta recibida]
**Estado**: [PASS/FAIL]

### Verificación 4.3: Logs (si aplica)
**Logs Revisados**: [Qué logs se verificaron]
**Errores Esperados**: [Ninguno/Específicos]
**Errores Encontrados**: [Qué se encontró]
**Estado**: [PASS/FAIL]

---

## 📊 Escenario 5: Testing de Estabilidad

### Objetivo
Verificar que el fix es estable y consistente en múltiples ejecuciones.

### Prueba de Repetición
**Número de Ejecuciones**: [Ej: 5 veces]
**Resultados**:
- Ejecución 1: [PASS/FAIL]
- Ejecución 2: [PASS/FAIL]
- Ejecución 3: [PASS/FAIL]
- Ejecución 4: [PASS/FAIL]
- Ejecución 5: [PASS/FAIL]

**Consistencia**: [100% consistente / Intermitente / Inconsistente]

### Prueba de Carga (si es relevante)
**Condiciones**: [Múltiples usuarios, gran volumen de datos, etc.]
**Resultado**: [Cómo se comporta bajo carga]
**Estado**: [PASS/FAIL/PARTIAL]

---

## 📋 Criterios de Aceptación del Retesting

### Criterios de PASS ✅
- [ ] El caso original no se reproduce
- [ ] Todas las variaciones funcionan correctamente
- [ ] No hay regresiones en funcionalidades relacionadas
- [ ] Performance se mantiene o mejora
- [ ] El fix es estable en múltiples ejecuciones
- [ ] Verificaciones técnicas son exitosas (si aplican)

### Criterios de FAIL ❌
- [ ] El bug original persiste
- [ ] Aparecen nuevos bugs relacionados
- [ ] Hay regresiones significativas
- [ ] Performance se degrada inaceptablemente
- [ ] El fix es intermitente o inestable

### Criterios de PARTIAL ⚠️
- [ ] El bug principal está resuelto pero hay issues menores
- [ ] Funciona en algunos escenarios pero no en todos
- [ ] Hay mejoras pero no es una solución completa
- [ ] Requiere ajustes adicionales

---

## 📈 Resumen de Resultados

### Tabla de Resultados por Escenario

| Escenario | Descripción | Estado | Comentarios |
|-----------|-------------|--------|-------------|
| 1 | Caso Original | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 2.1 | Variación 1 | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 2.2 | Variación 2 | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 2.3 | Casos Edge | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 3.1 | Regresión Área 1 | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 3.2 | Regresión Área 2 | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 4 | Verificación Técnica | [PASS/FAIL/PARTIAL] | [Comentario breve] |
| 5 | Estabilidad | [PASS/FAIL/PARTIAL] | [Comentario breve] |

### Estado General del Retesting
- [ ] ✅ **APROBADO** - Bug completamente resuelto, listo para cerrar
- [ ] ❌ **RECHAZADO** - Bug persiste o hay regresiones, reabrir
- [ ] ⚠️ **CONDICIONAL** - Mejoras significativas pero requiere trabajo adicional

---

## 🎯 Recomendaciones y Próximos Pasos

### Si el Estado es APROBADO ✅
- [ ] Cerrar el bug en Azure DevOps
- [ ] Documentar la resolución
- [ ] Comunicar al equipo que el fix es exitoso
- [ ] Actualizar documentación si es necesario

### Si el Estado es RECHAZADO ❌
- [ ] Reabrir el bug con nueva información
- [ ] Documentar qué aspectos persisten
- [ ] Proporcionar evidencias adicionales
- [ ] Sugerir próximos pasos para el desarrollador

### Si el Estado es CONDICIONAL ⚠️
- [ ] Crear nuevos bugs para issues menores encontrados
- [ ] Documentar qué funciona y qué no
- [ ] Proponer plan para completar la resolución
- [ ] Decidir si cerrar el bug original o mantenerlo abierto

---

## 📝 Issues Encontrados Durante Retesting

### Nuevos Bugs Identificados
1. **Issue 1**: [Descripción]
   - **Severidad**: [Alta/Media/Baja]
   - **Acción**: [Crear nuevo bug / Agregar al bug existente]

2. **Issue 2**: [Descripción]
   - **Severidad**: [Alta/Media/Baja]
   - **Acción**: [Crear nuevo bug / Agregar al bug existente]

### Mejoras Sugeridas
- [Sugerencia 1 para mejorar la solución]
- [Sugerencia 2 para prevenir bugs similares]
- [Sugerencia 3 para mejorar el proceso]

---

## 📊 Métricas del Retesting

### Tiempo Invertido
- **Preparación**: [Tiempo para setup y preparación]
- **Ejecución**: [Tiempo de ejecución de todos los escenarios]
- **Documentación**: [Tiempo para documentar resultados]
- **Total**: [Tiempo total del retesting]

### Cobertura
- **Escenarios Planeados**: [Número]
- **Escenarios Ejecutados**: [Número]
- **Cobertura**: [Porcentaje]

### Efectividad
- **Bugs Adicionales Encontrados**: [Número]
- **Regresiones Detectadas**: [Número]
- **Confianza en el Fix**: [Alta/Media/Baja]

---

## 📎 Evidencias Adjuntas

### Screenshots
- [ ] [Lista de todos los screenshots capturados]

### Videos
- [ ] [Lista de videos de evidencia]

### Logs
- [ ] [Lista de archivos de log relevantes]

### Datos de Prueba
- [ ] [Datasets utilizados durante el retesting]

---

## 🔄 Historial de Retesting

| Fecha | Tester | Build | Resultado | Notas |
|-------|--------|-------|-----------|-------|
| [YYYY-MM-DD] | [Nombre] | [Build] | [PASS/FAIL/PARTIAL] | [Comentarios] |

---

**Nota**: Este template debe adaptarse según la complejidad del bug y los componentes involucrados. No todos los escenarios son necesarios para todos los bugs.