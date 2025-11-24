# Sistema de Gestión de Panadería

Sistema de gestión desarrollado con php 8.2, mysql 8.0 y docker.

## Inicio Rapido

```bash
# 1. Clonar repositorio
git clone https://github.com/EiderMontalvo/panaderia-php.git
cd panaderia-php

# 2. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# 3. Levantar servicios
docker-compose up -d

# 4. Verificar conexión
docker exec panaderia_web php /var/www/html/scripts/verify_connection.php

# 5. Acceder
# Web: http://localhost:8080
# PHPMyAdmin: http://localhost:8888
```

## Requisitos

- Docker >= 20.10
- Docker Compose >= 2.0
- Git

## Arquitectura

```
├── docker-compose.yml      # orquestación de servicios
├── Dockerfile             # imagen PHP customizada
├── .env                   # variables de entorno
├── .env.example          # plantilla de configuración
└── www/
    ├── public/           # punto de entrada web
    ├── src/
    │   ├── config/       # configuraciones
    │   ├── models/       # modelos de datos
    │   └── controllers/  # lógica de negocio
    ├── database/
    │   ├── migrations/   # essquema de BD
    │   └── seeds/        # datos iniciales
    └── scripts/          # scripts CLI
```

## Seguridad

- Credenciales gestionadas via variables de entorno
- Prepared statements PDO para prevenir SQL Injection
- Patrón Singleton para gestión de conexiones
- `.env` excluido del control de versiones