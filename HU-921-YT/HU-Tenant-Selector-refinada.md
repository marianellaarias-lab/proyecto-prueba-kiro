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
3. Deben limpiarse todos los filtros aplicados
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
3. NO deben cargarse recursos (imágenes, archivos, configuraciones) no permitidos por el tenant activo

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

1. **Posición del selector**: ¿En qué ubicación específica del layout debe estar el selector de tenants (header, sidebar, toolbar)?

2. **Indicador visual**: ¿Qué formato debe tener el indicador del tenant activo (badge, label, breadcrumb)?

3. **Tiempo de refresco**: ¿Debe haber algún indicador de carga mientras se refresca la vista al cambiar de tenant?

4. **Confirmación de cambio**: ¿Se requiere confirmación del usuario antes de cambiar de tenant si hay cambios sin guardar?

5. **Tenant por defecto**: Aunque RN-04 está fuera de alcance, ¿qué debe mostrarse inicialmente en el selector antes de implementar "ALL Tenants"?

6. **Manejo de errores**: ¿Qué mensaje específico debe mostrarse si falla la carga de la lista de tenants?

7. **Búsqueda en selector**: ¿El dropdown debe incluir funcionalidad de búsqueda si hay muchos tenants?

8. **Límite de tenants**: ¿Existe un límite máximo de tenants que puede tener un Solution Owner?

9. **Auditoría**: ¿Se debe registrar en audit log cada cambio de tenant realizado por el Solution Owner?

10. **Comportamiento en modales**: ¿Los modales deben mostrar también el indicador del tenant activo o solo el selector en el layout principal?