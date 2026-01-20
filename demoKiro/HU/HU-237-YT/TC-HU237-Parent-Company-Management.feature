Feature: Parent Company Management - Listado con Chips de Estatus
  Como Manager y Analista de MCS
  Quiero gestionar Parent Companies con funcionalidades de listado, búsqueda y filtrado
  Para centralizar la relación entre inventario, merchants y compañía matriz

  Background:
    Given que el usuario ha iniciado sesión
    And tiene permisos CRUD para Parent Companies
    And se encuentra en el módulo Merchants

  # CASOS POSITIVOS - VISUALIZACIÓN Y NAVEGACIÓN

  Scenario: Visualización inicial de la pestaña Parent Company ----si
    When el usuario selecciona la pestaña "Parent Company"
    Then se debería ver la lista de Parent Companies
    And se deberían ver las columnas "Company Name", "ID", "Merchants (count)", "Estatus"
    And se deberían ver exactamente 10 registros por defecto
    And se deberían ver los chips de filtro "All", "Active", "Inactive"
    And el chip "All" debería estar seleccionado por defecto
    And se deberían ver controles de paginación
    And se debería ver un sort de ordenamiento por "Company Name"

  # CASOS POSITIVOS - BÚSQUEDA

  Scenario Outline: Búsqueda parcial exitosa por company name -----si
    Given que existen Parent Companies con nombres "<companies_existentes>"
    When el usuario ingresa "<termino_busqueda>" en el campo de búsqueda
    Then se deberían ver los Parent Companies "<resultados_esperados>"
    And NO se deberían ver los Parent Companies "<resultados_no_esperados>"

    Examples:
      | companies_existentes                           | termino_busqueda | resultados_esperados    | resultados_no_esperados |
      | Walmart,Walgreens,Super market Walmart,Target | Wal              | Walmart,Walgreens       | Super market Walmart    |
      | McDonald,MCDONALD,McDónald,Burger McDonald     | mcd              | McDonald,MCDONALD       | Burger McDonald         |
      | Apple Inc,Apple Store,Big Apple Corp           | Apple            | Apple Inc,Apple Store   | Big Apple Corp          |

  Scenario: Búsqueda insensible a mayúsculas, acentos y espacios múltiples ---- si
    Given que existe un Parent Company con nombre "Café  Martínez"
    When el usuario ingresa "cafe martinez" en el campo de búsqueda
    Then se debería ver el Parent Company "Café  Martínez" en los resultados

  Scenario: Búsqueda sin resultados ----- si
    When el usuario ingresa "XYZ123NoExiste" en el campo de búsqueda
    Then se debería ver el mensaje "No se encontraron resultados"
    And la lista debería estar vacía

  # CASOS POSITIVOS - FILTROS

  Scenario Outline: Filtrado por estatus usando chips ---- si
    Given que existen Parent Companies con diferentes estatus
    When el usuario selecciona el chip "<filtro>"
    Then se deberían ver solo Parent Companies con estatus "<estatus_esperado>"
    And el chip "<filtro>" debería estar resaltado
    And los otros chips deberían estar en estado normal

    Examples:
      | filtro   | estatus_esperado |
      | Active   | Active           |
      | Inactive | Inactive         |

  Scenario: Filtro All muestra todos los registros ---- si
    Given que existen Parent Companies con estatus "Active" e "Inactive"
    When el usuario selecciona el chip "All"
    Then se deberían ver Parent Companies con estatus "Active"
    And se deberían ver Parent Companies con estatus "Inactive"
    And el chip "All" debería estar resaltado

  # CASOS POSITIVOS - PAGINACIÓN

  Scenario Outline: Cambio de tamaño de página válido ----- si
    Given que existen más de 50 Parent Companies
    When el usuario cambia el tamaño de página a "<tamaño>"
    Then se deberían ver hasta "<tamaño>" registros por página
    And la paginación debería actualizarse correctamente

    Examples:
      | tamaño |
      | 10     |
      | 25     |
      | 50     |

  Scenario Outline: Navegación entre páginas ------ si
    Given que existen más de 40 Parent Companies
    And se está viendo la página "<pagina_actual>" con 10 registros
    When el usuario navega "<accion_navegacion>"
    Then se deberían ver los registros correspondientes a la página "<pagina_esperada>"
    And el indicador de página debería mostrar "<pagina_esperada>"

    Examples:
      | pagina_actual | accion_navegacion        | pagina_esperada |
      | 1             | a la página siguiente    | 2               |
      | 2             | a la página anterior     | 1               |
      | 3             | a la primera página      | 1               |
      | 2             | a la página 4            | 4               |

  # CASOS POSITIVOS - ORDENACIÓN

  Scenario Outline: Ordenación por Company Name ----- si
    Given que existen Parent Companies con nombres "Zebra Corp", "Apple Inc", "Microsoft"
    When el usuario selecciona ordenar por Company Name "<direccion>"
    Then los Parent Companies deberían mostrarse en orden "<orden_esperado>"

    Examples:
      | direccion  | orden_esperado                    |
      | ascendente | Apple Inc,Microsoft,Zebra Corp   |
      | descendente| Zebra Corp,Microsoft,Apple Inc   |

  # CASOS POSITIVOS - CONTEO DE MERCHANTS

  Scenario: Visualización correcta del conteo de merchants ----- si
    Given que existe un Parent Company "Walmart Inc" con 5 merchants asociados
    When se visualiza la lista de Parent Companies
    Then se debería ver "5" en la columna "Merchants (count)" para "Walmart Inc"

  Scenario: Conteo cero de merchants ----- si
    Given que existe un Parent Company "New Company" sin merchants asociados
    When se visualiza la lista de Parent Companies
    Then se debería ver "0" en la columna "Merchants (count)" para "New Company"

  # CASOS NEGATIVOS - VALIDACIONES

  Scenario: Límite máximo de paginación ---- si
    When el usuario intenta cambiar el tamaño de página a 100
    Then el sistema debería limitar el tamaño a 50 registros máximo
    And se debería ver un mensaje indicando el límite máximo

  Scenario: Tamaño de página inválido ---- no aplica
    When el usuario intenta establecer un tamaño de página de 0 o negativo
    Then el sistema debería mantener el tamaño actual
    And se debería ver un mensaje de error de validación

  # CASOS NEGATIVOS - PERMISOS

  Scenario: Usuario sin permisos de acceso ---- AGREGAR
    Given que el usuario no tiene permisos para Parent Companies
    When intenta acceder a la pestaña "Parent Company"
    Then se debería ver un mensaje de "Acceso denegado"
    And NO se debería ver la lista de Parent Companies

  # CASOS POSITIVOS - COMBINACIÓN DE FUNCIONALIDADES

  Scenario: Búsqueda combinada con filtro y paginación ---- NO APLICA
    Given que existen Parent Companies activos e inactivos que empiezan con "Tech"
    When el usuario ingresa "Tech" en el campo de búsqueda
    And selecciona el chip "Active"
    And cambia el tamaño de página a 25
    Then se deberían ver solo Parent Companies activos que empiecen con "Tech"
    And se deberían ver hasta 25 registros por página

  Scenario: Ordenación combinada con filtro ---- REVISAR
    Given que existen Parent Companies activos con nombres "Zebra Active", "Apple Active"
    When el usuario selecciona el chip "Active"
    And ordena por Company Name ascendente
    Then se debería ver "Apple Active" antes que "Zebra Active"
    And solo se deberían ver Parent Companies con estatus "Active"

  # CASOS DE RENDIMIENTO

  Scenario: Carga eficiente con paginación server-side ----no
    Given que existen más de 1000 Parent Companies
    When se accede a la lista de Parent Companies
    Then la página debería cargar en menos de 3 segundos
    And solo deberían cargarse los primeros 10 registros
    And NO debería cargarse toda la lista en memoria del cliente

  # CASOS DE AUDITORÍA

  Scenario: Acciones de lectura no se registran en audit log ----no
    When se visualiza la lista de Parent Companies
    Or se realiza una búsqueda
    Or se cambian filtros o paginación
    Then estas acciones NO deberían registrarse en el Audit Log

  # CASOS DE INTERFAZ DE USUARIO

  Scenario: Estado visual de chips de filtro ----- REVISAR
    Given que se está en la lista de Parent Companies
    When el usuario selecciona el chip "Active"
    Then el chip "Active" debería tener estilo visual de seleccionado
    And los chips "All" e "Inactive" deberían tener estilo visual normal

  Scenario: Indicadores de ordenación ---- no
    When el usuario selecciona ordenar por Company Name ascendente
    Then se debería ver un indicador visual de ordenación ascendente en la columna
    When cambia a ordenación descendente
    Then se debería ver un indicador visual de ordenación descendente

  Scenario: Campo de búsqueda con placeholder ---- no
    When se visualiza el campo de búsqueda
    Then debería tener un placeholder indicativo como "Buscar por nombre de compañía"

  # CASOS DE DATOS VACÍOS

  Scenario: Lista vacía de Parent Companies ---- no
    Given que no existen Parent Companies en el sistema
    When se accede a la pestaña Parent Company
    Then se debería ver un mensaje "No hay Parent Companies registradas"
    And se debería ver la estructura de la tabla con headers
    And los controles de filtro y búsqueda deberían estar disponibles