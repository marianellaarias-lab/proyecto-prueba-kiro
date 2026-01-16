Feature: Tenant Selector para Solution Owner
  Como Solution Owner
  Quiero poder visualizar toda la información filtrada por tenant
  Para garantizar aislamiento y control operacional de la data

  Background:
    Given que el usuario ha iniciado sesión
    And se encuentra en la solución

  # ACCESO Y VISUALIZACIÓN DEL SELECTOR (RN-01, RN-02)

  Scenario: Solution Owner visualiza selector de tenants
    Given que el usuario tiene rol "Solution Owner"
    When accede a cualquier pantalla de la solución
    Then se debería ver el selector de tenants en posición fija
    And se debería ver el indicador del tenant activo

  Scenario Outline: Roles sin acceso al selector de tenants
    Given que el usuario tiene rol "<rol>"
    When accede a cualquier pantalla de la solución
    Then NO se debería ver el selector de tenants
    And se debería ver el selector de programas existente

    Examples:
      | rol              |
      | Manager          |
      | Analyst 805/806  |
      | Analyst 807 OTC  |
      | Viewer           |

  # ORDEN ALFABÉTICO (RN-03)

  Scenario: Tenants ordenados alfabéticamente
    Given que el usuario es Solution Owner
    And existen tenants con nombres "Zebra Corp", "Apple Inc", "Microsoft"
    When abre el selector de tenants
    Then se deberían ver los tenants en orden "Apple Inc", "Microsoft", "Zebra Corp"

  # SELECTOR SIEMPRE VISIBLE (RN-02)

  Scenario Outline: Selector visible en todas las pantallas
    Given que el usuario es Solution Owner
    When navega a "<pantalla>"
    Then el selector de tenants debería estar visible en la misma posición
    And el indicador del tenant activo debería estar visible

    Examples:
      | pantalla           |
      | Dashboard          |
      | Merchants          |
      | Parent Companies   |
      | Items              |
      | Reports            |

  # APLICACIÓN GLOBAL DEL TENANT (RN-05)

  Scenario: Filtrado de data por tenant seleccionado
    Given que el usuario es Solution Owner
    And existen datos de "Tenant A" y "Tenant B" en el sistema
    When selecciona "Tenant A" del selector
    Then se debería ver solo data correspondiente a "Tenant A"
    And NO se debería ver data de "Tenant B"

  # CAMBIO DE TENANT (RN-06)

  Scenario: Cambio de tenant refresca la vista completamente
    Given que el usuario es Solution Owner
    And tiene seleccionado "Tenant A"
    And está en página 3 de un listado
    And tiene filtros aplicados
    And tiene ordenación personalizada
    When selecciona "Tenant B" del selector
    Then la vista debería refrescarse inmediatamente
    And la paginación debería reiniciarse a página 1
    And los filtros deberían limpiarse
    And la ordenación debería volver a valores por defecto
    And se debería ver solo data de "Tenant B"

  # INDICADOR DEL TENANT ACTIVO (RN-07)

  Scenario: Indicador se actualiza al cambiar tenant
    Given que el usuario es Solution Owner
    And tiene seleccionado "Tenant A"
    When selecciona "Tenant B" del selector
    Then el indicador del tenant activo debería mostrar "Tenant B"
    And el indicador debería ser visible en todas las pantallas

  Scenario: Indicador persiste en navegación
    Given que el usuario es Solution Owner
    And ha seleccionado "Tenant A"
    When navega entre diferentes módulos
    Then el indicador debería seguir mostrando "Tenant A"
    And el selector debería seguir mostrando "Tenant A" como seleccionado

  # AISLAMIENTO Y SEGURIDAD (RN-08)

  Scenario: Intento de acceso no autorizado al selector
    Given que el usuario tiene rol "Manager"
    When intenta acceder al endpoint del selector de tenants
    Then se debería retornar código 403 Forbidden

  Scenario: Intento de acceso a data de otro tenant
    Given que el usuario es Solution Owner
    And tiene seleccionado "Tenant A"
    When intenta acceder a un recurso que pertenece a "Tenant B"
    Then se debería retornar código 403 Forbidden o 404 Not Found

  # ROLES DISTINTOS A SOLUTION OWNER (RN-09)

  Scenario: Selector de programas funciona sin cambios
    Given que el usuario tiene rol "Manager"
    When accede a la solución
    Then se debería ver el selector de programas
    And el selector de programas debería funcionar exactamente como antes
    And NO se debería ver el selector de tenants

  # VALIDACIONES DE CAMPOS

  Scenario Outline: Validación de longitud de campos
    Given que el usuario es Solution Owner
    When se carga un tenant con "<campo>" de "<longitud>" caracteres
    Then debería "<resultado>"

    Examples:
      | campo       | longitud | resultado                    |
      | tenant_id   | 36       | cargarse correctamente       |
      | tenant_id   | 37       | mostrar error de validación  |
      | tenant_name | 100      | cargarse correctamente       |
      | tenant_name | 101      | mostrar error de validación  |

  # CASOS DE DATOS VACÍOS

  Scenario: Sin tenants disponibles
    Given que el usuario es Solution Owner
    And no existen tenants en el sistema
    When accede a la solución
    Then el selector de tenants debería estar visible pero vacío
    And se debería mostrar un mensaje indicativo

  # CASOS DE RENDIMIENTO

  Scenario: Carga eficiente del selector
    Given que el usuario es Solution Owner
    And existen más de 100 tenants en el sistema
    When abre el selector de tenants
    Then la lista debería cargarse en menos de 2 segundos
    And todos los tenants deberían estar ordenados alfabéticamente