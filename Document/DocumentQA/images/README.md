# Carpeta de Imágenes y Diagramas

Esta carpeta contiene todos los diagramas y recursos visuales para la documentación.

## 📁 Estructura

```
images/
├── diagramas/           # Diagramas de flujo, arquitectura, etc.
│   ├── *.drawio        # Archivos fuente editables
│   ├── *.png           # Imágenes para documentos
│   └── *.svg           # Vectoriales para web
├── screenshots/         # Capturas de pantalla
├── mockups/            # Mockups de UI
└── icons/              # Iconos y elementos gráficos
```

## 🎨 Herramientas Recomendadas

### Draw.io (Diagrams.net)
- **URL:** https://app.diagrams.net/
- **Para:** Diagramas de flujo, arquitectura, procesos
- **Formatos:** .drawio (fuente), .png/.svg (export)

### Excalidraw
- **URL:** https://excalidraw.com/
- **Para:** Diagramas rápidos, sketches
- **Estilo:** Hand-drawn, informal

## 📋 Convenciones de Nombres

### Diagramas
- `flujo-[proceso]-[version].drawio`
- `arquitectura-[componente].drawio`
- `secuencia-[funcionalidad].drawio`

### Imágenes Exportadas
- `flujo-[proceso]-[version].png`
- `arquitectura-[componente].png`
- `screenshot-[pantalla]-[fecha].png`

## 🔄 Workflow Recomendado

1. **Crear diagrama** en Draw.io
2. **Guardar como** `.drawio` en `/diagramas/`
3. **Exportar como** `.png` en `/diagramas/`
4. **Referenciar** en Markdown: `![Descripción](./images/diagramas/nombre.png)`

## 📝 Template para Referencias

```markdown
### Diagrama de [Nombre]
![Descripción del diagrama](./images/diagramas/nombre-diagrama.png)

*Archivo fuente: [nombre-diagrama.drawio](./images/diagramas/nombre-diagrama.drawio)*
```