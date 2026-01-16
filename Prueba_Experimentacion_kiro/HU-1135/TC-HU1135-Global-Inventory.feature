Feature: HU-1135 - Módulo Global Inventory con Listado, Filtros y Búsqueda
  Como usuario autorizado con roles específicos
  Quiero visualizar y gestionar el listado de Global Items
  Para administrar eficientemente el inventario global según mis permisos

  Background:
    Given el sistema tiene los siguientes Global Items configurados:
      | Global Name    | Global ID  | Program  | Category | Product IDs        |
      | Apple Juice    | GI-001     | Te Paga  | Beverages| PROD-101, PROD-102 |
      | Banana Chips   | GI-002     | OTC      | -        | PROD-201           |
      | Carrot Sticks  | GI-003     | Te Paga  | Snacks   | PROD-301           |
      | Dragon Fruit   | GI-004     | OTC      | -        | PROD-401, PROD-402 |
      | Elderberry Tea | GI-005     | Te Paga  | Beverages| PROD-501           |
    And el tenant "MCS" tiene las siguientes categorías habilitadas:
      | Category  | Program  |
      | Beverages | Te Paga  |
      | Snacks    | Te Paga  |
      | Health    | Te Paga  |

  # ===== CASOS DE CARGA INICIAL Y VISUALIZACIÓN =====

  Scenario: Carga inicial del módulo con orden alfabético por defecto
    Given el usuario está autenticado con rol "Manager"
    When el usuario accede al tab "Global Inventory"
    Then el sistema debe mostrar el listado de Global Items
    And debe estar ordenado alfabéticamente A-Z por "Global Name"
    And el primer item debe ser "Apple Juice"
    And el último item visible debe seguir el orden alfabético
    And debe mostrar paginación con 10 registros por defecto
    And cada registro debe mostrar "Global Name" y "Global ID"

  Scenario: Visualización de campos requeridos en cada registro
    Given el usuario está en el módulo Global Inventory
    When el listado se carga
    Then cada registro debe mostrar obligatoriamente:
      | Campo       |
      | Global Name |
      | Global ID   |
    And los campos deben ser claramente visibles
    And deben mantener formato consistente

  Scenario: Carga inicial sin Global Items disponibles
    Given el usuario está autenticado con rol "Manager"
    And no existen Global Items en el sistema
    When el usuario accede al tab "Global Inventory"
    Then debe mostrar el mensaje "No hay Global Items disponibles"
    And debe mostrar el botón "New Global Item" (si el rol lo permite)
    And no debe mostrar controles de paginación

  # ===== CASOS DE BÚSQUEDA =====

  Scenario: Búsqueda por Global Name - coincidencia exacta
    Given el usuario está en el listado de Global Items
    When el usuario escribe "Apple Juice" en el campo Search
    Then el sistema debe mostrar el Global Item "Apple Juice"
    And debe mostrar solo 1 resultado
    And debe mantener la paginación activa

  Scenario: Búsqueda por Global Name - coincidencia parcial
    Given el usuario está en el listado de Global Items
    When el usuario escribe "apple" en el campo Search
    Then el sistema debe mostrar todos los Global Items cuyo "Global Name" contenga "apple"
    And la búsqueda debe ser case-insensitive
    And debe mostrar "Apple Juice" en los resultados

  Scenario: Búsqueda case-insensitive
    Given el usuario está en el listado de Global Items
    When el usuario escribe "APPLE" en el campo Search
    Then debe mostrar los mismos resultados que buscar "apple"
    And debe mostrar "Apple Juice" en los resultados
    And la búsqueda no debe ser sensible a mayúsculas/minúsculas

  Scenario: Búsqueda por Global ID
    Given el usuario está en el listado de Global Items
    When el usuario escribe "GI-001" en el campo Search
    Then el sistema debe mostrar el Global Item con ID "GI-001"
    And debe mostrar "Apple Juice" como resultado
    And debe funcionar con búsqueda parcial

  Scenario: Búsqueda por Global ID parcial
    Given el usuario está en el listado de Global Items
    When el usuario escribe "GI-00" en el campo Search
    Then debe mostrar todos los Global Items cuyo ID contenga "GI-00"
    And debe mostrar múltiples resultados
    And debe incluir "GI-001", "GI-002", "GI-003", etc.

  Scenario: Búsqueda por Product ID asociado
    Given existen Global Items con Product IDs asociados
    When el usuario escribe "PROD-101" en el campo Search
    Then el sistema debe mostrar los Global Items que tengan "PROD-101" en sus Product IDs
    And debe mostrar "Apple Juice" en los resultados
    And debe funcionar aunque el Product ID no esté visible en la lista

  Scenario: Búsqueda por Product ID parcial
    Given el usuario está en el listado de Global Items
    When el usuario escribe "PROD-1" en el campo Search
    Then debe mostrar todos los Global Items con Product IDs que contengan "PROD-1"
    And debe incluir items con "PROD-101", "PROD-102", etc.

  Scenario: Búsqueda sin resultados
    Given el usuario está en el listado de Global Items
    When el usuario escribe "XYZ-NoExiste" en el campo Search
    Then debe mostrar el mensaje "No se encontraron resultados para 'XYZ-NoExiste'"
    And no debe mostrar ningún Global Item
    And debe mantener el campo de búsqueda con el texto ingresado
    And debe permitir limpiar la búsqueda

  Scenario: Limpiar búsqueda
    Given el usuario ha realizado una búsqueda con resultados
    When el usuario limpia el campo de búsqueda
    Then debe mostrar nuevamente todos los Global Items
    And debe restaurar el orden alfabético A-Z
    And debe resetear la paginación a la página 1

  # ===== CASOS DE FILTROS =====

  Scenario: Abrir panel de filtros
    Given el usuario está en el módulo Global Inventory
    When el usuario hace clic en el botón de filtros
    Then debe abrirse el panel de filtros
    And debe mostrar el filtro "Program"
    And debe mostrar las opciones "OTC" y "Te Paga"
    And debe mostrar botones "Apply" y "Clear"

  Scenario: Filtro por Program - OTC
    Given el usuario está en el listado de Global Items
    When el usuario abre el panel de filtros
    And selecciona "OTC" en el filtro Program
    And hace clic en "Apply"
    Then el sistema debe mostrar solo Global Items del programa OTC
    And debe mostrar "Banana Chips" y "Dragon Fruit"
    And NO debe mostrar items de Te Paga
    And NO debe mostrar el filtro de Category
    And debe actualizar la paginación según los resultados filtrados

  Scenario: Filtro por Program - Te Paga muestra filtro de Category
    Given el usuario está en el listado de Global Items
    When el usuario selecciona "Te Paga" en el filtro Program
    Then el sistema debe mostrar el filtro de Category
    And debe listar solo las categorías habilitadas: "Beverages", "Snacks", "Health"
    And el filtro de Category debe estar habilitado para selección

  Scenario: Filtro por Program Te Paga y Category
    Given el usuario ha seleccionado "Te Paga" en el filtro Program
    And el filtro de Category está visible
    When el usuario selecciona "Beverages" en Category
    And hace clic en "Apply"
    Then debe mostrar solo Global Items de Te Paga con categoría Beverages
    And debe mostrar "Apple Juice" y "Elderberry Tea"
    And NO debe mostrar items de otras categorías

  Scenario: Filtro por múltiples categorías
    Given el usuario ha seleccionado "Te Paga" en el filtro Program
    When el usuario selecciona "Beverages" y "Snacks" en Category
    And hace clic en "Apply"
    Then debe mostrar Global Items de Te Paga con categoría Beverages O Snacks
    And debe mostrar "Apple Juice", "Elderberry Tea" y "Carrot Sticks"
    And debe actualizar el contador de resultados

  Scenario: Limpiar filtros aplicados
    Given el usuario ha aplicado filtros de Program y Category
    And el listado muestra resultados filtrados
    When el usuario hace clic en "Clear"
    Then todos los filtros deben limpiarse
    And el listado debe mostrar todos los Global Items nuevamente
    And debe mantener el ordenamiento activo
    And debe resetear a la página 1

  Scenario: Filtros sin resultados
    Given el usuario selecciona filtros muy específicos
    When los filtros aplicados no coinciden con ningún Global Item
    Then debe mostrar el mensaje "No hay Global Items que coincidan con los filtros seleccionados"
    And debe mantener los filtros aplicados visibles
    And debe permitir modificar o limpiar los filtros

  # ===== CASOS DE ROLES Y PERMISOS =====

  Scenario: Analyst OTC (807) - No ve filtros de Te Paga
    Given el usuario está autenticado con rol "Analyst 807"
    When el usuario accede al módulo Global Inventory
    And abre el panel de filtros
    Then NO debe ver la opción "Te Paga" en el filtro Program
    And NO debe ver el filtro de Category
    And solo debe ver opciones relacionadas con OTC
    And debe ver el botón "New Global Item"

  Scenario: Analyst OTC (807) - Solo ve items de OTC
    Given el usuario está autenticado con rol "Analyst 807"
    When el usuario accede al módulo Global Inventory
    Then debe ver solo Global Items del programa OTC
    And debe mostrar "Banana Chips" y "Dragon Fruit"
    And NO debe mostrar items de Te Paga
    And el listado debe estar ordenado A-Z

  Scenario: Solution Owner - No ve botón New Global Item
    Given el usuario está autenticado con rol "Solution Owner"
    When el usuario accede al módulo Global Inventory
    Then NO debe ver el botón "New Global Item"
    And debe poder ver el listado completo de Global Items
    And debe poder buscar y filtrar normalmente
    And debe tener acceso a todas las funcionalidades de visualización

  Scenario: Solution Owner - Puede ver todos los programas
    Given el usuario está autenticado con rol "Solution Owner"
    When el usuario abre el panel de filtros
    Then debe ver las opciones "OTC" y "Te Paga"
    And debe poder filtrar por cualquier programa
    And debe poder ver categorías cuando selecciona Te Paga

  Scenario: Manager - Ve botón New Global Item
    Given el usuario está autenticado con rol "Manager"
    When el usuario accede al módulo Global Inventory
    Then debe ver el botón "New Global Item"
    And debe estar habilitado para hacer clic
    And debe tener acceso completo a todas las funcionalidades

  Scenario: Manager con selector OTC - Experiencia como Analyst 807
    Given el usuario está autenticado con rol "Manager"
    And ha seleccionado "OTC" en el selector superior de programa
    When el usuario accede al módulo Global Inventory
    Then su experiencia debe ser idéntica a la de un Analyst 807
    And NO debe ver filtros de Te Paga en el panel de filtros
    And NO debe ver filtro de Category
    And solo debe ver Global Items de OTC

  Scenario: Analyst 805/806 - Acceso a Te Paga
    Given el usuario está autenticado con rol "Analyst 805"
    When el usuario accede al módulo Global Inventory
    Then debe ver Global Items del programa Te Paga
    And debe poder filtrar por categorías
    And debe ver el botón "New Global Item"

  Scenario Outline: Validación de permisos por rol
    Given el usuario está autenticado con rol "<rol>"
    When el usuario accede al módulo Global Inventory
    Then debe ver el botón "New Global Item": "<ve_boton_new>"
    And debe ver filtro de Te Paga: "<ve_te_paga>"
    And debe ver filtro de Category: "<ve_category>"

    Examples:
      | rol              | ve_boton_new | ve_te_paga | ve_category |
      | Manager          | Sí           | Sí         | Condicional |
      | Analyst 807      | Sí           | No         | No          |
      | Analyst 805      | Sí           | Sí         | Condicional |
      | Analyst 806      | Sí           | Sí         | Condicional |
      | Solution Owner   | No           | Sí         | Condicional |

  # ===== CASOS DE ORDENAMIENTO =====

  Scenario: Ordenamiento por defecto A-Z
    Given el usuario accede al módulo Global Inventory
    When la vista se carga por primera vez
    Then los Global Items deben estar ordenados alfabéticamente A-Z por "Global Name"
    And el indicador de sort debe mostrar "A-Z" como activo
    And "Apple Juice" debe aparecer antes que "Banana Chips"
    And "Elderberry Tea" debe aparecer al final

  Scenario: Cambiar ordenamiento a Z-A
    Given el usuario está viendo el listado ordenado A-Z
    When el usuario selecciona la opción de sort "Z-A"
    Then el listado debe reordenarse alfabéticamente Z-A por "Global Name"
    And "Elderberry Tea" debe aparecer primero
    And "Apple Juice" debe aparecer al final
    And debe mantener la paginación activa

  Scenario: Ordenamiento Z-A con filtros aplicados
    Given el usuario ha aplicado filtro de Program "Te Paga"
    And el listado muestra solo items de Te Paga
    When el usuario selecciona sort "Z-A"
    Then debe ordenar Z-A solo los items filtrados de Te Paga
    And debe mantener los filtros activos
    And debe respetar la paginación

  Scenario: Ordenamiento con búsqueda activa
    Given el usuario ha realizado una búsqueda con múltiples resultados
    When el usuario cambia el ordenamiento de A-Z a Z-A
    Then debe reordenar solo los resultados de la búsqueda
    And debe mantener la búsqueda activa
    And debe actualizar la visualización inmediatamente

  Scenario: Alternar entre A-Z y Z-A múltiples veces
    Given el usuario está en el listado de Global Items
    When el usuario selecciona "Z-A"
    And luego selecciona "A-Z"
    And luego selecciona "Z-A" nuevamente
    Then el sistema debe responder correctamente en cada cambio
    And debe mantener la consistencia del ordenamiento
    And no debe haber errores o comportamiento inesperado

  # ===== CASOS DE PAGINACIÓN =====

  Scenario: Paginación básica con más de 10 items
    Given existen 25 Global Items en el sistema
    When el usuario accede al módulo Global Inventory
    Then debe ver controles de paginación
    And debe mostrar "Return First Page", "Previous", "Next"
    And debe mostrar selector numérico de páginas (1, 2, 3)
    And debe mostrar 10 registros en la página 1
    And debe indicar "Página 1 de 3"

  Scenario: Navegación a página siguiente
    Given el usuario está en la página 1 del listado
    And existen múltiples páginas de resultados
    When el usuario hace clic en "Next"
    Then debe navegar a la página 2
    And debe mostrar los siguientes 10 registros
    And debe mantener el ordenamiento activo
    And debe mantener los filtros aplicados

  Scenario: Navegación a página anterior
    Given el usuario está en la página 2 del listado
    When el usuario hace clic en "Previous"
    Then debe navegar a la página 1
    And debe mostrar los primeros 10 registros
    And debe mantener el contexto de filtros y ordenamiento

  Scenario: Navegación a primera página
    Given el usuario está en la página 3 del listado
    When el usuario hace clic en "Return First Page"
    Then debe navegar a la página 1
    And debe mostrar los primeros 10 registros
    And debe resetear la posición del scroll

  Scenario: Selección directa de página por número
    Given el usuario está en la página 1
    And existen 5 páginas de resultados
    When el usuario hace clic en el número "4"
    Then debe navegar directamente a la página 4
    And debe mostrar los registros correspondientes a esa página

  Scenario: Cambiar cantidad de registros por página a 25
    Given el usuario está viendo el listado con 10 registros por página
    And está en la página 2
    When el usuario selecciona "25 registros por página"
    Then el sistema debe mostrar 25 Global Items por página
    And debe recalcular el número total de páginas
    And debe navegar a la página 1
    And debe mantener los filtros y sort aplicados

  Scenario: Cambiar cantidad de registros por página a 50
    Given existen 100 Global Items en el sistema
    When el usuario selecciona "50 registros por página"
    Then debe mostrar 50 registros en la página actual
    And debe mostrar "Página 1 de 2"
    And debe ajustar los controles de paginación

  Scenario: Paginación con búsqueda que retorna pocos resultados
    Given el usuario ha aplicado una búsqueda que retorna 5 resultados
    When el listado se actualiza
    Then debe mostrar los 5 resultados en una sola página
    And NO debe mostrar controles de paginación
    And debe indicar "Mostrando 5 de 5 resultados"

  Scenario: Paginación con filtros que reducen resultados
    Given el usuario ha aplicado filtros que retornan 15 resultados
    And está mostrando 10 registros por página
    When el listado se actualiza
    Then debe mostrar 2 páginas de resultados
    And la página 1 debe tener 10 registros
    And la página 2 debe tener 5 registros

  Scenario: Mantener página al aplicar sort
    Given el usuario está en la página 3 del listado
    When el usuario cambia el ordenamiento de A-Z a Z-A
    Then debe mantener la página 3 activa
    And debe reordenar los items de esa página
    And no debe navegar automáticamente a página 1

  Scenario: Resetear a página 1 al aplicar nuevos filtros
    Given el usuario está en la página 3 del listado
    When el usuario aplica nuevos filtros
    Then debe navegar automáticamente a la página 1
    And debe mostrar los primeros resultados filtrados
    And debe recalcular el total de páginas

  Scenario: Resetear a página 1 al realizar nueva búsqueda
    Given el usuario está en la página 2 del listado
    When el usuario realiza una nueva búsqueda
    Then debe navegar automáticamente a la página 1
    And debe mostrar los primeros resultados de la búsqueda

  # ===== CASOS DE ACCIÓN NEW GLOBAL ITEM =====

  Scenario: Hacer clic en botón New Global Item
    Given el usuario tiene rol "Manager"
    And está en el módulo Global Inventory
    When el usuario hace clic en el botón "New Global Item"
    Then debe abrirse el formulario de creación de Global Item
    And debe mantener el contexto del tenant/programa activo
    And el formulario debe estar listo para ingresar datos

  Scenario: New Global Item mantiene contexto de filtros
    Given el usuario tiene filtros aplicados (Program: Te Paga)
    When el usuario hace clic en "New Global Item"
    Then el formulario debe pre-seleccionar "Te Paga" como programa
    And debe mantener el contexto del tenant activo

  Scenario: Botón New Global Item deshabilitado para Solution Owner
    Given el usuario está autenticado con rol "Solution Owner"
    When el usuario accede al módulo Global Inventory
    Then el botón "New Global Item" NO debe estar visible
    And no debe haber forma de acceder al formulario de creación

  # ===== CASOS DE RESPONSIVIDAD =====

  Scenario: Visualización en dispositivo móvil
    Given el usuario accede al módulo desde un dispositivo móvil (375px)
    When el listado se carga
    Then debe ajustarse al tamaño de pantalla
    And los controles deben ser accesibles con el dedo
    And debe mantener toda la funcionalidad disponible
    And el texto debe ser legible sin zoom

  Scenario: Visualización en tablet
    Given el usuario accede al módulo desde una tablet (768px)
    When el listado se carga
    Then debe ajustarse al tamaño de pantalla
    And debe mostrar una cantidad apropiada de información
    And los controles de paginación deben ser usables

  Scenario: Visualización en desktop
    Given el usuario accede al módulo desde desktop (1920px)
    When el listado se carga
    Then debe aprovechar el espacio disponible
    And debe mostrar todos los controles claramente
    And debe mantener un diseño balanceado

  # ===== CASOS DE INTEGRACIÓN Y EDGE CASES =====

  Scenario: Búsqueda y filtros simultáneos
    Given el usuario ha aplicado filtro de Program "Te Paga"
    When el usuario realiza una búsqueda por "Apple"
    Then debe mostrar solo items de Te Paga que coincidan con "Apple"
    And debe aplicar ambos criterios (filtro Y búsqueda)
    And debe actualizar la paginación correctamente

  Scenario: Búsqueda, filtros y sort simultáneos
    Given el usuario ha aplicado filtro de Program "Te Paga"
    And ha realizado una búsqueda por "e"
    When el usuario selecciona sort "Z-A"
    Then debe mostrar items de Te Paga que contengan "e", ordenados Z-A
    And debe mantener todos los criterios activos
    And la paginación debe reflejar los resultados combinados

  Scenario: Persistencia de estado al navegar fuera y volver
    Given el usuario ha aplicado filtros, búsqueda y está en página 2
    When el usuario navega a otra sección del portal
    And regresa al módulo Global Inventory
    Then debe mantener los filtros aplicados
    And debe mantener la búsqueda activa
    And debe estar en la página 2
    And debe mantener el ordenamiento seleccionado

  Scenario: Manejo de caracteres especiales en búsqueda
    Given el usuario está en el campo de búsqueda
    When el usuario escribe caracteres especiales "@#$%"
    Then el sistema debe manejar la búsqueda sin errores
    And debe mostrar "No se encontraron resultados" si no hay coincidencias
    And no debe causar errores en el sistema

  Scenario: Búsqueda con espacios múltiples
    Given el usuario está en el campo de búsqueda
    When el usuario escribe "Apple    Juice" (con múltiples espacios)
    Then el sistema debe normalizar los espacios
    And debe buscar "Apple Juice"
    And debe mostrar resultados correctos

  Scenario: Performance con gran volumen de datos
    Given existen 500 Global Items en el sistema
    When el usuario accede al módulo Global Inventory
    Then la carga inicial debe completarse en menos de 3 segundos
    And la paginación debe funcionar eficientemente
    And la búsqueda debe responder en menos de 1 segundo

  Scenario: Actualización de datos en tiempo real
    Given el usuario está viendo el listado de Global Items
    When otro usuario crea un nuevo Global Item
    And el usuario actual actualiza la vista
    Then debe mostrar el nuevo Global Item en el listado
    And debe mantener el ordenamiento correcto
    And debe actualizar el contador de páginas si es necesario