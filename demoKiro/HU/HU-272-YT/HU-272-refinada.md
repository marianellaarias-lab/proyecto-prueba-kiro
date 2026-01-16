# USER STORY 272 - REFINADA

## Historia de Usuario
**Como** Manager o Analyst Classicare 805/806, Analyst 807 (OTC)  
**Quiero** crear una Parent Company con un ID autogenerado  
**Para** mantener un catálogo gobernado y auditable

## Definición de Campos

### Campos Obligatorios
- **parent_company_name**: Nombre de la compañía (mínimo 3 caracteres, único case/acento-insensible)
- **email_address**: Correo electrónico (con validación de formato)
- **phone_number**: Número telefónico

### Campos Opcionales
- **Description**: Descripción (máximo 500 caracteres)

### Campos del Sistema
- **ParentCompanyID**: Generado automáticamente (único, inmutable, no editable, no visible en UI)
  - Formato ejemplo: HC01-0001
- **Estado**: Active por defecto (para trazabilidad futura)

### Elementos de UI
- **Botón Create Parent Company**: Ubicado en parte superior derecha del listado
- **Formulario**: Modal/página para captura de datos
- **Banner de éxito**: Con opciones "Dismiss" y "Create Merchants"

## Reglas de Negocio

### RN-01: Acceso y Navegación
1. El botón "Create Parent Company" debe estar en la parte superior derecha del listado
2. Al hacer clic debe abrir el formulario de creación

### RN-02: Generación de ID
1. El ParentCompanyID debe generarse automáticamente por el sistema
2. Debe ser único e inmutable
3. NO debe ser editable por el usuario
4. NO debe ser visible en la interfaz de usuario
5. Formato ejemplo: HC01-0001

### RN-03: Validaciones de Campos Obligatorios
1. parent_company_name debe tener mínimo 3 caracteres
2. email_address debe tener formato válido de email
3. phone_number es obligatorio (formato no especificado)

### RN-04: Validaciones de Campos Opcionales
1. Description tiene máximo 500 caracteres
2. Si no se proporciona, debe permitir valor vacío

### RN-05: Unicidad del Nombre
1. company_name debe ser único en el sistema
2. La validación debe ser case-insensitive (insensible a mayúsculas)
3. La validación debe ser acento-insensitive (insensible a acentos)
4. Se permiten caracteres especiales en el nombre

### RN-06: Activación del Botón Create
1. El botón "Create" solo se activa cuando TODOS los campos requeridos están completados
2. Debe permanecer deshabilitado mientras falten campos obligatorios

### RN-07: Flujo Post-Creación
1. Una vez creado exitosamente, debe mostrar mensaje: "Parent Company Created. You can start creating new merchants to add to this company"
2. Debe presentar dos opciones: "Dismiss" y "Create Merchants"
3. Si selecciona "Create Merchants": abrir modal de New Merchants
4. Si selecciona "Dismiss": cerrar el banner
5. Si navega fuera de la sección: el banner debe desaparecer automáticamente

### RN-08: Estado por Defecto
1. Todo Parent Company creado debe tener estado "Active" por defecto

### RN-09: Permisos de Creación
1. Manager: Puede crear Parent Companies
2. Analyst 805/806: Puede crear Parent Companies
3. Analyst 807 (OTC): Puede crear Parent Companies

### RN-10: Auditoría
1. Registrar en Audit Log la acción de create
2. Incluir información: who (quién), when (cuándo), after (datos creados)

## Escenarios Gherkin

### Escenario 1: Acceso al formulario de creación
```gherkin
Given que el usuario tiene permisos de creación de Parent Company
And se encuentra en el listado de Parent Companies
When selecciona el botón "Create Parent Company" en la parte superior derecha
Then se debería abrir el formulario de creación de Parent Company
And se deberían ver los campos: parent_company_name, email_address, phone_number, description
And el botón "Create" debería estar deshabilitado
```

### Escenario 2: Validación de campos obligatorios - Botón deshabilitado
```gherkin
Given que el usuario está en el formulario de creación de Parent Company
When no ha completado todos los campos obligatorios
Then el botón "Create" debería permanecer deshabilitado
```

### Escenario 3: Validación de campos obligatorios - Botón habilitado
```gherkin
Given que el usuario está en el formulario de creación de Parent Company
When completa parent_company_name con "Test Company"
And completa email_address con "test@company.com"
And completa phone_number con "1234567890"
Then el botón "Create" debería habilitarse
```

### Escenario 4: Creación exitosa de Parent Company
```gherkin
Given que el usuario ha completado todos los campos obligatorios correctamente
And el company_name "New Company" no existe en el sistema
When selecciona el botón "Create"
Then se debería crear el Parent Company exitosamente
And se debería generar un ParentCompanyID único automáticamente
And el estado debería establecerse como "Active"
And se debería mostrar el mensaje "Parent Company Created. You can start creating new merchants to add to this company"
And se deberían ver las opciones "Dismiss" y "Create Merchants"
```

### Escenario 5: Validación de longitud mínima del nombre
```gherkin
Given que el usuario está en el formulario de creación
When ingresa "AB" en el campo parent_company_name
Then se debería mostrar un mensaje de error indicando mínimo 3 caracteres
And el botón "Create" debería permanecer deshabilitado
```

### Escenario 6: Validación de formato de email
```gherkin
Given que el usuario está en el formulario de creación
When ingresa "email-invalido" en el campo email_address
Then se debería mostrar un mensaje de error de formato inválido
And el botón "Create" debería permanecer deshabilitado
```

### Escenario 7: Validación de unicidad case-insensitive
```gherkin
Given que existe un Parent Company con nombre "Test Company"
When el usuario intenta crear un Parent Company con nombre "TEST COMPANY"
Then se debería mostrar un mensaje de error de nombre duplicado
And no se debería permitir la creación
```

### Escenario 8: Validación de unicidad acento-insensitive
```gherkin
Given que existe un Parent Company con nombre "Café Martínez"
When el usuario intenta crear un Parent Company con nombre "Cafe Martinez"
Then se debería mostrar un mensaje de error de nombre duplicado
And no se debería permitir la creación
```

### Escenario 9: Validación de longitud máxima de descripción
```gherkin
Given que el usuario está en el formulario de creación
When ingresa más de 500 caracteres en el campo description
Then se debería mostrar un mensaje de error de longitud máxima excedida
And no se debería permitir continuar
```

### Escenario 10: Flujo post-creación - Seleccionar Create Merchants
```gherkin
Given que se ha creado exitosamente un Parent Company
And se muestra el banner de éxito con opciones
When el usuario selecciona "Create Merchants"
Then se debería abrir el modal de New Merchants
And el banner debería permanecer visible
```

### Escenario 11: Flujo post-creación - Seleccionar Dismiss
```gherkin
Given que se ha creado exitosamente un Parent Company
And se muestra el banner de éxito con opciones
When el usuario selecciona "Dismiss"
Then el banner debería cerrarse
And debería regresar al listado de Parent Companies
```

### Escenario 12: Flujo post-creación - Navegación fuera de sección
```gherkin
Given que se ha creado exitosamente un Parent Company
And se muestra el banner de éxito
When el usuario navega fuera de la sección de Parent Companies
Then el banner debería desaparecer automáticamente
```

## Preguntas para el Product Owner

1. **Formato de phone_number**: ¿Existe alguna validación específica para el formato del número telefónico (internacional, nacional, solo dígitos, longitud)?

2. **Caracteres especiales en nombre**: ¿Hay alguna lista específica de caracteres especiales permitidos/prohibidos en company_name?

3. **Formato del ParentCompanyID**: ¿El formato HC01-0001 es fijo? ¿Qué representa "HC01" y cómo se genera la secuencia numérica?

4. **Validación de email**: ¿Solo se valida el formato o también se verifica que el dominio exista?

5. **Mensaje de error de unicidad**: ¿El mensaje de error debe ser específico o genérico cuando el nombre ya existe?

6. **Cancelación del formulario**: ¿Hay un botón "Cancel" explícito? ¿Qué sucede si el usuario cierra el formulario sin guardar?

7. **Campo description vacío**: ¿Se permite guardar con description completamente vacío o debe tener al menos un carácter si se completa?

8. **Comportamiento del banner**: ¿El banner de éxito tiene un tiempo de auto-cierre o permanece hasta que el usuario interactúe?

9. **Integración con modal Merchants**: ¿El modal de "Create Merchants" debe pre-llenar automáticamente el Parent Company recién creado?

10. **Validación en tiempo real**: ¿Las validaciones de campos se muestran mientras el usuario escribe o al intentar enviar el formulario?