# HU-921 - Historia de Usuario Refinada

## Historia de Usuario Estructurada
**Como** Solution Owner  
**Quiero** poder ver todos los tenants configurados en la solución dentro del portal, incluyendo sus datos principales  
**Para** poder navegar, filtrar, validar y administrar la configuración y los programas de cada tenant de forma centralizada

## Definición de Campos

### Tenant
- **Tenant Name**: Nombre identificador único del tenant
- **Programs**: Lista de programas asociados al tenant (ej.: OTC, Te Paga, Classicare)

### Vista Dashboard
- **Tenant Management Dashboard**: Vista global que muestra todos los tenants
- **Filtro por Tenant Name**: Funcionalidad de búsqueda/filtrado por nombre de tenant
- **Navegación entre programas**: Capacidad de seleccionar y ver datos específicos de cada programa

### Roles y Permisos
- **Solution Owner**: Rol con acceso exclusivo a la vista de gestión de tenants
- **RBAC**: Control de acceso basado en roles

## Reglas de Negocio

### RN1 - Control de Acceso
Solo usuarios con rol Solution Owner pueden acceder a la vista Tenant Management Dashboard.

### RN2 - Visualización de Tenants
El dashboard debe mostrar todos los tenants existentes en la solución con sus datos base (Tenant Name y Programs).

### RN3 - Filtrado
Debe existir funcionalidad de filtro por Tenant Name para localizar tenants específicos.

### RN4 - Navegación entre Programas
Para tenants con múltiples programas, el sistema debe permitir navegar entre ellos y mostrar los datos correspondientes a cada programa seleccionado.

### RN5 - Rendimiento
La carga inicial del dashboard debe completarse en menos de 2 segundos para hasta 200 tenants.

## Escenarios Gherkin

### Escenario 1: Acceso exitoso con rol Solution Owner
```gherkin
Given el usuario está autenticado en el portal
And el usuario tiene asignado el rol "Solution Owner"
When el usuario accede a la vista Tenant Management Dashboard
Then el sistema debe mostrar la vista con todos los tenants disponibles
And debe mostrar los campos "Tenant Name" y "Programs" para cada tenant
```

### Escenario 2: Acceso denegado sin rol Solution Owner
```gherkin
Given el usuario está autenticado en el portal
And el usuario NO tiene asignado el rol "Solution Owner"
When el usuario intenta acceder a la vista Tenant Management Dashboard
Then el sistema debe denegar el acceso
And debe mostrar un mensaje de "Acceso no autorizado"
```

### Escenario 3: Visualización completa de tenants
```gherkin
Given el usuario es Solution Owner y está en el dashboard
And existen tenants configurados en la solución
When la vista se carga completamente
Then debe mostrar una lista con todos los tenants existentes
And cada tenant debe mostrar su "Tenant Name"
And cada tenant debe mostrar sus "Programs" asociados
```

### Escenario 4: Filtrado por nombre de tenant
```gherkin
Given el usuario está en la vista Tenant Management Dashboard
And existen múltiples tenants en la lista
When el usuario aplica un filtro por "Tenant Name" con valor "MCS"
Then el sistema debe mostrar únicamente los tenants que coincidan con "MCS"
And debe ocultar los tenants que no coincidan con el filtro
```

### Escenario 5: Navegación entre programas de un tenant
```gherkin
Given el usuario está visualizando un tenant con múltiples programas
And el tenant "MCS" tiene programas "OTC 807", "Classicare 805/806" y "Te Paga"
When el usuario selecciona el programa "OTC 807"
Then el sistema debe cargar y mostrar todos los datos correspondientes al programa "OTC 807"
And debe mantener la navegabilidad hacia los otros programas del tenant
```

### Escenario 6: Tenant con un solo programa
```gherkin
Given el usuario está visualizando un tenant con un solo programa
When el usuario selecciona el tenant
Then el sistema debe mostrar directamente los datos del programa único
And no debe mostrar opciones de navegación entre programas
```

### Escenario 7: Rendimiento de carga inicial
```gherkin
Given existen hasta 200 tenants configurados en la solución
When el usuario Solution Owner accede al dashboard
Then la vista debe cargar completamente en menos de 2 segundos
And debe mostrar todos los tenants con sus datos base
```

## Preguntas para el Product Owner

1. **Datos adicionales del tenant**: ¿Además de Tenant Name y Programs, qué otros datos del tenant deben mostrarse en la vista principal (ej.: fecha de creación, estado, contacto responsable)?

2. **Comportamiento del filtro**: ¿El filtro por Tenant Name debe ser de búsqueda exacta, parcial, o ambas opciones?

3. **Paginación**: ¿Se requiere paginación para la lista de tenants? ¿Cuántos tenants por página?

4. **Ordenamiento**: ¿Los tenants deben mostrarse en algún orden específico (alfabético, por fecha, etc.)?

5. **Datos del programa**: ¿Qué información específica de cada programa debe mostrarse al navegar entre ellos?

6. **Acciones disponibles**: ¿Qué acciones puede realizar el Solution Owner sobre los tenants desde esta vista (editar, eliminar, crear nuevo)?

7. **Estados del tenant**: ¿Los tenants pueden tener diferentes estados (activo, inactivo, suspendido) que deban reflejarse en la vista?

8. **Notificaciones**: ¿Se requieren notificaciones o alertas para tenants con configuraciones incompletas o problemas?

9. **Exportación**: ¿Se necesita funcionalidad para exportar la lista de tenants y sus datos?

10. **Actualización en tiempo real**: ¿La vista debe actualizarse automáticamente si se agregan/modifican tenants, o requiere refresh manual?