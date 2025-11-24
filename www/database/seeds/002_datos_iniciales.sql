-- Datos iniciales

USE panaderia_venta;

-- insetar categorias
INSERT INTO categorias (nombre, descripcion, activo) VALUES
('Panes', 'Variedad de panes artesanales', 'TRUE'),
('Pasteles', 'Pasteles y tartas para toda ocasión', 'TRUE'),
('Postres', 'Postres individuales y porciones', 'TRUE'),
('Galletas', 'Galletas dulces y saladas', 'TRUE'),
('Bebidas', 'Café, jugos naturales y bebidas calientes', 'TRUE'),
('Salados', 'Productos salados como empanadas y sandwiches', 'TRUE');

-- insertar productos
-- panes
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, activo) VALUES
(1, 'Pan Francés', 'Pan crujiente tradicional, recién horneado', 1.50, 50, TRUE),
(1, 'Pan Integral', 'Pan saludable con granos enteros y semillas', 2.00, 30, TRUE),
(1, 'Baguette', 'Pan estilo francés, alargado y crujiente', 2.50, 25, TRUE),
(1, 'Pan de Ajo', 'Pan suave con mantequilla de ajo y perejil', 3.00, 20, TRUE),
(1, 'Pan de Centeno', 'Pan oscuro de centeno, ideal para sándwiches', 2.80, 15, TRUE);

-- pasteles
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, activo) VALUES
(2, 'Pastel de Chocolate', 'Pastel de 3 leches con cobertura de chocolate belga', 25.00, 5, TRUE),
(2, 'Tarta de Fresa', 'Tarta fresca con fresas naturales y crema chantilly', 22.00, 4, TRUE),
(2, 'Cheesecake de Frutos Rojos', 'Cheesecake estilo Nueva York con mermelada', 28.00, 3, TRUE),
(2, 'Torta de Vainilla', 'Torta esponjosa de vainilla con relleno de crema', 20.00, 6, TRUE),
(2, 'Pastel de Zanahoria', 'Pastel húmedo de zanahoria con nueces', 23.00, 4, TRUE);

-- galletas
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, activo) VALUES
(3, 'Galletas de Avena', 'Paquete de 6 galletas con avena y pasas', 3.50, 40, TRUE),
(3, 'Galletas de Chocolate Chip', 'Paquete de 6 galletas con chips de chocolate', 4.00, 35, TRUE),
(3, 'Galletas de Mantequilla', 'Galletas tradicionales danesas, 8 unidades', 4.50, 30, TRUE),
(3, 'Alfajores', 'Galletas rellenas de dulce de leche, 4 unidades', 5.00, 25, TRUE);

-- bebidas
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, activo) VALUES
(4, 'Café Americano', 'Café recién preparado, tamaño regular', 2.50, 100, TRUE),
(4, 'Cappuccino', 'Café con leche espumosa y toque de canela', 3.50, 100, TRUE),
(4, 'Jugo de Naranja Natural', 'Jugo recién exprimido, 300ml', 3.00, 50, TRUE),
(4, 'Chocolate Caliente', 'Chocolate cremoso con marshmallows', 3.50, 80, TRUE),
(4, 'Té Chai Latte', 'Té especiado con leche vaporizada', 4.00, 60, TRUE);

-- postres
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, activo) VALUES
(5, 'Flan de Caramelo', 'Flan casero individual con caramelo', 4.50, 20, TRUE),
(5, 'Brownie con Helado', 'Brownie de chocolate caliente con helado de vainilla', 6.00, 15, TRUE),
(5, 'Tiramisú', 'Postre italiano de café y mascarpone', 7.00, 10, TRUE);

-- salados
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, activo) VALUES
(6, 'Empanada de Carne', 'Empanada jugosa rellena de carne molida', 3.50, 40, TRUE),
(6, 'Empanada de Pollo', 'Empanada rellena de pollo y verduras', 3.50, 35, TRUE),
(6, 'Sándwich Jamón y Queso', 'Sándwich caliente en pan ciabatta', 5.00, 25, TRUE);

-- insertar clientes 
INSERT INTO clientes (nombre, email, telefono, direccion, activo) VALUES
('María González', 'maria.gonzalez@email.com', '999-222-333', 'Calle Los Olivos 456, Lima', TRUE),
('Pedro Ramírez', 'pedro.ramirez@email.com', '999-333-444', 'Jr. Las Flores 789, Lima', TRUE),

-- insertar pedidos
-- pedido 1:
INSERT INTO pedidos (cliente_id, fecha_pedido, estado, total, metodo_pago, notas) VALUES
(1, '2025-01-23 14:15:00', 'en_preparacion', 68.50, 'tarjeta', 'Es para cumpleaños, decorar bonito');

INSERT INTO detalles_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1, 6, 1, 25.00, 25.00), 
(1, 10, 6, 3.50, 21.00),
(1, 14, 5, 3.50, 17.50),
(1, 18, 1, 6.00, 6.00);   

-- pedido 2:
INSERT INTO pedidos (cliente_id, fecha_pedido, estado, total, metodo_pago, notas) VALUES
(2, '2025-01-24 08:00:00', 'pendiente', 15.50, 'efectivo', NULL);

INSERT INTO detalles_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(2, 3, 4, 2.50, 10.00),
(2, 20, 1, 3.50, 3.50),
(2, 13, 1, 2.50, 2.50);

-- actualizar ultima compra de los clientes
UPDATE clientes SET ultima_compra = '2025-01-23 14:15:00' WHERE id = 1;
UPDATE clientes SET ultima_compra = '2025-01-24 08:00:00' WHERE id = 2;

-- verificar si se insertaron correctamente
SELECT 'Datos iniciales insertados exitosamente' AS mensaje;
SELECT 'CATEGORÍAS' AS Tabla, COUNT(*) AS Total FROM categorias
UNION ALL
SELECT 'PRODUCTOS', COUNT(*) FROM productos
UNION ALL
SELECT 'CLIENTES', COUNT(*) FROM clientes
UNION ALL
SELECT 'PEDIDOS', COUNT(*) FROM pedidos
UNION ALL
SELECT 'DETALLES_PEDIDO', COUNT(*) FROM detalles_pedido;
