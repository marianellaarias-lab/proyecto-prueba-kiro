# PREGUNTAS PENDIENTES DE DEFINICIÓN - HU TENANT SELECTOR

## Contexto
- **Rol**: Solution Owner (solo visualización, sin edición)
- **Funcionalidad**: Cambiar entre tenants (clientes) para ver información de cada uno
- **Cambio de Tenant**: Pasar de ver Cliente A a ver Cliente B

---

## 1. BÚSQUEDA EN EL SELECTOR ⚠️ CRÍTICO

### 1.1 Sensibilidad de Búsqueda
**Pregunta**: ¿La búsqueda será case-insensitive?
- **Ejemplo**: Si busco "acme", ¿debe encontrar "ACME", "Acme", "acme"?
- **Impacto**: Afecta la experiencia de usuario y la implementación del filtro

### 1.2 Alcance de Búsqueda
**Pregunta**: ¿La búsqueda debe buscar solo por `tenant_name` o también por `tenant_id`?
- **Opción A**: Solo por nombre (más común para usuarios)
- **Opción B**: Por nombre e ID (útil para soporte técnico)
- **Impacto**: Define los campos indexados y la lógica de búsqueda

### 1.3 Tipo de Búsqueda
**Pregunta**: ¿Búsqueda exacta o parcial (substring)?
- **Ejemplo exacta**: "ACME Corp" solo encuentra "ACME Corp"
- **Ejemplo parcial**: "ACME" encuentra "ACME Corp", "ACME Industries", "New ACME"
- **Impacto**: Afecta usabilidad y performance

### 1.4 Sin Resultados
**Pregunta**: ¿Qué se muestra si la búsqueda no encuentra resultados?
- **Opción A**: Mensaje "No se encontraron tenants"
- **Opción B**: Mostrar todos los tenants nuevamente
- **Opción C**: Mantener lista vacía con opción de limpiar búsqueda

---

## 2. MANEJO DE ERRORES DE SEGURIDAD ⚠️ CRÍTICO

### 2.1 Contradicción en RN-01
**Problema identificado**: 
- RN-01.3 dice: "Usuarios con roles diferentes al Solution Owner NO ven el selector de tenants"
- RN-01.5 dice: "Intentos de acceso al selector de tenants por roles no autorizados deben retornar 403 Forbidden"
- **Escenario 8** valida el error 403

**Pregunta**: Si el selector NO se muestra en el frontend para otros roles, ¿por qué validar con 403?

**Opciones**:
- **Opción A**: Ocultar completamente en frontend (no renderizar el componente). El 403 solo aplica si intentan acceder vía API directamente
- **Opción B**: Mostrar el selector pero deshabilitado con tooltip "No tiene permisos"
- **Opción C**: Mostrar el selector pero al hacer clic retornar 403

**Recomendación**: Opción A (ocultar en frontend, validar en backend solo para accesos directos a API)

### 2.2 Código de Error Apropiado
**Pregunta**: ¿403 Forbidden o 401 Unauthorized?
- **403**: El usuario está autenticado pero no tiene permisos (más apropiado)
- **401**: El usuario no está autenticado (no aplica si ya inició sesión)

---

## 3. ORDEN ALFABÉTICO - DETALLES TÉCNICOS

### 3.1 Caracteres Especiales
**Pregunta**: ¿Cómo se ordenan caracteres especiales y acentos?
- **Ejemplo**: ¿Dónde va "Ñoño Corp" en relación a "Nokia" y "Omega"?
- **Ejemplo**: ¿"Álvarez" va antes o después de "Alvarez"?
- **Opciones**:
  - Orden ASCII estándar (acentos al final)
  - Orden Unicode (respeta idioma español)
  - Normalizar caracteres (quitar acentos antes de ordenar)

### 3.2 Números vs Letras
**Pregunta**: ¿Números antes o después de letras?
- **Ejemplo**: "123 Corp", "ABC Corp", "456 Industries"
- **Opción A**: Números primero (123 Corp, 456 Industries, ABC Corp)
- **Opción B**: Letras primero (ABC Corp, 123 Corp, 456 Industries)

### 3.3 Case Sensitivity en Ordenamiento
**Pregunta**: ¿El ordenamiento es case-sensitive?
- **Ejemplo**: "abc Corp" vs "ABC Corp" vs "Abc Corp"
- **Recomendación**: Case-insensitive para mejor UX

---

## 4. SELECCIÓN INICIAL DE TENANT ⚠️ CRÍTICO

### 4.1 Contradicción con RN-04
**Problema identificado**:
- RN-04 dice que "ALL Tenants" está **fuera de alcance** (se implementará en otra HU)
- Pero RN-05 dice que toda la data debe ser del tenant activo
- **¿Qué se muestra al iniciar sesión si no hay tenant seleccionado?**

**Opciones**:
- **Opción A**: Vista vacía con mensaje "Seleccione un tenant para comenzar"
- **Opción B**: Seleccionar automáticamente el primer tenant alfabéticamente
- **Opción C**: Bloquear toda navegación hasta que seleccione un tenant
- **Opción D**: Mostrar dashboard sin datos con placeholder

### 4.2 Tenant por Defecto
**Pregunta**: ¿Se debe recordar el último tenant seleccionado?
- Si el usuario cierra sesión y vuelve a entrar, ¿se selecciona automáticamente el último tenant usado?
- ¿O siempre inicia sin selección?

---

## 5. PERSISTENCIA DEL TENANT SELECCIONADO ⚠️ CRÍTICO

### 5.1 Almacenamiento
**Pregunta**: ¿Dónde se guarda el tenant seleccionado?
- **Opción A**: Sesión del servidor (se pierde al cerrar navegador)
- **Opción B**: localStorage (persiste entre sesiones)
- **Opción C**: Cookie (persiste y se envía en cada request)
- **Opción D**: Estado en memoria (se pierde al refrescar página)

### 5.2 Múltiples Pestañas
**Pregunta**: Si el usuario abre múltiples pestañas, ¿se sincronizan?
- **Escenario**: Pestaña 1 tiene "Cliente A", Pestaña 2 tiene "Cliente B"
- **Opción A**: Cada pestaña mantiene su propio tenant (independientes)
- **Opción B**: Al cambiar en una pestaña, se sincronizan todas (usando localStorage events)

### 5.3 Refresco de Página
**Pregunta**: ¿Qué pasa si el usuario hace F5 (refresh)?
- **Opción A**: Se mantiene el tenant seleccionado
- **Opción B**: Se pierde la selección y vuelve al estado inicial

---

## 6. TENANT SIN DATOS

### 6.1 Vista Vacía
**Pregunta**: ¿Qué se muestra si el tenant seleccionado existe pero no tiene datos?
- **Opción A**: Mensaje específico "No hay datos disponibles para este tenant"
- **Opción B**: Vista vacía genérica (sin mensaje especial)
- **Opción C**: Mensaje "Este tenant aún no tiene información registrada"

---

## 7. PERFORMANCE Y TIMEOUTS

### 7.1 Carga de Lista de Tenants
**Pregunta**: ¿Cuánto tiempo máximo puede tomar cargar la lista de tenants?
- ¿Hay timeout definido? (ej: 5 segundos)
- ¿Qué pasa si falla la carga? ¿Mensaje de error? ¿Reintentar?

### 7.2 Refresco de Vista al Cambiar Tenant
**Pregunta**: ¿Cuánto tiempo máximo para refrescar la vista?
- ¿Hay indicador de carga (spinner, skeleton)?
- ¿Qué pasa si falla el refresco? ¿Se revierte al tenant anterior?

---

## 8. SOLUTION OWNER Y SELECTOR DE PROGRAMAS ⚠️ CRÍTICO

### 8.1 Coexistencia de Selectores
**Pregunta**: ¿El Solution Owner también ve el selector de programas?
- **Opción A**: Solo ve selector de tenants (no tiene programas asignados)
- **Opción B**: Ve ambos selectores (tenant + programa)

### 8.2 Prioridad de Filtrado (si aplica Opción B)
**Pregunta**: Si ve ambos selectores, ¿cuál tiene prioridad?
- ¿Primero filtra por tenant y luego por programa?
- ¿Son filtros independientes?
- ¿Cómo interactúan?

---

## 9. VALIDACIÓN DE TENANT_ID EN URLs

### 9.1 Estructura de URLs
**Pregunta**: ¿Las URLs incluyen el tenant_id?
- **Ejemplo A**: `/dashboard` (tenant en sesión/estado)
- **Ejemplo B**: `/tenants/123/dashboard` (tenant en URL)

### 9.2 Manipulación de URLs
**Pregunta**: Si las URLs incluyen tenant_id, ¿qué pasa si alguien lo manipula?
- **Escenario**: Usuario tiene seleccionado "Tenant A" pero cambia URL a "Tenant B"
- **Opción A**: Se sincroniza el selector con la URL
- **Opción B**: Se valida y retorna 403 si no coincide
- **Opción C**: Se ignora la URL y prevalece el selector

---

## 10. CANTIDAD DE TENANTS Y ESCALABILIDAD

### 10.1 Límite de Tenants
**Pregunta**: ¿Cuántos tenants puede tener un Solution Owner?
- ¿10, 50, 100, 1000+?
- **Impacto**: Define si se necesita paginación, virtualización, o solo búsqueda

### 10.2 Paginación en Dropdown
**Pregunta**: Si hay muchos tenants, ¿el dropdown tiene paginación?
- **Opción A**: Carga todos y usa búsqueda/scroll
- **Opción B**: Paginación (cargar de 50 en 50)
- **Opción C**: Virtualización (solo renderizar visibles)

---

## 11. INDICADOR VISUAL DEL TENANT ACTIVO

### 11.1 Contenido del Indicador
**Pregunta**: ¿Qué información muestra el indicador?
- **Opción A**: Solo `tenant_name` (ej: "ACME Corp")
- **Opción B**: `tenant_name` + `tenant_id` (ej: "ACME Corp (123)")
- **Opción C**: Solo `tenant_id` (menos común)

### 11.2 Estilo del Indicador
**Pregunta**: ¿Qué formato visual tiene?
- **Opción A**: Badge/chip con color distintivo
- **Opción B**: Label simple en texto
- **Opción C**: Breadcrumb (ej: "Home > ACME Corp > Dashboard")
- **Opción D**: Ícono + texto

### 11.3 Ubicación del Indicador
**Pregunta**: ¿Dónde se ubica exactamente?
- **Opción A**: Junto al selector de tenants
- **Opción B**: En el header (esquina superior)
- **Opción C**: En breadcrumb de navegación
- **Opción D**: En múltiples lugares (header + breadcrumb)

---

## 12. REFRESCO DE VISTA - COMPORTAMIENTO TÉCNICO

### 12.1 Tipo de Refresco
**Pregunta**: ¿Cómo se refresca la vista al cambiar de tenant?
- **Opción A**: Reload completo de la página (window.location.reload)
- **Opción B**: Recarga solo los datos vía AJAX (SPA)
- **Opción C**: Navegación a nueva URL con tenant_id

### 12.2 Transición Visual
**Pregunta**: ¿Hay animación o transición?
- **Opción A**: Instantáneo (sin animación)
- **Opción B**: Fade out/in
- **Opción C**: Skeleton loaders mientras carga
- **Opción D**: Spinner/loading overlay

### 12.3 Estado Durante Refresco
**Pregunta**: ¿Qué pasa con la UI mientras se refresca?
- **Opción A**: Se bloquea toda la UI (overlay)
- **Opción B**: Solo se bloquea el área de contenido
- **Opción C**: Se puede seguir navegando (refresco en background)

---

## 13. AUDITORÍA Y LOGGING

### 13.1 Registro de Cambios
**Pregunta**: ¿Se debe registrar cada cambio de tenant en audit log?
- **Información a registrar**:
  - Usuario (Solution Owner)
  - Tenant anterior
  - Tenant nuevo
  - Timestamp
  - IP/ubicación

### 13.2 Propósito del Audit Log
**Pregunta**: ¿Para qué se usará este log?
- Compliance/auditoría
- Análisis de uso
- Seguridad/detección de anomalías

---

## 14. COMPORTAMIENTO EN MODALES Y NAVEGACIÓN SECUNDARIA

### 14.1 Indicador en Modales
**Pregunta**: ¿Los modales deben mostrar el indicador del tenant activo?
- **Opción A**: Sí, siempre visible (incluso en modales)
- **Opción B**: No, solo en el layout principal

### 14.2 Cambio de Tenant con Modal Abierto
**Pregunta**: ¿Qué pasa si el usuario cambia de tenant mientras hay un modal abierto?
- **Opción A**: Se cierra el modal automáticamente
- **Opción B**: Se mantiene el modal pero se actualiza su contenido
- **Opción C**: Se bloquea el cambio hasta cerrar el modal

---

## RESUMEN DE PREGUNTAS CRÍTICAS (PRIORIDAD ALTA)

1. **Búsqueda**: ¿Case-insensitive? ¿Parcial o exacta?
2. **Error 403**: ¿Ocultar selector en frontend o mostrar error?
3. **Selección inicial**: ¿Qué se muestra al iniciar sesión sin tenant seleccionado?
4. **Persistencia**: ¿Dónde se guarda el tenant seleccionado? ¿Se mantiene entre sesiones?
5. **Solution Owner + Programas**: ¿Ve ambos selectores o solo tenants?
6. **Cantidad de tenants**: ¿Cuántos puede tener? ¿Se necesita paginación?
7. **Tipo de refresco**: ¿Reload completo o recarga de datos (SPA)?
8. **URLs**: ¿Incluyen tenant_id o se maneja en sesión/estado?

---

## PRÓXIMOS PASOS

1. Revisar estas preguntas con el Product Owner
2. Documentar las respuestas
3. Actualizar la HU refinada con las definiciones
4. Actualizar los escenarios Gherkin según las respuestas
5. Crear casos de prueba específicos para las definiciones
