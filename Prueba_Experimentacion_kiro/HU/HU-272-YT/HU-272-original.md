# USER STORY 272 - ORIGINAL

USER STORY 272
F2.1.1 | Merchant Section | Parent Company Tab | Create Parent Company

Como Manager o Analyst Classicare 805/806, Analyst 807 (OTC)
quiero crear una Parent Company con un ID autogenerado
para mantener un catálogo gobernado y auditable.

## Alcance:
Botón y Formulario Create Parent Company. Desde página de listado de Parent Company (botón parte superior derecha)
Generación automática de ParentCompanyID (único, inmutable, no editable).
Ejemplo: HC01-0001
Validaciones de campos y unicidad de nombre.
Crear Merchant para el Parent Company

## Functional Specifications
Campos Requeridos: parent company_name (≥ 3 chars)
email_address (validación del formato)
phone_number
Opcional: Description (≤ 500).
ParentCompanyID generado por el sistema y no editable, no se verá en UI 
Unicidad de company_name case/acento‑insensible
Caracteres especiales se permiten
Botón de Create solo se activa cuando todos los campos requeridos están completados.
Una vez creado el Parent Company debe llevar al usuario al flujo relacional de Parent Company, Merchants y Items. Presentar Mensaje de exito al crear el Parent Company que lea:
"Parent Company Created. You can start creating new nerchantas to add to this company"
debe presentar las opciones de Dismiss o Create Merchants
Al escoger esta opción se debe levantar el Modal (Formulario) de New Merchants
si se navega fuera de la sección se desaparece el banner
Si se selecciona Dismiss, se cierra el banner
Estado interno por defecto del parent company: Active (para trazabilidad futura).
Permisos: Create para Manager, Analyst 805/806, Analyst 807 (OTC).
Audit Log: registrar create con who/when y after.