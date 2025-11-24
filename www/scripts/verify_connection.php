<?php
//script para verificar la conexion a la base de datos
require_once __DIR__ . '/../src/config/database.php';

const COLOR_GREEN = "\033[32m";
const COLOR_RED = "\033[31m";
const COLOR_YELLOW = "\033[33m";
const COLOR_BLUE = "\033[34m";
const COLOR_RESET = "\033[0m";

function printSuccess(string $menssage): void
{
    echo COLOR_GREEN . "✓ " . $menssage . COLOR_RESET . PHP_EOL;
}
function printError(string $menssage): void
{
    echo COLOR_RED . "x " . $menssage . COLOR_RESET . PHP_EOL;
}
function printInfo(string $menssage): void
{
    echo COLOR_BLUE . "i " . $menssage . COLOR_RESET . PHP_EOL;
}
function printAlert(string $menssage): void
{
    echo COLOR_YELLOW . "! " . $menssage . COLOR_RESET . PHP_EOL;
}

echo PHP_EOL;
echo "========================================" . PHP_EOL;
echo "  VERIFICACIÓN DE CONEXIÓN A BD" . PHP_EOL;
echo "========================================" . PHP_EOL;
echo PHP_EOL;

try {
    //prueba de conexion
    printInfo("Prueba 1: Conectando a la base de datos...");
    $pdo = getDBConnection();
    printSuccess("Conexión exitosa");

    //prueba verificación de tablas
    printInfo("Prueba 2: Verificando tablas...");
    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);
    $expectedTables = ['categorias', 'productos', 'clientes', 'pedidos', 'detalle_pedidos'];
    $missingTables = array_diff($expectedTables);

    if (empty($missingTables)) {
        printSuccess("Todas las tablas exiisten (" . count($tables) . " tablas)");
    } else {
        printAlert("Faltan tablas: " . implode(', ', $missingTables));
    }

    //test conteo de registros
    printInfo("Test 3: contando registros...");
    $squeries = [
        'Categorias' => 'SELECT COUNT(*) FROM categorias',
        'Productos' => 'SELECT COUNT(*) FROM productos',
        'Clientes' => 'SELECT COUNT(*) FROM clientes',
        'Pedidos' => 'SELECT COUNT(*) FROM pedidos',
        'Detalles' => 'SELECT COUNT(*) FROM detalle_pedido',
    ];
    foreach ($squeries as $name => $query) {
        $count = $pdo->query($query)->fetchColumn();
        echo " - $name: $count registros" . PHP_EOL;
    }

    //test query compleja
    printInfo("Test 4: Probando JOIN...");
    $stmt = $pdo->query("
        SELECT p.nombre, c.nombre as categoria
        FROM productos p
        INNER JOIN categorias c ON p.categoria_id = c.id
        LIMIT 1
    ");
    $result = $stmt->fetch();
    if ($result) {
        printSuccess("JOIN funciona correctamente");
        echo " - ejemplo: {$result['nombre']} ({$result['categoria']})" . PHP_EOL;
    }
    echo PHP_EOL;
    printSuccess("Todas las verificaciones pasarón");
    echo PHP_EOL;
    exit(0);
} catch (Exception $e) {
    echo PHP_EOL;
    printError("Error: " . $e->getMessage());
    echo PHP_EOL;
    exit(1);
}
?>