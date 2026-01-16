# USER STORY - TENANT SELECTOR - REFINADA

## Historia de Usuario
**Como** Solution Owner (único rol con acceso al selector de tenants)  
**Quiero** poder visualizar toda la información de la solución filtrada exclusivamente por el tenant seleccionado  
**Para** garantizar aislamiento, control operacional y visibilidad precisa de la data según el tenant activo

## Definición de Campos

### Tenant Selector (solo Solution Owner)
- **tenant_id**: Identificador del tenant (string, 36 caracteres)
- **tenant_name**: Nombre del tenant (string, 100 caracteres)
- **Tipo de control**: Dropdown ordenado alfabéticamente
- **Visibilidad**: Siempre visible en posición fija

### Program Selector (todos los demás roles)
- **program_id**: Identificador del programa (string)
- **program_name**: Nombre del programa (string)
- **Funcionalidad**: Se mantiene exactamente como funciona actualmente
- **Sin cambios**: No se modifica comportamiento existente

### Contexto del Tenant
- **active_tenant**: Tenant actualmente seleccionado por el Solution Owner
- **indicator**: Indicador visual del tenant activo (visible en todas las pantallas)

## Reglas de Negocio

### RN-01: Acceso Exclusivo al Selector de Tenants
1. Solo el rol Solution Owner puede ver el selector de tenants
2. Solo el rol Solution Owner puede seleccionar o cambiar el tenant activo
3. Usuarios con roles diferentes al Solution Owner NO ven el selector de tenants
4. Usuarios con roles diferentes al Solution Owner SÍ continúan usando el selector de programas existente sin cambios
5. Intentos de acceso al selector de tenants por roles no autorizados deben retornar 403 Forbidden--- DUDA USUARIO DEBERIAN TENER DISPONIBLE ESTE ACCESO??

### RN-02: Selector Siempre Visible (Solo Solution Owner)
1. El selector de tenants debe estar siempre visible en una posición fija en el layout
2. El selector debe reflejar el tenant activo en todo momentO
3. El selector NO puede ocultarse en pantallas, modales o navegación interna

### RN-03: Orden Alfabético del Selector
1. Todos los tenants deben aparecer ordenados alfabéticamente (A-Z) por tenant_name
2. El orden debe ser consistente sin importar idioma o configuración regional
3. No se permite orden manual ni configuración personalizada por usuario

### RN-04: Selección Inicial (Fuera de Alcance)
**NOTA**: Esta regla está documentada pero será implementada en otra HU
1. Por defecto, al entrar a la solución debe aparecer "ALL Tenants"
2. "ALL Tenants" funciona como opción neutral antes de seleccionar un tenant específico

### RN-05: Aplicación Global del Tenant
1. Toda la data en vistas, listados, formularios y reportes debe corresponder exclusivamente al tenant activo
2. NO pueden aparecer datos de otros tenants
3. Backend debe aplicar filtro de tenant_id en todas las operaciones de lectura

### RN-06: Cambio de Tenant
1. Al cambiar el tenant seleccionado, toda la vista debe refrescarse inmediatamente
2. Debe reiniciarse la paginación a la página 1
3. Deben limpiarse todos los filtros aplicados ---- cuales son los filtros y ordenacion posible
4. Debe reiniciarse la ordenación a valores por defecto
5. Debe limpiarse cualquier estado de la vista anterior
6. NO debe quedar rastro de data del tenant previo

### RN-07: Indicador del Tenant Activo
1. Debe existir un indicador visual del tenant activo
2. El indicador debe ser visible en todas las pantallas de la solución
3. El indicador debe actualizarse inmediatamente al cambiar el tenant
4. El indicador NO puede ocultarse en navegación secundaria o modales

### RN-08: Aislamiento y Seguridad
1. Cualquier intento de acceso a datos que no pertenecen al tenant activo debe retornar 403 Forbidden o 404 Not Found
2. Backend debe validar el tenant_id en todos los endpoints
3. NO deben cargarse recursos 

### RN-09: Roles Distintos a Solution Owner
1. Los roles diferentes al Solution Owner mantienen su selector de programas tal como funciona actualmente
2. El selector de programas permanece sin cambios en funcionalidad, flujos o reglas
3. Dichos roles NO pueden seleccionar tenants
4. Dichos roles NO pueden visualizar información multi-tenant

## Escenarios Gherkin

### Escenario 1: Solution Owner visualiza selector de tenants
```gherkin
Given que el usuario ha iniciado sesión con rol "Solution Owner"
When accede a cualquier pantalla de la solución
Then se debería ver el selector de tenants en posición fija
And se debería ver el indicador del tenant activo
```

### Escenario 2: Otros roles NO visualizan selector de tenants
```gherkin
Given que el usuario ha iniciado sesión con un rol diferente a "Solution Owner"
When accede a cualquier pantalla de la solución
Then NO se debería ver el selector de tenants
And se debería ver el selector de programas existente
And el selector de programas debería funcionar como siempre
```

### Escenario 3: Selector siempre visible para Solution Owner
```gherkin
Given que el usuario es Solution Owner
And se encuentra en cualquier pantalla de la solución
When navega entre diferentes módulos
Then el selector de tenants debería permanecer visible en la misma posición
And el indicador del tenant activo debería permanecer visible
```

### Escenario 4: Tenants ordenados alfabéticamente
```gherkin
Given que el usuario es Solution Owner
When abre el selector de tenants
Then se deberían ver todos los tenants ordenados alfabéticamente por nombre
```

### Escenario 5: Selección de tenant y filtrado de data
```gherkin
Given que el usuario es Solution Owner
And existen datos de múltiples tenants en el sistema
When selecciona un tenant específico del selector
Then toda la data visible debería corresponder exclusivamente al tenant seleccionado
And NO se debería ver data de otros tenants
```

### Escenario 6: Cambio de tenant refresca la vista
```gherkin
Given que el usuario es Solution Owner
And tiene seleccionado "Tenant A"
And está en una vista con paginación, filtros y ordenación aplicados
When cambia la selección a "Tenant B"
Then la vista debería refrescarse inmediatamente
And la paginación debería reiniciarse a página 1
And los filtros deberían limpiarse
And la ordenación debería volver a valores por defecto
And NO debería verse data del "Tenant A"
```

### Escenario 7: Indicador de tenant activo se actualiza
```gherkin
Given que el usuario es Solution Owner
And tiene seleccionado "Tenant A"
When cambia la selección a "Tenant B"
Then el indicador del tenant activo debería actualizarse inmediatamente a "Tenant B"
And el indicador debería ser visible en todas las pantallas
```

### Escenario 8: Intento de acceso no autorizado al selector
```gherkin
Given que el usuario tiene un rol diferente a Solution Owner
When intenta acceder al endpoint del selector de tenants
Then se debería retornar código de error 403 Forbidden
```

### Escenario 9: Intento de acceso a data de otro tenant
```gherkin
Given que el usuario es Solution Owner
And tiene seleccionado "Tenant A"
When intenta acceder a un recurso que pertenece a "Tenant B"
Then se debería retornar código de error 403 Forbidden o 404 Not Found
```

### Escenario 10: Persistencia del tenant activo en navegación
```gherkin
Given que el usuario es Solution Owner
And ha seleccionado "Tenant A"
When navega entre diferentes módulos de la solución
Then el selector debería seguir mostrando "Tenant A" como activo
And toda la data en cada módulo debería corresponder a "Tenant A"
```

## Preguntas para el Product Owner

### Ambigüedades Críticas de Seguridad y Acceso

1. **Contradicción RN-01.3 vs RN-01.5 y Escenario 8**: 
   - RN-01.3 dice que usuarios no-Solution-Owner "NO ven el selector de tenants"
   - RN-01.5 dice "Intentos de acceso al selector de tenants por roles no autorizados deben retornar 403 Forbidden"
   - Escenario 8 valida el retorno de 403 Forbidden
   - **¿Cuál es la estrategia correcta?**
     - ¿Se oculta completamente en UI (no se renderiza) y el 403 solo aplica si intentan acceder vía API directamente?
     - ¿Se muestra el selector deshabilitado con tooltip explicativo?
     - ¿O se muestra pero retorna 403 al intentar usarlo?

### Funcionalidad de Búsqueda en el Selector

2. **Búsqueda case-sensitive**: ¿La búsqueda en el dropdown será case-insensitive? (ej: buscar "acme" encuentra "ACME", "Acme", "aCmE")

3. **Alcance de búsqueda**: ¿La búsqueda buscará solo por `tenant_name` o también por `tenant_id`?

4. **Tipo de búsqueda**: ¿Búsqueda parcial (substring) o exacta? (ej: buscar "Corp" encuentra "ABC Corp", "Corp Industries")

5. **Sin resultados**: ¿Qué se muestra si la búsqueda no encuentra resultados? ¿Mensaje "No se encontraron tenants"?

### Orden Alfabético - Detalles Técnicos

6. **Caracteres especiales**: ¿Cómo se ordenan caracteres especiales en el orden alfabético? (ñ, á, ü, ç, é)

7. **Números vs letras**: ¿Los números van antes o después de las letras en el orden? (ej: "123 Corp" vs "ABC Corp")

8. **Case-sensitivity en orden**: ¿El ordenamiento es case-sensitive o case-insensitive? (ej: "abc Corp" vs "ABC Corp" vs "Abc Corp")



### Estado Inicial y Selección por Defecto

10. **Estado inicial sin "ALL Tenants"**: RN-04 dice que "ALL Tenants" está fuera de alcance. ¿Qué debe mostrarse al iniciar sesión antes de seleccionar un tenant?
    - ¿Vista vacía con mensaje "Seleccione un tenant para visualizar información"?
    - ¿Se selecciona automáticamente el primer tenant alfabéticamente?
    - ¿Se bloquea toda navegación hasta seleccionar un tenant?
    - ¿El selector muestra placeholder "Seleccione un tenant..."?

### Persistencia y Sincronización

11. **Persistencia del tenant seleccionado**: ¿Dónde se guarda el tenant seleccionado?
    - ¿En sesión del servidor?
    - ¿En localStorage del navegador?
    - ¿En cookie?

12. **Persistencia entre sesiones**: ¿Qué pasa si el usuario cierra y vuelve a abrir el navegador? ¿Debe recordar el último tenant seleccionado?

13. **Múltiples pestañas**: ¿Qué pasa si el usuario abre múltiples pestañas del navegador? ¿Se sincronizan automáticamente o son independientes?


### Escalabilidad y Performance

16. **Cantidad de tenants**: ¿Cuántos tenants puede tener un Solution Owner? (10, 50, 100, 1000+?)

17. **Paginación en dropdown**: Si son muchos tenants, ¿hay paginación en el dropdown o se cargan todos de una vez?

18. **Lazy loading**: ¿Se implementa lazy loading para la lista de tenants o se cargan todos al abrir el dropdown?

19. **Timeout de carga**: ¿Cuánto tiempo máximo puede tomar cargar la lista de tenants en el dropdown?

20. **Timeout de refresco**: ¿Cuánto tiempo máximo puede tomar refrescar la vista al cambiar de tenant?

21. **Fallo en refresco**: ¿Qué pasa si falla el refresco de la vista? ¿Se muestra mensaje de error? ¿Se revierte al tenant anterior?

### Indicador Visual del Tenant Activo

22. **Contenido del indicador**: ¿El indicador muestra solo `tenant_name`, solo `tenant_id`, o ambos, o es logo del tenant?

23. **Estilo del indicador**: ¿El indicador tiene color, ícono o badge distintivo?  --- UI

24. **Ubicación del indicador**: ¿Dónde exactamente se ubica el indicador? (header, breadcrumb, junto al selector, esquina superior) ---- UI puede ser el logo del tenant

### Comportamiento de Refresco de Vista

25. **Tipo de refresco**: RN-06 dice "refrescar inmediatamente". ¿Esto significa:
    - ¿Reload completo de la página (equivalente a F5)?
    - ¿O solo recarga de datos vía AJAX/fetch sin reload de página?

26. **Indicador de carga**: ¿Debe haber indicador de carga (spinner, skeleton, progress bar) mientras se refresca? ---- UI

27. **Transición visual**: ¿Hay animación/transición o el cambio es instantáneo? ---- UI

### Validación y Seguridad

28. **Tenant_ID en URLs**: ¿Las URLs incluyen el tenant_id? (ej: `/dashboard?tenant=123` o `/tenants/123/dashboard`) --- DESA

29. **Manipulación de URL**: ¿Qué pasa si un usuario manipula la URL con otro tenant_id? ¿Se valida y sincroniza automáticamente con el selector? ---- DESA

30. **Validación en cada request**: ¿El backend debe validar el tenant_id en cada request HTTP? ---- DESA

### Casos Especiales

31. **Tenant sin datos**: Es posible tener un tenant sin datos?
    -¿Qué se muestra si el tenant seleccionado existe pero no tiene datos?
    - ¿Mensaje específico "No hay información disponible para este tenant"?
    - ¿Vista vacía genérica? 

32. **Error al cargar tenants**: ¿Qué mensaje específico debe mostrarse si falla la carga de la lista de tenants? ---- DESA


33. **Auditoría de cambios**: ¿Se debe registrar en audit log cada cambio de tenant realizado por el Solution Owner? ¿Qué información se guarda? (usuario, tenant_anterior, tenant_nuevo, timestamp)

34. **Indicador en modales**: ¿Los modales deben mostrar también el indicador del tenant activo o solo el selector en el layout principal? ---- SI ES EL LOGO DEL TENANT SE VA A VER SIEMPRE

35. **Posición del selector**: ¿En qué ubicación específica del layout debe estar el selector de tenants? (header, sidebar, toolbar, otra ubicación) --- UI

36. **Programas por tenants** Cuando se seleccione un tenant va a tener los programas (cuantos programas pueden ser)

37. **Comportamiento al cambiar de tenant** Cuando hay un cambio de tenant debe haber una vista inicial por defecto? o conservará la posición actual del tenant A cambiando los Datos del tenant B?