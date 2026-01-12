# USER STORY 237 - ORIGINAL

USER STORY 237 F2.1.0 | Merchant Section | Parent Company Tab | Listado con Chips de Estatus

Como Manager y Analista de MCS
quiero crear, ver, editar y eliminar Parent Companies, y asociarles merchants
para centralizar la relación entre inventario, merchants y compañía matriz con un identificador único autogenerado por el sistema.

## Alcance
Crear pestaña Parent Company dentro del módulo Merchants.
Lista contiene: Company Name, ID, Merchants (count) y estatus.
Búsqueda universal (case‑insensitive, búsqueda parcial) sobre company_name.
Paginación server‑side con page, size, sort. Por Defecto: 10 con un incremento máximo hasta 50 
Ordenación por company_name asc/desc.
Filtros Chips: All, Active, Inactive

## Functional Specifications
Al entrar al segmento de Merchants, se debe presentar toda la lista de Parent Companies,
Los resultados de búsuqeda, deben responder a la búsqueda parcial e insensible a mayúsculas/acentos/espacios múltiples.
Estatus del Parent Company Visible
El conteo Merchants (count) se calcula en backend y se devuelve en el mismo payload de la lista.
Paginación server‑side; no cargar todo en memoria del cliente.
Respetar permisos de CRUD para Analyst 805/806, Analyst 807 (OTC) y Manager.
Registrar en Audit Log el CRUD (Acciones no lectura)

## MCS Portal
Limitación Dynamo: La búsqueda parcial, solo se puede ser que "comience con". Por ejemplo, si se escribe "Wal" buscará todas los parent companies que empiecen con "Wal" (Walmart, etc), no traerá parent companies que contengan "wal", por ejemplo "Super market Walmart".