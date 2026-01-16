# USER STORY - TENANT SELECTOR - ORIGINAL

Como Solution Owner (único rol con acceso al selector de tenants)
Quiero poder visualizar toda la información de la solución filtrada exclusivamente por el tenant seleccionado
Para garantizar aislamiento, control operacional y visibilidad precisa de la data según el tenant activo.

---

## Definición de Campos

### Tenant Selector (solo Solution Owner)
· tenant_id (string, 36)
· tenant_name (string, 100)
· type: Dropdown ordenado alfabéticamente, siempre visible.

### Program Selector (todos los demás roles)
(Funcionalidad existente no afectada)
· program_id (string)
· program_name (string)
· Selector se mantiene exactamente como funciona hoy día.

### Contexto del Tenant
· active_tenant: Tenant actualmente seleccionado.
· indicator: Despliegue visible del tenant activo.

---

## ⚙️ Reglas de Negocio (RN)

### RN-01: Acceso exclusivo al selector de tenants
1. Solo el Solution Owner puede ver, seleccionar o cambiar el tenant activo.
2. Usuarios con roles diferentes al Solution Owner:
   o NO ven el selector de tenants.
   o SÍ continúan usando el selector de programas existente, sin cambios.
3. Intentos de acceso al selector de tenants por roles no autorizados → 403 Forbidden.

---

### RN-02: Selector de tenant siempre visible (solo Solution Owner)
1. El selector debe estar siempre visible en una posición fija en el layout.
2. Debe reflejar el tenant activo en todo momento.
3. No puede ocultarse en pantallas, modales o navegación interna.

---

### RN-03: Orden alfabético del selector de tenants
1. Todos los tenants deben aparecer en orden A-Z.
2. Sin importar idioma o configuración regional.
3. No se permite orden manual ni configuración por usuario.

---

### RN-04: Selección inicial (otra HU)
(Documentado aquí, pero implementado en una historia separada)
1. Por defecto, al entrar a la solución debe aparecer ALL Tenants.
2. "ALL Tenants" funciona como opción neutral antes de seleccionar un tenant específico.

---

### RN-05: Aplicación global del tenant (cuando Solution Owner lo usa)
1. Toda data en vistas, listados, formularios y reportes debe corresponder al tenant activo.
2. No pueden aparecer datos de otros tenants.
3. Backend debe aplicar tenant_id en todas las operaciones.

---

### RN-06: Cambio de tenant
1. Al cambiar el tenant, toda la vista debe refrescarse inmediatamente.
2. Debe reiniciarse paginación, filtros, ordenación y cualquier estado.
3. No debe quedar rastro de data del tenant previo.

---

### RN-07: Indicador del tenant activo
1. Debe ser visible en todas las pantallas.
2. Debe actualizarse inmediatamente al cambiar el tenant.
3. No puede ocultarse en navegación secundaria.

---

### RN-08: Aislamiento y seguridad
1. Acceso a datos que no pertenecen al tenant activo → 403/404.
2. Backend debe validar tenant en todos los endpoints.
3. No deben cargarse recursos no permitidos por tenant.

---

### RN-09: Roles distintos a Solution Owner
1. Los roles diferentes al Solution Owner mantienen su selector de programas tal como funciona hoy día.
2. El selector de programas permanece sin cambios, flujos o reglas adicionales.
3. Dichos roles no pueden seleccionar tenants ni visualizar información multi-tenant.

---

## Escenarios Gherkin

### Escenario 1: Solo Solution Owner ve el selector de tenants
Given que soy Solution Owner
Then debo ver el selector de tenants
Given que soy otro rol
Then NO debo ver el selector de tenants
And debo ver únicamente el selector de programas actual

---

### Escenario 2: Selector siempre visible
Given que soy Solution Owner
When navego entre pantallas
Then debo ver el selector de tenants en la misma posición

---

### Escenario 3: Orden alfabético
Given que tengo múltiples tenants
When abro el selector
Then debo ver la lista ordenada alfabéticamente

---

### Escenario 4: Selector mostrando el tenant activo
Given que seleccioné un tenant
When navego entre módulos
Then el selector debe mostrar consistentemente el tenant activo

---

### Escenario 5: Roles que no son Solution Owner usan selector actual
Given que soy un rol distinto a Solution Owner
Then debo ver el selector de programas funcional
And NO debo ver el selector de tenants