Feature: HU-921 v2 - Sistema de Selección de Cliente y Contexto Global para Solution Owner
  Como Solution Owner
  Quiero seleccionar cualquier cliente y que toda la aplicación se adapte dinámicamente
  Para tener una vista contextualizada sin limitaciones de hardcodeo

  Background:
    Given el usuario está autenticado con rol "Solution Owner"
    And existen los siguientes clientes configurados en el sistema:
      | Cliente      | Programas                    | Configuraciones Específicas           |
      | MCS          | Te Paga, OTC, Flexi         | Te Paga con categorías, OTC sin categorías |
      | DEMO         | Te Paga, OTC                | Te Paga con categorías, OTC sin categorías |
      | ClienteNuevo | Flexi                       | Configuraciones básicas                |
      | ClienteVacio |                             | Sin programas configurados             |

  # ===== CASOS DE ACCESO Y LISTADO DE CLIENTES =====

  Scenario: Acceso inicial y visualización de todos los clientes
    Given el usuario accede al sistema por primera vez
    When el sistema carga la vista inicial
    Then debe mostrar una sección dedicada para selección de clientes
    And debe listar todos los clientes disponibles: "MCS", "DEMO", "ClienteNuevo", "ClienteVacio"
    And no debe tener ningún cliente preseleccionado
    And debe mostrar el mensaje "Seleccione un cliente para continuar"

  Scenario: Acceso denegado sin rol Solution Owner
    Given el usuario tiene un rol diferente a "Solution Owner"
    When el usuario intenta acceder al sistema
    Then debe denegar el acceso a la funcionalidad de selección de clientes
    And debe mostrar "Acceso no autorizado - Se requiere rol Solution Owner"

  Scenario: Cliente nuevo registrado dinámicamente
    Given el sistema muestra los clientes existentes
    When se registra un nuevo cliente "SuperBank" en el sistema
    And el usuario actualiza la vista
    Then debe aparecer "SuperBank" en la lista de clientes disponibles
    And debe permitir seleccionar "SuperBank"
    And debe mantener los clientes existentes en la lista

  # ===== CASOS DE SELECCIÓN Y CAMBIO DE CONTEXTO =====

  Scenario: Selección inicial de cliente y carga de contexto
    Given el usuario está en la vista de selección de clientes
    When el usuario selecciona el cliente "MCS"
    Then el sistema debe establecer "MCS" como contexto global activo
    And debe cargar los programas específicos de "MCS": "Te Paga", "OTC", "Flexi"
    And debe mostrar visualmente que "MCS" está seleccionado
    And todas las secciones deben estar listas para mostrar datos de "MCS"

  Scenario: Cambio entre clientes con diferentes configuraciones
    Given el usuario tiene seleccionado el cliente "MCS"
    And está visualizando información específica de "MCS"
    When el usuario cambia la selección al cliente "DEMO"
    Then el contexto global debe cambiar a "DEMO"
    And debe cargar los programas de "DEMO": "Te Paga", "OTC"
    And debe limpiar cualquier estado específico de "MCS"
    And debe actualizar el indicador visual de cliente seleccionado
    And todas las secciones deben prepararse para datos de "DEMO"

  Scenario: Selección de cliente sin programas configurados
    Given el usuario selecciona el cliente "ClienteVacio"
    When el sistema carga el contexto del cliente
    Then debe establecer "ClienteVacio" como contexto activo
    And debe mostrar el mensaje "Este cliente no tiene programas configurados"
    And debe deshabilitar secciones dependientes de programas
    And debe ofrecer opción para configurar programas

  # ===== CASOS DE PROGRAMAS DINÁMICOS POR CLIENTE =====

  Scenario: Carga de programas específicos por cliente
    Given el usuario ha seleccionado el cliente "MCS"
    When el sistema carga los programas del cliente
    Then debe mostrar únicamente los programas configurados para "MCS"
    And debe cargar "Te Paga" con configuración de categorías habilitadas
    And debe cargar "OTC" con configuración de categorías deshabilitadas
    And debe cargar "Flexi" con sus configuraciones específicas
    And NO debe mostrar programas hardcodeados genéricos

  Scenario: Programas diferentes entre clientes
    Given el usuario selecciona el cliente "DEMO"
    When el sistema carga los programas
    Then debe mostrar solo "Te Paga" y "OTC" (sin "Flexi")
    And NO debe mostrar "Flexi" aunque esté disponible para otros clientes
    And cada programa debe tener las configuraciones específicas de "DEMO"

  Scenario: Validación de configuraciones no hardcodeadas
    Given el usuario selecciona cualquier cliente
    When el sistema carga las configuraciones del cliente
    Then todas las configuraciones deben provenir de base de datos o configuración dinámica
    And NO debe usar valores hardcodeados en el código
    And debe registrar en logs que las configuraciones son dinámicas

  # ===== CASOS DE COMPORTAMIENTOS ESPECÍFICOS POR PROGRAMA =====

  Scenario: Te Paga con categorías habilitadas
    Given el usuario ha seleccionado el cliente "MCS"
    And el cliente tiene el programa "Te Paga" configurado
    When el usuario navega a la sección de items de "Te Paga"
    Then los items deben mostrar el campo "categoría"
    And debe permitir filtrar por categorías
    And debe permitir asignar categorías a items
    And el comportamiento debe ser específico del programa "Te Paga"

  Scenario: OTC sin categorías
    Given el usuario ha seleccionado el cliente "MCS"
    And el cliente tiene el programa "OTC" configurado
    When el usuario navega a la sección de items de "OTC"
    Then los items NO deben mostrar el campo "categoría"
    And NO debe mostrar opciones de filtrado por categorías
    And NO debe permitir asignar categorías
    And el comportamiento debe ser específico del programa "OTC"

  Scenario: Comportamientos consistentes entre clientes para mismo programa
    Given el usuario selecciona el cliente "MCS" y navega a "Te Paga"
    And verifica que las categorías están habilitadas
    When el usuario cambia al cliente "DEMO" y navega a "Te Paga"
    Then las categorías también deben estar habilitadas para "DEMO"
    And el comportamiento debe ser consistente para el programa "Te Paga"

  # ===== CASOS DE PERSISTENCIA Y SESIÓN =====

  Scenario: Persistencia de selección durante navegación
    Given el usuario ha seleccionado el cliente "MCS"
    When el usuario navega entre diferentes secciones de la aplicación
    Then debe mantener "MCS" como contexto activo en todas las secciones
    And no debe requerir reseleccionar el cliente
    And el indicador visual debe mostrar consistentemente "MCS"

  Scenario: Persistencia durante la sesión completa
    Given el usuario selecciona el cliente "MCS"
    And navega por múltiples secciones durante 30 minutos
    When el usuario abre una nueva sección
    Then debe mantener el contexto de "MCS"
    And todas las configuraciones específicas deben seguir activas
    And no debe revertir a estado sin selección

  Scenario: Limpieza de contexto al cerrar sesión
    Given el usuario tiene seleccionado el cliente "MCS"
    When el usuario cierra sesión
    And vuelve a iniciar sesión
    Then no debe tener ningún cliente preseleccionado
    And debe mostrar nuevamente la vista de selección de clientes

  # ===== CASOS DE VALIDACIÓN Y ERRORES =====

  Scenario: Manejo de cliente eliminado durante sesión activa
    Given el usuario tiene seleccionado el cliente "MCS"
    When el cliente "MCS" es eliminado del sistema externamente
    And el usuario intenta realizar una acción
    Then debe detectar que el cliente ya no existe
    And debe mostrar el mensaje "El cliente seleccionado ya no está disponible"
    And debe redirigir a la vista de selección de clientes

  Scenario: Manejo de programas modificados durante sesión
    Given el usuario tiene seleccionado el cliente "MCS" con programas "Te Paga, OTC, Flexi"
    When los programas de "MCS" son modificados externamente (se elimina "Flexi")
    And el usuario navega a una nueva sección
    Then debe detectar el cambio en configuración
    And debe actualizar automáticamente los programas disponibles
    And debe mostrar solo "Te Paga" y "OTC"

  Scenario: Validación de permisos por cliente específico
    Given el usuario selecciona el cliente "MCS"
    When el sistema valida permisos específicos del cliente
    Then debe aplicar las reglas de permisos configuradas para "MCS"
    And debe respetar las restricciones específicas del cliente
    And debe registrar en audit log la validación por cliente

  # ===== CASOS DE RENDIMIENTO Y CARGA =====

  Scenario: Rendimiento con múltiples clientes
    Given existen 50 clientes configurados en el sistema
    When el usuario accede a la vista de selección
    Then debe cargar la lista completa en menos de 2 segundos
    And debe mantener la interfaz responsiva
    And debe permitir búsqueda/filtrado eficiente

  Scenario: Carga eficiente de contexto de cliente
    Given el usuario selecciona un cliente con múltiples programas y configuraciones
    When el sistema carga el contexto del cliente
    Then debe completar la carga en menos de 3 segundos
    And debe cargar solo las configuraciones necesarias inicialmente
    And debe cargar configuraciones adicionales bajo demanda

  # ===== CASOS DE INTEGRACIÓN Y CONSISTENCIA =====

  Scenario: Consistencia de datos entre secciones
    Given el usuario selecciona el cliente "MCS"
    And navega a la sección A que muestra datos específicos de "MCS"
    When el usuario navega a la sección B
    Then la sección B debe mostrar datos consistentes del mismo cliente "MCS"
    And no debe mostrar datos mezclados de diferentes clientes
    And debe mantener el mismo contexto de programas

  Scenario: Actualización automática de configuraciones
    Given el usuario tiene seleccionado el cliente "MCS"
    When las configuraciones de "MCS" son actualizadas externamente
    And el usuario realiza una acción que requiere las configuraciones
    Then debe detectar automáticamente las configuraciones actualizadas
    And debe aplicar los nuevos valores sin requerir reselección
    And debe notificar al usuario sobre los cambios aplicados

  # ===== CASOS DE FILTRADO Y BÚSQUEDA =====

  Scenario: Búsqueda de clientes en lista extensa
    Given existen múltiples clientes en el sistema
    When el usuario utiliza la función de búsqueda con "MCS"
    Then debe filtrar y mostrar solo los clientes que coincidan con "MCS"
    And debe mantener la funcionalidad de selección
    And debe permitir limpiar el filtro para ver todos los clientes

  Scenario: Filtrado por tipo de cliente o programa
    Given existen clientes con diferentes tipos de programas
    When el usuario aplica filtro "Solo clientes con Te Paga"
    Then debe mostrar únicamente clientes que tengan "Te Paga" configurado
    And debe ocultar clientes que no tengan ese programa
    And debe permitir seleccionar cualquiera de los clientes filtrados