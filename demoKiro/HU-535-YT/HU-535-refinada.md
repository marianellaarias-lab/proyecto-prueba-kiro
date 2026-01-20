# USER STORY 535F2.2.1 - Merchant Section Create Merchant (REFINADA)

## Historia de Usuario
**Como** usuario con permisos para gestionar Merchants  
**Quiero** abrir un modal de "Create/New Merchant"  
**Para** registrar un nuevo Merchant con todos los datos requeridos, asociado al Parent Company correspondiente  

## Definición de Campos

### Campos Obligatorios
- **Merchant Name**: Input text, alfanumérico, 3-80 caracteres
- **Merchant ID**: Input numérico, 1-20 dígitos, único
- **Parent Company**: Requerido, autopoblado y bloqueado si viene desde contexto de Parent Company
- **MCC**: Dropdown con búsqueda parcial
- **Program(s)**: Al menos 1 programa debe ser seleccionado
- **City**: Dropdown

### Campos Opcionales
- **Description**: Input text, máximo 120 caracteres
- **Te Paga Benefit**: Si se selecciona, requiere escoger una categoría (dropdown)
- **OTC**: Dropdown con opciones "Eligible", "Not Eligible"
- **Address Line 1**: Alfanumérico, máximo 60 caracteres
- **Address Line 2**: Alfanumérico, máximo 60 caracteres
- **Zip Code**: Numérico, exactamente 5 caracteres

## Reglas de Negocio

### RN001 - Control de Acceso
- Manager: permitido
- Analyst 805/806: permitido
- Analyst 807: permitido (no puede modificar la categoría de Te Paga)
- Usuarios fuera de estos roles: no deben ver ni usar la acción de creación

### RN002 - Puntos de Acceso
- Se puede crear desde Tab Merchants dentro de un Parent Company
- Se puede crear desde Tab Parent Company al finalizar la creación de un Parent Company

### RN003 - Validaciones de Campos
- Merchant ID es único, no se debe permitir crear un Merchant si ya existe otro con el mismo número
- Campos mandatorios deben ser completados antes de permitir guardar la data y crear el merchant
- Al menos 1 de los 2 programas es escogido
- Si se escoge TePaga es requerido escoger una categoría

### RN004 - Comportamientos de UI
- Dropdowns (MCC) con búsqueda parcial case-insensitive
- Botón "X" en inputs/dropdowns seleccionados para limpiar el contenido con un clic y mantener el foco
- Botones: Create (primary, activo solo si válido) y Cancel (presentado como X)

### RN005 - Comportamiento Post-Creación
- Al crear exitosamente: el nuevo merchant aparece en el listado, queda seleccionado, y se abre el panel lateral de detalles del merchant creado
- Toast/Alert éxito (verde): "Merchant Created"
- Audit Log de creación (usuario, timestamp, campos clave)

### RN006 - Validación Asíncrona
- Merchant ID tiene validación asíncrona de duplicados
- Debe presentar mensaje de error si ya existe

## Escenarios de Aceptación

### Escenario 1: Creación exitosa de Merchant desde Tab Merchants
```gherkin
Given el usuario tiene rol Manager
And está en el Tab Merchants dentro de un Parent Company
When abre el modal "Create/New Merchant"
And completa todos los campos obligatorios con datos válidos
And selecciona al menos 1 programa
And hace clic en "Create"
Then el merchant se crea exitosamente
And aparece el toast "Merchant Created"
And el nuevo merchant aparece en el listado
And queda seleccionado
And se abre el panel lateral de detalles del merchant creado
And se registra en Audit Log con usuario, timestamp y campos clave
```

### Escenario 2: Creación exitosa desde Tab Parent Company
```gherkin
Given el usuario tiene rol Analyst 805/806
And está en el Tab Parent Company al finalizar la creación de un Parent Company
When abre el modal "Create/New Merchant"
And el campo Parent Company está autopoblado y bloqueado
And completa todos los campos obligatorios con datos válidos
And selecciona al menos 1 programa
And hace clic en "Create"
Then el merchant se crea exitosamente
And aparece el toast "Merchant Created"
And el nuevo merchant aparece en el listado
And queda seleccionado
And se abre el panel lateral de detalles del merchant creado
And se registra en Audit Log con usuario, timestamp y campos clave
```

### Escenario 3: Error por Merchant ID duplicado
```gherkin
Given el usuario tiene permisos para gestionar Merchants
And existe un merchant con ID "12345"
When abre el modal "Create/New Merchant"
And ingresa Merchant ID "12345"
Then se ejecuta validación asíncrona de duplicados
And se presenta mensaje de error indicando que el Merchant ID ya existe
And el botón "Create" permanece inactivo
```

### Escenario 4: Error por campos obligatorios faltantes
```gherkin
Given el usuario tiene permisos para gestionar Merchants
When abre el modal "Create/New Merchant"
And deja campos obligatorios sin completar
Then el botón "Create" permanece inactivo
And no se permite guardar la data
```

### Escenario 5: Error por no seleccionar programas
```gherkin
Given el usuario tiene permisos para gestionar Merchants
When abre el modal "Create/New Merchant"
And completa todos los campos obligatorios
But no selecciona ningún programa
Then el botón "Create" permanece inactivo
And no se permite crear el merchant
```

### Escenario 6: Error por Te Paga sin categoría
```gherkin
Given el usuario tiene permisos para gestionar Merchants
When abre el modal "Create/New Merchant"
And selecciona Te Paga Benefit
But no escoge una categoría
Then el botón "Create" permanece inactivo
And no se permite crear el merchant
```

### Escenario 7: Usuario sin permisos no puede acceder
```gherkin
Given el usuario no tiene rol Manager, Analyst 805/806, ni Analyst 807
When intenta acceder a la funcionalidad de creación de Merchants
Then no debe ver la acción de creación
And no puede usar la funcionalidad
```

### Escenario 8: Analyst 807 con restricción en Te Paga
```gherkin
Given el usuario tiene rol Analyst 807
When abre el modal "Create/New Merchant"
And intenta modificar la categoría de Te Paga
Then no puede modificar la categoría de Te Paga
```

### Escenario 9: Funcionalidad de limpieza con botón X
```gherkin
Given el usuario está en el modal "Create/New Merchant"
When completa un campo con botón "X"
And hace clic en el botón "X"
Then el contenido del campo se limpia con un clic
And se mantiene el foco en el campo
```

### Escenario 10: Búsqueda parcial en dropdown MCC
```gherkin
Given el usuario está en el modal "Create/New Merchant"
When hace clic en el dropdown MCC
And escribe texto parcial
Then se muestran opciones que coinciden case-insensitive
And puede seleccionar una opción de la búsqueda
```

### Escenario 11: Cancelación de creación
```gherkin
Given el usuario está en el modal "Create/New Merchant"
When hace clic en Cancel (X)
Then el modal se cierra
And no se guarda ninguna información
```

## Impactos Técnicos
- Modal de creación con validaciones en tiempo real
- Validación asíncrona para Merchant ID
- Integración con sistema de permisos por roles
- Audit Log para trazabilidad
- Búsqueda parcial en dropdowns

## Tags
Merchant, Create, Modal, Permissions, Validation

---

## PREGUNTAS PARA EL PRODUCT OWNER

### Validaciones y Campos
1. **¿Qué caracteres específicos están permitidos en el campo alfanumérico de Merchant Name?** (letras, números, espacios, caracteres especiales)
2. **¿Cuál es el comportamiento esperado si el Merchant ID ingresado tiene menos de 1 dígito o más de 20?**
3. **¿Qué opciones específicas contiene el dropdown de City?**
4. **¿Cuáles son las categorías específicas disponibles para Te Paga Benefit?**
5. **¿Cuáles son los 2 programas específicos que se pueden seleccionar?**

### Permisos y Roles
6. **¿Qué significa exactamente "no puede modificar la categoría de Te Paga" para Analyst 807?** (¿puede ver pero no cambiar, o no puede acceder?)
7. **¿Existen otros roles además de los mencionados que deberían tener acceso?**

### Comportamiento de UI
8. **¿Cuál es el mensaje de error específico cuando el Merchant ID ya existe?**
9. **¿Cuáles son los mensajes de error específicos para cada campo obligatorio faltante?**
10. **¿Qué información específica se debe mostrar en el panel lateral de detalles del merchant creado?**

### Validación Asíncrona
11. **¿Cuándo se ejecuta exactamente la validación asíncrona del Merchant ID?** (al escribir, al salir del campo, al hacer clic en Create)
12. **¿Qué sucede si la validación asíncrona falla por problemas de conectividad?**

### Audit Log
13. **¿Qué campos específicos se consideran "campos clave" para el Audit Log?**
14. **¿En qué formato se debe registrar el timestamp en el Audit Log?**

### Parent Company
15. **¿Qué sucede si no hay Parent Company en el contexto cuando se accede desde Tab Merchants?**
16. **¿El campo Parent Company bloqueado puede ser modificado de alguna manera por algún rol específico?**