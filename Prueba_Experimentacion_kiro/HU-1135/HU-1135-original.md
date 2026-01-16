# HU-1135 - Historia de Usuario Original

## User Story
**Como** Usuario autorizado (Manager, Analyst 807, Analyst 805/806 o Solution Owner)  
**Quiero** Visualizar el listado completo de Global Items en el módulo Global Inventory, organizado y con herramientas de filtrado, búsqueda, sort y creación  
**Para** Administrar, navegar e identificar Global Items de forma eficiente, asegurando consistencia en la operación de clasificación, validación y mantenimiento del inventario global

## Functional Specifications

### Descripción Funcional
El módulo Global Inventory debe cumplir con lo siguiente:

#### 1. Listado de Global Items
- Presentar el listado completo de Global Items del tenant/programa activo
- Orden por defecto: Alfabético A–Z basado en Global Name
- Cada registro debe mostrar:
  - Global Name
  - Global ID

#### 2. Paginación
El listado debe incluir paginación estándar.

**Parámetros**:
- Mostrar 10-25-50 registros por página (configurable)
- Botones: Return First Page, Previous, Next, y selector numérico (1, 2, 3…)

La paginación debe respetar:
- Resultados filtrados
- Búsquedas
- Sort activo
- Scrolles dentro del contenedor del listado

#### 3. Search
- Debe permitir búsqueda parcial, contains y case-insensitive
- Debe buscar por:
  - Global Name
  - Global ID
  - Product IDs asociados (cuando existan)
- Comportamiento alineado con otros módulos del portal

#### 4. Filtros
**Filtros disponibles**:
- **Program**: OTC o Te Paga
- **Category**: 
  - Solo se muestra si el filtro es el programa Te Paga
  - Solo categorías habilitadas por el tenant/programa deben mostrarse

**Restricciones por Rol**:
- Para el Usuario Analyst OTC (807), no le aparecen los filtros relacionados al programa de Te Paga (Te Paga y Categorias)
- Rol de Solution Owner no ve la opción de New Global Item

Debe permitir:
- Múltiples selecciones
- Apply
- Clear

#### 5. Sort
- Sort A–Z (default)
- Sort Z–A

#### 6. Acción: New Global Item
- Debe mostrar un botón "New Global Item"
- Al seleccionarlo, debe levantar (llamar, mostrar) el formulario de creación de un Global Item (se encuentra en otra User Story)

#### 7. Response
- Debe ajustarse a distintos tamaños de pantalla

## Criterios de Aceptación (AC)

### AC1 – Carga inicial
Dado que el usuario accede al tab Global Inventory  
Entonces el listado se muestra en orden alfabético A–Z con paginación

### AC2 – Search funcional
Dado que el usuario escribe texto en el Search  
Cuando el sistema evalúa coincidencias  
Entonces se muestran resultados basados en Global Name, Global ID o Product ID asociado

### AC3 – Paginación
Dado que hay más elementos de los que caben en una página  
Entonces el sistema muestra controles de paginación  
Y la paginación debe mantenerse al aplicar search, filtros o sort

### AC4 – Visualización de filtros
Dado que el usuario abre el panel de filtros  
Entonces solo se muestran los programas y categorías activas para el tenant

### AC5 – Visualización de filtros Rol Analyst OTC (807)
Dado a que el usuario Analista OTC  
Entonces no tiene la opción de filtrar por el programa Te Paga

### AC6 – Aplicar filtros
Dado que el usuario selecciona uno o varios filtros  
Entonces el listado se actualiza con paginación acorde a los resultados filtrados

### AC7 – Aplicar sort
Dado que el usuario selecciona A–Z o Z–A  
Entonces el listado se reordena respetando la paginación activa

### AC8 – Acción New Global Item
Dado que el usuario presiona "New Global Item"  
Entonces es redirigido correctamente al formulario de creación

### AC9 – Rol Manager
Dado que el Manager puede escoger si desea visualizar un solo programa cuando ecoge el programa de OTC en el selector de la parte superior  
Entonces su experiencia es la misma que el de Rol OTC