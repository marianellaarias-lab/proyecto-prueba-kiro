Feature: HU-1135 - Escenarios Críticos y Principales - Global Inventory
  Resumen de los 20 escenarios más críticos para validar la funcionalidad principal
  del módulo Global Inventory con roles, filtros, búsqueda y paginación

  Background:
    Given el sistema tiene los siguientes Global Items configurados:
      | Global Name    | Global ID  | Program  | Category | Product IDs        |
      | Apple Juice    | GI-001     | Te Paga  | Beverages| PROD-101, PROD-102 |
      | Banana Chips   | GI-002     | OTC      | -        | PROD-201           |
      | Carrot Sticks  | GI-003     | Te Paga  | Snacks   | PROD-301           |
      | Dragon Fruit   | GI-004     | OTC      | -        | PROD-401, PROD-402 |
      | Elderberry Tea | GI-005     | Te Paga  | Beverages| PROD-501           |

  # ===== ESCENARIOS CRÍTICOS DE FUNCIONALIDAD BASE =====

  @critical @smoke
  Scenario: 1. Carga inicial con orden alfabético A-Z por defecto
    Given el usuario está autenticado con rol "Manager"
    When el usuario accede al tab "Global Inventory"
    Then el sistema debe mostrar el listado de Global Items
    And debe estar ordenado alfabéticamente A-Z por "Global Name"
    And el primer item debe ser "Apple Juice"
    And debe mostrar paginación con 10 registros por defecto
    And cada registro debe mostrar "Global Name" y "Global ID"

  @critical @search
  Scenario: 2. Búsqueda case-insensitive por Global Name
    Given el usuario está en el listado de Global Items
    When el usuario escribe "apple" en el campo Search
    Then el sistema debe mostrar todos los Global Items cuyo "Global Name" contenga "apple"
    And la búsqueda debe ser case-insensitive
    And debe mostrar "Apple Juice" en los resultados
    And debe mantener la paginación activa

  @critical @search
  Scenario: 3. Búsqueda por Product ID asociado (no visible)
    Given existen Global Items con Product IDs asociados
    When el usuario escribe "PROD-101" en el campo Search
    Then el sistema debe mostrar los Global Items que tengan "PROD-101" en sus Product IDs
    And debe mostrar "Apple Juice" en los resultados
    And debe funcionar aunque el Product ID no esté visible en la lista

  # ===== ESCENARIOS CRÍTICOS DE FILTROS =====

  @critical @filters
  Scenario: 4. Filtro por Program OTC - No muestra filtro de Category
    Given el usuario está en el listado de Global Items
    When el usuario abre el panel de filtros
    And selecciona "OTC" en el filtro Program
    And hace clic en "Apply"
    Then el sistema debe mostrar solo Global Items del programa OTC
    And debe mostrar "Banana Chips" y "Dragon Fruit"
    And NO debe mostrar el filtro de Category
    And debe actualizar la paginación según los resultados filtrados

  @critical @filters
  Scenario: 5. Filtro por Program Te Paga - Muestra filtro de Category
    Given el usuario está en el listado de Global Items
    When el usuario selecciona "Te Paga" en el filtro Program
    Then el sistema debe mostrar el filtro de Category
    And debe listar solo las categorías habilitadas para el tenant
    When el usuario selecciona "Beverages" en Category
    And hace clic en "Apply"
    Then debe mostrar solo Global Items de Te Paga con categoría Beverages
    And debe mostrar "Apple Juice" y "Elderberry Tea"

  @critical @filters
  Scenario: 6. Limpiar filtros aplicados
    Given el usuario ha aplicado filtros de Program "Te Paga" y Category "Beverages"
    And el listado muestra solo 2 resultados filtrados
    When el usuario hace clic en "Clear"
    Then todos los filtros deben limpiarse
    And el listado debe mostrar todos los Global Items nuevamente (5 items)
    And debe mantener el ordenamiento A-Z
    And debe resetear a la página 1

  # ===== ESCENARIOS CRÍTICOS DE ROLES Y PERMISOS =====

  @critical @permissions
  Scenario: 7. Analyst OTC (807) - No ve filtros de Te Paga
    Given el usuario está autenticado con rol "Analyst 807"
    When el usuario accede al módulo Global Inventory
    And abre el panel de filtros
    Then NO debe ver la opción "Te Paga" en el filtro Program
    And NO debe ver el filtro de Category
    And solo debe ver opciones relacionadas con OTC
    And debe ver solo Global Items de OTC en el listado

  @critical @permissions
  Scenario: 8. Solution Owner - No ve botón New Global Item
    Given el usuario está autenticado con rol "Solution Owner"
    When el usuario accede al módulo Global Inventory
    Then NO debe ver el botón "New Global Item"
    And debe poder ver el listado completo de Global Items
    And debe poder buscar y filtrar normalmente
    And debe poder ver todos los programas (OTC y Te Paga)

  @critical @permissions
  Scenario: 9. Manager con selector OTC - Experiencia como Analyst 807
    Given el usuario está autenticado con rol "Manager"
    And ha seleccionado "OTC" en el selector superior de programa
    When el usuario accede al módulo Global Inventory
    Then su experiencia debe ser idéntica a la de un Analyst 807
    And NO debe ver filtros de Te Paga en el panel de filtros
    And NO debe ver filtro de Category
    And solo debe ver Global Items de OTC

  # ===== ESCENARIOS CRÍTICOS DE ORDENAMIENTO =====

  @critical @sorting
  Scenario: 10. Cambiar ordenamiento de A-Z a Z-A
    Given el usuario está viendo el listado ordenado A-Z
    When el usuario selecciona la opción de sort "Z-A"
    Then el listado debe reordenarse alfabéticamente Z-A por "Global Name"
    And "Elderberry Tea" debe aparecer primero
    And "Apple Juice" debe aparecer al final
    And debe mantener la paginación activa
    And debe respetar los filtros aplicados

  # ===== ESCENARIOS CRÍTICOS DE PAGINACIÓN =====

  @critical @pagination
  Scenario: 11. Paginación básica con navegación
    Given existen 25 Global Items en el sistema
    And el usuario está mostrando 10 registros por página
    When el usuario está en la página 1
    And hace clic en "Next"
    Then debe navegar a la página 2
    And debe mostrar los siguientes 10 registros
    And debe mantener el ordenamiento activo
    And debe mantener los filtros aplicados

  @critical @pagination
  Scenario: 12. Cambiar cantidad de registros por página
    Given el usuario está viendo el listado con 10 registros por página
    And está en la página 2
    When el usuario selecciona "25 registros por página"
    Then el sistema debe mostrar 25 Global Items por página
    And debe recalcular el número total de páginas
    And debe navegar a la página 1
    And debe mantener los filtros y sort aplicados

  @critical @pagination
  Scenario: 13. Resetear a página 1 al aplicar nuevos filtros
    Given el usuario está en la página 3 del listado
    When el usuario aplica nuevos filtros de Program "OTC"
    Then debe navegar automáticamente a la página 1
    And debe mostrar los primeros resultados filtrados
    And debe recalcular el total de páginas según los resultados

  # ===== ESCENARIOS CRÍTICOS DE INTEGRACIÓN =====

  @critical @integration
  Scenario: 14. Búsqueda, filtros y sort simultáneos
    Given el usuario ha aplicado filtro de Program "Te Paga"
    And ha realizado una búsqueda por "e"
    When el usuario selecciona sort "Z-A"
    Then debe mostrar items de Te Paga que contengan "e", ordenados Z-A
    And debe mostrar "Elderberry Tea" antes que "Apple Juice"
    And debe mantener todos los criterios activos
    And la paginación debe reflejar los resultados combinados

  @critical @integration
  Scenario: 15. Persistencia de estado al navegar fuera y volver
    Given el usuario ha aplicado filtro de Program "Te Paga"
    And ha realizado una búsqueda por "Apple"
    And está en la página 1 con sort "Z-A"
    When el usuario navega a otra sección del portal
    And regresa al módulo Global Inventory
    Then debe mantener el filtro de Program "Te Paga"
    And debe mantener la búsqueda "Apple"
    And debe mantener el ordenamiento "Z-A"
    And debe estar en la página 1

  # ===== ESCENARIOS CRÍTICOS DE ACCIÓN =====

  @critical @action
  Scenario: 16. Hacer clic en botón New Global Item
    Given el usuario tiene rol "Manager"
    And está en el módulo Global Inventory
    When el usuario hace clic en el botón "New Global Item"
    Then debe abrirse el formulario de creación de Global Item
    And debe mantener el contexto del tenant/programa activo
    And el formulario debe estar listo para ingresar datos

  # ===== ESCENARIOS CRÍTICOS DE EDGE CASES =====

  @critical @edge-case
  Scenario: 17. Búsqueda sin resultados
    Given el usuario está en el listado de Global Items
    When el usuario escribe "XYZ-NoExiste" en el campo Search
    Then debe mostrar el mensaje "No se encontraron resultados para 'XYZ-NoExiste'"
    And no debe mostrar ningún Global Item
    And debe mantener el campo de búsqueda con el texto ingresado
    And debe permitir limpiar la búsqueda fácilmente

  @critical @edge-case
  Scenario: 18. Filtros sin resultados
    Given el usuario selecciona filtros muy específicos
    And los filtros aplicados no coinciden con ningún Global Item
    When el usuario hace clic en "Apply"
    Then debe mostrar el mensaje "No hay Global Items que coincidan con los filtros seleccionados"
    And debe mantener los filtros aplicados visibles
    And debe permitir modificar o limpiar los filtros

  # ===== ESCENARIOS CRÍTICOS DE PERFORMANCE =====

  @critical @performance
  Scenario: 19. Performance con gran volumen de datos
    Given existen 500 Global Items en el sistema
    When el usuario accede al módulo Global Inventory
    Then la carga inicial debe completarse en menos de 3 segundos
    And la paginación debe funcionar eficientemente
    And la búsqueda debe responder en menos de 1 segundo
    And el sistema debe mantener la responsividad

  # ===== ESCENARIOS CRÍTICOS DE VALIDACIÓN COMPLETA =====

  @critical @validation
  Scenario: 20. Validación completa de permisos por rol
    Given el sistema tiene configurados los siguientes roles:
      | Rol              | Ve New Item | Ve Te Paga | Ve Category |
      | Manager          | Sí          | Sí         | Condicional |
      | Analyst 807      | Sí          | No         | No          |
      | Analyst 805      | Sí          | Sí         | Condicional |
      | Solution Owner   | No          | Sí         | Condicional |
    When cada usuario accede al módulo Global Inventory
    Then cada rol debe ver exactamente los elementos permitidos
    And no debe tener acceso a funcionalidades restringidas
    And la experiencia debe ser consistente con los permisos asignados