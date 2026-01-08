Feature: HU-921 - Gestión de Tenants para Solution Owner
  Como Solution Owner
  Quiero poder ver todos los tenants configurados en la solución
  Para administrar la configuración y programas de cada tenant de forma centralizada

  Background:
    Given el usuario está autenticado en el portal
    And existen los siguientes tenants configurados:
      | Tenant Name | Programs                             |
      | MCS         | OTC 807, Classicare 805/806, Te Paga |
      | BankCorp    | OTC                                  |
      | FinTech     | Te Paga                              |
      | RetailPlus  | Classicare 806                       |

  # ===== CASOS DE CONTROL DE ACCESO =====

  Scenario: Acceso exitoso con rol Solution Owner
    Given el usuario tiene asignado el rol "Solution Owner"
    When el usuario accede a la vista "Tenant Management Dashboard"
    Then el sistema debe mostrar la vista del dashboard
    And debe mostrar la lista completa de tenants
    And debe mostrar los campos "Tenant Name" y "Programs" para cada tenant

  Scenario: Acceso denegado sin rol Solution Owner
    Given el usuario NO tiene asignado el rol "Solution Owner"
    When el usuario intenta acceder a la vista "Tenant Management Dashboard"
    Then el sistema debe denegar el acceso
    And debe mostrar el mensaje "Acceso no autorizado"
    And no debe mostrar la vista del dashboard

  Scenario Outline: Validación de acceso por diferentes roles
    Given el usuario tiene asignado el rol "<rol>"
    When el usuario intenta acceder a la vista "Tenant Management Dashboard"
    Then el acceso debe ser "<resultado>"
    And debe mostrar "<mensaje>"

    Examples:
      | rol             | resultado | mensaje              |
      | Solution Owner  | permitido | vista del dashboard  |
      | Admin           | denegado  | Acceso no autorizado |
      | User            | denegado  | Acceso no autorizado |
      | Tenant Admin    | denegado  | Acceso no autorizado |
      | Program Manager | denegado  | Acceso no autorizado |

  # ===== CASOS DE VISUALIZACIÓN =====

  Scenario: Visualización completa de todos los tenants
    Given el usuario tiene rol "Solution Owner"
    And está en la vista "Tenant Management Dashboard"
    When la vista se carga completamente
    Then debe mostrar exactamente 4 tenants en la lista
    And debe mostrar el tenant "MCS" con programas "OTC 807, Classicare 805/806, Te Paga"
    And debe mostrar el tenant "BankCorp" con programa "OTC"
    And debe mostrar el tenant "FinTech" con programa "Te Paga"
    And debe mostrar el tenant "RetailPlus" con programa "Classicare 806"

  Scenario: Vista vacía cuando no existen tenants
    Given el usuario tiene rol "Solution Owner"
    And no existen tenants configurados en la solución
    When el usuario accede a la vista "Tenant Management Dashboard"
    Then debe mostrar el mensaje "No hay tenants configurados"
    And debe mostrar una lista vacía
    And debe mantener disponible la funcionalidad de filtro

  # ===== CASOS DE FILTRADO =====

  Scenario: Filtro exitoso por nombre de tenant existente
    Given el usuario está en la vista "Tenant Management Dashboard"
    When el usuario aplica el filtro por Tenant Name con valor "MCS"
    Then debe mostrar únicamente el tenant "MCS"
    And debe ocultar los tenants "BankCorp", "FinTech" y "RetailPlus"
    And debe mantener visible el botón para limpiar filtro

  Scenario: Filtro sin resultados
    Given el usuario está en la vista "Tenant Management Dashboard"
    When el usuario aplica el filtro por Tenant Name con valor "NoExiste"
    Then debe mostrar el mensaje "No se encontraron tenants que coincidan con el filtro"
    And debe mostrar una lista vacía
    And debe mantener el valor "NoExiste" en el campo de filtro

  Scenario: Limpiar filtro aplicado
    Given el usuario ha aplicado un filtro por Tenant Name con valor "MCS"
    And la vista muestra únicamente el tenant "MCS"
    When el usuario limpia el filtro
    Then debe mostrar nuevamente todos los tenants (4 tenants)
    And el campo de filtro debe estar vacío

  Scenario Outline: Filtrado por diferentes valores
    Given el usuario está en la vista "Tenant Management Dashboard"
    When el usuario aplica el filtro por Tenant Name con valor "<filtro>"
    Then debe mostrar "<cantidad>" tenants
    And debe mostrar los tenants "<tenants_mostrados>"

    Examples:
      | filtro     | cantidad | tenants_mostrados |
      | MCS        | 1        | MCS               |
      | BankCorp   | 1        | BankCorp          |
      | FinTech    | 1        | FinTech           |
      | RetailPlus | 1        | RetailPlus        |

  # ===== CASOS DE NAVEGACIÓN ENTRE PROGRAMAS =====

  Scenario: Navegación en tenant con múltiples programas
    Given el usuario está visualizando el tenant "MCS"
    And el tenant "MCS" tiene los programas "OTC 807", "Classicare 805/806" y "Te Paga"
    When el usuario selecciona el programa "OTC 807"
    Then el sistema debe cargar los datos específicos del programa "OTC 807"
    And debe mostrar las opciones para navegar a "Classicare 805/806" y "Te Paga"
    And debe mantener visible el nombre del tenant "MCS"

  Scenario: Selección de diferentes programas en tenant múltiple
    Given el usuario está visualizando el tenant "MCS"
    When el usuario selecciona el programa "Classicare 805/806"
    Then debe cargar los datos del programa "Classicare 805/806"
    When el usuario cambia al programa "Te Paga"
    Then debe cargar los datos del programa "Te Paga"
    And debe mantener la navegabilidad entre todos los programas

  Scenario: Tenant con un solo programa
    Given el usuario está visualizando el tenant "BankCorp"
    And el tenant "BankCorp" tiene únicamente el programa "OTC"
    When el usuario selecciona el tenant "BankCorp"
    Then debe mostrar directamente los datos del programa "OTC"
    And NO debe mostrar opciones de navegación entre programas
    And debe indicar claramente que es el único programa del tenant

  Scenario: Navegación desde tenant múltiple a tenant único
    Given el usuario está visualizando el tenant "MCS" con programa "OTC 807" seleccionado
    When el usuario cambia al tenant "FinTech"
    Then debe mostrar directamente los datos del programa "Te Paga"
    And NO debe mostrar opciones de navegación entre programas
    And debe limpiar la selección previa de programas múltiples

  # ===== CASOS DE RENDIMIENTO =====

  Scenario: Rendimiento de carga inicial con múltiples tenants
    Given existen 200 tenants configurados en la solución
    And el usuario tiene rol "Solution Owner"
    When el usuario accede a la vista "Tenant Management Dashboard"
    Then la vista debe cargar completamente en menos de 2 segundos
    And debe mostrar todos los 200 tenants
    And debe mantener la funcionalidad de filtro operativa

  Scenario: Rendimiento del filtro con gran volumen de datos
    Given existen 200 tenants configurados en la solución
    And el usuario está en la vista "Tenant Management Dashboard"
    When el usuario aplica un filtro por Tenant Name
    Then el filtrado debe completarse en menos de 1 segundo
    And debe mostrar los resultados correspondientes
    And la interfaz debe permanecer responsiva

  # ===== CASOS DE VALIDACIÓN DE CAMPOS =====

  Scenario: Validación de campos obligatorios mostrados
    Given el usuario está en la vista "Tenant Management Dashboard"
    When la vista muestra cualquier tenant
    Then cada tenant debe mostrar obligatoriamente el campo "Tenant Name"
    And cada tenant debe mostrar obligatoriamente el campo "Programs"
    And ambos campos deben tener valores no vacíos

  Scenario: Manejo de tenant sin programas asociados
    Given existe un tenant "EmptyTenant" sin programas asociados
    And el usuario está en la vista "Tenant Management Dashboard"
    When la vista se carga
    Then debe mostrar el tenant "EmptyTenant"
    And debe mostrar "Sin programas asociados" en el campo Programs
    And debe permitir la selección del tenant

  # ===== CASOS DE INTEGRACIÓN =====

  Scenario: Actualización de datos tras modificación externa
    Given el usuario está en la vista "Tenant Management Dashboard"
    And se agrega un nuevo tenant "NewTenant" externamente
    When el usuario actualiza la vista
    Then debe mostrar el nuevo tenant "NewTenant" en la lista
    And debe mantener todos los tenants existentes
    And debe mantener cualquier filtro aplicado

  Scenario: Comportamiento con tenant eliminado externamente
    Given el usuario está visualizando el tenant "MCS"
    And el tenant "MCS" es eliminado externamente
    When el usuario actualiza la vista
    Then el tenant "MCS" no debe aparecer en la lista
    And debe mostrar los tenants restantes
    And si había filtro aplicado para "MCS", debe mostrar "sin resultados"