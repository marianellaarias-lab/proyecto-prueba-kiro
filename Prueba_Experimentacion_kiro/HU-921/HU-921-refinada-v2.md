# HU-921 - Historia de Usuario Refinada v2 (Post-Análisis Técnico)

## Contexto del Refinamiento
**Fuente**: Análisis técnico del TL y diagrama de flujo proporcionado por desarrollo  
**Razón**: La HU original era deficiente y no reflejaba la complejidad real del sistema

## Historia de Usuario Estructurada
**Como** Solution Owner  
**Quiero** poder seleccionar y visualizar toda la información de cualquier cliente/tenant (MCS, DEMO, nuevos clientes) y que el sistema adapte dinámicamente todas las secciones y comportamientos según el cliente y programa seleccionado  
**Para** tener una vista unificada y contextualizada de todos los clientes sin limitaciones de hardcodeo actual

## Definición de Campos Expandida

### Cliente/Tenant
- **Cliente**: Entidad principal (MCS, DEMO, nuevos clientes que se den de alta)
- **Tenant Name**: Identificador único del cliente
- **Programs**: Lista de programas específicos del cliente (Te Paga, OTC, Flexi, etc.)
- **Configuración específica**: Cada cliente tiene configuraciones únicas por programa

### Selector de Contexto
- **Lista de Clientes**: Sección donde se muestran todos los clientes disponibles
- **Selección Activa**: Cliente actualmente seleccionado que determina el contexto de toda la aplicación
- **Cambio de Contexto**: Capacidad de cambiar entre clientes y que toda la app se adapte

### Comportamientos Dinámicos por Programa
- **Categorías en Te Paga**: Los items tienen categoría (específico de Te Paga)
- **Sin Categorías en OTC**: Los items NO tienen categoría (específico de OTC)
- **Configuraciones Hardcodeadas**: Actualmente están fijas en código (problema a resolver)
- **Configuraciones Dinámicas**: Deben depender del cliente/programa seleccionado

### Arquitectura del Sistema
- **Contexto Global**: El cliente seleccionado afecta toda la aplicación
- **Secciones Dependientes**: Todas las secciones deben adaptarse al cliente seleccionado
- **Programas por Cliente**: Cada cliente tiene sus propios programas configurados

## Reglas de Negocio Expandidas

### RN1 - Control de Acceso Global
Solo usuarios con rol Solution Owner pueden acceder a la funcionalidad de selección de clientes y vista global de todos los tenants.

### RN2 - Listado Completo de Clientes
El sistema debe mostrar TODOS los clientes existentes (MCS, DEMO, y cualquier cliente nuevo que se dé de alta) en una sección dedicada para selección.

### RN3 - Selección de Contexto de Cliente
Al seleccionar un cliente, TODAS las secciones de la aplicación deben mostrar información específica y contextualizada de ese cliente seleccionado.

### RN4 - Programas Dinámicos por Cliente
Los programas disponibles (Te Paga, OTC, Flexi, etc.) deben estar asociados específicamente a cada cliente, eliminando el hardcodeo actual en el código.

### RN5 - Comportamientos Específicos por Programa
Cada programa debe tener comportamientos específicos (ej: Te Paga con categorías, OTC sin categorías) que se activen dinámicamente según el programa del cliente seleccionado.

### RN6 - Persistencia de Selección
La selección de cliente debe mantenerse durante toda la sesión del usuario hasta que explícitamente seleccione otro cliente.

### RN7 - Configuración No Hardcodeada
Todas las configuraciones específicas de cliente/programa deben ser dinámicas y configurables, no hardcodeadas en el código fuente.

## Escenarios Gherkin Expandidos

### Escenario 1: Acceso y visualización inicial de clientes
```gherkin
Given el usuario está autenticado con rol "Solution Owner"
When el usuario accede al sistema
Then debe ver una sección dedicada con la lista de todos los clientes disponibles
And debe mostrar los clientes "MCS", "DEMO" y cualquier cliente nuevo registrado
And debe permitir seleccionar cualquiera de los clientes listados
And no debe tener ningún cliente preseleccionado por defecto
```

### Escenario 2: Selección de cliente y cambio de contexto global
```gherkin
Given el usuario está en la vista de selección de clientes
And puede ver los clientes "MCS", "DEMO" y "ClienteNuevo"
When el usuario selecciona el cliente "MCS"
Then todas las secciones de la aplicación deben mostrar información específica de "MCS"
And los programas disponibles deben ser los configurados para "MCS"
And el contexto global de la aplicación debe cambiar a "MCS"
And debe mantener la selección visible en la interfaz
```

### Escenario 3: Programas específicos por cliente
```gherkin
Given el usuario ha seleccionado el cliente "MCS"
When el sistema carga los programas del cliente
Then debe mostrar los programas específicos configurados para "MCS" (ej: "Te Paga", "OTC", "Flexi")
And NO debe mostrar programas hardcodeados genéricos
And cada programa debe tener sus configuraciones específicas de "MCS"
```

### Escenario 4: Comportamientos dinámicos por programa - Te Paga con categorías
```gherkin
Given el usuario ha seleccionado el cliente "MCS"
And el cliente "MCS" tiene el programa "Te Paga" configurado
When el usuario navega a la sección de items del programa "Te Paga"
Then los items deben mostrar el campo "categoría"
And debe permitir filtrar y gestionar por categorías
And el comportamiento debe ser específico del programa "Te Paga"
```

### Escenario 5: Comportamientos dinámicos por programa - OTC sin categorías
```gherkin
Given el usuario ha seleccionado el cliente "MCS"
And el cliente "MCS" tiene el programa "OTC" configurado
When el usuario navega a la sección de items del programa "OTC"
Then los items NO deben mostrar el campo "categoría"
And NO debe mostrar opciones de filtrado por categorías
And el comportamiento debe ser específico del programa "OTC"
```

### Escenario 6: Cambio entre clientes con diferentes configuraciones
```gherkin
Given el usuario tiene seleccionado el cliente "MCS"
And está visualizando información específica de "MCS"
When el usuario cambia la selección al cliente "DEMO"
Then todas las secciones deben actualizarse con información de "DEMO"
And los programas disponibles deben cambiar a los de "DEMO"
And las configuraciones específicas deben ser las de "DEMO"
And debe limpiar cualquier filtro o estado específico de "MCS"
```

### Escenario 7: Cliente nuevo registrado dinámicamente
```gherkin
Given el sistema tiene los clientes "MCS" y "DEMO" registrados
When se registra un nuevo cliente "ClienteNuevo" en el sistema
And el usuario actualiza la vista de selección de clientes
Then debe aparecer "ClienteNuevo" en la lista de clientes disponibles
And debe permitir seleccionar "ClienteNuevo"
And debe cargar las configuraciones específicas de "ClienteNuevo"
```

### Escenario 8: Persistencia de selección durante la sesión
```gherkin
Given el usuario ha seleccionado el cliente "MCS"
And ha navegado por diferentes secciones de la aplicación
When el usuario navega a una nueva sección
Then debe mantener el contexto del cliente "MCS" seleccionado
And todas las nuevas secciones deben mostrar información de "MCS"
And no debe requerir reseleccionar el cliente
```

### Escenario 9: Validación de configuraciones no hardcodeadas
```gherkin
Given el usuario selecciona el cliente "MCS"
When el sistema carga las configuraciones del cliente
Then todas las configuraciones deben provenir de la base de datos o configuración dinámica
And NO debe usar valores hardcodeados en el código
And debe permitir modificar configuraciones sin cambios de código
```

### Escenario 10: Manejo de cliente sin programas configurados
```gherkin
Given existe un cliente "ClienteSinProgramas" sin programas asociados
When el usuario selecciona "ClienteSinProgramas"
Then debe mostrar el mensaje "Este cliente no tiene programas configurados"
And debe permitir navegar a configuración de programas
And no debe mostrar secciones dependientes de programas
```

## Análisis del Diagrama de Flujo

### Componentes Identificados en el Diagrama:
1. **Login/Owner**: Punto de entrada con validación de rol
2. **Selector de Cliente**: Lista de clientes disponibles
3. **Programas por Cliente**: OTC, Te Paga, Flexi (dinámicos según cliente)
4. **Secciones Dependientes**: Todas las áreas que cambian según selección
5. **Configuraciones Específicas**: Comportamientos únicos por programa
6. **Validaciones de Contexto**: Verificaciones de permisos y configuraciones

### Flujos Críticos Identificados:
- **Flujo de Selección**: Login → Lista Clientes → Selección → Carga Contexto
- **Flujo de Cambio**: Cliente A → Cambio → Cliente B → Actualización Global
- **Flujo de Configuración**: Cliente → Programas → Comportamientos Específicos

## Preguntas Críticas para el Product Owner

### Sobre Arquitectura y Alcance:
1. **Migración de Hardcodeo**: ¿Cuál es la prioridad para eliminar todas las configuraciones hardcodeadas existentes? ¿Se hace en esta HU o se divide?

2. **Configuraciones por Programa**: ¿Qué configuraciones específicas además de "categorías" varían entre programas? (validaciones, campos, flujos, etc.)

3. **Nuevos Clientes**: ¿Cómo se registran nuevos clientes? ¿Hay un proceso de onboarding que debe considerarse?

4. **Configuración de Programas**: ¿Quién y cómo se configuran los programas para cada cliente? ¿Hay una interfaz de administración?

### Sobre Comportamientos Específicos:
5. **Diferencias entre Programas**: Además de categorías en Te Paga vs OTC, ¿qué otras diferencias funcionales existen entre programas?

6. **Validaciones Dinámicas**: ¿Las validaciones de campos también cambian según el programa/cliente?

7. **Flujos de Trabajo**: ¿Los flujos de aprobación o procesamiento varían según cliente/programa?

### Sobre UX/UI:
8. **Selector de Cliente**: ¿Dónde exactamente debe ubicarse el selector de cliente en la interfaz? ¿Siempre visible o en sección específica?

9. **Indicador de Contexto**: ¿Cómo debe indicarse visualmente qué cliente está seleccionado en cada momento?

10. **Cambio de Contexto**: ¿Debe haber confirmación al cambiar de cliente si hay trabajo en progreso?

### Sobre Rendimiento y Datos:
11. **Volumen de Datos**: ¿Cuántos clientes se esperan manejar? ¿Hay límites de rendimiento a considerar?

12. **Carga de Datos**: ¿Se cargan todos los datos del cliente al seleccionarlo o se cargan bajo demanda por sección?

## Impacto Técnico Identificado

### Cambios Arquitectónicos Necesarios:
- **Eliminación de Hardcodeo**: Refactoring masivo de configuraciones fijas
- **Contexto Global**: Implementación de estado global de cliente seleccionado
- **Configuración Dinámica**: Sistema de configuraciones por cliente/programa
- **Validaciones Dinámicas**: Sistema de reglas configurables por programa

### Áreas de Código Afectadas:
- **Todas las secciones**: Deben ser conscientes del contexto de cliente
- **Validaciones**: Deben ser dinámicas según programa
- **Configuraciones**: Migración de hardcodeo a configuración dinámica
- **Permisos**: Integración con RBAC existente

## Recomendación de División de HU

Basándome en el análisis, recomiendo dividir en:

### HU-921A: Selector de Cliente y Contexto Global
- Implementar selector de clientes
- Cambio de contexto global
- Persistencia de selección

### HU-921B: Programas Dinámicos por Cliente
- Configuración de programas por cliente
- Eliminación de hardcodeo de programas
- Carga dinámica de programas

### HU-921C: Comportamientos Específicos por Programa
- Implementar diferencias entre Te Paga/OTC/Flexi
- Validaciones dinámicas
- Configuraciones específicas por programa