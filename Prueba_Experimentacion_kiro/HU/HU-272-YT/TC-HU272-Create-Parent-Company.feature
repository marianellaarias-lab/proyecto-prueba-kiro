Feature: Create Parent Company
  Como Manager o Analyst Classicare 805/806, Analyst 807 (OTC)
  Quiero crear una Parent Company con un ID autogenerado
  Para mantener un catálogo gobernado y auditable

  Background:
    Given que el usuario ha iniciado sesión
    And tiene permisos de creación para Parent Companies
    And se encuentra en el listado de Parent Companies

  # ACCESO Y NAVEGACIÓN (RN-01)

  Scenario: Acceso al formulario de creación
    When el usuario selecciona el botón "Create Parent Company" en la parte superior derecha
    Then se debería abrir el formulario de creación de Parent Company
    And se deberían ver los campos obligatorios y opcionales

  # CREACIÓN EXITOSA (RN-02, RN-07, RN-08)

  Scenario: Creación exitosa de Parent Company
    Given que el usuario está en el formulario de creación
    When completa parent_company_name con "Test Company"
    And completa email_address con "test@company.com"
    And completa phone_number con "1234567890"
    And selecciona el botón "Create"
    Then se debería crear el Parent Company exitosamente
    And se debería generar un ParentCompanyID único automáticamente
    And el ParentCompanyID NO debería ser visible en la interfaz
    And el estado debería establecerse como "Active"
    And se debería mostrar el mensaje "Parent Company Created. You can start creating new merchants to add to this company"
    And se deberían ver las opciones "Dismiss" y "Create Merchants"

  # VALIDACIONES DE CAMPOS OBLIGATORIOS (RN-03)

  Scenario Outline: Validación de campos obligatorios
    Given que el usuario está en el formulario de creación
    When deja el campo "<campo>" vacío
    And completa los demás campos obligatorios
    Then el botón "Create" debería permanecer deshabilitado
    And se debería mostrar mensaje de campo requerido para "<campo>"

    Examples:
      | campo               |
      | parent_company_name |
      | email_address       |
      | phone_number        |

  # VALIDACIONES DE LONGITUD DE CAMPOS (RN-03, RN-04)

  Scenario Outline: Validación de longitud de campos
    Given que el usuario está en el formulario de creación
    When ingresa "<valor>" en el campo "<campo>"
    Then debería mostrar "<resultado>"

    Examples:
      | campo               | valor                    | resultado                           |
      | parent_company_name | AB                       | Error: Mínimo 3 caracteres         |
      | parent_company_name | ABC                      | Válido                              |
      | description         | [501 caracteres]         | Error: Máximo 500 caracteres       |
      | description         | [500 caracteres]         | Válido                              |
      | email_address       | email-invalido           | Error: Formato de email inválido    |
      | email_address       | test@company.com         | Válido                              |

  # VALIDACIÓN DE UNICIDAD (RN-05)

  Scenario Outline: Unicidad del nombre del Parent Company
    Given que existe un Parent Company con nombre "<nombre_existente>"
    When el usuario intenta crear un Parent Company con nombre "<nombre_nuevo>"
    Then se debería mostrar error "El nombre de la compañía ya existe"
    And no se debería permitir la creación

    Examples:
      | nombre_existente | nombre_nuevo     |
      | Test Company     | TEST COMPANY     |
      | Test Company     | test company     |
      | Café Martínez    | Cafe Martinez    |

  # ACTIVACIÓN DEL BOTÓN CREATE (RN-06)

  Scenario Outline: Activación del botón Create
    Given que el usuario está en el formulario de creación
    When "<accion>"
    Then el botón "Create" debería estar "<estado>"

    Examples:
      | accion                                    | estado        |
      | el formulario está vacío                  | deshabilitado |
      | completa solo parent_company_name         | deshabilitado |
      | completa parent_company_name y email      | deshabilitado |
      | completa todos los campos obligatorios    | habilitado    |

  # FLUJO POST-CREACIÓN (RN-07)

  Scenario Outline: Opciones después de creación exitosa
    Given que se ha creado exitosamente un Parent Company
    When el usuario "<accion>"
    Then debería "<resultado>"

    Examples:
      | accion                              | resultado                           |
      | selecciona "Create Merchants"       | abrir el modal de New Merchants     |
      | selecciona "Dismiss"                | cerrar el banner                    |
      | navega fuera de la sección          | cerrar el banner automáticamente   |

  # PERMISOS DE CREACIÓN (RN-09)

  Scenario Outline: Permisos de creación por rol
    Given que el usuario tiene rol "<rol>"
    When intenta acceder al botón "Create Parent Company"
    Then el botón debería estar "<estado>"

    Examples:
      | rol              | estado     |
      | Manager          | disponible |
      | Analyst 805/806  | disponible |
      | Analyst 807 OTC  | disponible |
      | Usuario sin permisos | no visible |

  # AUDITORÍA (RN-10)

  Scenario: Registro en Audit Log
    Given que el usuario crea un Parent Company exitosamente
    Then se debería registrar la acción en el Audit Log
    And debería incluir información de who (usuario que creó)
    And debería incluir información de when (timestamp de creación)
    And debería incluir información de after (datos del Parent Company creado)