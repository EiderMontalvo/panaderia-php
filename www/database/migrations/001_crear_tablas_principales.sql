-- sistema de gestion de panaderia

-- usar la tabla panaderia
USE panaderia_venta;

--  Tabla categorias
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    img_url VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- restricciones
    CONSTRAINT chk_precio_positivo CHECK (precio > 0),
    CONSTRAINT chk_stock_positivo CHECK (stock >= 0),

    -- Relaciones
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

    -- Indices para optimizar las busquedas
    INDEX idx_categoria (categoria_id),
    INDEX idx_activo (activo),
    INDEX idx_nombre (nombre),
    INDEX idx_precio (precio)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_compra TIMESTAMP NULL,
    activo BOOLEAN DEFAULT TRUE

    -- indices
    INDEX idx_email (email),
    INDEX idx_activo (activo),
    INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM(
        'pendiente',
        'confirmado',
        'en_preparacion',
        'listo',
        'entregado',
        'cancelado'
    ) DEFAULT 'pendiente',
    total DECIMAL(10, 2) NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'yape', 'plin', 'contraentrega') DEFAULT 'efectivo',
    notas TEXT,
    fecha_entrega TIMESTAMP NULL,

    -- Restricciones
    CONSTRAINT chk_total_positivo CHECK(total >= 0),

    -- Relaciones
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    ON DELETE CASCADE,
    ON UPDATE CASCADE

    -- Indices
    INDEX idx_cliente (cliente_id),
    INDEX idx_estado (estado),
    INDEX idx_fecha_pedido (fecha_pedido),
    INDEX idx_fecha_entrega (fecha_entrega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla detalle pedidos
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    notas TEXT.

    -- restricciones
    CONSTRAINT chk_cantidad_positiva CHECK(cantidad > 0),
    CONSTRAINT chk_precio_unitario_positivo CHECK(precio_unitario >= 0),
    CONSTRAINT chk_subtotal_positivo CHECK(subtotal >= 0),

    -- Relaciones
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

    -- Indices
    INDEX idx_pedido (pedido_id),
    INDEX idx_producto (producto_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT 'Tablas creadas exitosamente' AS mensaje;
SHOW TABLES;
