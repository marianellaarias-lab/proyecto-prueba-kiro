# HU-1135 - Módulo Global Inventory

## 📋 Descripción
Implementación del módulo Global Inventory con listado completo de Global Items, incluyendo funcionalidades de búsqueda, filtrado, ordenamiento y paginación, con permisos específicos por rol.

## 📁 Archivos Incluidos

### 📄 HU-1135-original.md
Historia de usuario tal como fue proporcionada originalmente.

### 📄 HU-1135-refinada.md
Historia refinada que incluye:
- 7 Reglas de Negocio extraídas
- 20 Escenarios Gherkin completos
- 15 Preguntas críticas para el PO
- Análisis de complejidad técnica

### 📄 TC-HU1135-Global-Inventory.feature
**Suite completa** con 70+ escenarios de prueba cubriendo:
- Carga inicial y visualización
- Búsqueda (10 escenarios)
- Filtros (8 escenarios)
- Roles y permisos (9 escenarios)
- Ordenamiento (5 escenarios)
- Paginación (13 escenarios)
- Acción New Global Item (3 escenarios)
- Responsividad (3 escenarios)
- Integración y edge cases (10+ escenarios)

### 📄 TC-HU1135-Escenarios-Criticos.feature ⭐
**20 escenarios críticos** priorizados para smoke testing y validación principal.

## 🎯 Escenarios Críticos - Resumen

### Funcionalidad Base (1 escenario)
1. **Carga inicial con orden A-Z** - Validación del comportamiento por defecto

### Búsqueda (2 escenarios)
2. **Búsqueda case-insensitive** - Por Global Name
3. **Búsqueda por Product ID** - Campo no visible pero buscable

### Filtros (3 escenarios)
4. **Filtro OTC** - No muestra Category
5. **Filtro Te Paga** - Muestra Category condicional
6. **Limpiar filtros** - Reset completo

### Roles y Permisos (3 escenarios)
7. **Analyst OTC (807)** - Restricciones de Te Paga
8. **Solution Owner** - Sin botón New Item
9. **Manager como OTC** - Experiencia adaptada

### Ordenamiento (1 escenario)
10. **Sort Z-A** - Cambio de ordenamiento

### Paginación (3 escenarios)
11. **Navegación básica** - Next/Previous
12. **Cambio de registros** - 10/25/50 por página
13. **Reset a página 1** - Con filtros nuevos

### Integración (2 escenarios)
14. **Búsqueda + Filtros + Sort** - Combinación completa
15. **Persistencia de estado** - Al navegar y volver

### Acción (1 escenario)
16. **New Global Item** - Abrir formulario

### Edge Cases (2 escenarios)
17. **Búsqueda sin resultados** - Manejo de vacío
18. **Filtros sin resultados** - Manejo de vacío

### Performance (1 escenario)
19. **Gran volumen** - 500 items

### Validación Completa (1 escenario)
20. **Permisos por rol** - Validación integral

## 🔑 Reglas de Negocio Clave

**RN1**: Orden por defecto A-Z por Global Name
**RN2**: Visibilidad adaptada por rol
**RN3**: Filtro Category solo con Te Paga
**RN4**: Búsqueda multi-campo case-insensitive
**RN5**: Persistencia de contexto en paginación
**RN6**: Paginación configurable (10/25/50)
**RN7**: Manager como OTC = Analyst 807

## 👥 Matriz de Permisos

| Rol              | Ve New Item | Ve Te Paga | Ve Category | Items Visibles |
|------------------|-------------|------------|-------------|----------------|
| Manager          | ✅ Sí       | ✅ Sí      | Condicional | Todos          |
| Analyst 807      | ✅ Sí       | ❌ No      | ❌ No       | Solo OTC       |
| Analyst 805/806  | ✅ Sí       | ✅ Sí      | Condicional | Todos          |
| Solution Owner   | ❌ No       | ✅ Sí      | Condicional | Todos          |

## 📊 Métricas de Cobertura

- **Total de escenarios**: 70+
- **Escenarios críticos**: 20
- **Cobertura de roles**: 4 roles diferentes
- **Cobertura de funcionalidades**: 100%
- **Tags para ejecución**: @critical, @smoke, @search, @filters, @permissions, @pagination

## 🚀 Ejecución de Pruebas

### Smoke Testing (Rápido)
```bash
cucumber --tags @critical --tags @smoke
```

### Testing por Funcionalidad
```bash
cucumber --tags @search
cucumber --tags @filters
cucumber --tags @permissions
```

### Suite Completa
```bash
cucumber TC-HU1135-Global-Inventory.feature
```

## ⚠️ Preguntas Pendientes para PO

1. ¿Persistencia de estado al salir y volver?
2. ¿Product IDs deben mostrarse en la UI?
3. ¿Múltiples programas simultáneos en filtros?
4. ¿Diferencia entre Analyst 805 y 806?
5. ¿Solution Owner puede editar items?

## 🔧 Complejidad Técnica

**Nivel**: MEDIA-ALTA

**Componentes**:
- Frontend con múltiples funcionalidades
- Backend con APIs optimizadas
- Sistema de roles y permisos (RBAC)
- Queries eficientes para búsqueda/filtrado

**Estimación**: 11-17 días (2-3 sprints)