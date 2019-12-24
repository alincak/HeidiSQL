﻿unit dbstructures;

// -------------------------------------
// Server constants, variables and data types
// -------------------------------------

interface

uses
  Classes, Graphics, Windows, SysUtils, gnugettext, Vcl.Forms;



const
  // Used in TMysqlFunction
  SQL_VERSION_ANSI = -1;

  // General declarations
  MYSQL_ERRMSG_SIZE = 512;
  SQLSTATE_LENGTH = 5;
  SCRAMBLE_LENGTH = 20;
  MYSQL_PORT = 3306;
  LOCAL_HOST = 'localhost';
  NAME_LEN = 64;
  PROTOCOL_VERSION = 10;
  FRM_VER = 6;

  // Field's flags
  NOT_NULL_FLAG = 1;
  PRI_KEY_FLAG = 2;
  UNIQUE_KEY_FLAG = 4;
  MULTIPLE_KEY_FLAG = 8;
  BLOB_FLAG = 16;
  UNSIGNED_FLAG = 32;
  ZEROFILL_FLAG = 64;
  BINARY_FLAG = 128;
  ENUM_FLAG = 256;
  AUTO_INCREMENT_FLAG = 512;
  TIMESTAMP_FLAG = 1024;
  SET_FLAG = 2048;
  NUM_FLAG = 32768;
  PART_KEY_FLAG = 16384;
  GROUP_FLAG = 32768;
  UNIQUE_FLAG = 65536;
  BINCMP_FLAG = 131072;

  // Client connection options
  CLIENT_LONG_PASSWORD = 1;
  CLIENT_FOUND_ROWS = 2; // Found instead of affected rows
  CLIENT_LONG_FLAG = 4;
  CLIENT_CONNECT_WITH_DB = 8;
  CLIENT_NO_SCHEMA = 16; // Don't allow database.table.column
  CLIENT_COMPRESS = 32;
  CLIENT_ODBC = 64;
  CLIENT_LOCAL_FILES = 128;
  CLIENT_IGNORE_SPACE = 256; // Ignore spaces before '('
  CLIENT_PROTOCOL_41 = 512;
  CLIENT_INTERACTIVE = 1024;
  CLIENT_SSL = 2048; // Switch to SSL after handshake
  CLIENT_IGNORE_SIGPIPE = 4096;
  CLIENT_TRANSACTIONS = 8192;
  CLIENT_RESERVED = 16384;
  CLIENT_SECURE_CONNECTION = 32768;
  CLIENT_MULTI_STATEMENTS = 65536;
  CLIENT_MULTI_RESULTS = 131072;
  CLIENT_CAN_HANDLE_EXPIRED_PASSWORDS = 4194304;
  CLIENT_SSL_VERIFY_SERVER_CERT = 67108864;
  CLIENT_REMEMBER_OPTIONS = 134217728;

  COLLATION_BINARY = 63;
  // Equivalent to COLLATION_BINARY, this is what a new driver returns when connected to a pre-4.1 server.
  COLLATION_NONE =  0;

  { SQLite Result Codes
    result code definitions

    Many SQLite functions return an integer result code from the set shown
    here in order to indicate success or failure.

    New error codes may be added in future versions of SQLite.

    See also: [extended result code definitions]
  }
  SQLITE_OK           = 0;   // Successful result
  // beginning-of-error-codes
  SQLITE_ERROR        = 1;   // Generic error
  SQLITE_INTERNAL     = 2;   // Internal logic error in SQLite
  SQLITE_PERM         = 3;   // Access permission denied
  SQLITE_ABORT        = 4;   // Callback routine requested an abort
  SQLITE_BUSY         = 5;   // The database file is locked
  SQLITE_LOCKED       = 6;   // A table in the database is locked
  SQLITE_NOMEM        = 7;   // A malloc() failed
  SQLITE_READONLY     = 8;   // Attempt to write a readonly database
  SQLITE_INTERRUPT    = 9;   // Operation terminated by sqlite3_interrupt()*/
  SQLITE_IOERR        = 10;  // Some kind of disk I/O error occurred
  SQLITE_CORRUPT      = 11;  // The database disk image is malformed
  SQLITE_NOTFOUND     = 12;  // Unknown opcode in sqlite3_file_control()
  SQLITE_FULL         = 13;  // Insertion failed because database is full
  SQLITE_CANTOPEN     = 14;  // Unable to open the database file
  SQLITE_PROTOCOL     = 15;  // Database lock protocol error
  SQLITE_EMPTY        = 16;  // Internal use only
  SQLITE_SCHEMA       = 17;  // The database schema changed
  SQLITE_TOOBIG       = 18;  // String or BLOB exceeds size limit
  SQLITE_CONSTRAINT   = 19;  // Abort due to constraint violation
  SQLITE_MISMATCH     = 20;  // Data type mismatch
  SQLITE_MISUSE       = 21;  // Library used incorrectly
  SQLITE_NOLFS        = 22;  // Uses OS features not supported on host
  SQLITE_AUTH         = 23;  // Authorization denied
  SQLITE_FORMAT       = 24;  // Not used
  SQLITE_RANGE        = 25;  // 2nd parameter to sqlite3_bind out of range
  SQLITE_NOTADB       = 26;  // File opened that is not a database file
  SQLITE_NOTICE       = 27;  // Notifications from sqlite3_log()
  SQLITE_WARNING      = 28;  // Warnings from sqlite3_log()
  SQLITE_ROW          = 100; // sqlite3_step() has another row ready
  SQLITE_DONE         = 101; // sqlite3_step() has finished executing


type
  PUSED_MEM=^USED_MEM;
  USED_MEM = packed record
    next:       PUSED_MEM;
    left:       Integer;
    size:       Integer;
  end;

  PERR_PROC = ^ERR_PROC;
  ERR_PROC = procedure;

  PMEM_ROOT = ^MEM_ROOT;
  MEM_ROOT = packed record
    free:              PUSED_MEM;
    used:              PUSED_MEM;
    pre_alloc:         PUSED_MEM;
    min_malloc:        Integer;
    block_size:        Integer;
    block_num:         Integer;
    first_block_usage: Integer;
    error_handler:     PERR_PROC;
  end;

  NET = record
    vio:              Pointer;
    buff:             PAnsiChar;
    buff_end:         PAnsiChar;
    write_pos:        PAnsiChar;
    read_pos:         PAnsiChar;
    fd:               Integer;
    max_packet:       Cardinal;
    max_packet_size:  Cardinal;
    pkt_nr:           Cardinal;
    compress_pkt_nr:  Cardinal;
    write_timeout:    Cardinal;
    read_timeout:     Cardinal;
    retry_count:      Cardinal;
    fcntl:            Integer;
    compress:         Byte;
    remain_in_buf:    LongInt;
    length:           LongInt;
    buf_length:       LongInt;
    where_b:          LongInt;
    return_status:    Pointer;
    reading_or_writing: Char;
    save_char:        Char;
    no_send_ok:       Byte;
    last_error:       array[1..MYSQL_ERRMSG_SIZE] of Char;
    sqlstate:         array[1..SQLSTATE_LENGTH + 1] of Char;
    last_errno:       Cardinal;
    error:            Char;
    query_cache_query: Pointer;
    report_error:     Byte;
    return_errno:     Byte;
  end;

  PMYSQL_FIELD = ^MYSQL_FIELD;
  MYSQL_FIELD = record
    name:             PAnsiChar;   // Name of column
    org_name:         PAnsiChar;   // Name of original column (added after 3.23.58)
    table:            PAnsiChar;   // Table of column if column was a field
    org_table:        PAnsiChar;   // Name of original table (added after 3.23.58
    db:               PAnsiChar;   // table schema (added after 3.23.58)
    catalog:	        PAnsiChar;   // table catalog (added after 3.23.58)
    def:              PAnsiChar;   // Default value (set by mysql_list_fields)
    length:           LongInt;     // Width of column
    max_length:       LongInt;     // Max width of selected set
    // added after 3.23.58
    name_length:      Cardinal;
    org_name_length:  Cardinal;
    table_length:     Cardinal;
    org_table_length: Cardinal;
    db_length:        Cardinal;
    catalog_length:   Cardinal;
    def_length:       Cardinal;
    //***********************
    flags:            Cardinal;    // Div flags
    decimals:         Cardinal;    // Number of decimals in field
    charsetnr:        Cardinal;    // char set number (added in 4.1)
    _type:            Cardinal;    // Type of field. Se mysql_com.h for types
  end;

  MYSQL_ROW = array[0..$ffff] of PAnsiChar;
  PMYSQL_ROW = ^MYSQL_ROW;

  PMYSQL_ROWS = ^MYSQL_ROWS;
  MYSQL_ROWS = record
    next:       PMYSQL_ROWS;
    data:       PMYSQL_ROW;
  end;

  MYSQL_DATA = record
    Rows:       Int64;
    Fields:     Cardinal;
    Data:       PMYSQL_ROWS;
    Alloc:      MEM_ROOT;
  end;
  PMYSQL_DATA = ^MYSQL_DATA;

  PMYSQL = ^MYSQL;
  MYSQL = record
    _net:            NET;
    connector_fd:    Pointer;
    host:            PAnsiChar;
    user:            PAnsiChar;
    passwd:          PAnsiChar;
    unix_socket:     PAnsiChar;
    server_version:  PAnsiChar;
    host_info:       PAnsiChar;
    info:            PAnsiChar;
    db:              PAnsiChar;
    charset:         PAnsiChar;
    fields:          PMYSQL_FIELD;
    field_alloc:     MEM_ROOT;
    affected_rows:   Int64;
    insert_id:       Int64;
    extra_info:      Int64;
    thread_id:       LongInt;
    packet_length:   LongInt;
    port:            Cardinal;
    client_flag:     LongInt;
    server_capabilities: LongInt;
    protocol_version: Cardinal;
    field_count:     Cardinal;
    server_status:   Cardinal;
    server_language: Cardinal;
    warning_count:   Cardinal;
    options:         Cardinal;
    status:          Byte;
    free_me:         Byte;
    reconnect:       Byte;
    scramble:        array[1..SCRAMBLE_LENGTH+1] of Char;
    rpl_pivot:       Byte;
    master:          PMYSQL;
    next_slave:      PMYSQL;
    last_used_slave: PMYSQL;
    last_used_con:   PMYSQL;
    stmts:           Pointer;
    methods:         Pointer;
    thd:             Pointer;
    unbuffered_fetch_owner: PByte;
  end;

  MYSQL_RES = record
    row_count:       Int64;
    field_count, current_field:     Integer;
    fields:          PMYSQL_FIELD;
    data:            PMYSQL_DATA;
    data_cursor:     PMYSQL_ROWS;
    field_alloc:     MEM_ROOT;
    row:             PMYSQL_ROW;     // If unbuffered read
    current_row:     PMYSQL_ROW;     // buffer to current row
    lengths:         PLongInt;       // column lengths of current row
    handle:          PMYSQL;         // for unbuffered reads
    eof:             Byte;           // Used my mysql_fetch_row
    is_ps:           Byte;
  end;
  PMYSQL_RES = ^MYSQL_RES;

  TMySQLOption = (
    MYSQL_OPT_CONNECT_TIMEOUT,
    MYSQL_OPT_COMPRESS,
    MYSQL_OPT_NAMED_PIPE,
    MYSQL_INIT_COMMAND,
    MYSQL_READ_DEFAULT_FILE,
    MYSQL_READ_DEFAULT_GROUP,
    MYSQL_SET_CHARSET_DIR,
    MYSQL_SET_CHARSET_NAME,
    MYSQL_OPT_LOCAL_INFILE,
    MYSQL_OPT_PROTOCOL,
    MYSQL_SHARED_MEMORY_BASE_NAME,
    MYSQL_OPT_READ_TIMEOUT,
    MYSQL_OPT_WRITE_TIMEOUT,
    MYSQL_OPT_USE_RESULT,
    MYSQL_OPT_USE_REMOTE_CONNECTION,
    MYSQL_OPT_USE_EMBEDDED_CONNECTION,
    MYSQL_OPT_GUESS_CONNECTION,
    MYSQL_SET_CLIENT_IP,
    MYSQL_SECURE_AUTH,
    MYSQL_REPORT_DATA_TRUNCATION,
    MYSQL_OPT_RECONNECT,
    MYSQL_OPT_SSL_VERIFY_SERVER_CERT,
    MYSQL_PLUGIN_DIR,
    MYSQL_DEFAULT_AUTH,
    MYSQL_OPT_BIND,
    MYSQL_OPT_SSL_KEY,
    MYSQL_OPT_SSL_CERT,
    MYSQL_OPT_SSL_CA,
    MYSQL_OPT_SSL_CAPATH,
    MYSQL_OPT_SSL_CIPHER,
    MYSQL_OPT_SSL_CRL,
    MYSQL_OPT_SSL_CRLPATH,
    // Connection attribute options
    MYSQL_OPT_CONNECT_ATTR_RESET,
    MYSQL_OPT_CONNECT_ATTR_ADD,
    MYSQL_OPT_CONNECT_ATTR_DELETE,
    MYSQL_SERVER_PUBLIC_KEY,
    MYSQL_ENABLE_CLEARTEXT_PLUGIN,
    MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS,
    MYSQL_OPT_SSL_ENFORCE,
    MYSQL_OPT_MAX_ALLOWED_PACKET,
    MYSQL_OPT_NET_BUFFER_LENGTH,
    MYSQL_OPT_TLS_VERSION,

    // MariaDB specific
    MYSQL_PROGRESS_CALLBACK=5999,
    MYSQL_OPT_NONBLOCK,
    // MariaDB Connector/C specific
    MYSQL_DATABASE_DRIVER=7000,
    MARIADB_OPT_SSL_FP,                // deprecated, use MARIADB_OPT_TLS_PEER_FP instead
    MARIADB_OPT_SSL_FP_LIST,           // deprecated, use MARIADB_OPT_TLS_PEER_FP_LIST instead
    MARIADB_OPT_TLS_PASSPHRASE,        // passphrase for encrypted certificates
    MARIADB_OPT_TLS_CIPHER_STRENGTH,
    MARIADB_OPT_TLS_VERSION,
    MARIADB_OPT_TLS_PEER_FP,           // single finger print for server certificate verification
    MARIADB_OPT_TLS_PEER_FP_LIST,      // finger print white list for server certificate verification
    MARIADB_OPT_CONNECTION_READ_ONLY,
    MYSQL_OPT_CONNECT_ATTRS,           // for mysql_get_optionv
    MARIADB_OPT_USERDATA,
    MARIADB_OPT_CONNECTION_HANDLER,
    MARIADB_OPT_PORT,
    MARIADB_OPT_UNIXSOCKET,
    MARIADB_OPT_PASSWORD,
    MARIADB_OPT_HOST,
    MARIADB_OPT_USER,
    MARIADB_OPT_SCHEMA,
    MARIADB_OPT_DEBUG,
    MARIADB_OPT_FOUND_ROWS,
    MARIADB_OPT_MULTI_RESULTS,
    MARIADB_OPT_MULTI_STATEMENTS,
    MARIADB_OPT_INTERACTIVE,
    MARIADB_OPT_PROXY_HEADER
    );

  // MySQL data types
  TDBDatatypeIndex = (dtTinyint, dtSmallint, dtMediumint, dtInt, dtBigint, dtSerial, dtBigSerial,
    dtFloat, dtDouble, dtDecimal, dtNumeric, dtReal, dtDoublePrecision, dtMoney, dtSmallmoney,
    dtDate, dtTime, dtYear, dtDatetime, dtDatetime2, dtDatetimeOffset, dtSmalldatetime, dtTimestamp, dtInterval,
    dtChar, dtNchar, dtVarchar, dtNvarchar, dtTinytext, dtText, dtNtext, dtMediumtext, dtLongtext,
    dtJson, dtCidr, dtInet, dtMacaddr,
    dtBinary, dtVarbinary, dtTinyblob, dtBlob, dtMediumblob, dtLongblob, dtImage,
    dtEnum, dtSet, dtBit, dtVarBit, dtBool, dtRegClass, dtUnknown,
    dtCursor, dtSqlvariant, dtTable, dtUniqueidentifier, dtHierarchyid, dtXML,
    dtPoint, dtLinestring, dtLineSegment, dtPolygon, dtGeometry, dtBox, dtPath, dtCircle, dtMultipoint, dtMultilinestring, dtMultipolygon, dtGeometrycollection
    );

  // MySQL data type categorization
  TDBDatatypeCategoryIndex = (dtcInteger, dtcReal, dtcText, dtcBinary, dtcTemporal, dtcSpatial, dtcOther);

  // MySQL native column type constants. See include/mysql.h.pp in the server code
  TMySQLType = (mytDecimal, mytTiny, mytShort, mytLong, mytFloat, mytDouble, mytNull, mytTimestamp,
    mytLonglong, mytInt24, mytDate, mytTime, mytDatetime, mytYear, mytNewdate, mytVarchar,
    mytBit, mytTimestamp2, mytDatetime2, mytTime2, mytJson=245, mytNewdecimal, mytEnum, mytSet, mytTinyblob,
    mytMediumblob, mytLongblob, mytBlob, mytVarstring, mytString, mytGeometry);
  // MySQL data type structure
  TDBDatatype = record
    Index:           TDBDatatypeIndex;
    NativeType:      TMySQLType; // See above
    NativeTypes:     String; // Same as above, but for multiple postgresql oid's
    Name:            String;
    Names:           String;
    Description:     String;
    HasLength:       Boolean; // Can have Length- or Set-attribute?
    RequiresLength:  Boolean; // Must have a Length- or Set-attribute?
    HasBinary:       Boolean; // Can be binary?
    HasDefault:      Boolean; // Can have a default value?
    LoadPart:        Boolean; // Select per SUBSTR() or LEFT()
    DefLengthSet:    String;  // Should be set for types which require a length/set
    Format:          String;  // Used for date/time values when displaying and generating queries
    ValueMustMatch:  String;
    Category:        TDBDatatypeCategoryIndex;
  end;

  // MySQL data type category structure
  TDBDatatypeCategory = record
    Index:           TDBDatatypeCategoryIndex;
    Name:            String;
    Color:           TColor;
    NullColor:       TColor;
  end;

  // MySQL functions structure
  TMySQLFunction = record
    Name:         String;
    Declaration:  String;
    Category:     String;
    Version:      Integer; // Minimum MySQL version where function is available
    Description:  String;
  end;

  // PostgreSQL structures
  TPQConnectStatus = (CONNECTION_OK, CONNECTION_BAD, CONNECTION_STARTED, CONNECTION_MADE, CONNECTION_AWAITING_RESPONSE, CONNECTION_AUTH_OK, CONNECTION_SETENV, CONNECTION_SSL_STARTUP, CONNECTION_NEEDED);
  PPGconn = Pointer;
  PPGresult = Pointer;
  POid = Cardinal;

  // SQLite structures
  Psqlite3 = Pointer;
  Psqlite3_stmt = Pointer;

  // Server variables
  TVarScope = (vsGlobal, vsSession, vsBoth);
  TServerVariable = record
    Name: String;
    IsDynamic: Boolean;
    VarScope: TVarScope;
    EnumValues: String;
  end;

  // Custom exception class for any connection or database related error
  EDbError = class(Exception)
    public
      ErrorCode: Cardinal;
      constructor Create(const Msg: string; const ErrorCode: Cardinal=0);
  end;

  // DLL loading
  TDbLib = class(TObject)
    const
      LIB_PROC_ERROR: Cardinal = 1000;
    private
      FDllFile: String;
      FHandle: HMODULE;
      procedure AssignProc(var Proc: FARPROC; Name: PAnsiChar; Mandantory: Boolean=True);
      procedure AssignProcedures; virtual; abstract;
    public
      property Handle: HMODULE read FHandle;
      property DllFile: String read FDllFile;
      constructor Create(DllFile: String);
      destructor Destroy; override;
  end;
  TMySQLLib = class(TDbLib)
    mysql_affected_rows: function(Handle: PMYSQL): Int64; stdcall;
    mysql_character_set_name: function(Handle: PMYSQL): PAnsiChar; stdcall;
    mysql_close: procedure(Handle: PMYSQL); stdcall;
    mysql_data_seek: procedure(Result: PMYSQL_RES; Offset: Int64); stdcall;
    mysql_errno: function(Handle: PMYSQL): Cardinal; stdcall;
    mysql_error: function(Handle: PMYSQL): PAnsiChar; stdcall;
    mysql_fetch_field_direct: function(Result: PMYSQL_RES; FieldNo: Cardinal): PMYSQL_FIELD; stdcall;
    mysql_fetch_field: function(Result: PMYSQL_RES): PMYSQL_FIELD; stdcall;
    mysql_fetch_lengths: function(Result: PMYSQL_RES): PLongInt; stdcall;
    mysql_fetch_row: function(Result: PMYSQL_RES): PMYSQL_ROW; stdcall;
    mysql_free_result: procedure(Result: PMYSQL_RES); stdcall;
    mysql_get_client_info: function: PAnsiChar; stdcall;
    mysql_get_server_info: function(Handle: PMYSQL): PAnsiChar; stdcall;
    mysql_init: function(Handle: PMYSQL): PMYSQL; stdcall;
    mysql_num_fields: function(Result: PMYSQL_RES): Integer; stdcall;
    mysql_num_rows: function(Result: PMYSQL_RES): Int64; stdcall;
    mysql_options: function(Handle: PMYSQL; Option: Integer; arg: PAnsiChar): Integer; stdcall;
    mysql_optionsv: function(Handle: PMYSQL; Option: Integer; arg, val: PAnsiChar): Integer; stdcall;
    mysql_ping: function(Handle: PMYSQL): Integer; stdcall;
    mysql_real_connect: function(Handle: PMYSQL; const Host, User, Passwd, Db: PAnsiChar; Port: Cardinal; const UnixSocket: PAnsiChar; ClientFlag: Cardinal): PMYSQL; stdcall;
    mysql_real_query: function(Handle: PMYSQL; const Query: PAnsiChar; Length: Cardinal): Integer; stdcall;
    mysql_ssl_set: function(Handle: PMYSQL; const key, cert, CA, CApath, cipher: PAnsiChar): Byte; stdcall;
    mysql_stat: function(Handle: PMYSQL): PAnsiChar; stdcall;
    mysql_store_result: function(Handle: PMYSQL): PMYSQL_RES; stdcall;
    mysql_thread_id: function(Handle: PMYSQL): Cardinal; stdcall;
    mysql_next_result: function(Handle: PMYSQL): Integer; stdcall;
    mysql_set_character_set: function(Handle: PMYSQL; csname: PAnsiChar): Integer; stdcall;
    mysql_thread_init: function: Byte; stdcall;
    mysql_thread_end: procedure; stdcall;
    mysql_warning_count: function(Handle: PMYSQL): Cardinal; stdcall;
    private
      procedure AssignProcedures; override;
  end;
  TPostgreSQLLib = class(TDbLib)
    PQconnectdb: function(const ConnInfo: PAnsiChar): PPGconn cdecl;
    PQerrorMessage: function(const Handle: PPGconn): PAnsiChar cdecl;
    PQresultErrorMessage: function(const Result: PPGresult): PAnsiChar cdecl;
    PQresultErrorField: function(const Result: PPGresult; fieldcode: Integer): PAnsiChar;
    PQfinish: procedure(const Handle: PPGconn);
    PQstatus: function(const Handle: PPGconn): TPQConnectStatus cdecl;
    PQsendQuery: function(const Handle: PPGconn; command: PAnsiChar): Integer cdecl;
    PQgetResult: function(const Handle: PPGconn): PPGresult cdecl;
    PQbackendPID: function(const Handle: PPGconn): Integer cdecl;
    PQcmdTuples: function(Result: PPGresult): PAnsiChar; cdecl;
    PQntuples: function(Result: PPGresult): Integer; cdecl;
    PQclear: procedure(Result: PPGresult); cdecl;
    PQnfields: function(Result: PPGresult): Integer; cdecl;
    PQfname: function(const Result: PPGresult; column_number: Integer): PAnsiChar; cdecl;
    PQftype: function(const Result: PPGresult; column_number: Integer): POid; cdecl;
    PQftable: function(const Result: PPGresult; column_number: Integer): POid; cdecl;
    PQgetvalue: function(const Result: PPGresult; row_number: Integer; column_number: Integer): PAnsiChar; cdecl;
    PQgetlength: function(const Result: PPGresult; row_number: Integer; column_number: Integer): Integer; cdecl;
    PQgetisnull: function(const Result: PPGresult; row_number: Integer; column_number: Integer): Integer; cdecl;
    PQlibVersion: function(): Integer; cdecl;
    private
      procedure AssignProcedures; override;
  end;
  TSQLiteLib = class(TDbLib)
    sqlite3_open: function(const filename: PAnsiChar; var ppDb: Psqlite3): Integer; cdecl;
    sqlite3_libversion: function(): PAnsiChar; cdecl;
    sqlite3_close: function(ppDb: Psqlite3): Integer; cdecl;
    sqlite3_errmsg: function(ppDb: Psqlite3): PAnsiChar; cdecl;
    sqlite3_errcode: function(ppDb: Psqlite3): Integer; cdecl;
    sqlite3_prepare_v2: function(ppDb: Psqlite3; zSql: PAnsiChar; nByte: Integer; var ppStmt: Psqlite3_stmt; pzTail: PAnsiChar): Integer; cdecl;
    sqlite3_exec: function(ppDb: Psqlite3; sql: PAnsiChar; callback: Integer; callvack_arg: Pointer; errmsg: PAnsiChar): Integer; cdecl;
    sqlite3_finalize: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    sqlite3_step: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    sqlite3_changes: function(ppDb: Psqlite3): Integer; cdecl;
    sqlite3_column_text: function(pStmt: Psqlite3_stmt; iCol: Integer): PAnsiChar; cdecl;
    sqlite3_column_count: function(pStmt: Psqlite3_stmt): Integer; cdecl;
    sqlite3_column_name: function(pStmt: Psqlite3_stmt; N: Integer): PAnsiChar; cdecl;
    private
      procedure AssignProcedures; override;
  end;

var
  MySQLKeywords: TStringList;
  MySQLErrorCodes: TStringList;

  // MySQL data type categories
  DatatypeCategories: array[TDBDatatypeCategoryIndex] of TDBDatatypeCategory = (
    (
      Index:           dtcInteger;
      Name:            'Integer'
    ),
    (
      Index:           dtcReal;
      Name:            'Real'
    ),
    (
      Index:           dtcText;
      Name:            'Text'
    ),
    (
      Index:           dtcBinary;
      Name:            'Binary'
    ),
    (
      Index:           dtcTemporal;
      Name:            'Temporal (time)'
    ),
    (
      Index:           dtcSpatial;
      Name:            'Spatial (geometry)'
    ),
    (
      Index:           dtcOther;
      Name:            'Other'
    )
  );

  // MySQL Data Type List and Properties
  MySQLDatatypes: array [0..37] of TDBDatatype =
  (
    (
      Index:           dtUnknown;
      NativeTypes:     '99999';
      Name:            'UNKNOWN';
      Description:     'Unknown data type';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtTinyint;
      NativeType:      mytTiny;
      Name:            'TINYINT';
      Description:     'TINYINT[(M)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A very small integer. The signed range is -128 to 127. ' +
        'The unsigned range is 0 to 255.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtSmallint;
      NativeType:      mytShort;
      Name:            'SMALLINT';
      Description:     'SMALLINT[(M)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A small integer. The signed range is -32768 to 32767. ' +
        'The unsigned range is 0 to 65535.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtMediumint;
      NativeType:      mytInt24;
      Name:            'MEDIUMINT';
      Description:     'MEDIUMINT[(M)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A medium-sized integer. The signed range is -8388608 to 8388607. ' +
        'The unsigned range is 0 to 16777215.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtInt;
      NativeType:      mytLong;
      Name:            'INT';
      Description:     'INT[(M)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A normal-size integer. The signed range is -2147483648 to 2147483647. ' +
        'The unsigned range is 0 to 4294967295.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtBigint;
      NativeType:      mytLonglong;
      Name:            'BIGINT';
      Description:     'BIGINT[(M)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A large integer. The signed range is -9223372036854775808 to ' +
        '9223372036854775807. The unsigned range is 0 to 18446744073709551615.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtFloat;
      NativeType:      mytFloat;
      Name:            'FLOAT';
      Description:     'FLOAT[(M,D)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A small (single-precision) floating-point number. Allowable values are '+
        '-3.402823466E+38 to -1.175494351E-38, 0, and 1.175494351E-38 to '+
        '3.402823466E+38. These are the theoretical limits, based on the IEEE '+
        'standard. The actual range might be slightly smaller depending on your '+
        'hardware or operating system.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtDouble;
      NativeType:      mytDouble;
      Name:            'DOUBLE';
      Description:     'DOUBLE[(M,D)] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A normal-size (double-precision) floating-point number. Allowable ' +
        'values are -1.7976931348623157E+308 to -2.2250738585072014E-308, 0, and ' +
        '2.2250738585072014E-308 to 1.7976931348623157E+308. These are the ' +
        'theoretical limits, based on the IEEE standard. The actual range might ' +
        'be slightly smaller depending on your hardware or operating system.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtDecimal;
      NativeType:      mytNewdecimal;
      Name:            'DECIMAL';
      Description:     'DECIMAL[(M[,D])] [UNSIGNED] [ZEROFILL]' + sLineBreak +
        'A packed "exact" fixed-point number. M is the total number of digits ' +
        '(the precision) and D is the number of digits after the decimal point ' +
        '(the scale). The decimal point and (for negative numbers) the "-" sign ' +
        'are not counted in M. If D is 0, values have no decimal point or ' +
        'fractional part. The maximum number of digits (M) for DECIMAL is 65. ' +
        'The maximum number of supported decimals (D) is 30. If D is omitted, ' +
        'the default is 0. If M is omitted, the default is 10.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '10,0';
      Category:        dtcReal;
    ),
    (
      Index:           dtDate;
      NativeType:      mytDate;
      Name:            'DATE';
      Description:     'DATE' + sLineBreak +
        'A date. The supported range is ''1000-01-01'' to ''9999-12-31''. MySQL ' +
        'displays DATE values in ''YYYY-MM-DD'' format, but allows assignment of ' +
        'values to DATE columns using either strings or numbers.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtTime;
      NativeType:      mytTime;
      Name:            'TIME';
      Description:     'TIME' + sLineBreak +
        'A time. The range is ''-838:59:59'' to ''838:59:59''. MySQL displays TIME ' +
        'values in ''HH:MM:SS'' format, but allows assignment of values to TIME ' +
        'columns using either strings or numbers.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtYear;
      NativeType:      mytYear;
      Name:            'YEAR';
      Description:     'YEAR[(2|4)]' + sLineBreak +
        'A year in two-digit or four-digit format. The default is four-digit ' +
        'format. In four-digit format, the allowable values are 1901 to 2155, ' +
        'and 0000. In two-digit format, the allowable values are 70 to 69, ' +
        'representing years from 1970 to 2069. MySQL displays YEAR values in ' +
        'YYYY format, but allows you to assign values to YEAR columns using ' +
        'either strings or numbers.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDatetime;
      NativeType:      mytDatetime;
      Name:            'DATETIME';
      Description:     'DATETIME' + sLineBreak +
        'A date and time combination. The supported range is ''1000-01-01 ' +
        '00:00:00'' to ''9999-12-31 23:59:59''. MySQL displays DATETIME values in ' +
        '''YYYY-MM-DD HH:MM:SS'' format, but allows assignment of values to ' +
        'DATETIME columns using either strings or numbers.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtTimestamp;
      NativeType:      mytTimestamp;
      Name:            'TIMESTAMP';
      Description:     'TIMESTAMP' + sLineBreak +
        'A timestamp. The range is ''1970-01-01 00:00:01'' UTC to ''2038-01-09 ' +
        '03:14:07'' UTC. TIMESTAMP values are stored as the number of seconds ' +
        'since the epoch (''1970-01-01 00:00:00'' UTC). A TIMESTAMP cannot ' +
        'represent the value ''1970-01-01 00:00:00'' because that is equivalent to ' +
        '0 seconds from the epoch and the value 0 is reserved for representing ' +
        '''0000-00-00 00:00:00'', the "zero" TIMESTAMP value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtChar;
      NativeType:      mytString;
      Name:            'CHAR';
      Description:     'CHAR[(M)]' + sLineBreak +
        'A fixed-length string that is always right-padded with spaces to the ' +
        'specified length when stored. M represents the column length in ' +
        'characters. The range of M is 0 to 255. If M is omitted, the length is 1.' + sLineBreak + sLineBreak +
        '*Note*: Trailing spaces are removed when CHAR values are retrieved ' +
        'unless the PAD_CHAR_TO_FULL_LENGTH SQL mode is enabled.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       True;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '50';
      Category:        dtcText;
    ),
    (
      Index:           dtVarchar;
      NativeType:      mytVarstring;
      Name:            'VARCHAR';
      Description:     'VARCHAR(M)' + sLineBreak +
        'A variable-length string. M represents the maximum column length in ' +
        'characters. The range of M is 0 to 65,535. The effective maximum length ' +
        'of a VARCHAR is subject to the maximum row size (65,535 bytes, which is ' +
        'shared among all columns) and the character set used. For example, utf8 ' +
        'characters can require up to three bytes per character, so a VARCHAR ' +
        'column that uses the utf8 character set can be declared to be a maximum ' +
        'of 21,844 characters. ' + sLineBreak + sLineBreak +
        '*Note*: MySQL 5.1 follows the standard SQL specification, and does not ' +
        'remove trailing spaces from VARCHAR values.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       True; // MySQL-Help says the opposite but it's valid for older versions at least.
      HasDefault:      True;
      LoadPart:        True;
      DefLengthSet:    '50';
      Category:        dtcText;
    ),
    (
      Index:           dtTinytext;
      NativeType:      mytTinyblob;
      Name:            'TINYTEXT';
      Description:     'TINYTEXT' + sLineBreak +
        'A TEXT column with a maximum length of 255 (2^8 - 1) characters. The ' +
        'effective maximum length is less if the value contains multi-byte ' +
        'characters. Each TINYTEXT value is stored using a one-byte length ' +
        'prefix that indicates the number of bytes in the value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       True;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcText;
    ),
    (
      Index:           dtText;
      NativeType:      mytBlob;
      Name:            'TEXT';
      Description:     'TEXT[(M)]' + sLineBreak +
        'A TEXT column with a maximum length of 65,535 (2^16 - 1) characters. The ' +
        'effective maximum length is less if the value contains multi-byte ' +
        'characters. Each TEXT value is stored using a two-byte length prefix ' +
        'that indicates the number of bytes in the value. ' + sLineBreak +
        'An optional length M can be given for this type. If this is done, MySQL ' +
        'creates the column as the smallest TEXT type large enough to hold ' +
        'values M characters long.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       True;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtMediumtext;
      NativeType:      mytMediumblob;
      Name:            'MEDIUMTEXT';
      Description:     'MEDIUMTEXT' + sLineBreak +
        'A TEXT column with a maximum length of 16,777,215 (2^24 - 1) characters. ' +
        'The effective maximum length is less if the value contains multi-byte ' +
        'characters. Each MEDIUMTEXT value is stored using a three-byte length ' +
        'prefix that indicates the number of bytes in the value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       True;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtLongtext;
      NativeType:      mytLongblob;
      Name:            'LONGTEXT';
      Description:     'LONGTEXT' + sLineBreak +
        'A TEXT column with a maximum length of 4,294,967,295 or 4GB (2^32 - 1) ' +
        'characters. The effective maximum length is less if the value contains ' +
        'multi-byte characters. The effective maximum length of LONGTEXT columns ' +
        'also depends on the configured maximum packet size in the client/server ' +
        'protocol and available memory. Each LONGTEXT value is stored using a ' +
        'four-byte length prefix that indicates the number of bytes in the ' +
        'value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       True;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtJson;
      NativeType:      mytJson;
      Name:            'JSON';
      Description:     'JSON' + sLineBreak +
        'Documents stored in JSON columns are converted to an internal format that '+
        'permits quick read access to document elements. When the server later must '+
        'read a JSON value stored in this binary format, the value need not be parsed '+
        'from a text representation. The binary format is structured to enable the '+
        'server to look up subobjects or nested values directly by key or array index '+
        'without reading all values before or after them in the document.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcText;
    ),
    (
      Index:           dtBinary;
      NativeType:      mytString;
      Name:            'BINARY';
      Description:     'BINARY(M)' + sLineBreak +
        'The BINARY type is similar to the CHAR type, but stores binary byte ' +
        'strings rather than non-binary character strings. M represents the ' +
        'column length in bytes.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '50';
      Category:        dtcBinary;
    ),
    (
      Index:           dtVarbinary;
      NativeType:      mytVarstring;
      Name:            'VARBINARY';
      Description:     'VARBINARY(M)' + sLineBreak +
        'The VARBINARY type is similar to the VARCHAR type, but stores binary ' +
        'byte strings rather than non-binary character strings. M represents the ' +
        'maximum column length in bytes.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        True;
      DefLengthSet:    '50';
      Category:        dtcBinary;
    ),
    (
      Index:           dtTinyblob;
      NativeType:      mytTinyblob;
      Name:           'TINYBLOB';
      Description:     'TINYBLOB' + sLineBreak +
        'A BLOB column with a maximum length of 255 (2^8 - 1) bytes. Each ' +
        'TINYBLOB value is stored using a one-byte length prefix that indicates ' +
        'the number of bytes in the value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcBinary;
    ),
    (
      Index:           dtBlob;
      NativeType:      mytBlob;
      Name:            'BLOB';
      Description:     'BLOB[(M)]' + sLineBreak +
        'A BLOB column with a maximum length of 65,535 (2^16 - 1) bytes. Each ' +
        'BLOB value is stored using a two-byte length prefix that indicates the ' +
        'number of bytes in the value. ' + sLineBreak +
        'An optional length M can be given for this type. If this is done, MySQL ' +
        'creates the column as the smallest BLOB type large enough to hold ' +
        'values M bytes long.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcBinary;
    ),
    (
      Index:           dtMediumblob;
      NativeType:      mytMediumblob;
      Name:            'MEDIUMBLOB';
      Description:     'MEDIUMBLOB' + sLineBreak +
        'A BLOB column with a maximum length of 16,777,215 (2^24 - 1) bytes. Each ' +
        'MEDIUMBLOB value is stored using a three-byte length prefix that ' +
        'indicates the number of bytes in the value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcBinary;
    ),
    (
      Index:           dtLongblob;
      NativeType:      mytLongblob;
      Name:            'LONGBLOB';
      Description:     'LONGBLOB' + sLineBreak +
        'A BLOB column with a maximum length of 4,294,967,295 or 4GB (2^32 - 1) ' +
        'bytes. The effective maximum length of LONGBLOB columns depends on the ' +
        'configured maximum packet size in the client/server protocol and ' +
        'available memory. Each LONGBLOB value is stored using a four-byte ' +
        'length prefix that indicates the number of bytes in the value.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcBinary;
    ),
    (
      Index:           dtEnum;
      NativeType:      mytEnum;
      Name:            'ENUM';
      Description:     'ENUM(''value1'',''value2'',...)' + sLineBreak +
        'An enumeration. A string object that can have only one value, chosen ' +
        'from the list of values ''value1'', ''value2'', ..., NULL or the special '''' ' +
        'error value. An ENUM column can have a maximum of 65,535 distinct ' +
        'values. ENUM values are represented internally as integers.';
      HasLength:       True; // Obviously this is not meant as "length", but as "set of values"
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '''Y'',''N''';
      Category:        dtcOther;
    ),
    (
      Index:           dtSet;
      NativeType:      mytSet;
      Name:            'SET';
      Description:     'SET(''value1'',''value2'',...)' + sLineBreak +
        'A set. A string object that can have zero or more values, each of which ' +
        'must be chosen from the list of values ''value1'', ''value2'', ... A SET ' +
        'column can have a maximum of 64 members. SET values are represented ' +
        'internally as integers.';
      HasLength:       True; // Same as for ENUM
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '''Value A'',''Value B''';
      Category:        dtcOther;
    ),
    (
      Index:           dtBit;
      NativeType:      mytBit;
      Name:            'BIT';
      Description:     'BIT[(M)]' + sLineBreak +
        'A bit-field type. M indicates the number of bits per value, from 1 to ' +
        '64. The default is 1 if M is omitted.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtPoint;
      NativeType:      mytGeometry;
      Name:            'POINT';
      Description:     'POINT(x,y)' + sLineBreak +
        'Constructs a WKB Point using its coordinates.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtLinestring;
      NativeType:      mytGeometry;
      Name:            'LINESTRING';
      Description:     'LINESTRING(pt1,pt2,...)' + sLineBreak +
        'Constructs a WKB LineString value from a number of WKB Point arguments. ' +
        'If any argument is not a WKB Point, the return value is NULL. If the ' +
        'number of Point arguments is less than two, the return value is NULL.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtPolygon;
      NativeType:      mytGeometry;
      Name:            'POLYGON';
      Description:     'POLYGON(ls1,ls2,...)' + sLineBreak +
        'Constructs a WKB Polygon value from a number of WKB LineString ' +
        'arguments. If any argument does not represent the WKB of a LinearRing ' +
        '(that is, not a closed and simple LineString) the return value is NULL.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtGeometry;
      NativeType:      mytGeometry;
      Name:            'GEOMETRY';
      Description:     '';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtMultipoint;
      NativeType:      mytGeometry;
      Name:            'MULTIPOINT';
      Description:     'MULTIPOINT(pt1,pt2,...)' + sLineBreak +
        'Constructs a WKB MultiPoint value using WKB Point arguments. If any ' +
        'argument is not a WKB Point, the return value is NULL.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtMultilinestring;
      NativeType:      mytGeometry;
      Name:            'MULTILINESTRING';
      Description:     'MULTILINESTRING(ls1,ls2,...)' + sLineBreak +
        'Constructs a WKB MultiLineString value using WKB LineString arguments. ' +
        'If any argument is not a WKB LineString, the return value is NULL.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtMultipolygon;
      NativeType:      mytGeometry;
      Name:            'MULTIPOLYGON';
      Description:     'MULTIPOLYGON(poly1,poly2,...)' + sLineBreak +
        'Constructs a WKB MultiPolygon value from a set of WKB Polygon ' +
        'arguments. If any argument is not a WKB Polygon, the return value is ' +
        'NULL.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtGeometrycollection;
      NativeType:      mytGeometry;
      Name:            'GEOMETRYCOLLECTION';
      Description:     'GEOMETRYCOLLECTION(g1,g2,...)' + sLineBreak +
        'Constructs a WKB GeometryCollection. If any argument is not a ' +
        'well-formed WKB representation of a geometry, the return value is NULL.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    )

  );

  MSSQLDatatypes: array [0..33] of TDBDatatype =
  (
    (
      Index:           dtUnknown;
      NativeTypes:     '99999';
      Name:            'UNKNOWN';
      Description:     'Unknown data type';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index: dtTinyint;
      Name:            'TINYINT';
      Description:     'Integer data from 0 through 255.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtSmallint;
      Name:            'SMALLINT';
      Description:     'Integer data from -2^15 (-32,768) through 2^15 - 1 (32,767).';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtInt;
      Name:            'INT';
      Description:     'Integer (whole number) data from -2^31 (-2,147,483,648) through 2^31 - 1 (2,147,483,647).';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtBigint;
      Name:            'BIGINT';
      Description:     'Integer (whole number) data from -2^63 (-9,223,372,036,854,775,808) through 2^63-1 (9,223,372,036,854,775,807).';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtBit;
      Name:            'BIT';
      Description:     '0 or 1';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtDecimal;
      Name:            'DECIMAL';
      Description:     'Fixed precision and scale numeric data from -10^38 +1 through 10^38 1.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '10,0';
      Category:        dtcReal;
    ),
    (
      Index:           dtNumeric;
      Name:            'NUMERIC';
      Description:     'Functionally equivalent to decimal.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      DefLengthSet:    '10,0';
      Category:        dtcReal;
    ),
    (
      Index:           dtMoney;
      Name:            'MONEY';
      Description:     'Monetary data values from -2^63 (-922,337,203,685,477.5808) through 2^63 - 1 (+922,337,203,685,477.5807), with accuracy to a ten-thousandth of a monetary unit.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtSmallmoney;
      Name:            'SMALLMONEY';
      Description:     'Monetary data values from -214,748.3648 through +214,748.3647, with accuracy to a ten-thousandth of a monetary unit.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtFloat;
      Name:            'FLOAT';
      Description:     'Floating precision number data with the following valid values: -1.79E + 308 through -2.23E - 308, 0 and 2.23E + 308 through 1.79E + 308.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtReal;
      Name:            'REAL';
      Description:     'Floating precision number data with the following valid values: -3.40E + 38 through -1.18E - 38, 0 and 1.18E - 38 through 3.40E + 38.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtTime;
      Name:            'TIME';
      Description:     'The time data type stores time values only, based on a 24-hour clock. '+
        'The time data type has a range of 00:00:00.0000000 through 23:59:59.9999999 with an '+
        'accuracy of 100 nanoseconds. The default value is 00:00:00.0000000 (midnight). The '+
        'time data type supports user-defined fractional second precision, and the storage '+
        'size varies from 3 to 6 bytes, based on the precision specified.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDate;
      Name:            'DATE';
      Description:     'The date data type has a range of January 1, 01 through December 31, '+
        '9999 with an accuracy of 1 day. The default value is January 1, 1900. The storage size '+
        'is 3 bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDatetime;
      Name:            'DATETIME';
      Description:     'Date and time data from January 1, 1753, through December 31, 9999, with an accuracy of three-hundredths of a second, or 3.33 milliseconds.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss.zzz';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDatetime2;
      Name:            'DATETIME2';
      Description:     'Date and time data from January 1,1 AD through December 31, 9999 AD, with an accuracy of three-hundredths of a second, or 3.33 milliseconds.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss.zzzzzzz';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDatetimeOffset;
      Name:            'DATETIMEOFFSET';
      Description:     'Defines a date that is combined with a time of a day that has time zone awareness and is based on a 24-hour clock.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss.zzzzzzz';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtSmalldatetime;
      Name:            'SMALLDATETIME';
      Description:     'Date and time data from January 1, 1900, through June 6, 2079, with an accuracy of one minute.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtTimestamp;
      Name:            'TIMESTAMP';
      Description:     'A database-wide unique number that gets updated every time a row gets updated.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtChar;
      Name:            'CHAR';
      Description:     'Fixed-length non-Unicode character data with a maximum length of 8,000 characters.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        True;
      DefLengthSet:    '50';
      Category:        dtcText;
    ),
    (
      Index:           dtVarchar;
      Name:            'VARCHAR';
      Description:     'Variable-length non-Unicode data with a maximum of 8,000 characters.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        True;
      DefLengthSet:    '50';
      Category:        dtcText;
    ),
    (
      Index:           dtText;
      Name:            'TEXT';
      Description:     'Variable-length non-Unicode data with a maximum length of 2^31 - 1 (2,147,483,647) characters.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtNchar;
      Name:            'NCHAR';
      Description:     'Fixed-length Unicode data with a maximum length of 4,000 characters.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        True;
      DefLengthSet:    '50';
      Category:        dtcText;
    ),
    (
      Index:           dtNvarchar;
      Name:            'NVARCHAR';
      Description:     'Variable-length Unicode data with a maximum length of 4,000 characters. sysname is a system-supplied user-defined data type that is functionally equivalent to nvarchar(128) and is used to reference database object names.';
      HasLength:       True;
      RequiresLength:  True;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        True;
      DefLengthSet:    '50';
      Category:        dtcText;
    ),
    (
      Index:           dtNtext;
      Name:            'NTEXT';
      Description:     'Variable-length Unicode data with a maximum length of 2^30 - 1 (1,073,741,823) characters.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtBinary;
      Name:            'BINARY';
      Description:     'Fixed-length binary data with a maximum length of 8,000 bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcBinary;
    ),
    (
      Index:           dtVarbinary;
      Name:            'VARBINARY';
      Description:     'Variable-length binary data with a maximum length of 8,000 bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcBinary;
    ),
    (
      Index:           dtImage;
      Name:            'IMAGE';
      Description:     'Variable-length binary data with a maximum length of 2^31 - 1 (2,147,483,647) bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcBinary;
    ),
    (
      Index:           dtCursor;
      Name:            'CURSOR';
      Description:     'A reference to a cursor.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtSqlvariant;
      Name:            'SQL_VARIANT';
      Description:     'A data type that stores values of various SQL Server-supported data types, except text, ntext, timestamp, and sql_variant.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtTable;
      Name:            'TABLE';
      Description:     'A special data type used to store a result set for later processing .';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtUniqueidentifier;
      Name:            'UNIQUEIDENTIFIER';
      Description:     'A globally unique identifier (GUID).';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtHierarchyid;
      Name:            'HIERARCHYID';
      Description:     'Represents a position in a hierarchy.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtXML;
      Name:            'XML';
      Description:     'Lets you store XML documents and fragments.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    )
  );

  PostgreSQLDatatypes: Array[0..35] of TDBDatatype =
  (
    (
      Index:           dtUnknown;
      NativeTypes:     '99999';
      Name:            'UNKNOWN';
      Description:     'Unknown data type';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtSmallint;
      NativeTypes:     '21';
      Name:            'SMALLINT';
      Names:           'smallint|int2';
      Description:     'Small-range integer. Range: -32768 to +32767. Storage Size: 2 Bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      ValueMustMatch:  '^\d{1,5}$';
      Category:        dtcInteger;
    ),
    (
      Index:           dtInt;
      // 26 = oid, 28 = xid
      NativeTypes:     '23|26|28';
      Name:            'INTEGER';
      Names:           'integer|int4|int|oid|xid';
      Description:     'Typical choice for integer. Range: -2147483648 to +2147483647. Storage Size: 4 Bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      ValueMustMatch:  '^\d{1,10}$';
      Category:        dtcInteger;
    ),
    (
      Index:           dtBigint;
      NativeTypes:     '20';
      Name:            'BIGINT';
      Names:           'bigint|int8';
      Description:     'Large-range integer. Range: -9223372036854775808 to 9223372036854775807. Storage Size: 8 Bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      ValueMustMatch:  '^\d{1,19}$';
      Category:        dtcInteger;
    ),
    (
      Index:           dtSerial;
      Name:            'SERIAL';
      Names:           'serial|serial4';
      Description:     'Autoincrementing integer. Range: 1 to 2147483647. Storage Size: 4 Bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtBigSerial;
      Name:            'BIGSERIAL';
      Names:           'bigserial|serial8';
      Description:     'Large autoincrementing integer. Range: 1 to 9223372036854775807. Storage Size: 8 Bytes.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtVarBit;
      NativeTypes:     '1562';
      Name:            'BIT VARYING';
      Names:           'bit varying|varbit';
      Description:     'Variable-length bit string.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtBit;
      NativeTypes:     '1560';
      Name:            'BIT';
      Names:           'bit';
      Description:     'Fixed-length bit string.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      True;
      LoadPart:        False;
      Category:        dtcInteger;
    ),
    (
      Index:           dtNumeric;
      NativeTypes:     '1700';
      Name:            'NUMERIC';
      Names:           'numeric|float8|decimal';
      Description:     'User-specified precision, exact. Range: no limit. Storage Size: variable.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtReal;
      NativeTypes:     '700';
      Name:            'REAL';
      Names:           'real|float4';
      Description:     'Variable-precision, inexact. Range: 6 decimal digits precision. Storage Size: 4 Bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtDoublePrecision;
      NativeTypes:     '701|1700';
      Name:            'DOUBLE PRECISION';
      Names:           'double precision|float8';
      Description:     'Variable-precision, inexact. Range: 15 decimal digits precision. Storage Size: 8 Bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtMoney;
      NativeTypes:     '790';
      Name:            'MONEY';
      Description:     'Currency amount. Range: -92233720368547758.08 to +92233720368547758.07. Storage Size: 8 Bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcReal;
    ),
    (
      Index:           dtChar;
      NativeTypes:     '18|1042';
      Name:            'CHAR';
      Names:           'CHARACTER';
      Description:     'Fixed-length, blank padded.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtVarchar;
      NativeTypes:     '18|19|24|1043|1043';
      Name:            'VARCHAR';
      Names:           'char|bpchar|varchar|name|enum|regproc|character varying';
      Description:     'Variable-length with limit.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtText;
      NativeTypes:     '25|22|30|143|629|651|719|791|1000|1028|1040|1041|1115|1182|1183|1185|1187|1231|1263|1270|1561|1563|2201|2207|2211|2949|2951|3643|3644|3645|3735|3770';
      Name:            'TEXT';
      Names:           'text|int2vector|oidvector|bool';
      Description:     'Variable unlimited length.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcText;
    ),
    (
      Index:           dtCidr;
      NativeTypes:     '650';
      Name:            'CIDR';
      Names:           'cidr';
      Description:     'IPv4 and IPv6 networks. Storage size: 7 or 19 bytes';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcText;
    ),
    (
      Index:           dtInet;
      NativeTypes:     '869';
      Name:            'INET';
      Names:           'inet';
      Description:     'IPv4 and IPv6 hosts and networks. Storage size: 7 or 19 bytes';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcText;
    ),
    (
      Index:           dtMacaddr;
      NativeTypes:     '829';
      Name:            'MACADDR';
      Names:           'macaddr';
      Description:     'MAC addresses. Storage size: 6 bytes';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcText;
    ),
    (
      Index:           dtDate;
      NativeTypes:     '1082';
      Name:            'DATE';
      Description:     'Calendar date (year, month, day).';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Format:          'yyyy-mm-dd';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtTime;
      NativeTypes:     '1083';
      Name:            'TIME';
      Description:     'Time of day.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Format:          'hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDatetime;
      NativeTypes:     '1082|1114|702';
      Name:            'TIMESTAMP';
      Names:           'timestamp|datetime|abstime|timestamp without time zone';
      Description:     'Date and time.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDatetime2;
      NativeTypes:     '1184';
      Name:            'TIMESTAMPTZ';
      Names:           'timestamptz|timestamp with timezone';
      Description:     'Date and time.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtDate;
      NativeTypes:     '1082';
      Name:            'DATE';
      Description:     'Calendar date (year, month, day).';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Format:          'yyyy-mm-dd';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtInterval;
      NativeTypes:     '1186';
      Name:            'INTERVAL';
      Description:     'time interval	from -178000000 years to 178000000 years';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Format:          'yyyy-mm-dd hh:nn:ss';
      Category:        dtcTemporal;
    ),
    (
      Index:           dtBlob;
      NativeTypes:     '17';
      Name:            'BYTEA';
      Description:     'Binary data ("byte array").';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        True;
      Category:        dtcBinary;
    ),
    (
      Index:           dtPoint;
      NativeTypes:     '600';
      Name:            'POINT';
      Description:     'Point on a plane (x,y). Storage size: 16 bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtLinestring;
      NativeTypes:     '628';
      Name:            'LINE';
      Description:     'Infinite line ((x1,y1),(x2,y2)). Storage size: 32 bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtLineSegment;
      NativeTypes:     '601';
      Name:            'LSEG';
      Description:     'Finite line segment ((x1,y1),(x2,y2)). Storage size: 32 bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtBox;
      NativeTypes:     '603';
      Name:            'BOX';
      Description:     'Rectangular box ((x1,y1),(x2,y2)). Storage size: 32 bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtPath;
      NativeTypes:     '602';
      Name:            'PATH';
      Description:     'Closed path (similar to polygon) ((x1,y1),...). Storage size: 16+16n bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtPolygon;
      NativeTypes:     '604';
      Name:            'POLYGON';
      Description:     'Closed path (similar to polygon) ((x1,y1),...). Storage size: 40+16n bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtCircle;
      NativeTypes:     '718';
      Name:            'CIRCLE';
      Description:     'Circle <(x,y),r> (center point and radius). Storage size: 24 bytes.';
      HasLength:       True;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcSpatial;
    ),
    (
      Index:           dtBool;
      NativeTypes:     '16';
      Name:            'BOOLEAN';
      Names:           'boolean|bool';
      Description:     'State of true or false. Storage size: 1 byte.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      ValueMustMatch:  '^(true|false)$';
      Category:        dtcOther;
    ),
    (
      Index:           dtRegClass;
      NativeTypes:     '2205';
      Name:            'REGCLASS';
      Names:           'regclass';
      Description:     'Relation name';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcOther;
    ),
    (
      Index:           dtJson;
      NativeTypes:     '114';
      Name:            'JSON';
      Names:           'json';
      Description:     'JavaScript Object Notation data';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      Category:        dtcText;
    ),
    (
      Index:           dtUniqueidentifier;
      NativeTypes:     '2950';
      Name:            'UUID';
      Names:           'uuid';
      Description:     'The data type uuid stores Universally Unique Identifiers (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005, and related standards.';
      HasLength:       False;
      RequiresLength:  False;
      HasBinary:       False;
      HasDefault:      False;
      LoadPart:        False;
      ValueMustMatch:  '^\{?[a-f0-9]{8}-?[a-f0-9]{4}-?[a-f0-9]{4}-?[a-f0-9]{4}-?[a-f0-9]{12}\}?$';
      Category:        dtcText;
    )
  );

  MySqlFunctions: Array [0..254] of TMysqlFunction =
  (
    // Function nr. 1
    (
      Name:         'ABS';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the absolute value of X.'
    ),

    // Function nr. 2
    (
      Name:         'ACOS';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the arc cosine of X, that is, the value whose cosine is X.'+sLineBreak
        +'Returns NULL if X is not in the range -1 to 1.'
    ),

    // Function nr. 3
    (
      Name:         'ADDDATE';
      Declaration:  '(date,INTERVAL expr unit)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'When invoked with the INTERVAL form of the second argument, ADDDATE()'+sLineBreak
        +'is a synonym for DATE_ADD(). The related function SUBDATE() is a'+sLineBreak
        +'synonym for DATE_SUB(). For information on the INTERVAL unit argument,'+sLineBreak
        +'see the discussion for DATE_ADD().'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT DATE_ADD(''2008-01-02'', INTERVAL 31 DAY);'+sLineBreak
        +'        -> ''2008-02-02'''+sLineBreak
        +'MariaDB> SELECT ADDDATE(''2008-01-02'', INTERVAL 31 DAY);'+sLineBreak
        +'        -> ''2008-02-02'''+sLineBreak
        +''+sLineBreak
        +'When invoked with the days form of the second argument, MySQL treats it'+sLineBreak
        +'as an integer number of days to be added to expr.'
    ),

    // Function nr. 4
    (
      Name:         'ADDTIME';
      Declaration:  '(expr1,expr2)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'ADDTIME() adds expr2 to expr1 and returns the result. expr1 is a time'+sLineBreak
        +'or datetime expression, and expr2 is a time expression.'
    ),

    // Function nr. 5
    (
      Name:         'AES_DECRYPT';
      Declaration:  '(crypt_str,key_str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This function decrypts data using the official AES (Advanced Encryption'+sLineBreak
        +'Standard) algorithm. For more information, see the description of'+sLineBreak
        +'AES_ENCRYPT().'
    ),

    // Function nr. 6
    (
      Name:         'AES_ENCRYPT';
      Declaration:  '(str,key_str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'AES_ENCRYPT() and AES_DECRYPT() enable encryption and decryption of'+sLineBreak
        +'data using the official AES (Advanced Encryption Standard) algorithm,'+sLineBreak
        +'previously known as "Rijndael." Encoding with a 128-bit key length is'+sLineBreak
        +'used, but you can extend it up to 256 bits by modifying the source. We'+sLineBreak
        +'chose 128 bits because it is much faster and it is secure enough for'+sLineBreak
        +'most purposes.'+sLineBreak
        +''+sLineBreak
        +'AES_ENCRYPT() encrypts a string and returns a binary string.'+sLineBreak
        +'AES_DECRYPT() decrypts the encrypted string and returns the original'+sLineBreak
        +'string. The input arguments may be any length. If either argument is'+sLineBreak
        +'NULL, the result of this function is also NULL.'+sLineBreak
        +''+sLineBreak
        +'Because AES is a block-level algorithm, padding is used to encode'+sLineBreak
        +'uneven length strings and so the result string length may be calculated'+sLineBreak
        +'using this formula:'+sLineBreak
        +''+sLineBreak
        +'16 * (trunc(string_length / 16) + 1)'+sLineBreak
        +''+sLineBreak
        +'If AES_DECRYPT() detects invalid data or incorrect padding, it returns'+sLineBreak
        +'NULL. However, it is possible for AES_DECRYPT() to return a non-NULL'+sLineBreak
        +'value (possibly garbage) if the input data or the key is invalid.'+sLineBreak
        +''+sLineBreak
        +'You can use the AES functions to store data in an encrypted form by'+sLineBreak
        +'modifying your queries:'
    ),

    // Function nr. 7
    (
      Name:         'AREA';
      Declaration:  '(poly)';
      Category:     'Polygon properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns as a double-precision number the area of the Polygon value'+sLineBreak
        +'poly, as measured in its spatial reference system.'
    ),

    // Function nr. 8
    (
      Name:         'ASBINARY';
      Declaration:  '(g)';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Converts a value in internal geometry format to its WKB representation'+sLineBreak
        +'and returns the binary result.'
    ),

    // Function nr. 9
    (
      Name:         'ASCII';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the numeric value of the leftmost character of the string str.'+sLineBreak
        +'Returns 0 if str is the empty string. Returns NULL if str is NULL.'+sLineBreak
        +'ASCII() works for 8-bit characters.'
    ),

    // Function nr. 10
    (
      Name:         'ASIN';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the arc sine of X, that is, the value whose sine is X. Returns'+sLineBreak
        +'NULL if X is not in the range -1 to 1.'
    ),

    // Function nr. 11
    (
      Name:         'ASTEXT';
      Declaration:  '(g)';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Converts a value in internal geometry format to its WKT representation'+sLineBreak
        +'and returns the string result.'
    ),

    // Function nr. 12
    (
      Name:         'ATAN';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the arc tangent of X, that is, the value whose tangent is X.'
    ),

    // Function nr. 13
    (
      Name:         'AVG';
      Declaration:  '([DISTINCT] expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the average value of expr. The DISTINCT option can be used to'+sLineBreak
        +'return the average of the distinct values of expr.'+sLineBreak
        +''+sLineBreak
        +'AVG() returns NULL if there were no matching rows.'
    ),

    // Function nr. 14
    (
      Name:         'BENCHMARK';
      Declaration:  '(count,expr)';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'The BENCHMARK() function executes the expression expr repeatedly count'+sLineBreak
        +'times. It may be used to time how quickly MySQL processes the'+sLineBreak
        +'expression. The result value is always 0. The intended use is from'+sLineBreak
        +'within the mysql client, which reports query execution times:'
    ),

    // Function nr. 15
    (
      Name:         'BIN';
      Declaration:  '(N)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a string representation of the binary value of N, where N is a'+sLineBreak
        +'longlong (BIGINT) number. This is equivalent to CONV(N,10,2). Returns'+sLineBreak
        +'NULL if N is NULL.'
    ),

    // Function nr. 16
    (
      Name:         'BINARY';
      Declaration:  '(M)';
      Category:     'Data Types';
      Version:      SQL_VERSION_ANSI;
      Description:  'The BINARY type is similar to the CHAR type, but stores binary byte'+sLineBreak
        +'strings rather than nonbinary character strings. M represents the'+sLineBreak
        +'column length in bytes.'
    ),

    // Function nr. 17
    (
      Name:         'BIT_AND';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the bitwise AND of all bits in expr. The calculation is'+sLineBreak
        +'performed with 64-bit (BIGINT) precision.'
    ),

    // Function nr. 18
    (
      Name:         'BIT_COUNT';
      Declaration:  '(N)';
      Category:     'Bit Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the number of bits that are set in the argument N.'
    ),

    // Function nr. 19
    (
      Name:         'BIT_LENGTH';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the length of the string str in bits.'
    ),

    // Function nr. 20
    (
      Name:         'BIT_OR';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the bitwise OR of all bits in expr. The calculation is'+sLineBreak
        +'performed with 64-bit (BIGINT) precision.'
    ),

    // Function nr. 21
    (
      Name:         'BIT_XOR';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the bitwise XOR of all bits in expr. The calculation is'+sLineBreak
        +'performed with 64-bit (BIGINT) precision.'
    ),

    // Function nr. 22
    (
      Name:         'BOUNDARY';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a geometry that is the closure of the combinatorial boundary of'+sLineBreak
        +'the geometry value g.'
    ),

    // Function nr. 23
    (
      Name:         'CAST';
      Declaration:  '(expr AS type)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'The CAST() function takes an expression of any type and produces a'+sLineBreak
        +'result value of a specified type, similar to CONVERT(). See the'+sLineBreak
        +'description of CONVERT() for more information.'
    ),

    // Function nr. 24
    (
      Name:         'CEIL';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'CEIL() is a synonym for CEILING().'
    ),

    // Function nr. 25
    (
      Name:         'CEILING';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the smallest integer value not less than X.'
    ),

    // Function nr. 26
    (
      Name:         'CHARACTER_LENGTH';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'CHARACTER_LENGTH() is a synonym for CHAR_LENGTH().'
    ),

    // Function nr. 27
    (
      Name:         'CHARSET';
      Declaration:  '(str)';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the character set of the string argument.'
    ),

    // Function nr. 28
    (
      Name:         'CHAR_LENGTH';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the length of the string str, measured in characters. A'+sLineBreak
        +'multi-byte character counts as a single character. This means that for'+sLineBreak
        +'a string containing five 2-byte characters, LENGTH() returns 10,'+sLineBreak
        +'whereas CHAR_LENGTH() returns 5.'
    ),

    // Function nr. 29
    (
      Name:         'COALESCE';
      Declaration:  '(value,...)';
      Category:     'Comparison operators';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the first non-NULL value in the list, or NULL if there are no'+sLineBreak
        +'non-NULL values.'
    ),

    // Function nr. 30
    (
      Name:         'COERCIBILITY';
      Declaration:  '(str)';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the collation coercibility value of the string argument.'
    ),

    // Function nr. 31
    (
      Name:         'COLLATION';
      Declaration:  '(str)';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the collation of the string argument.'
    ),

    // Function nr. 32
    (
      Name:         'COMPRESS';
      Declaration:  '(string_to_compress)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Compresses a string and returns the result as a binary string. This'+sLineBreak
        +'function requires MySQL to have been compiled with a compression'+sLineBreak
        +'library such as zlib. Otherwise, the return value is always NULL. The'+sLineBreak
        +'compressed string can be uncompressed with UNCOMPRESS().'
    ),

    // Function nr. 33
    (
      Name:         'CONCAT';
      Declaration:  '(str1,str2,...)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string that results from concatenating the arguments. May'+sLineBreak
        +'have one or more arguments. If all arguments are nonbinary strings, the'+sLineBreak
        +'result is a nonbinary string. If the arguments include any binary'+sLineBreak
        +'strings, the result is a binary string. A numeric argument is converted'+sLineBreak
        +'to its equivalent string form. This is a nonbinary string as of MySQL'+sLineBreak
        +'5.5.3. Before 5.5.3, it is a binary string; to to avoid that and'+sLineBreak
        +'produce a nonbinary string, you can use an explicit type cast, as in'+sLineBreak
        +'this example:'+sLineBreak
        +''+sLineBreak
        +'SELECT CONCAT(CAST(int_col AS CHAR), char_col);'+sLineBreak
        +''+sLineBreak
        +'CONCAT() returns NULL if any argument is NULL.'
    ),

    // Function nr. 34
    (
      Name:         'CONCAT_WS';
      Declaration:  '(separator,str1,str2,...)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'CONCAT_WS() stands for Concatenate With Separator and is a special form'+sLineBreak
        +'of CONCAT(). The first argument is the separator for the rest of the'+sLineBreak
        +'arguments. The separator is added between the strings to be'+sLineBreak
        +'concatenated. The separator can be a string, as can the rest of the'+sLineBreak
        +'arguments. If the separator is NULL, the result is NULL.'
    ),

    // Function nr. 35
    (
      Name:         'CONNECTION_ID';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the connection ID (thread ID) for the connection. Every'+sLineBreak
        +'connection has an ID that is unique among the set of currently'+sLineBreak
        +'connected clients.'
    ),

    // Function nr. 36
    (
      Name:         'CONTAINS';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 completely contains g2. This'+sLineBreak
        +'tests the opposite relationship as Within().'
    ),

    // Function nr. 37
    (
      Name:         'CONV';
      Declaration:  '(N,from_base,to_base)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Converts numbers between different number bases. Returns a string'+sLineBreak
        +'representation of the number N, converted from base from_base to base'+sLineBreak
        +'to_base. Returns NULL if any argument is NULL. The argument N is'+sLineBreak
        +'interpreted as an integer, but may be specified as an integer or a'+sLineBreak
        +'string. The minimum base is 2 and the maximum base is 36. If to_base is'+sLineBreak
        +'a negative number, N is regarded as a signed number. Otherwise, N is'+sLineBreak
        +'treated as unsigned. CONV() works with 64-bit precision.'
    ),

    // Function nr. 38
    (
      Name:         'CONVERT';
      Declaration:  '(expr,type)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'The CONVERT() and CAST() functions take an expression of any type and'+sLineBreak
        +'produce a result value of a specified type.'+sLineBreak
        +''+sLineBreak
        +'The type for the result can be one of the following values:'+sLineBreak
        +''+sLineBreak
        +'o BINARY[(N)]'+sLineBreak
        +''+sLineBreak
        +'o CHAR[(N)]'+sLineBreak
        +''+sLineBreak
        +'o DATE'+sLineBreak
        +''+sLineBreak
        +'o DATETIME'+sLineBreak
        +''+sLineBreak
        +'o DECIMAL[(M[,D])]'+sLineBreak
        +''+sLineBreak
        +'o SIGNED [INTEGER]'+sLineBreak
        +''+sLineBreak
        +'o TIME'+sLineBreak
        +''+sLineBreak
        +'o UNSIGNED [INTEGER]'+sLineBreak
        +''+sLineBreak
        +'BINARY produces a string with the BINARY data type. See'+sLineBreak
        +'https://mariadb.com/kb/en/binary/ for a'+sLineBreak
        +'description of how this affects comparisons. If the optional length N'+sLineBreak
        +'is given, BINARY(N) causes the cast to use no more than N bytes of the'+sLineBreak
        +'argument. Values shorter than N bytes are padded with 0x00 bytes to a'+sLineBreak
        +'length of N.'+sLineBreak
        +''+sLineBreak
        +'CHAR(N) causes the cast to use no more than N characters of the'+sLineBreak
        +'argument.'+sLineBreak
        +''+sLineBreak
        +'CAST() and CONVERT(... USING ...) are standard SQL syntax. The'+sLineBreak
        +'non-USING form of CONVERT() is ODBC syntax.'+sLineBreak
        +''+sLineBreak
        +'CONVERT() with USING is used to convert data between different'+sLineBreak
        +'character sets. In MySQL, transcoding names are the same as the'+sLineBreak
        +'corresponding character set names. For example, this statement converts'+sLineBreak
        +'the string ''abc'' in the default character set to the corresponding'+sLineBreak
        +'string in the utf8 character set:'+sLineBreak
        +''+sLineBreak
        +'SELECT CONVERT(''abc'' USING utf8);'
    ),

    // Function nr. 39
    (
      Name:         'CONVERT_TZ';
      Declaration:  '(dt,from_tz,to_tz)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'CONVERT_TZ() converts a datetime value dt from the time zone given by'+sLineBreak
        +'from_tz to the time zone given by to_tz and returns the resulting'+sLineBreak
        +'value. Time zones are specified as described in'+sLineBreak
        +'https://mariadb.com/kb/en/time-zones/. This'+sLineBreak
        +'function returns NULL if the arguments are invalid.'
    ),

    // Function nr. 40
    (
      Name:         'COS';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the cosine of X, where X is given in radians.'
    ),

    // Function nr. 41
    (
      Name:         'COT';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the cotangent of X.'
    ),

    // Function nr. 42
    (
      Name:         'COUNT';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a count of the number of non-NULL values of expr in the rows'+sLineBreak
        +'retrieved by a SELECT statement. The result is a BIGINT value.'+sLineBreak
        +''+sLineBreak
        +'COUNT() returns 0 if there were no matching rows.'
    ),

    // Function nr. 43
    (
      Name:         'CRC32';
      Declaration:  '(expr)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Computes a cyclic redundancy check value and returns a 32-bit unsigned'+sLineBreak
        +'value. The result is NULL if the argument is NULL. The argument is'+sLineBreak
        +'expected to be a string and (if possible) is treated as one if it is'+sLineBreak
        +'not.'
    ),

    // Function nr. 44
    (
      Name:         'CROSSES';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 if g1 spatially crosses g2. Returns NULL if g1 is a Polygon'+sLineBreak
        +'or a MultiPolygon, or if g2 is a Point or a MultiPoint. Otherwise,'+sLineBreak
        +'returns 0.'+sLineBreak
        +''+sLineBreak
        +'The term spatially crosses denotes a spatial relation between two given'+sLineBreak
        +'geometries that has the following properties:'+sLineBreak
        +''+sLineBreak
        +'o The two geometries intersect'+sLineBreak
        +''+sLineBreak
        +'o Their intersection results in a geometry that has a dimension that is'+sLineBreak
        +'  one less than the maximum dimension of the two given geometries'+sLineBreak
        +''+sLineBreak
        +'o Their intersection is not equal to either of the two given geometries'
    ),

    // Function nr. 45
    (
      Name:         'CURDATE';
      Declaration:  '()';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the current date as a value in ''YYYY-MM-DD'' or YYYYMMDD format,'+sLineBreak
        +'depending on whether the function is used in a string or numeric'+sLineBreak
        +'context.'
    ),

    // Function nr. 46
    (
      Name:         'CURTIME';
      Declaration:  '()';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the current time as a value in ''HH:MM:SS'' or HHMMSS.uuuuuu'+sLineBreak
        +'format, depending on whether the function is used in a string or'+sLineBreak
        +'numeric context. The value is expressed in the current time zone.'
    ),

    // Added by hand, for https://github.com/HeidiSQL/HeidiSQL/issues/74#issuecomment-559321533
    (
      Name:         'CURRENT_TIMESTAMP';
      Declaration:  '()';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'CURRENT_TIMESTAMP and CURRENT_TIMESTAMP() are synonyms for NOW()'
    ),

    // Function nr. 47
    (
      Name:         'DATABASE';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the default (current) database name as a string in the utf8'+sLineBreak
        +'character set. If there is no default database, DATABASE() returns'+sLineBreak
        +'NULL. Within a stored routine, the default database is the database'+sLineBreak
        +'that the routine is associated with, which is not necessarily the same'+sLineBreak
        +'as the database that is the default in the calling context.'
    ),

    // Function nr. 48
    (
      Name:         'DATEDIFF';
      Declaration:  '(expr1,expr2)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'DATEDIFF() returns expr1 - expr2 expressed as a value in days from one'+sLineBreak
        +'date to the other. expr1 and expr2 are date or date-and-time'+sLineBreak
        +'expressions. Only the date parts of the values are used in the'+sLineBreak
        +'calculation.'
    ),

    // Function nr. 49
    (
      Name:         'DATE_ADD';
      Declaration:  '(date,INTERVAL expr unit)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'These functions perform date arithmetic. The date argument specifies'+sLineBreak
        +'the starting date or datetime value. expr is an expression specifying'+sLineBreak
        +'the interval value to be added or subtracted from the starting date.'+sLineBreak
        +'expr is a string; it may start with a "-" for negative intervals. unit'+sLineBreak
        +'is a keyword indicating the units in which the expression should be'+sLineBreak
        +'interpreted.'
    ),

    // Function nr. 50
    (
      Name:         'DATE_FORMAT';
      Declaration:  '(date,format)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Formats the date value according to the format string.'
    ),

    // Function nr. 51
    (
      Name:         'DATE_SUB';
      Declaration:  '(date,INTERVAL expr unit)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'See the description for DATE_ADD().'
    ),

    // Function nr. 52
    (
      Name:         'DAY';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'DAY() is a synonym for DAYOFMONTH().'
    ),

    // Function nr. 53
    (
      Name:         'DAYNAME';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the name of the weekday for date. The language used for the'+sLineBreak
        +'name is controlled by the value of the lc_time_names system variable'+sLineBreak
        +'(https://mariadb.com/kb/en/server-system-variables#lc_time_names).'
    ),

    // Function nr. 54
    (
      Name:         'DAYOFMONTH';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the day of the month for date, in the range 1 to 31, or 0 for'+sLineBreak
        +'dates such as ''0000-00-00'' or ''2008-00-00'' that have a zero day part.'
    ),

    // Function nr. 55
    (
      Name:         'DAYOFWEEK';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the weekday index for date (1 = Sunday, 2 = Monday, ..., 7 ='+sLineBreak
        +'Saturday). These index values correspond to the ODBC standard.'
    ),

    // Function nr. 56
    (
      Name:         'DAYOFYEAR';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the day of the year for date, in the range 1 to 366.'
    ),

    // Function nr. 57
    (
      Name:         'DECODE';
      Declaration:  '(crypt_str,pass_str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Decrypts the encrypted string crypt_str using pass_str as the password.'+sLineBreak
        +'crypt_str should be a string returned from ENCODE().'
    ),

    // Function nr. 58
    (
      Name:         'DEFAULT';
      Declaration:  '(col_name)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the default value for a table column. An error results if the'+sLineBreak
        +'column has no default value.'
    ),

    // Function nr. 59
    (
      Name:         'DEGREES';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the argument X, converted from radians to degrees.'
    ),

    // Function nr. 60
    (
      Name:         'DES_DECRYPT';
      Declaration:  '(crypt_str[,key_str])';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Decrypts a string encrypted with DES_ENCRYPT(). If an error occurs,'+sLineBreak
        +'this function returns NULL.'+sLineBreak
        +''+sLineBreak
        +'This function works only if MySQL has been configured with SSL support.'+sLineBreak
        +'See https://mariadb.com/kb/en/ssl-connections/.'+sLineBreak
        +''+sLineBreak
        +'If no key_str argument is given, DES_DECRYPT() examines the first byte'+sLineBreak
        +'of the encrypted string to determine the DES key number that was used'+sLineBreak
        +'to encrypt the original string, and then reads the key from the DES key'+sLineBreak
        +'file to decrypt the message. For this to work, the user must have the'+sLineBreak
        +'SUPER privilege. The key file can be specified with the --des-key-file'+sLineBreak
        +'server option.'+sLineBreak
        +''+sLineBreak
        +'If you pass this function a key_str argument, that string is used as'+sLineBreak
        +'the key for decrypting the message.'+sLineBreak
        +''+sLineBreak
        +'If the crypt_str argument does not appear to be an encrypted string,'+sLineBreak
        +'MySQL returns the given crypt_str.'
    ),

    // Function nr. 61
    (
      Name:         'DES_ENCRYPT';
      Declaration:  '(str[,{key_num|key_str}])';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Encrypts the string with the given key using the Triple-DES algorithm.'+sLineBreak
        +''+sLineBreak
        +'This function works only if MySQL has been configured with SSL support.'+sLineBreak
        +'See https://mariadb.com/kb/en/ssl-connections/.'+sLineBreak
        +''+sLineBreak
        +'The encryption key to use is chosen based on the second argument to'+sLineBreak
        +'DES_ENCRYPT(), if one was given. With no argument, the first key from'+sLineBreak
        +'the DES key file is used. With a key_num argument, the given key number'+sLineBreak
        +'(0 to 9) from the DES key file is used. With a key_str argument, the'+sLineBreak
        +'given key string is used to encrypt str.'+sLineBreak
        +''+sLineBreak
        +'The key file can be specified with the --des-key-file server option.'+sLineBreak
        +''+sLineBreak
        +'The return string is a binary string where the first character is'+sLineBreak
        +'CHAR(128 | key_num). If an error occurs, DES_ENCRYPT() returns NULL.'+sLineBreak
        +''+sLineBreak
        +'The 128 is added to make it easier to recognize an encrypted key. If'+sLineBreak
        +'you use a string key, key_num is 127.'+sLineBreak
        +''+sLineBreak
        +'The string length for the result is given by this formula:'+sLineBreak
        +''+sLineBreak
        +'new_len = orig_len + (8 - (orig_len % 8)) + 1'+sLineBreak
        +''+sLineBreak
        +'Each line in the DES key file has the following format:'+sLineBreak
        +''+sLineBreak
        +'key_num des_key_str'+sLineBreak
        +''+sLineBreak
        +'Each key_num value must be a number in the range from 0 to 9. Lines in'+sLineBreak
        +'the file may be in any order. des_key_str is the string that is used to'+sLineBreak
        +'encrypt the message. There should be at least one space between the'+sLineBreak
        +'number and the key. The first key is the default key that is used if'+sLineBreak
        +'you do not specify any key argument to DES_ENCRYPT().'+sLineBreak
        +''+sLineBreak
        +'You can tell MySQL to read new key values from the key file with the'+sLineBreak
        +'FLUSH DES_KEY_FILE statement. This requires the RELOAD privilege.'+sLineBreak
        +''+sLineBreak
        +'One benefit of having a set of default keys is that it gives'+sLineBreak
        +'applications a way to check for the existence of encrypted column'+sLineBreak
        +'values, without giving the end user the right to decrypt those values.'
    ),

    // Function nr. 62
    (
      Name:         'DIMENSION';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the inherent dimension of the geometry value g. The result can'+sLineBreak
        +'be -1, 0, 1, or 2. The meaning of these values is given in'+sLineBreak
        +'https://mariadb.com/kb/en/dimension/.'
    ),

    // Function nr. 63
    (
      Name:         'DISJOINT';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 is spatially disjoint from (does'+sLineBreak
        +'not intersect) g2.'
    ),

    // Function nr. 64
    (
      Name:         'ELT';
      Declaration:  '(N,str1,str2,str3,...)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns str1 if N = 1, str2 if N = 2, and so on. Returns NULL if N is'+sLineBreak
        +'less than 1 or greater than the number of arguments. ELT() is the'+sLineBreak
        +'complement of FIELD().'
    ),

    // Function nr. 65
    (
      Name:         'ENCODE';
      Declaration:  '(str,pass_str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Encrypt str using pass_str as the password. To decrypt the result, use'+sLineBreak
        +'DECODE().'+sLineBreak
        +''+sLineBreak
        +'The result is a binary string of the same length as str.'+sLineBreak
        +''+sLineBreak
        +'The strength of the encryption is based on how good the random'+sLineBreak
        +'generator is. It should suffice for short strings.'
    ),

    // Function nr. 66
    (
      Name:         'ENCRYPT';
      Declaration:  '(str[,salt])';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Encrypts str using the Unix crypt() system call and returns a binary'+sLineBreak
        +'string. The salt argument must be a string with at least two characters'+sLineBreak
        +'or the result will be NULL. If no salt argument is given, a random'+sLineBreak
        +'value is used.'
    ),

    // Function nr. 67
    (
      Name:         'ENDPOINT';
      Declaration:  '(ls)';
      Category:     'LineString properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the Point that is the endpoint of the LineString value ls.'
    ),

    // Function nr. 68
    (
      Name:         'ENUM';
      Declaration:  '(''value1'',''value2'',...)';
      Category:     'Data Types';
      Version:      SQL_VERSION_ANSI;
      Description:  'collation_name]'+sLineBreak
        +''+sLineBreak
        +'An enumeration. A string object that can have only one value, chosen'+sLineBreak
        +'from the list of values ''value1'', ''value2'', ..., NULL or the special '''''+sLineBreak
        +'error value. An ENUM column can have a maximum of 65,535 distinct'+sLineBreak
        +'values. ENUM values are represented internally as integers.'
    ),

    // Function nr. 69
    (
      Name:         'ENVELOPE';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the Minimum Bounding Rectangle (MBR) for the geometry value g.'+sLineBreak
        +'The result is returned as a Polygon value.'+sLineBreak
        +''+sLineBreak
        +'The polygon is defined by the corner points of the bounding box:'+sLineBreak
        +''+sLineBreak
        +'POLYGON((MINX MINY, MAXX MINY, MAXX MAXY, MINX MAXY, MINX MINY))'
    ),

    // Function nr. 70
    (
      Name:         'EQUALS';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 is spatially equal to g2.'
    ),

    // Function nr. 71
    (
      Name:         'EXP';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the value of e (the base of natural logarithms) raised to the'+sLineBreak
        +'power of X. The inverse of this function is LOG() (using a single'+sLineBreak
        +'argument only) or LN().'
    ),

    // Function nr. 72
    (
      Name:         'EXPORT_SET';
      Declaration:  '(bits,on,off[,separator[,number_of_bits]])';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a string such that for every bit set in the value bits, you get'+sLineBreak
        +'an on string and for every bit not set in the value, you get an off'+sLineBreak
        +'string. Bits in bits are examined from right to left (from low-order to'+sLineBreak
        +'high-order bits). Strings are added to the result from left to right,'+sLineBreak
        +'separated by the separator string (the default being the comma'+sLineBreak
        +'character ","). The number of bits examined is given by number_of_bits,'+sLineBreak
        +'which has a default of 64 if not specified. number_of_bits is silently'+sLineBreak
        +'clipped to 64 if larger than 64. It is treated as an unsigned integer,'+sLineBreak
        +'so a value of -1 is effectively the same as 64.'
    ),

    // Function nr. 73
    (
      Name:         'EXTERIORRING';
      Declaration:  '(poly)';
      Category:     'Polygon properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the exterior ring of the Polygon value poly as a LineString.'
    ),

    // Function nr. 74
    (
      Name:         'EXTRACT';
      Declaration:  '(unit FROM date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'The EXTRACT() function uses the same kinds of unit specifiers as'+sLineBreak
        +'DATE_ADD() or DATE_SUB(), but extracts parts from the date rather than'+sLineBreak
        +'performing date arithmetic.'
    ),

    // Function nr. 75
    (
      Name:         'EXTRACTVALUE';
      Declaration:  '(xml_frag, xpath_expr)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'ExtractValue() takes two string arguments, a fragment of XML markup'+sLineBreak
        +'xml_frag and an XPath expression xpath_expr (also known as a locator);'+sLineBreak
        +'it returns the text (CDATA) of the first text node which is a child of'+sLineBreak
        +'the elements or elements matched by the XPath expression. In MySQL 5.5,'+sLineBreak
        +'the XPath expression can contain at most 127 characters. (This'+sLineBreak
        +'limitation is lifted in MySQL 5.6.)'+sLineBreak
        +''+sLineBreak
        +'Using this function is the equivalent of performing a match using the'+sLineBreak
        +'xpath_expr after appending /text(). In other words,'+sLineBreak
        +'ExtractValue(''<a><b>Sakila</b></a>'', ''/a/b'') and'+sLineBreak
        +'ExtractValue(''<a><b>Sakila</b></a>'', ''/a/b/text()'') produce the same'+sLineBreak
        +'result.'+sLineBreak
        +''+sLineBreak
        +'If multiple matches are found, the content of the first child text node'+sLineBreak
        +'of each matching element is returned (in the order matched) as a'+sLineBreak
        +'single, space-delimited string.'+sLineBreak
        +''+sLineBreak
        +'If no matching text node is found for the expression (including the'+sLineBreak
        +'implicit /text())---for whatever reason, as long as xpath_expr is'+sLineBreak
        +'valid, and xml_frag consists of elements which are properly nested and'+sLineBreak
        +'closed---an empty string is returned. No distinction is made between a'+sLineBreak
        +'match on an empty element and no match at all. This is by design.'+sLineBreak
        +''+sLineBreak
        +'If you need to determine whether no matching element was found in'+sLineBreak
        +'xml_frag or such an element was found but contained no child text'+sLineBreak
        +'nodes, you should test the result of an expression that uses the XPath'+sLineBreak
        +'count() function. For example, both of these statements return an empty'+sLineBreak
        +'string, as shown here:'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT ExtractValue(''<a><b/></a>'', ''/a/b'');'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'| ExtractValue(''<a><b/></a>'', ''/a/b'') |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'|                                     |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'1 row in set (0.00 sec)'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT ExtractValue(''<a><c/></a>'', ''/a/b'');'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'| ExtractValue(''<a><c/></a>'', ''/a/b'') |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'|                                     |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'1 row in set (0.00 sec)'+sLineBreak
        +''+sLineBreak
        +'However, you can determine whether there was actually a matching'+sLineBreak
        +'element using the following:'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT ExtractValue(''<a><b/></a>'', ''count(/a/b)'');'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'| ExtractValue(''<a><b/></a>'', ''count(/a/b)'') |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'| 1                                   |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'1 row in set (0.00 sec)'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT ExtractValue(''<a><c/></a>'', ''count(/a/b)'');'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'| ExtractValue(''<a><c/></a>'', ''count(/a/b)'') |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'| 0                                   |'+sLineBreak
        +'+-------------------------------------+'+sLineBreak
        +'1 row in set (0.01 sec)'+sLineBreak
        +''+sLineBreak
        +'*Important*: ExtractValue() returns only CDATA, and does not return any'+sLineBreak
        +'tags that might be contained within a matching tag, nor any of their'+sLineBreak
        +'content (see the result returned as val1 in the following example).'
    ),

    // Function nr. 76
    (
      Name:         'FIELD';
      Declaration:  '(str,str1,str2,str3,...)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the index (position) of str in the str1, str2, str3, ... list.'+sLineBreak
        +'Returns 0 if str is not found.'+sLineBreak
        +''+sLineBreak
        +'If all arguments to FIELD() are strings, all arguments are compared as'+sLineBreak
        +'strings. If all arguments are numbers, they are compared as numbers.'+sLineBreak
        +'Otherwise, the arguments are compared as double.'+sLineBreak
        +''+sLineBreak
        +'If str is NULL, the return value is 0 because NULL fails equality'+sLineBreak
        +'comparison with any value. FIELD() is the complement of ELT().'
    ),

    // Function nr. 77
    (
      Name:         'FIND_IN_SET';
      Declaration:  '(str,strlist)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a value in the range of 1 to N if the string str is in the'+sLineBreak
        +'string list strlist consisting of N substrings. A string list is a'+sLineBreak
        +'string composed of substrings separated by "," characters. If the first'+sLineBreak
        +'argument is a constant string and the second is a column of type SET,'+sLineBreak
        +'the FIND_IN_SET() function is optimized to use bit arithmetic. Returns'+sLineBreak
        +'0 if str is not in strlist or if strlist is the empty string. Returns'+sLineBreak
        +'NULL if either argument is NULL. This function does not work properly'+sLineBreak
        +'if the first argument contains a comma (",") character.'
    ),

    // Function nr. 78
    (
      Name:         'FLOOR';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the largest integer value not greater than X.'
    ),

    // Function nr. 79
    (
      Name:         'FORMAT';
      Declaration:  '(X,D[,locale])';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Formats the number X to a format like ''#,###,###.##'', rounded to D'+sLineBreak
        +'decimal places, and returns the result as a string. If D is 0, the'+sLineBreak
        +'result has no decimal point or fractional part.'+sLineBreak
        +''+sLineBreak
        +'The optional third parameter enables a locale to be specified to be'+sLineBreak
        +'used for the result number''s decimal point, thousands separator, and'+sLineBreak
        +'grouping between separators. Permissible locale values are the same as'+sLineBreak
        +'the legal values for the lc_time_names system variable (see'+sLineBreak
        +'https://mariadb.com/kb/en/server-locale/). If no'+sLineBreak
        +'locale is specified, the default is ''en_US''.'
    ),

    // Function nr. 80
    (
      Name:         'FOUND_ROWS';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'A SELECT statement may include a LIMIT clause to restrict the number of'+sLineBreak
        +'rows the server returns to the client. In some cases, it is desirable'+sLineBreak
        +'to know how many rows the statement would have returned without the'+sLineBreak
        +'LIMIT, but without running the statement again. To obtain this row'+sLineBreak
        +'count, include a SQL_CALC_FOUND_ROWS option in the SELECT statement,'+sLineBreak
        +'and then invoke FOUND_ROWS() afterward:'
    ),

    // Function nr. 81
    (
      Name:         'FROM_DAYS';
      Declaration:  '(N)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Given a day number N, returns a DATE value.'
    ),

    // Function nr. 82
    (
      Name:         'FROM_UNIXTIME';
      Declaration:  '(unix_timestamp)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a representation of the unix_timestamp argument as a value in'+sLineBreak
        +'''YYYY-MM-DD HH:MM:SS'' or YYYYMMDDHHMMSS.uuuuuu format, depending on'+sLineBreak
        +'whether the function is used in a string or numeric context. The value'+sLineBreak
        +'is expressed in the current time zone. unix_timestamp is an internal'+sLineBreak
        +'timestamp value such as is produced by the UNIX_TIMESTAMP() function.'+sLineBreak
        +''+sLineBreak
        +'If format is given, the result is formatted according to the format'+sLineBreak
        +'string, which is used the same way as listed in the entry for the'+sLineBreak
        +'DATE_FORMAT() function.'
    ),

    // Function nr. 83
    (
      Name:         'GEOMCOLLFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a GEOMETRYCOLLECTION value using its WKT representation and'+sLineBreak
        +'SRID.'
    ),

    // Function nr. 84
    (
      Name:         'GEOMCOLLFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a GEOMETRYCOLLECTION value using its WKB representation and'+sLineBreak
        +'SRID.'
    ),

    // Function nr. 85
    (
      Name:         'GEOMETRYCOLLECTION';
      Declaration:  '(g1,g2,...)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a GeometryCollection.'
    ),

    // Function nr. 86
    (
      Name:         'GEOMETRYN';
      Declaration:  '(gc,N)';
      Category:     'GeometryCollection properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the N-th geometry in the GeometryCollection value gc.'+sLineBreak
        +'Geometries are numbered beginning with 1.'
    ),

    // Function nr. 87
    (
      Name:         'GEOMETRYTYPE';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns as a binary string the name of the geometry type of which the'+sLineBreak
        +'geometry instance g is a member. The name corresponds to one of the'+sLineBreak
        +'instantiable Geometry subclasses.'
    ),

    // Function nr. 88
    (
      Name:         'GEOMFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a geometry value of any type using its WKT representation'+sLineBreak
        +'and SRID.'
    ),

    // Function nr. 89
    (
      Name:         'GEOMFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a geometry value of any type using its WKB representation'+sLineBreak
        +'and SRID.'
    ),

    // Function nr. 90
    (
      Name:         'GET_FORMAT';
      Declaration:  '({DATE|TIME|DATETIME}, {''EUR''|''USA''|''JIS''|''ISO''|''INTERNAL''})';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a format string. This function is useful in combination with'+sLineBreak
        +'the DATE_FORMAT() and the STR_TO_DATE() functions.'
    ),

    // Function nr. 91
    (
      Name:         'GET_LOCK';
      Declaration:  '(str,timeout)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Tries to obtain a lock with a name given by the string str, using a'+sLineBreak
        +'timeout of timeout seconds. Returns 1 if the lock was obtained'+sLineBreak
        +'successfully, 0 if the attempt timed out (for example, because another'+sLineBreak
        +'client has previously locked the name), or NULL if an error occurred'+sLineBreak
        +'(such as running out of memory or the thread was killed with mysqladmin'+sLineBreak
        +'kill). If you have a lock obtained with GET_LOCK(), it is released when'+sLineBreak
        +'you execute RELEASE_LOCK(), execute a new GET_LOCK(), or your'+sLineBreak
        +'connection terminates (either normally or abnormally). Locks obtained'+sLineBreak
        +'with GET_LOCK() do not interact with transactions. That is, committing'+sLineBreak
        +'a transaction does not release any such locks obtained during the'+sLineBreak
        +'transaction.'+sLineBreak
        +''+sLineBreak
        +'This function can be used to implement application locks or to simulate'+sLineBreak
        +'record locks. Names are locked on a server-wide basis. If a name has'+sLineBreak
        +'been locked by one client, GET_LOCK() blocks any request by another'+sLineBreak
        +'client for a lock with the same name. This enables clients that agree'+sLineBreak
        +'on a given lock name to use the name to perform cooperative advisory'+sLineBreak
        +'locking. But be aware that it also enables a client that is not among'+sLineBreak
        +'the set of cooperating clients to lock a name, either inadvertently or'+sLineBreak
        +'deliberately, and thus prevent any of the cooperating clients from'+sLineBreak
        +'locking that name. One way to reduce the likelihood of this is to use'+sLineBreak
        +'lock names that are database-specific or application-specific. For'+sLineBreak
        +'example, use lock names of the form db_name.str or app_name.str.'
    ),

    // Function nr. 92
    (
      Name:         'GLENGTH';
      Declaration:  '(ls)';
      Category:     'LineString properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns as a double-precision number the length of the LineString value'+sLineBreak
        +'ls in its associated spatial reference.'
    ),

    // Function nr. 93
    (
      Name:         'GREATEST';
      Declaration:  '(value1,value2,...)';
      Category:     'Comparison operators';
      Version:      SQL_VERSION_ANSI;
      Description:  'With two or more arguments, returns the largest (maximum-valued)'+sLineBreak
        +'argument. The arguments are compared using the same rules as for'+sLineBreak
        +'LEAST().'
    ),

    // Function nr. 94
    (
      Name:         'GROUP_CONCAT';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'This function returns a string result with the concatenated non-NULL'+sLineBreak
        +'values from a group. It returns NULL if there are no non-NULL values.'+sLineBreak
        +'The full syntax is as follows:'+sLineBreak
        +''+sLineBreak
        +'GROUP_CONCAT([DISTINCT] expr [,expr ...]'+sLineBreak
        +'             [ORDER BY {unsigned_integer | col_name | expr}'+sLineBreak
        +'                 [ASC | DESC] [,col_name ...]]'+sLineBreak
        +'             [SEPARATOR str_val])'
    ),

    // Function nr. 95
    (
      Name:         'HEX';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'For a string argument str, HEX() returns a hexadecimal string'+sLineBreak
        +'representation of str where each character in str is converted to two'+sLineBreak
        +'hexadecimal digits. The inverse of this operation is performed by the'+sLineBreak
        +'UNHEX() function.'+sLineBreak
        +''+sLineBreak
        +'For a numeric argument N, HEX() returns a hexadecimal string'+sLineBreak
        +'representation of the value of N treated as a longlong (BIGINT) number.'+sLineBreak
        +'This is equivalent to CONV(N,10,16). The inverse of this operation is'+sLineBreak
        +'performed by CONV(HEX(N),16,10).'
    ),

    // Function nr. 96
    (
      Name:         'HOUR';
      Declaration:  '(time)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the hour for time. The range of the return value is 0 to 23 for'+sLineBreak
        +'time-of-day values. However, the range of TIME values actually is much'+sLineBreak
        +'larger, so HOUR can return values greater than 23.'
    ),

    // Function nr. 97
    (
      Name:         'IFNULL';
      Declaration:  '(expr1,expr2)';
      Category:     'Control flow functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'If expr1 is not NULL, IFNULL() returns expr1; otherwise it returns'+sLineBreak
        +'expr2. IFNULL() returns a numeric or string value, depending on the'+sLineBreak
        +'context in which it is used.'
    ),

    // Function nr. 98
    (
      Name:         'INET_ATON';
      Declaration:  '(expr)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Given the dotted-quad representation of an IPv4 network address as a'+sLineBreak
        +'string, returns an integer that represents the numeric value of the'+sLineBreak
        +'address in network byte order (big endian). INET_ATON() returns NULL if'+sLineBreak
        +'it does not understand its argument.'
    ),

    // Function nr. 99
    (
      Name:         'INET_NTOA';
      Declaration:  '(expr)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Given a numeric IPv4 network address in network byte order, returns the'+sLineBreak
        +'dotted-quad representation of the address as a string. INET_NTOA()'+sLineBreak
        +'returns NULL if it does not understand its argument.'+sLineBreak
        +''+sLineBreak
        +'As of MySQL 5.5.3, the return value is a nonbinary string in the'+sLineBreak
        +'connection character set. Before 5.5.3, the return value is a binary'+sLineBreak
        +'string.'
    ),

    // Function nr. 100
    (
      Name:         'INSTR';
      Declaration:  '(str,substr)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the position of the first occurrence of substring substr in'+sLineBreak
        +'string str. This is the same as the two-argument form of LOCATE(),'+sLineBreak
        +'except that the order of the arguments is reversed.'
    ),

    // Function nr. 101
    (
      Name:         'INTERIORRINGN';
      Declaration:  '(poly,N)';
      Category:     'Polygon properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the N-th interior ring for the Polygon value poly as a'+sLineBreak
        +'LineString. Rings are numbered beginning with 1.'
    ),

    // Function nr. 102
    (
      Name:         'INTERSECTS';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 spatially intersects g2.'
    ),

    // Function nr. 103
    (
      Name:         'INTERVAL';
      Declaration:  '(N,N1,N2,N3,...)';
      Category:     'Comparison operators';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 0 if N < N1, 1 if N < N2 and so on or -1 if N is NULL. All'+sLineBreak
        +'arguments are treated as integers. It is required that N1 < N2 < N3 <'+sLineBreak
        +'... < Nn for this function to work correctly. This is because a binary'+sLineBreak
        +'search is used (very fast).'
    ),

    // Function nr. 104
    (
      Name:         'ISEMPTY';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 if the geometry value g is the empty geometry, 0 if it is not'+sLineBreak
        +'empty, and -1 if the argument is NULL. If the geometry is empty, it'+sLineBreak
        +'represents the empty point set.'
    ),

    // Function nr. 105
    (
      Name:         'ISNULL';
      Declaration:  '(expr)';
      Category:     'Comparison operators';
      Version:      SQL_VERSION_ANSI;
      Description:  'If expr is NULL, ISNULL() returns 1, otherwise it returns 0.'
    ),

    // Function nr. 106
    (
      Name:         'ISSIMPLE';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Currently, this function is a placeholder and should not be used. If'+sLineBreak
        +'implemented, its behavior will be as described in the next paragraph.'+sLineBreak
        +''+sLineBreak
        +'Returns 1 if the geometry value g has no anomalous geometric points,'+sLineBreak
        +'such as self-intersection or self-tangency. IsSimple() returns 0 if the'+sLineBreak
        +'argument is not simple, and -1 if it is NULL.'+sLineBreak
        +''+sLineBreak
        +'The description of each instantiable geometric class given earlier in'+sLineBreak
        +'the chapter includes the specific conditions that cause an instance of'+sLineBreak
        +'that class to be classified as not simple. (See [HELP Geometry'+sLineBreak
        +'hierarchy].)'
    ),

    // Function nr. 107
    (
      Name:         'IS_FREE_LOCK';
      Declaration:  '(str)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Checks whether the lock named str is free to use (that is, not locked).'+sLineBreak
        +'Returns 1 if the lock is free (no one is using the lock), 0 if the lock'+sLineBreak
        +'is in use, and NULL if an error occurs (such as an incorrect argument).'
    ),

    // Function nr. 108
    (
      Name:         'IS_USED_LOCK';
      Declaration:  '(str)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Checks whether the lock named str is in use (that is, locked). If so,'+sLineBreak
        +'it returns the connection identifier of the client that holds the lock.'+sLineBreak
        +'Otherwise, it returns NULL.'
    ),

    // Function nr. 109
    (
      Name:         'LAST_DAY';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Takes a date or datetime value and returns the corresponding value for'+sLineBreak
        +'the last day of the month. Returns NULL if the argument is invalid.'
    ),

    // Function nr. 110
    (
      Name:         'LAST_INSERT_ID';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'LAST_INSERT_ID() (with no argument) returns a BIGINT (64-bit) value'+sLineBreak
        +'representing the first automatically generated value successfully'+sLineBreak
        +'inserted for an AUTO_INCREMENT column as a result of the most recently'+sLineBreak
        +'executed INSERT statement. The value of LAST_INSERT_ID() remains'+sLineBreak
        +'unchanged if no rows are successfully inserted.'+sLineBreak
        +''+sLineBreak
        +'For example, after inserting a row that generates an AUTO_INCREMENT'+sLineBreak
        +'value, you can get the value like this:'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT LAST_INSERT_ID();'+sLineBreak
        +'        -> 195'+sLineBreak
        +''+sLineBreak
        +'The currently executing statement does not affect the value of'+sLineBreak
        +'LAST_INSERT_ID(). Suppose that you generate an AUTO_INCREMENT value'+sLineBreak
        +'with one statement, and then refer to LAST_INSERT_ID() in a'+sLineBreak
        +'multiple-row INSERT statement that inserts rows into a table with its'+sLineBreak
        +'own AUTO_INCREMENT column. The value of LAST_INSERT_ID() will remain'+sLineBreak
        +'stable in the second statement; its value for the second and later rows'+sLineBreak
        +'is not affected by the earlier row insertions. (However, if you mix'+sLineBreak
        +'references to LAST_INSERT_ID() and LAST_INSERT_ID(expr), the effect is'+sLineBreak
        +'undefined.)'+sLineBreak
        +''+sLineBreak
        +'If the previous statement returned an error, the value of'+sLineBreak
        +'LAST_INSERT_ID() is undefined. For transactional tables, if the'+sLineBreak
        +'statement is rolled back due to an error, the value of LAST_INSERT_ID()'+sLineBreak
        +'is left undefined. For manual ROLLBACK, the value of LAST_INSERT_ID()'+sLineBreak
        +'is not restored to that before the transaction; it remains as it was at'+sLineBreak
        +'the point of the ROLLBACK.'+sLineBreak
        +''+sLineBreak
        +'Within the body of a stored routine (procedure or function) or a'+sLineBreak
        +'trigger, the value of LAST_INSERT_ID() changes the same way as for'+sLineBreak
        +'statements executed outside the body of these kinds of objects. The'+sLineBreak
        +'effect of a stored routine or trigger upon the value of'+sLineBreak
        +'LAST_INSERT_ID() that is seen by following statements depends on the'+sLineBreak
        +'kind of routine:'+sLineBreak
        +''+sLineBreak
        +'o If a stored procedure executes statements that change the value of'+sLineBreak
        +'  LAST_INSERT_ID(), the changed value is seen by statements that follow'+sLineBreak
        +'  the procedure call.'+sLineBreak
        +''+sLineBreak
        +'o For stored functions and triggers that change the value, the value is'+sLineBreak
        +'  restored when the function or trigger ends, so following statements'+sLineBreak
        +'  will not see a changed value.'
    ),

    // Function nr. 111
    (
      Name:         'LCASE';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'LCASE() is a synonym for LOWER().'
    ),

    // Function nr. 112
    (
      Name:         'LEAST';
      Declaration:  '(value1,value2,...)';
      Category:     'Comparison operators';
      Version:      SQL_VERSION_ANSI;
      Description:  'With two or more arguments, returns the smallest (minimum-valued)'+sLineBreak
        +'argument. The arguments are compared using the following rules:'+sLineBreak
        +''+sLineBreak
        +'o If any argument is NULL, the result is NULL. No comparison is needed.'+sLineBreak
        +''+sLineBreak
        +'o If the return value is used in an INTEGER context or all arguments'+sLineBreak
        +'  are integer-valued, they are compared as integers.'+sLineBreak
        +''+sLineBreak
        +'o If the return value is used in a REAL context or all arguments are'+sLineBreak
        +'  real-valued, they are compared as reals.'+sLineBreak
        +''+sLineBreak
        +'o If the arguments comprise a mix of numbers and strings, they are'+sLineBreak
        +'  compared as numbers.'+sLineBreak
        +''+sLineBreak
        +'o If any argument is a nonbinary (character) string, the arguments are'+sLineBreak
        +'  compared as nonbinary strings.'+sLineBreak
        +''+sLineBreak
        +'o In all other cases, the arguments are compared as binary strings.'
    ),

    // Function nr. 113
    (
      Name:         'LEFT';
      Declaration:  '(str,len)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the leftmost len characters from the string str, or NULL if any'+sLineBreak
        +'argument is NULL.'
    ),

    // Function nr. 114
    (
      Name:         'LENGTH';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the length of the string str, measured in bytes. A multi-byte'+sLineBreak
        +'character counts as multiple bytes. This means that for a string'+sLineBreak
        +'containing five 2-byte characters, LENGTH() returns 10, whereas'+sLineBreak
        +'CHAR_LENGTH() returns 5.'
    ),

    // Function nr. 115
    (
      Name:         'LINEFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a LINESTRING value using its WKT representation and SRID.'
    ),

    // Function nr. 116
    (
      Name:         'LINEFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a LINESTRING value using its WKB representation and SRID.'
    ),

    // Function nr. 117
    (
      Name:         'LINESTRING';
      Declaration:  '(pt1,pt2,...)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a LineString value from a number of Point or WKB Point'+sLineBreak
        +'arguments. If the number of arguments is less than two, the return'+sLineBreak
        +'value is NULL.'
    ),

    // Function nr. 118
    (
      Name:         'LN';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the natural logarithm of X; that is, the base-e logarithm of X.'+sLineBreak
        +'If X is less than or equal to 0, then NULL is returned.'
    ),

    // Function nr. 119
    (
      Name:         'LOAD_FILE';
      Declaration:  '(file_name)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Reads the file and returns the file contents as a string. To use this'+sLineBreak
        +'function, the file must be located on the server host, you must specify'+sLineBreak
        +'the full path name to the file, and you must have the FILE privilege.'+sLineBreak
        +'The file must be readable by all and its size less than'+sLineBreak
        +'max_allowed_packet bytes. If the secure_file_priv system variable is'+sLineBreak
        +'set to a nonempty directory name, the file to be loaded must be located'+sLineBreak
        +'in that directory.'+sLineBreak
        +''+sLineBreak
        +'If the file does not exist or cannot be read because one of the'+sLineBreak
        +'preceding conditions is not satisfied, the function returns NULL.'+sLineBreak
        +''+sLineBreak
        +'The character_set_filesystem system variable controls interpretation of'+sLineBreak
        +'file names that are given as literal strings.'
    ),

    // Function nr. 120
    (
      Name:         'LOCATE';
      Declaration:  '(substr,str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'The first syntax returns the position of the first occurrence of'+sLineBreak
        +'substring substr in string str. The second syntax returns the position'+sLineBreak
        +'of the first occurrence of substring substr in string str, starting at'+sLineBreak
        +'position pos. Returns 0 if substr is not in str.'
    ),

    // Function nr. 121
    (
      Name:         'LOG';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'If called with one parameter, this function returns the natural'+sLineBreak
        +'logarithm of X. If X is less than or equal to 0, then NULL is returned.'+sLineBreak
        +''+sLineBreak
        +'The inverse of this function (when called with a single argument) is'+sLineBreak
        +'the EXP() function.'
    ),

    // Function nr. 122
    (
      Name:         'LOG10';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the base-10 logarithm of X.'
    ),

    // Function nr. 123
    (
      Name:         'LOG2';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the base-2 logarithm of X.'
    ),

    // Function nr. 124
    (
      Name:         'LOWER';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str with all characters changed to lowercase'+sLineBreak
        +'according to the current character set mapping. The default is latin1'+sLineBreak
        +'(cp1252 West European).'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT LOWER(''QUADRATICALLY'');'+sLineBreak
        +'        -> ''quadratically'''+sLineBreak
        +''+sLineBreak
        +'LOWER() (and UPPER()) are ineffective when applied to binary strings'+sLineBreak
        +'(BINARY, VARBINARY, BLOB). To perform lettercase conversion, convert'+sLineBreak
        +'the string to a nonbinary string:'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SET @str = BINARY ''New York'';'+sLineBreak
        +'MariaDB> SELECT LOWER(@str), LOWER(CONVERT(@str USING latin1));'+sLineBreak
        +'+-------------+-----------------------------------+'+sLineBreak
        +'| LOWER(@str) | LOWER(CONVERT(@str USING latin1)) |'+sLineBreak
        +'+-------------+-----------------------------------+'+sLineBreak
        +'| New York    | new york                          |'+sLineBreak
        +'+-------------+-----------------------------------+'
    ),

    // Function nr. 125
    (
      Name:         'LPAD';
      Declaration:  '(str,len,padstr)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str, left-padded with the string padstr to a length'+sLineBreak
        +'of len characters. If str is longer than len, the return value is'+sLineBreak
        +'shortened to len characters.'
    ),

    // Function nr. 126
    (
      Name:         'LTRIM';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str with leading space characters removed.'
    ),

    // Function nr. 127
    (
      Name:         'MAKEDATE';
      Declaration:  '(year,dayofyear)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a date, given year and day-of-year values. dayofyear must be'+sLineBreak
        +'greater than 0 or the result is NULL.'
    ),

    // Function nr. 128
    (
      Name:         'MAKETIME';
      Declaration:  '(hour,minute,second)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a time value calculated from the hour, minute, and second'+sLineBreak
        +'arguments.'
    ),

    // Function nr. 129
    (
      Name:         'MAKE_SET';
      Declaration:  '(bits,str1,str2,...)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a set value (a string containing substrings separated by ","'+sLineBreak
        +'characters) consisting of the strings that have the corresponding bit'+sLineBreak
        +'in bits set. str1 corresponds to bit 0, str2 to bit 1, and so on. NULL'+sLineBreak
        +'values in str1, str2, ... are not appended to the result.'
    ),

    // Function nr. 130
    (
      Name:         'MASTER_POS_WAIT';
      Declaration:  '(log_name,log_pos[,timeout])';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This function is useful for control of master/slave synchronization. It'+sLineBreak
        +'blocks until the slave has read and applied all updates up to the'+sLineBreak
        +'specified position in the master log. The return value is the number of'+sLineBreak
        +'log events the slave had to wait for to advance to the specified'+sLineBreak
        +'position. The function returns NULL if the slave SQL thread is not'+sLineBreak
        +'started, the slave''s master information is not initialized, the'+sLineBreak
        +'arguments are incorrect, or an error occurs. It returns -1 if the'+sLineBreak
        +'timeout has been exceeded. If the slave SQL thread stops while'+sLineBreak
        +'MASTER_POS_WAIT() is waiting, the function returns NULL. If the slave'+sLineBreak
        +'is past the specified position, the function returns immediately.'+sLineBreak
        +''+sLineBreak
        +'If a timeout value is specified, MASTER_POS_WAIT() stops waiting when'+sLineBreak
        +'timeout seconds have elapsed. timeout must be greater than 0; a zero or'+sLineBreak
        +'negative timeout means no timeout.'
    ),

    // Function nr. 131
    (
      Name:         'MAX';
      Declaration:  '([DISTINCT] expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the maximum value of expr. MAX() may take a string argument; in'+sLineBreak
        +'such cases, it returns the maximum string value. See'+sLineBreak
        +'https://mariadb.com/kb/en/max/. The DISTINCT'+sLineBreak
        +'keyword can be used to find the maximum of the distinct values of expr,'+sLineBreak
        +'however, this produces the same result as omitting DISTINCT.'+sLineBreak
        +''+sLineBreak
        +'MAX() returns NULL if there were no matching rows.'
    ),

    // Function nr. 132
    (
      Name:         'MBRCONTAINS';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangle of g1'+sLineBreak
        +'contains the Minimum Bounding Rectangle of g2. This tests the opposite'+sLineBreak
        +'relationship as MBRWithin().'
    ),

    // Function nr. 133
    (
      Name:         'MBRDISJOINT';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangles of'+sLineBreak
        +'the two geometries g1 and g2 are disjoint (do not intersect).'
    ),

    // Function nr. 134
    (
      Name:         'MBREQUAL';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangles of'+sLineBreak
        +'the two geometries g1 and g2 are the same.'
    ),

    // Function nr. 135
    (
      Name:         'MBRINTERSECTS';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangles of'+sLineBreak
        +'the two geometries g1 and g2 intersect.'
    ),

    // Function nr. 136
    (
      Name:         'MBROVERLAPS';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangles of'+sLineBreak
        +'the two geometries g1 and g2 overlap. The term spatially overlaps is'+sLineBreak
        +'used if two geometries intersect and their intersection results in a'+sLineBreak
        +'geometry of the same dimension but not equal to either of the given'+sLineBreak
        +'geometries.'
    ),

    // Function nr. 137
    (
      Name:         'MBRTOUCHES';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangles of'+sLineBreak
        +'the two geometries g1 and g2 touch. Two geometries spatially touch if'+sLineBreak
        +'the interiors of the geometries do not intersect, but the boundary of'+sLineBreak
        +'one of the geometries intersects either the boundary or the interior of'+sLineBreak
        +'the other.'
    ),

    // Function nr. 138
    (
      Name:         'MBRWITHIN';
      Declaration:  '(g1,g2)';
      Category:     'MBR';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether the Minimum Bounding Rectangle of g1'+sLineBreak
        +'is within the Minimum Bounding Rectangle of g2. This tests the opposite'+sLineBreak
        +'relationship as MBRContains().'
    ),

    // Function nr. 139
    (
      Name:         'MD5';
      Declaration:  '(str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Calculates an MD5 128-bit checksum for the string. The value is'+sLineBreak
        +'returned as a string of 32 hex digits, or NULL if the argument was'+sLineBreak
        +'NULL. The return value can, for example, be used as a hash key. See the'+sLineBreak
        +'notes at the beginning of this section about storing hash values'+sLineBreak
        +'efficiently.'+sLineBreak
        +''+sLineBreak
        +'As of MySQL 5.5.3, the return value is a nonbinary string in the'+sLineBreak
        +'connection character set. Before 5.5.3, the return value is a binary'+sLineBreak
        +'string; see the notes at the beginning of this section about using the'+sLineBreak
        +'value as a nonbinary string.'
    ),

    // Function nr. 140
    (
      Name:         'MICROSECOND';
      Declaration:  '(expr)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the microseconds from the time or datetime expression expr as a'+sLineBreak
        +'number in the range from 0 to 999999.'
    ),

    // Function nr. 141
    (
      Name:         'MID';
      Declaration:  '(str,pos,len)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'MID(str,pos,len) is a synonym for SUBSTRING(str,pos,len).'
    ),

    // Function nr. 142
    (
      Name:         'MIN';
      Declaration:  '([DISTINCT] expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the minimum value of expr. MIN() may take a string argument; in'+sLineBreak
        +'such cases, it returns the minimum string value.'+sLineBreak
        +'The DISTINCT keyword can be used to find the minimum of the distinct values'+sLineBreak
        +'of expr, however, this produces the same result as omitting DISTINCT.'+sLineBreak
        +''+sLineBreak
        +'MIN() returns NULL if there were no matching rows.'
    ),

    // Function nr. 143
    (
      Name:         'MINUTE';
      Declaration:  '(time)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the minute for time, in the range 0 to 59.'
    ),

    // Function nr. 144
    (
      Name:         'MLINEFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MULTILINESTRING value using its WKT representation and'+sLineBreak
        +'SRID.'
    ),

    // Function nr. 145
    (
      Name:         'MLINEFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MULTILINESTRING value using its WKB representation and'+sLineBreak
        +'SRID.'
    ),

    // Function nr. 146
    (
      Name:         'MOD';
      Declaration:  '(N,M)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Modulo operation. Returns the remainder of N divided by M.'
    ),

    // Function nr. 147
    (
      Name:         'MONTH';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the month for date, in the range 1 to 12 for January to'+sLineBreak
        +'December, or 0 for dates such as ''0000-00-00'' or ''2008-00-00'' that have'+sLineBreak
        +'a zero month part.'
    ),

    // Function nr. 148
    (
      Name:         'MONTHNAME';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the full name of the month for date. The language used for the'+sLineBreak
        +'name is controlled by the value of the lc_time_names system variable'+sLineBreak
        +'(https://mariadb.com/kb/en/server-locale/).'
    ),

    // Function nr. 149
    (
      Name:         'MPOINTFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MULTIPOINT value using its WKT representation and SRID.'
    ),

    // Function nr. 150
    (
      Name:         'MPOINTFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MULTIPOINT value using its WKB representation and SRID.'
    ),

    // Function nr. 151
    (
      Name:         'MPOLYFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MULTIPOLYGON value using its WKT representation and SRID.'
    ),

    // Function nr. 152
    (
      Name:         'MPOLYFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MULTIPOLYGON value using its WKB representation and SRID.'
    ),

    // Function nr. 153
    (
      Name:         'MULTILINESTRING';
      Declaration:  '(ls1,ls2,...)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MultiLineString value using LineString or WKB LineString'+sLineBreak
        +'arguments.'
    ),

    // Function nr. 154
    (
      Name:         'MULTIPOINT';
      Declaration:  '(pt1,pt2,...)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MultiPoint value using Point or WKB Point arguments.'
    ),

    // Function nr. 155
    (
      Name:         'MULTIPOLYGON';
      Declaration:  '(poly1,poly2,...)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a MultiPolygon value from a set of Polygon or WKB Polygon'+sLineBreak
        +'arguments.'
    ),

    // Function nr. 156
    (
      Name:         'NAME_CONST';
      Declaration:  '(name,value)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the given value. When used to produce a result set column,'+sLineBreak
        +'NAME_CONST() causes the column to have the given name. The arguments'+sLineBreak
        +'should be constants.'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT NAME_CONST(''myname'', 14);'+sLineBreak
        +'+--------+'+sLineBreak
        +'| myname |'+sLineBreak
        +'+--------+'+sLineBreak
        +'|     14 |'+sLineBreak
        +'+--------+'
    ),

    // Function nr. 157
    (
      Name:         'NOW';
      Declaration:  '()';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the current date and time as a value in ''YYYY-MM-DD HH:MM:SS'''+sLineBreak
        +'or YYYYMMDDHHMMSS.uuuuuu format, depending on whether the function is'+sLineBreak
        +'used in a string or numeric context. The value is expressed in the'+sLineBreak
        +'current time zone.'
    ),

    // Function nr. 158
    (
      Name:         'NULLIF';
      Declaration:  '(expr1,expr2)';
      Category:     'Control flow functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns NULL if expr1 = expr2 is true, otherwise returns expr1. This is'+sLineBreak
        +'the same as CASE WHEN expr1 = expr2 THEN NULL ELSE expr1 END.'
    ),

    // Function nr. 159
    (
      Name:         'NUMGEOMETRIES';
      Declaration:  '(gc)';
      Category:     'GeometryCollection properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the number of geometries in the GeometryCollection value gc.'
    ),

    // Function nr. 160
    (
      Name:         'NUMINTERIORRINGS';
      Declaration:  '(poly)';
      Category:     'Polygon properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the number of interior rings in the Polygon value poly.'
    ),

    // Function nr. 161
    (
      Name:         'NUMPOINTS';
      Declaration:  '(ls)';
      Category:     'LineString properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the number of Point objects in the LineString value ls.'
    ),

    // Function nr. 162
    (
      Name:         'OCT';
      Declaration:  '(N)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a string representation of the octal value of N, where N is a'+sLineBreak
        +'longlong (BIGINT) number. This is equivalent to CONV(N,10,8). Returns'+sLineBreak
        +'NULL if N is NULL.'
    ),

    // Function nr. 163
    (
      Name:         'OCTET_LENGTH';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'OCTET_LENGTH() is a synonym for LENGTH().'
    ),

    // Function nr. 164
    (
      Name:         'OLD_PASSWORD';
      Declaration:  '(str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'OLD_PASSWORD() was added when the implementation of PASSWORD() was'+sLineBreak
        +'changed in MySQL 4.1 to improve security. OLD_PASSWORD() returns the'+sLineBreak
        +'value of the pre-4.1 implementation of PASSWORD() as a string, and is'+sLineBreak
        +'intended to permit you to reset passwords for any pre-4.1 clients that'+sLineBreak
        +'need to connect to your version 5.5 MySQL server without locking them'+sLineBreak
        +'out. See http://dev.mysql.com/doc/refman/5.1/en/password-hashing.html.'+sLineBreak
        +''+sLineBreak
        +'As of MySQL 5.5.3, the return value is a nonbinary string in the'+sLineBreak
        +'connection character set. Before 5.5.3, the return value is a binary'+sLineBreak
        +'string.'
    ),

    // Function nr. 165
    (
      Name:         'ORD';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'If the leftmost character of the string str is a multi-byte character,'+sLineBreak
        +'returns the code for that character, calculated from the numeric values'+sLineBreak
        +'of its constituent bytes using this formula:'+sLineBreak
        +''+sLineBreak
        +'  (1st byte code)'+sLineBreak
        +'+ (2nd byte code * 256)'+sLineBreak
        +'+ (3rd byte code * 2562) ...'+sLineBreak
        +''+sLineBreak
        +'If the leftmost character is not a multi-byte character, ORD() returns'+sLineBreak
        +'the same value as the ASCII() function.'
    ),

    // Function nr. 166
    (
      Name:         'OVERLAPS';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 spatially overlaps g2. The term'+sLineBreak
        +'spatially overlaps is used if two geometries intersect and their'+sLineBreak
        +'intersection results in a geometry of the same dimension but not equal'+sLineBreak
        +'to either of the given geometries.'
    ),

    // Function nr. 167
    (
      Name:         'PASSWORD';
      Declaration:  '(str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Calculates and returns a hashed password string from the plaintext'+sLineBreak
        +'password str and returns a nonbinary string in the connection character'+sLineBreak
        +'set (a binary string before MySQL 5.5.3), or NULL if the argument is'+sLineBreak
        +'NULL. This function is the SQL interface to the algorithm used by the'+sLineBreak
        +'server to encrypt MySQL passwords for storage in the mysql.user grant'+sLineBreak
        +'table.'+sLineBreak
        +''+sLineBreak
        +'The password hashing method used by PASSWORD() depends on the value of'+sLineBreak
        +'the old_passwords system variable:'
    ),

    // Function nr. 168
    (
      Name:         'PERIOD_ADD';
      Declaration:  '(P,N)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Adds N months to period P (in the format YYMM or YYYYMM). Returns a'+sLineBreak
        +'value in the format YYYYMM. Note that the period argument P is not a'+sLineBreak
        +'date value.'
    ),

    // Function nr. 169
    (
      Name:         'PERIOD_DIFF';
      Declaration:  '(P1,P2)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the number of months between periods P1 and P2. P1 and P2'+sLineBreak
        +'should be in the format YYMM or YYYYMM. Note that the period arguments'+sLineBreak
        +'P1 and P2 are not date values.'
    ),

    // Function nr. 170
    (
      Name:         'PI';
      Declaration:  '()';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the value of ? (pi). The default number of decimal places'+sLineBreak
        +'displayed is seven, but MySQL uses the full double-precision value'+sLineBreak
        +'internally.'
    ),

    // Function nr. 171
    (
      Name:         'POINT';
      Declaration:  '(x,y)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a Point using its coordinates.'
    ),

    // Function nr. 172
    (
      Name:         'POINTFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a POINT value using its WKT representation and SRID.'
    ),

    // Function nr. 173
    (
      Name:         'POINTFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a POINT value using its WKB representation and SRID.'
    ),

    // Function nr. 174
    (
      Name:         'POINTN';
      Declaration:  '(ls,N)';
      Category:     'LineString properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the N-th Point in the Linestring value ls. Points are numbered'+sLineBreak
        +'beginning with 1.'
    ),

    // Function nr. 175
    (
      Name:         'POLYFROMTEXT';
      Declaration:  '(wkt[,srid])';
      Category:     'WKT';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a POLYGON value using its WKT representation and SRID.'
    ),

    // Function nr. 176
    (
      Name:         'POLYFROMWKB';
      Declaration:  '(wkb[,srid])';
      Category:     'WKB';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a POLYGON value using its WKB representation and SRID.'
    ),

    // Function nr. 177
    (
      Name:         'POLYGON';
      Declaration:  '(ls1,ls2,...)';
      Category:     'Geometry constructors';
      Version:      SQL_VERSION_ANSI;
      Description:  'Constructs a Polygon value from a number of LineString or WKB'+sLineBreak
        +'LineString arguments. If any argument does not represent a LinearRing'+sLineBreak
        +'(that is, not a closed and simple LineString), the return value is'+sLineBreak
        +'NULL.'
    ),

    // Function nr. 178
    (
      Name:         'POSITION';
      Declaration:  '(substr IN str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'POSITION(substr IN str) is a synonym for LOCATE(substr,str).'
    ),

    // Function nr. 179
    (
      Name:         'POW';
      Declaration:  '(X,Y)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the value of X raised to the power of Y.'
    ),

    // Function nr. 180
    (
      Name:         'POWER';
      Declaration:  '(X,Y)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This is a synonym for POW().'
    ),

    // Function nr. 181
    (
      Name:         'QUARTER';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the quarter of the year for date, in the range 1 to 4.'
    ),

    // Function nr. 182
    (
      Name:         'QUOTE';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Quotes a string to produce a result that can be used as a properly'+sLineBreak
        +'escaped data value in an SQL statement. The string is returned enclosed'+sLineBreak
        +'by single quotation marks and with each instance of backslash ("\"),'+sLineBreak
        +'single quote ("''"), ASCII NUL, and Control+Z preceded by a backslash.'+sLineBreak
        +'If the argument is NULL, the return value is the word "NULL" without'+sLineBreak
        +'enclosing single quotation marks.'
    ),

    // Function nr. 183
    (
      Name:         'RADIANS';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the argument X, converted from degrees to radians. (Note that'+sLineBreak
        +'? radians equals 180 degrees.)'
    ),

    // Function nr. 184
    (
      Name:         'RAND';
      Declaration:  '()';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a random floating-point value v in the range 0 <= v < 1.0. If a'+sLineBreak
        +'constant integer argument N is specified, it is used as the seed value,'+sLineBreak
        +'which produces a repeatable sequence of column values. In the following'+sLineBreak
        +'example, note that the sequences of values produced by RAND(3) is the'+sLineBreak
        +'same both places where it occurs.'
    ),

    // Function nr. 185
    (
      Name:         'RELEASE_LOCK';
      Declaration:  '(str)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Releases the lock named by the string str that was obtained with'+sLineBreak
        +'GET_LOCK(). Returns 1 if the lock was released, 0 if the lock was not'+sLineBreak
        +'established by this thread (in which case the lock is not released),'+sLineBreak
        +'and NULL if the named lock did not exist. The lock does not exist if it'+sLineBreak
        +'was never obtained by a call to GET_LOCK() or if it has previously been'+sLineBreak
        +'released.'+sLineBreak
        +''+sLineBreak
        +'The DO statement is convenient to use with RELEASE_LOCK(). See [HELP'+sLineBreak
        +'DO].'
    ),

    // Function nr. 186
    (
      Name:         'REVERSE';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str with the order of the characters reversed.'
    ),

    // Function nr. 187
    (
      Name:         'RIGHT';
      Declaration:  '(str,len)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the rightmost len characters from the string str, or NULL if'+sLineBreak
        +'any argument is NULL.'
    ),

    // Function nr. 188
    (
      Name:         'ROUND';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Rounds the argument X to D decimal places. The rounding algorithm'+sLineBreak
        +'depends on the data type of X. D defaults to 0 if not specified. D can'+sLineBreak
        +'be negative to cause D digits left of the decimal point of the value X'+sLineBreak
        +'to become zero.'
    ),

    // Function nr. 189
    (
      Name:         'ROW_COUNT';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Before MySQL 5.5.5, ROW_COUNT() returns the number of rows changed,'+sLineBreak
        +'deleted, or inserted by the last statement if it was an UPDATE, DELETE,'+sLineBreak
        +'or INSERT. For other statements, the value may not be meaningful.'+sLineBreak
        +''+sLineBreak
        +'As of MySQL 5.5.5, ROW_COUNT() returns a value as follows:'+sLineBreak
        +''+sLineBreak
        +'o DDL statements: 0. This applies to statements such as CREATE TABLE or'+sLineBreak
        +'  DROP TABLE.'+sLineBreak
        +''+sLineBreak
        +'o DML statements other than SELECT: The number of affected rows. This'+sLineBreak
        +'  applies to statements such as UPDATE, INSERT, or DELETE (as before),'+sLineBreak
        +'  but now also to statements such as ALTER TABLE and LOAD DATA INFILE.'+sLineBreak
        +''+sLineBreak
        +'o SELECT: -1 if the statement returns a result set, or the number of'+sLineBreak
        +'  rows "affected" if it does not. For example, for SELECT * FROM t1,'+sLineBreak
        +'  ROW_COUNT() returns -1. For SELECT * FROM t1 INTO OUTFILE'+sLineBreak
        +'  ''file_name'', ROW_COUNT() returns the number of rows written to the'+sLineBreak
        +'  file.'+sLineBreak
        +''+sLineBreak
        +'o SIGNAL statements: 0.'+sLineBreak
        +''+sLineBreak
        +'For UPDATE statements, the affected-rows value by default is the number'+sLineBreak
        +'of rows actually changed. If you specify the CLIENT_FOUND_ROWS flag to'+sLineBreak
        +'mysql_real_connect() when connecting to mysqld, the affected-rows value'+sLineBreak
        +'is the number of rows "found"; that is, matched by the WHERE clause.'+sLineBreak
        +''+sLineBreak
        +'For REPLACE statements, the affected-rows value is 2 if the new row'+sLineBreak
        +'replaced an old row, because in this case, one row was inserted after'+sLineBreak
        +'the duplicate was deleted.'+sLineBreak
        +''+sLineBreak
        +'For INSERT ... ON DUPLICATE KEY UPDATE statements, the affected-rows'+sLineBreak
        +'value is 1 if the row is inserted as a new row and 2 if an existing row'+sLineBreak
        +'is updated.'+sLineBreak
        +''+sLineBreak
        +'The ROW_COUNT() value is similar to the value from the'+sLineBreak
        +'mysql_affected_rows() C API function and the row count that the mysql'+sLineBreak
        +'client displays following statement execution.'
    ),

    // Function nr. 190
    (
      Name:         'RPAD';
      Declaration:  '(str,len,padstr)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str, right-padded with the string padstr to a length'+sLineBreak
        +'of len characters. If str is longer than len, the return value is'+sLineBreak
        +'shortened to len characters.'
    ),

    // Function nr. 191
    (
      Name:         'RTRIM';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str with trailing space characters removed.'
    ),

    // Function nr. 192
    (
      Name:         'SCHEMA';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This function is a synonym for DATABASE().'
    ),

    // Function nr. 193
    (
      Name:         'SECOND';
      Declaration:  '(time)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the second for time, in the range 0 to 59.'
    ),

    // Function nr. 194
    (
      Name:         'SEC_TO_TIME';
      Declaration:  '(seconds)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the seconds argument, converted to hours, minutes, and seconds,'+sLineBreak
        +'as a TIME value. The range of the result is constrained to that of the'+sLineBreak
        +'TIME data type. A warning occurs if the argument corresponds to a value'+sLineBreak
        +'outside that range.'
    ),

    // Function nr. 195
    (
      Name:         'SESSION_USER';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'SESSION_USER() is a synonym for USER().'
    ),

    // Function nr. 196
    (
      Name:         'SHA1';
      Declaration:  '(str)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Calculates an SHA-1 160-bit checksum for the string, as described in'+sLineBreak
        +'RFC 3174 (Secure Hash Algorithm). The value is returned as a string of'+sLineBreak
        +'40 hex digits, or NULL if the argument was NULL. One of the possible'+sLineBreak
        +'uses for this function is as a hash key. See the notes at the beginning'+sLineBreak
        +'of this section about storing hash values efficiently. You can also use'+sLineBreak
        +'SHA1() as a cryptographic function for storing passwords. SHA() is'+sLineBreak
        +'synonymous with SHA1().'+sLineBreak
        +''+sLineBreak
        +'As of MySQL 5.5.3, the return value is a nonbinary string in the'+sLineBreak
        +'connection character set. Before 5.5.3, the return value is a binary'+sLineBreak
        +'string; see the notes at the beginning of this section about using the'+sLineBreak
        +'value as a nonbinary string.'
    ),

    // Function nr. 197
    (
      Name:         'SHA2';
      Declaration:  '(str, hash_length)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Calculates the SHA-2 family of hash functions (SHA-224, SHA-256,'+sLineBreak
        +'SHA-384, and SHA-512). The first argument is the cleartext string to be'+sLineBreak
        +'hashed. The second argument indicates the desired bit length of the'+sLineBreak
        +'result, which must have a value of 224, 256, 384, 512, or 0 (which is'+sLineBreak
        +'equivalent to 256). If either argument is NULL or the hash length is'+sLineBreak
        +'not one of the permitted values, the return value is NULL. Otherwise,'+sLineBreak
        +'the function result is a hash value containing the desired number of'+sLineBreak
        +'bits. See the notes at the beginning of this section about storing hash'+sLineBreak
        +'values efficiently.'+sLineBreak
        +''+sLineBreak
        +'As of MySQL 5.5.6, the return value is a nonbinary string in the'+sLineBreak
        +'connection character set. Before 5.5.6, the return value is a binary'+sLineBreak
        +'string; see the notes at the beginning of this section about using the'+sLineBreak
        +'value as a nonbinary string.'
    ),

    // Function nr. 198
    (
      Name:         'SIGN';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the sign of the argument as -1, 0, or 1, depending on whether X'+sLineBreak
        +'is negative, zero, or positive.'
    ),

    // Function nr. 199
    (
      Name:         'SIN';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the sine of X, where X is given in radians.'
    ),

    // Function nr. 200
    (
      Name:         'SLEEP';
      Declaration:  '(duration)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Sleeps (pauses) for the number of seconds given by the duration'+sLineBreak
        +'argument, then returns 0. If SLEEP() is interrupted, it returns 1. The'+sLineBreak
        +'duration may have a fractional part given in microseconds.'
    ),

    // Function nr. 201
    (
      Name:         'SOUNDEX';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a soundex string from str. Two strings that sound almost the'+sLineBreak
        +'same should have identical soundex strings. A standard soundex string'+sLineBreak
        +'is four characters long, but the SOUNDEX() function returns an'+sLineBreak
        +'arbitrarily long string. You can use SUBSTRING() on the result to get a'+sLineBreak
        +'standard soundex string. All nonalphabetic characters in str are'+sLineBreak
        +'ignored. All international alphabetic characters outside the A-Z range'+sLineBreak
        +'are treated as vowels.'+sLineBreak
        +''+sLineBreak
        +'*Important*: When using SOUNDEX(), you should be aware of the following'+sLineBreak
        +'limitations:'+sLineBreak
        +''+sLineBreak
        +'o This function, as currently implemented, is intended to work well'+sLineBreak
        +'  with strings that are in the English language only. Strings in other'+sLineBreak
        +'  languages may not produce reliable results.'+sLineBreak
        +''+sLineBreak
        +'o This function is not guaranteed to provide consistent results with'+sLineBreak
        +'  strings that use multi-byte character sets, including utf-8.'+sLineBreak
        +''+sLineBreak
        +'  We hope to remove these limitations in a future release. See Bug'+sLineBreak
        +'  #22638 for more information.'
    ),

    // Function nr. 202
    (
      Name:         'SPACE';
      Declaration:  '(N)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a string consisting of N space characters.'
    ),

    // Function nr. 203
    (
      Name:         'SQRT';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the square root of a nonnegative number X.'
    ),

    // Function nr. 204
    (
      Name:         'SRID';
      Declaration:  '(g)';
      Category:     'Geometry properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns an integer indicating the Spatial Reference System ID for the'+sLineBreak
        +'geometry value g.'+sLineBreak
        +''+sLineBreak
        +'In MySQL, the SRID value is just an integer associated with the'+sLineBreak
        +'geometry value. All calculations are done assuming Euclidean (planar)'+sLineBreak
        +'geometry.'
    ),

    // Function nr. 205
    (
      Name:         'STARTPOINT';
      Declaration:  '(ls)';
      Category:     'LineString properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the Point that is the start point of the LineString value ls.'
    ),

    // Function nr. 206
    (
      Name:         'STD';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the population standard deviation of expr. This is an extension'+sLineBreak
        +'to standard SQL. The standard SQL function STDDEV_POP() can be used'+sLineBreak
        +'instead.'+sLineBreak
        +''+sLineBreak
        +'This function returns NULL if there were no matching rows.'
    ),

    // Function nr. 207
    (
      Name:         'STDDEV';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the population standard deviation of expr. This function is'+sLineBreak
        +'provided for compatibility with Oracle. The standard SQL function'+sLineBreak
        +'STDDEV_POP() can be used instead.'+sLineBreak
        +''+sLineBreak
        +'This function returns NULL if there were no matching rows.'
    ),

    // Function nr. 208
    (
      Name:         'STDDEV_POP';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the population standard deviation of expr (the square root of'+sLineBreak
        +'VAR_POP()). You can also use STD() or STDDEV(), which are equivalent'+sLineBreak
        +'but not standard SQL.'+sLineBreak
        +''+sLineBreak
        +'STDDEV_POP() returns NULL if there were no matching rows.'
    ),

    // Function nr. 209
    (
      Name:         'STDDEV_SAMP';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the sample standard deviation of expr (the square root of'+sLineBreak
        +'VAR_SAMP().'+sLineBreak
        +''+sLineBreak
        +'STDDEV_SAMP() returns NULL if there were no matching rows.'
    ),

    // Function nr. 210
    (
      Name:         'STRCMP';
      Declaration:  '(expr1,expr2)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'STRCMP() returns 0 if the strings are the same, -1 if the first'+sLineBreak
        +'argument is smaller than the second according to the current sort'+sLineBreak
        +'order, and 1 otherwise.'
    ),

    // Function nr. 211
    (
      Name:         'STR_TO_DATE';
      Declaration:  '(str,format)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This is the inverse of the DATE_FORMAT() function. It takes a string'+sLineBreak
        +'str and a format string format. STR_TO_DATE() returns a DATETIME value'+sLineBreak
        +'if the format string contains both date and time parts, or a DATE or'+sLineBreak
        +'TIME value if the string contains only date or time parts. If the date,'+sLineBreak
        +'time, or datetime value extracted from str is illegal, STR_TO_DATE()'+sLineBreak
        +'returns NULL and produces a warning.'+sLineBreak
        +''+sLineBreak
        +'The server scans str attempting to match format to it. The format'+sLineBreak
        +'string can contain literal characters and format specifiers beginning'+sLineBreak
        +'with %. Literal characters in format must match literally in str.'+sLineBreak
        +'Format specifiers in format must match a date or time part in str. For'+sLineBreak
        +'the specifiers that can be used in format, see the DATE_FORMAT()'+sLineBreak
        +'function description.'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''01,5,2013'',''%d,%m,%Y'');'+sLineBreak
        +'        -> ''2013-05-01'''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''May 1, 2013'',''%M %d,%Y'');'+sLineBreak
        +'        -> ''2013-05-01'''+sLineBreak
        +''+sLineBreak
        +'Scanning starts at the beginning of str and fails if format is found'+sLineBreak
        +'not to match. Extra characters at the end of str are ignored.'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''a09:30:17'',''a%h:%i:%s'');'+sLineBreak
        +'        -> ''09:30:17'''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''a09:30:17'',''%h:%i:%s'');'+sLineBreak
        +'        -> NULL'+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''09:30:17a'',''%h:%i:%s'');'+sLineBreak
        +'        -> ''09:30:17'''+sLineBreak
        +''+sLineBreak
        +'Unspecified date or time parts have a value of 0, so incompletely'+sLineBreak
        +'specified values in str produce a result with some or all parts set to'+sLineBreak
        +'0:'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''abc'',''abc'');'+sLineBreak
        +'        -> ''0000-00-00'''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''9'',''%m'');'+sLineBreak
        +'        -> ''0000-09-00'''+sLineBreak
        +'MariaDB> SELECT STR_TO_DATE(''9'',''%s'');'+sLineBreak
        +'        -> ''00:00:09'''
    ),

    // Function nr. 212
    (
      Name:         'SUBDATE';
      Declaration:  '(date,INTERVAL expr unit)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'When invoked with the INTERVAL form of the second argument, SUBDATE()'+sLineBreak
        +'is a synonym for DATE_SUB(). For information on the INTERVAL unit'+sLineBreak
        +'argument, see the discussion for DATE_ADD().'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT DATE_SUB(''2008-01-02'', INTERVAL 31 DAY);'+sLineBreak
        +'        -> ''2007-12-02'''+sLineBreak
        +'MariaDB> SELECT SUBDATE(''2008-01-02'', INTERVAL 31 DAY);'+sLineBreak
        +'        -> ''2007-12-02'''+sLineBreak
        +''+sLineBreak
        +'The second form enables the use of an integer value for days. In such'+sLineBreak
        +'cases, it is interpreted as the number of days to be subtracted from'+sLineBreak
        +'the date or datetime expression expr.'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT SUBDATE(''2008-01-02 12:00:00'', 31);'+sLineBreak
        +'        -> ''2007-12-02 12:00:00'''
    ),

    // Function nr. 213
    (
      Name:         'SUBSTR';
      Declaration:  '(str,pos)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'FROM pos FOR len)'+sLineBreak
        +''+sLineBreak
        +'SUBSTR() is a synonym for SUBSTRING().'
    ),

    // Function nr. 214
    (
      Name:         'SUBSTRING';
      Declaration:  '(str,pos)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'SUBSTRING(str FROM pos FOR len)'+sLineBreak
        +''+sLineBreak
        +'The forms without a len argument return a substring from string str'+sLineBreak
        +'starting at position pos. The forms with a len argument return a'+sLineBreak
        +'substring len characters long from string str, starting at position'+sLineBreak
        +'pos. The forms that use FROM are standard SQL syntax. It is also'+sLineBreak
        +'possible to use a negative value for pos. In this case, the beginning'+sLineBreak
        +'of the substring is pos characters from the end of the string, rather'+sLineBreak
        +'than the beginning. A negative value may be used for pos in any of the'+sLineBreak
        +'forms of this function.'+sLineBreak
        +''+sLineBreak
        +'For all forms of SUBSTRING(), the position of the first character in'+sLineBreak
        +'the string from which the substring is to be extracted is reckoned as'+sLineBreak
        +'1.'
    ),

    // Function nr. 215
    (
      Name:         'SUBSTRING_INDEX';
      Declaration:  '(str,delim,count)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the substring from string str before count occurrences of the'+sLineBreak
        +'delimiter delim. If count is positive, everything to the left of the'+sLineBreak
        +'final delimiter (counting from the left) is returned. If count is'+sLineBreak
        +'negative, everything to the right of the final delimiter (counting from'+sLineBreak
        +'the right) is returned. SUBSTRING_INDEX() performs a case-sensitive'+sLineBreak
        +'match when searching for delim.'
    ),

    // Function nr. 216
    (
      Name:         'SUBTIME';
      Declaration:  '(expr1,expr2)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'SUBTIME() returns expr1 - expr2 expressed as a value in the same format'+sLineBreak
        +'as expr1. expr1 is a time or datetime expression, and expr2 is a time'+sLineBreak
        +'expression.'
    ),

    // Function nr. 217
    (
      Name:         'SUM';
      Declaration:  '([DISTINCT] expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the sum of expr. If the return set has no rows, SUM() returns'+sLineBreak
        +'NULL. The DISTINCT keyword can be used to sum only the distinct values'+sLineBreak
        +'of expr.'+sLineBreak
        +''+sLineBreak
        +'SUM() returns NULL if there were no matching rows.'
    ),

    // Function nr. 218
    (
      Name:         'SYSDATE';
      Declaration:  '()';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the current date and time as a value in ''YYYY-MM-DD HH:MM:SS'''+sLineBreak
        +'or YYYYMMDDHHMMSS.uuuuuu format, depending on whether the function is'+sLineBreak
        +'used in a string or numeric context.'+sLineBreak
        +''+sLineBreak
        +'SYSDATE() returns the time at which it executes. This differs from the'+sLineBreak
        +'behavior for NOW(), which returns a constant time that indicates the'+sLineBreak
        +'time at which the statement began to execute. (Within a stored function'+sLineBreak
        +'or trigger, NOW() returns the time at which the function or triggering'+sLineBreak
        +'statement began to execute.)'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT NOW(), SLEEP(2), NOW();'+sLineBreak
        +'+---------------------+----------+---------------------+'+sLineBreak
        +'| NOW()               | SLEEP(2) | NOW()               |'+sLineBreak
        +'+---------------------+----------+---------------------+'+sLineBreak
        +'| 2006-04-12 13:47:36 |        0 | 2006-04-12 13:47:36 |'+sLineBreak
        +'+---------------------+----------+---------------------+'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT SYSDATE(), SLEEP(2), SYSDATE();'+sLineBreak
        +'+---------------------+----------+---------------------+'+sLineBreak
        +'| SYSDATE()           | SLEEP(2) | SYSDATE()           |'+sLineBreak
        +'+---------------------+----------+---------------------+'+sLineBreak
        +'| 2006-04-12 13:47:44 |        0 | 2006-04-12 13:47:46 |'+sLineBreak
        +'+---------------------+----------+---------------------+'+sLineBreak
        +''+sLineBreak
        +'In addition, the SET TIMESTAMP statement affects the value returned by'+sLineBreak
        +'NOW() but not by SYSDATE(). This means that timestamp settings in the'+sLineBreak
        +'binary log have no effect on invocations of SYSDATE().'+sLineBreak
        +''+sLineBreak
        +'Because SYSDATE() can return different values even within the same'+sLineBreak
        +'statement, and is not affected by SET TIMESTAMP, it is nondeterministic'+sLineBreak
        +'and therefore unsafe for replication if statement-based binary logging'+sLineBreak
        +'is used. If that is a problem, you can use row-based logging.'+sLineBreak
        +''+sLineBreak
        +'Alternatively, you can use the --sysdate-is-now option to cause'+sLineBreak
        +'SYSDATE() to be an alias for NOW(). This works if the option is used on'+sLineBreak
        +'both the master and the slave.'+sLineBreak
        +''+sLineBreak
        +'The nondeterministic nature of SYSDATE() also means that indexes cannot'+sLineBreak
        +'be used for evaluating expressions that refer to it.'
    ),

    // Function nr. 219
    (
      Name:         'SYSTEM_USER';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'SYSTEM_USER() is a synonym for USER().'
    ),

    // Function nr. 220
    (
      Name:         'TAN';
      Declaration:  '(X)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the tangent of X, where X is given in radians.'
    ),

    // Function nr. 221
    (
      Name:         'TIMEDIFF';
      Declaration:  '(expr1,expr2)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'TIMEDIFF() returns expr1 - expr2 expressed as a time value. expr1 and'+sLineBreak
        +'expr2 are time or date-and-time expressions, but both must be of the'+sLineBreak
        +'same type.'+sLineBreak
        +''+sLineBreak
        +'The result returned by TIMEDIFF() is limited to the range allowed for'+sLineBreak
        +'TIME values. Alternatively, you can use either of the functions'+sLineBreak
        +'TIMESTAMPDIFF() and UNIX_TIMESTAMP(), both of which return integers.'
    ),

    // Function nr. 222
    (
      Name:         'TIMESTAMPADD';
      Declaration:  '(unit,interval,datetime_expr)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Adds the integer expression interval to the date or datetime expression'+sLineBreak
        +'datetime_expr. The unit for interval is given by the unit argument,'+sLineBreak
        +'which should be one of the following values: MICROSECOND'+sLineBreak
        +'(microseconds), SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, or'+sLineBreak
        +'YEAR.'+sLineBreak
        +''+sLineBreak
        +'It is possible to use FRAC_SECOND in place of MICROSECOND, but'+sLineBreak
        +'FRAC_SECOND is deprecated. FRAC_SECOND was removed in MySQL 5.5.3.'+sLineBreak
        +''+sLineBreak
        +'The unit value may be specified using one of keywords as shown, or with'+sLineBreak
        +'a prefix of SQL_TSI_. For example, DAY and SQL_TSI_DAY both are legal.'
    ),

    // Function nr. 223
    (
      Name:         'TIMESTAMPDIFF';
      Declaration:  '(unit,datetime_expr1,datetime_expr2)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns datetime_expr2 - datetime_expr1, where datetime_expr1 and'+sLineBreak
        +'datetime_expr2 are date or datetime expressions. One expression may be'+sLineBreak
        +'a date and the other a datetime; a date value is treated as a datetime'+sLineBreak
        +'having the time part ''00:00:00'' where necessary. The unit for the'+sLineBreak
        +'result (an integer) is given by the unit argument. The legal values for'+sLineBreak
        +'unit are the same as those listed in the description of the'+sLineBreak
        +'TIMESTAMPADD() function.'
    ),

    // Function nr. 224
    (
      Name:         'TIME_FORMAT';
      Declaration:  '(time,format)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This is used like the DATE_FORMAT() function, but the format string may'+sLineBreak
        +'contain format specifiers only for hours, minutes, seconds, and'+sLineBreak
        +'microseconds. Other specifiers produce a NULL value or 0.'
    ),

    // Function nr. 225
    (
      Name:         'TIME_TO_SEC';
      Declaration:  '(time)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the time argument, converted to seconds.'
    ),

    // Function nr. 226
    (
      Name:         'TOUCHES';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 spatially touches g2. Two'+sLineBreak
        +'geometries spatially touch if the interiors of the geometries do not'+sLineBreak
        +'intersect, but the boundary of one of the geometries intersects either'+sLineBreak
        +'the boundary or the interior of the other.'
    ),

    // Function nr. 227
    (
      Name:         'TO_DAYS';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Given a date date, returns a day number (the number of days since year'+sLineBreak
        +'0).'
    ),

    // Function nr. 228
    (
      Name:         'TO_SECONDS';
      Declaration:  '(expr)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Given a date or datetime expr, returns a the number of seconds since'+sLineBreak
        +'the year 0. If expr is not a valid date or datetime value, returns'+sLineBreak
        +'NULL.'
    ),

    // Function nr. 229
    (
      Name:         'TRIM';
      Declaration:  '([{BOTH | LEADING | TRAILING} [remstr] FROM] str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'FROM] str)'+sLineBreak
        +''+sLineBreak
        +'Returns the string str with all remstr prefixes or suffixes removed. If'+sLineBreak
        +'none of the specifiers BOTH, LEADING, or TRAILING is given, BOTH is'+sLineBreak
        +'assumed. remstr is optional and, if not specified, spaces are removed.'
    ),

    // Function nr. 230
    (
      Name:         'TRUNCATE';
      Declaration:  '(X,D)';
      Category:     'Numeric Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the number X, truncated to D decimal places. If D is 0, the'+sLineBreak
        +'result has no decimal point or fractional part. D can be negative to'+sLineBreak
        +'cause D digits left of the decimal point of the value X to become zero.'
    ),

    // Function nr. 231
    (
      Name:         'UCASE';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'UCASE() is a synonym for UPPER().'
    ),

    // Function nr. 232
    (
      Name:         'UNCOMPRESS';
      Declaration:  '(string_to_uncompress)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Uncompresses a string compressed by the COMPRESS() function. If the'+sLineBreak
        +'argument is not a compressed value, the result is NULL. This function'+sLineBreak
        +'requires MySQL to have been compiled with a compression library such as'+sLineBreak
        +'zlib. Otherwise, the return value is always NULL.'
    ),

    // Function nr. 233
    (
      Name:         'UNCOMPRESSED_LENGTH';
      Declaration:  '(compressed_string)';
      Category:     'Encryption Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the length that the compressed string had before being'+sLineBreak
        +'compressed.'
    ),

    // Function nr. 234
    (
      Name:         'UNHEX';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'For a string argument str, UNHEX(str) performs the inverse operation of'+sLineBreak
        +'HEX(str). That is, it interprets each pair of characters in the'+sLineBreak
        +'argument as a hexadecimal number and converts it to the character'+sLineBreak
        +'represented by the number. The return value is a binary string.'
    ),

    // Function nr. 235
    (
      Name:         'UNIX_TIMESTAMP';
      Declaration:  '()';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'If called with no argument, returns a Unix timestamp (seconds since'+sLineBreak
        +'''1970-01-01 00:00:00'' UTC) as an unsigned integer. If UNIX_TIMESTAMP()'+sLineBreak
        +'is called with a date argument, it returns the value of the argument as'+sLineBreak
        +'seconds since ''1970-01-01 00:00:00'' UTC. date may be a DATE string, a'+sLineBreak
        +'DATETIME string, a TIMESTAMP, or a number in the format YYMMDD or'+sLineBreak
        +'YYYYMMDD. The server interprets date as a value in the current time'+sLineBreak
        +'zone and converts it to an internal value in UTC. Clients can set their'+sLineBreak
        +'time zone as described in'+sLineBreak
        +'https://mariadb.com/kb/en/time-zones/.'
    ),

    // Function nr. 236
    (
      Name:         'UPDATEXML';
      Declaration:  '(xml_target, xpath_expr, new_xml)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This function replaces a single portion of a given fragment of XML'+sLineBreak
        +'markup xml_target with a new XML fragment new_xml, and then returns the'+sLineBreak
        +'changed XML. The portion of xml_target that is replaced matches an'+sLineBreak
        +'XPath expression xpath_expr supplied by the user. In MySQL 5.5, the'+sLineBreak
        +'XPath expression can contain at most 127 characters. (This limitation'+sLineBreak
        +'is lifted in MySQL 5.6.)'+sLineBreak
        +''+sLineBreak
        +'If no expression matching xpath_expr is found, or if multiple matches'+sLineBreak
        +'are found, the function returns the original xml_target XML fragment.'+sLineBreak
        +'All three arguments should be strings.'
    ),

    // Function nr. 237
    (
      Name:         'UPPER';
      Declaration:  '(str)';
      Category:     'String Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the string str with all characters changed to uppercase'+sLineBreak
        +'according to the current character set mapping. The default is latin1'+sLineBreak
        +'(cp1252 West European).'+sLineBreak
        +''+sLineBreak
        +'MariaDB> SELECT UPPER(''Hej'');'+sLineBreak
        +'        -> ''HEJ'''+sLineBreak
        +''+sLineBreak
        +'See the description of LOWER() for information that also applies to'+sLineBreak
        +'UPPER(), such as information about how to perform lettercase conversion'+sLineBreak
        +'of binary strings (BINARY, VARBINARY, BLOB) for which these functions'+sLineBreak
        +'are ineffective.'
    ),

    // Function nr. 238
    (
      Name:         'USER';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the current MySQL user name and host name as a string in the'+sLineBreak
        +'utf8 character set.'
    ),

    // Function nr. 239
    (
      Name:         'UUID';
      Declaration:  '()';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a Universal Unique Identifier (UUID) generated according to'+sLineBreak
        +'"DCE 1.1: Remote Procedure Call" (Appendix A) CAE (Common Applications'+sLineBreak
        +'Environment) Specifications published by The Open Group in October 1997'+sLineBreak
        +'(Document Number C706,'+sLineBreak
        +'http://www.opengroup.org/public/pubs/catalog/c706.htm).'+sLineBreak
        +''+sLineBreak
        +'A UUID is designed as a number that is globally unique in space and'+sLineBreak
        +'time. Two calls to UUID() are expected to generate two different'+sLineBreak
        +'values, even if these calls are performed on two separate computers'+sLineBreak
        +'that are not connected to each other.'+sLineBreak
        +''+sLineBreak
        +'A UUID is a 128-bit number represented by a utf8 string of five'+sLineBreak
        +'hexadecimal numbers in aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee format:'+sLineBreak
        +''+sLineBreak
        +'o The first three numbers are generated from a timestamp.'+sLineBreak
        +''+sLineBreak
        +'o The fourth number preserves temporal uniqueness in case the timestamp'+sLineBreak
        +'  value loses monotonicity (for example, due to daylight saving time).'+sLineBreak
        +''+sLineBreak
        +'o The fifth number is an IEEE 802 node number that provides spatial'+sLineBreak
        +'  uniqueness. A random number is substituted if the latter is not'+sLineBreak
        +'  available (for example, because the host computer has no Ethernet'+sLineBreak
        +'  card, or we do not know how to find the hardware address of an'+sLineBreak
        +'  interface on your operating system). In this case, spatial uniqueness'+sLineBreak
        +'  cannot be guaranteed. Nevertheless, a collision should have very low'+sLineBreak
        +'  probability.'+sLineBreak
        +''+sLineBreak
        +'  Currently, the MAC address of an interface is taken into account only'+sLineBreak
        +'  on FreeBSD and Linux. On other operating systems, MySQL uses a'+sLineBreak
        +'  randomly generated 48-bit number.'
    ),

    // Function nr. 240
    (
      Name:         'UUID_SHORT';
      Declaration:  '()';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a "short" universal identifier as a 64-bit unsigned integer'+sLineBreak
        +'(rather than a string-form 128-bit identifier as returned by the UUID()'+sLineBreak
        +'function).'+sLineBreak
        +''+sLineBreak
        +'The value of UUID_SHORT() is guaranteed to be unique if the following'+sLineBreak
        +'conditions hold:'+sLineBreak
        +''+sLineBreak
        +'o The server_id of the current host is unique among your set of master'+sLineBreak
        +'  and slave servers'+sLineBreak
        +''+sLineBreak
        +'o server_id is between 0 and 255'+sLineBreak
        +''+sLineBreak
        +'o You do not set back your system time for your server between mysqld'+sLineBreak
        +'  restarts'+sLineBreak
        +''+sLineBreak
        +'o You do not invoke UUID_SHORT() on average more than 16 million times'+sLineBreak
        +'  per second between mysqld restarts'+sLineBreak
        +''+sLineBreak
        +'The UUID_SHORT() return value is constructed this way:'+sLineBreak
        +''+sLineBreak
        +'  (server_id & 255) << 56'+sLineBreak
        +'+ (server_startup_time_in_seconds << 24)'+sLineBreak
        +'+ incremented_variable++;'
    ),

    // Function nr. 241
    (
      Name:         'VALUES';
      Declaration:  '(col_name)';
      Category:     'Miscellaneous Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'In an INSERT ... ON DUPLICATE KEY UPDATE statement, you can use the'+sLineBreak
        +'VALUES(col_name) function in the UPDATE clause to refer to column'+sLineBreak
        +'values from the INSERT portion of the statement. In other words,'+sLineBreak
        +'VALUES(col_name) in the UPDATE clause refers to the value of col_name'+sLineBreak
        +'that would be inserted, had no duplicate-key conflict occurred. This'+sLineBreak
        +'function is especially useful in multiple-row inserts. The VALUES()'+sLineBreak
        +'function is meaningful only in the ON DUPLICATE KEY UPDATE clause of'+sLineBreak
        +'INSERT statements and returns NULL otherwise. See'+sLineBreak
        +'https://mariadb.com/kb/en/insert-on-duplicate-key-update/.'
    ),

    // Function nr. 242
    (
      Name:         'VARBINARY';
      Declaration:  '(M)';
      Category:     'Data Types';
      Version:      SQL_VERSION_ANSI;
      Description:  'The VARBINARY type is similar to the VARCHAR type, but stores binary'+sLineBreak
        +'byte strings rather than nonbinary character strings. M represents the'+sLineBreak
        +'maximum column length in bytes.'
    ),

    // Function nr. 243
    (
      Name:         'VARIANCE';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the population standard variance of expr. This is an extension'+sLineBreak
        +'to standard SQL. The standard SQL function VAR_POP() can be used'+sLineBreak
        +'instead.'+sLineBreak
        +''+sLineBreak
        +'VARIANCE() returns NULL if there were no matching rows.'
    ),

    // Function nr. 244
    (
      Name:         'VAR_POP';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the population standard variance of expr. It considers rows as'+sLineBreak
        +'the whole population, not as a sample, so it has the number of rows as'+sLineBreak
        +'the denominator. You can also use VARIANCE(), which is equivalent but'+sLineBreak
        +'is not standard SQL.'+sLineBreak
        +''+sLineBreak
        +'VAR_POP() returns NULL if there were no matching rows.'
    ),

    // Function nr. 245
    (
      Name:         'VAR_SAMP';
      Declaration:  '(expr)';
      Category:     'Functions and Modifiers for Use with GROUP BY';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the sample variance of expr. That is, the denominator is the'+sLineBreak
        +'number of rows minus one.'+sLineBreak
        +''+sLineBreak
        +'VAR_SAMP() returns NULL if there were no matching rows.'
    ),

    // Function nr. 246
    (
      Name:         'VERSION';
      Declaration:  '()';
      Category:     'Information Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns a string that indicates the MySQL server version. The string'+sLineBreak
        +'uses the utf8 character set. The value might have a suffix in addition'+sLineBreak
        +'to the version number. See the description of the version system'+sLineBreak
        +'variable in'+sLineBreak
        +'https://mariadb.com/kb/en/server-system-variables#version.'
    ),

    // Function nr. 247
    (
      Name:         'WEEK';
      Declaration:  '(date[,mode])';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'This function returns the week number for date. The two-argument form'+sLineBreak
        +'of WEEK() enables you to specify whether the week starts on Sunday or'+sLineBreak
        +'Monday and whether the return value should be in the range from 0 to 53'+sLineBreak
        +'or from 1 to 53. If the mode argument is omitted, the value of the'+sLineBreak
        +'default_week_format system variable is used. See'+sLineBreak
        +'https://mariadb.com/kb/en/server-system-variables/.'
    ),

    // Function nr. 248
    (
      Name:         'WEEKDAY';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the weekday index for date (0 = Monday, 1 = Tuesday, ... 6 ='+sLineBreak
        +'Sunday).'
    ),

    // Function nr. 249
    (
      Name:         'WEEKOFYEAR';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the calendar week of the date as a number in the range from 1'+sLineBreak
        +'to 53. WEEKOFYEAR() is a compatibility function that is equivalent to'+sLineBreak
        +'WEEK(date,3).'
    ),

    // Function nr. 250
    (
      Name:         'WITHIN';
      Declaration:  '(g1,g2)';
      Category:     'Geometry relations';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns 1 or 0 to indicate whether g1 is spatially within g2. This'+sLineBreak
        +'tests the opposite relationship as Contains().'
    ),

    // Function nr. 251
    (
      Name:         'X';
      Declaration:  '(p)';
      Category:     'Point properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the X-coordinate value for the Point object p as a'+sLineBreak
        +'double-precision number.'
    ),

    // Function nr. 252
    (
      Name:         'Y';
      Declaration:  '(p)';
      Category:     'Point properties';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the Y-coordinate value for the Point object p as a'+sLineBreak
        +'double-precision number.'
    ),

    // Function nr. 253
    (
      Name:         'YEAR';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns the year for date, in the range 1000 to 9999, or 0 for the'+sLineBreak
        +'"zero" date.'
    ),

    // Function nr. 254
    (
      Name:         'YEARWEEK';
      Declaration:  '(date)';
      Category:     'Date and Time Functions';
      Version:      SQL_VERSION_ANSI;
      Description:  'Returns year and week for a date. The mode argument works exactly like'+sLineBreak
        +'the mode argument to WEEK(). The year in the result may be different'+sLineBreak
        +'from the year in the date argument for the first and the last week of'+sLineBreak
        +'the year.'
    )

  );


  MySQLVariables: array [0..417] of TServerVariable =
  (
    (
      Name: 'auto_increment_increment';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'auto_increment_offset';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'autocommit';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'automatic_sp_privileges';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'back_log';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'basedir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'big_tables';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'binlog_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'binlog_checksum';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'binlog_direct_non_transactional_updates';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'binlog_format';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'ROW,STATEMENT,MIXED';
    ),
    (
      Name: 'binlog_row_image';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'FULL,MINIMAL,NOBLOB';
    ),
    (
      Name: 'binlog_stmt_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'bulk_insert_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_client';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_connection';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_database[a]';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_filesystem';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_results';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_server';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'character_set_system';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'character_sets_dir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'collation_connection';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'collation_database[b]';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'collation_server';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'completion_type';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'NO_CHAIN,CHAIN,RELEASE,0,1,2';
    ),
    (
      Name: 'concurrent_insert';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: 'NEVER,AUTO,ALWAYS,0,1,2';
    ),
    (
      Name: 'connect_timeout';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'datadir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'date_format';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'datetime_format';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'debug';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'debug_sync';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'default_storage_engine';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'FEDERATED,MRG_MYISAM,MyISAM,BLACKHOLE,CSV,MEMORY,ARCHIVE,InnoDB';
    ),
    (
      Name: 'default_tmp_storage_engine';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'FEDERATED,MRG_MYISAM,MyISAM,BLACKHOLE,CSV,MEMORY,ARCHIVE,InnoDB';
    ),
    (
      Name: 'default_week_format';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'delay_key_write';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: 'ON,OFF,ALL';
    ),
    (
      Name: 'delayed_insert_limit';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'delayed_insert_timeout';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'delayed_queue_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'disable_gtid_unsafe_statements';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'div_precision_increment';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'end_markers_in_json';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'engine_condition_pushdown';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'eq_range_index_dive_limit';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'error_count';
      IsDynamic: False;
      VarScope: vsSession;
    ),
    (
      Name: 'event_scheduler';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: 'ON,OFF,DISABLED';
    ),
    (
      Name: 'expire_logs_days';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'external_user';
      IsDynamic: False;
      VarScope: vsSession;
    ),
    (
      Name: 'flush';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'flush_time';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'foreign_key_checks';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'ft_boolean_syntax';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ft_max_word_len';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ft_min_word_len';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ft_query_expansion_limit';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ft_stopword_file';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'general_log';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'general_log_file';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'group_concat_max_len';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'gtid_done';
      IsDynamic: False;
      VarScope: vsBoth;
    ),
    (
      Name: 'gtid_lost';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'gtid_mode';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'gtid_mode';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'gtid_next';
      IsDynamic: True;
      VarScope: vsSession;
      EnumValues: 'AUTOMATIC,ANONYMOUS';
    ),
    (
      Name: 'gtid_owned';
      IsDynamic: False;
      VarScope: vsBoth;
    ),
    (
      Name: 'have_compress';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_crypt';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_csv';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_dynamic_loading';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_geometry';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_innodb';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_ndbcluster';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_openssl';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_partitioning';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_profiling';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_query_cache';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_rtree_keys';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_ssl';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'have_symlink';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'host_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'hostname';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'identity';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'ignore_builtin_innodb';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'init_connect';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'init_file';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'init_slave';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_adaptive_flushing';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_adaptive_hash_index';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_adaptive_max_sleep_delay';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_additional_mem_pool_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_analyze_is_persistent';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_api_enable_binlog';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_api_enable_mdl';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_api_trx_level';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_autoextend_increment';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_autoinc_lock_mode';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_dump_at_shutdown';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_dump_now';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_filename';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_load_abort';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_load_at_startup';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_load_now';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_buffer_pool_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_change_buffer_max_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_change_buffering';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: 'INSERTS,DELETES,PURGES,CHANGES,ALL,NONE';
    ),
    (
      Name: 'innodb_checksum_algorithm';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: 'INNODB,CRC32,NONE,STRICT_INNODB,STRICT_CRC32,STRICT_NONE';
    ),
    (
      Name: 'innodb_checksums';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_commit_concurrency';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_concurrency_tickets';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_data_file_path';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_data_home_dir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_doublewrite';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_fast_shutdown';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_file_format';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_file_format_check';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_file_format_max';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_file_per_table';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_flush_log_at_trx_commit';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: '0,1,2';
    ),
    (
      Name: 'innodb_flush_method';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_flush_neighbors';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_force_load_corrupted';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_force_recovery';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_aux_table';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_enable_stopword';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_max_token_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_min_token_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_num_word_optimize';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_server_stopword_table';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_sort_pll_degree';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_ft_user_stopword_table';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_io_capacity';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_large_prefix';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_lock_wait_timeout';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'innodb_locks_unsafe_for_binlog';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_log_buffer_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_log_file_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_log_files_in_group';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_log_group_home_dir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_lru_scan_depth';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_max_dirty_pages_pct';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_max_purge_lag';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_mirrored_log_groups';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_monitor_disable';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_monitor_enable';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_monitor_reset';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_monitor_reset_all';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_old_blocks_pct';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_old_blocks_time';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_open_files';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_optimize_fulltext_only';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_page_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_print_all_deadlocks';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_purge_batch_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_purge_threads';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_random_read_ahead';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_read_ahead_threshold';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_read_io_threads';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_replication_delay';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_rollback_on_timeout';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_rollback_segments';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_sort_buffer_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_spin_wait_delay';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_stats_method';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'NULLS_EQUAL,NULLS_UNEQUAL,NULLS_IGNORED';
    ),
    (
      Name: 'innodb_stats_on_metadata';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_stats_persistent_sample_pages';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_stats_sample_pages';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_stats_transient_sample_pages';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_strict_mode';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'innodb_support_xa';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'innodb_sync_array_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_sync_spin_loops';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_table_locks';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'innodb_thread_concurrency';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_thread_sleep_delay';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_undo_directory';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_undo_logs';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_undo_tablespaces';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_use_native_aio';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_use_sys_malloc';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_version';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'innodb_write_io_threads';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'insert_id';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'interactive_timeout';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'join_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'keep_files_on_create';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'key_buffer_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'key_cache_age_threshold';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'key_cache_block_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'key_cache_division_limit';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'language';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'large_files_support';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'large_page_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'large_pages';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'last_insert_id';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'lc_messages';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'lc_messages_dir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'lc_time_names';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'license';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'local_infile';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'lock_wait_timeout';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'locked_in_memory';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_bin';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_bin_basename';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_error';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_output';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_queries_not_using_indexes';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_slave_updates';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_slow_queries';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_throttle_queries_not_using_indexes';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'log_warnings';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'long_query_time';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'low_priority_updates';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'lower_case_file_system';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'lower_case_table_names';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'master_info_repository';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'master_verify_checksum';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_allowed_packet';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_binlog_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_binlog_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_binlog_stmt_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_connect_errors';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_connections';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_delayed_threads';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_error_count';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_heap_table_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_insert_delayed_threads';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_join_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_length_for_sort_data';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_prepared_stmt_count';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_relay_log_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'max_seeks_for_key';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_sort_length';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_sp_recursion_depth';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_tmp_tables';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_user_connections';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'max_write_lock_count';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'memlock';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'metadata_locks_cache_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'myisam_data_pointer_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'myisam_max_sort_file_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'myisam_mmap_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'myisam_recover_options';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'myisam_repair_threads';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'myisam_sort_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'myisam_stats_method';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'NULLS_EQUAL,NULLS_UNEQUAL,NULLS_IGNORED';
    ),
    (
      Name: 'myisam_use_mmap';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'named_pipe';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'net_buffer_length';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'net_read_timeout';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'net_retry_count';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'net_write_timeout';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'new';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'old';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'old_alter_table';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'old_passwords';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'open_files_limit';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'optimizer_join_cache_level';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_prune_level';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_search_depth';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_switch';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_trace';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_trace_features';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_trace_limit';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_trace_max_mem_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'optimizer_trace_offset';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'have_partitioning';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_accounts_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_digests_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_events_stages_history_long_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_events_stages_history_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_events_statements_history_long_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_events_statements_history_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_events_waits_history_long_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_events_waits_history_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_hosts_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_cond_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_cond_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_file_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_file_handles';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_file_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_mutex_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_mutex_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_rwlock_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_rwlock_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_socket_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_socket_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_stage_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_statement_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_table_handles';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_table_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_thread_classes';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_max_thread_instances';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_setup_actors_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_setup_objects_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'performance_schema_users_size';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'pid_file';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'plugin_dir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'port';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'preload_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'profiling';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'profiling_history_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'protocol_version';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'proxy_user';
      IsDynamic: False;
      VarScope: vsSession;
    ),
    (
      Name: 'pseudo_thread_id';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'query_alloc_block_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'query_cache_limit';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'query_cache_min_res_unit';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'query_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'query_cache_type';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: '0,1,2';
    ),
    (
      Name: 'query_cache_wlock_invalidate';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'query_prealloc_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'rand_seed1';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'rand_seed2';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'range_alloc_block_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'read_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'read_only';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'read_rnd_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'relay_log_basename';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'relay_log_index';
      IsDynamic: False;
      VarScope: vsBoth;
    ),
    (
      Name: 'relay_log_index';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'relay_log_info_file';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'relay_log_info_repository';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'relay_log_purge';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'relay_log_recovery';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'relay_log_space_limit';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'report_host';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'report_password';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'report_port';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'report_user';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'rpl_semi_sync_master_enabled';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'rpl_semi_sync_master_timeout';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'rpl_semi_sync_master_trace_level';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'rpl_semi_sync_master_wait_no_slave';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'rpl_semi_sync_slave_enabled';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'rpl_semi_sync_slave_trace_level';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'secure_auth';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'secure_file_priv';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'server_id';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'server_uuid';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'shared_memory';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'shared_memory_base_name';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'skip_external_locking';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'skip_name_resolve';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'skip_networking';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'skip_show_database';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_compressed_protocol';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_exec_mode';
      IsDynamic: True;
      VarScope: vsGlobal;
      EnumValues: 'IDEMPOTENT,STRICT';
    ),
    (
      Name: 'slave_load_tmpdir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_net_timeout';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_parallel_workers';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_skip_errors';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_sql_verify_checksum';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_transaction_retries';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slave_type_conversions';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slow_launch_time';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slow_query_log';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'slow_query_log_file';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'socket';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sort_buffer_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_auto_is_null';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_big_selects';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_big_tables';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_buffer_result';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_log_bin';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_log_off';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_low_priority_updates';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_max_join_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_mode';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_notes';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_quote_show_create';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_safe_updates';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_select_limit';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'sql_slave_skip_counter';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sql_warnings';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'ssl_ca';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ssl_capath';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ssl_cert';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ssl_cipher';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ssl_crl';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ssl_crlpath';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'ssl_key';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'storage_engine';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'FEDERATED,MRG_MYISAM,MyISAM,BLACKHOLE,CSV,MEMORY,ARCHIVE,InnoDB';
    ),
    (
      Name: 'stored_program_cache';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sync_binlog';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sync_frm';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sync_master_info';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sync_relay_log';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'sync_relay_log_info';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'system_time_zone';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'table_definition_cache';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'table_open_cache';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'thread_cache_size';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'thread_concurrency';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'thread_handling';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'thread_stack';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'time_format';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'time_zone';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'timed_mutexes';
      IsDynamic: True;
      VarScope: vsGlobal;
    ),
    (
      Name: 'timestamp';
      IsDynamic: True;
      VarScope: vsSession;
    ),
    (
      Name: 'tmp_table_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'tmpdir';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'transaction_alloc_block_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'transaction_prealloc_size';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'tx_isolation';
      IsDynamic: True;
      VarScope: vsBoth;
      EnumValues: 'READ-UNCOMMITTED,READ-COMMITTED,REPEATABLE-READ,SERIALIZABLE';
    ),
    (
      Name: 'tx_read_only';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'unique_checks';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'updatable_views_with_limit';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'version';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'version_comment';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'version_compile_machine';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'version_compile_os';
      IsDynamic: False;
      VarScope: vsGlobal;
    ),
    (
      Name: 'wait_timeout';
      IsDynamic: True;
      VarScope: vsBoth;
    ),
    (
      Name: 'warning_count';
      IsDynamic: False;
      VarScope: vsSession;
    )

  );



  function GetFunctionCategories: TStringList;

implementation

uses apphelpers;

function GetFunctionCategories: TStringList;
var
  i: Integer;
begin
  Result := TStringList.Create;
  for i:=0 to Length(MySqlFunctions)-1 do
  begin
    if Result.IndexOf( MySqlFunctions[i].Category ) = -1 then
    begin
      Result.Add( MySqlFunctions[i].Category );
    end;
  end;
  Result.Sort;
end;



{ EDbError }

constructor EDbError.Create(const Msg: string; const ErrorCode: Cardinal=0);
begin
  Self.ErrorCode := ErrorCode;
  inherited Create(Msg);
end;



{ TDbLib }

constructor TDbLib.Create(DllFile: String);
var
  msg: String;
begin
  // Load DLL as is (with or without path)
  inherited Create;
  FDllFile := DllFile;
  if not FileExists(FDllFile) then begin
    msg := f_('File does not exist: %s', [FDllFile]) +
      sLineBreak + sLineBreak +
      f_('Please launch %s from the directory where you have installed it. Or just reinstall %s.', [APPNAME, APPNAME]
      );
    Raise EdbError.Create(msg);
  end;

  FHandle := LoadLibrary(PWideChar(FDllFile));
  if FHandle = 0 then begin
    msg := f_('Library %s could not be loaded. Please select a different one.',
      [ExtractFileName(FDllFile)]
      );
    if Windows.GetLastError <> 0 then
      msg := msg + sLineBreak + sLineBreak + f_('Internal error %d: %s', [Windows.GetLastError, SysErrorMessage(Windows.GetLastError)]);
    Raise EDbError.Create(msg);
  end;

  // Dll was loaded, now initialize required procedures
  AssignProcedures;
end;


destructor TDbLib.Destroy;
begin
  if FHandle <> 0 then begin
    FreeLibrary(FHandle);
    FHandle := 0;
  end;
  inherited;
end;


procedure TDbLib.AssignProc(var Proc: FARPROC; Name: PAnsiChar; Mandantory: Boolean=True);
var
  msg: String;
begin
  // Map library procedure to internal procedure
  Proc := GetProcAddress(FHandle, Name);
  if Proc = nil then begin
    if Mandantory then begin
      msg := f_('Library error in %s: Could not find procedure address for "%s"',
        [ExtractFileName(FDllFile), Name]
        );
      if Windows.GetLastError <> 0 then
        msg := msg + sLineBreak + sLineBreak + f_('Internal error %d: %s', [Windows.GetLastError, SysErrorMessage(Windows.GetLastError)]);
      Raise EDbError.Create(msg, LIB_PROC_ERROR);
    end;
  end;
end;


procedure TMySQLLib.AssignProcedures;
begin
  AssignProc(@mysql_affected_rows, 'mysql_affected_rows');
  AssignProc(@mysql_character_set_name, 'mysql_character_set_name');
  AssignProc(@mysql_close, 'mysql_close');
  AssignProc(@mysql_data_seek, 'mysql_data_seek');
  AssignProc(@mysql_errno, 'mysql_errno');
  AssignProc(@mysql_error, 'mysql_error');
  AssignProc(@mysql_fetch_field_direct, 'mysql_fetch_field_direct');
  AssignProc(@mysql_fetch_field, 'mysql_fetch_field');
  AssignProc(@mysql_fetch_lengths, 'mysql_fetch_lengths');
  AssignProc(@mysql_fetch_row, 'mysql_fetch_row');
  AssignProc(@mysql_free_result, 'mysql_free_result');
  AssignProc(@mysql_get_client_info, 'mysql_get_client_info');
  AssignProc(@mysql_get_server_info, 'mysql_get_server_info');
  AssignProc(@mysql_init, 'mysql_init');
  AssignProc(@mysql_num_fields, 'mysql_num_fields');
  AssignProc(@mysql_num_rows, 'mysql_num_rows');
  AssignProc(@mysql_ping, 'mysql_ping');
  AssignProc(@mysql_options, 'mysql_options');
  AssignProc(@mysql_optionsv, 'mysql_optionsv', False);
  AssignProc(@mysql_real_connect, 'mysql_real_connect');
  AssignProc(@mysql_real_query, 'mysql_real_query');
  AssignProc(@mysql_ssl_set, 'mysql_ssl_set');
  AssignProc(@mysql_stat, 'mysql_stat');
  AssignProc(@mysql_store_result, 'mysql_store_result');
  AssignProc(@mysql_thread_id, 'mysql_thread_id');
  AssignProc(@mysql_next_result, 'mysql_next_result');
  AssignProc(@mysql_set_character_set, 'mysql_set_character_set');
  AssignProc(@mysql_thread_init, 'mysql_thread_init');
  AssignProc(@mysql_thread_end, 'mysql_thread_end');
  AssignProc(@mysql_warning_count, 'mysql_warning_count');
end;


procedure TPostgreSQLLib.AssignProcedures;
begin
  AssignProc(@PQconnectdb, 'PQconnectdb');
  AssignProc(@PQerrorMessage, 'PQerrorMessage');
  AssignProc(@PQresultErrorMessage, 'PQresultErrorMessage');
  AssignProc(@PQresultErrorField, 'PQresultErrorField');
  AssignProc(@PQfinish, 'PQfinish');
  AssignProc(@PQstatus, 'PQstatus');
  AssignProc(@PQsendQuery, 'PQsendQuery');
  AssignProc(@PQgetResult, 'PQgetResult');
  AssignProc(@PQbackendPID, 'PQbackendPID');
  AssignProc(@PQcmdTuples, 'PQcmdTuples');
  AssignProc(@PQntuples, 'PQntuples');
  AssignProc(@PQclear, 'PQclear');
  AssignProc(@PQnfields, 'PQnfields');
  AssignProc(@PQfname, 'PQfname');
  AssignProc(@PQftype, 'PQftype');
  AssignProc(@PQftable, 'PQftable');
  AssignProc(@PQgetvalue, 'PQgetvalue');
  AssignProc(@PQgetlength, 'PQgetlength');
  AssignProc(@PQgetisnull, 'PQgetisnull');
  AssignProc(@PQlibVersion, 'PQlibVersion');
end;


procedure TSQLiteLib.AssignProcedures;
begin
  AssignProc(@sqlite3_open, 'sqlite3_open');
  AssignProc(@sqlite3_libversion, 'sqlite3_libversion');
  AssignProc(@sqlite3_close, 'sqlite3_close');
  AssignProc(@sqlite3_errmsg, 'sqlite3_errmsg');
  AssignProc(@sqlite3_errcode, 'sqlite3_errcode');
  AssignProc(@sqlite3_prepare_v2, 'sqlite3_prepare_v2');
  AssignProc(@sqlite3_exec, 'sqlite3_exec');
  AssignProc(@sqlite3_finalize, 'sqlite3_finalize');
  AssignProc(@sqlite3_step, 'sqlite3_step');
  AssignProc(@sqlite3_changes, 'sqlite3_changes');
  AssignProc(@sqlite3_column_text, 'sqlite3_column_text');
  AssignProc(@sqlite3_column_count, 'sqlite3_column_count');
  AssignProc(@sqlite3_column_name, 'sqlite3_column_name');
end;



initialization

// Keywords copied from SynHighligherSQL
MySQLKeywords := TStringList.Create;
MySQLKeywords.CommaText := 'ACCESSIBLE,ACTION,ADD,AFTER,AGAINST,AGGREGATE,ALGORITHM,ALL,ALTER,ANALYZE,AND,ANY,AS,' +
  'ASC,ASENSITIVE,AT,AUTO_INCREMENT,AVG_ROW_LENGTH,BACKUP,BEFORE,BEGIN,BENCHMARK,BETWEEN,BINLOG,BIT,' +
  'BOOL,BOTH,BY,CACHE,CALL,CASCADE,CASCADED,CASE,CHANGE,CHARACTER,CHARSET,CHECK,' +
  'CHECKSUM,CLIENT,COLLATE,COLLATION,COLUMN,COLUMNS,COMMENT,COMMIT,' +
  'COMMITTED,COMPLETION,CONCURRENT,CONNECTION,CONSISTENT,CONSTRAINT,' +
  'CONVERT,CONTAINS,CONTENTS,CREATE,CROSS,DATA,DATABASE,DATABASES,DAY_HOUR,' +
  'DAY_MICROSECOND,DAY_MINUTE,DAY_SECOND,DEALLOCATE,DEC,DEFAULT,DEFINER,DELAYED,DELAY_KEY_WRITE,DELETE,DESC,' +
  'DETERMINISTIC,DIRECTORY,DISABLE,DISCARD,DESCRIBE,DISTINCT,DISTINCTROW,' +
  'DIV,DROP,DUAL,DUMPFILE,DUPLICATE,EACH,ELSE,ELSEIF,ENABLE,ENCLOSED,END,ENDS,' +
  'ENGINE,ENGINES,ESCAPE,ESCAPED,ERRORS,EVENT,EVENTS,EVERY,EXECUTE,EXISTS,' +
  'EXPANSION,EXPLAIN,FALSE,FIELDS,FILE,FIRST,FLOAT4,FLOAT8,FLUSH,FOR,FORCE,FOREIGN,FROM,' +
  'FULL,FULLTEXT,FUNCTION,FUNCTIONS,GLOBAL,GRANT,GRANTS,GROUP,HAVING,HELP,' +
  'HIGH_PRIORITY,HOSTS,HOUR_MICROSECOND,HOUR_MINUTE,HOUR_SECOND,IDENTIFIED,IGNORE,IGNORE_SERVER_IDS,INDEX,INFILE,INNER,INOUT,INSENSITIVE,INSERT,' +
  'INSERT_METHOD,INSTALL,INT1,INT2,INT3,INT4,INT8,INTEGER,INTO,IO_THREAD,IS,' +
  'ISOLATION,INVOKER,JOIN,KEY,KEYS,KILL,LAST,LEADING,LEAVES,LEVEL,LESS,' +
  'LIKE,LIMIT,LINEAR,LINES,LIST,LOAD,LOCAL,LOCK,LOGS,LONG,LOW_PRIORITY,' +
  'MASTER,MASTER_HOST,MASTER_HEARTBEAT_PERIOD,MASTER_LOG_FILE,MASTER_LOG_POS,MASTER_CONNECT_RETRY,' +
  'MASTER_PASSWORD,MASTER_PORT,MASTER_SSL,MASTER_SSL_CA,MASTER_SSL_CAPATH,' +
  'MASTER_SSL_CERT,MASTER_SSL_CIPHER,MASTER_SSL_KEY,MASTER_SSL_VERIFY_SERVER_CERT,MASTER_USER,MATCH,' +
  'MAX_ROWS,MAXVALUE,MIDDLEINT,MIN_ROWS,MINUTE_MICROSECOND,MINUTE_SECOND,MOD,MODE,MODIFY,MODIFIES,NAMES,' +
  'NATURAL,NEW,NO,NODEGROUP,NOT,NO_WRITE_TO_BINLOG,NULL,NUMERIC,OJ,OFFSET,OLD,ON,OPTIMIZE,OPTION,' +
  'OPTIONALLY,OPEN,OR,ORDER,OUT,OUTER,OUTFILE,PACK_KEYS,PARTIAL,PARTITION,' +
  'PARTITIONS,PERSISTENT,PLUGIN,PLUGINS,PRECISION,PREPARE,PRESERVE,PRIMARY,PRIVILEGES,PROCEDURE,' +
  'PROCESS,PROCESSLIST,PURGE,QUERY,RAID_CHUNKS,RAID_CHUNKSIZE,RAID_TYPE,RANGE,' +
  'READ,READS,READ_WRITE,REAL,REBUILD,REFERENCES,REGEXP,RELAY_LOG_FILE,RELAY_LOG_POS,RELEASE,RELOAD,' +
  'RENAME,REORGANIZE,REPAIR,REPEATABLE,REPLACE,REPLICATION,REQUIRE,RESIGNAL,RESTRICT,RESET,' +
  'RESTORE,RETURN,RETURNS,REVOKE,RLIKE,ROLLBACK,ROLLUP,ROUTINE,ROW,' +
  'ROW_FORMAT,ROWS,SAVEPOINT,SCHEDULE,SCHEMA,SCHEMAS,SECOND_MICROSECOND,SECURITY,SELECT,' +
  'SENSITIVE,SEPARATOR,SERIALIZABLE,SESSION,SET,SHARE,SHOW,SHUTDOWN,SIGNAL,SIMPLE,SLAVE,SNAPSHOT,SOME,' +
  'SONAME,SPECIFIC,SQL,SQLEXCEPTION,SQLSTATE,SQLWARNING,SQL_BIG_RESULT,SQL_BUFFER_RESULT,SQL_CACHE,' +
  'SQL_CALC_FOUND_ROWS,SQL_NO_CACHE,SQL_SMALL_RESULT,SPATIAL,SQL_THREAD,SSL,START,' +
  'STARTING,STARTS,STATUS,STOP,STORAGE,STRAIGHT_JOIN,SUBPARTITION,' +
  'SUBPARTITIONS,SUPER,TABLE,TABLES,TABLESPACE,TEMPORARY,TERMINATED,THAN,' +
  'THEN,TO,TRAILING,TRANSACTION,TRIGGER,TRIGGERS,TRUE,TYPE,UNCOMMITTED,UNDO,' +
  'UNINSTALL,UNIQUE,UNLOCK,UNSIGNED,UPDATE,UPGRADE,UNION,USAGE,USE,USING,VALUES,VARCHARACTER,' +
  'VARIABLES,VARYING,VIEW,VIRTUAL,WARNINGS,WHEN,WHERE,WITH,WORK,WRITE,XOR,YEAR_MONTH,ZEROFILL,'
  // SQL Plus commands:
  + 'CLOSE,CONDITION,CONTINUE,CURSOR,DECLARE,DO,EXIT,FETCH,FOUND,GOTO,' +
  'HANDLER,ITERATE,LANGUAGE,LEAVE,LOOP,UNTIL,WHILE';

// Error codes copied from perror.exe
MySQLErrorCodes := Explode(',', '0=No error,'+
  '1=Operation not permitted,'+
  '2=No such file or directory,'+
  '3=No such process,'+
  '4=Interrupted function call,'+
  '5=Input/output error,'+
  '6=No such device or address,'+
  '7=Arg list too long,'+
  '8=Exec format error,'+
  '9=Bad file descriptor,'+
  '10=No child processes,'+
  '11=Resource temporarily unavailable,'+
  '12=Not enough space,'+
  '13=Permission denied,'+
  '14=Bad address,'+
  '16=Resource device,'+
  '17=File exists,'+
  '18=Improper link,'+
  '19=No such device,'+
  '20=Not a directory,'+
  '21=Is a directory,'+
  '22=Invalid argument,'+
  '23=Too many open files in system,'+
  '24=Too many open files,'+
  '25=Inappropriate I/O control operation,'+
  '27=File too large,'+
  '28=No space left on device,'+
  '29=Invalid seek,'+
  '30=Read-only file system,'+
  '31=Too many links,'+
  '32=Broken pipe,'+
  '33=Domain error,'+
  '34=Result too large,'+
  '36=Resource deadlock avoided,'+
  '38=Filename too long,'+
  '39=No locks available,'+
  '40=Function not implemented,'+
  '41=Directory not empty,'+
  '42=Illegal byte sequence,'+
  '120=Didn''t find key on read or update,'+
  '121=Duplicate key on write or update,'+
  '123=Someone has changed the row since it was read (while the table was locked to prevent it),'+
  '124=Wrong index given to function,'+
  '126=Index file is crashed,'+
  '127=Record-file is crashed,'+
  '128=Out of memory,'+
  '130=Incorrect file format,'+
  '131=Command not supported by database,'+
  '132=Old database file,'+
  '133=No record read before update,'+
  '134=Record was already deleted (or record file crashed),'+
  '135=No more room in record file,'+
  '136=No more room in index file,'+
  '137=No more records (read after end of file),'+
  '138=Unsupported extension used for table,'+
  '139=Too big row,'+
  '140=Wrong create options,'+
  '141=Duplicate unique key or constraint on write or update,'+
  '142=Unknown character set used,'+
  '143=Conflicting table definitions in sub-tables of MERGE table,'+
  '144=Table is crashed and last repair failed,'+
  '145=Table was marked as crashed and should be repaired,'+
  '146=Lock timed out; Retry transaction,'+
  '147=Lock table is full;  Restart program with a larger locktable,'+
  '148=Updates are not allowed under a read only transactions,'+
  '149=Lock deadlock; Retry transaction,'+
  '150=Foreign key constraint is incorrectly formed,'+
  '151=Cannot add a child row,'+
  '152=Cannot delete a parent row');



end.
