# HU-921 - Historia de Usuario Original

## Historia de Usuario
Como Solution Owner
Quiero poder ver todos los tenants configurados en la solución dentro del portal, incluyendo sus datos principales
Para poder navegar, filtrar, validar y administrar la configuración y los programas de cada tenant de forma centralizada

## Descripción funcional
Al autenticarse con el rol Solution Owner, el usuario debe acceder a una vista global tipo "Tenant Management Dashboard".

El portal debe mostrar todos los tenants existentes dentro de la solución.

Cada tenant debe mostrar al menos sus datos base:
- Tenant Name
- Programas asociados (ej.: OTC, Te Paga)

Debe existir un filtro por Tenant Name.

Cuando un tenant tiene más de un programa (ej. MCS), el portal debe permitir navegar entre los programas Al navegar dentro del portal debe presentar toda la data correspondiente.

El comportamiento de permisos debe respetar RBAC: Solo Solution Owner puede ver esta vista.

## ✅ Acceptance Criteria (AC)

### AC1 – Acceso exclusivo por rol
Dado que el usuario está autenticado
Y tiene el rol Solution Owner
Entonces el portal debe permitirle acceder a la vista de Todos los Tenants
Y si el usuario NO tiene ese rol, la vista NO debe ser accesible.

### AC2 – Visualización de todos los tenants
Dado que el usuario es Solution Owner
Cuando entra al módulo
Entonces debe ver una lista con todos los tenants disponibles dentro de la solución
Mostrando los campos:
- Tenant Name
- Programs

### AC3 – Filtro por tenant
Dado que el Solution Owner está en la vista
Cuando se selecciona un Tenant
Entonces debe filtrar resultados solo para ese Tenant

### AC4 – Navegación entre programas
Dado un tenant con múltiples programas (ej. MCS: OTC 807, Classicare 805/806, Te Paga)
Cuando el usuario selecciona el tenant
Entonces debe poder filtrar si desea entre los programas Y cada programa debe cargar todos sus datos

## 🟩 Definition of Ready (DoR)

Para que este User Story entre a desarrollo, debe cumplir con lo siguiente:

### 1. Criterios funcionales definidos
- Todos los Acceptance Criteria están completos y aprobados.
- Se definió claramente qué datos del tenant deben mostrarse.
- Se definió el comportamiento del filtro 
- Se definió el comportamiento de navegación entre programas.

### 2. Diseño UI/UX
- Mockups de la vista multitenant entregados por UX:
  - Lista de tenants
  - Tabs o dropdown para programas
- Validación con Solution Owner completada.

### 3. Acceso y seguridad
- Está documentado el rol Solution Owner y su permiso para acceder a la vista.
- Está confirmada la regla de acceso único para este rol.

### 4. Criterios no funcionales
- Rendimiento: carga inicial < 2s para hasta 200 tenants.
- Cumple con design system del portal.

### 6. Consideraciones de QA
Casos de prueba identificados:
- Tenant con 1 programa
- Tenant con múltiples programas
- Validación RBAC
- Filtro por tenant