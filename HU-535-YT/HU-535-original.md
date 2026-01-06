# USER STORY 535F2.2.1 | Merchant Section | Merchants Tab | Create Merchant

Como usuario con permisos para gestionar Merchants
Quiero abrir un modal de "Create/New Merchant"
Para registrar un nuevo Merchant con todos los datos requeridos, asociado al Parent Company correspondiente

## Criterios de Aceptación:

### Personas y Permisos
- Manager (permitido)
- Analyst 805/806 (permitido)
- Analyst 807 (permitido) (no puede modificar la categoría de Te Paga)
- Usuarios fuera de estos roles: no deben ver ni usar la acción de creación.

### Se puede crear desde:
- Tab Merchants dentro de un Parent Company
- Tab Parent Company al finalizar la creación de un Parent Company

### Campos del modal "Create/New Merchant":
- Merchant Name (input text, requerido, alfanumérico 3–80) con botón "X" para limpiar. Ya existe en Prod MANDATORIO
- Merchant ID (input numérico, requerido, 1–20 dígitos, único) con "X" para limpiar (validación asíncrona de duplicados). Ya existe en Prod MANDATORIO
- Description (input text, opcional, ≤120) con "X" para limpiar.
- Parent Company (requerido; autopoblado y bloqueado si viene desde el contexto de un Parent Company).
- MCC (dropdown con búsqueda parcial, requerido). Ya existe en Prod
- Program(s) Se escoge al menos 1 para poder crear el Merchant
- Te Paga Benefit: si se selecciona, se hace escogiendo una categoría que está dentro del campo estilo dropdown
- OTC dropdown Opciones: Eligible, Not Eligible
- Address: Field: line 1 Optional type: Alfanumérico Max 60 caracteres
- Address: Field: line 2 Optional type: Alfanumérico Max 60 caracteres
- City Dropdown (as of today) Mandatorio
- Zip Code Input Type: Numérico Exactamente 5 caracteres Optional

### Comportamientos clave de UI
- Dropdowns (MCC) con búsqueda parcial case-insensitive.
- Botón "X" en inputs/dropdowns seleccionados para limpiar el contenido con un clic y mantener el foco.
- Botones: Create (primary, activo solo si válido) y Cancel (Presentado como X).
- Toast/Alert éxito (verde): "Merchant Created".

### Al crear exitosamente:
- El nuevo merchant aparece en el listado,
- queda seleccionado,
- y se abre el panel lateral de detalles del merchant creado.
- Audit Log de creación (usuario, timestamp, campos clave).

### Validaciones:
- Merchant ID (número de Merchant) es único, no se debe permitir crear un Merchant si ya existe otro con el mismo número. (ya existe en Prod). Debe presentar mensaje de error.
- Campos mandatorios deben ser completados antes de permitir guardar la data y crear el merchant
- Al menos 1 de los 2 programas es escogido
- si se escoge TePaga es requerido escoger una categoría.