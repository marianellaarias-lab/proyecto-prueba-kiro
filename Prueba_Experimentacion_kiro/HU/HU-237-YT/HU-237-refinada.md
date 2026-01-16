# USER STORY 237 - REFINADA

## Historia de Usuario
**Como** Manager y Analista de MCS  
**Quiero** crear, ver, editar y eliminar Parent Companies, y asociarles merchants  
**Para** centralizar la relación entre inventario, merchants y compañía matriz con un identificador único autogenerado por el sistema

## Definición de Campos

### Parent Company
- **Company Name**: Nombre de la compañía matriz (string)
- **ID**: Identificador único autogenerado por el sistema
- **Merchants (count)**: Contador de merchants asociados (calculado en backend)
- **Estatus**: Active/Inactive

### Configuración de Lista
- **Paginación**: Server-side con page, size, sort
- **Tamaño por defecto**: 10 registros
- **Tamaño máximo**: 50 registros
- **Ordenación**: Por company_name (asc/desc)

## Reglas de Negocio

### RN-01: Visualización y Navegación
1. Al entrar al segmento de Merchants, se debe presentar la pestaña Parent Company
2. La lista debe mostrar todos los Parent Companies por defecto
3. Los campos visibles son: Company Name, ID, Merchants (count) y estatus

### RN-02: Búsqueda
1. La búsqueda debe ser universal sobre company_name
2. Debe ser case-insensitive (insensible a mayúsculas)
3. Debe ser insensible a acentos y espacios múltiples
4. Debe soportar búsqueda parcial tipo "comienza con" (limitación Dynamo)
5. Si se escribe "Wal" debe buscar companies que empiecen con "Wal"
6. NO debe traer companies que contengan "wal" en el medio del nombre

### RN-03: Paginación
1. Debe ser server-side (no cargar todo en memoria del cliente)
2. Parámetros: page, size, sort
3. Tamaño por defecto: 10 registros
4. Incremento máximo: hasta 50 registros

### RN-04: Filtros
1. Chips disponibles: All, Active, Inactive
2. Filtro por defecto: All

### RN-05: Ordenación
1. Debe permitir ordenación por company_name
2. Opciones: ascendente (asc) y descendente (desc)

### RN-06: Conteo de Merchants
1. El conteo de merchants asociados se calcula en backend
2. Se devuelve en el mismo payload de la lista

### RN-07: Permisos CRUD
1. Analyst 805/806: Permisos CRUD completos
2. Analyst 807 (OTC): Permisos CRUD completos  
3. Manager: Permisos CRUD completos

### RN-08: Auditoría
1. Registrar en Audit Log todas las acciones CRUD
2. NO registrar acciones de lectura/consulta

## Escenarios Gherkin

### Escenario 1: Visualización inicial de Parent Companies
```gherkin
Given que soy un usuario con rol Manager o Analista MCS
When accedo al módulo Merchants
And selecciono la pestaña Parent Company
Then debo ver la lista de Parent Companies
And debo ver las columnas: Company Name, ID, Merchants (count), Estatus
And debo ver 10 registros por defecto
And debo ver los filtros chips: All, Active, Inactive
And el filtro "All" debe estar seleccionado por defecto
```

### Escenario 2: Búsqueda parcial exitosa
```gherkin
Given que estoy en la lista de Parent Companies
When ingreso "Wal" en el campo de búsqueda
Then debo ver solo los Parent Companies que empiecen con "Wal"
And debo ver resultados como "Walmart", "Walgreens"
And NO debo ver resultados que contengan "wal" en el medio como "Super market Walmart"
```

### Escenario 3: Búsqueda insensible a mayúsculas y acentos
```gherkin
Given que estoy en la lista de Parent Companies
When ingreso "mcdonald" en el campo de búsqueda
Then debo ver Parent Companies que empiecen con "McDonald"
And debo ver Parent Companies que empiecen con "MCDONALD"
And debo ver Parent Companies que empiecen con "McDónald"
```

### Escenario 4: Filtrado por estatus Active
```gherkin
Given que estoy en la lista de Parent Companies
When selecciono el chip "Active"
Then debo ver solo Parent Companies con estatus "Active"
And el chip "Active" debe estar resaltado
And los otros chips deben estar en estado normal
```

### Escenario 5: Filtrado por estatus Inactive
```gherkin
Given que estoy en la lista de Parent Companies
When selecciono el chip "Inactive"
Then debo ver solo Parent Companies con estatus "Inactive"
And el chip "Inactive" debe estar resaltado
```

### Escenario 6: Paginación - Cambio de tamaño de página
```gherkin
Given que estoy en la lista de Parent Companies
When cambio el tamaño de página a 25
Then debo ver hasta 25 registros por página
And la paginación debe actualizarse según el nuevo tamaño
```

### Escenario 7: Ordenación ascendente por nombre
```gherkin
Given que estoy en la lista de Parent Companies
When selecciono ordenar por Company Name ascendente
Then los Parent Companies deben mostrarse ordenados alfabéticamente A-Z
```

### Escenario 8: Ordenación descendente por nombre
```gherkin
Given que estoy en la lista de Parent Companies
When selecciono ordenar por Company Name descendente
Then los Parent Companies deben mostrarse ordenados alfabéticamente Z-A
```

### Escenario 9: Validación de conteo de merchants
```gherkin
Given que estoy en la lista de Parent Companies
When veo un Parent Company en la lista
Then debo ver el conteo exacto de merchants asociados
And el conteo debe ser calculado desde el backend
```

### Escenario 10: Límite máximo de paginación
```gherkin
Given que estoy en la lista de Parent Companies
When intento cambiar el tamaño de página a más de 50
Then el sistema debe limitar el tamaño máximo a 50 registros
```

## Preguntas para el Product Owner

1. **Búsqueda sin resultados**: ¿Qué mensaje se debe mostrar cuando la búsqueda no retorna resultados?

2. **Comportamiento de filtros combinados**: ¿Se puede combinar la búsqueda con los filtros de estatus simultáneamente?

3. **Ordenación por defecto**: ¿Cuál es el orden por defecto al cargar la lista inicialmente (ascendente/descendente)?

4. **Acciones desde el listado**: ¿Hay alguna acción disponible desde cada fila del listado (ver detalle, editar, etc.)?

5. **Formato del ID**: ¿El ID tiene algún formato específico o es simplemente un identificador alfanumérico?

6. **Conteo de merchants**: ¿El conteo incluye merchants activos e inactivos, o solo activos?

7. **Persistencia de filtros**: ¿Los filtros y configuración de paginación deben persistir al salir y volver a la pestaña?

8. **Indicadores visuales**: ¿Hay algún indicador visual especial para Parent Companies sin merchants asociados?

9. **Búsqueda en tiempo real**: ¿La búsqueda se ejecuta automáticamente mientras se escribe o requiere presionar Enter/botón buscar?

10. **Permisos de visualización**: ¿Todos los roles mencionados (Manager, Analyst 805/806, 807) tienen los mismos permisos de visualización del listado?