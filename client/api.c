#include "api.h"
#include "protocol_client.h"
#include "connect.h"

#define DEFAULT_REPLICATION_SLOT "bottledwater"
#define APP_NAME "bottledwater"

/* The name of the logical decoding output plugin with which the replication
 * slot is created. This must match the name of the Postgres extension. */
#define OUTPUT_PLUGIN "bottledwater"

#define ensure(context, err, call) { \
    err = call; \
    if (err != 0) { \
        context->on_log(context, context->error); \
        return err; \
    } \
}

/* Allocate a new client context */
client_context_t bw_client_context_new(void) {
    frame_reader_t frame_reader = frame_reader_new();
    client_context_t context = db_client_new();

    frame_reader->cb_context = context;

    context->app_name = APP_NAME;
    context->allow_unkeyed = false;
    context->repl.slot_name = DEFAULT_REPLICATION_SLOT;
    context->repl.output_plugin = OUTPUT_PLUGIN;
    context->repl.frame_reader = frame_reader;

    return context;
}

/* Free a client context */
void bw_client_context_free(client_context_t context) {
    frame_reader_free(context->repl.frame_reader);
    db_client_free(context);
};

void bw_set_begin_txn_callback(client_context_t client_context, begin_txn_cb callback) {
    client_context->repl.frame_reader->on_begin_txn = callback;
}

void bw_set_on_commit_txn_callback(client_context_t client_context, commit_txn_cb callback) {
    client_context->repl.frame_reader->on_commit_txn = callback;
}

void bw_set_on_table_schema_callback(client_context_t client_context, table_schema_cb callback) {
    client_context->repl.frame_reader->on_table_schema = callback;
}

void bw_set_on_insert_row_callback(client_context_t client_context, insert_row_cb callback) {
    client_context->repl.frame_reader->on_insert_row = callback;
}

void bw_set_on_update_row_callback(client_context_t client_context, update_row_cb callback) {
    client_context->repl.frame_reader->on_update_row = callback;
}

void bw_set_on_delete_row_callback(client_context_t client_context, delete_row_cb callback) {
    client_context->repl.frame_reader->on_delete_row = callback;
}

void bw_set_on_log_callback(client_context_t client_context, log_cb callback) {
    client_context->on_log = callback;
}

int bw_run(client_context_t context) {
    int err = 0;
    ensure(context, err, db_client_start(context));

    while (context->status >= 0) {
        ensure(context, err, db_client_poll(context));

        if (context->status == 0) {
            ensure(context, err, db_client_wait(context));
        }
    }
    return 0;
}

int hello_ruby(client_context_t client_context, simple_cb callback) {
    return callback(42);
}
