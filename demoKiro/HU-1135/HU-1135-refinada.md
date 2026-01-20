# HU-1135 - Historia de Usuario Refinada

## Historia de Usuario Estructurada
**Como** Usuario autorizado con roles específicos (Manager, Analyst 807, Analyst 805/806 o Solution Owner)  
**Quiero** Visualizar y gestionar el listado completo de Global Items en el módulo Global Inventory con herramientas de filtrado, búsqueda, ordenamiento y creación adaptadas a mi rol  
**Para** Administrar eficientemente el inventario global, asegurando consistencia en la clasificación, validación y mantenimiento según los permisos y programas asignados a mi rol

## Definición de Campos y Conceptos

### Global Item
- **Global Name**: Nombre descriptivo del item global
- **Global ID**: Identificador único del item global
- **Product IDs**: IDs de productos asociados al Global Item (opcional)
- **Program**: Programa al que pertenece (OTC o Te Paga)
- **Category**: Categoría del item (solo para programa Te Paga)

### Roles y Permisos
- **Manager**: Acceso completo, puede seleccionar programa en selector superior
- **Analyst 807 (OTC)**: Solo ve programa OTC, no ve filtros de Te Paga ni categorías
- **Analyst 805/806 (Te Paga)**: Ve programa Te Paga y sus categorías
- **Solution Owner**: Ve todo pero NO puede crear nuevos Global Items

### Tenant/Programa Activo
- **Tenant**: Cliente específico (MCS, DEMO, etc.)
- **Programa Activo**: Programa seleccionado en el contexto actual del usuario
- **Categorías Habilitadas**: Solo las categorías activas para el tenant/programa específico

### Funcionalidades del Listado
- **Search**: Búsqueda parcial, case-insensitive, tipo "contains"
- **Filtros**: Program y Category (condicional)
- **Sort**: Ordenamiento A-Z o Z-A
- **Paginación**: 10, 25 o 50 registros por página

## Reglas de Negocio

### RN1 - Orden por Defecto
El listado de Global Items debe mostrarse por defecto en orden alfabético A-Z basado en el campo Global Name.

### RN2 - Visibilidad por Rol
Los filtros y acciones disponibles deben adaptarse según el rol del usuario:
- Analyst 807 (OTC): NO ve filtros de Te Paga ni categorías
- Solution Owner: NO ve botón "New Global Item"
- Manager: Puede seleccionar programa en selector superior

### RN3 - Filtro de Categorías Condicional
El filtro de Category solo debe mostrarse cuando el filtro de Program está establecido en "Te Paga", y debe mostrar únicamente las categorías habilitadas para el tenant/programa activo.

### RN4 - Búsqueda Multi-campo
La funcionalidad de Search debe buscar coincidencias parciales (contains) y case-insensitive en los campos: Global Name, Global ID y Product IDs asociados.

### RN5 - Persistencia de Contexto
La paginación debe mantener su estado al aplicar search, filtros o sort, respetando los resultados filtrados y el ordenamiento activo.

### RN6 - Paginación Configurable
El usuario debe poder seleccionar entre 10, 25 o 50 registros por página, con controles de navegación: Primera página, Anterior, Siguiente, y selector numérico.

### RN7 - Experiencia Manager como OTC
Cuando un Manager selecciona el programa OTC en el selector superior, su experiencia debe ser idéntica a la de un Analyst 807 (OTC).

## Escenarios Gherkin

### Escenario 1: Carga inicial del módulo Global Inventory
```gherkin
Given el usuario está autenticado con rol "Manager"
And tiene acceso al módulo Global Inventory
When el usuario accede al tab "Global Inventory"
Then el sistema debe mostrar el listado de Global Items
And debe estar ordenado alfabéticamente A-Z por "Global Name"
And debe mostrar paginación con 10 registros por defecto
And cada registro debe mostrar "Global Name" y "Global ID"
```

### Escenario 2: Búsqueda por Global Name
```gherkin
Given el usuario está en el listado de Global Items
When el usuario escribe "apple" en el campo Search
Then el sistema debe mostrar todos los Global Items cuyo "Global Name" contenga "apple"
And la búsqueda debe ser case-insensitive
And debe mantener la paginación activa
```

### Escenario 3: Búsqueda por Global ID
```gherkin
Given el usuario está en el listado de Global Items
When el usuario escribe "GI-12345" en el campo Search
Then el sistema debe mostrar los Global Items cuyo "Global ID" contenga "GI-12345"
And debe mostrar resultados parciales (contains)
```

### Escenario 4: Búsqueda por Product ID asociado
```gherkin
Given existen Global Items con Product IDs asociados
When el usuario escribe "PROD-789" en el campo Search
Then el sistema debe mostrar los Global Items que tengan "PROD-789" en sus Product IDs asociados
And debe funcionar aunque el Product ID no esté visible en la lista
```

### Escenario 5: Filtro por Program - OTC
```gherkin
Given el usuario está en el listado de Global Items
When el usuario abre el panel de filtros
And selecciona "OTC" en el filtro Program
And hace clic en "Apply"
Then el sistema debe mostrar solo Global Items del programa OTC
And NO debe mostrar el filtro de Category
And debe actualizar la paginación según los resultados filtrados
```

### Escenario 6: Filtro por Program - Te Paga con Categorías
```gherkin
Given el usuario está en el listado de Global Items
When el usuario selecciona "Te Paga" en el filtro Program
Then el sistema debe mostrar el filtro de Category
And debe listar solo las categorías habilitadas para el tenant/programa activo
When el usuario selecciona una categoría específica
And hace clic en "Apply"
Then debe mostrar solo Global Items de Te Paga con esa categoría
```

### Escenario 7: Restricción de filtros para Analyst OTC (807)
```gherkin
Given el usuario está autenticado con rol "Analyst 807"
When el usuario accede al módulo Global Inventory
And abre el panel de filtros
Then NO debe ver la opción "Te Paga" en el filtro Program
And NO debe ver el filtro de Category
And solo debe ver opciones relacionadas con OTC
```

### Escenario 8: Restricción de creación para Solution Owner
```gherkin
Given el usuario está autenticado con rol "Solution Owner"
When el usuario accede al módulo Global Inventory
Then NO debe ver el botón "New Global Item"
And debe poder ver, buscar y filtrar Global Items normalmente
```

### Escenario 9: Ordenamiento A-Z (por defecto)
```gherkin
Given el usuario está en el listado de Global Items
When la vista se carga por primera vez
Then los Global Items deben estar ordenados alfabéticamente A-Z por "Global Name"
And el indicador de sort debe mostrar "A-Z" como activo
```

### Escenario 10: Ordenamiento Z-A
```gherkin
Given el usuario está viendo el listado ordenado A-Z
When el usuario selecciona la opción de sort "Z-A"
Then el listado debe reordenarse alfabéticamente Z-A por "Global Name"
And debe mantener la paginación activa
And debe respetar los filtros aplicados
```

### Escenario 11: Paginación básica
```gherkin
Given existen más de 10 Global Items en el sistema
When el usuario accede al listado
Then debe ver controles de paginación
And debe mostrar "Return First Page", "Previous", "Next"
And debe mostrar selector numérico de páginas (1, 2, 3...)
And debe mostrar 10 registros por página por defecto
```

### Escenario 12: Cambio de registros por página
```gherkin
Given el usuario está viendo el listado con 10 registros por página
When el usuario selecciona "25 registros por página"
Then el sistema debe mostrar 25 Global Items por página
And debe recalcular el número total de páginas
And debe mantener los filtros y sort aplicados
```

### Escenario 13: Navegación entre páginas
```gherkin
Given el usuario está en la página 1 del listado
And existen múltiples páginas de resultados
When el usuario hace clic en "Next"
Then debe navegar a la página 2
And debe mantener el ordenamiento activo
And debe mantener los filtros aplicados
```

### Escenario 14: Paginación con búsqueda activa
```gherkin
Given el usuario ha aplicado una búsqueda que retorna 30 resultados
And está mostrando 10 registros por página
When el usuario navega entre las páginas
Then la paginación debe mostrar solo las 3 páginas de resultados filtrados
And debe mantener la búsqueda activa en todas las páginas
```

### Escenario 15: Múltiples filtros simultáneos
```gherkin
Given el usuario está en el listado de Global Items
When el usuario selecciona "Te Paga" en Program
And selecciona múltiples categorías
And hace clic en "Apply"
Then debe mostrar Global Items que cumplan con todos los filtros seleccionados
And debe actualizar la paginación según los resultados
```

### Escenario 16: Limpiar filtros
```gherkin
Given el usuario ha aplicado múltiples filtros
And el listado muestra resultados filtrados
When el usuario hace clic en "Clear"
Then todos los filtros deben limpiarse
And el listado debe mostrar todos los Global Items nuevamente
And debe mantener el ordenamiento activo
```

### Escenario 17: Acción New Global Item
```gherkin
Given el usuario tiene rol "Manager"
And está en el módulo Global Inventory
When el usuario hace clic en el botón "New Global Item"
Then debe abrirse el formulario de creación de Global Item
And debe mantener el contexto del tenant/programa activo
```

### Escenario 18: Manager con selector de programa OTC
```gherkin
Given el usuario tiene rol "Manager"
And ha seleccionado "OTC" en el selector superior de programa
When el usuario accede al módulo Global Inventory
Then su experiencia debe ser idéntica a la de un Analyst 807
And NO debe ver filtros de Te Paga
And NO debe ver filtro de Category
```

### Escenario 19: Responsividad en diferentes dispositivos
```gherkin
Given el usuario accede al módulo desde un dispositivo móvil
When el listado se carga
Then debe ajustarse al tamaño de pantalla
And debe mantener toda la funcionalidad disponible
And los controles deben ser accesibles y usables
```

### Escenario 20: Persistencia de estado al navegar
```gherkin
Given el usuario ha aplicado filtros, búsqueda y está en página 3
When el usuario navega a otra sección del portal
And regresa al módulo Global Inventory
Then debe mantener los filtros aplicados
And debe mantener la búsqueda activa
And debe estar en la misma página (3)
```

## Preguntas para el Product Owner

### Sobre Funcionalidad y Comportamiento:
1. **Persistencia de Estado**: ¿El estado de filtros, búsqueda y paginación debe persistir al salir y volver al módulo, o debe resetearse?

2. **Búsqueda en Product IDs**: ¿Los Product IDs asociados deben mostrarse en algún lugar de la interfaz o solo son buscables?

3. **Categorías Múltiples**: ¿Un Global Item puede tener múltiples categorías o solo una?

4. **Filtros Múltiples**: ¿Se pueden seleccionar múltiples programas simultáneamente o es excluyente (solo OTC o solo Te Paga)?

5. **Ordenamiento Adicional**: ¿Se requiere ordenamiento por otros campos además de Global Name (ej: por Global ID, por fecha de creación)?

### Sobre Roles y Permisos:
6. **Analyst 805/806**: ¿Este rol solo ve Te Paga o puede ver ambos programas? ¿Cuál es la diferencia entre 805 y 806?

7. **Solution Owner - Edición**: ¿El Solution Owner puede editar Global Items existentes o solo visualizar?

8. **Manager - Permisos Completos**: ¿El Manager puede crear, editar y eliminar Global Items sin restricciones?

### Sobre Datos y Contexto:
9. **Tenant/Programa Activo**: ¿Cómo se determina el tenant/programa activo? ¿Es seleccionado por el usuario o viene del contexto de autenticación?

10. **Global Items Sin Programa**: ¿Pueden existir Global Items sin programa asignado? ¿Cómo se manejan en los filtros?

11. **Categorías Deshabilitadas**: ¿Qué pasa con Global Items que tienen categorías que fueron deshabilitadas posteriormente?

### Sobre UX/UI:
12. **Indicadores Visuales**: ¿Se requieren indicadores visuales de filtros activos (ej: badges, chips)?

13. **Mensajes de Estado**: ¿Qué mensaje debe mostrarse cuando no hay resultados (búsqueda sin coincidencias, filtros sin resultados)?

14. **Carga de Datos**: ¿Se requiere un loading state mientras se cargan los Global Items?

15. **Exportación**: ¿Se requiere funcionalidad para exportar el listado filtrado (CSV, Excel)?

## Análisis de Complejidad

### Complejidad Técnica: MEDIA-ALTA

#### Componentes Involucrados:
- **Frontend**: Componente de listado con múltiples funcionalidades
- **Backend**: APIs para listado, búsqueda, filtrado
- **Base de Datos**: Queries optimizadas para búsqueda y filtrado
- **Autenticación**: Integración con sistema de roles y permisos

#### Desafíos Identificados:
1. **Lógica de Roles Compleja**: Diferentes vistas según rol y contexto
2. **Filtros Condicionales**: Category solo visible con Te Paga
3. **Búsqueda Multi-campo**: Incluyendo Product IDs no visibles
4. **Persistencia de Estado**: Mantener contexto de filtros/búsqueda/paginación
5. **Performance**: Búsqueda y filtrado eficiente con gran volumen de datos

### Estimación de Esfuerzo:
- **Desarrollo Frontend**: 5-8 días
- **Desarrollo Backend**: 3-5 días
- **Testing**: 3-4 días
- **Total Estimado**: 11-17 días (2-3 sprints)

## Dependencias Identificadas

### Dependencias Técnicas:
- Sistema de autenticación y roles (RBAC)
- Contexto de tenant/programa activo
- API de Global Items existente
- Formulario de creación de Global Item (otra HU)

### Dependencias de Datos:
- Catálogo de programas (OTC, Te Paga)
- Catálogo de categorías por tenant/programa
- Relación Global Items - Product IDs

### Dependencias de UX:
- Design system del portal
- Componentes reutilizables de paginación, filtros, búsqueda
- Mockups o wireframes del módulo