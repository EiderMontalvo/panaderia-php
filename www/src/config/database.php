<?php

//configuracion desde variables de entorno
define('DB_HOST', getenv('DB_HOST') ?: 'db');
define('DB_NAME', getenv('DB_NAME') ?: 'panaderia_venta');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('DB_PASS') ?: 'root');
define('DB_CHARSET', 'utf8mb4');
//variables de configuración
define('APP_ENV', getenv('APP_ENV') ?: 'production');
define('APP_DEBUG', filter_var(getenv('APP_DEBUG'), FILTER_VALIDATE_BOOLEAN));
define('APP_TIMEZONE', getenv('APP_TIMEZONE') ?: 'UTC');
date_default_timezone_set(APP_TIMEZONE);

class Database
{
    private static ?PDO $instance = null;

    private function __construct()
    {
    }

    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            try {
                $dsn = sprintf( //configurar el dsn dataSourceName
                    "mysql:host=%s;dbname=%s;charset=%s",
                    DB_HOST,
                    DB_NAME,
                    DB_CHARSET
                );
                //opciones del pdo para seguridad y rendimiento
                $options = [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                    PDO::ATTR_PERSISTENT => false,
                    PDO::ATTR_ORACLE_NULLS => PDO::NULL_EMPTY_STRING,
                ];

                self::$instance = new PDO($dsn, DB_USER, DB_PASS, $options);

                if (APP_DEBUG) {
                    error_log(sprintf(
                        "[%s] Conexión establecida a %s@%s",
                        date('Y-m-d H:i:s'),
                        DB_NAME,
                        DB_HOST
                    ));
                }

            } catch (PDOException $e) {
                error_log(sprintf(
                    "[%s] Error de conexión DB: %s",
                    date('Y-m-d H:i:s'),
                    $e->getMessage()
                ));

                if (APP_DEBUG) {
                    throw new PDOException(
                        "Error de conexión a la base de datos: " . $e->getMessage()
                    );
                } else {
                    throw new PDOException(
                        "Error al conectar con la base de datos. Por favor, contacte al administrador."
                    );
                }
            }
        }

        return self::$instance;
    }

    private function __clone()
    {
        throw new Exception("No se puede clonar un Singleton");
    }

    public function __wakeup()
    {
        throw new Exception("No se puede deserializar un Singleton");
    }

    public static function closeConnection(): void
    {
        self::$instance = null;
    }
}

function getDBConnection(): PDO
{
    return Database::getInstance();
}

function executeQuery(string $sql, array $params = []): PDOStatement
{
    try {
        $pdo = getDBConnection();
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt;

    } catch (PDOException $e) {
        error_log(sprintf(
            "[%s] Error en consulta: %s | SQL: %s | Params: %s",
            date('Y-m-d H:i:s'),
            $e->getMessage(),
            $sql,
            json_encode($params)
        ));

        if (APP_DEBUG) {
            throw new Exception("Error en consulta SQL: " . $e->getMessage());
        } else {
            throw new Exception("Error al ejecutar la consulta en la base de datos.");
        }
    }
}

function executeTransaction(callable $callback)
{
    $pdo = getDBConnection();

    try {
        $pdo->beginTransaction();
        $result = $callback($pdo);
        $pdo->commit();
        return $result;

    } catch (Exception $e) {
        $pdo->rollBack();

        error_log(sprintf(
            "[%s] Error en transacción: %s",
            date('Y-m-d H:i:s'),
            $e->getMessage()
        ));

        if (APP_DEBUG) {
            throw new Exception("Error en transacción: " . $e->getMessage());
        } else {
            throw new Exception("Error al procesar la transacción.");
        }
    }
}
