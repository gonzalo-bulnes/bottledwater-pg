#ifndef API_H
#define API_H

#include <stdio.h>

#include "connect.h"
#include "protocol_client.h"
#include "replication.h"

#define DEFAULT_REPLICATION_SLOT "bottledwater"
#define APP_NAME "bottledwater"

/* The name of the logical decoding output plugin with which the replication
 * slot is created. This must match the name of the Postgres extension. */
#define OUTPUT_PLUGIN "bottledwater"

#define ensure(context, call) { \
    if (call) { \
        fprintf(stderr, "%s: %s\n", progname, context->error); \
        exit_nicely(context); \
    } \
}

/* Allocate a new client context */
client_context_t bw_client_context_new(void);
/* Free a client context */
void bw_client_context_free(client_context_t context);

/* Set the callbacks */
void bw_set_begin_txn_callback(client_context_t client_context, begin_txn_cb callback);
void bw_set_on_commit_txn_callback(client_context_t client_context, commit_txn_cb callback);
void bw_set_on_table_schema_callback(client_context_t client_context, table_schema_cb callback);
void bw_set_on_insert_row_callback(client_context_t client_context, insert_row_cb callback);
void bw_set_on_update_row_callback(client_context_t client_context, update_row_cb callback);
void bw_set_on_delete_row_callback(client_context_t client_context, delete_row_cb callback);
void bw_set_on_log_callback(client_context_t client_context, log_cb callback);

/* Start the client */
int bw_run(client_context_t client_context);

/* Stop the client - not yet implemented */
/* int bw_stop(client_context_t client_context); */

#endif /* API_H */
