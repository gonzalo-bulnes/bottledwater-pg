#include "api.h"

static char *progname = "Bottled Water client";

static void exit_nicely(client_context_t context) {
    // If a snapshot was in progress and not yet complete, and an error occurred, try to
    // drop the replication slot, so that the snapshot is retried when the user tries again.
    if (context->taking_snapshot) {
        fprintf(stderr, "Dropping replication slot since the snapshot did not complete successfully.\n");
        if (replication_slot_drop(&context->repl) != 0) {
            fprintf(stderr, "%s: %s\n", progname, context->repl.error);
        }
    }

    frame_reader_free(context->repl.frame_reader);
    db_client_free(context);
    exit(1);
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
    ensure(context, db_client_start(context));

    while (context->status >= 0) { /* TODO install signal handler for graceful shutdown */
        ensure(context, db_client_poll(context));

        if (context->status == 0) {
            ensure(context, db_client_wait(context));
        }
    }
    return 0;
}
