server:
  applicationConnectors:
    - type: https
      port: 8443
      bindHost: 0.0.0.0
      keyStorePath: /opt/keypass/conf/ampdp.keystore.jks
      keyStorePassword: '$${bob.ampdp.password}'
      keyStoreType: JKS
      trustStorePath: /opt/keypass/conf/ampdp.truststore.jks
      trustStorePassword: '$${bob.ampdp.password}'
      trustStoreType: JKS
      validateCerts: true
      validatePeers: true
      supportedProtocols: ['TLSv1.2']
      supportedCipherSuites: [TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,
                              TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
                              TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384,
                              TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384,
                              TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,
                              TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,
                              TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
                              TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256,
                              TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256,
                              TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,
                              TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
                              TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
                              TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
                              TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384,
                              TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384,
                              TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,
                              TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
                              TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256,
                              TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256,
                              TLS_DHE_RSA_WITH_AES_128_GCM_SHA256]
  adminConnectors:
    - type: http
      port: 8081
      bindHost: 127.0.0.1

tenantHeader: AM-Service

correlatorHeader: Fiware-Correlator

# SteelSkinPep can perform a XACML request using several subject-id in the
# accesss-subject field
# If Policies were not prepared to match with everal subject-ids (by using
# subject-id in AttributeDesignator of Match) this mode enables to match each
# subject-id of XACML request, checking one by one
steelSkinPepMode: True

database:
  # the name of your JDBC driver
  driverClass: com.mysql.jdbc.Driver

  user: AMpdp
  password: '$${psst.database_pdp_pw}'

  url: jdbc:mysql://amdb/keypass

  # any properties specific to your JDBC driver:
  properties:
    charSet: UTF-8
    hibernate.dialect: org.hibernate.dialect.MySQLDialect

  # the maximum amount of time to wait on an empty pool before throwing an exception
  maxWaitForConnection: 1s

  # the SQL query to run when validating a connection's liveness
  validationQuery: "/* Keypass Health Check */ SELECT 1"

  # the minimum number of connections to keep open
  minSize: 8

  # the maximum number of connections to keep open
  maxSize: 32

  # whether or not idle connections should be validated
  checkConnectionWhileIdle: true

  checkConnectionOnBorrow: true

# cache for PDP objects
pdpCache:
  # expiration time for cached objects
  timeToLiveSeconds: 60

  # max PDP objects (per tenant)
  maxEntriesLocalHeap: 100

# Logging settings.
logging:

  # The default level of all loggers. Can be OFF, ERROR, WARN, INFO, DEBUG, TRACE, or ALL.
  level: DEBUG

  # Logger-specific levels.
  loggers:
    "org.hibernate": ERROR
    "io.dropwizard": ERROR
    "org.eclipse.jetty": ERROR
    "com.sun.jersey": ERROR
    "io.dropwizard.jersey.DropwizardResourceConfig": INFO
    "org.eclipse.jetty.server.ServerConnector": INFO
    "io.dropwizard.server.ServerFactory": INFO

  appenders:

    - type: file
      # The file to which current statements will be logged.
      currentLogFilename: ./log/keypass.log

      # When the log file rotates, the archived log will be renamed to this and gzipped. The
      # %d is replaced with the previous day (yyyy-MM-dd). Custom rolling windows can be created
      # by passing a SimpleDateFormat-compatible format as an argument: "%d{yyyy-MM-dd-hh}".
      archivedLogFilenamePattern: ./log/keypass-%d.log.gz

      # The number of archived files to keep.
      archivedFileCount: 5

      # The timezone used to format dates. HINT: USE THE DEFAULT, UTC.
      timeZone: UTC
      
      threshold: INFO
      
      logFormat: "time=%d{HH:mm:ss.SSS} | lvl=%level | Component=KEYPASS | corr=%X{client} | trans=n/a | op=%c{0} | msg=%msg\n"

    - type: console
      threshold: INFO
      target: stdout
