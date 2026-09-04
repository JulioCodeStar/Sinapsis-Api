# Sinapsis API

API en Express para consultar campañas y clientes, con documentación interactiva vía Swagger.

## Estructura del proyecto

```
Sinapsis/
├── src/
│   ├── index.js            # Punto de entrada de la app
│   ├── config/
│   │   ├── db.js           # Pool de conexión a MySQL
│   │   └── swagger.js      # Configuración de swagger-jsdoc
│   └── routes/
│       ├── campaigns.js    # Endpoints /api/campaigns
│       └── customers.js    # Endpoints /api/customers
├── .env.example             # Plantilla de variables de entorno
├── .gitignore
└── package.json
```


## Instalación

```bash
npm install
```

## Uso

```bash 
npm run dev     
```

El servidor levanta en `http://localhost:${PORT}` (por defecto `3000`).

## Documentación de la API (Swagger)

Con el servidor corriendo, la documentación interactiva está disponible en:

```
http://localhost:3000/api-docs
```

Los endpoints se documentan con comentarios `@openapi` (JSDoc) directamente encima de cada ruta en `src/index.js` y en los archivos de `src/routes/`. Para agregar un endpoint nuevo a la documentación, basta con escribir un bloque `/** @openapi ... */` sobre la ruta correspondiente.

## Endpoints

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/database` | Verifica la conexión a la base de datos |
| GET | `/api/customers/successful-messages` | Total de mensajes exitosos por cliente en un rango de fechas (`start_date`, `end_date`) |
| PUT | `/api/campaigns/:id/totals` | Recalcula los totales (`total_records`, `total_sent`, `total_error`) de una campaña |
| PUT | `/api/campaigns/:id/status` | Actualiza el estado de proceso de una campaña según sus mensajes pendientes |

## Variables de entorno

| Variable | Descripción |
|---|---|
| `PORT` | Puerto donde escucha la API |
| `DB_HOST` | Host de MySQL |
| `DB_PORT` | Puerto de MySQL |
| `DB_USER` | Usuario de MySQL |
| `DB_PASSWORD` | Contraseña de MySQL |
| `DB_NAME` | Nombre de la base de datos |
