# Template HU 

## Historia de Usuario
**Como** Definición de rol/usuario
**Quiero** Qué es lo que se va a trabajar 
**Para** Con qué finalidad

## Definición de Campos

## Qué completar en los campos: 
1. **Nombre del campo**
El nombre estándar del elemento (por ejemplo: tenant_id).
2. **Descripción / propósito**
¿Qué representa? ¿Para qué se usa? ¿Qué rol cumple dentro del sistema?
3. **Tipo de dato**
string, number, boolean, date, dropdown, etc.
4. **Reglas de formato / longitud**
Ejemplo: string de 36 caracteres, máximo 100 caracteres, solo letras y números, etc.
5. **Visibilidad / Disponibilidad por rol**
¿Quién lo ve? ¿Quién puede editarlo?
Ej: solo Solution Owner, visible para todos los roles, etc.
6. **Comportamiento esperado**
Cómo debe funcionar:
Ordenamiento (alfabético, por fecha, etc.)
Si es editable o solo lectura
Si es obligatorio u opcional
Si activa algún evento o contexto
7. **Dependencias o relaciones**
Si el campo depende de otro o afecta a otro.
Ej: El Program Selector depende del tenant activo.
8. **Validaciones**
Errores, restricciones, mensajes esperados.

## *Ejemplos de campos*:

### Campo de trabajo #1 *(son los titulos generales de lo que se va a trabajar en la HU)*
- **Company Name**: Nombre de la compañía matriz (string)
- **ID**: Identificador único autogenerado por el sistema
- **Merchants (count)**: Contador de merchants asociados (calculado en backend)
- **Estatus**: Active/Inactive

### Campo de trabajo #2 *(características de los campos que se van a trabajar)*
- **Paginación**: Server-side con page, size, sort
- **Tamaño por defecto**: 10 registros
- **Tamaño máximo**: 50 registros
- **Ordenación**: Por company_name (asc/desc)

*(Puede haber otros campos, dependiendo la HU)*

## Scope 

**Definición del alcance**: Definir qué y hasta dónde se va a trabajar en esta HU

## Out of scope

**Definición de lo que queda por fuera**: Dar una breve descripción de aquello que se nombra en esta HU pero queda por fuera y se trabajará en otra HU

## Reglas de Negocio

En esta sección se deberá colocar, como indica el titulo, reglas generales. Lo que no debe incluir son: 
* Detalles técnicos de implementación (SQL, APIs específicas)
* Descripción de la UI 
* Pasos de testing

## *Ejemplos de reglas de negocio*:

### RN-01: Visualización y Navegación
1. Al entrar al segmento de Merchants, se debe presentar la paestaña Parent Company
2. La lista debe mostrar todos los Parent Companies por defecto
3. Los campos visibles son: Company Name, ID, Merchants (count) y estatus

### RN-02: Búsqueda
1. La búsqueda debe ser universal sobre company_name
2. Debe ser case-insensitive (insensible a mayúsculas)
3. Debe ser insensible a acentos y espacios múltiples
4. Debe soportar búsqueda parcial tipo "comienza con" (limitación Dynamo)
5. Si se escribe "Wal" debe buscar companies que empiecen con "Wal"
6. NO debe traer companies que contengan "wal" en el medio del nombre

## Escenarios Gherkin

Se espera de estos escenarios que sean una descripción de pasos a modo de guia del comportamiento esperado de acuerdo a ciertas acciones esperables y no esperables del sistema, implementación o mejora descripto en la HU 

## *Ejemplos de escenarios gherking*:

### Escenario 1: Visualización inicial de Parent Companies
```gherkin
Given que soy un usuario con rol Manager o Analista MCS
When accedo al módulo Merchants
And selecciono la pestaña Parent Company
Then debo ver la lista de Parent Companies
And debo ver las columnas: Company Name, ID, Merchants (count), Estatus
And debo ver 10 registros por defecto
And debo ver los filtros chips: All, Active, Inactive
And el filtro "All" debe estar seleccionado por defecto
```

### Escenario 2: Búsqueda parcial exitosa
```gherkin
Given que estoy en la lista de Parent Companies
When ingreso "Wal" en el campo de búsqueda
Then debo ver solo los Parent Companies que empiecen con "Wal"
And debo ver resultados como "Walmart", "Walgreens"
And NO debo ver resultados que contengan "wal" en el medio como "Super market Walmart"
```

