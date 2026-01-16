Feature: Merchant Section Create Merchant
  Como usuario con permisos para gestionar Merchants
  Quiero abrir un modal de "Create/New Merchant"
  Para registrar un nuevo Merchant con todos los datos requeridos, asociado al Parent Company correspondiente

  Background:
    Given el sistema de gestión de Merchants está disponible
    And el sistema de permisos está configurado

  @positive @creation @manager
  Scenario Outline: Creación exitosa de Merchant por usuarios con permisos
    Given el usuario tiene rol <rol>
    And está en <ubicacion>
    When abre el modal "Create/New Merchant"
    And completa todos los campos obligatorios con datos válidos
    And el campo Parent Company este poblado y bloqueado
    And selecciona al menos 1 programa
    And hace clic en "Create"
    Then el merchant se crea exitosamente
    And aparece el toast "Merchant Created"
    And el nuevo merchant aparece en el listado
    And queda seleccionado
    And se abre el panel lateral de detalles del merchant creado
    And se registra en Audit Log con usuario, timestamp y campos clave

    Examples:
      | rol           | ubicacion                                                    |
      | Manager       | Tab Merchants dentro de un Parent Company                   |
      | Analyst 805   | Tab Parent Company al finalizar la creación de Parent Company |
      | Analyst 806   | Tab Merchants dentro de un Parent Company                   |

  @negative @duplicate_id
  Scenario: Error por Merchant ID duplicado
    Given el usuario tiene permisos para gestionar Merchants
    And existe un merchant con ID "12345"
    When abre el modal "Create/New Merchant"
    And ingresa Merchant ID "12345"
    Then se ejecuta validación asíncrona de duplicados
    And se presenta mensaje de error indicando que el Merchant ID ya existe
    And el botón "Create" permanece inactivo

  @negative @required_fields
  Scenario Outline: Error por campos obligatorios faltantes
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And deja el campo <campo_obligatorio> sin completar
    Then el botón "Create" permanece inactivo
    And no se permite guardar la data

    Examples:
      | campo_obligatorio |
      | Merchant Name     |
      | Merchant ID       |
      | Parent Company    |
      | MCC               |
      | City              |

  @negative @programs_validation
  Scenario: Error por no seleccionar programas
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And completa todos los campos obligatorios
    But no selecciona ningún programa
    Then el botón "Create" permanece inactivo
    And no se permite crear el merchant

  @negative @tepaga_validation
  Scenario: Error por Te Paga sin categoría
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And selecciona Te Paga Benefit
    But no escoge una categoría
    Then el botón "Create" permanece inactivo
    And no se permite crear el merchant

  @negative @permissions
  Scenario: Usuario sin permisos no puede acceder
    Given el usuario no tiene rol Manager, Analyst 805/806, ni Analyst 807
    When intenta acceder a la funcionalidad de creación de Merchants
    Then no debe ver la acción de creación
    And no puede usar la funcionalidad

  @negative @analyst_807_restriction
  Scenario: Analyst 807 con restricción en Te Paga
    Given el usuario tiene rol Analyst 807
    When abre el modal "Create/New Merchant"
    And intenta modificar la categoría de Te Paga
    Then no puede modificar la categoría de Te Paga

  @positive @ui_behavior
  Scenario Outline: Funcionalidad de limpieza con botón X
    Given el usuario está en el modal "Create/New Merchant"
    When completa el campo <campo> con datos
    And hace clic en el botón "X" del campo
    Then el contenido del campo se limpia con un clic
    And se mantiene el foco en el campo

    Examples:
      | campo         |
      | Merchant Name |
      | Merchant ID   |
      | Description   |

  @positive @search_functionality
  Scenario: Búsqueda parcial en dropdown MCC
    Given el usuario está en el modal "Create/New Merchant"
    When hace clic en el dropdown MCC
    And escribe texto parcial
    Then se muestran opciones que coinciden case-insensitive
    And puede seleccionar una opción de la búsqueda

  @positive @cancellation
  Scenario: Cancelación de creación
    Given el usuario está en el modal "Create/New Merchant"
    When hace clic en Cancel (X)
    Then el modal se cierra
    And no se guarda ninguna información

  @boundary @field_validation
  Scenario Outline: Validación de límites de campos
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And ingresa en <campo> exactamente <longitud> caracteres
    Then el campo acepta la entrada
    And puede continuar con la creación

    Examples:
      | campo         | longitud |
      | Merchant Name | 3        |
      | Merchant Name | 80       |
      | Merchant ID   | 1        |
      | Merchant ID   | 20       |
      | Description   | 120      |
      | Address Line 1| 60       |
      | Address Line 2| 60       |
      | Zip Code      | 5        |

  @negative @field_validation
  Scenario Outline: Error por exceder límites de campos
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And ingresa en <campo> <longitud> caracteres
    Then el campo no acepta la entrada
    And se muestra error de validación

    Examples:
      | campo         | longitud |
      | Merchant Name | 2        |
      | Merchant Name | 81       |
      | Merchant ID   | 21       |
      | Description   | 121      |
      | Address Line 1| 61       |
      | Address Line 2| 61       |
      | Zip Code      | 4        |
      | Zip Code      | 6        |

  @positive @field_type_validation
  Scenario Outline: Validación de tipos de datos en campos
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And ingresa en <campo> el valor <valor_valido>
    Then el campo acepta la entrada
    And puede continuar con la creación

    Examples:
      | campo         | valor_valido    |
      | Merchant Name | ABC123          |
      | Merchant ID   | 12345           |
      | Address Line 1| Calle 123 ABC   |
      | Address Line 2| Apt 4B          |
      | Zip Code      | 12345           |

  @negative @field_type_validation
  Scenario Outline: Error por tipo de dato incorrecto en campos
    Given el usuario tiene permisos para gestionar Merchants
    When abre el modal "Create/New Merchant"
    And ingresa en <campo> el valor <valor_invalido>
    Then el campo no acepta la entrada
    And se muestra error de validación de tipo

    Examples:
      | campo       | valor_invalido |
      | Merchant ID | ABC123         |
      | Zip Code    | ABCDE          |